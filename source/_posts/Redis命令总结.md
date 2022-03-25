---
title: Redis命令总结
tags:
  - redis
  - nosql
categories: 数据库
copyright: true
abbrlink: 6c3cc871
date: 2020-01-21 01:12:24
---





# Redis数据类型

官方命令大全网址：http://www.redis.cn/commands.html

 

Redis中存储数据是通过key-value格式存储数据的，其中value可以定义五种数据类型：

- String（字符类型）
- Hash（散列类型）
- List（列表类型）
- Set（集合类型）
- SortedSet（有序集合类型，简称zset）

注意：在redis中的命令语句中，**命令是忽略大小写的，而key是不忽略大小写的。**



## 1.1  String类型

### 1.1.1 命令

#### 1.1.1.1    赋值

语法：**SET key value**

```shell
127.0.0.1:6379> set test 123  OK  
```

#### 1.1.1.2    取值

语法：**GET key**

```shell
127.0.0.1:6379> get test  "123“ 
```

#### 1.1.1.3    取值并赋值

语法：**GETSET key value**

```shell
127.0.0.1:6379>  getset s2 222  "111"  127.0.0.1:6379>  get s2  "222"  
```

#### 1.1.1.4    数值增减

**注意实现：**

1、 当value为整数数据时，才能使用以下命令操作数值的增减。

2、 数值递增都是**原子**操作。

​      非原子性操作示例：      int i = 1;      i++;      System.out.println(i)  

 

**递增数字**

语法：**INCR key**

  127.0.0.1:6379>  incr num  (integer)  1  127.0.0.1:6379>  incr num  (integer)  2  127.0.0.1:6379>  incr num  (integer)  3  

 

**增加指定的整数**

语法：**INCRBY key increment**

  127.0.0.1:6379>  incrby num 2  (integer)  5  127.0.0.1:6379>  incrby num 2  (integer)  7  127.0.0.1:6379>  incrby num 2  (integer)  9  

 

**递减数值**

语法：**DECR key**

  127.0.0.1:6379>  decr num  (integer)  9  127.0.0.1:6379>  decr num  (integer)  8  

 

**减少指定的整数**

语法：**DECRBY key decrement**

  127.0.0.1:6379>  decr num  (integer)  6  127.0.0.1:6379>  decr num  (integer)  5  127.0.0.1:6379>  decrby num 3  (integer)  2  127.0.0.1:6379>  decrby num 3  (integer)  -1  

 

#### 1.1.1.5    仅当不存在时赋值

**使用该命令可以实现分布式锁的功能，后续讲解！！！**

**语法：setnx key value**

 

redis> EXISTS job        # job 不存在

(integer) 0

redis> SETNX job "programmer"  # job 设置成功

(integer) 1

redis> SETNX job "code-farmer"  # 尝试覆盖 job ，失败

(integer) 0

redis> GET job          # 没有被覆盖

"programmer"

#### 1.1.1.6    其它命令

##### 1.1.1.6.1 向尾部追加值 

APPEND命令，向键值的末尾追加value。如果键不存在则将该键的值设置为value，即相当于 SET key value。返回值是追加后字符串的总长度。

语法：**APPEND key value**

  127.0.0.1:6379>  set str hello  OK  127.0.0.1:6379>  append str " world!"  (integer)  12  127.0.0.1:6379>  get str   "hello  world!"  

 

##### 1.1.1.6.2 获取字符串长度 

STRLEN命令，返回键值的长度，如果键不存在则返回0。

 

语法：**STRLEN key**

  127.0.0.1:6379> strlen str   (integer) 0  127.0.0.1:6379> set str hello  OK  127.0.0.1:6379> strlen str   (integer) 5     

 

##### 1.1.1.6.3 同时设置/获取多个键值

语法：

**MSET key value [key value …]**

**MGET key [key …]**

 

  127.0.0.1:6379>  mset k1 v1 k2 v2 k3 v3  OK  127.0.0.1:6379>  get k1  "v1"  127.0.0.1:6379>  mget k1 k3  1)  "v1"  2)  "v3"  

 

### 1.1.2 应用场景之自增主键

**需求：商品编号、订单号采用INCR命令生成。**

**设计：**key命名要有一定的设计

**实现：**定义商品编号key：items:id

192.168.101.3:7003> INCR items:id

(integer) 2

192.168.101.3:7003> INCR items:id

(integer) 3

