#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
-----------------------------------------------------
	Chamdo pelo PE SACI008
	Atualiza o status na tela de COntrole de Caução do Financeiro
-----------------------------------------------------
*/
user function MGFFINB9()
	local cQryZE6	:= ""
	local cUpdZE6	:= ""
	local aAreaX	:= getArea()

	if allTrim( SE1->E1_TIPO ) == "CC" .and. !empty( SE1->E1_ZNSU ) .and. SE1->E1_SALDO == 0
		cQryZE6 := "SELECT ZE6.R_E_C_N_O_ ZE6RECNO"									+ CRLF
		cQryZE6 += " FROM " + retSQLName("ZE6") + " ZE6"							+ CRLF	
		cQryZE6 += " WHERE"															+ CRLF
		cQryZE6 += " 		ZE6.ZE6_LOJACL  =	'" + SE1->E1_LOJA   		+ "'"	+ CRLF
		cQryZE6 += " 	AND	ZE6.ZE6_CLIENT  =	'" + SE1->E1_CLIENTE		+ "'"	+ CRLF
		cQryZE6 += " 	AND	ZE6.ZE6_PREFIX	=	'" + SE1->E1_PREFIXO		+ "'"	+ CRLF
		cQryZE6 += " 	AND	ZE6.ZE6_TITULO	=	'" + SE1->E1_NUM			+ "'"	+ CRLF
		cQryZE6 += " 	AND	ZE6.ZE6_PARCEL	=	'" + SE1->E1_PARCELA		+ "'"	+ CRLF
		cQryZE6 += " 	AND	ZE6.ZE6_FILIAL	=	'" + xFilial("ZE6")			+ "'"	+ CRLF
		cQryZE6 += " 	AND	ZE6.D_E_L_E_T_	<>	'*'"								+ CRLF

		conout( "[MGFFINB9] " + cQryZE6 )

		tcQuery cQryZE6 New Alias "QRYZE6"

		if !QRYZE6->(EOF())
			cUpdZE6	:= ""

			cUpdZE6 := "UPDATE " + retSQLName("ZE6")										+ CRLF
			cUpdZE6 += "	SET"															+ CRLF
			cUpdZE6 += " 		ZE6_STATUS	=	'2'"										+ CRLF // 0-Caução / 1-Título Gerado / 2-Título Baixado / 3-Erro
			cUpdZE6 += " WHERE"																+ CRLF
			cUpdZE6 += " 		R_E_C_N_O_ = " + allTrim( str( QRYZE6->ZE6RECNO ) ) + ""	+ CRLF

			if tcSQLExec( cUpdZE6 ) < 0
				conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
			endif
		endif

		QRYZE6->(DBCloseArea())
	endif

	restArea( aAreaX )
return