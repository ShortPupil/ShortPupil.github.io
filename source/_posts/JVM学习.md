---
title: JVM学习
date: 2019-12-08 23:17:01
tags: [java]
categories: java
copyright: true
---

<!--toc-->

# JVM

## 一、基础原理：JVM内存区域划分、类加载机制、自实现自定义类加载器

### 1. 何为JVM

三个问题

- JVM和操作系统的关系：

  - C++直接在操作系统上运行编译后的二进制文件
  - Java新增一个处于程序和操作系统中间层的虚拟机（JVM）：抽象程度高
  - JVM约等于操作系统；Java字节码约等于汇编语言
  - JAVA -> java字节码 -> JVM -> 操作系统函数
  - JVM上承开发语言，下接操作系统，中间接口是字节码

- JVM\JRE\JDK的关系

  - JVM需要别人提供 .class文件
  - JRE：Java Runtime Environment Java运行时环境 = 基本类库+JVM标准
  - JDK：Java Development Kit = JRE + 好用小工具(Javac java jar)

- JVM虚拟机规范和Java语言规范的关系

  - ```
    Java        ->  Java语言规范
    ---------Java 字节码--------
    Hotspot VM  ->  Java虚拟机规范
    ```
    
  - 两者没有必然的联系，但是要提高代码效率，需要了解一些执行层面的指示
    
  - 了解JVM用于调优+故障排查，可以**掌握运行中的各种资源分配**

