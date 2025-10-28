
buildModelInstance_TeamSizeAndComposition_heur <- function(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location,source_info){
  
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
  
  outcome <- rep('',length(data_elements))
  names(outcome) <- data_elements
  
  model_instance <- vector("list",length=0)
  
  if(source_info$source_type[source_info$data_element=="sub area of interest"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/basic_units.rds",sep=''))){
      model_instance$basic_units <- readRDS(paste("../data/",analysisID,"/direct_user_input/basic_units.rds",sep=''))
      outcome["sub area of interest"] <- 'Sub area of interest read from basic_units.rds as direct user input'
    }else{
      outcome["sub area of interest"] <- 'ERROR: source file not found'  
    }
  }else if(source_info$source_type[source_info$data_element=="sub area of interest"]=="upstream"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/districts_of_interest.rds",sep=''))){
      districtIDs <- readRDS(paste("../data/",analysisID,"/direct_user_input/districts_of_interest.rds",sep=''))
      upstr_distr_analysis <- upstream_analyses[upstream_methodIDs %in% c("Districting1")][1]
      distr_solution <- readRDS(paste("../data/",upstr_distr_analysis,"/model_output/solution_",upstr_distr_analysis,".rds",sep=''))
      sel_basic_units <- apply(distr_solution$x_basic_unit_to_district * (rownames(distr_solution$x_basic_unit_to_district) %in% districtIDs),2,sum)
      model_instance$basic_units <- names(sel_basic_units)[sel_basic_units==1]
      outcome["sub area of interest"] <- 'Sub area of interest identified from upstream analysis using information provided in districts_of_interest.rds as direct user input'
    }else{
      outcome["sub area of interest"] <- 'ERROR: source file not found'  
    }
  }else{
    outcome["sub area of interest"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="list of roles"]=="user" & source_info$source_type[source_info$data_element=="visit types"]=="user" & source_info$source_type[source_info$data_element=="service times"]=="user" & source_info$source_type[source_info$data_element=="role to visit"]=="user" & source_info$source_type[source_info$data_element=="daily demand"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/roles.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/visit_types.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/service_times.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/role_to_visit.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/daily_demand_scenarios.rds",sep=''))){
      model_instance$roles <- readRDS(paste("../data/",analysisID,"/direct_user_input/roles.rds",sep=''))
      model_instance$visit_types <- readRDS(paste("../data/",analysisID,"/direct_user_input/visit_types.rds",sep=''))
      model_instance$service_times <- readRDS(paste("../data/",analysisID,"/direct_user_input/service_times.rds",sep=''))
      model_instance$role_to_visit <- readRDS(paste("../data/",analysisID,"/direct_user_input/role_to_visit.rds",sep=''))
      model_instance$daily_demand_scenarios <- readRDS(paste("../data/",analysisID,"/direct_user_input/daily_demand_scenarios.rds",sep=''))
      outcome["list of roles"] <- 'List of roles read from roles.rds as direct user input'
      outcome["visit types"] <- 'Visit types read from visit_types.rds as direct user input'
      outcome["service times"] <- 'Service times read from service_times.rds as direct user input'
      outcome["role to visit"] <- 'Role to visit read from role_to_visit.rds as direct user input'
      outcome["daily demand"] <- 'Daily demand read from daily_demand_scenarios.rds as direct user input'
    }else{
      outcome["list of roles"] <- 'ERROR: source file not found'
      outcome["visit types"] <- 'ERROR: source file not found'
      outcome["service times"] <- 'ERROR: source file not found'
      outcome["role to visit"] <- 'ERROR: source file not found'
      outcome["daily demand"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="list of roles"]=="upstream" & source_info$source_type[source_info$data_element=="visit types"]=="upstream" & source_info$source_type[source_info$data_element=="service times"]=="upstream" & source_info$source_type[source_info$data_element=="role to visit"]=="upstream" & source_info$source_type[source_info$data_element=="daily demand"]=="upstream and synthetic"){
    if("WorkforceRolesANDHomeHealthCarePackages1" %in% upstream_methodIDs){
      upstr_hhc_plan_analysis <- upstream_analyses[upstream_methodIDs %in% c("WorkforceRolesANDHomeHealthCarePackages1")][1]
      hhc_solution <- readRDS(paste("../data/",upstr_hhc_plan_analysis,"/model_output/solution_",upstr_hhc_plan_analysis,".rds",sep=''))
      model_instance$roles <- hhc_solution$roles
      model_instance$visit_types <- hhc_solution$visits
      model_instance$service_times <- hhc_solution$visit_duration[model_instance$visit_types]
      model_instance$role_to_visit <- hhc_solution$role_to_visit[model_instance$roles,model_instance$visit_types]
      
      patients <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))$patients
      patient_needs <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))$patient_needs
      weekly_need_scenarios <- lapply(unique(as.character(patient_needs$subperiod)),function(x){
        tmp <- unique(patient_needs[as.character(patient_needs$subperiod)==x,c("patID","profile")])
        tmp$basic_unit <- sapply(tmp$patID,function(p){
          patients[p,"basic_unit"]
        })
        rownames(tmp) <- NULL
        tmp
      })
      names(weekly_need_scenarios) <- paste("scen",1:length(weekly_need_scenarios),sep='')
      
      visits_by_profile <- sapply(model_instance$visit_types,function(v){
        apply(hhc_solution$x_visit_to_profile_to_role[,,v],2,sum)
      })
      
      weekly_demand <- vector("list",length=length(weekly_need_scenarios))
      names(weekly_demand) <- names(weekly_need_scenarios)
      for(i in 1:length(weekly_demand)){
        weekly_demand[[i]] <- matrix(0,length(model_instance$visit_types),length(model_instance$basic_units))
        rownames(weekly_demand[[i]]) <- model_instance$visit_types
        colnames(weekly_demand[[i]]) <- model_instance$basic_units
        for(b in model_instance$basic_units){
          weekly_profile_counts <- sapply(rownames(visits_by_profile),function(p){sum(weekly_need_scenarios[[i]]$profile==p & weekly_need_scenarios[[i]]$basic_unit==b)})
          weekly_demand[[i]][,b] <- apply(visits_by_profile * weekly_profile_counts,2,sum)
        }
      }
      
      daily_demand_scenarios <- weekly_demand
      for(i in 1:length(daily_demand_scenarios)){
        for(v in rownames(daily_demand_scenarios[[i]])){
          for(b in colnames(daily_demand_scenarios[[i]])){
            if(daily_demand_scenarios[[i]][v,b]>0){
              daily_demand_scenarios[[i]][v,b] <- sum(sample(c(1,0),size=daily_demand_scenarios[[i]][v,b],replace=TRUE,prob=c(1/7,6/7)))
            }
          }
        }
      }
      model_instance$daily_demand_scenarios <- daily_demand_scenarios
      
      outcome["list of roles"] <- 'List of roles identified from upstream analysis'
      outcome["visit types"] <- 'Visit types identified from upstream analysis'
      outcome["service times"] <- 'Service times identified from upstream analysis'
      outcome["role to visit"] <- 'Role to visit identified from upstream analysis'
      outcome["daily demand"] <- 'Daily demand identified from upstream analysis and synthetic data'
    }
  }else{
    outcome["list of roles"] <- 'ERROR: invalid input method'
    outcome["visit types"] <- 'ERROR: invalid input method'
    outcome["service times"] <- 'ERROR: invalid input method'
    outcome["role to visit"] <- 'ERROR: invalid input method'
    outcome["daily demand"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="demand proportion"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/dem_prop.rds",sep=''))){
      model_instance$dem_prop <- readRDS(paste("../data/",analysisID,"/direct_user_input/dem_prop.rds",sep=''))
      outcome["demand proportion"] <- 'Demand proportion to satisfy read from dem_prop.rds as direct user input'
    }else{
      outcome["demand proportion"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["demand proportion"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="max daily working hours"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/max_working_hours.rds",sep=''))){
      model_instance$max_working_hours <- readRDS(paste("../data/",analysisID,"/direct_user_input/max_working_hours.rds",sep=''))[model_instance$roles]
      outcome["max daily working hours"] <- 'Max daily working hours read from max_working_hours.rds as direct user input'
    }else{
      outcome["max daily working hours"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="max daily working hours"]=="synthetic"){
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
      role_features <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$role_features
      
      max_hours <- role_features$max_daily_working_hours
      names(max_hours) <- role_features$role
      
      model_instance$max_working_hours <- max_hours[model_instance$roles]
      
      outcome["max daily working hours"] <- 'Maximum daily working hours identified from synthetic data'
    }else{
      outcome["max daily working hours"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["max daily working hours"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="daily travel time"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/daily_travel_time.rds",sep=''))){
      model_instance$daily_travel_time <- readRDS(paste("../data/",analysisID,"/direct_user_input/daily_travel_time.rds",sep=''))[model_instance$roles]
      outcome["daily travel time"] <- 'Daily travel time read from daily_travel_time.rds as direct user input'
    }else{
      outcome["daily travel time"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["daily travel time"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="salary"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/deployment_costs.rds",sep=''))){
      model_instance$deployment_costs <- readRDS(paste("../data/",analysisID,"/direct_user_input/deployment_costs.rds",sep=''))[model_instance$roles]
      outcome["salary"] <- 'Salary read from deployment_costs.rds as direct user input'
    }else{
      outcome["salary"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="salary"]=="synthetic"){
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
      role_features <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$role_features
      
      salary <- role_features$hourly_rate * role_features$max_daily_working_hours
      names(salary) <- role_features$role
      
      model_instance$deployment_costs <- salary[model_instance$roles]
      
      outcome["salary"] <- 'Deployment costs identified from synthetic data'
    }else{
      outcome["salary"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["salary"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="minimum staff per role"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/min_staff_per_role.rds",sep=''))){
      model_instance$min_staff_per_role <- readRDS(paste("../data/",analysisID,"/direct_user_input/min_staff_per_role.rds",sep=''))[model_instance$roles]
      outcome["minimum staff per role"] <- 'Minimum staff per role read from min_staff_per_role.rds as direct user input'
    }else{
      outcome["minimum staff per role"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["minimum staff per role"] <- 'ERROR: invalid input method'
  }
  
  saveRDS(model_instance,file=paste("../data/",analysisID,"/model_input/input_",analysisID,".rds",sep=''))
  
  return(cbind(source_info,building_outcome=outcome))
  
}


  
  

