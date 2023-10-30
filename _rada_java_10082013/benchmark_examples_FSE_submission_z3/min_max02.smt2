;(set-option :produce-models true)
(set-logic ALL)
;(set-info :status unsat)
(declare-datatypes () (
  ( RealTree
    ( Node
      (left RealTree)
      (elem Real)
      (right RealTree))
    (Leaf))))

(declare-datatypes (T1 T2) ((Pair (mk-pair (first T1) (second T2)))))

; Gets the min of two numbers.
(define-fun min2 ((num1 Real) (num2 Real)) Real
  (ite (< num1 num2)
       num1
       num2))

; Gets the min of three numbers.
(define-fun min3 ((num1 Real) (num2 Real) (num3 Real)) Real
  (min2 (min2 num1 num2) num3))

; Gets the max of two numbers.
(define-fun max2 ((num1 Real) (num2 Real)) Real
  (ite (< num1 num2)
       num2
       num1))

; Gets the max of three numbers.
(define-fun max3 ((num1 Real) (num2 Real) (num3 Real)) Real
  (max2 (max2 num1 num2) num3))

; Maps a tree to a pair of its minimum value and maximum value.
; We assume that the tree has at least 1 element value.
(define-fun-rec MinAndMax ((foo RealTree)) (Pair Real Real)
  (ite
    (is-Leaf foo)
    (mk-pair 0.0 0.0)
    (mk-pair
      ; get the min value
      (min3 (elem foo)
            (ite (is-Leaf (left foo))
                 (elem foo)
                 (first (MinAndMax (left foo))))
            (ite (is-Leaf (right foo))
                 (elem foo)
                 (first (MinAndMax (right foo)))))
      ; get the max value
      (max3 (elem foo)
            (ite (is-Leaf (left foo))
                 (elem foo)
                 (second (MinAndMax (left foo))))
            (ite (is-Leaf (right foo))
                 (elem foo)
                 (second (MinAndMax (right foo))))))))

(declare-fun l1 () RealTree)
(declare-fun result () (Pair Real Real))
(assert (= l1 (Node
                (Node
                  (Node
                    (Node
                      (Node
                        (Node Leaf 5.0 Leaf)
                        1.0
                        (Node Leaf 2.0 Leaf))
                      3.0
                      Leaf)
                    7.0
                    Leaf)
                  11.0
                  Leaf)
                12.0
                Leaf)))
; unsat: min must be 1.0 and max must be 12.0
(assert (= result (MinAndMax l1)))
(assert (not (and (= (first result) 1.0)
                  (= (second result) 12.0))))
(check-sat)
(exit)