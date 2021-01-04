#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include 'DIRECTRY.CH'

/*/
{Protheus.doc} MGFEST73
Job para buscar as requisições que foram aprovadas pelo RH
Não estava processando as demais filiais. 
Problema corrigido.

@description
Este Job irá retornar as aprovações das requsições de EPI que foram aprovadas pelo RH
Exemplo de como montar o JOB:
;
	[OnStart]
jobs=MGFEST73,...,....,...,...
RefreshRate=300
;
	[MGFEST73]
Environment=HML/PROD
Main=U_MGFEST73

@author Wagner Neves
@since 21/05/2020

@version P12.1.017
@country Brasil
@language Português

@type Function
@table

@param
@return

@menu
@history
/*/
#define CRLF chr(13) + chr(10)

User function MGFEST73()

	Local cJob			:= ""	// Nome do semaforo que sera criado
	Local oLocker		:= Nil	// Objeto que ira criar um semaforo

	Private _aMatriz  	:= {"01","010001"}
	Private _lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"
	Private _lJob		:= .T.

	U_MFCONOUT('Inicio do processamento verificação das requisições de EPI aprovadas pelo RH...'		)

	RpcSetType(3)
	RpcSetEnv(_aMatriz[1],_aMatriz[2])

	cJob := "MGFEST73"
	oLocker := LJCGlobalLocker():New()

	If !oLocker:GetLock( cJob )
		U_MFCONOUT("JOB já em Execução: MGFEST73 " + DTOC(dDataBase) + " - " + TIME() )
		RpcClearEnv()
		Return
	EndIf

	EST73A()

	U_MFCONOUT("Completou o processamento de verificação das aprovações de requisições de EPI." )

	oLocker:ReleaseLock( cJob )
	RpcClearEnv()


Return()

/*/
	{Protheus.doc} JOBEST73
	Iniciaizador do JOB em tela, monitorando as mensagens.

	@author Wagner Neves
	@since 21/05/2020

	@type Function
	@param
	@return
/*/
User Function JOBEST73()
	Private oFont1  := TFont():New("MS Sans Serif",,014,,.T.,,,,,.F.,.F.)
	Private oFont2  := TFont():New("MS Sans Serif",,012,,.T.,,,,,.F.,.F.)
	DEFINE MSDIALOG Dlg_ExtExec TITLE "Aprovações RH" From 000, 000  TO 620, 1350 PIXEL
	Public _cMemLog := ""
	Public oMemLog
	oSInfCli:= tSay():New(020,007,{||"MONITOR DE MENSAGENS"},Dlg_ExtExec,,oFont1,,,,.T.,CLR_HBLUE,,200,20)
	oButton := tButton():New(007,520,"Executar"	,Dlg_ExtExec, {|| EST73A() 			} ,65,17,,oFont2,,.T.)
	oButton := tButton():New(007,600,"Sair"		,Dlg_ExtExec, {|| Dlg_ExtExec:End()	} ,65,17,,oFont2,,.T.)
	@ 30,05 GET oMemLog VAR _cMemLog MEMO SIZE 665,270 OF Dlg_ExtExec PIXEL
	oMemLog:lReadOnly := .T.
	ACTIVATE MSDIALOG Dlg_ExtExec CENTERED
Return

/*/
	{Protheus.doc} EST73A
	Inicializando processos para barras de processamento.
	@author Wagner Neves
	@since 21/05/2020
	@type Function
	@param
	@return
/*/
Static Function EST73A()
	Local _aAreaSM0	:= SM0->(GetArea())
	Private oProcess
	If _lJob
		SM0->(DbGoTop())
		While !SM0->(EOF()) .And. SM0->M0_CODIGO = _aMatriz[1]
			cEmpAnt 	:= SM0->M0_CODIGO
			cFilAnt 	:= SM0->M0_CODFIL
			MGFEST72E()
			SM0->(DBSkip())
		EndDo
		SM0->(restArea(_aAreaSM0))
		oProcess := MsNewProcess():New( { || MGFEST72E() } , "Verificando aprovações das requisições de EPI no RH" , "Aguarde..." , .F. )
		oProcess:Activate()
	EndIf
Return

