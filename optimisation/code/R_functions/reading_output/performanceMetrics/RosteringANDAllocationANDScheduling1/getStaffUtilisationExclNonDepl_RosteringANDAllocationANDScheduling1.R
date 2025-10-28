
getStaffUtilisationExclNonDepl_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  num <- sum(solution$workload)
  
  den <- sum(apply((t(solution$z_staff_to_subperiod) * solution$max_workload),1,sum))
  
  res <- num / den
  names(res) <- NULL
  
  return(res)
  
}


