---
title: "hugo安装、配置与常用命令"
description: "hugo轻量级博客的安装，配置及一些使用方法。"
auther: chenxi
date: "2023-04-03T19:03:56+08:00"
lastmod: 
categories:
    - 博客
    - 笔记
tags:
    - hugo
    - 博客
    - 教程
    - 笔记
    - 配置
series:
    - 笔记
license: 
image: 
math: 
hidden: false
comments: false
draft: false
---

## 前言

本文都是从网上找来的，我也是从零开始使用的，不建议完全相信，当你可以试试嘛，对吧。

## 介绍

hugo是一个轻量级的使用markdown语法的静态博客网站。我因为不想用nodejs之类的部署，所以没有选用hexo等其他的博客，选择了这个用go写的。我不确定哪个性能好，反正随便用嘛。

## 安装

没写呢，有空再写吧，反正网上有教程。
```bash
...
```

## 文件树

```bash
.
├── archetypes   # 类别，自动生成的不用管（应该
├── assets       # 静态资源，和下面那个不知道有啥区别
├── config.yaml  # 配置文件
├── content      # 内容，默认内容复制自主题的模板，因为我自己弄死活不能正常显示。
│   ├── categories # 归档，自动生成的不用管（应该，大概率不对
│   ├── _index.md  # 不用管
│   ├── page       # 页面，里面每个文件夹都是左侧的选项
│   │   ├── about    # 关于页面
│   │   ├── archives # 归档页面
│   │   ├── links    # 链接页面
│   │   └── search   # 搜索页面
│   └── post       # 主页
├── data         # 不知道
├── layouts      # 不知道
├── public       # 发布文件夹，里面就是静态文件，可以部署到其他网站
├── resources    # 不知道
├── static       # 静态资源，和上面那个不知道有啥区别
└── themes       # 主题文件夹
```

## hugo命令

### build

生成的静态文件在public文件夹下

```bash
hugo
```

### 启动测试服务器

```bash
hugo server -b http://访问地址:端口/ --bind 监听地址
```

访问地址我设置的自己的局域网ip。

监听地址设置的0.0.0.0，这样可以通过其他设备访问。

### 新建文件

```bash
hugo new post/Markdown文件名/index.md
```

## 配置

配置文件为

```bash
/config.yaml
或
/config.toml
```

### 配置文件内容

我使用的是yaml。
```yaml
# 全局配置
baseurl: http://0.0.0.0:1313   # 绑定的url，测试服务器会无视该项。
theme: hugo-theme-stack        # 主题，要在themes文件夹中
paginate: 10                   # 主页显示的文章数量
title: xxxx                    # 默认标题栏

# 语言配置
DefaultContentLanguage: zh-cn  # 默认语言
languageCode: zh-cn            # 不知道有啥用
hasCJKLanguage: true           # 启用CJK，有中日韩语的要打开。
languages:                     # 若只有一个语言，就不显示切换语言的按钮。
    zh-cn:                     # 启用的语言
        languageName: 中文     # 语言名字，显示在切换语言中
        title: xxx             # 标题
        description: xxx       # 描述
        weight: 1              # 语言的显示顺序
#    en:                       # 英文我没开，我用不到，切换按钮还比较丑
#        languageName: English # 同上
#        title: xxx
#        description: xxx
#        weight: 2

# 外观配置
params:
    mainSections:              # 主页显示哪个
        - post
    featuredImageField: image
    rssFullContent: true
    favicon: /favicon.ico      # 网站图标，位于 /static/favicon.ico

    footer:                    # 脚标，每个页面的最下方都有这个。
        since: 2023
        customText: XXX

    dateFormat:                # 时间相关，不要更改。
        published: Jan 02, 2006
        lastUpdated: Jan 02, 2006 15:04 MST

    sidebar:                   # 左侧边栏
        emoji: 🌞              # 头像右下角的emoji
        subtitle: XXX          # 头像下方的描述
        avatar:                # 头像
            enabled: true
            local: true
            src: img/xxx.jpg   # 位于 /assets/img/xxx.jpg
```
直接在theme的example里复制config文件是最好的。

## 编辑

