(set-logic ALL)

(declare-datatype nat ((O) (S (pred nat))))
(declare-datatype list ((Nil) (Cons (head nat) (tail list))))
(declare-datatype bool1 ((True) (False)))

(define-fun-rec size ((x list)) nat (
  match x (
    (Nil O)
    ((Cons h t) (S (size t)))
  )
))

(define-fun-rec plus ((x1 nat) (x2 nat)) nat (
  match x1 (
    (O x2)
    ((S x1p) (S (plus x1p x2)))
  )
))

(define-fun and1 ((b1 bool1) (b2 bool1)) bool1 (
  match b1 (
    (True b2)
    (False False)
  )
))

(define-fun-rec solution ((l1 list) (l2 list)) list (
  match l1 (
    (Nil l2)
    ((Cons h t) (Cons (head l1) (solution (tail l1) l2)))
  )
))

(define-fun-rec incorrectsolution ((l1 list) (l2 list)) list (
  match l1 (
    (Nil (Cons O l2))
    ((Cons h t) (Cons (head l1) (incorrectsolution (tail l1) l2)))
  )
))

(define-fun spec ((l1 list) (l2 list) (out list)) Bool
  (= (size out) (plus (size l1) (size l2)))
)

(declare-const list1 list)
(declare-const list2 list)

(assert (not (spec list1 list2 (solution list1 list2))))

(check-sat)

;;solution
;fix (f : list * list -> list) =
  ;fun (x:list * list) ->
    ;match x . 0 with
      ;| Nil _ -> x . 1
      ;| Cons _ -> Cons (Un_Cons (x . 0) . 0, f (Un_Cons (x . 0) . 1, x . 1))


;let size =
  ;fix (size : list -> nat) =
    ;fun (x:list) ->
      ;match x with
        ;| Nil -> O
        ;| Cons (_, t) -> S (size t)
;;;
;
;let plus =
  ;fix (plus : nat -> nat -> nat) =
    ;fun (x1:nat) ->
      ;fun (x2:nat) ->
        ;match x1 with
        ;| O -> x2
        ;| S x1p -> S (plus x1p x2)
;;;
;
;let and =
  ;fun (b1:bool) ->
    ;fun (b2:bool) ->
      ;match b1 with
      ;| True -> b2
      ;| False -> False
;;;
;
;fun (in1in2:list * list) -> (fun (out : list) ->
    ;(size out) == (plus (size (in1in2.0)) (size (in1in2.1))))