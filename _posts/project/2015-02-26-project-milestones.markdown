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
  states and observables."
  [observations n-states n-observables]
  ...)
{% endhighlight %}
- demo: inspect the transition matrices for some songs, and use in conjunction
  with the backwards algorithm to test the similarities between several songs,
  hopefully identifying songs as coming from the same composer


# Song Generation

Deadline: April 2, 2015

- implement some method of song generation given an HMM
- one possible approach is to use the Viterbi algorithm, which will find the
  "most likely" song to be observed from the model
- look for a less deterministic method, either by introducing randomness into
  the Viterbi algorithm, or just a more appropriate method
- demo: create songs from HMMs trained by several classical composers, and let
  the class guess who the training composer is for each model


# Chord Recognition

Deadline: April 14, 2015

- implement chord recognition through HMMs
{% highlight clojure %}
(ns hidden-markov-music.patterns)

(defn midi->chords
  "Returns a sequence of chords, given a sequence of midi notes"
  [midi]
  ...)
{% endhighlight %}
- demo: replace notes with chords in observations used for HMM training,
  and repeat previous demo


# Chord Progression Recognition

Deadline: April 23, 2015

- implement chord progression recognition through HMMs
{% highlight clojure %}
(ns hidden-markov-music.patterns)

(defn chords->chord-progressions
  "Returns a sequence of chord progressions, given a sequence of chords"
  [chords]
  ...)
{% endhighlight %}
- demo: repeat previous demo, replacing chords with chord progressions


# GUI and Filters

Deadline: April 30, 2015

- create GUI for selecting different transformation functions, as well as
  saving, loading, and training HMMs
- create various output transformations
    - map one genre's instruments to another's
    - produce sheet music output for piano
        - have a human play from the sheet music and record it
- demo: show off GUI, and play around with various features, as well as playing
  human recording