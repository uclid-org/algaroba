(declare-fun x () Int) 
(assert (> 5 x)) 
(assert (= (+ 5 3) 8)) 
(check-sat)