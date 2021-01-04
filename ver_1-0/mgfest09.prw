#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST09

Processo os agendamentos da rotina de
Autom.venda e transf. do armazem central (MGFEST01)

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 06/09/2016
/*/
//-------------------------------------------------------------------
user function MGFEST09()
	local cQrySZ5 := ""

	local aTables		:= {"SZ5","SF1","SD1","SF2","SD2","SB1","SB6","SC5","SC6","SC9"}
	
	Private _lJob	:= IIf(GetRemoteType() == -1, .T., .F.)

	If _lJob
		RpcSetEnv( "01" , "01000'" , Nil, Nil, "EST", Nil, aTables )
	EndIf

	cQrySZ5 := " SELECT *"
	cQrySZ5 += " FROM " + retSQLName("SZ5") + " SZ5"
	cQrySZ5 += " WHERE"
	cQrySZ5 += " 		SUBSTR(SZ5.Z5_AGHORA, 1, 2)	=	'" + left(time(), 2) + "'"
	cQrySZ5 += " 	AND	SZ5.Z5_AGDATA			=	'" + dToS(dDataBase) + "'"
	cQrySZ5 += " 	AND	SZ5.Z5_NUMPV			<>	''"	// APENAS OS QUE POSSUEM PV GERADO
	cQrySZ5 += " 	AND	SZ5.Z5_NUMNF			=	''" // APENAS OS QUE NÃO POSSUEM NOTA GERADA
	If !_lJob
		cQrySZ5 += " 	AND	SZ5.Z5_FILIAL			=	'" + xFilial("SZ5") + "'"
	EndIf
	cQrySZ5 += " 	AND	SZ5.D_E_L_E_T_			<>	'*'"
	cQrySZ5 += " ORDER BY Z5_FILIAL, Z5_NUM "
	
	TcQuery changeQuery(cQrySZ5) New Alias "QRYSZ5"

	while !QRYSZ5->(EOF())
		cFilAnt := QRYSZ5->Z5_FILIAL
		BEGIN TRANSACTION
			u_genNF(nil, QRYSZ5->Z5_NUMPV, QRYSZ5->Z5_NUM, .T.)
		END TRANSACTION
		QRYSZ5->(DBSkip())
	enddo

	QRYSZ5->(DBCloseArea())

	If _lJob
		RpcClearEnv()
	EndIf

return
