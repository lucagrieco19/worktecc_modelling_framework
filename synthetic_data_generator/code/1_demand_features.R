library(sp)

source("R_functions/generatePatients.R")
source("R_functions/generatePatientNeeds.R")

#provide path to the folder "data" (without slash at the end of the string)
path <- "../data"

#provide a unique ID for the current dataset (e.g. "Dataset1")
datasetID <- as.character(read.table("current_dataset_ID.txt",header=FALSE)[,1])

#load geographic area
geographic_area <- readRDS(paste(path,datasetID,"input/geographic_area.rds",sep='/'))


###### Generate demand data ######################################################

#load input on patient characteristics
state_freq <- readRDS(paste(path,datasetID,"input/state_freq.rds",sep='/'))
state_switch_freq <- readRDS(paste(path,datasetID,"input/state_switch_freq.rds",sep='/'))
patient_need_states <- readRDS(paste(path,datasetID,"input/patient_need_states.rds",sep='/'))
patient_distribution <- readRDS(paste(path,datasetID,"input/patient_distribution.rds",sep='/'))

#read the number of planning periods of interest
planningPeriods <- readRDS(paste(path,datasetID,"input/number_of_weeks.rds",sep='/'))

#generate the total number of patients over the whole planning period
expected_number_of_patients <- readRDS(paste(path,datasetID,"input/expected_number_of_patients.rds",sep='/'))
totPat <- round(rpois(1,expected_number_of_patients),0)

#generate patient profiles and locations
patients <- generatePatients(totPat,patient_distribution,geographic_area)

#generate patient state evolution over the reference planning period
patient_needs_and_profiles <- generatePatientNeeds(patients,state_freq,state_switch_freq,patient_need_states,planningPeriods)


###### Save output ################################################################

output <- list(
  patients = patients,
  patient_needs = patient_needs_and_profiles$patient_needs,
  profile_definition = patient_needs_and_profiles$profile_definition,
  profile_counts = patient_needs_and_profiles$profile_counts
)
saveRDS(output,file=paste(path,'/',datasetID,"/output/demand_data_",datasetID,".rds",sep=''))



