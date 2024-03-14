---
title: "系统全盘迁移"
auther: chenxi

description: 将系统从旧磁盘中迁移到新磁盘，保留所有数据并修复遇到的问题。
image: 
date: 2023-12-17T01:54:10+08:00

categories:
    - linux
tags:
    - linux
    - system

math: false
comments: false
license: 
hidden: false

draft: false
---

## 迁移系统到新硬盘

我买了一个新的迷你电脑，准备把老磁盘中的数据迁移到新的磁盘中，保留原来的系统和数据。

新老硬件都是x86。

### 硬盘克隆

将两个硬盘都连到同一个电脑中，我是新硬盘在新电脑上，将老ssd通过usb连上新电脑，通过U盘上的系统操作。

推荐使用ventoy，随时切换系统很爽。

我使用的是diskgenius软件（是在pe里，但实际上可以在任何系统上，win使用diskgenius，linux使用parted）。

打开软件，点击工具-拷贝硬盘-选择源硬盘（是原来的有系统的硬盘，不要选错）-选择目标硬盘（通常来说是空的）-调整分区大小（可选）-开始。

等待结束即可。

之后的步骤老硬盘用不到了，全程用新的硬盘。

### 修复系统

硬盘克隆后会有诸多问题，所以需要修复，主要是硬盘uuid和grub引导。

#### 修复grub

##### 从livecd进入linux环境

bios里设置usb启动第一位，然后插上ventoy的U盘直接启动，选择自己喜欢的livecd，我使用的是manjaro。

##### chroot到新硬盘的系统中

先查看硬盘中的分区

```bash
sudo fdisk -l

设备                 起点       末尾       扇区  大小 类型
/dev/nvme0n1p1                                        BIOS 启动
/dev/nvme0n1p2                                        EFI 系统
/dev/nvme0n1p3                                        Linux 文件系统
/dev/nvme0n1p4                                        Linux 文件系统
/dev/nvme0n1p5                                        Linux swap
```

可以看到，硬盘中有5个分区，我的第二个是efi分区，第三个是根目录，第四个是home

挂载必要分区

```bash
# 挂载根目录到 /mnt
sudo mount /dev/nvme0n1p3 /mnt
# 挂载home
sudo mount /dev/nvme0n1p4 /mnt/home
# 挂载proc，sys，run，dev
sudo mount -t proc /proc /mnt/proc
sudo mount --rbind /sys /mnt/sys
sudo mount --rbind /run /mnt/run
sudo mount --rbind /dev /mnt/dev
# chroot
chroot /mnt
```

##### 重新写入grub

```bash
# 安装grub到efi分区
sudo grub-install /dev/nvme0n1p2
# 更新grub
sudo update-grub
```

等待完成即可。

#### 修复磁盘自动挂载

获取分区的uuid。

```bash
lsblk -o name,uuid

/dev/nvme0n1p1 xxxxxx
/dev/nvme0n1p2 xxxxxx
/dev/nvme0n1p3 xxxxxx
/dev/nvme0n1p4 xxxxxx
/dev/nvme0n1p5 xxxxxx
```

如果最后一个swap分区没有uuid，就重新创建一个swap。

```bash
mkswap /dev/nvme0n1p5
```

此时再输出一遍就有了。

修改自动挂载文件

```bash
nano /etc/fstab
```

其他不用改动，就把对应的uuid改为前面的新的即可。

### 检查

正常重启，此时应当正常进入系统，不会出现卡grub等问题。


