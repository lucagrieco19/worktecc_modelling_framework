
getTotalWorkload_TeamSizeAndComposition_heur <- function(solution){
  
  res <- sum(solution$sol_total_travel_time) + sum(solution$sol_total_visit_time)
  
  names(res) <- NULL
  
  return(res)
  
}


