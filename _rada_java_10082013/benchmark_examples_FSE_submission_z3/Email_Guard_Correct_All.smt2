(set-logic ALL)
(set-info :source | SMT-COMP'06 organizers |)
(set-info :smt-lib-version 2.0)
(set-info :category "check")


(declare-sort char 0)
(declare-sort string 0)




(declare-datatypes ()
  ((xml (xml_Leaf (destxml_Leaf string)) (xml_Node (destxml_Node xmlList)))

   (xmlList (xmlList_nil) (xmlList_cons (destxmlList_cons xmlList_cons_recd)))

   (xmlList_cons_recd (xmlList_cons_recd (xmlList_cons_recd_hd xml)
  (xmlList_cons_recd_tl xmlList)))
))

(declare-datatypes ()
  ((byteList (byteList_nil) (byteList_cons (destbyteList_cons byteList_cons_recd)))

   (byteList_cons_recd (byteList_cons_recd (byteList_cons_recd_hd char)
  (byteList_cons_recd_tl byteList)))
))

(declare-datatypes ()
  ((stringList (stringList_nil) (stringList_cons (deststringList_cons stringList_cons_recd)))

   (stringList_cons_recd (stringList_cons_recd (stringList_cons_recd_hd string)
  (stringList_cons_recd_tl stringList)))
))

(declare-datatypes ()
  ((prod1 (prod1 (prod1_fst string) (prod1_snd string)))
))

(declare-datatypes ()
  ((audit (audit_Exec) (audit_Virus) (audit_Dirty_Word) (audit_Exe_Suffix) (audit_Unknown_Object_Type))
))

(declare-datatypes ()
  ((email (email (email_body string) (email_attachments attachList)))

   (attachList (attachList_nil) (attachList_cons (destattachList_cons attachList_cons_recd)))

   (attachType (attachType_Email (destattachType_Email email)) (attachType_Text (destattachType_Text string)) (attachType_Xml (destattachType_Xml xml)) (attachType_Binary (destattachType_Binary byteList)) (attachType_Other))

   (attach (attach (attach_name string) (attach_object attachType)))

   (attachList_cons_recd (attachList_cons_recd (attachList_cons_recd_hd attach)
  (attachList_cons_recd_tl attachList)))
))

(declare-datatypes ()
  ((xmlResult (xmlResult_Audit (destxmlResult_Audit audit)) (xmlResult_Xml (destxmlResult_Xml xml)))
))

(declare-datatypes ()
  ((prod2 (prod2 (prod2_fst1 string) (prod2_snd1 stringList)))
))

(declare-datatypes ()
  ((stringResult (stringResult_Audit (deststringResult_Audit audit)) (stringResult_String (deststringResult_String string)))
))

(declare-datatypes ()
  ((emailResult (emailResult_Audit (destemailResult_Audit audit)) (emailResult_Email (destemailResult_Email email)))
))

(declare-datatypes ()
  ((attachListResult (attachListResult_Audit (destattachListResult_Audit audit)) (attachListResult_attachList (destattachListResult_attachList attachList)))
))

(declare-datatypes ()
  ((attachResult (attachResult_Audit (destattachResult_Audit audit)) (attachResult_Attach (destattachResult_Attach attach)))
))



(declare-fun DIRTY_WORD_CHECKFn (string) stringResult)
(declare-fun EXEC_CHECKFn (byteList) Bool)
(declare-fun Email_GuardFn_ext (email) emailResult)
(declare-fun M () email)
(declare-fun NOT_SUFFIX_CHECKFn (prod2) Bool)
(declare-fun VIRUS_CHECKFn (email) Bool)
(declare-fun XML_CHECKFn (xml) xmlResult)
(declare-fun a () attach)
(declare-fun al () attachList)
(declare-fun alr () attachListResult)
(declare-fun ar () attachResult)
(declare-fun attachList_GuardFn_ext (attachList) attachListResult)
(declare-fun attach_GuardFn_ext (attach) attachResult)
(declare-fun er () emailResult)
(declare-fun s () string)
(declare-fun sp () prod1)
(declare-fun string_lit1 () string)
(declare-fun string_lit2 () string)
(declare-fun string_lit3 () string)
(declare-fun string_lit4 () string)
(declare-fun string_lit5 () string)
(declare-fun string_lit6 () string)
(declare-fun v3 () attach)
(declare-fun v4 () attachList)
(declare-fun v5 () email)


(define-fun String_EqFn ((sp prod1)) Bool
  (= (prod1_fst sp) (prod1_snd sp)))
(define-fun DIRTY_WORD_CHECK_IdempotentFn_ext ((s string)) Bool
  (ite (is-stringResult_Audit (DIRTY_WORD_CHECKFn s)) true (ite (is-stringResult_Audit (DIRTY_WORD_CHECKFn (deststringResult_String (DIRTY_WORD_CHECKFn s)))) false (String_EqFn (prod1 (deststringResult_String (DIRTY_WORD_CHECKFn s)) (deststringResult_String (DIRTY_WORD_CHECKFn (deststringResult_String (DIRTY_WORD_CHECKFn s)))))))))
(define-fun textStableFn_ext ((s string)) Bool
  (ite (is-stringResult_Audit (DIRTY_WORD_CHECKFn s)) false (String_EqFn (prod1 s (deststringResult_String (DIRTY_WORD_CHECKFn s))))))


(define-funs-rec ((emailResult_StableFn_ext ((er emailResult)) Bool) (emailStableFn_ext ((M email)) Bool) (attachListStableFn_ext ((al attachList)) Bool) (attachStableFn_ext ((a attach)) Bool) (attachListResult_StableFn_ext ((alr attachListResult)) Bool) (attachResult_StableFn_ext ((ar attachResult)) Bool))
  (
    (ite (is-emailResult_Audit er) true (emailStableFn_ext (destemailResult_Email er)))
    (and (textStableFn_ext (email_body M)) (attachListStableFn_ext (email_attachments M)))
    (ite (is-attachList_nil al) true (and (attachStableFn_ext (attachList_cons_recd_hd (destattachList_cons al))) (attachListStableFn_ext (attachList_cons_recd_tl (destattachList_cons al)))))
    (ite (is-attachType_Email (attach_object a)) (emailStableFn_ext (destattachType_Email (attach_object a))) (ite (is-attachType_Text (attach_object a)) (textStableFn_ext (destattachType_Text (attach_object a))) true))
    (ite (is-attachListResult_Audit alr) true (attachListStableFn_ext (destattachListResult_attachList alr)))
    (ite (is-attachResult_Audit ar) true (attachStableFn_ext (destattachResult_Attach ar))) 
  )
  )


; 01
(push)
(assert (and (not (VIRUS_CHECKFn v5)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (email_body v5)) (not (emailResult_StableFn_ext (emailResult_Audit audit_Virus))))))
(check-sat)
(pop)

