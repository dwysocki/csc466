---
layout: post
category: project
title: "Random Walk Sampler"
date: 2015-03-17T17:38:42-05:00
---

Functions for producing samples from the HMM via random walks have been
implemented in the `hidden-markov-music.hmm` namespace. See
[here](https://github.com/dwysocki/hidden-markov-music/releases/tag/v0.1.1)
for the source code and standalone jar.

This was actually a very straightforward task, and depended on implementing
only a few functions

- [`select-random-key`](https://dwysocki.github.io/csc466/hmm-doc/hidden-markov-music.random.html#var-select-random-key)
- [`random-initial-state`](https://dwysocki.github.io/csc466/hmm-doc/hidden-markov-music.hmm.html#var-random-initial-state)
- [`random-transition`](https://dwysocki.github.io/csc466/hmm-doc/hidden-markov-music.hmm.html#var-random-transition)
- [`random-emission`](https://dwysocki.github.io/csc466/hmm-doc/hidden-markov-music.hmm.html#var-random-emission)
- [`sample-states`](https://dwysocki.github.io/csc466/hmm-doc/hidden-markov-music.hmm.html#var-sample-states)
- [`sample-emissions`](https://dwysocki.github.io/csc466/hmm-doc/hidden-markov-music.hmm.html#var-sample-emissions)

`select-random-key` was a useful little function I came up with. Rows in the
probability matrices in my model are represented by hash-maps, mapping states
to their respective probabilities. This means I needed a function which takes
a hash-map (or really any sequence of `[key prob]` pairs), and randomly return
one of the keys, according to its probability. I accomplished this by choosing
a number on the interval `(0, 1]`, and iterating over each `[key prob]` pair,
subtracting the `prob` from that random number, until it was 0 or smaller.
Since the number was selected from a uniform distribution, this should function
properly. Each of `random-initial-state`, `random-transition`, and
`random-emission` were implemented in only a few lines of code, thanks to
`select-random-key`.

`sample-states` was my favorite function to implement. I made use of Clojure's
`iterate` function, which takes a function `f`, and an initial value `x`, and
returns the infinite lazy sequence
{% highlight clojure %}
(x (f x) (f (f x)) (f (f (f x))) ...)
{% endhighlight %}
So I used `random-initial-state` to select my initial `x`, and iterated
over it using `random-transition`.

`sample-emissions` was simple to implement, once `sample-states` was done.
All I had to do was map `random-emission` over the output of `sample-states`,
giving me yet another infinite lazy sequence.


# Demo

As a demonstration, I wrote a little `main` function, which you can try out by
downloading and running
[this jar](https://github.com/dwysocki/hidden-markov-music/releases/download/v0.1.1/hidden-markov-music-0.1.1-standalone.jar).

There are basically two options this demonstrates.

## Random Weather

The first option demonstrates a randomly constructed HMM for weather events,
and produces a user-specified length sample of weather states and emissions.
This demonstration is based on the classic example, where you want to predict
the weather based on the activities your friend performs that day, except here
we are merely producing random events based on that model.

Here are two trial runs

{% highlight clojure %}
$ java -jar hidden-markov-music-0.1.1-standalone.jar --model weather --number 10
MODEL:
{:states [:rainy :sunny],
 :observations [:run :clean :shop],
 :transition-prob
 {:rainy {:sunny 0.15290842575294025, :rainy 0.8470915742470598},
  :sunny {:sunny 0.7944099568677614, :rainy 0.20559004313223866}},
 :observation-prob
 {:rainy
  {:shop 0.17992544383482936,
   :clean 0.5032243598745245,
   :run 0.31685019629064615},
  :sunny
  {:shop 0.1995410394723953,
   :clean 0.3334005417814596,
   :run 0.4670584187461452}},
 :initial-prob {:sunny 0.05689179111816801, :rainy 0.943108208881832}}

SAMPLE:
S = :rainy, E = :clean
S = :rainy, E = :clean
S = :rainy, E = :clean
S = :sunny, E = :shop
S = :sunny, E = :run
S = :rainy, E = :clean
S = :rainy, E = :clean
S = :rainy, E = :clean
S = :sunny, E = :run
S = :sunny, E = :run


$ java -jar hidden-markov-music-0.1.1-standalone.jar --model weather --number 15
MODEL:
{:states [:rainy :sunny],
 :observations [:run :clean :shop],
 :transition-prob
 {:rainy {:sunny 0.344173499514248, :rainy 0.655826500485752},
  :sunny {:sunny 0.659253867160301, :rainy 0.34074613283969907}},
 :observation-prob
 {:rainy
  {:shop 0.4582534082891948,
   :clean 0.18845548548249824,
   :run 0.353291106228307},
  :sunny
  {:shop 0.22074445675297727,
   :clean 0.2564510210102876,
   :run 0.5228045222367352}},
 :initial-prob {:sunny 0.25606152474353544, :rainy 0.7439384752564645}}

SAMPLE:
S = :rainy, E = :shop
S = :rainy, E = :shop
S = :rainy, E = :run
S = :rainy, E = :shop
S = :rainy, E = :shop
S = :rainy, E = :shop
S = :rainy, E = :shop
S = :sunny, E = :clean
S = :sunny, E = :clean
S = :rainy, E = :shop
S = :sunny, E = :run
S = :sunny, E = :run
S = :sunny, E = :shop
S = :sunny, E = :clean
S = :rainy, E = :shop
{% endhighlight %}

Note that the model is different each time, and the length of the sample
matches the argument to `--number`. This is accomplished by producing an
infinite lazy sequence of states, let's call it `states`, and using the `take`
function to only evaluate the first `N` states.

{% highlight clojure %}
(take N states)
{% endhighlight %}


## Random Songs

The second option demonstrates an HMM for a song, where the state transition
probabilities are predefined, but the emission probabilities are randomly
determined. The states correspond to parts of the song: `beginning`, `middle`,
`chorus`, `finale`, and `end`. Each state emits notes `A` through `G`. Each
state has a high probability of transitioning to itself, and a low probability
to transitioning to one or two other states, but always has some transitions
with zero probability. For instance, `beginning` never transitions directly to
`finale`, but `middle` and `chorus` can transition back and forth. The `end`
state is special, because it is used as a signal to stop taking elements from
the sequence. The `take-while` function is used, which is a counter-part to
`take`, and takes a predicate function instead of a number. If we refer to the
lazy sequence as `states` once again, we can demonstrate the method by which
the sampled states are evaluated with the following snippet:

{% highlight clojure %}
(take-while (fn [state] (not= state :end))
            states)
{% endhighlight %}

Here are some sample runs. Note the varying sample durations.

{% highlight clojure %}
$ java -jar hidden-markov-music-0.1.1-standalone.jar --model song
MODEL:
{:states [:beginning :middle :chorus :finale :end],
 :observations [:A :B :C :D :E :F :G],
 :transition-prob
 {:beginning
  {:beginning 0.8, :finale 0.0, :chorus 0.0, :middle 0.2, :end 0.0},
  :finale
  {:beginning 0.0, :finale 0.8, :chorus 0.0, :middle 0.0, :end 0.2},
  :chorus
  {:beginning 0.0, :finale 0.0, :chorus 0.8, :middle 0.2, :end 0.0},
  :middle
  {:beginning 0.0, :finale 0.1, :chorus 0.4, :middle 0.5, :end 0.0},
  :end
  {:beginning 0.0, :finale 0.0, :chorus 0.0, :middle 0.0, :end 1.0}},
 :observation-prob
 {:beginning
  {:G 0.1508309681509713,
   :F 0.15368721592793577,
   :E 0.079066941340102,
   :D 0.17695854271291928,
   :C 0.16146726189345484,
   :B 0.03045306995996941,
   :A 0.2475360000146473},
  :middle
  {:G 0.12005076180581573,
   :F 0.06428695107404409,
   :E 0.3036071119102001,
   :D 0.21653617501862477,
   :C 0.03257088347348895,
   :B 0.016584061526303002,
   :A 0.24636405519152335},
  :chorus
  {:G 0.09263548066381984,
   :F 0.01203872772096103,
   :E 0.02990012466171941,
   :D 0.07466421448321871,
   :C 0.24091189200891075,
   :B 0.28023840813910855,
   :A 0.2696111523222619},
  :finale
  {:G 0.17095453372314598,
   :F 0.17234277762521422,
   :E 0.24731411503150375,
   :D 0.2460561422855615,
   :C 0.08448991466448294,
   :B 0.0063640704204651535,
   :A 0.07247844624962635},
  :end
  {:G 0.10528129534675565,
   :F 0.062358828230124855,
   :E 0.23776864068339829,
   :D 0.13049013305659535,
   :C 0.13991833986847177,
   :B 0.24745917867305567,
   :A 0.07672358414159838}},
 :initial-prob
 {:beginning 1.0, :finale 0.0, :chorus 0.0, :middle 0.0, :end 0.0}}

SAMPLE:
S = :beginning, E = :B
S = :beginning, E = :G
S = :middle, E = :D
S = :finale, E = :E
S = :finale, E = :A


$ java -jar hidden-markov-music-0.1.1-standalone.jar --model song
MODEL:
{:states [:beginning :middle :chorus :finale :end],
 :observations [:A :B :C :D :E :F :G],
 :transition-prob
 {:beginning
  {:beginning 0.8, :finale 0.0, :chorus 0.0, :middle 0.2, :end 0.0},
  :finale
  {:beginning 0.0, :finale 0.8, :chorus 0.0, :middle 0.0, :end 0.2},
  :chorus
  {:beginning 0.0, :finale 0.0, :chorus 0.8, :middle 0.2, :end 0.0},
  :middle
  {:beginning 0.0, :finale 0.1, :chorus 0.4, :middle 0.5, :end 0.0},
  :end
  {:beginning 0.0, :finale 0.0, :chorus 0.0, :middle 0.0, :end 1.0}},
 :observation-prob
 {:beginning
  {:G 0.20143238933347346,
   :F 0.15551526141796368,
   :E 0.16277322550821022,
   :D 0.1720958316716992,
   :C 0.054199440675473574,
   :B 0.22427402209380504,
   :A 0.029709829299374834},
  :middle
  {:G 0.1021063135605175,
   :F 0.21950608367754282,
   :E 0.18919919219508524,
   :D 0.18626842795120616,
   :C 0.17074153753933766,
   :B 0.02532689398642226,
   :A 0.10685155108988838},
  :chorus
  {:G 0.25976486943585025,
   :F 0.04415883369321402,
   :E 0.2342753237784126,
   :D 0.13035986998156399,
   :C 0.13258648445526064,
   :B 0.18751834456208297,
   :A 0.011336274093615397},
  :finale
  {:G 0.12058957367874495,
   :F 0.09679073772535408,
   :E 0.17410245213567632,
   :D 0.12115362598239593,
   :C 0.2003299708326019,
   :B 0.11671750049553742,
   :A 0.17031613914968943},
  :end
  {:G 0.2471501223910595,
   :F 0.19171631805403538,
   :E 0.07704646509624592,
   :D 0.041757749043241824,
   :C 0.182983645209612,
   :B 0.12242888814615784,
   :A 0.13691681205964762}},
 :initial-prob
 {:beginning 1.0, :finale 0.0, :chorus 0.0, :middle 0.0, :end 0.0}}

SAMPLE:
S = :beginning, E = :E
S = :beginning, E = :F
S = :middle, E = :D
S = :chorus, E = :G
S = :chorus, E = :G
S = :chorus, E = :B
S = :middle, E = :C
S = :chorus, E = :E
S = :chorus, E = :B
S = :chorus, E = :C
S = :chorus, E = :F
S = :chorus, E = :G
S = :chorus, E = :E
S = :middle, E = :G
S = :middle, E = :F
S = :middle, E = :E
S = :chorus, E = :G
S = :chorus, E = :D
S = :chorus, E = :A
S = :chorus, E = :E
S = :chorus, E = :C
S = :chorus, E = :C
S = :chorus, E = :D
S = :chorus, E = :E
S = :chorus, E = :D
S = :chorus, E = :B
S = :chorus, E = :E
S = :chorus, E = :B
S = :chorus, E = :G
S = :chorus, E = :E
S = :middle, E = :F
S = :chorus, E = :G
S = :chorus, E = :G
S = :chorus, E = :D
S = :chorus, E = :D
S = :chorus, E = :G
S = :chorus, E = :D
S = :middle, E = :E
S = :chorus, E = :C
S = :chorus, E = :C
S = :chorus, E = :G
S = :chorus, E = :C
S = :middle, E = :A
S = :chorus, E = :E
S = :chorus, E = :G
S = :chorus, E = :B
S = :chorus, E = :A
S = :chorus, E = :B
S = :chorus, E = :E
S = :chorus, E = :G
S = :chorus, E = :B
S = :chorus, E = :B
S = :chorus, E = :B
S = :middle, E = :G
S = :chorus, E = :G
S = :chorus, E = :D
S = :middle, E = :C
S = :middle, E = :D
S = :middle, E = :G
S = :chorus, E = :C
S = :chorus, E = :G
S = :chorus, E = :C
S = :chorus, E = :D
S = :chorus, E = :G
S = :chorus, E = :G
S = :chorus, E = :B
S = :chorus, E = :E
S = :chorus, E = :E
S = :chorus, E = :E
S = :chorus, E = :E
S = :chorus, E = :C
S = :chorus, E = :C
S = :chorus, E = :F
S = :chorus, E = :B
S = :chorus, E = :G
S = :chorus, E = :B
S = :chorus, E = :G
S = :chorus, E = :G
S = :chorus, E = :C
S = :middle, E = :D
S = :chorus, E = :G
S = :chorus, E = :D
S = :chorus, E = :E
S = :chorus, E = :G
S = :chorus, E = :G
S = :middle, E = :C
S = :middle, E = :D
S = :chorus, E = :E
S = :chorus, E = :C
S = :chorus, E = :E
S = :chorus, E = :G
S = :middle, E = :F
S = :middle, E = :A
S = :chorus, E = :C
S = :middle, E = :F
S = :chorus, E = :G
S = :chorus, E = :D
S = :chorus, E = :B
S = :chorus, E = :C
S = :chorus, E = :G
S = :chorus, E = :G
S = :chorus, E = :C
S = :middle, E = :C
S = :chorus, E = :D
S = :chorus, E = :D
S = :chorus, E = :G
S = :chorus, E = :B
S = :chorus, E = :B
S = :chorus, E = :C
S = :chorus, E = :B
S = :middle, E = :F
S = :finale, E = :E
S = :finale, E = :A
S = :finale, E = :C
S = :finale, E = :A
S = :finale, E = :G
S = :finale, E = :D
S = :finale, E = :D
S = :finale, E = :F


$ java -jar hidden-markov-music-0.1.1-standalone.jar --model song
MODEL:
{:states [:beginning :middle :chorus :finale :end],
 :observations [:A :B :C :D :E :F :G],
 :transition-prob
 {:beginning
  {:beginning 0.8, :finale 0.0, :chorus 0.0, :middle 0.2, :end 0.0},
  :finale
  {:beginning 0.0, :finale 0.8, :chorus 0.0, :middle 0.0, :end 0.2},
  :chorus
  {:beginning 0.0, :finale 0.0, :chorus 0.8, :middle 0.2, :end 0.0},
  :middle
  {:beginning 0.0, :finale 0.1, :chorus 0.4, :middle 0.5, :end 0.0},
  :end
  {:beginning 0.0, :finale 0.0, :chorus 0.0, :middle 0.0, :end 1.0}},
 :observation-prob
 {:beginning
  {:G 0.00639161546042577,
   :F 0.38472318640778935,
   :E 0.22012750520268148,
   :D 0.16921825941851767,
   :C 0.1747761107326599,
   :B 0.008765391933627064,
   :A 0.03599793084429881},
  :middle
  {:G 0.2398279388892917,
   :F 0.14950669312979956,
   :E 0.1824679967622751,
   :D 0.14358460039023815,
   :C 0.09552067739047057,
   :B 0.09259268971001008,
   :A 0.09649940372791492},
  :chorus
  {:G 0.14323756418816158,
   :F 0.2172621202038465,
   :E 0.25049000081339334,
   :D 0.2387604743405832,
   :C 0.035004101919727894,
   :B 0.10810262957794345,
   :A 0.007143108956343943},
  :finale
  {:G 0.15354096091255215,
   :F 0.08223841582866863,
   :E 0.14595373827374877,
   :D 0.253878563497316,
   :C 0.00406848104785561,
   :B 0.13543687061744433,
   :A 0.22488296982241443},
  :end
  {:G 0.21197766614284205,
   :F 0.03290573337770725,
   :E 0.02489642227853659,
   :D 0.0840650078384229,
   :C 0.2049859975737943,
   :B 0.22756670274569424,
   :A 0.2136024700430027}},
 :initial-prob
 {:beginning 1.0, :finale 0.0, :chorus 0.0, :middle 0.0, :end 0.0}}

SAMPLE:
S = :beginning, E = :E
S = :beginning, E = :F
S = :beginning, E = :C
S = :beginning, E = :E
S = :middle, E = :D
S = :middle, E = :E
S = :chorus, E = :D
S = :chorus, E = :D
S = :middle, E = :D
S = :middle, E = :B
S = :middle, E = :E
S = :finale, E = :G
S = :finale, E = :A
S = :finale, E = :A
S = :finale, E = :F
S = :finale, E = :E
S = :finale, E = :D
S = :finale, E = :F
{% endhighlight %}