#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: CTB500USU
Autor...............: Joni Lima
Data................: 30/01/2019
Descricao / Objetivo: O ponto de entrada CTB500USU � utilizado para validacao de usuario.
Solicitante.........: Cliente
Uso.................: 
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6068801
=====================================================================================
*/
User Function CTB500USU()
	
	Local lRet 		:= .T.
	Local cxUser	:= Alltrim(RetCodUsr())
	
	If FindFunction("U_xMG6ExUs")
		lRet := U_xMG6ExUs()
	EndIf

	If lRet .and. FindFunction("U_xMC26Sal")
		lRet := U_xMC26Sal(cFilAnt,cxUser,1)
	EndIf
	
return lRet 