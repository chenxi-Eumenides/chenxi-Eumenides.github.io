---
title: "Shell 脚本常见用法"
auther: chenxi

description: 包含了一些常见的用法和常见问题
image: 
date: 2023-08-11T14:00:49+08:00

categories:
    - 笔记
    - linux
tags:
    - shell
    - 笔记
    - 脚本

math: false
comments: false
license: 
hidden: false

#draft: true
---

## 适用范围

适用于`bash`，`zsh`等shell的sh脚本文件

## 基本

### 变量

定义变量
```bash
key="str"
# or
key=str
# 建议用第一种
```

定义数组
```bash
key=("value1" "value2" "value3")
# or
key="value1 value2 value3"
# 建议用第一种
```

定义关联数组
```bash
declare -A key=(["name1"]="value1" ["name2"]="value2")
# or
declare -A key
key["name1"]="value1"
key["name2"]="value2"
```

使用变量
```bash
$key
# or
${key}
```

使用数组
```bash
${key[index]}
# 从0开始
```

使用关联数组
```bash
${key["name"]}
```

### 函数

定义函数
```bash
func_name() {
    commands
}
# or
function func_name() {
    commands
}
```

使用函数
```bash
func_name args
```

### 参数

传入参数
```bash
func_name arg_1 arg_2
```

获取参数
```bash
$1 $2 #......
# 最多9个
```

特殊参数
```bash
# 文件名(相对路径)
$0
# 所有参数(单字符串)
$* # "$1 $2 $3..."
# 所有参数(多字符串)
$@ # "$1" "$2" "$3" ...
# 参数个数
$#
# 脚本的进程ID
$$
# 后台运行的最后一个进程ID
$!
# shell使用的当前选项
$-
# 最后一个命令的退出值，一般0为正常运行无错误，范围是0~255(-1)
$?
```

### 获取命令输出值

```bash
`commands`
# 例如
new_key=`echo ${key} | commands --args`
```

## 常用方法

### 变量值相关

#### 判断字符串值

```bash
# 若值未定义，则以default作为其值
${key-default} # default可以用变量${var}
${key=default} # 同上
# 若值未定义，或者为空，则以default作为其值
${key:-default}
${key:=default}
# 若值已定义，则以default作为其值
${key+default}
# 若值已定义，并且不为空，则以default作为其值
${key:+default}

# 若值未定义，报错error_msg并退出
${key?error_msg}
# 若值未定义，或者为空，报错error_msg并退出
${key:?error_msg}

# 匹配所有以char开头的变量名
# 得到的是变量名，不是变量值
${!char*}
${!char@}
```

#### 字符串长度

```bash
${#key}
```
#### 字符串截取

```bash
# 按位数截取
${key:5} # 从左侧第6个字符(0是第1个，1是第2个)开始，截取到末尾
${key:0-7:3} # 从右侧第7个字符开始，截取3个字符
# 从右往左正则截取(配合通配符)
${key%regex}
# 从右往左贪婪正则截取
${key%%regex}
# 从左往右正则截取
${key#regex}
# 从左往右贪婪正则截取
${key##regex}
```

例如
```bash
# 截取文件后缀名
${url##*.}
# 截取文件名
${url##*/}
# 截取文件夹路径
${url%/*}/
```

#### 判断变量是否存在

```bash
if [ -z "${key=}" ] ; then
    # 未定义
elif [ -z "${key:=}" ] ; then
    # 定义但为空
else
    # 存在
fi
```

# 待续

待续



