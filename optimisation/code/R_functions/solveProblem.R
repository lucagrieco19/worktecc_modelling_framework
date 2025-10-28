
solveProblem <- function(methID,loc,mod_loc,anID,pars){
  
  if(methID=="TeamSizeAndComposition_heur"){
      
    source("R_functions/solvers/solve_TeamSizeAndComposition_heur.R")
    
    solve_TeamSizeAndComposition_heur(loc,mod_loc,anID,
                                      pars$roles,
                                      pars$visit_types,
                                      pars$role_to_visit,
                                      pars$daily_demand_scenarios,
                                      pars$dem_prop,
                                      pars$max_working_hours,
                                      pars$daily_travel_time,
                                      pars$service_times,
                                      pars$deployment_costs,
                                      pars$min_staff_per_role
    )
      
  }else if(methID=="WorkforceRolesANDHomeHealthCarePackages1"){
    
    source("R_functions/solvers/solve_WorkforceRolesANDHomeHealthCarePackages1.R")
    
    solve_WorkforceRolesANDHomeHealthCarePackages1(loc,mod_loc,anID,
                                                   pars$profiles,
                                                   pars$visits,
                                                   pars$activities,
                                                   pars$roles,
                                                   pars$hourly_rates,
                                                   pars$visit_duration,
                                                   pars$visit_composition,
                                                   pars$profile_demand,
                                                   pars$role_to_visit,
                                                   pars$profile_counts
    )
  
    
  }else if(methID=="Districting1"){
    
    source("R_functions/solvers/solve_Districting1.R")
    
    solve_Districting1(loc,mod_loc,anID,
                       pars$districts,
                       pars$basic_units,
                       pars$basic_unit_distances,
                       pars$basic_unit_compatibility,
                       pars$activity_types,
                       pars$activity_times,
                       pars$basic_unit_annual_demand,
                       pars$obj_weights,
                       pars$d_max,
                       pars$tau,
                       pars$basic_unit_contiguity
    )
    
  
  }else if(methID=="RosteringANDAllocationANDScheduling1"){
    
    source("R_functions/solvers/solve_RosteringANDAllocationANDScheduling1.R")
    
    solve_RosteringANDAllocationANDScheduling1(loc,mod_loc,anID,
                      pars$patients,
                      pars$staff_members,
                      pars$roles,
                      pars$staff_to_role,
                      pars$subperiods,
                      pars$subperiods_available,
                      pars$visits,
                      pars$visits_by_patient,
                      pars$visits_to_staff,
                      pars$visit_time,
                      pars$within_district_travel_time,
                      pars$max_workload,
                      pars$salary,
                      pars$min_prop_visits,
                      pars$max_unique_pairs,
                      pars$budget_limit,
                      pars$obj_weights
    )
  
  
    
  }else cat("ERROR: unrecognised solution method")
  
}

