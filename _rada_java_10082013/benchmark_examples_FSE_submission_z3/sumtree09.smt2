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

(define-fun MySumTree ((rtree RealTree)) Real
  (ite (is-Leaf rtree) 
       0.0
       (SumTree rtree)))

(declare-fun v1 () Real)
(declare-fun l1 () RealTree)
(declare-fun l2 () RealTree)

; unsatisfiable
(assert (= l1 (Node Leaf 5.0 Leaf)))
(assert (= (SumTree l1) 5.0))
(assert (not (= (MySumTree l1) 5.0)))
(assert (= (MySumTree l1) (SumTree l1)))
(assert (= (MySumTree Leaf) 0.0))
(check-sat)
(exit)
