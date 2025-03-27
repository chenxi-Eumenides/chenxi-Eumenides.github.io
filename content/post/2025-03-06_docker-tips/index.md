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

## docker 基本概念

### docker 文件

```bash
Dockerfile # docker编译文件
docker-compose.yml # compose文件
```

### docker 概念

```md
            build
 Dockerfile  -> docker-image
            pull
  internet   -> docker-image
            run
docker-image -> container
            start
 container   -> running-container
```

### docker 命令

```bash
docker build <url> # 将指定路径的dockerfile编译为docker镜像
# -t 指定docker镜像名称

docker run <docker-image> # 启动docker镜像
# --name <container-name> # 指定容器名称，没有将自动命名
# -p <local-port>:<docker-port> # 指定监听端口
# -v <local-dir>:<docker-dir> # 挂载卷
# -idt </bin/bash> # 指定后台运行终端，可以attach，或exec

docker run --name <container-name> -p <local-port>:<docker-port> -v <local-dir>:<docker-dir> -idt <docker-image> /bin/bash
# 运行一个docker的终端

docker start <container-name> # 启动一个容器
# -i 进入交互终端
docker stop <container-name> # 停止一个容器
docker rm <container-name> # 删除一个容器
docker exec <runing-container-name> <command> # 在一个已启动的容器内执行一条命令
docker exec -it <running-container-name> /bin/bash # 新开一个终端并进入
```

### Dockerfile

```Dockerfile
FROM <name>:<version> # 选择一个基本镜像

WORKDIR <url> # 工作目录

COPY <local-dir> <docker-dir> # 从本地环境中复制文件
ADD <local-tar> <docker-dir> # 从本地环境中复制tar文件，并自动解压到指定目录

ENV key=value # 设定环境变量
ARG key=value # 设定仅Dockerfile中可用的环境变量
LABEL key=value # 设定元数据，如作者等

VOLUME <local-url> # 挂载匿名数据卷
VOLUME ["local-url-1", "local-url-2",...]
EXPOSE <port> # 声明要用的端口
USER <user>[:<group>] # 后续命令的执行用户

RUN command arg1 arg2 ... # 创建docker容器时运行的命令
# 可以有多个RUN

CMD ["command", "arg1", "arg2", ...] # 运行docker容器后运行的命令
# 只有最后一个cmd起作用
# 会被docker命令行参数覆盖，如 docker -it <docker> /bin/bash


```

### docker-compose
