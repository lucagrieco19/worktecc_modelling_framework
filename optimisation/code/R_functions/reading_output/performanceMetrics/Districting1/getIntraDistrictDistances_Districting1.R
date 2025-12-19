
getIntraDistrictDistances_Districting1 <- function(solution){
  
  M <- solution$districts
  N <- solution$basic_units
  
  dist <- sapply(M,function(j){
    num <- 0
    den <- 0
    for(i in 1:(length(N)-1)){
      for(k in (i+1):length(N)){
        num <- num + solution$basic_unit_distances[N[i],N[k]] * solution$x_basic_unit_to_district[j,N[i]] * solution$x_basic_unit_to_district[j,N[k]]
        den <- den + solution$x_basic_unit_to_district[j,N[i]] * solution$x_basic_unit_to_district[j,N[k]]
      }
    }
    num/den
  })
  
  res <- sum(dist) / length(M)
  
  return(res)
  
}

