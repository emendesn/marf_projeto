#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'
#INCLUDE 'tbiconn.ch'


#define CRLF chr(13) + chr(10)
/*
	Valida se Motivo / Justificatica podem ser usados
*/
user function MGFCRM50( nType, cCod )
	local lRet	:= .T.
	local cQryZ	:= ""

	if nType == 1 // MOTIVO
		cQryZ := "SELECT *"
		cQryZ += " FROM " + retSQLName("ZAS") + " ZAS"
		cQryZ += " WHERE"
		cQryZ += " 		ZAS.ZAS_ATIVO	=	'1'"
		cQryZ += " 	AND	ZAS.ZAS_CODIGO	=	'" + cCod			+ "'"
		cQryZ += " 	AND	ZAS.ZAS_FILIAL	=	'" + xFilial("ZAS")	+ "'"
		cQryZ += " 	AND	ZAS.D_E_L_E_T_	<>	'*'"

		TcQuery cQryZ New Alias "QRYZAS"

		if QRYZAS->(EOF())
			lRet := .F.
			//msgAlert("Motivo inválido.")
			Help( ,, 'MGFCRM50',, 'Motivo inválido.', 1, 0 )
		endif

		QRYZAS->(DBCloseArea())
	elseif nType == 2 // JUSTIFICATIVA
		cQryZ := "SELECT *"
		cQryZ += " FROM " + retSQLName("ZAT") + " ZAT"
		cQryZ += " WHERE"
		cQryZ += " 		ZAT.ZAT_ATIVO	=	'1'"
		cQryZ += " 	AND	ZAT.ZAT_CODIGO	=	'" + cCod			+ "'"
		cQryZ += " 	AND	ZAT.ZAT_FILIAL	=	'" + xFilial("ZAT")	+ "'"
		cQryZ += " 	AND	ZAT.D_E_L_E_T_	<>	'*'"
		
		TcQuery cQryZ New Alias "QRYZAT"
		
		if QRYZAT->(EOF())
			lRet := .F.
			//msgAlert("Justificativa inválida.")
			Help( ,, 'MGFCRM50',, 'Justificativa inválida.', 1, 0 )
		endif
		
		QRYZAT->(DBCloseArea())
	elseif nType == 3 // DIRECIONAMENTO
		cQryZ := "SELECT *"												+ CRLF
		cQryZ += " FROM " + retSQLName("ZAU") + " ZAU"					+ CRLF

		// ZAS - MOTIVO
		cQryZ += " INNER JOIN " + retSQLName("ZAS") + " ZAS"				+ CRLF
		cQryZ += " ON"													+ CRLF
		cQryZ += " 		ZAS.ZAS_ATIVO	=	'1'"						+ CRLF
		cQryZ += " 	AND	ZAU.ZAU_CODMOT	=	ZAS.ZAS_CODIGO"				+ CRLF
		cQryZ += " 	AND	ZAS.ZAS_FILIAL	=	'" + xFilial("ZAS") + "'"	+ CRLF
		cQryZ += " 	AND	ZAS.D_E_L_E_T_	<>	'*'"						+ CRLF

		// ZAT - JUSTIFICATIVA
		cQryZ += " INNER JOIN " + retSQLName("ZAT") + " ZAT"				+ CRLF
		cQryZ += " ON"													+ CRLF
		cQryZ += " 		ZAT.ZAT_ATIVO	=	'1'"
		cQryZ += " 	AND	ZAU.ZAU_CODJUS	=	ZAT.ZAT_CODIGO"				+ CRLF
		cQryZ += " 	AND	ZAT.ZAT_FILIAL	=	'" + xFilial("ZAT") + "'"	+ CRLF
		cQryZ += " 	AND	ZAT.D_E_L_E_T_	<>	'*'"						+ CRLF
	
		cQryZ += " WHERE"	+ CRLF
		cQryZ += " 		ZAU.ZAU_CODIGO	=	'" + M->ZAW_DIRECI	+ "'"	+ CRLF
		cQryZ += " 	AND	ZAU.ZAU_FILIAL	=	'" + xFilial("ZAU")	+ "'"	+ CRLF
		cQryZ += " 	AND	ZAU.D_E_L_E_T_	<>	'*'"	+ CRLF

		tcQuery cQryZ New Alias "QRYZAU"

		if QRYZAU->(EOF())
			lRet := .F.
			Help( ,, 'MGFCRM50',, 'Motivo e/ou Justificativa inválido(a).', 1, 0 )
		endif
	
		QRYZAU->(DBCloseArea())
	endif

return lRet