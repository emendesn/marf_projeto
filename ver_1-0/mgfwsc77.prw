#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} JOBWSC77
Integração de Tabela de Preço com Salesforce - Para ser chamado em JOB
@description
Integração de Tabela de Preço com Salesforce - Para ser chamado em JOB
@author TOTVS
@since 06/09/2019
@type Function
@table
 DA0 - Tabela de Preço
@param
 cFilJob - Caracter informa a filial que será usada
@return
 Sem retorno
@menu
 Sem menu
/*/
user function JOBWSC77( cFilJob )

	U_MGFWSC77( { "01" , cFilJob } )

return

/*/
=============================================================================
{Protheus.doc} MNUWSC77
Integração de Tabela de Preço com Salesforce - Para ser chamado em MENU
@description
Integração de Tabela de Preço com Salesforce - Para ser chamado em MENU
@author TOTVS
@since 06/09/2019
@type Function
@table
 DA0 - Tabela de Preço
@param
 Sem parametro
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MNUWSC77()

	runInteg77()

return

/*/
=============================================================================
{Protheus.doc} MGFWSC77
Integração de Tabela de Preço com Salesforce - Preparação de Ambiente
@description
Integração de Tabela de Preço com Salesforce - Preparação de Ambiente
@author TOTVS
@since 06/09/2019
@type Function
@table
 DA0 - Tabela de Preço
@param
 aEmpX - Array com Empresa e Filial que serão configuradas
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MGFWSC77( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC77] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg77()

	RESET ENVIRONMENT
return

/*/
=============================================================================
{Protheus.doc} runInteg77
Integração de Tabela de Preço com Salesforce
@description
Integração de Tabela de Preço com Salesforce
@author TOTVS
@since 06/09/2019
@type Function
@table
 DA0 - Tabela de Preço
@param

@return
 Sem retorno
@menu
 Sem menu
