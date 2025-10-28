
getTotalCost_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  salary_costs <- sum(solution$subperiods_available * solution$salary)
  
  res <- salary_costs
  
  return(res)
  
}


