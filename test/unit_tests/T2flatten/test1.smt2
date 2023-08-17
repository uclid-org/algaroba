; testing a very simple flattenning

(declare-const x Int)
;(declare-const y Int)
(declare-const z Int)
(define-fun y () Int 5)


(assert (> x (+ y z)))

(check-sat)