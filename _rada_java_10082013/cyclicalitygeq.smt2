(set-logic ALL)

(declare-datatypes () ((nat (succ (pred nat)) (zero))))
(declare-datatypes () ((enum (A) (B))))
(declare-datatypes () ((bool_adt (t) (f))))
(declare-datatypes () ((list (cons (car enum) (cdr list)) (null))))

(declare-fun x () nat)
(declare-fun y () nat)
(declare-fun z () nat)

;(declare-fun n () nat)
;(declare-fun m () nat)
;(assert (= n (pred m)))

(define-catamorphism greater_than_eq ((x nat) (y nat)) bool_adt 
  (ite (is-zero y) t (ite (is-zero x) f (greater_than_eq (pred y) (pred x)))))


;(assert (= size_x (size x)))
(assert (= (greater_than_eq x y) t))
(assert (= (greater_than_eq y z) t))
(assert (= (greater_than_eq z x) t))
(assert (not (= x y)))
(assert (not (= y z)))
(assert (not (= x z)))

;(assert (= (size z) (succ (size x))))
;(assert (and (is-cons x) (is-cons y)))

;(assert (= y null))
;(assert (= y (cons (succ zero) null)))


;(assert (= (size x) (size y)))

(check-sat)