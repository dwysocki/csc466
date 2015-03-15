---
layout: post
category: project
title: "Forward, Backward and Viterbi Algorithms"
date: 2015-03-15T17:50:00-05:00
---

The forward, backward, and Viterbi algorithms have all been implemented in the
`hidden-markov-music.hmm` namespace, whose most current version is always
documented [here]({{ site.baseurl }}/hmm-doc/hidden-markov-music.hmm.html).
See [here](https://github.com/dwysocki/hidden-markov-music/releases/tag/v0.1.0)
for the source code, or standalone jar.

The three algorithms are implemented in

- [`likelihood-forward`]({{ site.baseurl }}/hmm-doc/hidden-markov-music.hmm.html#var-likelihood-forward)
- [`likelihood-backward`]({{ site.baseurl }}/hmm-doc/hidden-markov-music.hmm.html#var-likelihood-backward)
- [`viterbi-path`]({{ site.baseurl }}/hmm-doc/hidden-markov-music.hmm.html#var-viterbi-path)

To test the validity of these functions, they were tested against examples from
Oliver C. Ibe's *Markov Processes for Stochastic Modeling*, and produced
consistent results. I also tested them against some extreme models I designed,
which gave sensible results.

For example, I made a fully deterministic model,
where all probabilities are `0.0` or `1.0`. I constructed two observation
sequences `O`, one which is certain to be observed, and another which is
impossible to observe. Both the forward and backward approaches gave
`P[O|λ] = 1.0` for the certain observation sequence, and `P[O|λ] = 0.0` for the
impossible one. The Viterbi algorithm gave the correct state sequence for the
possible observations, with likelihood `1.0`, and a repetition of one state
for the impossible observations, with likelihood `0.0`. The latter was an
interesting result, as any state sequence would be equally invalid, but that
may be due to the fact that my implementation only returns one state sequence
if more than one share equal likelihood.

As another example, I made a model with a 50/50 initial probability of starting
in one of two states, but all subsequent states are deterministic. The two
possible observation sequences gave `P[O|λ] = 0.5`, and the Viterbi path
returned the correct state sequence for each with likelihood `0.5`. I was
surprised the likelihood was not `1.0`, since the observations were known, but
my intuition was wrong.