/*/
static function runInteg77()
	// MOCK - POST		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/Tabela de Preço
	// MOCK - PUT		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/Tabela de Preço/{id}
	// MOCK - DELETE	- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/Tabela de Preço/{id}

	//local cURLInteg		:= allTrim( superGetMv( "MGFWSC77A" , , "https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/Tabela de Preço/{id}" ) )
	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC77A" , , "http://spdwvapl203:1337/processo-tabela-preco/api/v2/tabela-preco/{id}" ) )
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
	local cHttpRet		:= ""

	local oJson			:= nil
	local oJsonTipos	:= nil
	local oJsonItens	:= nil
	local oJsonFilia	:= nil
	local oJsonVende	:= nil
	local oJsonClien	:= nil
	local oJsonEstad	:= nil
	local oJsonRegio	:= nil

	local cHeadHttp		:= ""

	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2"	, , "008" ) ) // SZ2 - SISTEMA
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC77B"		, , "014" ) ) // SZ3 - ENTIDADE

	conout("[SALESFORCE] - MGFWSC77- Selecionando Tabela de Preço aptos a integrar com SALESFORCE")

	getDA0()

	while !QRYDA0->( EOF() )
        cIdInteg	:= ""
		cIdInteg	:= fwUUIDv4()

		aHeadStr := {}

		aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )
		aadd( aHeadStr , 'Content-Type: application/json'  )
		aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg   )

		oJson := nil
		oJson := jsonObject():new()

		oJson["id"]						:= iif( !empty( QRYDA0->DA0_CODTAB	)	, allTrim( QRYDA0->DA0_CODTAB	)	, nil )
		oJson["descricao"]				:= iif( !empty( QRYDA0->DA0_DESCRI	)	, allTrim( QRYDA0->DA0_DESCRI	)	, nil )
		oJson["dataValidadeInicial"]	:= iif( !empty( QRYDA0->DA0_DATDE	)	, left( fwTimeStamp( 3 , sToD( QRYDA0->DA0_DATDE	) ) , 10 )	, nil )
		oJson["dataValidadeFinal"]		:= iif( !empty( QRYDA0->DA0_DATATE	)	, left( fwTimeStamp( 3 , sToD( QRYDA0->DA0_DATATE	) ) , 10 )	, nil )
		oJson["comercial"]				:= chkType( QRYDA0->DA0_CODTAB )
		oJson["ativo"]					:= ( QRYDA0->DA0_ATIVO	== "1" )  //1=Sim;2=Nao
		//oJson["ativo"]	:= iif( !empty( QRYDA0->DA0_ATIVO	)	, allTrim( QRYDA0->DA0_ATIVO	)	, nil )

		//------------------------------------------
		// ITENS DA TABELA
		//------------------------------------------
		getDA1()

		oJson["produtos"] 				:= {}

		while !QRYDA1->(EOF())

			oJsonItens 					:= nil
			oJsonItens 					:= jsonObject():new()
			oJsonItens["sequencia"]		:= iif( !empty( QRYDA1->DA1_ITEM	)	, allTrim( QRYDA1->DA1_ITEM		)	, nil	)
			oJsonItens["idProduto"]		:= iif( !empty( QRYDA1->DA1_CODPRO	)	, allTrim( QRYDA1->DA1_CODPRO	)	, nil	)
			oJsonItens["precoVenda"]	:= iif( !empty( QRYDA1->DA1_PRCVEN	)	, QRYDA1->DA1_PRCVEN				, 0		)
			oJsonItens["precoBase"]		:= iif( !empty( QRYDA1->DA1_XPRCBA	)	, QRYDA1->DA1_XPRCBA				, 0		)
			//oJsonItens["excluido"]		:= QRYDA1->DA1DELETE == "*"

			aadd( oJson["produtos"] , oJsonItens )

			freeObj( oJsonItens )

			QRYDA1->( DBSkip() )
		enddo

		QRYDA1->( DBCloseArea() )

		//------------------------------------------
		// FILIAIS DA TABELA
		//------------------------------------------
		getSZB()

		oJson["filiais"] 				:= {}

		while !QRYSZB->(EOF())
			oJsonFilia 				:= nil
			oJsonFilia 				:= jsonObject():new()
			oJsonFilia["id"	]		:= iif( !empty( QRYSZB->ZB_CODFIL	)	, allTrim( QRYSZB->ZB_CODFIL ) , nil )
			//oJsonFilia["excluido" ]	:= QRYSZB->SZBDELETE == "*"

			aadd( oJson["filiais"] , oJsonFilia )

			freeObj( oJsonFilia )

			QRYSZB->(DBSkip())
		enddo

		QRYSZB->( DBCloseArea() )

		//------------------------------------------
		// VENDEDORES DA TABELA
		//------------------------------------------
		getSZC()

		oJson["vendedores"] 				:= {}

		while !QRYSZC->(EOF())
			oJsonVende 							:= nil
			oJsonVende 							:= jsonObject():new()
			oJsonVende["id"]					:= iif( !empty( QRYSZC->ZC_CODVEND	)	, allTrim( QRYSZC->ZC_CODVEND )	, nil	)
			oJsonVende["porcentagemComissao"]	:= iif( !empty( QRYSZC->ZC_PERCOMI	)	, QRYSZC->ZC_PERCOMI			, 0		)
			//oJsonVende["excluido"]				:= QRYSZC->SZCDELETE == "*"

			aadd( oJson["vendedores"] , oJsonVende )

			freeObj( oJsonVende )

			QRYSZC->(DBSkip())
		enddo

		QRYSZC->( DBCloseArea() )

		//------------------------------------------
		// CLIENTES DA TABELA
		//------------------------------------------
		getSZG()

		oJson["clientes"] 				:= {}

		while !QRYSZG->( EOF() )
			oJsonClien 				:= nil
			oJsonClien 				:= jsonObject():new()
			oJsonClien["id"]		:= iif( !empty( QRYSZG->ZG_CODCLI	)	, allTrim( QRYSZG->ZG_CODCLI )	, nil )
			oJsonClien["loja"]		:= iif( !empty( QRYSZG->ZG_LOJCLI	)	, allTrim( QRYSZG->ZG_LOJCLI )	, nil )
			//oJsonClien["excluido"]	:= QRYSZG->SZGDELETE == "*"

			aadd( oJson["clientes"] , oJsonClien )

			freeObj( oJsonClien )

			QRYSZG->( DBSkip() )
		enddo

		QRYSZG->( DBCloseArea() )

		//------------------------------------------
		// ESTADOS DA TABELA
		//------------------------------------------
		getSZH()

		oJson["estados"] 				:= {}

		while !QRYSZH->( EOF() )
			oJsonEstad 				:= nil
			oJsonEstad 				:= jsonObject():new()
			oJsonEstad["sigla"]		:= iif( !empty( QRYSZH->ZH_CODEST	)	, allTrim( QRYSZH->ZH_CODEST	)	, nil )
			//oJsonEstad["excluido"]	:= QRYSZH->SZHDELETE == "*"

			aadd( oJson["estados"] , oJsonEstad )

			freeObj( oJsonEstad )

			QRYSZH->( DBSkip() )
		enddo

		QRYSZH->( DBCloseArea() )

		//------------------------------------------
		// REGIOES DA TABELA
		//------------------------------------------
		getSZI()

		oJson["regioes"] 				:= {}

		while !QRYSZI->( EOF() )
			oJsonRegio 				:= nil
			oJsonRegio 				:= jsonObject():new()
			oJsonRegio["id"]		:= iif( !empty( QRYSZI->ZI_CODREG	)	, allTrim( QRYSZI->ZI_CODREG	)	, nil )
			//oJsonRegio["excluido"]	:= QRYSZI->SZIDELETE == "*"

			aadd( oJson["regioes"] , oJsonRegio )

			freeObj( oJsonRegio )

			QRYSZI->( DBSkip() )
		enddo

		QRYSZI->( DBCloseArea() )

		//------------------------------------------
		// TIPOS DA TABELA
		//------------------------------------------
		getSZK()

		oJson["tiposPedido"] 				:= {}

		while !QRYSZK->( EOF() )
			oJsonTipos						:= nil
			oJsonTipos						:= jsonObject():new()
			oJsonTipos["id"]				:= iif( !empty( QRYSZK->ZK_CODTPED	)	, allTrim( QRYSZK->ZK_CODTPED	)	, nil )
			oJsonTipos["diasMin"]			:= QRYSZK->ZJ_MINIMO
			oJsonTipos["diasMax"]			:= QRYSZK->ZJ_MAXIMO
			oJsonTipos["descricao"]			:= allTrim( QRYSZK->ZJ_NOME )
			oJsonTipos["usarEmAplicativo"]	:= ( QRYSZK->ZJ_APLICAT == "S" )

			aadd( oJson["tiposPedido"] , oJsonTipos )

			freeObj( oJsonTipos )

			QRYSZK->( DBSkip() )
		enddo

		QRYSZK->( DBCloseArea() )

		if QRYDA0->DA0_ZSTASF <> "S"
			cURLUse		:= strTran( cURLInteg , "/{id}" , "" )
			cHTTPMetho	:= "POST"
		else
			cURLUse		:= strTran( cURLInteg , "{id}" , allTrim( QRYDA0->DA0_CODTAB ) )
			//cHTTPMetho	:= "PATCH"
			cHTTPMetho	:= "PUT"
		endif

		cJson := ""
		cJson := oJson:toJson()
		conout( "[MGFWSC77] [JSON] " + cJson )

		cTimeIni	:= time()
		cHeaderRet	:= ""
		cHttpRet	:= ""
		cHttpRet	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni , cTimeFin )
		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		conout(" [SALESFORCE] [MGFWSC77] * * * * * Status da integracao * * * * *"									)
		conout(" [SALESFORCE] [MGFWSC77] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
		conout(" [SALESFORCE] [MGFWSC77] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
		conout(" [SALESFORCE] [MGFWSC77] Tempo de Processamento.......: " + cTimeProc 								)
		conout(" [SALESFORCE] [MGFWSC77] URL..........................: " + cURLUse 								)
		conout(" [SALESFORCE] [MGFWSC77] HTTP Method..................: " + cHTTPMetho								)
		conout(" [SALESFORCE] [MGFWSC77] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
		conout(" [SALESFORCE] [MGFWSC77] Envio........................: " + cJson 									)
		conout(" [SALESFORCE] [MGFWSC77] Retorno......................: " + cHttpRet 								)
		conout(" [SALESFORCE] [MGFWSC77] * * * * * * * * * * * * * * * * * * * * "									)

		if nStatuHttp >= 200 .and. nStatuHttp <= 299
			cUpdTbl	:= ""

			cUpdTbl := "UPDATE " + retSQLName("DA0")										+ CRLF
			cUpdTbl += "	SET"															+ CRLF
			cUpdTbl += " 		DA0_XINTSF = 'I', DA0_ZSTASF = 'S'"							+ CRLF
			cUpdTbl += " WHERE"																+ CRLF
			cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( QRYDA0->DA0RECNO ) ) + ""	+ CRLF

			if tcSQLExec( cUpdTbl ) < 0
				conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
			endif
		endif

		cHeadHttp := ""

		for nI := 1 to len( aHeadStr )
			cHeadHttp += aHeadStr[ nI ]
		next

		//GRAVAR LOG
		U_MGFMONITOR(							 ;
		cFilAnt																										/*cFil*/		        	,;
		iif( ( nStatuHttp >= 200 .and. nStatuHttp <= 299 ) , "1" , "2" )											/*cStatus*/		        	,;
		cCodInteg																									/*cCodint Z1_INTEGRA*/		,;
		cCodTpInt																									/*cCodtpint Z1_TPINTEG*/  	,;
		iif( ( nStatuHttp >= 200 .and. nStatuHttp <= 299 ) , "Processamento realizado com sucesso!" , cHttpRet )	/*cErro*/					,;
		" "																											/*cDocori*/				     ,;
		cTimeProc																									/*cTempo*/	 ,;
		cJson 																										/*cJSON*/		     ,;
		QRYDA0->DA0RECNO																							/*nRecnoDoc*/,;
		cValToChar( nStatuHttp )																					/*cHTTP*/,;
		.F.																											/*lJob*/		           ,;
		{}																											/*aFil*/		           ,;
		cIdInteg																									/*cUUID*/	       ,;
		iif( type( cHTTPRet ) <> "U" , cHTTPRet , " " )																/*cJsonR*/,;
		"S"																											/*cTipWsInt*/           ,;
		" "																											/*cJsonCB Z1_JSONCB*/ ,;
		" "																											/*cJsonRB Z1_JSONRB*/ ,;
		sTod("//")																									/*dDTCallb Z1_DTCALLB*/,;
		" "																											/*cHoraCall Z1_HRCALLB*/,;
		" "																											/*cCallBac Z1_CALLBAC*/,;
		cURLUse																										/*cLinkEnv Z1_LINKENV*/				,;
		" "																											/*cLinkRec Z1_LINKREC*/				,;
		cIdInteg																									/*cHeaderID		Z1_HEADEID*/		,;
		cHeadHttp																									/*cHeadeHttp	Z1_HEADER*/			)

		QRYDA0->( DBSkip() )

		freeObj( oJson )
	enddo

	QRYDA0->( DBCloseArea() )

	delClassINTF()
