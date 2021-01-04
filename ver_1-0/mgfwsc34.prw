#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} JOBWSC34
Integração de Clientes com Salesforce - Para ser chamado em JOB
@description
Integração de Clientes com Salesforce - Para ser chamado em JOB
@author TOTVS
@since 06/09/2019
@type Function
@table
 SA1 - Clientes
@param
 cFilJob - Caracter informa a filial que será usada
@return
 Sem retorno
@menu
 Sem menu
/*/
user function JOBWSC34( cFilJob )

	U_MGFWSC34( { "01" , cFilJob } )

return

/*/
=============================================================================
{Protheus.doc} MNUWSC34
Integração de Clientes com Salesforce - Para ser chamado em MENU
@description
Integração de Clientes com Salesforce - Para ser chamado em MENU
@author TOTVS
@since 06/09/2019
@type Function
@table
 SA1 - Clientes
@param
 Sem parametro
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MNUWSC34()

	runInteg34()

return

/*/
=============================================================================
{Protheus.doc} MGFWSC34
Integração de Clientes com Salesforce - Preparação de Ambiente
@description
Integração de Clientes com Salesforce - Preparação de Ambiente
@author TOTVS
@since 06/09/2019
@type Function
@table
 SA1 - Clientes
@param
 aEmpX - Array com Empresa e Filial que serão configuradas
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MGFWSC34( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC34] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg34()

	RESET ENVIRONMENT
return

/*/
=============================================================================
{Protheus.doc} runInteg34
Integração de Clientes com Salesforce
@description
Integração de Clientes com Salesforce
@author TOTVS
@since 06/09/2019
@type Function
@table
 SA1 - Clientes
@param
cCnpjCli - Caracter - CNPJ do cliente que será integrado, opcional
@return
 Sem retorno
@menu
 Sem menu
/*/
static function runInteg34( cCnpjCli )
	// MOCK - POST		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes
	// MOCK - PUT		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}
	// MOCK - DELETE	- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}

	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC34A" , , "http://spdwvapl203:1337/experience-protheus/cliente/api/clientes/{id}" ) )
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
	local aAreaX		:= getArea()
	local aAreaSA1		:= SA1->( getArea() )
	local nI			:= 0
	local nQtdMemo		:= 0
	local xRetHttp		:= nil

    //Variaveis dos logs
	local cErroLog      := "" // Texto do Erro ocorrido na integração
    local cStaLog		:= "" // Codigo do Status da integração, devera ser 1 (Integrado) ou 2 (Erro)
	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2" , , "008" ) )//Cod. de busca na SZ2, Tabela de Integração
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC34C" , , "001" ) )//Cod. de busca na SZ3, Tabela Tipo de Integração

	local cHeadHttp		:= ""

	private oJson		:= nil

	default cCnpjCli	:= ""

	conout("[SALESFORCE] - MGFWSC34- Selecionando clientes aptos a integrar com SALESFORCE")

	DBSelectArea( "SA1" )

	getSA1( cCnpjCli )

	while !QRYWSC34->(EOF())
		cIdInteg := ""
		cIdInteg := FWUUIDV4()

		aHeadStr := {}

		aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )
		aadd( aHeadStr , 'Content-Type: application/json'  )
		aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg   )

		oJson := nil
		oJson := JsonObject():new()

		setSA1()

		cJson	:= ""
		cJson	:= oJson:toJson()

		if !empty( cJson )
			cURLUse		:= ""

			if !empty( QRYWSC34->A1_XIDSFOR )
				cURLUse		:= strTran( cURLInteg , "{id}" , allTrim( QRYWSC34->A1_XIDSFOR ) )
				cHTTPMetho	:= "PUT"
			else
				cURLUse		:= strTran( cURLInteg , "/{id}" , "" )
				cHTTPMetho	:= "POST"
			endif

			cTimeIni	:= time()
			cHeaderRet	:= ""
			xRetHttp	:= nil
			xRetHttp	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni , cTimeFin )
			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()

			conout(" [SALESFORCE] [MGFWSC34] * * * * * Status da integracao * * * * *"									)
			conout(" [SALESFORCE] [MGFWSC34] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC34] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC34] Tempo de Processamento.......: " + cTimeProc 								)
			conout(" [SALESFORCE] [MGFWSC34] URL..........................: " + cURLUse 								)
			conout(" [SALESFORCE] [MGFWSC34] HTTP Method..................: " + cHTTPMetho								)
			conout(" [SALESFORCE] [MGFWSC34] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
			conout(" [SALESFORCE] [MGFWSC34] Envio........................: " + cJson 									)
			conout(" [SALESFORCE] [MGFWSC34] * * * * * * * * * * * * * * * * * * * * "									)

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				cStaLog  := "1"
				cErroLog := ""
				cUpdTbl	 := ""

				cUpdTbl := "UPDATE " + retSQLName("SA1")										+ CRLF
				cUpdTbl += "	SET"															+ CRLF
				cUpdTbl += " 		A1_XINTSFO = 'A'"											+ CRLF
				cUpdTbl += " WHERE"																+ CRLF
				cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( QRYWSC34->SA1RECNO ) ) + ""	+ CRLF

				if tcSQLExec( cUpdTbl ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					cErroLog := "Não foi possível executar UPDATE. "+ tcSqlError()
					cStaLog  := "2" //Erro
				endif

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
			" " /*cDocori*/		     ,;
			cTimeProc	/*cTempo*/	 ,;
			cJson /*cJSON*/		     ,;
			QRYWSC34->SA1RECNO/*nRecnoDoc*/,;
			cValToChar(nStatuHttp) /*cHTTP*/,;
			.F./*lJob*/		           ,;
			{}/*aFil*/		           ,;
			cIdInteg /*cUUID*/	       ,;
			iif(TYPE(xRetHttp) <> "U", xRetHttp, " ")/*cJsonR*/,;
			"A"/*cTipWsInt*/           ,;
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

		QRYWSC34->(DBSkip())
	enddo

	QRYWSC34->(DBCloseArea())

	restArea( aAreaSA1 )
	restArea( aAreaX )

	delClassINTF()
