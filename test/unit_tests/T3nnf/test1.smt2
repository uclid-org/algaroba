(declare-const x Int)
(define-fun y () Int 5)
(define-fun z () Int 6)


(assert (not (> y x)))
(assert (not (and (> y x) (> x y))))
(assert (not (or (> y x) (> x y))))
(assert (not (or (and (> y x) (> x y)) (> 4 7))))

(check-sat)
