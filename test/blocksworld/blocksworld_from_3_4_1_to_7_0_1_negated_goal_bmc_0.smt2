; 
(set-info :status unknown)
(set-logic QF_DT)
(declare-datatypes ((Enum_A_B_C_D_E_F_G_H 0)) (((A) (B) (C) (D) (E) (F) (G) (H))))
 (declare-datatypes ((Tower 0)) (((stack (top Enum_A_B_C_D_E_F_G_H) (rest Tower)) (empty))))
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
 (let ((?x21 (stack H empty)))
 (let ((?x20 (stack A ?x21)))
 (let ((?x22 (stack F ?x20)))
 (let ((?x80 (left s_tmp_)))
 (= ?x80 ?x22))))))
(assert
 (let ((?x23 (stack D empty)))
 (let ((?x24 (stack E ?x23)))
 (let ((?x25 (stack B ?x24)))
 (let ((?x26 (stack C ?x25)))
 (let ((?x83 (center s_tmp__)))
 (= ?x83 ?x26)))))))
(assert
 (let ((?x27 (stack G empty)))
 (let ((?x86 (right s_tmp___)))
 (= ?x86 ?x27))))
(assert
 (= c_tmp____ c!0))
(assert
 (= s_ s_tmp___))
(assert
 (= c_ c_tmp____))
(assert
 (let ((?x113 (left s_tmp__)))
 (= (left s_tmp___) ?x113)))
(assert
 (let ((?x83 (center s_tmp__)))
 (= (center s_tmp___) ?x83)))
(assert
 (let ((?x117 (center s_tmp_)))
 (= ?x117 (center s_tmp))))
(assert
 (let ((?x120 (right s_tmp_)))
 (= ?x120 (right s_tmp))))
(assert
 (let ((?x80 (left s_tmp_)))
 (let ((?x113 (left s_tmp__)))
 (= ?x113 ?x80))))
(assert
 (let ((?x120 (right s_tmp_)))
 (let ((?x124 (right s_tmp__)))
 (= ?x124 ?x120))))
(assert
 (let ((?x27 (stack G empty)))
 (let ((?x60 (right s_)))
 (let (($x127 (= ?x60 ?x27)))
 (let ((?x30 (stack B (stack F (stack D (stack H empty))))))
 (let ((?x31 (stack A ?x30)))
 (let ((?x32 (stack E ?x31)))
 (let ((?x33 (stack C ?x32)))
 (let ((?x57 (left s_)))
 (let (($x130 (not (and (= ?x57 ?x33) (= (center s_) empty) $x127))))
 (not $x130)))))))))))
(check-sat)
