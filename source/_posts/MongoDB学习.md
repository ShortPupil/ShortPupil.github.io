---
title: MongoDB学习
tags:
  - mongodb
categories: 数据库
copyright: true
abbrlink: '88175981'
date: 2020-02-18 01:12:24
---



# 一、了解

## 1.什么是MongoDB?
MongoDB和MySQL一样都是数据库, 都是存储数据的仓库,
不同的是MySQL是关系型数据库, 而MongoDB是非关系型数据库

## 2.什么是非关系型数据库?

- 在'关系型数据库'中, 数据都是存储在表中的, 对存储的内容有严格的要求
  因为在创建表的时候我们就
  
  已经规定了表中有多少个字段,已经规定了每个字段将来要存储什么类型数据,已经规定了每个字段将来是否可以为空,是否必须唯一等等

- 在'非关系型数据库'中, 没有表概念, 所以存储数据更加灵活
  因为不需要创建表,所以也
  
  没有规定有哪些字段,也没有规定每个字段数据类型,也没有规定每个字段将来是否可以为空,是否必须唯一等等

- '关系型数据库'由于操作的都是结构化的数据, 所以我们需要使用结构化语言SQL来操作

- '非关系型数据库'由于数据没有严格的结构要求, 所以无需使用SQL来操作

## 3.什么是MongoDB?
存储文档(BSON)的非关系型数据库
例如在MySQL中:

```
|--------------------------------------------------------|
|   name(varchar(255) not null)   |    age(int unique)   |
|--------------------------------------------------------|
我们可以把            'zs', 33        保存到表中
但是我们不能将         33, 'zs'       保存到表中
但我们不能能将         null, 33       保存到表中
但是我们不能将         'zs', 33,  '男' 保存到表中
但是我们不能再次将     'zs', 33        保存到表中
```
例如在MongoDB中:

我们可以把         {name: 'zs', age: 33};              保存到集合中
我们也可以把       {name: 33, age: 'zs'};              保存到集合中
我们也可以把       {name: null, age: 33};              保存到集合中
我们也可以把       {name: 'zs', age: 33, gender:'男'}; 保存到集合中
但是我们可以再次将 {name: 'zs', age: 33};              保存到集合中

- '非关系型数据库'可以看做是'关系型数据库'的功能阉割版本,
  通过减少用不到或很少用的功能，从而提升数据库的性能

## 4.MongoDB是如何存储文档的?
MySQL中所有的数据都是存储在表中的, 而MongoDB中所有的数据都是存储在集合中的

### 4.1MySQL

```
                |--行1
        |--表1--|--行2
数据库--|       |--行3
        |--表2
        |--... ...
```
### 4.2MongoDB

```
                  |--文档1
        |--集合1--|--文档2
`数据库--|         |--文档3`
        `|--集合2`
        `|--... ...`
```

## 5.一般开发如何选择?

- 关系型数据库和非关系型数据库之间并不是替代关系, 而是互补关系
所以在企业开发中大部分情况是结合在一起使用.
- 对于数据模型比较简单、数据性能要求较高、数据灵活性较强的数据, 我们存储到非关系型数据库中
相反则存储到关系型数据库中
- 具体使用: 会在项目中实现



# 二、 基本操作学习

```js
// 1.导入mongoose
const mongoose = require('mongoose');

/*
mongodb://MongoDB服务器IP地址:MongoDB服务器端口号/需要打开的数据库名称
* */
// 2.利用mongoose链接MongoDB服务器
mongoose.connect('mongodb://127.0.0.1:27017/my_mongodb');

// 3.监听链接成功还是失败
let db = mongoose.connection;
db.on('error', (err)=>{
    console.log(err, '连接失败');
});
db.once('open', function() {
    console.log('连接成功');
});
db.once('close', function() {
    console.log('断开连接');
});

// 1.定义集合中存储数据规则
let userSchema = new mongoose.Schema({
    name: String,
    age: Number
});
// 2.利用规则创建集合
// 注意点: 只要创建好了模型, 那么以后就可以使用模型来操作这个集合
// 注意点: mongoose会自动将我们指定的集合名称变成复数
let User = mongoose.model('User', userSchema);

// 3.利用集合创建文档
// 注意点: 只要创建好了对象, 那么以后就可以使用对象来操作文档
let u = new User({ name: 'zs', age:18 });

// 4.操作文档
u.save((err, product) => {
    if (!err){
        console.log('文档保存成功');
        console.log(product);
    }
});
```



1.连接MongoDB服务器
通过mongo连接MongoDB服务器

2.查看数据库

```
show dbs
#和MySQL中的 show databases; 指令一样
```
3.创建数据库

```
use 数据库名称
#和MySQL中的 use 指令一样, 只不过MongoDB中的use数据库不存在会自动创建
```
4.查看数据库中有哪些集合

```sql
show collections
# 和MySQL中的 show tables; 指令一样
```

5.创建集合

```
db.createCollection('集合名称');
#和MySQL中的 create table xxx(); 指令一样
```

6.插入数据
```
db.集合名称.insert(文档对象);
#和MySQL中的 insert into xxx values () 指令一样
```
7.查询数据
```
db.集合名称.find();
#和MySQL中的 select * from xxx; 指令一样
```
8.删除集合
```
db.集合名称.drop()
#和MySQL中的 drop table xxx; 指令一样
```
9.删除数据库

```
db.dropDatabase()
#在哪个数据库中就会删除哪个数据库
#和MySQL中的 drop database xxx; 指令一样
```
10.和MySQL的不同
- 没有MySQL中表的概念, 取而代之的是集合
- 创建集合时不用指定集合中有哪些字段
- 只要是一个合法的文档对象都可以往里面存储
- ... ...

# 三、创建文档

## 1.主键

- MongoDB的主键和MySQL一样, 也是用于保证每一条**数据唯一性**的
- 和MySQL不同的是, MongoDB中的主键无需明确指定
    + 每一个文档被添加到集合之后, MongoDB都会**自动添加主键**
    + MongoDB中文档主键的名称叫做 _id

- 默认情况下文档主键是一个ObjectId类型的数据
    + ObjectId类型是一个12个字节字符串(5e8c5ae9-c9d35e-759b-d6847)
        + 4字节是存储这条数据的时间戳
        + 3字节的存储这条数据的那台电脑的标识符
        + 2字节的存储这条数据的MongoDB进程id
        + 3字节是计数器

## 2.为什么要使用ObjectId类型数据作为主键?
因为MongoDB是支持'横向扩展'的数据库

- 横向扩展是指'增加数据库服务器的台数'
- 纵向扩展是指'增加数据库库服务器的配置'
- 过去一个数据库只能安装在一台电脑上, 但是每台电脑的性能是有峰值的
- 一旦达到峰值就会导致服务器卡顿、宕机、重启等问题.
  所以过去为了防止如上问题的出现,我们只能不断的'纵向扩展'
  也就是不断的提升服务器的配置, 让服务器能处理更多的请求
  但是纵向扩展也是有峰值的, 一台电脑的配置不可能无限提升
  所以为了解决这个问题就有了分布式数据库
- **分布式数据库**是指**可以在多台电脑上安装数据库, 然后把多台电脑组合成一个完整的数据库,**
  **在分布式数据库中,我们可以通过不断同步的方式, 让多台电脑都保存相同的内容**
  当用户请求数据时, 我们可以把请求派发给不同的数据库服务器处理
  当某一台服务器宕机后, 我们还可以继续使用其它服务器处理请求
  从而有效的解决了单台电脑性能峰值和单台电脑宕机后服务器不能使用的问题

