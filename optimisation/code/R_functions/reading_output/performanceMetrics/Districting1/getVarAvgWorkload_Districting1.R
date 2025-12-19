
getVarAvgWorkload_Districting1 <- function(solution){
  
  M <- solution$districts
  N <- solution$basic_units
  H <- solution$activity_types
  
  wl <- sapply(M,function(j){
    tmp <- 0
    for(i in N){
      for(h in H){
        tmp <- tmp + solution$basic_unit_annual_demand[i,h] * solution$activity_times[h] * solution$x_basic_unit_to_district[j,i]
      }
    }
    tmp
  })
  
  avg_wl <- 0
  for(i in N){
    for(h in H){
      avg_wl <- avg_wl + solution$basic_unit_annual_demand[i,h] * solution$activity_times[h]
    }
  }
  avg_wl <- avg_wl / length(M)
  
  res <- sum(abs(wl-avg_wl)) / length(M)
  
  return(res)
  
}

