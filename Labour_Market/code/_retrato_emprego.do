/*
O propostio desse do file é:
Descrever a composição e estrutura do emprego em uma fotografia

Mais especificamente:
A) Quantos trabalhadores há?
B) Quantos trabalhadores há em cada setor?
C) Quantos trabalhadores formais e informais?
D) Quantos trabalhadores informais há em cada setor?
E) Quantos trabalhadores formais há em cada setor?
E) Quantos trabalhadores estatutarios entre os formais?
*/

**********************
**	 Definitions	**
**********************

do "$code_dir\_definicoes_pnadcontinua_trimestral"

* select just a small sample for training data
cap drop __*
cap drop iten*
*sample 1

/////////////////////////////////////////////////////////
//	A) População
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 // população total
by Ano Trimestre, sort: egen iten2 = total(iten1)
gen n_populacao = iten2
replace n_populacao = round(n_populacao)
label variable n_populacao "População"
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
//	B) Número de ocupados
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1
by Ano Trimestre, sort: egen n_de_ocupacao = total(iten1)
replace n_de_ocupacao = round(n_de_ocupacao)
label variable n_de_ocupacao "Número de ocupados"
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
//	D) Número total de formalidade
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if formal == 1
by Ano Trimestre, sort: egen n_de_formal = total(iten1)
replace n_de_formal = round(n_de_formal)
label variable n_de_formal "Número de trabalhadores formais"
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
//	A) Taxa de desemprego
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if desocupado == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen tool1 = 1 * V1028 if forcatrabalho == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

gen taxa_de_desemprego = (iten2/tool2)*100
label variable taxa_de_desemprego "Taxa de desemprego em relação a força de trabalho (%)"
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
label variable taxa_de_ocupacao "Taxa de ocupação em relação a PIA (%)"
cap drop iten* tool* 

/////////////////////////////////////////////////////////
//	C) Taxa de participação
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if pea == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen tool1 = 1 * V1028 if pia == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

gen taxa_de_participacao = (iten2/tool2)*100
label variable taxa_de_participacao "Taxa de participação em relação a PIA (%)"
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
//	Proporção de militares e estatuarios entre os formais
/////////////////////////////////////////////////////////
* total de formal
gen tool1 = 1 * V1028 if formal == 1
by Ano Trimestre, sort: egen tool2 = total(tool1)

* proporção de militares
gen iten1 = 1 * V1028 if militar == 1
by Ano Trimestre, sort: egen iten2 = total(iten1)

gen prop_servidor_formal = (iten2/tool2)*100
label variable prop_servidor_formal "Proporção servidores públicos e militares em relação aos formais (%)"
cap drop iten*

/////////////////////////////////////////////////////////
//	Número de ocupados por setor
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & gstr_agricultura==1
by Ano Trimestre, sort: egen n_de_ocupado_gstr_agricultura = total(iten1)
replace n_de_ocupado_gstr_agricultura = round(n_de_ocupado_gstr_agricultura)
label variable n_de_ocupado_gstr_agricultura "Número de ocupados no setor de agropecuária"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gstr_industria==1
by Ano Trimestre, sort: egen n_de_ocupado_gstr_industria = total(iten1)
replace n_de_ocupado_gstr_industria = round(n_de_ocupado_gstr_industria)
label variable n_de_ocupado_gstr_industria "Número de ocupados no setor de indústria"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gstr_construcao==1
by Ano Trimestre, sort: egen n_de_ocupado_gstr_construcao = total(iten1)
replace n_de_ocupado_gstr_construcao = round(n_de_ocupado_gstr_construcao)
label variable n_de_ocupado_gstr_construcao "Número de ocupados no setor de construção"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gstr_comercio==1
by Ano Trimestre, sort: egen n_de_ocupado_gstr_comercio = total(iten1)
replace n_de_ocupado_gstr_comercio = round(n_de_ocupado_gstr_comercio)
label variable n_de_ocupado_gstr_comercio "Número de ocupados no setor de comércio"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gstr_servicos==1
by Ano Trimestre, sort: egen n_de_ocupado_gstr_servicos = total(iten1)
replace n_de_ocupado_gstr_servicos = round(n_de_ocupado_gstr_servicos)
label variable n_de_ocupado_gstr_servicos "Número de ocupados no setor de serviços"
cap drop iten*

