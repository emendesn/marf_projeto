#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST16

Envia a NF de Saída para a transmissão via Inventti

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 08/09/2016
/*/
//-------------------------------------------------------------------
user function MGFEST16()

	sendOutNF()

return

//-------------------------------------------------------------------
// Envia a NF para programa externo de transmissão
//-------------------------------------------------------------------
static function sendOutNF()
	local nI		:= 0
	local cQrySZ5	:= ""
	local aRecnoSF2	:= {}

	cQrySZ5 := " SELECT SF2.R_E_C_N_O_ F2RECNO"					+ CRLF
	cQrySZ5 += " FROM "			+ retSQLName("SZ5") + " SZ5"	+ CRLF
	cQrySZ5 += " INNER JOIN "	+ retSQLName("SF2") + " SF2"	+ CRLF
	cQrySZ5 += " ON"											+ CRLF
	cQrySZ5 += " 	SZ5.Z5_NUMNF = (SF2.F2_FILIAL || SF2.F2_DOC || SF2.F2_SERIE || SF2.F2_CLIENTE || SF2.F2_LOJA)"	+ CRLF
	cQrySZ5 += " WHERE"												+ CRLF
	cQrySZ5 += " 		SF2.F2_CHVNFE  	=	''"	+ CRLF // Notas geradas
	cQrySZ5 += " 	AND	SZ5.Z5_NUMNF  	<>	''"	+ CRLF // Notas geradas
	cQrySZ5 += " 	AND	SF2.F2_FILIAL	=	'" + xFilial("SF2") + "'"	+ CRLF
	cQrySZ5 += " 	AND	SZ5.Z5_FILIAL	=	'" + xFilial("SZ5") + "'"	+ CRLF
	cQrySZ5 += " 	AND	SF2.D_E_L_E_T_	<>	'*'"	+ CRLF
	cQrySZ5 += " 	AND	SZ5.D_E_L_E_T_	<>	'*'"	+ CRLF

	TcQuery changeQuery(cQrySZ5) New Alias "QRYSZ5"

	while !QRYSZ5->(EOF())
		aadd(aRecnoSF2, QRYSZ5->F2RECNO)
		QRYSZ5->(DBSkip())
	enddo

	QRYSZ5->(DBCloseArea())

	for nI := 1 to len(aRecnoSF2)
		//startJob( "U_MGF_ENVNF", getEnvServer(), .T., FwCodEmp(),cFilAnt,'SF2', 2, aRecnoSF2[nI], .T. )
		U_MGF_ENVNF(FwCodEmp(),cFilAnt,'SF2', 2, aRecnoSF2[nI], .F.)
	next
return
