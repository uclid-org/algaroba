; 
(set-info :status unknown)
(set-logic QF_DT)
(declare-datatypes ((Enum_A_B_C_D_E_F_G_H_I_J_K_L_M_N 0)) (((A) (B) (C) (D) (E) (F) (G) (H) (I) (J) (K) (L) (M) (N))))
 (declare-datatypes ((Tower 0)) (((stack (top Enum_A_B_C_D_E_F_G_H_I_J_K_L_M_N) (rest Tower)) (empty))))
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
 (let ((?x27 (stack D empty)))
 (let ((?x26 (stack B ?x27)))
 (let ((?x28 (stack F ?x26)))
 (let ((?x29 (stack E ?x28)))
 (let ((?x30 (stack L ?x29)))
 (let ((?x31 (stack G ?x30)))
 (let ((?x32 (stack A ?x31)))
 (let ((?x33 (stack I ?x32)))
 (let ((?x98 (left s_tmp_)))
 (= ?x98 ?x33)))))))))))
(assert
 (let ((?x34 (stack M empty)))
 (let ((?x35 (stack J ?x34)))
 (let ((?x101 (center s_tmp__)))
 (= ?x101 ?x35)))))
(assert
 (let ((?x36 (stack C empty)))
 (let ((?x37 (stack H ?x36)))
 (let ((?x38 (stack K ?x37)))
 (let ((?x39 (stack N ?x38)))
 (let ((?x104 (right s_tmp___)))
 (= ?x104 ?x39)))))))
(assert
 (= c_tmp____ c!0))
(assert
 (= s_ s_tmp___))
(assert
 (= c_ c_tmp____))
(assert
 (let ((?x131 (left s_tmp__)))
 (= (left s_tmp___) ?x131)))
(assert
 (let ((?x101 (center s_tmp__)))
 (= (center s_tmp___) ?x101)))
(assert
 (let ((?x135 (center s_tmp_)))
 (= ?x135 (center s_tmp))))
(assert
 (let ((?x138 (right s_tmp_)))
 (= ?x138 (right s_tmp))))
(assert
 (let ((?x98 (left s_tmp_)))
 (let ((?x131 (left s_tmp__)))
 (= ?x131 ?x98))))
(assert
 (let ((?x138 (right s_tmp_)))
 (let ((?x142 (right s_tmp__)))
 (= ?x142 ?x138))))
(assert
 (let ((?x46 (stack I (stack G (stack F (stack E (stack B (stack A empty))))))))
 (let ((?x47 (stack J ?x46)))
 (let ((?x48 (stack K ?x47)))
 (let ((?x49 (stack L ?x48)))
 (let ((?x50 (stack M ?x49)))
 (let ((?x51 (stack N ?x50)))
 (let ((?x78 (right s_)))
 (let (($x147 (and (= (left s_) empty) (= (center s_) (stack D (stack H (stack C empty)))) (= ?x78 ?x51))))
 (let (($x148 (not $x147)))
 (not $x148)))))))))))
(check-sat)
