---
layout: post
category: assignments
title: "Tic-tac-toe (Part 1)"
date: 2015-02-03T14:20:00-05:00
---

# Code

{% highlight cl %}
{% include_relative code/ttt1.l %}
{% endhighlight %}


# Demo

## Play 1

Outcome: Loss

    Turn 1
    ======
     | | 
    -----
     | | 
    -----
     |X| 
    
    Turn 2
    ======
     | | 
    -----
    O| | 
    -----
     |X| 
    
    Turn 3
    ======
     | |X
    -----
    O| | 
    -----
     |X| 
    
    Turn 4
    ======
     | |X
    -----
    O| | 
    -----
    O|X| 
    
    Turn 5
    ======
     | |X
    -----
    O|X| 
    -----
    O|X| 
    
    Turn 6
    ======
     |O|X
    -----
    O|X| 
    -----
    O|X| 
    
    Turn 7
    ======
     |O|X
    -----
    O|X|X
    -----
    O|X| 
    
    Turn 8
    ======
    O|O|X
    -----
    O|X|X
    -----
    O|X| 
    
    Turn 9
    ======
    O|O|X
    -----
    O|X|X
    -----
    O|X|X

## Play 2

Outcome: Loss

    Turn 1
    ======
     | | 
    -----
    X| | 
    -----
     | | 
    
    Turn 2
    ======
     |O| 
    -----
    X| | 
    -----
     | | 
    
    Turn 3
    ======
     |O| 
    -----
    X| | 
    -----
    X| | 
    
    Turn 4
    ======
     |O| 
    -----
    X| | 
    -----
    X|O| 
    
    Turn 5
    ======
     |O|X
    -----
    X| | 
    -----
    X|O| 
    
    Turn 6
    ======
     |O|X
    -----
    X| |O
    -----
    X|O| 
    
    Turn 7
    ======
     |O|X
    -----
    X| |O
    -----
    X|O|X
    
    Turn 8
    ======
     |O|X
    -----
    X|O|O
    -----
    X|O|X
    
    Turn 9
    ======
    X|O|X
    -----
    X|O|O
    -----
    X|O|X

## Play 3

Outcome: Win

    Turn 1
    ======
     | | 
    -----
     | | 
    -----
    X| | 
    
    Turn 2
    ======
     |O| 
    -----
     | | 
    -----
    X| | 
    
    Turn 3
    ======
     |O| 
    -----
     | | 
    -----
    X| |X
    
    Turn 4
    ======
     |O| 
    -----
    O| | 
    -----
    X| |X
    
    Turn 5
    ======
     |O|X
    -----
    O| | 
    -----
    X| |X
    
    Turn 6
    ======
     |O|X
    -----
    O|O| 
    -----
    X| |X
    
    Turn 7
    ======
     |O|X
    -----
    O|O|X
    -----
    X| |X
    
    Turn 8
    ======
     |O|X
    -----
    O|O|X
    -----
    X|O|X
    
    Turn 9
    ======
    X|O|X
    -----
    O|O|X
    -----
    X|O|X

## Play 4

Outcome: Win

    Turn 1
    ======
     | | 
    -----
     |X| 
    -----
     | | 
    
    Turn 2
    ======
     |O| 
    -----
     |X| 
    -----
     | | 
    
    Turn 3
    ======
     |O| 
    -----
     |X|X
    -----
     | | 
    
    Turn 4
    ======
     |O| 
    -----
     |X|X
    -----
     |O| 
    
    Turn 5
    ======
    X|O| 
    -----
     |X|X
    -----
     |O| 
    
    Turn 6
    ======
    X|O|O
    -----
     |X|X
    -----
     |O| 
    
    Turn 7
    ======
    X|O|O
    -----
     |X|X
    -----
     |O|X
    
    Turn 8
    ======
    X|O|O
    -----
    O|X|X
    -----
     |O|X
    
    Turn 9
    ======
    X|O|O
    -----
    O|X|X
    -----
    X|O|X

## Play 5

Outcome: Win

    Turn 1
    ======
     | | 
    -----
    X| | 
    -----
     | | 
    
    Turn 2
    ======
     | | 
    -----
    X| | 
    -----
    O| | 
    
    Turn 3
    ======
     | | 
    -----
    X| | 
    -----
    O|X| 
    
    Turn 4
    ======
     | |O
    -----
    X| | 
    -----
    O|X| 
    
    Turn 5
    ======
     | |O
    -----
    X|X| 
    -----
    O|X| 
    
    Turn 6
    ======
     |O|O
    -----
    X|X| 
    -----
    O|X| 
    
    Turn 7
    ======
    X|O|O
    -----
    X|X| 
    -----
    O|X| 
    
    Turn 8
    ======
    X|O|O
    -----
    X|X|O
    -----
    O|X| 
    
    Turn 9
    ======
    X|O|O
    -----
    X|X|O
    -----
    O|X|X