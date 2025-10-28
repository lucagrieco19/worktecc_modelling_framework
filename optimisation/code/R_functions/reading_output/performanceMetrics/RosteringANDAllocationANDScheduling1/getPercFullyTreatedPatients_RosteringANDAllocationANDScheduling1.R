
getPercFullyTreatedPatients_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  is_visit_conducted <- apply(solution$x_staff_to_visit_to_subperiod,c(2),sum)
  
  n_fully_treated_patients <- sum(sapply(solution$patients,function(p){
    visit_set <- rownames(solution$visits_by_patient)[solution$visits_by_patient[,p]==1]
    prod(is_visit_conducted[visit_set])
  }))
  
  res <- n_fully_treated_patients / length(solution$patients)
    
  return(res)
  
}


