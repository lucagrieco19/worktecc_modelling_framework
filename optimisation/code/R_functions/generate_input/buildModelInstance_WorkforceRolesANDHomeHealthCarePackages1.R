
buildModelInstance_WorkforceRolesANDHomeHealthCarePackages1 <- function(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location,source_info){
  
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
      model_instance$basic_units <- names(sel_basic_units)[sel_basic_units>0]
      outcome["sub area of interest"] <- 'Sub area of interest identified from upstream analysis using information provided in districts_of_interest.rds as direct user input'
    }else{
      outcome["sub area of interest"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["sub area of interest"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="activities"]=="user" & source_info$source_type[source_info$data_element=="visits"]=="user" & source_info$source_type[source_info$data_element=="visit composition"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/activities.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/visits.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/visit_composition.rds",sep=''))){
      model_instance$activities <- readRDS(paste("../data/",analysisID,"/direct_user_input/activities.rds",sep=''))
      model_instance$visits <- readRDS(paste("../data/",analysisID,"/direct_user_input/visits.rds",sep=''))
      model_instance$visit_composition <- readRDS(paste("../data/",analysisID,"/direct_user_input/visit_composition.rds",sep=''))
      outcome["activities"] <- 'Activities read from activities.rds as direct user input'
      outcome["visits"] <- 'Visits read from visits.rds as direct user input'
      outcome["visit_composition"] <- 'Visit composition read from visit_composition.rds as direct user input'
    }else{
      outcome["activities"] <- 'ERROR: source file not found'
      outcome["visits"] <- 'ERROR: source file not found'
      outcome["visit composition"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="activities"]=="synthetic" & source_info$source_type[source_info$data_element=="visits"]=="synthetic" & source_info$source_type[source_info$data_element=="visit composition"]=="synthetic"){
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
      visit_types <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$visit_types
      model_instance$activities <- rownames(visit_types)
      model_instance$visits <- colnames(visit_types)
      model_instance$visit_composition <- visit_types
      outcome["activities"] <- 'Activities identified from synthetic data'
      outcome["visits"] <- 'Visit types identified from synthetic data'
      outcome["visit composition"] <- 'Visit composition identified from synthetic data'
    }else{
      outcome["activities"] <- 'ERROR: source file not found'
      outcome["visits"] <- 'ERROR: source file not found'
      outcome["visit composition"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["activities"] <- 'ERROR: invalid input method'
    outcome["visits"] <- 'ERROR: invalid input method'
    outcome["visit composition"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="profiles"]=="user" & source_info$source_type[source_info$data_element=="profile counts"]=="user" & source_info$source_type[source_info$data_element=="profile demand"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/profiles.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/profile_counts.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/profile_demand.rds",sep=''))){
      model_instance$profiles <- readRDS(paste("../data/",analysisID,"/direct_user_input/profiles.rds",sep=''))
      model_instance$profile_counts <- readRDS(paste("../data/",analysisID,"/direct_user_input/profile_counts.rds",sep=''))
      model_instance$profile_demand <- readRDS(paste("../data/",analysisID,"/direct_user_input/profile_demand.rds",sep=''))
      outcome["profiles"] <- 'Profiles read from profiles.rds as direct user input'
      outcome["profile counts"] <- 'Profile counts read from profile_counts.rds as direct user input'
      outcome["profile demand"] <- 'Profile demand read from profile_demand.rds as direct user input'
    }else{
      outcome["profiles"] <- 'ERROR: source file not found'
      outcome["profile counts"] <- 'ERROR: source file not found'
      outcome["profile demand"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="profiles"]=="synthetic" & source_info$source_type[source_info$data_element=="profile counts"]=="synthetic" & source_info$source_type[source_info$data_element=="profile demand"]=="synthetic"){
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))){
      demand_data <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))
      profile_definition <- demand_data$profile_definition
      profile_counts <- demand_data$profile_counts
      activities_to_needs <- demand_data$activities_to_needs
      model_instance$profiles <- rownames(profile_counts)[apply(profile_counts[,model_instance$basic_units],1,sum)>0]
      model_instance$profile_counts <- apply(profile_counts[model_instance$profiles,model_instance$basic_units],1,sum)
      model_instance$profile_demand <- matrix(0,length(model_instance$profiles),length(model_instance$activities))
      rownames(model_instance$profile_demand) <- model_instance$profiles
      colnames(model_instance$profile_demand) <- model_instance$activities
      
      profiles <- profile_definition[model_instance$profiles]
      for(p in names(profiles)){
        def <- strsplit(profiles[p],split="______")[[1]]
        act <- sapply(def,function(s){strsplit(s,split='____')[[1]][1]})
        dem <- as.numeric(sapply(def,function(s){strsplit(s,split='____')[[1]][2]}))
        names(dem) <- act
        for(a in act){
          model_instance$profile_demand[p,a] <- dem[a]
        }
      }
      
      
      
#      tmp <- lapply(profile_definition[model_instance$profiles],function(def){
#        tmp2 <- lapply(strsplit(def,split="______")[[1]],function(a1){
#          a2 <- strsplit(a1,split='____')[[1]]
#          i <- which(activities_to_needs$need==a2[1] & activities_to_needs$level==a2[2])
#          j <- which(colnames(activities_to_needs)==a2[1])
#          activities_to_needs[i,j]
#        })
#        names(tmp2) <- sapply(strsplit(def,split="______")[[1]],function(a1){
#          strsplit(a1,split='____')[[1]][1]
#        })
#        tmp2
#      })
#      for(p in names(tmp)){
#        for(a in names(tmp[[p]])){
#          model_instance$profile_demand[p,a] <- tmp[[p]][[a]]
#        }
#      }
      outcome["profiles"] <- 'Profiles identified from synthetic data'
      outcome["profile counts"] <- 'Profile counts identified from synthetic data'
      outcome["profile demand"] <- 'Profile demand identified from synthetic data'
    }else{
      outcome["profiles"] <- 'ERROR: source file not found'
      outcome["profile counts"] <- 'ERROR: source file not found'
      outcome["profile demand"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["profiles"] <- 'ERROR: invalid input method'
    outcome["profile counts"] <- 'ERROR: invalid input method'
    outcome["profile demand"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="roles"]=="user" & source_info$source_type[source_info$data_element=="hourly rates"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/roles.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/hourly_rates.rds",sep=''))){
      model_instance$roles <- readRDS(paste("../data/",analysisID,"/direct_user_input/roles.rds",sep=''))
      model_instance$hourly_rates <- readRDS(paste("../data/",analysisID,"/direct_user_input/hourly_rates.rds",sep=''))
      outcome["roles"] <- 'Roles read from roles.rds as direct user input'
      outcome["hourly rates"] <- 'Hourly rates read from hourly_rates.rds as direct user input'
    }else{
      outcome["roles"] <- 'ERROR: source file not found'
      outcome["hourly rates"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="roles"]=="synthetic" & source_info$source_type[source_info$data_element=="hourly rates"]=="synthetic"){
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
      role_features <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$role_features
      model_instance$roles <- role_features$role
      model_instance$hourly_rates <- role_features$hourly_rate
      names(model_instance$hourly_rates) <- model_instance$roles
      outcome["roles"] <- 'Roles identified from synthetic data'
      outcome["hourly rates"] <- 'Hourly rates identified from synthetic data'
    }else{
      outcome["roles"] <- 'ERROR: source file not found'
      outcome["hourly rates"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["roles"] <- 'ERROR: invalid input method'
    outcome["hourly rates"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="visit durations"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/visit_duration.rds",sep=''))){
      model_instance$visit_duration <- readRDS(paste("../data/",analysisID,"/direct_user_input/visit_duration.rds",sep=''))
      outcome["visit durations"] <- 'Visit durations read from visit_duration.rds as direct user input'
    }else{
      outcome["visit durations"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="visit durations"]=="synthetic"){
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
      visit_times <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$visit_times
      model_instance$visit_duration <- visit_times[model_instance$visits]
      outcome["visit durations"] <- 'Visit durations identified from synthetic data'
    }else{
      outcome["visit durations"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["visit durations"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="role to visit"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/role_to_visit.rds",sep=''))){
      model_instance$role_to_visit <- readRDS(paste("../data/",analysisID,"/direct_user_input/role_to_visit.rds",sep=''))
      outcome["role to visit"] <- 'Role to visit read from role_to_visit.rds as direct user input'
    }else{
      outcome["role to visit"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="role to visit"]=="synthetic"){
    if(file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
      visits_to_role <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$visit_to_role
      model_instance$role_to_visit <- t(visits_to_role[model_instance$visits,model_instance$roles])
      outcome["role to visit"] <- 'Role to visit identified from synthetic data'
    }else{
      outcome["role to visit"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["role to visit"] <- 'ERROR: invalid input method'
  }
  
  saveRDS(model_instance,file=paste("../data/",analysisID,"/model_input/input_",analysisID,".rds",sep=''))

  return(cbind(source_info,building_outcome=outcome))

}





