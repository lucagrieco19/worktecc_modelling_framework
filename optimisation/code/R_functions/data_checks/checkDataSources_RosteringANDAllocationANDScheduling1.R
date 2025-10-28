
checkDataSources_RosteringANDAllocationANDScheduling1 <- function(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location){
  
  data_elements <- c(
    "list of patients",
    "list of staff members",
    "staff roles",
    "association between staff and roles",
    "salary",
    "sub periods",
    "staff availability",
    "list of visits",
    "association between visits and patients",
    "association between staff members and visits they can conduct",
    "districts",
    "service times",
    "within district travel distance",
    "maximum workload per staff member",
    "average travel speed",
    "minimum proportion of visits to be conducted",
    "maximum number of unique staff patient pairs",
    "max budget",
    "weights of objective function components",
    "euclidean to real distance factor",
    "reference time period"
  )
  
  
  source_files <- rep('',length(data_elements))
  names(source_files) <- data_elements
  
  source_types <- rep('user',length(data_elements))
  names(source_types) <- data_elements
  
  source_files["list of patients"] <- paste('Provide file patients.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["list of staff members"] <- paste('Provide file staff_members.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["staff roles"] <- paste('Provide file roles.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["association between staff and roles"] <- paste('Provide file staff_to_role.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["salary"] <- paste('Provide file salary.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["sub periods"] <- paste('Provide file subperiods.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["staff availability"] <- paste('Provide file subperiods_available.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["list of visits"] <- paste('Provide file visits.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["association between visits and patients"] <- paste('Provide file visits_by_patient.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["association between staff members and visits they can conduct"] <- paste('Provide file visits_to_staff.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["districts"] <- paste('Provide file district_structure.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["service times"] <- paste('Provide file visit_time.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["within district travel distance"] <- paste('Provide file within_district_travel_time.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["maximum workload per staff member"] <- paste('Provide file max_workload.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["average travel speed"] <- paste('Provide file avg_travel_speed.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["minimum proportion of visits to be conducted"] <- paste('Provide file min_prop_visits.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["maximum number of unique staff patient pairs"] <- paste('Provide file max_unique_pairs.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["max budget"] <- paste('Provide file budget_limit.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["weights of objective function components"] <- paste('Provide file obj_weights.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["euclidean to real distance factor"] <- paste('Provide file mult_eucl_to_real.rds in direct_user_input folder of ',analysisID,sep='')
  source_files["reference time period"] <- paste('Provide file ref_time_period.rds in direct_user_input folder of ',analysisID,sep='')
  
  if("Districting1" %in% upstream_methodIDs){
    source_files["districts"] <- paste('Districts identified from upstream analysis ',upstream_analyses[which(upstream_methodIDs=="Districting1")],'. Provide file districts_of_interest.rds in direct_user_input folder of ',analysisID,sep='')
    source_types["districts"] <- 'upstream'
  }
  
  if(("TeamSizeAndComposition_heur" %in% upstream_methodIDs)){
    source_files["list of staff members"] <- paste('List of staff members identified from upstream analysis ',upstream_analyses[grepl("TeamSizeAndComposition",upstream_methodIDs)],sep='')
    source_types["list of staff members"] <- 'upstream'
    source_files["staff roles"] <- paste('Staff roles identified from upstream analysis ',upstream_analyses[grepl("TeamSizeAndComposition",upstream_methodIDs)],sep='')
    source_types["staff roles"] <- 'upstream'
    source_files["association between staff and roles"] <- paste('Association between staff and roles identified from upstream analysis ',upstream_analyses[grepl("TeamSizeAndComposition",upstream_methodIDs)],sep='')
    source_types["association between staff and roles"] <- 'upstream'
    source_files["staff availability"] <- paste('Staff availability identified from upstream analysis ',upstream_analyses[grepl("TeamSizeAndComposition",upstream_methodIDs)],sep='')
    source_types["staff availability"] <- 'upstream'
  }
  
  if(("WorkforceRolesANDHomeHealthCarePackages1" %in% upstream_methodIDs) & file.exists(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep='')) & file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
    source_files["list of patients"] <- paste('List of patients identified from synthetic datasets and upstream analysis ',upstream_analyses[grepl("WorkforceRolesANDHomeHealthCarePackages",upstream_methodIDs)],sep='')
    source_types["list of patients"] <- 'upstream and synthetic'
    source_files["list of visits"] <- paste('List of visits identified from synthetic datasets and upstream analysis ',upstream_analyses[grepl("WorkforceRolesANDHomeHealthCarePackages",upstream_methodIDs)],sep='')
    source_types["list of visits"] <- 'upstream and synthetic'
    source_files["service times"] <- paste('Service times identified from synthetic datasets and upstream analysis ',upstream_analyses[grepl("WorkforceRolesANDHomeHealthCarePackages",upstream_methodIDs)],sep='')
    source_types["service times"] <- 'upstream and synthetic'
    source_files["association between visits and patients"] <- paste('Association between visits and patients identified from synthetic datasets and upstream analysis ',upstream_analyses[grepl("WorkforceRolesANDHomeHealthCarePackages",upstream_methodIDs)],sep='')
    source_types["association between visits and patients"] <- 'upstream and synthetic'
    source_files["association between staff members and visits they can conduct"] <- paste('Association between staff members and visits they can conduct identified from synthetic datasets and upstream analysis ',upstream_analyses[grepl("WorkforceRolesANDHomeHealthCarePackages",upstream_methodIDs)],sep='')
    source_types["association between staff members and visits they can conduct"] <- 'upstream and synthetic'
    source_files["within district travel distance"] <- paste('Within district travel time identified from synthetic datasets and upstream analysis ',upstream_analyses[grepl("WorkforceRolesANDHomeHealthCarePackages",upstream_methodIDs)],sep='')
    source_types["within district travel distance"] <- 'upstream and synthetic'
  }
  
  if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
    source_files["salary"] <- paste('Salary per staff identified from synthetic data')
    source_types["salary"] <- 'synthetic'
    source_files["maximum workload per staff member"] <- paste('Maximum workload per staff member identified from synthetic data')
    source_types["maximum workload per staff member"] <- 'synthetic'
  }
  
  return(cbind(data_element=data_elements,source_type=source_types,description=source_files))
  
}


