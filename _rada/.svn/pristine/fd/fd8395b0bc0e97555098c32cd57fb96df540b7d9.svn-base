/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.ArrayList;
import java.util.List;


public class RadaResult {
  // A list of results from solver, each result corresponds to a temporary SMT2 file.
  private List<SolverResult> solverResults;
  // Final result
  private ResultType type;
  // Number of unrollings
  private int numUnrollings;
  private String message;
  
  public RadaResult() {
    solverResults = new ArrayList<SolverResult>();
    type = ResultType.UNKNOWN;
    numUnrollings = 0;
    message = "";
  }
  
  public void addSolverResult(SolverResult sResult) {
    solverResults.add(sResult);
  }
  
  public List<SolverResult> getSolverResults() {
    return solverResults;
  }
   
  public ResultType getResultType() {
    return type;
  }
    
  public String getMessage() {
    return message;
  }
  
  public int getNumUnrollings() {
    return numUnrollings;
  }
  
  public void setResultType(ResultType t) {
    type = t;
  }
  
  public void setMessage(String m) {
    message = m;
  }
  
  public void setNumUnrollings(int num) {
    numUnrollings = num;
  }
  
  public void incNumUnrollings() {
    numUnrollings += 1;
  }
  
  public void setResultTypeAndMessage(ResultType t, String m) {
    type = t;
    message = m;
  }
  
  /**
   * Returns a list of results such that (1) the list contains only 1 result,
   * and (2) the result is an error message.
   */
  public static List<RadaResult> getErrorResults(String errorMessage) {
    List<RadaResult> radaResults = new ArrayList<RadaResult>();
    RadaResult errorResult = new RadaResult();
    errorResult.setResultTypeAndMessage(ResultType.ERROR, errorMessage);
    radaResults.add(errorResult);
    System.out.println("ERROR: " + errorMessage);
    return radaResults;
  }
}