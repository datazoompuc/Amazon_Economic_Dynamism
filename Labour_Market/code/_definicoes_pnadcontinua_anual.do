**********************
**	 Definitions	**
**********************

/*	Useful variables: Income

VD4016: 
Rendimento mensal habitual do trabalho principal para pessoas de 14 anos ou mais de idade 
(apenas para pessoas que receberam em dinheiro, produtos ou mercadorias no trabalho principal)

VD4019
Rendimento mensal habitual de todos os trabalhos para pessoas de 14 anos ou mais de idade 
(apenas para pessoas que receberam em dinheiro, produtos ou mercadorias em qualquer trabalho)

*/

/*	Useful variables: Labor

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

**************************************
** Definição de Área Geográfica 	**
**************************************

if "$area_geografica" == "Amazônia Legal"   {
    keep if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)
	
	local area = "amazonia_legal"
}
else if "$area_geografica" == "Resto do Brasil"   {
    drop if UF == 11 	/* 	Rondônia
	*/ 	| UF == 12 	/* Acre
	*/ 	| UF == 13 	/* Amazonas
	*/ 	| UF == 14 	/* Roraima
	*/ 	| UF == 15 	/* Pará
	*/ 	| UF == 16 	/* Amapá
	*/ 	| UF == 17 	/* Tocantins
	*/ 	| UF == 51 	/* Mato Grosso
	*/ 	| (UF == 21 & V1023 == 4) 	// Maranhão & Resto da UF (Unidade da Federação, excluindo a região metropolitana e a RIDE)

	local area = "resto_brasil"
}	

**********************************
**	Definições de variáveis 	**
**********************************

* pessoa ocupado
gen ocupado = 1 if VD4002 == 1 	// Pessoas ocupadas 
replace ocupado = 0 if ocupado ==. 

* pessoa desocupado
gen desocupado = 1 if VD4002 == 2 	// Pessoas desocupadas 
replace desocupado = 0 if desocupado ==. 

** trabalhador formal
gen formal =.
replace formal = 1 if VD4002 == 1 &  VD4009 == 1 	// Empregado no setor privado com carteira de trabalho assinada
replace formal = 1 if VD4002 == 1 &  VD4009 == 3 	// Trabalhador doméstico com carteira de trabalho assinada
replace formal = 1 if VD4002 == 1 &  VD4009 == 5 	// Empregado no setor público com carteira de trabalho assinada
replace formal = 1 if VD4002 == 1 &  VD4009 == 7 	// Militar e servidor estatutário
replace formal = 1 if VD4002 == 1 &  VD4009 == 9 & VD4012 == 1  // Conta-própria & Contribuinte
replace formal = 0 if formal ==.

** trabalhador informal
gen informal =.
replace informal = 1 if VD4002 == 1 &  VD4009 == 2 	// Empregado no setor privado sem carteira de trabalho assinada 
replace informal = 1 if VD4002 == 1 &  VD4009 == 4 	// Trabalhador doméstico sem carteira de trabalho assinada
replace informal = 1 if VD4002 == 1 &  VD4009 == 6 	// Empregado no setor público sem carteira de trabalho assinada
replace informal = 1 if VD4002 == 1 &  VD4009 == 9 & VD4012 == 2 	// Conta-própria & Não contribuinte
replace informal = 1 if VD4002 == 1 &  VD4009 == 10 	// Trabalhador familiar auxiliar
replace informal = 0 if informal ==. 

* pessoa na força de trabalho
gen forcatrabalho = 1 if VD4001 == 1 	// Pessoas na força de trabalho
replace forcatrabalho = 0 if forcatrabalho ==. 

* pessoa fora da força de trabalho
gen forcatrabalhofora = 1 if VD4001 == 2	// Pessoas fora da força de trabalho
replace forcatrabalhofora = 0 if forcatrabalhofora ==. 

* pessoa com idade ativa
gen pia = 1 if V2009 >= 14	// PIA = pessoas em idade de trabalhar inclui as pessoas de 14 anos
replace forcatrabalhofora = 0 if forcatrabalhofora ==. 

* pessoa com economicamente ativa
gen pea = 1 if VD4002 ==1 | VD4002 ==2  // PEA = população ocupada + população desocupada
replace pea = 0 if pea ==. 