return

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
static function getDA0()
	local cQryDA0		:= ""

	cQryDA0 += " SELECT DA0_CODTAB , DA0_DESCRI , DA0_DATDE , DA0_DATATE , DA0_ATIVO , D_E_L_E_T_ DA0DELETE , "	+ CRLF
	cQryDA0 += " DA0.R_E_C_N_O_ DA0RECNO , DA0_ZSTASF , DA0_XENVSF"												+ CRLF
	cQryDA0 += " FROM			" + retSQLName( "DA0" ) + " DA0"												+ CRLF
	cQryDA0 += " WHERE"																							+ CRLF
	cQryDA0 += " 		DA0.DA0_XINTSF	=	'P'"																+ CRLF
	// Integracao generica
	//cQryDA0 += " 	AND	DA0.DA0_XENVSF	=	'S'"																+ CRLF
	cQryDA0 += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"											+ CRLF
	cQryDA0 += " 	AND DA0.D_E_L_E_T_	=	' '"																+ CRLF

	conout("[MGFWSC77] [SALESFORCE] [getDA0] " + cQryDA0)

	tcQuery cQryDA0 new alias "QRYDA0"
return

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
static function getDA1()
	local cQryDA1 := ""

	cQryDA1 += " SELECT DA1_ITEM , DA1_CODPRO , DA1_PRCVEN , DA1_XPRCBA , DA1.D_E_L_E_T_ DA1DELETE"		+ CRLF
	cQryDA1 += " FROM			" + retSQLName( "DA0" ) + " DA0"										+ CRLF
	cQryDA1 += " INNER JOIN	" + retSQLName( "DA1" ) + " DA1"											+ CRLF
	cQryDA1 += " ON"																					+ CRLF
	//cQryDA1 += " 		DA1.DA1_XINTEG	<	DA1.DA1_XALTER"												+ CRLF
	//cQryDA1 += " 	AND	DA1.DA1_CODTAB	=	DA0.DA0_CODTAB"												+ CRLF
	cQryDA1 += " 		DA1.DA1_CODTAB	=	DA0.DA0_CODTAB"												+ CRLF
	cQryDA1 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial( "DA1") + "'"									+ CRLF
	cQryDA1 += " 	AND DA1.D_E_L_E_T_	=	' '"														+ CRLF
	cQryDA1 += " WHERE"																					+ CRLF
	cQryDA1 += " 		DA0.DA0_XINTSF	=	'P'"														+ CRLF
	//cQryDA1 += " 	AND	DA0.DA0_XENVSF	=	'S'"														+ CRLF
	cQryDA1 += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"								+ CRLF
	cQryDA1 += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"									+ CRLF
	cQryDA1 += " 	AND DA0.D_E_L_E_T_	=	' '"														+ CRLF

	conout("[MGFWSC77] [SALESFORCE] [getDA1] " + cQryDA1)

	tcQuery cQryDA1 new alias "QRYDA1"
