---
title: "Linux的一些tips"
auther: chenxi
description: 在Linux下遇到各种问题的解决方式与过程记录。
image: 

categories:
    - 开发
tags:
    - linux
    - 笔记
series:
    - 笔记

date: 2023-05-06T00:34:45+08:00
math: false
comments: false
license: 

hidden: false
draft: false
---

## 常见自带软件/命令使用

### pacman/yay

#### 搜索/安装

```bash
yay -Ss PKG_NAME

yay -S PKG_NAME
# 或
yay -Sy PKG_NAME
```

#### 卸载

卸载包及它依赖的包（往下递归）(常用)
```bash
yay -Rns PKG_NAME
```

卸载包及依赖它的包（往上递归）
```bash
yay -Rnc PKG_NAME
```

-n 不保留配置文件

#### 清理

```bash
yay -Sc # 清理未安装的包缓存
yay -Scc # 清理所有包缓存
```

#### 获取包信息

```bash
yay -Qq # 列出所有本地安装的包
# -Q 查询本地
# -q 省略版本号
yay -Qqe # 列出所有显式安装的包
yay -Qqen
# -n 忽略外部AUR包
yay -Qqd # 列出所有依赖安装的包
yay -Qqdt # 列出所有孤立的包

yay -Qi <PKG> # 获取包的详细信息
```

#### 修改包的元信息

```bash
pacman -D --asexplicit <PKG>
# -D 修改包的元数据
# --asexplicit 显示安装
# --asdeps 依赖安装
```

#### 报错

来自 "****" 的签名是未知信任的

```bash
yay -S archlinuxcn-keyring
# 哪个地址报错，就重新安装哪个地址的
# 比如这里是archlinuxcn
```

### 正则表达式

| 字符串 | 作用 |
| --- | --- |
| * | 贪婪匹配前面的子表达式零次或多次。紧跟?非贪婪 |
| + | 贪婪匹配前面的子表达式一次或多次。紧跟?非贪婪 |
| ? | 匹配前面的子表达式零次或一次 |
| {n} | 匹配签名的子表达式n次 |
| {n,} | 匹配签名的子表达式n次以上 |
| {n,m} | 匹配签名的子表达式n到m次 |
| [ABC] | 匹配[]中所有的字符 |
| [^ABC] | 匹配[]中所有不包含的字符 |
| [a-z] | 匹配一个范围，a-z包含小写字母，A-Z包含大写字母 |
| (ABC) | 分组，标记子表达式的范围，可用于后续的引用 |
| (?:ABC) | 非捕获子表达式，不可用于后续引用 |
| (?=ABC)、(?<=ABC) | 非捕获，前向预查(=在后，<=在前) |
| (?!ABC)、(?<!ABC) | 非捕获，负向预查(!在后，<!在前) |
| \1、\2、…… | 引用第n个匹配的结果 |
| `|` | 选择，匹配多个可能的表达式 |
| . | 匹配除换行符(\n、\r)之外的任意字符 |
| ^ | 匹配输入字符串的开始位置 |
| $ | 匹配输入字符串的结束位置 |
| \d | 匹配数字(==[0-9]) |
| \s | 匹配空白符，包括换行符 |
| \S | 匹配非空白符 |
| \w | 匹配字母、数字、下划线(==[A-Za-z0-9_]) |
| \n | 匹配换行符 |
| \t | 匹配制表符 |
| \b | 匹配单词边界 |
| \B | 匹配非单词边界 |

### 清除查看占用文件的进程

查看文件被哪些进程占用
```bash
lsof <URL>
```

结束进程
```bash
kill <PID>
```

lsof报错`lsof: WARNING: can't stat()`，添加参数`-e <ERROR_URL>`。

### 清楚占用端口的进程

查看端口被哪些进程占用
```bash
ss -tulnp | grep <port>
netstat -tuln | grep <port>
```

结束进程
```bash
kill <PID>
```

### linux同步时间

系统时间信息
```bash
timedatectl status
```

同步ntp时间
```bash
timedatectl set-ntp true
```

设置时区
```bash
timedatectl set-timezone Asia/Shanghai
```

修改ntp服务器：/etc/systemd/timesyncd.conf
```bash
FallbackNTP=ntp.ntsc.ac.cn ntp.aliyun.com ntp.tencent.com
```

重启服务
```bash
systemctl restart systemd-timesyncd
```

