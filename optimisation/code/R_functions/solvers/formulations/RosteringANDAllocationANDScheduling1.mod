/*********************************************
 * OPL 12.10.0.0 Model
 * Author: lucagrieco19
 * Creation Date: 10 Dec 2020 at 18:47:50
 *********************************************/

 
 //Allocation of a pre-defined set of home-based visits to staff members over a period of time and scheduling of those visits at sub-period resolution, such as day or half-day (without staff routing).
 //Optimise monetary costs or number of unique staff-patient pairs (continuity of care)
 
 //weights to be assigned to each component of the objective function
 float weight_costs = ...;
 float weight_pairs = ...;
 
 //set of patients
 {string} patients = ...;
 
 //set of staff members
 {string} staff_members = ...;
 
 //set of roles
 {string} roles = ...;
 
 //time points identifying sub-periods (starting from 1)
 {int} subperiods = ...;
 
 //sub-periods when each staff member is available
 int subperiods_available[staff_members][subperiods] = ...;
 
 //set of visits to be conducted during the planning period
 {string} visits = ...;
 
 //visit splitting by patients
 int visits_by_patient[visits][patients] = ...;

 //maximum number of daily visits allowed per patient
 float max_daily_visit_per_patient[p in patients] = ceil(sum(v in visits) visits_by_patient[v][p] / 7);
 
 //visit splitting by staff who can conduct them
 int visits_to_staff[visits][staff_members] = ...;
 
 //service time for each visit
 float visit_time[visits] = ...;
 
 //average travel time between any pair of locations in the same district
 float within_district_travel_time = ...;
 
 //maximum working time (including travel time) for each staff member in each sub-period
 float max_workload[staff_members] = ...;

 //staff cost (daily salary)
 float salary[staff_members] = ...;
 
 //minimum proportion of visits to be satisfied over the planning period
 float min_prop_visits = ...;
 
 //maximum number of unique staff-patient (weighted) pairs allowed
 float max_unique_pairs = ...;
 
 //budget limit
 float budget_limit = ...;
 
 //whether a staff member belongs to a role (elements are either 0 or 1)
 int staff_to_role[staff_members][roles] = ...;

 //output location
 string output_loc = ...;
 
 
 execute{
   cplex.tilim = 1200;
 } 


 
 //DECISION VARIABLES

 //whether staff member s is allocated to visit v during sub-period d
 dvar boolean x[staff_members][visits][subperiods];
 
 //whether staff member s visits patient p at least once during the planning period
 dvar boolean y[staff_members][patients];

 //whether staff member s is allocated at least one visit during sub-period p
 dvar boolean z[staff_members][subperiods];
 
 

 
 
 //EXPRESSIONS OF DECISION VARIABLES
 
 //daily workload of each staff member
 dexpr float daily_workload[s in staff_members][d in subperiods] = sum(v in visits) (visit_time[v] + within_district_travel_time) * x[s][v][d] + within_district_travel_time * z[s][d];
 
 //overall workload of each staff member
 dexpr float workload[s in staff_members] = sum(d in subperiods) daily_workload[s][d];

 //proportion of visits conducted
 dexpr float prop_visits = sum(s in staff_members, v in visits, d in subperiods) x[s][v][d] / card(visits);
 

 //number of unique staff-patient pairs
 dexpr int n_unique_pairs = sum(s in staff_members, p in patients) y[s][p];

 //monetary costs
 dexpr float monetary_costs = sum(s in staff_members, d in subperiods) salary[s] * z[s][d];
 //if hourly salary, then sum(s in staff_members) workload[s]; (with salary being specified as hourly rate)


 

 
 //OBJECTIVE FUNCTION
 
 //minimising the weighted sum of proportion of visits satisfied, monetary costs and number of unique staff-patient pairs
 dexpr float objective_value = weight_costs * monetary_costs + weight_pairs * n_unique_pairs;

 minimize objective_value;
 
 
 //CONSTRAINTS
 
 subject to{
 	
 	//logical relationships between decision variables
	forall(s in staff_members, p in patients, v in visits, d in subperiods)
	  y[s][p] >= visits_by_patient[v][p] * x[s][v][d];
 	  
	forall(s in staff_members, p in patients)
	  y[s][p] <= sum(v in visits, d in subperiods) visits_by_patient[v][p] * x[s][v][d];
 	
 	forall(s in staff_members, d in subperiods, v in visits)
 	  z[s][d] >= x[s][v][d];
 	
 	forall(s in staff_members, d in subperiods)
 	  z[s][d] <= sum(v in visits) x[s][v][d];

	//each visit to be conducted at most once
	forall(v in visits)
	  sum(s in staff_members, d in subperiods) x[s][v][d] <= 1;
	
 	//a staff member cannot be deployed when they are not available
 	forall(s in staff_members, d in subperiods)
	  z[s][d] <= subperiods_available[s][d];
 	
 	//a staff member cannot be allocated to a visit if they have not the right skills
	forall(v in visits, s in staff_members)
          sum(d in subperiods) x[s][v][d] <= visits_to_staff[v][s];
 	
 	//working time limit not to be exceeded for each staff in each sub-period
 	forall(s in staff_members, d in subperiods)
 	  daily_workload[s][d] <= max_workload[s];

	//keeping the number of daily visits balanced over the planning period for each patient
	forall(p in patients, d in subperiods)
	  sum(s in staff_members, v in visits) visits_by_patient[v][p] * x[s][v][d] <= max_daily_visit_per_patient[p];
 	  
 	//minimum number of visits to be conducted
	prop_visits >= min_prop_visits;
		  
 }
  
 
 execute{
 
 	var file=new IloOplOutputFile(output_loc + "/x_staff_to_visit_to_subperiod.txt");
 	file.writeln(x);
	file.close();
	
	var file=new IloOplOutputFile(output_loc + "/y_staff_to_patient.txt");
	file.writeln(y);
	file.close();
	
	var file=new IloOplOutputFile(output_loc + "/z_staff_to_subperiod.txt");
	file.writeln(z);
	file.close();
	
	var file=new IloOplOutputFile(output_loc + "/workload.txt");
	file.writeln(workload);
	file.close();

	var file=new IloOplOutputFile(output_loc + "/relative_gap.txt");
	file.writeln(cplex.getMIPRelativeGap());
	file.close();

	var file=new IloOplOutputFile(output_loc + "/cplex_time.txt");
	file.writeln(cplex.getCplexTime());
	file.close();

	var file=new IloOplOutputFile(output_loc + "/objective_value.txt");
	file.writeln(objective_value);
	file.close();
	
 }
 
 
 
 