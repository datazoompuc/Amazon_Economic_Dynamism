/*
O propostio desse do file é:
limpar os dados brutos da PNAD Contínua Trimestral e Anual
para posteriormente analisar a estrutura do mercado de tabalho 
e comparar a Amazônia Legal com o resto do Brasil.

A análise está dividida da seguinte forma:
1) Descrever a estrutrura do emprego
*/

* Stata version
version 14.2 //always set the stata version being used
set more off, perm

// caminhos (check your username by typing "di c(username)" in Stata) ----
if "`c(username)'" == "Francisco"   {
    global ROOT "C:\Users\Francisco\Dropbox"
	global RAIZ "C:\Users\Francisco\Dropbox"	
}
else if "`c(username)'" == "f.cavalcanti"   {
    global ROOT "C:\Users\f.cavalcanti\Documents"
    global DATABASE "G:\Meu Drive"
}
else if "`c(username)'" == "titobruni"   {
    global ROOT "C:\Users\titobruni\Documents\GitHub"
    global DATABASE "G:\.shortcut-targets-by-id\1bg4JQuS8YDz3Afj1yP6CEOlTI49w7zyY"
}	

global input_basiic		"${DATABASE}\DataZoom\Bases\datazoom_rar\PNAD_CONTINUA\pnadcontinua_trimestral_20190729\pnad_painel\basico"  
global input_advanc     "${DATABASE}\Data Zoom\Bases\datazoom_rar\PNAD_CONTINUA\pnadcontinua_trimestral_2022024\Stata\pnadcontinua"
global input_pnadanual	"${DATABASE}\DataZoom\Bases\datazoom_rar\PNAD_CONTINUA\pnadcontinua_anual_20191016\Stata"      
global tmp_dir			"${ROOT}\datazoom_labour_amazon\Labour_Market\tmp"   
global code_dir			"${ROOT}\datazoom_labour_amazon\Labour_Market\code"   
global output_dir		"${ROOT}\datazoom_labour_amazon\Labour_Market\output"   
global input_dir		"${ROOT}\datazoom_labour_amazon\Economic_Dynamism\output"  

cap mkdir $tmp_dir

* set more off 
set more off, perm


//////////////////////////////////////////////
//	
//	Retrato do Emprego
//	
//////////////////////////////////////////////
**********************
**	Amazônia Legal	**
**********************

global area_geografica = "Amazônia Legal"

forvalues yr = 2019(1)2019{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_retrato_emprego"
	* save as temporary
	save "$tmp_dir\_temp_retrato_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2019(1)2019 {
	* call data
	append using "$tmp_dir\_temp_retrato_emprego_PNADC`yr'.dta"
}

* save in the output directory
save "$output_dir\_retrato_emprego_amazonia_legal.dta", replace
export excel using "$output_dir\_retrato_emprego_amazonia_legal.xls", /*
	*/	firstrow(varlabels) replace

**********************
**	Resto do Brasil	**
**********************

global area_geografica = "Resto do Brasil"

forvalues yr = 2019(1)2019 {
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_retrato_emprego"
	* save as temporary
	save "$tmp_dir\_temp_retrato_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2019(1)2019 {
	* call data
	append using "$tmp_dir\_temp_retrato_emprego_PNADC`yr'.dta"
}

* save in the output directory
save "$output_dir\_retrato_emprego_resto_brasil.dta", replace
export excel using "$output_dir\_retrato_emprego_resto_brasil.xls", /*
	*/	firstrow(varlabels) replace
	
//////////////////////////////////////////////
//	
//	1) Descrever a estrutrura do emprego
//	
//////////////////////////////////////////////

**********************
**	Amazônia Legal	**
**********************

global area_geografica = "Amazônia Legal"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

cap gen idin = "amazonia_legal"

* save in the output directory
save "$output_dir\_estrutura_emprego_amazonia_legal.dta", replace

**********************
**	Resto do Brasil	**
**********************

global area_geografica = "Resto do Brasil"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

cap gen idin = "resto_brasil"

* save in the output directory
save "$output_dir\_estrutura_emprego_resto_brasil.dta", replace

**********************
**	Rondônia	**
**********************

global area_geografica = "Rondônia"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

*
cap gen idin = "rondonia"

* save in the output directory
save "$output_dir\_estrutura_emprego_rondonia.dta", replace	

**********************
**	Acre	**
**********************

global area_geografica = "Acre"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

*
cap gen idin = "acre"

* save in the output directory
save "$output_dir\_estrutura_emprego_acre.dta", replace


**********************
**	Amazonas	**
**********************

global area_geografica = "Amazonas"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

*
cap gen idin = "amazonas"

* save in the output directory
save "$output_dir\_estrutura_emprego_amazonas.dta", replace

**********************
**	Roraima	**
**********************

global area_geografica = "Roraima"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

*
cap gen idin = "roraima"

* save in the output directory
save "$output_dir\_estrutura_emprego_roraima.dta", replace

**********************
**	Pará	**
**********************

global area_geografica = "Pará"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

*
cap gen idin = "para"

* save in the output directory
save "$output_dir\_estrutura_emprego_para.dta", replace

**********************
**	Amapá	**
**********************

global area_geografica = "Amapá"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

*
cap gen idin = "amapa"

* save in the output directory
save "$output_dir\_estrutura_emprego_amapa.dta", replace

**********************
**	Tocantins	**
**********************

global area_geografica = "Tocantins"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

*
cap gen idin = "tocantins"

* save in the output directory
save "$output_dir\_estrutura_emprego_tocantins.dta", replace

**********************
**	Mato Grosso	**
**********************

global area_geografica = "Mato Grosso"

forvalues yr = 2012(1)2022{
	* call data
	use "$input_advanc\PNADC`yr'.dta", clear
	*sample 1
	* run code
	do "$code_dir\_estrutura_emprego"
	* save as temporary
	save "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta", replace
}

* append temporary data base
clear
forvalues yr = 2012(1)2022{
	* call data
	append using "$tmp_dir\_temp_estrutura_emprego_PNADC`yr'.dta"
}

*
cap gen idin = "matogrosso"

* save in the output directory
save "$output_dir\_estrutura_emprego_matogrosso.dta", replace


******************************************
** delete temporary files
******************************************

cd  "${tmp_dir}/"
local datafiles: dir "${tmp_dir}/" files "*.dta"
foreach datafile of local datafiles {
        rm `datafile'
}

cd  "${tmp_dir}/"
local datafiles: dir "${tmp_dir}/" files "*.csv"
foreach datafile of local datafiles {
        rm `datafile'
}

cd  "${tmp_dir}/"
local datafiles: dir "${tmp_dir}/" files "*.txt"
foreach datafile of local datafiles {
        rm "`datafile'"
}


cd  "${tmp_dir}/"
local datafiles: dir "${tmp_dir}/" files "*.pdf"
foreach datafile of local datafiles {
        rm `datafile'
}
