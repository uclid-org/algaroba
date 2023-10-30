/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.Stack;

import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.TokenStreamRewriter;

import rada.RadaGrammarParser.CommandPopContext;
import rada.RadaGrammarParser.CommandPushContext;


public class PreprocessPushPopListener extends RadaGrammarBaseListener{
  private Stack<Token> pushStarts;
  private TokenStreamRewriter rewriter;
  private boolean hasPushNumOrPopNum;
  
  public PreprocessPushPopListener(TokenStream tokens) {
    rewriter = new TokenStreamRewriter(tokens);
    pushStarts = new Stack<Token>();
    hasPushNumOrPopNum = false;
  }
  
  public TokenStreamRewriter getRewriter() {
    return rewriter;
  }
  
  public boolean getHasPushNumOrPopNum() {
    return hasPushNumOrPopNum;
  }
 
  public void exitCommandPush(CommandPushContext ctx) {
    if (ctx.NUMERAL() != null) {
      hasPushNumOrPopNum = true; 
    }
    pushStarts.push(ctx.start);
  }
  
  public void exitCommandPop(CommandPopContext ctx) {
    if (ctx.NUMERAL() != null) {
      hasPushNumOrPopNum = true;
    }
    
    if (!pushStarts.isEmpty()) {

      // Get the matching Push
      Token pushStart = pushStarts.pop();
      
      // Delete everything between Push and Pop
      rewriter.delete(pushStart, ctx.stop);
    }
  }
}