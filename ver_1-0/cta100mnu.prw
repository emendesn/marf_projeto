#include 'protheus.ch'
#include 'parmtype.ch'

user function CTA100MNU()

	If FindFunction("U_MGFCTB11")
		AADD(aRotina,{OemToAnsi('incluir Rateio'),"U_MGFCTB11", 0 , 2, 0, nil})
	EndIf
	
return