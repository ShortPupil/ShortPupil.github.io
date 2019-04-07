---
title: spring boot集成jsp
date: 2019-02-19 21:43:24
tags: [spring]
categories: 框架
copyright: true
---

# 目录

@[toc]

## 前言

Spring boot本身是不推荐使用jsp的，虽然本身兼容做得蛮好的。主要原因还是pringboot 是内嵌web容器的，推荐打成jar包不是war包，而。并且前后端分工日益细化，更符合现代前段思想和注重用户体验的各种框架才是主流。

但是如果像我这种没写过前端的，想使用jsp也可以，只需要自建web.xml即可。



## 做法

### 添加依赖

gradle为例

```
	// https://mvnrepository.com/artifact/javax.xml.bind/jaxb-api
    compile group: 'javax.xml.bind', name: 'jaxb-api', version: '2.3.1'

    // https://mvnrepository.com/artifact/javax.activation/javax.activation-api
    compile group: 'javax.activation', name: 'javax.activation-api', version: '1.2
	// https://mvnrepository.com/artifact/org.apache.tomcat.embed/tomcat-embed-jasper
    compile group: 'org.apache.tomcat.embed', name: 'tomcat-embed-jasper', version: '9.0.12'

    // https://mvnrepository.com/artifact/javax.servlet/jstl
    compile group: 'javax.servlet', name: 'jstl', version: '1.2'
```

### 改造程序主入口

```java
@ServletComponentScan
@SpringBootApplication
public class YummyApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(YummyApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(YummyApplication.class, args);
    }

}
```

### 新增配置项

application.properties文件

```
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
```

### web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://java.sun.com/xml/ns/javaee"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
		  http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
           version="3.0">
    <!-- Session失效时间 -->
    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>
    <!-- 首页 -->
    <welcome-file-list>
        <welcome-file>/</welcome-file>
    </welcome-file-list>
    <!-- 编码过滤器 -->
    <filter>
        <filter-name>characterEncodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
        <init-param>
            <param-name>forceEncoding</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>characterEncodingFilter</filter-name>
        <url-pattern>/</url-pattern>
    </filter-mapping>
    <!-- PUT请求过滤器 -->
    <filter>
        <filter-name>HttpPutFormContentFilter</filter-name>
        <filter-class>org.springframework.web.filter.HttpPutFormContentFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>HttpPutFormContentFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
    <!-- spring监听器 -->
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <!-- DispatcherServlet -->
    <servlet>
        <servlet-name>dispatcherServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>dispatcherServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
    <!-- 发生错误时页面处理 -->
    <error-page>
        <error-code>404</error-code>
        <location>/WEB-INF/view/404.jsp</location>
    </error-page>

    <error-page>
        <error-code>500</error-code>
        <location>/WEB-INF/view/error.jsp</location>
    </error-page>
    <error-page>
        <exception-type>java.lang.Throwable</exception-type>
        <location>/WEB-INF/view/error.jsp</location>
    </error-page>
</web-app>

```

### 工程截图

![](https://raw.githubusercontent.com/ShortPupil/ShortPupil.github.io/hexo/source/_posts/pictures/springboot_cut.png)