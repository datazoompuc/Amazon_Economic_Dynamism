/*
O propostio desse do file é:
Descrever a estrutura do emprego

Mais especificamente:
A) Taxa de desemprego
B) Proporção de ocupados
C) Taxa de participação
D) Taxa de informalidade
E) Inserção no mercado de trabalho por tipo ocupação
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
//	População total
/////////////////////////////////////////////////////////

* Número total
gen iten1 = 1 * V1028 
by Ano Trimestre, sort: egen n_populacao = total(iten1)
replace n_populacao = round(n_populacao)
label variable n_populacao "Número total de pessoas"
cap drop iten*

/////////////////////////////////////////////////////////
//	População Idade Ativa total
/////////////////////////////////////////////////////////

* Número total
gen iten1 = 1 * V1028 if pia == 1
by Ano Trimestre, sort: egen n_pia = total(iten1)
replace n_pia = round(n_pia)
label variable n_pia "Número total da PIA"
cap drop iten*


/////////////////////////////////////////////////////////
//	B1) Número de ocupados (15 a 64 anos)
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if idade_de_trabalhar ==1
by Ano Trimestre, sort: egen n_idade_de_trabalhar = total(iten1)
label variable n_idade_de_trabalhar "Número de pessoas entre 15 e 64 anos"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	A) Taxa de desemprego
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if desocupado == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen tool1 = 1 * V1028 if forcatrabalho == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

gen taxa_de_desemprego = (iten2/tool2)*100
label variable taxa_de_desemprego "Taxa de desemprego em relação à força de trabalho (%)"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	B) Proporção de ocupados
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen tool1 = 1 * V1028 if pia == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

gen taxa_de_ocupacao = (iten2/tool2)*100
label variable taxa_de_ocupacao "Taxa de ocupação em relação à PIA (%)"
cap drop iten* tool* 

/////////////////////////////////////////////////////////
//	C) Taxa de participação
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if pea == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen tool1 = 1 * V1028 if pia == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

gen taxa_de_participacao = (iten2/tool2)*100
label variable taxa_de_participacao "Taxa de participação em relação à PIA (%)"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	D) Taxa de informalidade
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if informal == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen tool1 = 1 * V1028 if ocupado == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

gen taxa_de_informalidade = (iten2/tool2)*100
label variable taxa_de_informalidade "Taxa de informalidade em relação aos ocupados (%)"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	C.1) Taxa de desalentados
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if desalento == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen tool1 = 1 * V1028 if pia == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

gen taxa_de_desalento = (iten2/tool2)*100
label variable taxa_de_desalento "Taxa de desalentados em relação a PIA (%)"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	C.1) Taxa de nem-nem
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if nemnem == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen tool1 = 1 * V1028 if pia == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

gen taxa_de_nemnem = (iten2/tool2)*100
label variable taxa_de_nemnem "Taxa de nem-nem em relação a PIA (%)"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	E) Inserção no mercado de trabalho por tipo ocupação
/////////////////////////////////////////////////////////

* total de ocupados
gen tool1 = 1 * V1028 if ocupado == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

* proporção de trabalhador com carteira assinada
gen iten1 = 1 * V1028 if empregadoCC == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen prop_empregadoCC = (iten2/tool2)*100
label variable prop_empregadoCC "Proporção de trabalhadores com carteira em relação aos ocupados (%)"
cap drop iten*

* proporção de trabalhador sem carteira assinada
gen iten1 = 1 * V1028 if empregadoSC == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen prop_empregadoSC = (iten2/tool2)*100
label variable prop_empregadoSC "Proporção de trabalhadores sem carteira em relação aos ocupados (%)"
cap drop iten*

* proporção de empregadores
gen iten1 = 1 * V1028 if empregador == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen prop_empregador = (iten2/tool2)*100
label variable prop_empregador "Proporção de empregadores em relação aos ocupados (%)"
cap drop iten*

* proporção de trabalhadores por conta-própria
gen iten1 = 1 * V1028 if cpropria == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen prop_cpropria = (iten2/tool2)*100
label variable prop_cpropria "Proporção de trabalhadores por conta própria em relação aos ocupados (%)"
cap drop iten*

* proporção de trabalhadores por conta-própria que contribui
gen iten1 = 1 * V1028 if cpropriaC == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen prop_cpropriaC = (iten2/tool2)*100
label variable prop_cpropriaC "Proporção de conta própria que contribui em relação aos ocupados (%)"
cap drop iten*

* proporção de trabalhadores por conta-própria que não contribui
gen iten1 = 1 * V1028 if cpropriaNc == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen prop_cpropriaNc = (iten2/tool2)*100
label variable prop_cpropriaNc "Proporção de conta própria que não contribui em relação aos ocupados (%)"
cap drop iten*

* proporção de militares
gen iten1 = 1 * V1028 if militar == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen prop_militar = (iten2/tool2)*100
label variable prop_militar "Proporção servidores públicos e militares em relação aos ocupados (%)"
cap drop iten*

* proporção de trabalhadores em casa
gen iten1 = 1 * V1028 if homeoffice == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen prop_homeoffice = (iten2/tool2)*100
label variable prop_homeoffice "Proporção trabalhadores em casa em relação aos ocupados (%)"
cap drop iten*

/////////////////////////////////////////////////////////
//	A) Número total de desemprego
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if desocupado == 1
by Ano Trimestre, sort: egen n_de_desemprego = total(iten1)
replace n_de_desemprego = round(n_de_desemprego)
label variable n_de_desemprego "Número de desempregados"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	A1) Número de desemprego (15 a 64 anos)
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if desocupado == 1 & idade_de_trabalhar ==1
by Ano Trimestre, sort: egen n_de_desemprego_idade = total(iten1)
label variable n_de_desemprego_idade "Número de desempregados (15 a 64 anos)"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	B) Número de ocupados
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1
by Ano Trimestre, sort: egen n_de_ocupacao = total(iten1)
label variable n_de_ocupacao "Número de ocupados"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	B1) Número de ocupados (15 a 64 anos)
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & idade_de_trabalhar ==1
by Ano Trimestre, sort: egen n_de_ocupacao_idade = total(iten1)
label variable n_de_ocupacao_idade "Número de ocupados (15 a 64 anos)"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	B2) Número fora da força de trabalho (15 a 64 anos)
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if forcatrabalhofora == 1 & idade_de_trabalhar ==1
by Ano Trimestre, sort: egen n_de_nforca_idade = total(iten1)
label variable n_de_nforca_idade "Número de fora da força de trabalho (15 a 64 anos)"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	D) Número total de informalidade
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if informal == 1
by Ano Trimestre, sort: egen n_de_informalidade = total(iten1)
replace n_de_informalidade = round(n_de_informalidade)
label variable n_de_informalidade "Número de trabalhadores informais"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	D.1) Número total de desalentados
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if desalento == 1
by Ano Trimestre, sort: egen n_de_desalento = total(iten1)
replace n_de_desalento = round(n_de_desalento)
label variable n_de_desalento "Número de desalentados"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	D.2) Número total de nem-nem
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if nemnem == 1
by Ano Trimestre, sort: egen n_de_nemnem= total(iten1)
replace n_de_nemnem = round(n_de_nemnem)
label variable n_de_nemnem "Número de nem-nem"
cap drop iten*
cap drop tool* 

/////////////////////////////////////////////////////////
//	E) Inserção no mercado de trabalho por tipo ocupação
/////////////////////////////////////////////////////////

* Número de trabalhador com carteira assinada
gen iten1 = 1 * V1028 if empregadoCC == 1
by Ano Trimestre, sort: egen n_empregadoCC = total(iten1)
replace n_empregadoCC = round(n_empregadoCC)
label variable n_empregadoCC "Número de trabalhadores com carteira"
cap drop iten*

* Número de trabalhador sem carteira assinada
gen iten1 = 1 * V1028 if empregadoSC == 1
by Ano Trimestre, sort: egen n_empregadoSC = total(iten1)
replace n_empregadoSC = round(n_empregadoSC)
label variable n_empregadoSC "Número de trabalhadores sem carteira"
cap drop iten*

* Número de empregadores
gen iten1 = 1 * V1028 if empregador == 1
by Ano Trimestre, sort: egen n_empregador = total(iten1)
replace n_empregador = round(n_empregador)
label variable n_empregador "Número de empregadores"
cap drop iten*

* Número de trabalhadores por conta-própria
gen iten1 = 1 * V1028 if cpropria == 1
by Ano Trimestre, sort: egen n_cpropria = total(iten1)
replace n_cpropria = round(n_cpropria)
label variable n_cpropria "Número de trabalhadores por conta própria"
cap drop iten*

* Número de trabalhadores por conta-própria que contribui
gen iten1 = 1 * V1028 if cpropriaC == 1
by Ano Trimestre, sort: egen n_cpropriaC = total(iten1)
replace n_cpropriaC = round(n_cpropriaC)
label variable n_cpropriaC "Número de conta própria que contribui"
cap drop iten*

* Número de trabalhadores por conta-própria que não contribui
gen iten1 = 1 * V1028 if cpropriaNc == 1
by Ano Trimestre, sort: egen n_cpropriaNc = total(iten1)
replace n_cpropriaNc = round(n_cpropriaNc)
label variable n_cpropriaNc "Número de conta própria que não contribui"
cap drop iten*

* Número de militares
gen iten1 = 1 * V1028 if militar == 1
by Ano Trimestre, sort: egen n_militar = total(iten1)
replace n_militar = round(n_militar)
label variable n_militar "Número servidores públicos e militares"
cap drop iten*

* Número de trabalhadores em casa
gen iten1 = 1 * V1028 if homeoffice == 1
by Ano Trimestre, sort: egen n_homeoffice = total(iten1)
replace n_homeoffice = round(n_homeoffice)
label variable n_homeoffice "Número trabalhadores em casa"
cap drop iten*


/////////////////////////////////////////////////////////
//	Caracterização por faixas de etarias, educacional, genero
/////////////////////////////////////////////////////////

// attach label of variables
local faixa faixa_*

foreach v of var `faixa' {

    local l`v' : variable label `v'
    /////////////////////////////////////////////////////////
	//	Número total
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if `v'==1
	by Ano Trimestre, sort: egen n_`v' = total(iten1)
	replace n_`v' = round(n_`v')
	label variable n_`v' "Número total"
	cap drop iten*

	/////////////////////////////////////////////////////////
	//	Número de ocupados 
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if ocupado == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_ocupado_`v' = total(iten1)
	replace n_de_ocupado_`v' = round(n_de_ocupado_`v')
	label variable n_de_ocupado_`v' "Número de ocupados"
	cap drop iten*
	
	/////////////////////////////////////////////////////////
	//	Número de formal 
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if formal == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_formal_`v' = total(iten1)
	replace n_de_formal_`v' = round(n_de_formal_`v')
	label variable n_de_formal_`v' "Número de formal"
	cap drop iten*
	
	/////////////////////////////////////////////////////////
	//	Número de informal  
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if informal == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_informal_`v' = total(iten1)
	replace n_de_informal_`v' = round(n_de_informal_`v')
	label variable n_de_informal_`v' "Número de informais"
	cap drop iten*

	/////////////////////////////////////////////////////////
	//	Número de economicamente ativo (PEA)  
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if pea == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_pea_`v' = total(iten1)
	replace n_de_pea_`v' = round(n_de_pea_`v')
	label variable n_de_pea_`v' "Número de PEA"
	cap drop iten*

	/////////////////////////////////////////////////////////
	//	Número de desalentados 
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if desalento == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_desa_`v' = total(iten1)
	replace n_de_desa_`v' = round(n_de_desa_`v')
	label variable n_de_desa_`v' "Número de desalentados"
	cap drop iten*	

	/////////////////////////////////////////////////////////
	//	Número de nem-nem 
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if nemnem == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_nemnem_`v' = total(iten1)
	replace n_de_nemnem_`v' = round(n_de_nemnem_`v')
	label variable n_de_nemnem_`v' "Número de nem-nem"
	cap drop iten*	
	
	/////////////////////////////////////////////////////////
	//	Número de empregadoSC
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if empregadoSC == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_empregadoSC_`v' = total(iten1)
	replace n_de_empregadoSC_`v' = round(n_de_empregadoSC_`v')
	label variable n_de_empregadoSC_`v' "Número "
	cap drop iten*
	
	/////////////////////////////////////////////////////////
	//	Número de empregadoCC
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if empregadoCC == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_empregadoCC_`v' = total(iten1)
	replace n_de_empregadoCC_`v' = round(n_de_empregadoCC_`v')
	label variable n_de_empregadoCC_`v' "Número "
	cap drop iten*
	
	/////////////////////////////////////////////////////////
	//	Número de cpropriaC
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if cpropriaC == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_cpropriaC_`v' = total(iten1)
	replace n_de_cpropriaC_`v' = round(n_de_cpropriaC_`v')
	label variable n_de_cpropriaC_`v' "Número "
	cap drop iten*
	
	/////////////////////////////////////////////////////////
	//	Número de cpropriaNc
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if cpropriaNc == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_cpropriaNc_`v' = total(iten1)
	replace n_de_cpropriaNc_`v' = round(n_de_cpropriaNc_`v')
	label variable n_de_cpropriaNc_`v' "Número "
	cap drop iten*
	
	/////////////////////////////////////////////////////////
	//	Número de empregador
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if empregador == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_empregador_`v' = total(iten1)
	replace n_de_empregador_`v' = round(n_de_empregador_`v')
	label variable n_de_empregador_`v' "Número "
	cap drop iten*
	
	/////////////////////////////////////////////////////////
	//	Número de militar
	/////////////////////////////////////////////////////////
	gen iten1 = 1 * V1028 if militar == 1 & `v'==1
	by Ano Trimestre, sort: egen n_de_militar_`v' = total(iten1)
	replace n_de_militar_`v' = round(n_de_militar_`v')
	label variable n_de_militar_`v' "Número "
	cap drop iten*
	

}

**************************************
**	Colapsar ao nível do trimestre 	**
**************************************

// attach label of variables
local colvar prop_* taxa_* n_*

foreach v of var `colvar' {
    local l`v' : variable label `v'
}

* colapse
collapse (firstnm) `colvar' , by(Ano Trimestre)

// copy back the label of variables
foreach v of var `colvar' {
    label var `v' "`l`v''"
}








