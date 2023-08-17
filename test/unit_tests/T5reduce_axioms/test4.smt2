; an example of a mutually recursive datatype that has a cyclicality issue
; should return unsat

(set-logic ALL)

(declare-datatypes (
  (MyList 0)
  (MyTree 0)
) (
  (
      (Nil)
      (Cons (Head MyTree) (Tail MyList))
    )
    (
      (Leaf)
      (Node (Value MyList) (Left MyTree) (Right MyTree))
    )
))



(declare-const x MyList)
(declare-const y MyTree)
(declare-const z MyTree)

(assert (= (Value y) x))
(assert (= (Head x) y))
(assert (= z (Head x)))

(assert (not (is-Nil x)))
(assert (not (is-Leaf y)))

(check-sat)
(get-model)