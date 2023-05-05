---
title: "gblog常用命令"
description: 
date: 2023-01-29T05:02:30+08:00
image: 
math: 
license: 
hidden: false
comments: false
categories:
    - 博客
    - 指南
    - gblog
    - 笔记
draft: true
---

# gblog常用命令

gblog常用的内容或方法

## gblog相关

### 1.文章标题

文章标题为md中的一级标题，建议全文只用一个一级标题。

### 2.引用图片

插入图片：

```md
![快速开始结果](/image/xxxx.xxx)
```

图片路径：

```bash
/articles/assets/image/xxxx.xxx
```

重新启动服务器

### 3.增加分类

建立以类别命名的目录，放入文档

```bash
# 新建`gblog使用指南`分类后的目录结构
articles
├── assets
└── 类别名称
    └── 文件.md
```

### 4.增加标签

文章顶部中增加“头数据”

```yaml
---
Tags:           # 为此文章设定标签，可以是1个或者多个
    - 心理      # 行首有1个tab缩进，1个“-”字符，以及1个空格
    - 情感      # 设定“情感”标签
---
```

**注意**：“头数据”前后，必须有一行“---”gblog才能正确识别。

### 5.短标签

只需要在config.toml末尾加上如下几行配置

```tml
[[Category]]
Name = "短类名"
Path = "我/的/名字/很长"
```
