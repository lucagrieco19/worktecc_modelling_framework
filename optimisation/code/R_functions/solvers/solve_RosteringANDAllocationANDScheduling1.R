
solve_RosteringANDAllocationANDScheduling1 <- function(loc,mod_loc,anID,patients,staff_members,roles,staff_to_role,subperiods,subperiods_available,visits,visits_by_patient,visits_to_staff,visit_time,within_district_travel_time,max_workload,salary,min_prop_visits,max_unique_pairs,budget_limit,obj_weights){

  options(scipen=999) #to deactivate scientific notation for big numbers (e.g. max_budget)
  
  source("R_functions/cplex_interface/vectorToCPLEXstringset.R")
  source("R_functions/cplex_interface/vectorToCPLEXintset.R")
  source("R_functions/cplex_interface/vectorToCPLEXarray.R")
  source("R_functions/cplex_interface/matrixToCPLEXarray.R")
  source("R_functions/cplex_interface/matrixToCPLEXintSetArray.R")
  source("R_functions/cplex_interface/matrixToCPLEXstringSetArray.R")
  source("R_functions/cplex_interface/dataframeToCPLEXorderedPairSet.R")
  
  model_instance <- c(
    
    vectorToCPLEXstringset(patients,"patients"),
    vectorToCPLEXstringset(staff_members,"staff_members"),
    vectorToCPLEXstringset(roles,"roles"),
    matrixToCPLEXarray(staff_to_role,"staff_to_role"),
    vectorToCPLEXintset(subperiods,"subperiods"),
    matrixToCPLEXarray(subperiods_available,"subperiods_available"),
    vectorToCPLEXstringset(visits,"visits"),
    matrixToCPLEXarray(visits_by_patient,"visits_by_patient"),
    matrixToCPLEXarray(visits_to_staff,"visits_to_staff"),
    vectorToCPLEXarray(visit_time,"visit_time"),
    paste("within_district_travel_time = ",within_district_travel_time,';',sep=''),
    vectorToCPLEXarray(max_workload,"max_workload"),
    vectorToCPLEXarray(salary,"salary"),
    paste("min_prop_visits = ",min_prop_visits,';',sep=''),
    paste("max_unique_pairs = ",max_unique_pairs,';',sep=''),
    paste("budget_limit = ",budget_limit,';',sep=''),
    paste("weight_costs = ",obj_weights["weight_costs"],';',sep=''),
    paste("weight_pairs = ",obj_weights["weight_pairs"],';',sep=''),
    paste('output_loc = "',paste(mod_loc,anID,"model_output",sep='/'),'";',sep='')
    
  )
  
  dat_file <- paste(loc,'/',anID,"/model_input/input_RosteringANDAllocationANDScheduling1.dat",sep='')
  mod_file <- "R_functions/solvers/formulations/RosteringANDAllocationANDScheduling1.mod"
  write.table(model_instance,file=dat_file,quote=FALSE,col.name=FALSE,row.names=FALSE)
  #system(paste("oplrun",mod_file,dat_file,sep=' '))
  system2("oplrun",paste(mod_file,dat_file,sep=' '))
  
}

