# NexT

> 精于心，简于形

<a href="http://notes.iissnan.com" target="_blank">在线预览 Preview</a> | <a href="http://theme-next.iissnan.com" target="_blank">NexT 使用文档</a> |  [English Documentation](README.en.md)

[![Join the chat at https://gitter.im/iissnan/hexo-theme-next](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/iissnan/hexo-theme-next?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

![NexT Schemes](http://iissnan.com/nexus/next/next-schemes.jpg)


## 浏览器支持 Browser support

![Browser support](http://iissnan.com/nexus/next/browser-support.png)


## 贡献 Contributing

接受各种形式的贡献，包括不限于提交问题与需求，修复代码。等待您的`Pull Request`。

Any types of contribution are welcome. Thanks.

## 开发 Development

NexT 主旨在于简洁优雅且易于使用，所以首先要尽量确保 NexT 的简洁易用性。

NexT is built for easily use with elegant appearance. First things first, always keep things simple.

## [开发历史 Changelog](https://github.com/iissnan/hexo-theme-next/wiki/Changelog)

[![hexo-image]][hexo-url]
[![bower-image]][bower-url]
[![jquery-image]][jquery-url]
[![velocity-image]][velocity-url]

[hexo-image]: http://img.shields.io/badge/Hexo-2.4+-2BAF2B.svg?style=flat-square
[hexo-url]: http://hexo.io
[bower-image]: http://img.shields.io/badge/Bower-*-2BAF2B.svg?style=flat-square
[bower-url]: http://bower.io
[jquery-image]: https://img.shields.io/badge/jquery-2.1-2BAF2B.svg?style=flat-square
[jquery-url]: http://jquery.com/
[velocity-image]: https://img.shields.io/badge/Velocity-1.2-2BAF2B.svg?style=flat-square
[velocity-url]: http://julian.com/research/velocity/

```html
<!-- 新增播放器 -->
<!-- 引用依赖 -->
<link rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/aplayer@1.10.1/dist/APlayer.min.css">
<script src="https://cdn.jsdelivr.net/npm/aplayer@1.10.1/dist/APlayer.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/meting@1.2.0/dist/Meting.min.js"></script>
<!-- require JQuery -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<!-- require pjax -->
<script src="https://cdn.jsdelivr.net/npm/pjax@0.2.8/pjax.js"></script>
<!-- 我使用的APlayer本体 -->
<div class="aplayer"
  data-id="986184445"
  data-server="netease"
  data-type="playlist"
  data-fixed="true"
  data-mini="true"
  data-autoplay="false"
  data-order="random"
  data-volume="0.35"
  data-theme="#FFEFD5"
  data-preload="auto" >
</div>
```
