---
title: "Ranger配置及使用"
auther: chenxi

description: ranger的功能配置，及使用的一些方法
image: 
date: 2023-05-06T01:35:00+08:00

categories:
    - 笔记
    - linux
tags:
    - 笔记
    - ranger
    - tips
    - linux
series:
    - 笔记

math: false
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

| 按键1 | 按键2 | 作用 |
|:-----:|:-----:|:----:|
|h|←|返回上一层|
|l|→|进入文件/文件夹|
|j|↓|向下|
|k|↑|向上|
|Enter||打开文件|
|q||退出|

### 新建/删除

| 按键1 | 按键2 | 作用 |
|:-----:|:-----:|:----:|
|F7|`:mkdir`|新建文件夹|
|INSERT|`:touch`|新建文件|
|dD|F8|删除文件/文件夹，等同`:delete`|
|DD||移至回收站|

### 重命名

| 按键 | 作用 |
|:----:|:----:|
|cw|重命名，包括后缀|
|I|重命名，光标在最前|
|A|重命名，光标在最后|
|a|重命名，光标在最后，不包括后缀|

### 粘贴

| 按键 | 作用 |
|:----:|:----:|
|pp|粘贴，默认 append 模式|
|pP|append 模式，如果该目录中有同名条目，则在条目后面加上 _、_0、_1……。如果条目是文件，则在文件后缀名后加入。|
|po|overwrite 模式，如果该目录中有同名条目，则覆盖原来的条目。|
|pO|append 模式 + overwrite 模式。|
|pl|粘贴为符号链接，不在状态栏显示目标条目的相对路径。|
|pL|粘贴为符号链接（相对路径），在状态栏显示目标条目的相对路径。|
|phl|粘贴为硬链接|
|pht|粘贴为硬链接的子目录（hardlinked subtree）|

### 搜索

| 按键 | 作用 |
|:----:|:----:|
|/|打开搜索框，输入要搜索的字符串，回车后开始搜索。|
|f|查找，等同于运行满足条件的文件或者打开满足条件的文件夹。|
|zf|与命令行 filter 作用一样，只显示符合条件的条目，区分大小写。|
|n N|查找下一个搜索结果 查找上一个搜索结果|
|c + 对应字母|通过对应属性依次遍历，如：ca：通过 atime属性依次遍历cc：通过 ctime 属性依次遍历ci：通过 mimetype 属性依次遍历cm：通过 mtime 属性依次遍历cs：通过 size 属性依次遍历ct：通过 tag 属性依次遍历|

### 帮助页面

| 按键 | 作用 |
|:----:|:----:|
|m|打开手册页|
|k|打开按键绑定|
|c|打开可用命令和描述的列表|
|s|打开设置及其当前值的列表|
