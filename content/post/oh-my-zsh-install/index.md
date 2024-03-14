---
title: "oh-my-zsh安装及配置"
auther: chenxi

description: oh-my-zsh的安装过程与配置
image: 
date: 2023-01-29T05:02:30+08:00

categories:
    - 笔记
    - linux
tags:
    - zsh
    - 安装
    - 配置
    - shell

math: false
comments: false
license: 
hidden: false

draft: false
---

## 前言

本文基本来至[oh-my-zsh官网](https://ohmyz.sh/#install)

## 安装

### zsh

系统为manjaro,直接pacman安装zsh

```bash
pacman -Sy zsh
```

在`/etc/passwd`中修改root和用户的默认shell为`/bin/zsh`。

重启终端即可。

### oh-my-zsh

前往官网复制安装命令，一键安装。

以下二选一即可。

1.使用curl
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
2.使用wget
```bash
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

## 配置

oh-my-zsh会自动替换.zshrc文件。

### alias

alias就是命令的简写方式

格式为`alias short_command='long_command'`

在.zshrc文件尾添加alias,也可以在.zshrc文件尾添加`source .zsh_alias`，然后创建.zsh_alias文件，在这其中添加alias。

### 插件

在[github](https://github.com/zsh-users)上可以看到多个插件，点进去，找到`INSTALL.md`链接，找到oh-my-zsh的安装命令，在终端中运行。

在`.zshrc`文件中的plugin一项中，添加刚下载的插件名称即可。

### 主题

去[官网](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)可以找到所有的主题，在更改theme变量为所要的主题名。

## 更新配置

刚写完的配置是不会启用的，手动启用一次，或者打开新的终端就能使用了

```bash
source .zshrc
```
