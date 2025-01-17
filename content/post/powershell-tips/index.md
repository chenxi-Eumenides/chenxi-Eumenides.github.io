---
title: "Powershell的美化与配置"
auther: chenxi

description: 对终端的powershell进行配置，并美化
image: 
date: 2024-05-30T10:50:23+08:00

categories:
    - 笔记
    - win
tags:
    - shell
    - win
    - 安装
    - 配置

math: false
comments: false
license: 
hidden: false

draft: false
---

## 前言

原始的终端并不算好看，所以打算进行一番配置，以符合我的审美

## 安装

### powershell

默认的powershell版本为5.1，将其升级为powershell 7。powershell 7默认就开启了很多功能，比如我最爱的↑↓→键快速匹配历史记录。

当前使用的版本

```powershell
$psversiontable
```

我的版本7.4.2。

没有7版本的进行安装

```powershell
winget install --id Microsoft.PowerShell
```

我的电脑默认两个版本都安装了，所以将终端的powershell 7启用即可。

终端-设置-新配置文件-从powershell复制

路径改为：`C:\Program Files\PowerShell\7\pwsh.exe`

将默认值改为该配置文件。

### oh-my-posh

oh-my-posh是一个类似与oh-my-zsh的美化插件，先进行安装。这里的winget我能正常使用，否则请前往官网。

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

## 配置

编辑powershell的用户配置

```powershell
notepad $PROFILE

# 没有该文件，则创建一个新的
New-Item -Path $PROFILE -Type File -Force
```

添加以下内容保存

```txt
oh-my-posh init pwsh | Invoke-Expression
```

重启终端。

### 临时在当前环境中启用

```powershell
$env:Path += ";C:\Users\user\AppData\Local\Programs\oh-my-posh\bin"
```

### 配置主题

主题是一个json配置文件，默认自带就有很多。

查看已安装主题

```powershell
Get-PoshThemes
```

要使用某个主题，编辑powershell配置

```powershell
notepad $PROFILE
```

将前面的语句修改为

```txt
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/<THEME_NAME>.omp.json" | Invoke-Expression
```

重启终端

### 安装字体

omp的主题大多需要特殊符号，所以要安装一个nerf字体。

官方推荐meslo字体，直接下载。

```powershell
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip" -OutFile Meslo.zip
```

解压后全选ttf文件，右键安装。

在终端-powershell7的配置文件-外观-字体，选择MesloLGM Nerd Font Mono字体，保存。

## 完成

到此，主题安装完成。

我选择使用的是iterm2主题，
