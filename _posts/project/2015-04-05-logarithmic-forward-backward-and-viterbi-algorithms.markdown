---
layout: post
category: project
title: "Logarithmic Forward, Backward, and Viterbi Algorithms"
date: 2015-04-05T21:46:56-04:00
---

The forward, backward, and Viterbi algorithms have all been implemented in their logarithmic forms in the `hidden-markov-music.hmm` namespace. The release can be downloaded [here](https://github.com/dwysocki/hidden-markov-music/releases/tag/v0.1.2).

The API has not changed, except for the addition of a `LogHMM` record type, and some of the functions previously defined have been replaced by multimethods. When computing the `forward-likelihood` on an `HMM`, the same result as before is obtained, while using it on a `LogHMM` will produce the logarithm of the likelihood.

The unit tests for the standard `HMM` have been copied over for the `LogHMM`, with the logarithms of the results used instead, and logarithmic forms of the models used.