
solve_TeamSizeAndComposition_heur <- function(loc,mod_loc,anID,roles,visit_types,role_to_visit,daily_demand,dem_prop,max_working_hours,daily_travel_time,service_times,deployment_costs,min_staff_per_role){
  
  options(scipen=999) #to deactivate scientific notation for big numbers (e.g. max_budget)
  
  W <- rep(0,length(roles))
  names(W) <- roles
  
  demand <- round( apply(sapply(daily_demand,function(d){apply(d,1,sum)}),1,function(q){quantile(q,dem_prop)}), 0)[visit_types]
  
  possible_roles <- lapply(visit_types,function(v){
    rownames(role_to_visit)[role_to_visit[,v]==1]
  })
  names(possible_roles) <- visit_types
  
  costs_by_visit_type <- lapply(visit_types,function(v){
    deployment_costs[possible_roles[[v]]] / max_working_hours[possible_roles[[v]]]
  })
  names(costs_by_visit_type) <- visit_types
  
  for(v in visit_types){
    
    sel_role <- names(costs_by_visit_type[[v]])[costs_by_visit_type[[v]]==min(costs_by_visit_type[[v]])][1]
    
    W[sel_role] <- W[sel_role] + demand[v] * service_times[v]
    
  }
  
  n_staff <- sapply(roles,function(r){
    max( 0, ceiling( W[r] / ( max_working_hours[r] - daily_travel_time[r] ) ) )
  })
  names(n_staff) <- roles
  
  solution <- list(
    sol_n_staff=n_staff,
    sol_total_visit_time=W,
    sol_total_travel_time=daily_travel_time * n_staff * (W>0),
    sol_n_visits_conducted=sum(demand)
  )
  
  saveRDS(solution,file=paste(path,'/',analysisID,"/model_output/output_",analysisID,".rds",sep=''))
  
}