### 查看ip信息

```bash
hostname -I
ifconfig
ip addr show
```

### 文本处理

使用sed
```bash
sed [option] 'command' file
```

替换字符串
```bash
sed 's/old/new/g' file
```

正则替换字符串
```bash
sed 's/^old_\(.*\)_string_\(.*\)$/\1 - \2/g' file
# 将 old_111_string_222 替换为 111 - 222
```

### awk — 文本处理神器

> awk 按行读取、按列分割，适合处理结构化文本（日志、CSV、表格等）。

#### 命令格式

```bash
awk [选项] 'pattern { action }' 文件...
awk [选项] -f 脚本文件 文件...
```

##### 常用选项

| 选项 | 作用 |
|------|------|
| `-F fs` | 指定输入分隔符，如 `-F:`、`-F'[,\t]'` |
| `-v var=val` | 传入外部变量 |
| `-f file` | 从文件读取 awk 脚本 |
| `--lint` | 检查语法警告（gawk） |

-v 引入外部变量
```bash
awk -v var1="$num1" -v var2="$num2" '{print var1, var2}' file
```

-f 指定脚本
```bash
awk -f script.awk file
```

-F 指定分隔符
```bash
awk -F: '{print $1, $6}' /etc/passwd
```

#### 内置变量速查

##### 行/列相关

| 变量 | 含义 | 示例 |
|------|------|------|
| `$0` | 当前整行 | `"root:x:0:0:root:/root:/bin/bash"` |
| `$1` ~ `$NF` | 第 N 列 | `$1="root"` |
| `NF` | 当前行字段数（列数） | `NF=7` |
| `NR` | 当前行号（总计数） | `NR=3` |
| `FNR` | 当前行号（文件独立计数） | 多文件时每个文件从 1 开始 |
| `FILENAME` | 当前文件名 | `"passwd"` |

##### 分隔符相关

| 变量 | 含义 | 默认值 |
|------|------|--------|
| `FS` | 输入字段分隔符 | 空格/Tab |
| `OFS` | 输出字段分隔符 | 空格 |
| `RS` | 输入行分隔符 | `\n` |
| `ORS` | 输出行分隔符 | `\n` |
| `FIELDWIDTHS` | 按固定宽度分割（gawk） | — |

##### 其他

| 变量 | 含义 |
|------|------|
| `ARGC` / `ARGV` | 命令行参数数量/数组 |
| `ENVIRON` | 环境变量数组，如 `ENVIRON["HOME"]` |
| `OFMT` | 数字输出格式（默认 `%.6g`） |
| `RSTART` / `RLENGTH` | `match()` 匹配到的起始位置和长度 |

#### 操作符

##### 算术
```awk
+  -  *  /  ^(幂)  %(取余)  ++  --
```

##### 比较
```awk
<  <=  >  >=  ==  !=  ~(匹配)  !~(不匹配)
```
示例：
```awk
$2 > 100
$1 ~ /^192\.168/
$3 !~ /error/
```

##### 逻辑
```awk
&&  ||  !
```

##### 赋值
```awk
=  +=  -=  *=  /=  %=  ^=
```

##### 三元
```awk
条件 ? 真值 : 假值
```

#### pattern（匹配模式）

| 模式类型 | 写法 | 示例 |
|----------|------|------|
| **无 pattern** | — | `{print $1}` 处理所有行 |
| **正则** | `/regex/` | `/^ERROR/` |
| **行号** | `NR > n` | `NR == 1` |
| **表达式** | 布尔条件 | `$3 >= 50 && $3 <= 100` |
| **范围** | `pat1,pat2` | `/start/,/end/` |
| **BEGIN** | `BEGIN { }` | 读文件前执行一次 |
| **END** | `END { }` | 所有行处理完后执行一次 |

#### 控制结构

if/else
```awk
{
    if ($3 > 100)
        print $1, "high"
    else if ($3 > 50)
        print $1, "medium"
    else
        print $1, "low"
}
```

while
```awk
{
    i = 1
    while (i <= NF) {
        printf "%s ", $i
        i++
    }
    print ""
}
```

do-while / for
```awk
{
    i = 1
    do { print $i; i++ } while (i <= NF)

    for (i = 1; i <= NF; i++) print $i
}
```

遍历数组
```awk
END {
    for (key in arr)
        print key, arr[key]
}
```

