
getAvgDailyVisits_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  res <- sum(solution$x_staff_to_visit_to_subperiod) / length(solution$subperiods)
    
  return(res)
  
}