## 1.2  Hash类型

### 1.2.1 hash介绍

hash叫**散列类型**，它提供了字段和字段值的映射。字段值只能是字符串类型，不支持散列类型、集合类型等其它类型。如下：

 

 

### 1.2.2 命令

#### 1.2.2.1    赋值

HSET命令不区分插入和更新操作，当执行插入操作时HSET命令返回1，当执行更新操作时返回0。

 

Ø 一次只能设置一个字段值

语法：**HSET key field value**  

  127.0.0.1:6379> hset user username zhangsan   (integer) 1  

 

Ø 一次可以设置多个字段值

语法：**HMSET key field value [field value ...]**     

  127.0.0.1:6379> hmset user age 20 username  lisi   OK  

 

Ø 当字段不存在时赋值，类似HSET，区别在于如果字段存在，该命令不执行任何操作

语法：**HSETNX key field value**

  127.0.0.1:6379> hsetnx user age 30   如果user中没有age字段则设置age值为30，否则不做任何操作  (integer) 0  

 

#### 1.2.2.2    取值

Ø 一次只能获取一个字段值

**语法：HGET key field**          

  127.0.0.1:6379> hget user username  "zhangsan“  

 

Ø 一次可以获取多个字段值

**语法：HMGET key field [field ...]**           

  127.0.0.1:6379> hmget user age username  1) "20"  2) "lisi"  

 

Ø 获取所有字段值

**语法：HGETALL key**

  127.0.0.1:6379> hgetall user  1) "age"  2) "20"  3) "username"  4) "lisi"  

 

 

 

 

#### 1.2.2.3    删除字段

可以删除一个或多个字段，返回值是被删除的字段个数 

 

**语法：HDEL key field [field ...]**

  127.0.0.1:6379> hdel user age  (integer) 1  127.0.0.1:6379> hdel user age name  (integer) 0  127.0.0.1:6379> hdel user age username  (integer) 1   

 

 

#### 1.2.2.4    增加数字

**语法：HINCRBY key field increment**

  127.0.0.1:6379> hincrby user age 2   将用户的年龄加2  (integer) 22  127.0.0.1:6379> hget user age       获取用户的年龄  "22“  

 

 

#### 1.2.2.5    其它命令(自学)

##### 1.2.2.5.1 判断字段是否存在

**语法：HEXISTS key field**

  127.0.0.1:6379> hexists user age     查看user中是否有age字段  (integer) 1  127.0.0.1:6379> hexists user name   查看user中是否有name字段  (integer) 0  

 

 

 

##### 1.2.2.5.2 只获取字段名或字段值

**语法：**

**HKEYS key**

**HVALS key**

  127.0.0.1:6379> hmset user age 20 name lisi   OK  127.0.0.1:6379> hkeys user  1) "age"  2) "name"  127.0.0.1:6379> hvals user  1) "20"  2) "lisi"  

 

 

##### 1.2.2.5.3 获取字段数量 

**语法：HLEN key**

  127.0.0.1:6379> hlen user  (integer) 2  

 

 

##### 1.2.2.5.4 获取所有字段

**作用：获得hash的所有信息，包括key和value**

**语法：hgetall key**

### 1.2.3 应用之存储商品信息

**注意事项：存储那些对象数据，特别是对象属性经常发生增删改操作的数据。**

Ø 商品信息字段

【商品id、商品名称、商品描述、商品库存、商品好评】

 

Ø 定义商品信息的key

商品ID为1001的信息在 Redis中的key为：[items:1001]

 

Ø 存储商品信息

  192.168.101.3:7003>  HMSET items:1001 id 3 name apple price 999.9  OK  

 

Ø 获取商品信息

  192.168.101.3:7003>  HGET **items:1001**  id  "3"  192.168.101.3:7003>  HGETALL items:1001  1)  "id"  2)  "3"  3)  "name"  4)  "apple"  5)  "price"  6)  "999.9"  

 

## 1.3  List类型

### 1.3.1 ArrayList与LinkedList的区别

​    ArrayList使用**数组方式**存储数据，所以根据索引查询数据速度快，而新增或者删除元素时需要设计到位移操作，所以比较慢。 

​    LinkedList使用**双向链表方式**存储数据，每个元素都记录前后元素的指针，所以插入、删除数据时只是更改前后元素的指针指向即可，速度非常快。然后通过下标查询元素时需要从头开始索引，所以比较慢，但是如果查询前几个元素或后几个元素速度比较快。