2.2为什么要使用ObjectId类型数据作为主键?

正是因为MongoDB是一个分布式数据库, 正是因为分布式数据库可以把请求派发给不同的服务器
所以第一次插入数据时, 我们可能派发给了A服务器, 插入到了A服务器的数据库中
但是第二次插入数据时, 我们又可能派发给了B服务器, 插入到了B服务器的数据库中
但是B服务器此时并不知道A服务器当前的主键值是多少, 如果通过MySQL中简单的递增来保证数据的唯一性
那么将来在多台服务器同步数据的时候就会出现重复的情况, 所以MongoDB的主键并没有使用简单的递增
而是使用了ObjectId类型数据作为主键

## 3.是否支持其它类型数据作为主键?
3.1 在MongoDB中支持除了'数组类型'以外的其它类型数据作为主键
3.2 在MongoDB中甚至还支持将一个文档作为另一个文档的主键(复合主键)

```sql
db.person.insert({name: 'lnj', age: 33});
db.person.insert({_id: 1, name: 'lnj', age: 33}); #报错，这个_id是由ESRI的软件来管理的，是不能够手动更改的

db.person.insert({_id: '1', name: 'lnj', age: 33});
db.person.insert({_id: {name:'it66', gender: '男'}, name: 'lnj', age: 33});
#db.person.insert({_id: {name:'it66', gender: '男'}, name: 'lnj', age: 33}); #报错
db.person.insert({_id: {gender: '男', name:'it66'}, name: 'lnj', age: 33});
```

# 四、文档操作 增删改查

```js
// 1.导入mongoose
const mongoose = require('mongoose');

// 2.利用mongoose链接MongoDB服务器
mongoose.connect('mongodb://127.0.0.1:27017/my');

// 3.监听链接成功还是失败
let db = mongoose.connection;
db.on('error', (err)=>{
    console.log(err, '连接失败');
});
db.once('open', function() {
    console.log('连接成功');
});
db.once('close', function() {
    console.log('断开连接');
});

// 1.定义集合中存储数据规则
let userSchema = new mongoose.Schema({
    name: String,
    age: Number
});

// 2.利用规则创建集合
let User = mongoose.model('User', userSchema);

// 增加
User.create({name:'zs', age:666}, (err, result)=>{
    if(!err){
        console.log('插入成功');
        console.log(result);
    }
});
User.create([
        {name:'ls', age:18},
        {name:'ls', age:22},
        {name:'ww', age:21},
        {name:'zl', age:23},
        {name:'lnj', age:33},
    ],
    (err, result)=>{
    if(!err){
        console.log('插入成功');
        console.log(result);
    }
});
(async ()=>{
    let result = await User.create([
            {name:'ls', age:18},
            {name:'ls', age:22},
            {name:'ww', age:21},
            {name:'zl', age:23},
            {name:'lnj', age:33},
        ]);
    console.log(result);
})();


// 查询
User.find({},{},(err, docs)=>{
    if(!err){
        console.log(docs);
    }
});
User.find({},{_id:0, name:1, age:1},(err, docs)=>{
    if(!err){
        console.log(docs);
    }
});
User.find({name:'ls'},{_id:0, name:1, age:1},(err, docs)=>{
    if(!err){
        console.log(docs);
    }
});
User.find({},{_id:0, name:1, age:1},{ skip: 5, limit: 5},(err, docs)=>{
    if(!err){
        console.log(docs);
    }
});
(async ()=>{
    let result = await User.find({},{_id:0, name:1, age:1},{ skip: 5, limit: 5});
    console.log(result);
})();

// 修改
User.update({name:'ls'},{$set:{age:888}},(err, docs)=>{
    if(!err){
        console.log('更新成功');
        console.log(docs);
    }
});
User.update({name:'ls'},{$set:{age:888}}, {multi: true},(err, docs)=>{
    if(!err){
        console.log('更新成功');
        console.log(docs);
    }
});
(async ()=>{
   let result = await User.update({name:'ls'},{$set:{age:123}}, {multi: true});
   console.log(result);
})();


// 删除
User.remove({name:'ww'}, {}, (err, docs)=>{
    if(!err){
        console.log('删除成功');
        console.log(docs);
    }
});
User.deleteOne({name:'lnj'}, (err, docs)=>{
    if(!err){
        console.log('删除成功');
        console.log(docs);
    }
});

(async ()=>{
    let result = await User.deleteOne({name:'lnj'});
    console.log(result);
})();
```





# 五、聚合

## 1.什么是聚合操作?

- 聚合操作就是通过一个方法完成一系列的操作
- 在聚合操作中, 每一个操作我们称之为一个阶段,
  聚合操作会将上一个阶段处理结果传给下一个阶段继续处理,
  所有阶段都处理完毕会返回一个新的结果集给我们

## 2.聚合操作格式
```
db.<collection>.aggregate(<pipeline>, <options>)
<pipeline>: 定义每个阶段操作
<options> : 聚合操作额外配置
```
## $project

1.聚合管道阶段

```
$project: 对输入文档进行再次投影
作用    : 按照我们需要的格式生成结果集
格式    : {$project:{<field>:<value>}}
```
2.示例

```
db.person.insert([
    {name:{firstName:'Jonathan', lastName:'Lee'}, age:18, book:{name:'玩转HTML', price: 88}},
    {name:{firstName:'Amelie', lastName:'Jiang'}, age:17, book:{name:'玩转JavaScript', price: 99}}
])
db.person.aggregate([
    {
        $project:{
            _id:0,
            clientName: '$name.firstName',
            clientAge: '$age'
        }
    }
])
```
5.聚合表达式

5.1 字段路径表达式
```
$<filed>: 使用$来指示字段路径
$<filed>.<sub-field>: 使用$和.来指示内嵌文档字段路径
```
5.2 字段路径表达式示例
```
$name
$book.name
```
6.注意点

```
// 注意点: $project修改的是结果集而不是原有的集合
db.person.find()
// 注意点: 如果字段表达式使用了不存在的字段, 那么会自动用Null填充
db.person.aggregate([
    {
        $project:{
            _id:0,
            fullName: ['$name.firstName', '$name.middleName','$name.lastName'],
            clientAge: '$age'
        }
    }
])
```
## $match

1.聚合管道阶段
`$match`: 和`find`方法中的第一个参数一样, 用于筛选符合条件的文档
格式  : `{$match:{<query>}}`

2.示例

```
db.person.aggregate([
    {
        $match:{
            'name.firstName':'Jonathan'
        }
    }
])
db.person.aggregate([
    {
        $match:{
            'name.firstName':'Jonathan'
        }
    },
    {
        $project:{
            _id:0,
            clientName: '$name.firstName',
            clientAge: '$age'
        }
    }
])
```

3.使用技巧:
应该在聚合操作的最前面使用`$match`, 这样可以有效减少处理文档的数量, 大大提升处理的效率



## $limit $skip

1.聚合管道阶段
```
$limit: 和游标的limit方法一样, 用于指定获取几个文档
格式  : {$limit:<number>}
$skip : 和游标的skip方法一样, 用于指定跳过几个文档
格式  : {$skip:<number>}
```
2.示例
```
db.person.aggregate([
    {
        $skip:1
    },
    {
        $limit:1
    },
    {
        $project:{
            _id:0,
            clientName: '$name.firstName',
            clientAge: '$age'
        }
    }
])
```

