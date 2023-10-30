;(set-option :produce-models true)
(set-logic ALL)
(declare-datatypes () (
  (RealTree
    (Node
      (left RealTree)
      (elem Real)
      (right RealTree))
    (Leaf))))


; definition of is-positive
(define-fun is-positive ((e Real)) Bool
  (ite (> e 0)
       true
       false))

; user-provided predicate pr_u
(define-fun pr_u ((e Real)) Bool
  (is-positive e))

(define-fun pr ((e Real)) Bool
  (pr_u e))

(define-fun delta_exists ((e Real)) Bool
  (pr_u e))
  
;;
;; Definition of PAC catamorphism Exists
;;
(define-fun-rec PAC_exists ((foo RealTree) (cleaf_exists Bool) (cpr_exists Bool) (rec Bool)) Bool
  (ite (is-Leaf foo)
       cleaf_exists
       (ite (not (pr (elem foo)))
            (or (PAC_exists  (left foo) cleaf_exists cpr_exists rec)
                (delta_exists (elem foo))
                (PAC_exists (right foo) cleaf_exists cpr_exists rec))
            (ite rec
                 (or (PAC_exists  (left foo) cleaf_exists cpr_exists rec)
                     cpr_exists
                     (PAC_exists (right foo) cleaf_exists cpr_exists rec))
                 cpr_exists))))

;;
;; Exists is a PAC catamorphism with
;;   + delta = pr_u
;;   + cleaf = false
;;   + cpr = true
;;   + pr = pr_u
;;   + rec = true or false
;;
;; Suppose our user-provided predicate is is-positive
;;
(declare-fun cleaf_exists_const () Bool)
(declare-fun cpr_exists_const () Bool)
(declare-fun rec_const () Bool)
(assert (= cleaf_exists_const false))
(assert (= cpr_exists_const true))
(assert (= rec_const false))


;;
;; Suppose we want to check if there exists a positive element value in tree t1:
;;
(declare-fun t1 () RealTree)
(assert (= t1 (Node
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

; the result is SAT: there exists a positive element value in t1.
(assert (= (PAC_exists t1 cleaf_exists_const cpr_exists_const rec_const) true))
(check-sat)
(exit)