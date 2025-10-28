
readOptimalSolution <- function(loc,anID,md){
  
  source("R_functions/cplex_interface/CPLEXoutputToNumericArray.R")
  
  inputObjects <- readRDS(paste(loc,'/',anID,"/model_input/input_",anID,".rds",sep=''))
  
  output_files <- dir(paste(loc,anID,"model_output",sep='/'))
  output_files <- output_files[grep(".txt",output_files)]
  
  outputObjects <- lapply(output_files,function(x){
    obj_name <- strsplit(x,split='.txt')[[1]][1]
    obj_name <- strsplit(obj_name,split='__')[[1]]
    
    obj_iter <- 0
    if(length(obj_name)==2){
      obj_iter <- obj_name[1]
      obj_name <- obj_name[2]
    }else{
      obj_name <- obj_name[1]
    }
    
    dim_list <- strsplit(as.character(md$dimensions)[md$output_object==obj_name],split=',')[[1]]
    dimnames <- vector('list',length=length(dim_list))
    names(dimnames) <- dim_list
    for(i in 1:length(dim_list)){
      if(is.list(inputObjects[[dim_list[i]]])){
        dimnames[[i]] <- inputObjects[[dim_list[i]]][[obj_iter]]
      }else{
        dimnames[[i]] <- inputObjects[[dim_list[i]]]
      }
    }
    
    dim <- sapply(dimnames,length)
    CPLEXoutputToNumericArray(paste(loc,anID,"model_output",x,sep='/'),dim,dimnames)
  })
  names(outputObjects) <- sapply(output_files,function(x){
    strsplit(x,split='.txt')[[1]][1]
  })
  
  res <- c(inputObjects,outputObjects)
  
  return(res)
  
}



