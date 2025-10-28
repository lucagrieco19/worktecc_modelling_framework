/*********************************************
 * OPL 12.9.0.0 Model
 * Author: lgrieco
 * Creation Date: 15 Nov 2019 at 11:55:30
 *********************************************/

 
 //Define districts by optimising district compactness, workload balance or deviation from current districting
 //(cf. https://link.springer.com/article/10.1007/s10479-020-03559-y)
 
 //weights to be assigned to each component of the objective function
 float weight_compactness = ...;
 float weight_balance = ...;
 
 //set of districts
 {string} districts = ...;
 
 //set of basic units
 {string} basic_units = ...;
 
 //set of activity types
 {string} activity_types = ...;
 
 //estimated annual number of times activities of a given type have to be conducted, in each basic unit
 float basic_unit_annual_demand[basic_units][activity_types] = ...;
 
 //average duration of an activity of a given types
 float activity_times[activity_types] = ...;
 
 //distances (in km) between pairs of basic units
 float basic_unit_distances[basic_units][basic_units] = ...;
 
 //maximum distance (in km) allowed between any pair of basic units in the same district, if workload balance is optimised
 float d_max = ...;
 
 //maximum percentage deviation of workload in each district in comparison with the average workload across districts, if district compactness is optimised 
 float tau = ...;
 
 //compatibility index (for reasons other than distance) between basic unit pairs (0 = incompatible, 1 = compatible)
 int basic_unit_compatibility[basic_units][basic_units] = ...;
 
 //basic unit contiguity (1 if the pair of basic units is contiguous, 0 otherwise)
 int basic_unit_contiguity[basic_units][basic_units] = ...;
 
 //output location
 string output_loc = ...;
 
 
 execute{
   cplex.tilim = 3600;
 }


 //DECISION VARIABLES

 //whether a basic unit is assigned to a district
 dvar boolean x[basic_units][districts];

 //auxiliary variable to make the compactness component of objective function linear
 dvar float+ dist_max;

 //auxiliary variable to make the balance component of objective function linear
 dvar float+ gap_max;
 
 //auxiliary variables for flow constraints
 dvar boolean s[basic_units][districts];
 dvar int+ alpha[basic_units][districts];
 dvar int+ beta[basic_units][basic_units][districts];
 dvar int+ gamma[basic_units][districts];
 dvar int+ delta[districts];
 
 //auxiliary variable for linearisation of flow constraints
 dvar boolean p[basic_units][basic_units][districts];
 dvar boolean r[basic_units][basic_units][districts];
 
 
 
 //EXPRESSIONS OF DECISION VARIABLES
 
 //workload in district j
 dexpr float wd[j in districts] = sum(i in basic_units, h in activity_types) basic_unit_annual_demand[i][h] * activity_times[h] * x[i][j];

 //average workload across districts
 dexpr float avg_wd = 1/card(districts) * sum(i in basic_units, h in activity_types) basic_unit_annual_demand[i][h] * activity_times[h];
 
 
 
 //OBJECTIVE FUNCTION
 
 //minimising the selected objective
 minimize weight_compactness * dist_max + weight_balance * gap_max;
 
 
 //CONSTRAINTS
 
 subject to{
 
 	//constraints linking the auxiliary variable "gap_max" to the other decision variables
 	forall(j in districts){
 		gap_max >= (wd[j] - avg_wd) / avg_wd;
 		gap_max >= (avg_wd - wd[j]) / avg_wd;
	}
 
 	//constraints linking the auxiliary variable "dist_max" to the other decision variables	
 	forall(i in basic_units, k in basic_units, j in districts)
 		dist_max >= basic_unit_distances[i][k] * (x[i][j] + x[k][j] - 1);
 	
	//constraints ensuring, together with binary constraints, that each basic unit is assigned to exactly one district
 	forall(i in basic_units)
 		sum(j in districts) x[i][j] == 1;
 	  
 	//constraints ensuring that incompatible basic units are not assigned to the same district  
	forall(i in basic_units, k in basic_units, j in districts)
		(1 - basic_unit_compatibility[i][k]) * (x[i][j] + x[k][j]) <= 1;
 	
 	//constraints ensuring that two basic units are not assigned to the same district if they are too far from each other, if workload balance is optimised
	forall(i in basic_units, k in basic_units, j in districts)
		basic_unit_distances[i][k] * (x[i][j] + x[k][j] - 1) <= d_max;
	  	
	//constraints ensuring that the workload in each district does not deviate too much from the average workload, if district compactness is optimised
	forall(j in districts){
		(1 - tau) * avg_wd <= wd[j];
		wd[j] <= (1 + tau) * avg_wd;
	}
	
	//constraints ensuring relationships between alpha, beta, gamma, delta, p, r, s and x variables
	forall(j in districts)
 		sum(i in basic_units) s[i][j] == 1;
	
	forall(i in basic_units, j in districts){
	  	s[i][j] <= x[i][j];
		alpha[i][j] <= card(basic_units) * x[i][j];  
		gamma[i][j] <= x[i][j];
	}
	
	sum(i in basic_units, j in districts) alpha[i][j] == card(basic_units);
	
	forall(j in districts){
	  sum(i in basic_units) gamma[i][j] == delta[j];
	}
	
	forall(l in basic_units, j in districts){
	  alpha[l][j] + sum(i in basic_units) ( beta[i][l][j] * basic_unit_contiguity[i][l] ) == gamma[l][j] + sum(k in basic_units) (beta[l][k][j] * basic_unit_contiguity[l][k]);
	}
	
	forall(i in basic_units, j in districts){
	  alpha[i][j] <= card(basic_units) * r[i][i][j];
	  x[i][j] + s[i][j] - 1 <= 2 * r[i][i][j];
	  2 * r[i][i][j] <= x[i][j] + s[i][j];
	}
	
	forall(i in basic_units, k in basic_units, j in districts){
	  beta[i][k][j] <= card(basic_units) * p[i][k][j] * basic_unit_contiguity[i][k];
	  x[i][j] + x[k][j] - 1 <= 2 * p[i][k][j];
	  2 * p[i][k][j] <= x[i][j] + x[k][j];
	}
		 	  
 }
 
 
 execute{
 
 	var f=new IloOplOutputFile(output_loc + "/x_basic_unit_to_district.txt");
 	f.writeln(x);
	f.close();

 }
 