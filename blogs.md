---
layout: page
title: Blogs
permalink: /blogs/
---

{% for post in site.posts %}

<article class="post">
  <div style="display: flex; justify-content: space-between; align-items: center;">
    <h1 style="font-size: 28px; font-weight: 500; margin: 0;"><a href="{{ post.url }}">{{ post.title }}</a></h1>
    <p class="meta" style="margin: 0;">{{ post.date | date: "%B %-d, %Y" }}</p>
  </div>
  <div style="height: 16px;"></div>
  <div class="entry">
    {{ post.excerpt }}
  </div>
  <div style="height: 32px;"></div>
</article>
{% endfor %}
