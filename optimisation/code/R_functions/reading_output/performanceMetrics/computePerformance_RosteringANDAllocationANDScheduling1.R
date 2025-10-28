
computePerformance_RosteringANDAllocationANDScheduling1 <- function(solution){
    
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getAvgDailyVisits_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getPatientsPerStaff_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getPercDemandSatisfied_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getPercFullyTreatedPatients_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getNStaff_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getNStaffExclNonDepl_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getStaffPerPatient_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getStaffUtilisation_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getStaffUtilisationExclNonDepl_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getTotalCost_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getTotalCostExclNonDepl_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getTotalVisitsConducted_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getTotalWorkload_RosteringANDAllocationANDScheduling1.R")
  source("R_functions/reading_output/performanceMetrics/RosteringANDAllocationANDScheduling1/getUniquePatStaffPairs_RosteringANDAllocationANDScheduling1.R")
  
  res <- c(
    
    NumberOfStaff = getNStaff_RosteringANDAllocationANDScheduling1(solution),
    NumberOfStaffExclNonDepl = getNStaffExclNonDepl_RosteringANDAllocationANDScheduling1(solution),
    TotWorkload = getTotalWorkload_RosteringANDAllocationANDScheduling1(solution),
    TotCost = getTotalCost_RosteringANDAllocationANDScheduling1(solution),
    TotCostExclNonDepl = getTotalCostExclNonDepl_RosteringANDAllocationANDScheduling1(solution),
    StaffUtil = getStaffUtilisation_RosteringANDAllocationANDScheduling1(solution),
    StaffUtilExclNonDepl = getStaffUtilisationExclNonDepl_RosteringANDAllocationANDScheduling1(solution),
    StaffPerPatient = getStaffPerPatient_RosteringANDAllocationANDScheduling1(solution),
    UniquePatStaffPairs = getUniquePatStaffPairs_RosteringANDAllocationANDScheduling1(solution),
    TotVisits = getTotalVisitsConducted_RosteringANDAllocationANDScheduling1(solution),
    PercVisitsConducted = getPercDemandSatisfied_RosteringANDAllocationANDScheduling1(solution),
    PatientsPerStaff = getPatientsPerStaff_RosteringANDAllocationANDScheduling1(solution),
    PercFullyTreated = getPercFullyTreatedPatients_RosteringANDAllocationANDScheduling1(solution),
    AvgDailyVisits = getAvgDailyVisits_RosteringANDAllocationANDScheduling1(solution)
    
  )
  
  return(res)
  
}



