#include 'protheus.ch'
#include 'parmtype.ch'

user function F50PERGUNT()
	
	If IsInCallStack("U_MGFCOM15") //Mov.Banc.sem Cheque ? 1 = sim 
		MV_PAR09 := 1
	EndIf
	
return