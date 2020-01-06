---
title: Java高效代码例子
copyright: false
date: 2020-01-05 13:19:06
tags: [java]
categories: java
---

@[toc]



转自[阿里云云栖号_常意](https://mp.weixin.qq.com/s/izVH7nVkQVpYbyJKN35uLA) 

参考《重构》第3章，代码的坏味道



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



## 2. 对象&类

### 2.1 禁止使用JSON转化对象

影响性能！

~~我经常用json转换~~

```java
//反例
List<UserDO> userDOList = ...;
List<UserVO> userVOList = JSON.parseArray(JSON.toJSONString(userDOList), UserVO.class); //不要用json转换对象

//正例 老老实实赋值
List<UserDO> userDOList = ...;
List<UserVO> userVOList = new ArrayList<>(userDOList.size());
for(UserDO userDO : userVOList){
    UserVO userVO = new UserVO();
    userVO.setId(userDO.getId());
    ...
    userVOList.add(userVO);
}
//VO是new创建，GC回收。值对象，业务对象，用于业务层之间的数据传递
//PO是向数据库中添加数据时创建，删除数据库中数据时消除。有状态，每个属性代表当前状态，与数据库表字段对应。需要序列化接口。
```

### 2.2 尽量不适用反射赋值对象

影响性能！x2

```java
//反例
List<UserDO> userDOList = ...;
List<UserVO> userVOList = new ArrayList<>(userDOList.size());
for(UserDO userDO : userVOList){
    UserVO userVO = new UserVO();
    BeanUtils.copyProperties(userDO, userVO);//不要用反射赋值
    userVOList.add(userVO);
}
//正例，同上
```

### 2.3 采用Lambda表达式替换内部匿名类 

Lambda表达式在大多数虚拟机中采用`invokeDynamic`指令实现，相对于匿名内部类在**效率上会更高一些**。

```java
//反例
List<User> userList = ...; 
Collections.sort(userList, new Comparator<User>(){ //匿名内部类
    @Override
    public int compare(User user1, User user2){
        Long userId1 = user1.getId();
        Long userId2 = user2.getId();
        return userId1.compareTo(userId2);
    }
})
//正例
List<User> userList = ...; 
Collections.sort(userList, (user1, user2) -> { //使用lambda表达式
    Long userId1 = user1.getId();
    Long userId2 = user2.getId();
    return userId1.compareTo(userId2);
});
```

### 2.4 避免不必要的子类定义

原因：多一个类就多一份类加载

### 2.5 尽量使用指定类的final修饰符

原因：类指定了final修饰符以后，该类不可以被继承。类为final，则该类的所有方法都是final，**Java编译器会寻找机会内联所有的final方法**。内联对于提升Java运行效率作用重大。

注：使用Spring的AOP特性时，需要对Bean进行动态代理，如果bean类添加final修饰，会导致异常



## 3. 方法

### 3.1 把跟类成员变量无关的方法声明成静态方法

静态方法本质上就不在属于某个对象，属于它所在的类。只要通过类名就可以访问，**不用消耗资源反复创建对象**。

注：即使在类内部的私有方法，没有用到类成员变量，也应该声明为静态方法。

```java
//正例
public static int getMonth(Date date){ //声明为静态方法
    Calendar calendar = Calendar.getInstance();
    calendar.setTime(date);
    return calendar.get(Calendar.MONTH) + 1；
}
```

### 3.2 尽量使用基本数据类型作为方法参数类型

原因：避免不必要的装箱、拆箱和空指针判断

```java
//反例
public static double sum(Double value1, Double value2){ //不必要的拆箱
    double double1 = Objects.isNull(value1) ? 0.0D : value1; //不必要的空指针
    double double2 = Objects.isNull(value2) ? 0.0D : value2;
    return double1+double2;
}
double result = sum(1.0D, 2.0D) //不必要的装箱
//正例
public static double sum(double value1, double value2){ //只改这一处，简洁很多，但有空指针的情况要格外注意
    return double1+double2;
}
double result = sum(1.0D, 2.0D) 
```

### 3.3 尽量使用基本数据类型作为方法返回值类型

原因同上

### 3.4 协议方法参数值/返回值非空，避免不必要的空指针判断

协议编程，用@NonNull @Nullable标注参数

```java
//正例
public static boolean isValid(@NonNull UserDO user){
    return Boolean.TRUE.equals(user.getIsValid());
}
```

### 3.5 被调用方法已支持判空处理，调用方法无需再进行判空处理

### 3.6 尽量避免不必要的函数封装

原因：方法调用会引起出栈和入栈，消耗CPU和内存。但可以为了代码简洁易维护，增加方法调用而牺牲性能。

### 3.7 尽量指定方法的final修饰符

原因，同类的原因。方法指定final修饰符，可以让方法不可以被重写，Java编译器会寻找机会内联所有的final方法。

注：所有的private方法会隐式地被指定final修饰符，所以无须再为其指定final修饰符。

```java
//正例
public class Rectangle{
    public final double area(){
        ...
    }
    ...
}
```



## 4. 表达式

### 4.1 尽量减少方法的重复调用

### 4.2.尽量避免不必要的方法调用

### 4.3 尽量使用移位来代替正整数乘除

原因：用移位操作可以极大地提高性能！

```java
int num1 = a << 2; //乘4
int num2 = a >> 2; //除4
```

### 4.4 提取公共表达式，只计算一次值，重复利用值

### 4.5 尽量不在条件表达式里用`!`取反

### 4.6.对于多常量选择分支，尽量使用switch语句而不是if-else语句

和面向对象原则不太一样。

原因：switch语句进行了跳转优化，Java中采用`tableswitch`或`lookupswitch`指令实现，对于多常量选择分支处理效率更高。



## 5. 字符串

### 5.1 尽量不用正则表达式匹配

注意是匹配，用字符串匹配操作

### 5.2 尽量使用字符替换字符串

字符串长度不确定，而字符长度固定为1

### 5.3 尽量使用StringBuilder进行字符串拼接

原因：String是final类，内容不可修改，所以每次字符串拼接都会生成一个新对象。StringBuilder在初始化时申请了一块内存，以后的字符串拼接都在这块内存中执行，不会申请新内存和生成新对象。

```java
//正例
StringBuilder sb = new StringBuilder(128);
for(int i=0 ; i<10 ; i++){
    if( i != 0) sb.append(',');
    sb.append(i);
}
```

### 5.4 不要使用""+转化字符串,建议使用String.valueOf.

使用""+进行字符串转化，使用方便但是效率低

```java
int i=12345;
String s = String.valueOf(i);
```



## 6. 数组

### 6.1 不要使用循环拷贝数组

尽量使用`System.arraycopy`拷贝数组，也可以使用`Arrays.copyOf`拷贝数组。

```java
//反例
int[] sources = new int[] {1,2,3,4,5};
int[] targets = new int[sources.length];
for(int i=0 ; i<targets.length ; i++){
    targets[i] = sources[i];
}
//正例
int[] sources = new int[] {1,2,3,4,5};
int[] targets = new int[sources.length];
System.arraycopy(sources, 0, targets, 0, targets.length);
```

### 6.2 集合转化为类型T数组时，尽量传入空数组T[0]

将集合转换为数组有2种形式：`toArray(new T[n])`和`toArray(new T[0])`。

原因：在旧的Java版本中，建议使用`toArray(new T[n])`，因为创建数组时所需的反射调用非常慢。在OpenJDK6后，反射调用是内在的，使得性能得以提高，`toArray(new T[0])`比`toArray(new T[n])`效率更高。此外，`toArray(new T[n])`比`toArray(new T[0])`多获取一次列表大小，如果计算列表大小耗时过长，也会导致`toArray(new T[n])`效率降低。

```java
//反例
List<Integer> integerList = Arrays.asList(1,2,3,4,5,...);
Integer[] integers = integerList.toArray(new Integer[integerList.size()]);
//正例
List<Integer> integerList = Arrays.asList(1,2,3,4,5,...);
Integer[] integers = integerList.toArray(new Integer[0]);
```

### 6.3 集合转化为Object数组时，尽量使用toArray()方法

转化Object数组时，没有必要使用toArray[new Object[0]]，可以直接使用toArray()。避免了类型的判断，也避免了空数组的申请，所以效率会更高。

```java
List<Object> objectList =Arrays.asList(1,"2",3,"4",5,...);
Object[] objects = objectList.toArray();
```



## 7. 集合

### 7.1 初始化集合时，尽量指定集合大小

原因：当默认大小不再满足数据需求时就会扩容，**每次扩容的时间复杂度有可能是O(n)**。所以，尽量指定预知的集合大小，就能避免或减少集合的扩容次数。

### 7.2 不要用循环拷贝集合

原因：尽量使用JDK提供的方法拷贝集合，底层用`System.arraycopy`实现，进行数据的批量拷贝效率高

```java
//反例
for(UserDO user1 : user1List) {
    userList.add(user1);
}
//正例
userList.addAll(user1List);
```

### 7.3 尽量使用Arrays.asList转化数组为列表

### 7.4 直接迭代需要使用的集合

```java
//反例
Map<Long, UserDO> userMap = ...;
for(Long userId : userMap.keySet()){
    //用其他操作获取user
    UserDO user = userMap.get(userId);
    ...
}
//正例
Map<Long, UserDO> userMap = ...;
for(Map.Entry<Long, UserDO> userEntry: userMap.entrySet()){
    Long userId = userEntry.getKey();
    UserDO user = userMap.getValue();
    ...
}
```

### 7.5 不要使用size方法检测空，必须使用isEmpty方法检测空

原因：使用size方法来检测空逻辑上没有问题，但使用isEmpty方法使得代码**更易读**，并且可以获得更好的性能。任何isEmpty方法实现的时间复杂度都是O(1)，但是**某些size方法实现的时间复杂度有可能是O(n)**。

### 7.6 非随机访问的List，尽量使用迭代代替随机访问

### 7.7 尽量使用HashSet判断值存在

原因：在Java集合类库中，List的contains方法普遍时间复杂度是O(n)，而HashSet的时间复杂度为O(1)。

### 7.8 避免先判断存在再进行获取

原因：如果需要先判断存在再进行获取，可以直接获取并判断空，**从而避免了二次查找操作**。



## 8. 异常

### 8.1 避免在循环中捕获异常

原因：当循环体抛出异常后，**无需循环继续执行**（注意前提）时，没有必要在循环体中捕获异常。因为，过多的捕获异常会降低程序执行效率。

### 8.2 禁止使用异常控制业务流程

原因：异常处理效率比条件表达式低

```java
//反例
public static boolean isValid(UserDO user){
    try{
        return Boolean.TRUE.equals(user.getIsValid());
    } catch(NullPointerException e){
        return false; //用异常控制业务
    }
}
//正例
public static boolean isValid(UserDO user){
    if(Objects.isNull(user)) return false;
    return Boolean.TRUE.equals(user.getIsValid());
}
```



## 9. 缓冲区



## 10. 线程

