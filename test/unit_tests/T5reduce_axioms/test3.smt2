(declare-datatypes ((nat 0)(list 0)(tree 0)) (((succ (pred tree)) (zero))
((cons (car tree) (cdr list)) (null))
((node (children list)) (leaf (data nat)))
))

(declare-fun x1 () nat)
(declare-fun x2 () list)
(declare-fun x3 () list)
(declare-fun x4 () tree)

