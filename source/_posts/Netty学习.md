---
title: netty学习
date: 2021-05-18 12:12:24
tags: [netty]
categories: netty
copyright: true
---

<!-- toc -->

# 概述

## 了解Netty

- 目前最流行的一款**高性能 java 网络编程框架**，被广泛使用在中间件、直播、社交、游戏等领域
- 将Netty作为底层框架的框架：Dubbo、RocketMQ、Elasticsearch、Hbase等
- 1. netty高性能表现在哪些方便？有何启发？
  2. 有哪些重要组件？及其联系？
  3. 内存池、对象池如何设计的？
  4. 有哪些印象比较深刻的系统调优案例？
  5. ......
- Netty的设计原理
  - 对理解I/O模型、内存管理、线程模型、数据结构有帮助
  - 对学习RocketMQ、Nginx、Redis等优秀框架有帮助
  - Netty的易用性和可靠性极大降低了心智负担
- Netty对java NIO进行高级封装，简化了网络应用的开发过程
- 对于**拆包/黏包、数据编解码、TCP断线重连**等问题，Netty提供了现成的解决方案，其可靠性和健壮性很强

学习源码之前，首先要让自己成为一个**熟练工**，掌握基本理论

## 一些问题

- 为什么使用Netty
  - I/O模型、线程模型、事件处理机制
  - 易用性API接口
  - 对数据协议、序列化的支持

- 高性能、低延迟

I/O模型基础知识：

- I/O请求

  - I/O调用阶段：用户进程向内核发起系统调用
  - I/O执行阶段：内核等待I/O请求处理完成返回

- ![](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/netty_learning/1.PNG)

- Linux的五种IO模式

  1. 同步阻塞I/O (BIO)

     ![](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/netty_learning/2.PNG)

  2. 同步非阻塞I/O (NIO)

     ![](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/netty_learning/3.PNG)

  3. I/O多路复用

     ![](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/netty_learning/4.PNG)

  4. 信号驱动I/O

     ![](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/netty_learning/5.PNG)3

  5. 异步I/O

     ![](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/netty_learning/6.PNG)

- Netty如何实现自己的I/O模型

  - 基于非阻塞IO实现
  - 底层依赖于JDK NIO框架的多路复用器Selector
  - 一个多路复用器Slector可以同时轮询多个Channel
  - 事件分发器 Event Dispather
    - 负责将读写事件分发给对应的读写事件处理器 Event Handler