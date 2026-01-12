---
title: "python使用方法记录"
author: chenxi
description: 记录一些常用的，有用的写法和代码
image: 

categories:
    - python
tags:
    - python
    - tips
    - 代码
    - 记录
series:
    - 

date: 2026-01-12T15:13:37+08:00
math: 
comments: false
license: 

hidden: false
draft: false
---

## 记录一些用到、写过的代码

### 循环或堵塞操作的多线程控制结束

```python
# 循环或堵塞操作
def _target_func(stop_event)
    while not stop_event.is_set():
        # do some thing
        if stop_event.wait(timeout=1): # 替代sleep
            break
    return

# 设置多线程
stop_event = threading.Event()
target_thread = threading.Thread(
    target = _target_func
    args = (
        stop_event,
    )
)
target_thread.start()

# 通过另一个线程检测是否要停止
check_thread.start()
while target_thread.is_alive():
    target_thread.join(timeout=0.1) # 防止无法获取报错
check_thread.join()

# 或者在主线程中检测是否要停止
while target_thread.is_alive():
    if CHECK_NEED_STOP:
        stop_event.set()
        break

# do other thing
```


