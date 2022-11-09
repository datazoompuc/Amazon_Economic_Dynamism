/*
O propostio desse do file é:
Descrever a matriz de transições de posição na ocupação

Referência está nas Tabelas 6 e 7 do trabalho:
Sobre o painel da Pesquisa Mensal de Emprego (PME) do IBGE
Ribas, Rafael Perez and Soares, Sergei Suarez Dillon
2008
*/

* select just a small sample for training data
cap drop __*
cap drop iten*
*sample 4

**********************
**	 Definitions	**
**********************

do "$code_dir\_definicoes_pnadcontinua_trimestral"
cap drop iten*
*preserve

* identifying pair of individuals by quarter
sort idind Ano Trimestre

* keep only individuals with identification
keep if idind !=""

* keep only individuals in annual painel (_n > 5)
by idind, sort: gen iten1 = _n
by idind, sort: egen iten2 = max(iten1)
keep if iten2 >= 5
tab iten2
drop iten*

* generate variable for actual position
sort idind Ano Trimestre
by idind, sort: gen position_act = 1 if trim[_n] == (trim[_n-4] + 4)

* generate variable for previous position 1 year before (or 5 quarters)
sort idind Ano Trimestre
by idind, sort: gen position_pre = 1 if trim[_n] == (trim[_n+4] - 4)

/*	Useful variables:

VD4001
1 // Pessoas na força de trabalho
2 // Pessoas fora da força de trabalho

VD4002
1 // Pessoas ocupadas 
2 // Pessoas desocupadas 

VD4009
1 // Empregado no setor privado com carteira de trabalho assinada
2 // Empregado no setor privado sem carteira de trabalho assinada
3 // Trabalhador doméstico com carteira de trabalho assinada
4 // Trabalhador doméstico sem carteira de trabalho assinada
5 // Empregado no setor público com carteira de trabalho assinada
6 // Empregado no setor público sem carteira de trabalho assinada
7 // Militar e servidor estatutário
8 // Empregador
9 // Conta-própria
10 // Trabalhador familiar auxiliar
. // Não aplicável
*/

* Definitions regarding the position of the indiviual in PREVIOUS period
* Vertical axis in the Table 6 (Ribas Soares, 2008)
* tem_var_y
*
* 1) Empregado SC:	VD4009 == 2 | VD4009 == 4 | VD4009 == 6 | VD4009 == 10 
* 2) Empregado CC:	VD4009 == 1 | VD4009 == 3 | VD4009 == 5 
* 3) Conta-própria: VD4009 == 9
* 4) Empregador:	VD4009 == 8
* 5) Militar e servidor estatutário:	VD4009 == 7

local tem_var_y inativa desempregado formal informal empregadoSC empregadoCC cpropria cpropriaC cpropriaNc empregador militar desalento nemnem
*local tem_var_y  desempregado

* Definitions regarding the position of the indiviual in ACTUAL period
* Horizontal axis in the Table 6 (Ribas Soares, 2008)
* tem_var_x

*
* A) Inativo:		VD4001 == 2
* B) Desempregado:	VD4001 == 1 & VD4002 == 2
* C) Empregado SC:	VD4009 == 2 | VD4009 == 4 | VD4009 == 6 | VD4009 == 10
* D) Empregado CC:	VD4009 == 1 | VD4009 == 3 | VD4009 == 5 
* E) Conta-própria: VD4009 == 9
* F) Empregador:	VD4009 == 8
* G) Militar e servidor estatutário:	VD4009 == 7

local tem_var_x inativa desempregado formal informal empregadoSC empregadoCC cpropria cpropriaC cpropriaNc empregador militar desalento nemnem
*local tem_var_x  formal 

* begin loop for vertical variables	
foreach yy of local tem_var_y {
	
* begin loop for horizontal variables
foreach xx of local tem_var_x {
	
* What is the number of tem_var_y that now is tem_var_x?
sort idind Ano Trimestre

* Indicating the who are tem_var_y in the previous period
gen iten1 = V1028 	/*
	*/ 	if position_pre == 1 	/*
	*/ 	& `yy' ==1 	// individual who are tem_var_y
	
* From those tem_var_y in the previous period, how many are in tem_var_x now?
by idind, sort: gen itenA = V1028 	/*
	*/ 	if position_pre[_n] == 1 	/*
	*/ 	& position_act[_n+4] ==1 	/*
	*/ 	& `yy'[_n] == 1 	/*
	*/ 	& `xx'[_n+4] == 1	 // individual who are tem_var_x
	
* By quarter, the number of individuals in the previous and actual period
capture by trim, sort: egen n_`yy' = total(iten1)
by trim, sort: egen n_`yy'_n_`xx' = total(itenA)
drop iten*	

* end loop for horizontal variables
}
	
* end loop for vertical variables	
}

**************************************
**	Colapsar ao nível do trimestre 	**
**************************************

// attach label of variables
local colvar n_* painel

foreach v of var `colvar' {
    local l`v' : variable label `v'
}

* colapse
collapse (firstnm) `colvar' , by(Ano Trimestre)
capture drop n_p_aux 
capture drop n_p 

// copy back the label of variables
foreach v of var `colvar' {
    label var `v' "`l`v''"
}