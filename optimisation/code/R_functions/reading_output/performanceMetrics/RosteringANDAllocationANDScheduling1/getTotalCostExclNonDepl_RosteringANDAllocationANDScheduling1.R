
getTotalCostExclNonDepl_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  salary_costs <- sum(t(solution$z_staff_to_subperiod) * solution$salary)
  
  res <- salary_costs
  
  return(res)
  
}


