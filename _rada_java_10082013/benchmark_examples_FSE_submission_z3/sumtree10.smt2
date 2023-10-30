(set-logic ALL)
(set-info :source | SMT-COMP'06 organizers |)
(set-info :smt-lib-version 2.0)
(set-info :category "check")
(set-info :status sat)
(declare-fun x1 () Bool)
(declare-fun x2 () Real)
(declare-fun x3 () Real)
(declare-fun x4 () Bool)
(declare-fun x5 () Real)
(declare-fun x6 () Real)
(declare-fun x7 () Real)
(declare-fun x8 () Real)

(declare-fun bo1 () Bool)
(declare-fun bo2 () Bool)
(declare-fun bo3 () Bool)

(declare-fun r1 () Real)
(declare-fun r2 () Real)
(declare-fun r3 () Real)


(define-fun myBoolIte ((a Real) (b Bool) (c Bool)) Bool
  (ite (> a 0.0)
       b
       c))

(define-fun myRealIte ((a1 Bool) (b1 Real) (c1 Real)) Real
  (ite a1
       b1
       c1))

(declare-fun f (Real Bool) Real)
(declare-fun fRealRealReal (Real Real) Real)
(declare-fun fRealReal (Real) Real)
(declare-fun fReal () Real)

;(assert (myBoolIte 1 true false))

;Test PLUS
;After rewriting ites:
;[(or (and x1 (or (and x4 (= (+ x2 x5) 4)) 
;                 (and (not x4) (= (+ x2 x6) 4)))) 
;     (and (not x1) (or (and x4 (= (+ x3 x5) 4)) 
;                       (and (not x4) (= (+ x3 x6) 4)))))]
;(assert (= (+ (myRealIte x1 x2 x3) (myRealIte x4 x5 x6)) 4) ) ; TEST PLUS

;(assert (= (+ (myRealIte x1 (myRealIte x1 x2 x3) x3) (myRealIte x4 x5 (myRealIte x4 x5 x6))) 4) ) ; TEST PLUS2


;Test MINUS
;After rewriting ites:
;[(or (and x1 (or (and x4 (= (+ x2 (* (- 1) x5)) 4)) 
;                 (and (not x4) (= (+ x2 (* (- 1) x6)) 4)))) 
;     (and (not x1) (or (and x4 (= (+ x3 (* (- 1) x5)) 4)) 
;                       (and (not x4) (= (+ x3 (* (- 1) x6)) 4)))))]
;(assert (= (- (myRealIte x1 x2 x3) (myRealIte x4 x5 x6)) 4) )

;(assert (= 4 (- (myRealIte x1 x2 x3) (myRealIte x4 x5 x6))) )

;(assert (= 4 (+ x2 x3 x5 x6 x7 x8)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;TEST SYMB
;(assert (= 4 (f (myRealIte x1 x2 x3) (myBoolIte r1 bo1 bo2))))
;(assert (= 4 (fRealRealReal (myRealIte x1 x2 x3) (myRealIte x4 x5 x6))))
;(assert (= 4 (fRealReal (myRealIte x1 x2 x3))))
(assert (= 4.0 (+ fReal (myRealIte x1 x2 x3))))

(check-sat)
(exit)
