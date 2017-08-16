/**********************************************************
 *
 * ADD_B_SE_TABLE.ADO: Adds regression to an `init_b_se_table` matrix for storing regression output
 *
 **********************************************************/
 
cap program drop add_b_se_table

program add_b_se_table 
	syntax, iter(int) vars(string) add_N(string)
	local i = 1
	foreach v in `vars'{
		if "`v'" == "." {
			mat table[2 * `i' - 1, `iter'] = .
			mat table[2 * `i',     `iter'] = .
		} 
		else {
			mat table[2 * `i' - 1, `iter'] = _b[`v']
			mat table[2 * `i',     `iter'] = _se[`v']
		}
		local i = `i' + 1
	}
	if "`add_N'" == "yes" {
		mat table[2 * `i' - 1, `iter'] = e(N)
	}
end