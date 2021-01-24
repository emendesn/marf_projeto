#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
=====================================================================================
Programa............: MGFFAT81
Autor...............: Totvs
Data................: Junho/2018 
Descricao / Objetivo: Rotina chamada pelo PE M410LIOK
Doc. Origem.........: Faturamento
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Valida se o item do pedido estah com a sequencia em branco
=====================================================================================
*/
User Function MGFFAT81()

Local lRet := .T.

If !gdDeleted(n)
	If Empty(gdFieldGet("C6_ITEM"))
		lRet := .F.
		APMsgAlert("Item do pedido em branco."+CRLF+;
		"Delete a linha e inclua uma nova linha.")
	Endif
	If lRet
		If Empty(gdFieldGet("C6_LOCAL"))
			lRet := .F.
			APMsgAlert("Armazém do pedido em branco.")
		Endif
	Endif	

	if ALTERA
		if !chkItem()
			lRet := .F.
			APMsgAlert("Produto não poderá ser alterado." + CRLF + "Delete a linha e inclua uma nova linha.")
		endif
	endif

Endif
		
Return(lRet)

//--------------------------------------------------------------------
//--------------------------------------------------------------------
static function chkItem()
	local cQrySC6	:= ""
	local lRetOk	:= .T.
	local aAreaX	:= getArea()

	cQrySC6 := "SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO"					+ CRLF
	cQrySC6 += " FROM " + retSQLName("SC6") + " SC6"							+ CRLF
	cQrySC6 += " WHERE"															+ CRLF
	cQrySC6 += " 		SC6.C6_ITEM		=	'" + gdFieldGet("C6_ITEM")	+ "'"	+ CRLF
	cQrySC6 += " 	AND	SC6.C6_NUM		=	'" + SC5->C5_NUM			+ "'"	+ CRLF
	cQrySC6 += " 	AND	SC6.C6_FILIAL	=	'" + SC5->C5_FILIAL			+ "'"	+ CRLF
	cQrySC6 += " 	AND	SC6.D_E_L_E_T_	<>	'*'"								+ CRLF

	tcQuery cQrySC6 New Alias "QRYSC6"

	if !QRYSC6->( EOF() )
		if allTrim( gdFieldGet("C6_PRODUTO") ) <> allTrim( QRYSC6->C6_PRODUTO )
			lRetOk := .F.
		endif
	endif

	QRYSC6->(DBCloseArea())

	restArea( aAreaX )
return lRetOk