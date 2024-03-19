---
title: "git常用命令笔记"
auther: chenxi

description: git的一些常用命令，方便查询使用。
image: 
date: 2023-05-06T16:25:48+08:00

categories:
    - git
    - 笔记
tags:
    - git
    - 编程
    - github

math: false
comments: false
license: 
hidden: false

draft: false
---

## 常用git命令

### 仓库

```git
git init # 初始化仓库

git status # 仓库状态

git reset --hard <COMMIT_ID> # 回退到指定提交
# HEAD 当前提交；HEAD^ 上一个提交； HEAD^^ 上上个提交
# HEAD~100 上100个提交
# --hard 删除后续的提交
# --soft 保留后续的提交

git log # 仓库记录
git reflog # git操作记录
```

### 文件

```git
git add <FILE> # 将文件的改动添加到暂存区

git diff <FILE> # 比对文件与提交的区别

git commit -m "TYPE: CONTENT" # 提交暂存区的所有改动

git checkout -- <FILE> # 将文件的改动从暂存区撤回
git reset <COMMIT_ID> <FILE> # 将文件恢复至某次提交

git rm <FILE> # 删除文件
```

### 分支

```git
git branch <branch> # 创建分支
git switch <branch> # 切换分支
git switch -c <branch> # 创建并切换分支

git merge <other_branch> # 合并分支

git cherry-pick <COMMIT_ID> # 将某次提交重复提交到当前分支

git branch -d <branch> # 删除分支
git branch -D <branch> # 强制删除分支

git log --graph # 查看分支合并图
```

### 远程

```git
git remote add origin git@github.com:<ACCOUNT>/<REPO_NAME>.git
# 添加远程库

git remote -v # 显示远程库信息

git clone git@github.com:<ACCOUNT>/<REPO_NAME>.git # 克隆远程库

git push -u origin master # 推送到远程库并绑定本地库
git push origin master # 推送到远程库

git remote rm origin # 删除远程库
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
