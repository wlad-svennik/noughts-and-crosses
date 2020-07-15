(defpackage noughts-and-crosses
  (:use :cl :ltk)
  (:export noughts-and-crosses))
(in-package :noughts-and-crosses)

(defun create-board ()
  (loop for i from 1 to 3 collect
        (loop for j from 1 to 3 collect nil)))

(defun at-position (i j board)
  (nth j (nth i board)))

(defun cpu-choose (board symbol scheduler)
  (let ((choice-i (random 3))
        (choice-j (random 3)))
    (if (not (illegal-choice choice-i choice-j board))
        (funcall scheduler choice-i choice-j)
        (cpu-choose board symbol scheduler))))

(defun illegal-choice (i j board)
  (at-position i j board))

(defun set-at-position (row-index col-index mat val)
  (loop for i from 0 to (length mat)
        for row in mat
        collect (loop for j from 0 to (length row)
                      for entry in row
                      collect (if (and (= i row-index) (= j col-index))
                                  val
                                  entry))))

(defun wonp (current-symbol board)
  (let ((rows board)
        (columns (apply #'mapcar #'list board))
        (diagonal1 (list (at-position 0 0 board)
                         (at-position 1 1 board)
                         (at-position 2 2 board)))
        (diagonal2 (list (at-position 0 2 board)
                         (at-position 1 1 board)
                         (at-position 2 0 board))))
    (member t (mapcar (all-equal-to current-symbol) (cons diagonal1 (cons diagonal2 (append columns rows)))))))

(defun drewp (board)
  (and (not (wonp 'O board))
       (not (wonp 'X board))
       (every #'(lambda (row)
                  (not (member nil row)))
              board)))

(defun all-equal-to (current-symbol)
  (lambda (row)
    (every #'(lambda (v) (equal v current-symbol))
           row)))

(defun circular (items)
  (setf (cdr (last items)) items)
  items)

(defun human-choose (board symbol scheduler)
  ;; pass to event handler
  nil)

(defun noughts-and-crosses (&key (players (list #'cpu-choose #'human-choose)))
  (with-ltk ()
    (let ((board (create-board))
          (buttons (make-array '(3 3) :initial-element nil))
          (scheduler-resume nil))
      (labels ((scheduler (board players symbols)
                 (let ((current-symbol (car symbols))
                       (current-player (car players)))
                   (setf scheduler-resume
                         #'(lambda (i j)
                             (if (illegal-choice i j board)
                                 (scheduler board players symbols)
                                 (progn
                                   (setf board (set-at-position i j board current-symbol))
                                   (setf (text (aref buttons i j)) (string current-symbol))
                                   (cond ((wonp current-symbol board)
                                          (do-msg (format nil "~A won!" current-symbol))
                                          (return-from noughts-and-crosses))
                                         ((drewp board)
                                          (do-msg "Draw!")
                                          (return-from noughts-and-crosses))
                                         (t (scheduler board (cdr players) (cdr symbols))))))))
                   (funcall current-player board current-symbol scheduler-resume))))
        (loop for i from 0 to 2 do
              (loop for j from 0 to 2 do
                    (let ((i i)
                          (j j))
                      (setf (aref buttons i j) (make-instance 'button :text ""
                                                                      :command #'(lambda () (funcall scheduler-resume i j))))
                      (grid (aref buttons i j) i j))))
        (scheduler board
                   (circular players)
                   (circular '(X O)))))))
