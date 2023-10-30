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

(declare-fun e () Real)
(declare-fun l () RealTree)
(declare-fun r () RealTree)

(define-fun-rec SumTree ((foo RealTree)) Real 
	(ite 
		(is-Leaf foo) 
		0.0
		(+ (SumTree (left foo)) e (SumTree (right foo)))
		))

(declare-fun v1 () Real)
(declare-fun l2 () RealTree)


;; satisfiable: a leaf cannot have an element
(assert (= l2 Leaf))
(assert (= (elem l2) e))
(check-sat)
(exit)