#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "APWEBEX.CH"
#include "APWEBSRV.CH"
#include 'DIRECTRY.CH'

#define CRLF chr(13) + chr(10)


/*/
{Protheus.doc} MGFEST73
Job para buscar as requisições que foram aprovadas pelo RH
@author Wagner Neves
@since 21/05/2020
/*/
User function MGFEST73(_nfast,_cfilial)

	Local cJob			:= ""	// Nome do semaforo que sera criado
	Local oLocker		:= Nil	// Objeto que ira criar um semaforo

	Private _aMatriz  	:= {"01","010001"}
	Private _lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"
	Private _lJob		:= .T.
	Default _nfast := "0" //Execução normal

	If _nfast == "1"

		_cmens := "fastlane"
	
	Else

		_cmens := "normal"

	Endif

	U_MFCONOUT('Inicio do processamento ' + _cmens + ' de verificação das requisições de EPI aprovadas pelo RH...'		)

	_aAreaSM0	:= SM0->(GetArea())
	
	SM0->(DbGoTop())
	
	While !SM0->(EOF()) .And. SM0->M0_CODIGO = _aMatriz[1]
		cEmpAnt 	:= SM0->M0_CODIGO
		cFilAnt 	:= SM0->M0_CODFIL

		MGFEST73E(_nfast)

		SM0->(DBSkip())
	EndDo
	
	SM0->(restArea(_aAreaSM0))

	U_MFCONOUT("Completou o processamento " + _cmens + " de  de verificação das aprovações de requisições de EPI." )


Return()

/*/
	===========================================================================================================================
	{Protheus.doc} MGFEST73E
	Aprovação da requisição de EPI
	@author Wagner Neves
	@since 08/05/2020
	@type Job
/*/  
Static function MGFEST73E(_nfast)
	

	If !cFilAnt $GetMv("MGF_EPIFIL") // Verifica se a filial está autorizada ao tratamento de EPI
		U_MFCONOUT("Esta filial não está habilitada para executar essa rotina-MGFEST73")
		Return
	ENDIF

	U_MFCONOUT("Selecionando requisições de EPI pendentes de aprovação pelo RH...")

	MGFEST73Q(_nfast) //Execução de query de produtos para envio de exportação

	If QRYSCP->(EOF())
		U_MFCONOUT("Não foram localizados requisições pendentes de aprovação!")
		QRYSCP->(DBCloseArea())
		Return
	Endif

	while !QRYSCP->(EOF())

		SCP->(Dbgoto(QRYSCP->REC))

		u_MGEST73I()

		QRYSCP->(DBSkip())
	
	enddo

	U_MFCONOUT("Completou a verificação das aprovações dos equipamentos de EPI junto ao RH")

	QRYSCP->(DBCloseArea())

return

/*/
===========================================================================================================================
{Protheus.doc} MGFEST73Q
Seleciona as requisições pendentes de aprovação pelo RH

@author Wagner Neves
@since 08/05/2020
@type Job
/*/  
static function MGFEST73Q(_nfast)

	Local _DataMin := dDatabase - superGetMv( "MGF_EPIPER" , , 360 )

	Local cQrySCP := ""
	cQrySCP := "SELECT "                                                            + CRLF
	cQrySCP += " R_E_C_N_O_ REC"                                                     + CRLF
	cQrySCP += " FROM "	+ RetSQLName("SCP") + " SCP"	    			            + CRLF
	cQrySCP += " WHERE "                                                            + CRLF
	cQrySCP += "    SCP.CP_FILIAL = '"+cFilAnt +"'"                    		        + CRLF

	cQrySCP += "    AND SCP.CP_ZSTATUS = '02'"                                      + CRLF
	cQrySCP += "    AND SCP.CP_ZMATFUN <> ' '  "                                     + CRLF
	
	//Execução normal (dias retroativos)
	If _nfast == "0"
		cQrySCP += "    AND SCP.CP_EMISSAO >= '"+DTOS(_DataMin)+"' "                    + CRLF
		cQrySCP += "    AND SCP.CP_EMISSAO < '"+DTOS(Date()-3)+"' "                    + CRLF
	Else
		//Execução faslane de requisições do dia anterior e do dia atual
		cQrySCP += "    AND SCP.CP_EMISSAO >= '"+DTOS(Date()-3)+"' "                    + CRLF
	Endif


	cQrySCP += "    AND SCP.D_E_L_E_T_ = ' '" + CRLF  
	
	If select("QRYSCP") > 0
		QRYSCP->(Dbclosearea())
	Endif
	                                    
	tcQuery cQrySCP New Alias "QRYSCP"