return

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
static function getSZB()
	local cQrySZB := ""

	cQrySZB += " SELECT ZB_CODFIL, SZB.D_E_L_E_T_ SZBDELETE"							+ CRLF
	cQrySZB += " FROM		" + retSQLName( "DA0" ) + " DA0"							+ CRLF
	cQrySZB += " INNER JOIN	" + retSQLName( "SZB" ) + " SZB"							+ CRLF
	cQrySZB += " ON"																	+ CRLF
	//cQrySZB += " 		SZB.SZB_XINTEG	<	SZB.SZB_XALTER"								+ CRLF
	//cQrySZB += " 	AND	SZB.ZB_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQrySZB += " 		SZB.ZB_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQrySZB += " 	AND	SZB.ZB_FILIAL	=	'" + xFilial( "SZB") + "'"					+ CRLF
	cQrySZB += " 	AND SZB.D_E_L_E_T_	=	' '"										+ CRLF
	cQrySZB += " WHERE"																	+ CRLF
	cQrySZB += " 		DA0.DA0_XINTSF	=	'P'"										+ CRLF
	//cQrySZB += " 	AND	DA0.DA0_XENVSF	=	'S'"										+ CRLF
	cQrySZB += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"				+ CRLF
	cQrySZB += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
	cQrySZB += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF

	conout("[MGFWSC77] [SALESFORCE] [getSZB] " + cQrySZB)

	tcQuery cQrySZB new alias "QRYSZB"
return

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
static function getSZC()
	local cQrySZC := ""

	cQrySZC += " SELECT ZC_CODVEND , ZC_PERCOMI , SZC.D_E_L_E_T_ SZCDELETE"				+ CRLF
	cQrySZC += " FROM		" + retSQLName( "DA0" ) + " DA0"						+ CRLF
	cQrySZC += " INNER JOIN	" + retSQLName( "SZC" ) + " SZC"							+ CRLF
	cQrySZC += " ON"																	+ CRLF
	//cQrySZC += " 		SZC.SZC_XINTEG	<	SZC.SZC_XALTER"								+ CRLF
	//cQrySZC += " 	AND	SZC.ZC_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQrySZC += " 		SZC.ZC_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQrySZC += " 	AND	SZC.ZC_FILIAL	=	'" + xFilial( "SZC") + "'"					+ CRLF
	cQrySZC += " 	AND SZC.D_E_L_E_T_	=	' '"										+ CRLF
	cQrySZC += " WHERE"																	+ CRLF
	cQrySZC += " 		DA0.DA0_XINTSF	=	'P'"										+ CRLF
	//cQrySZC += " 	AND	DA0.DA0_XENVSF	=	'S'"										+ CRLF
	cQrySZC += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"				+ CRLF
	cQrySZC += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
	cQrySZC += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF

	conout("[MGFWSC77] [SALESFORCE] [getSZC] " + cQrySZC)

	tcQuery cQrySZC new alias "QRYSZC"
