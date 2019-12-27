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

