---
title: "Shell 脚本基本规则及常见用法"
auther: chenxi

description: 包含了一些shell的基本规则和常见用法，用于写sh脚本时查询
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

#### 普通变量

定义变量
```bash
key="str"
# or
key=str
# 建议用第一种
```

使用变量
```bash
$key
# or
${key}
```

变量判断
```bash
# 若值未定义，则以default字符串或者变量${var}作为其值
${key-default}
${key=default}
# 若值未定义，或者为空，则以default字符串或者变量${var}作为其值
${key:-default}
${key:=default}
# 若值已定义，则以default字符串或者变量${var}作为其值
${key+default}
# 若值已定义，并且不为空，则以default字符串或者变量${var}作为其值
${key:+default}

# 若值未定义，报错error_msg并退出
${key?error_msg}
# 若值未定义，或者为空，报错error_msg并退出
${key:?error_msg}
```

#### 字符串变量

字符串长度
```bash
${#str}
```

字符串截取
```bash
# 按位数截取
${str:5} # 从左侧第6个字符(0是第1个，1是第2个)开始，截取到末尾
${str:0-7:3} # 从右侧第7个字符开始，截取3个字符
# 从右往左正则截取(配合通配符)
${str%regex}
# 从右往左贪婪正则截取
${str%%regex}
# 从左往右正则截取
${str#regex}
# 从左往右贪婪正则截取
${str##regex}
```

字符串替换
```bash
str="old_string"
${str/#old/new}
```

字符串大小写
```bash
# 大写
${str^^}
# 小写
${str,,}
```

#### 变量匹配

```bash
# 匹配所有以char开头的变量名
# 得到的是变量名，不是变量值
${!char*}
${!char@}
```

#### 变量的变量

```bash
var_name="name"
name="var_value"
${!ver_name} # 得到 "var_value"
```

### 数组

#### 普通数组

定义数组
```bash
key=("value1" "value2" "value3")
# or
key="value1 value2 value3"
# 建议用第一种
```

使用数组
```bash
${key[index]}
# 从0开始
```

#### 关联数组

定义关联数组
```bash
declare -A dic=(["key1"]="value1" ["key2"]="value2")
# or
declare -A dic
dic["key1"]="value1"
dic["key2"]="value2"
```

使用关联数组
```bash
# 获取key对应的value
${dic[key]}
# 获取所有的key（倒序）
${!dic[*]}
# 获取所有的value（倒序）
${dic[*]}
```

### 字符串值

```bash
"str"
# ${value} 变量 $(command) 函数 等
# \n 换行 \r 回到行首
'str'
# 字面值
```

#### 打印字符串

echo
```bash
echo "str1" "str2" # str1 str2

echo -ne "12345\r67\n" # 67345
# -n 结尾不换行
# -e 允许\r操作符回到行首
# 与printf默认行为一致
```

printf
```bash
printf "string\n"

printf "num:%d float:%f char:%c str:%s\n" $num $float $char $str
# % 转义符
# %2d 2宽 %.2d 2宽，用0补充
# %.2f 小数点后两位，四舍五入
# %2c 2宽
# %x 十六进制数 %o 八进制数 %e 二进制数
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
# 多个参数 空格分隔
```

函数返回值
```bash
return 0
# 0-255
# 0为正常运行 1-255为报错
```

### 控制

#### 判断

```bash
if [[ condition ]]; then
    #statements
elif [[ condition ]]; then
    #statements
else
    #statements
fi

# 简易写法
# 与
command1 && command2
# 左边返回真（$?==0），右边才执行

# 或
command1 || command2
# 左边返回假（$?==1），右边才执行
```
#### 循环

```bash
# 条件循环
for (( i = 0; i < 10; i++ )); do
    #statements
done
# 等价于
for i in `seq 0 9`; do
    #statements
done
# 等价于
for i in {0..9}; do
    #statements
done

# 枚举循环
for i in word1 word2 word3; do
    #statements
done
# 等价于
words=(word1 word2 word3)
for i in ${words[@]}; do
    #statements
done
```

### 参数

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

### 获取命令输出

```bash
$(command) # 支持嵌套，推荐
# 或者
`command`
```

### 管道

```bash
command1 | command2
```

### 合并执行

