---
title: 简单数据库实现一
date: 2019-10-18 19:40:24
tags: database
copyright: true
categories: 数据库
---

# 目录

<!-- toc -->



[课程链接](https://sites.google.com/site/cs186fall2013)





## 作业一

### 1. SimpleDB体系结构

Consists of

- **包含字段、元组、元组架构的类**。Classes that represent fields, tuples, and tuple schemas;
- **将谓词和条件应用于元组的类**。Classes that apply predicates and conditions to tuples;
- **一种或多种访问方式**——将关系存储在磁盘上并提供一种遍历这些关系的元组的方法。One or more access methods (e.g., heap files) that store relations on disk and provide a way to iterate through tuples of those relations;
- **处理元组的运算符类(select, join, insert, delete)的集合**。
- **缓冲池**，用于在内存中缓存活动的元组和页面，并处理并发控制和事务。demo已经做好了
- **存储有关可用表及其模式的信息的目录**。A catalog that stores information about available tables and their schemas.



#### 1.1 Class: Database

Database类提供**对静态对象集合的访问**，这些静态对象是数据库的**全局对象**。特别是，这包括访问目录（数据库中所有表的列表），缓冲池（当前驻留在内存中的数据库文件页面的集合）和日志文件的方法。



#### 1.2 Field  Tuple

**实现非常基本**。包含一组 `Field`对象，每个字段一个`Tuple`。 

`Field`是不同数据类型 (integer, string...) 实现的接口。

`Tuple`对象是由基础访问方法(heap file, B-trees)创建的。

元组还具有一种由对象表示的类型（或架构），称为*元组描述符*`TupleDesc`。

该对象由对象的集合组成，`Type`元组中的每个字段一个，每个对象描述相应字段的类型。



#### 1.3 Class: Catalog

由**table lists**和**数据库中当前存在的表的schemas**组成。

**添加新表**以及**获取有关特定表的信息**的功能需要用到这个类。

与每个表相关联的是一个`TupleDesc`对象，该对象可以确定**表中字段的类型和数量**。

The global catalog是`Catalog`为整个SimpleDB进程分配的**单个实例**。 可用方法`Database.getCatalog()`。



#### 1.4 Class: BufferPool

负责在内存中**缓存最近被读页面**。

所有操作都通过缓冲池**从磁盘上的各种文件读取和写入页面**。

它由固定数量的页面组成，由构造函数的`numPages`参数定义 `BufferPool`。

`Database`类提供一个获取BufferPool的静态方法，其中 `Database.getBufferPool()`即返回到单个缓冲池实例的引用整个SimpleDB的过程。



#### 1.5 HeapFile access method

堆文件访问方法提供了一种**从磁盘中读取或写入以特定方式排列的数据的方法**。