
computePerformance_Districting1 <- function(solution){
  
  source("R_functions/reading_output/performanceMetrics/Districting1/getIntraDistrictDistances_Districting1.R")
  source("R_functions/reading_output/performanceMetrics/Districting1/getWorkload_Districting1.R")
  source("R_functions/reading_output/performanceMetrics/Districting1/getVarAvgWorkload_Districting1.R")
  
  res <- c(
    
    IntraDistrictDistances = getIntraDistrictDistances_Districting1(solution),
    Workload = getWorkload_Districting1(solution),
    VarAvgWorkload = getVarAvgWorkload_Districting1(solution)
    
  )
  
  return(res)
  
}



