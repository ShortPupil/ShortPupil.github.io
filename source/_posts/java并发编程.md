---
title: Java并发编程
copyright: true
date: 2020-03-01 13:19:06
tags: [java]
categories: java
---

<!-- toc -->

# 一、 概念

- 并发： 多个线程操作相同的资源，保证线程安全，合理使用资源

  同时拥有两个或者多个线程，如果程序在*单核处理器*上运行，多个线程将交替地换入或者换出内存，**这些线程是同时“存在”的**，**每个线程都处于执行过程中的某个状态**，如果运行在*多核处理器*上，此时，程序中的每个线程都将分配到一个处理器核上，因此可以同时运行

- 高并发：  服务能同时处理很多请求，提高程序性能

  高并发(High Concurrency)是互联网分布式系统架构设计中必须考虑的因素之一，它通常是指，通过设计保证系统能够同时并行处理很多请求。
  
- 高并发处理的思路和方法

  - 扩容：水平扩容、垂直扩容
  - 缓存：redis、memcache、guava、cache等
  - 队列：kafka、rabbitmq、rocketmq等队列特性
  - 应用拆分：服务化dubbo与微服务、Spring Cloud
  - 限流：guava ratelimiter的介绍与适用、常用限流算法、自实现分布式限流
  - 服务降级与服务熔断：服务降级的多种选择、hystrix
  - 数据库切库、分库、分表：
  - 高可用的一些手段：任务调度分布式elastic-job、主备curator的实现、监控报警机制等

- ◆总体架构：Spring Boot、.Maven、JDK8、MySQL
  ◆基础组件：Mybatis、Guava、Lombok、Redis、.Kafka
  ◆高级组件（类）：Joda-Time、Atomic包、J.U.C、AQS、ThreadLocal、RateLimiter、Hystrix、threadPool、shardbatis、curator、elastic-job.…

# 二、并发编程的基础

## 1. CPU多级缓存

### 1.1 CPU cache

- 问：为什么需要CPU cache:

  CPU的频率太快了，快到主存跟不上，这样在处理器时钟周期内，CPU常常需要等待主存，浪费资源。所以cache的出现，是为了缓解CPU和内存之间速度的不匹配问题(结构：**cpu->cache->memory**).

- 问：CPU cache有什么意义：

  1)时间局部性：如果某个数据被访问，那么在不久的将来它很可能被再次访问
  2)空间局部性：如果某个数据被访问，那么与它相邻的数据很快也可能被访问；

### 1.2 缓存一致性(MESI)

可见 [缓存一致性协议-阿里云开发者社区 (aliyun.com)](https://developer.aliyun.com/article/46661)

- 用于保证多个CPU cache之间缓存共享数据的一致
- 四种 数据状态（MESI)、四种 转换状态操作
  - M: Modify，修改缓存，当前CPU的缓存已经被修改了，即与内存中数据已经不一致了
  - E: Exclusive，独占缓存，当前CPU的缓存和内存中数据保持一致，而且其他处理器并没有可使用的缓存数据
  - S: Share，共享缓存，和内存保持一致的一份拷贝，多组缓存可以同时拥有针对同一内存地址的共享缓存段
  - I: Invalid，实效缓存，这个说明CPU中的缓存已经不能使用了

### 1.3 乱序执行优化

处理器为提高运算速度而做出**违背代码原有顺序的优化**。

``` java
// 源代码
a = 10;
b = 200;
result = a*b;
// 优化可能
a = 10; b = 200; result = a*b;
b = 200; a = 10; result = a*b;
```

## 2. JAVA内存模型 (Java Memory Mode, JMM)

可参考[JVM学习 | 毫末室 (songzi2693.cn)](https://songzi2693.cn/2020/12/08/JVM学习/)

**需要重新学习**



## 3. 并发的优势和风险

优势：

1. 速度：同时处理多个请求，响应更快：复杂的操作可以分成多个进程同时进行
2. 设计：程序设计在某些情况下复简单，也可以有更多的选择
3. 资源利用：CPU能够在等待IO的时候做一些其他的事情

风险

1. 安全性：多个线程共享数据时可能会产生于**期望不相符**的结果
2. 活跃性：某个操作无法继续进行下去时，就会发生活跃性问题。比如**死锁、饥饿**等问题
3. 性能：线程过多时会使得：**CPU频繁切换，调度时间增多；同步机制：消耗过多内存**




## Disruptor核心原理与源码

LMAX架构：很低的延迟产生大量交易；建立在JVM上，核心是业务逻辑处理器

- 一个线程里每秒处理六百万订单
- 业务逻辑处理器完全是运行在内存中，使用**事件源驱动**方式
- 业务逻辑处理器的核心是disruptor

disruptor创建步骤

- 建立一个工厂Event类，用于创建Event类实例对象
- 需要有一个监听事件类，用于处理数据（Event类）
- 实例化Disruptor实例，配置一系列参数，编写Disruptor核心组件
- 编写生产者组件，向Disruptor容器中投递数据（最复杂）



### RingBuffer

生产者生产产品放到容器里面，消费者监听然后获取event数据

![ringbuffer](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/ringbuffer.PNG)

- 环形结构（首尾相连）
- 用作在不用上下文（线程）间传递数据的buffer
- RingBuffer拥有一个**序号sequence**，这个序号指向数组中**下一个可用元素**，或者说空的元素



生产者扔芝麻、消费者捡芝麻需要考虑速度问题

- 随着不停地填充这个buffer（可能也会有相应的读取），这个序号会一直增长，直到绕过这个环













