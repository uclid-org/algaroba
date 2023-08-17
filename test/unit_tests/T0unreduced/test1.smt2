; using this to test the Z3 interface


(declare-sort A 0)
(declare-sort B 0)
(declare-const x A)
(declare-const y A)
(declare-const z B)
(declare-fun f (A) B)

(assert (= (f x) z))
(assert (not (= (f y) z)))
(assert (= x y))

