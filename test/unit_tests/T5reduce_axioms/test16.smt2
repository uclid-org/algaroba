; We are testing to see if the new at-most thing is working

(set-info :license "https://creativecommons.org/licenses/by/4.0/")
(set-info :category "industrial")
(set-info :status unsat)

(declare-datatypes ((Place 0)) (((p1) (p2) (p3) (p33) (p55))))
(declare-datatypes ((Unit 0)) (((u0) (u1) (u2))))
(declare-fun u (Place) Unit)
(assert (= (u p1) u0))
(assert (or (= (u p2) u0) (= (u p2) u1)))
(assert (or (= (u p3) u0) (= (u p3) u1) (= (u p3) u2)))
(assert (distinct (u p33) (u p55)))
(check-sat)