流程控制语句

| 语句 | 作用 |
|------|------|
| `break` | 跳出循环 |
| `continue` | 跳到下次循环 |
| `next` | 跳过当前行，处理下一行 |
| `nextfile` | 跳过当前文件，开始下一个文件 |
| `exit` | 退出 awk |

#### 内置函数

##### 字符串函数

| 函数 | 说明 | 示例 |
|------|------|------|
| `length([s])` | 字符串长度 | `length($1)` |
| `index(s, t)` | t 在 s 中的位置 | `index("abc","b")` → 2 |
| `substr(s, p [, n])` | 从 p 起截取 n 个字符 | `substr($1,1,3)` |
| `split(s, a [, sep])` | 按分隔符拆到数组 | `split($1, a, ":")` |
| `gsub(r, t [, s])` | 全局替换（返回次数） | `gsub(/old/, "new")` |
| `sub(r, t [, s])` | 第一个替换 | `sub(/foo/, "bar")` |
| `match(s, r [, a])` | 匹配正则，设置 RSTART/RLENGTH | `match($0, /[0-9]+/)` |
| `tolower(s)` | 转小写 | `tolower($1)` |
| `toupper(s)` | 转大写 | `toupper($1)` |
| `sprintf(fmt, ...)` | 格式化字符串（不打印） | `sprintf("%.2f", x)` |
| `gensub(r, t, h [, s])` | 通用替换（gawk） | `gensub(/(a)/,"\\1b","g")` |

##### 数学函数

| 函数 | 说明 |
|------|------|
| `int(x)` | 取整 |
| `sqrt(x)` / `exp(x)` / `log(x)` | 平方根 / e^x / 自然对数 |
| `sin(x)` / `cos(x)` / `atan2(y,x)` | 三角函数 |
| `rand()` | 随机数 [0,1) |
| `srand([x])` | 设置随机种子 |

##### 时间函数（gawk）

| 函数 | 说明 |
|------|------|
| `systime()` | 当前时间戳（秒） |
| `strftime(fmt [, ts])` | 格式化时间，格式同 `date` 命令 |
| `mktime(datespec)` | 日期字符串转时间戳 |

#### printf 格式化输出

```awk
printf "格式符", 参数列表
```

| 格式符 | 说明 | 示例 |
|--------|------|------|
| `%s` | 字符串 | `%10s` 右对齐 10 位，`%-10s` 左对齐 |
| `%d` / `%i` | 整数 | `%5d` |
| `%f` | 浮点数 | `%.2f` 保留两位小数，`%8.2f` 总宽 8 |
| `%e` / `%E` | 科学计数 | `%10.2e` |
| `%x` / `%X` | 十六进制 | `%x` |
| `%%` | 百分号本身 | |

> 格式：`%[标志][宽度][.精度]格式符`；标志 `-` 左对齐，`+` 显示正负号，`0` 补零

#### 数组

awk 只有关联数组（类似字典），下标可以是字符串或数字。

```awk
arr["key"] = "value"      # 赋值
for (k in arr) print k, arr[k]  # 遍历
if ("key" in arr) print "存在"   # 判断存在
delete arr["key"]          # 删除元素
delete arr                 # 删除所有元素（gawk）
```

#### 自定义函数

```awk
function 函数名(参数列表) {
    语句
    return 值
}

function max(a, b) {
    return a > b ? a : b
}

{ print max($1, $2) }
```

> 函数定义必须在 BEGIN 块之前或在独立的 `-f` 文件中。

#### 输入输出重定向与管道

```awk
# 输出到文件
print $0 > "output.txt"

# 追加
print $0 >> "output.txt"

# 管道到 shell
print $0 | "sort -rn"

# 从命令读入
"date" | getline now
close("date")
```

#### getline 的四种用法

```awk
getline                        # 读取文件下一行到 $0
getline var                    # 读取文件下一行到 var
getline < "file"               # 从指定文件读取
"cmd" | getline var            # 从命令输出读取

# 返回值：1=成功  0=文件尾  -1=错误
```

#### 实用示例

打印每行第一项和第五项
```bash
cat file | awk '{print $1, $5}'
```

正则匹配行并打印第一项
```bash
cat file | awk '/pattern/ {print $1}'
```

以","为分隔，打印行号和文字
```bash
cat file | awk 'BEGIN{FS=","} {print NR, $0}'
```