* pessoa inativa
gen inativa = 1 if VD4001 == 2  // população desocupada
replace inativa = 0 if inativa ==. 

* pessoa desempregado
gen desempregado = 1 if VD4001 == 1 & VD4002 == 2 // pessoa na força de trabalho & população desocupada
replace desempregado = 0 if desempregado ==. 

* pessoa desalentada (não tomou tomou alguma providência para conseguir trabalho)
* ou V4074 =3 Desistiu de procurar por não conseguir encontrar trabalho
* e
* V4074 =4  Acha que não vai encontrar trabalho por ser muito jovem ou muito idoso
gen desalento = 1 if VD4005 ==1 // Pessoas desalentadas
replace desalento = 0 if desalento ==. 

* pessoa nem-nem
gen nemnem = 1 if VD4002 ==2  // população desocupada
cap replace nemnem = 1 if VD4001 == 2 & V3002 == 2 // Fora da força de trabalho e não estuda
cap replace nemnem = 0 if V3002 == 1 // frequenta escola? Sim
cap replace nemnem = 0 if V4074 == 6 // Qual foi o principal motivo de não ter tomado providência para conseguir trabalho? Estudo
cap replace nemnem = 0 if V4074A == 8 // Estava estudando (curso de qualquer tipo ou por conta própria)
replace nemnem = 0 if nemnem ==. 

* pessoa empregado SC
gen empregadoSC = 1 if VD4009 == 2 | VD4009 == 4 | VD4009 == 6 | VD4009 == 10 // trabalhadores informais
replace empregadoSC = 0 if empregadoSC ==. 

* pessoa empregado CC
gen empregadoCC = 1 if VD4009 == 1 | VD4009 == 3 | VD4009 == 5  // trabalhadores formais
replace empregadoCC = 0 if empregadoCC ==. 

* pessoa conta-própria
gen cpropria = 1 if VD4009 == 9  // conta-própria
replace cpropria = 0 if cpropria ==. 

* pessoa conta-própria contribuinte
gen cpropriaC = 1 if VD4009 == 9 & VD4012 == 1  // Conta-própria & Contribuinte
replace cpropriaC = 0 if cpropriaC ==. 

* pessoa conta-própria não-contribuinte
gen cpropriaNc = 1 if VD4009 == 9 & VD4012 == 2  // Conta-própria & Não contribuinte
replace cpropriaNc = 0 if cpropriaNc ==. 

* pessoa empregador
gen empregador = 1 if VD4009 == 8  // empregador
replace empregador = 0 if empregador ==. 

* pessoa militar e servidor estatutário
gen militar = 1 if VD4009 == 7  // militar e servidor estatutário
replace militar = 0 if militar ==. 

**************************************
**	Variáveis problemáticas 		**
**	que alteram ao longo do anos 	**
**************************************

* recebeu bolsa família
gen bolsa_familia=.

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace bolsa_familia=1 if V50101==1 //  ... recebeu Bolsa família ou do Programa de Erradicação do Trabalho Infantil - PETI
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace bolsa_familia=1 if V50101==1 & Trimestre ~=4 //  recebeu Bolsa família ou do Programa de Erradicação do Trabalho Infantil - PETI
		* Trimestre 4
		replace bolsa_familia=1 if V5002A==1 & Trimestre ==4 //  recebeu rendimentos de Programa Bolsa Família?
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
	replace bolsa_familia=1 if V5002A==1
}

