; testing let statements

(declare-const x Int)
(define-fun y () Int 5)
(define-fun z () Int 6)
(assert (> y x))

(assert 
  (let ((a 5)
        (b 3))
    (= (+ a b) 8))
)

(check-sat)
