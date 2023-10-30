/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class ObligationPreprocessorTest {
  final String filePathPushPop01 = "test/pushpop01.rada";
  final String filePathPushPop02 = "test/pushpop02.rada";

  @BeforeClass
  public static void setUpBeforeClass() throws Exception {
  }

  @AfterClass
  public static void tearDownAfterClass() throws Exception {
  }

  @Before
  public void setUp() throws Exception {
  }

  @After
  public void tearDown() throws Exception {
  }

  /*
   * Removes all redundant characters, including whitespaces and line breaks.
   */
  private static String removeRedundantChars(String s) {
    return s.replaceAll("\\s", "");
  }
  
  @Test
  public void testProcessObligationsPushPop01() {
    List<String> contents = new ArrayList<String>();
    try {
       contents = ObligationPreprocessor.processObligations(filePathPushPop01);      
    }
    catch (Exception e) {
    }
    assertEquals(contents.size(), 4);
    assertEquals(
        removeRedundantChars(contents.get(0)),
        removeRedundantChars(
            "(push)" + 
            "(assert (= 1 1))"));
    assertEquals(
        removeRedundantChars(contents.get(1)),
        removeRedundantChars(
            "(assert true)" +
            "(push)" +
            "(assert (= 2 2))"));
    assertEquals(
        removeRedundantChars(contents.get(2)),
        removeRedundantChars(
            "(assert true)" +
            "(assert false)" +
            "(push)" +
            "(assert (= 3 3))"));
    assertEquals(
        removeRedundantChars(contents.get(3)),
        removeRedundantChars(
            "(assert true)" +
            "(assert false)" +
            "(assert true)" +
            "(push)" +
            "(assert (= 4 4))"));
  }
  
  @Test
  public void testProcessObligationsPushPop02() {
    // This test involves nested instances of push-pop.
    List<String> contents = new ArrayList<String>();
    try {
       contents = ObligationPreprocessor.processObligations(filePathPushPop02);      
    }
    catch (Exception e) {
    }
    assertEquals(contents.size(), 4);
    assertEquals(
        removeRedundantChars(contents.get(0)),
        removeRedundantChars(
            "(push)" +
            "(push)" +
            "(push)" +
            "(push)" +
            "(assert (= 1 1))"));    
    assertEquals(
        removeRedundantChars(contents.get(1)),
        removeRedundantChars(
            "(push)" +
            "(push)" +
            "(push)" +          
            "(assert true)" +
            "(assert (= 2 2))"));
    assertEquals(
        removeRedundantChars(contents.get(2)),
        removeRedundantChars(
            "(push)" +
            "(push)" +        
            "(assert false)" +
            "(assert (= 3 3))"));
    assertEquals(
        removeRedundantChars(contents.get(3)),
        removeRedundantChars(
            "(push)" +
            "(assert true)" +
            "(assert (= 4 4))"));
  }
}
