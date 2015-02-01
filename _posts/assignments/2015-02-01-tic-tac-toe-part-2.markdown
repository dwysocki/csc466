---
layout: post
category: assignments
title: "Tic-tac-toe (Part 2)"
date: 2015-02-05T14:20:00-05:00
---

# Code

{% highlight cl %}
(defconstant player-tokens '(x o x o x o x o x))
(defconstant move-numbers  '(1 2 3 4 5 6 7 8 9))
(defconstant all-runs '((0 1 2)
                        (3 4 5)
                        (6 7 8)
                        (0 3 6)
                        (1 4 7)
                        (2 5 8)
                        (0 4 8)
                        (2 4 6)))

(defmethod multi-nth ((ns list) (the-list list))
  (mapcar (lambda (n) (nth n the-list))
          ns))

(defmethod get-all-runs ((play list))
  (mapcar (lambda (ns) (multi-nth ns play))
          all-runs))

(defmethod take ((n integer) (the-list list))
  (if (or (= n 0)
          (null the-list))
    nil
    (cons (car the-list)
          (take (1- n)
                (cdr the-list)))))

(defmethod sort-by-nth ((list-of-lists list) (n integer) (predicate function))
  (sort list-of-lists
        (lambda (x y) (funcall predicate (nth n x) (nth n y)))))

(defmethod select ((the-list list))
  (let ((n (random (length the-list))))
    (nth n the-list)))

(defmethod snoc (element (the-list list))
  (append the-list
          (list element)))

(defmethod play ()
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

(defmethod print-row ((row list))
  (format t "~{~{~A~D~}~^ ~}~%" row))

(defmethod outcome-move ((tokens-moves list))
  (let ((tokens (mapcar #'first  tokens-moves))
        (moves  (mapcar #'second tokens-moves)))
    (list (apply   #'max moves)
          (outcome tokens))))

(defmethod outcome ((tokens list))
  (cond
   ((equal tokens '(x x x)) 'w)
   ((equal tokens '(o o o)) 'l)
   (T                       nil)))

(defmethod sort-by-position ((play list))
  (let ((location-token-move (mapcar #'list play
                                            player-tokens
                                            move-numbers)))
    (mapcar #'cdr
            (mapcar (lambda (location) (assoc location location-token-move))
                    '(nw n ne
                       w c  e
                      sw s se)))))

(defmethod visualize ((play list))
  (let ((positions (sort-by-position play)))
    (mapcar #'print-row
            (list (subseq positions 0 3)
                  (subseq positions 3 6)
                  (subseq positions 6 9))))
  nil)

(defmethod analyze ((play list))
  (let* ((positions      (sort-by-position play))
         (tokens-moves   (get-all-runs positions))
         (outcomes-moves (mapcar #'outcome-move tokens-moves))
         (winning-moves  (remove-if (lambda (x) (null (second x)))
                                    outcomes-moves)))
    (if winning-moves
      (second (first (sort-by-nth winning-moves 0 #'<)))
      'D)))

(defmethod demo-va ()
  (let ((p (play)))
    (format t "~A~%" p)
    (visualize p)
    (format t "~A~%" (analyze p)))
  nil)

(defmethod stats ((n integer) (demo t))
  (when demo
    (format t "BEGIN GATHERING STATISTICS ...~%"))
  (let ((w 0)
        (l 0)
        (d 0))
    (dotimes (i n)
      (let* ((p (play))
             (result (analyze p)))
        (when demo
          (format t "~A~%" p)
          (visualize p)
          (format t "~A~%" result))
        (cond
         ((eq result 'w) (setf w (1+ w)))
         ((eq result 'l) (setf l (1+ l)))
         ((eq result 'd) (setf d (1+ d))))))
    (let ((results (mapcar #'probability
                           (list w l d)
                           (list n n n))))
      (when demo
        (format t "END GATHERING STATISTICS~%"))
      (mapcar #'list
              '(w l d)
              results))))

(defmethod probability ((special integer) (total integer))
  (float (/ special
            total)))
{% endhighlight %}

# Demo

{% highlight cl %}
[1]> (load "ttt2.l")
;; Loading file ttt2.l ...
;; Loaded file ttt2.l
T
[2]> (demo-va)
(SE SW E W S C NE N NW)
X9 O8 X7
O4 O6 X3
O2 X5 X1
W
NIL
[3]> (demo-va)
(SE SW C W NW E NE N S)
X5 O8 X7
O4 X3 O6
O2 X9 X1
W
NIL
[4]> (stats 5 t)
BEGIN GATHERING STATISTICS ...
(N SW NE SE W S E C NW)
X9 X1 X3
X5 O8 X7
O2 O6 O4
L
(S E C SW N NE W NW SE)
O8 X5 O6
X7 X3 O2
O4 X1 X9
W
(N E NE C SW NW S SE W)
O6 X1 X3
X9 O4 O2
X5 X7 O8
L
(N NE C NW S W SW E SE)
O4 X1 O2
O6 X3 O8
X7 X5 X9
W
(SE NW E N C SW NE W S)
O2 O4 X7
O8 X5 X3
O6 X9 X1
W
END GATHERING STATISTICS
((W 0.6) (L 0.4) (D 0.0))
[5]> (stats 5 t)
BEGIN GATHERING STATISTICS ...
(NW C SE E NE S SW N W)
X1 O8 X5
X9 O2 O4
X7 O6 X3
L
(NW S E C NE W SE N SW)
X1 O8 X5
O6 O4 X3
X9 O2 X7
W
(SW W SE NE NW S E N C)
X5 O8 O4
O2 X9 X7
X1 O6 X3
W
(SE E NW N C NE S SW W)
X3 O4 O6
X9 X5 O2
O8 X7 X1
W
(S C NE SE NW W SW N E)
X5 O8 X3
O6 O2 X9
X7 X1 O4
D
END GATHERING STATISTICS
((W 0.6) (L 0.2) (D 0.2))
[6]> (stats 1000 nil)
((W 0.585) (L 0.289) (D 0.126))
[7]> (bye)
Bye.
{% endhighlight %}

# Statistics

There was a 58.5% win-rate for `X`, compared to a 28.9% win-rate for `O`,
demonstrating that having first move contributes a significant amount to the
win rate. These numbers are very close to `W=7/12`, `L=7/24`, `D=1/8`.
A theoretical prediction of the probability of each outcome should be done,
to see if these numbers are accurate.