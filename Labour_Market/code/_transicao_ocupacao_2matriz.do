/*
O propostio desse do file é:
Descrever a matriz de transições de posição na ocupação para cada trimestre

Referência está nas Tabelas 6 e 7 do trabalho:
Sobre o painel da Pesquisa Mensal de Emprego (PME) do IBGE
Ribas, Rafael Perez and Soares, Sergei Suarez Dillon
2008
*/

* collapse everything
collapse (sum) n_*

* Definitions regarding the position of the indiviual in PREVIOUS period
* Vertical axis in the Table 6 (Ribas Soares, 2008)
* tem_var_y
local tem_var_y inativa desempregado formal informal empregadoSC empregadoCC cpropria cpropriaC cpropriaNc empregador militar desalento nemnem

* Definitions regarding the position of the indiviual in ACTUAL period
* Horizontal axis in the Table 6 (Ribas Soares, 2008)
* tem_var_x
local tem_var_x inativa desempregado formal informal empregadoSC empregadoCC cpropria cpropriaC cpropriaNc empregador militar desalento nemnem

* compute the share of tem_var_y that are tem_var_x in the next quarter
foreach yy in `tem_var_y' {	
foreach xx in `tem_var_x' {	
	gen sh_`yy'_sh_`xx' = ((n_`yy'_n_`xx') / (n_`yy'))*100
	label variable sh_`yy'_sh_`xx' /* 	
	*/ 	"Risco de transição entre `yy' para `xx' (%)"	
	
}	
}

* label variables
* cap label variables
cap label variable sh_empregadoSC_sh_inativa "Transição de empregados sem carteira para inativos (%)"	
cap label variable sh_empregadoSC_sh_formal "Transição de empregados sem carteira para formal (%)"	
cap label variable sh_empregadoSC_sh_informal "Transição de empregados sem carteira para informal (%)"	
cap label variable sh_empregadoSC_sh_desempregado "Transição de empregados sem carteira para desempregados (%)"
cap label variable sh_empregadoSC_sh_empregadoSC "Transição de empregados sem carteira para empregados sem carteira (%)"
cap label variable sh_empregadoSC_sh_empregadoCC "Transição de empregados sem carteira para empregados com carteira (%)"
cap label variable sh_empregadoSC_sh_cpropria "Transição de empregados sem carteira para conta própria (%)"
cap label variable sh_empregadoSC_sh_empregador "Transição de empregados sem carteira para empregadores (%)"
cap label variable sh_empregadoSC_sh_militar "Transição de empregados sem carteira para servidores públicos (%)"
cap label variable sh_empregadoSC_sh_desalento "Transição de empregados sem carteira para desalentados (%)"
cap label variable sh_empregadoSC_sh_nemnem "Transição de empregados sem carteira para nem-nem (%)"
 
cap label variable sh_empregadoCC_sh_inativa "Transição de empregados com carteira para inativos (%)"
cap label variable sh_empregadoCC_sh_formal "Transição de empregados com carteira para formal (%)"	
cap label variable sh_empregadoCC_sh_informal "Transição de empregados com carteira para informal (%)"	
cap label variable sh_empregadoCC_sh_desempregado "Transição de empregados com carteira para desempregados (%)"
cap label variable sh_empregadoCC_sh_empregadoSC "Transição de empregados com carteira para empregados sem carteira (%)"
cap label variable sh_empregadoCC_sh_empregadoCC "Transição de empregados com carteira para empregados com carteira (%)"
cap label variable sh_empregadoCC_sh_cpropria "Transição de empregados com carteira para conta própria (%)"
cap label variable sh_empregadoCC_sh_empregador "Transição de empregados com carteira para empregadores (%)"
cap label variable sh_empregadoCC_sh_militar "Transição de empregados com carteira para servidores públicos (%)"
cap label variable sh_empregadoCC_sh_desalento "Transição de empregados com carteira para desalentados (%)"
cap label variable sh_empregadoCC_sh_nemnem "Transição de empregados com carteira para nem-nem (%)"

cap label variable sh_cpropria_sh_inativa "Transição de conta própria para inativos (%)"
cap label variable sh_cpropria_sh_formal "Transição de conta própria para formal (%)"	
cap label variable sh_cpropria_sh_informal "Transição de conta própria para informal (%)"	
cap label variable sh_cpropria_sh_desempregado "Transição de conta própria para desempregados (%)"
cap label variable sh_cpropria_sh_empregadoSC "Transição de conta própria para empregados sem carteira (%)"
cap label variable sh_cpropria_sh_empregadoCC "Transição de conta própria para empregados com carteira (%)"
cap label variable sh_cpropria_sh_cpropria "Transição de conta própria para conta própria (%)"
cap label variable sh_cpropria_sh_empregador "Transição de conta própria para empregadores (%)"
cap label variable sh_cpropria_sh_militar "Transição de conta própria para servidores públicos (%)"
cap label variable sh_cpropria_sh_desalento "Transição de conta própria para desalentados (%)"
cap label variable sh_cpropria_sh_nemnem "Transição de conta própria para nem-nem (%)"

