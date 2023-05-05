---
title: "Linux的一些tips"
description: 在Linux下遇到各种问题的解决方式与过程记录。
image: 
auther: chenxi
date: 2023-05-06T00:34:45+08:00
categories:
    - Tips
    - 笔记
tags:
    - linux
    - tips
    - 笔记
math: 
comments: false
license: 
hidden: false
draft: false
---

## linux同步时间
```bash
// 系统时间信息
timedatectl status

// 同步ntp时间
timedatectl set-ntp true
```
