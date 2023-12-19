(set-logic ALL)


(declare-datatypes ((Rec 0) (List 0)) (((A)) ((Nil) (Cons (Head Rec) (Tail List)))))

(declare-fun x () List)
(declare-fun y () List)
(declare-fun z () List)
(declare-fun w () List)

(assert (and (is-Cons x) (is-Cons y) (is-Cons z) (is-Cons w)))

(assert (= x (Tail y)))
(assert (= y (Tail z)))
(assert (= z (Tail w)))
(assert (= w (Tail x)))

(check-sat)