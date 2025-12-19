
generatePatients <- function(totPat,patient_distribution,geographic_area){
  
  library(sp)
  
  #generate set of patient IDs
  patIDs <- paste("pat",1:totPat,sep='')
  
  #assign each patient to a patient profile and a basic unit
  comb <- data.frame(group=rep(rownames(patient_distribution),ncol(patient_distribution)),basic_unit=rep(colnames(patient_distribution),each=nrow(patient_distribution)))
  comb$prob <- sapply(1:nrow(comb),function(i){
     patient_distribution[comb$group[i],comb$basic_unit[i]]
  })
  assign <- sample(1:nrow(comb),length(patIDs),prob=comb$prob,replace=TRUE)
  patientBasicUnits <- as.character(comb$basic_unit[assign])
  names(patientBasicUnits) <- patIDs
  patientGroups <- as.character(comb$group[assign])
  names(patientGroups) <- patIDs

  #generate xy-coordinates of patient locations within the corresponding basic units
  patientLocations <- matrix(unlist(lapply(patientBasicUnits,function(x){
    id <- rownames(geographic_area@data)[geographic_area@data$NAME==x]
    spsample(geographic_area[id,],1,type="random",iter=100)@coords[1,]
  })),ncol=2,byrow=TRUE)
  rownames(patientLocations) <- patIDs
  colnames(patientLocations) <- c("x_coord","y_coord")
  
  res <- data.frame(patient_group=patientGroups,basic_unit=patientBasicUnits,patientLocations)
  rownames(res) <- patIDs
  
  return(res)
  
}


