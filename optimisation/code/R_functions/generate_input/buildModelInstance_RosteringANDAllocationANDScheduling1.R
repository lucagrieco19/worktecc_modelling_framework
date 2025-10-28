
buildModelInstance_RosteringANDAllocationANDScheduling1 <- function(analysisID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location,source_info){
  
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
  
  outcome <- rep('',length(data_elements))
  names(outcome) <- data_elements
  
  model_instance <- vector("list",length=0)
  
  
  if(source_info$source_type[source_info$data_element=="sub periods"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/subperiods.rds",sep=''))){
      model_instance$subperiods <- readRDS(paste("../data/",analysisID,"/direct_user_input/subperiods.rds",sep=''))
      outcome["sub periods"] <- 'Sub periods read from subperiods.rds as direct user input'
    }else{
      outcome["sub periods"] <- 'ERROR: source file not found'  
    }
  }else{
    outcome["sub periods"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="average travel speed"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/avg_travel_speed.rds",sep=''))){
      model_instance$avg_travel_speed <- readRDS(paste("../data/",analysisID,"/direct_user_input/avg_travel_speed.rds",sep=''))
      outcome["average travel speed"] <- 'Average travel speed read from avg_travel_speed.rds as direct user input'
    }else{
      outcome["average travel speed"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["average travel speed"] <- 'ERROR: invalid input method'
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
  
  if(source_info$source_type[source_info$data_element=="reference time period"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/ref_time_period.rds",sep=''))){
      model_instance$ref_time_period <- readRDS(paste("../data/",analysisID,"/direct_user_input/ref_time_period.rds",sep=''))
      outcome["reference time period"] <- 'Reference time period read from ref_time_period.rds as direct user input'
    }else{
      outcome["reference time period"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["reference time period"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="list of staff members"]=="user" & source_info$source_type[source_info$data_element=="staff roles"]=="user" & source_info$source_type[source_info$data_element=="association between staff and roles"]=="user" & source_info$source_type[source_info$data_element=="staff availability"]=="user" & source_info$source_type[source_info$data_element=="maximum workload per staff member"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/staff_members.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/roles.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/staff_to_role.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/subperiods_available.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/max_workload.rds",sep=''))){
      model_instance$staff_members <- readRDS(paste("../data/",analysisID,"/direct_user_input/staff_members.rds",sep=''))
      model_instance$roles <- readRDS(paste("../data/",analysisID,"/direct_user_input/roles.rds",sep=''))
      model_instance$staff_to_role <- readRDS(paste("../data/",analysisID,"/direct_user_input/staff_to_role.rds",sep=''))
      model_instance$subperiods_available <- readRDS(paste("../data/",analysisID,"/direct_user_input/subperiods_available.rds",sep=''))
      model_instance$max_workload <- readRDS(paste("../data/",analysisID,"/direct_user_input/max_workload.rds",sep=''))
      outcome["list of staff members"] <- 'List of staff members read from staff_members.rds as direct user input'
      outcome["staff roles"] <- 'Staff roles read from roles.rds as direct user input'
      outcome["association between staff and roles"] <- 'Association between staff and roles read from roles.rds as direct user input'
      outcome["staff availability"] <- 'Staff availability read from subperiods_available.rds as direct user input'
      outcome["maximum workload per staff member"] <- 'Maximum workload per staff member read from max_workload.rds as direct user input'
    }else{
      outcome["list of staff members"] <- 'ERROR: source file not found'
      outcome["staff roles"] <- 'ERROR: source file not found'
      outcome["association between staff and roles"] <- 'ERROR: source file not found'
      outcome["staff availability"] <- 'ERROR: source file not found'
      outcome["maximum workload per staff member"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="list of staff members"]=="upstream" & source_info$source_type[source_info$data_element=="staff roles"]=="upstream" & source_info$source_type[source_info$data_element=="association between staff and roles"]=="upstream" & source_info$source_type[source_info$data_element=="staff availability"]=="upstream" & source_info$source_type[source_info$data_element=="maximum workload per staff member"]=="synthetic" & file.exists(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))){
    upstr_team_mix_analysis <- upstream_analyses[upstream_methodIDs %in% c("TeamSizeAndComposition_heur")][1]
    team_mix_solution <- readRDS(paste("../data/",upstr_team_mix_analysis,"/model_output/solution_",upstr_team_mix_analysis,".rds",sep=''))
    
    staff_by_role <- team_mix_solution$sol_n_staff
    
    role_features <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$role_features
    max_hours <- role_features$max_daily_working_hours
    names(max_hours) <- role_features$role
    
    ##### Rostering heuristic procedure ########################
    
    roster <- vector('list',length=sum(staff_by_role>0))
    names(roster) <- names(staff_by_role[staff_by_role>0])
    
    staff_indices <- vector('list',length=length(roster))
    names(staff_indices) <- names(roster)
    
    for(role in names(roster)){
      
      nr <- staff_by_role[role]
      
      ndays <- 7
      
      av_days <- 5
      
      staff_indices[[role]] <- paste('s',1:ceiling(nr*ndays/av_days),sep='_')
      
      staff_by_role[role] <- length(staff_indices[[role]]) #assuming each salaried staff member is available 5 days a week
      
      assignment <- matrix('',nrow=nr,ncol=ndays)
      rownames(assignment) <- paste("shift",1:nr,sep='_')
      colnames(assignment) <- paste("day",1:ndays,sep='_')
      
      while(sum(assignment=='') > 0){
        
        for(j in staff_indices[[role]]){
          
          feasible_pairs <- vector('list',length=0)
          
          for(r in rownames(assignment)){
            for(c in colnames(assignment)){
              if(assignment[r,c]=='' & sum(assignment[,c]==j)==0 ){
                feasible_pairs <- c(feasible_pairs,list(c(r,c)))
              } 
            }
          }
          
          if(length(feasible_pairs) > 0){
            
            sel_pair <- feasible_pairs[[sample(1:length(feasible_pairs),1)]]
            
            assignment[sel_pair[1],sel_pair[2]] <- j
            
          }
          
        }
        
      }
      
      roster[[role]] <- assignment
      
    }
   
    ############################################################
    
    staff <- data.frame(
      staff_roles = rep(names(staff_by_role),times=staff_by_role)
    )
    staff$max_workload <- max_hours[staff$staff_roles]
    
    rownames(staff) <- paste("staff_member",1:nrow(staff),sep='')
    
    model_instance$staff_members <- rownames(staff)
    
    model_instance$staff_roles <- staff$staff_roles
    names(model_instance$staff_roles) <- model_instance$staff_members
    
    model_instance$roles <- unique(model_instance$staff_roles)
    
    for(role in names(roster)){
      
      staff_id <- names(which(model_instance$staff_roles==role))
      names(staff_id) <- staff_indices[[role]]
      
      for(r in rownames(roster[[role]])){
        for(c in colnames(roster[[role]])){
          roster[[role]][r,c] <- staff_id[roster[[role]][r,c]]
        }
      }
      
    }
    
    staff_to_role <- matrix(0,length(model_instance$staff_members),length(model_instance$roles))
    rownames(staff_to_role) <- model_instance$staff_members
    colnames(staff_to_role) <- model_instance$roles
    for(s in rownames(staff_to_role)){
      staff_to_role[s,model_instance$staff_roles[s]] <- 1
    }
    model_instance$staff_to_role <- staff_to_role
    
    model_instance$max_workload <- staff$max_workload
    names(model_instance$max_workload) <- model_instance$staff_members
    
    model_instance$subperiods_available <- matrix(0,length(model_instance$staff_members),length(model_instance$subperiods))
    rownames(model_instance$subperiods_available) <- model_instance$staff_members
    colnames(model_instance$subperiods_available) <- model_instance$subperiods
    for(s in rownames(model_instance$subperiods_available)){
      for(d in colnames(model_instance$subperiods_available)){
        if(sum(roster[[model_instance$staff_roles[s]]][,paste("day",d,sep='_')]==s)>0){
          model_instance$subperiods_available[s,d] <- 1
        }
      }
    }
    
    outcome["list of staff members"] <- 'List of staff members identified from upstream analysis'
    outcome["staff roles"] <- 'Staff roles identified from upstream analysis'
    outcome["association between staff and roles"] <- 'Association between staff and roles identified from upstream analysis'
    outcome["staff availability"] <- 'Staff availability identified from upstream analysis'
    outcome["maximum workload per staff member"] <- 'Maximum workload per staff member identified from synthetic data'
  }else{
    outcome["list of staff members"] <- 'ERROR: invalid input method'
    outcome["staff roles"] <- 'ERROR: invalid input method'
    outcome["association between staff and roles"] <- 'ERROR: invalid input method'
    outcome["staff availability"] <- 'ERROR: invalid input method'
    outcome["maximum workload per staff member"] <- 'ERROR: invalid input method'
  }
  
  
  if(source_info$source_type[source_info$data_element=="districts"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/district_structure.rds",sep=''))){
      distr_structure <- readRDS(paste("../data/",analysisID,"/direct_user_input/district_structure.rds",sep=''))
      model_instance$districts <- rownames(distr_structure)
      outcome["districts"] <- 'Districts read from district_structure.rds as direct user input'
    }else{
      outcome["districts"] <- 'ERROR: source file not found'  
    }
  }else if(source_info$source_type[source_info$data_element=="districts"]=="upstream"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/districts_of_interest.rds",sep=''))){
      districtIDs <- readRDS(paste("../data/",analysisID,"/direct_user_input/districts_of_interest.rds",sep=''))
      upstr_distr_analysis <- upstream_analyses[upstream_methodIDs %in% c("Districting1","Districting2")][1]
      distr_structure <- readRDS(paste("../data/",upstr_distr_analysis,"/model_output/solution_",upstr_distr_analysis,".rds",sep=''))$x_basic_unit_to_district[districtIDs,,drop=FALSE]
      model_instance$districts <- rownames(distr_structure)
      basic_units <- colnames(distr_structure)[apply(distr_structure,2,sum)>0]
      outcome["districts"] <- 'Districts identified from upstream analysis using information provided in districts_of_interest.rds as direct user input'
    }else{
      outcome["districts"] <- 'ERROR: source file not found'  
    }
  }else{
    outcome["districts"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="minimum proportion of visits to be conducted"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/min_prop_visits.rds",sep=''))){
      model_instance$min_prop_visits <- readRDS(paste("../data/",analysisID,"/direct_user_input/min_prop_visits.rds",sep=''))
      outcome["minimum proportion of visits to be conducted"] <- 'Minimum proportion of visits to be conducted read from min_prop_visits.rds as direct user input'
    }else{
      outcome["minimum proportion of visits to be conducted"] <- 'ERROR: source file not found'  
    }
  }else{
    outcome["minimum proportion of visits to be conducted"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="maximum number of unique staff patient pairs"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/max_unique_pairs.rds",sep=''))){
      model_instance$max_unique_pairs <- readRDS(paste("../data/",analysisID,"/direct_user_input/max_unique_pairs.rds",sep=''))
      outcome["maximum number of unique staff patient pairs"] <- 'Maximum number of unique staff patient pairs read from max_unique_pairs.rds as direct user input'
    }else{
      outcome["maximum number of unique staff patient pairs"] <- 'ERROR: source file not found'  
    }
  }else{
    outcome["maximum number of unique staff patient pairs"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="max budget"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/budget_limit.rds",sep=''))){
      model_instance$budget_limit <- readRDS(paste("../data/",analysisID,"/direct_user_input/budget_limit.rds",sep=''))
      outcome["max budget"] <- 'Max budget read from budget_limit.rds as direct user input'
    }else{
      outcome["max budget"] <- 'ERROR: source file not found'  
    }
  }else{
    outcome["max budget"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="list of patients"]=="user" & source_info$source_type[source_info$data_element=="list of visits"]=="user" & source_info$source_type[source_info$data_element=="service times"]=="user" & source_info$source_type[source_info$data_element=="association between visits and patients"]=="user" & source_info$source_type[source_info$data_element=="within district travel distance"]=="user" & source_info$source_type[source_info$data_element=="association between staff members and visits they can conduct"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/patients.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/visits.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/visit_time.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/visit_by_patient.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/visits_to_staff.rds",sep='')) & file.exists(paste("../data/",analysisID,"/direct_user_input/within_district_travel_time.rds",sep=''))){
      model_instance$patients <- readRDS(paste("../data/",analysisID,"/direct_user_input/patients.rds",sep=''))
      model_instance$visits <- readRDS(paste("../data/",analysisID,"/direct_user_input/visits.rds",sep=''))
      model_instance$visit_time <- readRDS(paste("../data/",analysisID,"/direct_user_input/visit_time.rds",sep=''))
      model_instance$visit_by_patient <- readRDS(paste("../data/",analysisID,"/direct_user_input/visit_by_patient.rds",sep=''))
      model_instance$visits_to_staff <- readRDS(paste("../data/",analysisID,"/direct_user_input/visits_to_staff.rds",sep=''))
      model_instance$within_district_travel_time <- readRDS(paste("../data/",analysisID,"/direct_user_input/within_district_travel_time.rds",sep=''))
      outcome["list of patients"] <- 'List of patients read from patients.rds as direct user input'
      outcome["list of visits"] <- 'List of visits read from visits.rds as direct user input'
      outcome["service times"] <- 'Service times read from visit_time.rds as direct user input'
      outcome["association between visits and patients"] <- 'Association between visits and patients read from visit_by_patient.rds as direct user input'
      outcome["association between staff members and visits they can conduct"] <- 'Association between staff members and visits they can conduct read from visits_to_staff.rds as direct user input'
      outcome["within district travel distance"] <- 'Within district travel distance read from within_district_travel_time.rds as direct user input'
    }else{
      outcome["list of patients"] <- 'ERROR: source file not found'
      outcome["list of visits"] <- 'ERROR: source file not found'
      outcome["service times"] <- 'ERROR: source file not found'
      outcome["association between visits and patients"] <- 'ERROR: source file not found'
      outcome["association between staff members and visits they can conduct"] <- 'ERROR: source file not found'
      outcome["within district travel distance"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="list of patients"]=="upstream and synthetic" & source_info$source_type[source_info$data_element=="list of visits"]=="upstream and synthetic" & source_info$source_type[source_info$data_element=="service times"]=="upstream and synthetic" & source_info$source_type[source_info$data_element=="association between visits and patients"]=="upstream and synthetic" & source_info$source_type[source_info$data_element=="within district travel distance"]=="upstream and synthetic" & source_info$source_type[source_info$data_element=="association between staff members and visits they can conduct"]=="upstream and synthetic"){
    if("WorkforceRolesANDHomeHealthCarePackages1" %in% upstream_methodIDs){
      upstr_hhc_plan_analysis <- upstream_analyses[upstream_methodIDs %in% c("WorkforceRolesANDHomeHealthCarePackages1")][1]
      hhc_solution <- readRDS(paste("../data/",upstr_hhc_plan_analysis,"/model_output/solution_",upstr_hhc_plan_analysis,".rds",sep=''))
      
      patients <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))$patients
      patient_needs <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/demand_data_",synth_dataID,".rds",sep=''))$patient_needs
      
      sel_patients <- unique(patient_needs[as.numeric(patient_needs$subperiod) %in% model_instance$ref_time_period,c("patID","profile")])
      sel_patients$basic_unit <- sapply(sel_patients$patID,function(p){
        patients[p,"basic_unit"]
      })
      sel_patients <- sel_patients[sel_patients$basic_unit %in% basic_units,]
      rownames(sel_patients) <- NULL
      
      visit_types <- hhc_solution$visits
      visits_by_profile <- sapply(visit_types,function(v){
        apply(hhc_solution$x_visit_to_profile_to_role[,,v],2,sum)
      })
      visits_by_profile <- visits_by_profile[intersect(sel_patients$profile,rownames(visits_by_profile)),apply(visits_by_profile,2,sum)>0]
      visit_types <- colnames(visits_by_profile)
      
      sel_patients <- sel_patients[sel_patients$profile %in% rownames(visits_by_profile),]

      demand <- Reduce('rbind',lapply(unique(sel_patients$patID),function(pat){
        pr <- sel_patients$profile[sel_patients$patID==pat]
        Reduce('rbind',lapply(pr,function(x){
          times <- visits_by_profile[x,]
          cbind(patID=pat,visit_type=rep(visit_types,times))
        }))
      }))

      rownames(demand) <- paste("visit",1:nrow(demand),sep='')
      
      model_instance$visits <- rownames(demand)
      
      model_instance$visits_to_staff <- matrix(0,length(model_instance$visits),length(model_instance$staff_members))
      rownames(model_instance$visits_to_staff) <- model_instance$visits
      colnames(model_instance$visits_to_staff) <- model_instance$staff_members
      for(v in model_instance$visits){
        for(s in model_instance$staff_members){
          if(hhc_solution$role_to_visit[model_instance$staff_roles[s],demand[v,"visit_type"]]==1){
            model_instance$visits_to_staff[v,s] <- 1
          }
        }
      }
      
      #remove visits that do not match any staff skills
      sel_visit_ind <- which(apply(model_instance$visits_to_staff,1,sum)>0)
      model_instance$visits_to_staff <- model_instance$visits_to_staff[sel_visit_ind,]
      model_instance$visits <- model_instance$visits[sel_visit_ind]
      demand <- demand[model_instance$visits,]
      model_instance$patients <- unique(demand[,"patID"])
      
      model_instance$visit_types <- demand[,"visit_type"]
      names(model_instance$visit_types) <- model_instance$visits
      
      model_instance$visit_time <- hhc_solution$visit_duration[demand[,"visit_type"]]
      names(model_instance$visit_time) <- model_instance$visits
      
      model_instance$visits_by_patient <- matrix(0,length(model_instance$visits),length(model_instance$patients))
      rownames(model_instance$visits_by_patient) <- model_instance$visits
      colnames(model_instance$visits_by_patient) <- model_instance$patients
      for(i in 1:nrow(demand)){
        model_instance$visits_by_patient[rownames(model_instance$visits_by_patient)==rownames(demand)[i],colnames(model_instance$visits_by_patient)==demand[i,"patID"]] <- 1
      }
      
      model_instance$within_district_travel_time <- mean(sapply(model_instance$districts,function(d){
        bu <- colnames(distr_structure)[distr_structure[d,]==1]
        (mean(dist(patients[(rownames(patients) %in% demand[,"patID"]) & (as.character(patients$basic_unit) %in% bu),c("x_coord","y_coord")])) / 1000) * model_instance$mult_eucl_to_real / model_instance$avg_travel_speed
      }))
      
      outcome["list of patients"] <- 'List of patients identified from upstream analysis and synthetic data'
      outcome["list of visits"] <- 'List of visits identified from upstream analysis and synthetic data'
      outcome["service times"] <- 'Service times identified from upstream analysis and synthetic data'
      outcome["association between visits and patients"] <- 'Association between visits and patients identified from upstream analysis and synthetic data'
      outcome["association between staff members and visits they can conduct"] <- 'Association between staff members and visits they can conduct identified from upstream analysis and synthetic data'
      outcome["within district travel distance"] <- 'Within district travel distance identified from upstream analysis and synthetic data'
    }else{
      outcome["list of patients"] <- 'ERROR: source file not found'
      outcome["list of visits"] <- 'ERROR: source file not found'
      outcome["service times"] <- 'ERROR: source file not found'
      outcome["association between visits and patients"] <- 'ERROR: source file not found'
      outcome["association between staff members and visits they can conduct"] <- 'ERROR: source file not found'
      outcome["within district travel distance"] <- 'ERROR: source file not found'
    }
  }else{
    outcome["list of patients"] <- 'ERROR: invalid input method'
    outcome["list of visits"] <- 'ERROR: invalid input method'
    outcome["service times"] <- 'ERROR: invalid input method'
    outcome["association between visits and patients"] <- 'ERROR: invalid input method'
    outcome["association between staff members and visits they can conduct"] <- 'ERROR: invalid input method'
    outcome["within district travel distance"] <- 'ERROR: invalid input method'
  }
  
  if(source_info$source_type[source_info$data_element=="salary"]=="user"){
    if(file.exists(paste("../data/",analysisID,"/direct_user_input/salary.rds",sep=''))){
      model_instance$salary <- readRDS(paste("../data/",analysisID,"/direct_user_input/salary.rds",sep=''))[model_instance$staff_members]
      outcome["salary"] <- 'Salary read from salary.rds as direct user input'
    }else{
      outcome["salary"] <- 'ERROR: source file not found'
    }
  }else if(source_info$source_type[source_info$data_element=="salary"]=="synthetic"){
    role_features <- readRDS(paste(synth_data_location,'/',synth_dataID,"/output/service_data_",synth_dataID,".rds",sep=''))$role_features
    
    hourly_rates <- sapply(model_instance$staff_members,function(s){
      r <- colnames(model_instance$staff_to_role)[which(model_instance$staff_to_role[s,]==1)][1]
      role_features$hourly_rate[which(role_features$role==r)[1]]
    })
    model_instance$salary <- hourly_rates * model_instance$max_workload
    names(model_instance$salary) <- model_instance$staff_members
    
    outcome["salary"] <- 'Salary identified from synthetic data'
  }else{
    outcome["salary"] <- 'ERROR: invalid input method'
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
  
  saveRDS(model_instance,file=paste("../data/",analysisID,"/model_input/input_",analysisID,".rds",sep=''))

  return(cbind(source_info,building_outcome=outcome))

}


