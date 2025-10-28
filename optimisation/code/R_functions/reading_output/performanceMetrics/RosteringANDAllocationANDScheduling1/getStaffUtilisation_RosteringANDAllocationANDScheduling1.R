
getStaffUtilisation_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  num <- sum(solution$workload)
  
  den <- sum(apply((solution$subperiods_available * solution$max_workload),1,sum))
  
  res <- num / den
  names(res) <- NULL
  
  return(res)
  
}