/////////////////////////////////////////////////////////
//	Número de formal por setor
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if formal == 1 & gstr_agricultura==1
by Ano Trimestre, sort: egen n_de_formal_gstr_agricultura = total(iten1)
replace n_de_formal_gstr_agricultura = round(n_de_formal_gstr_agricultura)
label variable n_de_formal_gstr_agricultura "Número de formal no setor de agropecuária"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gstr_industria==1
by Ano Trimestre, sort: egen n_de_formal_gstr_industria = total(iten1)
replace n_de_formal_gstr_industria = round(n_de_formal_gstr_industria)
label variable n_de_formal_gstr_industria "Número de formal no setor de indústria"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gstr_construcao==1
by Ano Trimestre, sort: egen n_de_formal_gstr_construcao = total(iten1)
replace n_de_formal_gstr_construcao = round(n_de_formal_gstr_construcao)
label variable n_de_formal_gstr_construcao "Número de formal no setor de construção"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gstr_comercio==1
by Ano Trimestre, sort: egen n_de_formal_gstr_comercio = total(iten1)
replace n_de_formal_gstr_comercio = round(n_de_formal_gstr_comercio)
label variable n_de_formal_gstr_comercio "Número de formal no setor de comércio"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gstr_servicos==1
by Ano Trimestre, sort: egen n_de_formal_gstr_servicos= total(iten1)
replace n_de_formal_gstr_servicos = round(n_de_formal_gstr_servicos)
label variable n_de_formal_gstr_servicos "Número de formal no setor de serviços"
cap drop iten*

/////////////////////////////////////////////////////////
//	Número de informal por setor
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if informal == 1 & gstr_agricultura==1
by Ano Trimestre, sort: egen n_de_informal_gstr_agricultura = total(iten1)
replace n_de_informal_gstr_agricultura = round(n_de_informal_gstr_agricultura)
label variable n_de_informal_gstr_agricultura "Número de informais no setor de agropecuária"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gstr_industria==1
by Ano Trimestre, sort: egen n_de_informal_gstr_industria = total(iten1)
replace n_de_informal_gstr_industria = round(n_de_informal_gstr_industria)
label variable n_de_informal_gstr_industria "Número de informais no setor de indústria"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gstr_construcao==1
by Ano Trimestre, sort: egen n_de_informal_gstr_construcao = total(iten1)
replace n_de_informal_gstr_construcao = round(n_de_informal_gstr_construcao)
label variable n_de_informal_gstr_construcao "Número de informais no setor de construção"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gstr_comercio==1
by Ano Trimestre, sort: egen n_de_informal_gstr_comercio = total(iten1)
replace n_de_informal_gstr_comercio = round(n_de_informal_gstr_comercio)
label variable n_de_informal_gstr_comercio "Número de informais no setor de comércio"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gstr_servicos==1
by Ano Trimestre, sort: egen n_de_informal_gstr_servicos = total(iten1)
replace n_de_informal_gstr_servicos = round(n_de_informal_gstr_servicos)
label variable n_de_informal_gstr_servicos "Número de informais no setor de serviços"
cap drop iten*

