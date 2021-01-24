#include 'protheus.ch'
#include 'parmtype.ch'

user function MTA103MNU()
	
	If FindFunction("U_MGFCTB10")
		AADD(aRotina,{OemToAnsi('incluir Rateio'),"U_MGFCTB10", 0 , 2, 0, nil})
	EndIf
	
return