---
title: Hibernate的三种状态、事务机制、缓存懒加载
copyright: true
date: 2018-10-29 23:33:44
tags: hibernate
---



了解hibernate的底层实现对于使用还是很重要的

今天有个用hibernate进行查询出了不少错误，问题在于没有理解其持久状态和事务机制



# 1. 三种状态

## 1.1 临时状态(Transient)

当new一个实体对象后, 这个对象处于临时状态, 即这个对象只是一个**保存临时数据的内存区域**, 如果没有变量引用这个对象, 则会被jre垃圾回收机制回收. 这个对象所保存的数据与数据库没有任何关系, 除非通过**Session的save或者SaveOrUpdate**把临时对象与数据库关联, 并把数据插入或者更新到数据库, 这个对象才转换为持久对象.

## 1.2 持久状态(Persistent)

持久化对象的实例在**数据库中有对应的记录, 并拥有一个持久化表示（ID）**. 对持久化对象进行delete操作后, 数据库中对应的记录将被删除, 那么持久化对象与数据库记录不再存在对应关系, 持久化对象变成临时状态. 持久化对象被修改变更后, 不会马上同步到数据库, 直到数据库事务提交. 在同步之前, 持久化对象是脏的（Dirty）.

## 1.3 游离状态(Detached)

当Session进行了Close、Clear或者evict后, **持久化对象虽然拥有持久化标识符和与数据库对应记录一致的值, 但是因为会话已经消失, 对象不在持久化管理之内**, 所以处于游离. 游离状态的对象与临时状态对象是十分相似的, 只是它还含有持久化标识.



# 2 事务机制

## 2.1 常见的Q&A

### 2.1.1 getTransaction、beginTransaction

```java
factory.getSession().getTransaction().hasCode = 832665667;
factory.getSession().beginTransaction().hasCode = 2119928380;
factory.getSession().getTransaction().hascode = 2119928380;
```

- 调用session.getTransaction()的时候，会创建一个全新的Transaction对象；
- 调用session.beginTransaction()的时候，会创建一个全新的Transaction对象，没有使用上一步的Transaction对象哦；
- 再次调用session.getTransaction()的时候，会看到这时返回的是第2步创建的Transaction对象；
- 这时调用session.getCurrentTransaction()，会看到仍然返回第2步创建的Transaction对象；

**结论**：通常情况下一个session内只会处理一个事务，所以大多数时候可直接调用session.beginTransaction()方法创建一个全新的transaction对象，并开始该事务。 



### 2.1.2 getTransaction、getCurrentTransaction 

### 2.1.3 如果不断的调用getTransaction，是否会返回同一个transaction对象？

### 2.1.4 通过getTransaction创建transaction对象begin之后，再调用session.beginTransaction是否会开启两个事务？

### 2.1.5 当transaction.commit()调用之后再次调用session.beginTransaction是否会继续沿用之前的transaction？ 

### 2.1.6 是否总是需要手工调用transaction.rollback实现事务回滚？



## 2.2 session & transaction scope（事务范围）



### 2.2.1 操作单元

- 别用_session-per-operation_这种反模式了，也就是说，在单个线程中， 不要因为一次简单的数据库调用，就打开和关闭一次`Session`！数据库事务也是如此。
- 最常用的模式是 *每个请求一个会话(**session-per-request**)*——一 个新的Hibernate `Session`被打开，并且**执行这个操作单元中所有的数据库操作**。 一旦操作完成（同时对客户端的响应也准备就绪），session被同步，然后关闭。
- key：**在服务器端要处理请求的时候，开启事务，在响应发送给客户之前结束事务。**
- 通常的方案有`ServletFilter`，在service方法中进行pointcut的AOP拦截器，或者proxy/interception容器。
- 在任何时间，任何地方，你的应用代码可以通过简单的调用`sessionFactory.getCurrentSession()`来访问"当前session"，用于处理请求。你总是会得到当前数据库事务范围内的`Session`。



### 2.2.2 长对话