* recebeu programa social
gen ajuda_gov=.

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace ajuda_gov=1 if V50101==1 //  recebeu Bolsa família ou do Programa de Erradicação do Trabalho Infantil - PETI
		replace ajuda_gov=1 if V50091==1 //  recebeu Benefício Assistencial de Prestação Continuada - BPC - LOAS
 		replace ajuda_gov=1 if V50111==1 //  recebeu rendimentos de algum outro programa social, público ou privado
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace ajuda_gov=1 if V50101==1 & Trimestre ~=4 //  recebeu Bolsa família ou do Programa de Erradicação do Trabalho Infantil - PETI
		replace ajuda_gov=1 if V50091==1 & Trimestre ~=4 //  recebeu Benefício Assistencial de Prestação Continuada - BPC - LOAS
 		replace ajuda_gov=1 if V50111==1 & Trimestre ~=4 //  recebeu rendimentos de algum outro programa social, público ou privado
		* Trimestre 4
		replace ajuda_gov=1 if V5002A==1 & Trimestre ==4 //  recebeu rendimentos de Programa Bolsa Família?
		replace ajuda_gov=1 if V5001A==1 & Trimestre ==4 //  recebeu rendimentos de Benefício Assistencial de Prestação Continuada – BPC-LOAS?
 		replace ajuda_gov=1 if V5003A==1 & Trimestre ==4 //  recebeu rendimentos de outros programas sociais do governo?
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace ajuda_gov=1 if V5002A==1 //  recebeu rendimentos de Programa Bolsa Família?
		replace ajuda_gov=1 if V5001A==1 //  recebeu rendimentos de Benefício Assistencial de Prestação Continuada – BPC-LOAS?
 		replace ajuda_gov=1 if V5003A==1 //  recebeu rendimentos de outros programas sociais do governo?
}

* recebeu bpc_loas
gen bpc_loas=.

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace bpc_loas=1 if V50091==1 //  recebeu Benefício Assistencial de Prestação Continuada - BPC - LOAS
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace bpc_loas=1 if V50091==1 & Trimestre ~=4 //  recebeu Benefício Assistencial de Prestação Continuada - BPC - LOAS
		* Trimestre 4
		replace bpc_loas=1 if V5001A==1 & Trimestre ==4 //  recebeu rendimentos de Benefício Assistencial de Prestação Continuada – BPC-LOAS?
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace bpc_loas=1 if V5001A==1 //  recebeu rendimentos de Benefício Assistencial de Prestação Continuada – BPC-LOAS?
}

**************************************
**	Outros rendimentos		 		**
**************************************

* Rendimento domiciliar per capita (habitual de todos os trabalhos e efetivo de outras fontes) 
gen renda_anual_pc = .

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace renda_anual_pc = VD5008 //  Rend habitual domiciliar per capita
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace renda_anual_pc = VD5008 if Trimestre ~=4 //  Rend habitual domiciliar per capita
		* Trimestre 4
		replace renda_anual_pc = VD5011 if Trimestre ==4  //  Rend habitual domiciliar per capita
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace renda_anual_pc = VD5011 //  Rend habitual domiciliar per capita
}

* Rendimento recebido em todas as fontes 
gen renda_anual = .

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace renda_anual = VD5008 //  Rend habitual domiciliar per capita
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace renda_anual = VD5008 if Trimestre ~=4 //  Rend habitual domiciliar per capita
		* Trimestre 4
		replace renda_anual= VD5011 if Trimestre ==4  //  Rend habitual domiciliar per capita
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace renda_anual= VD5011 //  Rend habitual domiciliar per capita
}

* Recebeu rendimentos de seguro-desemprego, seguro-defeso
gen seguro_desemp = .

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace seguro_desemp = 1 if V50081 ==1  //  Rend habitual domiciliar per capita
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace seguro_desemp = 1 if V50081 ==1 & Trimestre ~=4  //  Rend habitual domiciliar per capita
		* Trimestre 4
		replace seguro_desemp = 1 if  V5005A ==1 & Trimestre ==4  //  Rend habitual domiciliar per capita
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace seguro_desemp = 1 if  V5005A ==1 //  Rend habitual domiciliar per capita
}

* Recebeu rendimentos de aposentadoria ou pensão de instituto de previdência federal (INSS), estadual, municipal, ou do governo federal, estadual, municipal?
gen aposentadoria = .

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace aposentadoria = 1 if V50011 ==1  //  ... recebeu aposentadoria de instituto de previdência
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace aposentadoria = 1 if V50011 ==1 & Trimestre ~=4  //  ... recebeu aposentadoria de instituto de previdência
		* Trimestre 4
		replace aposentadoria = 1 if  V5004A ==1 & Trimestre ==4 //  Recebeu aposentadoria e pensão "
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace aposentadoria = 1 if  V5004A ==1 //  Recebeu aposentadoria e pensão "
}

**************************************
**	Composição de  rendimentos      **
**************************************

