; trying with more complicated datatypes

(set-logic ALL)

(declare-datatypes ((MyList 0)) (
    (
      (Nil)
      (Cons (Head Real) (Tail MyList))
    )
))

(declare-datatypes ((MyTree 0)) (
    (
      (Leaf (Value MyList))
      (Node (Left MyTree) (Right MyTree))
    )
))

(declare-const x MyList)
(declare-const y MyTree)
(declare-const z MyTree)


(check-sat)