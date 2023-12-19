(set-logic QF_UF)
(declare-sort Rec 0)
(declare-sort List 0)
(declare-fun A () Rec)
(declare-fun is-A (Rec) Bool)
(declare-fun Nil () List)
(declare-fun is-Nil (List) Bool)
(declare-fun Cons (Rec List) List)
(declare-fun is-Cons (List) Bool)
(declare-fun Tail (List) List)
(declare-fun Head (List) Rec)
(declare-fun x () List)
(declare-fun y () List)
(declare-fun z () List)
(declare-fun w () List)
(declare-fun contrived_variable1 () List)
(declare-fun contrived_variable0 () List)
(declare-fun contrived_variable2 () List)
(declare-fun contrived_variable6 () List)
(declare-fun contrived_variable7 () Rec)
(declare-fun contrived_variable4 () List)
(declare-fun contrived_variable8 () List)
(declare-fun contrived_variable3 () Rec)
(declare-fun contrived_variable5 () Rec)
(assert (and (is-A A)))
(assert (and (is-Nil Nil) (not (is-Cons Nil))))
(assert (and (is-Cons x) (is-Cons y) (is-Cons z) (is-Cons w)))
(assert (= x contrived_variable0))
(assert (= y contrived_variable1))
(assert (= z contrived_variable2))
(assert
 (and (= (Tail z) contrived_variable1)
  (= (Cons contrived_variable3 contrived_variable4) z)
  (=> (is-Cons z)
   (and (= (Head z) contrived_variable3) (= (Tail z) contrived_variable4)))))
(assert
 (and (= (Tail y) contrived_variable0)
  (= (Cons contrived_variable5 contrived_variable6) y)
  (=> (is-Cons y)
   (and (= (Head y) contrived_variable5) (= (Tail y) contrived_variable6)))))
(assert
 (and (= (Tail w) contrived_variable2)
  (= (Cons contrived_variable7 contrived_variable8) w)
  (=> (is-Cons w)
   (and (= (Head w) contrived_variable7) (= (Tail w) contrived_variable8)))))
(assert (or (= A contrived_variable5)))
(assert (or (= A contrived_variable3)))
(assert (or (= A contrived_variable7)))
(assert
 (or (and (not (is-Nil contrived_variable8)) (is-Cons contrived_variable8))
  (and (is-Nil contrived_variable8) (not (is-Cons contrived_variable8)))))
(assert (=> (is-Nil contrived_variable8) (= contrived_variable8 Nil)))
(assert
 (or (and (not (is-Nil contrived_variable4)) (is-Cons contrived_variable4))
  (and (is-Nil contrived_variable4) (not (is-Cons contrived_variable4)))))
(assert (=> (is-Nil contrived_variable4) (= contrived_variable4 Nil)))
(assert
 (or (and (not (is-Nil contrived_variable6)) (is-Cons contrived_variable6))
  (and (is-Nil contrived_variable6) (not (is-Cons contrived_variable6)))))
(assert (=> (is-Nil contrived_variable6) (= contrived_variable6 Nil)))
(assert
 (or (and (not (is-Nil contrived_variable2)) (is-Cons contrived_variable2))
  (and (is-Nil contrived_variable2) (not (is-Cons contrived_variable2)))))
(assert (=> (is-Nil contrived_variable2) (= contrived_variable2 Nil)))
(assert
 (or (and (not (is-Nil contrived_variable0)) (is-Cons contrived_variable0))
  (and (is-Nil contrived_variable0) (not (is-Cons contrived_variable0)))))
(assert (=> (is-Nil contrived_variable0) (= contrived_variable0 Nil)))
(assert
 (or (and (not (is-Nil contrived_variable1)) (is-Cons contrived_variable1))
  (and (is-Nil contrived_variable1) (not (is-Cons contrived_variable1)))))
(assert (=> (is-Nil contrived_variable1) (= contrived_variable1 Nil)))
(assert
 (or (and (not (is-Nil w)) (is-Cons w)) (and (is-Nil w) (not (is-Cons w)))))
