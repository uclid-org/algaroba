/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import rada.RadaGrammarParser.CommandCheckSatContext;

public class ObligationPreprocessor {
  
  /**
   * Processes the obligations in the input file and returns a list of string.
   * Each of the strings is the content of a .rada file corresponding to an
   * obligation (and only one obligation) in the input file.
   */
  public static List<String> processObligations(String inputFile) throws Exception {
    List<String> obligationContents = new ArrayList<String>();
    try {
      List<String> contentSeparateChecksats = new ArrayList<String> ();
      contentSeparateChecksats = separateChecksats(inputFile);
      for (String content0: contentSeparateChecksats) {
        String content1 = removeFromCheckSat(content0);
        String content2 = removePushPops(content1);
        obligationContents.add(content2);
      }
      return obligationContents;
    } catch (Exception e) {
      throw e;
    }
  }
  
  /**
   * Separates an input file with multiple check-sats to multiple inputs
   * by removing check-sat sequentially in a top-down fashion.
   * 
   * Example: Suppose the content of the input file is:
   *     (push)(assert (= 1 1))(check-sat)(pop)
   *     (push)(assert (= 2 2))(check-sat)(pop)
   *     (push)(assert (= 3 3))(check-sat)(pop)
   *    
   * The function will return the following strings: 
   *   First string:
   *     (push)(assert (= 1 1))(check-sat)(pop)
   *     (push)(assert (= 2 2))(check-sat)(pop)
   *     (push)(assert (= 3 3))(check-sat)(pop)
   *  Second string:
   *     (push)(assert (= 1 1))(pop)
   *     (push)(assert (= 2 2))(check-sat)(pop)
   *     (push)(assert (= 3 3))(check-sat)(pop)
   *  Third string:
   *     (push)(assert (= 1 1))(pop)
   *     (push)(assert (= 2 2))(pop)
   *     (push)(assert (= 3 3))(check-sat)(pop)
   */  
  public static List<String> separateChecksats(String inputFile) throws Exception {
    // Parse the input file   
    RadaGrammarLexer lexer = new RadaGrammarLexer(
        new ANTLRFileStream(inputFile));
    CommonTokenStream tokens = new CommonTokenStream(lexer);
    RadaGrammarParser parser = new RadaGrammarParser(tokens);
    ParseTree tree = parser.program();
    ParseTreeWalker walker = new ParseTreeWalker();
    PreprocessAllCheckSatsListener listener = new PreprocessAllCheckSatsListener(tokens);
    try {
      walker.walk(listener, tree);
    } catch (Exception e) {
      throw new Exception(e);
    }

    // Calculates the position of "check-sat" in the parse tree
    List<CommandCheckSatContext> checkSatContexts = listener.getCheckSatContexts();
    if (checkSatContexts.isEmpty()) {
      throw new Exception("There is no check-sat in the input file.");
    }
           
    List<String> contents = new ArrayList<String>();
    for (CommandCheckSatContext checkSatContext : checkSatContexts) {
      contents.add(listener.getRewriter().getText());

      // Remove the checkSatToken from the input stream
      listener.getRewriter().delete(checkSatContext.start, checkSatContext.stop);
    }    
    return contents;
  }
    
  /**
   * Removes all the contents from the beginning of the first check-sat.
   * 
   * Example: Suppose the content is as follows:
   *   (push)(assert (= 1 1))(pop)
   *   (push)(assert (= 2 2))(check-sat)(pop)
   *   (push)(assert (= 3 3))(check-sat)(pop)
   *   
   * This function will return the following:
   *   (push)(assert (= 1 1))(pop)
   *   (push)(assert (= 2 2))
   */
  public static String removeFromCheckSat(String content) throws Exception {
    // Parse the input file   
    RadaGrammarLexer lexer = new RadaGrammarLexer(new ANTLRInputStream(content));    
    CommonTokenStream tokens = new CommonTokenStream(lexer);
    RadaGrammarParser parser = new RadaGrammarParser(tokens);
    ParseTree tree = parser.program();  
    ParseTreeWalker walker = new ParseTreeWalker();
    PreprocessFirstCheckSatsListener listener = new PreprocessFirstCheckSatsListener(tokens);
    try {
      walker.walk(listener, tree);
    } catch (Exception e) {
      throw new Exception(e);
    }

    // Calculates the position of "check-sat" in the parse tree
    Token checkSatStartToken = listener.getCheckSatStartToken();
    if (checkSatStartToken == null) {
      throw new Exception("There is no check-sat in the input file.");
    }
        
    // Calculates the position of the last token in the parse tree
    Token programStopToken = listener.getProgramStopToken();
    
    // Ignore everything after check-sat
    listener.getRewriter().delete(checkSatStartToken, programStopToken);
    
    return listener.getRewriter().getText();
  }
  
  /**
   * Removes all the contents between each push and its corresponding pop
   * 
   * Example: Suppose the content is:
   *   (push)(assert (= 1 1))(pop)
   *   (push)(assert (= 2 2))(pop)
   *   (push)(assert (= 3 3))(check-sat)(pop)
   * 
   * The function will return the following:
   *   (push)(assert (= 3 3))   
   */
  public static String removePushPops(String content) throws Exception {
    // Parse the input file   
    RadaGrammarLexer lexer = new RadaGrammarLexer(new ANTLRInputStream(content));    
    CommonTokenStream tokens = new CommonTokenStream(lexer);
    RadaGrammarParser parser = new RadaGrammarParser(tokens);
    ParseTree tree = parser.program();  
    ParseTreeWalker walker = new ParseTreeWalker();
    PreprocessPushPopListener listener = new PreprocessPushPopListener(tokens);
    try {
      walker.walk(listener, tree);
    } catch (Exception e) {
      throw new Exception(e);
    }
    if (listener.getHasPushNumOrPopNum()) {
      throw new Exception("RADA does not support (push #num) or (pop #num)");
    }
    return listener.getRewriter().getText();
  }  
}