## $unwind
1.聚合管道阶段
```
$unwind: 展开数组字段
格式   : {$unwind:{path:<field>}}
```
2.示例:
```
db.person.update({'name.firstName':'Jonathan'}, {$set:{tags:['html', 'js']}})
db.person.update({'name.firstName':'Amelie'}, {$set:{tags:'vue'}})
db.person.aggregate([
    {
        $unwind:{
            path:'$tags'
        }
    }
])
```
3. 注意点:
   3.1 $unwind会为数组中的每个元素创建一个新的文档
   3.2 可以通过includeArrayIndex属性添加展开之后的元素在原数组中的位置
```
   db.person.aggregate([
       {
           $unwind:{
               path:'$tags',
               includeArrayIndex: 'index'
           }
       }
   ])
```

   3.3 如果需要展开的字段不存在, 或者数组中没有元素, 或者为null, 会被unwind剔除
```
   db.person.insert([
       {name:{firstName:'san', lastName:'zhang'}, age:20},
       {name:{firstName:'si', lastName:'li'}, age:21, tags:[]},
       {name:{firstName:'wu', lastName:'wang'}, age:22, tags:null}
   ])
```
   3.4 如果想让unwind不剔除不存在/没有元素/为Null的文档, 那么可以添加preserveNullAndEmptyArrays属性
```
   db.person.aggregate([
       {
           $unwind:{
               path:'$tags',
               includeArrayIndex: 'index',
               preserveNullAndEmptyArrays: true
           }
       }
   ])
```

## $sort
```
1.聚合管道阶段
$sort: 和文档游标sort方法一样, 对文档进行排序
格式   : `{$sort:{<field>>:1|-1}}`
```
2.示例

```
db.person.aggregate([
    {
        $sort:{
            age: 1
        }
    }
])
```

## $lookup
1.聚合管道阶段
```
$lookup: 用来做关联查询
格式   :
{$lookup:{
    from: 关联集合名称,
    localField: 当前集合中的字段名称,
    foreignField:关联集合中的字段名称,
    as: 输出字段的名称
}}
```
2.示例:
```
db.person.insert([
    {name:{firstName:'Jonathan', lastName:'Lee'}, age:18, books:['html', 'js']},
    {name:{firstName:'Amelie', lastName:'Jiang'}, age:19, books:['vue']},
    {name:{firstName:'si', lastName:'Li'}, age:20, books:[]}
])
db.books.insert([
    {name:'html', price:88},
    {name:'js', price:99},
    {name:'vue', price:110},
])

db.person.aggregate([
    {
        $lookup:{
            from: 'books',
            localField: 'books',
            foreignField: 'name',
            as: 'booksData'
        }
    }
])
```

3.和unwind阶段结合使用
可以有效的过滤掉无效数据
可以给每个匹配的结果生成一个新的文档
```
db.person.aggregate([
    {
        $unwind:{
            path:'$books'
        }
    },
    {
        $lookup:{
            from: 'books',
            localField: 'books',
            foreignField: 'name',
            as: 'booksData'
        }
    }
])
```

## $lookup
1.聚合管道阶段

```
$lookup: 用来做关联查询
格式   :
{$lookup:{
    from: 关联集合名称,
    let: {定义给关联集合的聚合操作使用的当前集合的常量},
    pipeline: [关联集合的聚合操作]
    as: 输出字段的名称
}}
```
2.示例:
不相关查询
```
db.person.aggregate([
    {
        $lookup:{
            from: 'books',
            pipeline: [
                {
                    $match:{
                        price:{$gte:100}
                    }
                }
            ],
            as: 'booksData'
        }
    }
])
```
相关查询
```
db.person.aggregate([
    {
        $lookup:{
            from: 'books',
            let: { bks: '$books'},
            pipeline: [
                {
                    $match:{
                        $expr:{
                            $and:[
                            {$gte: ['$price', 100]},
                            {$in: ['$name', '$$bks']}
                            ]
                        }
                        //price:{$gte:100}
                    }
                }
            ],
            as: 'booksData'
        }
    }
])
```
3系统变量表达式
`$$<variable>`: 使用$$来指示系统变量

## $group
1.聚合管道阶段
```
$group: 对文档进行分组
格式  :
{$group:{
    _id:<expression>,
    <field1>: {<accumulator1>: <expression1>}
    ... ...
}}
_id: 定义分组规则
<field>: 定义新字段
```
2.示例
```
db.person.insert([
{name:'zs', age:10, city:'北京'},
{name:'ls', age:20, city:'上海'},
{name:'ww', age:30, city:'北京'},
{name:'zl', age:40, city:'上海'},
{name:'lnj', age:50, city:'北京'},
{name:'jjj', age:60, city:'广州'},
])
db.person.aggregate([
    {$group:{
        _id:'$city',
        totalAge:{$sum:'$age'},
        avgAge:{$avg:'$age'},
        minAge:{$min:'$age'},
        maxAge:{$max:'$age'},
        totalName:{$push:'$name'}
    }}
])
```

## $out
1.聚合管道阶段
```
$out: 前面阶段处理完的文档写入一个新的集合
格式: {$out: <new collection name>}
```
2.示例:
```
db.person.aggregate([
    {
        $group:{
            _id: '$city',
            totalAge: {$sum:'$age'},
            avgAge: {$avg: '$age'},
            minAge: {$min: '$age'},
            maxAge: {$max: '$age'},
            totalAges: {$push: '$age'}
        }
    },
    {
        $out:'newPerson'
    }
])
db.newPerson.find()
```
3.注意点:
如果利用$out写入一个已经存在的集合, 那么集合中的原有数据会被覆盖

## allowDiskUse 额外配置
1.聚合操作额外配置
`db.<collection>.aggregate(<pipeline>, <options>)`

格式:` {allowDiskUse: <boolean>}`

allowDiskUse默认取值是false, 默认情况下管道阶段占用的内存不能超过100M,如果超出100M就会报错
如果需要处理的数据比较多, 聚合操作使用的内存可能超过100M, 那么我们可以将allowDiskUse设置为true
如果allowDiskUse设置为true, 那么一旦超出100M就会将操作的数据写入到临时文件中, 然后再继续操作


## `$ <filed>`
1.字段路径表达式

`$<filed>`: 使用$来指示字段路径

`$<filed>.<sub-field>`: 使用$和.来指示内嵌文档字段路径

2.示例

```
$name
$book.name
```
3.系统变量表达式

`$$CURRENT`: 表示当前操作的文档

4.示例

`$$CURRENT.name`  等价于 `$name`

5.常量表达式

`$literal:<value>` : 表示常量`<value>`

6.示例

`$literal:'$name'` : 表示常量字符串`$name`

```
db.person.insert([
    {name:{firstName:'Jonathan', lastName:'Lee'}, age:18},
    {name:{firstName:'Amelie', lastName:'Jiang'}, age:19}
])
db.person.find()

db.person.aggregate([
    {$project:{
        _id:0,
        //myName:'$name.firstName', // 字段路径表达式
        //myAge:'$age' // 字段路径表达式
        //myName:'$$CURRENT.name.firstName', //系统变量表达式
        //myAge:'$$CURRENT.age' // 系统变量表达式
        myName:'$name.firstName',
        myAge:{$literal:'$age'} // 常量表达式
    }}
])
```

