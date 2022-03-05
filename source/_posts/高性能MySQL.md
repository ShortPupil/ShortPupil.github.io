---
title: Mysql基准测试工具使用记录
copyright: true
date: 2019-06-11 10:30:20
tags: [mysql]
categories: 数据库
---

<!-- toc -->

# 概述

1. 主流数据库分类：关系型数据库、NoSQL、NewSQL

2. MySQL主流分支：MySQL、Percona Server、MariaDB

3. MySQL优点：
   - 体积小、速度快
     开源免费，工具生态完善
     简单易用，维护成本低
     兼容性好，支持多种操作系统
     提供多种API接口
     支持多种开发语言
     社区及用户活跃
     支持事务、MVCC、易扩展、集群、高可用
   
4. MySQL经常遇到的坑：
   - flush-Logs导致hang住无法写入数据
     忘记密码
     cache-full
     延迟
     2013
     1064
     死锁
     主键冲突
     掉电
     字符集错误
     删库跑路
     脑裂
     慢查询
     断网
     Query-Cache
     metadata-lock
     没备份
     ulimit-u导致创建链接失败
     表数据碎片
     大小写敏感
   
5. 内容丰富：

   - 系统
     网络
     硬件
     原理
     部署
     优化
     **InnoDB**
     复制
     备份/还原
     监控
     架构设计
     容量规划
     技术生态
     编程
     高可用

6. 书籍：

   《MySQL官方手册》
   《MySQL运维内参》
   《MySQL8 Cookbook（中文版）》
   《MySQL技术内幕InnoDB存储引擎》
   《高性能MySQL》
   《数据库索引设计与优化》
   《MySQL内核InnoDB存储引擎》
   《深入理解MySQL核心技术》
   《Effective MySQL Replication Techniques in Depth》

问题：

事务的四大特性？ 

数据库的三大范式 

事务隔离级别有哪些？ 

索引  

- 什么是索引？ 
- 索引的优缺点？ 
- 索引的作用？ 
- 什么情况下需要建索引？ 
- 什么情况下不建索引？ 
- 索引的数据结构 
- Hash索引和B+树索引的区别？ 
- 为什么B+树比B树更适合实现数据库索引？ 
- 索引有什么分类？ 
- 什么是最左匹配原则？ 
- 什么是聚集索引？ 
- 什么是覆盖索引？ 
- 索引的设计原则？ 
- 索引什么时候会失效？ 
- 什么是前缀索引？ 

常见的存储引擎有哪些？ 

MyISAM和InnoDB的区别？ 

MVCC 实现原理？ 

快照读和当前读 

共享锁和排他锁 

大表怎么优化？ 

MySQL 执行计划了解吗？ 

bin log/redo log/undo log 

bin log和redo log有什么区别？ 

讲一下MySQL架构？ 

分库分表 

什么是分区表？ 

分区表类型 

分区的问题？ 

查询语句执行流程？ 

更新语句执行过程？ 

exist和in的区别？ 

MySQL中int(10)和char(10)的区别？　 

truncate、delete与drop区别？ 

having和where区别？ 

什么是MySQL主从同步？ 

为什么要做主从同步？ 

乐观锁和悲观锁是什么？ 

用过processlist吗？



# 一、体系结构与存储引擎

## 1.MySQL体系结构

1.1 体系结构图示

### 1.2 Select执行轨迹



## 2.什么是存储引擎及其分类

存储引擎：MySQL中具体与文件打交道的子系统。根据MySQL AB公司提供的**文件访问层抽象接口**定制的一种**文件访问机制**

分类：InnoDB、MyISAM、ArkDB ......

### InnoDB体系结构

1. 实例层





## 3.InnoDB存储引擎体系结构(MySQL5.6)·
## 4.InnoDB存储引擎体系结构的优化与改进(MySQL5.7和MySQL8.0)
## 5.InnoDB“成王”MylSAM“败寇”的原因
## 6.InnoDB几大核心特性详解



# 二、事务与锁机制

# 三、库表设计

# 四、高性能索引

# 五、数据库架构设计

# 六、查询优化

# 七、MySQL高可用

# 八、自动化运维体系构建

# 九、 可拓展MySQL规划

# 十、其他项目

