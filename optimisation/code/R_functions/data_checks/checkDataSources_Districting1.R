
checkDataSources_Districting1 <- function(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location){
  
  data_elements <- c(
    "list of districts",
    "list of basic units",
    "basic unit pairwise distances",
    "basic unit compatibility",
    "activity types",
    "activity times",
    "basic unit annual demand",
    "maximum basic unit distance",
    "maximum workload deviation",
    "basic unit contiguity",
    "weights of objective function components",
    "euclidean to real distance factor"
  )
  
  source_files <- rep('',length(data_elements))
  names(source_files) <- data_elements
  
  source_types <- rep('user',length(data_elements))
  names(source_types) <- data_elements
  
  source_files["list of districts"] <- paste('Provide file districts.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["list of basic units"] <- paste('Provide file basic_units.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["basic unit pairwise distances"] <- paste('Provide file basic_unit_distances.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["basic unit compatibility"] <- paste('Provide file basic_unit_compatibility.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["activity types"] <- paste('Provide file activity_types.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["activity times"] <- paste('Provide file activity_times.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["basic unit annual demand"] <- paste('Provide file basic_unit_annual_demand.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["maximum basic unit distance"] <- paste('Provide file d_max.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["maximum workload deviation"] <- paste('Provide file tau.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["basic unit contiguity"] <- paste('Provide file basic_unit_contiguity.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["weights of objective function components"] <- paste('Provide file obj_weights.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["euclidean to real distance factor"] <- paste('Provide file mult_eucl_to_real.rds in direct_user_input folder of ',analysisID,sep='')
  
  if(!is.na(synth_dataID)){
    
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/input/geographic_area.rds",sep=''))){
      source_files["list of basic units"] <- paste('Existing geographic area data in the folder ',synth_dataID,sep='')
      source_types["list of basic units"] <- 'synthetic'
      source_files["basic unit pairwise distances"] <- paste('Existing geographic area data in the folder ',synth_dataID,sep='')
      source_types["basic unit pairwise distances"] <- 'synthetic'
    }else{
      source_files["list of basic units"] <- paste('Synthetic data not found - Provide file basic_units.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["basic unit pairwise distances"] <- paste('Synthetic data not found - Provide file basic_unit_distances.rds in direct_user_input folder of ',analysisID,sep='')
    }
    
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))){
      source_files["basic unit annual demand"] <- paste('Existing demand data in the folder ',synth_dataID,sep='')
      source_types["basic unit annual demand"] <- 'synthetic'
    }else{
      source_files["basic unit annual demand"] <- paste('Synthetic data not found - Provide file basic_unit_annual_demand.rds in direct_user_input folder of ',analysisID,sep='')
    }
    
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
      source_files["activity types"] <- paste('Existing service data in the folder ',synth_dataID,sep='')
      source_types["activity types"] <- 'synthetic'
      source_files["activity times"] <- paste('Existing service data in the folder ',synth_dataID,sep='')
      source_types["activity times"] <- 'synthetic'
    }else{
      source_files["activity types"] <- paste('Synthetic data not found - Provide file activity_types.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["activity times"] <- paste('Synthetic data not found - Provide file activity_times.rds in direct_user_input folder of ',analysisID,sep='')
    }
    
  }

  return(cbind(data_element=data_elements,source_type=source_types,description=source_files))
  
}


