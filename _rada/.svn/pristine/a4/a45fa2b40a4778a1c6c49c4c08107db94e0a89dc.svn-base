/*
 * This file is part of the RADA prototype.
 * 
 * Copyright (C) 2013 University of Minnesota 
 * See file COPYING in the top-level source directory for licensing information 
 */

package rada;

import java.util.List;

public class WorkerThread implements Runnable {
  private int obligationId;
  private String obligationContent;
  private SolverParameters parms;
  private List<RadaResult> radaResults;
  
  public WorkerThread(int obligationId, String obligationContent,
      List<RadaResult> radaResults, SolverParameters parms) {
    this.obligationId = obligationId;
    this.obligationContent = obligationContent;
    this.parms = parms;
    this.radaResults = radaResults;
  }

  @Override
  public void run() {
    System.out.println("** Start working on obligation #" + (obligationId + 1));
    long startTime = System.currentTimeMillis();
    UnrollingProcedure procedure = new UnrollingProcedure(obligationId);
    RadaResult result = procedure.checkSat(obligationContent, parms);
    procedure.terminateSolver();
    radaResults.set(obligationId, result);
//    if (result.getResultType() == ResultType.ERROR) {
//      // If we find an error during running time, we stop immediately.
//      // Also, we only store the error result.
//      radaResults = RadaResult.getErrorResults(result.getMessage());
//      System.out.println("Found an error. RADA is stopped!");
//    }
    System.out.println("** Done obligation #" + (obligationId + 1)
        + ". Time(s) = " + Util.getRunningTimeInSec(startTime));
  }
}
