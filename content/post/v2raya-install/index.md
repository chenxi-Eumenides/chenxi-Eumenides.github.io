---
title: v2raya安装
auther: chenxi

description: "linux上安装v2raya"
image: 
date: 2023-01-29T04:55:52+08:00

categories:
    - 笔记
    - 软件
tags:
    - 网络
    - 安装
    - v2ray
    - v2raya
    - 梯子
    - 配置

math: false
comments: false
license: 
hidden: true

draft: false
---

# v2raya安装及配置

本文内容大多来自官网：[v2rayA用户文档](https://v2raya.org/docs/prologue/quick-start/)，有问题请查询官网。

## 安装

我用的系统为manjaro，包管理器为pacman（yay）。\
使用pacman直接安装v2ray与v2raya即可。\
v2raya官方库中没有，要用yay。

```bash
yay -Sy v2ray v2raya
```

## 启动

通过systemctl启动服务，只需v2raya即可，v2ray不用启动

```bash
systemctl start v2raya
```

可以配置开机自启

```bash
systemctl enable v2raya
```

此时即可访问[web服务](http://127.0.0.1:2017)，端口为2017。

注册一个账号（自己记住即可）。

## 导入

我有订阅链接，所以选择导入即可。

填入订阅链接，点击更新。

在第三页中能看到导入的。

## 设置

设置页面在右上角，若页面宽度不够，会被隐藏在三个横杠里。

### gfwlist

设置页面中，第一行是gfwlist,更新一次。

若无需求，之后可以不用管了

若无法更新，请完成整个设置，启动服务后再试一次（即挂梯子更新）。

### 代理

以下为选项的内容

`透明代理/系统代理`：请选择`分流规则与规则端口所选模式一致`。

`透明代理/系统代理实现方式`：我不知道有什么区别，\
但有的系统不支持`tproxy`以外的其他方式，请自行尝试。

`规则端口的分流模式`：若不想折腾，选择`大陆白名单`或者`gfwlist`都行\
若想自定义，选择`RoutingA`，配置说明见下方。

其他可以自行查看`?`显示的提示。

### RoutingA

基础的规则见下

```bash
# 默认
default: direct
ip(geoip:private) -> direct

# 国外域名即使有中国IP也要优先代理
domain(geosite:cn)->direct
domain(geosite:geolocation-!cn)->proxy
domain(geosite:category-ads-all)->block
```

自定义规则自行添加。

基本格式为：`A`(`B`:`C`)->`D`

- `A`: domain -> 域名 / ip -> ip

- `B`: geoip -> ip集合 / geosite -> 域名集合 / geomain -> 单个域名

- `C`: 集合名称或域名

- `D`: direct -> 直连 / proxy -> 代理 / block -> 阻拦

示例：

```
domain(geomain:test.com)->proxy
```

## 运行

点击节点的`选择`按钮，选择需要启用的节点。

点左上角的`就绪`。

若按钮变为`正在运行`，则成功进行代理。
