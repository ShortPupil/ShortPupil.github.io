---
title: python翻转字符串
tags:
  - python
categories: python
copyright: true
abbrlink: 49164d1a
date: 2018-11-18 01:12:24
---

将s = “abcd” 反转为 “dcba”



#### 第一种 字符串切片

```python
result = s[::-1]
```



#### 第二种 列表的reverse方法

```python
l = list(s)
result = "".join(l.reverse())
```



#### 第三种 for循环

```python
def func(s):
    result = ""
    max_index = len(s)-1
    for index,value in enumerate(s):
        result += s[max_index-index]
    return result
result = func(s)
```



#### 第四种 栈

```python
def func(s):
    l = list(s) #全部入栈
    result = ""
    while len(l)>0:
        result += l.pop() #出栈
    return result
result = func(s)
```



#### 第五种 递归

```python
def func(s):
    if len(s) <1:
        return s
    return func(s[1:])+s[0]
result = func(s)
```



#### 第六种 reduce方法

```python
result = reduce(lambda x,y:y+x,s)
```