(assert (=> (is-Nil w) (= w Nil)))
(assert
 (or (and (not (is-Nil z)) (is-Cons z)) (and (is-Nil z) (not (is-Cons z)))))
(assert (=> (is-Nil z) (= z Nil)))
(assert
 (or (and (not (is-Nil y)) (is-Cons y)) (and (is-Nil y) (not (is-Cons y)))))
(assert (=> (is-Nil y) (= y Nil)))
(assert
 (or (and (not (is-Nil x)) (is-Cons x)) (and (is-Nil x) (not (is-Cons x)))))
(assert (=> (is-Nil x) (= x Nil)))
(assert (=> (and (is-Cons y)) (not (= (Tail y) y))))
(assert (=> (and (is-Cons (Tail y)) (is-Cons y)) (not (= (Tail (Tail y)) y))))
(assert
 (=> (and (is-Cons (Tail (Tail y))) (is-Cons (Tail y)) (is-Cons y))
  (not (= (Tail (Tail (Tail y))) y))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail y)))) (is-Cons (Tail (Tail y)))
   (is-Cons (Tail y)) (is-Cons y))
  (not (= (Tail (Tail (Tail (Tail y)))) y))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail y)))))
   (is-Cons (Tail (Tail (Tail y)))) (is-Cons (Tail (Tail y)))
   (is-Cons (Tail y)) (is-Cons y))
  (not (= (Tail (Tail (Tail (Tail (Tail y))))) y))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail y))))))
   (is-Cons (Tail (Tail (Tail (Tail y))))) (is-Cons (Tail (Tail (Tail y))))
   (is-Cons (Tail (Tail y))) (is-Cons (Tail y)) (is-Cons y))
  (not (= (Tail (Tail (Tail (Tail (Tail (Tail y)))))) y))))
(assert (=> (and (is-Cons z)) (not (= (Tail z) z))))
(assert (=> (and (is-Cons (Tail z)) (is-Cons z)) (not (= (Tail (Tail z)) z))))
(assert
 (=> (and (is-Cons (Tail (Tail z))) (is-Cons (Tail z)) (is-Cons z))
  (not (= (Tail (Tail (Tail z))) z))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail z)))) (is-Cons (Tail (Tail z)))
   (is-Cons (Tail z)) (is-Cons z))
  (not (= (Tail (Tail (Tail (Tail z)))) z))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail z)))))
   (is-Cons (Tail (Tail (Tail z)))) (is-Cons (Tail (Tail z)))
   (is-Cons (Tail z)) (is-Cons z))
  (not (= (Tail (Tail (Tail (Tail (Tail z))))) z))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail z))))))
   (is-Cons (Tail (Tail (Tail (Tail z))))) (is-Cons (Tail (Tail (Tail z))))
   (is-Cons (Tail (Tail z))) (is-Cons (Tail z)) (is-Cons z))
  (not (= (Tail (Tail (Tail (Tail (Tail (Tail z)))))) z))))
(assert (=> (and (is-Cons w)) (not (= (Tail w) w))))
(assert (=> (and (is-Cons (Tail w)) (is-Cons w)) (not (= (Tail (Tail w)) w))))
(assert
 (=> (and (is-Cons (Tail (Tail w))) (is-Cons (Tail w)) (is-Cons w))
  (not (= (Tail (Tail (Tail w))) w))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail w)))) (is-Cons (Tail (Tail w)))
   (is-Cons (Tail w)) (is-Cons w))
  (not (= (Tail (Tail (Tail (Tail w)))) w))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail w)))))
   (is-Cons (Tail (Tail (Tail w)))) (is-Cons (Tail (Tail w)))
   (is-Cons (Tail w)) (is-Cons w))
  (not (= (Tail (Tail (Tail (Tail (Tail w))))) w))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail w))))))
   (is-Cons (Tail (Tail (Tail (Tail w))))) (is-Cons (Tail (Tail (Tail w))))
   (is-Cons (Tail (Tail w))) (is-Cons (Tail w)) (is-Cons w))
  (not (= (Tail (Tail (Tail (Tail (Tail (Tail w)))))) w))))
