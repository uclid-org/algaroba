; 
(set-info :status unknown)
(set-logic QF_DT)
(declare-datatypes ((Enum_A_B_C_D 0)) (((A) (B) (C) (D))))
 (declare-datatypes ((Tower 0)) (((stack (top Enum_A_B_C_D) (rest Tower)) (empty))))
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
 (let ((?x68 (left s_tmp_)))
 (= ?x68 empty)))
(assert
 (let ((?x17 (stack A empty)))
 (let ((?x71 (center s_tmp__)))
 (= ?x71 ?x17))))
(assert
 (let ((?x16 (stack B empty)))
 (let ((?x18 (stack C ?x16)))
 (let ((?x19 (stack D ?x18)))
 (let ((?x74 (right s_tmp___)))
 (= ?x74 ?x19))))))
(assert
 (= c_tmp____ c!0))
(assert
 (= s_ s_tmp___))
(assert
 (= c_ c_tmp____))
(assert
 (let ((?x101 (left s_tmp__)))
 (= (left s_tmp___) ?x101)))
(assert
 (let ((?x71 (center s_tmp__)))
 (= (center s_tmp___) ?x71)))
(assert
 (let ((?x105 (center s_tmp_)))
 (= ?x105 (center s_tmp))))
(assert
 (let ((?x108 (right s_tmp_)))
 (= ?x108 (right s_tmp))))
(assert
 (let ((?x68 (left s_tmp_)))
 (let ((?x101 (left s_tmp__)))
 (= ?x101 ?x68))))
(assert
 (let ((?x108 (right s_tmp_)))
 (let ((?x112 (right s_tmp__)))
 (= ?x112 ?x108))))
(assert
 (let ((?x17 (stack A empty)))
 (let ((?x50 (center s_)))
 (let (($x114 (= ?x50 ?x17)))
 (let (($x117 (and (= (left s_) (stack C empty)) $x114 (= (right s_) (stack D (stack B empty))))))
 (let (($x118 (not $x117)))
 (not $x118)))))))
(check-sat)
