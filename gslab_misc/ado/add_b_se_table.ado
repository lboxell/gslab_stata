/**********************************************************
 *
 * ADD_B_SE_TABLE.ADO: Adds regression to an `init_b_se_table` matrix for storing regression output
 *
 **********************************************************/
 
cap program drop add_b_se_table

program add_b_se_table 
	syntax , iter(int) vars(string) [add_N(string) add_N_clust(string)]
	local i = 1
	local j = 1
	foreach v in `vars'{
		if "`v'" == "." {
			mat table[2 * `i' - 1, `iter'] = .
			mat table[2 * `i',     `iter'] = .
		} 
		else {
			mat table[2 * `i' - 1, `iter'] = _b[`v']
			mat table[2 * `i',     `iter'] = _se[`v']
				
			local t_stat = _b[`v']/_se[`v']
			if abs(t_stat) > 1.645 {
				global table_`row'_`iter' "$^{*}$"
			}
			if abs(t_stat) > 1.96 {
				global table_`row'_`iter' "$^{**}$"
			}
			if abs(t_stat) > 2.576 {
				global table_`row'_`iter' "$^{***}$"
			}
		}
		local i = `i' + 1
	}
	if "`add_N'" == "yes" {
		mat table[2 * `i' - 1, `iter'] = e(N)
		local j = 0
	}
	if "`add_N_clust'" == "yes" {
		mat table[2 * `i' - `j', `iter'] = e(N_clust)
	}
end
