#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} JOBWSC82
ENVIO DE INTEGRAÇÃO FINANCEIRA
@description
ENVIO DE INTEGRAÇÃO FINANCEIRA
@author TOTVS
@since 26/05/2020
@type Function
@table

@param
 cFilJob - Caracter informa a filial que será usada
@return
 Sem retorno
@menu
 Sem menu
/*/
user function JOBWSC82( cFilJob )

	U_MGFWSC82( { "01" , cFilJob } )

return

/*/
=============================================================================
{Protheus.doc} MNUWSC82
ENVIO DE INTEGRAÇÃO FINANCEIRA
@description
ENVIO DE INTEGRAÇÃO FINANCEIRA
@author TOTVS
@since 26/05/2020
@type Function
@table

@param
 Sem parametro
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MNUWSC82()

	runInteg82()

return

/*/
=============================================================================
{Protheus.doc} MGFWSC82
ENVIO DE INTEGRAÇÃO FINANCEIRA
@description
ENVIO DE INTEGRAÇÃO FINANCEIRA
@author TOTVS
@since 26/05/2020
@type Function
@table
@param
 aEmpX - Array com Empresa e Filial que serão configuradas
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MGFWSC82( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC82] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg82()

	RESET ENVIRONMENT
return

/*/
=============================================================================
{Protheus.doc} runInteg82
ENVIO DE INTEGRAÇÃO FINANCEIRA
@description
ENVIO DE INTEGRAÇÃO FINANCEIRA
@author TOTVS
@since 26/05/2020
@type Function
@table
@param
@return
 Sem retorno
@menu
 Sem menu
