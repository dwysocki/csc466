---
layout: page
title: "Notes"
author: "Dan Wysocki"
---

# General

[Student Webpages](http://www.cs.oswego.edu/~blue/courses/2015/SWS-S15.html)


# Introduction

{% highlight prolog %}
snoc(Obj, [], [Obj]).
snoc(Obj, [H|T], [H|S]) :- snoc(Obj, T, S).
{% endhighlight %}
