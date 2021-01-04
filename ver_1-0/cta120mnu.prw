#include 'protheus.ch'
#include 'parmtype.ch'

user function CTA120MNU()
	
	If FindFunction("U_MGFCTB12")
		AADD(aRotina,{OemToAnsi('incluir Rateio'),"U_MGFCTB12", 0 , 2, 0, nil})
	EndIf
	
return