; 
(set-info :status unknown)
(set-logic QF_DT)
(declare-datatypes ((Enum_A_B_C_D_E_F_G 0)) (((A) (B) (C) (D) (E) (F) (G))))
 (declare-datatypes ((Tower 0)) (((stack (top Enum_A_B_C_D_E_F_G) (rest Tower)) (empty))))
 (declare-datatypes ((Record_left_center_right 0)) (((Record_left_center_right (left Tower) (center Tower) (right Tower)))))
 (declare-datatypes ((Enum_left-to-center_left-to-right_center-to-left_center-to-right_right-to-left_right-to-center 0)) (((left-to-center) (left-to-right) (center-to-left) (center-to-right) (right-to-left) (right-to-center))))
 (declare-fun s () Record_left_center_right)
(declare-fun s_tmp () Record_left_center_right)
(declare-fun c () Enum_left-to-center_left-to-right_center-to-left_center-to-right_right-to-left_right-to-center)
(declare-fun c_tmp () Enum_left-to-center_left-to-right_center-to-left_center-to-right_right-to-left_right-to-center)
(declare-fun s_tmp_ () Record_left_center_right)
(declare-fun s_tmp__ () Record_left_center_right)
(declare-fun s_tmp___ () Record_left_center_right)
(declare-fun c!0 () Enum_left-to-center_left-to-right_center-to-left_center-to-right_right-to-left_right-to-center)
(declare-fun c_tmp____ () Enum_left-to-center_left-to-right_center-to-left_center-to-right_right-to-left_right-to-center)
(declare-fun s_ () Record_left_center_right)
(declare-fun c_ () Enum_left-to-center_left-to-right_center-to-left_center-to-right_right-to-left_right-to-center)
(assert
 (= s_tmp s))
(assert
 (= c_tmp c))
(assert
 (let ((?x20 (stack B empty)))
 (let ((?x19 (stack F ?x20)))
 (let ((?x77 (left s_tmp_)))
 (= ?x77 ?x19)))))
(assert
 (let ((?x80 (center s_tmp__)))
 (= ?x80 empty)))
(assert
 (let ((?x21 (stack A empty)))
 (let ((?x22 (stack C ?x21)))
 (let ((?x23 (stack D ?x22)))
 (let ((?x24 (stack E ?x23)))
 (let ((?x25 (stack G ?x24)))
 (let ((?x83 (right s_tmp___)))
 (= ?x83 ?x25))))))))
(assert
 (= c_tmp____ c!0))
(assert
 (= s_ s_tmp___))
(assert
 (= c_ c_tmp____))
(assert
 (let ((?x110 (left s_tmp__)))
 (= (left s_tmp___) ?x110)))
(assert
 (let ((?x80 (center s_tmp__)))
 (= (center s_tmp___) ?x80)))
(assert
 (let ((?x114 (center s_tmp_)))
 (= ?x114 (center s_tmp))))
(assert
 (let ((?x117 (right s_tmp_)))
 (= ?x117 (right s_tmp))))
(assert
 (let ((?x77 (left s_tmp_)))
 (let ((?x110 (left s_tmp__)))
 (= ?x110 ?x77))))
(assert
 (let ((?x117 (right s_tmp_)))
 (let ((?x121 (right s_tmp__)))
 (= ?x121 ?x117))))
(assert
 (let ((?x21 (stack A empty)))
 (let ((?x28 (stack E ?x21)))
 (let ((?x29 (stack F ?x28)))
 (let ((?x30 (stack G ?x29)))
 (let ((?x57 (right s_)))
 (let (($x126 (and (= (left s_) (stack D (stack C empty))) (= (center s_) (stack B empty)) (= ?x57 ?x30))))
 (let (($x127 (not $x126)))
 (not $x127)))))))))
(check-sat)
