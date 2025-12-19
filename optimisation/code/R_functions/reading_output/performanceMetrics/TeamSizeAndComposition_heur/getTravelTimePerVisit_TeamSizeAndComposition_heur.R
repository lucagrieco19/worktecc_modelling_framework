
getTravelTimePerVisit_TeamSizeAndComposition_heur <- function(solution){
  
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalTravelTime_TeamSizeAndComposition_heur.R")
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalVisitsConducted_TeamSizeAndComposition_heur.R")
  
  travel_time <- getTotalTravelTime_TeamSizeAndComposition_heur(solution)
  n_visits_conducted <- getTotalVisitsConducted_TeamSizeAndComposition_heur(solution)
  
  res <- travel_time / n_visits_conducted
  
  return(res)
  
}



