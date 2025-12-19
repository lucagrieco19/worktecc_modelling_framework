
generatePatientNeeds <- function(patients,init_prob,switch_prob,state_to_need,n_time_frames){
  
  needs_by_patient <- lapply(rownames(patients),function(x){
    
    group <- as.character(patients[x,]$patient_group)
    
    states <- sample(names(init_prob[[group]]),1,prob=init_prob[[group]])
    for(i in 2:n_time_frames){
      states <- c(states,sample(colnames(switch_prob[[group]]),1,prob=switch_prob[[group]][states[i-1],]))
    }
    while(sum(states%in%names(which(apply(state_to_need[[group]],2,sum)==0)))==n_time_frames){ #NOTE: the patient needs to be in a state different from "state0" in at least one time frame
      states <- sample(names(init_prob[[group]]),1,prob=init_prob[[group]])
      for(i in 2:n_time_frames){
        states <- c(states,sample(colnames(switch_prob[[group]]),1,prob=switch_prob[[group]][states[i-1],]))
      }
    }
    names(states) <- paste("subperiod",1:n_time_frames,sep='_')
    
    res <- lapply(states,function(s){
      tmp <- sapply(rownames(state_to_need[[group]]),function(f){
        state_to_need[[group]][f,s]
      })
      tmp[tmp>0]
    })
    
    res <- do.call(rbind.data.frame,lapply(which(sapply(res,length)>0),function(r){
      cbind(subperiod=rep(r,length(res[[r]])),need=names(res[[r]]),times=res[[r]])
    }))
    rownames(res) <- NULL
    
    res
    
  })
  names(needs_by_patient) <- rownames(patients)
  
  patient_needs <- data.frame(
    patID=rep(rownames(patients),sapply(needs_by_patient,nrow)),
    group=rep(as.character(patients$patient_group),sapply(needs_by_patient,nrow)),
    do.call(rbind.data.frame,needs_by_patient)
  )
  rownames(patient_needs) <- NULL
  patient_needs <- patient_needs[order(as.numeric(as.character(patient_needs$subperiod))),]
  
  rownames(patient_needs) <- NULL
  
  #compute weekly profiles
  needs_for_planning_period <- cbind(patient_needs,basic_unit=patients[as.character(patient_needs$patID),"basic_unit"])
  needs_for_planning_period$patID <- paste(as.character(needs_for_planning_period$patID),as.character(needs_for_planning_period$subperiod),sep='_')
  
  tmp1 <- vector('list',length=length(unique(needs_for_planning_period$patID)))
  names(tmp1) <- unique(needs_for_planning_period$patID)
  for(i in 1:length(tmp1)){
    tmp1[[i]] <- needs_for_planning_period[which(needs_for_planning_period$patID==names(tmp1)[i]),c("need","times")]
  }
  
  tmp2 <- sapply(tmp1,function(x){
    tmp3 <- paste(x$need,x$times,sep='____')
    tmp3 <- tmp3[order(tmp3)]
    paste(tmp3,collapse='______')
  })
  
  tmp2_loc <- sapply(names(tmp2),function(p){
    needs_for_planning_period$basic_unit[needs_for_planning_period$patID==p][1]
  })
  names(tmp2_loc) <- tmp2
  
  tmp_profile_definition <- unique(tmp2)
  tmp_profile_counts <- sapply(geographic_area@data$NAME,function(y){
    sapply(tmp_profile_definition,function(p){sum(names(tmp2_loc[tmp2_loc==y])==p)})
  })
  profile_definition <- tmp_profile_definition[apply(tmp_profile_counts,1,sum)>=0]
  profile_counts <- tmp_profile_counts[profile_definition,]
  names(profile_definition) <- paste("pat_profile",1:length(profile_definition),sep='')
  rownames(profile_counts) <- names(profile_definition)
  
  patient_profiles <- names(profile_definition)
  
  pat_profile_by_week <- lapply(unique(patient_needs$patID),function(p){
    sel1 <- patient_needs[patient_needs$patID==p,]
    subper <- unique(sel1$subperiod)
    res <- lapply(subper,function(i){
      sel2 <- sel1[sel1$subperiod==i,]
      sel3 <- paste(sel2$need,sel2$times,sep='____')
      sel3 <- sel3[order(sel3)]
      str <- paste(sel3,collapse='______')
      if(str %in% profile_definition){
        names(profile_definition)[profile_definition==str]
      }else{
        NA
      }
    })
    names(res) <- subper
    res
  })
  names(pat_profile_by_week) <- unique(patient_needs$patID)
  
  patient_needs$profile <- sapply(1:nrow(patient_needs),function(i){
    pat_profile_by_week[[patient_needs$patID[i]]][[patient_needs$subperiod[i]]]
  })
  
  patient_needs <- na.omit(patient_needs)
  patient_needs$subperiod <- as.numeric(patient_needs$subperiod)
  patient_needs$times <- as.numeric(patient_needs$times)
  
  return(list(
    patient_needs = patient_needs,
    profile_definition = profile_definition,
    profile_counts = profile_counts
  ))
  
}




