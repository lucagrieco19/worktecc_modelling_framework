
getTotalWorkload_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  res <- sum(solution$workload)
  
  return(res)
  
}


