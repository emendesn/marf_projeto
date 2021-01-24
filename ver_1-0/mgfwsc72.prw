#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} JOBWSC72
Integração de Hierarquia de Vendas vs Vendedor
@description
Integração de Hierarquia de Vendas vs Vendedor
@author TOTVS
@since 06/09/2019
@type Function
@table
 ZBI - Roteiro
 SA3 - Vendedor
@param
 cFilJob - Caracter informa a filial que será usada
@return
 Sem retorno
@menu
 Sem menu
/*/
user function JOBWSC72( cFilJob )

	U_MGFWSC72( { "01" , cFilJob } )

return

/*/
=============================================================================
{Protheus.doc} MNUWSC72
Integração de Hierarquia de Vendas vs Vendedor - Para ser chamado em MENU
@description
Integração de Hierarquia de Vendas vs Vendedor - Para ser chamado em MENU
@author TOTVS
@since 06/09/2019
@type Function
@table
 ZBI - Roteiro
 SA3 - Vendedor
@param
 Sem parametro
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MNUWSC72()

	runInteg72()

return

/*/
=============================================================================
{Protheus.doc} MGFWSC72
Integração de Hierarquia de Vendas vs Vendedor - Preparação de Ambiente
@description
Integração de Hierarquia de Vendas vs Vendedor - Preparação de Ambiente
@author TOTVS
@since 06/09/2019
@type Function
@table
 ZBI - Roteiro
 SA3 - Vendedor
@param
 aEmpX - Array com Empresa e Filial que serão configuradas
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MGFWSC72( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC72] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg72()

	RESET ENVIRONMENT
return

/*/
=============================================================================
{Protheus.doc} runInteg72
Integração de Hierarquia de Vendas vs Vendedor
@description
Integração de Hierarquia de Vendas vs Vendedor
@author TOTVS
@since 06/09/2019
@type Function
@table
 ZBI - Roteiro
 SA3 - Vendedor
@param
cCnpjCli - Caracter - CNPJ do cliente que será integrado, opcional
@return
 Sem retorno
@menu
 Sem menu
