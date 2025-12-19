rm(list=ls())

library(xlsx)

source("R_functions/reading_output/readOptimalSolution.R")
source("R_functions/reading_output/readHeuristicSolution.R")
source("R_functions/reading_output/computePerformance.R")

#provide path to the folder "data" (without slash at the end of the string)
path <- "../data"

#provide a unique ID for the current analysis (e.g. "Analysis3")
analysisID <- as.character(read.table("current_analysis_ID.txt",header=FALSE)[,1])

#read method ID
methodID <- as.character(read.table(paste(path,analysisID,"selected_method.txt",sep='/'),header=FALSE,dec='.',sep='\t')[,1])

if(grepl("heur",methodID)){
  
  solution <- readHeuristicSolution(path,analysisID)
  
}else{
  #read output metadata
  metadata <- read.xlsx(paste("output_metadata/",methodID,".xlsx",sep=''),sheetIndex=1)
  
  #load solution objects
  solution <- readOptimalSolution(path,analysisID,metadata)
  
}

#save all model parameters and solution as an R object
saveRDS(solution,file=paste(path,'/',analysisID,"/model_output/solution_",analysisID,".rds",sep=''))

#compute performance
performance <- computePerformance(methodID,solution)
write.xlsx(performance,file=paste(path,'/',analysisID,"/model_output/performance_summary_",analysisID,".xlsx",sep=''),col.names=FALSE)