匹配文件中第3个字段小于50并且第7个字段匹配pattern的所有行信息
```bash
cat file | awk '$3<50 && $7~/pattern/ {print $0}'
```

统计空白行
```bash
cat file | awk '/^$/ {sum++} END{print sum}'
```

报表形式统计文件
```bash
cat stu.txt | awk 'BEGIN{printf "%-8s%-5s%-5s%-5s%-5s%-5s%-8s\n","姓名","语文","数学","英语","物理","总分","平均分"} {total=$2+$3+$4+$5;avg=total/4;printf "%-8s%-8d%-6d%-8d%-7d%-5d%0.2f\n",$1,$2,$3,$4,$5,total,avg}'
```
输出：
```bash
姓名      语文   数学   英语   物理   总分   平均分
张三      80      60    85      90     315  78.75
李四      85      65    80      75     305  76.25
```

计算1+2+3+...+100的和
```bash
awk 'BEGIN{while(i<100){i++;sum+=i;}} {print sum}'
awk 'BEGIN{for(i=0;i<=100;i++){sum+=i;}} {print sum}'
```

统计日志中每个 IP 的访问次数
```bash
awk '{count[$1]++} END {for (ip in count) print ip, count[ip]}' access.log | sort -k2 -rn
```

计算某列平均值
```bash
awk '{sum += $3; n++} END {print n > 0 ? sum/n : 0}' scores.txt
```

删除重复行（保持顺序）
```bash
awk '!seen[$0]++' file.txt
```

打印前 N 行 / 跳过前 N 行
```bash
awk 'NR <= 10' file.txt
awk 'NR > 5' file.txt
```

去重（按某列）
```bash
awk '!seen[$2]++' file.txt
```

分组求和
```bash
awk '{sum[$1] += $2} END {for (k in sum) print k, sum[k]}' file.txt
```

多文件关联处理（类似 join）
```bash
awk 'NR==FNR {a[$1]=$2; next} {print $1, a[$1]}' map.txt data.txt
# NR==FNR: 只在第一个文件成立，加载映射表
# 第二个文件：查表输出
```

### 判断linux桌面环境是xorg还是wayland

```bash
echo $XDG_SESSION_TYPE
```

### 检查远程端口

```bash
nc -vz [ip/host] port
```
端口无法连到会超时，被拒绝会显示refused

### shell原生前后台运行

暂停当前任务并放到后台
```bash
ctrl-z
```

将暂停的任务在后台运行，1是作业号
```bash
bg 1
```

将暂停的任务回到前台运行，1是作业号
```bash
fg 1
```
fg 不带作业号，默认是最后一个任务

查看正在运行的任务
```bash
jobs
```

### 获取文件夹大小

```bash
du -h --max-depth=1 ./ # 获取当前文件夹下的各文件的大小
du -h --max-depth=1 ./ | sort -rh | head # 从大到小排序，并获取前10项
```

### 磁盘管理

#### 磁盘分区

gpt分区表用parted，mbr用parted或fdisk都行。

```bash
sudo parted /dev/sda # 分区不用加后面的数字，对整个磁盘操作
```

```parted
print # 查看下当前的分区表，可以用 rm NUMBER 命令删除不要的分区
mkpart NAME TYPE START END # 可以只输入mkpart，它问你一个，回答一个
# NAME，一般为空
# TYPE，可以是ext4,exfat,ntfs....
# START，从头开始为0，其他的根据上面print的结果填写
# END，结束的位置，不要大于整个磁盘的大小
quit # 退出保存
```

```bash
sudo fdisk /dev/sda -l # 查看当前分区表
sudo fdisk /dev/sda # 分区不用加后面的数字，对整个磁盘操作
```

```fdisk
d NUMBER # 删除不要的分区
n # 新建
Partition number (1-128, default 1): # 直接回车默认就行
First sector (2048-XXX, default 2048): # 直接回车默认就行
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-XXX, default XXX): # 输入磁盘大小
+10G # +表示在开始位置上加，10G表示10G大小，其他大小可以看提示里的符号
```

#### 磁盘格式化

格式化用mkfs即可，根据不同文件系统，选择不同参数

```bash
sudo mkfs /dev/sdaX -t TYPE
```
磁盘填自己的位置，TYPE有ext2,ext4,exfat,ntfs,xfs等等文件系统，可以tab查看

