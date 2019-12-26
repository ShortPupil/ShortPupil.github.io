---
title: Java(1)--JavaSE
date: 2019-12-28 15:48:24
tags: [java]
copyright: false
categories: java
---

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

`equals`本质同`==`, 但String和Integer等进行了重写，`equals`变成值比较，源码如下

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



### 



