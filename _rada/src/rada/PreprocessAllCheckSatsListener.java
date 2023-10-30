/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.ArrayList;
import java.util.List;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.TokenStreamRewriter;

import rada.RadaGrammarParser.CommandCheckSatContext;


public class PreprocessAllCheckSatsListener extends RadaGrammarBaseListener {
  private List<CommandCheckSatContext> checkSatContexts;
  private TokenStreamRewriter rewriter;
  
  public PreprocessAllCheckSatsListener(TokenStream tokens) {
    rewriter = new TokenStreamRewriter(tokens);
    checkSatContexts = new ArrayList<CommandCheckSatContext>();
  }
  
  public TokenStreamRewriter getRewriter() {
    return rewriter;
  }
  
  public List<CommandCheckSatContext> getCheckSatContexts() {
    return checkSatContexts;
  }
  
  public void exitCommandCheckSat(CommandCheckSatContext ctx) {
    checkSatContexts.add(ctx);
  }
}