## $convert
1.数据类型转换操作符
- MongoDB对于文档的格式并没有强制性的要求, 同一个集合中存储的文档, 字段的个数和数据类型都可以不同
对与文档的格式没有强制性的要求是MongoDB的一大优势, 但是同时也增加了数据消费端的使用难度
因为我们在使用数据的时候, 有可能同一个字段取出来的数据类型是不同的, 这样非常不利于我们后续操作
所以也正是因为如此, MongoDB在4.0中推出了$convert数据类型转换操作符
- 通过$convert数据类型转换操作符, 我们可以将不同的数据类型转换成相同的数据类型,
以便于后续我们在使用数据的过程中能够统一对数据进行处理

2.$convert格式
```
{$convert:{
    input: '需要转换的字段',
    to: '转换之后的数据类型',
    onError: '不支持的转换类型',
    onNull: '没有需要转换的数据'
}}
```
3.示例
```
db.person.insert([
{name:'zs', timestamp:ISODate('2020-08-09T11:23:34.733Z')},
{name:'ls', timestamp:'2021-02-14 12:00:06 +0800  '},
{name:'ww', timestamp:'  2023-04-01T12:00:00Z'},
{name:'zl', timestamp:'1587009270000'},
{name:'it666', timestamp:'Sunday'},
{name:'itzb'},
])
db.person.aggregate([
    {$project:{
        _id:0,
        timestamp:{
            $convert:{
                input:'$timestamp',
                to:'date',
                onError: '不支持的转换类型',
                onNull: '没有需要转换的数据'
            }
        }
    }}
])
```


## 聚合管道优化

[聚合管道优化 - MongoDB-CN-Manual (mongoing.com)](https://docs.mongoing.com/aggregation/aggregation-pipeline/aggregation-pipeline-optimization)



# 六、索引


## 1.什么是索引?

- 索引就相当于字典中的目录(拼音/偏旁部首手)
  有了目录我们就能通过目录快速的找到想要的结果.
- 但是如果没有目录(拼音/偏旁部首手), 没有索引
  那么如果想要查找某条数据就必须从前往后一条一条的查找
- 所以索引就是用于提升数据的查询速度的

## 2.如何获取索引
```
db.<collection>.getIndexes()

db.person.insert([
{name:'cs', age:19},
{name:'as', age:18},
{name:'bs', age:17},
]);
```
## 3.如何创建索引
```
db.<collection>.createIndex({<field>:<1 or -1>, ...}, <options>)
<keys>   : 指定创建索引的字段
<options>: 索引的额外配置
```
## 4.创建单键索引
```
db.person.createIndex({name:1})
db.person.explain().find({age:17})
db.person.explain().find({name:'cs'})
db.person.explain().find({name:'cs'}, {_id: 0, name:1})
```
## 5.查看是否使用索引
和MySQL一样, 我们可以通过explain来查看索引效果
```
db.<collection>.explain().<method()>
winningPlan->stage->COLLSCAN->遍历整个集合查询
winningPlan->stage->IXSCAN->  通过索引查询
winningPlan->stage->FETCH->   根据索引存储的地址取出对应文档
```
6.索引格式
```
as -> {name:'as', age:18, tags:['ahtml', 'bcss']}
bs:-> {name:'bs', age:17, tags:['cjs', 'dvue']}
cs:-> {name:'cs', age:19, tags:['enode', 'freact']}
```
7.注意点:
- 和MySQL一样, MongoDB默认也会为主键自动创建索引
- 如果查询条件中只需要查询出索引字段, 那么就不会再取出完整文档, 这样效率更高


## 复合索引
1.和MySQL一样, MongoDB也支持复合索引, 也就是将多个字段的值作为索引

2.示例
```
db.person.insert([
{name:'cs', age:19},
{name:'as', age:18},
{name:'bs', age:17},
{name:'bs', age:20},
])
db.person.createIndex({name:1, age:-1})
db.person.explain().find({name:'bs', age:17})
db.person.explain().find({name:'bs'})
db.person.explain().find({age:17})
```
3.索引格式
```
(as, 18)->{name:'as', age:18}
(bs, 20)->{name:'bs', age:20}
(bs, 17)->{name:'bs', age:17}
(cs, 19)->{name:'cs', age:19}
```
4.注意点:
复合件索引只支持前缀子查询, 也就是A,B,C复合索引. A,B,C会使用索引, A,B会使用索引, A会使用索引
但是B不会使用索引, C也不会使用索引, B,C也不会使用索引


## 多键索引
多键索引是专门针对数组字段的, 会为数组字段的每一个元素都创建一个索引

2.示例
```
db.person.insert([
{name:'as', age:18, tags:['ahtml', 'bcss']},
{name:'bs', age:17, tags:['cjs', 'enode']},
{name:'cs', age:19, tags:[ 'dvue', 'freact']},
])
db.person.explain().find({'tags':{$in:['ahtml']}})
db.person.createIndex({tags:1})
db.person.explain().find({'tags':{$in:['ahtml']}})
```
3.格式
```
'ahtml'->{name:'as', age:18, tags:['ahtml', 'bcss']}
'bcss'->{name:'as', age:18, tags:['ahtml', 'bcss']}
'cjs'->{name:'bs', age:17, tags:['cjs', 'enode']}
'dvue'->{name:'cs', age:19, tags:[ 'dvue', 'freact']}
'enode'->{name:'bs', age:17, tags:['cjs', 'enode']}
'freact'->{name:'cs', age:19, tags:[ 'dvue', 'freact']}
```

## 索引对排序的影响
如果排序的字段, 正好是索引的字段, 那么会大大提升排序效率

2.示例
```
db.person.insert([
{name:'cs', age:19},
{name:'as', age:18},
{name:'bs', age:17}
])
db.person.explain().find().sort({name:1})
db.person.createIndex({name:1})
db.person.explain().find().sort({name:1})
db.person.explain().find().sort({name:1, age:-1})
db.person.createIndex({name:1, age:-1})
db.person.explain().find().sort({name:1, age:-1})
```

3.注意点
如果是复合索引, 那么只有排序条件是前缀查询的形式才会使用索引来排序
例如:
复合件索引只支持前缀子查询, 也就是A,B,C复合索引. 
A,B,C会使用索引, A,B会使用索引, A会使用索引.
但是B不会使用索引, C也不会使用索引, B,C也不会使用索引

## 唯一索引
默认情况下MongoDB和MySQL一样, 都会自动为主键创建索引, 这个索引就是一个唯一索引
除了主键可以作为唯一索引以外, 只要某个字段的取值是唯一的, 我们也可以手动给这个字段添加唯一索引
格式: `db.<collection>.createIndex({<field>:<1 or -1>, ...}, {unique:true}})`

2.示例
```
db.person.insert([
{name:'cs', age:19},
{name:'as', age:18},
{name:'bs', age:17}
])
db.person.getIndexes()
db.person.createIndex({age:1}, {unique:true})
db.person.insert({name:'zs', age:20})
db.person.insert({name:'ls'})
db.person.find()
db.person.insert({name:'ls'})
db.person.createIndex({name:1,age:1}, {unique:true})
db.person.insert({name:'ww', age:22})
db.person.insert({name:'ww', age:22})
db.person.insert({name:'ww', age:23})
```
3.注意点
3.1如果为某个字段添加了唯一索引, 那么就不能再给这个字段添加重复的值
3.2如果插入的数据中没有包含唯一索引的字段, 那么第一次会自动用null填充, 第二次会报错
3.3如果是复合唯一索引, 那么复合字段的组合不能重复


## 索引的稀疏性
默认情况下MongoDB会给每一个文档都创建索引, 哪怕这个文档中没有指定索引的字段或者字段的取值是Null
但是这样大大增加了索引的体积, 所以为了进一步优化索引占用的存储空间, 我们可以创建稀疏索引
也就是只会为存在索引字段,并且索引字段取值不是null的文档创建索引
格式: db.<collection>.createIndex({<field>:<1 or -1>, ...}, {sparse:true}})

