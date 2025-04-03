---
title: "python环境管理"
author: chenxi
description: 使用uv等工具对python的开发环境进行管理
image: 

categories:
    - 开发
tags:
    - 开发
    - 编程
    - python
    - uv
series:
    - 开发

date: 2025-04-03T11:07:59+08:00
math: 
comments: false
license: 

hidden: false
draft: false
---

## 常见python管理工具

`pip+venv`: 原生内置的包管理和虚拟环境工具

`virtualenv`: 第三方venv，提供更多选项

`pyenv`: 轻量管理多个python版本的工具

`poetry`: 现代化的依赖管理和打包工具，专注于简化项目依赖管理

`conda(miniconda)`: 开源的数据科学和机器学习环境管理工具，支持包管理和虚拟环境

`mamba`: conda的开源高性能替代

`pipenv`: 结合 pip 和 virtualenv 的工具，提供更简洁的依赖管理方式

`uv`: 用rust写的高效全能一站式环境包管理工具

## uv使用方法

### 初始化

```bash
uv init <Project-Path>
# --name <Project-Name> # 指定项目名称
# --python <Python-Version> # 指定python版本
# --app 作为app创建
# --lib 作为liv创建
# --script 作为script创建
```

### 文件结构

```bash
├── .git             # git
├── .gitignore       # git
├── hello.py         # 默认代码
├── pyproject.toml   # 项目配置信息
├── .python-version  # python版本
└── README.md        # 说明文件
```

### 使用

```bash
uv run <Py-File> # 运行文件
# --with <lib> 带依赖运行

uv sync # 同步环境，第一次会生成必要文件
uv add <Py-Pkg> # 安装依赖
# --group <Group-Name> # 指定依赖的组，比如区分开发环境和生产环境
uv remove <Py-Pkg> # 删除依赖
uv lock --upgrade-package requests # 更新依赖

uv venv # 进入虚拟环境
deactivate # 退出环境

uv python install <Python-Version> # 安装指定版本的python
uv python list # 列出可用版本
uvx python@3.13.2 -c "print('hello world')" # 用指定版本直接运行

uv pip <Args> # 使用环境中的pip
uv tree # 显示树状图
```

### 全局工具

```bash
uv tool install <Cli-Tool> # 安装全局工具
uv tool run <Cli-Tool> <Args> # 使用全局工具
uvx <Cli-Tool> <Args> # 直接使用工具，未安装会自动下载
```
