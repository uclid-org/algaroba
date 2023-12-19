; 
(set-info :status unknown)
(set-logic QF_DT)
(declare-datatypes ((Enum_A_B_C_D_E 0)) (((A) (B) (C) (D) (E))))
 (declare-datatypes ((Tower 0)) (((stack (top Enum_A_B_C_D_E) (rest Tower)) (empty))))
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
 (let ((?x17 (stack E empty)))
 (let ((?x18 (stack D ?x17)))
 (let ((?x73 (left s_tmp_)))
 (= ?x73 ?x18)))))
(assert
 (let ((?x19 (stack A empty)))
 (let ((?x20 (stack B ?x19)))
 (let ((?x21 (stack C ?x20)))
 (let ((?x76 (center s_tmp__)))
 (= ?x76 ?x21))))))
(assert
 (let ((?x79 (right s_tmp___)))
 (= ?x79 empty)))
(assert
 (= c_tmp____ c!0))
(assert
 (= s_ s_tmp___))
(assert
 (= c_ c_tmp____))
(assert
 (let ((?x106 (left s_tmp__)))
 (= (left s_tmp___) ?x106)))
(assert
 (let ((?x76 (center s_tmp__)))
 (= (center s_tmp___) ?x76)))
(assert
 (let ((?x110 (center s_tmp_)))
 (= ?x110 (center s_tmp))))
(assert
 (let ((?x113 (right s_tmp_)))
 (= ?x113 (right s_tmp))))
(assert
 (let ((?x73 (left s_tmp_)))
 (let ((?x106 (left s_tmp__)))
 (= ?x106 ?x73))))
(assert
 (let ((?x113 (right s_tmp_)))
 (let ((?x117 (right s_tmp__)))
 (= ?x117 ?x113))))
(assert
 (let ((?x53 (right s_)))
 (let (($x120 (= ?x53 empty)))
 (let ((?x24 (stack E (stack B (stack C empty)))))
 (let ((?x25 (stack A ?x24)))
 (let ((?x26 (stack D ?x25)))
 (let ((?x50 (left s_)))
 (let (($x123 (not (and (= ?x50 ?x26) (= (center s_) empty) $x120))))
 (not $x123)))))))))
(check-sat)
