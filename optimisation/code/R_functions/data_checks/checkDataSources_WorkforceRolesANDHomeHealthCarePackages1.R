
checkDataSources_WorkforceRolesANDHomeHealthCarePackages1 <- function(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location){
  
  data_elements <- c(
    "sub area of interest",
    "profiles",
    "visits",
    "activities",
    "roles",
    "hourly rates",
    "visit durations",
    "visit composition",
    "profile demand",
    "role to visit",
    "profile counts"
  )
  
  source_files <- rep('',length(data_elements))
  names(source_files) <- data_elements
  
  source_types <- rep('user',length(data_elements))
  names(source_types) <- data_elements
  
  source_files["sub area of interest"] <- paste('Provide file basic_units.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["profiles"] <- paste('Provide file profiles.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["visits"] <- paste('Provide file visits.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["activities"] <- paste('Provide file activities.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["roles"] <- paste('Provide file roles.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["hourly rates"] <- paste('Provide file hourly_rates.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["visit durations"] <- paste('Provide file visit_duration.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["visit composition"] <- paste('Provide file visit_composition.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["profile demand"] <- paste('Provide file profile_demand.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["role to visit"] <- paste('Provide file role_to_visit.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["profile counts"] <- paste('Provide file profile_counts.rds in direct_user_input folder of ',analysisID,sep='')
  
  if(!is.na(synth_dataID)){
    
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
      source_files["activities"] <- paste('Existing visit_types.rds in the folder ',synth_dataID,sep='')
      source_types["activities"] <- 'synthetic'
      source_files["visits"] <- paste('Existing visit_types.rds in the folder ',synth_dataID,sep='')
      source_types["visits"] <- 'synthetic'
      source_files["visit composition"] <- paste('Existing visit_types.rds in the folder ',synth_dataID,sep='')
      source_types["visit composition"] <- 'synthetic'
      source_files["visit durations"] <- paste('Existing visit_times.rds in the folder ',synth_dataID,sep='')
      source_types["visit durations"] <- 'synthetic'
      source_files["roles"] <- paste('Existing staff_features.rds in the folder ',synth_dataID,sep='')
      source_types["roles"] <- 'synthetic'
      source_files["hourly rates"] <- paste('Existing staff_features.rds in the folder ',synth_dataID,sep='')
      source_types["hourly rates"] <- 'synthetic'
      source_files["role to visit"] <- paste('Existing role_to_visit.rds in the folder ',synth_dataID,sep='')
      source_types["role to visit"] <- 'synthetic'
    }else{
      source_files["activities"] <- paste('Synthetic data not found - Provide file activities.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["visits"] <- paste('Synthetic data not found - Provide file visits.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["visit composition"] <- paste('Synthetic data not found - Provide file visit_composition.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["visit durations"] <- paste('Synthetic data not found - Provide file visit_duration.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["roles"] <- paste('Synthetic data not found - Provide file roles.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["hourly rates"] <- paste('Synthetic data not found - Provide file hourly_rates.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["role to visit"] <- paste('Synthetic data not found - Provide file role_to_visit.rds in direct_user_input folder of ',analysisID,sep='')
    }
    
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))){
      source_files["profiles"] <- paste('Existing profile_definition.rds and profile_counts.rds in the folder ',synth_dataID,sep='')
      source_types["profiles"] <- 'synthetic'
      source_files["profile counts"] <- paste('Existing profile_counts.rds in the folder ',synth_dataID,sep='')
      source_types["profile counts"] <- 'synthetic'
      source_files["profile demand"] <- paste('Existing profile_definition.rds and activities_to_needs.rds in the folder ',synth_dataID,sep='')
      source_types["profile demand"] <- 'synthetic'
    }else{
      source_files["profiles"] <- paste('Synthetic data not found - Provide file profiles.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["profile counts"] <- paste('Synthetic data not found - Provide file profile_counts.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["profile demand"] <- paste('Synthetic data not found - Provide file profile_demand.rds in direct_user_input folder of ',analysisID,sep='')
    }
    
  }
  
  if("Districting1" %in% upstream_methodIDs){
    source_files["sub area of interest"] <- paste('Sub area of interest identified from upstream analysis ',upstream_analyses[which(upstream_methodIDs %in% c("Districting1"))][1],'. Provide file districts_of_interest.rds in direct_user_input folder of ',analysisID,sep='')
    source_types["sub area of interest"] <- 'upstream'
  }
  
  return(cbind(data_element=data_elements,source_type=source_types,description=source_files))
  
}


