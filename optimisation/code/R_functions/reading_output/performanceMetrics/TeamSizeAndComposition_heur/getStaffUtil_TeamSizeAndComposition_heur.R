
getStaffUtil_TeamSizeAndComposition_heur <- function(solution){
  
  #num <- sum(solution$sol_total_visit_time)
  num <- sum(solution$sol_total_visit_time) + sum(solution$sol_total_travel_time)
  
  #den <- sum(solution$sol_total_visit_time) + sum(solution$sol_total_travel_time)
  den <- sum(solution$max_working_hours[solution$roles] * solution$sol_n_staff[solution$roles])
  
  res <- num / den
  names(res) <- NULL
  
  return(res)
  
}