#### 磁盘重命名

不同文件系统用不同的指令

```bash
sudo mlabel -i /dev/sdaX ::NEWNAME # fat32
sudo ntfslabel /dev/sdaX NEWNAME # ntfs
sudo e2label /dev/sdaX NEWNAME # ext2,ext3,ext4
sudo exfatlabel /dev/sdaX NEWNAME # exfat
sudo xfs_admin -L "NEWNAME" /dev/sdaX # xfs
```

### 手动更改aur包

1. 下载的包通常位于`$HOME/.cache/yay/$PKGNAME`
2. 修改`PKGBUILD`
3. 执行`makepkg -si`(-s 自动下载makedepend -i 自动安装)

### 比对两个文件

```bash
diff file_old.txt file_new.txt

-y -W 100  # 左右显示比对
-u         # git形式显示比对
```

### 自定义dns地址

修改`NetworkManager`配置
```bash
nano /etc/NetworkManager/conf.d/20-rc-manager.conf
# 添加
[main]
rc-manager=resolvconf
```

修改`resolvconf`配置
```bash
nano /etc/resolvconf.conf
# 添加
name_servers="114.114.114.114 8.8.8.8"
```

重启`NetworkManager`
```bash
sudo systemctl restart NetworkManager
```

### 获取时间

```bash
date
# 获取当前时间戳
date +%s
# 获取时间戳对应的时间
date -d @"TIMENUM"
# 获取时间戳转为指定格式的字符串
date -d @"TIMENUM" +"%Y/%m/%d %H:%M:%S"
# 获取日期字符串转为时间戳
date -d "TIMESTRING" +"%s"
# 偏移量
date +"%Y/%m/%d %H:%M:%S" --date="+1 day" # 明天
date +"%Y/%m/%d %H:%M:%S" --date="-1 year" # 去年
# 格式化输出
date +"%F"
```

#### 完整时间代码

| 代码 | 描述 |
| --- | --- |
| %c | 当前区域设置的日期和时间（例如：2005年03月03日 星期四 23时05分25秒） |
| %s | 自 Epoch (1970-01-01 00:00 UTC) 以来的秒数 |

#### 日期代码

| 代码 | 描述 |
| --- | --- |
| %D | 日期（有歧义）；等于 %m/%d/%y |
| %F | 完整的日期；类似 %+4Y-%m-%d |
| %x | 当前区域设置的日期表示法（例如：1999年12月31日） |
| %C | 世纪（指年份的最高两位）；类似 %Y，但省略最后两位数（例如：20） |
| %y | 年的最后两位（有歧义；00..99） |
| %Y | 年 |
| %g | ISO 周数年的最后两位（有歧义；00-99）；参见 %G |
| %G | ISO 周数年；一般要和 %V 一起使用 |
| %m | 月 (01..12) |
| %b | 当前区域设置的月份缩写（例如：1月） |
| %h | 等于 %b |
| %B | 当前区域设置的月份全称（例如：一月） |
| %q | 季度 (1..4) |
| %d | 日（例如：01） |
| %e | 日，以空格填充；等于 %_d |
| %j | 一年中的第几日 (001..366) |
| %u | 星期几 (1..7)；1 代表星期一 |
| %w | 星期几 (0..6)；0 代表星期日 |
| %a | 当前区域设置的星期几的缩写（例如：日） |
| %A | 当前区域设置的星期几的全称（例如：星期日） |
| %V | ISO 周数，以周一为每周第一天 (01..53) |
| %U | 一年中的第几周，以周日为每周第一天 (00..53) |
| %W | 一年中的第几周，以周一为每周第一天 (00..53) |

#### 时间代码

| 代码 | 描述 |
| --- | --- |
| %T | 时间；等于 %H:%M:%S |
| %r | 当前区域设置中 12 小时制时间（例如：下午 11时11分04秒） |
| %R | 24 小时制的小时和分钟；等于 %H:%M |
| %X | 当前区域设置的时间表示法（例如：23时13分48秒） |
| %p | 当前区域设置中 AM 或 PM 的等价说法（"上午" 或 "下午"）；未知则为空 |
| %P | 类似 %p，但使用小写 |
| %H | 小时 (00..23) |
| %I | 小时 (01..12) |
| %k | 小时，以空格填充 ( 0..23)；等于 %_H |
| %l | 小时，以空格填充 ( 1..12)；等于 %_I |
| %M | 分钟 (00..59) |
| %S | 秒 (00..60) |
| %N | 纳秒 (000000000..999999999) |
| %z | +hhmm 数字时区（例如：-0400） |
| %:z | +hh:mm 数字时区（例如：-04:00） |
| %::z | +hh:mm:ss 数字时区（例如：-04:00:00） |
| %:::z | 数字时区，精度上有必要时加 ":"（例如：-04、+05:30） |
| %Z | 字母时区缩写（例如：EDT） |

