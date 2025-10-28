
getCost_WorkforceRolesANDHomeHealthCarePackages1 <- function(solution){
  
  res <- apply(solution$x_visit_to_profile_to_role,c(2,3),function(m){
    sum(m * solution$hourly_rates)
  })
  res <- t(res) * solution$visit_duration
  res <- t(res) * solution$profile_counts
  
  res <- sum(res)
  
  return(res)
  
}