/////////////////////////////////////////////////////////
//	Número de ocupados por atividade principal do empreendimento do trabalho
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & gape_agricultura==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_agricultura = total(iten1)
replace n_de_ocupado_gape_agricultura = round(n_de_ocupado_gape_agricultura)
label variable n_de_ocupado_gape_agricultura "Agricultura, pecuária, produção florestal, pesca e aquicultura "
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_industria==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_industria = total(iten1)
replace n_de_ocupado_gape_industria = round(n_de_ocupado_gape_industria)
label variable n_de_ocupado_gape_industria "Indústria geral"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_construcao==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_construcao = total(iten1)
replace n_de_ocupado_gape_construcao = round(n_de_ocupado_gape_construcao)
label variable n_de_ocupado_gape_construcao "Construção"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_comercio==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_comercio = total(iten1)
replace n_de_ocupado_gape_comercio = round(n_de_ocupado_gape_comercio)
label variable n_de_ocupado_gape_comercio "Comércio, reparação de veículos automotores e motocicletas"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_transporte==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_transporte = total(iten1)
replace n_de_ocupado_gape_transporte = round(n_de_ocupado_gape_transporte)
label variable n_de_ocupado_gape_transporte "Transporte, armazenagem e correio"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_alimentacao==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_alimentacao = total(iten1)
replace n_de_ocupado_gape_alimentacao = round(n_de_ocupado_gape_alimentacao)
label variable n_de_ocupado_gape_alimentacao "Alojamento e alimentação"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_informacao==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_informacao = total(iten1)
replace n_de_ocupado_gape_informacao = round(n_de_ocupado_gape_informacao)
label variable n_de_ocupado_gape_informacao "Informação, comunicação e atividades financeiras, imobiliárias, profissionais e administrativas"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_publica==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_publica = total(iten1)
replace n_de_ocupado_gape_publica = round(n_de_ocupado_gape_publica)
label variable n_de_ocupado_gape_publica "Administração pública, defesa e seguridade social"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_educacao==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_educacao = total(iten1)
replace n_de_ocupado_gape_educacao = round(n_de_ocupado_gape_educacao)
label variable n_de_ocupado_gape_educacao "Educação, saúde humana e serviços sociais"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_outros ==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_outros  = total(iten1)
replace n_de_ocupado_gape_outros  = round(n_de_ocupado_gape_outros )
label variable n_de_ocupado_gape_outros  "Outros Serviços"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & gape_domestico==1
by Ano Trimestre, sort: egen n_de_ocupado_gape_domestico = total(iten1)
replace n_de_ocupado_gape_domestico = round(n_de_ocupado_gape_domestico)
label variable n_de_ocupado_gape_domestico "Serviços domésticos"
cap drop iten*

/////////////////////////////////////////////////////////
//	Número de formal por atividade principal do empreendimento do trabalho
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if formal == 1 & gape_agricultura==1
by Ano Trimestre, sort: egen n_de_formal_gape_agricultura = total(iten1)
replace n_de_formal_gape_agricultura = round(n_de_formal_gape_agricultura)
label variable n_de_formal_gape_agricultura "Agricultura, pecuária, produção florestal, pesca e aquicultura "
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_industria==1
by Ano Trimestre, sort: egen n_de_formal_gape_industria = total(iten1)
replace n_de_formal_gape_industria = round(n_de_formal_gape_industria)
label variable n_de_formal_gape_industria "Indústria geral"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_construcao==1
by Ano Trimestre, sort: egen n_de_formal_gape_construcao = total(iten1)
replace n_de_formal_gape_construcao = round(n_de_formal_gape_construcao)
label variable n_de_formal_gape_construcao "Construção"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_comercio==1
by Ano Trimestre, sort: egen n_de_formal_gape_comercio = total(iten1)
replace n_de_formal_gape_comercio = round(n_de_formal_gape_comercio)
label variable n_de_formal_gape_comercio "Comércio, reparação de veículos automotores e motocicletas"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_transporte==1
by Ano Trimestre, sort: egen n_de_formal_gape_transporte = total(iten1)
replace n_de_formal_gape_transporte = round(n_de_formal_gape_transporte)
label variable n_de_formal_gape_transporte "Transporte, armazenagem e correio"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_alimentacao==1
by Ano Trimestre, sort: egen n_de_formal_gape_alimentacao = total(iten1)
replace n_de_formal_gape_alimentacao = round(n_de_formal_gape_alimentacao)
label variable n_de_formal_gape_alimentacao "Alojamento e alimentação"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_informacao==1
by Ano Trimestre, sort: egen n_de_formal_gape_informacao = total(iten1)
replace n_de_formal_gape_informacao = round(n_de_formal_gape_informacao)
label variable n_de_formal_gape_informacao "Informação, comunicação e atividades financeiras, imobiliárias, profissionais e administrativas"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_publica==1
by Ano Trimestre, sort: egen n_de_formal_gape_publica = total(iten1)
replace n_de_formal_gape_publica = round(n_de_formal_gape_publica)
label variable n_de_formal_gape_publica "Administração pública, defesa e seguridade social"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_educacao==1
by Ano Trimestre, sort: egen n_de_formal_gape_educacao = total(iten1)
replace n_de_formal_gape_educacao = round(n_de_formal_gape_educacao)
label variable n_de_formal_gape_educacao "Educação, saúde humana e serviços sociais"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_outros ==1
by Ano Trimestre, sort: egen n_de_formal_gape_outros  = total(iten1)
replace n_de_formal_gape_outros  = round(n_de_formal_gape_outros )
label variable n_de_formal_gape_outros  "Outros Serviços"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & gape_domestico==1
by Ano Trimestre, sort: egen n_de_formal_gape_domestico = total(iten1)
replace n_de_formal_gape_domestico = round(n_de_formal_gape_domestico)
label variable n_de_formal_gape_domestico "Serviços domésticos"
cap drop iten*

