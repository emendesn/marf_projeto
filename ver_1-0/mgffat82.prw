#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
	Valida��o do campo A1_VEND
	N�o permite altera��o caso o cliente esteja na Estrutura de Venda
*/
user function MGFFAT82()
	local lRet		:= .T.
	local cQryZBJ	:= ""

	cQryZBJ := " SELECT *"											+ CRLF
	cQryZBJ += " FROM " + retSQLName("ZBJ") + " ZBJ"				+ CRLF
	cQryZBJ += " WHERE"												+ CRLF
	cQryZBJ += "		ZBJ.ZBJ_LOJA	= '" + M->A1_LOJA	+ "'"	+ CRLF
	cQryZBJ += "	AND	ZBJ.ZBJ_CLIENT	= '" + M->A1_COD	+ "'"	+ CRLF
	cQryZBJ += "	AND	ZBJ.D_E_L_E_T_	= ' '"						+ CRLF

	tcQuery cQryZBJ New Alias "QRYZBJ"

	if !QRYZBJ->(EOF())
		msgAlert("Este Cliente est� em Estrutura Comercial e n�o poder� ter o Vendedor alterado.")
		lRet := .F.
	endif

	QRYZBJ->(DBCloseArea())
return lRet