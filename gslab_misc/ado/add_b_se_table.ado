/**********************************************************
 *
 * ADD_B_SE_TABLE.ADO: Adds regression to an `init_b_se_table` matrix for storing regression output
 *
 **********************************************************/
 
cap program drop add_b_se_table

program add_b_se_table 
	syntax , iter(int) vars(string) [add_N(string) add_N_clust(string) add_R_sq(string) wild_boot]
	local i = 1
	foreach v in `vars'{
		if "`v'" == "." {
			mat table[2 * `i' - 1, `iter'] = .
			mat table[2 * `i',     `iter'] = .
		} 
		else {
			mat table[2 * `i' - 1, `iter'] = _b[`v']
			mat table[2 * `i',     `iter'] = _se[`v']
				
			local row = 2 * `i' - 1
			local t_stat = _b[`v']/_se[`v']
			if abs(`t_stat') > 1.645 {
				global table_`row'_`iter' "$^{*}$"
			}
			if abs(`t_stat') > 1.96 {
				global table_`row'_`iter' "$^{**}$"
			}
			if abs(`t_stat') > 2.576 {
				global table_`row'_`iter' "$^{***}$"
			}
			if "`wild_boot'" != "" {
				quietly boottest `v', reps(999) weight(webb)
				mat table[2 * `i',     `iter'] = abs(_b[`v'] / invnormal(1 - (`r(p)' / 2)))
				if `r(p)' < .1 {
					global table_wild_`row'_`iter' "$^{\dagger}$"
				}
				if `r(p)' < .05 {
					global table_wild_`row'_`iter' "$^{\dagger\dagger}$"
				}
				if `r(p)' < .01 {
					global table_wild_`row'_`iter' "$^{\dagger\dagger\dagger}$"
				}
			}
		}
		local i = `i' + 1
	}
	local j = 0
	if "`add_N_clust'" == "yes" {
		mat table[2 * `i' - 1 + `j', `iter'] = e(N_clust)
		local j = `j' + 1
	}
	if "`add_N'" == "yes" {
		mat table[2 * `i' - 1 + `j', `iter'] = e(N)
		local j = `j' + 1
	}
	if "`add_R_sq'" == "yes" {
		mat table[2 * `i' - 1 + `j', `iter'] = e(r2)
	}
end
