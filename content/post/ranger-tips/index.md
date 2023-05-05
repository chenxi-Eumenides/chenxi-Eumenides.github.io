---
title: "Ranger配置及使用"
description: ranger的功能配置，及使用的一些方法
image: 
auther: chenxi
date: 2023-05-06T01:35:00+08:00
categories:
    - Tips
    - 笔记
tags:
    - 笔记
    - ranger
    - tips
    - linux
series:
    - 笔记
math: 
comments: false
license: 
hidden: false
draft: false
---

## 安装

pacman直接安装即可

## 配置

运行命令将全局配置复制到 `~/.config/ranger/`
```bash
ranger --copy-config=all
```

编辑`~/.config/ranger/rc.conf`。

### 文件预览

默认打开的。
```code
set preview_files true
```

### 图像预览

`注：我按照网上说的没成功。有说需要xterm字符界面，不能是terminal虚拟终端。`

```code
set preview_images false # 改成 true
set preview_images_method w3m # 改成自己用的就行 w3m/kitty/等，需要自己安装
```

### 代码高亮

安装`highlight`即可。
```bash
pacman -S highlight
```

### 压缩包预览

安装`atool`即可。
```bash
pacman -S atool
```

### 编辑器选择

第一次用ranger打开文件会让选择编辑器

### 外观

```code
set draw_borders true # 绘制边框
set line_numbers true # 显示序号
set column_ratios 2,3,5 # 设置宽度，比例
```

## 使用

### 基本操作

| 字符1 | 字符2 | 作用 |
|:-----:|:-----:|:----:|
|h|←|返回上一层|
|l|→|进入文件/文件夹|
|j|↓|向下|
|k|↑|向上|

