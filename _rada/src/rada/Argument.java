/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

public class Argument {
  private String symbol;
  private String sort;
  
  public Argument(String mySymbol, String mySort) {
    symbol = mySymbol;
    sort = mySort;
  }
  
  public String getSymbol() {
    return symbol;
  }
  
  public String getSort() {
    return sort;
  }
  
  @Override public String toString() {
    return "(" + symbol + " " + sort + ")";
  }
}