#### 其他代码

| 代码 | 描述 |
| --- | --- |
| %% | 字面上的百分号 % |
| %n | 换行 |
| %t | 制表符 |

## 常用第三方软件/命令行

### 终端下载github release文件

获取release文件下载链接（替换链接中内容）
```bash
curl -s https://api.github.com/repos/<OWNER>/<REPO>/releases/latest | grep browser_download_url | awk 'BEGIN{FS="\""} {print $4}'
```

下载文件
```bash
wget -O <SAVE_FILE_NAME> <URL>
```

### pdf编辑

#### pdf分割

pdf每页一个文件
```bash
qpdf input1.pdf --split-pages -- o.pdf
```

每两页一个文件
```bash
qpdf input1.pdf --split-pages=2 -- o.pdf
```

#### pdf合并

保留其中一个文件的信息
```bash
qpdf input1.pdf --pages input2.pdf -- ouput.pdf
```

从新文件开始合并
```bash
qpdf --empty --pages input1.pdf input2.pdf -- output.pdf
```

#### pdf选取某几页

一个范围
```bash
qpdf --empty --pages input.pdf 3-5 -- output.pdf
```

某几页
```bash
qpdf --empty --pages input.pdf 1,3,5 -- output.pdf
```

倒数几页
```bash
qpdf --empty --pages input.pdf r3-r1 --output.pdf
```

逆序
```bash
qpdf --empty --pages input.pdf 5-3 -- output.pdf
```

奇偶页（需qpdf 9以上版本），该奇偶页为最终排序的奇偶页，非原始文件的奇偶页
```bash
qpdf --empty --pages input.pdf 1-5:even -- output.pdf
```

#### 页面旋转

逆时针90度
```bash
qpdf input.pdf --rotate=+90 -- output.pdf
```

顺时针90度
```bash
qpdf input.pdf --rotate=-90 -- output.pdf
```

#### 重复使用主文件

```bash
qpdf input.pdf --pages input2.pdf . -- output.pdf
```

### 文件格式转换

使用pandoc

