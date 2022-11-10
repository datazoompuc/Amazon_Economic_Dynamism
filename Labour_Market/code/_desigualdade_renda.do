/*
O propostio desse do file é:
Descrever a relevância da programas sociais

Mais especificamente:
A) Proporção da população que recebe Bolsa Família
*/


/////////////////////////////////////////////////////////
//	A) Proporção da população que recebe Bolsa Família
/////////////////////////////////////////////////////////

// Dificuldade: 
// A pergunta sobre Bolsa Família é feita em diferentes visitas entre os anos, 
// e as vezes possui varíaveis com nomes diferentes
// i) 2012 até 2015 (visita 1)
// ii) 2016 até 2019 (visita 1)
// ii) 2016 até 2019 (visita 5)
// Solução: fazer loops separados,
// e ao final somar números totais por todos os trimestres

// i) 2012 até 2019 (visita 1)
forvalues year = 2012(1)2019 {
	
* call data
	use "$input_pnadanual\PNADC_anual_`year'_visita1.dta", clear
	cap drop iten*
	*sample 1
	gen visita = 1
	
	**********************
	**	 Definitions	**
	**********************
	
	global time  `year'
	
	do "$code_dir\_definicoes_pnadcontinua_anual"
	
	* select just a small *sample for training data
	cap drop __*
	cap drop iten*
	cap drop tool*
	**sample 2
	
	/////////////////////////////////////////////////////////
	//	F) Rendimento domiciliar per capita (R$)
	/////////////////////////////////////////////////////////
	
	* Merge na base de dados com o deflator
	cap tostring Trimestre, replace
	merge m:1 Ano Trimestre UF using "$input_dir\deflatorPNADC_12.1-20.1.dta", update force
	drop if _merge==2 
	drop _merge
	cap destring Trimestre, replace
	
	/////////////////////////////////////////////////////////
	//	I) Pobreza
	/////////////////////////////////////////////////////////
	
	/////////////////////////////////////////////////////////
	// Número indivíduos com rendimento per capita de até R$ 89,00 
	/////////////////////////////////////////////////////////
	gen iten0 = renda_anual_pc * Habitual
	gen tool1 = 1 * V1032 if iten0 <= 89
	by Ano Trimestre, sort: egen tool2 = total(tool1)

	gen tempa1 = 1* V1032
	by Ano Trimestre, sort: egen tempa2 = total(tempa1)

	by Ano Trimestre, sort: gen prop_rendimento_domiciliar_89 = (tool2/tempa2)*100
	label variable prop_rendimento_domiciliar_89 "(%) de indivíduos com renda habitual domiciliar per capita de até R$ 89,00"
	cap drop iten*
	cap drop temp*
	cap drop tool*
	
	/////////////////////////////////////////////////////////
	// Número indivíduos com rendimento per capita de até R$ 178,00 
	/////////////////////////////////////////////////////////
	gen iten0 = renda_anual_pc * Habitual
	gen tool1 = 1 * V1032 if iten0 <= 178
	by Ano Trimestre, sort: egen tool2 = total(tool1)

	gen tempa1 = 1* V1032
	by Ano Trimestre, sort: egen tempa2 = total(tempa1)

	by Ano Trimestre, sort: gen prop_rendimento_domiciliar_178 = (tool2/tempa2)*100
	label variable prop_rendimento_domiciliar_178 "(%) de indivíduos com renda habitual domiciliar per capita de até R$ 178,00"
	cap drop iten*
	cap drop temp*
	cap drop tool*
	
	/////////////////////////////////////////////////////////
	//	C) Desigualdade
	/////////////////////////////////////////////////////////
		
	* Gini Renda Per Capita
	gen gini_rendimento_domiciliar_pc = .
	
	gen iten0 = renda_anual_pc * Habitual
	* loop over quarter
	levelsof Ano, local(xy) 
	foreach zz of local xy {
		ineqdeco iten0 [aw = V1032] if Ano == `zz' 
		replace gini_rendimento_domiciliar_pc = `r(gini)' if gini_rendimento_domiciliar_pc ==. & Ano == `zz'
	}
		
	label variable	gini_rendimento_domiciliar_pc "GINI do rendimento domiciliar per capita"
	cap drop iten*
	cap drop temp*
	
	**************************************
	**	Colapsar ao nível do trimestre 	**
	**************************************
	
	// attach label of variables
	local colvar visita prop_* gini_* 
	
	foreach v of var `colvar' {
	    local l`v' : variable label `v'
	}
	
	* colapse
	collapse (firstnm) `colvar' , by(Ano Trimestre)
	
	// copy back the label of variables
	foreach v of var `colvar' {
	    label var `v' "`l`v''"
	}
	
	* save as temporary
	save "$tmp_dir\_temp_desigualdade_renda_PNADC_anual_`year'_visita1.dta", replace

}
 
 
 
 ************************************
 * 	Append temporary data base
 ************************************
clear 
	// i) 2012 até 2015  (visita 1) &
	// ii) 2016 até 2019  (visita 1)
	forvalues year = 2012(1)2019 {
	append using "$tmp_dir\_temp_desigualdade_renda_PNADC_anual_`year'_visita1.dta"
	}

* sort	 
sort  Ano Trimestre visita
** Atenção!!! Temos casos de Trimestres duplicados (representando visita 1 e 5)
*** decidir criar variáveis auxiliares: a média da população para casos onde só há informação na visita 5


* keep only relavant variables
keep Ano Trimestre  prop_* gini_*
keep Ano Trimestre  prop_* gini_*