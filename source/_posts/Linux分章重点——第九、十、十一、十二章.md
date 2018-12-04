---
title: Linux分章重点——第九、十、十一、十二章
date: 2018-11-14 10:52:24
tags: linux
copyright: false
categories: linux
---

# 目录

@[toc]



## 第九章

### 9.1 硬盘分区：从分区到使用的步骤

1. 使用fdisk命令在硬盘上创建分区。 `fdisk -l /dev/sdb`
2. 使用mkfs命令在分区上创建文件系统。`mkfs -t ext4 /dev/sdb1`
3. 使用mount命令挂载文件系统，或修改/etc/fstab文件使得开机自动挂载文件系统`mount -o ro /dev/sdb1 /mnt/kk`
4. 使用umount卸载文件0系统。



### 9.2 挂载：手动挂载 mnt、etc/fstab

**mount**:mount 【选项】【设备名称】【挂载点】

**etc/fstab**: 

/dev/sda5    /mnt/kk    ext4     defaults     0     0

1行包含着1个设备或分区的信息。

第1列是设备名或者设备UUID+号

第2列是它的挂载点

第3列是它的文件系统格式

第4列是挂载参数

第5列是转储选项

第6列是文件系统检查选项。



### 9.3 权限设定：字符、数字

#### 9.3.1 文字设定

```
chmod [ugoa][+-=][rwx][文件或目录名]
```

u表示该文件的所有者，g表示与该文件的所有者属于同一个组的用户，o表示其他用户，a表示以上三者；

+表示增加指定权限，-表示取消指定权限，=表示设定权限等于指定权限；

r表示可读取，w表示可写入，x表示表示文件可执行或目录可进入。



#### 9.3.2 数字设定

```shell
chmod [n1n2n3] [文件或目录名]
```

使用数字设定法更改文件权限，首先必须了解数字表示的含义：0表示没有权限，1表示可执行权限，2表示写入权限，4表示读取权限，然后将其相加。所以数字属性的格式应为3个0～7的8进制数，其顺序是（u），（g），（o）。

- r:4
- w:2
- x:1
- -:0



example——对/root/ab文件设置权限，所有者为读取、写入和执行权限，同组用户
为读取和写入权限，而其他用户没有任何权限

```shell
chmod 760 /root/ab
```



## 第十章

### 10.1 rpm使用																																																																																																																																																																																																																																																																																																																																																																																																																																										

#### 10.1.1 安装

```shell
rpm -ivh [RPM包文件名]
```



#### 10.1.2 卸载

```shell
rpm –e [RPM包名称]
```



#### 10.1.3 查询

```shell
rpm –q [RPM包名称] #查询指定软件包的详细信息
rpm –qa #查询系统中所有已安装的RPM软件包
rpm –qi [RPM包名称] #查询指定已安装软件包的描述信息
rpm –ql [RPM包名称] #查询某已安装软件包所含的文件列表
rpm –qR [RPM包名称] #查询软件包的依赖要求   
rpm –qf [文件名] #查询系统中指定文件属于哪个软件包
```



#### 10.1.4 升级

```shell
rpm –Uvh [RPM包文件名称] 
```



### 10.2 tar使用

```shell
tar cvf 压缩包名称.tar 源文件/目录 #创建压缩
tar xvf 压缩文件 #解压
```

tar调用gzip、bzip2



### 10.3 进程：ps、kill

```shell
ps ax|grep less #查看less进程是否在运行。
kill -9 5975 #强制杀死进程号是5975的进程。

```

### 10.4 任务计划：cron“分时日月周”+命令；at在命令行上写，或者-f文件+脚本

#### 10.4.1 crontab

```bash
crontab [-u username] -e #编辑工作表
<minute> <hour> <day> <month> <dayofweek> <commands> #编辑命令
```

#### 10.4.2 at

```shell
at [-f script] [-m -l -r] [time] [date] 
```

example——在5天之后的此时此刻将/root/a文件复制到/home目录下。

```bash
[root@PC-LINUX ~]# at now +5 days 
at> cp /root/a /home 
at> <EOT>  //按[Ctrl+D]键退出 
```



### 10.5 服务的管理：systemctl启动、停止

```bash
systemctl start/stop service_name
```



## 第十一章

### 网卡配置、命名

#### ifconfig

```shell
ifconfig [网络设备][down up -allmulti -arp -promisc][add<地址>][del<地址>][<硬件地址>][mtu<字节>][netmask<子网掩码>][IP地址]
```



#### 修改好ip地址之后，如何起作用、如何生效？

第四节：网络服务的管理

- ntsysv：基于文本的程序。它允许为每个运行级别配置引导时要启动的服务。对于独立服务而言，改变不会立即生效。
- systemctl命令：Fedora 17中新的管理服务的命令，用来替换chkconfig和service命令。
- chkconfig和service命令：允许在不同运行级别启动和关闭服务的命令行工具。



### 网络服务管理

- ntsysv
- systemctl
- chkconfig、service



## 第十二章

### SSH、SFTP、Scopy的格式
#### SSH

```shell
ssh -l username ip_address
```

```shell
ssh username@ip_address [command]
```

#### SCP

将本地文件传输到远程主机

```shell
scp [本地文件][用户名@远程主机IP地址:/目标文件]
```

把远程文件传输到本地主机

```shell
scp [用户名@远程主机IP地址:/源文件] [本地文件]
```

#### SFTP

```shell
sftp [用户名@远程主机IP地址]
```



### VNC稍微看一下
#### apache配置文件：端口、目录

Apache服务器的配置文件是/etc/httpd/conf/httpd.conf。

修改配置需要在这个配置文件下修改。



[参考学长博客](https://blog.csdn.net/qq_33230935/article/details/78639056)