---
title: Java高效代码50例
copyright: false
date: 2020-01-05 13:19:06
tags: [java]
categories: java
---

@[toc]



转载自[阿里云云栖号](https://mp.weixin.qq.com/s/izVH7nVkQVpYbyJKN35uLA)



## 1. 常量&变量

### 1.1 直接赋值常量值，禁止声明新变量

```java
//反例
Long i = new Long(1L);
String s = new String("abc");
//正例
Long i = 1L;
String s = "abc"
```

### 1.2 当成员变量值无需改变时，尽量定义为静态变量

```java
//反例
public class HttpConnection{
    private final long timeout = 5L;
    ...
}
//正例
public class HttpConnection{
    private static final long timeout = 5L;
    ...
}
```

### 1.3 尽量使用基本数据类型，避免自动装箱和拆箱

Java 中的基本数据类型double、float、long、int、short、char、boolean，分别对应包装类Double、Float、Long、Integer、Short、Character、Boolean。

JVM支持基本类型与对应包装类的自动转换，被称为自动装箱和拆箱。装箱和拆箱都是需要CPU和内存资源的，所以应尽量避免使用自动装箱和拆箱。

```java
//反例
Integer sum = 0;
int[] values = ...;
for(int value : values){
    sum += value;
}
//正例
int sum = 0;
int[] values = ...;
for(int value : values){
    sum += value;
}
```

### 1.4 如果变量的初值会被覆盖，就没有必要给变量赋初值

```java
//反例
List<UserDO> userList = new ArrayList<>();
if(isAll) {
    userList = userDAO.queryAll();
} else {
    userList = userDAO.queryActive();
}
//正例
List<UserDO> userList;
if(isAll) {
    userList = userDAO.queryAll();
} else {
    userList = userDAO.queryActive();
}
```

### 1.5 尽量使用函数内的基本类型临时变量

在函数内，基本类型的参数和临时变量都保存在栈（Stack）中，访问速度较快；对象类型的参数和临时变量的引用都保存在栈（Stack）中，内容都保存在堆（Heap）中，访问速度较慢。在类中，任何类型的成员变量都保存在堆（Heap）中，访问速度较慢。

```java
//反例
public final class Accumlator {
    private double result = 0.0;
    public void addAll(@NonNull double[] values){
        for(double value : values){
            result += value;
        }
    }
}
//正例
public final class Accumlator {
    private double result = 0.0D;
    public void addAll(@NonNull double[] values){
        double sum = 0.0D;
        for(double value : values){
            sum += value;
        }
        result += sum;
    }
}
```

### 1.6 尽量不要在循环体外定义变量

```java
//反例
UserVO userVO; //不再循环体外定义变量
List<UserVO> userDOList = ...;
List<UserVO> USERVOList = new ArrayList<>(userDOList.size());
for(UserDO userDO : userDOList){
    userVO = new UserVO();
    userVO.setId(userDO.getId());
    ...
    userVOList.add(userVO);
}
//正例
List<UserVO> userDOList = ...;
List<UserVO> USERVOList = new ArrayList<>(userDOList.size());
for(UserDO userDO : userDOList){
    userVO = new UserVO();
    userVO.setId(userDO.getId());
    ...
    userVOList.add(userVO);
}
```

### 1.7 不可变的静态常量，尽量使用非线程安全类

```java
//反例
public static final Map<String, Class> CLASS_MAP;
static {
    Map<String, Class> classMap = new ConcurrentHashMap<>(16);
    classMap.put("VARCHAR", java.lang.String.class);
    ...
    CLASS_MAP = Collection.unmodifiableMap(classMap);
}
//正例
public static final Map<String, Class> CLASS_MAP;
static {
    Map<String, Class> classMap = new ConcurrentHashMap<>(16);
    classMap.put("VARCHAR", java.lang.String.class);
    ...
    CLASS_MAP = Collection.unmodifiableMap(classMap);
}
```

### 1.8 不可变的成员变量，尽量使用非线程安全类

```java
//反例
@Service
public class StrategyFactory implements InitializingBean {
    @Autowired
    private List<Strategy> strategyList;
    private Map<String, Strategy> strategyMap;
    @Override
    public void afterPropertiesSet(){
        if(CollectionUtils.isNotEmpty(strategyList)) {
            int size = (int) Math.ceil(strategyList.size() * 4.0 / 3);
            Map<String, Strategy> map = new ConcurrentHashMap<>(size);  //要使用非线程安全类
            for(Strategy strategy : strategyList){
                map.put(strategy.getType, strategy);
            }
            strategyMap = Collections.unmodifiableMap(map);
        }
    }
}
//正例
@Service
public class StrategyFactory implements InitializingBean {
    @Autowired
    private List<Strategy> strategyList;
    private Map<String, Strategy> strategyMap;
    @Override
    public void afterPropertiesSet(){
        if(CollectionUtils.isNotEmpty(strategyList)) {
            int size = (int) Math.ceil(strategyList.size() * 4.0 / 3);
            Map<String, Strategy> map = new HashMap<>(size);
            for(Strategy strategy : strategyList){
                map.put(strategy.getType, strategy);
            }
            strategyMap = Collections.unmodifiableMap(map);
        }
    }
}
```

