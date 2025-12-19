
getTotalStaffCost_TeamSizeAndComposition_heur <- function(solution){
  
  source("R_functions/reading_output/performanceMetrics/TeamSizeAndComposition_heur/getTotalSalariedCost_TeamSizeAndComposition_heur.R")
  
  salaried_cost <- getTotalSalariedCost_TeamSizeAndComposition_heur(solution)
  
  res <- salaried_cost
  
  return(res)
  
}