return

/*/
=============================================================================
{Protheus.doc} getSA1
Seleciona os clientes para exportação
@description
Seleciona os clientes para exportação
@author TOTVS
@since 06/09/2019
@type Function
@table
 SA1 - Clientes
@param
cCnpjCli - Caracter - CNPJ do cliente, opcional
@return
 Sem retorno
@menu
 Sem menu
/*/
static function getSA1( cCnpjCli )
	local cQryWSC34 := ""
	local lFilPes := superGetMv( "MGFWSC34D" , , .T.) //Filtro para filtrar pessoa Juridica

	cQryWSC34 += " SELECT"															+ CRLF
	cQryWSC34 += " A1_TIPO					,"										+ CRLF
	cQryWSC34 += " A1_PESSOA				,"										+ CRLF
	cQryWSC34 += " A1_NATUREZ				,"										+ CRLF
	cQryWSC34 += " A1_CONTA					,"										+ CRLF
	cQryWSC34 += " A1_TIPCLI				,"										+ CRLF
	cQryWSC34 += " A1_CODPAIS				,"										+ CRLF
	cQryWSC34 += " A1_GRPTRIB				,"										+ CRLF
	cQryWSC34 += " A1_TPESSOA				,"										+ CRLF
	cQryWSC34 += " A1_PAIS					,"										+ CRLF
	cQryWSC34 += " A1_XIDSFOR				,"										+ CRLF
	cQryWSC34 += " A1_FILIAL				,"										+ CRLF
	cQryWSC34 += " A1_COD					,"										+ CRLF
	cQryWSC34 += " A1_LOJA					,"										+ CRLF
	cQryWSC34 += " A1_NOME					,"										+ CRLF
	cQryWSC34 += " A1_NREDUZ				,"										+ CRLF
	cQryWSC34 += " A1_CGC					,"										+ CRLF
	cQryWSC34 += " A1_CEP					,"										+ CRLF
	cQryWSC34 += " A1_END					,"										+ CRLF
	cQryWSC34 += " A1_COMPLEM				,"										+ CRLF
	cQryWSC34 += " A1_EST					,"										+ CRLF

	cQryWSC34 += " ("																+ CRLF
	cQryWSC34 += "		SELECT ZBJ_REPRES"											+ CRLF
	cQryWSC34 += "		FROM " + retSQLName( "ZBJ" ) + " ZBJ"						+ CRLF
	cQryWSC34 += "		WHERE"														+ CRLF
	cQryWSC34 += "			ZBJ.ZBJ_REPRES  = SA1.A1_VEND"							+ CRLF
	cQryWSC34 += "		AND	ZBJ.ZBJ_CLIENT  = SA1.A1_COD"							+ CRLF
	cQryWSC34 += "		AND ZBJ.ZBJ_LOJA    = SA1.A1_LOJA"							+ CRLF
	cQryWSC34 += "		AND ZBJ.ZBJ_FILIAL  = '" + xFilial("ZBJ") + "'"				+ CRLF
	cQryWSC34 += "		AND ZBJ.D_E_L_E_T_  = ' '"									+ CRLF
	cQryWSC34 += "		AND ROWNUM			= 1"									+ CRLF
	cQryWSC34 += " ) A1_VEND ,"														+ CRLF

	cQryWSC34 += " A1_COD_MUN				,"										+ CRLF
	cQryWSC34 += " A1_DDD					,"										+ CRLF
	cQryWSC34 += " A1_BAIRRO				,"										+ CRLF
	cQryWSC34 += " A1_DDI					,"										+ CRLF
	cQryWSC34 += " A1_TEL					,"										+ CRLF
	cQryWSC34 += " A1_EMAIL					,"										+ CRLF
	cQryWSC34 += " A1_CONTATO				,"										+ CRLF
	cQryWSC34 += " A1_ZSUGELC				,"										+ CRLF
	cQryWSC34 += " A1_ZSUGPRZ				,"										+ CRLF
	cQryWSC34 += " A1_CEPC					,"										+ CRLF
	cQryWSC34 += " A1_ENDCOB				,"										+ CRLF
	cQryWSC34 += " A1_ESTC					,"										+ CRLF
	cQryWSC34 += " A1_MUNC					,"										+ CRLF
	cQryWSC34 += " A1_BAIRROC				,"										+ CRLF
	cQryWSC34 += " A1_XMAILCO				,"										+ CRLF
	cQryWSC34 += " A1_XCOMPCO				,"										+ CRLF
	cQryWSC34 += " A1_XCDMUNC				,"										+ CRLF
	cQryWSC34 += " A1_INSCR					,"										+ CRLF
	cQryWSC34 += " A1_CNAE					,"										+ CRLF
	cQryWSC34 += " A1_DTNASC				,"										+ CRLF
	cQryWSC34 += " A1_SIMPNAC				,"										+ CRLF
	cQryWSC34 += " A1_MSBLQL 				,"										+ CRLF
	cQryWSC34 += " A1_ZINATIV				,"										+ CRLF
	cQryWSC34 += " A1_XPENFIN				,"										+ CRLF
	cQryWSC34 += " A1_SIMPLES				,"										+ CRLF
	cQryWSC34 += " A1_SATIV1				,"										+ CRLF
	cQryWSC34 += " A1_SATIV2				,"										+ CRLF
	cQryWSC34 += " A1_SATIV3				,"										+ CRLF

	cQryWSC34 += " A1_XTELCOB				,"										+ CRLF
	cQryWSC34 += " A1_LC					,"										+ CRLF
	cQryWSC34 += " A1_VENCLC				,"										+ CRLF
	cQryWSC34 += " A1_COND					,"										+ CRLF
	cQryWSC34 += " ZF5_DESCRI A1_XORIGEM	,"										+ CRLF

	cQryWSC34 += " ZE9.ZE9_TIPOLO TIPOLOGIA	,"										+ CRLF
	cQryWSC34 += " ZE9.ZE9_CATEGO CATEGORIA	,"										+ CRLF
	cQryWSC34 += " ZE9.ZE9_CANAL CANAL		,"										+ CRLF

	cQryWSC34 += " A1_ZREDE					,"										+ CRLF
	cQryWSC34 += " A1_ZBOLETO				,"										+ CRLF
	cQryWSC34 += " A1_ZGDERED				,"										+ CRLF

	cQryWSC34 += " A1_ZVIDAUT				,"										+ CRLF

	cQryWSC34 += " ZQ_DESCR					,"										+ CRLF
	//cQryWSC34 += " UTL_RAW.CAST_TO_VARCHAR2( A1_ZALTCRE ) A1_ZALTCRE				,"	+ CRLF

	cQryWSC34 += " SA1.R_E_C_N_O_ SA1RECNO"											+ CRLF
	cQryWSC34 += " FROM "		+ retSQLName( "SA1" ) + " SA1"						+ CRLF

	cQryWSC34 += " LEFT JOIN "	+ retSQLName( "ZE9" ) + " ZE9"						+ CRLF
	cQryWSC34 += " ON"																+ CRLF
	cQryWSC34 += " 		ZE9.ZE9_TIPOLO	=	SA1.A1_SATIV1"							+ CRLF
	cQryWSC34 += " 	AND	ZE9.ZE9_CATEGO	=	SA1.A1_SATIV2"							+ CRLF
	cQryWSC34 += " 	AND	ZE9.ZE9_CANAL	=	SA1.A1_SATIV3"							+ CRLF
	cQryWSC34 += " 	AND ZE9.ZE9_FILIAL	=	'" + xFilial( "ZE9" ) + "'"				+ CRLF
	cQryWSC34 += " 	AND ZE9.D_E_L_E_T_	<>	'*'"									+ CRLF

	cQryWSC34 += " LEFT JOIN "	+ retSQLName( "ZF5" ) + " ZF5"						+ CRLF
	cQryWSC34 += " ON"																+ CRLF
	cQryWSC34 += " 		SA1.A1_XORIGEM	=	ZF5.ZF5_CODIGO"							+ CRLF
	cQryWSC34 += " 	AND ZF5.ZF5_FILIAL	=	'" + xFilial( "ZF5" ) + "'"				+ CRLF
	cQryWSC34 += " 	AND ZF5.D_E_L_E_T_	<>	'*'"									+ CRLF

	cQryWSC34 += " LEFT JOIN "	+ retSQLName( "SZQ" ) + " SZQ"						+ CRLF
	cQryWSC34 += " ON"																+ CRLF
	cQryWSC34 += " 		SA1.A1_ZREDE	=	SZQ.ZQ_COD"							    + CRLF
	cQryWSC34 += " 	AND SZQ.ZQ_FILIAL	=	'" + xFilial( "SZQ" ) + "'"				+ CRLF
	cQryWSC34 += " 	AND SZQ.D_E_L_E_T_	<>	'*'"									+ CRLF

	cQryWSC34 += " WHERE "															+ CRLF
	cQryWSC34 += "  SA1.D_E_L_E_T_	<>	'*'"									    + CRLF
	cQryWSC34 += " 	AND	SA1.A1_XINTSFO	=	'P'"									+ CRLF // Integrado SALESFORCE	-> 0=Nao;1=Sim
	cQryWSC34 += " 	AND	SA1.A1_XENVSFO	=	'S'"									+ CRLF // Envia SALESFORCE		-> 0=Nao;1=Sim
	cQryWSC34 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"				+ CRLF
	cQryWSC34 += " 	AND	SA1.A1_EST	<>	'EX' "								        + CRLF

	if lFilPes
		cQryWSC34 += "	AND	SA1.A1_PESSOA = 'J' "							        + CRLF
	endIf

	if !empty( cCnpjCli )
		cQryWSC34 += " 	AND	SA1.A1_CGC = '" + cCnpjCli + "'"						+ CRLF
	endif

	cQryWSC34 += " ORDER BY A1_COD, A1_LOJA"										+ CRLF

	conout("[MGFWSC34] [SALESFORCE] " + cQryWSC34)

	tcQuery cQryWSC34 New Alias "QRYWSC34"
