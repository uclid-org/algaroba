;(set-option :produce-models true)
(set-logic ALL)
(declare-datatypes () (
  (RealTree
    (Node
      (left RealTree)
      (elem Real)
      (right RealTree))
    (Leaf))))

; definition of is-equal
(define-fun is-equal ((e Real) (x Real)) Bool
  (ite (= e x)
       true
       false))

; user-provided predicate pr_u
(define-fun pr_u ((e Real) (x Real)) Bool
  (is-equal e x))

(define-fun pr ((e Real) (x Real)) Bool
  (pr_u e x))

(define-fun delta_member ((e Real) (x Real)) Bool
  (pr_u e x))


;;
;; Definition of PAC catamorphism Member(x)
;;
(define-fun-rec PAC_member ((foo RealTree) (cleaf_member Bool) (cpr_member Bool) (rec Bool) (x Real)) Bool
  (ite (is-Leaf foo)
       cleaf_member
       (ite (not (pr (elem foo) x))
            (or (PAC_member  (left foo) cleaf_member cpr_member rec x)
                (delta_member (elem foo) x)
                (PAC_member (right foo) cleaf_member cpr_member rec x))
            (ite rec
                 (or (PAC_member  (left foo) cleaf_member cpr_member rec x)
                     cpr_member
                     (PAC_member (right foo) cleaf_member cpr_member rec x))
                 cpr_member))))

;;
;; Member(x) is a PAC catamorphism with
;;   + delta = pr_u
;;   + cleaf = false
;;   + cpr = true
;;   + pr = pr_u
;;   + rec = true or false
;;
;;   where pr_u(e x) = (e = x)
;;
(declare-fun cleaf_member_const () Bool)
(declare-fun cpr_member_const () Bool)
(declare-fun rec_const () Bool)
(assert (= cleaf_member_const false))
(assert (= cpr_member_const true))
(assert (= rec_const false))



;;
;; Suppose we want to check if 1.1 is a member of tree t1:
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

; the result is UNSAT: there does not exist 1.1 in t1.
(assert (= (PAC_member t1 cleaf_member_const cpr_member_const rec_const 1.1) true))
(check-sat)
(exit)