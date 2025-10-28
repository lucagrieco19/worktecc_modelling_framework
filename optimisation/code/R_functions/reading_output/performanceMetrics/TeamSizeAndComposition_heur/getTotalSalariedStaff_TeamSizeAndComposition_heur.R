
getTotalSalariedStaff_TeamSizeAndComposition_heur <- function(solution){
  
  res <- sum(solution$sol_n_staff)
  
  return(res)
  
}

