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

(defclass player ()
  ((name :accessor player-name :initarg :name :initform 'emanon)))

(defclass random-machine-player (player) ())
(defclass human-player (player) ())
(defclass heuristic-machine-player (player)
  ((rules :accessor heuristic-machine-player-rules
          :initform NIL)))

(defmethod make-rule ((l list))
  `(if   (prefix of ,l matches the play so far)
       then (select move from ,l)))

(defmethod add-rule ((p heuristic-machine-player) (l list))
  (setf (heuristic-machine-player-rules p)
        (append (heuristic-machine-player-rules p)
                (list (make-rule l))))
  nil)

(defmethod add-rules ((p heuristic-machine-player) (n integer))
  (dotimes (i n)
    (add-rule p (winning-play)))
  nil)

(defmethod winning-play ()
  (let ((p (play)))
    (if (eq (game-over-p p) 'w)
      p
      (winning-play))))

(defmethod display ((p random-machine-player))
  (format t "RANDOM MACHINE PLAYER ...~%")
  (format t "name = ~A~%" (player-name p))
  (terpri)
  nil)

(defmethod display ((p human-player))
  (format t "HUMAN PLAYER ...~%")
  (format t "name = ~A~%" (player-name p))
  (terpri)
  nil)

(defmethod display ((p heuristic-machine-player))
  (format t "HEURISTIC MACHINE PLAYER ...~%")
  (format t "name = ~A~%" (player-name p))
  (format t "number of rules = ~A~%" (length
                                      (heuristic-machine-player-rules p)))
  (format t "rules ...~%")
  (dolist (rule (heuristic-machine-player-rules p))
    (print-rule rule)
    (terpri))
  (terpri)
  nil)

(defmethod print-rule ((rule list))
  (format t "~A ~A~%~A ~A~%"
          (first rule) (second rule) (third rule) (fourth rule))
  nil)

(defmethod make-move ((p random-machine-player) (report t))
  (let ((move (select *avail*)))
    (when report
      (format t "BEGIN RANDOM PLAYER MOVE ...~%")
      (format t "randomly selecting ~A for my move ~%" move)
      (format t "END RANDOM PLAYER MOVE ...~%"))
    (setf *avail* (remove move *avail*))
    move))

(defmethod make-move ((p human-player) (report t))
  (when report
    (format t "BEGIN HUMAN PLAYER MOVE ...~%"))
  (format t "Please select a move from ~A~%" *avail*)
  (let ((move (read)))
    (if (not (member move *avail*))
      (make-move p)
      (setf *avail* (remove move *avail*)))
    (when report
      (format t "END HUMAN PLAYER MOVE~%"))
    move))

(defmethod make-move ((p heuristic-machine-player) (report t))
  (when report
    (format t "BEGIN HEURISTIC PLAYER MOVE ...~%"))
  (let ((rule (select-from-rule-base p)))
    (if (null rule)
      (progn
        (setf move (select *avail*))
        (setf *nr-random-moves-by-hmp* (1+ *nr-random-moves-by-hmp*))
        (setf *most-recent-hmp-move* 'random)
        (when report
          (format t "making random move ~A since no rule is applicable.~%"
                  move)))
      (progn
        (setf move (apply-rule rule))
        (setf *nr-heuristic-moves-by-hmp* (1+ *nr-heuristic-moves-by-hmp*))
        (setf *most-recent-hmp-move* 'heuristic)
        (when report
          (format t "play so far = ~A~%" *play-so-far*)
          (format t "Making move ~A by applying the rule ...~%" move)
          (print-rule rule))))
    (setf *avail* (remove move *avail*))
    (when report
      (format t "END HEURISTIC PLAYER MOVE~%"))
    move))

(defmethod select-from-rule-base ((p heuristic-machine-player))
  (let ((rule-base (heuristic-machine-player-rules p)))
    (first (remove-if-not #'applicablep rule-base))))

(defmethod applicablep ((rule list))
  (setf the-play (third (second rule)))
  (matches *play-so-far* the-play))

(defmethod matches ((psf list) (play list))
  (cond
   ((null psf) t)
   ((eq (car psf) (car play))
    (matches (cdr psf)
             (cdr play)))))

(defmethod apply-rule ((rule list))
  (let ((the-play (fourth (fourth rule))))
    (nth (length *play-so-far*)
         the-play)))

(defmethod generic-play ((x player) (o player) (report t) &aux move)
  (setf *avail*       '(nw n ne w c e sw s se))
  (setf *play-so-far* ())
  (dolist (player '(x o x o x o x o x))
    (when (or report (equal (type-of o) 'human-player-machine))
      (visualize *play-so-far*))
    (cond
     ((eq player 'x) (setf move (make-move x report)))
     ((eq player 'o) (setf move (make-move o report))))
    (setf *play-so-far* (snoc move *play-so-far*))
    (when (game-over-p *play-so-far*)
      (return nil)))
  *play-so-far*)

(defmethod generic-play-with-stats ((x player) (o player) (report t))
  (setf *avail* '(nw n ne w c e sw s se))
  (setf *play-so-far* ())
  (let (move)
    (dolist (player '(x o x o x o x o x))
      (visualize *play-so-far*)
      (cond
       ((eq player 'x)
        (setf move (make-move x report)))
       ((eq player 'o)
        (setf move (make-move o report))))
      (setf *play-so-far* (snoc move *play-so-far*))
      (when (game-over-p *play-so-far*)
        (return nil)))
    (cond
     ((eq (game-over-p *play-so-far*) 'w)
      (cond
       ((eq *most-recent-hmp-move* 'random)
        (setf *nr-random-move-wins-by-hmp*
              (1+ *nr-random-move-wins-by-hmp*)))
       ((eq *most-recent-hmp-move* 'heuristic)
        (setf *nr-heuristic-move-wins-by-hmp*
              (1+ *nr-heuristic-move-wins-by-hmp*)))))))
  *play-so-far*)

(defmethod game-over-p ((play list))
  (cond
   ((line-p (odd play))  'w)
   ((line-p (even play)) 'l)
   ((= (length play) 9)  'd)))

(defmethod odd ((l list))
  (cond
   ((null l) ())
   ((null (cdr l)) (list (car l)))
   (t (cons (car l)
            (odd (cddr l))))))

(defmethod even ((l list))
  (cond
   ((null l) ())
   ((null (cdr l)) ())
   (t (cons (cadr l)
            (even (cddr l))))))

(defun line (&rest line)
  (or (subsetp '(nw n ne) line)
      (subsetp '( w c  e) line)
      (subsetp '(sw s se) line)
      (subsetp '(nw w sw) line)
      (subsetp '(n  c s ) line)
      (subsetp '(ne e se) line)
      (subsetp '(nw c se) line)
      (subsetp '(ne c sw) line)))

(defmethod line-p ((l list))
  (cond
   ((< (length l) 3)
    nil)

   ((= (length l) 3)
    (line (first  l)
          (second l)
          (third  l)))

   ((= (length l) 4)
    (or
     (line (first l)  (second l) (third l))
     (line (first l)  (second l) (fourth l))
     (line (first l)  (third l)  (fourth l))
     (line (second l) (third l)  (fourth l))))

   ((= (length l) 5)
    (or
     (line (first l)  (second l) (third l))
     (line (first l)  (second l) (fourth l))
     (line (first l)  (second l) (fifth l))
     (line (first l)  (third l)  (fourth l))
     (line (first l)  (third l)  (fifth l))
     (line (second l) (third l)  (fourth l))
     (line (second l) (third l) (fifth l))
     (line (second l) (fourth l) (fifth l))
     (line (third l) (fourth l) (fifth l))))))

(defmethod demo-random-random ()
  (let* ((x (make-instance 'random-machine-player))
         (o (make-instance 'random-machine-player))
         (p (generic-play x o t)))
    (format t "~A~%" p)
    (visualize p)
    (format t "~A~%" (game-over-p p))
    nil))

(defmethod demo-random-human ()
  (let* ((x (make-instance 'random-machine-player))
         (o (make-instance 'human-player))
         (p (generic-play x o t)))
    (format t "~A~%" p)
    (visualize p)
    (format t "~A~%" (game-over-p p))
    nil))

(defmethod demo-human-random ()
  (let* ((x (make-instance 'human-player))
         (o (make-instance 'random-machine-player))
         (p (generic-play x o t)))
    (format t "~A~%" p)
    (visualize p)
    (format t "~A~%" (game-over-p p))
    nil))


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
  (format t "~{~{~A~D~}~^║~}~%" row))

(defmethod print-row-sep ()
  (format t "══╬══╬══~%"))

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
            (mapcar (lambda (location)
                      (assoc location location-token-move))
                    '(nw n ne
                       w c  e
                      sw s se)))))

(defmethod sort-by-position* ((play list))
  (let ((location-token-move (mapcar #'list play
                                            player-tokens
                                            move-numbers)))
    (mapcar #'cdr
            (mapcar (lambda (location)
                      (or (assoc location location-token-move)
                          (list location " " " ")))
                    '(nw n ne
                       w c  e
                      sw s se)))))

(defmethod visualize ((play list))
  (let ((positions (sort-by-position* play)))
    (print-row (subseq positions 0 3))
    (print-row-sep)
    (print-row (subseq positions 3 6))
    (print-row-sep)
    (print-row (subseq positions 6 9)))
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


(defmethod demo-heuristic-human ((nr-rules integer) &aux p x o)
  (setf *nr-random-moves-by-hmp* 0)
  (setf *nr-heuristic-moves-by-hmp* 0)
  (setf *nr-random-move-wins-by-hmp* 0)
  (setf *nr-heuristic-move-wins-by-hmp* 0)

  (setf x (make-instance 'heuristic-machine-player :name 'hm))
  (add-rules x nr-rules)
  (display x)

  (setf o (make-instance 'human-player :name 'hu))
  (display o)

  (setf p (generic-play-with-stats x o t))

  (format t "GAME SUMMARY~%")
  (format t "Play of the game = ~A~%" p)
  (visualize p)

  (format t "~A~%" (game-over-p p))
  (format t "HEURISTIC USE SUMMARY~%")
  (summarize-heuristic-use)

  nil)

(defmethod summarize-heuristic-use ()
  (format t "random move count = ~A and heuristic move count = ~A~%"
          *nr-random-moves-by-hmp* *nr-heuristic-moves-by-hmp*)
  (format t "random move wins = ~A and heuristic move wins = ~A~%"
          *nr-random-move-wins-by-hmp* *nr-heuristic-move-wins-by-hmp*)
  nil)

(defmethod demo-heuristic-random ((nr-rules integer) &aux p x o)
  (setf *nr-random-moves-by-hmp* 0)
  (setf *nr-heuristic-moves-by-hmp* 0)
  (setf *nr-random-move-wins-by-hmp* 0)
  (setf *nr-heuristic-move-wins-by-hmp* 0)

  (setf x (make-instance 'heuristic-machine-player :name 'hm))
  (add-rules x nr-rules)
  (display x)

  (setf o (make-instance 'random-machine-player :name 'rm))
  (display o)

  (setf p (generic-play-with-stats x o t))

  (format t "GAME SUMMARY~%")
  (format t "Play of the game = ~A~%" p)
  (visualize p)

  (format t "~A~%" (game-over-p p))
  (format t "HEURISTIC USE SUMMARY~%")
  (summarize-heuristic-use)

  nil)