cap label variable sh_empregador_sh_inativa "Transição de empregadores para inativos (%)"
cap label variable sh_empregador_sh_formal "Transição de empregadores para formal (%)"	
cap label variable sh_empregador_sh_informal "Transição de empregadores para informal (%)"	
cap label variable sh_empregador_sh_desempregado "Transição de empregadores para desempregados (%)"
cap label variable sh_empregador_sh_empregadoSC "Transição de empregadores para empregados sem carteira (%)"
cap label variable sh_empregador_sh_empregadoCC "Transição de empregadores para empregados com carteira (%)"
cap label variable sh_empregador_sh_cpropria "Transição de empregadores para conta própria (%)"
cap label variable sh_empregador_sh_empregador "Transição de empregadores para empregadores (%)"
cap label variable sh_empregador_sh_militar "Transição de empregadores para servidores públicos (%)"
cap label variable sh_empregador_sh_desalento "Transição de empregadores para desalentados (%)"
cap label variable sh_empregador_sh_nemnem "Transição de empregadores para nem-nem (%)"
 
cap label variable sh_militar_sh_inativa "Transição de servidores públicos para inativos (%)"
cap label variable sh_militar_sh_formal "Transição de servidores públicos para formal (%)"	
cap label variable sh_militar_sh_informal "Transição de servidores públicos para informal (%)"	
cap label variable sh_militar_sh_desempregado "Transição de servidores públicos para desempregados (%)"
cap label variable sh_militar_sh_empregadoSC "Transição de servidores públicos para empregados sem carteira (%)"
cap label variable sh_militar_sh_empregadoCC "Transição de servidores públicos para empregados com carteira (%)"
cap label variable sh_militar_sh_cpropria "Transição de servidores públicos para conta própria (%)"
cap label variable sh_militar_sh_empregador "Transição de servidores públicos para empregadores (%)"
cap label variable sh_militar_sh_militar "Transição de servidores públicos para servidores públicos (%)"
cap label variable sh_militar_sh_desalento "Transição servidores públicos para desalentados (%)"
cap label variable sh_militar_sh_nemnem "Transição de servidores públicos para nem-nem (%)"

cap label variable sh_desalento_sh_inativa "Transição de desalentados para inativos (%)"
cap label variable sh_desalento_sh_formal "Transição de desalentados para formal (%)"	
cap label variable sh_desalento_sh_informal "Transição de desalentados para informal (%)"	
cap label variable sh_desalento_sh_desempregado "Transição de desalentados para desempregados (%)"
cap label variable sh_desalento_sh_empregadoSC "Transição de desalentados para empregados sem carteira (%)"
cap label variable sh_desalento_sh_empregadoCC "Transição de desalentados para empregados com carteira (%)"
cap label variable sh_desalento_sh_cpropria "Transição de desalentados para conta própria (%)"
cap label variable sh_desalento_sh_empregador "Transição de desalentados para empregadores (%)"
cap label variable sh_desalento_sh_militar "Transição de desalentados para servidores públicos (%)"
cap label variable sh_desalento_sh_desalento "Transição de desalentados para desalentados (%)"
cap label variable sh_desalento_sh_nemnem "Transição de desalentados para nem-nem (%)"
 

cap label variable sh_nemnem_sh_inativa "Transição de nem-nem para inativos (%)"
cap label variable sh_nemnem_sh_formal "Transição de nem-nem para formal (%)"	
cap label variable sh_nemnem_sh_informal "Transição de nem-nem para informal (%)"	
cap label variable sh_nemnem_sh_desempregado "Transição de nem-nem para desempregados (%)"
cap label variable sh_nemnem_sh_empregadoSC "Transição de nem-nem para empregados sem carteira (%)"
cap label variable sh_nemnem_sh_empregadoCC "Transição de nem-nem para empregados com carteira (%)"
cap label variable sh_nemnem_sh_cpropria "Transição de nem-nem para conta própria (%)"
cap label variable sh_nemnem_sh_empregador "Transição de nem-nem para empregadores (%)"
cap label variable sh_nemnem_sh_militar "Transição de nem-nem para servidores públicos (%)"
cap label variable sh_nemnem_sh_desalento "Transição de nem-nem para desalentados (%)"
cap label variable sh_nemnem_sh_nemnem "Transição de nem-nem para nem-nem (%)"
 
* keep relevant variables
keep sh_*

