
getVisitsPerStaff_TeamSizeAndComposition_heur <- function(solution){
  
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalVisitsConducted_TeamSizeAndComposition_heur.R")
  
  n_visits_conducted <- getTotalVisitsConducted_TeamSizeAndComposition_heur(solution)
  
  res <- sum(n_visits_conducted) / sum(solution$sol_n_staff)
  
  names(res) <- NULL
  
  return(res)
  
}