; 02
(push)
(assert (and (is-stringResult_Audit (DIRTY_WORD_CHECKFn (email_body v5))) (and (VIRUS_CHECKFn v5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (email_body v5)) (not (emailResult_StableFn_ext (emailResult_Audit (deststringResult_Audit (DIRTY_WORD_CHECKFn (email_body v5))))))))))
(check-sat)
(pop)

; 03
(push)
(assert (and (attachListResult_StableFn_ext (attachList_GuardFn_ext (email_attachments v5))) (and (not (is-stringResult_Audit (DIRTY_WORD_CHECKFn (email_body v5)))) (and (is-attachListResult_Audit (attachList_GuardFn_ext (email_attachments v5))) (and (VIRUS_CHECKFn v5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (email_body v5)) (not (emailResult_StableFn_ext (emailResult_Audit (destattachListResult_Audit (attachList_GuardFn_ext (email_attachments v5))))))))))))
(check-sat)
(pop)

; 04
(push)
(assert (and (attachListResult_StableFn_ext (attachList_GuardFn_ext (email_attachments v5))) (and (not (is-stringResult_Audit (DIRTY_WORD_CHECKFn (email_body v5)))) (and (not (is-attachListResult_Audit (attachList_GuardFn_ext (email_attachments v5)))) (and (VIRUS_CHECKFn v5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (deststringResult_String (DIRTY_WORD_CHECKFn (email_body v5)))) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (email_body v5)) (not (emailResult_StableFn_ext (emailResult_Email (email (deststringResult_String (DIRTY_WORD_CHECKFn (email_body v5))) (destattachListResult_attachList (attachList_GuardFn_ext (email_attachments v5))))))))))))))
(check-sat)
(pop)

