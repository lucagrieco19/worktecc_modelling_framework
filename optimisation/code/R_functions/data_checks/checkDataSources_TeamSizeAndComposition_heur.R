
checkDataSources_TeamSizeAndComposition_heur <- function(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location){
  
  data_elements <- c(
    "sub area of interest",
    "list of roles",
    "visit types",
    "role to visit",
    "daily demand",
    "demand proportion",
    "max daily working hours",
    "daily travel time",
    "service times",
    "salary",
    "minimum staff per role"
  )
  
  source_files <- rep('',length(data_elements))
  names(source_files) <- data_elements
  
  source_types <- rep('user',length(data_elements))
  names(source_types) <- data_elements
  
  source_files["sub area of interest"] <- paste('Provide file basic_units.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["list of roles"] <- paste('Provide file roles.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["visit types"] <- paste('Provide file visit_types.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["role to visit"] <- paste('Provide file role_to_visit.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["daily demand"] <- paste('Provide file daily_demand.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["demand proportion"] <- paste('Provide file dem_prop.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["max daily working hours"] <- paste('Provide file max_working_hours.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["daily travel time"] <- paste('Provide file daily_travel_time.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["service times"] <- paste('Provide file service_times.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["salary"] <- paste('Provide file deployment_costs.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["minimum staff per role"] <- paste('Provide file min_staff_per_role.rds in direct_user_input folder of ',analysisID,sep='')
  
  if("Districting1" %in% upstream_methodIDs){
    source_files["sub area of interest"] <- paste('Sub area of interest identified from upstream analysis ',upstream_analyses[which(upstream_methodIDs=="Districting1")],'. Provide file districts_of_interest.rds in direct_user_input folder of ',analysisID,sep='')
    source_types["sub area of interest"] <- 'upstream'
  }
  
  if("WorkforceRolesANDHomeHealthCarePackages1" %in% upstream_methodIDs){
    source_files["list of roles"] <- paste('List of roles identified from upstream analysis ',upstream_analyses[which(upstream_methodIDs=="WorkforceRolesANDHomeHealthCarePackages1")],sep='')
    source_types["list of roles"] <- 'upstream'
    source_files["visit types"] <- paste('Visit types identified from upstream analysis ',upstream_analyses[which(upstream_methodIDs=="WorkforceRolesANDHomeHealthCarePackages1")],sep='')
    source_types["visit types"] <- 'upstream'
    source_files["service times"] <- paste('Service times identified from upstream analysis ',upstream_analyses[which(upstream_methodIDs=="WorkforceRolesANDHomeHealthCarePackages1")],sep='')
    source_types["service times"] <- 'upstream'
    source_files["role to visit"] <- paste('Role to visit identified from upstream analysis ',upstream_analyses[which(upstream_methodIDs=="WorkforceRolesANDHomeHealthCarePackages1")],sep='')
    source_types["role to visit"] <- 'upstream'
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))){
      source_files["daily demand"] <- paste('Daily demand identified from upstream analysis ',upstream_analyses[which(upstream_methodIDs=="WorkforceRolesANDHomeHealthCarePackages1")],' and from existing patients.rds and patient_needs.rds in the folder ',synth_dataID,sep='')
      source_types["daily demand"] <- 'upstream and synthetic'
    }else{
      source_files["daily demand"] <- paste('Synthetic data not found - Provide file daily_demand_scenarios.rds in direct_user_input folder of ',analysisID,sep='')
    }
    
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
      source_files["salary"] <- paste('Deployment costs identified from existing service data in the folder ',synth_dataID,sep='')
      source_types["salary"] <- 'synthetic'
      source_files["max daily working hours"] <- paste('Maximum daily working hours identified from existing service data in the folder ',synth_dataID,sep='')
      source_types["max daily working hours"] <- 'synthetic'
    }else{
      source_files["salary"] <- paste('Synthetic data not found - Provide file deployment_costs.rds in direct_user_input folder of ',analysisID,sep='')
      source_files["max daily working hours"] <- paste('Synthetic data not found - Provide file max_working_hours.rds in direct_user_input folder of ',analysisID,sep='')
    }
  }
  
  return(cbind(data_element=data_elements,source_type=source_types,description=source_files))
  
}


