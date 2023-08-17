(declare-fun x () Int) 
(assert (> 5 x)) 
(assert (= (+ 2 3) 5)) 
(check-sat)