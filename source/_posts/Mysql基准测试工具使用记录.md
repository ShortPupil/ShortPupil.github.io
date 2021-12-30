---
title: Mysql基准测试工具使用记录
copyright: true
date: 2018-12-11 19:30:20
tags: [mysql,test]
categories: 数据库
---

# 目录

@[toc]



## Apache ab压力测试工具

### windows下安装

1. [下载地址](https://www.apachehaus.com/cgi-bin/download.plx)
2. 压缩包中提供了readme_first.html文件，有相关安装、使用说明



### 测试

对本站点进行测试

```powershell
H:\apache_ab\Apache24\bin>ab -n 100 -c 10 http://songzi2693.cn/s
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking songzi2693.cn (be patient).....done

## 服务器软件
Server Software:        GitHub.com
## 站点名
Server Hostname:        songzi2693.cn
## 端口
Server Port:            80

## 请求路径
Document Path:          /s
## 页面数据量
Document Length:        9340 bytes

## 并发数量
Concurrency Level:      10
## 总共使用时间
Time taken for tests:   33.206 seconds
## 总请求数
Complete requests:      100
## 失败的请求
Failed requests:        0

Non-2xx responses:      100
Total transferred:      976686 bytes
HTML transferred:       934000 bytes
## 每秒多少请求，表示服务器的吞吐量
Requests per second:    3.01 [#/sec] (mean)
Time per request:       3320.588 [ms] (mean)
Time per request:       332.059 [ms] (mean, across all concurrent requests)
## 每秒获取的数据长度
Transfer rate:          28.72 [Kbytes/sec] received

## 连接时间的数据
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:      270  325 110.6    301    1297
Processing:   335 2798 607.0   2789    4493
Waiting:      298 1646 830.3   1609    3630
Total:        700 3123 602.3   3123    4781

Percentage of the requests served within a certain time (ms)
## 50%的请求在3123ms内返回 
  50%   3123
  66%   3162
  75%   3247
  80%   3485
  90%   3998
  95%   4009
  98%   4085
  99%   4781
 100%   4781 (longest request)

```

