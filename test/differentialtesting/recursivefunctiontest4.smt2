(set-logic ALL)

(declare-datatypes ((nat 0) (enum 0) (bool_adt 0) (list 0)) (((succ (pred nat)) (zero)) ((A)) ((t) (f))
((cons (car enum) (cdr list)) (null))
))
(declare-fun x () nat)
(declare-fun y () nat)
(declare-fun z () nat)

;(declare-fun n () nat)
;(declare-fun m () nat)
;(assert (= n (pred m)))

(define-fun-rec greater_than_eq ((x nat) (y nat)) bool_adt (
  match y (
    (zero t)
    ((succ tail1) 
      (match x (
        (zero f)
        ((succ tail2) (greater_than_eq tail1 tail2))
      )))
  )
))

(declare-fun size_x () nat)
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