2.示例

```
db.person.insert([
{name:'cs', age:19},
{name:'as', age:18},
{name:'bs', age:17}
])
db.person.find()
db.person.getIndexes()
db.person.createIndex({age:1}, {unique:true})
db.person.insert({name:'lnj'}) // lnj null
db.person.insert({name:'lnj'}) // lnj null
// 注意点: 如果索引具备了唯一性又具备了稀疏性, 那么就可以多次添加缺失了索引字段的文档了
// 原因 : 如果索引具备了稀疏性, 那么就不会为缺失了索引字段或者索引字段取值是null的文档创建索引了, 所以就不会冲突了
db.person.createIndex({age:1}, {unique:true, sparse: true})
db.person.insert({name:'lnj'}) // lnj null
db.person.insert({name:'lnj'}) // lnj null
```
3.注意点
3.1如果索引字段既具备唯一性又具备稀疏性, 那么就可以在集合中保存多个缺失唯一索引字段的文档

## 索引生存时间
针对日期字段或者包含日期的数组字段, 我们可以在创建索引的时候, 指定索引的生存时间,
一旦索引超过了指定的生存时间, 那么MongoDB会自动删除超过生存时间的文档
格式: db.<collection>.createIndex({<field>:<1 or -1>, ...}, {expireAfterSeconds:second}})

2.示例
```
db.person.createIndex({addTime:1}, {expireAfterSeconds: 5})
db.person.insert({name:'zs', addTime:new Date()})
db.person.insert({name:'ls', addTime:new Date()})
db.person.insert({name:'ww', addTime:new Date()})
```

3.注意点
3.0 MongoDB会定期清理超过时间的文档, 但是无法保证即时性(也就是设置的过期时间是1秒, 但是可能3秒后才会清除)
3.1 复合索引字段是不具备生存时间特性的, 也就是不能在复合索引中指定生存时间
3.2 当数组字段中包含多个日期, 我们给数组字段设置生存时间时, 系统会按照数组中最小的时间来计算生存时间
例如: `{name:'it666', times:['2022-04-16 09:13:33','2022-04-16 07:13:33','2022-04-16 08:13:33']}`
       会按照'2022-04-16 07:13:33'来计算生存时间

## 删除索引
`db.<collection>.dropIndex(<IndexName | IndexDefine>)`

2.示例
```
db.person.insert([
{name:'cs', age:19},
{name:'as', age:18},
{name:'bs', age:17}
])
db.person.find()
db.person.getIndexes()
db.person.createIndex({name:1})
db.person.dropIndex('name_1') // 通过索引的名称来删除
db.person.dropIndex({name:1}) // 通过索引的定义来删除
// 注意点: 如果是复合索引, 如果需要通过索引的定义来删除, 那么就必须一模一样才能正确的删除
db.person.createIndex({name:1, age:-1})
db.person.dropIndex({name:1}) // 报错
db.person.dropIndex({age:-1}) // 报错
db.person.dropIndex({age:-1, name:1}) // 报错
db.person.dropIndex({name:1, age:-1}) // 不会报错
```
3.注意点
3.1在MongoDB中没有修改索引的方法, 所以如果想修改索引就必须先删除再重新创建
3.2如果删除的索引是多个字段, 如果是通过索引定义来删除, 那么传入的参数必须和定义一模一样才可以

# 七、数据模型

1.文档之间关系
MongoDB对于文档的格式并没有强制性的要求, 但不等于我们不能在文档中表达数据的关系
在MongoDB中我们可以通过'内嵌式结构'和'规范式结构'来表达文档之间的关系

2.内嵌式结构
在一个文档中又包含了另一个文档, 我们就称之为内嵌式结构
例如:
{
    name:'zs',
    age:'18',
    card:{
        num:'420626200002023556',
        date: 88
    }
}

3.规范式结构
将文档存储在不同的集合中, 然后通过某一个字段来建立文档之间的关系, 我们就称之为规范式
{
    _id: 1,
    num:'420626200002023556',
    date: 88
}
{
    name:'zs',
    age:'18',
    cardId: 1
}

1.文档一对一关系
一个人有一张身份证
1.1内嵌式结构
db.person.insert({
    name:'zs',
    age:'18',
    card:{
        num:'420626200002023556',
        date: 88
    }
})
db.person.find({name:'zs'})
优势: 一次查询就能得到所有数据
劣势: 如果数据比较复杂, 不方便管理和更新
应用场景: 数据不复杂/查询频率较高数据

1.2规范式结构
db.card.insert({
    _id: 123,
    num:'420626200002023556',
    date: '2022-12-08',
    userId: 456
})
db.person.insert({
    _id: 456,
    name:'zs',
    age:'18',
    cardId: 123
})
db.person.aggregate([
    {$lookup:{
        from: 'card',
        localField: 'cardId',
        foreignField: '_id',
        as: 'card'
    }}
])
优势: 如果数据比较复杂, 也方便管理和更新
劣势: 查询数据相对内嵌结果稍微有点复杂
应用场景: 数据比较复杂/更新频率较高数据

1.文档一对多关系
一个人有多本书
1.1内嵌式结构
db.person.insert({
    name:'zs',
    age:'18',
    books:[{
        name:'玩转HTML',
        price: 88
    },
    {
        name:'玩转CSS',
        price: 88
    }]
})
db.person.find({name:'zs'})
优势: 一次查询就能得到所有数据
劣势: 冗余数据较多, 不方便管理和更新
应用场景: 数据不复杂/查询频率较高数据

1.2规范式结构
db.books.insert([{
    _id: 1,
    name:'玩转HTML',
    price: 88,
    userId:123
},
{
    _id: 2,
    name:'玩转CSS',
    price: 88,
    userId:123
}])
db.person.insert({
    _id: 123,
    name:'ls',
    age:'20',
    booksId:[1, 2]
})
db.person.aggregate([
    {$lookup:{
        from: 'books',
        localField: 'booksId',
        foreignField: '_id',
        as: 'books'
    }}
])
优势: 冗余数据较少, 更新较为方便
劣势: 查询数据相对内嵌结果稍微有点复杂
应用场景: 数据比较复杂/更新频率较高数据

1.文档多对多关系
一个学生有多个老师
一个老师有多个学生
1.1内嵌式结构
db.students.insert([{name:'zs', teachers:[{name:'it666'}, {name:'itzb'}]},
{name:'ls', teachers:[{name:'it666'}, {name:'itzb'}]}])

db.teachers.insert([{name:'it666', students:[{name:'zs'}, {name:'ls'}]},
{name:'itzb', students:[{name:'zs'}, {name:'ls'}]}])
db.students.find({name:'zs'})
db.teachers.find({name:'itzb'})
优势: 一次查询就能得到所有数据
劣势: 冗余数据较多, 更新和管理较为复杂
应用场景: 数据比较简单/查询频率较高数据

