; testing let statements where the variables are defined outised

(declare-const x Int)
(define-fun y () Int 5)
(define-fun z () Int 6)
(assert (> y x))

(assert 
  (let ((x 2)
        (y 3))
    (= (+ x y) 5))
)

(check-sat)