文件路径（默认页面）：
```bash
./content/post/Markdown文件名/index.md
```
中文页面
```bash
./content/post/Markdown文件名/index.zh-cn.md
```

图片等路径：
```bash
./content/post/Markdown文件名/文件名
```

### 文件头

```markdown
---
title: "标题"
description: "描述"
auther: "作者" # 貌似不显示
date: "年-月-日T时:分:秒+08:00"
categories:
    - 分类
tags:
    - 标签
series:
    - 系列
license: 开源协议
image: 头图 # 放在同一个文件夹内，就直接写文件名
math: 数学公式 # 好像没啥用
hidden: false # 是否隐藏
comments: false # 是否开启评论，这个配置文件里开了才有用。
draft: false # 是否是草稿
---
```

放在文件开头。

***默认文件模板***
```bash
/archetypes/default.md
```

### markdown语法

#### 标题

```markdown
# H1 (太大了，可以跳过不用捏)
## H2
### H3
#### H4
```

#### 换行

行1  
行2  

```markdown
文本  
后面跟两个空格
```

#### 强调

**粗体**
```md
**粗体**
```

*斜体*
```md
*斜体*
```

***粗体和斜体***
```md
***粗体和斜体***
```

`重点标注`
```markdown
`文本`
```

#### \*删除线

~~删除线~~
```md
~~删除线~~
```

#### 引用

> content  # 后面要有两个空格  
> content  
> ...  
```markdown
> content  # 后面要有两个空格
> content  
> ...  
```

嵌套引用


#### 图片

![图片说明1](pic-1.jpg) ![图片说明2](pic-2.jpg)
![图片说明3](pic-3.jpg) ![图片说明4](pic-4.jpg)

![图片说明1](avatar-1.jpg) ![图片说明2](avatar-2.jpg)
```markdown
![图片说明1](图片路径，放在md文件的同级文件夹中最好)
![图片说明2](图片路径) # 不空行则图片在同一行，空一行则图片另起一行

![图片说明3](图片路径)
```

#### 链接

[链接](http://blog.chenxi-eumenides.top:81/ "悬浮文字")
```markdown
[链接内容](链接 "悬浮文字")
```

引用类型链接  
能使文本更紧凑，把较长的链接放在统一的不相关的地方，如段落后或者文章结尾。

一行[文本][1]字符

[1]: http://blog.chenxi-eumenides.top:81/> "出处"

```md
第一部分
[文本][label]
第二部分，放在哪都行
[label]: http://blog.chenxi-eumenides.top:81/> "出处"
```

#### 网址和邮箱

<chenxi@test.com>  
<http://blog.chenxi-eumenides.top:81/>
```md
<chenxi@test.com>
<http://blog.chenxi-eumenides.top:81/>
```

#### 上下分隔线

---
```markdown
***
或者
---
```

#### 列表

有序列表

1. one
2. two
```md
1. one
2. two
```

无序列表

- one
- two
```md
- one
- two
```

嵌套则增加4个空格/制表符

#### \*定义列表

术语
: 描述1
: 描述2

```md
术语
: 描述1
: 描述2
```

#### \*任务列表

- [x] 勾选
- [ ] 没勾选

```md
- [x] 勾选
- [ ] 没勾选
```


#### \*围栏代码块

```md
这段文字就是在围栏代码块中。
```

#### \*表格

| Tables   |      Are      |  Cool |
|----------|:-------------:|------:|
| col 1 is |  left-aligned | $1600 |
| col 2 is |    centered   |   $12 |
| col 3 is | right-aligned |    $1 |

```markdown
| Tables   |      Are      |  Cool |
|----------|:-------------:|------:| # - 三个及三个以上
| col 1 is |  left-aligned | $1600 |
| col 2 is |    centered   |   $12 |
| col 3 is | right-aligned |    $1 |
```

两边冒号为居中  
右边冒号为居右  
左边冒号为居左  

#### 转义

\*不斜体\*

```md
\*不斜体\*
```

#### \*脚注

一行文字[^abc]。前方有文本就会变成上标。
[^abc]: 脚注内容，自动放置在文章末尾

```md
[^label]label是什么不会影响显示的数字，只是用来标记。
[^label]: 脚注内容
```