1.2规范式结构
db.students.insert([{_id:1, name:'zs'},{_id:2, name:'ls'}])
db.teachers.insert([{_id:3, name:'it6666'},{_id:4, name:'itzb'}])
db.relation.insert([{stuId:1, teacherId:3},{stuId:1, teacherId:4},{stuId:2, teacherId:3},{stuId:2, teacherId:4}])

db.students.aggregate([
    {$lookup:{
        from: 'relation',
        localField: '_id',
        foreignField:'stuId',
        as: 'relation'
    }},
    {$lookup:{
        from: 'teachers',
        localField: 'relation.teacherId',
        foreignField:'_id',
        as: 'teachers'
    }},
    {$project:{_id:0, name:1, teachers:1}}
])

优势: 冗余数据较少, 更新较为方便
劣势: 查询数据相对内嵌结果稍微有点复杂
应用场景: 数据比较复杂/更新频率较高数据

1.树形结构
在MongoDB中我们除了可以使用'内嵌式结构'和'规范式结构'来表示数据的关系以外
由于MongoDB数据的灵活性, 我们还可以使用'树形结构'来表示数据之间的关系

2.什么是树形结构
            Database
               |
     |--------------------|
 Relational           No-Relational
     |          |-----------|-------------|
   MySQL      Key-Value                Document
                |                         |
              Redis                    MongoDB

3.对于经常需要查询子节点的数据
{name:'Database', parent:null}
{name:'No-Relational', parent:'Database'}
{name:'Document', parent:'No-Relational'}
{name:'MongoDB', parent:'Document'}
{name:'Key-Value', parent:'No-Relational'}
{name:'Redis', parent:'Key-Value'}
例如:我们要查询非关系型数据库有几种类型, 我们可以使用find({parent:'No-Relational'})

4.对于经常需要查询父节点的数据
{name:'Database', children:['Relational', 'No-Relational']}
{name:'No-Relational', children:['Key-Value', 'Document']}
{name:'Document', children:['MongoDB']}
{name:'MongoDB', children:[]}
例如:我们要查询MongoDB是什么类型的的数据, 我们可以使用find({children:{$in:['MongoDB']}})

5.对于经常查询祖先或者后代节点的数据
{name:'Database', ancestors:[]}
{name:'No-Relational', ancestors:['Database']}
{name:'Document', ancestors:['Database', 'No-Relational']}
{name:'MongoDB', ancestors:['Database', 'No-Relational', 'Document']}
例如: 我们要查询MongoDB的祖先有哪些, 我们可以使用find({name:'MongoDB'})
例如: 我们要查询Database的后代有哪些, 我们可以使用find({ancestors:{$in:['Database']}}})

6.结合深度优先或者广度优先算法来实现树形结构


# 八、复制集

1.MongoDB高可用性

- 如果所有用户都从同一台MongoDB服务器上读写数据
  那么如果这台MongoDB服务器宕机了, 用户就不能进行读写了
- 如果我们有多台MongoDB服务器, 并且每台服务器中存储的内容都相同
  那么即使有一台服务器宕机了, 用户依然可以进行读写数据, 因为用户还可以继续使用其它保存了相同内容的服务器
- 以上这种特点, 我们就称之为'高可用性'

2.MongoDB数据安全性
- 如果所有数据都保存在同一台MongoDB服务器上
  那么如果这台MongoDB服务器坏了, 那么很有可能会导致数据丢失
- 如果我们有多台MongoDB服务器, 并且每台服务器中存储的内容都相同
  那么即使有一台服务器坏了, 那么依然不会导致数据丢失, 因为我们还有其它保存了相同内容的服务器
- 以上这种特点, 我们就称之为'数据的安全性'

3.MongoDB数据分流
- 如果所有用户都从同一台MongoDB服务器上读写数据
  那么由于服务器的性能限制和网络传输速度的限制
  会导致同一时刻用户量较多时, 服务器负荷增大, 数据处理速度变慢的问题
  会导致由于用户距离服务器较远, 网络传输时间变长, 响应速度变慢的问题
- 如果我们有多台MongoDB服务器, 并且每台服务器中存储的内容都相同, 并且安放到了不同的地区
  那么我们可以采用就近原则返回数据, 提升网络的传输速度
  那么我们可以采用请求分流, 降低每台服务器负荷, 提升数据处理速度
- 以上这种特点, 我们就称之为'数据分流'

4.MongoDB复制集
- 在MongoDB中我们可以通过复制集来实现如上的功能
- 复制集就是使用多台保存了相同内容的MongoDB服务器来组成一个数据库集群
  这个数据库集群中的每一台MongoDB服务我们称之为一个节点


1.MongoDB复制集特点
- 复制集中必须有一个主节点
    + 主节点主要负责写入数据和读取
- 复制集中除了主节点以外的节点我们称之为'副节点'
    + 副节点默认情况下只能读取数据, 不能写入数据
    + 副节点主要负责从主节点不断复制数据
- 复制集中所有的节点都会不断的相互发送心跳请求
    + 心跳请求的目的是相互检查节点的健康程度(是否发生故障)
    + 默认情况下每个2秒发送一次心跳请求
    + 默认情况下如果10秒没有收到某一个节点心跳请求, 系统就会认定为超时
- 复制集中节点的个数是有限制的
    + 每个复制集中最多只能有50个节点
    + 由于节点会发送心跳请求(消耗性能), 所以并不是节点越多越好

2.复制集选举
- 复制集最大的特点之一就是高可用性,
  但是在复制集中只有一个主节点, 只有主节点可以读写
  那么如果主节点宕机了, 也就意味着用户只能读取数据, 不能写入数据了
- 复制集中的主节点是通过选举出来的, 也就是一旦当前主节点宕机了
  MongoDB会通过自动选举的方式, 将其它的副节点设置为主节点
- 正式因为复制集的这个特点, 大大的保证了数据库的高可用性


1.选举规则
- 一旦发现主节点没有响应/发送心跳请求, 那么副节点就会认为主节点挂了
- 一旦发现主节点挂了, 任意一个副节点都可以发起选举
- (发起选举的节点我们称之为候选节点, 每一个节点内部都有一个选举计数器)
- 发起选举的节点会给自己先投一票, 然后将自己的票数依次发送给其它节点
- 其它节点收到投票请求后,会先利用发送过来的票数同步自己计数器的票数
  然后再对比自己的数据和候选节点的数据哪个更完整
  如果自己的更完整, 那么会投出反对票
  如果候选节点的更完整, 那么会投出赞同票
- 最后如果超过半数的节点投出赞同票, 那么候选节点就会变成主节点
- 最后如果没有超过半数节点投出赞同票, 那么其它节点会重新发起选举, 重复上述过程

2.选举注意点
- 一个复制集中最多只能有7个投票节点
- 如果某个节点没有返回投票结果, 那么默认就是不赞同
    + 挂掉的节点不会返回结果
- 因为选举需要超过半数节点同意,才会将副节点变成主节点
  所以在企业开发中一个复制集至少需要3个节点
  否则一旦主节点挂了, 永远无法完成投票
- 因为选举需要超过半数节点同意,才会将副节点变成主节点
  所以在企业开发中节点的个数最好是奇数

