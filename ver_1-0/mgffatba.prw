#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwmvcdef.ch"

#define CRLF chr( 13 ) + chr( 10 )

user function MGFFATBA()
	local cUpdSU5	:= ""

	if PARAMIXB[ 2 ] == "MODELCOMMITNTTS"
		// MODELCOMMITNTTS - Após a gravação total do modelo e fora da transação
		// Parâmetros Recebidos:
		// 1 O Objeto do formulário ou do modelo, conforme o caso.
		// 2 C ID do local de execução do ponto de entrada.
		// 3 C ID do formulário.

		cUpdSU5 := "UPDATE " + retSQLName("SU5")											+ CRLF
		cUpdSU5	+= " SET U5_XINTSFO = 'P'"													+ CRLF
		cUpdSU5	+= " WHERE"																	+ CRLF
		cUpdSU5	+= " R_E_C_N_O_ IN"															+ CRLF
		cUpdSU5	+= " ("																		+ CRLF
		cUpdSU5 += "	SELECT SU5.R_E_C_N_O_"												+ CRLF
		cUpdSU5 += "	FROM "			+ retSQLName( "SU5" ) + " SU5"						+ CRLF
		cUpdSU5 += "	INNER JOIN "	+ retSQLName( "AC8" ) + " AC8"						+ CRLF
		cUpdSU5 += "	ON"																	+ CRLF
		cUpdSU5 += " 			AC8.AC8_ENTIDA	=	'SA1'"									+ CRLF
		cUpdSU5 += " 		AND	AC8.AC8_CODENT	=	'" + SA1->( A1_COD + A1_LOJA ) + "'"	+ CRLF
		cUpdSU5 += " 		AND	AC8.AC8_CODCON	=	SU5.U5_CODCONT"							+ CRLF
		cUpdSU5 += "		AND	AC8.AC8_FILENT	=	'" + xFilial("AC8") + "'"				+ CRLF
		cUpdSU5 += "		AND	AC8.AC8_FILIAL	=	'" + xFilial("AC8") + "'"				+ CRLF
		cUpdSU5 += "		AND	AC8.D_E_L_E_T_	<>	'*'"									+ CRLF
		cUpdSU5 += " 	WHERE"																+ CRLF
		cUpdSU5 += " 			SU5.U5_FILIAL	=	'" + xFilial("SU5")			+ "'"		+ CRLF
		cUpdSU5 += " 		AND	SU5.D_E_L_E_T_	<>	'*'"									+ CRLF
		cUpdSU5	+= " )"

		if tcSQLExec( cUpdSU5 ) < 0
			conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
		endif
	endif
return