/*/
static function runInteg82()
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG"	, , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC82A"		, , "http://spdwvapl203:1666/processo-financeiro/api/v1/resumo-financeiro/lote" ) )
	local cIdInteg		:= FWUUIDV4()
	local cURLUse		:= ""
	local cHTTPMetho	:= "PUT"
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local xRetHttp		:= nil
	local aAreaX		:= getArea()

	local cCodInteg		:= allTrim( superGetMv( "MGFSZ2PROT"	, , "009" ) ) // SZ2 - SISTEMA
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC82B"		, , "001" ) ) // SZ3 - ENTIDADE

	local aFinanceir	:= {}
	local oJsonLimit	:= nil
	local oJsonClien	:= nil

	local nI			:= 0
	local cZF7Recno		:= ""
	local cUpdZF7		:= ""
	local cJson			:= ""

	local cHeadHttp		:= ""

	//Variaveis dos logs
	local cErroLog      := "" // Texto do Erro ocorrido na integração
    local cStaLog		:= "" // Codigo do Status da integração, devera ser 1 (Integrado) ou 2 (Erro)
	local cCodInteg		:= allTrim( superGetMv( "MGFCODSZ22"	, , "009" ) )//Cod. de busca na SZ2, Tabela de Integração
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC82C"		, , "003" ) )//Cod. de busca na SZ3, Tabela Tipo de Integração
	local nMaxItens		:= superGetMv( "MGFWSC82D" , , 200 )

	aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf	)
	aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg	)
	aadd( aHeadStr , 'Content-Type: application/json'	)

    getZF7()

    while !QRYZF7->( EOF() )

		aFinanceir	:= {}
		cZF7Recno	:= ""
		nCountIten	:= 1

		while !QRYZF7->(EOF()) .AND. nCountIten <= nMaxItens
			cZF7Recno	+= allTrim( str( QRYZF7->ZF7RECNO ) ) +  ","

			aadd( aFinanceir , jsonObject():new() )

			aFinanceir[ len( aFinanceir ) ][ "RECNO"]								:= QRYZF7->ZF7RECNO
			aFinanceir[ len( aFinanceir ) ][ "UID"]									:= fwUUIDv4()
			aFinanceir[ len( aFinanceir ) ][ "valorAcumuladoFaturamento180Dias"]	:= QRYZF7->ZF7_ZVALAB
			aFinanceir[ len( aFinanceir ) ][ "valorAcumuladoFaturamento365Dias"]	:= QRYZF7->ZF7_VACUMB
			aFinanceir[ len( aFinanceir ) ][ "qtdDiasMaiorAtraso" ]					:= QRYZF7->ZF7_MATRB
			aFinanceir[ len( aFinanceir ) ][ "mediaDiasAtraso" ]					:= QRYZF7->ZF7_METRB
			aFinanceir[ len( aFinanceir ) ][ "valorPagamentosAtrasadosHistorico" ]	:= QRYZF7->ZF7_PAGATB
			aFinanceir[ len( aFinanceir ) ][ "valorPagamentosAtrasadosEmAberto" ]	:= QRYZF7->ZF7_TITATB
			aFinanceir[ len( aFinanceir ) ][ "qtdCompras" ]							:= QRYZF7->ZF7_NROCOB
			aFinanceir[ len( aFinanceir ) ][ "qtdPagamentos" ]						:= QRYZF7->ZF7_NROPAB
			aFinanceir[ len( aFinanceir ) ][ "valorMaiorCompra" ]					:= QRYZF7->ZF7_MCOMPB
			aFinanceir[ len( aFinanceir ) ][ "valorMaiorDuplicata" ]				:= QRYZF7->ZF7_MAIDUB
			aFinanceir[ len( aFinanceir ) ][ "valorMaiorSaldoDevedor" ]				:= QRYZF7->ZF7_MSALDB
			aFinanceir[ len( aFinanceir ) ][ "valorPedidosEmAberto" ]				:= QRYZF7->ZF7_TOTPVB

			aFinanceir[ len( aFinanceir ) ][ "dataUltimaCompra" ]					:= iif( !empty( QRYZF7->ZF7_ULTCOB ) , left( fwTimeStamp( 3, sToD( QRYZF7->ZF7_ULTCOB ) ) , 10 ) , nil )

			oJsonLimit := nil
			oJsonLimit := jsonObject():new()

			oJsonLimit[ "total" ]		:= QRYZF7->ZF7_LCB
			oJsonLimit[ "utilizado" ]	:= QRYZF7->ZF7_UTILIB
			oJsonLimit[ "secundario" ]	:= QRYZF7->A1_LCFIN
			oJsonLimit[ "vencimento" ]	:= iif( !empty( QRYZF7->A1_VENCLC ) , left( fwTimeStamp( 3, sToD( QRYZF7->A1_VENCLC ) ) , 10 ) , nil )

			aFinanceir[ len( aFinanceir ) ][ "limiteCredito" ] := oJsonLimit

			oJsonClien := nil
			oJsonClien := jsonObject():new()

			if !empty( QRYZF7->A1_DTCAD ) .and. !empty( QRYZF7->A1_HRCAD )
				oJsonClien[ "dataCadastro" ]	:= fwTimeStamp( 3, sToD( QRYZF7->A1_DTCAD ), QRYZF7->A1_HRCAD + ":00" )   // 3 - Fotmato UTC aaaa-mm-ddThh:mm:ss (Soment pega a hora local e coloca neste formato)
			else
				oJsonClien[ "dataCadastro" ]	:= nil
			endif

			oJsonClien[ "id" ]				:= ( QRYZF7->A1_COD + QRYZF7->A1_LOJA )
			oJsonClien[ "cnpj" ]			:= iif( !empty( QRYZF7->A1_CGC )		, QRYZF7->A1_CGC		, nil )
			oJsonClien[ "idCommerce" ]		:= iif( !empty( QRYZF7->A1_ZCDECOM )	, QRYZF7->A1_ZCDECOM	, nil )

			aFinanceir[ len( aFinanceir ) ][ "cliente" ] := oJsonClien

			/*
			[
			{
				"valorAcumuladoFaturamento180Dias": 1230.50,
				"valorAcumuladoFaturamento365Dias": 230.00,
				"qtdDiasMaiorAtraso": 10,
				"mediaDiasAtraso": 10,
				"valorPagamentosAtrasadosHistorico": 123.00,
				"valorPagamentosAtrasadosEmAberto": 132.01,
				"qtdCompras": 123,
				"qtdPagamentos": 123,
				"valorMaiorCompra": 123.00,
				"valorMaiorDuplicata": 123.01,
				"dataUltimaCompra": "2019-01-01",
				"valorMaiorSaldoDevedor": 123.00,
				"valorPedidosEmAberto": 10.00,
				"limiteCredito": {
				"total": 123.00,
				"utilizado": 123.00,
				"secundario": 123.01,
				"vencimento": "2020-01-01"
				},
				"cliente": {
				"dataCadastro": "2014-01-01T23:28:56",
				"cnpj": "2203020300320",
				"idCommerce": "2o2xo3"
				},
				"UID": "9265ccc0-420b-11ea-bd9b-d80f99a790cc"
			}
			]
			*/

			QRYZF7->( DBSkip() )

			nCountIten++
		enddo

		cJson := ""
		cJson := fwJsonSerialize( aFinanceir, .T., .T. )  //Serializar o array de Json

		cTimeIni	:= time()
		cHeaderRet	:= ""
		xRetHttp	:= ""
		xRetHttp	:= httpQuote( cURLInteg /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni , cTimeFin )
		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		conout(" [SALESFORCE] [MGFWSC82] * * * * * Status da integracao * * * * *"									)
		conout(" [SALESFORCE] [MGFWSC82] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
		conout(" [SALESFORCE] [MGFWSC82] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
		conout(" [SALESFORCE] [MGFWSC82] Tempo de Processamento.......: " + cTimeProc 								)
		conout(" [SALESFORCE] [MGFWSC82] URL..........................: " + cURLInteg 								)
		conout(" [SALESFORCE] [MGFWSC82] HTTP Method..................: " + cHTTPMetho								)
		conout(" [SALESFORCE] [MGFWSC82] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
		conout(" [SALESFORCE] [MGFWSC82] Envio........................: " + cJson 									)
		conout(" [SALESFORCE] [MGFWSC82] Retorno......................: " + xRetHttp 								)
		conout(" [SALESFORCE] [MGFWSC82] * * * * * * * * * * * * * * * * * * * * "									)

		if nStatuHttp >= 200 .and. nStatuHttp <= 299
			//Inicializar variáveis.
			cStaLog  := "1"
			cErroLog := ""
			cUpdZF7	:= ""

			cUpdZF7 := "UPDATE " + retSQLName("ZF7")										+ CRLF
			cUpdZF7 += "	SET"															+ CRLF
			cUpdZF7 += "	ZF7_HASHA = ZF7_HASHB"											+ CRLF
			cUpdZF7 += " WHERE"																+ CRLF
			cUpdZF7 += " 		R_E_C_N_O_ IN ("+ left( cZF7Recno , len(cZF7Recno)-1 )+")"  + CRLF

			if tcSQLExec( cUpdZF7 ) < 0
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

		for nI := 1 to len( aFinanceir )
			//GRAVAR LOG
			U_MGFMONITOR(																													 ;
			cFilAnt																			/* Filial */									,;
			cStaLog																			/* Status - 1-Suceso / 2-Erro*/					,;
			cCodInteg																		/* Integração */								,;
			cCodTpInt																		/* Tipo de integração */						,;
			iif( empty( cErroLog ) , "Processamento realizado com sucesso!" , cErroLog )	/*cErro*/										,;
			" "																				/*cDocori*/										,;
			cTimeProc																		/* Tempo de processamento */					,;
			aFinanceir[ nI ]:toJson()														/* JSON */										,;
			aFinanceir[ nI ]["RECNO"]														/* RECNO do registro */							,;
			cValToChar( nStatuHttp )														/* Status HTTP Retornado */						,;
			.F.																				/* Se precisar preparar ambiente enviar .T. */	,;
			{}																				/* Filial para preparar ambiente */				,;
			aFinanceir[ nI ]["UID"]															/* UUID */	     								,;
			iif( type( xRetHttp ) <> "U", xRetHttp, " ")									/* JSON de RETORNO */							,;
			"A"																				/*cTipWsInt*/									,;
			" "																				/*cJsonCB Z1_JSONCB*/							,;
			" "																				/*cJsonRB Z1_JSONRB*/							,;
			sTod("    /  /  ")																/*dDTCallb Z1_DTCALLB*/							,;
			" "																				/*cHoraCall Z1_HRCALLB*/						,;
			" "																				/*cCallBac Z1_CALLBAC*/							,;
			cURLInteg																		/*cLinkEnv Z1_LINKENV*/							,;
			" "																				/*cLinkRec Z1_LINKREC*/							,;
			cIdInteg																		/*cHeaderID		Z1_HEADEID*/					,;
			cHeadHttp																		/*cHeadeHttp	Z1_HEADER*/						)
		next

    enddo

    QRYZF7->( DBCloseArea() )

	restArea( aAreaX )
return

//----------------------------------------------------------
// Seleciona os clientes com dados financeiros atualizados
//----------------------------------------------------------
static function getZF7()
    local cQryWSC82 := ""

	cQryWSC82 := "SELECT"															+ CRLF
	cQryWSC82 += " ZF7.R_E_C_N_O_ ZF7RECNO	,"										+ CRLF
	cQryWSC82 += " ZF7_ZVALAB				,"										+ CRLF
	cQryWSC82 += " ZF7_VACUMB				,"										+ CRLF
	cQryWSC82 += " ZF7_MATRB				,"										+ CRLF
	cQryWSC82 += " ZF7_METRB				,"										+ CRLF
	cQryWSC82 += " ZF7_PAGATB				,"										+ CRLF
	cQryWSC82 += " ZF7_TITATB				,"										+ CRLF
	cQryWSC82 += " ZF7_NROCOB				,"										+ CRLF
	cQryWSC82 += " ZF7_NROPAB				,"										+ CRLF
	cQryWSC82 += " ZF7_MCOMPB				,"										+ CRLF
	cQryWSC82 += " ZF7_MAIDUB				,"										+ CRLF
	cQryWSC82 += " ZF7_ULTCOB				,"										+ CRLF
	cQryWSC82 += " ZF7_MSALDB				,"										+ CRLF
	cQryWSC82 += " ZF7_TOTPVB				,"										+ CRLF
	cQryWSC82 += " ZF7_LCB					,"										+ CRLF
	cQryWSC82 += " ZF7_UTILIB				,"										+ CRLF
	cQryWSC82 += " A1_LCFIN					,"										+ CRLF
	cQryWSC82 += " A1_VENCLC				,"										+ CRLF
	cQryWSC82 += " A1_DTCAD					,"										+ CRLF
	cQryWSC82 += " A1_HRCAD					,"										+ CRLF
	cQryWSC82 += " A1_CGC					,"										+ CRLF
	cQryWSC82 += " A1_ZCDECOM				,"										+ CRLF
	cQryWSC82 += " A1_COD					,"										+ CRLF
	cQryWSC82 += " A1_LOJA"															+ CRLF
	cQryWSC82 += " FROM "			+ retSQLName( "ZF7" ) + " ZF7"					+ CRLF
	cQryWSC82 += " INNER JOIN   "	+ retSQLName( "SA1" ) + " SA1"					+ CRLF
	cQryWSC82 += " ON"																+ CRLF
	cQryWSC82 += "         ZF7.ZF7_LOJA		=	SA1.A1_LOJA"						+ CRLF
	cQryWSC82 += "     AND ZF7.ZF7_COD		=	SA1.A1_COD"							+ CRLF
	cQryWSC82 += "     AND SA1.A1_FILIAL	=	'" + xFilial( "SA1" ) + "'"			+ CRLF
	cQryWSC82 += "     AND SA1.D_E_L_E_T_	=	' '"								+ CRLF
	cQryWSC82 += "    AND ("														+ CRLF
	cQryWSC82 += "         A1_XIDSFOR <> ' '"										+ CRLF
	cQryWSC82 += "         OR"														+ CRLF
	cQryWSC82 += "         ( (SA1.A1_ZCDECOM <> ' ' or SA1.A1_ZCDEREQ <> ' ' ) )"	+ CRLF
	cQryWSC82 += "     )"															+ CRLF
	cQryWSC82 += " WHERE"															+ CRLF
	cQryWSC82 += " 		ZF7.ZF7_HASHA	<>	ZF7.ZF7_HASHB"							+ CRLF
	cQryWSC82 += " 	AND	ZF7.ZF7_FILIAL	=	'" + xFilial( "ZF7" ) + "'"				+ CRLF
	cQryWSC82 += " 	AND	ZF7.D_E_L_E_T_	<>	'*'"									+ CRLF

	conout( "[MGFWSC82] [SALESFORCE] " + cQryWSC82 )

	tcQuery cQryWSC82 new alias "QRYZF7"
return