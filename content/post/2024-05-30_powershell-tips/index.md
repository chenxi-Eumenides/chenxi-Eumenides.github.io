---
title: "Powershell的配置、脚本用法"
auther: chenxi
description: 对终端的powershell进行配置、美化，并记录ps1脚本的使用方法。
image: 

categories:
    - 软件
tags:
    - shell
    - win
    - 安装
    - 配置
series:
    - win

date: 2024-05-30T10:50:23+08:00
math: false
comments: false
license: 

hidden: false
draft: false
---

## 安装配置

原始的终端并不算好看，所以打算进行一番配置，以符合我的审美

### 安装

#### powershell

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

#### oh-my-posh

oh-my-posh是一个类似与oh-my-zsh的美化插件，先进行安装。这里的winget我能正常使用，否则请前往官网。

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

### 配置

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

#### 临时在当前环境中启用

```powershell
$env:Path += ";C:\Users\user\AppData\Local\Programs\oh-my-posh\bin"
```

#### 配置主题

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

#### 安装字体

omp的主题大多需要特殊符号，所以要安装一个nerf字体。

官方推荐meslo字体，直接下载。

```powershell
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip" -OutFile Meslo.zip
```

解压后全选ttf文件，右键安装。

在终端-powershell7的配置文件-外观-字体，选择MesloLGM Nerd Font Mono字体，保存。

### 完成

到此，主题安装完成。

我选择使用的是iterm2主题，

## powershell脚本

PowerShell的脚本后缀为ps1

### 变量

定义变量
```pwsh
# 中间可以有空格
$key = value
$list = @()
# 强类型
[int] $key = int_value
[string[]] $list = @('str_value')
```

使用变量
```pwsh
Write-Output $key
Write-Output ${key}
```

#### 整数

#### 浮点

#### 字符串

#### 数组

```pwsh
# 空数组
$list = @()
# 单行定义，可省略@()
$list = @('one','two')
$list = 'one','two'
# 多行定义，逗号可省略
$list = @(
    'one'
    'two'
)
```

```pwsh
$list[0] # 第一个
$list[0,2,5] # 第一、三、六个
$list[1..3] # 第二、三、四个
$list[-1] # 倒数第一个

$list1 + $list2
$list += new_value
$list * 2 # $list + $list
```

```pwsh
$list.count # 获取数量
$list.foreach({"$_"}) # 循环执行
```

```pwsh
$list = @(1,2,3)
$list -join '-' # 1-2-3
-join $list # 123
$list -replace "old","new" # 将old替换new
$list -split "arg" # 以arg分割
2 -in $list # True
$list -eq/ne 1 # 返回完全匹配/不匹配的数组
$list -match 1 # 返回部分匹配的数组
Write-Output -NoEnumerate $data | Get-Member # 不展开数组传递管道
```

#### 对象数组

```pwsh
# 手动定义
$data = @(
    [pscustomobject]@{FirstName='Kevin';LastName='Marquette'}
    [pscustomobject]@{FirstName='John'; LastName='Doe'}
)
```

```pwsh
$data[1] # 访问第二个对象
$data[0].FirstName # 访问第一个对象的FirstName属性
$data.LastName # 获取所有对象的LastName属性
$data.Where({$_.FirstName -eq 'Kevin'}) # 筛选方法
```

```pwsh
$data | ForEach-Object {$_.LastName} # 循环
$data | Where-Object {$_.FirstName -eq 'Kevin'} # 筛选
```

#### 特殊变量

```pwsh
$null # 空
$_ # 管道/循环当中的对象
$PSItem # 与 $_ 相同
```

#### 泛型列表

```pwsh
using namespace System.Collections.Generic
$myList = [List[int]]@(1,2,3)
$myList.Add(4)
$myList.Remove(3)
```

### 控制

#### 判断

```pwsh
if () {
    //
}elseif () {
    //
}else {
    //
}
```

```bash
switch (value/value_list) {
    value1 {}
    value2 {}
    value3 {;break}
}
```

#### 循环

```pwsh
for
```



## 常见用法

### 路径

常见win10路径变量

```txt
%SYSTEMDRIVE% -> 系统所在磁盘分区，通常是 C:\
%SYSTEMROOT% -> Windows系统目录，通常是 C:\Windows
%WINDIR% -> 与%SYSTEMROOT%相同，指向系统目录
%USERPROFILE% -> 当前用户目录，通常是 C:\Users\当前用户名
%HOMEPATH% -> 当前用户主路径，通常是 \Users\当前用户名
%HOMEDRIVE% -> 当前用户所在盘符，通常是 C:\
%APPDATA% -> 当前用户的应用程序数据目录，通常是 C:\Users\当前用户名\AppData\Roaming
%LOCALAPPDATA% -> 当前用户的本地应用程序数据目录，通常是 C:\Users\当前用户名\AppData\Local
%TEMP% 或 %TMP% -> 当前用户的临时文件目录，通常是 C:\Users\当前用户名\AppData\Local\Temp
%PROGRAMFILES% -> 程序文件目录，通常是 C:\Program Files
%PROGRAMFILES(X86)% -> 32位程序文件目录，通常是 C:\Program Files (x86)
%ALLUSERSPROFILE% -> 所有用户的公共数据目录，通常是 C:\ProgramData
```

### 测试远程端口

```pwsh
test-NetConnection -ComputerName <IP> -Port <PORT>
```

### 