3.触发选举的其它条件
- 初始化复制集时, 会自动触发选举
- 有新节点加入时, 会自动触发选举
- 当前主节点挂掉时, 会自动触发选举


1.初始化同步
- 将一个新的节点加入到复制集中时, 就需要进行初始化同步
- 初始化同步会先情况自己所有的内容, 保证将来自己和主节点一模一样
- 初始化同步会将主节点中现有所有的'数据库','集合','文档','索引'全部拷贝过来
- 但是在拷贝的过程中主节点仍然可能会做一些其它操作, 新增一些其它的数据等
  所以仅仅做一次大型的拷贝是不能保证副节点和主节点一模一样的

2.同步写库记录
- 每个节点中都有一个local数据库, 这个数据库中有一个oplog的集合
  这个集合就是专门用来保存数据库的操作记录的(写库记录)
- 做完初始化同步之后, 副节点就会定期从主节点中拷贝写库记录
  将写库记录保存到自己的local数据库中, 然后执行写库记录中的操作
  从而使得自己的内容和主节点的内容保持高度一致

3.写库记录注意点
- 写库记录是可以被多次应用的, 但是多次应用和一次应用的效果是一样的
  也就是有效的防止了多次应用造成的主节点和副节点内容不一致问题
- 应用写库记录的时候是通过多线程分批次应用的, 这样大大提高了引用的效率和性能


1.投票节点
- 投票节点就是不保存任何数据, 只参与投票的节点
- 无论是初始化同步, 还是同步写库记录, 其实都会消耗服务器性能
  所以在企业开发中并不是副节点越多越好
  所以在保证高可用性、数据库安全性的同时, 为了提升服务器的性能
  我们还可以添加投票节点
- 投票节点不保存任何数据, 所以就不存在同步数据带来的性能消耗问题
- 投票节点可以投票, 就保证了不会出现副节点过少无法完成投票问题


1.MongoDB复制集搭建
https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2012plus-4.2.6.zip
1.1解压MongoDB安装包
1.2在安装目录下新建data/conf/log文件夹
1.3在conf文件夹下新建mongo.config
1.4在mongo.config中配置如下内容
```
# Where and how to store data.
storage:
  dbPath: D:\Developer\MongoDB666\mongodb27020\data
  journal:
    enabled: true
# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path:  D:\Developer\MongoDB666\mongodb27020\log\mongo.log
# network interfaces
net:
  port: 27020
  bindIp: 127.0.0.1
```
1.5注册配置MongoDB
1.5.1注册服务
```
mongod --config D:\Developer\MongoDB666\mongodb27018\bin\mongo.config --serviceName "MongoDB27018" --serviceDisplayName "MongoDB27018" --replSet "it666" --install
mongod --config D:\Developer\MongoDB666\mongodb27019\bin\mongo.config --serviceName "MongoDB27019" --serviceDisplayName "MongoDB27019" --replSet "it666" --install
mongod --config D:\Developer\MongoDB666\mongodb27020\bin\mongo.config --serviceName "MongoDB27020" --serviceDisplayName "MongoDB27020" --replSet "it666" --install
```
1.5.2手动启动服务
1.5.3测试连接
mongo --host 127.0.0.1 --port 27018
mongo --host 127.0.0.1 --port 27019
mongo --host 127.0.0.1 --port 27020
1.6初始化复制集
rs.initiate({
_id: 'it666',
members: [
{_id: 0, host: '127.0.0.1:27018'},
{_id: 1, host: '127.0.0.1:27019'},
{_id: 2, host: '127.0.0.1:27020'}]
})
1.7在主节点写入读取
1.8在副节点读取rs.slaveOk()


_id            整数 节点的唯一标识。
host       字符串    节点的IP地址，包含端口号。
arbiterOnly    布尔值    是否为投票节点，默认是false。是设置投票(选举)节点有关的参数
priority   整数 选举为主节点的权值，默认是1，范围0-1000。
hidden     布尔值    是否隐藏，默认false，是设置隐藏节点有关的参数。
votes      整数 投票数，默认为1，取值是0或1，是设置”投票“节点有关的参数。
slaveDelay 整数 延时复制，是设置延时节点有关的参数。单位秒(s)



# 九、分片



1.什么是复制集?
'多台''保存了相同数据'的MongoDB服务器组成

2.复制集解决的问题
高可用性-服务器宕机不会影响我们继续使用
数据安全性-服务器损坏数据不会丢失

3.复制集不能解决的问题
- 服务器容量的问题
- 我们都知道一台服务器的容量是有上限的
  所以我们只能通过增加服务器的台数来提升容量
- 复制集虽然是由多台电脑组成的, 但是由于多台电脑保存的数据都是一样的
  所以在复制集中虽然电脑增多了, 但是容量并没有增加
  所以复制集是不能解决服务器容量问题的

5.MongoDB中如何增加服务器容量?
- 通过'分片'来实现

6.什么是分片?
- 分片就是将数据库集合中的数据拆分成多份, 分布式的保存到多台电脑上
    + 这样不同的电脑保存不同的数据, 就大大的提升了服务器的容量

7.分片注意点
- 并不是数据库所有的集合都需要使用分片, 对于那些不使用分片的集合会统一保存到主分片中
    + 默认每个数据库都有一个主分片, 保存那些不需要分片的集合数据
    + 在创建数据库的时候, 系统会自动选择存储内容最少的分片作为主分片
+ 1.分片集群结构
1.分片服务器: 用于保存集合中的一部分数据
2.配置服务器: 用于保存分片数据的数据段和数据范围
3.mongos路由(路由服务器): 用于分发请求到保存对应数据的分片服务器上

3.分片集群执行流程
用户发送请求到'mongos路由' -> 'mongos路由'去'配置服务器'查询数据在哪个分片服务器
'mongos路由'根据'配置服务器'返回的结果到对应的'分片服务器'操作数据
'分片服务器'将操作结果返回给'mongos路由', 'mongos路由'将最终结果返回给用户


1.如何将数据存储到不同的分片服务器上的?
通过分片片键

2.什么是分片片键?
2.1可以将文档的一个或多个字设置成分片片键
2.2设置完分片片键后, MongoDB会自动对字段可能的取值进行划分, 划分出一个个的数据段
2.3划分完数据段之后,  MongoDB会自动决定哪些分片服务器保存哪些数据段对应的数据
例如: {name:'lnj', age:33}
      age:min    20     40     60     80    age:max
         |-------|------|------|------|------|

 分片服务器1      分片服务器2       分片服务器3
|-----------|    |-----------|     |-----------|
|   min-20  |    |   80-max  |     |   40-60   |
|   20-40   |    |   60-80   |     |           |
|-----------|    |-----------|     |-----------|

3.注意点:
1.片键可以是一个字段也可以是多个字段
2.只有索引字段才能设置为片键
3.分片服务器保存哪些数据段的值是随机的, 并不是连续的
4.数据段的划分可以使用片键的取值, 也可以使用片键取值的哈希值


1.如何选择片键
使用分片的目的是为了将数据存储到不同的服务器上
所以在选择片键的时候
1.1应该选择取值范围更广的字段作为片键
因为如果取值范围太小, 那么划分出来的数据段就太少, 那么分配到不同服务器的概率就越小
例如: 取值如果只有true或false, 那么就只能划分出两个数据段
      那么也就最多只能保存到两台服务器上
