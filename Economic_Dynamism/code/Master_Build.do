* Francisco Cavalcanti
* Website: https://sites.google.com/view/franciscocavalcanti/
* GitHub: https://github.com/FranciscoCavalcanti
* Twitter: https://twitter.com/Franciscolc85
* LinkedIn: https://www.linkedin.com/in/francisco-de-lima-cavalcanti-5497b027/

/*
O propostio desse do file é:
limpar os dados brutos da PNAD Contínua Trimestral e Anual
*/

* Stata version
cap version 16.1 //always set the stata version being used
set more off, perm

// caminhos (check your username by typing "di c(username)" in Stata) ----
if "`c(username)'" == "Francisco"   {
    global ROOT "C:\Users\Francisco\Dropbox\DataZoom"
    global DATABASE "C:\Users\Francisco\Dropbox\DataZoom"
}
else if "`c(username)'" == "titobruni"   {
    global ROOT "C:\Users\titobruni\Documents\GitHub"
    global DATABASE "G:\.shortcut-targets-by-id\1bg4JQuS8YDz3Afj1yP6CEOlTI49w7zyY\Data Zoom\Bases\datazoom_rar\PNAD_CONTINUA"
}	
else if "`c(username)'" == "f.cavalcanti"   {
    global ROOT "C:\Users\f.cavalcanti\Documents"
    global DATABASE "G:\Meu Drive\Data Zoom\Bases\datazoom_rar\PNAD_CONTINUA"
}	

global input_advanc     "${DATABASE}\pnadcontinua_trimestral_2022024\Stata\pnadcontinua"
global input_pnadanual	"${DATABASE}\pnadcontinua_anual_20191016\Stata"      
global input_pnadcdoc	"${DATABASE}\pnadcontinua_trimestral_2022024\Documentacao"      
global tmp_dir			"${ROOT}\datazoom_labour_amazon\Economic_Dynamism\tmp"   
global code_dir			"${ROOT}\datazoom_labour_amazon\Economic_Dynamism\code"   
global output_dir		"${ROOT}\datazoom_labour_amazon\Economic_Dynamism\output"   
global input_dir		"${ROOT}\datazoom_labour_amazon\Economic_Dynamism\input"   

//////////////////////////////////////////////
//	
//	Gerar deflator
//	
//////////////////////////////////////////////
clear
do "$code_dir\_deflator_pnad_continua"

//////////////////////////////////////////////
//	
//	Descricao de codigos de atividades (agregado)
//	
//////////////////////////////////////////////
* run code
clear 
do "$code_dir\_cod_cnae2dig"


//////////////////////////////////////////////
//	
//	Descricao de codigos de ocupacao (agregado)
//	
//////////////////////////////////////////////
* run code
clear 
do "$code_dir\_cod_cod2dig"


//////////////////////////////////////////////
//	
//	Dinamismo Econômico na Amazonia Legal
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_legal"
clear


//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Maranhao
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_ma"
clear


//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Mato Grosso
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_mt"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Pará
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_pa"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Acre
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_ac"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Amazonas
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_am"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Amapa
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_ap"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Roraima
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_rr"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Rondonia
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_ro"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico no Tocantins
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_to"
clear

//////////////////////////////////////////////
//	
//	Dinamismo Econômico Brasil (exceto Amazônia Legal)
//	
//////////////////////////////////////////////
* run code
clear
do "$code_dir\_amz_resto"
clear

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