return

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
static function getSZG()
	local cQrySZG		:= ""
	local lGetOthers	:= superGetMv( "MGFWSC77D", , .T. )

	if !lGetOthers
		cQrySZG += " SELECT ZG_CODCLI , ZG_LOJCLI"											+ CRLF
		cQrySZG += " FROM		" + retSQLName( "DA0" ) + " DA0"							+ CRLF
		cQrySZG += " INNER JOIN	" + retSQLName( "SZG" ) + " SZG"							+ CRLF
		cQrySZG += " ON"																	+ CRLF
		cQrySZG += " 		SZG.ZG_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
		cQrySZG += " 	AND	SZG.ZG_FILIAL	=	'" + xFilial( "SZG") + "'"					+ CRLF
		cQrySZG += " 	AND SZG.D_E_L_E_T_	=	' '"										+ CRLF

		cQrySZG += " INNER JOIN "	+ retSQLName( "SA1" ) + " SA1"							+ CRLF
		cQrySZG += " ON"																	+ CRLF
		cQrySZG += " 		SA1.A1_LOJA		=	SZG.ZG_LOJCLI"								+ CRLF
		cQrySZG += " 	AND SA1.A1_COD		=	SZG.ZG_CODCLI"								+ CRLF
		cQrySZG += " 	AND	SA1.A1_EST		<>	'EX' "										+ CRLF
		cQrySZG += " 	AND	SA1.A1_XIDSFOR	<>	' ' "										+ CRLF
		cQrySZG += " 	AND SA1.A1_FILIAL	=	'" + xFilial( "SA1") + "'"					+ CRLF
		cQrySZG += " 	AND SA1.D_E_L_E_T_	<>	'*'"										+ CRLF

		cQrySZG += " WHERE"																	+ CRLF
		cQrySZG += " 		DA0.DA0_XINTSF	=	'P'"										+ CRLF
		cQrySZG += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"				+ CRLF
		cQrySZG += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
		cQrySZG += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF

		conout("[MGFWSC77] [SALESFORCE] [getSZG] " + cQrySZG)

		tcQuery cQrySZG new alias "QRYSZG"
	else
		// SE lGetOthers true - Pega os clientes vinculados a tabela de preço das outras tabelas
		cQrySZG := ""
		cQrySZG += " SELECT ZG_CODCLI , ZG_LOJCLI"											+ CRLF
		cQrySZG += " FROM		" + retSQLName( "DA0" ) + " DA0"							+ CRLF
		cQrySZG += " INNER JOIN	" + retSQLName( "SZG" ) + " SZG"							+ CRLF
		cQrySZG += " ON"																	+ CRLF
		cQrySZG += " 		SZG.ZG_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
		cQrySZG += " 	AND	SZG.ZG_FILIAL	=	'" + xFilial( "SZG") + "'"					+ CRLF
		cQrySZG += " 	AND SZG.D_E_L_E_T_	=	' '"										+ CRLF

		cQrySZG += " INNER JOIN "	+ retSQLName( "SA1" ) + " SA1"							+ CRLF
		cQrySZG += " ON"																	+ CRLF
		cQrySZG += " 		SA1.A1_LOJA		=	SZG.ZG_LOJCLI"								+ CRLF
		cQrySZG += " 	AND SA1.A1_COD		=	SZG.ZG_CODCLI"								+ CRLF
		cQrySZG += " 	AND	SA1.A1_EST		<>	'EX' "										+ CRLF
		cQrySZG += " 	AND	SA1.A1_XIDSFOR	<>	' ' "										+ CRLF
		cQrySZG += " 	AND SA1.A1_FILIAL	=	'" + xFilial( "SA1") + "'"					+ CRLF
		cQrySZG += " 	AND SA1.D_E_L_E_T_	<>	'*'"										+ CRLF

		cQrySZG += " WHERE"																	+ CRLF
		cQrySZG += " 		DA0.DA0_XINTSF	=	'P'"										+ CRLF
		cQrySZG += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"				+ CRLF
		cQrySZG += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
		cQrySZG += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF

		conout("[MGFWSC77] [SALESFORCE] [getSZG - 1] " + cQrySZG)

		tcQuery cQrySZG new alias "QRYSZG"

		if QRYSZG->( EOF() )
			// Somente se NAO existir clientes - Tabela
			cQrySZG := ""
			cQrySZG += " SELECT DISTINCT ZG_CODCLI , ZG_LOJCLI"									+ CRLF
			cQrySZG += " FROM"																	+ CRLF
			cQrySZG += " ("																		+ CRLF
			//****************************************************************************************
			// Clientes amarrados ao vendedor
			//****************************************************************************************

			cQrySZG += " SELECT ZBJ_CLIENT ZG_CODCLI , ZBJ_LOJA ZG_LOJCLI"						+ CRLF
			cQrySZG += " FROM		" + retSQLName( "DA0" ) + " DA0"							+ CRLF
			cQrySZG += " INNER JOIN	" + retSQLName( "SZC" ) + " SZC"							+ CRLF
			cQrySZG += " ON"																	+ CRLF
			cQrySZG += " 		SZC.ZC_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
			cQrySZG += " 	AND	SZC.ZC_FILIAL	=	'" + xFilial( "SZC") + "'"					+ CRLF
			cQrySZG += " 	AND SZC.D_E_L_E_T_	=	' '"										+ CRLF
			cQrySZG += " INNER JOIN	" + retSQLName( "ZBJ" ) + " ZBJ"							+ CRLF
			cQrySZG += " ON"																	+ CRLF
			cQrySZG += " 		SZC.ZC_CODVEND	=	ZBJ.ZBJ_REPRES"								+ CRLF
			cQrySZG += " 	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial( "ZBJ") + "'"					+ CRLF
			cQrySZG += " 	AND ZBJ.D_E_L_E_T_	=	' '"										+ CRLF

			cQrySZG += " INNER JOIN "	+ retSQLName( "SA1" ) + " SA1"							+ CRLF
			cQrySZG += " ON"																	+ CRLF
			cQrySZG += " 		SA1.A1_LOJA		=	ZBJ.ZBJ_LOJA"								+ CRLF
			cQrySZG += " 	AND SA1.A1_COD		=	ZBJ.ZBJ_CLIENT"								+ CRLF
			cQrySZG += " 	AND	SA1.A1_EST		<>	'EX' "										+ CRLF
			cQrySZG += " 	AND	SA1.A1_XIDSFOR	<>	' ' "										+ CRLF
			cQrySZG += " 	AND SA1.A1_FILIAL	=	'" + xFilial( "SA1") + "'"					+ CRLF
			cQrySZG += " 	AND SA1.D_E_L_E_T_	<>	'*'"										+ CRLF

			cQrySZG += " WHERE"																	+ CRLF
			cQrySZG += " 		DA0.DA0_XINTSF	=	'P'"										+ CRLF
			cQrySZG += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"				+ CRLF
			cQrySZG += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
			cQrySZG += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF

			cQrySZG += " UNION ALL"																+ CRLF

			//****************************************************************************************
			// Clientes amarrados a região
			//****************************************************************************************

			cQrySZG += " SELECT A1_COD ZG_CODCLI, A1_LOJA ZG_LOJCLI"					+ CRLF
			cQrySZG += " FROM "			+ retSQLName( "DA0" ) + " DA0"					+ CRLF
			cQrySZG += " INNER JOIN	"	+ retSQLName( "SZI" ) + " SZI"					+ CRLF // TABELA DE PRECO x REGIAO
			cQrySZG += " ON"															+ CRLF
			cQrySZG += " 		SZI.ZI_CODTAB	=	DA0.DA0_CODTAB"						+ CRLF
			cQrySZG += " 	AND	SZI.ZI_FILIAL	=	'" + xFilial( "SZI") + "'"			+ CRLF
			cQrySZG += " 	AND SZI.D_E_L_E_T_	=	' '"								+ CRLF
			cQrySZG += " INNER JOIN "	+ retSQLName( "SZP" ) + " SZP"					+ CRLF // REGIAO x CD
			cQrySZG += " ON"															+ CRLF
			cQrySZG += " 		SZP.ZP_CODREG	=	SZI.ZI_CODREG"						+ CRLF
			cQrySZG += " 	AND SZP.ZP_FILIAL	=	'" + xFilial( "SZP") + "'"			+ CRLF
			cQrySZG += " 	AND SZP.D_E_L_E_T_	<>	'*'"								+ CRLF
			cQrySZG += " INNER JOIN "	+ retSQLName( "ZAP" ) + " ZAP"					+ CRLF // CIDADES x REGIAO
			cQrySZG += " ON"															+ CRLF
			cQrySZG += " 		ZAP.ZAP_CODREG	=	SZP.ZP_CODREG"						+ CRLF
			cQrySZG += " 	AND ZAP.ZAP_FILIAL	=	'" + xFilial( "ZAP") + "'"			+ CRLF
			cQrySZG += " 	AND ZAP.D_E_L_E_T_	<>	'*'"								+ CRLF
			cQrySZG += " INNER JOIN "	+ retSQLName( "SA1" ) + " SA1"					+ CRLF
			cQrySZG += " ON"															+ CRLF
			cQrySZG += " 		SA1.A1_EST		=	ZAP.ZAP_UF"							+ CRLF
			cQrySZG += " 	AND SA1.A1_COD_MUN	=	ZAP.ZAP_CODMUN"						+ CRLF
			cQrySZG += " 	AND SA1.A1_FILIAL	=	'" + xFilial( "SA1") + "'"			+ CRLF
			cQrySZG += " 	AND SA1.D_E_L_E_T_	<>	'*'"								+ CRLF
			cQrySZG += " 	AND	SA1.A1_EST		<>	'EX' "								+ CRLF
			cQrySZG += " 	AND	SA1.A1_XIDSFOR	<>	' ' "								+ CRLF
			cQrySZG += " WHERE"															+ CRLF
			cQrySZG += " 		DA0.DA0_XINTSF	=	'P'"								+ CRLF
			cQrySZG += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"		+ CRLF
			cQrySZG += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"			+ CRLF
			cQrySZG += " 	AND DA0.D_E_L_E_T_	=	' '"								+ CRLF

			cQrySZG += " UNION ALL"														+ CRLF

			//****************************************************************************************
			// Clientes amarrados no Estado
			//****************************************************************************************

			cQrySZG += " SELECT A1_COD ZG_CODCLI, A1_LOJA ZG_LOJCLI"					+ CRLF
			cQrySZG += " FROM		" + retSQLName( "DA0" ) + " DA0"					+ CRLF
			cQrySZG += " INNER JOIN	" + retSQLName( "SZH" ) + " SZH"					+ CRLF
			cQrySZG += " ON"															+ CRLF
			cQrySZG += " 		SZH.ZH_CODTAB	=	DA0.DA0_CODTAB"						+ CRLF
			cQrySZG += " 	AND	SZH.ZH_FILIAL	=	'" + xFilial( "SZH") + "'"			+ CRLF
			cQrySZG += " 	AND SZH.D_E_L_E_T_	=	' '"								+ CRLF
			cQrySZG += " INNER JOIN "	+ retSQLName( "SA1" ) + " SA1"					+ CRLF
			cQrySZG += " ON"															+ CRLF
			cQrySZG += " 		SA1.A1_EST		=	SZH.ZH_CODEST"						+ CRLF
			cQrySZG += " 	AND SA1.A1_FILIAL	=	'" + xFilial( "SA1") + "'"			+ CRLF
			cQrySZG += " 	AND SA1.D_E_L_E_T_	<>	'*'"								+ CRLF
			cQrySZG += " 	AND	SA1.A1_EST		<>	'EX' "								+ CRLF
			cQrySZG += " 	AND	SA1.A1_XIDSFOR	<>	' ' "								+ CRLF
			cQrySZG += " WHERE"															+ CRLF
			cQrySZG += " 		DA0.DA0_XINTSF	=	'P'"								+ CRLF
			cQrySZG += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"		+ CRLF
			cQrySZG += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"			+ CRLF
			cQrySZG += " 	AND DA0.D_E_L_E_T_	=	' '"								+ CRLF
			cQrySZG += " ) TABA"														+ CRLF

			if select("QRYSZG") > 0
				QRYSZG->( DBCloseArea() )
			endif

			conout("[MGFWSC77] [SALESFORCE] [getSZG - 2] " + cQrySZG)

			tcQuery cQrySZG new alias "QRYSZG"
		endif
	endif