- 长时间运行的对话（conversation）例子

  - 在界面的第一屏，打开对话框，用户所看到的数据是被一个特定的 `Session` 和数据 库事务载入(load)的。用户可以随意修改对话框中的数据对象。
  - 5分钟后，用户点击“保存”，期望所做出的修改被持久化；同时他也期望自己是唯一修改这个信息的人，不会出现 修改冲突。
- 我们必须使用**多个数据库事务**来实现这个对话。
- 如果仅仅只有一 个数据库事务（最后的那个事务）保存更新过的数据，而所有其他事务只是单纯的读取数据（例如在一个跨越多个请求/响应周期的向导风格的对话框中），那么应用程序事务将保证其**原子性**。
- hibernate有用的特性
  - *自动版本化* - Hibernate能够自动进行乐观并发控制 ，如果在用户思考 的过程中发生并发修改，Hibernate能够自动检测到。一般我们只在**对话结束**时才检查。
  - *脱管对象*（Detached  Objects）- 如果你决定采用前面已经讨论过的 _session-per-request_模式，所有载入的实例在用户思考的过程  中都处于与Session脱离的状态。Hibernate允许你**把与Session脱离的对象重新关联到Session上**，**并且对修改进行持久化**，这种模式被称为 *session-per-request-with-detached-objects*。自动版本化被用来隔离并发修改。
  - *Extended (or Long) Session* - Hibernate 的`Session`  可以在数据库事务提交之后和底层的JDBC连接断开，当一个新的客户端请求到来的时候，它又重新连接上底层的  JDBC连接。这种模式被称之为**_session-per-conversation_**，这种情况可 能会造成不必要的Session和JDBC连接的重新关联。自动版本化被用来隔离并发修改, **`Session`通常不允许自动flush,而是明确flush**。



### 2.1.3 关注对象标识（Considering object identity）

- 当应用程序在两个不同的session中并发访问具有同一持久化标 识的业务对象实例的时候，这个业务对象的**两个实例事实上是不相同的**（从 JVM识别来看）。这种冲突可以通过在同步和提交的时候使用**自动版本化**和**乐观锁定**方法来解决。
- **只要在单个线程只持有一个** `Session`，**应用程序就不需要同步任何业务对象**。在`Session` 的范围内，应用程序可以放心的使用`==`进行对象比较。
- 应用程序在`Session`的外面使用`==`进行对象比较可能会导致**无法预期的结果**。例如，如果你把两个脱管对象实例放进同一个 `Set`的时候，就可能发生。开发人员必须**覆盖持久化类的`equals()`方法和 `hashCode()` 方法，从而实现自定义的对象相等语义**。
- 不要使用数据库标识 来实现对象相等，应该使用**业务键值**，由**唯一的，通常不变的属性**组成。



### 2.1.4 问题

- 决不要使用反模式**_session-per-user-session_或者 session-per-application**（这个规定几乎没有例外）
- `Session` 对象是非线程安全的。
- 一个由Hibernate抛出的异常意味着你必须立即回滚数据库事务，并立即关闭`Session` 
- `Session` 缓存了处于持久化状态的每个对象（Hibernate会监视和检查脏数据）。



## 2.3 事务声明

手工启动，提交，或者回滚数据库事务

通常情况下，结束 `Session` 包含了四个不同的阶段:

