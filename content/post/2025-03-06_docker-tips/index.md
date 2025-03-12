---
title: "Docker的用法，与创建一个开发环境"
author: chenxi
description: 记录了docker的一些用法，并使用docker创建一个干净的开发环境，避免污染本地环境。
image: 

categories:
    - 开发
tags:
    - docker
    - linux
    - 笔记
    - 开发
series:
    - 笔记

date: 2025-03-06T15:50:19+08:00
math: 
license: 
comments: false

hidden: false
draft: false
---

## 文件结构

```bash
Dockerfile # docker编译文件
docker-com
```

### docker command

```bash
docker build <url> # 将指定路径的dockerfile编译为docker镜像
# -t 指定docker镜像名称

docker run <docker-image> # 启动docker镜像
# --name <docker-name> # 指定容器名称，没有将自动命名
# -p <local-port>:<docker-port> # 指定监听端口
```

### Dockerfile

```Dockerfile
FROM <name>:<version> # 选择一个基本镜像

WORKDIR <url> # 工作目录

COPY <local-dir> <docker-dir> # 从本地环境中复制文件

RUN command arg1 arg2 ... # 创建docker容器时运行的命令
# 可以有多个RUN

CMD ["command", "arg1", "arg2", ...] # 运行docker容器后运行的命令
# 只有最后一个cmd起作用
# 会被docker命令行参数覆盖，如 docker -it <docker> /bin/bash
```

### docker-compose
