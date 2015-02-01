---
layout: post
category: assignments
title: "Tic-tac-toe (Part 1)"
date: 2015-02-03T14:20:00-05:00
---

# Code

{% highlight cl %}
(defconstant player-tokens '(x o x o x o x o x))

(defun take (n the-list)
  (if (or (= n 0)
          (null the-list))
    nil
    (cons (car the-list)
          (take (1- n)
                (cdr the-list)))))

(defun select (the-list)
  (let ((n (random (length the-list))))
    (nth n the-list)))

(defun snoc (element the-list)
  (append the-list
          (list element)))

(defun play ()
  (let* ((play  ())
         (avail '(nw n ne w c e sw s se)))
    (dolist (player player-tokens)
      (cond
       ((eq player 'x)
        (setf move (select avail))
        (setf avail (remove move avail))
        (setf play (snoc move play)))

       ((eq player 'o)
        (setf move (select avail))
        (setf avail (remove move avail))
        (setf play (snoc move play)))))
    play))

(defun print-if-assoc (symbol alist)
  (let ((elem (assoc symbol alist)))
    (if elem
      (format t (string (cdr elem)))
      (format t " "))))

(defun print-vbar ()
  (format t "|"))

(defun print-hbar ()
  (format t "-----"))

(defun print-board (move-pairs)
  (print-if-assoc 'nw move-pairs)
  (print-vbar)
  (print-if-assoc 'n  move-pairs)
  (print-vbar)
  (print-if-assoc 'ne move-pairs)

  (terpri)
  (print-hbar)
  (terpri)

  (print-if-assoc 'w  move-pairs)
  (print-vbar)
  (print-if-assoc 'c  move-pairs)
  (print-vbar)
  (print-if-assoc 'e  move-pairs)

  (terpri)
  (print-hbar)
  (terpri)

  (print-if-assoc 'sw move-pairs)
  (print-vbar)
  (print-if-assoc 's  move-pairs)
  (print-vbar)
  (print-if-assoc 'se move-pairs)

  (terpri))

(defun print-game (moves)
  (let ((move-pairs (pairlis moves player-tokens)))
    (dotimes (i 9)
      (format t "Turn ~D~%" (1+ i))
      (format t "======~%")
      (print-board (take (1+ i) move-pairs))
      (terpri))))
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