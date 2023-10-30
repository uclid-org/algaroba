/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.TokenStreamRewriter;

import rada.RadaGrammarParser.CommandCheckSatContext;
import rada.RadaGrammarParser.MainProgramContext;


public class PreprocessFirstCheckSatsListener extends RadaGrammarBaseListener {
  private Token checkSatStartToken;
  private Token programStopToken;
  private TokenStreamRewriter rewriter;
  
  public PreprocessFirstCheckSatsListener(TokenStream tokens) {
    rewriter = new TokenStreamRewriter(tokens);
    checkSatStartToken = null;
    programStopToken = null;
  }
  
  public TokenStreamRewriter getRewriter() {
    return rewriter;
  }
  
  public Token getCheckSatStartToken() {
    return checkSatStartToken;
  }
  
  public Token getProgramStopToken() {
    return programStopToken;
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