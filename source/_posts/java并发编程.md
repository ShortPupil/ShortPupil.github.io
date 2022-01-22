---
title: Java并发编程
copyright: true
date: 2020-03-01 13:19:06
tags: [java]
categories: java
---

<!-- toc -->



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





### Sequence、Sequence Barrier



### WaitStrategy等待策略



### Event、EventProcess策略



### EventHandler消费者处理器



### WorkProcessor核心处理器













