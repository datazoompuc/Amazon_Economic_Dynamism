/*
O propostio desse do file é:
Descrever a estrutura do renda

Mais especificamente:
A) Rendimentos real
B) Pobreza
C) Desigualdade
*/

**********************
**	 Definitions	**
**********************

do "$code_dir\_definicoes_pnadcontinua_trimestral"

* select just a small sample for training data
cap drop __*
cap drop iten*
*sample 2

/////////////////////////////////////////////////////////
//	A) Rendimentos real
/////////////////////////////////////////////////////////

* Merge na base de dados com o deflator
merge m:1 Ano Trimestre UF using "$input_dir\_deflator_pnad_continua.dta", update force
drop if _merge==2 
drop _merge

* Total de ocupados
gen iten1 = ocupado * V1028
by Ano Trimestre, sort: egen total_ocupado = total(iten1)
drop iten*

* Total de ocupados remunerados monetariamente no setor formal
gen iten1 = formal * V1028
by Ano Trimestre, sort: egen total_formal = total(iten1)
drop iten*

* Total de ocupados remunerados monetariamente no setor informal
gen iten1 = informal * V1028
by Ano Trimestre, sort: egen total_informal = total(iten1)
drop iten*

* Rendimento medio habitual real dos ocupados total
gen iten1 = ocupado * (VD4019 * Habitual) * V1028
by Ano Trimestre, sort: egen total_rendimento_ocupado = total(iten1)
gen rendimento_medio_total = (total_rendimento_ocupado/total_ocupado)
drop iten*
label variable	rendimento_medio_total "Rendimento médio habitual real dos ocupados (R$)"

* Rendimento medio habitual real dos ocupados no setor formal
gen iten1 = formal * (VD4019 * Habitual) * V1028
by Ano Trimestre, sort: egen total_rendimento_formal = total(iten1)
gen rendimento_medio_formal = (total_rendimento_formal/total_formal)
drop iten*
label variable	rendimento_medio_formal "Rendimento médio habitual real no setor formal (R$)"

* Rendimento medio habitual real dos ocupados no setor informal
gen iten1 = informal * (VD4019 * Habitual) * V1028
by Ano Trimestre, sort: egen total_rendimento_informal = total(iten1)
gen rendimento_medio_informal = (total_rendimento_informal/total_informal)
drop iten*
label variable	rendimento_medio_informal "Rendimento médio habitual real no setor informal (R$)"

* Rendimento domiciliar real habitual per capita
	
	* numero total de individuos nos domicilios
	by Ano Trimestre hous_id, sort: gen temp1 =  _n
	by Ano Trimestre hous_id, sort: egen temp2 =  max(temp1) // total number of individuals in each household

	* rendimento total de individuos nos domicilios (deflacionado)
	gen tempx1 = (VD4019 * Habitual)
	by Ano Trimestre hous_id, sort: egen tempx2 =  sum(tempx1) // total amount of earnings in each household
	replace tempx2 = 0 if tempx2==.

	* rendimento per capita no domicílio
	gen tempk1 = tempx2 / temp2

	* numero total de individuos
	gen tempa1 = 1* V1028
	by Ano Trimestre, sort: egen tempa2 = sum(tempa1)	

	* rendimento médio per capita nos domicílios
	by Ano Trimestre, sort: gen temph1 =  tempk1 * V1028  
	by Ano Trimestre, sort: egen temph2 =  sum(temph1) // total rendimento

by Ano Trimestre, sort: gen rendimento_domiciliar_pc = temph2/tempa2  // total rendimento / total de individuos
label variable rendimento_domiciliar_pc "Renda mensal domiciliar per capita (R$)"
cap drop iten*
cap drop temp*

/////////////////////////////////////////////////////////
//	B) Pobreza
/////////////////////////////////////////////////////////

* Proporção de indivíduos com rendimento per capita de até R$ 178,00 

	* numero total de individuos nos domicilios
	by Ano Trimestre hous_id, sort: gen temp1 =  _n
	by Ano Trimestre hous_id, sort: egen temp2 =  max(temp1) // total number of individuals in each household

	* rendimento total de individuos nos domicilios  (deflacionado)
	gen tempx1 = (VD4019 * Habitual)
	by Ano Trimestre hous_id, sort: egen tempx2 =  sum(tempx1) // total amount of earnings in each household
	replace tempx2 = 0 if tempx2==.

	* rendimento per capita no domicílio (já deflacionado)
	gen tempk1 = tempx2 / temp2

	* total de individuos em domicilios com até 178 reais per capita
	gen tempk2 = 1 * V1028 if tempk1 <= 178
	by Ano Trimestre, sort: egen iten2 = total(tempk2)

	* numero total de individuos
	gen tempa1 = 1* V1028
	by Ano Trimestre, sort: egen tempa2 = total(tempa1)

