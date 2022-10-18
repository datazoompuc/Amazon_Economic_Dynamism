//////////////////////////////////////////////
//	
//	Descricao de codigos de ocupacao (agregado)
//	
//////////////////////////////////////////////

* call data Ocupacao_COD
import excel "$input_pnadcdoc\Estrutura_Ocupacao_COD.xls", sheet("Estrutura COD") cellrange(A3:E617) firstrow clear

* clean data
cap gen titulo = Denominação 

* take out accents and double space
gen normalized_string = ustrto(ustrnormalize(titulo, "nfd"), "ascii", 2)
replace titulo = normalized_string
drop normalized_string

replace titulo = lower(titulo)
replace titulo = proper(titulo)
cap gen cod_codagr = Subgrupoprincipal
cap tostring cod_codagr, replace
keep if cod_codagr !=""
sort cod_codagr
keep cod_codagr titulo


gen new_name = ""
destring cod_codagr, gen(codnumeric)

replace new_name  = "Policiais, bombeiros e forças armadas" if codnumeric == 1
replace new_name  = "Policiais, bombeiros e forças armadas" if codnumeric == 2
replace new_name  = "Policiais, bombeiros e forças armadas" if codnumeric == 4
replace new_name  = "Policiais, bombeiros e forças armadas" if codnumeric == 5
replace new_name  = "Trabalhadores no governo" if codnumeric == 11
replace new_name  = "Dirigentes e gerentes" if codnumeric == 12
replace new_name  = "Dirigentes e gerentes" if codnumeric == 13
replace new_name  = "Dirigentes e gerentes" if codnumeric == 14
replace new_name  = "Cientistas e engenheiros" if codnumeric == 21
replace new_name  = "Profissionais da saúde" if codnumeric == 22
replace new_name  = "Profissionais do ensino" if codnumeric == 23
replace new_name  = "Administradores e especialista em gestão" if codnumeric == 24
replace new_name  = "Serviços de TI e comunicação" if codnumeric == 25
replace new_name  = "Serviços sociais e culturais" if codnumeric == 26
replace new_name  = "Cientistas e engenheiros" if codnumeric == 31
replace new_name  = "Profissionais da saúde" if codnumeric == 32
replace new_name  = "Serviços financeiros e administrativos" if codnumeric == 33
replace new_name  = "Serviços sociais e culturais" if codnumeric == 34
replace new_name  = "Serviços de TI e comunicação" if codnumeric == 35
replace new_name  = "Escriturários" if codnumeric == 41
replace new_name  = "Atendimento direto ao público" if codnumeric == 42
replace new_name  = "Apoio administrativo" if codnumeric == 43
replace new_name  = "Apoio administrativo" if codnumeric == 44
replace new_name  = "Serviços e cuidados pessoais" if codnumeric == 51
replace new_name  = "Vendedores" if codnumeric == 52
replace new_name  = "Serviços e cuidados pessoais" if codnumeric == 53
replace new_name  = "Profissionais de segurança" if codnumeric == 54
replace new_name  = "Agricultores qualificados" if codnumeric == 61
replace new_name  = "Extrativistas florestais" if codnumeric == 62
replace new_name  = "Operários da construção, metalurgia e indústria" if codnumeric == 71
replace new_name  = "Operários da construção, metalurgia e indústria" if codnumeric == 72
replace new_name  = "Artesões e artes gráficas" if codnumeric == 73
replace new_name  = "Técnicos de eletricidade e eletrônica" if codnumeric == 74
replace new_name  = "Operários de processamento e instalações" if codnumeric == 75
replace new_name  = "Operários de processamento e instalações" if codnumeric == 81
replace new_name  = "Montadores e condutores de veículos" if codnumeric == 82
replace new_name  = "Montadores e condutores de veículos" if codnumeric == 83
replace new_name  = "Domésticos" if codnumeric == 91
replace new_name  = "Agricultores elementares" if codnumeric == 92
replace new_name  = "Operários da construção, metalurgia e indústria" if codnumeric == 93
replace new_name  = "Profissionais em alimentação" if codnumeric == 94
replace new_name  = "Ambulantes" if codnumeric == 95
replace new_name  = "Coletores de lixo" if codnumeric == 96

* keep only relevant variables
replace titulo = new_name
cap drop cod_cod2dig
gen  cod_cod2dig = cod_codagr
sort cod_codagr titulo cod_cod2dig
keep cod_codagr titulo cod_cod2dig

* save in the output directory
compress
save "$output_dir\cod_cod2dig.dta", replace