### 1.3.2 list介绍

Redis的列表类型（list）可以存储一个有序的字符串列表，常用的操作是**向列表两端添加元素，或者获得列表的某一个片段**。

​    列表类型内部是使用**双向链表（double linked list）实现**的，所以向列表两端添加元素的时间复杂度为0(1)，获取越接近两端的元素速度就越 快。这意味着即使是一个有几千万个元素的列表，获取头部或尾部的10条记录也是极快的。

 

### 1.3.3 命令

#### 1.3.3.1    向列表两端增加元素

Ø 向列表左边增加元素

**语法：LPUSH key value [value ...]**

  127.0.0.1:6379> lpush list:1 1 2 3  (integer) 3  

 

Ø 向列表右边增加元素 

**语法：RPUSH key value [value ...]**

  127.0.0.1:6379> rpush list:1 4 5 6  (integer) 3  

 

#### 1.3.3.2    查看列表

**语法：LRANGE key start stop**

LRANGE命令是列表类型最常用的命令之一，获取列表中的某一片段，将返回start、stop之间的所有元素（包含两端的元素），索引从0开始。索引可以是负数，如：**“-1”代表最后边的一个元素。**

 

  127.0.0.1:6379> lrange  list:1 0 2  1) "2"  2) "1"  3) "4"  

 

#### 1.3.3.3    从列表两端弹出元素

LPOP命令从列表左边弹出一个元素，会分两步完成：

l 第一步是将列表左边的元素从列表中移除

l 第二步是返回被移除的元素值。

 

**语法：**

**LPOP key**

**RPOP key**

  127.0.0.1:6379>  lpop list:1  "3“  127.0.0.1:6379>  rpop list:1  "6“  

 

#### 1.3.3.4    获取列表中元素的个数

**语法：LLEN key**

  127.0.0.1:6379> llen list:1  (integer) 2  

 

#### 1.3.3.5    其它命令(自学)

##### 1.3.3.5.1 删除列表中指定个数的值 

LREM命令会删除列表中前count个值为value的元素，返回实际删除的元素个数。根据count值的不同，该命令的执行方式会有所不同：

l 当count>0时， LREM会从列表左边开始删除。 

l 当count<0时， LREM会从列表后边开始删除。 

l 当count=0时， LREM删除所有值为value的元素。 

 

**语法：LREM key count value**

 

##### 1.3.3.5.2 获得/设置指定索引的元素值

Ø 获得指定索引的元素值

**语法：LINDEX key index**

  127.0.0.1:6379>  lindex l:list 2  "1"  

 

Ø 设置指定索引的元素值

**语法：LSET key index value**

  127.0.0.1:6379>  lset l:list 2 2  OK  127.0.0.1:6379>  lrange l:list 0 -1  1)  "6"  2)  "5"  3)  "2"  4)  "2"  

 

##### 1.3.3.5.3 只保留列表指定片段

指定范围和LRANGE一致 

 

**语法：LTRIM key start stop**

  127.0.0.1:6379> lrange l:list 0 -1  1) "6"  2) "5"  3) "0"  4) "2"  127.0.0.1:6379> ltrim l:list 0 2  OK  127.0.0.1:6379> lrange l:list 0 -1  1) "6"  2) "5"  3) "0"  

 

 

##### 1.3.3.5.4 向列表中插入元素 

该命令首先会在列表中从左到右查找值为pivot的元素，然后根据第二个参数是BEFORE还是AFTER来决定将value插入到该元素的前面还是后面。 

 

 

**语法：LINSERT key BEFORE|AFTER pivot value**

  127.0.0.1:6379>  lrange list 0 -1  1)  "3"  2)  "2"  3)  "1"  127.0.0.1:6379>  linsert list after 3 4  (integer)  4  127.0.0.1:6379>  lrange list 0 -1  1)  "3"  2)  "4"  3)  "2"  4)  "1"  

 

##### 1.3.3.5.5 将元素从一个列表转移到另一个列表中 

**语法：RPOPLPUSH source destination**

  127.0.0.1:6379> rpoplpush list newlist   "1"  127.0.0.1:6379> lrange newlist 0 -1  1) "1"  127.0.0.1:6379> lrange  list 0 -1  1) "3"  2) "4"  3) "2"  

 

### 1.3.4 应用之商品评论列表

