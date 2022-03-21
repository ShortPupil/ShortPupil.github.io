---
title: Linux分章重点——第四章
tags: linux
copyright: false
categories: linux
abbrlink: c62aba6d
date: 2018-10-18 18:47:24
---

# 目录

<!-- toc -->

# Ch4 Linux字符界面操作 重点

## 进入命令行的方式
* 字符界面
* 图形界面下的终端
* 虚拟控制台

## 虚拟控制台的切换
* 在**字符界面**下，虚拟控制台的切换可以通过按`Alt+F1`~`Alt+F6`键实现
* 在**图形界面**下，可以使用`Ctrl+Alt+F2`～`Ctrl+Alt+F6`键切换不同的字符虚拟控制台，在 使用`Ctrl+Alt+F1`切换会图形界面



## 系统关机/重启
`shutdown halt reboot init`
​	
`shutdown`：安全地关闭系统

shutdown [选项] [时间] [警告信息]
​				
​				`shutdown -h now` 立即关闭系统
​				
				`shutdown -h 45`定时45分钟后关闭系统
				
				`shutdown -r now`重新启动系统,并发出警告信息

`halt`：引发主机关闭系统=调用 “shutdown —h”命令执行关闭系统 
​       
​			 [root@PC-LINUX ~]# halt

`reboot`：引发主机重启,参数与“halt”相似。 
​         
​			 [root@PC-LINUX ~]# reboot 

`init`：“init”命令是所有进程的祖先,它的进程号始终为“1”,所以发送“TERM”信号给 “init”会终止所有的用户进程和守护进程等。

“init” 定义了7个运行级别,其中`init 0`为关闭系统,`init 6`为重启，通过init可以完成不同运行级别之间的切换 

shutdown和init都是既可以关机又可以重启：

`shutdown –h now`和`init 0`用于关机 + halt

`shutdown –r now`和`init 6`用户重启  + reboot


## 运行级别 0～6 要很清楚，3字符、5图形、0关机、6重启

Linux运行级别有如下7种：

	0:*停止运行*,所有进程中止,关闭系统。 
	1:*单用户模式*,用于维护系统,只有少数进程运行。
	2:*多用户模式*,除了NFS服务没有启动外,其他和运行级别3一样。
	3:*完整的多用户模式*,进入Linux系统的字符界面。 
	4:*没有使用*(可由用户定义)。 
	5:*完整的多用户模式*(带有基于X Window的图形界面)。
	6:*重新引导计算机*。

![](https://raw.githubusercontent.com/ShortPupil/wordpress_picture/master/linux_4/ok.png)

## man帮助命令
man是一种显示Unix/Linux在线手册的命令。可以用来**查看命令、函数或文件**的帮助手册,另外它还可以显示一些gzip压缩格式的文件。 
man命令格式化并显示在线的手册页。 

`help`使用help命令可以查找Shell命令的用法
查看mkdir命令帮助：
​	[root@PC-LINUX ~]# mkdir --help 
（注意help前有两条-）

`whereis`命令可以查找命令所在的位置

## Shell里技巧性的  
### 命令行自动补全
输入第一个之后按下Tab键,自动补齐


### 光标上翻下翻
	[Ctrl+k]:删除从光标到行尾的部分。 
	[Ctrl+u]:删除从光标到行首的部分。
	[Alt+d]:删除从光标到当前单词结尾的部分。 
	[Ctrl+w]:删除从光标到当前单词开头的部分。 
	[Ctrl+a]:将光标移到行首。 
	[Ctrl+e]:将光标移到行尾。 
	[Alt+a]:将光标移到当前单词头部。 
	[Alt+e]:将光标移到当前单词尾部。
	[Ctrl+y]:插入最近删除的单词。
	[!$]:重复前一个命令最后的参数。

### 一行上执行多个命令
![](https://raw.githubusercontent.com/ShortPupil/wordpress_picture/master/linux_4/more1.png)

![](https://raw.githubusercontent.com/ShortPupil/wordpress_picture/master/linux_4/more2.png)
## 管道，管道什么意思，管道有什么作用，具体怎么使用
管道可以通过组合许多小程序共同完成复杂的任务，可以将某个命令的输出信息当作某个命令的输入，由管道符号“|”来标识。

**命令语法**：[命令1] | [命令2] | [命令3]

|more之后就可以分页显示上一个命令的输出

## vi （编辑的是ASCII文本）
### 三种模式，三种模式之间的转换及命令

vi编辑器有3种基本工作模式,分别是**命令行模式**、**插入模式**和**末行模式**。

当在Shell提示符下输入“vi文件名”之后就进入了命令行模式,在命令行模式下是不能输入任何数据的。

在命令行模式下输入文本插入命令就可以进入插入模式,这时候就可以开始输入文字了。

从插入模式切换为命令行模式只需按“Esc”键。

在命令行模式下,按转义命令冒号键“:”可以进入末行模式。

命令行模式：控制屏幕光标的移动，字符、字或行的删除，移动、复制某区域及进入插入模式，或者到末行模式
注：下面操作都是只能在命令行模式下控制，在输入模式下会变成输入

### 屏幕光标的移动

`h j k l`分别对应：左 下 上 右

`Ctrl + b f u d` 分别对应：

屏幕向前移动一页、向后移动一页、向前移动半页、向后移动半页
![](https://raw.githubusercontent.com/ShortPupil/wordpress_picture/master/linux_4/yidongbanye.png)
​       
 注：0和^的效果是一样的，都是所在行的行首；$是在行尾
​	
### 字符、字或行的删除
`X` 删除光标所在位置前面一个字符  x 删除光标所在位置的一个字符

`nX` 例20X，删除光标所在位置前面20个字符

`nx` 例6x，删除光标所在位置开始的6个字符

### 复制某区域
![](https://raw.githubusercontent.com/ShortPupil/wordpress_picture/master/linux_4/fuzhimoquyu.png)

### 复制
y，以字为单位
### 替换操作
![](https://raw.githubusercontent.com/ShortPupil/wordpress_picture/master/linux_4/tihuancaozuo.png)

### 撤销上一次操作
`u`，多次u，多次撤销
### 跳至指定的行
![](https://raw.githubusercontent.com/ShortPupil/wordpress_picture/master/linux_4/tiaozhizhidingdehang.png)
第一个g小写，第二个行后的G大写
### 退出
存盘退出：`ZZ`
不存盘退出：`ZQ`
### 进入插入模式
 (仍然必须在命令行模式下，输入下面操作，光标移到这些位置，然后进入插入模式，从这些位置开始可以被编辑)

* I行首		
   i光标当前位置		
    A行末		
* a光标下一个位置
   O 光标上一行插入一行		
* o 光标下一行插入一行，从行首开始输 
   S 删除光标所在行		
* s 删除光标位置的一个字符
* ![](https://raw.githubusercontent.com/ShortPupil/wordpress_picture/master/linux_4/yigezifu.png)

S和dd的区别是，dd只删，S删完之后进入插入模式
### 进入末行模式
确保先按“ESC”进入命令行模式，再按“：”进入末行模式

末行模式：将文件保存或退出编辑器，也可以设置编辑环境，如寻找字符串、列出行号等。
### 保存文件
`w`:在冒号后输入字母“w”就可以将文件保存起来。

离开vi编辑器操作如下

`q`:按“q”即退出vi,如果无法离开vi,可以在“q”后跟一个“!”强制符离开vi 

`wq`:一般建议离开时,搭配“w”一起使用,这样在退出的时候还可以保存文件