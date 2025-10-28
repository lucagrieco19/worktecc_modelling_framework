
readHeuristicSolution <- function(loc,anID){
  
  inputObjects <- readRDS(paste(loc,'/',anID,"/model_input/input_",anID,".rds",sep=''))
  
  outputObjects <- readRDS(paste(loc,'/',anID,"/model_output/output_",anID,".rds",sep=''))
  
  res <- c(inputObjects,outputObjects)
  
  return(res)
  
}



