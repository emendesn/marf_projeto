#include 'protheus.ch'
#include 'parmtype.ch'

user function CT102VLES()
	
	Local lRet 		:= .T.
	Local cxUser	:= Alltrim(RetCodUsr())
	
	If IsInCallStack("CTBA102cap")
		If FindFunction("U_xMG6ExUs")
			lRet := U_xMG6ExUs()
		EndIf
	EndIf

	If lRet .and. FindFunction("U_xMC26Sal")
		lRet := U_xMC26Sal(cFilAnt,cxUser,1)
	EndIf
	
return lRet