/////////////////////////////////////////////////////////
//	Número de informal  por atividade principal do empreendimento do trabalho
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if informal == 1 & gape_agricultura==1
by Ano Trimestre, sort: egen n_de_informal_gape_agricultura = total(iten1)
replace n_de_informal_gape_agricultura = round(n_de_informal_gape_agricultura)
label variable n_de_informal_gape_agricultura "Agricultura, pecuária, produção florestal, pesca e aquicultura "
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_industria==1
by Ano Trimestre, sort: egen n_de_informal_gape_industria = total(iten1)
replace n_de_informal_gape_industria = round(n_de_informal_gape_industria)
label variable n_de_informal_gape_industria "Indústria geral"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_construcao==1
by Ano Trimestre, sort: egen n_de_informal_gape_construcao = total(iten1)
replace n_de_informal_gape_construcao = round(n_de_informal_gape_construcao)
label variable n_de_informal_gape_construcao "Construção"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_comercio==1
by Ano Trimestre, sort: egen n_de_informal_gape_comercio = total(iten1)
replace n_de_informal_gape_comercio = round(n_de_informal_gape_comercio)
label variable n_de_informal_gape_comercio "Comércio, reparação de veículos automotores e motocicletas"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_transporte==1
by Ano Trimestre, sort: egen n_de_informal_gape_transporte = total(iten1)
replace n_de_informal_gape_transporte = round(n_de_informal_gape_transporte)
label variable n_de_informal_gape_transporte "Transporte, armazenagem e correio"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_alimentacao==1
by Ano Trimestre, sort: egen n_de_informal_gape_alimentacao = total(iten1)
replace n_de_informal_gape_alimentacao = round(n_de_informal_gape_alimentacao)
label variable n_de_informal_gape_alimentacao "Alojamento e alimentação"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_informacao==1
by Ano Trimestre, sort: egen n_de_informal_gape_informacao = total(iten1)
replace n_de_informal_gape_informacao = round(n_de_informal_gape_informacao)
label variable n_de_informal_gape_informacao "Informação, comunicação e atividades financeiras, imobiliárias, profissionais e administrativas"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_publica==1
by Ano Trimestre, sort: egen n_de_informal_gape_publica = total(iten1)
replace n_de_informal_gape_publica = round(n_de_informal_gape_publica)
label variable n_de_informal_gape_publica "Administração pública, defesa e seguridade social"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_educacao==1
by Ano Trimestre, sort: egen n_de_informal_gape_educacao = total(iten1)
replace n_de_informal_gape_educacao = round(n_de_informal_gape_educacao)
label variable n_de_informal_gape_educacao "Educação, saúde humana e serviços sociais"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_outros ==1
by Ano Trimestre, sort: egen n_de_informal_gape_outros  = total(iten1)
replace n_de_informal_gape_outros  = round(n_de_informal_gape_outros )
label variable n_de_informal_gape_outros  "Outros Serviços"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & gape_domestico==1
by Ano Trimestre, sort: egen n_de_informal_gape_domestico = total(iten1)
replace n_de_informal_gape_domestico = round(n_de_informal_gape_domestico)
label variable n_de_informal_gape_domestico "Serviços domésticos"
cap drop iten*

