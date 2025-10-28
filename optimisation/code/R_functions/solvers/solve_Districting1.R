
solve_Districting1 <- function(loc,mod_loc,anID,districts,basic_units,basic_unit_distances,basic_unit_compatibility,activity_types,activity_times,basic_unit_annual_demand,obj_weights,d_max,tau,basic_unit_contiguity){
  
  options(scipen=999) #to deactivate scientific notation for big numbers (e.g. max_budget)
  
  source("R_functions/cplex_interface/vectorToCPLEXstringset.R")
  source("R_functions/cplex_interface/vectorToCPLEXarray.R")
  source("R_functions/cplex_interface/matrixToCPLEXarray.R")
  source("R_functions/cplex_interface/array3dToCPLEXarray.R")
  source("R_functions/cplex_interface/CPLEXoutputToNumericArray.R")
 
  model_instance <- c(
    
    vectorToCPLEXstringset(districts,"districts"),
    vectorToCPLEXstringset(basic_units,"basic_units"),
    vectorToCPLEXstringset(activity_types,"activity_types"),
    vectorToCPLEXarray(activity_times,"activity_times"),
    matrixToCPLEXarray(basic_unit_distances,"basic_unit_distances"),
    matrixToCPLEXarray(basic_unit_compatibility,"basic_unit_compatibility"),
    matrixToCPLEXarray(basic_unit_annual_demand,"basic_unit_annual_demand"),
    matrixToCPLEXarray(basic_unit_contiguity,"basic_unit_contiguity"),
    paste("d_max = ",d_max,';',sep=''),
    paste("tau = ",tau,';',sep=''),
    paste("weight_compactness = ",obj_weights["weight_compactness"],';',sep=''),
    paste("weight_balance = ",obj_weights["weight_balance"],';',sep=''),
    paste('output_loc = "',paste(mod_loc,anID,"model_output",sep='/'),'";',sep='')
    
  )

  dat_file <- paste(loc,'/',anID,"/model_input/input_Districting1.dat",sep='')
  mod_file <- "R_functions/solvers/formulations/Districting1.mod"
  write.table(model_instance,file=dat_file,quote=FALSE,col.name=FALSE,row.names=FALSE)
  #system(paste("oplrun",mod_file,dat_file,sep=' '))
  system2("oplrun",paste(mod_file,dat_file,sep=' '))
  
}

