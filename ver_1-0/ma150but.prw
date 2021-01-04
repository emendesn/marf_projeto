#include 'protheus.ch'
#include 'parmtype.ch'

user function MA150BUT()
	Local aButtons := {}
	
	aadd(aButtons,{"BUDGET",  {|| U_MGFCOM30() },             'Aplicar Desconto', 'Aplicar Desconto'})
	//aadd(aButtons,{"BUDGET",  {|| U_MGFCOM96() },                'Enviar WF PC', 'Enviar WF PC'})

return aButtons