/*/
static function runInteg72()
	// MOCK - POST		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes
	// MOCK - PUT		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}
	// MOCK - DELETE	- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}

	//local cURLInteg		:= allTrim( superGetMv( "MGFWSC72A" , , "https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}" ) )
	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC72A" , , "http://spdwvapl203:1337/experience/protheus/hierarquia-vendas/api/v1/vendedores/{id}" ) )
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
	local xRetHttp		:= nil
	local oJsonRet		:= nil
	local nI			:= 0
	local cStaLog		:= ""

	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2"	, , "008" ) ) // SZ2 - SISTEMA
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC72B"		, , "012" ) ) // SZ3 - ENTIDADE

	local cHeadHttp		:= ""

	private oJson		:= nil

	conout("[SALESFORCE] - MGFWSC72- Selecionando vendedores aptos a integrar com SALESFORCE")

	getVendedo()

	while !QRYWSC72->( EOF() )
        cIdInteg	:= ""
		cIdInteg	:= fwUUIDv4()

		aHeadStr := {}

		aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )
		aadd( aHeadStr , 'Content-Type: application/json'  )
		aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg   )

		cIDSalesfo := ""
		cIDSalesfo := getIDSfor( QRYWSC72->NIVEL , QRYWSC72->VENDEDOR )

		if !empty( cIDSalesfo )
			oJson := nil
			oJson := JsonObject():new()

			oJson['ID_PAPEL_EXTERNO'] := cIDSalesfo

			cJson	:= ""
			cJson	:= oJson:toJson()

			//	{
			//		"ID_PAPEL_EXTERNO": "00E1D000000ghRKUAY"
			//	}

			if !empty( cJson )
				cStaLog		:= ""
				cURLUse		:= ""

				cURLUse		:= strTran( cURLInteg , "{id}" , allTrim( QRYWSC72->VENDEDOR ) )
				cHTTPMetho	:= "PATCH"

				cTimeIni	:= time()
				cHeaderRet	:= ""
				xRetHttp	:= nil
				xRetHttp	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
				cTimeFin	:= time()
				cTimeProc	:= elapTime( cTimeIni , cTimeFin )
				nStatuHttp	:= 0
				nStatuHttp	:= httpGetStatus()

				conout(" [SALESFORCE] [MGFWSC72] * * * * * Status da integracao * * * * *"									)
				conout(" [SALESFORCE] [MGFWSC72] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
				conout(" [SALESFORCE] [MGFWSC72] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
				conout(" [SALESFORCE] [MGFWSC72] Tempo de Processamento.......: " + cTimeProc 								)
				conout(" [SALESFORCE] [MGFWSC72] URL..........................: " + cURLUse 								)
				conout(" [SALESFORCE] [MGFWSC72] HTTP Method..................: " + cHTTPMetho								)
				conout(" [SALESFORCE] [MGFWSC72] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
				conout(" [SALESFORCE] [MGFWSC72] Envio........................: " + cJson 									)
				conout(" [SALESFORCE] [MGFWSC72] * * * * * * * * * * * * * * * * * * * * "									)

				if nStatuHttp >= 200 .and. nStatuHttp <= 299
					/*
					[
						{
							"sucesso": true,
							"operacao": "UPDATED",
							"erros": []
						}
					]
					*/

					oJsonRet := nil

					if fwJsonDeserialize( xRetHttp, @oJsonRet )
						conout( xRetHttp )

						for nI := 1 to len( oJsonRet )
							if oJsonRet[ nI ]:sucesso
								cStaLog := "1"

								cUpdTbl	:= ""

								cUpdTbl := "UPDATE " + retSQLName("SA3")							+ CRLF
								cUpdTbl += "	SET"												+ CRLF
								cUpdTbl += " 		A3_XINTSFO = 'I'"								+ CRLF
								cUpdTbl += " WHERE"													+ CRLF
								cUpdTbl += " 		A3_COD = " + allTrim( QRYWSC72->VENDEDOR ) + ""	+ CRLF

								if tcSQLExec( cUpdTbl ) < 0
									conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
								endif
							else
								cStaLog := "2"
							endif
						next
					else
						cStaLog := "2"
					endif
				endif

				cHeadHttp := ""

				for nI := 1 to len( aHeadStr )
					cHeadHttp += aHeadStr[ nI ]
				next

				//GRAVAR LOG
				U_MGFMONITOR(							 ;
				cFilAnt																										/*cFil*/		        	,;
				cStaLog																										/*cStatus*/		        	,;
				cCodInteg																									/*cCodint Z1_INTEGRA*/		,;
				cCodTpInt																									/*cCodtpint Z1_TPINTEG*/  	,;
				iif( ( cStaLog == "1" ) , "Processamento realizado com sucesso!" , xRetHttp )								/*cErro*/					,;
				" "																											/*cDocori*/				     ,;
				cTimeProc																									/*cTempo*/	 ,;
				cJson 																										/*cJSON*/		     ,;
				0																											/*nRecnoDoc*/,;
				cValToChar( nStatuHttp )																					/*cHTTP*/,;
				.F.																											/*lJob*/		           ,;
				{}																											/*aFil*/		           ,;
				cIdInteg																									/*cUUID*/	       ,;
				iif( type( xRetHttp ) <> "U" , xRetHttp , " " )																/*cJsonR*/,;
				"S"																											/*cTipWsInt*/           ,;
				" "																											/*cJsonCB Z1_JSONCB*/ ,;
				" "																											/*cJsonRB Z1_JSONRB*/ ,;
				sTod("//")																									/*dDTCallb Z1_DTCALLB*/,;
				" "																											/*cHoraCall Z1_HRCALLB*/,;
				" "																											/*cCallBac Z1_CALLBAC*/,;
				cURLUse																										/*cLinkEnv Z1_LINKENV*/,;
				" "																				/*cLinkRec Z1_LINKREC*/							,;
				cIdInteg																		/*cHeaderID		Z1_HEADEID*/					,;
				cHeadHttp																		/*cHeadeHttp	Z1_HEADER*/						)
			endif

			freeObj( oJsonRet )
			freeObj( oJson )
		endif

		QRYWSC72->(DBSkip())
	enddo

	QRYWSC72->(DBCloseArea())

	delClassINTF()
return

