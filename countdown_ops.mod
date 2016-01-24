using CP;

int n = ...; /* numble of available numbers */
assert n > 0;

range N = 1..n;
range O = 1..5;
range R = 1..n+1;

int target = ...; /* target number */
assert target >= 0;

int values[N] = ...; /* list of number available to calculate target */
assert forall(i in N) values[i] > 0;

string op_[O] = ["+", "-", "*", "/", "abs"];

dvar int res[R];
dvar int op[N] in O;
dvar int index[N] in N;
dvar int values_[N];

// Concatenate two arrays x and y of decision variables
dvar int xy[0..2*n-1] = append(all(i in N) values_[i], all(i in N) op[i]);

execute SEARCH{
	// Restrict branching decisions to the variables which belong to xy
	var f = cp.factory;
	cp.setSearchPhases(f.searchPhase(xy));
	// Set a time limit of 20s
	cp.param.timelimit=20;
}

dexpr float obj1 = abs(target - res[n + 1]);	/* difference between calculated result and target */
dexpr float obj2 = (	/* number of operation required to calculate the target */
		count(all(i in N) op[i], 1) +
		count(all(i in N) op[i], 2) +
		count(all(i in N) op[i], 3) +
		count(all(i in N) op[i], 4)
		);

minimize staticLex(obj1, obj2);	/* criteria ordered by importance, perform lexicographic optimization */

subject to {
	res[1] == 0; /* first intermediate result is zero */
	allDifferent(index); /* each value is used only once */

	/* apply constraint for each intermediate result */
	forall(i in R){
		res[i] >= 0;
		res[i] <= prod(j in N) values[j]; /* upper bound for intermediate result */
	}

	/* create a dvar with each value from values to restrict branch decision */
	forall(i in N) {
		values_[i] == values[index[i]];
	}

	/* using exactly 4 operations */
	//count(all(i in N) op[i], 5) == n - 4;

	/* using at most 4 operations */
	count(all(i in N) op[i], 5) >= n - 4;

	/* constraint for each operator */
	forall(i in N){
		((op[i] == 1) => (res[i] + values[index[i]] == res[i + 1])) &&
			((op[i] == 2) => (res[i] - values[index[i]] == res[i + 1])) &&
			((op[i] == 3) => (res[i] * values[index[i]] == res[i + 1])) &&
			((op[i] == 4) => (res[i] / values[index[i]] == res[i + 1])) &&
			((op[i] == 5) => (res[i] == res[i + 1]));
	}

	/* move all absorbant operator to the end of op */
	forall(i in 1..n-1){
		(op[i] == 5) => (op[i + 1] == op[i]);
	}
}

execute DISPLAY {
	writeln("target: ", target);
	writeln("values: ", values);
	writeln("res: ", res);
	writeln("operator: ", op);
	writeln("index: ", index);
	for(var i in N){
		if(op[i] != 5){
			writeln(res[i], " ", op_[op[i]], " ", values[index[i]], " = ", res[i + 1]);
		}
	}
}
