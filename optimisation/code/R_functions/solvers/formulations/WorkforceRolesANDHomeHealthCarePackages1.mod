/*********************************************
 * OPL 12.9.0.0 Model
 * Author: lgrieco
 * Creation Date: 20 Aug 2019 at 15:14:49
 *********************************************/

 
 //set of patient profiles
 {string} profiles = ...;
 
 //set of visit types
 {string} visits = ...;
 
 //set of activities
 {string} activities = ...;
 
 //set of roles
 {string} roles = ...;

 //hourly rates (£) of roles
 float hourly_rates[roles] = ...;

 //visit durations (hours)
 float visit_duration[visits] = ...;
 
 //visit composition
 int visit_composition[activities][visits] = ...;
 
 //number of times a patient of given profile needs each activity during a week
 int profile_demand[profiles][activities] = ...;
 
 //whether a staff member in a given role can conduct a visit of a given type - note, this has to reflect whether or not sharing is enabled
 int role_to_visit[roles][visits] = ...;
 
 //number of patients belonging to each profile
 int profile_counts[profiles] = ...;

 //big number
 int M = sum(p in profiles, a in activities) profile_demand[p][a];

 //output location
 string output_loc = ...;
 
 
 execute{
   cplex.tilim = 3600;
 }
 

 //DECISION VARIABLES

 //how many times a visit of a given type is conducted by a staff member in a given role to the benefit of a patient of a given profile over a week
 dvar int+ x[visits][profiles][roles];

 
  

 //EXPRESSIONS OF DECISION VARIABLES
 
 //total treatment costs based on staff hourly rates
 dexpr float tot_cost = sum(v in visits, p in profiles, r in roles) profile_counts[p] * hourly_rates[r] * visit_duration[v] * x[v][p][r];

 dexpr float n_visits = sum(v in visits, p in profiles, r in roles) profile_counts[p] * x[v][p][r];
 
 
 //OBJECTIVE FUNCTION
 
 //minimising the total treatment cost
 //minimize tot_cost;

 //minimising the total number of visits to cover the demand
 minimize n_visits;

 
 
 //CONSTRAINTS
 
 subject to{
 
 	//constraints ensuring that demand is satisfied
 	forall(p in profiles, a in activities){
 		sum(r in roles, v in visits) visit_composition[a][v] * x[v][p][r] == profile_demand[p][a];
	}
	
	//constraints ensuring compatibility between roles and visit types
	forall(v in visits, p in profiles, r in roles){
		x[v][p][r] <= role_to_visit[r][v] * M;
	}

 }
 


execute{
 
 	var f=new IloOplOutputFile(output_loc + "/x_visit_to_profile_to_role.txt");
	f.writeln(x);
	f.close();
 	
 }
 
 