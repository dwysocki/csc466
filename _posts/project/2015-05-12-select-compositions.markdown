---
layout: post
category: project
title: "Select Compositions"
date: 2015-05-12T23:36:20-04:00
permalink: /simple_compositions/
---

{% assign songs = "auld-lang-syne,barbara-allen,frere-jacques,happy-birthday,im-a-little-teapot,mary-had-a-little-lamb,scarborough-fair,this-old-man,three-blind-mice,twinkle-twinkle-little-star" | split: "," %}

{% for song in {{songs}} %}
  {{song}}
{% endfor %}