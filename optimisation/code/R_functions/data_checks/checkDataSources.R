
checkDataSources <- function(analysisID,methID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location){
  
  res <- c()
  
  if(methID=="Districting1"){
    source("R_functions/data_checks/checkDataSources_Districting1.R")
    res <- checkDataSources_Districting1(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location)
  }else if(methID=="WorkforceRolesANDHomeHealthCarePackages1"){
    source("R_functions/data_checks/checkDataSources_WorkforceRolesANDHomeHealthCarePackages1.R")
    res <- checkDataSources_WorkforceRolesANDHomeHealthCarePackages1(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location)
  }else if(methID=="TeamSizeAndComposition_heur"){
    source("R_functions/data_checks/checkDataSources_TeamSizeAndComposition_heur.R")
    res <- checkDataSources_TeamSizeAndComposition_heur(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location)
  }else if(methID=="RosteringANDAllocationANDScheduling1"){
    source("R_functions/data_checks/checkDataSources_RosteringANDAllocationANDScheduling1.R")
    res <- checkDataSources_RosteringANDAllocationANDScheduling1(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location)
  }else{
    cat("ERROR: invalid method ID in checkDataSources function")
  }
  
  return(res)
  
}


