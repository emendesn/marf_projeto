#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
	Se Pedido do SFA for alterado na mesa reenvia ao Tablet
*/
user function MGFFAT73()

	if !empty( SC5->C5_XIDSFA )
		sfaZC5()
	endif

return

//-----------------------------------------------------------------
// Atualiza ZC5 para retorno do Pedido na integracao do SFA
//-----------------------------------------------------------------
static function sfaZC5()
	local cUpdZC5 := ""

	cUpdZC5 := "UPDATE " + retSQLName("ZC5")
	cUpdZC5 += " SET "
	cUpdZC5 += "	ZC5_INTEGR = 'P'"
	cUpdZC5 += " WHERE"
	cUpdZC5 += "		ZC5_IDSFA	=	'" + allTrim(SC5->C5_XIDSFA)	+ "'"
	cUpdZC5 += "	AND	D_E_L_E_T_	<>	'*'"

	tcSQLExec(cUpdZC5)

	// ATUALIZA PEDIDO DE VENDA - SC5
	cUpdZC5 := ""

	cUpdZC5 := "UPDATE " + retSQLName("SC5")
	cUpdZC5 += " SET "
	cUpdZC5 += "	C5_XINTEGR = 'P'"
	cUpdZC5 += " WHERE"
	cUpdZC5 += "		C5_FILIAL	=	'" + SC5->C5_FILIAL	+ "'"
	cUpdZC5 += "	AND	C5_NUM		=	'" + SC5->C5_NUM	+ "'"
	cUpdZC5 += "	AND	D_E_L_E_T_	<>	'*'"

	tcSQLExec(cUpdZC5)
return