/////////////////////////////////////////////////////////
//	SUB-CATEGORIAS DE AGRICULTURA E INDUSTRIA
/////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
//	Número de ocupados por setor
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & sgap_agricultura==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_agricultura = total(iten1)
replace n_de_ocupado_sgap_agricultura = round(n_de_ocupado_sgap_agricultura)
label variable n_de_ocupado_sgap_agricultura "Número de ocupados no setor de agricultura"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_animal==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_animal = total(iten1)
replace n_de_ocupado_sgap_animal = round(n_de_ocupado_sgap_animal)
label variable n_de_ocupado_sgap_animal "Número de ocupados no setor de agropecuária"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_florestal==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_florestal = total(iten1)
replace n_de_ocupado_sgap_florestal = round(n_de_ocupado_sgap_florestal)
label variable n_de_ocupado_sgap_florestal "Número de ocupados no setor de produção florestal"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_extrativa==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_extrativa = total(iten1)
replace n_de_ocupado_sgap_extrativa = round(n_de_ocupado_sgap_extrativa)
label variable n_de_ocupado_sgap_extrativa "Número de ocupados na indústria extrativa"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_trans==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_trans = total(iten1)
replace n_de_ocupado_sgap_trans = round(n_de_ocupado_sgap_trans)
label variable n_de_ocupado_sgap_trans "Número de ocupados na indústria de transformação"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_energia==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_energia = total(iten1)
replace n_de_ocupado_sgap_energia = round(n_de_ocupado_sgap_energia)
label variable n_de_ocupado_sgap_energia "Número de ocupados no setor de eletricidade e gás"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_agua==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_agua = total(iten1)
replace n_de_ocupado_sgap_agua = round(n_de_ocupado_sgap_agua)
label variable n_de_ocupado_sgap_agua "Número de ocupados no setor de água"
cap drop iten*


/////////////////////////////////////////////////////////
//	Número de formal por setor
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if formal == 1 & sgap_agricultura==1
by Ano Trimestre, sort: egen n_de_formal_sgap_agricultura = total(iten1)
replace n_de_formal_sgap_agricultura = round(n_de_formal_sgap_agricultura)
label variable n_de_formal_sgap_agricultura "Número de formal no setor de agricultura"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_animal==1
by Ano Trimestre, sort: egen n_de_formal_sgap_animal = total(iten1)
replace n_de_formal_sgap_animal = round(n_de_formal_sgap_animal)
label variable n_de_formal_sgap_animal "Número de formal no setor de agropecuária"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_florestal==1
by Ano Trimestre, sort: egen n_de_formal_sgap_florestal = total(iten1)
replace n_de_formal_sgap_florestal = round(n_de_formal_sgap_florestal)
label variable n_de_formal_sgap_florestal "Número de formal no setor de produção florestal"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_extrativa==1
by Ano Trimestre, sort: egen n_de_formal_sgap_extrativa = total(iten1)
replace n_de_formal_sgap_extrativa = round(n_de_formal_sgap_extrativa)
label variable n_de_formal_sgap_extrativa "Número de formal na indústria extrativa"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_trans==1
by Ano Trimestre, sort: egen n_de_formal_sgap_trans= total(iten1)
replace n_de_formal_sgap_trans = round(n_de_formal_sgap_trans)
label variable n_de_formal_sgap_trans "Número de formal na indústria de transformação"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_energia==1
by Ano Trimestre, sort: egen n_de_formal_sgap_energia = total(iten1)
replace n_de_formal_sgap_energia = round(n_de_formal_sgap_energia)
label variable n_de_formal_sgap_energia "Número de formal no setor de eletricidade e gás"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_agua==1
by Ano Trimestre, sort: egen n_de_formal_sgap_agua = total(iten1)
replace n_de_formal_sgap_agua = round(n_de_formal_sgap_agua)
label variable n_de_formal_sgap_agua "Número de formal no setor de água"
cap drop iten*

