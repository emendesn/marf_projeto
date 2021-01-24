#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*
	INTEGRACAO SALESFORCE
	CONTATOS
*/
//-------------------------------------------------------------------
// Para ser chamado em JOB
//-------------------------------------------------------------------
user function JOBWSC36( cFilJob )

	U_MGFWSC36( { "01" , cFilJob } )

return

//-------------------------------------------------------------------
// Para ser chamado em MENU
//-------------------------------------------------------------------
user function MNUWSC36()

	runInteg36()

return

//-------------------------------------------------------------------
user function MGFWSC36( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC36] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg36()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
static function runInteg36( )
	// MOCK - POST 		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}/contatos
	// MOCK - PUT  		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}/contatos/{id_codigo_c}
	// MOCK - DELETE	- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}/contatos/{id_codigo_c}
    local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC36A" , , "http://spdwvapl203:1337/experience-protheus/cliente/api/clientes/{id}/contatos/{id_codigo_c}" ) )
	local cURLUse		:= ""
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
	local cStaLog		:= "" // Codigo do Status da integração, devera ser 1 (Integrado) ou 2 (Erro)
	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2" , , "008" ) )//Cod. de busca na SZ2, Tabela de Integração
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC36C" , , "003" ) )//Cod. de busca na SZ3, Tabela Tipo de Integração

	local cHeadHttp		:= ""

	private oJson		:= nil

	conout("[SALESFORCE] - MGFWSC36- Selecionando contatos aptos a integrar com SALESFORCE")

	getSU5()

	while !QRYWSC36->(EOF())
		cIdInteg := ""
		cIdInteg := FWUUIDV4()

		aHeadStr := {}

		aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )
		aadd( aHeadStr , 'Content-Type: application/json'  )
		aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg   )

		oJson := nil
		oJson := JsonObject():new()

		setSU5()

		cURLUse	:= ""
		cJson	:= ""
		cJson	:= oJson:toJson()

		if !empty( cJson )
			cURLUse := strTran( cURLInteg , "{id}" , allTrim( QRYWSC36->AC8_CODENT ) )

			if !empty( QRYWSC36->U5_XIDSFOR )
				cURLUse		:= strTran( cURLUse , "{id_codigo_c}" , allTrim( QRYWSC36->U5_XIDSFOR ) )
				cHTTPMetho	:= "PUT"
			else
				cURLUse		:= strTran( cURLUse , "/{id_codigo_c}" , "" )
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

			conout(" [SALESFORCE] [MGFWSC36] * * * * * Status da integracao * * * * *"									)
			conout(" [SALESFORCE] [MGFWSC36] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC36] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC36] Tempo de Processamento.......: " + cTimeProc 								)
			conout(" [SALESFORCE] [MGFWSC36] URL..........................: " + cURLUse 								)
			conout(" [SALESFORCE] [MGFWSC36] HTTP Method..................: " + cHTTPMetho								)
			conout(" [SALESFORCE] [MGFWSC36] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
			conout(" [SALESFORCE] [MGFWSC36] Envio........................: " + cJson 									)
			conout(" [SALESFORCE] [MGFWSC36] Retorno......................: " + cHTTPRet 								)
			conout(" [SALESFORCE] [MGFWSC36] * * * * * * * * * * * * * * * * * * * * "									)

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
			    cStaLog  := "1"
				cErroLog := ""
				jHTTPRet := nil

				if fwJsonDeserialize( cHTTPRet, @jHTTPRet )
					//conout(" [SALESFORCE] [MGFWSC35] Retorno........................: " + jHTTPRet:mensagem )
				endif

				varInfo( "jHTTPRet" , jHTTPRet )

				if jHTTPRet:mensagem
					cUpdTbl	:= ""

					cUpdTbl := "UPDATE " + retSQLName("SU5")										+ CRLF
					cUpdTbl += "	SET"															+ CRLF
					cUpdTbl += " 		U5_XINTSFO = 'I'"											+ CRLF

					if cHTTPMetho == "POST"
						cUpdTbl += " , U5_XIDSFOR = '" + jHTTPRet:Id + "'"					    	+ CRLF
					endif

					cUpdTbl += " WHERE"																+ CRLF
					cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( QRYWSC36->SU5RECNO ) ) + ""	+ CRLF

					if tcSQLExec( cUpdTbl ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
						cErroLog := "Não foi possível executar UPDATE. " + tcSqlError()
						cStaLog  := "2" //Erro
					endif

				else
                	cErroLog := "Erro -Mensagem false e não retornou o Id Salesforce!"
					cStaLog := "2"//Erro
				endif

				freeObj( jHTTPRet )
			else
				cErroLog := "Erro -Integração retornou estatus Http diferente de sucesso!"
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
			" " /*cDocori*/	         ,;
			cTimeProc	/*cTempo*/	 ,;
			cJson /*cJSON*/		     ,;
			QRYWSC36->SU5RECNO /*nRecnoDoc*/,;
			cValToChar(nStatuHttp) /*cHTTP*/,;
			.F./*lJob*/		           ,;
			{}/*aFil*/		           ,;
			cIdInteg/*cUUID*/	      ,;
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

		QRYWSC36->(DBSkip())
	enddo

	QRYWSC36->(DBCloseArea())

	delClassINTF()
return

//-------------------------------------------------------------------
// Seleciona os clientes para exportação
//-------------------------------------------------------------------
static function getSU5()
	local cQryWSC36	:= ""
	local lFilPes	:= superGetMv( "MGFWSC34D" , , .T.) //Filtro para filtrar pessoa Juridica

	cQryWSC36 += " SELECT"														+ CRLF
	cQryWSC36 += " AC8_CODENT	,"												+ CRLF
	cQryWSC36 += " U5_CODCONT	,"												+ CRLF
	cQryWSC36 += " U5_CONTAT	,"												+ CRLF
	cQryWSC36 += " U5_CLIENTE	,"												+ CRLF
	cQryWSC36 += " U5_LOJA		,"												+ CRLF
	cQryWSC36 += " U5_DDD		, U5_CODPAIS ,"									+ CRLF
	cQryWSC36 += " U5_FCOM1		,"												+ CRLF
	cQryWSC36 += " U5_CELULAR	,"												+ CRLF
	cQryWSC36 += " U5_EMAIL		,"												+ CRLF
	cQryWSC36 += " U5_XIDSFOR	,"												+ CRLF
	cQryWSC36 += " U5_XDEPTO	,"												+ CRLF
	cQryWSC36 += " U5_XCARGO	,"												+ CRLF
	cQryWSC36 += " SU5.R_E_C_N_O_ SU5RECNO"										+ CRLF
	cQryWSC36 += " FROM "	+ retSQLName( "SU5" ) + " SU5"						+ CRLF

	cQryWSC36 += " INNER JOIN "	+ retSQLName( "AC8" ) + " AC8"					+ CRLF
	cQryWSC36 += " ON"															+ CRLF
	cQryWSC36 += " 		AC8.AC8_ENTIDA	=	'SA1'"								+ CRLF
	cQryWSC36 += " 	AND	AC8.AC8_CODCON	=	SU5.U5_CODCONT"						+ CRLF
	cQryWSC36 += "	AND	AC8.AC8_FILENT	=	'" + xFilial("AC8") + "'"			+ CRLF
	cQryWSC36 += "	AND	AC8.AC8_FILIAL	=	'" + xFilial("AC8") + "'"			+ CRLF
	cQryWSC36 += "	AND	AC8.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQryWSC36 += " INNER JOIN "	+ retSQLName( "SA1" ) + " SA1"						+ CRLF
	cQryWSC36 += " ON"																+ CRLF
	cQryWSC36 += " 		SA1.A1_XIDSFOR				<>	' '"						+ CRLF
	cQryWSC36 += " 	AND	SA1.A1_XINTSFO				=	'I'"						+ CRLF
	cQryWSC36 += " 	AND	SA1.A1_XENVSFO				=	'S'"						+ CRLF
	cQryWSC36 += " 	AND	SA1.A1_COD || SA1.A1_LOJA	=	AC8.AC8_CODENT"				+ CRLF
	cQryWSC36 += " 	AND	SA1.A1_FILIAL				=	'" + xFilial("SA1") + "'"	+ CRLF
	cQryWSC36 += " 	AND	SA1.D_E_L_E_T_				<>	'*'"						+ CRLF

	if lFilPes
		cQryWSC36 += "	AND	SA1.A1_PESSOA = 'J' "							        + CRLF
	endIf

	cQryWSC36 += " WHERE"														+ CRLF
	cQryWSC36 += " 		SU5.U5_XINTSFO	=	'P'"								+ CRLF
	cQryWSC36 += " 	AND	SU5.U5_FILIAL	=	'" + xFilial("SU5") + "'"			+ CRLF
	cQryWSC36 += " 	AND	SU5.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQryWSC36 += " ORDER BY AC8_CODENT"											+ CRLF

	conout( "[MGFWSC36] [SALESFORCE] " + cQryWSC36 )

	tcQuery cQryWSC36 New Alias "QRYWSC36"
return

//---------------------------------------------------------------------
// Carrega o cliente
//---------------------------------------------------------------------
static function setSU5()
	oJson["U5_CODCONT"	]	:= iif( !empty( QRYWSC36->U5_CODCONT	)	, allTrim( QRYWSC36->U5_CODCONT	)	, nil )

	oJson["U5_CONTAT"	]	:= iif( !empty( QRYWSC36->U5_CONTAT		)	, EncodeUtf8(allTrim( QRYWSC36->U5_CONTAT))							, nil )

	oJson["U5_CLIENTE"	]	:= iif( !empty( QRYWSC36->AC8_CODENT	)	, allTrim( QRYWSC36->AC8_CODENT	)	, nil )
	oJson["U5_LOJA"		]	:= iif( !empty( QRYWSC36->U5_LOJA		)	, allTrim( QRYWSC36->U5_LOJA	)	, nil )
	oJson["U5_DDD"		]	:= iif( !empty( QRYWSC36->U5_DDD		)	, allTrim( QRYWSC36->U5_DDD		)	, nil )
	oJson["U5_FCOM2"	]	:= iif( !empty( QRYWSC36->U5_FCOM1		)	, allTrim( QRYWSC36->U5_FCOM1	)	, nil )
	oJson["U5_CELULAR"	]	:= iif( !empty( QRYWSC36->U5_CELULAR	)	, allTrim( QRYWSC36->U5_CELULAR	)	, nil )
	oJson["U5_EMAIL"	]	:= iif( !empty( QRYWSC36->U5_EMAIL		)	, allTrim( QRYWSC36->U5_EMAIL	)	, nil )
	oJson["U5_XIDSFOR"	]	:= iif( !empty( QRYWSC36->U5_XIDSFOR	)	, allTrim( QRYWSC36->U5_XIDSFOR	)	, nil )
	oJson["U5_XDEPTO"	]	:= iif( !empty( QRYWSC36->U5_XDEPTO		)	, allTrim( QRYWSC36->U5_XDEPTO	)	, nil )
	oJson["U5_XCARGO"	]	:= iif( !empty( QRYWSC36->U5_XCARGO		)	, allTrim( QRYWSC36->U5_XCARGO	)	, nil )
	oJson["U5_XDDI"	]		:= iif( !empty( QRYWSC36->U5_CODPAIS	)	, allTrim( QRYWSC36->U5_CODPAIS	)	, nil )
return
