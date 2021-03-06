---
title: 数据挖掘算法（二）——Boosting算法和AdaBoost装袋提升算法
date: 2019-05-06 16:44:06
tags: [Data Mining]
categories: 商务智能
copyright: true
mathjax: true


---

# 目录

@[toc]



## 如何理解

### Boosting算法

**Boosting 提升算法**是**一系列**将罗学习器提升为强学习器的算法。

思想：对于一个复杂的任务，将多个专家的判断总和得出的结果要比任何一个专家单独的判断好。

大致工作机制：

先从初始训练集训练出一个**基学习器**，再根据基学习器表现对训练样本分布进行调整，在后续赋予基学习器中做错的样本更大的权值，然后基于调整后的样本分布来训练下一个基学习器，一直反复进行，直到达到指定值。



### AdaBoost算法

AdaBoost算法工作机制同上。

对于弱分类器的组合，AdaBoost算法采取**加权多数表决**的方法——加大分类误差率小的弱分类器的权值，使其在表决中起到较大的作用；减小分类误差率大的弱分类器的权值，使其在表决中起较小的作用。

应用集中于**提高分类准确率**。



## 算法原理

1. 对D训练集数据训练处一个分类器Ci
2. 通过分类器Ci对数据进行分类，计算此时误差率
3. 把上步骤中的分错的数据的权重提高，分对的权重降低，以此凸显了分错的数据。为什么这么做呢，后面会做出解释。

![adaboost算法伪码](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/1335428125_1739.png)



## 算法实现





