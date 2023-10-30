/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import rada.RadaGrammarParser.*;


public class MyVisitor extends RadaGrammarBaseVisitor<String> {
  
  @Override
  public String visitCatbody(CatbodyContext ctx) {    
    return visit(ctx.term());
  }
  
  // Symbol - Begin
  @Override
  public String visitNormalSymbol(NormalSymbolContext ctx) {
    return ctx.getText();
  }
  
  @Override
  public String visitSymbolWithOr(SymbolWithOrContext ctx) {
    return ctx.getText();
  }
  // Symbol - End
  
  
  // Varbinding - Begin
  @Override
  public String visitVarBindingSymTerm(VarBindingSymTermContext ctx) {
    return Util.joinStringsWithSpaceSeparator(Arrays.asList(
        ctx.LPAREN().getText(),
        visit(ctx.symbol()),
        visit(ctx.term()),
        ctx.RPAREN().getText()));
  }
  // Varbinding - End
  
  
  // Sort - Begin  
  @Override
  public String visitSortIdentifier(SortIdentifierContext ctx) {
    return visit(ctx.identifier());
  }
  
  @Override
  public String visitSortIdSortMulti(SortIdSortMultiContext ctx) {
    List<String> l = new ArrayList<String>();
    l.add(ctx.LPAREN().getText());
    l.add(visit(ctx.identifier()));    
    for (int i = 0; i < ctx.sort().size(); i++) {
      l.add(visit(ctx.sort(i)));
    }
    l.add(ctx.RPAREN().getText());
    return Util.joinStringsWithSpaceSeparator(l);
  }    
  // Sort - End
  
  // Term - Begin
  @Override
  public String visitTermSpecConst(TermSpecConstContext ctx) {
    return visit(ctx.specconstant());
  }
  
  @Override
  public String visitTermQualIdentifier(TermQualIdentifierContext ctx) {
    return visit(ctx.qualidentifier());
  }
    
  @Override
  public String visitTermQualIdTerm(TermQualIdTermContext ctx) {
    List<String> l = new ArrayList<String>();
    l.add(ctx.LPAREN().getText());
    l.add(visit(ctx.qualidentifier()));
    for (int i = 0; i < ctx.term().size(); i++) {
      l.add(visit(ctx.term(i)));
    }
    l.add(ctx.RPAREN().getText());
    return Util.joinStringsWithSpaceSeparator(l);
  }
  
  @Override
  public String visitTermLetTerm(TermLetTermContext ctx) {
    List<String> l = new ArrayList<String>();    
    l.add(ctx.LPAREN(0).getText());
    l.add(ctx.LET().getText());
    l.add(ctx.LPAREN(1).getText());
    for (int i = 0; i < ctx.varbinding().size(); i++) {
      l.add(visit(ctx.varbinding(i)));
    }
    l.add(ctx.RPAREN(0).getText());
    l.add(visit(ctx.term()));
    l.add(ctx.RPAREN(1).getText());  
    return Util.joinStringsWithSpaceSeparator(l);
  }
  
  @Override
  public String visitTermForAllTerm(TermForAllTermContext ctx) {
    List<String> l = new ArrayList<String>();
    l.add(ctx.LPAREN(0).getText());
    l.add(ctx.FORALL().getText());
    l.add(ctx.LPAREN(1).getText());
    for (int i = 0; i < ctx.sortedvar().size(); i++) {
      l.add(visit(ctx.sortedvar(i)));
    }
    l.add(ctx.RPAREN(0).getText());
    l.add(visit(ctx.term()));
    l.add(ctx.RPAREN(1).getText());
    return Util.joinStringsWithSpaceSeparator(l);    
  }
  
  @Override
  public String visitTermExistsTerm(TermExistsTermContext ctx) {
    List<String> l = new ArrayList<String>();
    l.add(ctx.LPAREN(0).getText());
    l.add(ctx.EXISTS().getText());
    l.add(ctx.LPAREN(1).getText());       
    for (int i = 0; i < ctx.sortedvar().size(); i++) {
      l.add(visit(ctx.sortedvar(i)));
    }
    l.add(ctx.RPAREN(0).getText());
    l.add(visit(ctx.term()));
    l.add(ctx.RPAREN(1).getText());
    return Util.joinStringsWithSpaceSeparator(l);
  }
  
  @Override
  public String visitTermExclimationPt(TermExclimationPtContext ctx) {
    List<String> l = new ArrayList<String>();
    l.add(ctx.LPAREN().getText());
    l.add(ctx.EXCLIMATIONPT().getText());
    l.add(visit(ctx.term()));
    for (int i = 0; i < ctx.attribute().size(); i++) {
      l.add(visit(ctx.attribute(i)));
    }
    l.add(ctx.RPAREN().getText());
    return Util.joinStringsWithSpaceSeparator(l);
  }
  // Term - End
  
  
  // Qualidentifier - Begin
  @Override
  public String visitQualIdentifierId(QualIdentifierIdContext ctx) {
    return visit(ctx.identifier());
  }
  