; 05
(push)
(assert (and (not (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil))))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Audit audit_Exe_Suffix)))))))))))))))))))))))))))
(check-sat)
(pop)

; 06
(push)
(assert (and (emailResult_StableFn_ext (Email_GuardFn_ext (destattachType_Email (attach_object v3)))) (and (is-attachType_Email (attach_object v3)) (and (is-emailResult_Audit (Email_GuardFn_ext (destattachType_Email (attach_object v3)))) (and (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil)))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Audit (destemailResult_Audit (Email_GuardFn_ext (destattachType_Email (attach_object v3))))))))))))))))))))))))))))))))))
(check-sat)
(pop)

; 07
(push)
(assert (and (emailResult_StableFn_ext (Email_GuardFn_ext (destattachType_Email (attach_object v3)))) (and (is-attachType_Email (attach_object v3)) (and (not (is-emailResult_Audit (Email_GuardFn_ext (destattachType_Email (attach_object v3))))) (and (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil)))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Attach (attach (attach_name v3) (attachType_Email (destemailResult_Email (Email_GuardFn_ext (destattachType_Email (attach_object v3))))))))))))))))))))))))))))))))))))
(check-sat)
(pop)

; 08
(push)
(assert (and (not (is-attachType_Email (attach_object v3))) (and (is-attachType_Text (attach_object v3)) (and (is-stringResult_Audit (DIRTY_WORD_CHECKFn (destattachType_Text (attach_object v3)))) (and (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil)))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (destattachType_Text (attach_object v3))) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Audit (deststringResult_Audit (DIRTY_WORD_CHECKFn (destattachType_Text (attach_object v3)))))))))))))))))))))))))))))))))))
(check-sat)
(pop)

; 09
(push)
(assert (and (not (is-attachType_Email (attach_object v3))) (and (is-attachType_Text (attach_object v3)) (and (not (is-stringResult_Audit (DIRTY_WORD_CHECKFn (destattachType_Text (attach_object v3))))) (and (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil)))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (deststringResult_String (DIRTY_WORD_CHECKFn (destattachType_Text (attach_object v3))))) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (destattachType_Text (attach_object v3))) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Attach (attach (attach_name v3) (attachType_Text (deststringResult_String (DIRTY_WORD_CHECKFn (destattachType_Text (attach_object v3))))))))))))))))))))))))))))))))))))))
(check-sat)
(pop)

; 10
(push)
(assert (and (not (is-attachType_Email (attach_object v3))) (and (not (is-attachType_Text (attach_object v3))) (and (is-attachType_Xml (attach_object v3)) (and (is-xmlResult_Audit (XML_CHECKFn (destattachType_Xml (attach_object v3)))) (and (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil)))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Audit (destxmlResult_Audit (XML_CHECKFn (destattachType_Xml (attach_object v3)))))))))))))))))))))))))))))))))))
(check-sat)
(pop)

; 11
(push)
(assert (and (not (is-attachType_Email (attach_object v3))) (and (not (is-attachType_Text (attach_object v3))) (and (is-attachType_Xml (attach_object v3)) (and (not (is-xmlResult_Audit (XML_CHECKFn (destattachType_Xml (attach_object v3))))) (and (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil)))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Attach (attach (attach_name v3) (attachType_Xml (destxmlResult_Xml (XML_CHECKFn (destattachType_Xml (attach_object v3)))))))))))))))))))))))))))))))))))))
(check-sat)
(pop)

; 12
(push)
(assert (and (not (is-attachType_Email (attach_object v3))) (and (not (is-attachType_Text (attach_object v3))) (and (not (is-attachType_Xml (attach_object v3))) (and (is-attachType_Binary (attach_object v3)) (and (EXEC_CHECKFn (destattachType_Binary (attach_object v3))) (and (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil)))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Attach v3))))))))))))))))))))))))))))))))
(check-sat)
(pop)

