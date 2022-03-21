---
title: spring boot学习
tags:
  - spring
copyright: true
categories: spring
abbrlink: 2f959504
date: 2020-03-10 12:52:24
---



---

根据spring boot的历史，有以下几个问题

- Spring Boot 是如何基于 Spring Framework 逐步走向自动装配？
- SpringApplication 是怎样掌控 Spring 应用生命周期？
- Spring Boot 外部化配置与 Spring Environment 抽象之间是什么关系？
- Spring Web MVC 向 Spring Reactive WebFlux 过渡的真实价值和意义？

有关实践

- 场景分析
- 系统学习
- 重视规范
- 源码解读
- 实战演练

官方网站

- Spring 全栈技术和实现原理
- Spring Boot 核心技术
- BAT大规模微服务基础设施开发与生产实施经验

运行环境

- java：8
- ide：idea community 2018
- 多记api、多写代码



---

spring boot易学

- 组件自动装配：规约大于配置，专注核心业务
- 外部化配置：一次构建、按需调配、到处运行
- 嵌入式容器：内置容器、无需部署、独立运行
- spring boot starter：简化依赖、按需装配、自我包含
- production-ready：一站式运维、生态无缝整合

spring boot难精

- 组件自动装配：模式注解、@Enable模块、条件装配、加载机制
- 外部化配置：Environment抽象、生命周期、破坏性变更
- 嵌入式容器：Servlet Web容器、Reactive Web容器
- spring boot starter：依赖管理（二方库、三方库）、装配条件、装配顺序
- production-ready：健康检查、数据指标、@Endpoint管控

spring boot 与 java ee 规范

- web：servlet
- sql：jdbc
- 数据校验：bean validation
- 缓存：java caching api
- websockets：java api for websocket
- web service：jax-ws
- java管理：jmx
- 消息：jms



---

内容

- 核心特性
- web应用
- 数据相关
- 功能扩展
- 运维管理
- 课堂总结



---

### 三大特性

- 组件自动装配：web mvc、web flux、jdbc等
  - 如何激活：@EnableAutoConfiguration
  - 如何配置：/META-INF/spring.factories
  - 如何实现：XXXAutoConfiguration

---

- 嵌入式web容器：tomcat、jetty、undertow等
  - web servlet：Tomcat、Jetty、Undertow
  - web reactive：Netty Web Server

---

- 生产准备特性：指标、健康检查、外部化配置等
  - 指标：/actuator/metrics
  - 健康检查：/actuator/health
  - 外部化配置：/actuator/configprops

---



### web应用

传统servlet应用

- servlet主键：servlet、filter、listener
- servlet注册：servlet注册、spring bean、RegistrationBean
- 异步非阻塞：异步servlet、非阻塞servlet



