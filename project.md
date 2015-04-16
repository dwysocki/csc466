---
layout: page
title: Project
---

My hidden Markov model based music composition AI is available [here](https://github.com/dwysocki/hidden-markov-music) to download. Periodic updates about the project's status are tracked on this page.

<ul class="post-list">
{% for post in site.categories.project %} 
  <li><article><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }} <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span></a></article></li>
{% endfor %}
</ul>
