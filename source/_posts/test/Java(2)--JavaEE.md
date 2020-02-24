---
title: Java(2)--JavaEE
date: 2018-12-30 15:48:24
tags: [java]
copyright: false
categories: java
---

@[toc]



## RMI Remote Method Invoke

对象的序列化——对象的序列化就是将你程序中实例化的某个类的对象，比如，你自定一个类MyClass，或者任何一个类的对象，将它转换成字节数组，也就是说可以放到一个byte 数组中，这时候，你既然已经把一个对象放到了byte数组中，那么你当然就可以随便处置了它了，用得最多的就是**把他发送到网络上远程的计算机上**了。用java.io包里的字节流类等。

RPC，远程过程调用，本地计算机调用远程计算机上的一个函数。





用对象序列化来实现远程调用，一台机器上的程序调用另一台机器上的方法。

> The **Java Remote Method Invocation** (**Java RMI**) is a Java API that performs remote method invocation, the object-oriented equivalent of remote procedure calls (RPC), with support for direct transfer of serialized Java classes and distributed garbage collection.
>
> 1. The original implementation depends on Java Virtual Machine(JVM) class representation mechanisms and it thus only supports making calls from one JVM to another. The protocol underlying this Java-only implementation is known as Java Remote Method Protocol (JRMP).
> 2. In order to support code running in a non-JVM context, a CORBA version was later developed.

RMI让运行在不同计算机上的对象之间的调用表现得像本地调用一样。分为服务器程序和客户机程序。

RMI将行为的定义与行为的实现分别定义，并允许将行为定义代码与行为实现代码存放并运行在不同JVM上。

**远程服务的定义**存放在继承了Remote的接口中，**远程服务的实现代码**存放在实现该定义接口的类中。

RMI支持两个类实现一个相同的远程服务接口：一个类实现行为并运行在服务器上，另一个类作为远程服务的代理运行在客户机上。——客户程序发出关于代理对象的调用方法，RMI将该调用请求发送到远程JVM上，并进一步发送到实现的方法中。实现方法将结构发送给代理，再通过代理将结果返回给调用者。



**当客户端调用远程对象方法时, 存根负责把要调用的远程对象方法的方法名及其参数编组打包,并将该包向下经远程引用层、传输层转发给远程对象所在的服务器。通过 RMI 系统的 RMI 注册表实现的简单服务器名字服务, 可定位远程对象所在的服务器。该包到达服务器后, 向上经远程引用层, 被远程对象的 Skeleton 接收, 此 Skeleton 解析客户包中的方法名及编组的参数后, 在服务器端执行客户要调用的远程对象方法, 然后将该方法的返回值( 或产生的异常) 打包后通过相反路线返回给客户端, 客户端的 Stub 将返回结果解析后传递给客户程序。**

