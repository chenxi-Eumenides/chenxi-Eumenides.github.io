---
title: "AI Agent Skill 系统设计——从Google、Anthropic、OpenAI的实践中提炼最佳实践"
author: chenxi
description: 综合Google、Anthropic(Claude Code)、OpenAI(Codex)的最新实践，深入解析AI Agent Skill系统的设计模式、分类体系、测试评估与分发治理。
image: 

categories:
    - AI
tags:
    - AI
    - Agent
    - Skill
    - LLM
    - 设计模式
    - 开发
    - 研究
series:
    - 开发

date: 2026-04-27T14:00:00+08:00
math: 
comments: true
license: 

hidden: false
draft: false
---

## 前言

2025-2026年，AI Agent Skill系统经历了从概念到工程化的关键转变。Google、Anthropic、OpenAI三大巨头几乎同时推出了各自的Skill体系，虽然命名和具体实现各有差异，但在核心理念上呈现出惊人的趋同性。

本文综合了多家来源的研究与报告，试图为开发者提供一个关于Agent Skill系统设计的全景视角，涵盖设计模式、Skill分类、最佳实践、测试评估以及治理策略。

> 本文编撰过程中参考了大量一手资料，原始文章链接见文末[参考资料](#参考资料)部分。

---

## 一、什么是Skill？——从工具到认知的跃迁

要理解Skill体系，首先要区分 **工具(Tool)** 和 **Skill** 的本质差异。

> **工具是机械的，Skill是认知的**
> - 工具：无状态 + 具体——"调用这个API，返回这个schema"
> - Skill：携带指令、约定、内部逻辑——知道"什么时候该做什么、怎么做、为什么这么做"

**判断标准很简单：** 如果是一个单一函数调用，那就是工具；如果需要推理排序、决策判断、错误处理、多步骤执行、升级策略——那就是Skill。

Google将Skill定义为 **"Docker for Prompts"** ——认知的可移植容器。从端侧(Gemma 4)到云端(Gemini Enterprise)，同一个SKILL.md格式，实现了跨平台的技能迁移。

---

## 二、五大Skill设计模式

Google Cloud Tech在其技术博客中系统性地梳理了5种Agent Skill设计模式[^1]，以下是它们的概况：

| 模式 | 适用场景 | 核心机制 | 框架保障 |
|------|---------|---------|---------|
| **Tool Wrapper** | 按需注入库/框架约定 | LoadSkillResourceTool | ✅ 原生支持 |
| **Generator** | 模板化稳定输出(API文档、commit) | LoadSkillResourceTool + LLM填充 | ⚠️ 不校验完整性 |
| **Reviewer** | 检查清单+评分(代码质量、安全) | 与Tool Wrapper共享代码层 | ⚠️ 语义由SKILL.md赋予 |
| **Inversion** | 先访谈再行动，阶段门控 | "DO NOT start building until…" | ❌ 无状态机 |
| **Pipeline** | 多步检查点防跳步 | 步骤顺序+用户确认 | ❌ 无checkpoint/状态机 |

### 1. Tool Wrapper（工具包装器）

将某个工具、库、CLI的正确用法封装进Skill。Agent不需要记住所有参数和约定，读Skill就知道怎么用。

**典型结构：**
```
references/conventions.md  — 详细用法约定
references/api.md          — 完整的API/CLI参考
```

### 2. Generator（生成器）

让Agent按照稳定模板生成结构化输出。关键是在SKILL.md中嵌入输出模板和示例。适用于API文档、commit消息、项目模板等场景。

### 3. Reviewer（审查器）

将检查标准与执行逻辑分离。Agent加载检查清单，逐项审查并打分。

**严重级别分级：**
- 🔴 阻断级（必须修复）
- 🟡 警告级（建议修复）
- 🟢 建议级（可选优化）

### 4. Inversion（反转模式）

传统模式是"用户提问 → Agent回答"。反转模式是"用户提问 → Agent反问确认 → Agent回答"。这一模式非常适用于需要收集上下文才能执行的复杂任务。

**实测经验：** GPT-4级别模型在3-5轮内通常能遵守反转约束，但5-10轮后注意力稀释可能跳过阶段。企业落地时建议使用 `before_tool_callback` 实现显式状态机。

### 5. Pipeline（管道模式）

多步骤操作强制执行顺序，每步完成后再进入下一步。SkillToolset本身没有checkpoint机制，因此框架层面保障最弱。

### 设计模式的组合运用

五种模式不是孤立的，可以灵活组合：

| 组合 | 场景 |
|------|------|
| Inversion + Generator | 先收集参数，再按模板生成 |
| Pipeline + Reviewer | 每个阶段完成后自动审查 |
| Generator + Reviewer | 生成后自动检查输出质量 |
| Tool Wrapper + Pipeline | 按正确顺序调用多个工具 |

---

## 三、Skill的9大分类

Anthropic团队基于Claude Code中数百个活跃使用的Skill[^2]，将其归纳为9类：

| # | 类型 | 说明 | 示例 |
|---|------|------|------|
| 1 | **Library & API Reference** | 库/CLI/SDK用法 | billing-lib, internal-platform-cli |
| 2 | **Product Verification** | 代码验证测试 | signup-flow-driver, checkout-verifier |
| 3 | **Data Fetching & Analysis** | 数据获取与分析 | funnel-query, cohort-compare, grafana |
| 4 | **Business Process & Automation** | 业务流程自动化 | standup-post, create-ticket, weekly-recap |
| 5 | **Code Scaffolding & Templates** | 代码脚手架 | new-framework-workflow, create-app |
| 6 | **Code Quality & Review** | 代码质量审查 | adversarial-review, code-style |
| 7 | **CI/CD & Deployment** | CI/CD部署 | babysit-pr, deploy-service |
| 8 | **Runbooks** | 运维手册 | service-debugging, oncall-runner |
| 9 | **Infrastructure Operations** | 基础设施运维 | resource-orphans, cost-investigation |

> 最佳实践表明，最优秀的Skill往往清晰归属于一个类别；而那些"写起来很拧巴"的Skill，通常是因为试图同时涵盖多个类别。

---

## 四、Skill编写：9个来自Anthropic的最佳实践

以下是Anthropic在Claude Code中积累的实战经验[^2]，是目前最一线的Skill编写指南：

### 1. Don't State the Obvious
Claude已经知道大量编程知识和通用约定。Skill应该聚焦于**改变模型默认行为**的信息——那些"模型不知道的特殊约定"。

### 2. Build a Gotchas Section
Gotchas是Skill中**信号密度最高的部分**。记录Claude在这个任务上常见的失败点，随着使用持续更新。一条好的Gotcha胜过十句正面说明。

### 3. Use the File System & Progressive Disclosure
Skill是一个文件夹，不只是一个Markdown文件。利用 `references/`、`scripts/`、`examples/` 子目录实现渐进式披露——Agent在需要时才加载更深层的内容。

### 4. Avoid Railroading Claude
给出**目标和约束**，而不是逐条指令。给Agent灵活性去适应不同的具体场景。

### 5. Think through the Setup
有些Skill需要用户提供上下文。用 `config.json` 存储配置，让Agent在未配置时主动询问。使用结构化问题而非自由文本。

### 6. Description Field Is For the Model
Description是Claude扫描时判断"是否有匹配的Skill"的依据。它的角色是**触发条件**，不是功能摘要。"何时触发"比"做什么"重要得多。

### 7. Memory & Storing Data
使用 `${CLAUDE_PLUGIN_DATA}` 环境变量指向的目录存储持久数据，防止Skill升级时数据丢失。适合存储append-only log、JSON、SQLite等。

### 8. Store Scripts & Generate Code
给Agent脚本和库，让它把时间花在**组合**上，而不是重建样板代码。

### 9. On Demand Hooks
Skill可以注册仅在调用时激活的钩子。例如 `/careful` 阻止 `rm -rf` 等危险操作，`/freeze` 阻止指定目录外的编辑。

---

## 五、如何系统地测试和评估Skill

OpenAI在其开发者博客中详细介绍了如何用Evals系统地测试Agent Skill[^3]。核心思路是把Skill从"感觉变好了"提升到"有证据证明变好了"。

### 完整流程

```
定义成功 → 创建Skill → 手动触发 → 小批量prompt集 → 
确定性评分器 → 定性检查+评分卡 → 随Skill成熟扩展
```

### 四维评估体系

| 维度 | 要回答的问题 |
|------|------------|
| **Outcome goals** | 任务完成了吗？应用能跑吗？ |
| **Process goals** | 调用了预期的工具/步骤吗？ |
| **Style goals** | 输出符合约定的风格吗？ |
| **Efficiency goals** | 有没有不必要的命令或token浪费？ |

### 关键技术实现

**确定性检查**——通过 `codex exec --json` 捕获JSONL事件流，检查关键行为是否发生：

```javascript
function checkRanNpmInstall(events) {
  return events.some(e =>
    (e.type === "item.started" || e.type === "item.completed") &&
    e.item?.type === "command_execution" &&
    e.item.command.includes("npm install")
  );
}
```

**结构化评分卡：**
```json
{
  "overall_pass": boolean,
  "score": 0-100,
  "checks": [
    { "id": "npm_install_performed", "pass": true, "notes": "" }
  ]
}
```

### Prompt集设计

一个小型但有效的prompt集（10-20个）应包含：
- **显式调用**：直接命名Skill
- **隐式调用**：描述场景但不提Skill名
- **上下文干扰**：噪音prompt但需要Skill
- **负向控制**：明确不应该触发

---

## 六、Skill的渐进式披露与目录结构

Anthropic在skill-creator项目中提出的三层渐进式披露模型[^4]已成为事实标准：

```
L1: Metadata (name + description)  ~100词     → Always in context
L2: SKILL.md body                              → <500行, 触发时加载
L3: Bundled resources (references/scripts/)    → 按需加载, 无限制
```

### 标准化目录结构

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - 可执行代码
    ├── references/ - 按需加载的文档
    ├── examples/   - 使用示例
    └── assets/     - 模板、图标等资源文件
```

### JSON Schema体系

| 文件 | 用途 | 关键字段 |
|------|------|---------|
| evals.json | 测试用例定义 | skill_name, evals[].prompt, expectations |
| grading.json | 评分结果 | expectations[].text/passed/evidence, summary |
| benchmark.json | 基准测试 | run_summary, delta (with_skill vs without_skill) |
| timing.json | 计时数据 | total_tokens, duration_ms |
| history.json | 版本追踪 | iterations[].version/pass_rate |

---

## 七、Skill的分发与治理

### 三层分发模型

- **仓库级别**（`.claude/skills/` 或 `.opencode/skills/`）——适合小团队
- **插件市场**（Plugin Marketplace）——适合组织级分发
- **个人级别**——个人试验和本地化hack

### 三层治理模型[^5]

- **组织级**：全局标准、品牌语音、合规规则
- **项目级**：客户端约定和工作流模式
- **个人级**：个人试验和本地化hack

### 待解决的挑战

虽然Skill体系已经相当完善，但仍有一些未解决的问题：
1. **模型版本变更时如何版本化Skill？**——"Pinned Skills"成为企业需求
2. **50+ Skill后的描述冲突问题**——Skill Leaderboard追踪成功率
3. **谁拥有Skill库？**——基础Skill→平台团队，工作流Skill→领域Owner，个人Skill→个人

---

## 八、综合发现：设计原则总结

### 格式规范（已趋同）

各家的SKILL.md规范已经高度一致：
- SKILL.md + YAML frontmatter (name, description)
- 子目录：references/, scripts/, assets/, examples/
- 渐进式披露：L1元数据 → L2 body → L3资源

### 内容设计（真正的差异化）

- 五类设计模式：Tool Wrapper / Generator / Reviewer / Inversion / Pipeline
- 九类Skill类型，每一类有清晰的定位
- **Gotchas > 正面说明**——错误案例比正确用法更有价值

### 测试评估

- 确定性检查（JSONL事件）+ 定性评分卡
- with-skill vs without-skill 对比基准测试
- 小批量迭代（10-20 prompts）→ 持续扩大

### 编写法则

- Description = Trigger，写对描述比写好内容更重要
- 用祈使语气写指令
- 解释"为什么"比写 MUST/NEVER 更有效
- 保持精炼——移除不产生价值的指令

---

## 九、对我们（Opencode）的启发

回到我们自己的Opencode Skill系统，可以从这次调研中获得以下启发：

1. **Skill组合策略**：鼓励Tool Wrapper + Pipeline + Generator的组合模式，让Skill既有工具性又有流程性
2. **重视Gotchas**：在Skill中单独设立Gotchas章节，持续记录Agent在该任务上的常见失败点
3. **渐进式披露落地**：利用Opencode已有的 `references/`、`scripts/` 目录结构，实现按需加载
4. **测试先行**：为每个关键Skill编写至少10-20个测试prompt，定期运行对比基准
5. **Description优化**：Description应该更像"触发器描述"而非"功能摘要"，从用户可能如何表述需求的角度去写

---

## 参考资料

[^1]: Google: [5 Agent Skill Design Patterns Every ADK Developer Should Know](https://cloud.google.com/blog) — Google Cloud Tech, 2026-03-18
[^2]: Anthropic / @trq212: [Lessons from Building Claude Code: How We Use Skills](https://x.com/trq212/status/2033949937936085378) — 2026-03-17
[^3]: OpenAI: [Testing Agent Skills Systematically with Evals](https://developers.openai.com/blog/eval-skills) — 2026-01-22
[^4]: Anthropic: [Skill Creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator) — github.com/anthropics/skills
[^5]: Google Agent Stack全景 — Google Developer Experts (Sonika Janagill)