(assert
 (=> (and (is-Cons contrived_variable0))
  (not (= (Tail contrived_variable0) contrived_variable0))))
(assert
 (=> (and (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not (= (Tail (Tail contrived_variable0)) contrived_variable0))))
(assert
 (=>
  (and (is-Cons (Tail (Tail contrived_variable0)))
   (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not (= (Tail (Tail (Tail contrived_variable0))) contrived_variable0))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail contrived_variable0))))
   (is-Cons (Tail (Tail contrived_variable0)))
   (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not
   (= (Tail (Tail (Tail (Tail contrived_variable0)))) contrived_variable0))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail contrived_variable0)))))
   (is-Cons (Tail (Tail (Tail contrived_variable0))))
   (is-Cons (Tail (Tail contrived_variable0)))
   (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not
   (= (Tail (Tail (Tail (Tail (Tail contrived_variable0)))))
    contrived_variable0))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail contrived_variable0))))))
   (is-Cons (Tail (Tail (Tail (Tail contrived_variable0)))))
   (is-Cons (Tail (Tail (Tail contrived_variable0))))
   (is-Cons (Tail (Tail contrived_variable0)))
   (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not
   (= (Tail (Tail (Tail (Tail (Tail (Tail contrived_variable0))))))
    contrived_variable0))))
(assert
 (=> (and (is-Cons contrived_variable1))
  (not (= (Tail contrived_variable1) contrived_variable1))))
(assert
 (=> (and (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not (= (Tail (Tail contrived_variable1)) contrived_variable1))))
(assert
 (=>
  (and (is-Cons (Tail (Tail contrived_variable1)))
   (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not (= (Tail (Tail (Tail contrived_variable1))) contrived_variable1))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail contrived_variable1))))
   (is-Cons (Tail (Tail contrived_variable1)))
   (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not
   (= (Tail (Tail (Tail (Tail contrived_variable1)))) contrived_variable1))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail contrived_variable1)))))
   (is-Cons (Tail (Tail (Tail contrived_variable1))))
   (is-Cons (Tail (Tail contrived_variable1)))
   (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not
   (= (Tail (Tail (Tail (Tail (Tail contrived_variable1)))))
    contrived_variable1))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail contrived_variable1))))))
   (is-Cons (Tail (Tail (Tail (Tail contrived_variable1)))))
   (is-Cons (Tail (Tail (Tail contrived_variable1))))
   (is-Cons (Tail (Tail contrived_variable1)))
   (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not
   (= (Tail (Tail (Tail (Tail (Tail (Tail contrived_variable1))))))
    contrived_variable1))))
(assert
 (=> (and (is-Cons contrived_variable2))
  (not (= (Tail contrived_variable2) contrived_variable2))))
(assert
 (=> (and (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not (= (Tail (Tail contrived_variable2)) contrived_variable2))))
(assert
 (=>
  (and (is-Cons (Tail (Tail contrived_variable2)))
   (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not (= (Tail (Tail (Tail contrived_variable2))) contrived_variable2))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail contrived_variable2))))
   (is-Cons (Tail (Tail contrived_variable2)))
   (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not
   (= (Tail (Tail (Tail (Tail contrived_variable2)))) contrived_variable2))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail contrived_variable2)))))
   (is-Cons (Tail (Tail (Tail contrived_variable2))))
   (is-Cons (Tail (Tail contrived_variable2)))
   (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not
   (= (Tail (Tail (Tail (Tail (Tail contrived_variable2)))))
    contrived_variable2))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail contrived_variable2))))))
   (is-Cons (Tail (Tail (Tail (Tail contrived_variable2)))))
   (is-Cons (Tail (Tail (Tail contrived_variable2))))
   (is-Cons (Tail (Tail contrived_variable2)))
   (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not
   (= (Tail (Tail (Tail (Tail (Tail (Tail contrived_variable2))))))
    contrived_variable2))))
