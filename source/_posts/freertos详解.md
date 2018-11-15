---
title: FreeRTOS详解
date: 2018-10-18 18:47:24
tags: Embedded System
copyright: true
---

# 目录

@[toc]



## 1. 关于RTOS（实时应用程序）

对于大多数操作系统来说，支持多任务是一个最基本的特性。

一个RTOS的多任务特性

- 多任务并发运行
- 调度器决定哪个任务运行
- 调度器可以抢占某个正在运行任务的资源
- 支持任务间的通信



## 2. FreeRTOS 介绍

### 2.1 FreeRTOS内核文件结构

![](https://raw.githubusercontent.com/ShortPupil/ShortPupil.github.io/hexo/source/_posts/pictures/freertos_1.png)



### 2.2 FreeRTOS多任务管理机制

FreeRTOS允许**在同一时刻处理多个任务**，但**只能有一个任务运行（单核）**。因此，系统需要一个调度器将时间片分配给各个任务。**调度器是FreeRTOS内核的核心**，它依据分配给**任务的优先级和它的状态**来选择要运行的任务。

![任务状态的转换和任务的调度](https://raw.githubusercontent.com/ShortPupil/ShortPupil.github.io/hexo/source/_posts/pictures/freertos_2.png)

- 总状态
  - 运行态
  - 非运行态
    - Suspend：任务被应用程序挂起（deactivated）
    - Blocked：为获得同步事件任务被阻塞
    - Ready：任务准备运行，但有更高级别的任务正在运行。

任务调度的时候，瞄准那些**“ready”状态的任务**并决定**哪些任务可以被执行**。FreeRTOS根据任务被创建时分配的优先级来决定。**任务的优先级**是调度器判断和执行调度时考虑的唯一要素。

内核代码（调度器）负责在两个任务之间协调时间片的分配。当第一个任务（Task1）从运行状态变到非运行状态的时候，例如，程序运行结束，主程序main（）调用Return，系统的都会自动调用调度器代码，调度器会按照调度算法从所有当前是“ready”的任务中选择一个运行。**调度器的运行时间都很短，相对于Task的运行时间可以忽略不计。**

![内核和任务之间的调度关系](https://raw.githubusercontent.com/ShortPupil/ShortPupil.github.io/hexo/source/_posts/pictures/freertos_3.png)



### 2.3  FreeRTOS的内存管理

FreeRTOS**没有设置Task数量的上限**，只要配套的硬件和内存可以支持如此众多的任务。FreeRTOS作为一个实时的操作系统，可以支持**周期性和非周期性的任务**。

系统的内核在每创建一个任务或者一个内核对象的时候分配一块内存空间，这块被分配给任务或者对象的空间叫做“栈”。栈的大小可以在创建任务的时候配置。每个栈都包含“Task  File”和“Task Control  Board（TCB）”，它们被内核用来处理任务。所有的Stack被存储在被称之为“堆”（HEAP）的结构里。**堆管理器是依据Heap_x.c这个内核文件的内容来完成的，到底选择哪一个Heap_x.c是由需求决定的。**

- Heap_1.c：最简单的实现，并且在分配完内存以后，不能释放。

- Heap_2.c：使用了“最佳适应”算法，允许之前分配的内存被回收。
- Heap_3.c：封装了标准的C函数malloc()和free()，在大多数情况下，可以被选用的C编译器支持。封装使得malloc和free函数的使用是线程安全的。
- Heap_4.c: 使用了“第一适应”算法，和heap_2.c不同的是，它可以将临皆被释放的内存融合成一个大的内存块。

除了Heap_3.c以外的所有模型都可以**通过“configTOTAL_HEAP_SIZE”来配置**，而Heap_3.c的堆大小配置则是通过链接器脚本来完成的。



## Arduino上的Freertos多任务使用例子

```c++

```





[参考博客](https://blog.csdn.net/isscollege/article/details/78404706?locationNum=9&fps=1)