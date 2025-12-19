
CPLEXoutputToNumericArray <- function(file,dim,dimnames){
  
  tmp <- scan(file,what="character",sep=NULL)
  tmp <- gsub('\\[','',tmp)
  tmp <- gsub('\\]','',tmp)
  tmp <- as.numeric(tmp)
  
  res <- tmp
  if(length(dim)>0){
    res <- array(tmp,dim=rev(dim),dimnames=rev(dimnames))
  }
  
  return(res)
  
}
