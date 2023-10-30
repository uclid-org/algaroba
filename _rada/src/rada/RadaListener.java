/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.TokenStreamRewriter;
import org.antlr.v4.runtime.RuleContext;
import rada.RadaGrammarParser.CatamorphismContext;
import rada.RadaGrammarParser.CommandCheckSatContext;
import rada.RadaGrammarParser.DefineCatamorphismContext;
import rada.RadaGrammarParser.MainProgramContext;
import rada.RadaGrammarParser.TermQualIdTermContext;


public class RadaListener extends RadaGrammarBaseListener {
  private Map<String, Catamorphism> catMap;
  private List<CatamorphismApp> catApps;  
  private TokenStreamRewriter rewriter;
  private Token checkSatStartToken;
  private Token programStopToken;
  private MyVisitor visitor;
  
  public RadaListener(TokenStream tokens) {
    rewriter = new TokenStreamRewriter(tokens);
    catMap = new HashMap<String, Catamorphism>();
    catApps = new ArrayList<CatamorphismApp>();
    checkSatStartToken = null;
    programStopToken = null;
    visitor = new MyVisitor();
  }
  
  public TokenStreamRewriter getRewriter() {
    return rewriter;
  }
  
  public Map<String, Catamorphism> getCatmap() {
    return catMap;
  }
  
  public List<CatamorphismApp> getCatApps() {
    return catApps;
  }
  
  public Token getCheckSatStartToken() {
    return checkSatStartToken;
  }
  
  public Token getProgramStopToken() {
    return programStopToken;
  }
  
//  public String printParseTree(ParseTree tree) {
//    if (tree.getChildCount() == 0) {
//      return tree.getText();
//    }
//    else {
//      String res = "";
//      for (int i = 0; i < tree.getChildCount(); i++) {
//        res += printParseTree(tree.getChild(i)) + " ";
//      }
//      return res;
//    }
//  }
//  
//  public String printContext(RuleContext ctx) {        
//    if (ctx.getChildCount() == 0) {
//      return ctx.getText();
//    }
//    else {
//      String res = "";
//      for (int i = 0; i < ctx.getChildCount(); i++) {
//        res += printParseTree(ctx.getChild(i));
//      }
//      return res;
//    }    
//  }
   
    public boolean isCatamorphism(String id) {
    return catMap.containsKey(id);
  }
   
  public void exitDefineCatamorphism(DefineCatamorphismContext ctx) {
    CatamorphismContext cataCtx = ctx.catamorphism(); 
    String name = cataCtx.symbol().getText();
//    String formalArg = cataCtx.parameter().symbol().getText();
//    String inputSort = cataCtx.parameter().sort().getText();
//    String outputSort = cataCtx.sort().getText(); // need to fix here
    List<Argument> formalArgs = new ArrayList<Argument>();
    for (int i = 0; i < cataCtx.parameter().size(); i++) {
      String argSymbol = visitor.visit(cataCtx.parameter().get(i).symbol());
      String argSort   = visitor.visit(cataCtx.parameter().get(i).sort());
      formalArgs.add(new Argument(argSymbol, argSort));
    }
    String outputSort = visitor.visit(cataCtx.sort());
    String body = visitor.visit(cataCtx.catbody());
    
    String postCond = null;
    if (cataCtx.postcond() != null) {
      postCond = visitor.visit(cataCtx.postcond());
    }
  
    Catamorphism cat = 
        new Catamorphism(name, formalArgs, outputSort, body, postCond);    
    if (!catMap.containsKey(name)) {
      catMap.put(name, cat);
      String declareFunCat = 
          Util.makeDeclareFunCat(name, formalArgs, outputSort);
      rewriter.replace(ctx.start, ctx.stop, declareFunCat);
    }     
  }    
  
  // Checks if ctx is in a define-catamorphism or not
  public boolean isInCatamorphismDef(RuleContext ctx) {
    if (ctx.getChildCount() >= 2 && 
        ctx.getChild(0).getText().equals(Constant.LPAREN) &&
        ctx.getChild(1).getText().equals(Constant.DEFINECATA)) {
      return true;
    }
    if (ctx.parent == null) {
      return false;
    }
    return isInCatamorphismDef(ctx.parent);
  }
  
  public void exitTermQualIdTerm(TermQualIdTermContext ctx) {
    if (isCatamorphism(ctx.qualidentifier().getText())) {
      // Extract a catamorphism call that is not in the definition of any
      // catamorphisms. This call should be in an assert statement. Add all
      // such calls to catApps, which contains all catamorphism calls that 
      // appear in assert statements.
      Catamorphism catamorphism = catMap.get(ctx.qualidentifier().getText());
      List<String> actualTerms = new ArrayList<String>();
      for (int i = 0; i < ctx.term().size(); i++) {
        actualTerms.add(visitor.visit(ctx.term(i)));
      }
      CatamorphismApp catApp = new CatamorphismApp(catamorphism, actualTerms);
      // if catApps has not had catApp, we insert catApp to catApps.
      // catApp must not be in the definition of a catamorphism
      if (!catApps.contains(catApp) && 
          !isInCatamorphismDef(ctx.parent)) {
        catApps.add(catApp);
      }
    }
  }
  
  public void exitCommandCheckSat(CommandCheckSatContext ctx) {
    if (checkSatStartToken == null) {
      checkSatStartToken = ctx.start;
    }
  }
  
  public void exitMainProgram(MainProgramContext ctx) {
    programStopToken = ctx.stop;
  }
}