/*
O propostio desse do file é:
Descrever a estrutura do emprego da Amazônia Legal Diferenciado por comoposição demográfica

Mais especificamente, comparar variáveis entre:
1) Educação
2) Área geográfica
3) Gênero
4) Raça
5) Setor ocupacional

Variáveis de interesse:
A) Taxa de desemprego
B) Proporção de ocupados
C) Taxa de participação
D) Taxa de informalidade
E) Inserção no mercado de trabalho por tipo ocupação
*/


**********************
**	Amazônia Legal	**
**********************

global area_geografica = "Amazônia Legal"


local type raca_branca raca_preta raca_indigena 	/*
	*/ 	edu_1fundamental edu_2medio edu_3superior 	/*
	*/ 	domicilio_urbano domicilio_rural 	/*
	*/ 	homem mulher area_regiao_metropolitana area_nregiao_metropolitana /*
	*/ 	setor_agricultura setor_industria setor_construcao setor_comercio setor_servicos 	/*
	*/ 	faixa_etaria_17 faixa_etaria_24 faixa_etaria_39 faixa_etaria_59 faixa_etaria_60
	
* begin of loop over demographic composition
foreach lname in `type' {
	
* begin of loop over years
forvalues yr = 2012(1)2022{	
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	* run code
	global definicao_demografica `lname'
	do "$code_dir\_definicoes_composicao_demografica"
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_composicao_demografica_PNADC`yr'.dta", replace

* end of loop over years	
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_composicao_demografica_PNADC`yr'.dta"
}

* generate variable depicting 
gen `lname' = 1

* save in the output directory
save "$output_dir\_composicao_demografica_amazonia_legal_`lname'.dta", replace
export excel using "$output_dir\_composicao_demografica_amazonia_legal_`lname'.xls", /*
	*/	firstrow(varlabels) replace

* end of loop over demographic composition
}





