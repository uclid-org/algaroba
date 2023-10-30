//
// This file is part of the RADA prototype.
//
// Copyright (C) 2013 University of Minnesota 
// See file COPYING in the top-level source directory for licensing information 
//

//
// Parts of of the grammar were adapted from the grammars in
//  (1) The OCaml parser for SMT-LIB format version 2.0
//      (http://homepage.cs.uiowa.edu/~astump/software/ocaml-smt2.zip)
//  (2) CVC4 (http://cvc4.cs.nyu.edu/web/)
//

 
grammar RadaGrammar;

@header
{
package rada;
}

// PARSER

program : command*                                                     # mainProgram;

command 
  : LPAREN SETLOGIC symbol RPAREN                                      # commandSetLogic
  | LPAREN SETOPTION an_option RPAREN                                  # commandSetOption
  | LPAREN SETINFO attribute RPAREN                                    # commandSetInfo
  | LPAREN DECLARESORT symbol NUMERAL RPAREN                           # commandDeclareSort
  | LPAREN DEFINESORT symbol LPAREN symbol* RPAREN sort RPAREN         # commandDefineSort
  | LPAREN DECLAREFUN symbol LPAREN sort* RPAREN sort RPAREN           # commandDeclareFun
  | LPAREN DEFINEFUN symbol LPAREN sortedvar* RPAREN sort term RPAREN  # commandDefineFun
  | LPAREN PUSH NUMERAL? RPAREN                                        # commandPush
  | LPAREN POP NUMERAL? RPAREN                                         # commandPop
  | LPAREN ASSERT term RPAREN                                          # commandAssert
  | LPAREN CHECKSAT RPAREN                                             # commandCheckSat
  | LPAREN GETASSERT RPAREN                                            # commandGetAssert
  | LPAREN GETPROOF RPAREN                                             # commandGetProof
  | LPAREN GETUNSATCORE RPAREN                                         # commandGetUnsatCore
  | LPAREN GETVALUE LPAREN term+ RPAREN RPAREN                         # commandGetValue
  | LPAREN GETASSIGN RPAREN                                            # commandGetAssign
  | LPAREN GETOPTION KEYWORD RPAREN                                    # commandGetOption
  | LPAREN GETINFO infoflag RPAREN                                     # commandGetInfo
  | LPAREN EXIT RPAREN                                                 # commandExit
  | LPAREN DECLAREDTYPES LPAREN symbol* RPAREN
                         LPAREN datatype+ RPAREN RPAREN                # declareDatatypes
  | LPAREN DEFINECATA catamorphism RPAREN                              # defineCatamorphism
  ;
  
datatype : LPAREN symbol dtypebranch+ RPAREN;
dtypebranch: LPAREN symbol parameter* RPAREN;
parameter: LPAREN symbol sort RPAREN;

catamorphism: symbol LPAREN parameter+ RPAREN sort catbody postcond?;

catbody: term;

postcond: POSTCOND term;


symbol
  : SYMBOL                                                  # normalSymbol
  | ASCIIWOR                                                # symbolWithOr;

varbinding : LPAREN symbol term RPAREN                      # varBindingSymTerm;

sort
  : identifier                                              # sortIdentifier
  | LPAREN identifier sort+ RPAREN                          # sortIdSortMulti;

sortedvar : LPAREN symbol sort RPAREN                       # sortedVarSymSort;

term
  : specconstant                                            # termSpecConst
  | qualidentifier                                          # termQualIdentifier
  | LPAREN qualidentifier term+ RPAREN                      # termQualIdTerm
  | LPAREN LET LPAREN varbinding+ RPAREN term RPAREN        # termLetTerm
  | LPAREN FORALL LPAREN sortedvar+ RPAREN term RPAREN      # termForAllTerm
  | LPAREN EXISTS LPAREN sortedvar+ RPAREN term RPAREN      # termExistsTerm
  | LPAREN EXCLIMATIONPT term attribute+ RPAREN             # termExclimationPt;

qualidentifier
  : identifier                                              # qualIdentifierId
  | LPAREN AS identifier sort RPAREN                        # qualIdentifierAs;

