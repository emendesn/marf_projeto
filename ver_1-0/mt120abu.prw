#include 'protheus.ch'
#include 'parmtype.ch'

user function MT120ABU()
	
	Local aButtons := PARAMIXB[1]
	
	aadd(aButtons,{"BUDGET",  {|| U_MGFCOM30() },                'Aplicar Desconto', 'Aplicar Desconto'})
	
return aButtons