rm(list=ls())

library(xlsx)
source("R_functions/data_checks/checkDataSources.R")

#provide path to the folder "analyses" (without slash at the end of the string)
path <- "../data"

#provide a unique ID for the current analysis (e.g. "Analysis3")
analysisID <- as.character(read.table("current_analysis_ID.txt",header=FALSE)[,1])

#read method ID
methodID <- as.character(read.table(paste(path,analysisID,"selected_method.txt",sep='/'),header=FALSE,dec='.',sep='\t')[,1])

#read IDs of upstream analyses
upstream_analyses <- as.character(read.table(paste(path,analysisID,"upstream_analyses.txt",sep='/'),header=FALSE,dec='.',sep='\t')[,1])

#read methods associated with upstream analyses
upstream_methodIDs <- NA
if(sum(!is.na(upstream_analyses))>0){
  upstream_methodIDs <- as.character(sapply(upstream_analyses,function(x){
    as.character(read.table(paste(path,x,"selected_method.txt",sep='/'),header=FALSE,dec='.',sep='\t')[,1])
  }))
  names(upstream_methodIDs) <- upstream_analyses
}

#read location of synthetic data
synth_data_location <- as.character(read.table("synth_data_location.txt",header=FALSE)[,1])

#read ID of synthetic data
synth_dataID <- as.character(read.table("synth_data_ID.txt",header=FALSE)[,1])

#chech existence of data sources to build model instance
source_info <- checkDataSources(analysisID,methodID,upstream_analyses,upstream_methodIDs,synth_dataID,synth_data_location)

#write results to file
write.xlsx(source_info,file=paste(path,analysisID,"source_info.xlsx",sep='/'),row.names=FALSE)
cat('Please provide input data sources as specified in "source_info.xlsx". Direct user input can be enforced by replacing "upstream" or "synthetic" with "user" in the source_type column.')


