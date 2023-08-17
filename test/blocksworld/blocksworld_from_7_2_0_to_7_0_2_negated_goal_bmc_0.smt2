; 
(set-info :status unknown)
(set-logic QF_DT)
(declare-datatypes ((Enum_A_B_C_D_E_F_G_H_I 0)) (((A) (B) (C) (D) (E) (F) (G) (H) (I))))
 (declare-datatypes ((Tower 0)) (((stack (top Enum_A_B_C_D_E_F_G_H_I) (rest Tower)) (empty))))
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
 (let ((?x21 (stack B empty)))
 (let ((?x22 (stack G ?x21)))
 (let ((?x23 (stack I ?x22)))
 (let ((?x24 (stack D ?x23)))
 (let ((?x25 (stack A ?x24)))
 (let ((?x26 (stack E ?x25)))
 (let ((?x27 (stack C ?x26)))
 (let ((?x84 (left s_tmp_)))
 (= ?x84 ?x27))))))))))
(assert
 (let ((?x28 (stack H empty)))
 (let ((?x29 (stack F ?x28)))
 (let ((?x87 (center s_tmp__)))
 (= ?x87 ?x29)))))
(assert
 (let ((?x90 (right s_tmp___)))
 (= ?x90 empty)))
(assert
 (= c_tmp____ c!0))
(assert
 (= s_ s_tmp___))
(assert
 (= c_ c_tmp____))
(assert
 (let ((?x117 (left s_tmp__)))
 (= (left s_tmp___) ?x117)))
(assert
 (let ((?x87 (center s_tmp__)))
 (= (center s_tmp___) ?x87)))
(assert
 (let ((?x121 (center s_tmp_)))
 (= ?x121 (center s_tmp))))
(assert
 (let ((?x124 (right s_tmp_)))
 (= ?x124 (right s_tmp))))
(assert
 (let ((?x84 (left s_tmp_)))
 (let ((?x117 (left s_tmp__)))
 (= ?x117 ?x84))))
(assert
 (let ((?x124 (right s_tmp_)))
 (let ((?x128 (right s_tmp__)))
 (= ?x128 ?x124))))
(assert
 (let ((?x28 (stack H empty)))
 (let ((?x30 (stack C ?x28)))
 (let ((?x31 (stack I ?x30)))
 (let ((?x32 (stack B ?x31)))
 (let ((?x33 (stack D ?x32)))
 (let ((?x34 (stack F ?x33)))
 (let ((?x35 (stack G ?x34)))
 (let ((?x61 (left s_)))
 (let (($x133 (and (= ?x61 ?x35) (= (center s_) empty) (= (right s_) (stack E (stack A empty))))))
 (let (($x134 (not $x133)))
 (not $x134))))))))))))
(check-sat)
