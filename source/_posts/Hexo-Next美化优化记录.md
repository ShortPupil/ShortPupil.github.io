---
title: Hexo Next美化优化记录
copyright: true
tags: blog
categories: 博客
abbrlink: 5b7ae5f0
date: 2022-03-29 13:58:05
---

# 写在开头

这么久都没做过Hexo的优化记录，有些功能忘了，有些功能以前做过。这篇文章就用来记录自己容易忘记的美化和一些好的优化博文。

# 小功能

## 设置字体颜色

**链接**：[hexo 博客如何写出彩色字体，能实时预览的那种？ | OldGerman's Blog](https://oldgerman.github.io/6c57f882/)

<span style='color:white;background:black;font-family:仿宋;'>黑白配</span>

### span - - - style | 设置字体属性

```js
<span style='color:文字颜色;background:背景颜色;font-size:文字大小;font-family:字体;'>文字</span>
```

style后传入的参数以分号隔开，参数数量可裁剪

其中color：支持三种格式 颜色名，十六进制颜色值，RGB取色器

示例：

1. 三种color格式显示同样的红色字体：

```js
<span style="color:red;">红不红？</span>
```

<span style="color:red;">红不红？</span>

```js
<span style="color:rgb(255, 0, 0);">红不红？</span>
```

<span style="color:rgb(255, 0, 0);">红不红？</span>

```js
<span style="color:#FF0000;">红不红？</span>
```

<span style="color:#FF0000;">红不红？</span>

```js
<span style='color:white;background:black;font-size:50px;font-family:仿宋;'>黑白配</span>
```

黑底白字仿宋50px：黑白配

### b & strong | 加粗字体

用法：

```js
<b>我被B标签加粗</b>
<strong>我被Strong标签加粗</strong>
```

示例：

1. 加粗字体：**加粗**

```js
<b>加粗</b>
```

1. 紫色加粗：**骚紫色加粗**

   <b><span style="color:rgb(255, 0, 255);">骚紫色加粗</span></b>

```js
<b><span style="color:rgb(255, 0, 255);">骚紫色加粗</span></b>
```

### sup & sub | 上标 & 下标

用法：

```js
上标：<sup>内容</sup>
下标：<sub>内容</sub>
```

示例：

```js
mm<sup>2</sup>
```

平方毫米: mm<sup>2</sup>

```js
y = log<sub>2 </sub>x
```

对数:y = log<sub>2 </sub>x

### div - - align | 各种对齐

示例：

```js
<div align="center">奇怪的知识增加了！</div>
```

<div align="center">奇怪的知识增加了！</div>

```js
<div align="center"><span style='color:white;background:black;font-size:20px;'>&#12288“事情总会朝着意想不到的方向发展”&#12288</span></div>
```

<div align="center"><span style='color:white;background:black;font-size:20px;'>&#12288“事情总会朝着意想不到的方向发展”&#12288</span></div>



## Note使用

**参考链接**：[在hexo-NexT中插入note提示块 | JOHZEN (jinnsjj.github.io)](https://jinnsjj.github.io/uncategorized/hexo-next-note/)



next主题有个小功能还没用过，在主题配置文件中有：

```xml
note:
  # Note tag style values:
  #  - simple    bs-callout old alert style. Default.
  #  - modern    bs-callout new (v2-v3) alert style.
  #  - flat      flat callout style with background, like on Mozilla or StackOverflow.
  #  - disabled  disable all CSS styles import of note tag.
  style: flat
  icons: true
  border_radius: 3
  # Offset lighter of background in % for modern and flat styles (modern: -12 | 12; flat: -18 | 6).
  # Offset also applied to label tag variables. This option can work with disabled note tag.
  light_bg_offset: 0
```

效果如下：

{% note default %}
default 提示块标签
{% endnote %}

{% note primary %}
primary 提示块标签
{% endnote %}

{% note success %}
success 提示块标签
{% endnote %}

{% note info %}
info 提示块标签
{% endnote %}

{% note warning %}
warning 提示块标签
{% endnote %}

{% note danger %}
danger 提示块标签
{% endnote %}


代码如下：
```markdown
{% note default %}
default 提示块标签
{% endnote %}

{% note primary %}
primary 提示块标签
{% endnote %}

{% note success %}
success 提示块标签
{% endnote %}

{% note info %}
info 提示块标签
{% endnote %}

{% note warning %}
warning 提示块标签
{% endnote %}

{% note danger %}
danger 提示块标签
{% endnote %}
```



## 选项卡使用

效果如下：
{% tabs tab,1 %} 名字为tab，默认在第1个选项卡，如果是-1则隐藏
<!-- tab -->
**选项卡 1** 
<!-- endtab -->
<!-- tab -->
**选项卡 2**
<!-- endtab -->
<!-- tab A -->
**选项卡 3** 名字为A
<!-- endtab -->
{% endtabs %}



```markdown
{% tabs tab,1 %} 名字为tab，默认在第1个选项卡，如果是-1则隐藏
<!-- tab -->
**选项卡 1** 
<!-- endtab -->
<!-- tab -->
**选项卡 2**
<!-- endtab -->
<!-- tab A -->
**选项卡 3** 名字为A
<!-- endtab -->
{% endtabs %}
```



# 美化

## 随机背景图

思路就是将喜欢的图片打包上传到图床，通过`url.csv`文件中给出的图床链接来实现一个随机图片 API，`backgound:url`调用相应的API。



找资源的网站：

---

麦田艺术 - 收尽世界名画，无水印高清油画免费下载 (nbfox.com)
https://www.nbfox.com/

---

---

绘画和绘画 – 加勒里克斯在线博物馆 (gallerix.asia)
https://gallerix.asia/

---

---

书格 (shuge.org)
https://new.shuge.org/

---

图床：[新建一个github repo就行](https://github.com/ShortPupil/VPicture)



下面链接里都有工具详细的使用方法

本地图片上传工具：

---

Molunerfinn/PicGo: A simple & beautiful tool for pictures uploading built by vue-cli-electron-builder (github.com)
https://github.com/Molunerfinn/picgo/

---

随机生成背景图方法：

---

YieldRay/Random-Picture: 随机图片api (github.com)
https://github.com/YieldRay/Random-Picture

---



我的background路径设置文件是 `...\themes\next\source\css\_custom\custom.styl`

```stylus
body {
   // 替换成自己的随机图片链接
   background:url(https://fine-clam-71.deno.dev);
   background-repeat:no-repeat;
   background-attachment:fixed;
   background-position:center;
   background-size:cover;
}
```
