
array3dToCPLEXarray <- function(arr,name){
  
  res <- paste(name,' = [',sep='')
  
  for(i in 1:dim(arr)[1]){
    
    res <- paste(res,'\n[ ',sep='')
    
    res <- paste(res,'\n[ ',paste(arr[i,1,],collapse=' , '),' ]',sep='')
    
    if(dim(arr)[2]>1){
      
      for(j in 2:dim(arr)[2]){
      
        res <- paste(res,',','\n[ ',paste(arr[i,j,],collapse=' , '),' ]',sep='')
        
      }
      
    }
    
    if(i==dim(arr)[1]){
      res <- paste(res,'\n]',sep='')
    }else{
      res <- paste(res,'\n],',sep='')
    }
    
    #print(paste(name,': ',dim(arr)[1] - i,sep=''))
    
  }

  res <- paste(res,'\n];',sep='')
  
  return(res)
  
}