return

/*/
=============================================================================
{Protheus.doc} setSA1
Carrega objeto JSON
@description
Carrega objeto JSON
@author TOTVS
@since 06/09/2019
@type Function
@table
 SA1 - Clientes
@param
 Sem parâmetro
@return
 Sem retorno
@menu
 Sem menu
/*/
static function setSA1()
	oJson["IDPROTHEUS"	]	:= iif( !empty( QRYWSC34->A1_COD		)	, allTrim( QRYWSC34->A1_COD		) + allTrim( QRYWSC34->A1_LOJA	)	, nil )
	oJson["A1_TIPO"		]	:= iif( !empty( QRYWSC34->A1_TIPO		)	, allTrim( QRYWSC34->A1_TIPO	)									, nil )
	oJson["A1_PESSOA"	]	:= iif( !empty( QRYWSC34->A1_PESSOA		)	, allTrim( QRYWSC34->A1_PESSOA	)									, nil )
	oJson["A1_NATUREZ"	]	:= iif( !empty( QRYWSC34->A1_NATUREZ	)	, allTrim( QRYWSC34->A1_NATUREZ	)									, nil )
	oJson["A1_CONTA"	]	:= iif( !empty( QRYWSC34->A1_CONTA		)	, allTrim( QRYWSC34->A1_CONTA	)									, nil )
	oJson["A1_TIPCLI"	]	:= iif( !empty( QRYWSC34->A1_TIPCLI		)	, allTrim( QRYWSC34->A1_TIPCLI	)									, nil )
	oJson["A1_CODPAIS"	]	:= iif( !empty( QRYWSC34->A1_CODPAIS	)	, allTrim( QRYWSC34->A1_CODPAIS	)									, nil )
	oJson["A1_GRPTRIB"	]	:= iif( !empty( QRYWSC34->A1_GRPTRIB	)	, allTrim( QRYWSC34->A1_GRPTRIB	)									, nil )
	oJson["A1_TPESSOA"	]	:= iif( !empty( QRYWSC34->A1_TPESSOA	)	, allTrim( QRYWSC34->A1_TPESSOA	)									, nil )
	oJson["A1_PAIS"		]	:= iif( !empty( QRYWSC34->A1_PAIS		)	, allTrim( QRYWSC34->A1_PAIS	)									, nil )
	oJson["A1_XIDSFOR"	]	:= iif( !empty( QRYWSC34->A1_XIDSFOR	)	, allTrim( QRYWSC34->A1_XIDSFOR	)									, nil )
	oJson["A1_FILIAL"	]	:= iif( !empty( QRYWSC34->A1_FILIAL		)	, allTrim( QRYWSC34->A1_FILIAL	)									, nil )
	oJson["A1_COD"		]	:= iif( !empty( QRYWSC34->A1_COD		)	, allTrim( QRYWSC34->A1_COD		)									, nil )
	oJson["A1_LOJA"		]	:= iif( !empty( QRYWSC34->A1_LOJA		)	, allTrim( QRYWSC34->A1_LOJA	)									, nil )
	oJson["A1_NOME"		]	:= iif( !empty( QRYWSC34->A1_NOME		)	, EncodeUtf8(allTrim( QRYWSC34->A1_NOME))							, nil )
	oJson["A1_NREDUZ"	]	:= iif( !empty( QRYWSC34->A1_NREDUZ		)	, EncodeUtf8(allTrim( QRYWSC34->A1_NREDUZ))							, nil )
	oJson["A1_CGC"		]	:= iif( !empty( QRYWSC34->A1_CGC		)	, allTrim( QRYWSC34->A1_CGC		)									, nil )
	oJson["A1_VEND"		]	:= iif( !empty( QRYWSC34->A1_VEND		)	, allTrim( QRYWSC34->A1_VEND	)									, nil )
	oJson["A1_DDD"		]	:= iif( !empty( QRYWSC34->A1_DDD		)	, allTrim( QRYWSC34->A1_DDD		)									, nil )
	oJson["A1_DDI"		]	:= iif( !empty( QRYWSC34->A1_DDI		)	, allTrim( QRYWSC34->A1_DDI		)									, nil )
	oJson["A1_TEL"		]	:= iif( !empty( QRYWSC34->A1_TEL		)	, allTrim( QRYWSC34->A1_TEL		)									, nil )
	oJson["A1_EMAIL"	]	:= iif( !empty( QRYWSC34->A1_EMAIL		)	, allTrim( QRYWSC34->A1_EMAIL	)									, nil )
	oJson["A1_ZSUGELC"	]	:= iif( !empty( QRYWSC34->A1_ZSUGELC	)	, allTrim( QRYWSC34->A1_ZSUGELC	)									, nil )
	oJson["A1_ZSUGPRZ"	]	:= iif( !empty( QRYWSC34->A1_ZSUGPRZ	)	, allTrim( QRYWSC34->A1_ZSUGPRZ	)									, nil )
	oJson["A1_INSCR"	]	:= iif( !empty( QRYWSC34->A1_INSCR		)	, allTrim( QRYWSC34->A1_INSCR	)									, nil )
	oJson["A1_CNAE"		]	:= iif( !empty( QRYWSC34->A1_CNAE		)	, allTrim( QRYWSC34->A1_CNAE	)									, nil )
	oJson["A1_DTNASC"	]	:= iif( !empty( QRYWSC34->A1_DTNASC		)	, allTrim( QRYWSC34->A1_DTNASC	)									, nil )
	oJson["A1_SIMPNAC"	]	:= iif( !empty( QRYWSC34->A1_SIMPNAC	)	, allTrim( QRYWSC34->A1_SIMPNAC	)									, nil )
	oJson["A1_SIMPLES"	]	:= iif( !empty( QRYWSC34->A1_SIMPLES	)	, allTrim( QRYWSC34->A1_SIMPLES	)									, nil )
	oJson["A1_SATIV1"	]	:= iif( !empty( QRYWSC34->A1_SATIV1		)	, allTrim( QRYWSC34->A1_SATIV1	)									, nil )
	oJson["A1_SATIV2"	]	:= iif( !empty( QRYWSC34->A1_SATIV2		)	, allTrim( QRYWSC34->A1_SATIV2	)									, nil )
	oJson["A1_SATIV3"	]	:= iif( !empty( QRYWSC34->A1_SATIV3		)	, allTrim( QRYWSC34->A1_SATIV3	)									, nil )
	oJson["TIPOLOGIA"	]	:= iif( !empty( QRYWSC34->TIPOLOGIA		)	, allTrim( QRYWSC34->TIPOLOGIA	)									, nil )
	oJson["CATEGORIA"	]	:= iif( !empty( QRYWSC34->CATEGORIA		)	, allTrim( QRYWSC34->CATEGORIA	)									, nil )
	oJson["CANAL"	]		:= iif( !empty( QRYWSC34->CANAL			)	, allTrim( QRYWSC34->CANAL		)									, nil )
	oJson["A1_XORIGEM"	]	:= iif( !empty( QRYWSC34->A1_XORIGEM	)	, allTrim( QRYWSC34->A1_XORIGEM	)									, nil )
	oJson["A1_VENCLC"	]	:= iif( !empty( QRYWSC34->A1_VENCLC		)	, allTrim( QRYWSC34->A1_VENCLC	)									, nil )
	oJson["A1_COND"	]		:= iif( !empty( QRYWSC34->A1_COND		)	, allTrim( QRYWSC34->A1_COND	)									, nil )

	oJson["A1_ZREDE"	]	:= iif( !empty( QRYWSC34->A1_ZREDE		)	, allTrim( QRYWSC34->A1_ZREDE	)									, nil )
	oJson["ZQ_DESCR"	]	:= iif( !empty( QRYWSC34->ZQ_DESCR		)	, EncodeUtf8(allTrim( QRYWSC34->ZQ_DESCR))							, nil )
	oJson["A1_ZBOLETO"	]	:= iif( !empty( QRYWSC34->A1_ZBOLETO	)	, allTrim( QRYWSC34->A1_ZBOLETO	)									, nil )
	oJson["A1_ZGDERED"	]	:= iif( !empty( QRYWSC34->A1_ZGDERED	)	, allTrim( QRYWSC34->A1_ZGDERED	)									, nil )

	oJson["A1_ZVIDAUT"	]	:= iif( !empty( QRYWSC34->A1_ZVIDAUT	)	, QRYWSC34->A1_ZVIDAUT												, nil )

	//oJson["A1_ZALTCRE"	]	:= iif( !empty( QRYWSC34->A1_ZALTCRE	)	, allTrim( QRYWSC34->A1_ZALTCRE	)									, nil )
	oJson["A1_ZALTCRE"	]	:= ""

	SA1->( DBGoTo( QRYWSC34->SA1RECNO ) )

	if !empty( SA1->A1_ZALTCRE )
		nQtdMemo := mlCount( SA1->A1_ZALTCRE )

		for nI :=1 to nQtdMemo
			oJson["A1_ZALTCRE"] += encodeUTF8( memoLine( SA1->A1_ZALTCRE , , nI ) )
		next
	endif

	oJson["A1_LC"	]		:= QRYWSC34->A1_LC

	oJson["A1_MSBLQL"	]	:= iif( QRYWSC34->A1_MSBLQL		== "1"	, .T. , .F. )
	oJson["A1_XPENFIN"	]	:= iif( QRYWSC34->A1_XPENFIN	== "S"	, .T. , .F. )
	oJson["A1_ZINATIV"	]	:= iif( QRYWSC34->A1_ZINATIV	== "1"	, .T. , .F. )
	oJson["REATIVACAO"	]	:= .F.

	// DESCONTO CONTRATO
	getDesc( QRYWSC34->A1_COND , QRYWSC34->A1_COD , QRYWSC34->A1_LOJA )

	// COBRANCA
	oJsonCobra 					:= nil
	oJsonCobra 					:= JsonObject():new()
	oJsonCobra["A1_CEPC"	]	:= iif( !empty( QRYWSC34->A1_CEPC		)	, allTrim( QRYWSC34->A1_CEPC	)	, nil )
	oJsonCobra["A1_ENDCOB"	]	:= iif( !empty( QRYWSC34->A1_ENDCOB		)	, EncodeUtf8(allTrim( QRYWSC34->A1_ENDCOB))	, nil )
	oJsonCobra["A1_ESTC"	]	:= iif( !empty( QRYWSC34->A1_ESTC		)	, allTrim( QRYWSC34->A1_ESTC	)	, nil )
	oJsonCobra["A1_MUNC"	]	:= iif( !empty( QRYWSC34->A1_MUNC		)	, allTrim( QRYWSC34->A1_MUNC	)	, nil )
	oJsonCobra["A1_BAIRROC"	]	:= iif( !empty( QRYWSC34->A1_BAIRROC	)	, allTrim( QRYWSC34->A1_BAIRROC	)	, nil )
	oJsonCobra["A1_XMAILCO"	]	:= iif( !empty( QRYWSC34->A1_XMAILCO	)	, allTrim( QRYWSC34->A1_XMAILCO	)	, nil )
	oJsonCobra["A1_XCOMPCO"	]	:= iif( !empty( QRYWSC34->A1_XCOMPCO	)	, allTrim( QRYWSC34->A1_XCOMPCO	)	, nil )
	oJsonCobra["A1_XCDMUNC"	]	:= iif( !empty( QRYWSC34->A1_XCDMUNC	)	, allTrim( QRYWSC34->A1_XCDMUNC	)	, nil )
	oJsonCobra["A1_CONTATO"	]	:= iif( !empty( QRYWSC34->A1_CONTATO	)	, allTrim( QRYWSC34->A1_CONTATO	)	, nil )
	oJsonCobra["A1_XTELCOB"	]	:= iif( !empty( QRYWSC34->A1_XTELCOB	)	, allTrim( QRYWSC34->A1_XTELCOB	)	, nil )
	oJson["COBRANCA"] 			:= oJsonCobra
	// FIM - COBRANCA
	// ENDERECO PRINCIPAL
	oJsonEnder 					:= nil
	oJsonEnder 					:= JsonObject():new()
	oJsonEnder["A1_CEP"		]	:= iif( !empty( QRYWSC34->A1_CEP		)	, allTrim( QRYWSC34->A1_CEP		)	        , nil )
	oJsonEnder["A1_END"		]	:= iif( !empty( QRYWSC34->A1_END		)	, EncodeUtf8(allTrim( QRYWSC34->A1_END))	, nil )
	oJsonEnder["A1_COMPLEM"	]	:= iif( !empty( QRYWSC34->A1_COMPLEM	)	, EncodeUtf8(allTrim( QRYWSC34->A1_COMPLEM)), nil )
	oJsonEnder["A1_EST"		]	:= iif( !empty( QRYWSC34->A1_EST		)	, allTrim( QRYWSC34->A1_EST		)	        , nil )
	oJsonEnder["A1_COD_MUN"	]	:= iif( !empty( QRYWSC34->A1_COD_MUN	)	, allTrim( QRYWSC34->A1_COD_MUN	)	        , nil )
	oJsonEnder["A1_BAIRRO"	]	:= iif( !empty( QRYWSC34->A1_BAIRRO		)	, allTrim( QRYWSC34->A1_BAIRRO	)	        , nil )
	oJson["ENDERECOPRINCIPAL"] 	:= oJsonEnder
	// FIM - ENDERECO PRINCIPAL
