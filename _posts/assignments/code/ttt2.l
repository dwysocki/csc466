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
