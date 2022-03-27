{% extends '_layout.swig' %}
{% import '_macro/post.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}


{% block title %}{{ page.title }} | {{ config.title }}{% endblock %}

{% block page_class %}page-post-detail{% endblock %}


{% block content %}

  <div id="posts" class="posts-expand">
    {{ post_template.render(page) }}

    <div class="post-spread">
      {% if theme.jiathis %}
        {% include '_partials/share/jiathis.swig' %}
      {% elseif theme.baidushare %}
        {% include '_partials/share/baidushare.swig' %}
      {% elseif theme.add_this_id %}
        {% include '_partials/share/add-this.swig' %}
      {% elseif theme.duoshuo_shortname and theme.duoshuo_share %}
        {% include '_partials/share/duoshuo_share.swig' %}
      {% endif %}
    </div>
  </div>

{% if page.copyright %}
      <script>
          function setClipboardText(event){
              // clipboardData 对象是为通过编辑菜单、快捷菜单和快捷键执行的编辑操作所保留的，也就是你复制或者剪切内容
              let clipboardData = event.clipboardData || window.clipboardData;
              // 如果未复制或者未剪切，则return出去
              if (!clipboardData) { return; }
              event.preventDefault();
              // Selection 对象，表示用户选择的文本范围或光标的当前位置。
              //     声明一个变量接收 -- 用户输入的剪切或者复制的文本转化为字符串
              let text = window.getSelection().toString();

              if (text) {
                // 如果文本存在则先取消文本默认事件
                event.preventDefault();
                // 通过调用常clipboardData对象的 setData(format, data) 方法；来设置相关文本
                // format: 一个DOMString 表示要添加到 drag object的拖动数据的类型。
                // data: 一个 DOMString表示要添加到 drag object的数据。
                var url = window.location.href;
                var copyright = '\n\n'
                                + '\n来源：毫末室 (songzi.info)'
                                + '\n作者：松子'
                                + '\n链接：' + url
                                + '\n转载请保留原文链接及作者。';

                clipboardData.setData('text/plain', text + copyright);

              }
          };
          var contents = document.getElementsByClassName("content");
          // 监听文章内容的copy事件
          contents[0].addEventListener('copy',function(e){
              setClipboardText(e);
          });
      </script>
{% endif %}

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(true) }}
{% endblock %}


{% block script_extra %}
  {% include '_scripts/pages/post-details.swig' %}
{% endblock %}
