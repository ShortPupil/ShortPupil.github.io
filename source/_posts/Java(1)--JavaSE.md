---
title: Java(1)--JavaSE
date: 2019-12-28 15:48:24
tags: [java]
copyright: false
categories: java
---

## java 基础

@[toc]

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

### 1. 

