
getTotalVisitsConducted_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  res <- sum(solution$x_staff_to_visit_to_subperiod)
  
  return(res)
  
}


