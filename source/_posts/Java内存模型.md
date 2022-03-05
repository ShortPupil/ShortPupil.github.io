---
title: Java并发编程实战 第16章 Java内存模型
date: 2020-02-18 11:48:24
tags: [java]
copyright: false
categories: java
---

## 1. 为什么需要内存模型

Java语言规范要求JVM在线程中维护一种类似**串行**的语义：只要程序的最终结果与在严格串行环境中执行的结果相同，则上述操作都是允许的。

多线程环境中，维护程序的串行性会导致很大的**性能开销**。只有当多个线程要共享数据时，才必须协调它们之间的操作，并且JVM依赖程序通过同步操作来找到这些协调操作将在何处发生。

### 1.1 平台的内存模型

不同处理器拥有自己的缓存，并且定期和主内存进行协调。

不同级别的缓存一致性（Cache Coherence）

为了使java开发人员无需关心不同架构上内存模型之间的差异，java还**提供了自己的内存模型**，并且**JVM通过在适当的位置上插入内存栅栏**来屏蔽在JMM与底层平台内存模型之间的差异。

程序执行一种简单假设：想象在程序中只存在唯一的操作执行顺序，而不考虑这些操作在何种处理器上执行，并且每次读取变量时，都能获得**在执行序列中最近一次写入该变量的值**。——串行一致性，但现代多处理器架构中不提供

跨线程共享数据时，出现的问题，需要通过使用**内存栅栏**来防止。而Java程序不需要指定内存栅栏的位置，只需通过**正确地使用同步来找出何时将访问共享状态**。

### 1.2 重排序

如果在程序中没有包含足够的同步，可能产生起卦的结果，错误实例——可能由重排序导致的交替执行方式

```java
public class PossibleRecording{
    static int x=0, y=0;
    static int a=0, b=0;
    public static void main(String [] args) throws InterruptedException{
        Thread one new Thread(new Runnable() {
           public void run(){
               a = 1;
               x = b;
           } 
        });
        Thread other new Thread(new Runnable() {
           public void run(){
               b = 1;
               y = a;
           } 
        });
        one.start(); other.start();
        one.join(); other.join();
        System.out.println(x + "," + y);
    }
}
```

可能发成内存级的重排序。

### 1.3 Java内存模型简介

JMM为程序中所有操作定义了一个偏序关系，称为**Happens-Before**

- **程序顺序规则**：如果**程序中**操作A在操作B之前，那么在**线程中**A将在B之前执行
- **监视器锁规则**：在监视器锁上的解锁操作必须在同一监视器锁上的加锁操作之前执行
- **volatile变量规则**：对volatile变量的写入操作必须在对该变量的读操作之前执行
- **线程启动规则**：在线程上对Thread.Start的调用必须在该线程中执行任何操作之前执行
- **线程结束规则**：线程中的任何操作都必须在其他线程检测到该线程已经结束之前执行。
- **中断规则**：当一个线程在另一个线程上调用interrupt时，必须在被中断线程检测到interrupt调用之前执行
- **终结器规则**：对象的构造函数必须在启动该对象的终结期之前执行完成
- **传递性**：如果A在B之前执行，并且B在C之前执行，则A必须在C之前执行

![](https://gitee.com/songzi2625/resources/raw/master/image/Happens-Before.png)

### 1.4 借助同步