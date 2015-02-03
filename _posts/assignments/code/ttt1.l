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
  (let ((move-pairs (mapcar #'cons moves player-tokens)))
    (dotimes (i 9)
      (format t "Turn ~D~%" (1+ i))
      (format t "======~%")
      (print-board (take (1+ i) move-pairs))
      (terpri))))