![JVM1.drawio.png](https://github.com/ShortPupil/VPicture/blob/main/JVM1.drawio.png?raw=true)

- 为什么Java研发系统需要JVM
  - JVM解释的是类似于汇编语言的字节码，需要一个抽象的运行时环境
    同时，这个虚拟环境也需要解决字节码加载、自动垃圾回收、并发等一系列问题
    JVM其实是一个规范，定义了class文件的结构、加载机制、数据存储、运行时栈等诸多内容
    最常用的JVM实现就是Hotspot
- JVM的运行原理
  - JVM生命周期跟JAVA程序运行一样，当程序运行结束，JVM实例也跟着消失了
- JAVA代码如何运行的
  - Java文件 -> 编译器 -> 字节码 -> JVM -> 机器码

### 2.  JVM内存管理 理解

#### 2.1 JVM的内存区域是如何高效划分的

- 问：为什么要问JVM的内存区域划分？
- 答：JAVA最引以为豪的就是其自动内存管理机制，相比于C++手动内存管理、难以理解的指针

JVM内存布局：**静态成员变量；动态成员变量；区域变量；短小紧凑的对象声明；庞大复杂的内存声明**

![JVM内存布局.drawio.png](https://github.com/ShortPupil/VPicture/blob/main/JVM%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80.drawio.png?raw=true)

- JVM堆中的数据共享，
- 执行引擎：可以执行字节码的模块
- 执行引擎在线程切换时如何恢复？ 用程序计数器
- JVM的内存划分与多线程息息相关， 如程序运行时用的栈、本地方法栈，其维度都是线程
- 本地内存包含元数据区和一些直接内存

#### 2.2 虚拟机栈

栈里的每条数据，就是**栈帧**

线程的生命历程同栈帧：在每个Java方法被调用的时候，都会创建一个栈帧，并入栈。一旦完成相应的调用，则出栈。所有的栈帧都出栈后，线程也就结束了

每个栈帧都包含四个区域：

1. 局部变量表
2. 操作数栈
3. 动态连接
4. 返回地址

![](https://github.com/ShortPupil/VPicture/blob/main/%E8%99%9A%E6%8B%9F%E6%A0%88%E5%B8%A71.drawio.png?raw=true)

#### 2.3 程序计数器

- 问：若我们的程序在线程之间切换，如何指导这个线程执行到什么地方了
- 答：需要有个地方对线程运行到的点位进行**缓冲记录**。用**程序计数器**

程序计数器是一块较小的内存空间

其作用可以看做是当前线程所指新的字节码的行号指示器，即存的是**当前线程执行的进度**

包括：指令、跳转、分支、循环、异常处理、线程恢复

![程序计数器1.drawio.png](https://github.com/ShortPupil/VPicture/blob/main/%E7%A8%8B%E5%BA%8F%E8%AE%A1%E6%95%B0%E5%99%A81.drawio.png?raw=true)



#### 2.4 堆

![堆1.drawio.png](https://github.com/ShortPupil/VPicture/blob/main/%E5%A0%861.drawio.png?raw=true)

java包括 基本数据类型、普通对象

- 对7种基本数据类型，有两种情况
- 对普通对象，JVM会首先在堆上创建对象，然后在其他地方使用的其实是它的引用。如把这个引用保存在虚拟机栈的局部变量表

#### 2.5 元空间

- 问：为什么有Metaspace区域？它有什么问题？
- 在Java8之前，这些类的信息是放在一个叫**Perm区**的内存里面的
  更早版本，甚至String.intern相关的运行时常量池也放在这里
  这个区域有**大小限制**，很容易造成**JVM内存溢出**，从而造成JVM崩溃
- 方法区，作为一个概念，依然存在
  它的**物理存储的容器**，就是Metaspace
  这个区域存储的内容，包括：**类的信息、常量池、方法数据、方法代码**

#### 2.6 其他

- 问：我们常说的字符串常量，存放在哪呢？
- 答：由于常量池，在java7之后，放到了堆中，我们创建的字符串，将会在堆上分配

- 问：堆、非堆、本地内存 之间的关系
- 答：堆——软绵绵，松散而有弹性，也就是数据密度低，而非堆——紧凑、数据密度高

- JVM的**运行时区域**是**栈**，而**存储区域**是**堆**，很多变量，其实在编译期就已经固定了



### 3. JVM的类加载机制

#### 3.1 三个问题

1. **我们能够通过一定的手段，覆盖HashMap类的实现么？**
2. **有哪些地方打破了Java的类加载机制？**
3. **如何加载一个远程的。class文件？怎样加密。class文件？** ： 实现新的类加载器

#### 3.2 类加载过程

​                                                    linking
加载loading -> (验证verifying -> 准备preparing -> 解析resolving) -> 初始化initiallsing

- 加载：
  加载的主要作用是将外部的.class文件，加载到Java的方法区内
  加载阶段主要是**找到**并**加载**类的二进制数据，比如从jar包里或者war包里找到它们
  
- 验证
  肯定**不能任何 .class文件都能加载**，那样太不安全了，容易受到恶意代码的攻击
  验证阶段在虚拟机整个类加载过程中占了很大一部分，不符合规范的将抛出java.lang.VerifyError错误
  像一些低版本的JVM,是无法加载一些高版本的类库的，就是在这个阶段完成的
  
- 准备
  从这部分开始，将为一些类变量分配内存，并将其初始化为默认值
  此时，实例对象还没有分配内存，所以这些动作是在方法区上进行的
  
  ```java
  // code 1
  public class A {
      static int a;
      public static void main(String[] args) {
          System.out.println(a); // 输出0
      }
  }
  
  // code 2
  public class B {
      public static void main(String[] args) {
          int a;
          System.out.println(a); // 无法通过编译
      }
  }
  /**因为局部变量不像类变量那样存在准备阶段
    *类变量有两次赋初始值的过程
    *1. 准备阶段，赋予初始值 （可以是指定值）
    *2. 初始化阶段，赋予城御园定义的值*/
  ```

- 解析
  解析在类加载中是非常非常重要的一环，是将符号引用替换为直接引用的过程
  **符号引用是一种定义**，可以是任何字面上的含义，而**直接引用就是直接指向目标的指针、相对偏移量**
  经常发生的异常，与解析阶段有关
  
    - java.lang.NoSuchFieldError根据继承关系从下往上，找不到相关字段时的报错
    - java.lang.lllegalAccessError字段或者方法，访问权限不具备时的错误
    - java.lang.NoSuchMethodError找不到相关方法时的错误
  
- 初始化
  如果前面的流程一切顺利的话，接下来该初始化成员变量了
  到了这一步，才真正开始执行一些字节码

  ```java
  public class A {
      static int a =0;
      static {
          a=1;
          b=1;
      }
      static int b =0;
      public static void main(String[] args){
          System.out.println(a);
          System.out.println(b);
      }
  }
  // 输出内容：1 0
  // a b唯一的区别就是他们的static代码块的位置
  
  public class A {
      static {
          b=b+1;
      }
      static int b =0;
      public static void main(String[] args){
          System.out.println(b);
      }
  }
  // 无法通过编译：static语句块，只能访问到定义在static语句块之前的变量
  ```

  JVM会保证在子类的初始化方法执行之前，父类的初始化方法已经执行完毕（父类>子类）

  JVM第一个被执行的类初始化方法一定是java,lang.Object；也意味着父类中定义的static语句块要优先于子类

- 问：`<cinit>` 方法 和`<init>`方法有什么区别？

- ```java
  public class A {
      static {
          System.out.println("1");
      }
      public A() {
      	System.out.println("2");
      }
  }
  
  public class B extends A {
      static {
          System.out.println("a");
      }
      public B() {
          System.out.println("b");
      }
  }
  
  public static void main(String [] args) {
      A ab = new B();
      ab = new B();
  }
  // 输出： 1 a 2 b 2 b
  // static 在<cinit> 类加载阶段就已经执行，且只会执行一次
  // <init> 在对象初始化阶段执行，且每次对象初始化都会执行一次
  ```

#### 3.3 类加载器

- 问：类加载器是如何保证整个过程（类加载过程）的**安全性**？ 类不能被轻易覆盖，否则会被恶意攻击
- 答：利用 严格的等级制度

包括（从父到子）

- Bootstrap ClassLoader
  加载器中的大boss，任何类的加载行为，都要经它过问
  作用是加载核心类库，也就是rt.jar、resources..jar、charsets.jar等
  这些jar包的路径是可以指定的
  -Xbootclasspath参数可以完成指定操作
  这个加载器是C++编写的，随着JVM启动
- Extention ClassLoader
  扩展类加载器，主要用于加载 lib/ext 目录下的jar包和。class文件
  同样的，通过系统变量java.ext.dirs可以指定这个目录
  这个加载器是个Java类，继承自URLClassLoader
- App classLoader
  Java类的默认加载器，有时也叫作System ClassLoader
  一般用来加载classpath下的其他所有jar包和。class文件
  我们写的代码，会**首先尝试使用**这个类加载器进行加载
- Custom ClassLoader
  自定义加载器，支持一些个性化的扩展功能
- ![双亲委派机制.drawio.png](https://github.com/ShortPupil/VPicture/blob/main/%E5%8F%8C%E4%BA%B2%E5%A7%94%E6%B4%BE%E6%9C%BA%E5%88%B6.drawio.png?raw=true)

**双亲委派机制**

- 双亲委派机制的意思是**除了顶层的启动类加载器以外**
  其余的类加载器，在加载之前，都会委派给它的父加载器进行加载
  这样**一层层向上传递**，**直到祖先们都无法胜任**，它才会真正的加载

- java类有一定的优先级层次划分机制，如果没有双亲委派模型，就会导致多个类加载情形，导致混乱

**打破双亲委派机制的情况**

1. tomcat：使用shared类加载器实现共享和分离

2. SPI：SPI机制(Service Provider Interface)，是Java提供的一套用来被第三方实现或者扩展的API。可以用来启用框架扩展和替换组件。

   ```java
   Class.forName("com.mysql.jdbc.Driver") // 用于加载所需要的驱动类
   mysql-connector-java-8.0.15.jar!/META-INF/services/java.sql.Driver //路径
   com.mysql.cj.jdbc.Driver //内容
   ```

   “基于接口的编程十策略模式+配置文件” 组合实现的动态加载机制；
   主要使用`java,util.ServiceLoader`类进行动态装载
   
   ```
        接口调用
   使用方 -> 标准服务接口 -> 接口实现类A 接口实现类B
                  本地服务发现服务加载
   ```
   
3. OSGI : 曾经非常流行，Eclipse使用OSGi作为插件系统的基础
   OSGI是服务平台的规范，旨在用于需要长运行时间、动态更新和对运行环境破坏最小的系统
   随着jigsaw的发展(**旨在为Java SE平台设计、实现一个标准的模块系统**)
   个人认为，现在的OSGi，意义已经不是很大了
   只需要知道有**这么个复杂的东西实现了模块化**，**每个模块可以独立安装、启动、停止、卸载**，就可以了 

#### 3.4 如何替换JDK的类

- 以HashMap为例
  当Java的原生API不能满足需求时
  比如我们要修改HashMap类，就必须要使用到**Java的endorsed技术**——我们需要**将自己的HashMap类，打包成一个jar包，然后放到-Djava.endorsed.dirs指定的目录中**。注意类名和包名，应该和JDK自带的是一样的
  但是，java.lang包下面的类除外，因为这些都是特殊保护的。而**双亲委派机制，是无法直接在应用中替换JDK的原生类的**。但是**有时候又不得不进行一下增强、替换**
  比如你想要调试一段代码，或者比Java团队早发现了一个Bug
  所以，**Java提供了endorsed技术，用于替换这些类**
  这个目录下的jar包，会比rt,jar中的文件，优先级更高，可以被最先加载到

### 4. 从栈帧看字节码如何在JVM中流转

#### 4.1 三个问题

1. 怎么查看字节码文件？
2. 字节码文件长什么样子？
3. 对象初始化之后，具体的字节码如何执行？

#### 4.2 两个字节码查看工具

- **javap**是 JDK自带的反解析工具
  作用是将 .class字节码文件解析成可读的文件格式
  javac中可以指定一些额外的内容输出到字节码，常用的有：
  `javac-g:lines` 强制生成LineNumberTable
  `javac-g:vars` 强制生成LocalVariableTable
  `javac-g` 生成所有的debug信息

  `javav -p -v Helloworld`
  
- **jclasslib**是一个图形化的工具，能够更加直观的查看字节码中的内容
  分门别类的对类中的各个部分进行了整理，非常的人性化

#### 4.3 一个例子

```java
class B{
    private int a = 23456;
    public long test(long num) {
        long text = this.a + num;
        return text;
    }
}
public class A {
    private B b = new B();  // 此处触发B类的加载
    public static void main(String [] args) {
        A a = new A();
        long num = 65432;
        long ret = a.b.test(num);
        System.out.println(ret);
    }
}
```

 ![查看字节码.drawio.png](https://github.com/ShortPupil/VPicture/blob/main/%E6%9F%A5%E7%9C%8B%E5%AD%97%E8%8A%82%E7%A0%81.drawio.png?raw=true)






## 二、垃圾回收：理论为主

### 1. OOM相关问题

#### 1.1 GC Roots

**JVM的GC动作是不受程序控制的，它会在满足条件的时候，自动触发**
发生GC的时候，一个对象，JVM总能够找到引用它的祖先
找到最后，**如果发现这个祖先已经名存实亡了，它们都会被清理掉**
而**能够躲过垃圾回收的那些祖先比较特殊，它们的名字就叫作GC Roots**

从GC Roots向下追溯、搜索，会产生一个叫作Reference Chain的链条
当一个对象不能和任何一个GC Root产生关系时，就会被无情的诛杀掉

GC Roots是**一组必须活跃的引用**,就是**程序接下来通过直接引用或者间接引用，能够访问到的潜在被使用的对象**
包括：

- java线程中，当前所有正在被调用的方法的引用类型参数、局部变量、临时值等.也就是与我们栈帧相关的各种引用
- 所有当前被加载的Java类
- Java类的引用类型静态变量
- 运行时常量池里的引用类型常量(String或Class类型
- JVM内部数据结构的一些引用，比如sun.jvm.hotspot.memory.Universe类
- 用于同步的监控对象，比如调用了对象的wait0方法
- JNI handles,包括global handles和local handles

因此主要分为三大类

1. **活动线程的相关引用**
2. **类的静态变量的引用**
3. **JNI引用**

注意

1. 这里说的是活跃的引用，而不是对象，对象是不能作为GC Roots的
2. GC过程是**找出所有活对象，并把其余空间认定为“无用”**；而不是找出所有死掉的对象，并回收它们占用的空间。所以，哪怕JVM的堆非常的大，基于tracing的GC方式，回收速度也会非常快。

#### 1.2 引用级别

> 问：**弱引用有什么用处**

![GC Roots.drawio.png](https://github.com/ShortPupil/VPicture/blob/main/GC%20Roots.drawio.png?raw=true)

其关系可以分为 **强引用、软引用、弱引用、虚引用**...... 

- 强引用Strong references
  当内存空间不足，系统撑不住了，JVM就会抛出OutOfMemoryError错误
  **即使程序会异常终止，这种对象也不会被回收**
  这种引用属于最普通最强硬的一种存在，**只有在和GC Roots断绝关系时，才会被消灭掉**

  ``` java
  // 例子
  Object o = new Object(); 
  static Map<User, long> userVisitMap = new HashMap<>(); 
  userVisitMap.put(user, time);  //由于它被userVisitMap引用，我们没有其他手段remove掉它，这个时就发生了内存泄漏(memory leak)
  ```

- 软引用Soft references
  在**内存足够的时候，软引用对象不会被回收**，**只有在内存不足时，系统则会回收软引用对象**
  如果**回收了软引用对象之后仍然没有足够的内存，才会抛出内存溢出异常**
  这种特性非常适合用在**缓存技术**上。比如网页缓存、图片缓存等

  ```java
  // 例子
  Object object = new Object(); 
  SoftReference<Object> softRef = new SoftReference(object);
  // 同时可以设置每MB堆空闲空间中SoftReference的存活时间，这个值默认时间是1s=1000
  -XX:SoftRefLRUPolicyMSPerMB = <N>
  ```

- 弱引用Weak references
  弱引用对象相比较软引用，要更加无用一些，它拥有更短的生命周期
  在Java中，用java.lang.ref.WeakReference类来表示

  ```java
  // 例子
  Object object = new Object（）;
  WeakReference<Object>softRef new WeakReference(object);
  ```

- 虚引l用Phantom References
  主要用来跟踪对象被垃圾回收的活动
  当垃圾回收器准备回收一个对象时，如果发现它还有虚引用，就会在回收对象之前，把这个虚引用加入到
  与之关联的引用队列中

  ```java
  // 虚引用的实现
  private static void startMonitoring(ReferenceQueue<MyObject>referenceQueue,
  Reference<MyObject>ref){
      ExecutorService ex Executors.newSingleThreadExecutor();
      ex.execute(()->{
      	while (referenceQueue.poll()!=ref){
      		//don't hang forever
      		if(finishFlag)
      			break;
          }
     		 System.out.println("--ref gc'ed--");
      });
      ex.shutdown();
  }
  ```

#### 1.3 OOM场景
  ![JVM内存布局.drawio.png](https://github.com/ShortPupil/VPicture/blob/main/JVM%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80.drawio.png?raw=true)

| 区域       | 是否线程私有 | 是否会发生OOM |
| ---------- | ------------ | ------------- |
| 程序计数器 | 是           | 否            |
| 虚拟机栈   | 是           | 是            |
| 本地方法栈 | 是           | 是            |
| 方法区     | 否           | 是            |
| 直接内存   | 否           | 是            |
| 堆         | 否           | 是            |

 典型的OOM场景如图

不要为了方便把对象到处引用。即使引用了，也要正在合适的时机手动清理。

#### 1.4 总结

- GC Roots的专业叫法，**可达性分析法**。另外，还有一种叫作引用计数法的方式，在判断对象的存活问题上，经常被提及。遍历所有的可达对象，这个过程即为标记
- 因为有循环依赖的硬伤，现在主流的JVM,没有一个是采用引用计数法来实现GC的，所以大体了解一下就可以
- 引用计数法是在对象头里维护一个counter计数器，被引用一次数量+1，引用失效记数-1。计数器为0时，就被认为无效

### 2. 垃圾回收机制

JVM是有**专门的线程**在做这件事情，当内存空间达到一定条件时，会**自动触发**
这个过程就叫作GC。负责GC的组件，就叫作垃圾回收器

- JVM中有哪些垃圾回收算法？它们各自有什么优劣？
- CMS垃圾回收器是怎么工作的？有哪些阶段？
- 服务卡顿的元凶到底是谁？

1. 几种重要回收算法
2. 分代垃圾回收的内存划分和GC过程
3. 当前JVM中几种常见的垃圾回收期

本节重点知识记录

| 算法    | 分代                   | 名词                         |
| ------- | ---------------------- | ---------------------------- |
| Mark    | 年轻代                 | weak generational hypothesis |
| Sweep   | Survivor               | 分配担保                     |
| Copy    | Eden                   | 提升                         |
| Compact | 老年代                 | 卡片标记                     |
|         | GC: Minor GC、Major GC | STW                          |



#### 2.1 复制、标记-清除、标记整理

![标记.PNG](https://github.com/ShortPupil/VPicture/blob/main/%E6%A0%87%E8%AE%B0.PNG?raw=true)

- 灰色结点被清除

- 申请了| 1k | 2k | 3k | 4k | 5k |，由于某种原因，2k和4k的内存不再使用，就要交给垃圾回收器回收

- 在程序设计中，一般遇到扩缩容或者碎片整理问题时，**复制算法**都是非常有效的
  比如：HashMap的扩容也是使用同样的思路，Redis的rehash也是类似的
  
- ![复制算法.PNG](https://github.com/ShortPupil/VPicture/blob/main/%E5%A4%8D%E5%88%B6%E7%AE%97%E6%B3%95.PNG?raw=true)
  
- ```java
  /**整理算法例子*/
  last = 0;
  for(i=0;i<mems.length;i++){
      if(mems[i] != null){
          mems[last++]=mems [i];
          changeReference(mems[last]);
      }
  }
  clear(mems,last,mems.length);
  // 以上情况只是一个理想状态。对象的引用关系一般都是非常复杂的
  // 从效率上来说，一般整理算法是要低于复制算法的
  ```

- 1. ·复制算法(Copy)
     复制算法是所有算法里面效率最高的，缺点是会造成一定的空间浪费

  2. 标记-清除(Mark-Sweep)
     效率一般，缺点是会造成内存碎片问题

  3. 标记-整理(Mark-Compact)
     效率比前两者要差，但没有空间浪费，也消除了内存碎片问题

     没有最优算法，只有最合适的算法

#### 2.2 分代

- 弱代假设 weak generational hypothesis

  JVM是**计算节点**，而不是存储节点
  研究表明，大部分对象，可以分为两类：1.大部分对象的生命周期都很短；2.其他对象则很可能会存活很长时间。即大部分死的快，其他的活的长

- **年轻代** Young generation

  - **复制算法**
  - *|to (Survivor0)|from (Survivor 1)| Edge(TLAB1) (TLAB2)(TLAB3)...(TLABn)|
  - 分为一个伊甸园空间，两个幸存者空间
  - 当年轻代中的Eden区分配满时，就会触发**年轻代的GC (Minor GC)**
  - 在Eden区执行了第一次GC之后，存活的对象会被移动到其中一个Survivor分区(以下简称from)
  - Eden区再次GC之后，存活的对象同样会被堆积在from上
  - 如果GC之后from区已经满了，这时会采用复制算法，将Eden和from区一起清理。存活的对象会被复制到to区；接下来，只需要清空from区就可以了
    所以在这个过程中，**总会有一个Survivor分区是空置的**。Eden、from、to的默认比例是8:1:1，所以只会造成10%的空间浪费。**这个比例，是由参数-XX:SurvivorRatio进行配置的(默认为8)**
  - TLAB：Thread Local Allocation Buffer：**JVM默认给每个线程开辟一个buffer区域，用来加速对象分配。**这个buffer就放在Eden区中

- **老年代** Tenured generation/Old generation

  - **标记-清理、标记-整理算法**

  - 老年代一般使用“标记-清除”、“标记整理”算法，因为老年代的对象存活率一般是比较高的。**空间又比较大，拷贝起来并不划算，还不如采取就地收集的方式**

  - > 问：对象怎么进入老年代呢？

  - 1. **提升(Promotion)**
       如果**对象够老**，会通过“提升”进入老年代
       关于对象老不老，是**通过它的年龄(age)来判断**的。每当发生一次Minor GC,存话下来的对象年龄都会加1。直到达到一定的阈值，就会把这些“老顽固”给提升到老年代
       这些对象如果变的不可达，直到老年代发生GC的时候，才会被清理掉
       这个阈值，可以通过参数~XX:+MaxTenuringThreshold进行配置，最大值是l5,因为它是用4bit存储
       的(所以网络上那些要把这个值调的很大的文章，是没有什么根据的)

    2. **分配担保**

       看一下年轻代的图，**每次存活的对象，都会放入其中一个幸存区，这个区域默认的比例是10%**
       但是**我们无法保证每次存活的对象都小于10%，当Survivor空间不够，就需要依赖其他内存（指老年代）进行分配担保**
       这个时候，对象也会直接在老年代上分配

    3. **大对象直接在老年代分配**
       超出某个大小的对象将直接在老年代分配。这个值是通过参数-X:PretenureSizeThreshold进行配置的，默认为0，意思是**全部首选Eden区进行分配**

    4. **动态对象年龄判定**
       有的垃圾回收算法，并不要求age必须达到15才能晋升到老年代，它会使用一些**动态的计算方法**（一般不受外部控制）如果**幸存区中相同年龄对象大小的和，大于幸存区的一半，大于或等于ag的对象**将会直接进入老年代

  - 卡片标记

  - > 对象的引用关系是一个巨大的网状。有的对象可能在Ede区，有的可能在老年代，那么这种**跨代的引用是如何处理的呢**？
    > 由于Minor GC是单独发生的，如果一个老年代的对象引用了它，**如何确保能够让年轻代的对象存活呢**？
    >
> 对于是、否的判断，通常都会用Bitmap（位图）和布隆过滤器来加快搜索的速度

    - JVM也是用了类似的方法。其实，**老年代是被分成众多的卡页(card page)的(一般数量是2的次幂)**
      **卡表(Card Table)就是用于标记卡页状态的一个集合**，每个卡表项对应一个卡页
      如果年轻代有对象分配，而且老年代有对象指向这个新对象，那么这个老年代对象所对应内存的卡页就会标识为dirty,卡表只需要非常小的存储空间就可以保留这些状态
      **垃圾回收时，就可以先读这个卡表，进行快速判断**

- 图总结：

- **Minor GC**：发生在年轻代的GC
  **Major GC**：发生在老年代的GC
  **Full GC**：全堆垃圾回收，比如Metaspace区引起年轻代和老年代的回收

- ![HotSpot垃圾回收器.PNG](https://github.com/ShortPupil/VPicture/blob/main/HotSpot%E5%9E%83%E5%9C%BE%E5%9B%9E%E6%94%B6%E5%99%A8.PNG?raw=true)

#### 2.3 垃圾回收器

年轻代垃圾回收器

1. **Serial垃圾收集器**
   处理GC的只有一条线程，并且在垃圾回收的过程中暂停一切用户线程
   这可以说是**最简单**的垃圾回收器。因为简单，所以高效它通常用在**客户端应用**上。因为客户端应用不会频繁创建很多对象，用户也不会感觉出明显的卡顿。相反，它使用的资源更少，也更轻量级
2. ParNew垃圾收集器
   ParNew是Serial的多线程版本，由**多条GC线程并行地进行垃圾清理，清理过程依然要停止用户线程**
   ParNew**追求“低停顿时间”**，与Serial唯一区别就是使用了多线程进行垃圾收集，在多CPU环境下性
   能比Serial会有一定程度的提升
   但线程切换需要**额外的开销，因此在单CPU环境中表现不如Serial**
3. **Parallel Scavenge垃圾收集器**
   另一个多线程版本的垃圾回收器。它与ParNew的主要区别是：
   - Parallel Scavenge: 追求**CPU吞吐量**，能够在较短时间内完成指定任务，**适合没有交互的后台计算**
     **弱交互强计算**
   - ParNew:追求降低用户停顿时间，**适合交互式应用，强交互弱计算**

老年代垃圾回收期

1. Serial Old垃圾收集器
   与年轻代的Serial垃圾收集器对应，都是单线程版本，同样适合客户端使用

   - 年轻代的Serial,使用复制算法
   - 老年代的Old Serial,使用标记-整理算法

2. Parallel Old
   Parallel Old收集器是Parallel Scavenge的老年代版本，追求CPU吞吐量

**CMS垃圾收集器**

- CMS(Concurrent Mark Sweep)收集器是**以获取最短GC停顿时间为目标**的收集器，它在垃圾收集时
  使得用户线程和GC线程能够并发执行，因此在垃圾收集过程中用户也不会感到明显的卡顿。
  长期来看，CMS垃圾回收器，是要被G1等垃圾回收器替换掉的。在Java8之后，使用它将会抛出一个警告
- 全称Mostly Concurrent Mark and Sweep Garbage Collector（主要并发标记清除垃圾收集器）
  设计目标是**避免在老年代GC时出现长时间的卡顿**（但它并不是一个老年代回收器）
  使用的是**Sweep**而不是Compact,所以它的主要问题是**碎片化**
  随着JVM的长时间运行，**碎片化会越来越严重，只有通过Full GC才能完成整理**

  

垃圾回收器的相关命令

![垃圾回收期命令.PNG](https://github.com/ShortPupil/VPicture/blob/main/%E5%9E%83%E5%9C%BE%E5%9B%9E%E6%94%B6%E6%9C%9F%E5%91%BD%E4%BB%A4.PNG?raw=true)

线上使用最多的垃圾回收器：就有**CMS**和**G1**，以及Java8默认的**Parallel Scavenge**

- CMS的设置参数：-XX:+UseConcMarkSweepGC
- Java8的默认参数：-XX:+UseParallelGC
- Java13的默认参数：-XX:+UseG1GC

#### 2.4 STW Stop the world

为了保证程序不会乱套，最好的办法就是暂停用户的一切线程
也就是在这段时间，你是不能new对象的，只能等待
表现在JVM上就是**短暂的卡顿，什么都干不了**，这个头疼的现象，就叫作Stop the world,简称STW

![STW.PNG](https://github.com/ShortPupil/VPicture/blob/main/STW.PNG?raw=true)

例子：某个高并发服务的峰值流量是10万/秒，后面有10台负载均衡的机器，每台机器平均下来需要1万/秒。假设某台机器发生了STW持续了1秒，本来10ms就能返回10万个请求，此时需要等待1秒。在用户那里的表现就是会卡顿，而且GC频繁卡顿则会十分明显。

1.**年轻代是GC的重灾区，大部分对象活不到老年代**
2.面试经常问，都是些非常朴素的原理
3.为后面对G1和ZGC的介绍打下基础

### 3. CMS 不太会

#### 3.1 CMS回收过程

1. **初始标记(Initial Mark)**
   初始标记阶段，**只标记直接关联GC Root的对象**，不用向下追溯。因为最耗时的就在tracing阶段，这样就**极大地缩短了初始标记时间**

2. **并发标记(Concurrent Mark)**
   在初始标记的基础上，进行并发标记。这一步骤主要是tracinng的过程，用于标记所有可达的对象。这个过程会持续比较长的时间，但却**可以和用户线程并行**
   在这个阶段的执行过程中，可能会产生很多变化：

   ​	有些对象，从新生代晋升到了老年代
   ​	有些对象，直接分配到了老年代
   ​	老年代或者新生代的对象引用发生了变化

3. **并发预清理(Concurrent Preclean)**
   并发预清理也是**不需要STW**的，目的是为了让重新标记阶段的STW尽可能短。这个时候，**老年代中被标记为dity的卡页中的对象，就会被重新标记，然后清除掉dity的状态**
   由于这个阶段也是可以并发的，在执行过程中引用关系依然会发生一些变化
   我们可以假定这个清理动作是第一次清理。所以重新标记阶段，有可能还会有处于dity状态的卡页

4. **并发可取消的预清理(Concurrent Abortable Preclean)**
   因为重新标记是需要STW的，所以会有很多次预清理动作
   并发可取消的预清理，顾名思义，在满足某些条件的时候可以终止，比如迭代次数、有用工作量、消耗的系统时间等。**这个阶段是可选的**。
   换句话说，**这个阶段是“并发预清理”阶段的一种优化**：第一个意图，是避免回扫年轻代的大量对象；另外一个意图，就是当满足最终标记的条件时，自动退出

5. **最终标记(Final Remark)**
   通常CMS会尝试在年轻代尽可能空的情况下运行Final Remark阶段，以免接连多次发生STW事件。这是CMS垃圾回收阶段的第二次STW阶段，目标是完成老年代中所有存活对象的标记。
   我们前面多轮的preclean阶段，一直在和应用线程玩追赶游戏，**有可能跟不上引用的变化速度**。本轮的标记动作就需要STW来处理这些情况
   **如果预处理阶段做的不够好，会显著增加本阶段的STW时间**。CMS垃圾回收器把回收过程分了多个部分，而影响最大的不是STW阶段本身，而是它之前的预处理动作

6. **并发清除(Concurrent Sweep)**
   此阶段用户线程被重新激活，目标是删掉不可达的对象，并回收它们的空间
   由于CMS并发清理阶段用户线程还在运行中，伴随程序运行自然就还会有新的垃圾不断产生，这一部分垃
   圾出现在标记过程之后，CMS无法在当次GC中处理掉它们，只好留待下一次GC时再清理掉
   这一部分垃圾就称为“浮动垃圾”

7. **并发重置(Concurrent Reset)**
   此阶段与应用程序并发执行，重置CMS算法相关的内部数据，为下一次GC循环做准备

#### 3.2 内存碎片

由于CMS在执行过程中，用户线程还需要运行，那就需要保证有充足的内存空间供用户使用
如果等到老年代空间快满了，再开启这个回收过程，用户线程可能会产生“Concurrent Mode Failure”
的错误，这时会临时启用Serial Old收集器来重新进行老年代的垃圾收集，这样停顿时间就很长了(STW)
当老年代的使用率达到70%，就会触发GC了
如果你的系统老年代增长不是太快，可以调高这个参数，降低内存回收的次数

CMS提供了两个参数来解决这个问题：

1. UseCMSCompactAtFullCollection（默认开启），表示在要进行Full GC的时候，进行内存碎片整理
   内存整理的过程是无法并发的，所以停顿时间会变长
2. CMSFullGCsBeforeCompaction,每隔多少次不压缩的Full GC后，执行一次带压缩的Full GC
   默认值为0，表示每次进入Full GC时都进行碎片整理

#### 3.3 总结

总结一下CMS中都会有哪些停顿(STW)

1. 初始标记，这部分的停顿时间较短
2. Minor GC（可选），在预处理阶段对年轻代的回收，停顿由年轻代决定
3. 重新标记，由于preclaen阶段的介入，这部分停顿也较短
4. Serial-Old收集老年代的停顿，主要发生在预留空间不足的情况下，时间会持续很长
5. Full GC,永久代空间耗尽时的操作，由于会有整理阶段，持续时间较长
   在发生GC问题时，你一定要明确发生在哪个阶段，然后对症下药。**gclog**通常能够非常详细的表现这个过程

长期来看，CMS垃圾回收器，是要被G1等垃圾回收器替换掉的。



### 4. G1问题 

> G1的回收原理是什么？为什么G1比传统GC回收性能好？
>
> 为什么G1如此完美仍然会有ZGC?

在发生Minor GC时，由于Survivor区已经放不下了，多出的对象只能提升(promotion)到老年代。但是此时老年代因为空间碎片的缘故，会发生concurrent mode failure的错误。这时就需要降级为Serail Old垃圾回收器进行收集。
这就是比concurrent mode failure更加严重的**promotion failed问题**

#### 4.1 G1 的KPI思路 和 特点

- G1的思路：它不要求每次都把垃圾清理的干干净净，它只是努力做它认为对的事情。我们要求G1**,在任意1秒的时间内，停顿不得超过10ms**,这就是在给它制定KPI
  **G1会尽量达成这个目标，它能够推算出本次要收集的大体区域，以增量的方式完成收集**
  这也是使用G1垃圾回收器不得不设置的一个参数：**-XX:MaxGCPauseMillis=10**

- G1(全称**GarbageFirst GC**)的目标是用来干掉CMS的，它同样是一款软实时垃圾回收器。相比CMS,G1的使用更加人性化。
  比如CMS垃圾回收器的相关参数有72个，而G1的参数只有26个

- 为了达成上面制定的KPI,它和前面介绍的垃圾回收器，**在对堆的划分上有一些不同**（问题）
  一小份区域的大小是固定的，名字叫作**小堆区(Region)**。小堆区可以是Eden区，也可以是Survivor区，还可以是Old区，所以G1的**年轻代**和**老年代**的概念都是**逻辑**上的。
  每一块Region,大小都是一致的，它的数值是在1M到32M字节之间的一个2的幂值数
  
  ![G1分区.PNG](https://github.com/ShortPupil/VPicture/blob/main/G1%E5%88%86%E5%8C%BA.PNG?raw=true)

#### 4.2 G1的垃圾回收过程

**逻辑上**，G1分为年轻代和老年代。但它的年轻代和老年代比例，并不是那么“固定”。为了达到MaxGCPauseMillis所规定的效果，G1会自动调整两者之间的比例
G1的回收过程主要分为**3类**：

1. G1**“年轻代”的垃圾回收，同样叫Minor GC**, 这个过程和我们前面描述的类似，发生时机就是Eden区满的时候。
2. 老年代的垃圾收集，严格上来说其实不算是收集，它是一个**“并发标记”**的过程，顺便清理了一点点对象。
3. 真正的清理，发生在**“混合模式”，**它不止清理年轻代，还会将老年代的一部分区域进行清理

#### 4.3 RSet

RSet是一个空间换时间的数据结构。与Card Table有些不同的地方

- Card Table是一种**points-out**（我引用了谁的对象）的结构
- RSet**记录了其他Region中的对象引用本Region中对象的关系**，属于**points-into**结构
- 对于年轻代的Region,RSet只保存了来自老年代的引用，是因为年轻代的回收是针对所有年轻代Region的，没必要画蛇添足。所以说年轻代Region的RSet有可能是空的。
- RSt通常会占用很大的空间，大约5%或者更高，不仅仅是空间方面，很多计算开销也是比较大的。为了维护RSet,程序运行的过程中，写入某个字段就会产生一个post-write barrier
- 为了减少这个开销，将内容放入RSt的过程是异步的，而且经过了很多的优化：Write Barrier把脏卡信息存放到本地缓冲区(local buffer),有专门的GC线程负责收集，并将相关信息传给被引用Region的RSet
- 参数`-XX:G1ConcRefinementThreads`或者`-XX:ParallelGCThreads`可以控制这个异步的过程。如果并发优化线程跟不上缓冲区的速度，就会在用户进程上完成

#### 4.4 G1具体回收过程 不会 

**年轻代的收集**包括下面的回收阶段：

1. 扫描根
   根，可以看作是我们前面介绍的GC Roots,加上RSet记录的其他Region的外部引用
2. 更新RS
   处理dirty card queue中的卡页，更新Rset
   此阶段完成后，RSt可以准确的反映老年代对所在的内存分段中对象的引用，可以看作是第一步的补充
3. 处理RS
   识别被老年代对象指向的Eden中的对象，这些被指向的Eden中的对象被认为是存活的对象
4. 复制对象
   这个阶段，对象树被遍历，Eden区内存段中存活的对象会被复制到Survivor区中空的Region
   这个过程和其他垃圾回收算法一样，包括对象的年龄和晋升
5. 处理引用
   处理Soft、Weak、Phantom、Final、.JNI Weak等引用，结束收集

具体标记过程

1. 初始标记(Initial Mark)
   这个过程共用了Minor GC的暂停，这是因为它们可以复用root scan操作
   虽然是STW的，但是时间通常非常短。

2. Root区扫描(Root Region Scan)

3. 并发标记(Concurrent Mark)
   这个阶段从GC Roots开始对heap中的对象标记，标记线程与应用程序线程并行执行
   并且收集各个Region的存活对象信息。

4. 重新标记(Remaking)
   和CMS类似，也是STW的。标记那些在并发标记阶段发生变化的对象。

5. 清理阶段(Cleanup)
   这个过程不需要STW,如果发现Region里全是垃圾，在这个阶段会立马被清除掉
   不全是垃扔的Region:并不会被立马处理，它会在Mixed GC阶段，进行收集

   **混合回收(Mixed GC)**
   能并发清理老年代中的整个整个的小堆区是一种最优情形
   混合收集过程，不只清理年轻代，还会将一部分老年代区域也加入到CSt中
   通过Concurrent Marking阶段，我们已经统计了老年代的垃圾占比
   在Minor GC之后，如果判断这个占比达到了某个阈值，下次就会触发Mixed GC.。这个阈值，由-XX:G1HeapWastePercent参数进行设置(默认是堆大小的5%)。因为这种情况下，GC会花费很多的时间但是回收到的内存却很少
   所以这个参数也是可以调整Mixed GC的频率的
   还有参数G1MixedGCCountTarget,用于控制一次并发标记之后，最多执行Mixed GC的次数

#### 5. ZGC

在系统切换到G1垃圾回收器之后，线上发生的严重GC问题已经非常少了
这归功于**G1的预测模型和它创新的分区模式**
但预测模型也会有失效的时候。它并不是总如我们期望的那样运行，尤其是你给它定下一个苛刻的目标之后
另外，**如果应用的内存非常吃紧，对内存进行部分回收根本不够始终要进行整个Heap的回收，那么G1要做的工作量就一点也不会比其他垃圾回收器少**
**而且因为本身算法复杂了，还可能比其他回收器要差**

最新的ZGC垃圾回收器，就有3个令人振奋的Flag:
1.停顿时间不会超过10ms
2.停顿时间不会随着堆的增大而增大(不管多大的堆都能保持在10s以下)
3.可支持几百M,甚至几T的堆大小(最大支持4T)