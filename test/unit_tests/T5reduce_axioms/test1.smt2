(set-logic ALL)

(declare-datatypes ((MyList 0)) (((Nil) (Cons (Head Real) (Tail MyList)) (Sons (Sead Real) (Sail MyList)))))

(declare-const x MyList)
(declare-const y MyList)
(assert (= x (Cons 1 y)))