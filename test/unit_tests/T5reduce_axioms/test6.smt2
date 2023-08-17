; just testing out new selector/constructor reduction rules using nats

(declare-datatypes ((nat 0)) (((succ (pred nat)) (zero))))
(declare-fun x1 () nat)
(assert (= (pred zero) x1))
(assert (= (succ x1) zero))