- 同步session(flush,刷出到磁盘）
- 提交事务
- 关闭session
- 处理异常



### 2.3.1 非托管环境 

session/transaction常见处理方式

```java
//Non-managed environment idiom
Session sess = factory.openSession();
Transaction tx = null;
try {
    tx = sess.beginTransaction();

    // do some work
    ...

    tx.commit(); //自动触发session的同步
}
catch (RuntimeException e) {
    if (tx != null) tx.rollback();
    throw e; // or display error message
}
finally {
    sess.close();
}
```

Hibernate内置的**"current session"上下文管理**

```java
// Non-managed environment idiom with getCurrentSession()
try {
    factory.getCurrentSession().beginTransaction();

    // do some work
    ...

    factory.getCurrentSession().getTransaction().commit();
}
catch (RuntimeException e) {
    factory.getCurrentSession().getTransaction().rollback();
    throw e; // or display error message
}

```

你所有的一切就是`SessionFactory`



### 2.3.2 使用JTA



### 2.3.3 异常处理

标准的 `JDBCException`子类型是：

- `JDBCConnectionException` - 指明底层的JDBC通讯出现错误
- `SQLGrammarException` - 指明发送的SQL语句的语法或者格式错误
- `ConstraintViolationException` - 指明某种类型的约束违例错误
- `LockAcquisitionException` - 指明了在执行请求操作时，获取 所需的锁级别时出现的错误。
- `GenericJDBCException` - 不属于任何其他种类的原生异常



### 2.3.4 事务超时

在托管环境中，Hibernate会把事务超时转交给JTA。这一功能通过**Hibernate `Transaction`对象进行抽象**。

```
Session sess = factory.openSession();
try {
    //set transaction timeout to 3 seconds
    sess.getTransaction().setTimeout(3);
    sess.getTransaction().begin();

    // do some work
    ...

    sess.getTransaction().commit()
}
catch (RuntimeException e) {
    sess.getTransaction().rollback();
    throw e; // or display error message
}
finally {
    sess.close();
}
```



# 3. 缓存懒加载

## 3.1 常见使用Q&A

### 3.1.1 对于ManyToOne注解默认FetchType.EAGER 

EAGER是什么意思呢？比如User类有个role属性，当加载user对象的时候，就会同时加载role对象，也就是你期望的只有一条简单sql从user表查询，但是却执行了两条sql（或者是join查询）。

所以，通常情况下对于ManyToOne注解，都需要**手工设置fetch = FetchType.LAZY**，否则会出现严重性能问题。



## 3.2 缓存机制

### 3.2.1 一级缓存

Session缓存表示将查询结果放置到Session的临时存储空间（一级缓存中），一旦session关闭，则缓存关闭。方法有`load`、`save`、`update`、`delete`



### 3.2.2 二级缓存

二级缓存是将查询的数据放置在SessionFactory临时存储空间中，因为一个SessionFactory可以创建多个Session对象，所以范围比Session缓存的要大，多个Session可以共享二级缓存的数据。



## 3.3 懒加载

表示**查询当前对象或关联对象数据时，不真正访问数据库，当使用对象非主键属性时，才真正发送查询语句，访问数据库。**由于在某些情况下，查的数据在后续流程到可能用不上，如果做查询处理就多余了，所以延迟加载功能可以提高性能，合理使用即可。当然了Hibernate框架是通过Cglib代理来完成延迟加载功能的扩展的。



### 3.3.1 延迟加载会出现的问题

延迟加载功能是**运用的一级缓存**，也就是利用的是session的内存，一般情况下，我们在用完session后会进行关闭，但是关闭后我们就无法进行延迟查询数据了，也就是说，延迟加载功能就将失效，剖出异常：**No Sesssion**，所以这是需要我们解决的。



### 3.3.2 处理No  Session

在处理父子表中经常出现No Session



#### 3.3.2.1 解决原理

基于对Hibernate和JPA的理解，在ORM中，其为了提升性能使用了Lazy加载，就是在使用的时候，才会加载额外的数据，故导致了在使用之时再加载数据之时， session失效的问题出现。所以问题的目标点实现提前加载数据



#### 3.3.2.2 方法

查看hibernate配置

```html
<property name="current_session_context_class">thread</property> 
```

In order to overcome this problem you could change the configuration of  session factory or open another session and only than ask for those lazy loaded objects. But what I would suggest here is to initialize this  lazy collection in getModelByModelGroup itself and call:

```
Hibernate.initialize(subProcessModel.getElement()) 
```

 [AOP编程思想](https://www.zhihu.com/question/24863332/answer/48376158)



[参考博客](https://www.cnblogs.com/leotsai/p/hibernate-transaction-session-flush-commit-rollback.html) [hibernate中文文档](https://www.kancloud.cn/wizardforcel/hibernate-doc/103753)