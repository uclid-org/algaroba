/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class rada {
  
  
  /**
   * Prints a separator if there are multiple obligations.
   */  
  private static void printSeparator(int numObligations) {
    if (numObligations > 1) {
      System.out.println("======================");
    }
  }

  /**
   * Prints the number of obligations if there are multiple obligations.
   */
  private static void printNumObligations(int numObligations) {
    if (numObligations > 1) {
      System.out.println("Number of obligations: " + numObligations);
    }    
  }
 
  /**
   * Prints the total running time if there are multiple obligations.
   */
  private static void printTotalRunningTime(int numObligations, long startTimeAll) {    
    //if (numObligations > 1) 
    {
      System.out.println("Total time (s) = " + Util.getRunningTimeInSec(startTimeAll));
    }
  }
   
  //  /**
  //   * Prints the result from RADA.
  //   */
  //  private static void printResult(RadaResult result, long startTimeI) {
  //    System.out.println(result.getResultType());
  //    if (result.getResultType() == ResultType.ERROR && result.getMessage() != null) {
  //      System.out.println(result.getMessage());          
  //    }
  //    if (Config.VERBOSE) {
  //      // If in verbose mode, print some extra information.
  //      if (result.getResultType() != ResultType.ERROR) {
  //        System.out.println("Number of unrollings: " + result.getNumUnrollings());
  //      }
  //      printRunningTime(startTimeI);
  //    }
  //  }
  //  
  //  /**
  //   * Runs RADA.
  //   */
  //  private static void runRada(String filePath, String solverName) {        
  //    try {
  //      // Generate files corresponding to each check-sat
  //      List<String> obligationContents = 
  //          ObligationPreprocessor.processObligations(filePath);
  //      printNumObligations(obligationContents.size());
  //      long startTimeAll = System.currentTimeMillis();
  //      for (int i = 0; i < obligationContents.size(); i++) {
  //        printObligationIndex(obligationContents.size(), i + 1);
  //        long startTimeI = System.currentTimeMillis();
  //        UnrollingProcedure procedure = new UnrollingProcedure();;
  //        RadaResult result = procedure.checkSat(obligationContents.get(i),
  //            solverName, -1);
  //        printResult(result, startTimeI);
  //        printSeparator(obligationContents.size());
  //      }
  //      printTotalRunningTime(obligationContents.size(), startTimeAll);
  //    } catch (Exception e) {
  //      System.out.println("Error when preprocessing the input file.");
  //    }
  //  }
  
  /**
   * Prints the result from RADA.
   */
  private static void printResult(List<RadaResult> results, long startTimeAll, SolverParameters parms) {
    System.out.println("======================");
    System.out.println("======= SUMMARY ======");
    System.out.println("======================");
    for (int i = 0; i < results.size(); i++) {
      RadaResult result = results.get(i);
      System.out.println("Obligation #" + (i + 1) + " -> " + result.getResultType());
      if (result.getResultType() == ResultType.ERROR && result.getMessage() != null) {
        System.out.println(result.getMessage());          
      }
      if (parms.verbose > 0) {
        // If in verbose mode, print some extra information.
        if (result.getResultType() != ResultType.ERROR) {       
          System.out.println("Number of unrollings: " + result.getNumUnrollings());
          System.out.println("Number of generated temporary .smt2 files: " + result.getSolverResults().size());
        }
      }
      printSeparator(results.size());
    }
    printTotalRunningTime(results.size(), startTimeAll);
  }

  /**
   * Runs RADA.
   */
  public static List<RadaResult> run(SolverParameters parms) {
    if (!Util.programExists(parms.solverName)) {
      return RadaResult.getErrorResults("Solver " + parms.solverName + " is not in system path.");
    } else if (!Util.fileExists(parms.filePath)) {
      return RadaResult.getErrorResults("File " + parms.filePath + " does not exist.");
    }
    
    // Parameters seemed valid. Start the unrolling decision procedure.    
    List<RadaResult> radaResults = new ArrayList<RadaResult>();
    List<String> obligationContents = new ArrayList<String>();
    try {
      // Generate files corresponding to each check-sat
      obligationContents = ObligationPreprocessor.processObligations(parms.filePath);
    } catch (Exception e) {
      return RadaResult.getErrorResults(e.getMessage());
    }
    printNumObligations(obligationContents.size());
    long startTimeAll = System.currentTimeMillis();
//    for (int i = 0; i < obligationContents.size(); i++) {
//      printObligationIndex(obligationContents.size(), i + 1);
//      long startTimeI = System.currentTimeMillis();
//      UnrollingProcedure procedure = new UnrollingProcedure();;
//      RadaResult result = procedure.checkSat(obligationContents.get(i), parms);
//      procedure.terminateSolver();
//      radaResults.add(result);
//      if (result.getResultType() == ResultType.ERROR) {
//        // If we find an error during running time, we stop immediately.
//        // Also, we only store the error result.
//        radaResults = RadaResult.getErrorResults(result.getMessage());
//        System.out.println("Found an error. RADA is stopped!");
//        break;
//      } else {
//        printResult(result, startTimeI, parms);
//        printSeparator(obligationContents.size());
//      }
//    }
//    printTotalRunningTime(obligationContents.size(), startTimeAll);
    
    ExecutorService executor = Executors.newFixedThreadPool(parms.threadPoolSize);
    for (int obligationId = 0; obligationId < obligationContents.size(); obligationId++) {
      radaResults.add(null);
    }
    for (int obligationId = 0; obligationId < obligationContents.size(); obligationId++) {
      String obligationContent = obligationContents.get(obligationId);
      Runnable worker = new WorkerThread(obligationId, obligationContent, radaResults, parms);
      executor.execute(worker);
    }
    executor.shutdown();
    while (!executor.isTerminated()) {}
    printResult(radaResults, startTimeAll, parms);
    return radaResults;
  }

  public static void printUsage() {
    System.out.println("usage: rada [options] <input>");
    System.out.println(" --solver [z3 | cvc4]      change the underlying solver ");
    System.out.println(" --showTempFiles           causes temp file paths to be displayed ");
    System.out.println(" --depth <arg>             changes the maximum unrolling depth to <arg> ");
    System.out.println(" --help                    print this message");
    System.out.println(" --timeout <arg>           maximum runtime in seconds");
    System.out.println(" --verbose <arg>           set verbosity level (default: 0)\n");
  }
  
  private static void parseArgs(String[] args, SolverParameters parms) throws Exception {
    int i = 0; 
    while (i < (args.length - 1)) {
      if (args[i].equals("--solver") || args[i].equals("-s")) {
        parms.solverName = args[i+1];
        i = i + 2;
      } else if (args[i].equals("--showTempFiles") || args[i].equals("-st")) {
        parms.showTempFiles = true;
        i = i + 1;
      } else if (args[i].equals("--help") || args[i].equals("-h")) {
        printUsage();
        i = i + 1;
      } else if (args[i].equals("--timeout") || args[i].equals("-to")) {
        parms.timeout = Integer.parseInt(args[i+1]);
        i = i + 2; 
      } else if (args[i].equals("--depth") || args[i].equals("-d")) {
        parms.maxDepth = Integer.parseInt(args[i+1]);
        i = i + 2;
      } else if (args[i].equals("--verbose") || args[i].equals("-v")) {
        parms.verbose = Integer.parseInt(args[i+1]);
        i = i + 2; 
      } else  {
        System.out.println("Argument: " + args[i] + " not understood.");
        printUsage();
        throw new Exception("Bad Argument");
      }
    }
    if (i >= args.length) {
      printUsage();
      throw new Exception("No input file specified");
    }
    parms.filePath = args[i];
  }
  
  public static void main(String[] args) throws Exception {
    SolverParameters parms = new SolverParameters(); 
    parseArgs(args, parms); 
    run(parms);
  }
}
