
getUniquePatStaffPairs_RosteringANDAllocationANDScheduling1 <- function(solution){
  
  #number of salaried staff visiting each patient
  sal <- apply(solution$y_staff_to_patient,1,sum)
  
  res <- sum( sal )
  
  return(res)
  
}


