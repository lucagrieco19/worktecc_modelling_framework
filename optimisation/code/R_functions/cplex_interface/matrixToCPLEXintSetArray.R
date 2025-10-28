
matrixToCPLEXintSetArray <- function(m,name){
  
  m <- as.matrix(m)
  
  res <- paste(name,' = [',sep='')
  
  res <- paste(res,'\n{ ',paste(colnames(m)[m[1,]==1],collapse=' , '),' }',sep='')
  
  if(nrow(m)>1){
    for(i in 2:nrow(m)){
      res <- paste(res,',','\n{ ',paste(colnames(m)[m[i,]==1],collapse=' , '),' }',sep='')
      #print(paste(name,': ',nrow(m) - i,sep=''))
    }
  }
  
  res <- paste(res,'\n];',sep='')
  
  return(res)
  
}