```bash
pandoc input.md -f markdown -t html -s -o output.html
```
-f markdown -> 输入文件格式 (可根据输入文件后缀猜测省略
-t html     -> 输出文件格式 (可根据输出文件后缀猜测省略
-s          -> 输出为单文件
-o FILENAME -> 输出文件名字

### 修复桌面环境

无法进入桌面(uos)

重新安装桌面环境
```bash
apt install dde startdde
```

### 键盘映射

软件 evtest udevadm

#### 获取键盘信息及按键scanid

```bash
$ evtest
# 输入键盘对应的数字
Input device ID: bus 0x3 vendor 0x1a2c product 0x7f07 version 0x110
Input device name: "SEMICO   USB Gaming Keyboard "
# 记录信息

# 按下按键
Event: time 1715308057.759600, type 4 (EV_MSC), code 4 (MSC_SCAN), value 700e2
Event: time 1715308057.759600, type 1 (EV_KEY), code 56 (KEY_LEFTALT), value 0
# 记录value对应的值
# usb键盘的scanid应当为5位16进制数字
```

#### 修改按键

```bash
cd /etc/udev/hwdb.d/
touch <num>-<word>.hwdb # 数字-名称
# 编辑该文件
```

```hwdb
evdev:input:b<bus_id>v<vendor_id>p<product_id>e<version_id>*
# 每一个id都需要补足到4位，如bus 0x3，则补为b0003
# 16进制的字母大写
# 如：evdev:input:b0003v1A2Cp7F07e0100*
# 也可以用通配符*代替某些字段，只要能匹配到键盘就行

 KEYBOARD_KEY_<scan_id>=<key_name>
# 前面有空格
# key_name可以从 https://hal.freedesktop.org/quirk/quirk-keymap-list.txt 中找
# 如： KEYBOARD_KEY_70029=grave
# 中间不能有注释、空行
```

#### 生效

```bash
sudo udevadm hwdb --update
sudo udevadm trigger
```

请注意，修改生效后，无法删除，只能重启电脑恢复。

### scrcpy

常用参数

```bash
-m    # 分辨率
-b    # 码率 
-Sw   # 黑屏启动
-V    # 通知等级 info warn error
```

### 发送邮件

使用`mailx`命令行，`msmtp`后端，确保都安装了。

设置`msmtp`配置
```bash
nano ~/.msmtprc
# 添加
defaults
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.163.com
port 25
auth on
user USER_NAME@163.com
password USER_PASSWORD
from SEND_USER_NAME@163.com
```

修改`mailx`配置
```bash
nano /etc/mail.rc
# 添加
set mta=/usr/bin/msmtp # 使用msmtp发邮件
unset save             # 发送失败时取消保存dead.letter
```

发送文件
```bash
echo "SEND_CONTENT" | mailx -s "TITLE" "TO_EMAIL_URL"
```

### 同步文件

```bash
rsync src/ target/
```

 - -r 递归进目录
 - -u 更新模式
 - -a 归档模式
 - -delate 从target中删除src里没有的文件
 - -n 不实际运行，用于delate前检查
 - -v 详细信息
 - --progress 传输进度
 - --info=progress2 总体传输进度
 - --max-size 文件最大限制
 - --exclude 排除路径
 - --exclude-from 从文件中获取排除的路径
 - --include 包含路径
 - --include-from 从文件中获取包含的路径

#### 常用方式

```bash
# 更新同步
rsync -ru --info=progress2 /src/ /target/

# 黑名单同步
rsync --exclude-from="./exclude.txt" /src/ /target/

# 白名单同步
rsync --include-from="./include.txt" --exclude="*.*" /src/ /target/
```

### 用ssh端口转发

本地转发到远程

user -> local -> remote -> target

```bash
ssh -fgN -L <local_port>:<target_ip>:<target_port> <remote_user>@<remote_ip> ...
```

远程转发到本地

user -> local -> remote -> target

```bash
ssh -fgN -R <remote_port>:<user_ip>:<user_port> <remote_user>@<remote_ip> ...
```

### 修复nginx模块版本不正确

#### 获取必要信息

yay缓存的模块代码路径：`~/.cache/yay/<PKG_NAME>`，此处我的dav扩展模块的路径为：`/home/<USER>/.cache/yay/nginx-mainline-mod-dav-ext/src/nginx-dav-ext-module-3.0.0`

nginx源码的路径：`/usr/src/nginx/`

获取原先的nginx配置选项，configure arguments: 后的所有内容都复制下来
```bash
nginx -V
```

备份原来的nginx与模块
```bash
mv /usr/bin/nginx /usr/bin/nginx.old
# mv /usr/sbin/nginx /usr/sbin/nginx.old
# mv /bin/nginx /bin/nginx.old
mv /usr/lib/nginx/modules/ngx_http_dav_ext_module.so /usr/lib/nginx/modules/ngx_http_dav_ext_module.so.old
```

#### 编译

root 或 sudo
```bash
cd /usr/src/nginx/
./configure "str" --with-compat --add-dynamic-module="url"
# 这里的"str"是前面复制的configure arguments
# 这里的"url"是前面模块的源码路径
make
```

编译结果在`/usr/src/nginx/objs`

#### 启用

root 或 sudo
```bash
cp /usr/src/nginx/objs/nginx /usr/bin/nginx
# cp /usr/src/nginx/objs/nginx /usr/sbin/nginx
# cp /usr/src/nginx/objs/nginx /bin/nginx
cp /usr/src/nginx/objs/ngx_http_dav_ext_module.so /usr/lib/nginx/modules/ngx_http_dav_ext_module.so

systemctl restart nginx
```

### heic图片转换

安装libheif库
```bash
for file in *.heic ; then
    heif-convert $file ${file/#.heic/.jpg}
done
```

### 判断rsa私钥公钥是否一致

```bash
ssh-keygen -y -f <key> > temp.id_rsa.pub # 生成公钥临时文件
md5sum temp.id_rsa.pub <pubkey> # 比对md5值
rm temp.id_rsa.pub # 删除临时文件
```
