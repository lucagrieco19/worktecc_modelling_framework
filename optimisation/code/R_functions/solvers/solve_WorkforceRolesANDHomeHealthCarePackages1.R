

solve_WorkforceRolesANDHomeHealthCarePackages1 <- function(loc,mod_loc,anID,profiles,visits,activities,roles,hourly_rates,visit_duration,visit_composition,profile_demand,role_to_visit,profile_counts){
  
  options(scipen=999) #to deactivate scientific notation for big numbers (e.g. max_budget)
  
  source("R_functions/cplex_interface/vectorToCPLEXstringset.R")
  source("R_functions/cplex_interface/vectorToCPLEXarray.R")
  source("R_functions/cplex_interface/matrixToCPLEXarray.R")
  source("R_functions/cplex_interface/array3dToCPLEXarray.R")
  source("R_functions/cplex_interface/CPLEXoutputToNumericArray.R")
  
  model_instance <- c(
        
    vectorToCPLEXstringset(profiles,"profiles"),
    vectorToCPLEXstringset(visits,"visits"),
    vectorToCPLEXstringset(activities,"activities"),
    vectorToCPLEXstringset(roles,"roles"),
    vectorToCPLEXarray(hourly_rates,"hourly_rates"),
    vectorToCPLEXarray(visit_duration,"visit_duration"),
    matrixToCPLEXarray(visit_composition,"visit_composition"),
    matrixToCPLEXarray(profile_demand,"profile_demand"),
    matrixToCPLEXarray(role_to_visit,"role_to_visit"),
    vectorToCPLEXarray(profile_counts,"profile_counts"),
    paste('output_loc = "',paste(mod_loc,anID,"model_output",sep='/'),'";',sep='')
    
  )

  dat_file <- paste(loc,'/',anID,"/model_input/input_WorkforceRolesANDHomeHealthCarePackages1.dat",sep='')
  mod_file <- "R_functions/solvers/formulations/WorkforceRolesANDHomeHealthCarePackages1.mod"
  write.table(model_instance,file=dat_file,quote=FALSE,col.name=FALSE,row.names=FALSE)
  #system(paste("oplrun",mod_file,dat_file,sep=' '))
  system2("oplrun",paste(mod_file,dat_file,sep=' '))
  
}