/*/
=============================================================================
{Protheus.doc} getVendedo
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
static function getVendedo()
	local cQryWSC72 := ""

	cQryWSC72 += "SELECT MIN(NIVEL) NIVEL , VENDEDOR"						+ CRLF
	cQryWSC72 += " FROM"													+ CRLF
	cQryWSC72 += " ("														+ CRLF
	cQryWSC72 += "	SELECT 1 NIVEL, ZBD_REPRES VENDEDOR"					+ CRLF
	cQryWSC72 += "	FROM		" + retSQLName( "ZBD" ) + " ZBD"			+ CRLF
	cQryWSC72 += "	INNER JOIN	" + retSQLName( "SA3" ) + " SA3"			+ CRLF
	cQryWSC72 += "	ON"														+ CRLF
	cQryWSC72 += "			SA3.A3_COD      =   ZBD.ZBD_REPRES"				+ CRLF
	cQryWSC72 += "		AND SA3.A3_FILIAL   =   '" + xFilial("ZBD") + "'"	+ CRLF
	cQryWSC72 += "		AND SA3.D_E_L_E_T_  =   ' '"						+ CRLF
	cQryWSC72 += "		AND SA3.A3_XINTSFO	=	'P'"						+ CRLF
	cQryWSC72 += "	WHERE"													+ CRLF
	cQryWSC72 += "			ZBD.ZBD_FILIAL  =   '" + xFilial("ZBI") + "'"	+ CRLF
	cQryWSC72 += "		AND ZBD.D_E_L_E_T_  =   ' '"						+ CRLF

	cQryWSC72 += "	UNION ALL"												+ CRLF

	cQryWSC72 += "	SELECT 2 NIVEL, ZBE_REPRES VENDEDOR"					+ CRLF
	cQryWSC72 += "	FROM		" + retSQLName( "ZBE" ) + " ZBE"			+ CRLF
	cQryWSC72 += "	INNER JOIN	" + retSQLName( "SA3" ) + " SA3"			+ CRLF
	cQryWSC72 += "	ON"														+ CRLF
	cQryWSC72 += "			SA3.A3_COD      =   ZBE.ZBE_REPRES"				+ CRLF
	cQryWSC72 += "		AND SA3.A3_FILIAL   =   '" + xFilial("ZBE") + "'"	+ CRLF
	cQryWSC72 += "		AND SA3.D_E_L_E_T_  =   ' '"						+ CRLF
	cQryWSC72 += "		AND SA3.A3_XINTSFO	=	'P'"						+ CRLF
	cQryWSC72 += "	WHERE"													+ CRLF
	cQryWSC72 += "			ZBE.ZBE_FILIAL  =   '" + xFilial("ZBI") + "'"	+ CRLF
	cQryWSC72 += "		AND ZBE.D_E_L_E_T_  =   ' '"						+ CRLF

	cQryWSC72 += "	UNION ALL"												+ CRLF

	cQryWSC72 += "	SELECT 3 NIVEL, ZBF_REPRES VENDEDOR"					+ CRLF
	cQryWSC72 += "	FROM		" + retSQLName( "ZBF" ) + " ZBF"			+ CRLF
	cQryWSC72 += "	INNER JOIN	" + retSQLName( "SA3" ) + " SA3"			+ CRLF
	cQryWSC72 += "	ON"														+ CRLF
	cQryWSC72 += "			SA3.A3_COD      =   ZBF.ZBF_REPRES"				+ CRLF
	cQryWSC72 += "		AND SA3.A3_FILIAL   =   '" + xFilial("ZBF") + "'"	+ CRLF
	cQryWSC72 += "		AND SA3.D_E_L_E_T_  =   ' '"						+ CRLF
	cQryWSC72 += "		AND SA3.A3_XINTSFO	=	'P'"						+ CRLF
	cQryWSC72 += "	WHERE"													+ CRLF
	cQryWSC72 += "			ZBF.ZBF_FILIAL  =   '" + xFilial("ZBI") + "'"	+ CRLF
	cQryWSC72 += "		AND ZBF.D_E_L_E_T_  =   ' '"						+ CRLF

	cQryWSC72 += "	UNION ALL"												+ CRLF

	cQryWSC72 += "	SELECT 4 NIVEL, ZBG_REPRES VENDEDOR"					+ CRLF
	cQryWSC72 += "	FROM		" + retSQLName( "ZBG" ) + " ZBG"			+ CRLF
	cQryWSC72 += "	INNER JOIN	" + retSQLName( "SA3" ) + " SA3"			+ CRLF
	cQryWSC72 += "	ON"														+ CRLF
	cQryWSC72 += "			SA3.A3_COD      =   ZBG.ZBG_REPRES"				+ CRLF
	cQryWSC72 += "		AND SA3.A3_FILIAL   =   '" + xFilial("ZBG") + "'"	+ CRLF
	cQryWSC72 += "		AND SA3.D_E_L_E_T_  =   ' '"						+ CRLF
	cQryWSC72 += "		AND SA3.A3_XINTSFO	=	'P'"						+ CRLF
	cQryWSC72 += "	WHERE"													+ CRLF
	cQryWSC72 += "			ZBG.ZBG_FILIAL  =   '" + xFilial("ZBI") + "'"	+ CRLF
	cQryWSC72 += "		AND ZBG.D_E_L_E_T_  =   ' '"						+ CRLF

	cQryWSC72 += "	UNION ALL"												+ CRLF

	cQryWSC72 += "	SELECT 5 NIVEL, ZBH_REPRES VENDEDOR"					+ CRLF
	cQryWSC72 += "	FROM		" + retSQLName( "ZBH" ) + " ZBH"			+ CRLF
	cQryWSC72 += "	INNER JOIN	" + retSQLName( "SA3" ) + " SA3"			+ CRLF
	cQryWSC72 += "	ON"														+ CRLF
	cQryWSC72 += "			SA3.A3_COD      =   ZBH.ZBH_REPRES"				+ CRLF
	cQryWSC72 += "		AND SA3.A3_FILIAL   =   '" + xFilial("ZBH") + "'"	+ CRLF
	cQryWSC72 += "		AND SA3.D_E_L_E_T_  =   ' '"						+ CRLF
	cQryWSC72 += "		AND SA3.A3_XINTSFO	=	'P'"						+ CRLF
	cQryWSC72 += "	WHERE"													+ CRLF
	cQryWSC72 += "			ZBH.ZBH_FILIAL  =   '" + xFilial("ZBI") + "'"	+ CRLF
	cQryWSC72 += "		AND ZBH.D_E_L_E_T_  =   ' '"						+ CRLF

	cQryWSC72 += "	UNION ALL"												+ CRLF

	cQryWSC72 += "	SELECT 6 NIVEL, ZBI_REPRES VENDEDOR"					+ CRLF
	cQryWSC72 += "	FROM		" + retSQLName( "ZBI" ) + " ZBI"			+ CRLF
	cQryWSC72 += "	INNER JOIN	" + retSQLName( "SA3" ) + " SA3"			+ CRLF
	cQryWSC72 += "	ON"														+ CRLF
	cQryWSC72 += "			SA3.A3_COD      =   ZBI.ZBI_REPRES"				+ CRLF
	cQryWSC72 += "		AND SA3.A3_FILIAL   =   '" + xFilial("SA3") + "'"	+ CRLF
	cQryWSC72 += "		AND SA3.D_E_L_E_T_  =   ' '"						+ CRLF
	cQryWSC72 += "		AND SA3.A3_XINTSFO	=	'P'"						+ CRLF
	cQryWSC72 += "	WHERE"													+ CRLF
	cQryWSC72 += "			ZBI.ZBI_FILIAL  =   '" + xFilial("ZBI") + "'"	+ CRLF
	cQryWSC72 += "		AND ZBI.D_E_L_E_T_  =   ' '"						+ CRLF
	cQryWSC72 += " ) A"														+ CRLF
	cQryWSC72 += " GROUP BY VENDEDOR"										+ CRLF

	conout( "[MGFWSC72] [SALESFORCE] " + cQryWSC72 )

	tcQuery cQryWSC72 New Alias "QRYWSC72"
return

//---------------------------------------------------------------------------
// Retorna ID Salesforce
//---------------------------------------------------------------------------
static function getIDSfor( nNivelHier , cCodVend )
	local cIDSalesfo	:= ""
	local cQryIDSFO		:= ""
	local cTableX		:= ""
	local aAreaX		:= getArea()

	do case
		case nNivelHier == 1 // ZBD - Diretoria
			cTableX := "ZBD"
		case nNivelHier == 2 // ZBE - Nacional
			cTableX := "ZBE"
		case nNivelHier == 3 // ZBF - Tatica
			cTableX := "ZBF"
		case nNivelHier == 4 // ZBG - Regional
			cTableX := "ZBG"
		case nNivelHier == 5 // ZBH - Supervisao
			cTableX := "ZBH"
		case nNivelHier == 6 // ZBI - Roteiro
			cTableX := "ZBI"
	endcase

	cQryIDSFO := "SELECT " + cTableX + "_XIDSFO IDSALESFOR"
	cQryIDSFO += " FROM " + retSQLName( cTableX ) + " X"
	cQryIDSFO += " WHERE"
	cQryIDSFO += " 			X." + cTableX + "_REPRES	=	'" + cCodVend			+ "'"
	cQryIDSFO += " 		AND X." + cTableX + "_FILIAL	=	'" + xFilial( cTableX )	+ "'"
	cQryIDSFO += "		AND	X.D_E_L_E_T_				=	' '"

	tcQuery cQryIDSFO New Alias "QRYIDSFO"

	if !QRYIDSFO->( EOF() )
		cIDSalesfo := QRYIDSFO->IDSALESFOR
	endif

	QRYIDSFO->( DBCloseArea() )

	restArea( aAreaX )
return cIDSalesfo