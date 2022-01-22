---
title: 博弈论
date: 2021-01-30 14:23:24
tags: [Game Theory]
copyright: true
categories: 博弈论
---

# 学习课程

[博弈论 | Coursera](https://www.coursera.org/learn/game-theory-1)

# Intro

博弈论研究的是 两位自利者的策略性互动 

这些学科共同点，在于它们都关心自利者在策略性互动当中如何做 ，同时考虑这些互动如何为研究者所建构



## Self-Interested Agents and Utility Theory

Utility Function 收益函数：决定一个局中人对于特定情况的喜恶程度

*现代博弈论的基础：每个人都试图将期望效益最大化*



## 定义

- Players: who are the decision makers?
  - 明确主体：*政府？公民？企业？员工？*
- Actions: what can the players do?
  - 明确决策：*拍卖行为？投资行为？投票行为？*
- Payoffs: what motivates players?
  - 明确收益
  - 明确主体对收益的态度：*主体是否在乎收益？主体是否在乎别人的收益？*
- Normal Form 范式博弈：以**函数关系**呈现参与者收益与其行为的关系
  - 参与者同时行动
  - 参与者产生策略
- Extensive Form 拓展形式的博弈：**树形图**表示
  - 新增其他要素
    -  *timing*，参与者按次序行动，谁会先采取行动，例如*下棋、打牌...*
    - *Information*，参与者知道自己和其他人所采取的行动的信息
  - 跟踪参与者的决策



### Normal Form 范式博弈模型构建

![范式博弈公式](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/2022%E5%B9%B41%E6%9C%8822%E6%97%A5160817.PNG)

![范式博弈矩阵模型](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/2022%E5%B9%B41%E6%9C%8822%E6%97%A5160818.PNG)

根据上述模型，形成TCP博弈矩阵

|       | **C**  | **D**  |
| ----- | ------ | ------ |
| **C** | -1, -1 | -4, 0  |
| **D** | 0, -4  | -3, -3 |

### 大规模群体的博弈

![](https://songzi-blog-pic.oss-cn-hangzhou.aliyuncs.com/2022%E5%B9%B41%E6%9C%8822%E6%97%A5160819.PNG)

