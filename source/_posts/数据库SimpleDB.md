---
title: 简单数据库实现一
date: 2018-10-18 19:40:24
tags: database
copyright: true
categories: 数据库
---

# 前言



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

堆文件访问方法提供了一种**从磁盘中读取或写入以特定方式排列的数据的方法**。常见的访问方法包括堆文件（元组的未排序文件）和B树。对于此分配，您将仅实现堆文件访问方法，并且我们已为您编写了一些代码。

一个`HeapFile`对象被安排在一组页面中，每个页面由一个固定数量的字节组成，用于存储元组（由constant定义 `BufferPool.PAGE_SIZE`），包括一个标头。在SimpleDB中，`HeapFile`数据库中的每个表都有一个 对象。a中的每个页面`HeapFile`都按一组插槽安排，每个插槽可以容纳一个元组（SimpleDB中给定表的元组都具有相同的大小）。除这些插槽外，每个页面还有一个标头，该标头由一个位图组成，每个元组插槽一个位。如果对应于特定元组的位为1，则表示该元组有效。如果它为0，则该元组无效（例如，已被删除或从未初始化。）`HeapFile` 对象页面的类型`HeapPage`可实现 `Page`接口。页面存储在缓冲池中，但由`HeapFile`类读取和写入。

SimpleDB将堆文件以与存储在内存中相同的格式存储在磁盘上。每个文件由在磁盘上连续排列的页面数据组成。每个页面由一个或多个表示标题的字节组成，后跟`BufferPool.PAGE_SIZE - # header bytes `实际页面内容的字节。每个元组需要*元组大小* * 8位内容，1位元组。因此，可以在单个页面中容纳的元组数为：

$tupsPerPage = floor((BufferPool.PAGE_SIZE * 8) / (*tuple size* * 8 + 1))$

当*元组大小*是在字节的页面元组的大小。这里的想法是，每个元组在标头中都需要多存储一点。我们计算页面中的位数（乘以 `PAGE_SIZE`8），然后将此数量除以元组中的位数（包括该额外的标头位），以获得每页中的元组数。下层操作会舍入到最接近的整数元组（我们不想在页面上存储部分元组！）

一旦我们知道每页的元组数，存储标头所需的字节数就是：

$headerBytes = ceiling(tupsPerPage/8)$

上限操作会四舍五入到最接近的整数字节（我们永远不会存储少于完整字节的标题信息。）

每个字节的低（最低有效）位表示文件中较早的插槽的状态。因此，第一个字节的最低位表示页面中的第一个插槽是否正在使用。另外，请注意，最后一个字节的高位可能与文件中实际存在的插槽不对应，因为插槽数可能不是8的倍数。还要注意，所有Java虚拟机都是[big-endian](http://en.wikipedia.org/wiki/Endianness)。