by Ano Trimestre, sort: gen prop_rendimento_domiciliar_178 = (iten2/tempa2)*100
label variable prop_rendimento_domiciliar_178 "(%) de indivíduos com renda mensal domiciliar per capita de até R$ 178,00"
cap drop iten*
cap drop temp*

* Proporção de domicilios com rendimento per capita de até R$ 89,00

	* numero total de individuos nos domicilios
	by Ano Trimestre hous_id, sort: gen temp1 =  _n
	by Ano Trimestre hous_id, sort: egen temp2 =  max(temp1) // total number of individuals in each household

	* rendimento total de individuos nos domicilios  (deflacionado)
	gen tempx1 = (VD4019 * Habitual)
	by Ano Trimestre hous_id, sort: egen tempx2 =  sum(tempx1) // total amount of earnings in each household
	replace tempx2 = 0 if tempx2==.

	* rendimento per capita no domicílio (já deflacionado)
	gen tempk1 = tempx2 / temp2

	* total de individuos em domicilios com até 89 reais per capita
	gen tempk2 = 1 * V1028 if tempk1 <= 89
	by Ano Trimestre, sort: egen iten2 = total(tempk2)

	* numero total de individuos
	gen tempa1 = 1* V1028
	by Ano Trimestre, sort: egen tempa2 = total(tempa1)

by Ano Trimestre, sort: gen prop_rendimento_domiciliar_89 = (iten2/tempa2)*100
label variable prop_rendimento_domiciliar_89 "(%) de indivíduos com renda mensal domiciliar per capita de até R$ 89,00"
cap drop iten*
cap drop temp*

/////////////////////////////////////////////////////////
//	C) Desigualdade
/////////////////////////////////////////////////////////
	
* Gini Coeficiente dos ocupados
gen gini_ocupado = .

	* loop over quarter
	levelsof trim, local(xy) 
	foreach zz of local xy {
	ineqdeco VD4019 [aw = V1028] if trim == `zz' & ocupado ==1
	replace gini_ocupado = `r(gini)' if gini_ocupado ==. & trim == `zz'
	}
	
label variable	gini_ocupado "GINI do rendimento habitual entre os ocupados"	

* Gini Coeficiente dos ocupados no setor informal
gen gini_informal = .

	* loop over quarter
	levelsof trim, local(xy) 
	foreach zz of local xy {
	ineqdeco VD4019 [aw = V1028] if trim == `zz' & informal ==1
	replace gini_informal = `r(gini)' if gini_informal ==. & trim == `zz'
	}
	
label variable	gini_informal "GINI do rendimento habitual no setor informal"

* Gini Coeficiente dos ocupados no setor formal
gen gini_formal = .

	* loop over quarter
	levelsof trim, local(xy) 
	foreach zz of local xy {
	ineqdeco VD4019 [aw = V1028] if trim == `zz' & formal ==1
	replace gini_formal = `r(gini)' if gini_formal ==. & trim == `zz'
	}
	
label variable	gini_formal "GINI do rendimento habitual no setor formal"

* Gini Coeficiente do rendimento domiciliar per capita
gen gini_rendimento_domiciliar_pc = .

	* Rendimento domiciliar real habitual per capita
	
	* numero total de individuos nos domicilios
	by Ano Trimestre hous_id, sort: gen temp1 =  _n
	by Ano Trimestre hous_id, sort: egen temp2 =  max(temp1) // total number of individuals in each household

	* rendimento total de individuos nos domicilios (deflacionado)
	gen tempx1 = (VD4019 * Habitual)
	by Ano Trimestre hous_id, sort: egen tempx2 =  sum(tempx1) // total amount of earnings in each household
	replace tempx2 = 0 if tempx2==.

	* rendimento per capita no domicílio
	gen tempk1 = tempx2 / temp2

	* loop over quarter
	levelsof trim, local(xy) 
	foreach zz of local xy {
	ineqdeco tempk1 [aw = V1028] if trim == `zz' 
	replace gini_rendimento_domiciliar_pc = `r(gini)' if gini_rendimento_domiciliar_pc ==. & trim == `zz'
	}
	
label variable	gini_rendimento_domiciliar_pc "GINI do rendimento domiciliar per capita"
cap drop iten*
cap drop temp*

**************************************
**	Colapsar ao nível do trimestre 	**
**************************************

// attach labels variables
local colvar rendimento_* gini_* prop_*

foreach v of var `colvar' {
    local l`v' : variable label `v'
}

* colapse
collapse (firstnm) `colvar' , by(Ano Trimestre)

// copy back labels variables
foreach v of var `colvar' {
    label var `v' "`l`v''"
}








