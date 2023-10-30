(set-logic ALL)
(set-info :source | SMT-COMP'06 organizers |)
(set-info :smt-lib-version 2.0)
(set-info :category "check")
(set-info :status sat)

(declare-datatypes () (
  ( RealTree 
      ( Node 
	      (left RealTree) 
		  (elem Real) 
		  (right RealTree)) 
	  (Leaf)
  )
))

(define-fun-rec SumTree ((foo RealTree)) Real 
	(ite 
		(is-Leaf foo) 
		0.0
		(+ (SumTree (left foo)) (elem foo) (SumTree (right foo)))
		))


(declare-fun v1 () Real)
(declare-fun l1 () RealTree)
(declare-fun num2 () Real)

(define-fun five () Real (+ 4.0 1.0))

(define-fun add0 ((add0_1 Real)) Real
	add0_1)

(define-fun add2 ((add2_1 Real)) Real
	(+ (add0 add2_1) (add0 2.0)))

(define-fun add ((add_1 Real) (add_2 Real)) Real
	(+ (add0 add_1) (- (add2 (add2 (add2 add_2))) 6.0)))

; satisfiable: (SumTree l1) = 5.0 and (add (add 2 0) (add2 1) = 5.0
(assert (= l1 (Node Leaf 5.0 Leaf)))
(assert (= (SumTree l1) (add (add 2.0 0.0) (add2 1.0))))
(check-sat)
(exit)
