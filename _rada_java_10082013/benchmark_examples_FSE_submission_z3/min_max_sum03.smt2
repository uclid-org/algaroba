;(set-option :produce-models true)
(set-logic ALL)

(declare-datatypes () (
  ( RealAndNone
    ( RealNum (val Real))
    ( None))))

(declare-datatypes () (
  ( RealTree
    ( Node
      (left RealTree)
      (elem Real)
      (right RealTree))
    (Leaf))))

; SumTree catamorphism
(define-fun-rec SumTree ((foo RealTree)) Real
  (ite
    (is-Leaf foo)
      0.0
      (+ (SumTree (left foo)) (elem foo) (SumTree (right foo)))))

; Gets the min of two RealAndNone numbers.
(define-fun min2 ((num1 RealAndNone) (num2 RealAndNone)) RealAndNone
  (ite (is-None num1)
       num2
       (ite (is-None num2)
            num1
            (ite (< (val num1) (val num2))
                 num1
                 num2))))

; Gets the min of three RealAndNone numbers.
(define-fun min3 ((num1 RealAndNone) (num2 RealAndNone) (num3 RealAndNone)) RealAndNone
  (min2 (min2 num1 num2) num3))

; Gets the max of two RealAndNone numbers.
(define-fun max2 ((num1 RealAndNone) (num2 RealAndNone)) RealAndNone
  (ite (is-None num1)
       num2
       (ite (is-None num2)
            num1
            (ite (> (val num1) (val num2))
                 num1
                 num2))))

; Gets the max of three RealAndNone numbers.
(define-fun max3 ((num1 RealAndNone) (num2 RealAndNone) (num3 RealAndNone)) RealAndNone
  (max2 (max2 num1 num2) num3))

; ; Test min2, min3, max2, and max3
; (assert (= (min2 None None) None))
; (assert (= (min2 None (RealNum 1.0)) (RealNum 1.0)))
; (assert (= (min2 (RealNum 1.0) None) (RealNum 1.0)))
; (assert (= (min3 (RealNum 1.0) (RealNum 2.0) (RealNum 3.0)) (RealNum 1.0)))
; (assert (= (min3 None (RealNum 1.0) (RealNum 2.0)) (RealNum 1.0)))
; (assert (= (max2 None None) None))
; (assert (= (max2 None (RealNum 1.0)) (RealNum 1.0)))
; (assert (= (max2 (RealNum 1.0) None) (RealNum 1.0)))
; (assert (= (max3 (RealNum 1.0) (RealNum 2.0) (RealNum 3.0)) (RealNum 3.0)))
; (assert (= (max3 None (RealNum 1.0) (RealNum 2.0)) (RealNum 2.0)))

; Min catamorphism.
(define-fun-rec Min ((foo RealTree)) RealAndNone
  (ite
    (is-Leaf foo)
      None
      (min3 (Min (left foo)) (RealNum (elem foo)) (Min (right foo))))
  ;:post-cond (or (and (is-None (Min foo))
                      ;(is-None (Max foo))
                      ;(= 0.0 (SumTree foo)))
                 ;(and (is-RealNum (Min foo))
                      ;(is-RealNum (Max foo))
                      ;(<= (val (Min foo)) (val (Max foo)))
                      ;(or (< (val (Min foo)) 0)
                          ;(and (>= (val (Min foo)) 0)
                               ;(or (=  (SumTree foo) (val (Min foo)))
                                   ;(>= (SumTree foo) (+ (val (Min foo)) (val (Min foo)))))))))
                                   )

; Max catamorphism.
(define-fun-rec Max ((foo RealTree)) RealAndNone
  (ite
    (is-Leaf foo)
      None
      (max3 (Max (left foo)) (RealNum (elem foo)) (Max (right foo)))))

; (define-fun-rec Min ((foo RealTree)) Real
;   (min3 (elem foo)
;         (ite (is-Leaf (left foo))
;              (elem foo)
;              (Min (left foo)))
;         (ite (is-Leaf (right foo))
;              (elem foo)
;              (Min (right foo))))
;   :post-cond (and (<= (Min foo) (Max foo))
;                   (or (< (Min foo) 0)
;                       (and (>= (Min foo) 0)
;                            (>= (SumTree foo) (Min foo))))))

; ; Test Min, Max, and SumTree
; (declare-fun l1 () RealTree)
; (assert (= l1 (Node
;                 (Node
;                   (Node
;                     (Node
;                       (Node
;                         (Node Leaf 5.0 Leaf)
;                         1.0
;                         (Node Leaf 2.0 Leaf))
;                       3.0
;                       Leaf)
;                     7.0
;                     Leaf)
;                   11.0
;                   Leaf)
;                 12.0
;                 Leaf)))
; (assert (= (Min Leaf) None))
; (assert (= (Max Leaf) None))
; (assert (= (SumTree Leaf) 0.0))
; (assert (= (Min l1) (RealNum 1.0)))
; (assert (= (Max l1) (RealNum 12.0)))
; (assert (= (SumTree l1) 41.0))


(declare-fun t () RealTree)
; min = 3, max = 4, sum = 15 => The result is SAT
(assert (= (Min t) (RealNum 3.0)))
(assert (= (Max t) (RealNum 4.0)))
(assert (= (SumTree t) 15.0))

(check-sat)
(exit)