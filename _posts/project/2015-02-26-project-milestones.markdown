---
layout: post
category: project
title: "Project Milestones"
date: 2015-02-26T14:20:00-05:00
---

# MIDI Source

Deadline: March 5, 2015

- find a source of MIDI files
    - download the (complete?) works of classical composers
        - Beethoven
        - Bach
        - Mozart
        - Chopin
- implement the necessary functions for dealing with these files
{% highlight clojure %}
(ns hidden-markov-music.midi)

(defn parse-midi
  "Transforms a file into a seq of midi notes."
  [file]
  ...)

(defn hash-midi
  "Transforms a seq of midi notes into a seq of hash keys."
  [seq]
  ...)
(defn unhash-midi
  "Inverse of `hash-midi`."
  [seq]
  ...)
(defn play-midi
  "Plays a seq of midi notes through the speakers."
  [seq]
  ...)
{% endhighlight %}
- demo: play some classical music


# HMM Forwards and Backwards Algorithms

Deadline: March 12, 2015

- implement the forwards and backwards algorithms
{% highlight clojure %}
(ns hidden-markov-music.hmm)

(defn forwards
  "Returns the probability of the sequence of observations, given the model."
  [model observations]
  ...)

(defn backwards
  "Returns the *most likely* hidden state sequence, given the model and
  observations."
  [model observations]
  ...)
{% endhighlight %}
- demo: compare obtained solutions against known solutions


# HMM Baum--Welch Algorithm

Deadline: March 26, 2015

- implement the Baum--Welch algorithm
    - note: depends on completion of both the forwards and backwards algorithms
{% highlight clojure %}
(defn baum-welch
  "Returns the HMM which best fits the observations, with the given number of
  states and observables.
  [observations n-states n-observables]
  ...)
{% endhighlight %}
- demo: run on sequences of MIDI notes, and use to generate new sequences