identifier
  : symbol                                                  # idSymbol
  | LPAREN UNDERSCORE symbol NUMERAL+ RPAREN                # idUnderscoreSymNum;

infoflag : KEYWORD                                          # infoFlagKeyword;

an_option : attribute                                       # anOptionAttribute;

attribute
  : KEYWORD                                                 # attributeKeyword
  | KEYWORD attributevalue                                  # attributeKeywordValue;

attributevalue
  : specconstant                                            # attributeValSpecConst
  | symbol                                                  # attributeValSymbol
  | LPAREN sexpr* RPAREN                                    # attributeValSexpr;

sexpr
  : specconstant                                            # sexprSpecConst
  | symbol                                                  # sexprSymbol
  | KEYWORD                                                 # sexprKeyword
  | LPAREN sexpr* RPAREN                                    # sexprInParen;

specconstant
  : DECIMAL                                                 # specConstsDec
  | NUMERAL                                                 # specConstNum
  | STRINGLIT                                               # specConstString
  | HEXADECIMAL                                             # specConstsHex
  | BINARY                                                  # specConstsBinary;

// LEXER

UNDERSCORE : '_';
LPAREN : '(';
RPAREN : ')';
AS : 'as';
LET : 'let';
FORALL : 'forall';
EXISTS : 'exists';
EXCLIMATIONPT : '!';
SETLOGIC : 'set-logic';
SETOPTION : 'set-option';
SETINFO : 'set-info';
DECLARESORT : 'declare-sort';
DEFINESORT : 'define-sort';
DECLAREFUN : 'declare-fun';
DEFINEFUN : 'define-fun';
PUSH : 'push';
POP : 'pop';
ASSERT : 'assert';
CHECKSAT : 'check-sat';
GETASSERT : 'get-assertions';
GETPROOF : 'get-proof';
GETUNSATCORE : 'get-unsat-core';
GETVALUE : 'get-value';
GETASSIGN : 'get-assignment';
GETOPTION : 'get-option';
GETINFO : 'get-info';
EXIT : 'exit';

DECLAREDTYPES : 'declare-datatypes';
DEFINECATA : 'define-catamorphism';
POSTCOND : ':post-cond';

WS : (' ' | '\t' | '\f' | '\r' | '\n')+ -> channel(HIDDEN) ;
COMMENT : ';' (~('\n' | '\r'))* -> channel(HIDDEN) ;

HEXADECIMAL : '#x' (ALPHA | DIGIT)+; //Done
BINARY : '#b' ('0' | '1')+; //Done
ASCIIWOR : '|' ~('|' | '\\')* '|'  ; //Done

KEYWORD : ':' (ALPHA | DIGIT | SYMBOL_CHAR)+ ;
  
fragment SYMBOL_CHAR_NOUNDERSCORE_NOATTRIBUTE
  : '+' | '-' | '/' | '*' | '=' | '%' | '?' | '.' | '$' | '~'
  | '&' | '^' | '<' | '>' | '@'
  ;

fragment SYMBOL_CHAR : SYMBOL_CHAR_NOUNDERSCORE_NOATTRIBUTE | '_' | '!' ;


SYMBOL
  : (ALPHA | SYMBOL_CHAR) (ALPHA | DIGIT | SYMBOL_CHAR)+
  | ALPHA
  | SYMBOL_CHAR_NOUNDERSCORE_NOATTRIBUTE
  ;
  
STRINGLIT : '"' (ESCAPE | ~('"'|'\\'))* '"' ;

// Matches an allowed escaped character.
fragment ESCAPE : '\\' ('"' | '\\');

NUMERAL : '0' | PDIGIT DIGIT*;
DECIMAL : ('0' | PDIGIT DIGIT*) '.' DIGIT+;


// Matches any letter ('a'-'z' and 'A'-'Z').
fragment ALPHA : 'a'..'z' | 'A'..'Z' ;

// Matches the positive digits (1-9)
fragment PDIGIT : '1'..'9';

// Matches the digits (0-9)
fragment DIGIT : '0' | PDIGIT;
