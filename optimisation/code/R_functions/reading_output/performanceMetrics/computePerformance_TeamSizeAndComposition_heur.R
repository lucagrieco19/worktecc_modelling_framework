
computePerformance_TeamSizeAndComposition_heur <- function(solution){
  
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalSalariedStaff_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalWorkload_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalSalariedCost_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalStaffCost_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalVisitsConducted_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getVisitsPerStaff_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalVisitTime_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalTravelTime_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTravelTimePerVisit_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getStaffUtil_TeamSizeAndComposition_heur.R")
  
  res <- c(
    
    TotalSalariedStaff = getTotalSalariedStaff_TeamSizeAndComposition_heur(solution),
    TotalWorkload = getTotalWorkload_TeamSizeAndComposition_heur(solution),
    TotalSalariedCost = getTotalSalariedCost_TeamSizeAndComposition_heur(solution),
    TotalStaffCost = getTotalStaffCost_TeamSizeAndComposition_heur(solution),
    TotalVisitsConducted = getTotalVisitsConducted_TeamSizeAndComposition_heur(solution),
    VisitsPerStaff = getVisitsPerStaff_TeamSizeAndComposition_heur(solution),
    TotalVisitTime = getTotalVisitTime_TeamSizeAndComposition_heur(solution),
    TotalTravelTime = getTotalTravelTime_TeamSizeAndComposition_heur(solution),
    TravelTimePerVisit = getTravelTimePerVisit_TeamSizeAndComposition_heur(solution),
    StaffUtil = getStaffUtil_TeamSizeAndComposition_heur(solution)
    
  )
  
  return(res)
  
}



