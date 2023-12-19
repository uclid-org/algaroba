(set-logic ALL)

(declare-datatypes () ((nat 0) (enum 0) (list 0)) (((succ (pred nat)) (zero)) ((A) (B))
((cons (car enum) (cdr list)) (null))
))
(declare-fun x () list)
(declare-fun y () list)
;(declare-fun z () list)

;(declare-fun n () nat)
;(declare-fun m () nat)
;(assert (= n (pred m)))

(define-catamorphism size ((x list)) nat (
  (ite (is-null x)  (null zero) ((cons h t) (succ (size t))))
  )
)

;(declare-fun size_x () nat)
;(assert (= size_x (size x)))
(assert (= (size x) (succ (size y))))
(assert (= (size y) (succ (size x))))
;(assert (= (size z) (succ (size x))))
;(assert (and (is-cons x) (is-cons y)))

;(assert (= y null))
;(assert (= y (cons (succ zero) null)))


;(assert (= (size x) (size y)))

(check-sat)