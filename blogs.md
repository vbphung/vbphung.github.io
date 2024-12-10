---
layout: page
title: Blogs
permalink: /blogs/
---

{% for post in site.posts %}

<article class="post">
  <div style="display: flex; justify-content: space-between; align-items: center;">
    <h1 style="font-size: 24px; font-weight: 500; margin: 0;">
      <a href="{{ post.url }}">{{ post.title }}</a>
    </h1>
    <div class="hello" style="margin: 0 0 0 12px; white-space: nowrap;">
      {{ post.date | date: "%B %-d, %Y" }}
    </div>
  </div>
  <div style="height: 16px;"></div>
  <div class="entry">
    {{ post.description | post.excerpt }}
  </div>
  <div style="height: 32px;"></div>
</article>

{% endfor %}
