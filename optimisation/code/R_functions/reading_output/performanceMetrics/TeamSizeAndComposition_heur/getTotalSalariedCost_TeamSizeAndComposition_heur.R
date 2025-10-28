
getTotalSalariedCost_TeamSizeAndComposition_heur <- function(solution){
  
  res <- sum(solution$deployment_costs * solution$sol_n_staff)
  
  return(res)
  
}
