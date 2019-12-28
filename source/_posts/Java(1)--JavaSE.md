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