return

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
static function getSZH()
	local cQrySZH := ""

	cQrySZH += " SELECT ZH_CODEST , SZH.D_E_L_E_T_ SZHDELETE"							+ CRLF
	cQrySZH += " FROM		" + retSQLName( "DA0" ) + " DA0"						+ CRLF
	cQrySZH += " INNER JOIN	" + retSQLName( "SZH" ) + " SZH"							+ CRLF
	cQrySZH += " ON"																	+ CRLF
	//cQrySZH += " 		SZH.SZH_XINTEG	<	SZH.SZH_XALTER"								+ CRLF
	//cQrySZH += " 	AND	SZH.ZH_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQrySZH += " 		SZH.ZH_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQrySZH += " 	AND	SZH.ZH_FILIAL	=	'" + xFilial( "SZH") + "'"					+ CRLF
	cQrySZH += " 	AND SZH.D_E_L_E_T_	=	' '"										+ CRLF
	cQrySZH += " WHERE"																	+ CRLF
	cQrySZH += " 		DA0.DA0_XINTSF	=	'P'"										+ CRLF
	//cQrySZH += " 	AND	DA0.DA0_XENVSF	=	'S'"										+ CRLF
	cQrySZH += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"				+ CRLF
	cQrySZH += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
	cQrySZH += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF

	conout("[MGFWSC77] [SALESFORCE] [getSZH] " + cQrySZH)

	tcQuery cQrySZH New Alias "QRYSZH"
