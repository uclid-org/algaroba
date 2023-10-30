(set-logic ALL)
(set-info :source | SMT-COMP'06 organizers |)
(set-info :smt-lib-version 2.0)
(set-info :category "check")
(set-info :status unsat)

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
(declare-fun l1 () RealTree)
(declare-fun l2 () RealTree)
(declare-fun l3 () RealTree)


; unsatifiable: l1 and l3 must have the same element
(assert (= l2 Leaf))
(assert (= l1 (Node l2 5.0 Leaf)))
(assert (= l3 (Node l1 5.0 Leaf)))
(assert (and
          (not (= (elem l1) (elem l3)))
          (is-Node l1)
          (= (SumTree l1) 5.0)))
(check-sat)
(exit)