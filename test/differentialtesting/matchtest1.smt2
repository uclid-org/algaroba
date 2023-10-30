(set-logic ALL)


(declare-datatypes ((Rec 0) (List 0)) (((A)) ((Nil) (Cons (Head Rec) (Tail List)))))

(declare-fun x () List)
(define-fun y () List 
    (match x (
        (Nil (Cons A Nil))
        ((Cons h t) x))))

(assert (is-Nil y))
(assert (= y y))
(check-sat)