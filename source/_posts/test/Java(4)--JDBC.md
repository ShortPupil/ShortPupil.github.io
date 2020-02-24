---
title: Java(4)--JDBC
date: 2018-12-29 10:12:00
tags: [java]
copyright: false
categories: java
---

@[toc]

#### 事务四大特性

ACID：Atomicity原子性、consistency 一致性、isolation 隔离性、durability 持久性



## 数据库

### 1. 垂直切分、水平切分

数据库垂直拆分：**把表按模块划分到不同数据库表中**（不能破坏第三范式）。

当一个规模小的系统变大，变成需要多个子系统支撑，这时有按模块和功能把表划分出来的需求。垂直切分更近一步是服务化改造，简单来说就是把原来强耦合的系统拆分成多个弱耦合的服务，通过服务间的调用来满足业务需求，因此表拆出去后要通过服务的形式暴露出去，而不是直接调用不同模块的表。例如淘宝。

问题：单表大数据量依然存在性能瓶颈

数据库水平拆分：**把一个表按照某种规则把数据划分到不同表或数据库里。**

例如像计费系统，通过按时间来划分表就比较合适，因为系统都是处理某一时间段的数据。SaaS应用通过按用户维度来划分数据比较合适，简单地按user_id范围水平切分。



### 一些小问题

#### 如何查看sql语句执行效率

使用explain 命令 `explain select … from … [where ...]`

+----+-------------+-------+-------+-------------------+---------+---------+-------+------+-------+

| id | select_type | table | type | possible_keys | key | key_len | ref | rows | Extra |

+----+-------------+-------+-------+-------------------+---------+---------+-------+------+-------+



### 2. 数据库索引

索引：**对数据库表的一列或多列的值进行排序的结构**，使用索引可以快速访问数据库表中的特定信息。

主要目的：加快检索表中数据的方法，亦能协助信息搜索者尽快地找到符合限制条件的记录ID的辅助数据结构。

注意事项：B+树实现，没有遵循最左匹配原则，一些关键字会导致索引失效——`or` `!=` `not in` `is null` `is not null`， like查询是用%开头， 隐式转换会导致索引失效

InnoDB主要面向在线事务处理OLTP的应用。MyISAM主要面向一些OLAP应用。

#### 最左匹配原则

<https://www.cnblogs.com/u013533289/p/11695122.html>

针对联合索引，最左有限，以最左边的为起点任何连续的索引都能匹配，但遇到范围查询(>, <, between, like)就会停止查询



### 3. 数据库两种引擎

- InnoDB 聚集引擎，支持事务，支持行级锁
- MyISAM 非聚集索引，不支持事务，只支持表级锁



### 4. 数据库隔离级别

| 四个隔离级别\三个问题      | 脏读（Dirty Read） | 不可重复读（NonRepeatable Read） | 幻读（Phantom Read） |
| -------------------------- | ------------------ | -------------------------------- | -------------------- |
| 未提交读(Read uncommitted) | Y                  | Y                                | Y                    |
| 已提交读(Read committed)   | N                  | Y                                | Y                    |
| 可重复读(Repeatable read)  | N                  | N                                | Y                    |
| 可串行化(Serializable)     | N                  | N                                | N                    |

未提交读：允许脏读，也就是可能读取到其他会话中未提交事务修改的数据

提交读：只能读取到已提交的数据。Oracle等多数数据库均默认该级别（不重复读）

可重复读：在同一事务内的查询都是事务开始时刻一致，这是InnoDB默认级别。在SQL标准中，该隔离级别消除了不可重复读，但是存在幻想读。

串行读：完全串行化的毒，每次读都需要获得表级共享锁，读写相互都会阻塞。



### 5. 乐观锁 悲观锁

**乐观锁 Optimistic Lock**

**假设不会发生并发冲突，只在提交操作时检查是否违反数据完整性**。适用于读多写少的应用场景，可以提高吞吐量——每次拿数据的时候都认为别人不会修改，所以不会上锁，但是在提交更新的时候回判断一下在此期间别人有没有去更新这个数据。

两种实现方式

1. 使用数据版本*Version*记录机制实现（最常见），为数据增加一个版本标识，一般是通过为数据库表增加一个数据类型的“version”字段来实现。数据每更新一次，version字段+1.
2. 使用时间戳*timestamp*。也是为数据增加一个字段，但是字段类型使用时间戳*timestamp*

提交更新是，将version或timestamp进行比对，如果相等则更新，若不同则为**版本冲突**。

