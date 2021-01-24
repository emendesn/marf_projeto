#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFIN80

Fonte utilizado no layout CNAB do Contas a Pagar de REMESSA

nTipo 1 - Para VALOR DO TITULO
nTipo 2 - Para DESCONTO

@author Gustavo Ananias Afonso - TOTVS Campinas
@since
/*/
//-------------------------------------------------------------------
user function MGFFIN80( nTipo )
	local cRetFin80	:= ""

	if nTipo == 1
		if allTrim( SE2->E2_ZCONTRA ) == '3'
			cRetFin80 := STRZERO( ( SE2->( E2_SALDO + E2_ZTXBOL + E2_ACRESC - E2_DECRESC ) + sumSE5() ) * 100, 15 )
		elseif allTrim( SE2->E2_ZCONTRA ) == '1' .OR. allTrim( SE2->E2_ZCONTRA ) == ' ' 
			cRetFin80 := STRZERO( ( SE2->( E2_SALDO + E2_ZTXBOL + E2_ACRESC - E2_DECRESC ) ) * 100, 15 )
		else
			cRetFin80 := REPLICATE("0",15)
		endif
	elseif nTipo == 2
		if allTrim( SE2->E2_ZCONTRA ) == '3'
			recLock("SE2", .F.)
				SE2->E2_ZTXBOL := sumSE5()
			SE2->(msUnlock())

			cRetFin80 := STRZERO( SE2->( SE2->E2_ZTXBOL *100, 15 ) )

		elseif allTrim( SE2->E2_ZCONTRA ) == '1' .OR. allTrim( SE2->E2_ZCONTRA ) == ' '
			cRetFin80 := STRZERO( SE2->( E2_XDESCO + E2_ZTXBOL ) * 100, 15 )
		else
			cRetFin80 := REPLICATE("0",15)
		endif
	endif

return cRetFin80

//--------------------------------------------------------------------------
// Retorna a soma das Compensacoes do Titulo (SE2) posicionado
//--------------------------------------------------------------------------
static function sumSE5()
	local cQrySE5	:= ""
	local aArea		:= getArea()
	local aAreaSE2	:= SE2->(getArea())
	local nSumSE5	:= 0

	cQrySE5 := "SELECT"
	cQrySE5 += " E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ, E5_VALOR"
	cQrySE5 += " FROM " + retSQLName("SE5") + " SE5"
	cQrySE5 += " WHERE"
	cQrySE5 += "		SE5.E5_LOJA		=	'" + SE2->E2_LOJA		+ "'"
	cQrySE5 += "	AND	SE5.E5_CLIFOR	=	'" + SE2->E2_FORNECE	+ "'"
	cQrySE5 += "	AND	SE5.E5_TIPO		=	'" + SE2->E2_TIPO		+ "'"
	cQrySE5 += "	AND	SE5.E5_NUMERO	=	'" + SE2->E2_NUM		+ "'"
	cQrySE5 += "	AND	SE5.E5_PREFIXO	=	'" + SE2->E2_PREFIXO	+ "'"
	cQrySE5 += "	AND	SE5.E5_FILIAL	=	'" + SE2->E2_FILIAL		+ "'"
	cQrySE5 += "	AND	SE5.E5_MOTBX	=	'CMP'"
	cQrySE5 += "	AND	SE5.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySE5 New Alias "QRYSE5"

	// SITUACAO -> Cancelado
	// Funcao verifica os excluidos TemBxCanc( (cAliasSE5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) , .T. )

	while !QRYSE5->(EOF())
		if !TemBxCanc( QRYSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) , .T. )
			nSumSE5 += QRYSE5->E5_VALOR
		endif

		QRYSE5->( DBSkip() )
	enddo

	QRYSE5->(DBCloseArea())

	restArea( aAreaSE2 )
	restArea( aArea )
return nSumSE5
