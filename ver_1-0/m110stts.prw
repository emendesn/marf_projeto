#include 'protheus.ch'
#include 'parmtype.ch'

user function M110STTS()
	
	Local cNumSC := PARAMIXB[1]
	Local nxOpc	 := PARAMIXB[2]
	
	If nxOpc <> 3 //.or. nxOpc == 2
		If Findfunction("U_xM8GASC")
			U_xM8GASC(cNumSC,nxOpc)
		EndIf
	EndIf
	
return