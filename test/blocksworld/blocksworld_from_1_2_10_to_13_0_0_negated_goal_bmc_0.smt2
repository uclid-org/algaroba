; 
(set-info :status unknown)
(set-logic QF_DT)
(declare-datatypes ((Enum_A_B_C_D_E_F_G_H_I_J_K_L_M 0)) (((A) (B) (C) (D) (E) (F) (G) (H) (I) (J) (K) (L) (M))))
 (declare-datatypes ((Tower 0)) (((stack (top Enum_A_B_C_D_E_F_G_H_I_J_K_L_M) (rest Tower)) (empty))))
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
 (let ((?x25 (stack B empty)))
 (let ((?x96 (left s_tmp_)))
 (= ?x96 ?x25))))
(assert
 (let ((?x26 (stack G empty)))
 (let ((?x27 (stack M ?x26)))
 (let ((?x99 (center s_tmp__)))
 (= ?x99 ?x27)))))
(assert
 (let ((?x28 (stack A empty)))
 (let ((?x29 (stack C ?x28)))
 (let ((?x30 (stack D ?x29)))
 (let ((?x31 (stack E ?x30)))
 (let ((?x32 (stack F ?x31)))
 (let ((?x33 (stack H ?x32)))
 (let ((?x34 (stack I ?x33)))
 (let ((?x35 (stack J ?x34)))
 (let ((?x36 (stack K ?x35)))
 (let ((?x37 (stack L ?x36)))
 (let ((?x102 (right s_tmp___)))
 (= ?x102 ?x37)))))))))))))
(assert
 (= c_tmp____ c!0))
(assert
 (= s_ s_tmp___))
(assert
 (= c_ c_tmp____))
(assert
 (let ((?x129 (left s_tmp__)))
 (= (left s_tmp___) ?x129)))
(assert
 (let ((?x99 (center s_tmp__)))
 (= (center s_tmp___) ?x99)))
(assert
 (let ((?x133 (center s_tmp_)))
 (= ?x133 (center s_tmp))))
(assert
 (let ((?x136 (right s_tmp_)))
 (= ?x136 (right s_tmp))))
(assert
 (let ((?x96 (left s_tmp_)))
 (let ((?x129 (left s_tmp__)))
 (= ?x129 ?x96))))
(assert
 (let ((?x136 (right s_tmp_)))
 (let ((?x140 (right s_tmp__)))
 (= ?x140 ?x136))))
(assert
 (let ((?x42 (stack M (stack E (stack A (stack F (stack J (stack B empty))))))))
 (let ((?x48 (stack I (stack H (stack K (stack G (stack D (stack L ?x42))))))))
 (let ((?x49 (stack C ?x48)))
 (let ((?x73 (left s_)))
 (let (($x145 (and (= ?x73 ?x49) (= (center s_) empty) (= (right s_) empty))))
 (let (($x146 (not $x145)))
 (not $x146))))))))
(check-sat)