* Rendimento recebido de programa sociais
gen renda_ajuda_gov=.

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace renda_ajuda_gov= V501011 if V50101==1 //  recebeu Bolsa família ou do Programa de Erradicação do Trabalho Infantil - PETI
		replace renda_ajuda_gov= V500911 if V50091==1 //  recebeu Benefício Assistencial de Prestação Continuada - BPC - LOAS
 		replace renda_ajuda_gov= V501111 if V50111==1 //  recebeu rendimentos de algum outro programa social, público ou privado
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace renda_ajuda_gov= V501011 if V50101==1 & Trimestre ~=4 //  recebeu Bolsa família ou do Programa de Erradicação do Trabalho Infantil - PETI
		replace renda_ajuda_gov= V500911 if V50091==1 & Trimestre ~=4 //  recebeu Benefício Assistencial de Prestação Continuada - BPC - LOAS
 		replace renda_ajuda_gov= V501111 if V50111==1 & Trimestre ~=4 //  recebeu rendimentos de algum outro programa social, público ou privado
		* Trimestre 4
		replace renda_ajuda_gov= V5002A2 if V5002A==1 & Trimestre ==4 //  recebeu rendimentos de Programa Bolsa Família?
		replace renda_ajuda_gov= V5001A2 if V5001A==1 & Trimestre ==4 //  recebeu rendimentos de Benefício Assistencial de Prestação Continuada – BPC-LOAS?
 		replace renda_ajuda_gov= V5003A2 if V5003A==1 & Trimestre ==4 //  recebeu rendimentos de outros programas sociais do governo?
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace renda_ajuda_gov= V5002A2 if V5002A==1 //  recebeu rendimentos de Programa Bolsa Família?
		replace renda_ajuda_gov= V5001A2 if V5001A==1 //  recebeu rendimentos de Benefício Assistencial de Prestação Continuada – BPC-LOAS?
 		replace renda_ajuda_gov= V5003A2 if V5003A==1 //  recebeu rendimentos de outros programas sociais do governo?
}

* Rendimento recebido de seguro-desemprego, seguro-defeso
gen renda_seguro_desemp = .

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace renda_seguro_desemp = V500811 if V50081 ==1  //  Rend de seguro desemprego
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace renda_seguro_desemp = V500811 if V50081 ==1 & Trimestre ~=4  //   seguro-desemprego, seguro-defeso
		* Trimestre 4
		replace renda_seguro_desemp = V5005A2 if  V5005A ==1 & Trimestre ==4  //   seguro-desemprego, seguro-defeso
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace renda_seguro_desemp = V5005A2 if  V5005A ==1 //   seguro-desemprego, seguro-defeso
}

* Rendimento de renda_aposentadoria ou pensão de instituto de previdência federal (INSS), estadual, municipal, ou do governo federal, estadual, municipal?
gen renda_aposentadoria = .

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace renda_aposentadoria = V500111 if V50011 ==1   //  ... recebeu aposentadoria de instituto de previdência
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace renda_aposentadoria = V500111 if V50011 ==1  & Trimestre ~=4  //  ... recebeu aposentadoria de instituto de previdência
		* Trimestre 4
		replace renda_aposentadoria = V5004A2 if V5004A ==1  & Trimestre ==4 //  Recebeu aposentadoria e pensão "
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace renda_aposentadoria = V5004A2 if V5004A ==1  //  Recebeu aposentadoria e pensão "
}

* Rendimento de rendimentos de pensão alimentícia, doação ou mesada em dinheiro de pessoa que não morava no domicílio?
gen renda_doacao = .

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace renda_doacao = V500511 if V50051 ==1   //  ... recebeu pensão alimentícia
		replace renda_doacao = V500711 if V50071 ==1   //  ... recebeu doação em dinheiro

}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace renda_doacao = V500511 if V50051 ==1  & Trimestre ~=4  //  ... recebeu pensão alimentícia
		replace renda_doacao = V500711 if V50071 ==1  & Trimestre ~=4  //  ... recebeu doação em dinheiro		
		* Trimestre 4
		replace renda_doacao = V5006A2 if V5006A ==1  & Trimestre ==4 //   recebeu rendimentos de pensão alimentícia, doação ou mesada em dinheiro de pessoa que não morava no domicílio?
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace renda_doacao = V5006A2 if V5006A ==1  //   recebeu rendimentos de pensão alimentícia, doação ou mesada em dinheiro de pessoa que não morava no domicílio?
}

