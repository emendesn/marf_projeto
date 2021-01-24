#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include "FWMVCDEF.CH"

/*/{Protheus.doc} MGFWSS10
Integração Protheus-Taura, para envio do Cadastro de Tipo de Veiculo (Função utilizada no JOB)
MGFWSS10 - Usado no JOB
@type function

@author Joni Lima do Carmo
@since 24/06/2019
@version P12
/*/
User Function MGFWSS10()

	//U_xMGWSS10({"01", "010001"})
	U_xMGWSS10()

	Return

	/*/{Protheus.doc} xMGWSS10
	Prepara o Ambiente para chamar o processamento (usado no JOB)
	MGFWSS10 - Usado no JOB
	@type function

	@author Joni Lima do Carmo
	@since 24/06/2019
	@version P12
	/*/
User Function xMGWSS10()

	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "010001"
	xProcTipo()
	Return

	/*/{Protheus.doc} xMGFPT10
	Chama a rotina de processamento (Pode ser usado em Menu para chamar Manualmente)
	MGFWSS10 - Usado no JOB
	@type function

	@author Joni Lima do Carmo
	@since 24/06/2019
	@version P12
	/*/
User Function xMGFPT10()
	xProcTipo()
	Return

	/*/{Protheus.doc} xProcTipo
	Realiza o Processamento da Integração com o Taura
	MGFWSS10 - Usado no JOB
	@type function

	@author Joni Lima do Carmo
	@since 24/06/2019
	@version P12
	/*/
Static Function xProcTipo()

	Local cQ 		:= ""
	Local cAliasTrb := GetNextAlias()

	Local cIDTaura 	:= GetMV("MGF_IDTIVE",.F.,) //0000000001
	Local cUrl 		:= Alltrim(GetMv("MGF_URLTIV"))
	Local cHeadRet 	:= ""
	Local aHeadOut	:= {}

	Local cJson		:= ""
	Local oJson		:= Nil

	Local cTimeIni	:= ""
	Local cTimeProc	:= ""

	Local xPostRet	:= Nil
	Local nStatuHttp	:= 0
	local nTimeOut		:= 120

	If Empty(cIDTaura)
		ConOut("Não encontrado parâmetro 'MGF_IDTIVE'.")
		Return()
	Endif

	cIDTaura := Soma1(cIDTaura)
	PutMV("MGF_IDTIVE",cIDtaura)

	// flega todos os veiculos selecionados como "em processamento", para que outro job nao pegue o mesmo veiculo para processar
	cQ := " UPDATE "
	cQ += RetSqlName("DUT") + " "
	cQ += " SET DUT_ZINTEG = '" + cIDTaura + "' "
	cQ += " WHERE D_E_L_E_T_ = ' ' "
	cQ += " AND DUT_ZINTTA IN ('N','E') "

	nRet := tcSqlExec(cQ)
	If nRet == 0
	Else
		ConOut("Problemas na gravação do semáforo do cadastro de Tipo veiculo, para envio ao Taura.")
		Return()
	EndIf

	cQ := "SELECT DUT.R_E_C_N_O_ DUT_RECNO,DUT_FILIAL,DUT_TIPVEI,DUT_DESCRI,DUT.D_E_L_E_T_ DELET "
	cQ += "FROM "+RetSqlName("DUT")+" DUT "
	cQ += "WHERE "
	//cQ += "DUT.D_E_L_E_T_ <> '*' " // OBS: processa linhas deletadas
	cQ += "DUT_ZINTEG = '" + cIDTaura + "' "
	//cQ += "ORDER BY DUT_FILIAL,DUT_TIPVEI "

	cQ := ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",tcGenQry(,,cQ),cAliasTrb,.T.,.T.)

	aadd( aHeadOut, 'Content-Type: application/json' )
	aadd( aHeadOut, 'Accept-Charset: utf-8' )

	While (cAliasTrb)->(!Eof())

		oJson						:= JsonObject():new()
		oJson['IDGrupoVeiculo']		:= (cAliasTrb)->DUT_TIPVEI
		oJson['DescGrupoVeiculo']	:= (cAliasTrb)->DUT_DESCRI

		cJson	:= ""
		cJson	:= oJson:toJson()

		cTimeIni := time()

		if !empty( cJson )
			xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
		endif

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )

		conout(" [MGFWSS10] * * * * * Status da integracao * * * * *"								)
		conout(" [MGFWSS10] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
		conout(" [MGFWSS10] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
		conout(" [MGFWSS10] Tempo de Processamento.......: " + cTimeProc 							)
		conout(" [MGFWSS10] URL..........................: " + cUrl									)
		conout(" [MGFWSS10] HTTP Method..................: " + "POST" 								)
		conout(" [MGFWSS10] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 		)
		conout(" [MGFWSS10] cJson........................: " + allTrim( cJson ) 					)
		conout(" [MGFWSS10] Retorno......................: " + allTrim( xPostRet ) 					)
		conout(" [MGFWSS10] * * * * * * * * * * * * * * * * * * * * "								)

		cQ := "UPDATE "
		cQ += RetSqlName("DUT")+" "
		cQ += "SET "
		if nStatuHttp >= 200 .and. nStatuHttp <= 299
			cQ += "DUT_ZINTTA = 'S' "
		Else
			cQ += "DUT_ZINTTA = 'E' "
		endif

		cQ += "WHERE R_E_C_N_O_ = " + Alltrim(Str((cAliasTrb)->DUT_RECNO))

		nRet := tcSqlExec(cQ)
		If nRet == 0
		Else
			ConOut("Problemas na gravação dos campos do cadastro de veiculo, para envio ao Taura.")
			Return()
		EndIf

		freeObj( oJson )

		(cAliasTrb)->(dbSkip())
	EndDo

	(cAliasTrb)->(dbCloseArea())

	Return()