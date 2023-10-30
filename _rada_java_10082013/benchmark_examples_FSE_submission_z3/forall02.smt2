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
  (not (pr_u e)))

(define-fun delta_forall ((e Real)) Bool
  (pr_u e))

;;
;; Definition of PAC catamorphism Forall
;;
(define-fun-rec PAC_forall ((foo RealTree) (cleaf_forall Bool) (cpr_forall Bool) (rec Bool)) Bool
  (ite (is-Leaf foo)
       cleaf_forall
       (ite (not (pr (elem foo)))
            (and (PAC_forall  (left foo) cleaf_forall cpr_forall rec)
                 (delta_forall (elem foo))
                 (PAC_forall (right foo) cleaf_forall cpr_forall rec))
            (ite rec
                 (and (PAC_forall  (left foo) cleaf_forall cpr_forall rec)
                      cpr_forall
                      (PAC_forall (right foo) cleaf_forall cpr_forall rec))
                 cpr_forall))))

;;
;; Forall is a PAC catamorphism with
;;   + delta(e) = pr_u(e)
;;   + cleaf = true
;;   + cpr = false
;;   + pr = not pr_u
;;   + rec = true or false
;;
;; Suppose our user-provided predicate is is-positive
;;
(declare-fun cleaf_forall_const () Bool)
(declare-fun cpr_forall_const () Bool)
(declare-fun rec_const () Bool)
(assert (= cleaf_forall_const true))
(assert (= cpr_forall_const false))
(assert (= rec_const false))



;;
;; Suppose we want to check if NOT all the element values in tree t1 are positive
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

; the result is UNSAT: all element values in t1 are positive
(assert (= (PAC_forall t1 cleaf_forall_const cpr_forall_const rec_const) false))
(check-sat)
(exit)