l 需求1：用户针对某一商品发布评论，一个商品会被不同的用户进行评论，存储商品评论时，要按时间顺序排序。

l 需求2：用户在前端页面查询该商品的评论，需要安装时间顺序降序排序。

 

思路：

​    使用list存储商品评论信息，KEY是该商品的ID，VALUE是商品评论信息列表

商品编号为1001的商品评论key【items: comment:1001】

  192.168.101.3:7001>  LPUSH **items:comment:1001**  '{"id":1,"name":"商品不错，很好！！","date":1430295077289}'  

 

## 1.4  Set类型

### 1.4.1 set介绍

set类型即**集合类型**，其中的数据是**不重复且没有顺序**。

 

集合类型和列表类型的对比：

 

​    集合类型的常用操作是向集合中加入或删除元素、判断某个元素是否存在等，由于集合类型的Redis内部是使用值为空的散列表实现，所有这些操作的时间复杂度都为0(1)。

Redis还提供了多个集合之间的交集、并集、差集的运算。

### 1.4.2 命令

#### 1.4.2.1    增加/删除元素 

**语法：SADD key member [member ...]**

  127.0.0.1:6379> sadd set a b c  (integer) 3  127.0.0.1:6379> sadd set a  (integer) 0  

 

**语法：SREM key member [member ...]**

  127.0.0.1:6379> srem set c d  (integer) 1  

 

 

#### 1.4.2.2    获得集合中的所有元素

**语法：SMEMBERS key**

  127.0.0.1:6379>  smembers set  1)  "b"  2)  "a”  

 

#### 1.4.2.3    判断元素是否在集合中

**语法：SISMEMBER key member**

  127.0.0.1:6379>  sismember set a  (integer)  1  127.0.0.1:6379>  sismember set h  (integer)  0  

 

### 1.4.3 集合运算命令

#### 1.4.3.1    集合的差集运算 A-B

属于A并且不属于B的元素构成的集合。 

 

**语法：SDIFF key [key ...]**

  127.0.0.1:6379> sadd setA 1 2 3  (integer) 3  127.0.0.1:6379> sadd setB 2 3 4  (integer) 3  127.0.0.1:6379> sdiff setA setB   1) "1"  127.0.0.1:6379> sdiff setB setA   1) "4"  

 

#### 1.4.3.2    集合的交集运算 A ∩ B

属于A且属于B的元素构成的集合。 

 

**语法：SINTER key [key ...]**

  127.0.0.1:6379>  sinter setA setB   1)  "2"  2)  "3"  

 

#### 1.4.3.3    集合的并集运算 A ∪ B

属于A或者属于B的元素构成的集合

 

 

**语法：SUNION key [key ...]**

  127.0.0.1:6379> sunion setA setB  1) "1"  2) "2"  3) "3"  4) "4"  

 

### 1.4.4 其它命令(自学)

#### 1.4.4.1    获得集合中元素的个数

**语法：SCARD key**

  127.0.0.1:6379>  smembers setA   1)  "1"  2)  "2"  3)  "3"  127.0.0.1:6379>  scard setA   (integer)  3  

 

#### 1.4.4.2    从集合中弹出一个元素

注意：由于集合是无序的，所有SPOP命令会从集合中随机选择一个元素弹出 

 

**语法：SPOP key**

  127.0.0.1:6379> spop setA   "1“  

 

## 1.5  SortedSet类型zset 

### 1.5.1 sorted set介绍

​    在集合类型的基础上，有序集合类型为集合中的**每个元素都关联一个分数**，这使得我们不仅可以完成插入、删除和判断元素是否存在在集合中，还能够获得分数最高或最低的前N个元素、获取指定分数范围内的元素等与分数有关的操作。 

 

在某些方面有序集合和列表类型有些相似。

1、二者都是有序的。 

2、二者都可以获得某一范围的元素。 

但是，二者有着很大区别：

1、列表类型是通过链表实现的，获取靠近两端的数据速度极快，而当元素增多后，访问中间数据的速度会变慢。

2、有序集合类型使用散列表实现，所有即使读取位于中间部分的数据也很快。 

3、列表中不能简单的调整某个元素的位置，但是有序集合可以（通过更改分数实现）

4、有序集合要比列表类型更耗内存。 

 

### 1.5.2 命令

#### 1.5.2.1    增加元素

​    向有序集合中加入一个元素和该元素的分数，如果该元素已经存在则会用新的分数替换原有的分数。返回值是新加入到集合中的元素个数，不包含之前已经存在的元素。 

 

