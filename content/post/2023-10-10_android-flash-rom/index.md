---
title: "小米9扩容刷机"
auther: chenxi
description: "将小米9扩容system分区，并刷入flyme10系统。"
image: 

categories:
    - 玩机
tags:
    - 笔记
    - 安卓
    - 刷机
series:
    - 笔记

date: 2023-10-10T22:25:15+08:00
math: false
comments: false
license: 

hidden: false
draft: false
---

## 前言

其实是打算卖了米9，所以把扩容的flyeme10刷回来miui12.5。

但我这篇为扩容过程，刷回来自行反过来操作就行。

主要内容来自于[酷安-忆昔以西](https://blog.csdn.net/qq_66424312/article/details/131675279)（虽然是csdn的链接，但是是原作者嘛）

## 0 准备

### 软件

- parted软件，我使用的是3.2版本，其他版本有可能出错，以下文件名`parted`，没有后缀名的。
- flyme10的卡刷包（我的来自酷安-wwrrj，请自行搜索），卡刷包与线刷包的区别在最后一步中
  - 不用解压
- miui12.5官方线刷包
  - 请将压缩包解压
  - 通常官方线刷包解压后会有很多bat与sh文件，还有一个image文件夹，里面是非常多文件
  - 其他包大概率只有必要的几个包，如`vendor.img`，`boot.img`等

- 第三方rec，我是用的twrp和orangefox，两个都行反正
  - 文件名为`recovery.img`或者其他名字，请注意和线刷包里的rec文件区分，下面用`twrp.img`指代此文件。
- adb工具

### 硬件

- 能正常使用的数据线

- 米9一部（注意需要解锁bl，不懂请百度）

- 电脑（win系统，linux也可以，反正没有本质区别）

### 命令格式说明

看得懂的可跳过该部分

以下出现的命令，分为两种

- `adb`或者`fastboot`开头的，为电脑命令行中的命令
- `#`开头的，为shell命令，在输入`adb shell`后输入该命令，退出该模式需要输入`exit`

## 0.5 开始usb调试（可跳过）

其实理论上，是不用这步的。

1. 手机连接电脑
2. 打开手机设置-我的设备-全部参数
3. 连点5下`miui版本`，直到跳出处于开发者模式的横条
4. 进入设置-更多设置-开发者选项
5. 打开`usb调试`和`usb安全设置`（实际上安全设置没啥用，应该）
6. 输入命令`adb devices`，在`List of devices attached`下方出现一个设备，左边为设备id，右边的单词是`unauthorized`
7. 此时手机上应该有个弹窗，点击、确定
8. 此时输入命令`adb devices`，在`List of devices attached`下方出现一个设备，左边为设备id，右边的单词是`device`

此时完成usb调试的打开。

## 1 刷rec

扩容操作主要在第三方rec的shell中进行，所以需要刷rec。

从此步开始，你的原系统就没用了

1. 手机关机（或重启，请注意下一步）
2. 同时按住音量减和电源键开机，此时屏幕出现安卓机器人为正确步骤。
3. 手机连接电脑
4. 电脑命令行输入（之后就直接写命令了）`fastboot flash recovery ` ，从文件夹中拖入`twrp.img`，回车运行
5. 等待`Finished`文字出现，出现其他文字请百度如何解决

刷入完成。

## 2 扩容

由于flyme10的system分区大于米9原生的system分区，所以需要对system分区扩容

***请注意！！一定要注意拼写，我前面把`vendor`打成`vender`导致一连串的问题，所以一定要注意拼写。***

1. 关机或重启
2. 同时按住音量加贺电源键开机
   - 刷入twrp的为蓝色屏幕，刷入orangefox为橙色屏幕
   - 虽然rec不同，但功能是一样的
3. 电脑上输入`adb push `拖入`parted`文件，再输入`/sbin/parted`，回车
   - 例如 `adb push D:\files\parted /sbin/parted`
4. 此时应当出现`xxxxx: 1 file pushed, 0 skipped.`，此时为成功
5. 输入`adb shell`回车，此时命令行为`~ #`开头
6. 输入`parted /dev/block/sda`，回车，行首变为`(parted)`
   - 注意，不同设备应该输入的不同，但同为小米9，输入的应当一致
   - 有不懂请看最开始的链接
   - 出现的字不对，行首仍为`~ #`，说明步骤3出错，请重试，或百度
7. 输入`p`回车，出现一大串字，最后两行：
   - `53      1007MB  2617MB  1611MB  ext4         vendor`
   - `54      2617MB  6375MB  3758MB  ext2         system`
   - 这是vendor和system分区，由于要扩容system分区，其后方没有空间可以给它了，所以要从前面vendor分区抢空间
   - 接下来如果问你是或者否，或者其他选择，一律选第一项
8. `rm 53`，这里的53就是前面vendor这一行最前面的序号
9. `rm 54`，54为system分区的序号
10. `mkpart system ext4 1007 6375`
   - 不用创建vendor分区，因为没空间了，所以在userdata分区中分出去一部分当作vendor分区
   - 此时输入`p`，最后一行如下
   - `53      1007MB  6375MB  5368MB ext4         system`
   - system分区为5368MB，一般的刷机包足够了，若需要更多，请将system分区创建在下面的部分（下面的剩余空间足够大）
11. `q`退出parted，此时行首为`~ #`

完成一半了

1. 输入`parted /dev/block/sde`，回车，行首变为`(parted)`
2. 输入`p`回车，出现一大串字，最后一行：
   - `31      2080MB  121GB   119GB   ext4         userdata`
   - 这是userdata分区
3. `rm 31`，这里的31是userdata分区的序号
4. `mkpart vendor ext4 2080 4000`，创建vendor分区
5. `mkpart userdata ext4 4000 121GB`，创建userdata分区
   - 此时输入`p`，最后两行应当为
   - `31      2080MB  4000MB   1920MB   ext4         vendor`
   - `32      4000MB  121GB    119GB    ext4         userdata`
6. 输入`q`退出parted，输入`exit`，退出adb shell

分区的事就到这里了，但扩容还未完成，接下来要格式化刚才新建的分区

重启手机至fastboot模式（比如在电脑终端中输入`adb reboot fastboot`）

1. `fastboot erase vendor`
2. `fastboot erase system`
3. `fastboot erase userdata`

此时手机已经扩容完毕，若是线刷包，可以直接在fastboot模式下线刷了。但我是卡刷包，所以重启至recovery

`fastboot reboot recovery`

## 3.1 刷入卡刷包

卡刷包为zip压缩包，里面有多个img文件，及META文件等

1. 在rec模式下，将zip压缩包复制到手机存储内
   - 如果rec中文件显示为乱码，请百度如何解密，或者百度如何刷入防止自动解密补丁
2. 在rec内，选择该zip文件，确认刷入，等待进度条结束即可。

## 3.2 刷入线刷包

将手机重启至fastboot模式。

线刷包需要解压，文件夹内通常有多个img文件，也可能有bat后缀的文件

如果有bat后缀的文件，直接将这个文件拖入命令行，等待即可。

如果没有，或者bat运行失败，可以手动操作。

   - `fastboot flash boot `，拖入`boot.img`文件回车
   - `fastboot flash system `，拖入`system.img`文件回车
   - `fastboot flash vendor `，拖入`vendor.img`文件回车
   - 。。。。。。

文件与分区名大多为相同的，少数为不同，可以下载一个官方线刷包，查看其bat文件的内容。

## 4 结束

到这里，系统就刷好了，重启手机。

卡住可以强制重启一次，一般来说，第二次就能正常开机了。

如果前面步骤有任何报错，请百度，或者酷安。当然如果没有报错，那我也不知道了，也许是你的刷机包有问题，换一个吧。
