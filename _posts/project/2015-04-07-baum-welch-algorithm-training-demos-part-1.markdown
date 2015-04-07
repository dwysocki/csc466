---
layout: post
category: project
title: "Baum-Welch Algorithm Training Demos (Part 1)"
date: 2015-04-07T01:37:51-04:00
---

Here I have taken a random `LogHMM` with 2 states and 2 observables, and
trained it on 3 random observation sequences repeatedly. It is trained on the
first sequence for 20 iterations, then that model is trained on the second
sequence, that on the third, and then back to the first.

The idea was to show that by repeatedly training it on the same sequences, it
would eventually converge to a mutual local maxima, but here we see that no
such thing takes place. It tends to become periodic after the first one or two
repetitions. I will have to find a better way to train a model on multiple
observation sequences.

{% for len in (1..2) %}
# Training Length {{len}}0
{% for i in (1..10) %}
[Example {{i}}]({{ site.baseurl }}/assets/demos/baum-welch/training-length-{{len}}0_{{i}}.pdf)
{% endfor %}
{% endfor %}