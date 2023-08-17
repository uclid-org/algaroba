; basic query with ADTs

(set-logic ALL)

; incorrect ways to declare datatypes (smt_utils won't parse these even though z3 will)
;(declare-datatypes () ((Tree leaf (node (left Tree) (right Tree)))))
;(declare-datatype MyList ((Nil) (Cons (head Int) (tail MyList)) ))

(declare-datatypes ((MyList 0)) (((Nil) (Sil) (Cons (Head Real) (Tail MyList)))))

(declare-const x MyList)
(declare-const y MyList)

(assert (= x (Cons 1 Nil)))
(assert (and (= y (Tail (Tail x))) (is-Nil x)))
(assert (is-Cons x))

(check-sat)