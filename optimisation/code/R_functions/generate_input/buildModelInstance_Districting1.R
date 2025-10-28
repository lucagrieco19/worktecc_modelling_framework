
buildModelInstance_Districting1 <- function(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location,source_info){
  
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
  
  outcome <- rep('',length(data_elements))
  names(outcome) <- data_elements
  
  model_instance <- vector("list",length=0)
  
  if(source_info$source_type[source_info$data_element=="list of districts"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/districts.rds",sep=''))){
      model_instance$districts <- readRDS(paste("../data/",analysisID,"/direct_user_input/districts.rds",sep=''))
      outcome["list of districts"] <- 'List of districts read from districts.rds as direct user input'
    }else{
      outcome["list of districts"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["list of districts"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="euclidean to real distance factor"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/mult_eucl_to_real.rds",sep=''))){
      model_instance$mult_eucl_to_real <- readRDS(paste("../data/",analysisID,"/direct_user_input/mult_eucl_to_real.rds",sep=''))
      outcome["euclidean to real distance factor"] <- 'Euclidean to real distance factor read from mult_eucl_to_real.rds as direct user input'
    }else{
      outcome["euclidean to real distance factor"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["euclidean to real distance factor"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="maximum basic unit distance"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/d_max.rds",sep=''))){
      model_instance$d_max <- readRDS(paste("../data/",analysisID,"/direct_user_input/d_max.rds",sep=''))
      outcome["maximum basic unit distance"] <- 'Maximum basic unit distance read from d_max.rds as direct user input'
    }else{
      outcome["maximum basic unit distance"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["maximum basic unit distance"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="maximum workload deviation"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/tau.rds",sep=''))){
      model_instance$tau <- readRDS(paste("../data/",analysisID,"/direct_user_input/tau.rds",sep=''))
      outcome["maximum workload deviation"] <- 'Maximum workload deviation read from tau.rds as direct user input'
    }else{
      outcome["maximum workload deviation"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["maximum workload deviation"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="weights of objective function components"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/obj_weights.rds",sep=''))){
      model_instance$obj_weights <- readRDS(paste("../data/",analysisID,"/direct_user_input/obj_weights.rds",sep=''))
      outcome["weights of objective function components"] <- 'Weights of objective function components read from obj_weights.rds as direct user input'
    }else{
      outcome["weights of objective function components"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["weights of objective function components"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="list of basic units"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/basic_units.rds",sep=''))){
      model_instance$basic_units <- readRDS(paste("../data/",analysisID,"/direct_user_input/basic_units.rds",sep=''))
      outcome["list of basic units"] <- 'List of basic units read from basic_units.rds as direct user input'
      if(file.exists(paste(synth_data_location,'/',synth_dataID,"/geographic_area.rds",sep=''))){
        outcome["list of basic units"] <- paste(outcome["list of basic units"],' - note, relevant synthetic data might be available',sep='')
      }
    }else{
      outcome["list of basic units"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="list of basic units"]=="synthetic"){
    geographic_area <- readRDS(paste(synth_data_location,'/',synth_dataID,"/input/geographic_area.rds",sep=''))
    model_instance$basic_units <- as.character(geographic_area@data$NAME)
    outcome["list of basic units"] <- 'List of basic units identified from synthetic data'
  }else{
    outcome["list of basic units"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="basic unit pairwise distances"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/basic_unit_distances.rds",sep=''))){
      model_instance$basic_unit_distances <- readRDS(paste("../data/",analysisID,"/direct_user_input/basic_unit_distances.rds",sep=''))
      model_instance$basic_unit_distances <- model_instance$basic_unit_distances[model_instance$basic_units,model_instance$basic_units]
      outcome["basic unit pairwise distances"] <- 'Basic unit pairwise distances read from basic_unit_distances.rds as direct user input'
      if(file.exists(paste(synth_data_location,'/',synth_dataID,"/geographic_area.rds",sep=''))){
        outcome["basic unit pairwise distances"] <- paste(outcome["basic unit pairwise distances"],' - note, relevant synthetic data might be available',sep='')
      }
    }else{
      outcome["basic unit pairwise distances"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="basic unit pairwise distances"]=="synthetic"){
    geographic_area <- readRDS(paste(synth_data_location,'/',synth_dataID,"/input/geographic_area.rds",sep=''))
    model_instance$basic_unit_distances <- (as.matrix(dist(geographic_area@data[,c("x_centroid","y_centroid")])) / 1000) * model_instance$mult_eucl_to_real
    rownames(model_instance$basic_unit_distances) <- as.character(geographic_area@data$NAME)
    colnames(model_instance$basic_unit_distances) <- as.character(geographic_area@data$NAME)
    model_instance$basic_unit_distances <- model_instance$basic_unit_distances[model_instance$basic_units,model_instance$basic_units]
    outcome["basic unit pairwise distances"] <- 'Basic unit pairwise distances identified from synthetic data'
  }else{
    outcome["basic unit pairwise distances"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="basic unit compatibility"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/basic_unit_compatibility.rds",sep=''))){
      model_instance$basic_unit_compatibility <- readRDS(paste("../data/",analysisID,"/direct_user_input/basic_unit_compatibility.rds",sep=''))
      model_instance$basic_unit_compatibility <- model_instance$basic_unit_compatibility[model_instance$basic_units,model_instance$basic_units]
      outcome["basic unit compatibility"] <- 'Basic unit compatibility read from basic_unit_compatibility.rds as direct user input'
    }else{
      outcome["basic unit compatibility"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["basic unit compatibility"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="basic unit contiguity"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/basic_unit_contiguity.rds",sep=''))){
      model_instance$basic_unit_contiguity <- readRDS(paste("../data/",analysisID,"/direct_user_input/basic_unit_contiguity.rds",sep=''))
      model_instance$basic_unit_contiguity <- model_instance$basic_unit_contiguity[model_instance$basic_units,model_instance$basic_units]
      outcome["basic unit contiguity"] <- 'Basic unit contiguity read from basic_unit_contiguity.rds as direct user input'
    }else{
      outcome["basic unit contiguity"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["basic unit contiguity"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="activity types"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/activity_types.rds",sep=''))){
      model_instance$activity_types <- readRDS(paste("../data/",analysisID,"/direct_user_input/activity_types.rds",sep=''))
      outcome["activity types"] <- 'Activity types read from activity_types.rds as direct user input'
      if(file.exists(paste(synth_data_location,'/',synth_dataID,"/activity_features.rds",sep=''))){
        outcome["activity types"] <- paste(outcome["activity types"],' - note, relevant synthetic data might be available',sep='')
      }
    }else{
      outcome["activity types"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="activity types"]=="synthetic"){
    activity_features <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$activity_features
    model_instance$activity_types <- rownames(activity_features)
    outcome["activity types"] <- 'Activity types identified from synthetic data'
  }else{
    outcome["activity types"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="activity times"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/activity_times.rds",sep=''))){
      model_instance$activity_times <- readRDS(paste("../data/",analysisID,"/direct_user_input/activity_times.rds",sep=''))
      outcome["activity times"] <- 'Activity times read from activity_times.rds as direct user input'
      if(file.exists(paste(synth_data_location,'/',synth_dataID,"/activity_features.rds",sep=''))){
        outcome["activity times"] <- paste(outcome["activity times"],' - note, relevant synthetic data might be available',sep='')
      }
    }else{
      outcome["activity times"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="activity times"]=="synthetic"){
    activity_features <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$activity_features
    model_instance$activity_times <- as.numeric(as.character(activity_features$service_time))
    names(model_instance$activity_times) <- rownames(activity_features)
    outcome["activity times"] <- 'Activity times identified from synthetic data'
  }else{
    outcome["activity times"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="basic unit annual demand"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/basic_unit_annual_demand.rds",sep=''))){
      model_instance$basic_unit_annual_demand <- readRDS(paste("../data/",analysisID,"/direct_user_input/basic_unit_annual_demand.rds",sep=''))
      outcome["basic unit annual demand"] <- 'Basic unit annual demand read from basic_unit_annual_demand.rds as direct user input'
      if(file.exists(paste(synth_data_location,'/',synth_dataID,"/only_hc_patients.rds",sep='')) & file.exists(paste(synth_data_location,'/',synth_dataID,"/only_hc_patient_needs.rds",sep='')) & file.exists(paste(synth_data_location,'/',synth_dataID,"/activities_to_needs.rds",sep=''))){
        outcome["basic unit annual demand"] <- paste(outcome["basic unit annual demand"],' - note, relevant synthetic data might be available',sep='')
      }
    }else{
      outcome["basic unit annual demand"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="basic unit annual demand"]=="synthetic"){
    patients <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))$patients
    patient_needs <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))$patient_needs
    model_instance$basic_unit_annual_demand <- matrix(0,length(model_instance$basic_units),length(model_instance$activity_types))
    rownames(model_instance$basic_unit_annual_demand) <- model_instance$basic_units
    colnames(model_instance$basic_unit_annual_demand) <- model_instance$activity_types
    needs_and_locations <- cbind(patient_needs,basic_unit=patients[as.character(patient_needs$patID),"basic_unit"])
    
    for(b in rownames(model_instance$basic_unit_annual_demand)){
      for(n in colnames(model_instance$basic_unit_annual_demand)){
        model_instance$basic_unit_annual_demand[b,n] <- sum(needs_and_locations$times[needs_and_locations$basic_unit==b & needs_and_locations$need==n])
      }
    }
    
    outcome["basic unit annual demand"] <- 'Basic unit annual demand identified from synthetic data'
  }else{
    outcome["basic unit annual demand"] <- 'ERROR: invalid input method'
  }
  
  saveRDS(model_instance,file=paste("../data/",analysisID,"/model_input/input_",analysisID,".rds",sep=''))
  
  return(cbind(source_info,building_outcome=outcome))
  
}