**悲观锁 Pessimistic Lock**

**假定会发生并发冲突，只在提交操作时检查是否违反数据完整性**。每次去拿数据的时候都认为别人会修改，每次拿数据都会上锁，这样别人想拿这个数据的时候会block直到它拿到锁。

java synchronized，每次线程要修改数据时都先获得锁，保证同一时刻只有一个线程能操作数据，其他线程会被block.



### 6. ACID特性 三范式

原子性——事务是一个不可分割的工作单位，事务中的操作要么都发生，要么都不发生

一致性——事务前后数据的完整性必须保持一致

隔离性——多个用户并发访问数据库时，一个用户的事务不能被其他用户的事务所干扰，多个并发事务之间数据要相互隔离

持久性——一个事务一旦提交，它对数据库中的数据改变就是永久性的，即数据库发生故障也不应该对其有任何影响



**第一范式（1NF）**

列的原子性；即列不能够再分成其它几列。

**第二范式（2NF）**

包括1NF，另外包括两方面：一是**表必须有一个主键**，二是没有包含在主键中的列必须完全依赖于主键，而不能只依赖于主键的一部分。

**第三范式（3NF）**

第三范式满足2NF，另外非主键列必须直接依赖于主键，不能存在传递依赖。也就是不能存在非主键列A依赖于非主键列B，非主键列B依赖于主键的情况。



### 7. mysql的主从复制



### 8. leftjoin rightjoin

leftjoin——返回包括左表中所有记录和右表中联结字段相等的记录

rightjoin——返回包括右表中所有记录和左表中联结字段相等的记录



### 9. 数据库的优化

