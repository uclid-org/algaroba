; trying with more complicated datatypes

(set-logic ALL)

(declare-datatypes ((MyList 0)) (
    (
      (Nil)
      (Cons (Head Real) (Tail MyList))
    )
))

(declare-const x MyList)
(declare-const y MyList)
(declare-const z MyList)

(assert (= x (Cons 1 (Cons 2 (Tail (Tail (Tail y)))))))
(assert (= x (Cons 1 (Cons 2 (Tail (Tail y))))))
(assert (= x (Cons 1 (Cons 2 (Tail (Tail y))))))

;(assert (= x (Tail (Tail y))))


(check-sat)