  @Override
  public String visitQualIdentifierAs(QualIdentifierAsContext ctx) {
    return Util.joinStringsWithSpaceSeparator(Arrays.asList(
        ctx.LPAREN().getText(),
        ctx.AS().getText(),
        visit(ctx.identifier()),
        visit(ctx.sort()),
        ctx.RPAREN().getText()));
  }
  // Qualidentifier - End
  

  // Identifier - Begin
  @Override
  public String visitIdSymbol(IdSymbolContext ctx) {
    return visit(ctx.symbol());
  }
  
  @Override
  public String visitIdUnderscoreSymNum(IdUnderscoreSymNumContext ctx) {
    List<String> l = new ArrayList<String>();
    l.add(ctx.LPAREN().getText());
    l.add(ctx.UNDERSCORE().getText());
    l.add(visit(ctx.symbol()));    
    for (int i = 0; i < ctx.NUMERAL().size(); i++) {
      l.add(ctx.NUMERAL(i).getText());
    }
    l.add(ctx.RPAREN().getText());       
    return Util.joinStringsWithSpaceSeparator(l);
  }
  // Identifier - End
  
  // Infoflag - Begin
  @Override
  public String visitInfoFlagKeyword(InfoFlagKeywordContext ctx) {
    return ctx.KEYWORD().getText();
  }
  // Infoflag - End
  

  // an_option - Begin
  @Override
  public String visitAnOptionAttribute(AnOptionAttributeContext ctx) {
    return visit(ctx.attribute());
  }
  // an_option - End
  
  // Attribute - Begin
  @Override
  public String visitAttributeKeyword(AttributeKeywordContext ctx) {
    return ctx.KEYWORD().getText();
  }
  
  @Override
  public String visitAttributeKeywordValue(AttributeKeywordValueContext ctx) {
    return Util.joinStringsWithSpaceSeparator(Arrays.asList(
        ctx.KEYWORD().getText(), 
        visit(ctx.attributevalue())));
  }  
  // Attribute - End
  
  
  // Attributevalue - Begin
  @Override
  public String visitAttributeValSpecConst(AttributeValSpecConstContext ctx) {
    return visit(ctx.specconstant());    
  }
  
  @Override
  public String visitAttributeValSymbol(AttributeValSymbolContext ctx) {
    return visit(ctx.symbol());
  }
  
  @Override
  public String visitAttributeValSexpr(AttributeValSexprContext ctx) {
    List<String> l = new ArrayList<String>();    
    l.add(ctx.LPAREN().getText());
    for (int i = 0; i < ctx.sexpr().size(); i++) {
      l.add(visit(ctx.sexpr(i)));
    }
    l.add(ctx.RPAREN().getText());
    return Util.joinStringsWithSpaceSeparator(l);    
  }        
  // Attributevalue - End
  
  
  // sexpr - Begin
  @Override
  public String visitSexprSpecConst(SexprSpecConstContext ctx) {
    return visit(ctx.specconstant());
  }
  
  @Override
  public String visitSexprSymbol(SexprSymbolContext ctx) {
    return visit(ctx.symbol());
  }
  
  @Override
  public String visitSexprKeyword(SexprKeywordContext ctx) {
    return ctx.KEYWORD().getText();
  }
  
  @Override
  public String visitSexprInParen(SexprInParenContext ctx) {
    List<String> l = new ArrayList<String>();
    l.add(ctx.LPAREN().getText());    
    for (int i = 0; i < ctx.sexpr().size(); i++) {
      l.add(visit(ctx.sexpr(i)));
    }
    l.add(ctx.RPAREN().getText());
    return Util.joinStringsWithSpaceSeparator(l);    
  }            
  // sexpr - End

  
  // specconstant - Begin
  @Override
  public String visitSpecConstsDec(SpecConstsDecContext ctx) {
    return ctx.getText();
  }
  
  @Override
  public String visitSpecConstNum(SpecConstNumContext ctx) {
    return ctx.getText();
  }  
  
  @Override
  public String visitSpecConstString(SpecConstStringContext ctx) {
    return ctx.getText();
  }
  
  @Override
  public String visitSpecConstsHex(SpecConstsHexContext ctx) {
    return ctx.getText();
  }
  
  @Override
  public String visitSpecConstsBinary(SpecConstsBinaryContext ctx) {
    return ctx.getText();
  }
  // specconstant - End    
}