; testing reduction with no ADTs. It should not do anything

(declare-const x Real)
(define-fun y () Real 5)
(define-fun z () Real 6)
(declare-fun f (Real) Bool)

(assert (=> (not (and (f (f x)) (> y x))) (not (= x y))))
(assert (not (=> (> y x) (not (= x y)))))

(check-sat)