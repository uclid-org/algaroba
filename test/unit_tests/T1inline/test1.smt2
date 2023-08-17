; only testing constant functions

(declare-const x Int)
(define-fun y () Int 5)
(define-fun z () Int 6)
(assert (> y x))

(assert (> x (+ z z)))