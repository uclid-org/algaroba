(set-logic ALL)
(declare-sort MyList 0)
(declare-fun Nil () MyList)
(declare-fun is-Nil (MyList) Bool)
(declare-fun Cons (Real MyList) MyList)
(declare-fun is-Cons (MyList) Bool)
(declare-fun Head (MyList) Real)
(declare-fun Tail (MyList) MyList)
(declare-fun x () MyList)
(declare-fun y () MyList)
(assert
 (or (and (is-Nil y) (not (is-Cons y))) (and (not (is-Nil y)) (is-Cons y))))
(assert
 (or (and (is-Nil x) (not (is-Cons x))) (and (not (is-Nil x)) (is-Cons x))))
(assert
 (or (and (is-Nil Nil) (not (is-Cons Nil)))
  (and (not (is-Nil Nil)) (is-Cons Nil))))
(assert (not (= (Tail y) y)))
(assert (not (= (Tail (Tail y)) (Tail y))))
(assert (not (= (Tail (Tail y)) y)))
(assert (not (= (Tail (Tail (Tail y))) (Tail (Tail y)))))
(assert (not (= (Tail (Tail (Tail y))) (Tail y))))
(assert (not (= (Tail (Tail (Tail y))) y)))
(assert (not (= (Tail x) x)))
(assert (not (= (Tail (Tail x)) (Tail x))))
(assert (not (= (Tail (Tail x)) x)))
(assert (not (= (Tail (Tail (Tail x))) (Tail (Tail x)))))
(assert (not (= (Tail (Tail (Tail x))) (Tail x))))
(assert (not (= (Tail (Tail (Tail x))) x)))
(assert (not (= (Tail Nil) Nil)))
(assert (not (= (Tail (Tail Nil)) (Tail Nil))))
(assert (not (= (Tail (Tail Nil)) Nil)))
(assert (not (= (Tail (Tail (Tail Nil))) (Tail (Tail Nil)))))
(assert (not (= (Tail (Tail (Tail Nil))) (Tail Nil))))
(assert (not (= (Tail (Tail (Tail Nil))) Nil)))
(check-sat)