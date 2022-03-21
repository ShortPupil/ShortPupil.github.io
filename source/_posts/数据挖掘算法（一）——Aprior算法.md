---
title: 数据挖掘算法（一）——Aprior算法和FP-Tree算法
tags:
  - Data Mining
categories: 商务智能
copyright: true
abbrlink: 93db42ae
date: 2019-05-05 08:16:06
---

# 目录

<!-- toc -->



## 如何理解

[啤酒与尿布](http://book.douban.com/subject/3283973/)

### 总项集

数据记录的所有项的集合

| TID  | Items                     |
| ---- | ------------------------- |
| T1   | {牛奶， 面包}             |
| T2   | {面包，尿布，啤酒， 鸡蛋} |
| T3   | {尿布，啤酒}              |
| T4   | {面包，牛奶，尿布，可乐}  |

### 关联规则的定义

两个不相交的非空集合X、Y，如果有X-->Y，就说X-->Y是一条关联规则。例如购买啤酒就一定会购买尿布，可表示为*{啤酒}-->{尿布}*。

下面两项用于描述**关联规则的强度**

#### 支持度 support

**项集{X,Y}在总项集里出现的概率**
$$
Support(X→Y) = P(X,Y) / P(I) = P(X∪Y) / P(I) = num(XUY) / num(I) = (同时购买{X, Y}的订单) / (总订单)
$$
I表示总事务集。num()表示求事务集里特定项集出现的次数。 num(I)表示总事务集的个数。num(X∪Y)表示含有{X,Y}的事务集的个数（个数也叫次数）。



#### 置信度 confidence

**在先决条件X发生的情况下，由关联规则”X→Y“推出Y的概率**
$$
Confidence(X→Y) = P(Y|X)  = P(X,Y) / P(X) = P(XUY) / P(X) = （同时购买{X, Y}的订单）/（购买X的订单）
$$

$$
Confidence(Y→X) = P(X|Y)  = P(X,Y) / P(Y) = P(XUY) / P(Y) = （同时购买{X, Y}的订单）/（购买Y的订单）
$$



#### 提升度 lift

**含有X的条件下，同时含有Y的概率，与Y总体发生的概率之比**
$$
Lift(X→Y) = P(Y|X) / P(Y) = （同时购买{X，Y}的订单*总订单）/（购买X的订单*购买Y的订单）
$$


#### 例子

|              | buy tea | buy coffee |
| ------------ | ------- | ---------- |
| Group A(500) | 500     | 450        |
| Group B(500) | 0       | 450        |

X= {buy tea}，Y={buy coffee}，则规则”茶叶→咖啡“表示”即买了茶叶，又买了咖啡“
- support(X→Y) =  450 / 500 = 90%
- Confidence(X→Y) = 450 / 500 = 90%
- Lift(X→Y) = Confidence(X→Y) / P(Y) = 90% /  ((450+450) / 1000) = 90% / 90% = 1



### 关联规则挖掘的定义和步骤

*给定一个交易数据集T，找出其中所有支持度$support >= minSupport$、自信度$confidence >= minConfidence$的关联规则。*

#### 步骤

- **生成频繁项集（O(2^N)，耗时，优化对象）**

  找出所有满足最小支持度的项集

- **生成规则**

  生成满足最小自信度的规则，产生的规则为强规则



## Apriori定律——消除频繁项集生成时间

#### 定律一

*如果一个集合是频繁项集，则它的所有子集都是频繁项集*。

举例：假设一个集合{A,B}是频繁项集，即A、B同时出现在一条记录的次数大于等于最小支持度min_support，则它的子集{A},{B}出现次数必定大于等于min_support，即它的子集都是频繁项集。

#### 定律二

*如果一个集合不是频繁项集，则它的所有超集都不是频繁项集。*

举例：假设集合{A}不是频繁项集，即A出现的次数小于min_support，则它的任何超集如{A,B}出现的次数必定小于min_support，因此其超集必定也不是频繁项集。

### Apriori算法实现

[大佬的算法实现](<https://github.com/linyiqun/DataMiningAlgorithm/tree/master/AssociationAnalysis/DataMining_Apriori>)



## FP-Tree频繁模式树算法 

FP-Tree算法是Apriori算法的优化处理，Apriori算法在过程中会产生大量的候选集的问题，FP-Tree算法则是*发现频繁模式而不产生候选集*。

但是频繁模式挖掘出来后，产生关联规则的步骤还是和Apriori是一样的。

### 步骤

- 创建根节点

- 统计所有的事务数据，统计事务中各个类型项的总支持度(在下面的例子中就是各个商品ID的总个数)

- 依次读取每条事务，比如T1， 1， 2， 5，因为按照总支持度计数数量降序排列，输入的数据顺序就是2， 1， 5，然后挂到根节点上

- 依次读取后面的事务，并以同样的方式加入的FP树中，顺着根节点路径添加，并更新节点上的支持度计数。

  





## 参考

[数据挖掘系列（1）关联规则挖掘基本概念与Aprior算法](https://www.cnblogs.com/fengfenggirl/p/associate_apriori.html)

[算法实现](<https://github.com/linyiqun/DataMiningAlgorithm/tree/master/AssociationAnalysis/DataMining_Apriori>)