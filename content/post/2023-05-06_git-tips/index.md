---
title: "git常用命令笔记"
auther: chenxi
description: git的一些常用命令，方便查询使用。
image: 

categories:
    - 开发
tags:
    - git
    - 编程
    - github
series:
    - 笔记

date: 2023-05-06T16:25:48+08:00
math: false
comments: false
license: 

hidden: false
draft: false
---

## 常用git命令

### 设置

```git
git config --global user.name "<USERNAME>" # 设置用户名
git config --global user.email "<EMAIL>" # 设置邮箱

git config --global http.proxy "<PROXY>" # 设置代理
git config --global https.proxy "<PROXY>" # 设置代理

git config --global init.defaultBranch <default-branch> # 设置默认分支名，建议为 master
```

### 基本流程

```git
# 克隆远程仓库到本地
git clone <URL> # 克隆远程仓库

# 创建本地仓库
git init # 初始化仓库
git remote add <remote-name> <remote-url> # 添加远程仓库
# 通常远程仓库名称可以叫 origin

git status # 仓库状态

# 修改仓库
git add <FILE> # 将文件的改动添加到暂存区
git commit -m "TYPE: CONTENT" # 提交暂存区的所有改动
# feat:   新功能
# fix:    修复问题
# docs:   文档更改
# update: 更新文件
# test:   测试修改


# 重新获取远程仓库
git fetch <remote-name> # 获取远程仓库的更新
git fetch <remote-name> <remote-branch> # 获取远程仓库的某一个分支更新
# 此时获取到的分支为 <remote-name>/<remote-branch>
git merge <remote-name>/<remote-branch> # 将该分支合并到主分支中
git rebase <remote-name>/<remote-branch> # 将该分支合并到主分支中

# 获取、推送
git pull <remote-name> <remote-branch>:<local-branch> # 将远程仓库的某个分支合并到本地分支中
git push <remote-name> <local-branch>:<remote-branch> # 将本地分支推送到远程仓库的某个分支中
```

### 常用命令

#### 仓库

```git
git init # 初始化仓库
git init -b <branch-name> # 初始化仓库，并设置默认分支名
git status # 仓库状态

git reset --soft <COMMIT_ID> # 回退到指定提交
# HEAD 当前提交；HEAD^ 上一个提交； HEAD^^ 上上个提交
# HEAD~100 上100个提交
# --soft 保留后续的提交
# --hard 删除后续的提交

git log # 仓库记录
git reflog # git操作记录
```

#### 远程

```git
git remote add <remote-name> <remote-url> # 添加远程仓库
git remote -v # 列出远程仓库
git remote show <remote-name> # 查看远程仓库信息
git remote rm <remote-name> # 删除远程库

git push <remote-name> <local-name> # 将本地推送到远程
git push -u <remote-name> <local-name> # 将本地推送到远程，并绑定本地
```

#### 文件

```git
git diff <FILE> # 比对文件与已提交的区别

git checkout -- <FILE> # 将文件的改动从暂存区撤回
git reset <COMMIT_ID> <FILE> # 将文件恢复至某次提交

git rm <FILE> # 删除文件
```

#### 分支

```git
git branch <branch> # 创建分支
git switch <branch> # 切换分支
git switch -c <branch> # 创建并切换分支
git checkout -b <branch> # 创建并切换分支，老方法

git merge <other_branch> # 合并分支

git cherry-pick <COMMIT_ID> # 将某次提交重复提交到当前分支

git branch -d <branch> # 删除分支
git branch -D <branch> # 强制删除分支

git log --graph # 查看分支合并图
```

### 暂存

```git
git stash # 将当前改动存到临时区

git stash list # 列出当前临时区内的列表

git stash apply stash@{x} # 恢复某个临时区内容
git stash drop # 删除某个临时区
git stash pop # 恢复并删除某个临时区
```

### 标签

```git
git tag <tag_name> <COMMIT_ID> # 为某次提交添加标签
git tag -a <tag_name> -m "tag info" <COMMIT_ID> # 为某次提交添加带说明的标签

git tag # 列出所有标签

git show <tag_name> # 显示标签信息

git push origin <tag_name> # 将某个标签推送到远程库
git push origin --tags # 将所有没被推送的标签推送到远程库

git tag -d <tag_name> # 删除本地标签
git push origin :refs/tags/<tag_name> # 删除远程库标签
```

### 整理提交

```git
git rebase -i HEAD~n # 交互式修改前n个提交
# 将其中的pick改为fixup可合并commit
# 其他可看提示信息
git rebase --edit-todo # 编辑rebase
git rebase --continue # 继续rebase
git rebase --skip # 跳过rebase的错误
git rebase --abort # 取消rebase，回退到之前的状态
```