/*/
	===========================================================================================================================
	{Protheus.doc} MGFEST72E
	Aprovação da requisição de EPI
	@author Wagner Neves
	@since 08/05/2020
	@type Job
/*/  
Static function MGFEST72E()
	local cURLUse		:= ""
	local oInteg		:= nil
	local cUpdTbl		:= ""
	local nTotalSB1		:= 0
	local nCountSB1		:= 0

	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpMetho	:= ""

	If !cFilAnt $GetMv("MGF_EPIFIL") // Verifica se a filial está autorizada ao tratamento de EPI
		//MsgAlert("Esta filial não está habilitada para executar essa rotina-MGFEST73","MGF_EPIFIL")
		Return
	ENDIF

	aadd( aHeadStr, 'Content-Type: application/json')

	U_MFCONOUT("Selecionando requisições de EPI pendentes de aprovação pelo RH...")

	MGFEST72Q() //Execução de query de produtos para envio de exportação

	If QRYSCP->(EOF())
		U_MFCONOUT("Não foram localizados requisições pendentes de aprovação!")
		QRYSCP->(DBCloseArea())
		Return
	Endif

	nCountSCP	:= 1
	nTotalSCP	:= 0
	Count to nTotalSCP

	QRYSCP->(DBGoTop())

	while !QRYSCP->(EOF())

		_CUUID := FWUUIDV4() //Identificador único da integração

		_lcommit := .F.

		cUrlPostOri := allTrim( superGetMv( "MGF_EPIURH" , , "http://spdwvapl203:1685/epi/api/equipamento/individual?nroReqErp=" ) )

		cURLPost := cURLPostori
		cUrlPost += AllTrim( QRYSCP->CP_NUM )
		cUrlPost += "&matricula="
		cUrlPost += AllTrim( QRYSCP->CP_ZMATFUN )
		cUrlPost += "&codEquipSupr="
		cUrlPost += AllTrim( QRYSCP->CP_PRODUTO )

		cTimeIni	:= time()
		cHeaderRet	:= ""
		aHeadStr := {}
		aadd( aHeadStr, 'Content-Type: application/json')
		_cret := httpQuote( cURLPost /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, "" /*[cPOSTParms]*/, 120 /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

		nStatuHttp	:= httpGetStatus()
		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )

		conout(" [MGFEST73] * * * * * Status da integracao * * * * *")
		conout(" [MGFEST73] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
		conout(" [MGFEST73] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
		conout(" [MGFEST73] Tempo de Processamento.......: " + cTimeProc)
		conout(" [MGFEST73] URL..........................: " + cURLPost)
		conout(" [MGFEST73] HTTP Method..................: " + "GET")
		conout(" [MGFEST73] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
		conout(" [MGFEST73] Retorno........................: " + _cret)
		conout(" [MGFEST73] * * * * * * * * * * * * * * * * * * * * ")
		_oObjRet := nil
		fwJsonDeserialize(_cret, @_oObjRet)
		_nNumReq	:=	 QRYSCP->CP_NUM
		_NumItem	:= 	 QRYSCP->CP_ITEM
		IF LEN(_OOBJRET) > 0
			_CodeSupri 	:= 	_OOBJRET[nCountSCP]:CODEQUIPSUPR
			_CodeUnid	:=	_OOBJRET[nCountSCP]:CODUNIDADE
			_MatFun		:=	_OOBJRET[nCountSCP]:MATRICULA
		Else
			_CodeSupri 	:= 	QRYSCP->CP_PRODUTO //_CODESUPRI
			_CodeUnid	:=	QRYSCP->CP_FILIAL //_CODEUNID
			_MatFun		:=	QRYSCP->CP_ZMATFUN //_MATFUN
		EndIf
		IF LEN(_OOBJRET) > 0
			If _OOBJRET[nCountSCP]:DATAASSIN <> NIL
				_Aprovacao	  :=  _OOBJRET[nCountSCP]:DATAASSIN
				_cMensRetorno := "Requisição aprovada"+" - Data "+SUBS(_Aprovacao,1,10) + " - Hora "+Subs(_Aprovacao,12,8)
			else
				_cMensRetorno := "Requisição pendente de aprovação"
			ENDIF
		else
			_cMensRetorno := "Retorno veio vazio"
		endif

		//Grava log do retorno
		ZG8->(dbSetOrder(1))
		Reclock("ZG8",.T.)
		ZG8->ZG8_FILIAL		:= _CodeUnid
		ZG8->ZG8_DATA 		:= dDataBase
		ZG8->ZG8_HORA 		:= ctimeini
		ZG8->ZG8_USUENV		:= IIF(_lJob,"Executado Via JOB",cUserId+"-"+Alltrim(UsrFullName(__cUserId)))
		ZG8->ZG8_NUMSA 		:= _nNumReq //+"-"+_NumItem
		ZG8->ZG8_JASENV 	:= _cRet
		ZG8->ZG8_JASRET 	:= CVALTOCHAR(fwJsonDeserialize(_cret, @_oObjRet))
		ZG8->ZG8_STARET	 	:= _cMensRetorno
		ZG8->ZG8_URLPOS     := cUrlPost
		ZG8->ZG8_STAENV 	:= cValToChar(nStatuHttp)
		ZG8->ZG8_PROD		:= _CodeSupri
		ZG8->ZG8_TEMPO 		:= ctimeproc
		ZG8->(MsUnlock())

		IF LEN(_OOBJRET) > 0
			IF _OOBJRET[nCountSCP]:DATAASSIN <> NIL
				cQryEst73A := "UPDATE " + RetSqlName("SCP")  		            +CRLF
				cQryEst73A += "SET CP_ZSTATUS   = '05',CP_STATSA='L'" 			+CRLF
				cQryEst73A += " WHERE CP_NUM  	=	'" + _nNumReq+"'"       	+CRLF
				cQryEst73A += " AND CP_PRODUTO 	=	'" + _CodeSupri+"'"      	+CRLF
				cQryEst73A += " AND CP_ITEM 	=	'" + _NumItem+"'" 	     	+CRLF
				cQryEst73A += " AND CP_ZSTATUS  = '02'" 						+CRLF
				cQryEst73A += "	AND CP_FILIAL	=	'" + _CodeUnid + "'"  		+CRLF
				cQryEst73A += "	AND D_E_L_E_T_ = ' ' "
				IF (TcSQLExec(cQryEst73A) < 0)
					bContinua   := .F.
					MsgStop(TcSQLError())
				ENDIF
			ENDIF
		ENDIF
		QRYSCP->(DBSkip())
	enddo

	U_MFCONOUT("Completou a verificação das aprovações dos equipamentos de EPI junto ao RH")

	QRYSCP->(DBCloseArea())

return

/*/
	===========================================================================================================================
	{Protheus.doc} MGFEST72Q
	Seleciona as requisições pendentes de aprovação pelo RH

	@author Wagner Neves
	@since 08/05/2020
	@type Job
/*/  
static function MGFEST72Q()

	Local _DataMin := dDatabase - superGetMv( "MGF_EPIPER" , , 360 )

	Local cQrySCP := ""
	cQrySCP := "SELECT "                                                            + CRLF
	cQrySCP += " CP_FILIAL,"                                                        + CRLF
	cQrySCP += " CP_NUM,"                                                           + CRLF
	cQrySCP += " CP_ITEM,"                                                          + CRLF
	cQrySCP += " CP_PRODUTO,"                                                       + CRLF
	cQrySCP += " CP_DESCRI,"                                                        + CRLF
	cQrySCP += " CP_ZMATFUN,"                                                       + CRLF
	cQrySCP += " CP_ZSTATUS"                                                        + CRLF
	cQrySCP += " FROM "	+ RetSQLName("SCP") + " SCP"	    			            + CRLF
	cQrySCP += " WHERE "                                                            + CRLF
	cQrySCP += "    SCP.CP_FILIAL = '"+cFilAnt +"'"                    		        + CRLF

	//xFilial("SCP")+"'"                           + CRLF
	cQrySCP += "    AND SCP.CP_ZSTATUS = '02'"                                      + CRLF
	cQrySCP += "    AND SCP.CP_ZMATFUN <> ' '"                                      + CRLF
	cQrySCP += "    AND SCP.CP_EMISSAO >= '"+DTOS(_DataMin)+"' "                    + CRLF
	cQrySCP += "    AND SCP.D_E_L_E_T_ = ' '"                                       + CRLF
	tcQuery cQrySCP New Alias "QRYSCP"

return

