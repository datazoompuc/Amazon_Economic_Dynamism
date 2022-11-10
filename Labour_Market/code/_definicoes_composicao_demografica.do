**********************
**	 Definitions	**
**********************

/*	Useful variables: Education

VD3004
1 // Sem instrução e menos de 1 ano de estudo
2 // Fundamental incompleto ou equivalente
3 // Fundamental completo ou equivalente
4 // Médio incompleto ou equivalente
5 // Médio completo ou equivalente
6 // Superior incompleto ou equivalente
7 // Superior completo 
. // Não aplicável

*/

/*	Useful variables: Rural vs. Urban
V1022
1 // Urbana
2 // Rural
*/

/*	Useful variables: race
V2010		Cor ou raça	
1	Branca
2	Preta
3	Amarela
4	Parda 
5	Indígena
9	Ignorado
*/
			
**********************************
**	Definições de variáveis 	**
**********************************

local keep_this $definicao_demografica
display "$definicao_demografica"
display "`keep_this'"

if "`keep_this'" == "edu_1fundamental" {
	* nivel educacional até fundamental
	gen edu_1fundamental = 0 
	replace edu_1fundamental =  1 if VD3004 ==1 	// Sem instrução e menos de 1 ano de estudo
	replace edu_1fundamental =  1 if VD3004 ==2 	// Fundamental incompleto ou equivalente
	replace edu_1fundamental =  1 if VD3004 ==3 	// Fundamental completo ou equivalente
	keep if edu_1fundamental==1
}


else if "`keep_this'" == "edu_2medio" {
	* nivel educacional até médio completo
	gen edu_2medio = 0 
	replace edu_2medio =  1 if VD3004 ==4 	// Médio incompleto ou equivalente
	replace edu_2medio =  1 if VD3004 ==5 	// Médio completo ou equivalente
	replace edu_2medio =  1 if VD3004 ==6 	// Superior incompleto ou equivalente
	keep if edu_2medio==1
}


else if "`keep_this'" == "edu_3superior" {
	* nivel educacional superior completo
	gen edu_3superior = 0 
	replace edu_3superior =  1 if VD3004 ==7 	// Superior completo 
	keep if edu_3superior==1
}


else if "`keep_this'" == "domicilio_urbano" {
	* urbano
	gen domicilio_urbano = 0
	replace domicilio_urbano = 1 if V1022 ==1 // 1 Urbana
	keep if domicilio_urbano==1
}

else if "`keep_this'" == "domicilio_rural" {
	* rural
	gen domicilio_rural = 0
	replace domicilio_rural = 1 if V1022 ==2 // 2 Rural
	keep if domicilio_rural==1
}

else if "`keep_this'" == "homem" {
* sexo: homem
	gen homem = 0
	replace homem = 1 if V2007 ==1 // 1 Homem
	keep if homem==1
}


else if "`keep_this'" == "mulher" {
* sexo: mulher
	gen mulher = 0
	replace mulher = 1 if V2007 ==2 // 1 Mulher
	keep if mulher==1
}

else if "`keep_this'" == "raca_branca" {
	* raça: branca/amarela
	gen raca_branca = 0
	replace raca_branca = 1 if V2010 ==1 // 1 Branca
	replace raca_branca = 1 if V2010 ==3 // 1 Amarela
	keep if raca_branca==1
}

else if "`keep_this'" == "raca_preta" {
	* raça: preta/parda
	gen raca_preta = 0
	replace raca_preta = 1 if V2010 ==2 // 1 Preta
	replace raca_preta = 1 if V2010 ==4 // 1 Parda 
	keep if raca_preta==1
}

else if "`keep_this'" == "raca_indigena" {
	* raça: indígena
	gen raca_indigena = 0
	replace raca_indigena = 1 if V2010 ==5 // 1 Indígena
	keep if raca_indigena==1
}

else if "`keep_this'" == "faixa_etaria_17" {
	gen faixa_etaria_17 = 1 if V2009 >= 14 & V2009 <= 17
	keep if faixa_etaria_17==1
}

else if "`keep_this'" == "faixa_etaria_24" {
	gen faixa_etaria_24 = 1 if V2009 >= 18 & V2009 <= 24
	keep if faixa_etaria_24==1
}

else if "`keep_this'" == "faixa_etaria_39" {
	gen faixa_etaria_39 = 1 if V2009 >= 25 & V2009 <= 39
	keep if faixa_etaria_39==1
}

else if "`keep_this'" == "faixa_etaria_59" {
	gen faixa_etaria_59 = 1 if V2009 >= 40 & V2009 <= 59
	keep if faixa_etaria_59==1
}

else if "`keep_this'" == "faixa_etaria_60" {
	gen faixa_etaria_60 = 1 if V2009 >= 60
	keep if faixa_etaria_60==1
}

else if "`keep_this'" == "setor_agricultura" {
	gen setor_agricultura = 1 if VD4010 == 1 	// Indústria geral
	keep if setor_agricultura==1
}

else if "`keep_this'" == "setor_industria" {
	gen setor_industria = 1 if VD4010 == 2 	// Indústria geral
	keep if setor_industria==1
}

else if "`keep_this'" == "setor_construcao" {
	gen setor_construcao = 1 if VD4010 == 3 	// Construção
	keep if setor_construcao==1
}

else if "`keep_this'" == "setor_comercio" {
	gen setor_comercio = 1 if VD4010 == 4 	// Comércio, reparação de veículos automotores e motocicletas
	keep if setor_comercio==1
}

else if "`keep_this'" == "setor_servicos" {
	gen setor_servicos = 1 if VD4010 >= 5 	// 
	keep if setor_servicos==1
}

else if "`keep_this'" == "area_regiao_metropolitana" {
	gen area_regiao_metropolitana = 1 if V1023 == 1 	//  Capital
	replace area_regiao_metropolitana = 1 if V1023 == 2 	// 	Resto da RM (Região Metropolitana, excluindo a capital)
	keep if area_regiao_metropolitana==1
}

else if "`keep_this'" == "area_nregiao_metropolitana" {
	gen area_nregiao_metropolitana = 1 if V1023 == 3 	//  Resto da RIDE (Região Integrada de Desenvolvimento Econômico, excluindo a capital) 
	replace area_nregiao_metropolitana = 1 if V1023 == 4 	// 	Resto da UF  (Unidade da Federação, excluindo a região metropolitana e a RIDE)
	keep if area_nregiao_metropolitana==1
}