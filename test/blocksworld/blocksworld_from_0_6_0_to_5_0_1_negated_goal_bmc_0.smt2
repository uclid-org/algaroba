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
 (let ((?x76 (left s_tmp_)))
 (= ?x76 empty)))
(assert
 (let ((?x19 (stack E empty)))
 (let ((?x18 (stack A ?x19)))
 (let ((?x20 (stack B ?x18)))
 (let ((?x21 (stack C ?x20)))
 (let ((?x22 (stack D ?x21)))
 (let ((?x23 (stack F ?x22)))
 (let ((?x79 (center s_tmp__)))
 (= ?x79 ?x23)))))))))
(assert
 (let ((?x82 (right s_tmp___)))
 (= ?x82 empty)))
(assert
 (= c_tmp____ c!0))
(assert
 (= s_ s_tmp___))
(assert
 (= c_ c_tmp____))
(assert
 (let ((?x109 (left s_tmp__)))
 (= (left s_tmp___) ?x109)))
(assert
 (let ((?x79 (center s_tmp__)))
 (= (center s_tmp___) ?x79)))
(assert
 (let ((?x113 (center s_tmp_)))
 (= ?x113 (center s_tmp))))
(assert
 (let ((?x116 (right s_tmp_)))
 (= ?x116 (right s_tmp))))
(assert
 (let ((?x76 (left s_tmp_)))
 (let ((?x109 (left s_tmp__)))
 (= ?x109 ?x76))))
(assert
 (let ((?x116 (right s_tmp_)))
 (let ((?x120 (right s_tmp__)))
 (= ?x120 ?x116))))
(assert
 (let ((?x28 (stack D (stack A (stack B (stack E (stack F empty)))))))
 (let ((?x53 (left s_)))
 (let (($x125 (and (= ?x53 ?x28) (= (center s_) empty) (= (right s_) (stack C empty)))))
 (let (($x126 (not $x125)))
 (not $x126))))))
(check-sat)