* Rendimento de rendimentos de aluguel ou arrendamento
gen renda_aluguel = .

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace renda_aluguel = V50061 if V5006 ==1   //  ... recebeu aluguel ou arrendamento
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace renda_aluguel = V50061 if V5006 ==1  & Trimestre ~=4  //  ... recebeu aluguel ou arrendamento
		* Trimestre 4
		replace renda_aluguel = V5007A2 if V5007A ==1  & Trimestre ==4 //   recebeu rendimentos de aluguel ou arrendamento?
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace renda_aluguel = V5007A2 if V5007A ==1  //   recebeu rendimentos de aluguel ou arrendamento?
}

* Rendimento de outros rendimentos (bolsa de estudos, rendimento de caderneta de poupança, aplicações financeiras, etc.). 
gen renda_outro = .

if $time == 2012 /*
	*/ 	| 	$time == 2013 /* 
	*/ 	| 	$time == 2014 {
		replace renda_outro = V501211 if V50121 ==1   //  ... recebeu rendimentos de poupança
		replace renda_outro = V501311 if V50131 ==1   //  ... recebeu rendimentos de parceria, direitos autoriais	
}

if $time == 2015 {
		* Trimestre 1, 2, 3
		replace renda_outro = V501211 if V50121 ==1  & Trimestre ~=4  //  ... recebeu rendimentos de poupança
		replace renda_outro = V501311 if V50131 ==1  & Trimestre ~=4  //  ... recebeu rendimentos de parceria, direitos autoriais			
		* Trimestre 4
		replace renda_outro = V5008A2 if V5008A ==1  & Trimestre ==4 //    recebeu outros rendimentos (bolsa de estudos, rendimento de caderneta de poupança, aplicações financeiras, etc.). 
}

if $time == 2016 /* 
	*/ 	| 	$time == 2017 /* 
	*/ 	| 	$time == 2018 /* 
	*/ 	| 	$time == 2019 {
		replace renda_outro = V5008A2 if V5008A ==1  //    recebeu outros rendimentos (bolsa de estudos, rendimento de caderneta de poupança, aplicações financeiras, etc.). 
}

* Rendimento no setor publico
gen renda_setorpublico = .

replace renda_setorpublico = VD4019 if VD4002 == 1 &  VD4009 == 5 	// Empregado no setor público com carteira de trabalho assinada
replace renda_setorpublico = VD4019 if VD4002 == 1 &  VD4009 == 6 	// Empregado no setor público sem carteira de trabalho assinada
replace renda_setorpublico = VD4019 if VD4002 == 1 &  VD4009 == 7 	// Militar e servidor estatutário

* Rendimento no setor privado formal
gen renda_privadoformal = .

replace renda_privadoformal = VD4019 if VD4002 == 1 &  VD4009 == 1 	// Empregado no setor privado com carteira de trabalho assinada
replace renda_privadoformal = VD4019 if VD4002 == 1 &  VD4009 == 3 	// Trabalhador doméstico com carteira de trabalho assinada
replace renda_privadoformal = VD4019 if VD4002 == 1 &  VD4009 == 9 & VD4012 == 1  // Conta-própria & Contribuinte

* Rendimento no setor privado informal
gen renda_privadoinformal =.
replace renda_privadoinformal = VD4019 if VD4002 == 1 &  VD4009 == 2 	// Empregado no setor privado sem carteira de trabalho assinada 
replace renda_privadoinformal = VD4019 if VD4002 == 1 &  VD4009 == 4 	// Trabalhador doméstico sem carteira de trabalho assinada
replace renda_privadoinformal = VD4019 if VD4002 == 1 &  VD4009 == 9 & VD4012 == 2 	// Conta-própria & Não contribuinte
replace renda_privadoinformal = VD4019 if VD4002 == 1 &  VD4009 == 10 	// Trabalhador familiar auxiliar

* Faixa de renda por quintil 
xtile renda_quintil = VD5008 [w=V1032] , nq(5)

**************************************
**	Composição de  rendimentos por faixa de renda     **
**************************************
//  Loop over common variables
local faixa  renda_anual renda_anual_pc renda_ajuda_gov  renda_seguro_desemp  renda_aposentadoria  renda_doacao  renda_aluguel  renda_outro  renda_setorpublico renda_privadoformal renda_privadoinformal