return

/*/
===========================================================================================================================
{Protheus.doc} MGEST73I
Recupera resposta do RH para SA posicionada

@author Wagner Neves
@since 08/05/2020
@type Job
/*/  
User Function MGEST73I(_lshow)

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
	Default _lshow := .F.

	If EMPTY(SCP->CP_ZMATFUN)
		If _lshow

			u_MGFmsg("SA não possui EPI!!!")

		Endif
		Return
	Endif

	_CUUID := FWUUIDV4() //Identificador único da integração

	_lcommit := .F.

	cUrlPostOri := allTrim( superGetMv( "MGF_EPIURH" , , "http://spdwvapl203:1685/epi/api/equipamento/individual?nroReqErp=" ) )

	cURLPost := cURLPostori
	cUrlPost += AllTrim( SCP->CP_NUM )
	cUrlPost += "&matricula="
	cUrlPost += AllTrim( SCP->CP_ZMATFUN )
	cUrlPost += "&codEquipSupr="
	cUrlPost += AllTrim( SCP->CP_PRODUTO )


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

	_CodeUnid	:=	SCP->CP_FILIAL
	_nNumReq	:=	 SCP->CP_NUM
	_NumItem	:= 	 SCP->CP_ITEM
	_CodeSupri 	:= 	SCP->CP_PRODUTO

	If nStatuHttp >= 200 .and. nStatuHttp <= 299 .and. fwJsonDeserialize(_cret, @_oObjRet)

		IF LEN(_OOBJRET) > 0
			_CodeSupri 	:= 	_OOBJRET[1]:CODEQUIPSUPR
			_MatFun		:=	_OOBJRET[1]:MATRICULA
		Else
			_CodeSupri 	:= 	SCP->CP_PRODUTO //_CODESUPRI
			_MatFun		:=	SCP->CP_ZMATFUN //_MATFUN
		EndIf

		IF LEN(_OOBJRET) > 0
			If _OOBJRET[1]:DATAASSIN <> NIL
				_Aprovacao	  :=  _OOBJRET[1]:DATAASSIN
				_cMensRetorno := "Requisição aprovada"+" - Data "+SUBS(_Aprovacao,1,10) + " - Hora "+Subs(_Aprovacao,12,8)
			else
				_cMensRetorno := "Requisição pendente de aprovação"
			ENDIF
		else
			_cMensRetorno := "Verifique situação da SA com SESMT"
		endif

	Elseif nStatuHttp >= 200 .and. nStatuHttp <= 299

		_cMensRetorno := "Verifique situação da SA com SESMT"

	Else

		_cMensRetorno := "Falha de comunicação com o RHE, por favor tente novamente em alguns minutos."	

	Endif
	
	
	If _lshow

		u_MGFmsg(_cMensRetorno)

	Endif

	//Grava log do retorno
	ZG8->(dbSetOrder(1))
	Reclock("ZG8",.T.)
	ZG8->ZG8_FILIAL		:= _CodeUnid
	ZG8->ZG8_DATA 		:= dDataBase
	ZG8->ZG8_HORA 		:= ctimeini
	ZG8->ZG8_USUENV		:= IIF(!_lshow,"Executado Via JOB",__cUserId+"-"+Alltrim(UsrFullName(__cUserId)))
	ZG8->ZG8_NUMSA 		:= _nNumReq 
	ZG8->ZG8_JASENV 	:= _cRet
	ZG8->ZG8_JASRET 	:= CVALTOCHAR(fwJsonDeserialize(_cret, @_oObjRet))
	ZG8->ZG8_STARET	 	:= _cMensRetorno
	ZG8->ZG8_URLPOS     := cUrlPost
	ZG8->ZG8_STAENV 	:= cValToChar(nStatuHttp)
	ZG8->ZG8_PROD		:= _CodeSupri
	ZG8->ZG8_TEMPO 		:= ctimeproc
	ZG8->(MsUnlock())

	IF nStatuHttp >= 200 .and. nStatuHttp <= 299 .and. fwJsonDeserialize(_cret, @_oObjRet) .and. LEN(_OOBJRET) > 0
		IF _OOBJRET[1]:DATAASSIN <> NIL
		
			If ALLTRIM(SCP->CP_FILIAL) == ALLTRIM(_CodeUnid) .AND. ALLTRIM(SCP->CP_NUM) == ALLTRIM(_nNumReq)

				RECLOCK("SCP",.F.)
				SCP->CP_ZSTATUS :=  '05'
				SCP->CP_STATSA := 'L'
				SCP->(Msunlock())

			ENDIF
		ENDIF
	ENDIF

