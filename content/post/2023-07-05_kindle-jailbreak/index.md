---
title: "Kindle越狱"
auther: chenxi
description: 记录我自己在越狱kindle中的流程与遇到的问题及解决方法。
image: 

categories:
    - 玩机
tags:
    - kindle
    - 越狱
    - 阅读
series:
    - 笔记

date: 2023-07-05T01:09:41+08:00
math: false
comments: false
license: 

hidden: false
draft: false
---

## 前言

本文内容基本来自于[书伴](https://bookfere.com/post/970.html)

越狱插件内容基本来自于[书伴](https://bookfere.com/post/311.html)

如有疑问, 请前往源网站查看。

## 准备

### 设备

- 设备型号：Kindle Voyage
- 系统版本：5.13.6（其他版本请查阅[原网站](https://bookfere.com/post/406.html)
- 任意电脑（请熟悉电脑操作）
- 一根可以传输数据的micro-usb数据线(有些商家可能会卖只能充电不能传输数据的线, 请注意甄别)

### 文件

- [watchthis-jailbreak-r03.zip](https://pan.baidu.com/s/1xWeZlDj4S6rrv7lxARBLjA?pwd=rfwm)越狱包
- [JailBreak-x.xx.N-FW-5.x-hotfix.zip](https://down.bookfere.com/s/e919Wt1zT0QNbkl)越狱环境固化包
- *[kual-mrinstaller-1.7.N-r18896.tar.xz](https://down.bookfere.com/s/87dWBnJuNRYWUps)插件管理器（可选）

所有文件来自于原链接。

## 越狱

### 进入演示模式

1. `重置`Kindle(注意是重置)
2. 等待重置后, 在语言选择界面选择`English(United Kingdom)`
3. 选择WIFI界面,点击`set up`, 然后点`X`关闭选择WIFI页面, 点击新出现的`set up later`
4. 搜索栏输入`;enter_demo`, 回车
5. `重启`设备(注意是重启, 与前面不同)

#### *秘密手势

此步骤只有在版本号小于等于 5.14.1 时需要, 5.14.2 版本并且重启后没有出现`Register This Demo`界面可直接跳过。

1. 进入`Register This Demo`界面后跳出WIFI设置, 点`X`跳过
2. 三项信息的表单中输入任意字符, 然后点`CONTINUE`继续
3. 点击`Skip`
4. 点击`standard`
5. 点击`Done`
6. 点一下屏幕激活
7. 使用`秘密手势`进入系统

![秘密手势示意图](https://bookfere.com/wp-content/uploads/2022/04/kindle-jailbreak-secret-gesture.gif)

> 1. 双指点击右下角  
> 2. 单指从右下角向左划（大概到中间偏左即可）  

有可能要多次尝试

### 侧载越狱文件

1. 搜索栏输入`;demo`进入演示菜单
2. 点击`Sideload Content`进入`Demo Mode: Add Content`菜单
3. 用USB线连接电脑

将`watchthis-jailbreak-r03.zip`文件解压, 其目录内有`Update_hotfix_watchthis_custom.bin`文件与一堆文件夹。

我的设备是Kindle Voyage, 进入KV文件夹。

我的版本号是5.13.6, 进入5.13.6文件夹, 其中有一个zip压缩包与一个demo.json文件。

1. 在Kindle根目录下, 创建一个名为`.demo`的文件夹（注意有个点）
1. 在`.demo`文件夹中, 放入zip与demo.json两个文件
2. 在`.demo`文件夹中, 创建一个名为`goodreads`的空文件夹

此时文件树为：

```sh
Kindle磁盘
└── .demo
    ├── [Kindle设备型号简称]-[固件版本号].zip
    ├── demo.json
    └── goodreads
        └──
```

1. 点击`Done`
2. 点击`Exit`(如果在点击`Exit`按钮后，出现`Application Error`提示，请按住电源按钮 40 秒硬重启设备，重启后会再次进入演示模式，在搜索框中输入命令 `;demo` 重新进入演示菜单`Demo Menu`，然后断开 Kindle 与电脑的 USB 数据线连接，再一次点击`Sideload Content` -> `Done`，最后点击`Exit`退出演示菜单)
3. 在搜索栏中输入`;dsts`进入设置，并依次点击`Help & User Guides` -> `Get Started`

此时设备会自动重启，重启过程中会看到启动界面上有文本提示越狱安装过程。

### 退出演示模式

重启完成后会进入演示模式（如果之前没有使用“秘密手势”进入演示模式，这一步也不需要，否则需要再次操作秘密手势进入演示模式）

1. 搜索栏输入`;demo`进入演示菜单
2. 点击`Sideload Content`进入`Demo Mode: Add Content`菜单
3. 用USB线连接电脑
4. 将`Update_hotfix_watchthis_custom.bin`文件直接放入根目录中
5. 点击`Done`
6. 电脑上弹出磁盘
7. 搜索栏输入`;dsts`进入设置, 点击`Device Options` -> `Update Your Kindle`，点OK

Kindle会自动重启，重启完成后会在正常模式。

### 安装越狱环境固化更新

1. 用USB线连接电脑
2. 将`Update_jailbreak_hotfix_x.xx.N_install.bin`文件放入根目录
3. 电脑上弹出磁盘
4. 进入设置, 点击`Device Options` -> `Update Your Kindle`，点OK
5. 等待重启

### *更新固件

越狱环境固化完成后，即可放心更新固件，越狱环境不会消失。

## *越狱插件

下载文件[kual-mrinstaller-1.7.N-r18896.zip](https://down.bookfere.com/s/87dWBnJuNRYWUps)并解压。

把文件夹内的 extensions 和 mrpackages 拷贝到 Kindle 的根目录。

其他插件请去原网站下载安装