foreach v in `faixa' {
	* Rendimento recebido em todas as fontes (R$)
	gen `v'1 = `v' if VD5009 == 1
	gen `v'2 = `v' if VD5009 == 2
	gen `v'3 = `v' if VD5009 == 3
	gen `v'4 = `v' if VD5009 == 4
	gen `v'5 = `v' if VD5009 == 5
	gen `v'6 = `v' if VD5009 == 6
	gen `v'7 = `v' if VD5009 == 7
	
	* Faixa de quintil
	gen `v'q1 = `v' if renda_quintil == 1
	gen `v'q2 = `v' if renda_quintil == 2
	gen `v'q3 = `v' if renda_quintil == 3
	gen `v'q4 = `v' if renda_quintil == 4
	gen `v'q5 = `v' if renda_quintil == 5	
}

******************************************************
**	Trabalhadores não remunerados e consumo próprio	**
******************************************************
gen trab_nremun = .
gen trab_cprop = .
gen trab_volun = .
gen trab_domes = .

if visita == 5 {
	replace trab_nremun = 1 if V40121 ==1  // Em ajuda a conta própria ou empregador	
	replace trab_nremun = 1 if V40121 ==2  // Em ajuda a empregado 
	replace trab_nremun = 1 if V40121 ==3  // Em ajuda a trabalhador doméstico
	
	replace trab_cprop = 1 if V4099 ==1  // exerceu atividades em cultivo, pesca, caça ou criação de animais destinadas somente à alimentação das pessoas moradoras do domicílio ou de parente?
	replace trab_cprop = 1 if V4102 ==1  // exerceu atividades na produção de carvão, corte ou coleta de lenha, coleta de água, extração de sementes, de ervas, de areia, argila ou outro material destinado somente ao próprio uso das pessoas moradoras do domicílio ou de parente?
	replace trab_cprop = 1 if V4105 ==1  // exerceu atividades na fabricação de roupas, tricô, crochê, bordado, cerâmicas, rede de pesca, alimentos ou bebidas alcóolicas, produtos medicinais ou outros produtos destinados somente ao próprio uso das pessoas do domicílio ou de parente?
	replace trab_cprop = 1 if V4108 ==1  // exerceu atividades de construção casa, cômodo, muro, telhado, forno ou churrasqueira, cerca, estrada, abrigo para animais ou outras obras destinadas somente ao próprio uso das pessoas moradoras do domicílio ou de parente?
	
	replace trab_volun = 1 if V4111 ==1  // trabalhou, durante pelo menos uma hora, voluntariamente e sem remuneração?
	
	replace trab_domes = 1 if V4120 ==1  // fez tarefas domésticas para o próprio domicílio?
}

**************************************************************
**	Trabalhador infantil (pessoas de 5 a 13 anos de idade)	**
**************************************************************
gen infantil =.
gen infantil_trab = .

if visita == 5 & Ano == 2016 {
	replace infantil = 1 if S06001 ~=.  // Características de trabalho das pessoas de 5 a 13 anos de idade
	replace infantil_trab = 1 if S06001 ==1  // trabalhou, durante pelo menos 1 hora, em alguma atividade remunerada em dinheiro?
	replace infantil_trab = 1 if S06002 ==1  // trabalhou,  durante pelo menos 1 hora, em alguma atividade remunerada em produtos, mercadorias, moradia, alimentação etc.?
	replace infantil_trab = 1 if S06003 ==1  // Fez algum bico pelo menos de 1 hr
	replace infantil_trab = 1 if S06004 ==1  // Ajudou sem receber no domic. 1 hr
	replace infantil_trab = 1 if S06005 ==1  // tinha algum trabalho remunerado do qual estava temporariamente afastado por motivo de férias, folga, doença, acidente, más condições de tempo etc.?
}

**************************************
**	Editar variável trimestre 		**
** 									**
**	É útil ter valores contínuos 	**
**************************************
 
* generate variable of quartely date
	tostring Ano, gen(iten1)
	tostring Trimestre, gen(iten2)
	gen iten3 = iten1 + "." + iten2
	gen  trim = quarterly(iten3, "YQ")
	cap drop iten*
	cap drop tool*