**语法：ZADD key score member [score member ...]**

  127.0.0.1:6379> zadd scoreboard 80 zhangsan 89  lisi 94 wangwu   (integer) 3  127.0.0.1:6379> zadd scoreboard 97 lisi   (integer) 0  

 

#### 1.5.2.2    获得排名在某个范围的元素列表

获得排名在某个范围的元素列表

Ø 按照元素分数**从小到大的**顺序返回索引从start到stop之间的所有元素（包含两端的元素）

 

**语法：ZRANGE key start stop [WITHSCORES]**           

  127.0.0.1:6379>  zrange scoreboard 0 2  1)  "zhangsan"  2)  "wangwu"  3)  "lisi“  

 

Ø 按照元素分数**从大到小**的顺序返回索引从start到stop之间的所有元素（包含两端的元素）



 

**语法：ZREVRANGE key start stop [WITHSCORES]**       

  127.0.0.1:6379>  zrevrange scoreboard 0 2  1)  " lisi "  2)  "wangwu"  3)  " zhangsan “  

 

如果需要获得元素的分数的可以在命令尾部加上WITHSCORES参数 

  127.0.0.1:6379>  zrange scoreboard 0 1 WITHSCORES  1)  "zhangsan"  2)  "80"  3)  "wangwu"  4)  "94"  

 

#### 1.5.2.3    获取元素的分数

**语法：ZSCORE key member**

  127.0.0.1:6379>  zscore scoreboard lisi   "97"  

 

#### 1.5.2.4    删除元素

移除有序集key中的一个或多个成员，不存在的成员将被忽略。

当key存在但不是有序集类型时，返回一个错误。

 

**语法：ZREM key member [member ...]**

  127.0.0.1:6379>  zrem scoreboard lisi  (integer)  1  

 

 

#### 1.5.2.5    其它命令(自学)

##### 1.5.2.5.1 获得指定分数范围的元素 

**语法：ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]**

  127.0.0.1:6379> ZRANGEBYSCORE scoreboard 90 97  WITHSCORES  1) "wangwu"  2) "94"  3) "lisi"  4) "97"  127.0.0.1:6379> ZRANGEBYSCORE scoreboard 70  100 limit 1 2  1) "wangwu"  2) "lisi"  

 

##### 1.5.2.5.2 增加某个元素的分数

返回值是更改后的分数

 

**语法：ZINCRBY key increment member**

  127.0.0.1:6379>  ZINCRBY scoreboard 4 lisi   "101“  

 

 

##### 1.5.2.5.3 获得集合中元素的数量 

**语法：ZCARD key**

  127.0.0.1:6379>  ZCARD scoreboard  (integer)  3  

 

##### 1.5.2.5.4 获得指定分数范围内的元素个数 

**语法：ZCOUNT key min max**

  127.0.0.1:6379> ZCOUNT scoreboard 80 90  (integer) 1  

 

##### 1.5.2.5.5 按照排名范围删除元素 

**语法：ZREMRANGEBYRANK key start stop**

  127.0.0.1:6379> ZREMRANGEBYRANK scoreboard 0 1  (integer) 2   127.0.0.1:6379> ZRANGE scoreboard 0 -1  1) "lisi"  

##### 1.5.2.5.6 按照分数范围删除元素 

**语法：ZREMRANGEBYSCORE key min max**

  127.0.0.1:6379>  zadd scoreboard 84 zhangsan      (integer)  1  127.0.0.1:6379>  ZREMRANGEBYSCORE scoreboard 80 100  (integer)  1  

 

##### 1.5.2.5.7 获取元素的排名 

Ø 从小到大

**语法：ZRANK key member**

  127.0.0.1:6379>  ZRANK scoreboard lisi   (integer)  0  

 

Ø 从大到小

**语法：ZREVRANK key member**

  127.0.0.1:6379>  ZREVRANK scoreboard zhangsan   (integer)  1  

 

### 1.5.3 应用之商品销售排行榜

l 需求：根据商品销售量对商品进行排行显示

l 思路：定义商品销售排行榜（sorted set集合），Key为items:sellsort，分数为商品销售量。

 

写入商品销售量：

Ø 商品编号1001的销量是9，商品编号1002的销量是10

  192.168.101.3:7007>  ZADD items:sellsort 9 1001 10 1002  

 

