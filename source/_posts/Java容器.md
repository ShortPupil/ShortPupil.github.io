---
title: Java容器
tags:
  - java
categories: java
copyright: true
abbrlink: 58b717aa
date: 2019-04-08 23:17:01
---

# 目录

<!-- toc -->



## java容器分类

**Collection**

- List
- ArrayList
- LinkedList
- Vector
- - Stack
- Set
- HashSet
- - LinkedHashSet
- TreeSet

**Map**

- HashMap
- LinkedHashMap
- TreeMap
- ConcurrentHashMap
- Hashtable



## 最常使用的List、Set、Map的区别

### Collection 和 Map 的区别
容器内每个为之所存储的元素个数不同。

Collection类型，每个位置只有一个元素。

Map类型，持有 key-value pair，强调映射关系。

### 各自的子类关系
Collection
​     - List：将以特定次序存储元素。所以取出来的顺序可能和放入顺序不同。
​          - ArrayList 
​          - LinkedList
​          - Vector
​     - Set ： 不能含有重复的元素
​                    - HashSet 
​                    - TreeSet

### 其他特征
List，Set，Map将持有对象一律视为Object。

Collection、List、Set、Map都是接口，不能实例化。继承自它们的 ArrayList, Vector, HashTable, HashMap是具象class，这些才能被实例化。



## Map的辨析

### HashMap和TreeMap的取舍

这是在使用map时经常要考虑的，方法原则就是

- **插入、删除、定位一个元素**——HashMap更能体现map的映射关系
- **对一个key集合进行有序的遍历**——TreeMap 效率更高

### HashSet的实现原理

HashSet本身是基于HashMap实现，底层使用HashMap保存全部元素，基本是直接调用底层HashMap的方法。具体可见以下代码。

```java
private transient HashMap<E,Object> map;

// Dummy value to associate with an Object in the backing Map
private static final Object PRESENT = new Object();

/**
 * Constructs a new, empty set; the backing <tt>HashMap</tt> instance has
 * default initial capacity (16) and load factor (0.75).
 */
public HashSet() {
	map = new HashMap<>();
}
```



但是**HashSet不允许元素重复，HashMap中Key值必须唯一，value可重复**。以下代码说明原因

```java
/**

 * @param e 将添加到此set中的元素。
 * @return 如果此set尚未包含指定元素，则返回true。
 */
public boolean add(E e) {
    return map.put(e, PRESENT)==null;
}
```

如果此 set 中尚未包含指定元素，则添加指定元素。如果此 set 已包含该元素，则该调用不更改 set 并返回false。但底层**实际将该元素作为 key 放入 HashMap**。新添加的 Entry 的 value 会将覆盖原来 Entry 的 value（HashSet 中的 value 都是`PRESENT`），但 key 不会有任何改变，因此如果向 HashSet 中添加一个已经存在的元素时，新添加的集合元素将不会被放入 HashMap中，**原来的元素也不会有任何改变**，这也就满足了 Set 中元素**不重复**的特性。



## List辨析

### ArrayList和LinkedList

- ArrayList是实现了基于**动态数组**的数据结构，而LinkedList是基于**链表**的数据结构；

- 对于**随机访问get和set**，ArrayList要优于LinkedList，因为LinkedList要移动指针；

- 对于添加和删除操作add和remove，在**非首尾的增加的操作**，LinkedList要比ArrayList快，因为ArrayList要移动数据。

### 数据与List之间的转化

- 数组转List：使用Arrays.asList(array)进行转换
- List转数组：使用List自带的toArray()方法



## 迭代器

### Iterator是什么

Iterator提供遍历任何Collection的接口。

### Iterator的特点

**更加安全**，因为可以确保在当前遍历的集合原色被更改时，就会抛出ConcurrentModificationException异常。

### Iterator和ListIterator的区别

- Iterator可以遍历Set和List集合，ListIterator只能遍历List
- Iterator只能**单向**遍历， ListIterator可以**双向（向前/后）遍历**
- ListIterator从Iterator中继承，并添加了一些额外的功能



## 参考

[List、Set、Map的区别](https://blog.csdn.net/SpeedMe/article/details/22398395) 

[HashSet的实现原理](http://wiki.jikexueyuan.com/project/java-collection/hashset.html)

