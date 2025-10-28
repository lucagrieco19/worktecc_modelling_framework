rm(list=ls())

source("R_functions/solveProblem.R")

#make sure the command oplrun (CPLEX) is accessible from the R session
new_path <- "/Applications/CPLEX_Studio2211/opl/bin/arm64_osx"
old_path <- Sys.getenv("PATH")
Sys.setenv(PATH = paste(old_path, new_path, sep = ":"))

#provide path from current R folder to the folder "data" (without slash at the end of the string)
path <- "../data"

#provide path from model formulation folder to the folder "data" (without slash at the end of the string)
mod_path <- "../../../../data"

#provide a unique ID for the current analysis (e.g. "Analysis3")
analysisID <- as.character(read.table("current_analysis_ID.txt",header=FALSE)[,1])

#read method ID
methodID <- as.character(read.table(paste(path,analysisID,"selected_method.txt",sep='/'),header=FALSE,dec='.',sep='\t')[,1])

#upload input data
input_list <- readRDS(paste(path,'/',analysisID,"/model_input/input_",analysisID,".rds",sep=''))

#solve problem
solveProblem(methodID,path,mod_path,analysisID,input_list)