return

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
static function getSZI()
	local cQrySZI := ""

	cQrySZI += " SELECT ZI_CODREG , SZI.D_E_L_E_T_ SZIDELETE"							+ CRLF
	cQrySZI += " FROM		" + retSQLName( "DA0" ) + " DA0"						+ CRLF
	cQrySZI += " INNER JOIN	" + retSQLName( "SZI" ) + " SZI"							+ CRLF
	cQrySZI += " ON"																	+ CRLF
	//cQrySZI += " 		SZI.SZI_XINTEG	<	SZI.SZI_XALTER"								+ CRLF
	//cQrySZI += " 	AND	SZI.ZI_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQrySZI += " 		SZI.ZI_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQrySZI += " 	AND	SZI.ZI_FILIAL	=	'" + xFilial( "SZI") + "'"					+ CRLF
	cQrySZI += " 	AND SZI.D_E_L_E_T_	=	' '"										+ CRLF
	cQrySZI += " WHERE"																	+ CRLF
	cQrySZI += " 		DA0.DA0_XINTSF	=	'P'"										+ CRLF
	//cQrySZI += " 	AND	DA0.DA0_XENVSF	=	'S'"										+ CRLF
	cQrySZI += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"				+ CRLF
	cQrySZI += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
	cQrySZI += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF

	conout("[MGFWSC77] [SALESFORCE] [getSZI] " + cQrySZI)

	tcQuery cQrySZI new alias "QRYSZI"
