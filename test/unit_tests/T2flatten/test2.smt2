; testing a more comlicated flattenning with user definined functions and compound expressions

(declare-const x Real)
;(declare-const y Real)
(declare-const z Real)
(declare-fun f (Real Real) Real)
(define-fun y () Real 5)

(assert (> x (+ (f (f y x) y) z)))

(check-sat)