/////////////////////////////////////////////////////////
//	Número de informal por setor
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if informal == 1 & sgap_agricultura==1
by Ano Trimestre, sort: egen n_de_informal_sgap_agricultura = total(iten1)
replace n_de_informal_sgap_agricultura = round(n_de_informal_sgap_agricultura)
label variable n_de_informal_sgap_agricultura "Número de informais no setor de agricultura"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_animal==1
by Ano Trimestre, sort: egen n_de_informal_sgap_animal = total(iten1)
replace n_de_informal_sgap_animal = round(n_de_informal_sgap_animal)
label variable n_de_informal_sgap_animal "Número de informais no setor de agropecuária"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_florestal==1
by Ano Trimestre, sort: egen n_de_informal_sgap_florestal = total(iten1)
replace n_de_informal_sgap_florestal = round(n_de_informal_sgap_florestal)
label variable n_de_informal_sgap_florestal "Número de informais no setor de produção florestal"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_extrativa==1
by Ano Trimestre, sort: egen n_de_informal_sgap_extrativa = total(iten1)
replace n_de_informal_sgap_extrativa = round(n_de_informal_sgap_extrativa)
label variable n_de_informal_sgap_extrativa "Número de informais na indústria extrativa"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_trans==1
by Ano Trimestre, sort: egen n_de_informal_sgap_trans = total(iten1)
replace n_de_informal_sgap_trans = round(n_de_informal_sgap_trans)
label variable n_de_informal_sgap_trans "Número de informais na indústria de transformação"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_energia==1
by Ano Trimestre, sort: egen n_de_informal_sgap_energia = total(iten1)
replace n_de_informal_sgap_energia = round(n_de_informal_sgap_energia)
label variable n_de_informal_sgap_energia "Número de informais no setor de eletricidade e gás"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_agua==1
by Ano Trimestre, sort: egen n_de_informal_sgap_agua = total(iten1)
replace n_de_informal_sgap_agua = round(n_de_informal_sgap_agua)
label variable n_de_informal_sgap_agua "Número de informais no setor de água"
cap drop iten*

/////////////////////////////////////////////////////////
//	SUB-CATEGORIAS INDUSTRIA DE TRANFORMAÇÃO
/////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
//	Número de ocupados por setor
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if ocupado == 1 & sgap_trans01==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_trans01 = total(iten1)
replace n_de_ocupado_sgap_trans01 = round(n_de_ocupado_sgap_trans01)
label variable n_de_ocupado_sgap_trans01 "Número de ocupados em fabricação de produtos alimentícios"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_trans02==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_trans02 = total(iten1)
replace n_de_ocupado_sgap_trans02 = round(n_de_ocupado_sgap_trans02)
label variable n_de_ocupado_sgap_trans02 "Número de ocupados em fabricação de produtos têxteis"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_trans03==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_trans03 = total(iten1)
replace n_de_ocupado_sgap_trans03 = round(n_de_ocupado_sgap_trans03)
label variable n_de_ocupado_sgap_trans03 "Número de ocupados em fabricação de produtos de madeira"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_trans04==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_trans04 = total(iten1)
replace n_de_ocupado_sgap_trans04 = round(n_de_ocupado_sgap_trans04)
label variable n_de_ocupado_sgap_trans04 "Número de ocupados em fabricação de produtos químicos"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_trans05==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_trans05 = total(iten1)
replace n_de_ocupado_sgap_trans05 = round(n_de_ocupado_sgap_trans05)
label variable n_de_ocupado_sgap_trans05 "Número de ocupados em fabricação de produtos minerais"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_trans06==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_trans06 = total(iten1)
replace n_de_ocupado_sgap_trans06 = round(n_de_ocupado_sgap_trans06)
label variable n_de_ocupado_sgap_trans06 "Número de ocupados em fabricação de máquinas"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_trans07==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_trans07 = total(iten1)
replace n_de_ocupado_sgap_trans07 = round(n_de_ocupado_sgap_trans07)
label variable n_de_ocupado_sgap_trans07 "Número de ocupados em fabricação de equipamentos de transporte"
cap drop iten*

