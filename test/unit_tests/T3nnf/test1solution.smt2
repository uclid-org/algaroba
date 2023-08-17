; Tessting Not, Or, And, Implies

(declare-fun x () Int)
(define-fun y () Int 5)
(define-fun z () Int 6)
(assert (not (> y x)))
(assert (or (not (> y x)) (not (> x y))))
(assert (and (not (> y x)) (not (> x y))))
(assert (and (or (not (> y x)) (not (> x y))) (not (> 4 7))))
(check-sat)