(check-sat)
(assert (=> (and (is-Cons y)) (not (= (Tail y) y))))
(assert (=> (and (is-Cons (Tail y)) (is-Cons y)) (not (= (Tail (Tail y)) y))))
(assert
 (=> (and (is-Cons (Tail (Tail y))) (is-Cons (Tail y)) (is-Cons y))
  (not (= (Tail (Tail (Tail y))) y))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail y)))) (is-Cons (Tail (Tail y)))
   (is-Cons (Tail y)) (is-Cons y))
  (not (= (Tail (Tail (Tail (Tail y)))) y))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail y)))))
   (is-Cons (Tail (Tail (Tail y)))) (is-Cons (Tail (Tail y)))
   (is-Cons (Tail y)) (is-Cons y))
  (not (= (Tail (Tail (Tail (Tail (Tail y))))) y))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail y))))))
   (is-Cons (Tail (Tail (Tail (Tail y))))) (is-Cons (Tail (Tail (Tail y))))
   (is-Cons (Tail (Tail y))) (is-Cons (Tail y)) (is-Cons y))
  (not (= (Tail (Tail (Tail (Tail (Tail (Tail y)))))) y))))
(assert (=> (and (is-Cons z)) (not (= (Tail z) z))))
(assert (=> (and (is-Cons (Tail z)) (is-Cons z)) (not (= (Tail (Tail z)) z))))
(assert
 (=> (and (is-Cons (Tail (Tail z))) (is-Cons (Tail z)) (is-Cons z))
  (not (= (Tail (Tail (Tail z))) z))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail z)))) (is-Cons (Tail (Tail z)))
   (is-Cons (Tail z)) (is-Cons z))
  (not (= (Tail (Tail (Tail (Tail z)))) z))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail z)))))
   (is-Cons (Tail (Tail (Tail z)))) (is-Cons (Tail (Tail z)))
   (is-Cons (Tail z)) (is-Cons z))
  (not (= (Tail (Tail (Tail (Tail (Tail z))))) z))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail z))))))
   (is-Cons (Tail (Tail (Tail (Tail z))))) (is-Cons (Tail (Tail (Tail z))))
   (is-Cons (Tail (Tail z))) (is-Cons (Tail z)) (is-Cons z))
  (not (= (Tail (Tail (Tail (Tail (Tail (Tail z)))))) z))))
(assert (=> (and (is-Cons w)) (not (= (Tail w) w))))
(assert (=> (and (is-Cons (Tail w)) (is-Cons w)) (not (= (Tail (Tail w)) w))))
(assert
 (=> (and (is-Cons (Tail (Tail w))) (is-Cons (Tail w)) (is-Cons w))
  (not (= (Tail (Tail (Tail w))) w))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail w)))) (is-Cons (Tail (Tail w)))
   (is-Cons (Tail w)) (is-Cons w))
  (not (= (Tail (Tail (Tail (Tail w)))) w))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail w)))))
   (is-Cons (Tail (Tail (Tail w)))) (is-Cons (Tail (Tail w)))
   (is-Cons (Tail w)) (is-Cons w))
  (not (= (Tail (Tail (Tail (Tail (Tail w))))) w))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail w))))))
   (is-Cons (Tail (Tail (Tail (Tail w))))) (is-Cons (Tail (Tail (Tail w))))
   (is-Cons (Tail (Tail w))) (is-Cons (Tail w)) (is-Cons w))
  (not (= (Tail (Tail (Tail (Tail (Tail (Tail w)))))) w))))
(assert
 (=> (and (is-Cons contrived_variable0))
  (not (= (Tail contrived_variable0) contrived_variable0))))
