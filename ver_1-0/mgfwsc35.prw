#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )


/*
	INTEGRACAO SALESFORCE
	ENDEREÇOS DE ENTREGA
*/
//-------------------------------------------------------------------
// Para ser chamado em JOB
//-------------------------------------------------------------------
user function JOBWSC35( cFilJob )

	U_MGFWSC35( { "01" , cFilJob } )

return

//-------------------------------------------------------------------
// Para ser chamado em MENU
//-------------------------------------------------------------------
user function MNUWSC35()

	runInteg35()

return

//-------------------------------------------------------------------
user function MGFWSC35( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC35] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg35()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
static function runInteg35( )
	// MOCK - POST		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}/enderecos
	// MOCK - PUT		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}/enderecos/{id_endereco_c}
	// MOCK - DELETE	- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}/enderecos/{id_endereco_c}
	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC35A" , , "http://spdwvapl203:1337/experience-protheus/cliente/api/clientes/{id}/enderecos/{id_endereco_c}" ) )
	local cURLUse		:= ""
	local cHTTPMetho	:= ""
	local cUpdTbl		:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	local cHTTPRet		:= ""
	local jHTTPRet		:= nil
	//Variaveis dos logs
	local cErroLog      := "" // Texto do Erro ocorrido na integra??o.
	local cStaLog		:= "" // Codigo do Status da integracao, devera ser 1 (Integrado) ou 2 (Erro)
	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2" , , "008" ) )//Cod. de busca na SZ2, Tabela de Integra??o
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC35C" , , "002" ) )//Cod. de busca na SZ3, Tabela Tipo de Integ

	local cHeadHttp		:= ""

	private oJson		:= nil

	conout("[SALESFORCE] - MGFWSC35- Selecionando endereços aptos a integrar com SALESFORCE")

	getSZ9()

	while !QRYWSC35->( EOF() )
        cIdInteg := ""
		cIdInteg := FWUUIDV4()

		aHeadStr := {}

		aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )
		aadd( aHeadStr , 'Content-Type: application/json'  )
		aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg   )

		oJson := nil
		oJson := JsonObject():new()

		setSZ9()

		cURLUse	:= ""
		cJson	:= ""
		cJson	:= oJson:toJson()

		if !empty( cJson )
			cURLUse := strTran( cURLInteg , "{id}" , allTrim( QRYWSC35->Z9_ZCLIENT ) + allTrim( QRYWSC35->Z9_ZLOJA ) )

			if !empty( QRYWSC35->Z9_XIDSFOR )
				//cURLUse		:= strTran( cURLUse , "{id_endereco_c}" , allTrim( QRYWSC35->Z9_XIDSFOR ) )
				cURLUse		:= strTran( cURLUse , "{id_endereco_c}" , allTrim( QRYWSC35->Z9_ZIDEND ) )
				cHTTPMetho	:= "PUT"
			else
				cURLUse		:= strTran( cURLUse , "/{id_endereco_c}" , "" )
				cHTTPMetho	:= "POST"
			endif

			cTimeIni	:= time()
			cHeaderRet	:= ""
			cHTTPRet	:= ""
			cHTTPRet	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni , cTimeFin )
			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()

			conout(" [SALESFORCE] [MGFWSC35] * * * * * Status da integracao * * * * *"									)
			conout(" [SALESFORCE] [MGFWSC35] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC35] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC35] Tempo de Processamento.......: " + cTimeProc 								)
			conout(" [SALESFORCE] [MGFWSC35] URL..........................: " + cURLUse 								)
			conout(" [SALESFORCE] [MGFWSC35] HTTP Method..................: " + cHTTPMetho								)
			conout(" [SALESFORCE] [MGFWSC35] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
			conout(" [SALESFORCE] [MGFWSC35] Envio........................: " + cJson 									)
			conout(" [SALESFORCE] [MGFWSC35] Retorno......................: " + cHTTPRet 								)
			conout(" [SALESFORCE] [MGFWSC35] * * * * * * * * * * * * * * * * * * * * "									)

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				cStaLog  := "1"
				cErroLog := ""
				jHTTPRet := nil

				if fwJsonDeserialize( cHTTPRet, @jHTTPRet )
					//conout(" [SALESFORCE] [MGFWSC35] Retorno........................: " + jHTTPRet:mensagem )
				endif

				varInfo( "jHTTPRet" , jHTTPRet )

				// jHTTPRet := JsonObject():new()
				// jHTTPRet:fromJson( cHTTPRet )

				if jHTTPRet:mensagem
					cUpdTbl	:= ""
					cUpdTbl := "UPDATE " + retSQLName("SZ9")										+ CRLF
					cUpdTbl += "	SET"															+ CRLF
					cUpdTbl += " 		Z9_XINTSFO = 'I'"											+ CRLF

					if cHTTPMetho == "POST"
						cUpdTbl += " , Z9_XIDSFOR = '" + jHTTPRet:Id + "'"							+ CRLF
					endif

					cUpdTbl += " WHERE"																+ CRLF
					cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( QRYWSC35->SZ9RECNO ) ) + ""	+ CRLF

					if tcSQLExec( cUpdTbl ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
						cErroLog := "Não foi possível executar UPDATE. "+ tcSqlError()
						cStaLog  := "2" //Erro
					endif
				endif

				freeObj( jHTTPRet )
			else
			  cErroLog := "Erro - Integração retornou estatus Http diferente de sucesso!"
			  cStaLog := "2"//Erro
			endif

			cHeadHttp := ""

			for nI := 1 to len( aHeadStr )
				cHeadHttp += aHeadStr[ nI ]
			next

			//GRAVAR LOG
			U_MGFMONITOR(							 ;
			cFilAnt	/*cFil*/		        		,;
			cStaLog /*cStatus*/		        		,;
			cCodInteg /*cCodint Z1_INTEGRA*/		,;
			cCodTpInt /*cCodtpint Z1_TPINTEG*/  	,;
			Iif(EMPTY(cErroLog),"Processamento realizado com sucesso!",cErroLog) /*cErro*/,;
			" "/*cDocori*/		     ,;
			cTimeProc	/*cTempo*/	 ,;
			cJson /*cJSON*/		     ,;
			QRYWSC35->SZ9RECNO/*nRecnoDoc*/,;
			cValToChar(nStatuHttp) /*cHTTP*/,;
			.F./*lJob*/		           ,;
			{}/*aFil*/		           ,;
			cIdInteg /*cUUID*/	       ,;
			iif(TYPE(cHTTPRet) <> "U", cHTTPRet, " ")/*cJsonR*/,;
			"S"/*cTipWsInt*/           ,;
			" "/*cJsonCB /*Z1_JSONCB*/ ,;
			" "/*cJsonRB /*Z1_JSONRB*/ ,;
			sTod("    /  /  ") /*dDTCallb /*Z1_DTCALLB*/,;
			" "/*cHoraCall /*Z1_HRCALLB*/,;
			" "/*cCallBac /*Z1_CALLBAC*/,;
			cURLUse /*cLinkEnv /*Z1_LINKENV*/,;
			" "																				/*cLinkRec Z1_LINKREC*/							,;
			cIdInteg																		/*cHeaderID		Z1_HEADEID*/					,;
			cHeadHttp																		/*cHeadeHttp	Z1_HEADER*/						)

		endif

		freeObj( oJson )

		QRYWSC35->(DBSkip())
	enddo

	QRYWSC35->(DBCloseArea())

	delClassINTF()
return

//-------------------------------------------------------------------
// Seleciona os clientes para exportação
//-------------------------------------------------------------------
static function getSZ9()
	local cQryWSC35 := ""

	cQryWSC35 += " SELECT"														+ CRLF
	cQryWSC35 += " Z9_ZCLIENT		,"											+ CRLF
	cQryWSC35 += " Z9_ZLOJA			,"											+ CRLF
	cQryWSC35 += " Z9_ZCGC			,"											+ CRLF
	cQryWSC35 += " Z9_ZRAZEND		,"											+ CRLF
	cQryWSC35 += " Z9_ZENDER		,"											+ CRLF
	cQryWSC35 += " Z9_ZBAIRRO		,"											+ CRLF
	cQryWSC35 += " Z9_ZCEP			,"											+ CRLF
	cQryWSC35 += " Z9_ZEST			,"											+ CRLF
	cQryWSC35 += " Z9_ZCODMUN		,"											+ CRLF
	cQryWSC35 += " Z9_ZMUNIC		,"											+ CRLF
	cQryWSC35 += " Z9_ZIDEND		,"											+ CRLF
	cQryWSC35 += " Z9_XIDSFOR		,"											+ CRLF
	cQryWSC35 += " Z9_ZCOMPLE		,"											+ CRLF
	cQryWSC35 += " Z9_MSBLQL		,"											+ CRLF
	cQryWSC35 += " SZ9.R_E_C_N_O_ SZ9RECNO"										+ CRLF
	cQryWSC35 += " FROM "		+ retSQLName( "SZ9" ) + " SZ9"					+ CRLF

	cQryWSC35 += " INNER JOIN "	+ retSQLName( "SA1" ) + " SA1"					+ CRLF
	cQryWSC35 += " ON"															+ CRLF
	cQryWSC35 += " 		SA1.A1_XIDSFOR	<>	' '"								+ CRLF
	cQryWSC35 += " 	AND	SA1.A1_XINTSFO	=	'I'"								+ CRLF
	cQryWSC35 += " 	AND	SA1.A1_XENVSFO	=	'S'"								+ CRLF
	cQryWSC35 += " 	AND	SA1.A1_LOJA		=	SZ9.Z9_ZLOJA"						+ CRLF
	cQryWSC35 += " 	AND	SA1.A1_COD		=	SZ9.Z9_ZCLIENT"						+ CRLF
	cQryWSC35 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"			+ CRLF
	cQryWSC35 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQryWSC35 += " WHERE"														+ CRLF
	cQryWSC35 += " 		SZ9.Z9_XINTSFO	=	'P'"								+ CRLF
	cQryWSC35 += " 	AND	SZ9.Z9_FILIAL	=	'" + xFilial("SZ9") + "'"			+ CRLF
	cQryWSC35 += " 	AND	SZ9.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQryWSC35 += " ORDER BY Z9_ZCLIENT, Z9_ZLOJA"								+ CRLF

	conout( "[MGFWSC35] [SALESFORCE] " + cQryWSC35 )

	tcQuery cQryWSC35 New Alias "QRYWSC35"
return

//---------------------------------------------------------------------
// Carrega o cliente
//---------------------------------------------------------------------
static function setSZ9()
	oJson["Z9_ZCLIENT"]		:= iif( !empty( QRYWSC35->Z9_ZCLIENT	)	, allTrim( QRYWSC35->Z9_ZCLIENT ) + allTrim( QRYWSC35->Z9_ZLOJA )	, nil )
	oJson["Z9_ZCGC"]		:= iif( !empty( QRYWSC35->Z9_ZCGC		)	, allTrim( QRYWSC35->Z9_ZCGC		)								, nil )
	oJson["Z9_ZRAZEND"]		:= iif( !empty( QRYWSC35->Z9_ZRAZEND	)	, allTrim( QRYWSC35->Z9_ZRAZEND		)								, nil )
	oJson["Z9_ZENDER"]		:= iif( !empty( QRYWSC35->Z9_ZENDER		)	, allTrim( QRYWSC35->Z9_ZENDER		)								, nil )
	oJson["Z9_ZBAIRRO"]		:= iif( !empty( QRYWSC35->Z9_ZBAIRRO	)	, allTrim( QRYWSC35->Z9_ZBAIRRO		)								, nil )
	oJson["Z9_ZCEP"]		:= iif( !empty( QRYWSC35->Z9_ZCEP		)	, allTrim( QRYWSC35->Z9_ZCEP		)								, nil )
	oJson["Z9_ZEST"]		:= iif( !empty( QRYWSC35->Z9_ZEST		)	, allTrim( QRYWSC35->Z9_ZEST		)								, nil )
	oJson["Z9_ZCODMUN"]		:= iif( !empty( QRYWSC35->Z9_ZCODMUN	)	, allTrim( QRYWSC35->Z9_ZCODMUN		)								, nil )
	oJson["Z9_ZMUNIC"]		:= iif( !empty( QRYWSC35->Z9_ZMUNIC		)	, allTrim( QRYWSC35->Z9_ZMUNIC		)								, nil )
	oJson["Z9_ZIDEND"]		:= iif( !empty( QRYWSC35->Z9_ZIDEND		)	, allTrim( QRYWSC35->Z9_ZIDEND		)								, nil )
	oJson["Z9_XIDSFOR"]		:= iif( !empty( QRYWSC35->Z9_XIDSFOR	)	, allTrim( QRYWSC35->Z9_XIDSFOR		)								, nil )
	oJson["Z9_ZCOMPLE"]		:= iif( !empty( QRYWSC35->Z9_ZCOMPLE	)	, allTrim( QRYWSC35->Z9_ZCOMPLE		)								, nil )
	oJson["Z9_MSBLQL"]		:= iif( QRYWSC35->Z9_MSBLQL == "1"	, .T. , .F. )
return