[见另一篇博客](<http://songzi.info/categories/%E6%95%B0%E6%8D%AE%E5%BA%93/>)

1. 选取最适用的字段属性
2. 使用连接（join）来代替子查询（Sub-Queries）
3. 使用联合（union）来代替手动创建的临时表
4. 事务



### 10. 继承映射

继承关系的映射策略有三种

- 每个继承结构一张表(table per class hierarchy)，不管多少个子类都用一张表
- 每个子类一张表(table per subclass)，公共信息放一张表，特有信息放单独的表
- 每个具体类一张表(table per concrete class)，有多少个子类就有多少张表

第一种属于**单表策略**，其优点在于查询子类对象的时候无需表连接，查询速度快，适合多态查询；缺点是可能导致表很大。

后两种方式属于**多表策略**，其优点在于数据存储紧凑，缺点是需要进行连接查询，不适合多态查询。

多态查询？——例如返回的对象包括类的实例



### 11. 数据库连接池

J2EE服务器启动时会**建立一定数量的池连接，并一直维持不少于此数目的池连接**。

客户端程序需要连接时，池驱动程序会返回一个未使用的池连接并将其标记为“忙”。如果当前没有空闲连接，池驱动程序就新建一定数量的连接，新建连接的数量由配置参数决定。当使用的池连接调用完成后，池驱动程序将此连接表记为空闲，其它调用就可以使用这个连接。



### 12. 事务

只有并发数据访问时才需要事务

当多个事务访问同一数据时，

**脏读**：一个事务A读取了一个事务B已修改但未提交的数据，假如B回退，则A读取的是无效的数据。

```mysql
select * from users where id=1; #事务A
update users set age=21 where id=1; #事务B
select * from users where id=1; #事务A
commit; #lock-based dirty read
```

**不可重复读**：在基于锁的并行控制方法中，若在执行select时不添加读锁，就会发生不可重复读问题。

```mysql
select * from users where id=1; #事务A
update users set age=21 where id=1; #事务B
commit; #事务B in multiversion concurrency control, or lock-based READ cOMMITTED
select * from users where id=1;#事务A
commit; #事务B lock-based REPEATABLE READ
```

事务B提交成功，修改已经可见，但事务A已经读取了一个其他值。在提交读和为提交读隔离级别下，可能会返回被更新的值，这就是“不可重复读”。

**幻读**：发生在两个完全相同的查询执行时，第二次查询所返回的结果与第一个查询不相同。发生的情况：**新增或删除数据**，没有范围锁。

```mysql
select * from users where age between 10 and 30; # 事务A
insert into users values(3,'Bob',27); # 事务B
select * from users where age between 10 and 30; # 事务A
```



**第一类丢失更新**：**撤销一个事务的时候，把其它事务已提交的更新数据覆盖了。**这是完全没有事务隔离级别造成的。如果事务1被提交，另一个事务被撤销，那么会连同事务1所做的更新也被撤销。

**第二类丢失更新**：它和不可重复读本质上是同一类并发问题，通常将它看成**不可重复读的特例**。当两个或多个事务查询相同的记录，然后各自基于查询的结果更新记录时会造成第二类丢失更新问题。**每个事务不知道其它事务的存在，最后一个事务对记录所做的更改将覆盖其它事务之前对该记录所做的更改。**





## JDBC

### 基本概念

#### JDBC架构

双层![Two-tier-Architecture-for-Data-Access](https://www.runoob.com/wp-content/uploads/2015/05/Two-tier-Architecture-for-Data-Access.gif)

三层![Three-tier-Architecture-for-Data-Access](https://www.runoob.com/wp-content/uploads/2015/05/Three-tier-Architecture-for-Data-Access.gif)

#### 编程步骤

1. 加载驱动程序

   ```java
   //加载MySql驱动
   Class.forName("com.mysql.jdbc.Driver")
   //加载Oracle驱动
   Class.forName("oracle.jdbc.driver.OracleDriver")
   ```

2. 获得数据库连接

   ```java
   //url 用户名 密码
   DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/imooc", "root", "root");
   ```

3. 创建Statement\ PreparedStatement对象

   ```java
   conn.createStatement();
   conn.prepareStatement(sql);
   ```


### 1. 反射

1. 首先通过反射com.mysql.jdbc.Driver类，实例化该类的时候会执行该类内部的静态代码块，该代码块会在Java实现的DriverManager类中注册自己,DriverManager管理所有已经注册的驱动类，当调用DriverManager.geConnection方法时会遍历这些驱动类，并尝试去连接数据库，只要有一个能连接成功，就返回Connection对象，否则则报异常。
2. 通过使用DriverManager.geConnection(url,user,password)函数，传入url，数据库用户名，数据库密码，得到数据库的Connection对象。

```java
public void testJDBC(){
    try{
        //通过反射实例化com.mysql.jdbc.Driver
        Driver driver = (Driver)Class.forName("com.mysql.jdbc.Driver").newInstance();
        //得到数据库的连接对象
        Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/notedb", "root", "");
        System.out.println(conn);
    } catch(InstantiationException e){
        e.printStackTrace();
	} catch (IllegalAccessException e) {
		e.printStackTrace();
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	} catch (SQLException e) {
		e.printStackTrace();
    }
}
```



### 2. Jdo

Jdo--java data obkect，一个用于存取某种数据仓库中的对象标准化的API。

JDO提供透明的对象存储，因此存储数据对象完全不需要额外的代码。

JDBC只是面向关系数据库(RDBMS)；JDO更通用，提供到任何数据底层的存储功能。



### 3. Statement PreparedStatement

**区别**——主要谈PreparedStatement

1. PreparedStatement接口代表预编译的语句，主要优势在于可以减少sql编译错误并且增加sql的安全性
2. PreparedStatement中的sql是可以带参数的，避免使用字符串拼接sql语句的不安全
3. 批量处理sql或频繁执行相同的查询，PreparedStatement有明显的性能优势，因为数据库会**把编译优化的sql语句缓存起来**。



### 4. JDBC读取数据的性能优化

**用空间换时间**：结果集（ResultSet）对象的setFetchSize() 方法指定每次抓取的记录数；

提升**更新数据的性能**：可以用PreparedStatement语句构建批处理，将若干sql语句置于一个批处理执行



### 如何预防sql注入，有几种方式呢

<https://www.cnblogs.com/baizhanshi/p/6002898.html>

- jdbc方式查询，用PreparedStatement，不要拼接字符串
- hibernate查询，用name:parameter `
- 正则表达式过滤传入的参数 
- 字符串过滤



## hibernate

hibernate操作数据库

1. 读取并解析配置文件

   ```java
   Configuration conf = new Configuration().configure();
   ```

2. 读取并解析映射信息，创建SessionFactory

   ```java
   SessionFactory sf = conf.buildSessionFactory();
   ```

3. 打开Session

   ```java
   Session session = sf.openSession();
   ```

4. 开始一个事务（增删改操作必须，查询操作可选）

   ```java
   Transaction tx = session.beginTransaction();
   ```

5. 数据库操作

   ```java
   session.save(user);//或其它操作
   ```

6. 提交事务/回滚事务

   ```java
   tx.commit();
   tx.rollback();
   ```

7. 关闭session

   ```java
   session.close();
   ```

**Configuration**

**SessionFactiory**

**Session**

**事务transaction**





























