---
title: "B站直播开播工具"
author: chenxi
description: 写了一个用于B站直播的开播工具
image: 

categories:
    - 软件
tags:
    - python
    - 开发
    - bilibili
    - 直播
series:
    - 开发

date: 2025-07-24T13:58:50+08:00
math: 
comments: false
license: 

hidden: true
draft: false
---

## B站直播开播工具

25年5月28日，B站直播仅允许5000粉以上用obs开播，其余只能用直播姬开播。

虽然直播姬可以用第三方推流模式，但开播要后台运行两个软件，很吃性能。对我这种有些软件精神洁癖的人也不友好。

在搜索时找到了一个油猴脚本，可以网页显示推流码，很好用。但由于不想每次开播都打开浏览器，所以准备找一个可以获取推流码进行开播的工具。

继续搜索的时候找到了[bilibili_live_stream_code](https://github.com/ChaceQC/bilibili_live_stream_code)这个项目。可以正常使用。

但该软件使用到了gui，作为终端婆罗门(bushi)，我很不喜欢，所以向自己写一个纯终端的软件。

搜索B站api可以找到[bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect/)这个项目。查看文档，是有相应api的，而且非常齐全，很多问题issues里也有。

从bilibili_live_stream_code克隆项目后，拆解了其中的代码，捋了一遍，看起来不是很难。

先从main入手，把
