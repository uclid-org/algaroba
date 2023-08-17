; testing out the weirder selector-constructor recution rule

(declare-datatypes ((weirdList 0)) (((nil) (cons (head int) (tail weirdList)) (weirdCons (weirdHead int) (weirdTail weirdList)))))
(assert (= nil (tail (tail (weirdCons 1 (weirdCons 2 (weirdCons 3 nil)))))))