return

/*/
==============================================================================================================================================================================
{Protheus.doc} getDesc()
Rotina de retorno do Desconto
@type function
@author Rogerio Almeida
@since 10/02/2020
@version P12
/*/
static function getDesc( condPg , codigo , loja )
	local cAlias	:= GetNextAlias()
	local cQryDes	:= ""
	local nDesc		:= 0
	local _xcFil	:= Alltrim(GetMV('MGF_CT09FI',.F.,"010001"))

	cQryDes := " SELECT CN9_ZTOTDE, CN9_DTINIC , CN9_DTFIM"							+ CRLF
	cQryDes += " FROM"																+ CRLF
	cQryDes += " ("																	+ CRLF
	cQryDes += "	SELECT MAX( CN9_ZTOTDE ) CN9_ZTOTDE , CN9_DTINIC , CN9_DTFIM"	+ CRLF
	cQryDes += "	FROM "			+ retSQLName("CN9") + " CN9"					+ CRLF
	cQryDes += "	INNER JOIN "	+ retSQLName("CNA") + " CNA"					+ CRLF
	cQryDes += "	ON"																+ CRLF
	cQryDes += "		CNA.CNA_CLIENT	=	'" + codigo	+ "'	AND"				+ CRLF
	cQryDes += "		CNA.CNA_LOJACL	=	'" + loja	+ "'	AND"				+ CRLF
	cQryDes += "		CNA.CNA_FILIAL	=	'" + _xcFil + "'	AND"				+ CRLF
	cQryDes += "	 	CNA.CNA_CONTRA	=	CN9.CN9_NUMERO		AND"				+ CRLF
	cQryDes += "		CNA.CNA_REVISA	=	CN9.CN9_REVISA		AND"				+ CRLF
	cQryDes += "		CNA.D_E_L_E_T_	<>	'*'"									+ CRLF
	cQryDes += "	WHERE"															+ CRLF
	cQryDes += "		CN9.CN9_ESPCTR	=	'2'					AND"				+ CRLF // 1=Compra;2=Venda
	cQryDes += "		CN9.CN9_ZTOTDE	>	0					AND"				+ CRLF
	cQryDes += "		CN9.CN9_FILIAL	=	'" + _xcFil	+ "'	AND"				+ CRLF
	cQryDes += "		CN9.CN9_CONDPG	=	'" + condPg	+ "'	AND"				+ CRLF
	cQryDes += "		CN9.CN9_SITUAC	=	'05'				AND"				+ CRLF
	cQryDes += "		CN9.D_E_L_E_T_	<>	'*'"									+ CRLF
	cQryDes += "	GROUP BY CN9_DTINIC , CN9_DTFIM"								+ CRLF
	cQryDes += "	ORDER BY CN9_ZTOTDE DESC"										+ CRLF
	cQryDes += " )"																	+ CRLF
	cQryDes += " WHERE ROWNUM = 1"													+ CRLF

	conout("[MGFWSC34] [GETDESC] [SALESFORCE] " + cQryDes )

	tcQuery cQryDes alias &cAlias new

	if !( cAlias )->( EOF() )
		oJson['CN9_ZTOTDE']	:= ( cAlias )->CN9_ZTOTDE
		oJson['CN9_DTINIC']	:= left( fwTimeStamp( 3 , sToD( ( cAlias )->CN9_DTINIC	) ) , 10 )
		oJson['CN9_DTFIM']	:= left( fwTimeStamp( 3 , sToD( ( cAlias )->CN9_DTFIM	) ) , 10 )
	else
		oJson['CN9_ZTOTDE']	:= 0
		oJson['CN9_DTINIC']	:= ""
		oJson['CN9_DTFIM']	:= ""
	endif

	( cAlias )->( DBCloseArea() )

return nDesc