![img](https://images2015.cnblogs.com/blog/735119/201603/735119-20160319210716896-1990636233.jpg)

### 例子

![img](https://images2015.cnblogs.com/blog/735119/201603/735119-20160319213522178-2046114770.png)



### 我自己的例子

```java
/**
 *@Description: 远程接口实现
 */
public class DataRemoteObject extends UnicastRemoteObject implements  
 UserDataService, CustomerDataService,
 StockDataService, LogDataService, 
 SalesStrategyDataService,
 AccountDataService, StartAccountDataService, 
 SalesAndPurchaseBillDataService, SalesAndPurchaseItemDataService, 
 StockAlarmBillDataService, StockGiftBillDataService, StockLossBillDataService, StockOverflowBillDataService,
 PayAndReceiveBillDataService, PayAndReceiveItemDataService, 
 CashBillDataService, CashItemDataService,
 BillHelperDataService{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4029039744279087114L;
	private UserDataService userDataService;    
		private CustomerDataService customerDataService;
		private StockDataService stockDataService;
		private LogDataService logDataService;
		
		private AccountDataService accountDataService;
		private StartAccountDataService startAccountDataService;
		
		private BillHelperDataService billHelperDataService;
		
		private PayAndReceiveBillDataService payAndReceiveBillDataService;
		private PayAndReceiveItemDataService payAndReceiveItemDataService;
		private CashBillDataService cashBillDataService;
		private CashItemDataService cashItemDataService;
		
		private SalesAndPurchaseBillDataService salesAndPurchaseBillDataService;
		private SalesAndPurchaseItemDataService salesAndPurchaseItemDataService;
		
		private StockAlarmBillDataService stockAlarmBillDataService;
		private StockGiftBillDataService stockGiftBillDataService;
		private StockLossBillDataService stockLossBillDataService;
		private StockOverflowBillDataService stockOverflowBillDataService;
		
		private SalesStrategyDataService salesStrategyDataService;
		
		public DataRemoteObject() throws RemoteException {
			userDataService = new UserDataServiceImpl();
			customerDataService = new CustomerDataServiceImpl();
		}

		@Override
		public String getUserNewID(UserRole role) throws RemoteException {
			// TODO Auto-generated method stub
			return userDataService.getUserNewID(role);
		}
     	//...之后是一系列远程调用的方法
}

/**远程接口定义，有很多个，如上面implement所示，但这里只显示一个*/
package dataservice.billdataservice;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.Date;

import po.BillCategory;

public interface BillHelperDataService extends Remote{

	/**
	 * 根据账单名得到账单
	 * @author 钟镇鸿
	 * @param name
	 * @return 字符串
	 * */
	public String getNewID(BillCategory category, Date date) throws RemoteException;
}

/**服务器绑定*/
public class RemoteHelper {
	public RemoteHelper(){
		initServer();
	}
	
	public void initServer(){
	
		DataRemoteObject dataRemoteObject;
		try {
			dataRemoteObject = new DataRemoteObject();
			LocateRegistry.createRegistry(8880);
			Naming.bind("rmi://127.0.0.1:8880/DataRemoteObject",
					dataRemoteObject);
			System.out.println("Create Registry Server!");
		} catch (RemoteException e) {
			e.printStackTrace();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (AlreadyBoundException e) {
			e.printStackTrace();
		}
		
	}
	
}

/**客户端调用*/
public class ClientLink {
	private RemoteHelper remoteHelper;
	public ClientLink() {
		
		linkToServer();
	}
	
	private void linkToServer() {
		
		try {
			remoteHelper = RemoteHelper.getInstance();
			remoteHelper.setRemote(Naming.lookup("rmi://127.0.0.1:8880/DataRemoteObject"));
			System.out.println("linked");
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (RemoteException e) {
			e.printStackTrace();
		} catch (NotBoundException e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String [] args) {
		ClientLink l = new ClientLink();
	}
}

/**客户端实现调用*/
public class RemoteHelper {
	private Remote remote;
	private static RemoteHelper remoteHelper = new RemoteHelper();
	public static RemoteHelper getInstance(){
		return remoteHelper;
	}
	
	public void setRemote(Remote remote){
		this.remote = remote;
	}
	
	
	public UserDataService getUserDataService(){
		return (UserDataService)remote;
	}
	
	public CustomerDataService getCustomerDataService(){
		return (CustomerDataService)remote;
	}
    //...下面包含了一系列方法调用
}
```



## EJB

把编写的软件中需要执行制定的任务的类，不放在客户端软件上，而是打包放在服务器上。

在java中，能实现远程对象调用的技术是RMI，而EJB技术基础正是RMI。

但是ejb只需要定义远程接口不用生成实现类。

### ejb服务群集

将原来在一个计算机上运算的几个类，分别放到其他计算机上去运行，以便分担运
行这几个类所需要占用的CPU 和内存资源。同时，也可以将不同的软件功能模块放到不同的
服务器上，当需要修改某些功能的时候直接修改这些服务器上的类就行了，修改以后所有客
户端的软件都被修改了。



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



## MVC与DAO

### MVC各部分有哪些技术实现，如何实现

Model-View-Controller

Model——应用的业务逻辑（通过JavaBean，EJB组件实现）

View——应用的表示面，用于与用户的交互（JSP页面产生）

Controller——提供应用的处理过程控制（一般是一个Servlet）；model与view之间沟通的桥梁，可以分派用户的请求并选择恰当的视图用于显示，同时它也可以解释用户的输入并将它们映射为模型层可执行的操作



### 什么是DAO

DAO(Data Access Object)是一个**为数据库或其他持久化机制提供了抽象接口的对象，在不暴露底层持久化方案实现细节的前提下提供了各种数据访问操作**。

在实际的开发中，应该将所有对数据源的访问操作进行抽象化后封装在一个公共API中。——**建立一个接口，接口定义了此应用程序将会用到的事务方法**。在这个应用程序中，当需要和数据源进行交互的时候则使用这个接口，并且编写一个单独的类来实现这个接口，在逻辑上该类对应一个特定的数据存储。

DAO模式实际上包含两个模式：**Data Accessor** 数据访问器；**Data Object** 数据对象



### Model1 Model2

Model 1是以页面为中心的Java Web开发，使用JSP+JavaBean技术将页面显示逻辑和业务逻辑处理分开。

JSP实现页面显示，JavaBean对象用来保存数据和实现业务逻辑

Model2是基于MVC架构模式的开发模型，实现了模型和视图的彻底分离，利于开发。





## Hibernate

### 基本概念

ORM object relational mapping：用元数据来描述对象与关系映射的细节

主要框架有：Hibernate(Nhibernate)，iBATIS，mybatis，EclipseLink，JFinal



配置

1. **hibernate.properties文件作为配置文件**

   我的例子

   ```xml
   # IDENTITY (ContextIdApplicationContextInitializer)
   spring.application.index=Spring-boot-Hibernate.v1.1
   spring.application.name=Spring-boot-Hibernate
   
   #Server
   server.port=8080
   server.jsp-servlet.class-name=org.apache.jasper.servlet.JspServlet
   
   security.basic.enabled=false
   management.security.enabled=false
   
   #MVC
   spring.mvc.view.prefix=/WEB-INF/views/
   # spring.datasource.url=jdbc:mysql://sh-cdb-nkw1cg69.sql.tencentcdb.com:63086/test?useSSL\=false
   # spring.datasource.username=root
   # spring.datasource.password=uVSoj(Dw)5FM
   
   spring.datasource.url=jdbc:mysql://localhost:3306/crowdtag?useSSL\=false
   spring.datasource.username=root
   spring.datasource.password=1234
   spring.datasource.driver-class-name=com.mysql.jdbc.Driver
   
   # JPA (JpaBaseConfiguration, HibernateJpaAutoConfiguration)
   spring.data.jpa.repositories.enabled=true
   spring.jpa.generate-ddl=false
   # logging.config=classpath\:log4j2.xml
   spring.jpa.hibernate.ddl-auto=update
   spring.jpa.open-in-view=true 
   spring.jpa.show-sql=true
   
   ```

   

2. **hibernate.cfg.xml文件作为配置文件**



#### 基于Annotation的注解配置

##### 1. 类级注解

| 注解    | 作用                                         |
| ------- | -------------------------------------------- |
| @Entity | 只有一个属性name，作为实体名称，表到类的映射 |
| @Table  | 与@Entity联用，name属性指定映射的表名。      |

##### 2. 属性级注解

**@Id**  用在主键id属性上，或者getter方法上

**@GeneratedValue** 

- 指定主键的来源。属性strategy用于指定主键的生成策略。其值为系统定义好的四种策略之一。默认为AUTO。
- GenerationType.AUTO：在MySql中使用该策略，自动选择了Sequence生成方式。自动创建了序列表hibernate_sequence。
- GenerationType.IDENTITY：根据数据库的Identity字段生成。类似于配置文件中的identity生成策略。
- GenerationType.SEQUENCE：使用Sequence来决定主键的取值。类似于配置文件中的Sequence生成策略。
- Generation.TABLE：使用指定表来决定主键取值，结合@TableGenerator使用。
- 注解中的生成策略只有四种。若要使用Hibernate映射文件中的主键生成器，则可以使用@GenericGenerator指定一个Hibernate主键生成器，再使用@GenerateValue的属性generator来引用即可。

**@Column**

可将**属性映射到列**中，描述了数据库表中该字段的详细定义，字段包括

**@Version**：指定乐观锁字段

##### 3. 关联关系映射注解

**@OneToMany** 一对多关联关系

- targetEntity：指明该属性所关联的类。
- cascade：指定级联类型。其为数组，使用多种级联，则可使用{}赋值。其值为Cascade常量。
  - Cascade.All 所有
  - Cascade.DETACH 分离
  - Cascade.MERCH 修改
  - Cascade.PERSIST 保存
  - Cascade.REFRESH 刷新
  - Cascade.REMOVE 删除
- mappedBy：指定一对多的双向关系
  - 该属性与关联关系的维护权相关；
  - 该属性应放在**放弃维护权**一方；
  - 该属性值为对方的关联属性，表明以后的关联关系将由它来负责；
  - 该属性只可能在双向关联中使用；
  - 使用了该属性，**将不能够再使用@JoinColumn注解**。因为@JoinColumn注解表示其所注解的属性将来通过set方法设值后，会与DB中哪个字段相关联。

**@JoinColumn** 其name属性指定该属性关联的外键



**@ManyToOne**



**@ManyToMany**

- **多对多关联**使用@ManyToMany注解。其会**自动生成一个中间表**，表名为两个关联对象的映射表名的联合：表1_表2。只不过，谁在维护关联关系，谁的表名在前。
- 该中间表会包含两个字段，字段名与谁在维护关联关系相关。谁在维护关联关系，谁的表名将出现在第一个字段名中，而该类的关联属性名将出现在第二个字段名中。字段名分别为表名_id与关联属性名_id。
- 当然，默认的表名和字段名均可通过@JoinTable进行修改。



##### 4. 二级缓存注解@Cache

- 二级缓存，使用注解式开发，其注解主要替换的是配置文件中对类缓存对象以及集合缓存对象的指定配置。至于在主配置文件中开启二级缓存、注册二级缓存区域工厂，仍然还是需要的。
- 对于查询缓存，没有相应的注解。
- 对于类缓存和集合缓存的注解，主要使用@Cache注解。其由一个属性usage，用于指定二级缓存所使用的事务并发访问策略。其取值为一个枚举型CacheConcurrencyStrategy常值，该枚举常量具有5个常量值：
  1、NONE：不使用并发访问策略；
  2、NONSTRICT_READ_WRITE：非严格读写策略；
  3、READ_ONLY：只读策略；
  4、READ_WRITE：读写策略；
  5、TRANSACTIONAL：事务策略；



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



## Web编程原理

### http https



### forward转发 redirect重定位

forward：**服务器请求资源，服务器直接访问目标地址的URL，把那个URL的响应地址读取过来，然后把这些内容发给浏览器**，浏览器根本不知道服务器发送的内容来自哪，所以地址栏还是原来的地址。

redirect：**服务器端根据逻辑，发送一个状态码，告诉浏览器重新去请求那个地址**，一般来说，**浏览器会用刚才请求的所有参数重新请求**，故session、request参数都可以获取。



### 大型网站的架构问题



### J2EE

- Web容器：给在其中的应用程序组件（JSP, SERVLET）提供一个环境，**使JSP，SERVLET直接和容器中的环境变量接口交互，不必关注其他系统问题**，主要由web服务器实现。例如tomcat, weblogic, websohere等
- Web container：**实现J2EE体系结构中web组件协议的容器。**这个协议规定了一个web组件运行时的环境
- JNDI：JAVA命名目录服务。**提供一个目录系统让其他各地的应用程序在上面留下自己的索引，从而满足快速查找和定位分布式应用程序的功能。**
- JMS：JAVA消息服务。**主要实现各个应用程序之间的通讯**。包括点对点和广播。
- JTA：JAVA事务服务。**提供各种分布式事务服务。**应用程序只需调用其提供的接口即可。
- JAF：JAVA安全认证框架。提供一些安全控制方面的框架。让开发者通过各种部署和自定义实现自己的个性安全控制策略
- RMI/IIOP：





## 计算机网络

### 1. TCP和UDP

#### 1.1 TCP的连接和释放连接

假设主机A为客户端，主机B为服务器

三次握手

- 第一次，主机A向主机B发送tcp连接请求数据包，其中包括主机A的初始序列号seq(A)=x。（SYN=1， ACK=0， 表示这是一个TCP连接请求数据报文；序号seq=x，表明传输数据时的第一个数据字节的序号是x）
- 第二次，主机B收到请求后，会发回连接确认数据包。（SYN=1, ACK=1，表示这是一个TCP连接响应数据报文，并含主机B的初始序列号seq(B)=y，以及主机B对主机A初始序列号的确认号 ack(B)=seq(A)+1=x+1）
- 第三次，主机A收到主机B的确认报文后，还需做出确认，即发送一个序列号seq(A)=x+1；确认好为ack(A)=y+!的报文

四次挥手——全双工连接，因此每个方向必须单独进行关闭。这个原则是当一方完成它的数据发送任务后就能发送一个FIN来终止这个方向的连接。收到一个FIN只代表一个方向没数据流动。

- 关闭客户端到服务器的连接：首先A发送一个FIN，用来关闭客户到服务器的数据传送，然后等待服务器的确认。其中终止标志位FIN=1，序列号seq=u
- 服务器收到这个FIN，它发回一个ACK，确认ack号为收到的序号+1
- 关闭服务器到客户端的连接：即发送一个FIN给哭护短
- 客户端收到FIN后，发回一个ACK报文确认，并将确认序号seq设置为收到序号+1.
- 首先进行关闭的一方将执行主动关闭，而另一方执行被动关闭



#### 1.2 tcp可靠传输

建立全双工连接；三次握手，超时重传，滑动窗口，拥塞控制



### 2. http https

区别

- https协议需要ca 证书颁发机构 申请证书
- http是超文本传输协议，信息是明文传输的。https是ssl（Secure Sockets Layer 安全套接层，是为网络通信提供安全和数据完整性的一种安全协议）加密传输协议
- 连接方式完全不同，http是客户端和服务器端请求和应答的标准，https是以安全为标准的http通道，用的端口也不一样，http用80，https用443
- http的连接很简单，**无状态**；https是由ssl+http协议构件的进行加密传输、身份认证的网络协议，比http协议安全



### 3. get post

- get请求用来**从服务器上获取资源**；post是用来**向服务器提交数据**
- get将表单中数据按照 `name=value` 的形式，添加到action所指的URL后面，并两者使用“？”连接，而变量之间使用“&”连接；post是将表单中的数据放在http协议的请求头或消息体中，传递到action所指向的URL
- get传输的数据要收到URL长度限制；post可以传输大量的数据，上传文件通常要使用post方法。
- 使用get时参数会显示在地址栏，如果这些数据不是敏感数据，可以使用get；对于敏感数据还是应使用post
- get使用MIME类型application/x-www-form-urlencoded的URL编码文本的格式传递参数，保证被传送的参数由遵循规范的文本组成，如空格的编码为“%20”



### 4. 网际协议IP

etc...



## 操作系统

64位和32位的区别：CPU设计的区别



### 1. 进程 线程





### 2. linux的线程



## 算法与数据结构

### 1. 哈希 很多

hashset存的数——无序



### 2. 树

#### 2.1 B+树， B树

B+树的中间节点不保存数据，所以磁盘页能容纳更多节点元素，更矮胖

B+树必须查询到叶子节点，b树只要匹配不管位置，因此b+树更稳定，但不慢

对于范围查找来说，b+树只要遍历叶子节点链表即可，b树却要重复地中序遍历

#### 2.2 二叉树的深度，代码

```java
public int depth(TreeNode root){
    if(root == null) return 0;
    int left = depth(root.left);
    int right = depth(root.right);
    int bigger = Math.max(left, right);
    return bigger+1;
}
```

#### 2.3 二叉树层序遍历——用队列



#### 2.4 二叉树任意两个节点之间路径的最大长度

```cpp
int maxDist(Tree root){
    //如果树是空的，则返回0
    if(root == null) return 0;
    if(root->left != null){
        root->lm = maxDist(root->left) + 1;
    }
    if(root->right != null){
        root->rm = maxDist(root->right) + 1;
    }
    //如果以该节点为根的子树中有最大的距离，那就更新最大距离
    int sum = root->rm + root->lm;
    if(sum > max){
        max = sum;
    }
    return root->rm > root->lm ? root->rm : root->lm;
}
```



#### 2.5 实现二叉树的深度



#### 2.6 打印二叉树每层的节点



### 3. 遍历

#### 3.1 写一个函数，找到文件夹下所有文件，包括子文件夹

```java
public class Counter2 {
    public void readfile(File[] files){
        //如果目录为空，直接退出
        if(files == null) return 0;
        for(File f : files){
            //如果是文件，直接输出名字
            if(f.isFile()){
                System.out.pringln(f.getName());
            }
            //如果是文件夹，递归调用
            else if(f.isDirectory()){
                readfile(f.listFiles());
            }
        }
    }
}
```

#### 3.2 二叉树Z字遍历



### 4. 链表

#### 4.1 反转单链表

```cpp
ListNode reverseList(ListNode* head){
    if(head == nullptr || head->next == nullptr) return head;
    ListNode* p;
    ListNode* q;
    ListNode* r;
    p = head;
    q = head->next;
    head->next = nullptr;//旧的头指针是新的尾指针，指向null
    while(q){
        r = q->next;	//用来保存下一步要处理的指针
        q->next =p;		//q p 交替处理，进行反转单链表
        p = q;
        q = r;
    }
    head = p;			//最后的q必定指向null，p就成了新链表的头指针
    return head;
}
```

#### 4.2 随机链表的复制

```

```

#### 4.3 链表-奇数位升序偶数位降序-让链表变成升序

```

```

#### 4.4 判断链表检测环



### 5. 数组

#### 5.1 寻找一数组中前k个最大的数

```java


public int findKthLargest(int [] nums, int k){
    if(k < 1 || nums == null) return 0;
    return getKth(nums.length-k+1, nums, 0, nums.length-1);
}
public void swap(int [] nums, int n1, int n2){
    int tmp = nums[n1];
    nums[n1] = nums[n2];
    nums[n2] = tmp;
}
public int getKth(int k, int [] nums, int start, int end){
    int pivot = nums[end];
    int left = start;
    int right = end;
    
    while(true){
        while(nums[left] < pivot && left < right){
            left++;
        }
        while(nums[left] >= pivot && left > right){
            left--;
        }
        if(left == right) beak;
        swap(nums, left, right);
    }
    swap(nums, left, right);
    
    if(k == left +1){
        return pivot;
    }else if(k < left +1){
        return getKth(k, nums, start, left-1);
    }else {
        return getKth(k, nums, left+1, end);
    }
}
```

#### 5.2 求一个数组中连续子向量的最大和

```

```

#### 5.3 找出数组中和为S的一对组合，找出一组就行

```

```

#### 5.4  一个数组，除一个元素外其他都是两两相等，求那个元素？

```

```

#### 5.5 将一个二维数组顺时针旋转90度，说一下思路

```

```



### 6.排序

#### 6.1 手写冒泡排序

```java
import java.util.Comparator;
/**排序器接口：将算法封装到具有共同接口的独立类中使得他们可以相互替换*/
public interface Sorter{
    public <T extends Comparable<T>> void sort(T[] list);
    public <T> void sort(T[] list, Comparator<T> comp);
}

import java.util.Comparator;
/**冒泡排序*/
public class BubbleSorter implements Sorter{
    //二重循环
    @Override
    public <T extends Comparable<T>> void sort(T[] list){
        boolean swapped = true;
        for(int i=1 , len=list.length ; i<len&&swapped ; ++i){
            swapped = false;
            for(int j=0 ; j<len-1 ; ++j){
                if(list[j].compareTo(list[j+1]) > 0){
                    T temp = list[j];
                    list[j] = list[j+1];
                    list[j+1] = temp;
                    swapped = true;
                }
            }
        }
    }
    
    @Override
    public <T> void sort(T[] list, Comparator<T> comp){
        boolean swapped = true;
        for(int i=1 , len=list.length ; i<len&&swapped ; ++i){
            swapped = false;
            for(int j=0 ; j<len-i ; ++j){
                if(comp.compareTo(list[j], list[j+1]) > 0){
                    T temp = list[j];
                    list[j] = list[j+1];
                    list[j+1] = temp;
                    swapped = true;
                }
            }
        }
    }
}
```

#### 6.2 快速排序

```java
public class QuickSort{
    public void QuickSort(int [] num, int left, int right){
        //如果left==right，即数组只有一个元素，直接返回
        if(left >= right) return;
        //设置最左边的元素为基准值
        int key = num[left];
        //数组中比key小的放在左边，比key大的放在右边，key值下标为i
        int i = left;
        int j = right;
        while(i<j){
            //j向左移，直到遇到比key小的值
            while(num[j]>=key && i<j) j--;
            //i向右移，直到遇到比key大的值
            while(num[j]<=key && i<j) i--;
            //i j指向的元素交换
            if(i<j){
                int temp = num[i];
                num[i] = num[j];
                num[j] = temp;
            }
        }
        num[left] = num[i];
        num[i] = key;
        count++;
        QuickSort(num, left, i+1);
        QuickSort(num, i+1, right);
    }
}
```

