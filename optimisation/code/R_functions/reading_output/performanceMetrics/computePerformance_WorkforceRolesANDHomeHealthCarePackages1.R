
computePerformance_WorkforceRolesANDHomeHealthCarePackages1 <- function(solution){
  
  source("R_functions/reading_output/performanceMetrics/WorkforceRolesANDHomeHealthCarePackages1/getCost_WorkforceRolesANDHomeHealthCarePackages1.R")
  source("R_functions/reading_output/performanceMetrics/WorkforceRolesANDHomeHealthCarePackages1/getNVis_WorkforceRolesANDHomeHealthCarePackages1.R")
  source("R_functions/reading_output/performanceMetrics/WorkforceRolesANDHomeHealthCarePackages1/getVisTime_WorkforceRolesANDHomeHealthCarePackages1.R")
  
  res <- c(
    
    TotalCost = getCost_WorkforceRolesANDHomeHealthCarePackages1(solution),
    NumVisitsToCoverDemand = getNVis_WorkforceRolesANDHomeHealthCarePackages1(solution),
    TotalVisitTime = getVisTime_WorkforceRolesANDHomeHealthCarePackages1(solution)
    
  )
  
  return(res)
  
}



