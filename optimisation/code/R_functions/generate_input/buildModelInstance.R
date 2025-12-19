
buildModelInstance <- function(analysisID,methID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location,source_info){
  
  res <- NA
  
  if(methID=="Districting1"){
    source("R_functions/generate_input/buildModelInstance_Districting1.R")
    res <- buildModelInstance_Districting1(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location,source_info)
  }else if(methID=="WorkforceRolesANDHomeHealthCarePackages1"){
    source("R_functions/generate_input/buildModelInstance_WorkforceRolesANDHomeHealthCarePackages1.R")
    res <- buildModelInstance_WorkforceRolesANDHomeHealthCarePackages1(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location,source_info)
  }else if(methID=="TeamSizeAndComposition_heur"){
    source("R_functions/generate_input/buildModelInstance_TeamSizeAndComposition_heur.R")
    res <- buildModelInstance_TeamSizeAndComposition_heur(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location,source_info)
  }else if(methID=="RosteringANDAllocationANDScheduling1"){
    source("R_functions/generate_input/buildModelInstance_RosteringANDAllocationANDScheduling1.R")
    res <- buildModelInstance_RosteringANDAllocationANDScheduling1(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location,source_info)
  }else{
    cat("ERROR: invalid method ID in buildModelInstance function")
  }
  
  
}