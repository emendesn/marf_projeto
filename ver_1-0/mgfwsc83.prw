#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} MGFWSC83
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
user function MGFWSC83( cA1Cod , cA1Loja )
	// MOCK - POST		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/Tabela de Preço
	// MOCK - PUT		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/Tabela de Preço/{id}
	// MOCK - DELETE	- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/Tabela de Preço/{id}

	//local cURLInteg		:= allTrim( superGetMv( "MGFWSC83A" , , "https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/Tabela de Preço/{id}" ) )
	local cIdInteg		:= ""
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG", , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC83A" , , "http://integracoes-homologacao.marfrig.com.br:1663/processo-tabela-preco/api/v2/tabela-preco/{id}/clientes" ) )
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

	local cCodInteg		:= allTrim( superGetMv( "MGF_CODSZ2"	, , "009" ) ) // SZ2 - SISTEMA
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC83B"		, , "004" ) ) // SZ3 - ENTIDADE
	local aClientes	:= {}
	local nI

/*
	POST: {url base padrão do mule}:1663/processo-tabela-preco/api/v2/tabela-preco/{id}/clientes

	{id}: Id da tabela de preço

	headers:
	x-marfrig-client-id: <<valor fixo>>
	x-correlation-id: <<valor aleatório para cada integração>>

	body:
	[
	{
	"id": "4842",
	"loja": "12",
	"UID":  <<valor aleatório para cada integração>>
	}
	]

	*enviar no máximo lotes de 200 registros
*/

	U_MFCONOUT("Selecionando Tabela de Preço aptos a integrar com SALESFORCE")

	getDA0( cA1Cod , cA1Loja )

	while !QRYWSC83->( EOF() )
        cIdInteg	:= ""
		cIdInteg	:= fwUUIDv4()

		aHeadStr	:= {}
		aClientes	:= {}

		aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf  )
		aadd( aHeadStr , 'Content-Type: application/json'  )
		aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg   )

		oJson := nil
		oJson := jsonObject():new()

		//oJson["id"]			:= QRYWSC83->ZG_CODCLI
		//oJson["loja"]		:= QRYWSC83->ZG_LOJCLI
		oJson["id"]			:= cA1Cod
		oJson["loja"]		:= cA1Loja
		oJson["UID"]		:= fwUUIDv4()

		aadd( aClientes , oJson )

		cJson := ""
		cJson := fwJsonSerialize( aClientes , .T. , .T. )  //Serializar o array de Json

		cURLUse		:= strTran( cURLInteg , "{id}" , QRYWSC83->DA0_CODTAB )

		cHTTPMetho	:= "POST"

		cTimeIni	:= time()
		cHeaderRet	:= ""
		cHttpRet	:= ""
		cHttpRet	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni , cTimeFin )
		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		U_MFCONOUT(" * * * * * Status da integracao * * * * *"									)
		U_MFCONOUT(" Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
		U_MFCONOUT(" Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
		U_MFCONOUT(" Tempo de Processamento.......: " + cTimeProc 								)
		U_MFCONOUT(" URL..........................: " + cURLUse 								)
		U_MFCONOUT(" HTTP Method..................: " + cHTTPMetho								)
		U_MFCONOUT(" Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
		U_MFCONOUT(" Envio........................: " + cJson 									)
		U_MFCONOUT(" Retorno......................: " + cHttpRet 								)
		U_MFCONOUT(" * * * * * * * * * * * * * * * * * * * * "									)

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
		QRYWSC83->DA0RECNO																							/*nRecnoDoc*/,;
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

		QRYWSC83->( DBSkip() )

		freeObj( oJson )
	enddo

	QRYWSC83->( DBCloseArea() )

	delClassINTF()
return


//---------------------------------------------------------------------------------------------
// SELECIONA TABELAS DO CLIENTE - APENAS DE TABELA NÃO EXCLUSIVAS
//---------------------------------------------------------------------------------------------
static procedure getDA0( cA1Cod , cA1Loja )
	local cQryWSC83
	local lDA0Active	:= superGetMv( "MGFWSC83C"		, , .T. ) // ATUALIZA APENAS TABELAS DE PREÇO ATIVO
	local lComercial	:= superGetMv( "MGFWSC83D"		, , .T. ) // ATUALIZA APENAS TABELAS DE PREÇO COMERCIAIS

	cQryWSC83 := " SELECT DISTINCT DA0RECNO , DA0_CODTAB , ZG_CODCLI , ZG_LOJCLI"		+ CRLF
	cQryWSC83 += " FROM"																+ CRLF
	cQryWSC83 += " ("																	+ CRLF

	//****************************************************************************************
	// Clientes amarrados ao vendedor
	//****************************************************************************************

	cQryWSC83 += " SELECT DA0.R_E_C_N_O_ DA0RECNO , DA0.DA0_CODTAB, "					+ CRLF
	cQryWSC83 += "        ZBJ_CLIENT ZG_CODCLI , ZBJ_LOJA ZG_LOJCLI"					+ CRLF
	cQryWSC83 += " FROM		" + retSQLName( "DA0" ) + " DA0"							+ CRLF
	cQryWSC83 += " LEFT JOIN	" + retSQLName( "SZG" ) + " SZG"						+ CRLF
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SZG.ZG_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQryWSC83 += " 	AND	SZG.ZG_FILIAL	=	'" + xFilial( "SZG") + "'"					+ CRLF
	cQryWSC83 += " 	AND SZG.D_E_L_E_T_	=	' '"										+ CRLF
	cQryWSC83 += " INNER JOIN	" + retSQLName( "SZC" ) + " SZC"						+ CRLF
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SZC.ZC_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQryWSC83 += " 	AND	SZC.ZC_FILIAL	=	'" + xFilial( "SZC") + "'"					+ CRLF
	cQryWSC83 += " 	AND SZC.D_E_L_E_T_	=	' '"										+ CRLF
	cQryWSC83 += " LEFT JOIN	" + retSQLName( "ZBJ" ) + " ZBJ"						+ CRLF
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SZC.ZC_CODVEND	=	ZBJ.ZBJ_REPRES"								+ CRLF

	cQryWSC83 += " 	AND	ZBJ.ZBJ_LOJA	=	'" + cA1Loja	+ "'"						+ CRLF
	cQryWSC83 += " 	AND	ZBJ.ZBJ_CLIENT	=	'" + cA1Cod	+ "'"						    + CRLF

	cQryWSC83 += " 	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial( "ZBJ") + "'"					+ CRLF
	cQryWSC83 += " 	AND ZBJ.D_E_L_E_T_	=	' '"										+ CRLF

	if lComercial
		cQryWSC83 += " INNER JOIN	" + retSQLName( "SZK" ) + " SZK"						+ CRLF
		cQryWSC83 += " ON"																	+ CRLF
		cQryWSC83 += " 		SZK.ZK_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
		cQryWSC83 += " AND	SZK.ZK_FILIAL	=	'" + xFilial( "SZK") + "'"					+ CRLF
		cQryWSC83 += " AND 	SZK.D_E_L_E_T_	=	' '"										+ CRLF

		cQryWSC83 += " INNER JOIN	" + retSQLName( "SZJ" ) + " SZJ"						+ CRLF
		cQryWSC83 += " ON"																	+ CRLF
		cQryWSC83 += " 		SZJ.ZJ_VENDA	=	'S'"										+ CRLF
		cQryWSC83 += " 	AND	SZK.ZK_CODTPED	=	SZJ.ZJ_COD"									+ CRLF
		cQryWSC83 += " 	AND	SZJ.ZJ_FILIAL	=	'" + xFilial( "SZJ") + "'"					+ CRLF
		cQryWSC83 += " 	AND SZJ.D_E_L_E_T_	=	' '"										+ CRLF
	endif

	cQryWSC83 += " WHERE"																+ CRLF
	cQryWSC83 += " 		DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
	cQryWSC83 += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF

	if lDA0Active
		cQryWSC83 += " 	AND DA0_ATIVO	=	'1'"											+ CRLF
		cQryWSC83 += " 	AND DA0_DATDE	<=	'" + dToS( dDataBase ) + "'"					+ CRLF
		cQryWSC83 += " 	AND DA0_DATATE	>=	'" + dToS( dDataBase ) + "'"					+ CRLF
	endif

	cQryWSC83 += " 	AND SZG.ZG_CODTAB IS NULL"											+ CRLF

	cQryWSC83 += " UNION ALL"															+ CRLF

	//****************************************************************************************
	// Clientes amarrados a região
	//****************************************************************************************

	cQryWSC83 += " SELECT DA0.R_E_C_N_O_ DA0RECNO , DA0.DA0_CODTAB,"	   				+ CRLF
	cQryWSC83 += "        A1_COD ZG_CODCLI, A1_LOJA ZG_LOJCLI"							+ CRLF
	cQryWSC83 += " FROM "			+ retSQLName( "DA0" ) + " DA0"						+ CRLF
	cQryWSC83 += " LEFT JOIN	" + retSQLName( "SZG" ) + " SZG"						+ CRLF
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SZG.ZG_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQryWSC83 += " 	AND	SZG.ZG_FILIAL	=	'" + xFilial( "SZG") + "'"					+ CRLF
	cQryWSC83 += " 	AND SZG.D_E_L_E_T_	=	' '"								        + CRLF

	if lComercial
		cQryWSC83 += " INNER JOIN	" + retSQLName( "SZK" ) + " SZK"						+ CRLF
		cQryWSC83 += " ON"																	+ CRLF
		cQryWSC83 += " 		SZK.ZK_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
		cQryWSC83 += " AND	SZK.ZK_FILIAL	=	'" + xFilial( "SZK") + "'"					+ CRLF
		cQryWSC83 += " AND 	SZK.D_E_L_E_T_	=	' '"										+ CRLF

		cQryWSC83 += " INNER JOIN	" + retSQLName( "SZJ" ) + " SZJ"						+ CRLF
		cQryWSC83 += " ON"																	+ CRLF
		cQryWSC83 += " 		SZJ.ZJ_VENDA	=	'S'"										+ CRLF
		cQryWSC83 += " 	AND	SZK.ZK_CODTPED	=	SZJ.ZJ_COD"									+ CRLF
		cQryWSC83 += " 	AND	SZJ.ZJ_FILIAL	=	'" + xFilial( "SZJ") + "'"					+ CRLF
		cQryWSC83 += " 	AND SZJ.D_E_L_E_T_	=	' '"										+ CRLF
	endif

	cQryWSC83 += " INNER JOIN	"	+ retSQLName( "SZI" ) + " SZI"						+ CRLF // TABELA DE PRECO x REGIAO
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SZI.ZI_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQryWSC83 += " 	AND	SZI.ZI_FILIAL	=	'" + xFilial( "SZI") + "'"					+ CRLF
	cQryWSC83 += " 	AND SZI.D_E_L_E_T_	=	' '"										+ CRLF
	cQryWSC83 += " INNER JOIN "	+ retSQLName( "SZP" ) + " SZP"							+ CRLF // REGIAO x CD
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SZP.ZP_CODREG	=	SZI.ZI_CODREG"								+ CRLF
	cQryWSC83 += " 	AND SZP.ZP_FILIAL	=	'" + xFilial( "SZP") + "'"					+ CRLF
	cQryWSC83 += " 	AND SZP.D_E_L_E_T_	<>	'*'"										+ CRLF
	cQryWSC83 += " INNER JOIN "	+ retSQLName( "ZAP" ) + " ZAP"							+ CRLF // CIDADES x REGIAO
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		ZAP.ZAP_CODREG	=	SZP.ZP_CODREG"								+ CRLF
	cQryWSC83 += " 	AND ZAP.ZAP_FILIAL	=	'" + xFilial( "ZAP") + "'"					+ CRLF
	cQryWSC83 += " 	AND ZAP.D_E_L_E_T_	<>	'*'"										+ CRLF
	cQryWSC83 += " LEFT JOIN "	+ retSQLName( "SA1" ) + " SA1"							+ CRLF
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SA1.A1_EST		=	ZAP.ZAP_UF"									+ CRLF
	cQryWSC83 += " 	AND SA1.A1_COD_MUN	=	ZAP.ZAP_CODMUN"								+ CRLF
	cQryWSC83 += " 	AND SA1.A1_FILIAL	=	'" + xFilial( "SA1") + "'"					+ CRLF
	cQryWSC83 += " 	AND SA1.D_E_L_E_T_	<>	'*'"										+ CRLF
	cQryWSC83 += " 	AND	SA1.A1_EST		<>	'EX' "										+ CRLF
	cQryWSC83 += " 	AND	SA1.A1_XIDSFOR	<>	' ' "										+ CRLF

	cQryWSC83 += " 	AND	SA1.A1_LOJA		=	'" + cA1Loja	+ "'"						+ CRLF
	cQryWSC83 += " 	AND	SA1.A1_COD		=	'" + cA1Cod	+ "'"							+ CRLF
	cQryWSC83 += " 	AND	SA1.A1_XINTSFO  =	'I'"						  				+ CRLF

	cQryWSC83 += " WHERE"																+ CRLF
	cQryWSC83 += " 		DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
	cQryWSC83 += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF
	cQryWSC83 += " 	AND SZG.ZG_CODTAB IS NULL"											+ CRLF

	if lDA0Active
		cQryWSC83 += " 	AND DA0_ATIVO	=	'1'"											+ CRLF
		cQryWSC83 += " 	AND DA0_DATDE	<=	'" + dToS( dDataBase ) + "'"					+ CRLF
		cQryWSC83 += " 	AND DA0_DATATE	>=	'" + dToS( dDataBase ) + "'"					+ CRLF
	endif

	cQryWSC83 += " UNION ALL"															+ CRLF

	//****************************************************************************************
	// Clientes amarrados no Estado
	//****************************************************************************************

	cQryWSC83 += " SELECT DA0.R_E_C_N_O_ DA0RECNO , DA0.DA0_CODTAB , A1_COD ZG_CODCLI, A1_LOJA ZG_LOJCLI"	+ CRLF
	cQryWSC83 += " FROM "		+ retSQLName( "DA0" ) + " DA0"							+ CRLF
	cQryWSC83 += " LEFT JOIN "	+ retSQLName( "SZG" ) + " SZG"							+ CRLF
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SZG.ZG_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQryWSC83 += " 	AND	SZG.ZG_FILIAL	=	'" + xFilial( "SZG") + "'"					+ CRLF
	cQryWSC83 += " 	AND SZG.D_E_L_E_T_	=	' '"										+ CRLF

	if lComercial
		cQryWSC83 += " INNER JOIN	" + retSQLName( "SZK" ) + " SZK"						+ CRLF
		cQryWSC83 += " ON"																	+ CRLF
		cQryWSC83 += " 		SZK.ZK_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
		cQryWSC83 += " AND	SZK.ZK_FILIAL	=	'" + xFilial( "SZK") + "'"					+ CRLF
		cQryWSC83 += " AND 	SZK.D_E_L_E_T_	=	' '"										+ CRLF

		cQryWSC83 += " INNER JOIN	" + retSQLName( "SZJ" ) + " SZJ"						+ CRLF
		cQryWSC83 += " ON"																	+ CRLF
		cQryWSC83 += " 		SZJ.ZJ_VENDA	=	'S'"										+ CRLF
		cQryWSC83 += " 	AND	SZK.ZK_CODTPED	=	SZJ.ZJ_COD"									+ CRLF
		cQryWSC83 += " 	AND	SZJ.ZJ_FILIAL	=	'" + xFilial( "SZJ") + "'"					+ CRLF
		cQryWSC83 += " 	AND SZJ.D_E_L_E_T_	=	' '"										+ CRLF
	endif

	cQryWSC83 += " INNER JOIN	" + retSQLName( "SZH" ) + " SZH"						+ CRLF
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SZH.ZH_CODTAB	=	DA0.DA0_CODTAB"								+ CRLF
	cQryWSC83 += " 	AND	SZH.ZH_FILIAL	=	'" + xFilial( "SZH") + "'"					+ CRLF
	cQryWSC83 += " 	AND SZH.D_E_L_E_T_	=	' '"										+ CRLF
	cQryWSC83 += " INNER JOIN "	+ retSQLName( "SA1" ) + " SA1"							+ CRLF
	cQryWSC83 += " ON"																	+ CRLF
	cQryWSC83 += " 		SA1.A1_EST		=	SZH.ZH_CODEST"								+ CRLF
	cQryWSC83 += " 	AND SA1.A1_FILIAL	=	'" + xFilial( "SA1") + "'"					+ CRLF
	cQryWSC83 += " 	AND SA1.D_E_L_E_T_	<>	'*'"										+ CRLF
	cQryWSC83 += " 	AND	SA1.A1_EST		<>	'EX' "										+ CRLF
	cQryWSC83 += " 	AND	SA1.A1_XIDSFOR	<>	' ' "										+ CRLF

	cQryWSC83 += " 	AND	SA1.A1_LOJA		=	'" + cA1Loja + "'"							+ CRLF
	cQryWSC83 += " 	AND	SA1.A1_COD		=	'" + cA1Cod	+ "'"							+ CRLF
	cQryWSC83 += " 	AND	SA1.A1_XINTSFO  =	'I'"						  				+ CRLF

	cQryWSC83 += " WHERE"																+ CRLF
	cQryWSC83 += " 		DA0.DA0_FILIAL	=	'" + xFilial( "DA0") + "'"					+ CRLF
	cQryWSC83 += " 	AND DA0.D_E_L_E_T_	=	' '"										+ CRLF
	cQryWSC83 += " 	AND SZG.ZG_CODTAB IS NULL"											+ CRLF

	if lDA0Active
		cQryWSC83 += " 	AND DA0_ATIVO	=	'1'"											+ CRLF
		cQryWSC83 += " 	AND DA0_DATDE	<=	'" + dToS( dDataBase ) + "'"					+ CRLF
		cQryWSC83 += " 	AND DA0_DATATE	>=	'" + dToS( dDataBase ) + "'"					+ CRLF
	endif

	cQryWSC83 += " ) TABA"																+ CRLF

	U_MFCONOUT( "[QUERY] [cQryWSC83] " + cQryWSC83 )

	tcQuery cQryWSC83 new alias "QRYWSC83"
return
