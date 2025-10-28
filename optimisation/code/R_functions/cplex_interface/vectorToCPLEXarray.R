
vectorToCPLEXarray <- function(v,name){
  
  res <- paste(name,' = [ ',v[1],sep='')
  
  if(length(v)>1){
    for(i in 2:length(v)){
      res <- paste(res,',',v[i],sep=' ')
      #print(paste(name,': ',length(v) - i,sep=''))
    }
  }
  
  res <- paste(res,'];',sep=' ')
  
  return(res)
  
}


