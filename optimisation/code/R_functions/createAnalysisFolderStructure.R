
createAnalysisFolderStructure <- function(loc,anID){
  
  if(!file.exists(paste(loc,anID,sep='/'))){
    
    dir.create(paste(loc,anID,sep='/'))
    
    file.create(paste(loc,anID,'selected_method.txt',sep='/'))
    write.table(NA,file=paste(loc,anID,"upstream_analyses.txt",sep='/'),col.names=FALSE,row.names=FALSE,quote=FALSE,sep='\t',dec='.')
    
    dir.create(paste(loc,anID,'direct_user_input',sep='/'))
    dir.create(paste(loc,anID,'model_input',sep='/'))
    dir.create(paste(loc,anID,'model_output',sep='/'))
    
    
  }else{
    cat("Error: the analysis ID provided already exists, please provide a different one")
  }
  
}

