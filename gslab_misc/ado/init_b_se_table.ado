/**********************************************************
 *
 * INIT_B_SE_TABLE.ADO: Initializes a matrix for storing regression output
 *
 **********************************************************/
 
cap program drop init_b_se_table

program init_b_se_table
	syntax, vars(int) regs(int) extra_rows(int)
	mat table = J(`vars' * 2 + `extra_rows', `regs', .)
	macro drop table_*
end
