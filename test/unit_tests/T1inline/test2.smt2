; testing flattening non-constant functions

(declare-const x Int)
(define-fun y () Int 5)
(define-fun z () Int 6)
(assert (> y x))

(define-fun square ((n Int)) Int
    (* n n))

(assert (= 3 (square y)))

(assert (> (square x) z))