return

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
static function getSZK()
	local cQrySZK		:= ""

	cQrySZK += " SELECT ZK_CODTPED, SZK.D_E_L_E_T_ SZKDELETE, ZJ_MINIMO, ZJ_MAXIMO, ZJ_COMFT14, ZJ_NOME, ZJ_VENDA , ZJ_APLICAT"	+ CRLF // ZJ_COMFT14 - 1=Sim;2=Nao
	cQrySZK += " FROM		" + retSQLName( "DA0" ) + " DA0"								    + CRLF
	cQrySZK += " INNER JOIN	" + retSQLName( "SZK" ) + " SZK"									+ CRLF
	cQrySZK += " ON"																			+ CRLF
	//cQrySZK += " 		SZK.SZK_XINTEG	<	SZK.SZK_XALTER"										+ CRLF
	//cQrySZK += " 	AND	SZK.ZK_CODTAB	=	DA0.DA0_CODTAB"										+ CRLF
	cQrySZK += " 		SZK.ZK_CODTAB	=	DA0.DA0_CODTAB"										+ CRLF
	cQrySZK += " 	AND	SZK.ZK_FILIAL	=	'" + xFilial( "SZK") + "'"							+ CRLF
	cQrySZK += " 	AND SZK.D_E_L_E_T_	=	' '"												+ CRLF

	cQrySZK += " INNER JOIN	" + retSQLName( "SZJ" ) + " SZJ"									+ CRLF
	cQrySZK += " ON"																			+ CRLF
	cQrySZK += " 		SZJ.ZJ_COD   	=	SZK.ZK_CODTPED "									+ CRLF
	cQrySZK += " 	AND	SZJ.ZJ_FILIAL	=	'" + xFilial( "SZJ") + "'"							+ CRLF
	cQrySZK += " 	AND SZJ.D_E_L_E_T_	=	' '"												+ CRLF

	cQrySZK += " WHERE"																			+ CRLF
	cQrySZK += " 		DA0.DA0_XINTSF	=	'P'"												+ CRLF
	//cQrySZK += " 	AND	DA0.DA0_XENVSF	=	'S'"												+ CRLF
	cQrySZK += " 	AND	DA0.DA0_CODTAB	=	'" + QRYDA0->DA0_CODTAB + "'"						+ CRLF
	cQrySZK += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"							+ CRLF
	cQrySZK += " 	AND DA0.D_E_L_E_T_	=	' '"												+ CRLF

	conout("[MGFWSC77] [SALESFORCE] [getSZK] " + cQrySZK)

	tcQuery cQrySZK New Alias "QRYSZK"
return

//---------------------------------------------------------------------------------------------
// Verifica se o Tipo de Pedido é de Venda
//---------------------------------------------------------------------------------------------
static function chkType( cDA0CODTAB )
	local lTipoVenda	:= .F.
	local cQryCHK		:= ""

	cQryCHK += " SELECT DISTINCT ZK_CODTPED, DA0_CODTAB , DA0_DESCRI , DA0_DATDE , DA0_DATATE , DA0_ATIVO , DA0.D_E_L_E_T_ DA0DELETE , "	+ CRLF
	cQryCHK += " DA0.R_E_C_N_O_ DA0RECNO , DA0_ZSTASF , DA0_XENVSF"												+ CRLF
	cQryCHK += " FROM			" + retSQLName( "DA0" ) + " DA0"												+ CRLF

	cQryCHK += " INNER JOIN	" + retSQLName( "SZK" ) + " SZK"													+ CRLF
	cQryCHK += " ON"																							+ CRLF
	cQryCHK += " 		SZK.ZK_CODTAB	=	DA0.DA0_CODTAB"														+ CRLF
	cQryCHK += " AND	SZK.ZK_FILIAL	=	'" + xFilial( "SZK") + "'"											+ CRLF
	cQryCHK += " AND 	SZK.D_E_L_E_T_	=	' '"																+ CRLF

	cQryCHK += " INNER JOIN	" + retSQLName( "SZJ" ) + " SZJ"													+ CRLF
	cQryCHK += " ON"																							+ CRLF
	cQryCHK += " 		SZJ.ZJ_VENDA	=	'S'"																+ CRLF
	cQryCHK += " 	AND	SZK.ZK_CODTPED	=	SZJ.ZJ_COD"															+ CRLF
	cQryCHK += " 	AND	SZJ.ZJ_FILIAL	=	'" + xFilial( "SZJ") + "'"											+ CRLF
	cQryCHK += " 	AND SZJ.D_E_L_E_T_	=	' '"																+ CRLF

	cQryCHK += " WHERE"																							+ CRLF
	cQryCHK += " 		DA0.DA0_CODTAB	=	'" + cDA0CODTAB + "'"												+ CRLF
	cQryCHK += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"											+ CRLF
	cQryCHK += " 	AND DA0.D_E_L_E_T_	=	' '"																+ CRLF

	conout("[MGFFATBO] [SALESFORCE] [chkType] " + cQryCHK)

	tcQuery cQryCHK new alias "QRYCHK"

	if !QRYCHK->( EOF() )
		lTipoVenda := .T.
	endif

	QRYCHK->( DBCloseArea() )
return lTipoVenda