(assert
 (=> (and (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not (= (Tail (Tail contrived_variable0)) contrived_variable0))))
(assert
 (=>
  (and (is-Cons (Tail (Tail contrived_variable0)))
   (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not (= (Tail (Tail (Tail contrived_variable0))) contrived_variable0))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail contrived_variable0))))
   (is-Cons (Tail (Tail contrived_variable0)))
   (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not
   (= (Tail (Tail (Tail (Tail contrived_variable0)))) contrived_variable0))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail contrived_variable0)))))
   (is-Cons (Tail (Tail (Tail contrived_variable0))))
   (is-Cons (Tail (Tail contrived_variable0)))
   (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not
   (= (Tail (Tail (Tail (Tail (Tail contrived_variable0)))))
    contrived_variable0))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail contrived_variable0))))))
   (is-Cons (Tail (Tail (Tail (Tail contrived_variable0)))))
   (is-Cons (Tail (Tail (Tail contrived_variable0))))
   (is-Cons (Tail (Tail contrived_variable0)))
   (is-Cons (Tail contrived_variable0)) (is-Cons contrived_variable0))
  (not
   (= (Tail (Tail (Tail (Tail (Tail (Tail contrived_variable0))))))
    contrived_variable0))))
(assert
 (=> (and (is-Cons contrived_variable1))
  (not (= (Tail contrived_variable1) contrived_variable1))))
(assert
 (=> (and (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not (= (Tail (Tail contrived_variable1)) contrived_variable1))))
(assert
 (=>
  (and (is-Cons (Tail (Tail contrived_variable1)))
   (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not (= (Tail (Tail (Tail contrived_variable1))) contrived_variable1))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail contrived_variable1))))
   (is-Cons (Tail (Tail contrived_variable1)))
   (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not
   (= (Tail (Tail (Tail (Tail contrived_variable1)))) contrived_variable1))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail contrived_variable1)))))
   (is-Cons (Tail (Tail (Tail contrived_variable1))))
   (is-Cons (Tail (Tail contrived_variable1)))
   (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not
   (= (Tail (Tail (Tail (Tail (Tail contrived_variable1)))))
    contrived_variable1))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail contrived_variable1))))))
   (is-Cons (Tail (Tail (Tail (Tail contrived_variable1)))))
   (is-Cons (Tail (Tail (Tail contrived_variable1))))
   (is-Cons (Tail (Tail contrived_variable1)))
   (is-Cons (Tail contrived_variable1)) (is-Cons contrived_variable1))
  (not
   (= (Tail (Tail (Tail (Tail (Tail (Tail contrived_variable1))))))
    contrived_variable1))))
(assert
 (=> (and (is-Cons contrived_variable2))
  (not (= (Tail contrived_variable2) contrived_variable2))))
(assert
 (=> (and (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not (= (Tail (Tail contrived_variable2)) contrived_variable2))))
(assert
 (=>
  (and (is-Cons (Tail (Tail contrived_variable2)))
   (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not (= (Tail (Tail (Tail contrived_variable2))) contrived_variable2))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail contrived_variable2))))
   (is-Cons (Tail (Tail contrived_variable2)))
   (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not
   (= (Tail (Tail (Tail (Tail contrived_variable2)))) contrived_variable2))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail contrived_variable2)))))
   (is-Cons (Tail (Tail (Tail contrived_variable2))))
   (is-Cons (Tail (Tail contrived_variable2)))
   (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not
   (= (Tail (Tail (Tail (Tail (Tail contrived_variable2)))))
    contrived_variable2))))
(assert
 (=>
  (and (is-Cons (Tail (Tail (Tail (Tail (Tail contrived_variable2))))))
   (is-Cons (Tail (Tail (Tail (Tail contrived_variable2)))))
   (is-Cons (Tail (Tail (Tail contrived_variable2))))
   (is-Cons (Tail (Tail contrived_variable2)))
   (is-Cons (Tail contrived_variable2)) (is-Cons contrived_variable2))
  (not
   (= (Tail (Tail (Tail (Tail (Tail (Tail contrived_variable2))))))
    contrived_variable2))))
(check-sat)
(get-model)