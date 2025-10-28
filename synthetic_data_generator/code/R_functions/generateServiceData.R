
generateServiceData <- function(activity_features,activity_to_role,patient_needs,profile_definition,additional_time){
  
  #determine visit types
  activities <- unique(patient_needs$need)
  activities <- activities[order(activities)]
  visit_types <- do.call(cbind,lapply(profile_definition,function(x){
    act <- sapply(strsplit(x,split="______")[[1]],function(y){strsplit(y,split="____")[[1]][1]})
    sapply(powerSet(act),function(z){1 * (activities %in% z)})
  }))
  rownames(visit_types) <- activities
  visit_types <- t(unique(t(visit_types)))
  visit_types <- visit_types[,apply(visit_types,2,sum)>0]
  colnames(visit_types) <- paste("visit_type",1:ncol(visit_types),sep='')
  
  #association between staff types and visits
  visit_to_role <- matrix(0,ncol(visit_types),ncol(activity_to_role))
  rownames(visit_to_role) <- colnames(visit_types)
  colnames(visit_to_role) <- colnames(activity_to_role)
  for(v in rownames(visit_to_role)){
    for(s in colnames(visit_to_role)){
      tmp1 <- rownames(visit_types)[visit_types[,v]==1]
      tmp2 <- rownames(activity_to_role)[activity_to_role[,s]==1]
      visit_to_role[v,s] <- prod(tmp1 %in% tmp2)
    }
  }
  visit_to_role <- visit_to_role[apply(visit_to_role,1,sum)>0,]
  visit_types <- visit_types[,rownames(visit_to_role)]
  activity_to_role <- as.matrix(activity_to_role[rownames(visit_types),])
  activity_features <- activity_features[rownames(visit_types),]
  colnames(visit_types) <- paste("visit_type",1:ncol(visit_types),sep='')
  rownames(visit_to_role) <- colnames(visit_types)
  
  #compute visit times
  visit_times <- apply(visit_types * activity_features$service_time,2,sum) + additional_time
  
  return(list(
    activity_features = activity_features,
    activity_to_role = activity_to_role,
    visit_types = visit_types,
    visit_times = visit_times,
    visit_to_role = visit_to_role
  ))
  
}




