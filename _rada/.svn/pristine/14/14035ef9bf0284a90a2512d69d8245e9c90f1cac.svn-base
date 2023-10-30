/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.List;

import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.TokenStreamRewriter;
import rada.RadaGrammarParser.NormalSymbolContext;

public class SubstitutionListener extends RadaGrammarBaseListener { 
  private TokenStreamRewriter rewriter;
  private List<Argument> formalArgs;
  private List<String> actualTerms;
  
  public SubstitutionListener(TokenStream tokens, List<Argument> f, List<String> a) {
    rewriter = new TokenStreamRewriter(tokens);
    formalArgs = f;
    actualTerms = a;
  }
  
  public TokenStreamRewriter getRewriter() {
    return rewriter;
  }
  
  public void exitNormalSymbol(NormalSymbolContext ctx) {
    for (int i = 0; i < formalArgs.size(); i++) {
      if (formalArgs.get(i).getSymbol().equals(ctx.getText())) {
        rewriter.replace(ctx.start, ctx.stop, actualTerms.get(i));
        break;
      }
    }
  }
}