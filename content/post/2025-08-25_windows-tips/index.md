---
title: "Win系统使用技巧"
author: chenxi
description: 收集使用过的值得记录的一些技巧或笔记
image: 

categories:
    - 笔记
tags:
    - Windows
    - 笔记
series:
    - 笔记

date: 2025-08-25T10:18:46+08:00
math: 
comments: false
license: 

hidden: false
draft: false
---

## 原生系统

### 添加webdav网络位置

1. 允许http协议的webdav
  1. HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters
  2. BasicAuthLevel把这个值从1改为2
  3. 重启或开启WebClient服务
2. 修改文件复制上限
  1. HKLM\SYSTEM\CurrentControlSet\Services\WebClient\Parameters
  2. FileSizeLimitInBytes改为ffffffff(4G左右)
3. 添加webdav位置
  1. 此电脑右键，添加一个网络位置
  2. 下一步，输入url，确认

## 第三方软件

### windhawk

修改win11的系统

1. temp1
  - 修改任务栏
2. temp2
  - 修改开始菜单
3. temp3
  - 文件管理器显示文件夹总大小
4. temp4
5. temp5
