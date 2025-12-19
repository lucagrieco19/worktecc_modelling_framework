library(rje)

source("R_functions/generateServiceData.R")

#provide path to the folder "data" (without slash at the end of the string)
path <- "../data"

#provide a unique ID for the current dataset (e.g. "Dataset1")
datasetID <- as.character(read.table("current_dataset_ID.txt",header=FALSE)[,1])

demand_data <- readRDS(paste(path,'/',datasetID,"/output/demand_data_",datasetID,".rds",sep=''))
patient_needs <- demand_data$patient_needs
profile_definition <- demand_data$profile_definition

#load activity and role info
activity_features <- readRDS(paste(path,datasetID,"input/activity_features.rds",sep='/'))
activity_features <- activity_features[order(rownames(activity_features)),]

role_features <- readRDS(paste(path,datasetID,"input/role_features.rds",sep='/'))

activity_to_role <- readRDS(paste(path,datasetID,"input/activity_to_role.rds",sep='/'))
activity_to_role <- activity_to_role[order(rownames(activity_to_role)),]

additional_time <- readRDS(paste(path,datasetID,"input/overhead_visit_time.rds",sep='/'))

#generate visits and their association with available roles
visits_and_roles <- generateServiceData(activity_features,activity_to_role,patient_needs,profile_definition,additional_time)


###### Save output ################################################################

output <- list(
  activity_features = visits_and_roles$activity_features,
  role_features = role_features,
  activity_to_role = visits_and_roles$activity_to_role,
  visit_types = visits_and_roles$visit_types,
  visit_times = visits_and_roles$visit_times,
  visit_to_role = visits_and_roles$visit_to_role
)
saveRDS(output,file=paste(path,'/',datasetID,"/output/service_data_",datasetID,".rds",sep=''))