Ø 商品编号1001的销量加1

  192.168.101.3:7001>  ZINCRBY items:sellsort 1 1001  

 

Ø 商品销量前10名：

  192.168.101.3:7001>  ZRANGE items:sellsort 0 9 withscores  

 

## 1.6  通用命令

### 1.6.1 keys

返回满足给定pattern 的所有key

语法：**keys pattern**

  redis  127.0.0.1:6379> keys mylist*  1)  "mylist"  2)  "mylist5"  3)  "mylist6"  4)  "mylist7"  5)  "mylist8"  

 

 

### 1.6.2 del

**语法：****DEL key**

  127.0.0.1:6379> del test  (integer)  1  

 

### 1.6.3 exists

**作用：确认一个key 是否存在**

**语法：exists key**

示例：从结果来看，数据库中不存在HongWan 这个key，但是age 这个key 是存在的

  redis  127.0.0.1:6379> exists HongWan  (integer)  0  redis  127.0.0.1:6379> exists age  (integer)  1  redis  127.0.0.1:6379>  

 

### 1.6.4 expire 常用

Redis在实际使用过程中更多的用作缓存，然而缓存的数据一般都是需要设置生存时间的，即：到期后数据销毁。

 

  **EXPIRE key seconds**         设置key的生存时间（单位：秒）key在多少秒后会自动删除  **TTL key**                  查看key生于的生存时间  **PERSIST key**              清除生存时间    PEXPIRE key milliseconds   生存时间设置单位为：毫秒  

 

 

例子：

  192.168.101.3:7002> set test 1       设置test的值为1  OK  192.168.101.3:7002> get test        获取test的值  "1"  192.168.101.3:7002> EXPIRE test 5    设置test的生存时间为5秒  (integer) 1  192.168.101.3:7002> TTL test        查看test的生于生成时间还有1秒删除  (integer) 1  192.168.101.3:7002> TTL test  (integer) -2  192.168.101.3:7002> get test        获取test的值，已经删除  (nil)     

 

### 1.6.5 rename

**作用：重命名key**

**语法：rename oldkey newkey**

示例：age 成功的被我们改名为age_new 了

  redis  127.0.0.1:6379[1]> keys *  1)  "age"  redis  127.0.0.1:6379[1]> rename age age_new  OK  redis  127.0.0.1:6379[1]> keys *  1)  "age_new"  redis  127.0.0.1:6379[1]>  

 

### 1.6.6 type

**作用：显示指定key的数据类型**

**语法：type key**

示例：这个方法可以非常简单的判断出值的类型

  redis  127.0.0.1:6379> type addr  string  redis  127.0.0.1:6379> type myzset2  zset  redis  127.0.0.1:6379> type mylist  list  redis  127.0.0.1:6379>  

 

# 2  Redis事务

## 2.1  Redis事务介绍

l Redis的事务是通过**MULTI，EXEC，DISCARD和WATCH**这四个命令来完成的。

l Redis的单个命令都是**原子性**的，所以这里确保事务性的对象是**命令集合**。

l Redis将命令集合序列化并确保处于同一事务的**命令集合连续且不被打断**的执行

l Redis不支持回滚操作

## 2.2  相关命令

l **MULTI**

​    **用于标记事务块的开始**。

​    Redis会将后续的命令逐个放入队列中，然后使用EXEC命令原子化地执行这个命令序列。

​    **语法：multi**

l **EXEC**

​    **在一个事务中执行所有先前放入队列的命令**，然后恢复正常的连接状态

​    **语法：exec**

l **DISCARD**

​    **清除所有先前在一个事务中放入队列的命令**，然后恢复正常的连接状态。

​    **语法：discard**

l **WATCH**

​    当某个**事务需要按条件执行**时，就要使用这个命令将给定的**键设置为受监控**的状态。

​    **语法：watch key [key…]**

​    **注意事项：**使用该命令可以实现redis的**乐观锁**。

l **UNWATCH**

​    清除所有先前为一个事务监控的键。

​    **语法：unwatch**

## 2.3  事务失败处理

l Redis语法错误（可以理解为编译期错误）

l Redis类型错误（可以理解为运行期错误）

l **Redis****不支持事务回滚**

**为什么redis不支持事务回滚？**

1、 大多数事务失败是因为**语法错误或者类型错误**，这两种错误，在开发阶段都是可以预见的

2、 redis为了**性能方面**就忽略了事务回滚



