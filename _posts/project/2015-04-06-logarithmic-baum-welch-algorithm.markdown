---
layout: post
category: project
title: "Logarithmic Baum-Welch Algorithm"
date: 2015-04-06T01:42:10-04:00
---

I have now successfully implemented the Baum--Welch algorithm in its logarithmic form. The release can be downloaded [here](https://github.com/dwysocki/hidden-markov-music/releases/tag/v0.1.3).

The main change to the API is the addition of the [`train-model`]({{ site.baseurl }}/hmm-doc/hidden-markov-music.hmm.html#var-train-model) function, which takes an existing model and an observation sequence, and improves it via the Baum--Welch algorithm. This is an iterative approach that terminates when one of two limits are met: max iterations or convergence. By default, max iterations is `1000`, and convergence is defined when the likelihood from one model to the next improves by `0.0`, but both of these defaults can be overridden.

Now models can be trained against observations, and thus the fun begins. There still lies the challenge of creating a useful representation of music to train the model on. To get started, I will enter simple songs like "Twinkle Twinkle Little Star" by hand as vectors of notes, but more elaborate and automatic representations of music will follow. Previously my heart was set on MIDI, but MusicXML is starting to look attractive. I will probably wind up trying both.