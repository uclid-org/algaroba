; testing the reduction of ITE statements to logic

(declare-const x Real)
(declare-const y Real)
(declare-const z Real)
(declare-fun f (Real Real) Real)
(declare-fun g (Real) Real)

(assert (> x (ite (< z (f y y)) y z)))

(check-sat)