(set-logic QF_DT)

(declare-sort u 0)

(declare-datatypes ((tree 0))
        (((Leaf (value u))
          (Node (left tree) (right tree)))))

(declare-fun t1 () tree)
(declare-fun t2 () tree)

(assert ((_ is Node) t1))
(assert ((_ is Node) t2))
(assert (= (left t1) (left t2)))
(assert (= (right t1) (right t2)))
(assert (not (= t1 t2)))

(check-sat)