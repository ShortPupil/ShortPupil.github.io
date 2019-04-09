---
title: Linux分章重点——第五、六、七、八章
date: 2018-10-18 18:47:24
tags: linux
copyright: false
categories: linux
---

# 目录

@[toc]

# Ch5 文件和目录

文件类型，ls -l所看到的信息，每一段都要搞得很清楚（作业第4题） ⽬目录常用命令，选项挑一些重点的看

比如：ls -a/-l，但是-F就不不⽤用看
文件目录命令，PPT有一个表要好好看一看


ls -l

以长格式的形式查看当前目录下所有可见文件的详细属性。(l就是long)
​    

1. 第1列:1.第1个字符表示文件的类型  2.第2～4个字符表示文件所有者对此文件的访问权限 3.第5～7个字符表示用户组对此文件的访问权限  4.第8～10个字符表示其他用户对此文件的访问权限
2. 第2列:文件的链接数 
3. 第3列:文件的所有者
4. 第4列:文件的用户组名 
5. 第5列:文件所占的字节数  
6. 第6～8列:文件上一次的修改时间
7. 第9列:文件名

ls -a

显示包含连隐藏文件在内的所有文件。(a就是all)

------
# Ch6 Linux常用操作命令

很多命令，但是考的不多，要把命令看一下是干什么的，不用深入了解

第二小节：**grep**，**ﬁnd** 
## grep

使用grep命令可以查找文件中符合条件的字符串。

命令语法：
grep [选项][查找模式][文件名]

【例6.22】显示所有以d开头的文件中包含 “test”的行数据内容。

[root@PC-LINUX ~]#cat d1

1

test1

[root@PC-LINUX ~]# cat d2

2

test2

//查看文件d1和d2的文件内容

[root@PC-LINUX ~]# grep ‘test’ d*

d1:test1

d2:test2

## find

使用find命令可以将文件系统中符合条件的文件或目录列出来，可以指定文件的名称、类别、时间、大小以及权限等不同信息的组合，只有完全相符的文件才会被列出来。

命令语法：
find [路径][选项][-print]

【例6.27】列出当前目录及其子目录下所有最近20天内更新过的文件。

[root@PC-LINUX ~]# find . -ctime -20

.

./install.log

./.mission-control

./.mission-control/accounts

./.mission-control/accounts/accounts.cfg 

./anaconda-ks.cfg

./install.log.syslog

./.tcshrc

./.gconf

./.gconf/apps

./.gconf/apps/%gconf.xml

./.gconf/apps/nm-applet

./.gconf/apps/nm-applet/%gconf.xml 
………………………………………………

------
# Ch7 Shell编程
不会超过20行 
环境变量、特殊变量要掌握，语句的语法要掌握
写题



------

# Ch8 用户和组群账号管理

用户管理：添加账号、删除账号、添加组 

涉及⽂件、password的格式

常⽤⽂件、⽂件的每⼀⾏，要求低，不⽤写每⼀⾏是什么

字符常⽤的，添加、删除⽤户、修改密码，这些对应⽂件中主要的信息的命令重要

修改⽤户的有效期什么的，考的可能性⼩

group命令，要认识