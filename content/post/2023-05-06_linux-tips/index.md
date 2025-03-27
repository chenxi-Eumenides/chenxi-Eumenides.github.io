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
```

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

### 文件格式化处理

使用awk
```bash
awk 'BEGIN{commands} pattern {commands} END{commands}' file
```
BEGIN{} 开始前运行的命令
pattern 匹配模式
{} 处理命令
END{} 结束后运行的命令
命令间用 ; 分隔

-v 引入外部变量
```bash
awk -v var1="$num1" -v var2="$num2" '' file
```

-f 指定脚本
```bash
awk -f file.awk '' file
```

-F 指定分隔符
```bash
awk -F, '' file
```

#### 匹配模式

正则匹配
```bash
awk '/pattern/ {commands}'
```

关系匹配
```bash
awk '$1>10 {commandss}'
```

关系运算符
```awk
<  小于
>  大于
<= 小于等于
>= 大于等于
== 等于
!= 不等于
~  匹配正则表达式
!~ 不匹配正则表达式
```

布尔运算符
```awk
|| 或
&& 与
!  非
```

#### 内置变量

```awk
$0 整行内容
$n 第n个内容
NF 当前行总列数
NR 当前行行数，从1开始
FNR 当前行在当前文件的行数，从0开始
FS 字段分隔符，默认空格及tab
RS 行分隔符，默认回车
OFS 输出字段分隔符
ORS 输出行分隔符
FILENAME 当前输入文件名字
ARGC 命令行参数个数
ARGV 命令行参数数组
```

#### 内置命令

表达式
```awk
+ - * / % ^ **
++x x++ --x x--
```

输出
```awk
print $1 $2
printf "%4s %-4s","string","string"
```
%s字符串 %c字符的ascll码 %d整数 %f浮点数 %x十六进制 %o八进制 %e科学计数法
%-N 左对齐 %+N 右对齐 %# 8进制前加0，16进制前加0x
%.2f 小数点后两位

```awk
length(str) # 字符串长度
index(str1,str2) # 在str1中找str2的位置
substr(str,m,n) # 从str的m个字符开始，截取n位
split(str,arr,fs) # 按fs切割字符串并保存在arr中，返回切割后的子串个数
match(str,RE) # 在str中按照RE查找，返回索引位置
sub(RE,RepStr,str) # 在str中替换第一个符合RE的子串为RepStr，返回替换的个数
gsub(RE,RepStr,str) # 在str中替换所有符合RE的子串为RepStr，返回替换的个数
```

条件语句
```awk
if(){}else if(){}else{}
```

循环语句
```bash
while(){}
do{}while()
for(;;){}
```

#### 常用例子

打印每行第一项和第五项
```bash
cat file | awk '{print $1 $5}'
```

正则匹配行并打印第一项
```bash
cat file | awk '/pattern/ {print $1}'
```

以“,”为分隔，打印行号和文字
```bash
cat file | awk 'BEGIN{FS=","} {print NR "TEXT"}'
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
cat stu.txt |awk 'BEGIN{printf "%-8s%-5s%-5s%-5s%-5s%-5s%-8s\n","姓名","语文","数学","英语","物理","总分","平均分"} {total=$2+$3+$4+$5;avg=total/4;printf "%-8s%-8d%-6d%-8d%-7d%-5d%0.2f\n",$1,$2,$3,$4,$5,total,avg}'
```
输出：
```bash
姓名      语文   数学   英语   物理   总分   平均分
张三      80      60    85      90     315  78.75
李四      85      65    80      75     305  76.25
```

计算1+2+3+...+100的和。
```bash
awk 'BEGIN{while(i<100){i++;sum+=i;}} {print sum}'
awk 'BEGIN{for(i=0;i<=100;i++){sum+=i;}} {print sum}'
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
# 格式化输出
date +"%F"
```

#### 日期

```bash
%D # mm/dd/yy 格式
%F # yyyy-mm-dd 格式

%a # 日期名称，缩写为 Mon、Tue、Wed 等
%A # 当天的全称，周一周二周三等
%u # 星期几，其中星期一=1，星期二=2，星期三=3，依此类推。
%w # 星期几，星期日=0，星期一=1，星期二=2，依此类推。
%d # 月份中的第几天，带有前导零（01、02 … 09）。
%e # 月份中的第几天，带有前导空格（‘1’、‘2’……‘9’）。
%j # 一年中的第几天，最多有两个前导零。
```

#### 时间

```bash
%T # HH:MM:SS 格式，24小时制
%R # HH:MM 格式，24小时制
%r # 12 小时制
%X # 24 小时制，根据语言环境
```

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
qpdf input1.pdf --split-pages
```

每两页一个文件
```bash
qpdf input1.pdf --split-pages=2
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
