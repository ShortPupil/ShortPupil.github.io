---
title: Java(1)--JavaSE
date: 2018-12-28 15:48:24
tags: [java]
copyright: false
categories: java
---

@[toc]

[TOC]



自己加的

问了io，设计模式，并发，主要针对简历和你笔试的两道算法问，让你想一想你的算法怎么优化

问了bufferedinputstream是什么设计模式

- java io运用了什么设计模式。 主要运用了俩个设计模式，**适配器**和**装饰者模式**。
- 装饰者模式：对已有的业务逻辑进一步的封装，使其增加额外的功能，如java中的IO流就使用了装饰者模式，用户在使用的时候，可以任意组装，达到自己想要的效果。；一个父类，多个子类
- 将两种完全不同的事物联系到一起，就像现实生活中的变压器。假设一个手机充电器需要的电压是20V，但是正常的电压是220V，这时候就需要一个变压器，将220V的电压转换成20V的电压，这样，变压器就将20V的电压和手机联系起来了。

策略模式、装饰模式、静态代理模式区别

- 单一职责原则 、开闭原则、里氏替换原则  、依赖倒转原则、接口隔离原则、合成复用原则、迪米特原则

- 单一职责原则

- 开放-封闭原则

- 依赖倒转原则

- 策略模式通过将一些易变的计算抽象为策略实体，通过多态，让实际调用者尽可能的不用感知这种变化。

  ![img](https://img2018.cnblogs.com/blog/586700/201904/586700-20190407134415807-796326898.png)

- 代理模式

  ![img](https://img2018.cnblogs.com/blog/586700/201904/586700-20190407134715681-747251066.png)

- 装饰者模式

  ![img](https://img2018.cnblogs.com/blog/586700/201904/586700-20190407134733065-2115257767.png)



1. 代理模式与策略模式不同的是，代理类必须和被代理类具有相同的父类或接口，即代理类要么继承或实现被代理类的父类，要么直接记成被代理类本身。这两种情况分别对应java的jdk代理和cglib代理实现。

   代理模式不是为了封装变化，而是为了隐藏实际执行者本身。

2. 装饰者模式和策略模式的不同在于，原有类和装饰器类必须继承同一个父类。装饰器对象除了需要完成持有对象的操作外，还有一些附加操作，这些附加操作随着装饰器的不同而变化。持有对象本身的操作是主体，装饰器的操作是补充。而策略模式中，具体策略才是主体。

3. **代理模式主要是控制对某个特定对象访问，而装饰模式主要是为了给对象添加行为**。



### **计算机网络**

- 计算机网络分为哪几层？
  计算机网络如果是ISO模型的话，分为七层。TCP／IP协议簇模型的话，分为四层。这一个你需要能够说出来每一层叫做什么，大概做了什么事情，网上查一查就知道了，我就不具体说了。

- 回答：ISO 七层：物理层（物理媒介）、数据链路层（在不可靠的物理线路上进行可靠的数据传输）、网络层（网络地址翻译成物理地址，决定如何从发送方路由到接收方）、传输层（最重要，流量控制。传输控制协议tcp udp）、会话层（两个节点之间的建立和维持通信）、表示层（应用程序与网络的翻译官，主要格式化数据）、应用层（对软件提供接口用以程序能使用网络服务）

- 回答：TCP/IP协议簇模型：应用层、传输层、网络层、数据链路层

  ![img](https://img-blog.csdnimg.cn/20190312140727339.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMzMjYzNzY5,size_16,color_FFFFFF,t_70)



- TCP和UDP有什么区别？什么场景使用TCP，什么场景什么UDP？哪些应用层协议使用了TCP，哪些使用了UDP？
  传输层绝壁是你在面试的时候最常被问到的，这一块你需要好好看。TCP和UDP最主要的区别是TCP是可靠传输的，UDP是不可靠传输的。所以如果我们的发送消息之类的场景，因为你要确保用户的消息不会丢失，需要使用TCP协议。如果你是在进行视频聊天或者看直播，那你可以使用UDP协议，因为即使几个画面丢失了，对用户来说影响也不是很大。哪些应用层协议使用TCP，哪些使用UDP的话，你自己去查一下，懒得打字了。
- tcp可靠传输：SMTP\POP\FTP\HTTP、udp不可靠传输：DNS\



- 什么是窗口滑动协议，什么是快速重传，什么是拥塞避免，什么是慢启动？
  这个考的基本上就是TCP协议的具体实现，如果对于这一块没有接触过的话，最少要知道窗口滑动协议是什么。后面的那几个问题你可以作为拓展，好好看一下书也基本上就知道是什么了。

**全集合**

1. 属于传输层通信协议、基于tcp的协议有http、smtp、ftp、telnet、pop3

  2. 特点

     - **面向连接**：使用tcp传输数据前，必须先建立tcp连接；传输完成后释放连接

     - **面向字节流**：数据以流的形式进行传输；

       流：流入/流出进程的字符序列；

       TCP一次传输的报文长度有限制，若太大则需要分块、分次传输；

       但由于TCP传输的可靠性，接收方可按顺序接受数据块&重新组成分块之前的数据流

       所以TCP看起来就像直接互相传播字节流一样，即面向字节流

     - **全双工通信**：建立TCP连接后，通信双方都能发送数据

     - **可靠**：不丢失、无差错、不重复、按序到达

   3. 数据传输可靠，但是效率低

   4. 应用场景：需要精确无误；万维网：HTTP协议；文件传输：FTP协议；电子邮件：SMTP协议；远程终端接入：TELNET协议

   5. ![img](https://upload-images.jianshu.io/upload_images/944365-123333642e8eb31a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1110/format/webp)

   6. ![img](https://upload-images.jianshu.io/upload_images/944365-4740db911582939f.png?imageMogr2/auto-orient/strip|imageView2/2/w/808/format/webp)

   7. 建立连接过程——三次握手——SYN 同步位、seq 报文段序号、ACK 确认号、

      - **第一次握手**：客户端由closed状态主动打开，进入同步已发送状态(SYN_SEND)，向服务器发送1个连接请求的报文段，

        *同步标志位 SYN=1, 随机选择一个起始序号seq=x, 不携带数据*（**SYN位被设置为1的报文段不携带数据，但要消耗一个序号**）

        TCP服务器被动打开

      - **第二次握手**：服务器收到请求连接报文段后，若同意建立连接，则向客户端发回连接确认的报文段

        *同步标志位 SYN=1, 确认标志位 ACK=1,随机选择一个起始序号 seq=y, 确认号字段 ack=x+1, 不携带数据*

        服务器进入 同步已接受状态(SYN_RCVD)

      - **第三次握手**：客户端收到确认报文段后，向服务器再次发出连接确认报文段

        *确认标记位 ACK=1, 序号 seq=x+1, 确认号字段 ack=y+1, 此时可携带数据*（**SYN未设为1，若不携带数据则不消耗序号**）

8. 三次握手原因：防止服务器端因接受了早已失效的连接请求报文，从而一直等待客户端请求，**形成死锁**

   - 可能出现的情况：“已失效的连接请求报文段”——客户端发出的第一个连接请求报文段无丢失，而是**在某个网络节点长时间滞留**导致延误到连接释放后的某个时间才到达服务器
   - 冲突：不用三次握手——**只要服务器发出确认报文段后，tcp连接就建立了**，但由于客户端并无发出建立连接的请求，因此不会向服务器发送数据。服务器却误以为新的tcp连接已经建立，于是一直等待客户端发送数据——**进入死锁状态**
   - 解决方案：第三次握手——客户端不会向服务器的确认报文信息再次发出确认。**服务器端由于收不到客户端的确认信息，即知道客户端并无要求建立TCP连接**，故服务器不会一直等待——不会进入死锁状态

9. 释放连接过程

   - **第一次挥手**：客户端向服务器发送1个连接释放的报文段

     *终止控制位 FIN=1，报文段序号 seq=u，可携带数据*（FIN=1的报文即使不携带数据也消耗一个序号）

     客户端进入 终止等待1状态(FIN-WAIT-1) 这时在等待服务器的确认

   - **第二次挥手**：服务器收到连接释放报文段后，则向客户端发回连接释放确认的报文段

     *确认标记位 ACK=1, 报文段序号 seq=v，确认号字段 ack=u+1*

     服务器端进入关闭等待状态 (CLOSE-WAIT),此时客户端->服务器的TCP连接断开；tcp连接进入半关闭状态，

     **客户端->服务器的TCP连接断开；服务器->客户端的TCP连接未断开**

   - **第三次挥手**：若服务器已不向客户端发送数据，则发出释放连接的报文段

     *终止控制位 FIN=1, 确认标志位 ACK=1, 报文段序号 seq=w, ack=u+1, 可携带数据*

     服务器进入最后确认状态(LAST-ACK)

   - **第四次挥手**：客户端收到连接释放报文段后，则向服务器发回连接释放确认的报文段

     **

10. 四次挥手原因

11. 客户端关闭连接前为什么要等待2MSL时间？

12. TCP无差错传输：传输信道不出差错、无论发送方以多快的速度发送数据，接收方总来得及收到数据

    - 滑动窗口协议




- 当你输入域名访问一个网站的时候，背后的过程是什么？
  这个问题是比较开放的，你可以回答的内容有很多，但是你如果回答得**越详细肯定是越好的**。**第一步就是域名解析**，域名解析的话你可以说一下域名缓存在哪些地方，然后如果你域名在本地没有缓存的话，是如何通过DNS来进行域名解析的，如果你的DNS服务器上没有保存那个域名，那你的DNS服务器将如何处理来得到这个域名的ip。**第二步就是说一下TCP连接的三次握手的过程**。其他拓展内容有很多可以说，看你知识储备。例如你可以说通过CDN来进行访问加速。也可以说目前网站基本上都是前后端分离的，访问的时候会先访问反向代理服务器进行负载均衡之类的
- 一般分为五步；用到的协议 应用层：DNS HTTP；传输层：TCP；网络层：IP ICMP ARP
- 1. DNS解析，将对应的域名解析为对应的ip地址
     - 首先查阅浏览器的DNS缓存，如果有就返回对应ip
     - 如果没有，查询系统缓存，这里会用到底层的系统调用进行查询
     - 如果没有，查询路由器的缓存
     - 如果没有，查找ISP对应的缓存记录
     - 如果没有，对根域名解析服务器发起查询请求，返回对应的ip地址
  2. 根据获取的ip地址，通过三次握手建立TCP连接
  3. 通过TCP连接发起HTTP请求
  4. 服务器根据响应的HTTP请求，交给特定的处理器进行处理，并将结果和响应的视图进行返回
  5. 浏览器解析并渲染视图
- CDN网络加速：在dns解析的时候，比如访问baidu.com，请求会直接发到百度的服务器上，加入请求者在新疆，但服务器在北京，这样请求和响应会因为距离而慢一些。有了CDN之后，请求先发至距离请求ip最近的CDN服务器上。但是这个**仅限加速静态资源**。分布式系统
- 负载均衡：利用反向代理缓存资源，以改善网站性能。在部署位置上面，反向代理服务器是在web服务器前面，这个位置也是负载均衡服务器的位置。
- 反向代理：用带路服务器来接受Internet上的连接请求，然后将请求转发给内部网络上的服务器，并将服务器上得到的结果返回Internet上请求连接的客户端




- 什么是https协议？https协议用到了哪种密钥？
  https是在http上面套了一层ssl，用来实现安全连接。用到的密钥有对称密钥和非对称密钥。目前基本上大一点的网站，都会使用https，这里面涉及的知识点也不是很多，但是过程相对来说会复杂一点，感兴趣的话可以去看一下。基本上就是有**数字证书**，然后**把对称密钥作为消息内容**，通过**非对称密钥来进行传输**。之后双方的通信就通过**对称密钥来进行解密**就行了。




- 什么是socket？
  socket是用来进行网络通信的，java里面已经有封装好这个类了，分为客户端和服务器，通过ip+端口来进行访问。如果没有用过socket的话，建议你到网上找一个demo，跟着写一下，你基本上就知道socket怎么用了，算是比较简单的。




- **什么是IO，什么是NIO，什么是AIO，什么是netty框架？**
  如果我上面那个问题，你自己有到网上找一个例子去写一下，你就会发现在socket在读取消息的时候阻塞的。这里有一个概念，阻塞。如果你不知道什么是阻塞函数的话，需要去了解一下。NIO就是非阻塞IO，用来解决上面读取消息的时候会阻塞的问题。在jdk1.4左右引入的，是通过selector、buffer、通道等组件来实现的，具体实现原理我觉得还是需要有所了解的。
  AIO就是异步非阻塞IO。咱们上面说的NIO是同步阻塞IO。AIO是异步的，NIO是同步的。同步和异步是什么区别我有点讲不清楚，如果这个你不懂自己去查一下资料。异步基本上就是通过回调来实现的。AIO是在jdk1.7左右引入的，面试官问AIO一般也会问得比较少。
  netty是用来实现非阻塞IO的一个框架，这个作为拓展点，感兴趣可以去了解一下。我在面试阿里的时候被问到过，其他公司还没问过。
- <https://www.cnblogs.com/sxkgeek/p/9488703.html>
- 阻塞：IO操作需要彻底完成后才能返回用户空间；非阻塞：IO操作被调用后立即返回一个状态值，无需等IO操作彻底完成



### **数据库**

- 数据库常用的操作
  这不算是一个问题，只算是给大家的一个提醒。如果你是现场面试的话，有时候是会被要求手写SQL的，所以你对于groupBy，orderBy，子查询之类的基础肯定是要会的。。。不然写一个简单的sql你都不会，估计直接就凉了。推荐你们看一下《MySQL必知必会》，我觉得这本书算是比较基础，比较容易上手。

- ```sql
  # design
  CREATE DATABASE /*!32312 IF NOT EXISTS*/`homework_1` /*!40100 DEFAULT CHARACTER SET utf8 */;
  
  USE `homework_1`;
  
  /*Table structure for table `agent` */
  
  DROP TABLE IF EXISTS `agent`;
  
  CREATE TABLE `agent` (
    `aid` varchar(60) DEFAULT NULL,
    `aname` varchar(80) DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
  /*Data for the table `agent` */
  
  insert  into `agent`(`aid`,`aname`) values ('1','AAA'),('2','BBB'),('3','CCC'),('4','DDD'),('5','EEE'),('6','FFF'),('7','GGG'),('8','HHH'),('9','III'),('10','JJJ');
  
  /*Table structure for table `deal` */
  
  DROP TABLE IF EXISTS `deal`;
  
  CREATE TABLE `deal` (
    `sid` varchar(60) DEFAULT NULL,
    `pid` varchar(60) DEFAULT NULL,
    `volume` varchar(60) DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
  /*Data for the table `deal` */
  
  insert  into `deal`(`sid`,`pid`,`volume`) values ('5','1','48'),('7','8','23'),('4','7','134'),('1','9','234'),('2','5','75'),('3','2','76'),('8','10','342'),('6','6','66'),('10','3','43'),('9','4','54'),('3','6','235'),('4','2','156'),('10','2','4'),('2','7','135'),('3','8','45'),('8','6','67'),('9','2','104'),('11','7','152');
  
  /*Table structure for table `production` */
  
  DROP TABLE IF EXISTS `production`;
  
  CREATE TABLE `production` (
    `pid` varchar(60) DEFAULT NULL,
    `pname` varchar(60) DEFAULT NULL,
    `pdate` date DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
  /*Data for the table `production` */
  
  insert  into `production`(`pid`,`pname`,`pdate`) values ('1','A','2016-04-05'),('2','B','2016-05-07'),('3','C','2016-07-08'),('4','D','2017-03-06'),('5','E','2017-09-10'),('6','F','2017-12-02'),('7','G','2017-12-09'),('8','H','2018-10-02'),('9','IJ','2019-10-01'),('10','J','2017-12-01');
  
  /*Table structure for table `sales` */
  
  DROP TABLE IF EXISTS `sales`;
  
  CREATE TABLE `sales` (
    `sid` varchar(60) DEFAULT NULL,
    `sname` varchar(60) DEFAULT NULL,
    `aid` varchar(60) DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
  /*Data for the table `sales` */
  
  insert  into `sales`(`sid`,`sname`,`aid`) values ('3','c','3'),('4','d','4'),('5','e','5'),('6','f','6'),('7','g','7'),('8','h','8'),('9','i','9'),('10','j','10'),('1','a','1'),('2','b','2'),('11','y','2');
  
  #pid+sid作为主键，第一题销售量与第二题总销量不同，总销售是同一商品销售量的累计结果
  
  #1. 查询销售量最高的产品的前两名（pname，volume）
  SELECT p.pname, d.volume 
  FROM production p, deal d 
  WHERE d.pid = p.pid 
  ORDER BY CAST(d.volume AS SIGNED) DESC 
  LIMIT 2;
  #2. 查询2017年生产的产品的总销量（pname，volume）
  SELECT p.pname,SUM(d.volume) AS volume 
  FROM production p, deal d 
  WHERE YEAR(pdate) = 2017 AND p.pid = d.pid 
  GROUP BY p.pid;
  #3. 查询产品编号为2且销售量超过100的销售人员的姓名及所在的公司（sname，aname）
  SELECT s.sname, a.aname 
  FROM deal d, agent a, sales s 
  WHERE s.aid = a.aid AND d.sid = s.sid AND d.pid = 2 AND d.volume > 100;
  #4. 查询所有代理商所有产品的销量（aname，pname，volume）
  SELECT a.aname, p.pname, SUM(d.volume) AS volume 
  FROM agent a, production p, deal d, sales s 
  WHERE a.aid = s.aid AND p.pid = d.pid AND d.sid = s.sid 
  GROUP BY a.aid, d.pid;
  #5. 查询每个产品有多少个销售人员在销售（pname，scount（计数））
  SELECT p.pname, COUNT(*) AS scount 
  FROM production p, deal d 
  WHERE p.pid = d.pid 
  GROUP BY d.pid;
  #6. 查询名称包含BBB的代理商中的所有销售人员（aname，sname）
  SELECT a.aname, s.sname 
  FROM agent a, sales s 
  WHERE a.aid = s.aid AND a.aname LIKE binary "%BBB%";
  #7. 查询总销量最差的产品（pname，volume）
  SELECT p.pname, SUM(d.volume) AS volume 
  FROM production p, deal d 
  WHERE d.pid = p.pid 
  GROUP BY p.pid 
  ORDER BY CAST(SUM(d.volume) AS SIGNED) ASC 
  LIMIT 1;
  #8. 查询每种产品销售总量最高的销售人员（pname，sname，volume）
  SELECT p.pname, s.sname, d.volume 
  FROM deal d, sales s, production p 
  WHERE d.pid = p.pid AND s.sid = d.sid 
  AND NOT EXISTS(
  SELECT * FROM deal d2 
  WHERE d2.pid = d.pid AND d2.sid <> d.sid AND CAST(d2.volume AS SIGNED) > CAST(d.volume AS SIGNED)
  );
  ```



- 什么是左连接，什么是右连接，什么是全连接，什么是内连接？
  这个知识点太基础了，我就不说了，不会的自己去查。。。

- 内连接 inner join on 

  ```sql
  select * from a_table a inner join b_table b on a.a_id = b.b_id;
  ```

  组合两个表的记录，返回关联字段相符的记录，也就是返回两个表的交集（阴影）部分

- 左连接 left join on / left outer join on 外连接的一种

  ```sql
  select * from a_table a left join b_table bon a.a_id = b.b_id;
  ```

  左表的记录a_table全部表示出来，右表b_table只会显示符合搜索条件的记录。右表记录不足的地方均为null

- 右连接 right join on

  ```sql
  select * from a_table a right outer join b_table b on a.a_id = b.b_id;
  ```

  与左连接相反

- 全连接 **union**

  ```sql
  (select colum1,colum2...columN from tableA ) union (select colum1,colum2...columN from tableB )
  ```

  ?



- 数据库的事务有哪些特性？
  主要有四个特性，ACID，原子性(Atomicity)、一致性(Consistency)、隔离性(Isolation)、持久性(Durability)。如果你觉得这四个特性你无法理解的话，你直接背下来这四个词就行了，然后对隔离性做深入一点的理解，其他的基本上不会被问。
- 隔离性：指的是在并发环境中，当不同的事务同时操纵相同的数据时，每个事务都有各自的完整数据空间。由并发事务所做的修改必须与任何其他并发事务所做的修改隔离。事务查看数据更新时，数据所处的状态要么是另一事务修改它之前的状态，要么是另一事务修改它之后的状态，**事务不会查看到中间状态的数据**。
- 日志保证原子性、一致性、持久性
- 锁机制实现隔离性。当多个事务同时更新数据库中相同的数据时，只允许持有锁的事务能更新该数据，其他事务必须等待，直到前一个事务释放了锁，其他事务才有机会更新该数据。
- 隔离级别有四个：
- - 脏读：脏数据是未提交的数据。一个事务正在对数据进行修改，在未提交之前数据待定，若此时第二个事务来读这条未提交的数据，机会产生未提交的数据依赖关系。
  - 不可重复读：一个事务在两次读取之间，该数据会被其他事务修改
  - 幻读：一个事务按相同的查询条件重新读取以前检索过的数据，却发现其他事务插入了满足其查询条件的新数据
  - 串行读：完全的串行读。读写相互会阻塞，完全串行，无并行。
- mysql默认的事务处理级别是'REPEATABLE-READ',也就是可重复读；
- oracle数据库支持READ COMMITTED 和 SERIALIZABLE这两种事务隔离级别。
- 默认系统事务隔离级别是read committed,也就是读已提交



- 数据库中的隔离等级有哪些？
  基本问完你数据库事务有什么特性之后，接下来就是问隔离等级。隔离等级就是咱们上面说的隔离性的拓展。
  在学习隔离等级之前，你需要先去了解什么是脏读、不可重复读、幻读。之后你就知道mysql的四个隔离等级分别起到什么作用，oracle的两个隔离等级起到什么做什么。作为拓展，你可以记住mysql的默认隔离等级是什么，oracle的默认隔离等级是什么。我当时面试阿里的时候就连默认等级都给面试官背出来了。。。我估计面试官自己都没记住默认等级。



- 数据库的索引有什么作用？用什么来实现的？
  这个问题我觉得三次面试会被问到一次，基本上也是被问烂了。索引是用来加快查找速度的。目前在数据库中一般是使用B+树来实现索引的。



- B树和B+树有什么区别？为什么索引不用B树
  这个问题我是在阿里三面的时候被问的，而且感觉其他人也被问过这个问题。这个问题你需要去了解B+和B树具体结构上有什么区别，但是相对还是难一点的，如果觉得自己不想了解那么深入可以不去看。总体上来说，B+树在非叶子结点不保存数据，只在叶子结点保存。而B树在叶子结点和非叶子结点都会保存。这种结构导致你如果用B树来进行查询，会增加磁盘IO的次数，导致性能不如B+树。



- 什么是乐观锁，什么是悲观锁？
  这个问题很常问，自己去查一下

- **乐观锁 Optimistic Lock**

  **假设不会发生并发冲突，只在提交操作时检查是否违反数据完整性**。适用于读多写少的应用场景，可以提高吞吐量——每次拿数据的时候都认为别人不会修改，所以不会上锁，但是在提交更新的时候回判断一下在此期间别人有没有去更新这个数据。

  两种实现方式

  1. 使用数据版本*Version*记录机制实现（最常见），为数据增加一个版本标识，一般是通过为数据库表增加一个数据类型的“version”字段来实现。数据每更新一次，version字段+1.
  2. 使用时间戳*timestamp*。也是为数据增加一个字段，但是字段类型使用时间戳*timestamp*

  提交更新是，将version或timestamp进行比对，如果相等则更新，若不同则为**版本冲突**。

  **悲观锁 Pessimistic Lock**

  **假定会发生并发冲突，只在提交操作时检查是否违反数据完整性**。每次去拿数据的时候都认为别人会修改，每次拿数据都会上锁，这样别人想拿这个数据的时候会block直到它拿到锁。

  java synchronized，每次线程要修改数据时都先获得锁，保证同一时刻只有一个线程能操作数据，其他线程会被block.



- SQL编译的过程大概是什么样的？（这一点可不看，算是偏门）
  这个其实是一个很有意思的问题。当时有一个面试官问我说，你直接写一堆的sql来进行数据的处理，和用一个存储过程来进行数据的处理，哪个性能更好一些。我当时没回答上来，后来面试官逐步引导我，我才回答上来的。存储过程是会在数据库中先进行编译的，所以你使用存储过程直接调用就可以了。而你如果直接写一堆的SQL语句的话，比存储过程多了一个编译的过程，所以存储过程性能好一点。然后由这个问题延伸出来一个有意思的问题。如果你了解过一些网络安全方面的知识，那你应该就听过SQL注入攻击。防止SQL注入，在jdbc中一种有效的方法就是使用prepareStatement，prepareStatement其实就是使用了预编译的方式来防止SQL注入的。



### **操作系统**

操作系统我觉得常问的也就那几个问题，一般面试官自己对于操作系统底层也不是特别懂，我这里只说几个常被问的。

- 进程和线程的区别是什么？
  这个问题基本上已经被问烂了，你肯定得会的。进程是CPU分配资源的最小单元，线程是CPU调度的基本单元、一个进程可以包含多个线程、巴拉巴拉。如果你觉得这个概念在你心里不是特别清楚的话，一定要到网上看一下，最好能够理解为什么有些时候要使用线程不使用进程。因为进程启动的时候cpu需要给他分配资源，对系统压力比进程大，你可以把线程看成是轻量级的进程。





- 进程间通信的方式有什么？线程间通信的方式有什么？
- 管道
- FIFO 命名管道
- 消息队列
- 信号量
- 共享内存
- 这也是一个被问烂的问题。进程间通讯可以通过socket，管道，信号，消息，共享内存等多种方式。线程间通信就比较简单了，直接共享变量也行，通过管道也行。



- 什么是缓存？有哪些缓存的更新算法？
- 数据交换的缓存区
- 原始数据缓存：存储处理前的来源数据；对结果数据缓存：只存A+B的结果数据
- 算法：FIFO、LRU 最近最少使用、LRU-K、Two queue、Multi Queue
- CPU寄存器 > CPU高速缓存Cache > 计算机主存（内存）> 硬盘
- 这个太基础了。。。肯定得会的，缓存的更新算法用的最多的应该就是LRU。



- 你用过什么linux命令？
  其实我用shell算是比较少的，但是一些基本上命令例如cd、ps、vim之类的。。。还是得懂的。如果你和我一样知道的不是很多应该也没关系，你记住几个最常用的，和面试官扯一扯就行了。。。你就说我用过巴拉巴拉，但是对于其他命令，其实我用得还是比较少的，因为比较少在linux上开发。我觉得你这样面试一般也会放过你的。

### **数据结构与算法**

这一个我觉得没有什么通用的题目，但是我还是说一下需要准备的知识以及如何准备。

- 数据结构的话，链表，树，图的基本知识得懂
- 了解树的先序遍历，中序遍历，后序遍历。图的广度优先搜索算法，深度优先搜索算法。
- 如果你是准备笔试算法题的话，我建议你先刷剑指offer，然后再去刷leetCode。刷的时候一定要直接在编辑器上写代码，不要用任何ide，因为有些笔试环境就是不允许你使用ide的。而且你如果是线下笔试，还需要直接在纸上写。所以，一定不要用任何IDE写算法题。
- 算法题中的重点应该是动态规划，主要是因为动态规划如果你能够找得到状态转移方程的话，那么代码行数会比较少的，所以动态规划适合被当作笔试题，这个要重点准备。

### **java知识**

Java知识要准备的太多了。。。我都有点儿不知道怎么说，我说一下常被问的吧。

- java虚拟机的内存如何划分的？
  主要划分为五个区域，方法区，本地方法栈，虚拟机栈，程序计数器，堆。大概就是这五个区域，一定要背下来。咱们的垃圾回收主要就是针对堆区来进行的，堆区又会被划分为新生代老年代。。。这个具体内容去看《深入理解Java虚拟机》这本书，我觉得这本书是必看的。
- java的垃圾回收算法有哪些？垃圾回收器有哪些？不同的垃圾回收器有什么区别？
  垃圾回收算法有 标记复制法，标记清除法 等。垃圾回收器最常被问的就是CMS和G1。scavage之类的回收器基本上不问。CMS在不同阶段使用串行或并发来做垃圾回收的，而且他和G1垃圾回收器有什么区别，这一块强烈建议去看《深入理解java虚拟机》这本书。我觉得你如果看完这本书，基本上所有虚拟机的问题都会了。
- voliatile和synchonized有什么区别？synchonized和jdk提供的Lock包又有什么区别？
  voliatile只能够保证可见性和有序性，不能保证原子性，synchonized是通过上锁来防治出现并发问题。具体实现原理看我刚才建议的那本书，我就不说了。jdk提供的Lock包相比于synchozied提供了更加多样化的锁机制，为什么多样化，自己去查一下资料就知道了。
- HashMap的原理是什么
  hashmap也是一个被问烂的问题，但是我这里进行一些拓展。基本上面试官最常问的就是hashmap是如何实现的，这个网上一查就知道了。但是一些深入一点的东西，如果你能够讲的话，是会有加分的。例如hashmap如何实现动态扩容，hashmap并不是线程安全的，在哪些情况下会出现线程安全的问题？那么哪一个提供了线程安全的map？他的锁机制是如何实现的？（它的锁机制并不是简单地直接把函数给锁住，而是通过分段来治理的，还是很有意思的）
- 常用的设计模式有哪些？
  这个地方你最少有说得出来单例模式、工厂模式、代理模式等，这些都是很常见的设计模式，而且这个问题也经常被问。
- Spring的AOP、IOC作用是什么？如何实现的。
  Spring是一个java web的框架，面试官特别喜欢问。但是问spring基本上也只围绕着这几个点，第一个是AOP、IOC的作用是什么，这个问题查一下就知道了。第二个是AOP、IOC是通过什么实现的？AOP是通过代理模式来实现的，IOC是通过单例模式+工厂模式来实现的。问得比较多的是AOP的实现方式，你如果回答代理模式一般就够了。作为拓展，你可以回答里面用到了动态代理，动态代理有两种方式，一种是jdk提供的，一种是cglib。。。然后你和面试官比较一下两种动态代理的区别，我觉得也是会有加分的。

### 设计模式





## java 基础

### 1. == 与 equals

`==`

- 基本类型——比较**值**是否相同
- 引用类型——比较**引用**是否相同

```java
String x = "string";
String y = "string";
String z = new String("string");
System.out.println(x==y); //true
System.out.println(x==z); //false
System.out.println(x.equals(y)); //true
System.out.println(x.equals(z)); //true
//x、y是同一引用，所以==也是true，但new String()重写开辟了内存空间，所以==结果为false
//equals比较的一直是值，所以为true
```

`equals`本质同`==`,若对一个类不重写，**`equals`比较的是对象的地址**, 但String和Integer等进行了重写，`equals`变成值比较，源码如下

```java
//这是未经重写的equals代码
public boolean equals(Object obj){
    return (this==obj);
}

//这是String重写过的equals
public boolean equals(Object anObject){
    if(this == anObject) return true;
    if(anObject instanceof String){
        String anotherString = (String)anObject;
        int n = value.length;
        if(n == anotherString.value.length){
            char v1[] = value;
            char v2[] = anotherString.value;
            int i = 0;
            while(n-- != 0){
                if(v1[i] != v2[i]) return false;
                i++;
            }
            return true;
        }
    }
    return false;
}
```

这提醒我们在构造自己的对象class且需要使用euqals比较时，不能直接继承自Object，而应该尽量**按需求重写**。



### 2. euqals() 与 hashCode()

两个对象的hashCode()相同，equals()不一定相同。hashCode()相等即两个键值对的哈希值相等，然而哈希值相等，并不一定能得出键值对相等。

```java
String str1 = "通话";
String str2 = "重地";
System.out.println(String.format("%d | %d", str1.hashCode(), str2.hashCode())); //1179395 | 1179395
System.out.println(str1.equals(str2));//false
```

在HashMap中，若要比较key是否相等，要同时使用这两个函数。

自定义类的hashCode()方法继承自Object类，其hashcode码为默认的内存地址，这样即使有相同含义的两个对象，比较也是不相等的。



Object的hashCode()是本地方法，该方法直接返回**对象的内存地址**。



### 3. map分类和常见使用情况

Java为图的映射定义了一个接口 `java.util.Map`,分为四个实现类HashMap Hashtable LinkedHashMap TreeMap

| Map           | 存储键值对，根据键得到值，因此不允许键重复，但允许值重复     | 适用情况                        |
| ------------- | ------------------------------------------------------------ | ------------------------------- |
| HashMap       | 最常用，根据键的HashCode值存储数据，根据键直接获取它的值，具有很快的访问速度。遍历时，取得数据的顺序是**完全随机**的。HashMap最多只允许一条记录的键为Null；允许多条记录的值为Null。HashMap**不支持线程的同步**，即任意时刻可以有多个线程同时写HashMap；**可能导致数据的不一致**。如果需要同步，可以用Collections的**synchronizedMap方法**使HashMap具有同步的能力；或改用**ConcurrentHashMap** | 最常用，在Map中插入删除定位元素 |
| HashTable     | y与HashMap类似，继承自Dictionary类。不同点：**不允许记录的键和值为Null**；支持线程的同步，虽然保持了数据的一致性，但**写入时会比较慢**。 |                                 |
| LinkedHashMap | HashMap的一个子类，**保存了记录的插入顺序**，在用Iterator遍历LinkedHashMap时，先得到的记录一定是先插入的，但遍历比HashMap慢。但**LinkedHashMap的遍历速度只和实际数据有关，和容量无关；HashMap的遍历速度和他的容量有关**。 | x需要输出的顺序和输入的相同     |
| TreeMap       | 实现SortMap接口，能够把它保存的记录根据键**排序**，默认是按键值升序排序，也可以指定排序的比较器——**用Iterator遍历TreeMap时，得到的记录是排过序的**。 | 按自然顺序或自定义顺序遍历键    |



### 4. Lamda表达式

优点

1. 简洁
2. 非常容易并行运算

缺点

1. 如不用并行计算，很多时候计算速度没有比传统的for循环快（并行计算有时也需要预热才能显示出效率优势）
2. 不容易调试
3. 不容易被看懂

```shell
Lambda> I = \x.x
Lambda> I a
a
Lambda> SWAP = \x.\y.y x 
Lambda> SWAP a b 
b a
Lambda> S = \x.\y.\z.x z(y z) 
Lambda> S a b c
a c (b c)
Lambda> l = S I
Lambda> l m n
n (m n)

# 模拟自然数
Lambda> ZERO = \f.\x.x 
Lambda> SUCC = \n.\f.\x.f (n f x)
# 模拟逻辑
Lambda> TRUE = \x.\y.x 
Lambda> FALSE = \x.\y.y
# 模拟谓词
Lambda> ISZERO = \n.n (\x.FALSE) TRUE 
Lambda> LEQ = \m.\n.ISZERO (SUB m n) 
Lambda> EQ = \m.\n. AND (LEQ m n) (LEQ n m)
# 模拟函数
Lambda> MAX = \m.\n.IF (LEQ m n) n m 
Lambda> MAX ONE TWO 
\f.\x.f (f x)
```



### 5. 数据类型

byte	short	int	long	float	double	boolean	char

自动装箱：Java编译器在基本数据类型和对应的对象包装类型之间做一个转化。比如int转化成Integer，double转化成Double；反之就是自动拆箱。



java.lang.String不是基本数据类型，String类是final类型，因此不可以继承、修改这个类。为了节省空间提高效率，应用**StringBuffer**类

String与StringBuffer的区别：

- String类提供可数值不可改变的字符串。
- StringBuffer类提供的字符串可以进行修改。

Array和ArrayList区别：

- Array可以包含基本类型和对象类型，ArrayList只能包含对象类型
- Array大小是固定的，ArrayList的大小是动态变化的
- ArrayList提供更多的方法和特性。如addAll(), removeAll(), iterator()等

引用类型、原始类型

- 引用类型和原始类型的行为完全不同，并且具有不同的语义。

- 引用类型和原始类型具有不同的特征和用法——大小和速度。这种类型以哪种类型的数据结构存储

- 对象引用实例变量的缺省值为null，而原始类型实例变量的缺省值与它们的类型有关。

- ```java
  boolean	char	byte	short	int	long	float	double
  Boolean	Character	Byte	Short	Integer	Long	Float	Double
  
  class AutoUnboxingTest{
  	public static void main(String [] args){
  		Integer a = new Integer(3);
  		Integer b = 3;
  		int c = 3;
  		System.out.println(a==b); //false，两个引用没有引用统一对象
  		System.out.println(a==c); //true，a自动拆箱成int类型
  	}
  }
  ```

一个例子，输出某种编码的字符，如iso8859-1等，如何输出一个某种编码的字符串？

```java
public String translate(String str){
    String tempStr = "";
    try{
        tempStr = new String(str.getBytes("iso8859-1"), "GBK");
        tempStr = tempStr.trim();
    }
    catch(Exception e){
        System.err.println(e.getMessage());
    }
    return tempStr;
}
```



### 4. Java和JavaScript

- **基于对象与面向对象**：java是一种真正的面向对象的语言，**必须设计对象**。JavaScript是种脚本语言，基于**对象(Object-Based)和事件驱动(Event-Driven)**的编程语言，本身提供了非常丰富的内部对象供设计人员使用。
- **解释和编译**：Java源代码在执行前，**必须经过编译**。JavaScript是解释性编程语言，源代码由浏览器解释执行（目前浏览器几乎都使用**JIT即时编译**技术来提升运行效率）
- **强类型变量和弱类型变量**：Java采用强类型变量检查，即**所有变量在编译之前必须作声明**。JavaScript中变量是弱类型，甚至**在使用变量前可以不做声明，解释器在运行时检查推断其数据类型**。
- 代码格式不一样



### 5. Java的正则表达式操作

Java中的String类提供了支持**正则表达式**操作的方法，包括matches()	replaceAll()	replaceFirst()	split()

Java中可以用Pattern类表示正则表达式对象，用具体式子表达

```java
import java.util.regex.Matcher;
import Java.util.regex.Pattern;
class RegExpTest {
    public static void main(String [] args){
        String str = "南京市(栖霞区)(玄武区)(鼓楼区)";
        Pattern p = Pattern.comple(".*?(?=\\()");
        Matcher m = p.matcher(str);
        if(m.find()){
            System.out.println(m.group());
        }
    }
}
```



## 关键字

### 1. syncronized、lock

syncronized是Java的关键字，当它用来修饰一个方法或者一个代码块时，**能够保证在同一时刻最多只有一个线程执行该段代码**。

Lock是一个接口，而syncronized是Java中的关键字，syncronized是内置的语言实现；

syncronized在发生异常时，会自动释放线程占有的锁，因此不会导致死锁现象发生；

而Lock发生异常时，如果没有主动通过unLock()去释放锁，则很有可能造成死锁现象，因此使用Lock时需要在finally块中释放锁；

Lock可以让等待锁的线程响应中断，而synchronized却不行，使用syncronized等待的线程会一直等待下去，不能够响应中断；

通过Lock可以知道有没有成功获取锁，而syncronized无法办到。



### 2. volatile关键字

volatile关键字是用来保证**有序性**和**可见性**。这与Java内存模型有关。比如我们所写的代码，不一定是按照我们自己书写的顺序来执行，编译器会做重排序，CPU也会做重排序，这种重排序是为了**减少流水线的阻塞**，引起流水阻塞，比如数据相关性，提高CPU的执行效率。这需要有一定的顺序和规则来保证，不然程序员自己写的代码不知道对不对，所以必须有**happens-before规则**

其中有条就是**volatile变量规则**：对一个变量的写操作先行发生于后面对这个变量的读操作。**有序性：**实现的是通过**插入内存屏障**来保证的。**可见性**：首先Java内存模型分为，主内存、工作内存。比如线程A从主内存把变量从主内存读到了自己的工作内存中，做了+1的操作，但是此时没有将i的最新值刷新到主内存中，线程B此时读到了还是i的旧值。

加了volatile关键字代码生成的汇编代码发现，会多出一个lock前缀指令。Lock指令对Intel平台的CPU，早期是锁总线，这样代价太高，后面提出了缓存一致性协议、MESI，来**保证了多核之间数据不一致性问题**。



### 3. final关键字





## 面向对象

### 1. Java特性

封装

继承

多态：允许不同类的对象对同一消息做出响应。即同一消息可以根据发送对象的不同而采用不同的行为方式。（发送消息就是函数调用）



### 2. String StringBuffer StringBuilder

String属于不可变对象：**一个对象的状态在对象被创建之后就不再变化**。即不能改变对象内的成员变量，包括基本数据类型的值不能改变，引用类型变量不能指向其他的对象，引用类型指向的对象的状态也不能改变。

String不能被继承，char数据用final修饰

StringBuffer线程安全，StringBuffer线程不安全，底层实现上，StringBuffer其实就是比StringBuilder多了synchronized修饰符。



### 3. 类和对象的区别

- 类是对某一类事物的描述，是抽象的。对象是一个实实在在的个体，是类的一个实例。class :人  实例 : 教师
- 对象是**函数、变量的集合体**。类时一组函数和变量的集合体，即类是**一组具有相同属性的对象集合体**。



### 4. Object类的方法

- Object() 默认构造方法
- clone() 创建并返回此对象的一个副本
- equals(Object obj) 某个其他对象是否与此对象“相等
- finalize() 当垃圾回收器不存在对该对象的更多引用时，由对象的垃圾回收器调用此方法
- getClass() 返回一个对象的运行时类
- notify() 唤醒在此对象监视器上等待的单个线程
- notifyAll() 唤醒在此对象监视器上等待的所有线程
- toString() 返回该对象的字符串显示
- wait() 导致当前线程等待，知道其他线程调用此对象的notify() notifyAll()方法
- wait(long timeout) 导致当前线程等待，知道其他线程调用此对象的notify() notifyAll()方法；或者超过指定时间量timeout
- wait(long timeout, int nanos)导致当前线程等待，知道其他线程调用此对象的notify() notifyAll()方法；或者超过指定时间量timeout；或是其他某个线程中断当前线程



### 5. 重载和重写

**重载Overloading**

1. 方法重载是让类以统一的方式处理不同类型数据的一种手段。多个同名函数同时存在，具有不同的参数个数、类型。

   Overloading是一个类中**多态性的一种表现**。

2. Java的方法重载，就是在类中可以创建多个方法，他们具有相同的名字，但是**具有不同的参数和不同的定义**。

   **调用方法时通过传递给它们的不同参数个数和参数类型来决定具体使用哪个方法**，这就是多态性。

3. 重载的时候，**方法名要一样，但参数类型和个数不一样，返回值类型可以相同or不同**。无法以返回类型作为重载函数的区分标准。

**重写Overriding**

1. **父类与子类之间的多态性，对父类的函数进行重新定义**。如果在子类中定义某方法与其父类有相通的名称和参数，该方法即被重写。或称方法覆盖。

2. 若子类中方法与父类中某一方法具有相同的方法名、返回类型和参数表，则新方法将覆盖原有的方法。

   如需父类中原有方法，可使用super关键字，该关键字直接引用当前类的父类

3. 子类函数的**访问修饰权限不能少于父类**的。



### 6. static

static 表明**一个成员变量或是一个成员方法可以在没有所属的类的实例变量的情况下被访问**。

java中的static方法不能被覆盖。因为方法覆盖是基于运行时动态绑定的，而static方法时**编译时静态绑定**的。static方法跟类的任何实例都不相关。

static变量存在方法区。

static变量在java中是属于类的，它在所有实例中的值是一样的。当类被Java虚拟机载入时，会对static变量进行初始化。如果**不用实例来访问非static的变量，编译器会报错**。因为非static变量还没被创建出来。



### 7. 类加载机制、双亲委派模型

?



### 8. 泛型

泛型，即“**参数化类型**”。

参数——定义方法时的形参，调用该方法时传递实参。

参数化类型——讲类型由原来具体的类型参数化，类似于方法中的变量参数，此时类型也定义成参数ixngshi，在使用调用时传入具体的类型（类型实参）。

```java
public class GenericTest{
    public static void main(String [] args){
 
        List<String> list = new ArrayList<String>();
        list.addlist.add("121");
        list.add("ccc");
        //list.add(100); // 1 
        for(int i=0 ; i<list.size() ; i++)
        {
            String name = list.get(i); // 2
            System.out.println("name" + name);
        }
    }
}
```



### 9. extends super泛型限定符

1. 泛型中上界和下界的定义
   - 上界 <? extend Fruit>
   - 下界 <? super Apple>
2. 上界和下界的特点
   - 上届的list只能get，不能add
   - 下界的list只能add，不能get

```java
import java.util.ArrayList;
import java.util.List;

class Fruit {}
class Apple extends Fruit {}
class Jonathan extends Apple {}
class Orange extends Fruit {}

public class CovariantArrays {
    public static void main(String [] args){
        //上界
        List<? extend Fruit> flistTop = new ArrayList<Apple>();
        flistTop.add(null); 
        //flistTop.add(new Fruit()); //add Fruit对象会报错
        Fruit fruit1 = flistTop.get(0);
        
        //下界
        List<? super Apple> flistBottem = new ArrayList<Apple>();
        flistBottem.add(new Apple());
        flistBottem.add(new Jonathan());
        //Apple apple = flistBottem.get(0); //get Apple对象会报错
    }
}
```

3. 上界<? extend Fruit>，**表示所有继承Fruit的子类**，但具体是哪个子类，无法确定，所以调用add的时候，要add什么类型，谁也不知道。但是get的时候，不管是什么子类，不管追溯多少辈，必定有个父类是Fruit，所以也就是**把所有子类向上转型为Fruit**；

   Fruit可get，不可add，add相应子类。

4. 下界<? super Apple>，**表示Apple的所有父类**，包括Fruit，一直可以追溯到Object！当我add时，我不能add Apple的父类，因为不确定List里面存放的到底是哪个父类。但可以add Apple及其子类。因为不管我的子类是什么类型，它都可以向上转型为Apple及其所有的父类甚至转型为Object。



### 10. 反射对应的关键字

**创建对象**

1. 通过类对象调用newInstance()方法，例如：String.class.newInstance()
2. 通过类对象的getConstructor()/ getDeclaredConstructor()方法获取构造器对象并调用其newInstance()方法创建对象，例如：String.class.getConstructor(String.class).newInstance("Hello");



### 11. 接口与抽象类的区别

接口与抽象类的实现具有共同点，但是存在很多不同点

- 接口所有方法隐含的都是抽象的。而抽象类则可以同时包含抽象和非抽象方法
- 类可以实现很多个接口，但只能继承一个抽象类
- 类可以不实现抽象类合和接口声明的所有方法，此时类也应当是抽象的。
- 抽象类可以在不提供接口方法实现的情况下实现接口
- Java接口中声明的变量默认都是final的。抽象类可以包含非final变量
- Java接口中成员函数默认是public的。抽象类的成员函数可以是private、protected或者public
- 接口是绝对抽象的，不可被实例化。抽象类也不可被实例化，但是若包含main方法则可以被调用



### 12. Comparable和Comparator接口的区别

Java提供了只包含一个compareTo()方法的Comparable接口，用以给两个对象排序。

Java提供了包含compare()和equals()两个方法的Comparator接口



### 13. 面向对象的特征

#### 1. 抽象

- 过程抽象
- 数据抽象

#### 2. 继承

一种连接类的层次模型，并且允许和鼓励类的重用。提供了一种明确表述共性的方法。

对象的一个新类可以从现有的类中派生，这个过程称为类继承。新类继承了原始类的特性，新类称为原始类的子类，原始类称为新类的父类。

#### 3. 封装



#### 4. 多态性