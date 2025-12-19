
dataframeToCPLEXorderedPairSet <- function(m,name){
  
  m <- as.data.frame(m)
  
  res <- paste(name,' = {',sep='')
  
  res <- paste(res,'\n< "',paste(m[1,],collapse='" , "'),'" >',sep='')
  
  if(nrow(m)>1){
    for(i in 2:nrow(m)){
      res <- paste(res,',','\n< "',paste(m[i,],collapse='" , "'),'" >',sep='')
      #print(paste(name,': ',nrow(m) - i,sep=''))
    }
  }
  
  res <- paste(res,'\n};',sep='')
  
  return(res)
  
}


