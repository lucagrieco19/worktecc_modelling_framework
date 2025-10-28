
getPatientsPerStaff_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  #number of patients being visited by each staff
  pat <- apply(solution$y_staff_to_patient,2,sum)
  
  res <- mean( pat[solution$workload>0] )
  
  return(res)
  
}