; 13
(push)
(assert (and (not (is-attachType_Email (attach_object v3))) (and (not (is-attachType_Text (attach_object v3))) (and (not (is-attachType_Xml (attach_object v3))) (and (is-attachType_Binary (attach_object v3)) (and (not (EXEC_CHECKFn (destattachType_Binary (attach_object v3)))) (and (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil)))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Audit audit_Exec))))))))))))))))))))))))))))))))
(check-sat)
(pop)

; 14
(push)
(assert (and (not (is-attachType_Email (attach_object v3))) (and (not (is-attachType_Text (attach_object v3))) (and (not (is-attachType_Xml (attach_object v3))) (and (not (is-attachType_Binary (attach_object v3))) (and (NOT_SUFFIX_CHECKFn (prod2 (attach_name v3) (stringList_cons (stringList_cons_recd string_lit3 (stringList_cons (stringList_cons_recd string_lit2 (stringList_cons (stringList_cons_recd string_lit4 (stringList_cons (stringList_cons_recd string_lit1 (stringList_cons (stringList_cons_recd string_lit6 (stringList_cons (stringList_cons_recd string_lit5 stringList_nil)))))))))))))) (and (not (= string_lit1 string_lit2)) (and (not (= string_lit1 string_lit3)) (and (not (= string_lit1 string_lit4)) (and (not (= string_lit1 string_lit5)) (and (not (= string_lit1 string_lit6)) (and (not (= string_lit2 string_lit3)) (and (not (= string_lit2 string_lit4)) (and (not (= string_lit2 string_lit5)) (and (not (= string_lit2 string_lit6)) (and (not (= string_lit3 string_lit4)) (and (not (= string_lit3 string_lit5)) (and (not (= string_lit3 string_lit6)) (and (not (= string_lit4 string_lit5)) (and (not (= string_lit4 string_lit6)) (and (not (= string_lit5 string_lit6)) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit5) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit6) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit1) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit4) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit2) (and (DIRTY_WORD_CHECK_IdempotentFn_ext string_lit3) (and (DIRTY_WORD_CHECK_IdempotentFn_ext (attach_name v3)) (not (attachResult_StableFn_ext (attachResult_Audit audit_Unknown_Object_Type)))))))))))))))))))))))))))))))
(check-sat)
(pop)

; 15
(push)
(assert (and (is-attachList_nil v4) (not (attachListResult_StableFn_ext (attachListResult_attachList v4)))))
(check-sat)
(pop)

; 16
(push)
(assert (and (attachResult_StableFn_ext (attach_GuardFn_ext (attachList_cons_recd_hd (destattachList_cons v4)))) (and (not (is-attachList_nil v4)) (and (is-attachResult_Audit (attach_GuardFn_ext (attachList_cons_recd_hd (destattachList_cons v4)))) (not (attachListResult_StableFn_ext (attachListResult_Audit (destattachResult_Audit (attach_GuardFn_ext (attachList_cons_recd_hd (destattachList_cons v4)))))))))))
(check-sat)
(pop)

; 17
(push)
(assert (and (attachListResult_StableFn_ext (attachList_GuardFn_ext (attachList_cons_recd_tl (destattachList_cons v4)))) (and (attachResult_StableFn_ext (attach_GuardFn_ext (attachList_cons_recd_hd (destattachList_cons v4)))) (and (not (is-attachList_nil v4)) (and (not (is-attachResult_Audit (attach_GuardFn_ext (attachList_cons_recd_hd (destattachList_cons v4))))) (and (not (is-attachListResult_Audit (attachList_GuardFn_ext (attachList_cons_recd_tl (destattachList_cons v4))))) (not (attachListResult_StableFn_ext (attachListResult_attachList (attachList_cons (attachList_cons_recd (destattachResult_Attach (attach_GuardFn_ext (attachList_cons_recd_hd (destattachList_cons v4)))) (destattachListResult_attachList (attachList_GuardFn_ext (attachList_cons_recd_tl (destattachList_cons v4)))))))))))))))
(check-sat)
(pop)