---
title: C语言程序设计笔记
date: 2020-05-20 14:23:24
tags: [C]
copyright: true
categories: C语言
---

<!-- toc -->



## 数组

```c
#include <stdio.h>

int main(){
    int x;
    double sum = 0;
    int cnt = 0;
    int number[100];
    scanf("%d", &x);
    while(x != -1){
        number[cnt] = x;
        sum += x;
        cnt++;
        scanf("%d", &x);
    }
    if(cnt > 0){
        printf("%f\n", sum/cnt);
        int i;
        for( i=0 ; i<cnt ;)
    }
    return 0;
}
```



越界... 

### 集成初始化时的定位

```c
int a[13] = {[1]=2,3,[5]=6};
```