gen iten1 = 1 * V1028 if ocupado == 1 & sgap_trans08==1
by Ano Trimestre, sort: egen n_de_ocupado_sgap_trans08 = total(iten1)
replace n_de_ocupado_sgap_trans08 = round(n_de_ocupado_sgap_trans08)
label variable n_de_ocupado_sgap_trans08 "Número de ocupados em outros"
cap drop iten*

/////////////////////////////////////////////////////////
//	Número de formal por setor
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if formal == 1 & sgap_trans01==1
by Ano Trimestre, sort: egen n_de_formal_sgap_trans01 = total(iten1)
replace n_de_formal_sgap_trans01 = round(n_de_formal_sgap_trans01)
label variable n_de_formal_sgap_trans01 "Número de formal em fabricação de produtos alimentícios"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_trans02==1
by Ano Trimestre, sort: egen n_de_formal_sgap_trans02 = total(iten1)
replace n_de_formal_sgap_trans02 = round(n_de_formal_sgap_trans02)
label variable n_de_formal_sgap_trans02 "Número de formal em fabricação de produtos têxteis"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_trans03==1
by Ano Trimestre, sort: egen n_de_formal_sgap_trans03 = total(iten1)
replace n_de_formal_sgap_trans03 = round(n_de_formal_sgap_trans03)
label variable n_de_formal_sgap_trans03 "Número de formal em fabricação de produtos de madeira"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_trans04==1
by Ano Trimestre, sort: egen n_de_formal_sgap_trans04 = total(iten1)
replace n_de_formal_sgap_trans04 = round(n_de_formal_sgap_trans04)
label variable n_de_formal_sgap_trans04 "Número de formal em fabricação de produtos químicos"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_trans05==1
by Ano Trimestre, sort: egen n_de_formal_sgap_trans05 = total(iten1)
replace n_de_formal_sgap_trans05 = round(n_de_formal_sgap_trans05)
label variable n_de_formal_sgap_trans05 "Número de formal em fabricação de produtos minerais"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_trans06==1
by Ano Trimestre, sort: egen n_de_formal_sgap_trans06 = total(iten1)
replace n_de_formal_sgap_trans06 = round(n_de_formal_sgap_trans06)
label variable n_de_formal_sgap_trans06 "Número de formal em fabricação de máquinas"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_trans07==1
by Ano Trimestre, sort: egen n_de_formal_sgap_trans07 = total(iten1)
replace n_de_formal_sgap_trans07 = round(n_de_formal_sgap_trans07)
label variable n_de_formal_sgap_trans07 "Número de formal em fabricação de equipamentos de transporte"
cap drop iten*

gen iten1 = 1 * V1028 if formal == 1 & sgap_trans08==1
by Ano Trimestre, sort: egen n_de_formal_sgap_trans08 = total(iten1)
replace n_de_formal_sgap_trans08 = round(n_de_formal_sgap_trans08)
label variable n_de_formal_sgap_trans08 "Número de formal em outros"
cap drop iten*

/////////////////////////////////////////////////////////
//	Número de informal por setor
/////////////////////////////////////////////////////////
gen iten1 = 1 * V1028 if informal == 1 & sgap_trans01==1
by Ano Trimestre, sort: egen n_de_informal_sgap_trans01 = total(iten1)
replace n_de_informal_sgap_trans01 = round(n_de_informal_sgap_trans01)
label variable n_de_informal_sgap_trans01 "Número de informais em fabricação de produtos alimentícios"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_trans02==1
by Ano Trimestre, sort: egen n_de_informal_sgap_trans02 = total(iten1)
replace n_de_informal_sgap_trans02 = round(n_de_informal_sgap_trans02)
label variable n_de_informal_sgap_trans02 "Número de informais em fabricação de produtos têxteis"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_trans03==1
by Ano Trimestre, sort: egen n_de_informal_sgap_trans03 = total(iten1)
replace n_de_informal_sgap_trans03 = round(n_de_informal_sgap_trans03)
label variable n_de_informal_sgap_trans03 "Número de informais em fabricação de produtos de madeira"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_trans04==1
by Ano Trimestre, sort: egen n_de_informal_sgap_trans04 = total(iten1)
replace n_de_informal_sgap_trans04 = round(n_de_informal_sgap_trans04)
label variable n_de_informal_sgap_trans04 "Número de informais em fabricação de produtos químicos"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_trans05==1
by Ano Trimestre, sort: egen n_de_informal_sgap_trans05 = total(iten1)
replace n_de_informal_sgap_trans05 = round(n_de_informal_sgap_trans05)
label variable n_de_informal_sgap_trans05 "Número de informais em fabricação de produtos minerais"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_trans06==1
by Ano Trimestre, sort: egen n_de_informal_sgap_trans06 = total(iten1)
replace n_de_informal_sgap_trans06 = round(n_de_informal_sgap_trans06)
label variable n_de_informal_sgap_trans06 "Número de informais em fabricação de máquinas"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_trans07==1
by Ano Trimestre, sort: egen n_de_informal_sgap_trans07 = total(iten1)
replace n_de_informal_sgap_trans07 = round(n_de_informal_sgap_trans07)
label variable n_de_informal_sgap_trans07 "Número de informais em fabricação de equipamentos de transporte"
cap drop iten*

