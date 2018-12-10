---
title: shell一些小坑
date: 2018-10-24 23:46:19
tags: [linux, shell]
copyright: true
categories: linux
---

## 条件判断

- 按着书上的输入都出了问题 if [] then  这些中间都要加空格

```shell
if [ 判断式 ]; then
else 
fi 
```

- `||`和`&&`要用两个独立的`[]`,如下

- 如果a>b且a<c 

  ```shell
  if [[ $a > $b ]] && [[ $a < $c ]] 
  
  if [ $a -gt $b -a $a -lt $c ]     
  ```

- 如果a>b或a<c

  ```shell
  if [[ $a > $b ]] || [[ $a < $c ]] 
  
  if [ $a -gt $b -o $a -lt $c ] 
  ```

- 别忘了**-o = or , -a = and**






后续慢慢加