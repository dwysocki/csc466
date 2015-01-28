---
layout: page
title: "Notes"
author: "Dan Wysocki"
---

# General

[Student Webpages]()


# Introduction

{% highlight prolog %}
snoc(Obj, [], [Obj]).
snoc(Obj, [H|T], [H|S]) :- snoc(Obj, T, S).
{% endhighlight %}
