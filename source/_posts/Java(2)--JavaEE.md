---
title: Java(2)--JavaEE
date: 2019-12-30 15:48:24
tags: [java]
copyright: false
categories: java
---

@[toc]

## Spring

### 1. 基本概念

依赖注入*DI*的三种方式：接口注入；Construct注入；Setter注入。

引入控制反转*IoC*的目的：脱开、降低类之间的耦合；倡导面向接口编程、实施依赖倒换原则；提高系统可插入、可测试、可修改等特性。

IoC具体做法：

1. 将bean之间的依赖关系尽可能地转换为关联关系
2. 将对具体类的关联尽可能转换为对Java interface的关联，而不是对具体服务对象的关联
3. bean实例具体关联相关Java interface的哪个实现类的实例，在配置信息的元数据中描述
4. 由IoC组件根据配置信息，实例化具体bean类、将bean之间的依赖关系注入进来

面向切面编程AOP，是面向对象编程OOP——封装、继承、多态的补充和完善。但OOP允许开发者定义纵向的关系，但不适合定义横向的关系。例如，日志功能。OOP设计会导致大量代码的重复，不利于各个模块的重用。

AOP利用“横切”的技术，剖解开封装的对象内部，并将哪些影响了多个类的公共行为封装到一个可重用模块，并将其命名为“Aspect”——切面。所谓aspect，简单说就是那些与业务无关，却为业务模板所共同调用的逻辑或责任封装起来，便于减少系统的重复代码，降低模块之间的耦合度，并有利于未来的可操作性和可维护性。

AOP把软件系统分为两个部分：核心关注点和横切关注点。业务处理的主要流程是核心关注点，与之关系不大的部分是横切关注点。

横切关注点的一个主要特点：经常发生在核心关注点的多处，各处基本相似，例如日志、权限验证。AOP的作用在于分离系统中的关注点，将核心关注点和横切关注点分离开。



### 2. bean生命周期

1. getBean
2. 调用bean的缺省构造函数
3. 根据XML文件中的配置设置bean的相关属性
4. 检查bean所实现的aware接口
5. BeanPostProcessor前置处理
6. 检查InitialzingBean接口
7. 检查init-method方法
8. BeanPostProcessor后置处理
9. In Use
10. 检查Disposable接口
11. destroy接口



### 3. 注解

#### @autowired @resource

共同点：两者都可以写在字段上和setter方法上

区别：

1. @autowired需要导入包`org.springframework.beans.factory.annotation.Autowired`;,只按照**byType**注入

   @autowired注解是按照类型装配依赖对象，默认情况下它要求**依赖对象必须存在**，如果允许设置null值，**可以设置required值为false**。如果想使用按照名称byName来装配，可以结合@Qualifier注解一起使用

2. @resource默认按照byName自动注入，由J2EE提供，需要导入包javax.annotation.Resource. Resource有两个重要的属性：name, type。如果使用name属性，则使用byName的自动注入策略；如果使用type属性，则使用byType自动注入策略。



#### @Controller @RestController

@RestController相当于@ResponseBody + @Controller合在一起的作用



### 4. BeanFactory ApplicationFactory

BeanFactory——spring中比较原始古老的Factory，无法支持spring插件

ApplicationContext是BeanFactory的子类，基本上代替了BeanFactory的工作。拓展的功能

1. MessageSource，提供国家化的消息访问
2. 资源访问，如URL 文件
3. 事件传递
4. bean的自动装配
5. 各种不同应用层的Context实现

区别：

1. 如果使用ApplicationContext，如果配置的bean是单件singleton，那么无论是否用它，它都会被实例化。好处是可以预加载，坏处是浪费了内存
2. 如果使用BeanFactory实例化对象，配置的bean不会被马上实例化，而是等到getBean才会被实例化。好处是节约内存，坏处是速度比较慢。
3. 无特殊要求，一般用ApplicationContext。



### 5. bean作用域

单例模式 singleton、原型模式 prototype

一般情况下，无状态或状态不可变的类适合使用单例模式。

在传统开发中，由于DAO持有Connection这个非线程安全对象因而没有使用单例模式；

但在Spring环境下，所有DAO类都可以采用单例模式。



### 6. Spring自动装配

方式

1. no：不进行自动装配，手动设置Bean 的依赖关系
2. byName
3. byType
4. constructor
5. autodetect



## Hibernate

### 1.实体对象的三种状态以及转换关系

**瞬时态(new, or transient)**

当new一个实体对象以后，这个对象处于瞬时态，也就是这个对象只是一个保存临时数据的内存区域，如果没有变量引用这个对象，就会被JVM的垃圾回收机制回收。此时该数据与数据库没有任何关系。

经过session的save(), saveOrUpdate(), persist(), merge()把瞬时态对象与数据库关联，并把数据插入或更新到数据库，这个对象才转换为持久态对象。



**持久态(managed, or persistent)**

持久态对象的实例在数据库中有对应的记录，并拥有一个持久化标识ID。

对持久态对象进行delete操作后，数据库中对应的记录将被删除，那么持久态对象与数据库记录不再存在对应关系，持久态对象变成移除态 or 瞬时态。

持久态对象呗修改变更后，不会马上同步到数据库，知道数据库事务提交。



**游离态(detached)**

当session进行close(), clear(), evict(), flush()后，实体对象从持久态变成游离态，对象已经从会话中清除，不在持久化管理之内。

游离态对象与临时状态对象十分相似，只是它还含有持久化标识。



**移除态(removed)**



### 2. 延迟加载、性能优化





### 3. 一级缓存、二级缓存、查询缓存

- hibernate的**session**提供了一级缓存的功能，**默认有效**。当应用程序保存持久化实体、修改持久化实体时，session并不会立即把这种改变提交到数据库，而是**缓存在当前的session**中，除非显示调用了session的flush() 或 通过close()方法关闭session。

  通过一级缓存，可以减少程序与数据库的交互，从而提高数据库访问性能。

- 二级缓存，**sessionFactory**级别是全局性的，所有的session可以共享这个二级缓存。不过二级缓存**默认关闭**。需要显示开启并制定需要使用哪种二级缓存实现类（可以使用第三方提供的实现）。**一旦开启了二级缓存并设置了需要使用二级缓存的实体类，SessionFactory就会缓存访问过的该实体类的每个对象。**

- 一级缓存、二级缓存不会缓存普通属性。**需要缓存普通属性，则使用查询缓存。**

  查询缓存是将HQL或SQL以及它们的查询结果作为键值对进行缓存，对于同样的查询可以直接从缓存中获取数据。**查询缓存默认关闭。**