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

[PowerShell 的维基百科](https://en.wikipedia.org/wiki/PowerShell)

[微软 PowerShell 文档](https://docs.microsoft.com/en-us/powershell/)

[PowerShell 官方网站](https://powershell.org/)

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

```pwsh
$int = 1
```

#### 浮点

```pwsh
$float = 1.1
```

#### 字符串

```pwsh
$str = "string"
```

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
#### hash表

```pwsh
$hash = @{ ID = 1; Shape = "Square"; Color = "Blue"} # 无序
$hash = [ordered]@{ ID = 1; Shape = "Square"; Color = "Blue"} # 有序

$hash["Updated"] = "Now"
$hash.Add("Created","Now")

$hash.Remove("Updated")
```

```pwsh
$hash["ID"] # 取值
$hash.keys # 取key数组
$hash.values # 取value数组
$hash.Number # 取数量
$hash.Count # 取大小
$hash.GetEnumerator() | Sort-Object -Property key # 根据key排序
```

#### 特殊变量

| 特殊变量 | 描述 |
| --- | --- |
| $$ | 表示会话收到的最后一行中的最后一个令牌。 |
| $? | 表示上次操作的执行状态。 如果最后一次操作成功则包含 TRUE，如果失败则包含 FALSE。 |
| $^ | 表示会话收到的最后一行中的第一个令牌。 |
| $_ | 与 $PSItem 相同。 包含管道对象中的当前对象。 您可以在对管道中的每个对象或选定对象执行操作的命令中使用此变量。 |
| $ARGS | 表示传递给函数、脚本或脚本块的未声明参数和/或参数值的数组。 |
| $CONSOLEFILENAME | 表示会话中最近使用的控制台文件 (.psc1) 的路径。 |
| $ERROR | 表示一个错误对象数组，这些对象代表最近的错误。 |
| $EVENT | 表示 PSEventArgs 对象，该对象表示正在处理的事件。 |
| $EVENTARGS | 表示一个对象，该对象表示从正在处理的事件的 EventArgs 派生的第一个事件参数。 |
| $EVENTSUBSCRIBER | 表示一个 PSEventSubscriber 对象，该对象表示正在处理的事件的事件订阅者。 |
| $EXECUTIONCONTEXT | 表示 EngineIntrinsics 对象，该对象表示 PowerShell 主机的执行上下文。 |
| $FALSE | 代表FALSE。 您可以在命令和脚本中使用此变量来表示 FALSE，而不是使用字符串"false"。 |
| $FOREACH | 表示 ForEach 循环的枚举数（不是结果值）。 您可以对 $ForEach 变量的值使用枚举器的属性和方法。 |
| $HOME | 表示用户主目录的完整路径。 |
| $HOST | 代表一个对象，该对象代表 PowerShell 的当前主机应用程序。 |
| $INPUT | 表示一个枚举器，用于枚举传递给函数的所有输入。 |
| $LASTEXITCODE | 表示最后运行的基于 Windows 的程序的退出代码。 |
| $MATCHES | $Matches 变量与 -match 和 -notmatch 运算符一起使用。 |
| $MYINVOCATION | $MyInspiration 仅针对脚本、函数和脚本块填充。 $MyInspiration 自动变量的 PSScriptRoot 和 PSCommandPath 属性包含有关调用者或调用脚本的信息，而不是当前脚本的信息。 |
| $NESTEDPROMPTLEVEL | 代表当前提示级别。 |
| $NULL | $null 是包含 NULL 或空值的自动变量。 您可以使用此变量来表示命令和脚本中不存在或未定义的值。 |
| $PID | 表示托管当前 PowerShell 会话的进程的进程标识符 (PID)。 |
| $PROFILE | 表示当前用户和当前主机应用程序的 PowerShell 配置文件的完整路径。 |
| $PSCMDLET | 代表一个对象，该对象代表正在运行的 cmdlet 或高级函数。 |
| $PSCOMMANDPATH | 表示正在运行的脚本的完整路径和文件名。 |
| $PSCULTURE | 表示操作系统中当前使用的区域性名称。 |
| $PSDEBUGCONTEXT | 调试时，该变量包含有关调试环境的信息。 否则，它包含 NULL 值。 |
| $PSHOME | 表示 PowerShell 安装目录的完整路径。 |
| $PSITEM | 与$_相同。 包含管道对象中的当前对象。 |
| $PSSCRIPTROOT | 表示正在运行脚本的目录。 |
| $PSSENDERINFO | 表示有关启动 PSSession 的用户的信息，包括用户身份和发起计算机的时区。 |
| $PSUICULTURE | 表示操作系统中当前使用的用户界面 (UI) 区域性的名称。 |
| $PSVERSIONTABLE | 表示一个只读哈希表，显示有关当前会话中运行的 PowerShell 版本的详细信息。 |
| $SENDER | 表示生成此事件的对象。 |
| $SHELLID | 表示当前shell的标识符。 |
| $STACKTRACE | 表示最近错误的堆栈跟踪。 |
| $THIS | 在定义脚本属性或脚本方法的脚本块中，$This 变量引用正在扩展的对象。 |
| $TRUE | 代表 TRUE。 您可以使用此变量在命令和脚本中表示 TRUE。 |

#### 泛型列表

```pwsh
using namespace System.Collections.Generic
$myList = [List[int]]@(1,2,3)
$myList.Add(4)
$myList.Remove(3)
```

### 运算符

#### 算术运算符

```pwsh
+ # 加
- # 减
* # 乘
/ # 除
% # 取模
```

#### 比较运算符

```pwsh
-eq # 等于
-ne # 不等于
-gt # 大于
-ge # 大于等于
-lt # 小于
-le # 小于等于
```

#### 赋值运算符

```pwsh
= # 赋值
+= # 加并赋值
-= # 减并赋值
```

#### 逻辑运算符

```pwsh
-AND # 逻辑与
-OR # 逻辑或
-NOT # 逻辑非
```

#### 其他运算符

```pwsh
> # 重定向、写入
>> # 写入追加
```

### 控制

#### 判断

```pwsh
if () {
    //
} elseif () {
    //
} else {
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
for ($i = 0; $i -lt 10; $i++) {
    Write-Host "$array[$i]"
}

foreach ($element in $array) {
    Write-Host "$element"
}
$array | foreach {
    Write-Host "$_"
}

while ($counter -lt $array.length) {
    $array[$counter]
    $counter += 1
}
do {
   $array[$counter]
   $counter += 1
} while ($counter -lt $array.length)
```

### 其他

```pwsh
commands `
 | commands # 反引号换行
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
