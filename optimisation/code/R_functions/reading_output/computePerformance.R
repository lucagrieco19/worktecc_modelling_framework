
computePerformance <- function(methID,sol){
  
  res <- c()
  
  if(methID=="Districting1"){
    source("R_functions/reading_output/performanceMetrics/computePerformance_Districting1.R")
    res <- computePerformance_Districting1(sol)
  }else if(methID=="WorkforceRolesANDHomeHealthCarePackages1"){
    source("R_functions/reading_output/performanceMetrics/computePerformance_WorkforceRolesANDHomeHealthCarePackages1.R")
    res <- computePerformance_WorkforceRolesANDHomeHealthCarePackages1(sol)
  }else if(methID=="TeamSizeAndComposition_heur"){
    source("R_functions/reading_output/performanceMetrics/computePerformance_TeamSizeAndComposition_heur.R")
    res <- computePerformance_TeamSizeAndComposition_heur(sol)
  }else if(methID=="RosteringANDAllocationANDScheduling1"){
    source("R_functions/reading_output/performanceMetrics/computePerformance_RosteringANDAllocationANDScheduling1.R")
    res <- computePerformance_RosteringANDAllocationANDScheduling1(sol)
  }else{
    cat("ERROR: invalid method ID in computePerformance function")
  }
  
  return(res)
  
}




