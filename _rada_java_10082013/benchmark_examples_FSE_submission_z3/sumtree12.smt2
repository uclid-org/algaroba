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

(declare-fun v () Real)
(declare-fun l () RealTree)
(declare-fun r () RealTree)

(declare-fun v1 () Real)
(declare-fun rt1 () RealTree)
(declare-fun rt2 () RealTree)
(declare-fun rt3 () RealTree)
(declare-fun rt () RealTree)

(define-fun-rec SumTree ((foo RealTree)) Real 
	(ite 
		(is-Leaf foo) 
		0.0
		(+ (SumTree (left foo)) (SumTree (right foo))) ;there was a constant e here for some reason that I got rid of
		))

; unsatifiable: 
;(assert (= rt (Node (Node Leaf 2.0 Leaf) 1.0 Leaf)))
;(assert (not (and (not (is-Leaf rt))
;                  (is-Node rt)
;                  (= (elem rt) 1)
;                  (= (elem (left rt)) 2.0)
;                  (= (right rt) Leaf))))

; unsatifiable: 
;(assert (= rt2 Leaf))
;(assert (= rt1 (Node rt2 5.0 Leaf)))
;(assert (= rt3 (Node rt1 5.0 Leaf)))
;(assert (not (and (= (elem rt1) (elem rt3))
;                  (is-Node rt1)
;                  (= (SumTree rt1) 5.0)
;                  (= (SumTree rt3) 10.0))))

; problem here: return sat while it should be unsat
(assert (= rt (Node (Node Leaf 2.0 Leaf) 1.0 Leaf)))
(assert (not (= (left rt) (Node Leaf 2.0 Leaf))))

(check-sat)
(exit)