Return

/*/
===========================================================================================================================
{Protheus.doc} MGEST73C
Chamada com barra de progresso para recuperar SA do RH

@author Wagner Neves
@since 08/05/2020
@type Job
/*/  
User Function MGEST73C()

	fwMsgRun(, {|| u_MGEST73I(.T.) }, "Comunicando com RHE", "Aguarde. Recuperando dados..." )

Return

/*/
===========================================================================================================================
{Protheus.doc} MGEST73D
Chamada com barra de progresso para enviar SA ao RH

@author Wagner Neves
@since 08/05/2020
@type Job
/*/  
User Function MGEST73D()

	fwMsgRun(, {|| u_MGEST73G(.T.) }, "Comunicando com RHE", "Aguarde. Enviando dados..." )

Return



/*/
===========================================================================================================================
{Protheus.doc} MGEST73I
Recupera resposta do RH para SA posicionada

@author Wagner Neves
@since 08/05/2020
@type Job
/*/  
User Function MGEST73G(_lshow)

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
	Default _lshow := .F.

	If EMPTY(SCP->CP_ZMATFUN)
		If _lshow

			u_MGFmsg("SA não possui EPI!!!")

		Endif
		Return
	Endif

	If alltrim(SCP->CP_ZSTATUS) != '02'
		If _lshow

			u_MGFmsg("SA não possui aprovação!!!")

		Endif
		Return
	Endif

	//POSICIONA ZG6
	lachou := .F.
	ZG6->(Dbsetorder(1)) //ZG6_FILIAL+ZG6_NUM+ZG6_ITEM
	
	If ZG6->(Dbseek(SCP->CP_FILIAL+SCP->CP_NUM+SCP->CP_ITEM))

		Do while SCP->CP_FILIAL+SCP->CP_NUM+SCP->CP_ITEM == ZG6->ZG6_FILIAL+ZG6->ZG6_NUM+ZG6->ZG6_ITEM

			If ZG6->ZG6_NIVEL = 'T' .AND. ZG6->ZG6_DATLIB > STOD('20010101') 
				_lachou := .T.
				Exit
			Endif

			ZG6->(Dbskip())

		EndDo

	Endif

	If _lachou

		u_MGEST72E(alltrim(SCP->CP_ZMATFUN)) //Envia SA para RHe

	Else

		u_MGFmsg("Não foi localizada autorização para a SA!!!")

	Endif

Return




