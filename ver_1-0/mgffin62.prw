#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

//-----------------------------------------------------------------------
// Retorna true se o titulo posicionado tiver movimentacao bancaria (SE5)
//-----------------------------------------------------------------------
user function MGFFIN62()
	local cQrySE5	:= ""
	local lRetFin59	:= .F.
	local aArea		:= getArea()
	local aAreaSE2	:= SE2->(getArea())

	cQrySE5 := "SELECT"
	cQrySE5 += " E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ"
	cQrySE5 += " FROM " + retSQLName("SE5") + " SE5"
	cQrySE5 += " WHERE"
	cQrySE5 += "		SE5.E5_LOJA		=	'" + SE2->E2_LOJA		+ "'"
	cQrySE5 += "	AND	SE5.E5_CLIFOR	=	'" + SE2->E2_FORNECE	+ "'"
	cQrySE5 += "	AND	SE5.E5_TIPO		=	'" + SE2->E2_TIPO		+ "'"
	cQrySE5 += "	AND	SE5.E5_PARCELA	=	'" + SE2->E2_PARCELA	+ "'"
	cQrySE5 += "	AND	SE5.E5_NUMERO	=	'" + SE2->E2_NUM		+ "'"
	cQrySE5 += "	AND	SE5.E5_PREFIXO	=	'" + SE2->E2_PREFIXO	+ "'"
	cQrySE5 += "	AND	SE5.E5_FILIAL	=	'" + SE2->E2_FILIAL		+ "'"
	cQrySE5 += "	AND	SE5.E5_SITUACA NOT IN ('C','E','X')"
	cQrySE5 += "	AND	SE5.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySE5 New Alias "QRYSE5"

	// SITUACAO -> Cancelado
	// Funcao verifica os excluidos TemBxCanc( (cAliasSE5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) , .T. )

	while !QRYSE5->(EOF())
		if TemBxCanc( QRYSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) , .T. )
			QRYSE5->( DBSkip() )
			loop
		endif

		lRetFin59 := .T.
		exit
	enddo

	QRYSE5->(DBCloseArea())

	restArea(aAreaSE2)
	restArea(aArea)
return lRetFin59