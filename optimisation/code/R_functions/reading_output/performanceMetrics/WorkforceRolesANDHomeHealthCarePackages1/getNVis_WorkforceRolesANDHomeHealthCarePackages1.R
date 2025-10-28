
getNVis_WorkforceRolesANDHomeHealthCarePackages1 <- function(solution){
  
  res <- apply(solution$x_visit_to_profile_to_role,2,sum) * solution$profile_counts
  
  res <- sum(res)
  
  return(res)
  
}


