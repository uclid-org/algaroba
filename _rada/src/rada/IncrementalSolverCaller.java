/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.lang.Process;
import java.lang.ProcessBuilder.Redirect;
import java.util.List;


public class IncrementalSolverCaller {
  private String solver;  
  private int obligationId;
  private int tempFileId;
  Process process;
  private BufferedWriter inputToSolver;
  private BufferedReader outputFromSolver;
  private StringBuffer allSmt2Content;
   
  public IncrementalSolverCaller(String s, int id) throws Exception {
    solver = s;
    obligationId = id;
    tempFileId = 1;
    try {
      process = new ProcessBuilder()
        .redirectInput(Redirect.PIPE)
        .redirectOutput(Redirect.PIPE)
        .redirectError(Redirect.PIPE)
        .command(getCmd(solver))
        .start();
      inputToSolver = new BufferedWriter(
          new OutputStreamWriter(process.getOutputStream()));
      outputFromSolver = new BufferedReader(
          new InputStreamReader(process.getInputStream()));
      allSmt2Content = new StringBuffer();
    } catch (Exception e) {
      throw new Exception("Cannot initialize SMT solvers. Details: " + e.getMessage());
    }
  }
  
  /**
   * Gets the command to run the SMT solver.
   */  
  private List<String> getCmd(String solver) {
    if (Util.isCVC4(solver)) {
      return Constant.CVC4_CMD;
    } else { // z3
      return Constant.Z3_CMD;
    }
  }
  
  /**
   * Checks if a line we received from the SMT solver is the end of a stream
   * of results that the solver sent us. 
   */
  private boolean isEndOfStream(String line) {
    return line == null
        || line.equals(Constant.END_OF_STREAM)        // for Z3
        || line.equals(Constant.QUOTE_END_OF_STREAM); // for CVC4
  }
  
  
  private void showTempFiles(String incrementalContent, ResultType resultType, SolverParameters parms) {
    if (parms.showTempFiles) {
      allSmt2Content.append(incrementalContent);
      try {
        File tempSmt2File = writeToTempFile(allSmt2Content.toString());
        System.out.println("TempFile: " + tempSmt2File.getPath() + " -> " + resultType);
      } catch (Exception e) {
        System.out.println(e.getMessage());
      }
    }
  }
  
  /**
   * Sends the content to the solver and reads the result from the solver. 
   */
  public SolverResult appendContent(String incrementalContent,
      SolverParameters parms) throws Exception {
    try {
      inputToSolver.write(incrementalContent);
      inputToSolver.write(Util.makeEcho(Constant.END_OF_STREAM));
      inputToSolver.newLine();
      inputToSolver.flush();
      
      // If the solver is terminating, we do not need to wait for the output.
      if (incrementalContent.equals(Util.makeExit())) { //TODO: Revise. Use constant.
        return null;
      }
     
      // Read the result from the solver.
      // The output stream will end with Constant.END_OF_STREAM.
      StringBuffer rawResult = new StringBuffer();
      ResultType resultType = ResultType.ERROR;
      String line;
      while (!isEndOfStream(line = outputFromSolver.readLine())) {
        rawResult.append(line).append(Constant.NEWLINE);
        if (line.equalsIgnoreCase(Constant.SAT)) {
          resultType = ResultType.SAT;
        } else if (line.equalsIgnoreCase(Constant.UNSAT)) {
          resultType = ResultType.UNSAT;
        } else if (line.equalsIgnoreCase(Constant.UNKNOWN)) {
          resultType = ResultType.UNKNOWN;
        }
      }
      showTempFiles(incrementalContent, resultType, parms);
      return new SolverResult(rawResult.toString(), resultType);
    } catch (IOException e) {
      throw new Exception("Cannot feeding content to SMT solvers. Details: " + e.getMessage());
    }    
  }
    
  /**
   * Terminates the incremental solver and releases all the resources.
   */
  public void terminate() throws Exception {
    try {
      // Send an (exit) command to the SMT solver. This might be unnecessary.
      appendContent(Util.makeExit(), null);  
      
      // Terminate the SMT solver process.
      process.destroy();

      // Close inputToSolver and outputFromSolver
      inputToSolver.close();
      outputFromSolver.close();
    } catch (Exception e) {
      throw new Exception("Cannot terminate solver. Detail: " + e.getMessage());
    }
  }
  
  /**
   * Increases the id of temporary files by 1.
   */
  private void increaseTempFileId() {
    tempFileId += 1;
  }

  /**
   * Creates a new temporary .smt file in a system temporary folder.
   */
  private File createTempFile() throws IOException{
    String prefix = Constant.TEMPFILENAME + "_" + "obligation" + Integer.toString(obligationId) + "_" + "tempfile" + Integer.toString(tempFileId) + "_";
    String suffix = Constant.TEMPFILEEXT;
    File tempFile = File.createTempFile(prefix, suffix);
    increaseTempFileId();    
    return tempFile;
  }
  
  /**
   * Writes the content of a given string to a temporary file and returns
   * the path of the file.
   */
  private File writeToTempFile(String content) throws Exception {
    File tempFile = null;
    try {
      tempFile = createTempFile();
      PrintWriter out = new PrintWriter(tempFile);
      out.write(content);
      out.close();
    } catch (IOException e) {
      throw new Exception("I/O Error: Cannot create temporary file. " + 
                          e.getMessage());
    }
    return tempFile;
  }
}
