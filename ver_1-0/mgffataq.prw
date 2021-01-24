#include "protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#define CRLF chr( 13 ) + chr( 10  )

//------------------------------------------------------------------------
// Verifica se pedido é do E-Commerce
//------------------------------------------------------------------------
user function MGFFATAQ()
	local cQrySC5	:= ""
	local aAreaX	:= getArea()
	local lEcomm	:= .F.

	cQrySC5 := "SELECT C5_FILIAL, C5_NUM"										+ CRLF
	cQrySC5 += " FROM " + retSQLName("SC5") + " SC5"							+ CRLF
	cQrySC5 += " WHERE"															+ CRLF
	cQrySC5 += " 		SC5.C5_ZIDECOM	<>	' '"								+ CRLF
	cQrySC5 += " 	AND	SC5.C5_NUM		=	'" + SD2->D2_PEDIDO + "'"			+ CRLF
	cQrySC5 += " 	AND	SC5.C5_FILIAL	=	'" + xFilial("SC5")	+ "'"			+ CRLF
	cQrySC5 += " 	AND	SC5.D_E_L_E_T_	<>	'*'"								+ CRLF

	//conout('[MGFFATAQ] QUERY ' + cQrySC5 )

	TcQuery cQrySC5 New Alias "QRYSC5"

	if !QRYSC5->(EOF())
		lEcomm := .T.
		//conout( '[MGFFATAQ] PV ' + SD2->D2_PEDIDO + ' originado do e-commerce' )
	endif

	QRYSC5->(DBCloseArea())

	restArea( aAreaX )
return lEcomm