```bash
# 在当前shell中执行
(command1; command2; command3)

# 在子shell中执行
{ command1; command2; command3 }
# {}与命令间有空格
```

### 判断条件

双中括号（字符串比较）(推荐)
```bash
# 字符串匹配
[[ string == str* ]]
# 右侧可以为模式，*等通配符无需引号
# *任意字符

# 相等 ==
# 不等于 !=
# 正则匹配 =~ 左侧为被搜索内容，右侧为正则内容
# ascii码比较 < >

# 可使用中括号的所有内容
```

单中括号
```bash
# 字符串比较
[ a != b ]
# 支持 ==相等, !=不等

# 整数比较
[ 1 -eq 2 ]
# 支持 -eq等于 -ne不等于 -lt小于 -le小于等于 -gt大于 -ge大于等于

# 逻辑计算
[ true -a true ]
# 支持 -a逻辑与 -o逻辑或

# 文件判断
[ -d file ]
# 支持 -d为目录 -e存在 -f文件 -r可读 -w可写 -x可执行 -O拥有 -G同组
[ file1 -nt file2 ]
# 支持 -nt新于 -ot旧于
```

双小括号（数学比较）
```bash
# 计算数学表达式
(( 1 + 1 && 1 ))
# 支持 + - * / % ** ++ -- (整数运算)
# 支持 && || ! ~ >> << & |

# 结果非0或为真，返回真（1）
# 结果为0或为假，返回假（0）

# 优先级同C语言
# 可使用中括号的所有内容
```

### 数值计算
```bash
# 使用bash内置计算方式
res=$[$num1 + $num2]
# 支持 + - * /
# 只能整数计算，除法向下取整

# 使用expr计算
res=$(expr $num1 \* $num2)
# 支持 + - \* / % （请注意乘法需要加转义符\）
# 只能整数计算，除法向下取整

# 使用 bc 命令行工具计算
res=$(echo "scale=3;($num1 + $num2) * $num3 / $num4" | bc)
# scale=3 精度为小数点3位
```

### C语言规则
```bash
$((exp))
# 只要符合C语言运算规则

# 正常的计算
$(( (1*(1+1)-1)/1%1 ))
# 只支持整数计算

# 三目运算符
$(( 1 != 2 ? 1 : 2 ))

# 不同进制
$(( 16#2a ))
# 结果为 42（转成十进制）
```

### 其他

```bash
# 命令替换
(cmd) 
# 等同 `cmd`

# 重定义变量
(( a++ ))

# 文件名扩展
ls {file1,file{2..3},file[4-5]}.sh
# 等同于
ls file1.sh file2.sh file3.sh file4.sh file5.sh
```

## 常用方法

### 获取后缀名

```bash
# 截取文件后缀名
${url##*.}
# 截取文件名
${url##*/}
# 截取文件夹路径
${url%/*}/
```

### 判断变量是否存在

```bash
if [[ -z "${key=}" ]] ; then
    # 未定义
elif [[ -z "${key:=}" ]] ; then
    # 定义但为空
else
    # 存在
fi
```

### 工作路径切换

```bash
work_url=$(cd $(dirname $0);pwd)
cd "${work_url}"
# 切换到父文件夹
cd "${work_url%/*}"
```

### 获取带空格的文件名

```bash
# 方法一(推荐)
readarray -t files <<< "$(ls)"
for file in "${files[@]}"; do
    echo "$file"
done

# 方法二
SAVEIFS=$IFS
IFS=$'\n'
for file in ./* ; do
    echo $file
done
IFS=$SAVEIFS

# 方法三
SAVEIFS=$IFS
IFS=$'\n'
fileArray=($(find . -type f))
IFS=$SAVEIFS
tLen=${#fileArray[@]}
for (( i=0; i<${tLen}; i++ )) ; do
    echo "${fileArray[$i]}"
done
```

### 判断语句的简单写法

```bash
[[ -z $1 ]] && echo true || echo false
```

### 判断字符串是否在数组中

简单判断(可能部分匹配)
```bash
[[ "${array[@]}" =~ "$1" ]] && echo true || echo false 
```

完整判断
```bash
for str in "${array[@]}"; then
    if [[ "$str" == "$1" ]]; then
        echo True
        break
    fi
done
```

