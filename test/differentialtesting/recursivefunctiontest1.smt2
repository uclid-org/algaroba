(set-logic ALL)

(declare-datatypes ((nat 0)(list 0)) (((succ (pred nat)) (zero))
((cons (car nat) (cdr list)) (null))
))
(declare-fun x () list)
(declare-fun y () list)

;(declare-fun n () nat)
;(declare-fun m () nat)
;(assert (= n (pred m)))

(define-fun-rec size ((x list)) nat (
  match x (
    (null zero)
    ((cons h t) (succ (size t)))
  )
))


(assert (= x (cons zero null)))
;(assert (= y null))
(assert (= y (cons (succ zero) null)))


(assert (= (size x) (size y)))

(check-sat)