gen iten1 = 1 * V1028 if informal == 1 & sgap_trans08==1
by Ano Trimestre, sort: egen n_de_informal_sgap_trans08 = total(iten1)
replace n_de_informal_sgap_trans08 = round(n_de_informal_sgap_trans08)
label variable n_de_informal_sgap_trans08 "Número de informais em outros"
cap drop iten*

/////////////////////////////////////////////////////////
//	E) Inserção no mercado de trabalho por tipo ocupação
/////////////////////////////////////////////////////////

* Número de trabalhador com carteira assinada
gen iten1 = 1 * V1028 if empregadoCC == 1
by Ano Trimestre, sort: egen n_empregadoCC = total(iten1)
replace n_empregadoCC = round(n_empregadoCC)
label variable n_empregadoCC "Trabalhadores com carteira"
cap drop iten*

* Número de trabalhador sem carteira assinada
gen iten1 = 1 * V1028 if empregadoSC == 1
by Ano Trimestre, sort: egen n_empregadoSC = total(iten1)
replace n_empregadoSC = round(n_empregadoSC)
label variable n_empregadoSC "Trabalhadores sem carteira"
cap drop iten*

* Número de empregadores
gen iten1 = 1 * V1028 if empregador == 1
by Ano Trimestre, sort: egen n_empregador = total(iten1)
replace n_empregador = round(n_empregador)
label variable n_empregador "Empregadores"
cap drop iten*

* Número de trabalhadores por conta-própria
gen iten1 = 1 * V1028 if cpropria == 1
by Ano Trimestre, sort: egen n_cpropria = total(iten1)
replace n_cpropria = round(n_cpropria)
label variable n_cpropria "Trabalhadores por conta própria"
cap drop iten*

* Número de trabalhadores por conta-própria que contribui
gen iten1 = 1 * V1028 if cpropriaC == 1
by Ano Trimestre, sort: egen n_cpropriaC = total(iten1)
replace n_cpropriaC = round(n_cpropriaC)
label variable n_cpropriaC "Conta própria que contribui"
cap drop iten*

* Número de trabalhadores por conta-própria que não contribui
gen iten1 = 1 * V1028 if cpropriaNc == 1
by Ano Trimestre, sort: egen n_cpropriaNc = total(iten1)
replace n_cpropriaNc = round(n_cpropriaNc)
label variable n_cpropriaNc "Conta própria que não contribui"
cap drop iten*

* Número de militares
gen iten1 = 1 * V1028 if militar == 1
by Ano Trimestre, sort: egen n_militar = total(iten1)
replace n_militar = round(n_militar)
label variable n_militar "Servidores públicos e militares"
cap drop iten*

* Número de trabalhadores em casa
gen iten1 = 1 * V1028 if homeoffice == 1
by Ano Trimestre, sort: egen n_homeoffice = total(iten1)
replace n_homeoffice = round(n_homeoffice)
label variable n_homeoffice "Trabalhadores em casa"
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

