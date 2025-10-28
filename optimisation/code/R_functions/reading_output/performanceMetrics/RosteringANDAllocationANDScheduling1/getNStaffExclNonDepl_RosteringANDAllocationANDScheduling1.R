
getNStaffExclNonDepl_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  res <- sum( solution$workload > 0 )
  
  return(res)
  
}


