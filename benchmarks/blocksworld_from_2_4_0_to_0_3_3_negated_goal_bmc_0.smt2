; 
(set-info :status unknown)
(set-logic QF_DT)
(declare-datatypes ((Enum_A_B_C_D_E_F 0)) (((A) (B) (C) (D) (E) (F))))
 (declare-datatypes ((Tower 0)) (((stack (top Enum_A_B_C_D_E_F) (rest Tower)) (empty))))
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
 (let ((?x19 (stack B empty)))
 (let ((?x18 (stack E ?x19)))
 (let ((?x75 (left s_tmp_)))
 (= ?x75 ?x18)))))
(assert
 (let ((?x20 (stack C empty)))
 (let ((?x21 (stack A ?x20)))
 (let ((?x22 (stack D ?x21)))
 (let ((?x23 (stack F ?x22)))
 (let ((?x78 (center s_tmp__)))
 (= ?x78 ?x23)))))))
(assert
 (let ((?x81 (right s_tmp___)))
 (= ?x81 empty)))
(assert
 (= c_tmp____ c!0))
(assert
 (= s_ s_tmp___))
(assert
 (= c_ c_tmp____))
(assert
 (let ((?x108 (left s_tmp__)))
 (= (left s_tmp___) ?x108)))
(assert
 (let ((?x78 (center s_tmp__)))
 (= (center s_tmp___) ?x78)))
(assert
 (let ((?x112 (center s_tmp_)))
 (= ?x112 (center s_tmp))))
(assert
 (let ((?x115 (right s_tmp_)))
 (= ?x115 (right s_tmp))))
(assert
 (let ((?x75 (left s_tmp_)))
 (let ((?x108 (left s_tmp__)))
 (= ?x108 ?x75))))
(assert
 (let ((?x115 (right s_tmp_)))
 (let ((?x119 (right s_tmp__)))
 (= ?x119 ?x115))))
(assert
 (let (($x124 (and (= (left s_) empty) (= (center s_) (stack F (stack D (stack C empty)))) (= (right s_) (stack E (stack B (stack A empty)))))))
 (let (($x125 (not $x124)))
 (not $x125))))
(check-sat)
