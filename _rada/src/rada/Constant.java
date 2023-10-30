/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;


public interface Constant {
  public static final String LPAREN = "(";
  public static final String RPAREN = ")";
  public static final String SPACE = " ";
  public static final String EQUAL = "=";
  public static final String NEWLINE = "\n";
  public static final String AND = "and";
  public static final String OR = "or";
  public static final String NOT = "not";
  public static final String ITE = "ite";
  public static final String ASSERT = "assert";
  public static final String DECLAREFUN = "declare-fun";
  public static final String DEFINEFUN = "define-fun";
  public static final String DEFINECATA = "define-catamorphism";  
  public static final String CHECKSAT = "check-sat";
  public static final String TEMPFILENAME = "rada";
  public static final String TEMPFILEEXT = ".smt2";
  public static final String SAT = "sat";
  public static final String UNSAT = "unsat";
  public static final String UNKNOWN = "unknown";
  public static final String ERROR = "error";
  public static final String CVC4 = "cvc4";
  public static final String CVC4_INCREMENTAL_MODE = "--incremental";
  
  public static final String BOOL = "Bool";
  
  public static final String GENERATED_CAT_DEFINE_FUN_SUFFIX = "_GeneratedCatDefineFun";
  public static final String GENERATED_UNROLL_DEFINE_FUN_SUFFIX = "_GeneratedUnrollDefineFun";
  
  public static final String EXIT = "exit";
  public static final String PUSH = "push";
  public static final String POP = "pop";
  public static final String ECHO = "echo";
  public static final String QUOTE = "\"";
  public static final String END_OF_STREAM = "GENERATED_END_OF_STREAM";
  public static final String QUOTE_END_OF_STREAM = QUOTE + "GENERATED_END_OF_STREAM" + QUOTE;
  
  public static final List<String> Z3_CMD = Collections.unmodifiableList(
      Arrays.asList(new String[] {"z3", "-in", "-smt2"}));
  public static final List<String> CVC4_CMD = Collections.unmodifiableList(
      Arrays.asList(new String[] {"cvc4", "--lang", "smt2", "--incremental"}));
}