1.2应该选择取值分配更平衡字段作为片键
因为如果取值范围不平衡, 就会导致某一个数据段的数据太多, 某一台分片服务器压力太大
例如: 将age作为片键, 但是我们的用户90%都集中中20~30岁,
      那么就会导致保存20~30数据段的分片服务器存储数据过多压力过大
1.3不应该选择单向增加或者减少的字段作为片键
因为如果取值是单向增加或者减少的, 那么就会出现可能出现的最小值数据段或者最大值数据段保存的数据过多,
对应的分片服务器压力过大

2.片键选择技巧
2.1如果片键字段取值范围不够广, 那么我们可以使用复合片键
2.2如果片键字段的取值不够平衡, 那么我们可以使用复合片键
2.3如果片键字段的取值是单向增加或减少的, 那么我们可以使用片键字段的哈希值

3.片键注意点
片键一旦选择就不能更改, 所以在前期选择片键时一定要多动脑


1.数据段分裂
分片的主要目的就是将数据分配到不同的服务器中保存,
提升服务器的容量, 让数据更加的均衡, 更有效的降低服务器的压力
但是随着时间推移, 某些数据段中保存的数据会越来越多,
所以为了保证个分片均衡, 当某个数据段数据过多或体积过大的时候,
系统就会自动在下一次操作这个数据段时(新增/更新), 将一个大的数据段分裂成多个小的数据段

3.分片平衡
除了当某个数据段数据过多或体积过大的时候会自动对数据段进行分裂以外
当各分片服务器上保存的数据段之间数量相差较大时, 还会自动触发分片服务器数据段迁移
在MongoDB中后台会自动运行一个'集群平衡器'来负责监视分片的平衡和调整分片的平衡


1.分片查询注意事项
1.1用户的请求会发送给mongos路由服务器,
路由服务器会根据查询条件去配置服务器查询对应的数据段和属于哪个分片服务器
1.2如果用户查询的条件是分片片键字段,
那么路由服务器会返回保存在那一台分片服务器上, 路由服务器就会去对应的分片服务器获取数据,
并将取到的数据返回给用户
1.3如果用户查询的条件不是分片片键字段,
那么配置服务器无法告知路由服务器数据保存在哪一个分片服务器上
路由服务器会把请求发送到所有的分片服务器上, 然后再将查询到的数据汇总后返回给用户


1.分片集群搭建
1.1搭建配置服务器复制集
    - 早期版本的配置服务器只要一台即可
    - 最新版本MongoDB要求配置服务器必须是一个复制集
1.2搭建分片服务器复制集
    - 用于保存数据的多台电脑
1.3搭建路由服务器
    - 用于建立配置服务器和分片服务器之间的关系


1.搭建配置服务器集群
1.1编写配置文件
```
# 数据保存到哪
storage:
  dbPath: D:\Developer\MongoDB666\mongodb-config-27018\data
  journal:
    enabled: true
#  engine:
#  mmapv1:
#  wiredTiger:
# 日志保存到哪
systemLog:
  destination: file
  logAppend: true
  path:  D:\Developer\MongoDB666\mongodb-config-27018\log\mongod.log
# 绑定的IP和端口号
net:
  port: 27018
  bindIp: 127.0.0.1
# 复制集名称
replication:
  replSetName: 'it666'
# 复制集的作用
sharding:
  clusterRole: configsvr
```
1.2注册MongoDB服务
管理员权限运行终端, 执行如下指令
mongod --config D:\Developer\MongoDB666\mongodb-config-27018\bin\mongo.config --serviceName "MongoDB27018" --serviceDisplayName "MongoDB27018"  --install
mongod --config D:\Developer\MongoDB666\mongodb-config-27019\bin\mongo.config --serviceName "MongoDB27019" --serviceDisplayName "MongoDB27019"  --install
mongod --config D:\Developer\MongoDB666\mongodb-config-27020\bin\mongo.config --serviceName "MongoDB27020" --serviceDisplayName "MongoDB27020"  --install
在任务管理器中开启任务
1.3测试服务可用性
mongo --host 127.0.0.1 --port 27018
mongo --host 127.0.0.1 --port 27019
mongo --host 127.0.0.1 --port 27020
1.4添加复制集
rs.initiate({
_id: 'it666',
configsvr: true,
members: [
{_id: 0, host: '127.0.0.1:27018'},
{_id: 1, host: '127.0.0.1:27019'},
{_id: 2, host: '127.0.0.1:27020'}]
})


2.搭建分片服务器集群
2.1编写配置文件
```
# 数据保存到哪
storage:
  dbPath: D:\Developer\MongoDB666\mongodb-shard-27021\data
  journal:
    enabled: true
#  engine:
#  mmapv1:
#  wiredTiger:
# 日志保存到哪
systemLog:
  destination: file
  logAppend: true
  path:  D:\Developer\MongoDB666\mongodb-shard-27021\log\mongod.log
# 绑定的IP和端口号
net:
  port: 27021
  bindIp: 127.0.0.1
# 复制集名称
replication:
  replSetName: 'itzb'
# 复制集的作用
sharding:
    clusterRole: shardsvr
```
2.2注册MongoDB服务
管理员权限运行终端, 执行如下指令
mongod --config D:\Developer\MongoDB666\mongodb-shard-27021\bin\mongo.config --serviceName "MongoDB27021" --serviceDisplayName "MongoDB27021"  --install
mongod --config D:\Developer\MongoDB666\mongodb-shard-27022\bin\mongo.config --serviceName "MongoDB27022" --serviceDisplayName "MongoDB27022"  --install
mongod --config D:\Developer\MongoDB666\mongodb-shard-27023\bin\mongo.config --serviceName "MongoDB27023" --serviceDisplayName "MongoDB27023"  --install
在任务管理器中开启任务

2.3测试服务可用性
mongo --host 127.0.0.1 --port 27021
mongo --host 127.0.0.1 --port 27022
mongo --host 127.0.0.1 --port 27023

2.4添加复制集
rs.initiate({
_id: 'itzb',
members: [
{_id: 0, host: '127.0.0.1:27021'},
{_id: 1, host: '127.0.0.1:27022'},
{_id: 2, host: '127.0.0.1:27023'}]
})


3.搭建路由服务器
3.1编写配置文件
```
# 日志保存到哪
systemLog:
  destination: file
  logAppend: true
  path:  D:\Developer\MongoDB666\mongodb-router-27024\log\mongod.log
# 绑定的IP和端口号
net:
  port: 27024
  bindIp: 127.0.0.1
# 配置服务器地址
sharding:
  configDB: it666/127.0.0.1:27018,127.0.0.1:27019,127.0.0.1:27020
```
3.2注册MongoDB服务
管理员权限运行终端, 执行如下指令
mongos  --config D:\Developer\MongoDB666\mongodb-router-27024\bin\mongo.config --serviceName "MongoDB27024" --serviceDisplayName "MongoDB27024"  --install
在任务管理器中开启任务

3.3测试服务可用性
mongo --host 127.0.0.1 --port 27024

3.4添加分片服务器
sh.addShard( "itzb/127.0.0.1:27021")
sh.addShard( "itzb/127.0.0.1:27022")
sh.addShard( "itzb/127.0.0.1:27023")

3.5给指定数据库开启分片
sh.enableSharding("demo")

3.6指定分片片键
sh.shardCollection("demo.user",{'age':1})
sh.shardCollection("demo.user",{'name':hashed})