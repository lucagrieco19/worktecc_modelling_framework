
getStaffPerPatient_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  #number of staff visiting each patient
  sal <- apply(solution$y_staff_to_patient,1,sum)
  
  res <- mean( sal )
  
  return(res)
  
}


