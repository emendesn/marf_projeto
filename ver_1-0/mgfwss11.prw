#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#include "fwmvcdef.ch"

#define CRLF chr( 13 ) + chr( 10 )

static _aErr

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_CUSTOMER
	WSDATA A1_NOME		AS STRING OPTIONAL
	WSDATA A1_NREDUZ	AS STRING OPTIONAL
	WSDATA A1_CGC		AS STRING
	WSDATA A1_INSCR		AS STRING OPTIONAL
	WSDATA A1_CEP		AS STRING OPTIONAL
	WSDATA A1_END		AS STRING OPTIONAL
	WSDATA A1_COMPLEM	AS STRING OPTIONAL
	WSDATA A1_EST		AS STRING OPTIONAL
	WSDATA A1_COD_MUN	AS STRING OPTIONAL
	WSDATA A1_DDD		AS STRING OPTIONAL
	WSDATA A1_BAIRRO	AS STRING OPTIONAL
	WSDATA A1_TEL		AS STRING OPTIONAL
	WSDATA A1_CNAE		AS STRING OPTIONAL
	WSDATA A1_CNAES		AS STRING OPTIONAL
	WSDATA A1_DTNASC	AS STRING OPTIONAL
	WSDATA A1_EMAIL		AS STRING OPTIONAL
	WSDATA A1_SIMPNAC	AS STRING OPTIONAL
	WSDATA A1_VEND		AS STRING OPTIONAL
	WSDATA A1_CONTATO	AS STRING OPTIONAL
	WSDATA A1_XIDSFOR	AS STRING
	WSDATA A1_ZSUGELC	AS FLOAT OPTIONAL
	WSDATA A1_ZSUGPRZ	AS STRING OPTIONAL
	WSDATA A1_CEPC		AS STRING OPTIONAL
	WSDATA A1_ENDCOB	AS STRING OPTIONAL
	WSDATA A1_ESTC		AS STRING OPTIONAL
	WSDATA A1_MUNC		AS STRING OPTIONAL
	WSDATA A1_BAIRROC	AS STRING OPTIONAL
	WSDATA A1_XMAILCO	AS STRING OPTIONAL
	WSDATA A1_XCOMPCO	AS STRING OPTIONAL
	WSDATA A1_XCDMUNC	AS STRING OPTIONAL
	WSDATA A1_XTELCOB	AS STRING OPTIONAL
	//WSDATA LISTACNAE	AS ARRAY OF WSS11_XCNAE OPTIONAL
	WSDATA INTEGRATED	AS BOOLEAN OPTIONAL
	WSDATA CALLBACK		AS BOOLEAN OPTIONAL
	WSDATA MSGCALLBACK	AS STRING OPTIONAL
	WSDATA UUID			AS STRING OPTIONAL
	WSDATA REACTIVATION	AS BOOLEAN OPTIONAL
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_FINANCIAL_LIMIT
	WSDATA CODIGO_LOJA	AS STRING
	WSDATA A1_LC		AS FLOAT OPTIONAL
	WSDATA A1_COND		AS STRING OPTIONAL
	WSDATA A1_VENCLC	AS STRING OPTIONAL
	WSDATA A1_ZREDE		AS STRING OPTIONAL
	WSDATA A1_ZBOLETO	AS STRING OPTIONAL
	WSDATA A1_ZGDERED	AS STRING OPTIONAL
	WSDATA A1_ZALTCRE	AS STRING OPTIONAL
	WSDATA APPROVED		AS BOOLEAN
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_ADDRESS
	WSDATA Z9_ZCLIENT	AS STRING OPTIONAL // + Z9_ZLOJA
	//WSDATA Z9_ZLOJA		AS STRING OPTIONAL
	//WSDATA Z9_ZCGC		AS STRING OPTIONAL
	WSDATA Z9_ZRAZEND	AS STRING OPTIONAL
	WSDATA Z9_ZENDER	AS STRING OPTIONAL
	WSDATA Z9_ZBAIRRO	AS STRING OPTIONAL
	WSDATA Z9_ZCEP		AS STRING OPTIONAL
	WSDATA Z9_ZEST		AS STRING OPTIONAL
	WSDATA Z9_ZCODMUN	AS STRING OPTIONAL
	WSDATA Z9_ZMUNIC	AS STRING OPTIONAL
	WSDATA Z9_ZIDEND	AS STRING OPTIONAL
	WSDATA Z9_XIDSFOR	AS STRING OPTIONAL
	WSDATA Z9_ZCOMPLE	AS STRING OPTIONAL
	WSDATA DELETE		AS BOOLEAN OPTIONAL
	WSDATA INTEGRATED	AS BOOLEAN OPTIONAL
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_GENERAL_STATUS
	WSDATA status			AS STRING
	WSDATA message			AS STRING
	WSDATA codProtheus		AS STRING
	WSDATA codProtheusLoja	AS STRING  OPTIONAL
	WSDATA codExternal		AS STRING
	WSDATA blocked			AS BOOLEAN OPTIONAL
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_CONTACT
	WSDATA U5_CODCONT	AS STRING OPTIONAL
	WSDATA U5_CONTAT	AS STRING OPTIONAL
	WSDATA U5_CLIENTE	AS STRING OPTIONAL // + U5_LOJA
	WSDATA U5_DDD		AS STRING OPTIONAL
	WSDATA U5_FCOM2		AS STRING OPTIONAL
	WSDATA U5_CELULAR	AS STRING OPTIONAL
	WSDATA U5_EMAIL		AS STRING OPTIONAL
	WSDATA U5_XIDSFOR	AS STRING OPTIONAL
	WSDATA DELETE		AS BOOLEAN OPTIONAL
	WSDATA INTEGRATED	AS BOOLEAN OPTIONAL
	WSDATA U5_XDEPTO	AS STRING OPTIONAL
	WSDATA U5_XCARGO	AS STRING OPTIONAL
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_ZC5
	WSDATA ZC5_FILIAL	as string
	WSDATA ZC5_CLIENT	as string optional
	WSDATA ZC5_ZTIPPE	as string optional
	WSDATA ZC5_VENDED	as string optional
	WSDATA ZC5_ZIDEND	as string optional
	WSDATA ZC5_CODCON	as string optional // CONDIÇÃO DE PAGAMENTO
	WSDATA ZC5_CODTAB	as string optional // TABELA DE PREÇO
	WSDATA ZC5_DTENTR	as string optional
	WSDATA ZC5_IDEXTE	as string optional // ID Unico
	WSDATA ZC5_RESERV	as string optional // Reserva estoque?
	WSDATA ZC5_ORCAME	as string optional // Orçamento?
	WSDATA ZC5_PVREDE	as string optional // Pedido de Rede?
	WSDATA ZC5_PVPAI	as string optional // Pedido de Origem
	WSDATA ZC5_PVPROT	as string optional // Pedido Protheus - usado apenas na alteração
	WSDATA ZC5_PEDCLI	as string optional
	WSDATA ZC5_ORIGEM	as string optional
	WSDATA ZC5_XOBSPE	as string optional
	WSDATA ZC5_MSGNOT	as string optional

	/*
C5_MENNOTA
ZC5_MSGNOT

		ZC5_PEDCLI	-	C5_ZPEDCLI
		ZC5_ORIGEM	-	C5_XORIGEM

		DATA EMISSAO DO SALESFORCE - C5_EMISSAO
	*/
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_ZC6
	WSDATA ZC6_ITEM		as string optional
	WSDATA ZC6_PRODUT	as string optional
	WSDATA ZC6_QTDVEN	as float optional
	WSDATA ZC6_PRCVEN	as float optional
	WSDATA ZC6_DTMINI	as string optional
	WSDATA ZC6_DTMAXI	as string optional
	WSDATA CANCEL		as string optional
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_SALESORDER
	WSDATA header	as WSS11_ZC5
	WSDATA items	as array of WSS11_ZC6 optional
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_SC5
	WSDATA C5_FILIAL	as STRING
	WSDATA C5_NUM		as STRING
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_CAMPO
	WSDATA CHAVE	as STRING
	WSDATA VALOR	as STRING
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_CALLBACK_INTEGRATION
	WSDATA UUID			as STRING
	WSDATA ENTIDADE		as STRING
	WSDATA SISTEMA		as STRING
	WSDATA STATUS		as STRING // 1 - SUCESSO, 2 - ERRO NEGOCIO, 3 - ERRO APLICAÇÃO
	WSDATA MENSAGEM		as STRING
	WSDATA CAMPOS		as ARRAY OF WSS11_CAMPO OPTIONAL
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_RETURN
	WSDATA TIPO						as STRING optional
	WSDATA CONDICAOPAGAMENTO		as STRING optional
	WSDATA STATUS					as STRING optional
	WSDATA DATAENTREGA				as STRING optional // 1 - SUCESSO, 2 - ERRO NEGOCIO, 3 - ERRO APLICAÇÃO
	WSDATA IDVENDEDOR				as STRING optional
	WSDATA NUMERONF					as STRING optional
	WSDATA CLIENTEID				as STRING optional
	WSDATA CLIENTELOJA				as STRING optional
	WSDATA CLIENTECNPJ				as STRING optional
	WSDATA NUMEROPEDIDOERP			as STRING optional
	WSDATA IDENDERECO				as STRING optional
	WSDATA MENSAGEMERRO				as STRING optional
	WSDATA NUMEROPEDIDOPAIREDE		as STRING optional
	WSDATA NUMEROPEDIDOCLIENTE		as STRING optional
	WSDATA REDE						as STRING optional
	WSDATA RESEVAESTOQUE			as STRING optional
	WSDATA ORCAMENTO				as STRING optional
	WSDATA IDTABELAPRECO			as STRING optional
	WSDATA IDSISTEMAORIGEM			as STRING optional
	WSDATA BLOQUEIOS				AS ARRAY OF WSS11_BLOCK optional
	WSDATA ITEMS					AS ARRAY OF WSS11_ITEM optional
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_BLOCK
	WSDATA CODIGO		AS STRING optional
	WSDATA DESCRICAO	AS STRING optional
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_ITEM
	WSDATA ITEM				AS STRING optional
	WSDATA QUANTIDADEKG		AS FLOAT optional
	WSDATA STATUS			AS STRING optional
	WSDATA IDPRODUTO		AS STRING optional
	WSDATA PRECO			AS FLOAT optional
	WSDATA BLOQUEIOS		AS ARRAY OF WSS11_BLOCK optional
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSTRUCT WSS11_financialInformation
	WSDATA valorAcumuladoFaturamento180Dias		AS FLOAT	optional
	WSDATA valorAcumuladoFaturamento365Dias		AS FLOAT	optional
	WSDATA qtdDiasMaiorAtraso					AS FLOAT	optional
	WSDATA mediaDiasAtraso						AS FLOAT	optional
	WSDATA valorPagamentosAtrasadosHistorico	AS FLOAT	optional
	WSDATA valorPagamentosAtrasadosEmAberto		AS FLOAT	optional
	WSDATA qtdCompras							AS FLOAT	optional
	WSDATA qtdPagamentos						AS FLOAT	optional
	WSDATA valorMaiorCompra						AS FLOAT	optional
	WSDATA valorMaiorDuplicata					AS FLOAT	optional
	WSDATA valorMaiorSaldoDevedor				AS FLOAT	optional
	WSDATA valorPedidosEmAberto					AS FLOAT	optional
	WSDATA total								AS FLOAT	optional
	WSDATA utilizado							AS FLOAT	optional
	WSDATA secundario							AS FLOAT	optional
	WSDATA dataUltimaCompra						AS STRING	optional
	WSDATA vencimento							AS STRING	optional
	WSDATA dataCadastro							AS STRING	optional
	WSDATA cnpj									AS STRING	optional
	WSDATA idCommerce							AS STRING	optional
ENDWSSTRUCT

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSSERVICE MGFWSS11 DESCRIPTION "SALESFORCE" namespace "http://www.totvs.com.br/MGFWSS11"
	WSDATA codRequest			AS STRING
	WSDATA customer				AS WSS11_CUSTOMER
	WSDATA generalResponse		AS WSS11_GENERAL_STATUS
	WSDATA address				AS WSS11_ADDRESS
	WSDATA contact				AS WSS11_CONTACT
	WSDATA helloRequest			AS STRING
	WSDATA helloReponse			AS STRING
	WSDATA financialLimit		AS WSS11_FINANCIAL_LIMIT
	WSDATA salesOrder			AS WSS11_SALESORDER
	WSDATA cancelSalesOrder		AS WSS11_SC5
	WSDATA callbackIntegration	AS WSS11_CALLBACK_INTEGRATION
	WSDATA response				AS WSS11_RETURN
	WSDATA financialInformation	AS WSS11_financialInformation

	WSMETHOD hello						DESCRIPTION "Ping"
	WSMETHOD insertOrUpdateCustomer		DESCRIPTION "Inclusão / Atualização Cliente no Protheus - Síncrono"
	WSMETHOD insertOrUpdateAddress		DESCRIPTION "Inclusão / Alteração de Endereço de Entrega no Protheus - Síncrono"
	WSMETHOD insertOrUpdateContact		DESCRIPTION "Inclusão / Alteração de Contato de Cliente no Protheus - Síncrono"
	WSMETHOD updateFinancialLimit		DESCRIPTION "Alteração de Limite Financeiro do Cliente no Protheus - Síncrono"
	WSMETHOD insertSalesOrder			DESCRIPTION "Inclusão de Pedido de Vendas no Protheus - Assíncrono"
	WSMETHOD updateSalesOrder			DESCRIPTION "Alteração de Pedido de Vendas no Protheus - Síncrono"
	WSMETHOD cancelSalesOrder			DESCRIPTION "Cancelamento de Pedido de Vendas no Protheus - Síncrono"
	WSMETHOD callbackIntegration		DESCRIPTION "Callback de Integração - Síncrono"
	WSMETHOD getfinancialInformation	DESCRIPTION "Retorna dado financeiros do cliente"
ENDWSSERVICE

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD getfinancialInformation WSRECEIVE codRequest WSSEND financialInformation WSSERVICE MGFWSS11
    local cQryZF7	:= ""
	local aAreaX	:= getArea()

	setFunName( "MGFWSS11" )

	conout( "[MGFWSS11] [BEGIN] [getfinancialInformation] " + dToC( dDataBase ) + " - " + time() )

	varInfo( "codRequest" , ::codRequest )

	::financialInformation := WSClassNew( "WSS11_financialInformation")

	cQryZF7 := "SELECT"															+ CRLF
	cQryZF7 += " ZF7.R_E_C_N_O_ ZF7RECNO	,"									+ CRLF
	cQryZF7 += " ZF7_ZVALAB				,"										+ CRLF
	cQryZF7 += " ZF7_VACUMB				,"										+ CRLF
	cQryZF7 += " ZF7_MATRB				,"										+ CRLF
	cQryZF7 += " ZF7_METRB				,"										+ CRLF
	cQryZF7 += " ZF7_PAGATB				,"										+ CRLF
	cQryZF7 += " ZF7_TITATB				,"										+ CRLF
	cQryZF7 += " ZF7_NROCOB				,"										+ CRLF
	cQryZF7 += " ZF7_NROPAB				,"										+ CRLF
	cQryZF7 += " ZF7_MCOMPB				,"										+ CRLF
	cQryZF7 += " ZF7_MAIDUB				,"										+ CRLF
	cQryZF7 += " ZF7_ULTCOB				,"										+ CRLF
	cQryZF7 += " ZF7_MSALDB				,"										+ CRLF
	cQryZF7 += " ZF7_TOTPVB				,"										+ CRLF
	cQryZF7 += " ZF7_LCB				,"										+ CRLF
	cQryZF7 += " ZF7_UTILIB				,"										+ CRLF
	cQryZF7 += " A1_LCFIN				,"										+ CRLF
	cQryZF7 += " A1_VENCLC				,"										+ CRLF
	cQryZF7 += " A1_DTCAD				,"										+ CRLF
	cQryZF7 += " A1_HRCAD				,"										+ CRLF
	cQryZF7 += " A1_CGC					,"										+ CRLF
	cQryZF7 += " A1_ZCDECOM"													+ CRLF
	cQryZF7 += " FROM "			+ retSQLName( "ZF7" ) + " ZF7"					+ CRLF
	cQryZF7 += " INNER JOIN   "	+ retSQLName( "SA1" ) + " SA1"					+ CRLF
	cQryZF7 += " ON"															+ CRLF
	cQryZF7 += "         ZF7.ZF7_LOJA		=	SA1.A1_LOJA"					+ CRLF
	cQryZF7 += "     AND ZF7.ZF7_COD		=	SA1.A1_COD"						+ CRLF
	cQryZF7 += "     AND SA1.A1_FILIAL	=	'" + xFilial( "SA1" ) + "'"			+ CRLF
	cQryZF7 += "     AND SA1.D_E_L_E_T_	=	' '"								+ CRLF
	cQryZF7 += " WHERE"															+ CRLF
	//cQryZF7 += " 		SA1.A1_CGC		=	'" + allTrim( ::codRequest ) + "'"	+ CRLF

	cQryZF7 += "		ZF7.ZF7_COD || ZF7.ZF7_LOJA =	'" + allTrim( ::codRequest )	+ "'"	+ CRLF
	cQryZF7 += " 	AND	ZF7.ZF7_FILIAL				=	'" + xFilial( "ZF7" )			+ "'"	+ CRLF
	cQryZF7 += " 	AND	ZF7.D_E_L_E_T_				<>	'*'"									+ CRLF

	conout( "[MGFWSS11] [getfinancialInformation] " + cQryZF7 )

	tcQuery cQryZF7 new alias "QRYZF7"

	if !QRYZF7->( EOF() )
		::financialInformation:valorAcumuladoFaturamento180Dias		:= QRYZF7->ZF7_ZVALAB
		::financialInformation:valorAcumuladoFaturamento365Dias		:= QRYZF7->ZF7_VACUMB
		::financialInformation:qtdDiasMaiorAtraso					:= QRYZF7->ZF7_MATRB
		::financialInformation:mediaDiasAtraso						:= QRYZF7->ZF7_METRB
		::financialInformation:valorPagamentosAtrasadosHistorico	:= QRYZF7->ZF7_PAGATB
		::financialInformation:valorPagamentosAtrasadosEmAberto		:= QRYZF7->ZF7_TITATB
		::financialInformation:qtdCompras							:= QRYZF7->ZF7_NROCOB
		::financialInformation:qtdPagamentos						:= QRYZF7->ZF7_NROPAB
		::financialInformation:valorMaiorCompra						:= QRYZF7->ZF7_MCOMPB
		::financialInformation:valorMaiorDuplicata					:= QRYZF7->ZF7_MAIDUB
		::financialInformation:dataUltimaCompra						:= QRYZF7->ZF7_ULTCOB
		::financialInformation:valorMaiorSaldoDevedor				:= QRYZF7->ZF7_MSALDB
		::financialInformation:valorPedidosEmAberto					:= QRYZF7->ZF7_TOTPVB
		::financialInformation:total								:= QRYZF7->ZF7_LCB
		::financialInformation:utilizado							:= QRYZF7->ZF7_UTILIB
		::financialInformation:secundario							:= QRYZF7->A1_LCFIN
		::financialInformation:vencimento							:= left( fwTimeStamp( 3, sToD( QRYZF7->A1_VENCLC ) , ) , 10 )
		::financialInformation:dataCadastro							:= fwTimeStamp( 3, sToD( QRYZF7->A1_DTCAD ), QRYZF7->A1_HRCAD )
		::financialInformation:cnpj									:= QRYZF7->A1_CGC
		::financialInformation:idCommerce							:= QRYZF7->A1_ZCDECOM
	endif

    QRYZF7->( DBCloseArea() )

	varInfo( "financialInformation" , ::financialInformation )

	conout( "[MGFWSS11] [END] getfinancialInformation " + dToC( dDataBase ) + " - " + time() )

	delClassINTF()

	restArea( aAreaX )
RETURN .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD callbackIntegration WSRECEIVE callbackIntegration WSSEND generalResponse WSSERVICE MGFWSS11
	local bError		:= ErrorBlock( { |oError| MyError( oError ) } )
	local cSystemTMS	:= allTrim( superGetMv( "MFG_WSS11G" , , "011" ) ) // Cod. de busca na SZ2, Tabela de Integração

	setFunName( "MGFWSS11" )

	conout( "[MGFWSS11] [BEGIN] [callbackIntegration] " + dToC( dDataBase ) + " - " + time() )

	varInfo( "callbackIntegration" , ::callbackIntegration )

	::generalResponse := WSClassNew( "WSS11_GENERAL_STATUS")

	BEGIN SEQUENCE

/*
	WSDATA UUID			as STRING
	WSDATA ENTIDADE		as STRING
	WSDATA SISTEMA		as STRING
	WSDATA STATUS		as STRING // 1 - SUCESSO, 2 - ERRO NEGOCIO, 3 - ERRO APLICAÇÃO
	WSDATA MENSAGEM		as STRING
*/

		U_MGFCALLB(	::callbackIntegration:UUID			/*Z1_UUID*/								,;
					::callbackIntegration:MENSAGEM		/*Z1_JSONCB*/							,;
					::callbackIntegration:MENSAGEM		/*Z1_JSONRB*/							,;
					dDataBase							/*Z1_DTCALLBK*/							,;
					time()								/*Z1_HRCALLBK*/							,;
					::callbackIntegration:STATUS		/*Z1_CALLBACK - I=Integrado;E=Erro*/	,;
					""									/*Z1_LINKENV*/							,;
					funName()							/*Z1_LINKREC*/							,;
					::callbackIntegration:SISTEMA		/*Z1_INTEGRA*/							,;
					::callbackIntegration:ENTIDADE		/*Z1_TPINTEG*/							)

		if ::callbackIntegration:SISTEMA == cSystemTMS //011
			_cSitWss11 := ' '
			_cMsgWss11 := ::callbackIntegration:MENSAGEM
			_cEntWss11 := ::callbackIntegration:ENTIDADE
			_cStaWss11 := ::callbackIntegration:STATUS			
			_cUidWss11 := ::callbackIntegration:UUID
			_cProtWss11 := ' '
			if ::callbackIntegration:CAMPOS[2]:CHAVE != nil
				if ::callbackIntegration:CAMPOS[2]:CHAVE == "situacao"
					_cSitWss11	:= ::callbackIntegration:CAMPOS[2]:VALOR
				endif
			endif
			if ::callbackIntegration:CAMPOS[3]:CHAVE != nil
				if ::callbackIntegration:CAMPOS[3]:CHAVE == "situacao"
					_cSitWss11	:= ::callbackIntegration:CAMPOS[3]:VALOR
				endif	
			endif
			_cControle := 0
			If _cSitWss11 == '1'	
				if ::callbackIntegration:CAMPOS[ _cControle+1 ]:CHAVE != Nil		
					if ::callbackIntegration:CAMPOS[ _cControle+1 ]:CHAVE == "protocolo"
						_cProtWss11 := ::callbackIntegration:CAMPOS[_cControle+1 ]:VALOR				//PROTOCOLO
						_cControle += 1
					endif
				endif
			endif
			if ::callbackIntegration:CAMPOS[ _cControle+1 ]:CHAVE != Nil
				if ::callbackIntegration:CAMPOS[ _cControle+1 ]:CHAVE == "filial"
					_cFilWss11  := ::callbackIntegration:CAMPOS[ _cControle+1 ]:VALOR				//FILIAL
					_cControle += 1
				endif
			endif
			if ::callbackIntegration:CAMPOS[ _cControle+1 ]:CHAVE != Nil
				if ::callbackIntegration:CAMPOS[ _cControle+1 ]:CHAVE == "situacao"
					_cSitWss11	:= ::callbackIntegration:CAMPOS[ _cControle+1 ]:VALOR				//SITUAÇÃO
					_cControle += 1
				endif
			endif
			if ::callbackIntegration:CAMPOS[ _cControle+1 ]:CHAVE != Nil
				if ::callbackIntegration:CAMPOS[ _cControle+1 ]:CHAVE == "pedido"
					_cPedWss11	:= ::callbackIntegration:CAMPOS[ _cControle+1 ]:VALOR				//SITUAÇÃO
					_cControle += 1
				endif
			endif
				
			// _cSisWss11 = 1 	-	Inclusão  -  Atualiza C5_ZTMSID 
			//				3	-	Alteração -  
			//				4	-	Cancelar  |  Atualiza C5_ZTMSERR COM MENSAGEM
			//				2	-	Erro	  -  
			DBSelectaREA("SC5")
			SC5->( DBSetOrder(1) )
			if SC5->( DBSeek( _cFilWss11 + _cPedWss11 ) )
				reclock("SC5",.F.)
				if  _cSitWss11 == '1'
					SC5->C5_ZTMSID := _cProtWss11 
				elseif _cSitWss11 $ '2|3|4'
					SC5->C5_ZTMSERR := _cMsgWss11 
				endif
				SC5->(MSUNLOCK())
			EndIf
		endif

		::generalResponse:status			:= "1"
		::generalResponse:message			:= "Callback recebido"
		::generalResponse:codProtheus		:= ::callbackIntegration:UUID
		::generalResponse:codProtheusLoja	:= ::callbackIntegration:UUID
		::generalResponse:codExternal		:= ::callbackIntegration:UUID
		::generalResponse:blocked			:= .F.
	RECOVER
		conout('[MGFWSS11] [END] [callbackIntegration] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
	END SEQUENCE

	if valType(_aErr) == 'A'
		::generalResponse:status			:= _aErr[1]
		::generalResponse:message			:= _aErr[2]
		::generalResponse:codProtheus		:= ::callbackIntegration:UUID
		::generalResponse:codExternal		:= ""
		::generalResponse:blocked			:= .F.
	endif

	varInfo( "generalResponse" , ::generalResponse )

	delClassINTF()
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD cancelSalesOrder WSRECEIVE cancelSalesOrder WSSEND response WSSERVICE MGFWSS11
	local bError			:= ErrorBlock( { |oError| MyError( oError ) } )
	local aErro				:= {}
	local cErro				:= ""
	local nI				:= 0

	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	private cQrySZVRet		:= ""

	setFunName( "MGFWSS11" )

	conout( "[MGFWSS11] [BEGIN] cancelSalesOrder " + dToC( dDataBase ) + " - " + time() )

	varInfo( "cancelSalesOrder" , ::cancelSalesOrder )

	::response := WSClassNew( "WSS11_RETURN")

	BEGIN SEQUENCE
		cEmpAnt := left( allTrim( ::cancelSalesOrder:C5_FILIAL ) , 2 )
		cFilAnt := allTrim( ::cancelSalesOrder:C5_FILIAL )

		DBSelectArea( "SC5" )
		SC5->( DBSetOrder( 1 ) ) // C5_FILIAL+C5_NUM

		SC5->( DBGoTop() )

		if SC5->( DBSeek( allTrim( ::cancelSalesOrder:C5_FILIAL ) + allTrim( ::cancelSalesOrder:C5_NUM ) ) )
			if SC5->( DBRLock( SC5->( RECNO() ) ) )

				aSC5 := {}

				aadd(aSC5, {'C5_FILIAL'	, SC5->C5_FILIAL		, NIL})
				aadd(aSC5, {'C5_NUM'	, SC5->C5_NUM			, NIL})

				aSC5 := fwVetByDic( aSC5 /*aVetor*/ , "SC5" /*cTable*/ , .F. /*lItens*/ )

				varInfo( "aSC5" , aSC5 )

				U_MFCONOUT("[MGFWSS11] [cancelSalesOrder] Alterando pedido "  + alltrim( ::cancelSalesOrder:C5_FILIAL ) + "/"+ ALLTRIM( ::cancelSalesOrder:C5_NUM ) + "...")

				msExecAuto( { | x , y , z | MATA410( x , y , z ) } , aSC5 , {} , 5 )

				if lMsErroAuto
					aErro := GetAutoGRLog() // Retorna erro em array
					cErro := ""

					for nI := 1 to len(aErro)
						cErro += aErro[nI] + CRLF
					next nI

					::response:STATUS				:= "0"
					::response:MENSAGEMERRO			:= cErro
				else
					conout('[MGFWSS11] [cancelSalesOrder] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' ' + time() )

					::response:STATUS				:= "1"
					::response:MENSAGEMERRO			:= ""
				endif

				::response:TIPO					:= SC5->C5_ZTIPPED
				::response:CONDICAOPAGAMENTO	:= SC5->C5_CONDPAG
				::response:DATAENTREGA			:= dTos( SC5->C5_FECENT )
				::response:IDVENDEDOR			:= SC5->C5_VEND1
				::response:NUMERONF				:= ""
				::response:CLIENTEID			:= SC5->C5_CLIENTE
				::response:CLIENTELOJA			:= SC5->C5_LOJACLI
				::response:CLIENTECNPJ			:= ""
				::response:NUMEROPEDIDOERP		:= SC5->C5_NUM
				::response:IDENDERECO			:= SC5->C5_ZIDEND
				::response:REDE					:= SC5->C5_XREDE
				::response:NUMEROPEDIDOPAIREDE	:= SC5->C5_XPVPAI
				::response:NUMEROPEDIDOCLIENTE	:= SC5->C5_ZPEDCLI
				::response:RESEVAESTOQUE		:= SC5->C5_XRESERV
				::response:ORCAMENTO			:= SC5->C5_XORCAME
				::response:IDTABELAPRECO		:= SC5->C5_TABELA
				::response:IDSISTEMAORIGEM		:= SC5->C5_XORIGEM

				::response:BLOQUEIOS			:= {} // BLOQUEIOS DO PEDIDO - NAO POSSUI NA EXCLUSAO
				::response:ITEMS				:= {} // ITENS - NAO POSSUI NA EXCLUSAO

				SC5->( DBRUnlock( SC5->( RECNO() ) ) )
			endif
		else
			::response:STATUS				:= "1"
			::response:MENSAGEMERRO			:= "Pedido de Venda não localizado."
			::response:NUMEROPEDIDOERP		:= ::cancelSalesOrder:C5_NUM
		endif
	RECOVER
		conout('[MGFWSS11] [cancelSalesOrder] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
	END SEQUENCE

	if valType(_aErr) == 'A'
		::response:STATUS				:= _aErr[1]
		::response:MENSAGEMERRO			:= _aErr[2]
		::response:NUMEROPEDIDOERP		:= ::cancelSalesOrder:C5_NUM
	endif

	varInfo( "response" , ::response )

	conout( "[MGFWSS11] [END] cancelSalesOrder " + dToC( dDataBase ) + " - " + time() )

	delClassINTF()
RETURN .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD updateSalesOrder WSRECEIVE salesOrder WSSEND response WSSERVICE MGFWSS11
	local bError		:= ErrorBlock( { |oError| MyError( oError ) } )
	local aRequest		:= {}
	local lExecFAT14	:= .F.
	local nI			:= 0
	local cNotFAT14		:=  superGetMv( "MFG_WSS11E" , , "ZC5_FILIAL | ZC5_PVPROT | ZC5_XOBSPE | ZC5_PEDCLI | ZC5_MSGNOT" )

	private cQrySZVRet	:= ""

	setFunName( "MGFWSS11" )

	conout( "[MGFWSS11] [BEGIN] updateSalesOrder " + dToC( dDataBase ) + " - " + time() )

	varInfo( "salesOrder" , ::salesOrder )

	::response := WSClassNew( "WSS11_RETURN")

	BEGIN SEQUENCE
		// lExecFAT14 -> Indica se devera executar regras do FAT14
		lExecFAT14 := .F.

		if len( ::salesOrder:items ) > 0
			lExecFAT14 := .T.
		else
			aRequest	:= {}
			aRequest	:= classDataArr( ::salesOrder:header )

			for nI := 1 to len( aRequest )
				if !( aRequest[ nI , 1 ] $ cNotFAT14 ) .and. !empty( aRequest[ nI , 2 ] )
					lExecFAT14 := .T.
					exit
				endif
			next
		endif

		if lExecFAT14
			U_RUNFAT53( @::salesOrder , @::response )
		else
			DBSelectArea( "SC5" )
			SC5->( DBSetOrder( 1 ) ) // C5_FILIAL+C5_NUM
			if SC5->( DBSeek( allTrim( salesOrder:header:ZC5_FILIAL ) + allTrim( salesOrder:header:ZC5_PVPROT ) ) )
				if SC5->( DBRLock( SC5->( RECNO() ) ) )
					if SC5->C5_ZROAD <> "S"
						recLock("SC5", .F.)
							if !empty( ::salesOrder:header:ZC5_MSGNOT )
								SC5->C5_MENNOTA := ::salesOrder:header:ZC5_MSGNOT
							endif

							if !empty( ::salesOrder:header:ZC5_XOBSPE )
								SC5->C5_XOBSPED := ::salesOrder:header:ZC5_XOBSPE
							endif

							if !empty( ::salesOrder:header:ZC5_PEDCLI )
								SC5->C5_ZPEDCLI := ::salesOrder:header:ZC5_PEDCLI

								DBSelectArea( "SC6" )
								SC6->( DBSetOrder( 1 ) ) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

								if SC6->( DBSeek( allTrim( salesOrder:header:ZC5_FILIAL ) + allTrim( salesOrder:header:ZC5_PVPROT ) ) )
									while !SC6->( EOF() ) .and. SC6->( C6_FILIAL + C6_NUM ) == allTrim( salesOrder:header:ZC5_FILIAL ) + allTrim( salesOrder:header:ZC5_PVPROT )

										recLock("SC6", .F.)
											SC6->C6_ITEMPC	:= SC6->C6_ITEM
											SC6->C6_NUMPCOM	:= ::salesOrder:header:ZC5_PEDCLI
										SC6->(msUnlock())

										SC6->( DBSkip() )
									enddo
								endif

							endif

							// Flags para enviar para o Taura
							SC5->C5_ZBLQTAU	:= 'S'
							SC5->C5_ZLIBENV	:= 'S'
						SC5->( msUnlock() )

						::response:STATUS				:= "1"
						::response:MENSAGEMERRO			:= ""
						::response:TIPO					:= SC5->C5_ZTIPPED
						::response:CONDICAOPAGAMENTO	:= SC5->C5_CONDPAG
						::response:DATAENTREGA			:= dTos( SC5->C5_FECENT )
						::response:IDVENDEDOR			:= SC5->C5_VEND1
						::response:NUMERONF				:= ""
						::response:CLIENTEID			:= SC5->C5_CLIENTE
						::response:CLIENTELOJA			:= SC5->C5_LOJACLI
						::response:CLIENTECNPJ			:= ""
						::response:NUMEROPEDIDOERP		:= SC5->C5_NUM
						::response:IDENDERECO			:= SC5->C5_ZIDEND
						::response:REDE					:= SC5->C5_XREDE
						::response:NUMEROPEDIDOPAIREDE	:= SC5->C5_XPVPAI
						::response:NUMEROPEDIDOCLIENTE	:= SC5->C5_ZPEDCLI
						::response:RESEVAESTOQUE		:= SC5->C5_XRESERV
						::response:ORCAMENTO			:= SC5->C5_XORCAME
						::response:IDTABELAPRECO		:= SC5->C5_TABELA
						::response:IDSISTEMAORIGEM		:= SC5->C5_XORIGEM

						// BLOQUEIOS DO PEDIDO

						::response:BLOQUEIOS			:= {}

						u_getSZVx( .F. , SC5->C5_FILIAL , SC5->C5_NUM , )

						while !(cQrySZVRet)->( EOF() )
							oBloqueio			:= nil
							oBloqueio			:= WSClassNew( "WSS11_BLOCK")

							oBloqueio:codigo	:= allTrim( (cQrySZVRet)->ZV_CODRGA )
							oBloqueio:descricao	:= allTrim( (cQrySZVRet)->ZT_DESCRI )

							aadd( ::response:BLOQUEIOS , oBloqueio )

							(cQrySZVRet)->( DBSkip() )
						enddo

						(cQrySZVRet)->( DBCloseArea() )

						SC6->( DBGoTop() )

						::response:ITEMS := {}

						if SC6->( DBSeek( SC5->C5_FILIAL + SC5->C5_NUM ) )

							while !SC6->( EOF() ) .and. SC5->C5_FILIAL == SC6->C6_FILIAL .and.  SC5->C5_NUM == SC6->C6_NUM
								oItem				:= nil
								oItem				:= WSClassNew( "WSS11_ITEM")

								oItem:ITEM			:= SC6->C6_ITEM
								oItem:QUANTIDADEKG	:= SC6->C6_QTDVEN
								oItem:IDPRODUTO		:= SC6->C6_PRODUTO
								oItem:PRECO			:= SC6->C6_PRCVEN
								oItem:STATUS		:= "L"

								// BLOQUEIOS DOS ITENS
								oItem:BLOQUEIOS := {}

								u_getSZVx( .T. , SC5->C5_FILIAL , SC5->C5_NUM , SC6->C6_ITEM )

								while !(cQrySZVRet)->( EOF() )
									oItem:STATUS		:= "B"

									oBloqueio			:= nil
									oBloqueio			:= WSClassNew( "WSS11_BLOCK")

									oBloqueio:codigo	:= allTrim( (cQrySZVRet)->ZV_CODRGA )
									oBloqueio:descricao	:= allTrim( (cQrySZVRet)->ZT_DESCRI )

									aadd( oItem:BLOQUEIOS , oBloqueio )

									(cQrySZVRet)->( DBSkip() )
								enddo

								(cQrySZVRet)->( DBCloseArea() )
								// FIM - BLOQUEIOS DOS ITENS

								SC6->( DBSkip() )

								aadd( ::response:ITEMS , oItem )
							enddo
						endif

					else
						::response:STATUS				:= "0"
						::response:MENSAGEMERRO			:= "Pedido de Venda Roteirizado não permite edição."
						::response:NUMEROPEDIDOERP		:= salesOrder:header:ZC5_PVPROT
					endif

					SC5->( DBRUnlock( SC5->( RECNO() ) ) )
				else
					::response:STATUS				:= "0"
					::response:MENSAGEMERRO			:= "Pedido de Venda não disponível para edição no momento."
					::response:NUMEROPEDIDOERP		:= salesOrder:header:ZC5_PVPROT
				endif
			else
				::response:STATUS				:= "0"
				::response:MENSAGEMERRO			:= "Pedido de Venda não localizado."
				::response:NUMEROPEDIDOERP		:= salesOrder:header:ZC5_PVPROT
			endif
		endif

	RECOVER
		conout('[MGFWSS11] [updateSalesOrder] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
	END SEQUENCE

	if valType(_aErr) == 'A'
		::Response:STATUS			:= _aErr[1]
		::Response:MENSAGEMERRO		:= _aErr[2]
		::Response:NUMEROPEDIDOERP	:= ::salesOrder:header:ZC5_IDEXTE
	endif

	varInfo( "response" , ::response )

	conout( "[MGFWSS11] [END] updateSalesOrder " + dToC( dDataBase ) + " - " + time() )

	delClassINTF()
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
USER FUNCTION RUNFAT53( oSalesOrde , oResponse )
	local nI				:= 0
	local nJ				:= 0
    local aSC5				:= {}
    local aSC6				:= {}
	local aLine				:= {}
	local aCustomer			:= {}
	local aErro				:= {}
	local cErro				:= ""
	local nStackSX8			:= GetSx8Len()
	local nTamProd			:= superGetMv( "MFG_WSS17A" , , 6 )
	local lCancel			:= .F.
	local lNewItem			:= .F.
	local cUpdSC5			:= ""
	local cBlockOrca		:= superGetMv( "MFG_WSS17C" , , "777777" )

	private lMsHelpAuto     := .T.
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	cEmpAnt := left( allTrim( oSalesOrde:header:ZC5_FILIAL ) , 2 )
	cFilAnt := allTrim( oSalesOrde:header:ZC5_FILIAL )

	DBSelectArea( "SC5" )
	SC5->( DBSetOrder( 1 ) ) // C5_FILIAL+C5_NUM

	if SC5->( DBSeek( allTrim( oSalesOrde:header:ZC5_FILIAL ) + allTrim( oSalesOrde:header:ZC5_PVPROT ) ) )
		if SC5->( DBRLock( SC5->( RECNO() ) ) )

			if SC5->C5_XORCAME == "S"
				// SE FOR ORCAMENTO LIMPA O BLOQUEIO GERADO PARA NAO FATURAR
				DBSelectArea( 'SZV' )
				SZV->( DBSetOrder( 1 ) ) //ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
				if SZV->( DBSeek( xFilial('SZV') + SC5->C5_NUM + "01" + cBlockOrca ) )
					recLock("SZV", .F.)
						SZV->( DBDelete() )
					SZV->(msUnlock())
				endif
			endif

			aSC5 := {}
			aSC6 := {}

			aadd(aSC5, {'C5_FILIAL'	, SC5->C5_FILIAL		, NIL})
			aadd(aSC5, {'C5_NUM'	, SC5->C5_NUM			, NIL})

			if !empty( oSalesOrde:header:ZC5_CLIENT )
				aCustomer := {}
				aCustomer := staticCall( MGFFAT53, FAT53CLI , oSalesOrde:header:ZC5_CLIENT )

				aadd(aSC5, {'C5_CLIENTE'	, aCustomer[1, 1]										, NIL})
				aadd(aSC5, {'C5_LOJACLI'	, aCustomer[1, 2]										, NIL})
				aadd(aSC5, {'C5_TIPOCLI'	, aCustomer[1, 4]										, NIL})
			else
				aadd(aSC5, {'C5_CLIENTE'	, SC5->C5_CLIENTE										, NIL})
				aadd(aSC5, {'C5_LOJACLI'	, SC5->C5_LOJACLI										, NIL})
				aadd(aSC5, {'C5_TIPOCLI'	, SC5->C5_TIPOCLI										, NIL})
			endif

			if !empty( oSalesOrde:header:ZC5_ZTIPPE )
				aadd(aSC5, {'C5_ZTIPPED'	, oSalesOrde:header:ZC5_ZTIPPE						, NIL})
			else
				aadd(aSC5, {'C5_ZTIPPED'	, SC5->C5_ZTIPPED									, NIL})
			endif

			if !empty( oSalesOrde:header:ZC5_CODTAB )
				aadd(aSC5, {'C5_TABELA'		, oSalesOrde:header:ZC5_CODTAB						, NIL})
			else
				aadd(aSC5, {'C5_TABELA'		, SC5->C5_TABELA									, NIL})
			endif

			if !empty( oSalesOrde:header:ZC5_CODCON )
				aadd(aSC5, {'C5_CONDPAG'	, oSalesOrde:header:ZC5_CODCON						, NIL})
			else
				aadd(aSC5, {'C5_CONDPAG'	, SC5->C5_CONDPAG									, NIL})
			endif

			if !empty( oSalesOrde:header:ZC5_ORCAME )
				aadd(aSC5, {'C5_XORCAME'	, oSalesOrde:header:ZC5_ORCAME						, NIL})
			else
				aadd(aSC5, {'C5_XORCAME'	, SC5->C5_XORCAME									, NIL})
			endif

			if !empty( oSalesOrde:header:ZC5_RESERV )
				aadd(aSC5, {'C5_XRESERV'	, oSalesOrde:header:ZC5_RESERV						, NIL})
			else
				aadd(aSC5, {'C5_XRESERV'	, SC5->C5_XRESERV									, NIL})
			endif

			if !empty( oSalesOrde:header:ZC5_VENDED )
				aadd(aSC5, {'C5_VEND1'		, oSalesOrde:header:ZC5_VENDED						, NIL})
			else
				aadd(aSC5, {'C5_VEND1'		, SC5->C5_VEND1										, NIL})
			endif

			if !empty( oSalesOrde:header:ZC5_MSGNOT )
				aadd(aSC5, {'C5_MENNOTA'		, oSalesOrde:header:ZC5_MSGNOT					, NIL})
			else
				aadd(aSC5, {'C5_MENNOTA'		, SC5->C5_MENNOTA								, NIL})
			endif

			if !empty( oSalesOrde:header:ZC5_ZIDEND )
				aadd(aSC5, {'C5_ZIDEND'	, oSalesOrde:header:ZC5_ZIDEND							, NIL})
			else
				if !empty( SC5->C5_ZIDEND )
					aadd(aSC5, {'C5_ZIDEND'	, SC5->C5_ZIDEND									, NIL})
				endif
			endif

			if !empty( oSalesOrde:header:ZC5_DTENTR )
				aadd(aSC5, {'C5_FECENT'		, sToD( oSalesOrde:header:ZC5_DTENTR ) 				, NIL})
				aadd(aSC5, {'C5_ZDTEMBA'	, sToD( oSalesOrde:header:ZC5_DTENTR ) 				, NIL})
			else
				if !empty( SC5->C5_FECENT )
					aadd(aSC5, {'C5_FECENT'		, SC5->C5_FECENT								, NIL})
				endif

				if !empty( SC5->C5_ZDTEMBA )
					aadd(aSC5, {'C5_ZDTEMBA'	, SC5->C5_ZDTEMBA								, NIL})
				endif
			endif

			if !empty( oSalesOrde:header:ZC5_PEDCLI )
				aadd(aSC5, {'C5_ZPEDCLI'	, oSalesOrde:header:ZC5_PEDCLI			, NIL})
			else
				aadd(aSC5, {'C5_ZPEDCLI'	, SC5->C5_ZPEDCLI						, NIL})
			endif

			if !empty( oSalesOrde:header:ZC5_XOBSPE )
				aadd(aSC5, {'C5_XOBSPED'	, oSalesOrde:header:ZC5_XOBSPE			, NIL})
			else
				aadd(aSC5, {'C5_XOBSPED'	, SC5->C5_XOBSPED						, NIL})
			endif

			DBSelectArea( "SC6" )
			SC6->( DBSetOrder( 1 ) ) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

			if SC6->( DBSeek( allTrim( oSalesOrde:header:ZC5_FILIAL ) + allTrim( oSalesOrde:header:ZC5_PVPROT ) ) )
				while !SC6->( EOF() ) .and. SC6->( C6_FILIAL + C6_NUM ) == allTrim( oSalesOrde:header:ZC5_FILIAL ) + allTrim( oSalesOrde:header:ZC5_PVPROT )

					aLine	:= {}
					lCancel	:= .F.

					for nI := 1 to len( oSalesOrde:items )
						//if allTrim( SC6->C6_PRODUTO ) == alltrim( oSalesOrde:items[ nI ]:ZC6_PRODUT )
						if allTrim( SC6->C6_PRODUTO ) == padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" ) .and. allTrim( oSalesOrde:items[ nI ]:CANCEL ) <> "C"
							aadd(aLine, {'C6_ITEM'			, SC6->C6_ITEM									, NIL})

							aadd(aLine, {'C6_PRODUTO'		, SC6->C6_PRODUTO								, NIL})

							if !empty( oSalesOrde:items[ nI ]:ZC6_QTDVEN )
								aadd(aLine, {'C6_QTDVEN'	, oSalesOrde:items[ nI ]:ZC6_QTDVEN				, NIL})
							else
								aadd(aLine, {'C6_QTDVEN'	, SC6->C6_QTDVEN								, NIL})
							endif

							if !empty( oSalesOrde:items[ nI ]:ZC6_PRCVEN )
								aadd(aLine, {'C6_PRCVEN'	, oSalesOrde:items[ nI ]:ZC6_PRCVEN				, NIL})
							else
								aadd(aLine, {'C6_PRCVEN'	, SC6->C6_PRCVEN								, NIL})
							endif

							if !empty( oSalesOrde:header:ZC5_CODTAB )
								aadd(aLine, {'C6_PRUNIT'	, staticCall( MGFFAT53 , FAT53PRC , 0 , padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" ) , oSalesOrde:header:ZC5_CODTAB	)	, NIL})
							else
								aadd(aLine, {'C6_PRUNIT'	, staticCall( MGFFAT53 , FAT53PRC , 0 , padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" ) , SC5->C5_TABELA					)	, NIL})
							endif

							if !empty( oSalesOrde:items[ nI ]:ZC6_DTMINI )
								aadd(aLine, {'C6_ZDTMIN'	, sToD( oSalesOrde:items[ nI ]:ZC6_DTMINI )		, NIL})
							else
								aadd(aLine, {'C6_ZDTMIN'	, SC6->C6_ZDTMIN								, NIL})
							endif

							if !empty( oSalesOrde:items[ nI ]:ZC6_DTMAXI )
								aadd(aLine, {'C6_ZDTMAX'	, sToD( oSalesOrde:items[ nI ]:ZC6_DTMAXI )		, NIL})
							else
								aadd(aLine, {'C6_ZDTMAX'	, SC6->C6_ZDTMAX								, NIL})
							endif

							if !empty( oSalesOrde:header:ZC5_PEDCLI )
								aadd(aLine, {'C6_ITEMPC'	, SC6->C6_ITEM					, NIL})
								aadd(aLine, {'C6_NUMPCOM'	, oSalesOrde:header:ZC5_PEDCLI	, NIL})
							else
								aadd(aLine, {'C6_ITEMPC'	, SC6->C6_ITEMPC				, NIL})
								aadd(aLine, {'C6_NUMPCOM'	, SC6->C6_NUMPCOM				, NIL})
							endif

							aadd( aLine , { 'AUTDELETA' ,'N'												, Nil			} )
							//aadd( aLine , { 'LINPOS'	,'C6_ITEM'											, SC6->C6_ITEM	} )

							exit
						elseif allTrim( SC6->C6_PRODUTO ) == padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" ) .and. allTrim( oSalesOrde:items[ nI ]:CANCEL ) == "C"
							// SE O ITEM ESTIVER CANCELADO

							lCancel := .T.
							aadd(aLine, {'C6_ITEM'		, SC6->C6_ITEM		, NIL})
							aadd(aLine, {'C6_PRODUTO'	, SC6->C6_PRODUTO	, NIL})
							aadd(aLine, {'C6_QTDVEN'	, SC6->C6_QTDVEN	, NIL})
							aadd(aLine, {'C6_PRCVEN'	, SC6->C6_PRCVEN	, NIL})
							aadd(aLine, {'C6_PRUNIT'	, SC6->C6_PRUNIT	, NIL})
							aadd(aLine, {'C6_ZDTMIN'	, SC6->C6_ZDTMIN	, NIL})
							aadd(aLine, {'C6_ZDTMAX'	, SC6->C6_ZDTMAX	, NIL})
							aadd(aLine, { 'AUTDELETA'	, 'S'				, Nil})
							//aadd( aLine , { 'LINPOS'	,'C6_ITEM'			, SC6->C6_ITEM	} )

							/*
							recLock( "SC6" , .F. )
								SC6->( DBDelete() )
							SC6->( msUnLock() )
							*/

							exit
						endif
					next

					if len( aLine ) == 0
						// SE NAO ENCONTRAR O PRODUTO - PREENCHE COM SC6 EXISTENTE - NAO INCLUI OS CANCELADOS
						aadd(aLine, {'C6_ITEM'		, SC6->C6_ITEM		, NIL})
						aadd(aLine, {'C6_PRODUTO'	, SC6->C6_PRODUTO	, NIL})
						aadd(aLine, {'C6_QTDVEN'	, SC6->C6_QTDVEN	, NIL})

						aadd(aLine, {'C6_PRCVEN'	, SC6->C6_PRCVEN	, NIL})

						if !empty( SC6->C6_PRUNIT )
							aadd(aLine, {'C6_PRUNIT'	, SC6->C6_PRUNIT	, NIL})
						else
							aadd(aLine, {'C6_PRUNIT'	, staticCall( MGFFAT53 , FAT53PRC , 0 , allTrim( SC6->C6_PRODUTO ) , SC5->C5_TABELA ) , NIL})
						endif

						aadd(aLine, {'C6_ZDTMIN'	, SC6->C6_ZDTMIN	, NIL})
						aadd(aLine, {'C6_ZDTMAX'	, SC6->C6_ZDTMAX	, NIL})

						if !empty( oSalesOrde:header:ZC5_PEDCLI )
							aadd(aLine, {'C6_ITEMPC'	, SC6->C6_ITEM					, NIL})
							aadd(aLine, {'C6_NUMPCOM'	, oSalesOrde:header:ZC5_PEDCLI	, NIL})
						else
							aadd(aLine, {'C6_ITEMPC'	, SC6->C6_ITEMPC				, NIL})
							aadd(aLine, {'C6_NUMPCOM'	, SC6->C6_NUMPCOM				, NIL})
						endif

						aadd(aLine, {'AUTDELETA'	, 'N'				, Nil})

						//aadd(aLine, { 'LINPOS'		,'C6_ITEM'			, SC6->C6_ITEM	} )
					endif

					if len( aLine ) > 0
						aadd( aSC6, aLine )
					endif

					SC6->( DBSkip() )
				enddo
			endif

			// ADD ITENS NOVOS
			cMaxItem := ""
			cMaxItem := getMaxSC6( SC5->C5_FILIAL , SC5->C5_NUM )

			if len( aSC6 ) > 0
				for nI := 1 to len( oSalesOrde:items )
					if allTrim( oSalesOrde:items[ nI ]:CANCEL ) <> "C" // NAO CONSIDERA OS CANCELADOS
						lNewItem := .T.
						for nJ := 1 to len( aSC6 )
							if allTrim( aSC6[ nJ , 2 , 2 ] ) == allTrim( padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" ) )
								lNewItem := .F.
								exit
							endif
						next

						if lNewItem
							aLine := {}

							cMaxItem := soma1( cMaxItem )

							aadd(aLine, {'C6_ITEM'		, cMaxItem																																			, NIL})
							aadd(aLine, {'C6_PRODUTO'	, padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" )																				, NIL})
							aadd(aLine, {'C6_QTDVEN'	, oSalesOrde:items[ nI ]:ZC6_QTDVEN																													, NIL})
							aadd(aLine, {'C6_PRCVEN'	, oSalesOrde:items[ nI ]:ZC6_PRCVEN																													, NIL})

							if !empty( oSalesOrde:header:ZC5_CODTAB )
								aadd(aLine, {'C6_PRUNIT'	, staticCall( MGFFAT53 , FAT53PRC , 0 , padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" ) , oSalesOrde:header:ZC5_CODTAB	)	, NIL})
							else
								aadd(aLine, {'C6_PRUNIT'	, staticCall( MGFFAT53 , FAT53PRC , 0 , padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" ) , SC5->C5_TABELA					)	, NIL})
							endif

							if !empty( oSalesOrde:items[ nI ]:ZC6_DTMINI ) .and. !empty( oSalesOrde:items[ nI ]:ZC6_DTMAXI )
								aadd(aLine, {'C6_ZDTMIN'	, sToD( oSalesOrde:items[ nI ]:ZC6_DTMINI )		, NIL})
								aadd(aLine, {'C6_ZDTMAX'	, sToD( oSalesOrde:items[ nI ]:ZC6_DTMAXI )		, NIL})
							else
								aadd(aLine, {'C6_ZDTMIN'	, CTOD("  /  /  ")								, NIL})
								aadd(aLine, {'C6_ZDTMAX'	, CTOD("  /  /  ")								, NIL})
							endif

							if !empty( oSalesOrde:header:ZC5_PEDCLI )
								aadd(aLine, {'C6_ITEMPC'	, cMaxItem						, NIL})
								aadd(aLine, {'C6_NUMPCOM'	, oSalesOrde:header:ZC5_PEDCLI	, NIL})
							endif

							aadd( aLine , { 'AUTDELETA' ,'N'							, Nil } )
							//aadd( aLine , { 'LINPOS'	,'C6_ITEM'						, cMaxItem	} )

							aadd( aSC6, aLine )
						endif
					endif
				next
			else
				// SE NENHUM ITEM ENVIADO FOI ENCONTRADO - INCLUI OS ITENS ENVIADOS - EXCETO CANCELADOS
				for nI := 1 to len( oSalesOrde:items )
					if allTrim( oSalesOrde:items[ nI ]:CANCEL ) <> "C" // NAO CONSIDERA OS CANCELADOS
						aLine := {}

						cMaxItem := soma1( cMaxItem )

						aadd(aLine, {'C6_ITEM'		, cMaxItem																																			, NIL})
						aadd(aLine, {'C6_PRODUTO'	, padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" )																				, NIL})
						aadd(aLine, {'C6_QTDVEN'	, oSalesOrde:items[ nI ]:ZC6_QTDVEN																													, NIL})
						aadd(aLine, {'C6_PRCVEN'	, oSalesOrde:items[ nI ]:ZC6_PRCVEN																													, NIL})

						if !empty( oSalesOrde:header:ZC5_CODTAB )
							aadd(aLine, {'C6_PRUNIT'	, staticCall( MGFFAT53 , FAT53PRC , 0 , padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" ) , oSalesOrde:header:ZC5_CODTAB	)	, NIL})
						else
							aadd(aLine, {'C6_PRUNIT'	, staticCall( MGFFAT53 , FAT53PRC , 0 , padL( allTrim( oSalesOrde:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" ) , SC5->C5_TABELA					)	, NIL})
						endif

						if !empty( oSalesOrde:items[ nI ]:ZC6_DTMINI ) .and. !empty( oSalesOrde:items[ nI ]:ZC6_DTMAXI )
							aadd(aLine, {'C6_ZDTMIN'	, sToD( oSalesOrde:items[ nI ]:ZC6_DTMINI )		, NIL})
							aadd(aLine, {'C6_ZDTMAX'	, sToD( oSalesOrde:items[ nI ]:ZC6_DTMAXI )		, NIL})
						else
							aadd(aLine, {'C6_ZDTMIN'	, CTOD("  /  /  ")								, NIL})
							aadd(aLine, {'C6_ZDTMAX'	, CTOD("  /  /  ")								, NIL})
						endif

						if !empty( oSalesOrde:header:ZC5_PEDCLI )
							aadd(aLine, {'C6_ITEMPC'	, cMaxItem						, NIL})
							aadd(aLine, {'C6_NUMPCOM'	, oSalesOrde:header:ZC5_PEDCLI	, NIL})
						endif

						aadd( aLine , { 'AUTDELETA' ,'N'                           , Nil } )
						//aadd( aLine , { 'LINPOS'	,'C6_ITEM'						, cMaxItem	} )

						aadd( aSC6, aLine )
					endif
				next
			endif
			// FIM - ADD ITENS NOVOS

			aSC5 := fwVetByDic( aSC5 /*aVetor*/ , "SC5" /*cTable*/ , .F. /*lItens*/ )
			//aSC6 := fwVetByDic( aSC6 /*aVetor*/ , "SC6" /*cTable*/ , .T. /*lItens*/ )

			varInfo( "aSC5" , aSC5 )
			varInfo( "aSC6" , aSC6 )

			U_MFCONOUT("[MGFWSS11] [updateSalesOrder] Alterando pedido "  + alltrim( oSalesOrde:header:ZC5_FILIAL ) + "/"+ ALLTRIM( oSalesOrde:header:ZC5_PVPROT ) + "...")
			msExecAuto( { | x , y , z | MATA410( x , y , z ) } , aSC5 , aSC6 , 4 )

			if lMsErroAuto
				while GetSX8Len() > nStackSX8
					ROLLBACKSX8()
				enddo

				aErro := GetAutoGRLog() // Retorna erro em array
				cErro := ""

				for nI := 1 to len(aErro)
					cErro += aErro[nI] + CRLF
				next nI

				oResponse:STATUS				:= "0"
				oResponse:MENSAGEMERRO			:= cErro
			else
				while GetSX8Len() > nStackSX8
					CONFIRMSX8()
				enddo

				conout('[MGFWSS11] [updateSalesOrder] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' ' + time() )

				oResponse:STATUS				:= "1"
				oResponse:MENSAGEMERRO			:= ""

				if SC5->C5_XORCAME == "S"
					cUpdSC5	:= ""

					cUpdSC5 := "UPDATE " + retSQLName("SC5")						+ CRLF
					cUpdSC5 += "	SET"											+ CRLF
					cUpdSC5 += " 		C5_ZBLQRGA = 'B'"							+ CRLF
					cUpdSC5 += " WHERE"												+ CRLF
					cUpdSC5 += " 		C5_NUM		=	'" + SC5->C5_NUM	+ "'"	+ CRLF
					cUpdSC5 += " 	AND	C5_FILIAL	=	'" + SC5->C5_FILIAL	+ "'"	+ CRLF
					cUpdSC5 += " 	AND	D_E_L_E_T_	<>	'*'"						+ CRLF

					if tcSQLExec( cUpdSC5 ) < 0
						conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
					endif

					DBSelectArea( 'SZV' )
					SZV->( DBSetOrder( 1 ) ) //ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
					if !SZV->( DBSeek( xFilial('SZV') + SC5->C5_NUM + "01" + cBlockOrca ) )
						recLock("SZV", .T.)
							SZV->ZV_FILIAL	:= xFilial("SZV")
							SZV->ZV_PEDIDO	:= SC5->C5_NUM
							SZV->ZV_ITEMPED	:= "01"
							SZV->ZV_CODRGA	:= cBlockOrca
						SZV->(msUnlock())
					endif
				endif
			endif

			oResponse:TIPO					:= SC5->C5_ZTIPPED
			oResponse:CONDICAOPAGAMENTO		:= SC5->C5_CONDPAG
			oResponse:DATAENTREGA			:= dTos( SC5->C5_FECENT )
			oResponse:IDVENDEDOR			:= SC5->C5_VEND1
			oResponse:NUMERONF				:= ""
			oResponse:CLIENTEID				:= SC5->C5_CLIENTE
			oResponse:CLIENTELOJA			:= SC5->C5_LOJACLI
			oResponse:CLIENTECNPJ			:= ""
			oResponse:NUMEROPEDIDOERP		:= SC5->C5_NUM
			oResponse:IDENDERECO			:= SC5->C5_ZIDEND
			oResponse:REDE					:= SC5->C5_XREDE
			oResponse:NUMEROPEDIDOPAIREDE	:= SC5->C5_XPVPAI
			oResponse:NUMEROPEDIDOCLIENTE	:= SC5->C5_ZPEDCLI
			oResponse:RESEVAESTOQUE			:= SC5->C5_XRESERV
			oResponse:ORCAMENTO				:= SC5->C5_XORCAME
			oResponse:IDTABELAPRECO			:= SC5->C5_TABELA
			oResponse:IDSISTEMAORIGEM		:= SC5->C5_XORIGEM

			// BLOQUEIOS DO PEDIDO

			oResponse:BLOQUEIOS			:= {}

			u_getSZVx( .F. , SC5->C5_FILIAL , SC5->C5_NUM , )

			while !(cQrySZVRet)->( EOF() )
				oBloqueio			:= nil
				oBloqueio			:= WSClassNew( "WSS11_BLOCK")

				oBloqueio:codigo	:= allTrim( (cQrySZVRet)->ZV_CODRGA )
				oBloqueio:descricao	:= allTrim( (cQrySZVRet)->ZT_DESCRI )

				aadd( oResponse:BLOQUEIOS , oBloqueio )

				(cQrySZVRet)->( DBSkip() )
			enddo

			(cQrySZVRet)->( DBCloseArea() )

			SC6->( DBGoTop() )

			oResponse:ITEMS := {}

			if SC6->( DBSeek( SC5->C5_FILIAL + SC5->C5_NUM ) )

				while !SC6->( EOF() ) .and. SC5->C5_FILIAL == SC6->C6_FILIAL .and.  SC5->C5_NUM == SC6->C6_NUM
					oItem				:= nil
					oItem				:= WSClassNew( "WSS11_ITEM")

					oItem:ITEM			:= SC6->C6_ITEM
					oItem:QUANTIDADEKG	:= SC6->C6_QTDVEN
					oItem:IDPRODUTO		:= SC6->C6_PRODUTO
					oItem:PRECO			:= SC6->C6_PRCVEN
					oItem:STATUS		:= "L"

					// BLOQUEIOS DOS ITENS
					oItem:BLOQUEIOS := {}

					u_getSZVx( .T. , SC5->C5_FILIAL , SC5->C5_NUM , SC6->C6_ITEM )

					while !(cQrySZVRet)->( EOF() )
						oItem:STATUS		:= "B"

						oBloqueio			:= nil
						oBloqueio			:= WSClassNew( "WSS11_BLOCK")

						oBloqueio:codigo	:= allTrim( (cQrySZVRet)->ZV_CODRGA )
						oBloqueio:descricao	:= allTrim( (cQrySZVRet)->ZT_DESCRI )

						aadd( oItem:BLOQUEIOS , oBloqueio )

						(cQrySZVRet)->( DBSkip() )
					enddo

					(cQrySZVRet)->( DBCloseArea() )
					// FIM - BLOQUEIOS DOS ITENS

					SC6->( DBSkip() )

					aadd( oResponse:ITEMS , oItem )
				enddo
			endif

			SC5->( DBRUnlock( SC5->( RECNO() ) ) )
		else
			oResponse:STATUS				:= "0"
			oResponse:MENSAGEMERRO			:= "Pedido de Venda não disponível para edição no momento."
			oResponse:NUMEROPEDIDOERP		:= oSalesOrde:header:ZC5_PVPROT
		endif
	else
		oResponse:STATUS				:= "0"
		oResponse:MENSAGEMERRO			:= "Pedido de Venda não encontrado."
		oResponse:NUMEROPEDIDOERP		:= oSalesOrde:header:ZC5_PVPROT
	endif
return

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD insertSalesOrder WSRECEIVE salesOrder WSSEND generalResponse WSSERVICE MGFWSS11
	local nI		:= 0
	local lOk		:= .T.
	local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )
	local nTamProd	:= superGetMv( "MFG_WSS17A" , , 6 )

	setFunName( "MGFWSS11" )

	conout( "[MGFWSS11] [BEGIN] insertSalesOrder " + dToC( dDataBase ) + " - " + time() )

	varInfo( "salesOrder" , ::salesOrder )

	DBSelectArea( "ZC5" )
	DBSelectArea( "ZC6" )

	ZC5->( DBSetOrder( 1 ) )
	ZC5->( DBGoTop() )

	::generalResponse := WSClassNew( "WSS11_GENERAL_STATUS")

	if empty( ::salesOrder:header:ZC5_FILIAL ) .or. ;
		empty( ::salesOrder:header:ZC5_CLIENT ) .or. ;
		empty( ::salesOrder:header:ZC5_ZTIPPE ) .or. ;
		empty( ::salesOrder:header:ZC5_VENDED ) .or. ;
		empty( ::salesOrder:header:ZC5_CODCON ) .or. ;
		empty( ::salesOrder:header:ZC5_CODTAB ) .or. ;
		empty( ::salesOrder:header:ZC5_IDEXTE ) .or. ;
		empty( ::salesOrder:header:ZC5_RESERV ) .or. ;
		empty( ::salesOrder:header:ZC5_ORCAME ) .or. ;
		empty( ::salesOrder:header:ZC5_PVREDE )

		lOk := .F.
	endif

	for nI := 1 to len( ::salesOrder:items)
		if empty( ::salesOrder:items[ nI ]:ZC6_ITEM	) .or. ;
			empty( ::salesOrder:items[ nI ]:ZC6_PRODUT	) .or. ;
			empty( ::salesOrder:items[ nI ]:ZC6_QTDVEN	) .or. ;
			empty( ::salesOrder:items[ nI ]:ZC6_PRCVEN	)

			lOk := .F.
			exit
		endif
	next

	if lOk
		BEGIN SEQUENCE
			if !ZC5->( DBSeek( allTrim( ::salesOrder:header:ZC5_FILIAL ) + left( ::salesOrder:header:ZC5_IDEXTE, tamSx3("ZC5_IDEXTE")[1] ) ) )
				if recLock("ZC5", .T.)
					ZC5->ZC5_FILIAL	:= allTrim( ::salesOrder:header:ZC5_FILIAL )
					ZC5->ZC5_CLIENT	:= ::salesOrder:header:ZC5_CLIENT
					ZC5->ZC5_CODTAB	:= ::salesOrder:header:ZC5_CODTAB
					ZC5->ZC5_CODCON	:= ::salesOrder:header:ZC5_CODCON
					ZC5->ZC5_ZTIPPE	:= ::salesOrder:header:ZC5_ZTIPPE
					ZC5->ZC5_ZTIPOP	:= allTrim( getMv( "MGF_SFATIP" ) ) //"BJ"
					ZC5->ZC5_VENDED	:= ::salesOrder:header:ZC5_VENDED

					if !empty( ::salesOrder:header:ZC5_DTENTR )
						ZC5->ZC5_DTENTR	:= sToD( allTrim( ::salesOrder:header:ZC5_DTENTR ) )
					endif

					if val( ::salesOrder:header:ZC5_ZIDEND ) > 0
						ZC5->ZC5_ZIDEND	:=  strZero( val( ::salesOrder:header:ZC5_ZIDEND ) , 9 )
					endif

					ZC5->ZC5_STATUS	:= "1" // 1 - Recebido / 2 - Processando / 3 - Gerado Pedido / 4 - Erro

					ZC5->ZC5_IDEXTE	:= ::salesOrder:header:ZC5_IDEXTE
					ZC5->ZC5_IDSFA	:= ::salesOrder:header:ZC5_IDEXTE

					ZC5->ZC5_RESERV	:= ::salesOrder:header:ZC5_RESERV
					ZC5->ZC5_ORCAME	:= ::salesOrder:header:ZC5_ORCAME
					ZC5->ZC5_PVREDE	:= ::salesOrder:header:ZC5_PVREDE

					ZC5->ZC5_XOBSPE	:= ::salesOrder:header:ZC5_XOBSPE
					ZC5->ZC5_PEDCLI	:= ::salesOrder:header:ZC5_PEDCLI
					ZC5->ZC5_MSGNOT	:= ::salesOrder:header:ZC5_MSGNOT

					if !empty( ::salesOrder:header:ZC5_PVPAI )
						ZC5->ZC5_PVPAI	:= ::salesOrder:header:ZC5_PVPAI
					endif

					ZC5->ZC5_DTRECE	:= date()
					ZC5->ZC5_HRRECE	:= time() // Hr Recebido

					ZC5->ZC5_INTEGR	:= "P" // Apos gerado pedido e retornado ao SFA muda para Integrado
					ZC5->ZC5_ORIGEM := U_MGFINT68( 2 , funName() )

					ZC5->( msUnlock() )

					for nI := 1 to len( ::salesOrder:items)
						if recLock("ZC6", .T.)
							ZC6->ZC6_FILIAL	:= allTrim( ::salesOrder:header:ZC5_FILIAL)
							ZC6->ZC6_ITEM	:= ::salesOrder:items[ nI ]:ZC6_ITEM
							//ZC6->ZC6_PRODUT	:= alltrim( ::salesOrder:items[ nI ]:ZC6_PRODUT )
							ZC6->ZC6_PRODUT	:= padL( allTrim( ::salesOrder:items[ nI ]:ZC6_PRODUT ) , nTamProd , "0" )
							ZC6->ZC6_QTDVEN	:= ::salesOrder:items[ nI ]:ZC6_QTDVEN
							ZC6->ZC6_PRCVEN	:= ::salesOrder:items[ nI ]:ZC6_PRCVEN
							ZC6->ZC6_OPER	:= allTrim( getMv( "MGF_SFATIP" ) )//"BJ"
							ZC6->ZC6_IDSFA	:= ::salesOrder:header:ZC5_IDEXTE
							ZC6->ZC6_PRCLIS	:= 0

							if !empty( ::salesOrder:items[ nI ]:ZC6_DTMINI )
								ZC6->ZC6_DTMINI	:= sToD( ::salesOrder:items[ nI ]:ZC6_DTMINI )
							endif

							if !empty( ::salesOrder:items[ nI ]:ZC6_DTMAXI )
								ZC6->ZC6_DTMAXI	:= sToD( ::salesOrder:items[ nI ]:ZC6_DTMAXI )
							endif

							ZC6->( msUnlock() )
						else
							::generalResponse:status			:= "0"
							::generalResponse:message			:= "Erro gravacao dos itens  (Tabela ZC6)"
							::generalResponse:codProtheus		:= "" // ????
							::generalResponse:codExternal		:= ::salesOrder:header:ZC5_IDEXTE
							::generalResponse:blocked			:= .F. // ????

							lOk := .F.
							exit
						endif
					next

					if lOk
						/*
						WSSTRUCT WSS11_GENERAL_STATUS
							WSDATA status			AS STRING
							WSDATA message			AS STRING
							WSDATA codProtheus		AS STRING
							WSDATA codProtheusLoja	AS STRING OPTIONAL
							WSDATA codExternal		AS STRING
							WSDATA blocked			AS BOOLEAN OPTIONAL
						ENDWSSTRUCT
						*/

						::generalResponse:status			:= "1"
						::generalResponse:message			:= "Pedido recebido"
						::generalResponse:codProtheus		:= "" // ????
						::generalResponse:codExternal		:= ::salesOrder:header:ZC5_IDEXTE
						::generalResponse:blocked			:= .F. // ????
					endif
				else
					::generalResponse:status			:= "0"
					::generalResponse:message			:= "Erro gravacao do cabecalho (Tabela ZC5)"
					::generalResponse:codProtheus		:= "" // ????
					::generalResponse:codExternal		:= ::salesOrder:header:ZC5_IDEXTE
					::generalResponse:blocked			:= .F. // ????
				endif
			else
				::generalResponse:status			:= "1"
				::generalResponse:message			:= "Erro gravacao - ID " + allTrim( ::salesOrder:header:ZC5_FILIAL ) + left( ::salesOrder:header:ZC5_IDEXTE, tamSx3("ZC5_IDEXTE")[1] ) + " ja existente na tabela intermediaria do Protheus"
				::generalResponse:codProtheus		:= "" // ????
				::generalResponse:codExternal		:= ::salesOrder:header:ZC5_IDEXTE
				::generalResponse:blocked			:= .F. // ????
			endif
		RECOVER
			conout('[MGFWSS11] [insertSalesOrder] Problema Ocorreu em : ' + dToC( dDataBase ) + " - " + time() )
		END SEQUENCE
	else
		::generalResponse:status			:= "0"
		::generalResponse:message			:= "Campos obrigatórios na inclusão não enviados ( ZC5_FILIAL / ZC5_CLIENT / ZC5_ZTIPPE / ZC5_VENDED / ZC5_CODCON / ZC5_CODTAB / ZC5_IDEXTE / ZC5_RESERV / ZC5_ORCAME / ZC5_PVREDE / ZC6_ITEM / ZC6_PRODUT / ZC6_QTDVEN / ZC6_PRCVEN )"
		::generalResponse:codProtheus		:= ""
		::generalResponse:codExternal		:= ::salesOrder:header:ZC5_IDEXTE
		::generalResponse:blocked			:= .F.
	endif

	if valType(_aErr) == 'A'
		::generalResponse:status			:= _aErr[1]
		::generalResponse:message			:= _aErr[2]
		::generalResponse:codProtheus		:= "" // ????
		::generalResponse:codExternal		:= ::salesOrder:header:ZC5_IDEXTE
		::generalResponse:blocked			:= .F. // ????
	endif

	varInfo( "generalResponse" , ::generalResponse )

	conout( "[MGFWSS11] [END] insertSalesOrder " + dToC( dDataBase ) + " - " + time() )

	delClassINTF()
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD updateFinancialLimit WSRECEIVE financialLimit WSSEND generalResponse WSSERVICE MGFWSS11
	local cQrySA1			:= ""
	local aSA1				:= {}
	local aAreaX			:= getArea()
	local aAreaSA1			:= SA1->( getArea() )
	local aErro				:= {}
	local cErro				:= ""
	local nI				:= 0
	local nOpcX				:= 4
	local lValid			:= .T.
	local cTimeIni		    := ""
	local cTimeFin		    := ""
	local cTimeResul	    := ""

	private lMsHelpAuto     := .T. // Se .T. direciona as mensagens de help para o arq. de log
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	setFunName( "MGFWSS11" )

	conout( "[MGFWSS11] updateFinancialLimit " + dToC( dDataBase ) + " - " + time() )

	varInfo( "financialLimit" , ::financialLimit )

	::generalResponse	:= WSClassNew( "WSS11_GENERAL_STATUS" )

	DBSelectArea( "SA1" )

	if ::financialLimit:APPROVED
		if	empty( ::financialLimit:A1_LC		)	.or. ;
			empty( ::financialLimit:A1_COND		)	.or. ;
			empty( ::financialLimit:A1_ZGDERED	)	.or. ;
			empty( ::financialLimit:A1_ZBOLETO	)	.or. ;
			empty( ::financialLimit:A1_VENCLC	)

			lValid := .F.

			::generalResponse:status			:= "0"
			::generalResponse:message			:= "Campos obrigatórios não enviados na Aprovação - A1_LC | A1_COND | A1_ZGDERED | A1_ZBOLETO | A1_VENCLC"
			::generalResponse:codProtheus		:= ""
			::generalResponse:codProtheusLoja	:= ""
			::generalResponse:codExternal		:= ""
			::generalResponse:blocked			:= .F.
		endif
	endif

	if lValid
		cQrySA1 := "SELECT SA1.R_E_C_N_O_ SA1RECNO"																	+ CRLF
		cQrySA1 += " FROM " + retSQLName( "SA1" ) + " SA1"															+ CRLF
		cQrySA1 += " WHERE"																							+ CRLF
		cQrySA1 += " 		SA1.A1_COD || SA1.A1_LOJA	=	'" + allTrim( ::financialLimit:CODIGO_LOJA )	+ "'"	+ CRLF
		cQrySA1 += " 	AND	SA1.A1_FILIAL				=	'" + xFilial("SA1")								+ "'"	+ CRLF
		cQrySA1 += " 	AND	SA1.D_E_L_E_T_				<>	'*'"													+ CRLF

		tcQuery cQrySA1 new alias "QRYSA1"

		if !QRYSA1->( EOF() )
			SA1->( DBGoTo( QRYSA1->SA1RECNO ) )

			// DBRLock - Retorna verdadeiro (.T.), se o registro for bloqueado com sucesso; caso contrário, falso (.F.).
			if SA1->( DBRLock( QRYSA1->SA1RECNO ) )
				/*
				if ::financialLimit:REACTIVATION
					// ELIMINAR GRADES PENDENTES DO FINANCEIRO - SOMENTE SE NAO HOUVER PENDENCIA FINANCEIRA
					if SA1->A1_XPENFIN <> "S"
						getZB1( .T. )

						cUpdSA1 := ""
						cUpdSA1 := "UPDATE " + retSQLName("SA1")																+ CRLF
						cUpdSA1 += "	SET"																					+ CRLF
						cUpdSA1 += " 		A1_MSBLQL	= '2' "																	+ CRLF
						cUpdSA1 += " WHERE"																						+ CRLF
						cUpdSA1 += " 		SA1.A1_COD || SA1.A1_LOJA	=	'" + allTrim( ::financialLimit:CODIGO_LOJA ) + "'"	+ CRLF
						cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")	+ "'"											+ CRLF
						cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"																+ CRLF

						if tcSQLExec( cUpdSA1 ) < 0
							conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
						endif
					else
						nOpcX := 0

						::generalResponse:status		:= "0"
						::generalResponse:message		:= "Cliente com Pendência Financeira"
						::generalResponse:codProtheus	:= ""
						::generalResponse:codExternal	:= ::customer:A1_CGC
						::generalResponse:blocked		:= .T.
					endif
				endif
				*/

				U_MGFFATBE() // Cadastra o cliente automaticamente na estrutura de vendas (carteira) do vendedor

				aSA1 := {}
				aadd( aSA1, { "A1_COD"		, SA1->A1_COD								, nil } )
				aadd( aSA1, { "A1_LOJA"		, SA1->A1_LOJA								, nil } )

				if ::financialLimit:APPROVED
					aadd( aSA1, { "A1_LC"		, ::financialLimit:A1_LC				, nil } )
					aadd( aSA1, { "A1_COND"		, ::financialLimit:A1_COND				, nil } )
					aadd( aSA1, { "A1_ZGDERED"	, ::financialLimit:A1_ZGDERED			, nil } )
					aadd( aSA1, { "A1_ZBOLETO"	, ::financialLimit:A1_ZBOLETO			, nil } )
					aadd( aSA1, { "A1_VENCLC"	, sToD( ::financialLimit:A1_VENCLC )	, nil } )

					if !empty( ::financialLimit:A1_ZREDE )
						aadd( aSA1, { "A1_ZREDE"	, ::financialLimit:A1_ZREDE			, nil } )
					endif
				endif

				if !empty( ::financialLimit:A1_ZALTCRE )
					aadd( aSA1, { "A1_ZALTCRE"	, ::financialLimit:A1_ZALTCRE									, nil } )
				endif

				aSA1 := fwVetByDic( aSA1 /*aVetor*/ , "SA1" /*cTable*/ , .F. /*lItens*/ )

				varInfo( "aSA1" , aSA1 )

				msExecAuto( { | x , y | MATA030( x , y ) } , aSA1 , nOpcX ) // SA1 Cliente

				if lMsErroAuto
					aErro := GetAutoGRLog() // Retorna erro em array
					cErro := ""

					for nI := 1 to len( aErro )
						cErro += aErro[ nI ] + CRLF
					next nI

					::generalResponse:status			:= "0"
					::generalResponse:message			:= allTrim( cErro )
					::generalResponse:codProtheus		:= ""
					::generalResponse:codProtheusLoja	:= ""
					::generalResponse:codExternal		:= ""
					::generalResponse:blocked			:= .F.
				else
					getZB1( .F. /*lReactivat*/ , ::financialLimit:APPROVED /*lUpdCredit*/ )

					::generalResponse:status			:= "1"
					::generalResponse:codProtheus		:= allTrim( SA1->A1_COD )
					::generalResponse:codProtheusLoja	:= allTrim( SA1->A1_LOJA )
					::generalResponse:codExternal		:= allTrim( SA1->A1_XIDSFOR )
					::generalResponse:message			:= ""
					::generalResponse:blocked			:= ( SA1->A1_MSBLQL == "1" )

					if ::generalResponse:blocked
						::generalResponse:message += getZB1()
					endif
				endif

				SA1->( DBRUnlock( QRYSA1->SA1RECNO ) )
			else
				::generalResponse:status			:= "0"
				::generalResponse:message			:= "Registro bloqueado no momento."
				::generalResponse:codProtheus		:= ""
				::generalResponse:codProtheusLoja	:= ""
				::generalResponse:codExternal		:= ""
				::generalResponse:blocked			:= .F.
			endif
		else
			::generalResponse:status			:= "0"
			::generalResponse:message			:= "Cliente não encontrado"
			::generalResponse:codProtheus		:= ""
			::generalResponse:codProtheusLoja	:= ""
			::generalResponse:codExternal		:= ""
			::generalResponse:blocked			:= .F.
		endif

		QRYSA1->( DBCloseArea() )
	endif

	restArea( aAreaX )
	restArea( aAreaSA1 )
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD hello WSRECEIVE helloRequest WSSEND helloReponse WSSERVICE MGFWSS11
::helloReponse := "Hello, " + ::helloRequest + "!"
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD insertOrUpdateAddress WSRECEIVE address WSSEND generalResponse WSSERVICE MGFWSS11
	local aArea		:= getArea()
	local aAreaSA1	:= SA1->( getArea() )
	local aAreaSZ9	:= SZ9->( getArea() )
	local aSZ9	:= {}
	local oModel	:= nil
	local oAux		:= nil
	local oStruct	:= nil
	local nI		:= 0
	local nPos		:= 0
	local lRet		:= .T.
	local aAux		:= {}
	local lAux		:= .T.
	local aErro		:= {}
	local cQrySZ9	:= ""
	local cQrySA1	:= ""
	local nOpcX		:= 0
	//Variaveis de Logs
	local cLinkRec          :=  allTrim( superGetMv( "MGF_WSS11L" , , "http://spdwfapl180:8712/MGFWSS11.apw?WSDL" ) )
	local cRetCall          := ""
	local cCodInteg			:= allTrim( superGetMv( "MGF_CODSZ2" , , "008" ) )//Cod. de busca na SZ2, Tabela de Integração
	local cCodTpInt			:= allTrim( superGetMv( "MGF_WSS11B" , , "005" ) )//Cod. de busca na SZ3, Tabela Tipo de Integração
	local cTimeIni		    := ""
	local cTimeFin		    := ""
	local cTimeResul	    := ""
	local nRecnoEn          := 0
	local cVarInfoX			:= ""

	setFunName( "MGFWSS11" )

	conout( "[MGFWSS11] insertOrUpdateAddress " + dToC( dDataBase ) + " - " + time() )

	cVarInfoX := varInfo( "address" , ::address )

	::generalResponse	:= WSClassNew( "WSS11_GENERAL_STATUS")

	cTimeIni	:= time()

	DBSelectArea( "SA1" )
	DBSelectArea( "SZ9" )
	SZ9->( DBSetOrder( 1 ) )

	cQrySA1 := "SELECT SA1.R_E_C_N_O_ SA1RECNO"									+ CRLF
	cQrySA1 += " FROM " + retSQLName( "SA1" ) + " SA1"							+ CRLF
	cQrySA1 += " WHERE"															+ CRLF
	//cQrySA1 += " 		SA1.A1_LOJA		=	'" + ::address:Z9_ZLOJA		+ "'"	+ CRLF
	cQrySA1 += " 		SA1.A1_LOJA		=	'" + right( allTrim( ::address:Z9_ZCLIENT ) , 2 )		+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.A1_COD		=	'" + left( allTrim( ::address:Z9_ZCLIENT ) , 6 )	+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1")			+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"								+ CRLF

	tcQuery cQrySA1 new alias "QRYSA1"

	if !QRYSA1->( EOF() )
		SA1->( DBGoTo( QRYSA1->SA1RECNO ) )

		if !empty( ::address:Z9_ZIDEND )
			cQrySZ9 := "SELECT SZ9.R_E_C_N_O_ SZ9RECNO"									+ CRLF
			cQrySZ9 += " FROM " + retSQLName( "SZ9" ) + " SZ9"							+ CRLF
			cQrySZ9 += " WHERE"															+ CRLF
			cQrySZ9 += " 		SZ9.Z9_MSBLQL	=	'2'"								+ CRLF
			cQrySZ9 += " 	AND	SZ9.Z9_ZIDEND	=	'" + ::address:Z9_ZIDEND	+ "'"	+ CRLF
			//cQrySZ9 += " 	AND	SZ9.Z9_ZLOJA	=	'" + ::address:Z9_ZLOJA		+ "'"	+ CRLF
			//cQrySZ9 += " 	AND	SZ9.Z9_ZCLIENT	=	'" + ::address:Z9_ZCLIENT	+ "'"	+ CRLF
			cQrySZ9 += " 	AND	SZ9.Z9_ZLOJA	=	'" + right( allTrim( ::address:Z9_ZCLIENT ) , 2 )		+ "'"	+ CRLF
			cQrySZ9 += " 	AND	SZ9.Z9_ZCLIENT	=	'" + left( allTrim( ::address:Z9_ZCLIENT ) , 6 )		+ "'"	+ CRLF
			cQrySZ9 += " 	AND	SZ9.Z9_FILIAL	=	'" + xFilial("SZ9")			+ "'"	+ CRLF
			cQrySZ9 += " 	AND	SZ9.D_E_L_E_T_	<>	'*'"								+ CRLF

			tcQuery cQrySZ9 New Alias "QRYSZ9"

			if !QRYSZ9->( EOF() )
				SZ9->( DBGoTo( QRYSZ9->SZ9RECNO ) )

				// DBRLock - Retorna verdadeiro (.T.), se o registro for bloqueado com sucesso; caso contrário, falso (.F.).
				if SZ9->( DBRLock( QRYSZ9->SZ9RECNO ) )
					if ::address:INTEGRATED
						recLock( "SZ9" , .F. )
						SZ9->Z9_XIDSFOR	:= ::address:Z9_XIDSFOR
						SZ9->( msUnlock() )

						::generalResponse:status		:= "1"
						::generalResponse:message		:= "Retorno de integração recebido com sucesso."
						::generalResponse:codProtheus	:= allTrim( SZ9->Z9_ZIDEND )
						::generalResponse:codExternal	:= allTrim( SZ9->Z9_XIDSFOR )
					else
						if ::address:DELETE
							nOpcX := 5 // EXCLUSAO
						else
							nOpcX := 4 // ALTERACAO
						endif
					endif

					SZ9->( DBRUnlock( QRYSZ9->SZ9RECNO ) )
				else
					::generalResponse:status			:= "0"
					::generalResponse:message			:= "Registro bloqueado no momento."
					::generalResponse:codProtheus		:= ""
					::generalResponse:codExternal		:= ""
					::generalResponse:blocked			:= .F.
				endif
			else
				::generalResponse:status		:= "0"
				::generalResponse:message		:= "Endereço '" + ::address:Z9_ZIDEND + "' não localizado para alteração / Registro bloqueado para alterações."
				::generalResponse:codProtheus	:= ""
				::generalResponse:codExternal	:= ::address:Z9_XIDSFOR
				::generalResponse:blocked		:= .F.
			endif

			QRYSZ9->( DBCloseArea() )
		else
			// INCLUSAO
			nOpcX := 3
		endif
	else
		::generalResponse:status		:= "0"
		::generalResponse:message		:= "Codigo / Loja não encontrado na base."
		::generalResponse:codProtheus	:= ""
		::generalResponse:codExternal	:= ::address:Z9_XIDSFOR
		::generalResponse:blocked		:= .F.
	endif

	QRYSA1->( DBCloseArea() )

	if nOpcX > 0
		// Aqui ocorre o instanciamento do modelo de dados (Model)
		// Neste exemplo instanciamos o modelo de dados do fonte COMP022_MVC
		// que é a rotina de manutenção de musicas
		oModel := FWLoadModel( 'MGFFAT01' )

		// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
		oModel:SetOperation( nOpcX )

		// Antes de atribuirmos os valores dos campos temos que ativar o modelo
		oModel:Activate()

		// Instanciamos apenas a parte do modelo referente aos dados de cabeçalho
		oAux := oModel:GetModel( 'FAT01MASTER' )
	endif

	if nOpcX <> 5 .and. nOpcX > 0
		aSZ9 := {}

		aadd( aSZ9, { 'Z9_XINTSFO'		, 'I'			} )

		if nOpcX == 3
			aadd( aSZ9, { 'Z9_XIDSFOR', ::address:Z9_XIDSFOR	} )
		endif

		aadd( aSZ9, { 'Z9_ZCGC'		, SA1->A1_CGC			} )

		if !empty( ::address:Z9_ZRAZEND )
			aadd( aSZ9, { 'Z9_ZRAZEND'	, ::address:Z9_ZRAZEND	} )
		else
			aadd( aSZ9, { 'Z9_ZRAZEND'	, SA1->A1_NOME			} )
		endif

		if !empty( ::address:Z9_ZENDER )
			aadd( aSZ9, { 'Z9_ZENDER'	, ::address:Z9_ZENDER	} )
		endif

		if !empty( ::address:Z9_ZBAIRRO )
			aadd( aSZ9, { 'Z9_ZBAIRRO'	, ::address:Z9_ZBAIRRO	} )
		endif

		if !empty( ::address:Z9_ZCEP )
			aadd( aSZ9, { 'Z9_ZCEP'		, strTran( ::address:Z9_ZCEP , "-" ) } )
		endif

		if !empty( ::address:Z9_ZEST )
			aadd( aSZ9, { 'Z9_ZEST'		, ::address:Z9_ZEST		} )
		endif

		if !empty( ::address:Z9_ZCODMUN )
			aadd( aSZ9, { 'Z9_ZCODMUN'	, ::address:Z9_ZCODMUN	} )
		endif

		if !empty( ::address:Z9_ZMUNIC )
			aadd( aSZ9, { 'Z9_ZMUNIC'	, ::address:Z9_ZMUNIC	} )
		endif

		if !empty( ::address:Z9_ZCOMPLE )
			aadd( aSZ9, { 'Z9_ZCOMPLE'	, ::address:Z9_ZCOMPLE	} )
		endif

		aadd( aSZ9, { 'Z9_ZROTEIR'	, "S"					} )
		aadd( aSZ9, { 'Z9_ALROAD'	, "S"					} )
		aadd( aSZ9, { 'Z9_XSFA'		, "S"					} )
		//aadd( aSZ9, { 'Z9_MSBLQL'	, "1"					} )
		aadd( aSZ9, { 'Z9_XSFAX'	, "S"					} )

		aSZ9 := fwVetByDic( aSZ9 /*aVetor*/ , "SZ9" /*cTable*/ , .F. /*lItens*/ )

		varInfo( "aSZ9" , aSZ9 )

		// Obtemos a estrutura de dados do cabeçalho
		oStruct := oAux:GetStruct()
		aAux	:= oStruct:GetFields()

		For nI := 1 To Len( aSZ9 )
			// Verifica se os campos passados existem na estrutura do cabeçalho
			If ( nPos := aScan( aAux, { |x| allTrim( x[3] ) == allTrim( aSZ9[nI][1] ) } ) ) > 0

				// È feita a atribuicao do dado aos campo do Model do cabeçalho
				If !( lAux := oModel:SetValue( "FAT01MASTER", aSZ9[nI][1], aSZ9[nI][2] ) )
					// Caso a atribuição não possa ser feita, por algum motivo (validação, por exemplo)
					// o método SetValue retorna .F.
					lRet    := .F.
					Exit
				endif
			endif
		next
	endif

	if nOpcX > 0
		if lRet
			// Faz-se a validação dos dados, note que diferentemente das tradicionais "rotinas automáticas"
			// neste momento os dados não são gravados, são somente validados.
			if ( lRet := oModel:VldData() )
				// Se o dados foram validados faz-se a gravação efetiva dos dados (commit)
				lRet := oModel:CommitData()
			endif

			if !lRet
				// Se os dados não foram validados obtemos a descrição do erro para gerar LOG ou mensagem de aviso
				aErro   := oModel:GetErrorMessage()
				// A estrutura do vetor com erro é:
				//  [1] Id do formulário de origem
				//  [2] Id do campo de origem
				//  [3] Id do formulário de erro
				//  [4] Id do campo de erro
				//  [5] Id do erro
				//  [6] mensagem do erro
				//  [7] mensagem da solução
				//  [8] Valor atribuido
				//  [9] Valor anterior

				::generalResponse:status := "0"
				::generalResponse:message := ""
				::generalResponse:message += ( "Id do formulário de origem:" + ' [' + allToChar( aErro[1]  ) + ']' )
				::generalResponse:message += ( "Id do campo de origem:     " + ' [' + allToChar( aErro[2]  ) + ']' )
				::generalResponse:message += ( "Id do formulário de erro:  " + ' [' + allToChar( aErro[3]  ) + ']' )
				::generalResponse:message += ( "Id do campo de erro:       " + ' [' + allToChar( aErro[4]  ) + ']' )
				::generalResponse:message += ( "Id do erro:                " + ' [' + allToChar( aErro[5]  ) + ']' )
				::generalResponse:message += ( "Mensagem do erro:          " + ' [' + allToChar( aErro[6]  ) + ']' )
				::generalResponse:message += ( "Mensagem da solução:       " + ' [' + allToChar( aErro[7]  ) + ']' )
				::generalResponse:message += ( "Valor atribuido:           " + ' [' + allToChar( aErro[8]  ) + ']' )
				::generalResponse:message += ( "Valor anterior:            " + ' [' + allToChar( aErro[9]  ) + ']' )
				::generalResponse:codProtheus	:= ""
				::generalResponse:codExternal	:= ::address:Z9_XIDSFOR
				::generalResponse:blocked		:= .F.

				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do formulário de origem:" + " [" + allToChar( aErro[1]  ) + "]")
				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do campo de origem:     " + " [" + allToChar( aErro[2]  ) + "]")
				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do formulário de erro:  " + " [" + allToChar( aErro[3]  ) + "]")
				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do campo de erro:       " + " [" + allToChar( aErro[4]  ) + "]")
				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do erro:                " + " [" + allToChar( aErro[5]  ) + "]")
				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Mensagem do erro:          " + " [" + allToChar( aErro[6]  ) + "]")
				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Mensagem da solução:       " + " [" + allToChar( aErro[7]  ) + "]")
				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Valor atribuido:           " + " [" + allToChar( aErro[8]  ) + "]")
				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Valor anterior:            " + " [" + allToChar( aErro[9]  ) + "]")
			else
				::generalResponse:status		:= "1"
				::generalResponse:message		:= "Operação em cadastro feita com sucesso."
				::generalResponse:codProtheus	:= oModel:GetModel("FAT01MASTER"):getValue("Z9_ZIDEND")
				::generalResponse:codExternal	:= oModel:GetModel("FAT01MASTER"):getValue("Z9_XIDSFOR")
				::generalResponse:blocked		:= ( oModel:GetModel("FAT01MASTER"):getValue("Z9_MSBLQL") == "1" )

				conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Operação em cadastro feita com sucesso.")
			endif
		else
			// Se os dados não foram validados obtemos a descrição do erro para gerar LOG ou mensagem de aviso
			aErro   := oModel:GetErrorMessage()
			// A estrutura do vetor com erro é:
			//  [1] Id do formulário de origem
			//  [2] Id do campo de origem
			//  [3] Id do formulário de erro
			//  [4] Id do campo de erro
			//  [5] Id do erro
			//  [6] mensagem do erro
			//  [7] mensagem da solução
			//  [8] Valor atribuido
			//  [9] Valor anterior

			::generalResponse:status := "0"
			::generalResponse:message := ""
			::generalResponse:message += ( "Id do formulário de origem:" + ' [' + allToChar( aErro[1]  ) + ']' )
			::generalResponse:message += ( "Id do campo de origem:     " + ' [' + allToChar( aErro[2]  ) + ']' )
			::generalResponse:message += ( "Id do formulário de erro:  " + ' [' + allToChar( aErro[3]  ) + ']' )
			::generalResponse:message += ( "Id do campo de erro:       " + ' [' + allToChar( aErro[4]  ) + ']' )
			::generalResponse:message += ( "Id do erro:                " + ' [' + allToChar( aErro[5]  ) + ']' )
			::generalResponse:message += ( "Mensagem do erro:          " + ' [' + allToChar( aErro[6]  ) + ']' )
			::generalResponse:message += ( "Mensagem da solução:       " + ' [' + allToChar( aErro[7]  ) + ']' )
			::generalResponse:message += ( "Valor atribuido:           " + ' [' + allToChar( aErro[8]  ) + ']' )
			::generalResponse:message += ( "Valor anterior:            " + ' [' + allToChar( aErro[9]  ) + ']' )
			::generalResponse:codProtheus	:= ""
			::generalResponse:codExternal	:= ::address:Z9_XIDSFOR
			::generalResponse:blocked		:= .F.

			conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do formulário de origem:" + " [" + allToChar( aErro[1]  ) + "]")
			conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do campo de origem:     " + " [" + allToChar( aErro[2]  ) + "]")
			conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do formulário de erro:  " + " [" + allToChar( aErro[3]  ) + "]")
			conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do campo de erro:       " + " [" + allToChar( aErro[4]  ) + "]")
			conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Id do erro:                " + " [" + allToChar( aErro[5]  ) + "]")
			conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Mensagem do erro:          " + " [" + allToChar( aErro[6]  ) + "]")
			conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Mensagem da solução:       " + " [" + allToChar( aErro[7]  ) + "]")
			conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Valor atribuido:           " + " [" + allToChar( aErro[8]  ) + "]")
			conout("[SALESFORCE] [MGFWSS11] [insertOrUpdateAddress] - Valor anterior:            " + " [" + allToChar( aErro[9]  ) + "]")
		endif

		// Desativamos o Model
		oModel:DeActivate()

		SZ9->( DBRUnlock( RECNO() ) )
	endif

	varinfo( "::generalResponse " , ::generalResponse )
	cTimeFin	:= time()
	cTimeResul	:= elapTime( cTimeIni , cTimeFin )

	//GRAVAR LOG - Endereço
	U_MGFMONITOR(							     ;
		cFilAnt	/*cFil*/		        		,;
		Iif(::generalResponse:status == "0", "2", ::generalResponse:status )/*cStatus*/,;
		cCodInteg /*cCodint Z1_INTEGRA*/		 ,;
		cCodTpInt /*cCodtpint Z1_TPINTEG*/  	 ,;
		::generalResponse:message /*cErro*/      ,;
		""/*cDocori*/		                     ,;
		cTimeResul/*cTempo*/,;
		cVarInfoX /*cJSON*/ ,;
		nRecnoEn/*nRecnoDoc*/            ,;
		::generalResponse:status/*cHTTP*/,;
		.F./*lJob*/		                 ,;
		{}/*aFil*/		                 ,;
		" "/*cUUID*/                     ,;
		::generalResponse:message/*cJsonR*/,;
		"S"/*cTipWsInt*/           ,;
		" "/*cJsonCB /*Z1_JSONCB*/ ,;
		" "/*cJsonRB /*Z1_JSONRB*/ ,;
		sTod("    /  /  ") /*dDTCallb /*Z1_DTCALLB*/,;
		" "/*cHoraCall /*Z1_HRCALLB*/,;
		" "/*cCallBac /*Z1_CALLBAC*/,;
		cLinkRec /*cLinkEnv /*Z1_LINKENV*/,;
		cLinkRec /*cLinkRec /*Z1_LINKREC*/)

	restArea( aAreaSZ9 )
	restArea( aAreaSA1 )
	restArea( aArea )
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
WSMETHOD insertOrUpdateCustomer WSRECEIVE customer WSSEND generalResponse WSSERVICE MGFWSS11
local aErro				:= {}
local cErro				:= ""
local aSA1				:= {}
local nI				:= 0
local nOpcX				:= 0
local aCodSA1			:= {}
local aArea				:= getArea()
local aAreaSA1			:= SA1->( getArea() )
local aAreaZE9			:= ZE9->( getArea() )
local lExecAutoX		:= .T.
local cCNAE2			:= ""
local nRecnoZE9			:= 0
local cUpdTbl			:= ""
local cUpdSA1			:= ""
local cQryZB1			:= ""
local aListCnae			:= {}
local nLimiteIni		:= superGetMv( "MFG_WSS11C" , , 1		)
local cCondPgtoI		:= superGetMv( "MFG_WSS11D" , , "002"	)
//Variaveis de Logs
local cLinkRec          :=  allTrim( superGetMv( "MGF_WSS11L" , , "http://spdwfapl180:8712/MGFWSS11.apw?WSDL" ) )
local cRetCall          := ""
local cCodInteg			:= allTrim( superGetMv( "MGF_CODSZ2" , , "008" ) )//Cod. de busca na SZ2, Tabela de Integração
local cCodTpInt			:= allTrim( superGetMv( "MGF_WSS11F" , , "004" ) )//Cod. de busca na SZ3, Tabela Tipo de Integração
local cTimeIni		    := ""
local cTimeFin		    := ""
local cTimeResul	    := ""
local cVarInfoX		    := ""
local lCNAEOk			:= .F. // Verifica se CNAE não esta bloqueado

private lMsHelpAuto     := .T. // Se .T. direciona as mensagens de help para o arq. de log
private lMsErroAuto     := .F.
private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

setFunName( "MGFWSS11" )

conout( "[MGFWSS11] insertOrUpdateCustomer " + dToC( dDataBase ) + " - " + time() )

cVarInfoX := varInfo( "::customer" , ::customer )

::generalResponse := WSClassNew( "WSS11_GENERAL_STATUS" )

cTimeIni := time()

aCodSA1 := chkSA1( ::customer:A1_CGC )

if len( aCodSA1 ) > 0
	nOpcX := 4

	if ::customer:REACTIVATION
		// ELIMINAR GRADES PENDENTES POIS VIRAO DADOS ATUALIZADOS DA AZIX
		if aCodSA1[6] <> "S"
			getZB1( .T. )

			cUpdSA1 := ""
			cUpdSA1 := "UPDATE " + retSQLName("SA1")									+ CRLF
			cUpdSA1 += "	SET"														+ CRLF
			cUpdSA1 += " 		A1_MSBLQL	= '2' , A1_ZINATIV = '0'"					+ CRLF
			cUpdSA1 += " WHERE"															+ CRLF
			cUpdSA1 += " 		A1_CGC		=	'" + allTrim( ::customer:A1_CGC ) + "'"	+ CRLF
			cUpdSA1 += " 	AND	A1_FILIAL	=	'" + xFilial("SA1")	+ "'"				+ CRLF
			cUpdSA1 += " 	AND	D_E_L_E_T_	<>	'*'"									+ CRLF

			if tcSQLExec( cUpdSA1 ) < 0
				conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
			endif
		else
			nOpcX := 0

			::generalResponse:status		:= "0"
			::generalResponse:message		:= "Cliente com Pendência Financeira"
			::generalResponse:codProtheus	:= ""
			::generalResponse:codExternal	:= ::customer:A1_CGC
			::generalResponse:blocked		:= .T.
		endif
	endif

	if ::customer:INTEGRATED
		cUpdTbl	:= ""

		cUpdTbl := "UPDATE " + retSQLName("SA1")																			+ CRLF
		cUpdTbl += "	SET"																								+ CRLF
		cUpdTbl += " 		A1_XINTSFO	=	'I',"																			+ CRLF
		cUpdTbl += " 		A1_XIDSFOR	=	'" + ::customer:A1_XIDSFOR + "'"												+ CRLF
		cUpdTbl += " WHERE"																									+ CRLF
		//cUpdTbl += " 		A1_COD || A1_LOJA	=	'" + allTrim( ::customer:A1_COD ) + "'"	+ CRLF
		cUpdTbl += " 		A1_CGC				=	'" + allTrim( ::customer:A1_CGC ) + "'"	+ CRLF
		cUpdTbl += " 	AND	D_E_L_E_T_			<>	'*'"																	+ CRLF

		if tcSQLExec( cUpdTbl ) < 0
			conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
		else
			::generalResponse:status		:= "1"
			::generalResponse:message		:= "Retorno de integração recebido com sucesso."
			::generalResponse:codProtheus	:= allTrim( ::customer:A1_CGC )
			::generalResponse:codExternal	:= ""//allTrim( ::customer:A1_XIDSFOR )
		endif

		nOpcX := 0 // PARA NAO CAIR NA EXECAUTO
	endif
elseif len( aCodSA1 ) == 0
	nOpcX := 3
endif

if nOpcX == 3

	aListCnae := {}
	if !empty( ::customer:A1_CNAES )
		aListCnae := strTokArr2( allTrim( ::customer:A1_CNAES ), ";", .F. )
	endif

	// VERIFICA SE CNAE ESTA BLOQUEADO
	lCNAEOk := .F.

	if blockCNAE( ::customer:A1_CNAE ) // VERIFICA SE CNAE PRINCIPAL ESTA BLOQUEADO
		for nI := 1 to len( aListCnae )
			if !blockCNAE( aListCnae[ nI ] ) // VERIFICA SE CNAES SECUNDARIOS ESTAO BLOQUEADO
				lCNAEOk	:= .T.
				cCNAE2	:= aListCnae[ nI ]
				exit
			endif
		next
	else
		lCNAEOk	:= .T.
	endif

	if !lCNAEOk
		lExecAutoX := .F. // SE CNAE ESTIVER BLOQUEADO NAO EXECUTA ROTINA AUTOMATICA
	endif
	// FIM - VERIFICA SE CNAE ESTA BLOQUEADO

	// SE INCLUSAO VERIFICA REGRA DE CNAE
	// SALESFORCE NAO FARA ALTERACAO DE VENDEDOR NO CLIENTE
	// NAO HAVERA ALTERACAO DE CNAE

	if lCNAEOk
		if !excessCNAE( ::customer:A1_VEND )
			if !chkCNAE( ::customer:A1_CGC , "" , @nRecnoZE9 ) // VERIFICA SE ENCONTRA HIERARQUIA PELO CNPJ
				lExecAutoX := .F.

				if !chkCNAE( "" , ::customer:A1_CNAE , @nRecnoZE9 ) // VERIFICA SE ENCONTRA HIERARQUIA PELO CNAE PRINCIPAL
					for nI := 1 to len( aListCnae )
						if chkCNAE( "" , aListCnae[ nI ] , @nRecnoZE9 ) // VERIFICA SE ENCONTRA HIERARQUIA PELOS CNAES SECUNDARIOS
							// SE ENCONTROU CNAE CONTINUA GRAVACAO
							lExecAutoX	:= .T.
							cCNAE2		:= aListCnae[ nI ]
							exit
						endif
					next
				else
					lExecAutoX := .T.
				endif
			endif
		endif
	endif
endif

if !lExecAutoX
	::generalResponse:status		:= "0"
	::generalResponse:message		:= "CNAE Inválido" // Hierarquia de Vendas não localizada para este CNAE / CNPJ."
	::generalResponse:codProtheus	:= ""
	::generalResponse:codExternal	:= ::customer:A1_XIDSFOR
	::generalResponse:blocked		:= .F.
endif

if lExecAutoX .and. nOpcX == 4
	SA1->( DBGoTo( aCodSA1[ 7 ] ) )

	// DBRLock - Retorna verdadeiro (.T.), se o registro for bloqueado com sucesso; caso contrário, falso (.F.).
	if !SA1->( DBRLock( aCodSA1[ 7 ] ) )
		lExecAutoX	:= .F.
		nOpcX		:= 0

		::generalResponse:status			:= "0"
		::generalResponse:message			:= "Registro bloqueado no momento."
		::generalResponse:codProtheus		:= ""
		::generalResponse:codExternal		:= ""
		::generalResponse:blocked			:= .F.
	endif
endif

if lExecAutoX .and. nOpcX > 0
	DBSelectArea( "ZE9" )
	ZE9->( DBGoTo( nRecnoZE9 ) )

	if nOpcX == 3
		aadd( aSA1, { "A1_TIPO"		, "R"									, nil } )
		aadd( aSA1, { "A1_PESSOA"	, "J"									, nil } )
		aadd( aSA1, { "A1_NATUREZ"	, "10101"								, nil } )
		aadd( aSA1, { "A1_CONTA"	, "112010001"							, nil } )
		aadd( aSA1, { "A1_TIPCLI"	, "4"									, nil } )
		aadd( aSA1, { "A1_CODPAIS"	, "01058"								, nil } )
		aadd( aSA1, { "A1_GRPTRIB"	, "ZZZ"									, nil } )
		aadd( aSA1, { "A1_TPESSOA"	, "CI"									, nil } )
		aadd( aSA1, { "A1_PAIS"		, "105"									, nil } )
		aadd( aSA1, { "A1_DDI"		, "55"									, nil } )
		aadd( aSA1, { "A1_XIDSFOR"	, ::customer:A1_XIDSFOR					, nil } )
		aadd( aSA1, { "A1_CGC"		, ::customer:A1_CGC						, nil } )
		aadd( aSA1, { "A1_LC"		, nLimiteIni							, nil } )
		aadd( aSA1, { "A1_COND"		, cCondPgtoI							, nil } )
		aadd( aSA1, { "A1_VENCLC"	, lastDay( monthSum( dDataBase , 6 ) )	, nil } )

		// VENDEDOR NAO PODE SER ALTERADO PELO SALESFORCE - DEVE RESPEITAR CARTEIRA DA ADM DE VENDAS
		if !empty( ::customer:A1_VEND )
			aadd( aSA1, { "A1_VEND"		, ::customer:A1_VEND	, nil } )
		endif
	endif

	if nOpcX == 4
		aadd( aSA1, { "A1_FILIAL"	, xFilial("SA1")				, nil } )
		aadd( aSA1, { "A1_COD"		, aCodSA1[1]					, nil } )
		aadd( aSA1, { "A1_LOJA"		, aCodSA1[2]					, nil } )
	endif

	aadd( aSA1, { "A1_XENVSFO"	, "S"								, nil } )
	aadd( aSA1, { "A1_XINTSFO"	, "P"								, nil } )

	if !empty( ::customer:A1_NOME )
		aadd( aSA1, { "A1_NOME"		, allTrim( ::customer:A1_NOME )		, nil } )
	endif

	if !empty( ::customer:A1_NREDUZ )
		aadd( aSA1, { "A1_NREDUZ"	, left( allTrim( ::customer:A1_NREDUZ ) , tamSX3("A1_NREDUZ")[1] )	, nil } )
	endif

	if !empty( ::customer:A1_CEP )
		aadd( aSA1, { "A1_CEP"		, allTrim( ::customer:A1_CEP )		, nil } )
	endif

	if !empty( ::customer:A1_END )
		aadd( aSA1, { "A1_END"		, allTrim( ::customer:A1_END )		, nil } )
	endif

	if !empty( ::customer:A1_COMPLEM )
		aadd( aSA1, { "A1_COMPLEM"	, allTrim( ::customer:A1_COMPLEM )	, nil } )
	endif

	if !empty( ::customer:A1_EST )
		aadd( aSA1, { "A1_EST"		, allTrim( ::customer:A1_EST )		, nil } )
	endif

	if !empty( ::customer:A1_COD_MUN )
		aadd( aSA1, { "A1_COD_MUN"	, allTrim( ::customer:A1_COD_MUN )	, nil } )
	endif

	if !empty( ::customer:A1_DDD )
		aadd( aSA1, { "A1_DDD"		, allTrim( ::customer:A1_DDD )		, nil } )
	else
		if nOpcX == 3
			aadd( aSA1, { "A1_DDD"		, "000"					, nil } )
		endIf
	endif

	if !empty( ::customer:A1_BAIRRO )
		aadd( aSA1, { "A1_BAIRRO"	, allTrim( ::customer:A1_BAIRRO )	, nil } )
	endif

	if !empty( ::customer:A1_TEL )
		aadd( aSA1, { "A1_TEL"		, allTrim( ::customer:A1_TEL )		, nil } )
	endif

	if !empty( ::customer:A1_EMAIL )
		aadd( aSA1, { "A1_EMAIL"	, allTrim( ::customer:A1_EMAIL )	, nil } )
	endif

	if !empty( ::customer:A1_CONTATO )
		aadd( aSA1, { "A1_CONTATO"	, allTrim( ::customer:A1_CONTATO )	, nil } )
	endif

	if !empty( ::customer:A1_ZSUGELC )
		aadd( aSA1, { "A1_ZSUGELC"	, ::customer:A1_ZSUGELC	, nil } )
	endif

	if !empty( ::customer:A1_ZSUGPRZ )
		aadd( aSA1, { "A1_ZSUGPRZ"	, ::customer:A1_ZSUGPRZ	, nil } )
	endif

	if !empty( ::customer:A1_CEPC )
		aadd( aSA1, { "A1_CEPC"		, allTrim( ::customer:A1_CEPC )	, nil } )
	endif

	if !empty( ::customer:A1_ENDCOB )
		aadd( aSA1, { "A1_ENDCOB"	, allTrim( ::customer:A1_ENDCOB )	, nil } )
	endif

	if !empty( ::customer:A1_ESTC )
		aadd( aSA1, { "A1_ESTC"		, allTrim( ::customer:A1_ESTC )	, nil } )
	endif

	if !empty( ::customer:A1_MUNC )
		aadd( aSA1, { "A1_MUNC"		, allTrim( ::customer:A1_MUNC )	, nil } )
	endif

	if !empty( ::customer:A1_BAIRROC )
		aadd( aSA1, { "A1_BAIRROC"	, allTrim( ::customer:A1_BAIRROC )	, nil } )
	endif

	if !empty( ::customer:A1_XMAILCO )
		aadd( aSA1, { "A1_XMAILCO"	, allTrim( ::customer:A1_XMAILCO )	, nil } )
	endif

	if !empty( ::customer:A1_XCOMPCO )
		aadd( aSA1, { "A1_XCOMPCO"	, allTrim( ::customer:A1_XCOMPCO )	, nil } )
	endif

	if !empty( ::customer:A1_XCDMUNC )
		aadd( aSA1, { "A1_XCDMUNC"	, allTrim( ::customer:A1_XCDMUNC )	, nil } )
	endif

	if !empty( ::customer:A1_XTELCOB )
		aadd( aSA1, { "A1_XTELCOB"	, allTrim( ::customer:A1_XTELCOB )	, nil } )
	endif

	if !empty( cCNAE2 )
		// SE VALIDOU PELO CNAE SECUNDARIO - UTILIZA NO CADASTRO PRINCIPAL
		aadd( aSA1, { "A1_CNAE"		, allTrim( TRANSFORM( allTrim( cCNAE2 )				,  "@R 9999-9/99" ) ) , nil } )
	else
		if !empty( ::customer:A1_CNAE )
			aadd( aSA1, { "A1_CNAE"		, allTrim( TRANSFORM( allTrim( ::customer:A1_CNAE )	,  "@R 9999-9/99" ) ) , nil } )
		endif
	endif

	if !empty( cCNAE2 )
		aadd( aSA1, { "A1_XCNAE"	, allTrim( cCNAE2 )				, nil } )
	endif
	if !empty( ::customer:A1_INSCR )
		aadd( aSA1, { "A1_INSCR"	, allTrim( ::customer:A1_INSCR )		, nil } )
	endif

	if !empty( ::customer:A1_DTNASC )
		// ::customer:A1_DTNASC - Formato enviado DD/MM/AAAA - necessário formatação
		aadd( aSA1, { "A1_DTNASC"	, cToD( ::customer:A1_DTNASC )	, nil } )
	endif

	if !empty( ::customer:A1_SIMPNAC )
		aadd( aSA1, { "A1_SIMPNAC"	, ::customer:A1_SIMPNAC	, nil } )
	endif

	if nRecnoZE9 > 0
		aadd( aSA1, { "A1_SATIV1"	, ZE9->ZE9_TIPOLO	, nil } )
		aadd( aSA1, { "A1_SATIV2"	, ZE9->ZE9_CATEGO	, nil } )
		aadd( aSA1, { "A1_SATIV3"	, ZE9->ZE9_CANAL	, nil } )
	endif

	aSA1 := fwVetByDic( aSA1 /*aVetor*/ , "SA1" /*cTable*/ , .F. /*lItens*/ )

	varInfo( "aSA1" , aSA1 )

	msExecAuto( { | x , y | MATA030( x , y ) } , aSA1 , nOpcX ) // SA1 Cliente

	if lMsErroAuto
		aErro := GetAutoGRLog() // Retorna erro em array
		cErro := ""

		for nI := 1 to len( aErro )
			cErro += aErro[ nI ] + CRLF
		next nI

		::generalResponse:status		:= "0"
		::generalResponse:message		:= allTrim( cErro )
		::generalResponse:codProtheus	:= ""
		::generalResponse:codExternal	:= ::customer:A1_XIDSFOR
		::generalResponse:blocked		:= .F.
	else
		::generalResponse:status			:= "1"
		::generalResponse:codProtheus		:= allTrim( SA1->A1_COD )
		::generalResponse:codProtheusLoja	:= allTrim( SA1->A1_LOJA )
		::generalResponse:codExternal		:= allTrim( SA1->A1_XIDSFOR )
		::generalResponse:message			:= ""

		::generalResponse:message += getZB1()
		//::generalResponse:message += "FINANCEIRA;INATIVIDADE"

		if empty( ::generalResponse:message )
			// CASO NAO TENHA PENDENCIAS NA GRADE DESBLOQUEIA O REGISTRO
			recLock( "SA1" , .F. )
				SA1->A1_MSBLQL := "2"
			SA1->( msUnlock() )
		endif

		::generalResponse:blocked := ( SA1->A1_MSBLQL == "1" )
	endif

	SA1->( DBRUnlock( RECNO() ) )
endif

varinfo( "::generalResponse " , ::generalResponse )

cTimeFin	:= time()
cTimeResul	:= elapTime( cTimeIni , cTimeFin )

 if !::customer:CALLBACK
	//GRAVAR LOG - Cliente
	U_MGFMONITOR(cFilAnt        												,;
		Iif(::generalResponse:status == "0", "2", ::generalResponse:status )	,;
		cCodInteg 																,;
		cCodTpInt   	 														,;
		::generalResponse:message      			 								,;
		" "																		,;
		cTimeResul																,;
		cVarInfoX  																,;
		0  																		,;
		::generalResponse:status												,;
		.F.		                 												,;
		{}																		,;
		allTrim( fwUUIDv4() )   												,;
		::generalResponse:message                                               ,;
		"S"          															,;
		" " 																	,;
		" " 																	,;
		sTod("    /  /  ") 														,;
		" " 																	,;
		" "																		,;
		cLinkRec																,;
		cLinkRec																)
Endif

restArea( aAreaZE9 )
restArea( aAreaSA1 )
restArea( aArea )
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
static function MyError(oError)
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	nQtd := iif( nQtd > 10 , 10 , nQtd ) //Retorna as 4 linhas

	for nI :=1 to nQtd
		cEr += MemoLine(oError:ERRORSTACK,,ni)
	next nI

	conout( "[MGFWSS11] [ERROR] " + oError:Description )
	_aErr := { '0', cEr }

	break
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
static function chkSA1( cA1Cod )
	local cQWSS07	:= ""
	local aRetSA1	:= {}
	local aArea		:= getArea()

	cQWSS07 := "SELECT A1_COD, A1_LOJA, A1_TIPO, A1_PESSOA, A1_MSBLQL, A1_XPENFIN, SA1.R_E_C_N_O_ SA1RECNO"	+ CRLF
	cQWSS07 += " FROM " + retSQLName("SA1") + " SA1"								+ CRLF
	cQWSS07 += " WHERE"																+ CRLF
	cQWSS07 += " 		SA1.A1_CGC		=	'" + cA1Cod			+ "'"				+ CRLF
	//cQWSS07 += " 		SA1.A1_LOJA		=	'" + right( allTrim( ::contact:cA1Cod ) , 2 )	+ "'"	+ CRLF
	//cQWSS07 += " 	AND	SA1.A1_COD		=	'" + left( allTrim( ::contact:cA1Cod ) , 6 )	+ "'"	+ CRLF
	cQWSS07 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial( "SA1" )	+ "'"	+ CRLF
	cQWSS07 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"							+ CRLF

	TcQuery cQWSS07 New Alias "QWSS07"

	if !QWSS07->( EOF() )
		//		 1				 2				  3				  	  4					  5                  6					 7
		aRetSA1 := { QWSS07->A1_COD, QWSS07->A1_LOJA, QWSS07->A1_TIPO, QWSS07->A1_PESSOA, QWSS07->A1_MSBLQL, QWSS07->A1_XPENFIN, QWSS07->SA1RECNO }
	endif

	QWSS07->(DBCloseArea())

	restArea( aArea )
return aRetSA1

//--------------------------------------------------------------------
//--------------------------------------------------------------------
	WSMETHOD insertOrUpdateContact WSRECEIVE contact WSSEND generalResponse WSSERVICE MGFWSS11
	local aAreaX	:= getArea()
	local aAreaSA1	:= SA1->( getArea() )
	local aAreaSU5	:= SU5->( getArea() )
	local aAreaAC8	:= AC8->( getArea() )
	local cQrySA1	:= ""
	local cQrySU5	:= ""
	local aErro		:= {}
	local cErro		:= ""
	local nOpcX		:= 0
	local nI		:= 0
	//Variaveis de Logs
	local cLinkRec          :=  allTrim( superGetMv( "MGF_WSS11L" , , "http://spdwfapl180:8712/MGFWSS11.apw?WSDL" ) )
	local cRetCall          := ""
	local cCodInteg			:= allTrim( superGetMv( "MGF_CODSZ2" , , "008" ) )//Cod. de busca na SZ2, Tabela de Integração
	local cCodTpInt			:= allTrim( superGetMv( "MGF_WSS11H" , , "006" ) )//Cod. de busca na SZ3, Tabela Tipo de Integração
	local cTimeIni		    := ""
	local cTimeFin		    := ""
	local cTimeResul	    := ""
	local nRecnoCT          := 0
	local cVarInfoX			:= ""

	private lMsHelpAuto     := .T. // Se .T. direciona as mensagens de help para o arq. de log
	private lMsErroAuto     := .F.
	private lAutoErrNoFile  := .T. // Precisa estar como .T. para GetAutoGRLog() retornar o array com erros

	setFunName( "MGFWSS11" )

	conout( "[MGFWSS11] insertOrUpdateContact " + dToC( dDataBase ) + " - " + time() )

	cVarInfoX	:= varInfo( "contact" , ::contact )
	cTimeIni	:= time()

	DBSelectArea( "SA1" )
	DBSelectArea( "SU5" )
	DBSelectArea( "AC8" )

	cQrySA1 := "SELECT SA1.R_E_C_N_O_ SA1RECNO"									+ CRLF
	cQrySA1 += " FROM " + retSQLName( "SA1" ) + " SA1"							+ CRLF
	cQrySA1 += " WHERE"															+ CRLF
	//cQrySA1 += " 		SA1.A1_LOJA		=	'" + ::contact:U5_LOJA		+ "'"	+ CRLF
	//cQrySA1 += " 	AND	SA1.A1_COD		=	'" + ::contact:U5_CLIENTE	+ "'"	+ CRLF
	cQrySA1 += " 		SA1.A1_LOJA		=	'" + right( allTrim( ::contact:U5_CLIENTE ) , 2 )	+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.A1_COD		=	'" + left( allTrim( ::contact:U5_CLIENTE ) , 6 )	+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1")			+ "'"	+ CRLF
	cQrySA1 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"								+ CRLF

	tcQuery cQrySA1 new alias "QRYSA1"

	if !QRYSA1->( EOF() )
		SA1->( DBGoTo( QRYSA1->SA1RECNO ) )

		if !empty( ::contact:U5_CODCONT )
			cQrySU5 := "SELECT SU5.R_E_C_N_O_ SU5RECNO"										+ CRLF
			cQrySU5 += " FROM "			+ retSQLName( "SU5" ) + " SU5"						+ CRLF
			cQrySU5 += " INNER JOIN "	+ retSQLName( "AC8" ) + " AC8"						+ CRLF
			cQrySU5 += " ON"																+ CRLF
			cQrySU5 += " 		AC8.AC8_ENTIDA	=	'SA1'"									+ CRLF
			cQrySU5 += " 	AND	AC8.AC8_CODENT	=	'" + SA1->( A1_COD + A1_LOJA ) + "'"	+ CRLF
			cQrySU5 += " 	AND	AC8.AC8_CODCON	=	SU5.U5_CODCONT"							+ CRLF
			cQrySU5 += "	AND	AC8.AC8_FILENT	=	'" + xFilial("AC8") + "'"				+ CRLF
			cQrySU5 += "	AND	AC8.AC8_FILIAL	=	'" + xFilial("AC8") + "'"				+ CRLF
			cQrySU5 += "	AND	AC8.D_E_L_E_T_	<>	'*'"									+ CRLF
			cQrySU5 += " WHERE"																+ CRLF
			cQrySU5 += " 		SU5.U5_CODCONT	=	'" + ::contact:U5_CODCONT	+ "'"		+ CRLF
			cQrySU5 += " 	AND	SU5.U5_FILIAL	=	'" + xFilial("SU5")			+ "'"		+ CRLF
			cQrySU5 += " 	AND	SU5.D_E_L_E_T_	<>	'*'"									+ CRLF

			tcQuery cQrySU5 New Alias "QRYSU5"

			if !QRYSU5->( EOF() )
				SU5->( DBGoTo( QRYSU5->SU5RECNO ) )

				// DBRLock - Retorna verdadeiro (.T.), se o registro for bloqueado com sucesso; caso contrário, falso (.F.).
				if SU5->( DBRLock( QRYSU5->SU5RECNO ) )
					if ::contact:INTEGRATED
						recLock( "SZ9" , .F. )
						SU5->U5_CODCONT	:= "2"
						SU5->U5_XIDSFOR	:= ::contact:U5_XIDSFOR
						SZ9->( msUnlock() )

						::generalResponse:status		:= "1"
						::generalResponse:message		:= "Retorno de integração recebido com sucesso."
						::generalResponse:codProtheus	:= allTrim( SU5->U5_CODCONT )
						::generalResponse:codExternal	:= allTrim( SU5->U5_XIDSFOR )
						::generalResponse:blocked		:= ( SU5->U5_MSBLQL  == "1" )
					else
						if ::contact:DELETE
							nOpcX := 5 // EXCLUSAO
						else
							nOpcX := 4 // ALTERACAO
						endif
					endif
				else
					nOpcX := 0

					::generalResponse:status			:= "0"
					::generalResponse:message			:= "Registro bloqueado no momento."
					::generalResponse:codProtheus		:= ""
					::generalResponse:codExternal		:= ""
					::generalResponse:blocked			:= .F.
				endif
			else
				::generalResponse:status		:= "0"
				::generalResponse:message		:= "Contato '" + ::contact:U5_CODCONT + "' não localizado para alteração."
				::generalResponse:codProtheus	:= ""
				::generalResponse:codExternal	:= ::contact:U5_XIDSFOR
				::generalResponse:blocked		:= .F.
			endif

			QRYSU5->( DBCloseArea() )
		else
			// INCLUSAO
			nOpcX := 3
		endif
	else
		::generalResponse:status		:= "0"
		::generalResponse:message		:= "Codigo / Loja não encontrado na base."
		::generalResponse:codProtheus	:= ""
		::generalResponse:codExternal	:= ::contact:U5_XIDSFOR
		::generalResponse:blocked		:= .F.
	endif

	QRYSA1->( DBCloseArea() )

	if nOpcX > 0
		aSU5 := {}

		aadd( aSU5 , { "U5_FILIAL"	, xFilial("SU5")			, nil } )

		if !empty( ::contact:U5_CONTAT )
			aadd( aSU5 , { "U5_CONTAT"	, ::contact:U5_CONTAT	, nil } )
		endif

		if !empty( ::contact:U5_DDD )
			::contact:U5_DDD := strTran( ::contact:U5_DDD , ")" , "" )
			::contact:U5_DDD := strTran( ::contact:U5_DDD , "(" , "" )

			aadd( aSU5 , { "U5_DDD" , ::contact:U5_DDD , nil } )
		endif

		if !empty( ::contact:U5_FCOM2 )
			aadd( aSU5 , { "U5_FCOM2"	, ::contact:U5_FCOM2	, nil } )
		endif

		if !empty( ::contact:U5_CELULAR )
			aadd( aSU5 , { "U5_CELULAR"	, ::contact:U5_CELULAR	, nil } )
		endif

		if !empty( ::contact:U5_EMAIL )
			aadd( aSU5 , { "U5_EMAIL"	, ::contact:U5_EMAIL	, nil } )
		endif

		if !empty( ::contact:U5_XDEPTO )
			aadd( aSU5 , { "U5_XDEPTO"	, ::contact:U5_XDEPTO	, nil } )
		endif

		if !empty( ::contact:U5_XCARGO )
			aadd( aSU5 , { "U5_XCARGO"	, ::contact:U5_XCARGO	, nil } )
		endif

		if nOpcX == 3
			aadd( aSU5 , { "U5_XIDSFOR"	, ::contact:U5_XIDSFOR	, nil } )
			aadd( aSU5 , { "U5_CLIENTE"	, right( allTrim( ::contact:U5_CLIENTE ) , 6 )	, nil } )
			aadd( aSU5 , { "U5_LOJA"	, left( allTrim( ::contact:U5_CLIENTE ) , 2 )	, nil } )
		endif

		if nOpcX == 4 .or. nOpcX == 5
			aadd( aSU5 , { "U5_CODCONT"	, ::contact:U5_CODCONT	, nil } )
		endif

		msExecAuto( { | x , y | TMKA070( x , y ) } , aSU5 , nOpcX )

		if lMsErroAuto
			aErro := GetAutoGRLog() // Retorna erro em array
			cErro := ""

			for nI := 1 to len(aErro)
				cErro += aErro[ nI ] + CRLF
			next nI

			::generalResponse:status		:= "0"
			::generalResponse:message		:= "Problema na operação em cadastro dos Dados de Contato:" + CRLF + cErro
			::generalResponse:codProtheus	:= ""
			::generalResponse:codExternal	:= ::contact:U5_XIDSFOR
			::generalResponse:blocked		:= .F.
		else
			if nOpcX == 3
				recLock("AC8", .T.)
				AC8->AC8_FILIAL := xFilial("AC8")
				AC8->AC8_FILENT := xFilial("AC8")
				AC8->AC8_ENTIDA := "SA1"
				AC8->AC8_CODENT := SA1->( A1_COD + A1_LOJA )
				AC8->AC8_CODCON := SU5->U5_CODCONT // U5_CODCONT = AC8_CODCON
				AC8->( msUnlock() )
			elseif nOpcX == 5
				AC8->( DBSetOrder( 1 ) ) // 1 - AC8_FILIAL+AC8_CODCON+AC8_ENTIDA+AC8_FILENT+AC8_CODENT
				if AC8->( DBSeek( xFilial("AC8") + SU5->U5_CODCONT + "SA1" + xFilial("AC8") + SA1->( A1_COD + A1_LOJA ) ) )
					recLock( "AC8" , .F. )
					AC8->( DBDelete() )
					AC8->( msUnlock() )
				endif
			endif

			::generalResponse:status		:= "1"
			::generalResponse:message		:= "Operação em cadastro de Contato feita com sucesso"
			::generalResponse:codProtheus	:= allTrim( SU5->U5_CODCONT )
			::generalResponse:codExternal	:= allTrim( SU5->U5_XIDSFOR )
		endif

		SU5->( DBRUnlock( RECNO() ) )
	endif

	varinfo( "::generalResponse " , ::generalResponse )
	cTimeFin	:= time()
	cTimeResul	:= elapTime( cTimeIni , cTimeFin )

		//GRAVAR LOG - Contato
		U_MGFMONITOR(							 ;
		cFilAnt	/*cFil*/		        		,;
		Iif(::generalResponse:status == "0", "2", ::generalResponse:status )/*cStatus*/,;
		cCodInteg /*cCodint Z1_INTEGRA*/		 ,;
		cCodTpInt /*cCodtpint Z1_TPINTEG*/  	 ,;
		::generalResponse:message /*cErro*/      ,;
		""/*cDocori*/	                         ,;
		cTimeResul/*cTempo*/,;
		cVarInfoX /*cJSON*/ ,;
		nRecnoCT/*nRecnoDoc*/            ,;
		::generalResponse:status/*cHTTP*/,;
		.F./*lJob*/		                 ,;
		{}/*aFil*/		                 ,;
		" "/*cUUID*/               ,;
		::generalResponse:message /*cJsonR*/,;
		"S"/*cTipWsInt*/           ,;
		" "/*cJsonCB /*Z1_JSONCB*/ ,;
		" "/*cJsonRB /*Z1_JSONRB*/ ,;
		sTod("    /  /  ") /*dDTCallb /*Z1_DTCALLB*/,;
		" "/*cHoraCall /*Z1_HRCALLB*/,;
		" "/*cCallBac /*Z1_CALLBAC*/,;
		cLinkRec /*cLinkEnv /*Z1_LINKENV*/,;
		cLinkRec /*cLinkRec /*Z1_LINKREC*/)

	restArea( aAreaAC8 )
	restArea( aAreaSU5 )
	restArea( aAreaSA1 )
	restArea( aAreaX )
return .T.

//--------------------------------------------------------------------
//--------------------------------------------------------------------
static function chkCNAE( cCNPJ , cCNAE , nZE9Recno )
	local lRetCNAE	:= .F.
	local cQryZE9	:= ""

	default cCNPJ	:= ""
	default cCNAE	:= ""

	cQryZE9 := "SELECT ZE9.R_E_C_N_O_	ZE9RECNO"																	+ CRLF
	cQryZE9 += " FROM " + retSQLName( "ZE9" ) + " ZE9"																+ CRLF

	if !empty( cCNPJ )
		cQryZE9 += " INNER JOIN "	+ retSQLName( "ZEM" ) + " ZEM"													+ CRLF
		cQryZE9 += " ON"																							+ CRLF
		cQryZE9 += " 			ZEM.ZEM_CNPJ	=	'" + left( allTrim( cCNPJ ) , 8 )	+ "'"						+ CRLF
		cQryZE9 += " 		AND	ZEM.ZEM_FILIAL	=	ZE9.ZE9_FILIAL"													+ CRLF
		cQryZE9 += " 		AND	ZEM.ZEM_TIPOLO	=	ZE9.ZE9_TIPOLO"													+ CRLF
		cQryZE9 += " 		AND	ZEM.ZEM_CATEGO	=	ZE9.ZE9_CATEGO"													+ CRLF
		cQryZE9 += " 		AND	ZEM.ZEM_CANAL	=	ZE9.ZE9_CANAL"													+ CRLF
		cQryZE9 += " 		AND ZEM.ZEM_FILIAL	=	'" + xFilial("ZEM") + "'"										+ CRLF
		cQryZE9 += " 		AND	ZEM.D_E_L_E_T_	<>	'*'"															+ CRLF
	elseif !empty( cCNAE )
		cQryZE9 += " INNER JOIN "	+ retSQLName( "CC3" ) + " CC3"													+ CRLF
		cQryZE9 += " ON"																							+ CRLF
		cQryZE9 += " 			CC3.CC3_COD		=	'" + transform( allTrim( cCNAE ) , "@R 9999-9/99" )	+ "'"		+ CRLF
		cQryZE9 += " 		AND	CC3.CC3_ZTIPOL	=	ZE9.ZE9_TIPOLO"													+ CRLF
		cQryZE9 += " 		AND	CC3.CC3_ZCATEG	=	ZE9.ZE9_CATEGO"													+ CRLF
		cQryZE9 += " 		AND	CC3.CC3_ZCANAL	=	ZE9.ZE9_CANAL"													+ CRLF
		cQryZE9 += " 		AND CC3.CC3_FILIAL	=	'" + xFilial( "CC3" ) + "'"										+ CRLF
		cQryZE9 += " 		AND	CC3.D_E_L_E_T_	<>	'*'"															+ CRLF
		cQryZE9 += " 		AND	CC3.CC3_MSBLQL	=	'2'"															+ CRLF
		// VERIFICA SE CNAE ESTA ATIVO COMERCIALMENTE - QUANDO CONSULTA FOR POR CNPJ NAO CONSIDERAR ESTE CAMPO POIS SERA EXCECAO
		cQryZE9 += " 		AND	ZE9.ZE9_COMERC	=	'S'"															+ CRLF
	endif

	cQryZE9 += " WHERE"																								+ CRLF
	cQryZE9 += " 		ZE9.ZE9_FILIAL	=	'" + xFilial("ZE9")			+ "'"										+ CRLF
	cQryZE9 += " 	AND	ZE9.D_E_L_E_T_	<>	'*'"																	+ CRLF

	if !empty( cQryZE9 )
		tcQuery cQryZE9 New Alias "QRYZE9"

		if !QRYZE9->( EOF() )
			lRetCNAE	:= .T.
			nZE9Recno	:= QRYZE9->ZE9RECNO
		endif

		QRYZE9->( DBCloseArea() )
	endif
return lRetCNAE

//--------------------------------------------------------------------
// Verifica se vendedor tem exceção de CNAE
//--------------------------------------------------------------------
static function excessCNAE( cCodSA3 )
	local lExcessao	:= .F.
	local cQrySA3	:= ""

	cQrySA3 := "SELECT SA3.R_E_C_N_O_	SA3RECNO"						+ CRLF
	cQrySA3 += " FROM " + retSQLName( "SA3" ) + " SA3"					+ CRLF
	cQrySA3 += " WHERE"													+ CRLF
	cQrySA3 += " 		SA3.A3_XEXCNAE	=	'S'"						+ CRLF
	cQrySA3 += " 	AND	SA3.A3_COD		=	'" + cCodSA3		+ "'"	+ CRLF
	cQrySA3 += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3")	+ "'"	+ CRLF
	cQrySA3 += " 	AND	SA3.D_E_L_E_T_	<>	'*'"						+ CRLF

	tcQuery cQrySA3 New Alias "QRYSA3"

	if !QRYSA3->( EOF() )
		lExcessao	:= .T.
	endif

	QRYSA3->( DBCloseArea() )
return lExcessao

//--------------------------------------------------------------------
// Retorna as aprovações pendentes da Grade de Aprovação
// Se lReactivat igual a .T. aprova a grade para a reativação do cliente
// lReactivat - Se verdadeiro aprova as pendencias para gerar reativacao
// lUpdCredit - Se verdadeiro operacao vem do metodo updateFinancialLimit e devera aprovar apenas bloqueios de financeiro
//--------------------------------------------------------------------
static function getZB1( lReactivat , lUpdCredit )
	local aAreaX		:= getArea()
	local aAreaZB1		:= ZB1->( getArea() )
	local aAreaZB2		:= ZB2->( getArea() )
	local cQryZB1		:= ""
	local cUpdSA1		:= ""
	local cUpdZB1		:= ""
	local cApprovals	:= ""
	local nZB1Recno		:= 0

	default lReactivat	:= .F. // Se verdadeiro aprova as pendencias para gerar reativacao
	default lUpdCredit	:= .F. // Se verdadeiro operacao vem do metodo updateFinancialLimit e devera aprovar apenas bloqueios de financeiro

	DBSelectArea( "ZB1" )
	DBSelectArea( "ZB2" )

	cQryZB1 := "SELECT ZB1.R_E_C_N_O_ ZB1RECNO , ZB6_NOME, ZB2.R_E_C_N_O_ ZB2RECNO"		+ CRLF
	cQryZB1 += " FROM "			+ retSQLName( "ZB1" ) + " ZB1"							+ CRLF
	cQryZB1 += " INNER JOIN "	+ retSQLName( "ZB2" ) + " ZB2"							+ CRLF
	cQryZB1 += " ON"																	+ CRLF
	cQryZB1 += " 		ZB2.ZB2_ID		=	ZB1.ZB1_ID"									+ CRLF
	cQryZB1 += " 	AND	ZB2.ZB2_STATUS	<>	'1'"										+ CRLF
	cQryZB1 += " 	AND	ZB2.ZB2_FILIAL	=	'" + xFilial("ZB2")	+ "'"					+ CRLF
	cQryZB1 += " 	AND	ZB2.D_E_L_E_T_	<>	'*'"										+ CRLF

	if lUpdCredit
		// Se verdadeiro operacao vem do metodo updateFinancialLimit e devera aprovar apenas bloqueios de financeiro
		cQryZB1 += " INNER JOIN "	+ retSQLName( "ZB6" ) + " ZB6"						+ CRLF
		cQryZB1 += " ON"																+ CRLF
		cQryZB1 += " 		ZB6.ZB6_ID    	=	'04'"									+ CRLF
		cQryZB1 += " 	AND	ZB6.ZB6_ID    	=	ZB2.ZB2_IDSET"							+ CRLF
		cQryZB1 += " 	AND	ZB6.ZB6_FILIAL	=	'" + xFilial("ZB6")	+ "'"				+ CRLF
		cQryZB1 += " 	AND	ZB6.D_E_L_E_T_	<>	'*'"									+ CRLF
	else
		// Se verdadeiro aprova as pendencias para gerar reativacao
		cQryZB1 += " LEFT JOIN "	+ retSQLName( "ZB6" ) + " ZB6"						+ CRLF
		cQryZB1 += " ON"																+ CRLF
		cQryZB1 += " 		ZB6.ZB6_ID    	=	ZB2.ZB2_IDSET"							+ CRLF
		cQryZB1 += " 	AND	ZB6.ZB6_FILIAL	=	'" + xFilial("ZB6")	+ "'"				+ CRLF
		cQryZB1 += " 	AND	ZB6.D_E_L_E_T_	<>	'*'"									+ CRLF
	endif

	cQryZB1 += " WHERE"																	+ CRLF
	cQryZB1 += "		ZB1.ZB1_RECNO	=	'" + alltrim( str( SA1->( RECNO() ) ) ) + "'"	+ CRLF
	cQryZB1 += " 	AND	ZB1.ZB1_STATUS	IN	( '3' , '4' )"				+ CRLF // Solicitação Aberta / Aprovação em Andamento
	cQryZB1 += " 	AND	ZB1.ZB1_CAD		=	'1'"						+ CRLF // SA1 - Clientes
	cQryZB1 += " 	AND	ZB1.ZB1_FILIAL	=	'" + xFilial("ZB1")	+ "'"	+ CRLF
	cQryZB1 += " 	AND	ZB1.D_E_L_E_T_	<>	'*'"						+ CRLF

	tcQuery cQryZB1 new alias "QRYZB1"

	while !QRYZB1->( EOF() )
		nZB1Recno := QRYZB1->ZB1RECNO

		if lReactivat .or. lUpdCredit
			ZB2->( DBGoTo( QRYZB1->ZB2RECNO ) )
			recLock( "ZB2" , .F. )
				ZB2->ZB2_STATUS	:= '1' //Aprovado
				if lUpdCredit
					ZB2->ZB2_OBS	:= "Liberação automática - crédito aprovado via Salesforce"
				else
					ZB2->ZB2_OBS	:= "Liberação automática - Reativação Salesforce"
				endif
				ZB2->ZB2_IDAPR	:= "MGFWSS11 - SALESFORCE"
				ZB2->ZB2_DATA	:= date()
				ZB2->ZB2_HORA	:= time()
			ZB2->( msUnlock() )
		else
			cApprovals += allTrim( QRYZB1->ZB6_NOME ) + ";"
		endif

		QRYZB1->( DBSkip() )
	enddo

	if !empty( cApprovals )
		cApprovals := left( cApprovals , len( cApprovals ) - 1 )
	endif

	QRYZB1->( DBCloseArea() )

	if lReactivat .or. lUpdCredit
		if empty( getZB1( .F. /*lReactivat*/ , .F. /*lUpdCredit*/ ) )
			// CASO NAO EXISTA PENDENCIAS APROVA A ZB1 E CLIENTE
			cUpdZB1 := ""
			cUpdZB1 := "UPDATE " + retSQLName("ZB1")									+ CRLF
			cUpdZB1 += "	SET"														+ CRLF
			cUpdZB1 += " 		ZB1_STATUS	= '1' "										+ CRLF
			cUpdZB1 += " WHERE"															+ CRLF
			cUpdZB1 += "		R_E_C_N_O_	=	'" + alltrim( str( nZB1Recno ) ) + "'"	+ CRLF

			if tcSQLExec( cUpdZB1 ) < 0
				conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
			endif

			// CASO NAO TENHA PENDENCIAS NA GRADE DESBLOQUEIA O REGISTRO
			recLock( "SA1" , .F. )
				SA1->A1_MSBLQL	:= "2"
				SA1->A1_ZINATIV	:= "0"
			SA1->( msUnlock() )
		endif
	endif

	restArea( aAreaZB2 )
	restArea( aAreaZB1 )
	restArea( aAreaX )
return cApprovals

//--------------------------------------------------------------------
// Verifica se CNAE esta bloqueado
//--------------------------------------------------------------------
static function blockCNAE( cCNAE )
	local lBlockCNAE	:= .F.
	local cQryCC3		:= ""

	cQryCC3 := "SELECT CC3.R_E_C_N_O_"																	+ CRLF
	cQryCC3 += " FROM " + retSQLName( "CC3" ) + " CC3"													+ CRLF
	cQryCC3 += " WHERE"																					+ CRLF
	cQryCC3 += " 		CC3.CC3_COD		=	'" + transform( allTrim( cCNAE ) ,  "@R 9999-9/99" ) + "'"	+ CRLF
	cQryCC3 += " 	AND	CC3.CC3_MSBLQL	=	'1'"														+ CRLF
	cQryCC3 += " 	AND CC3.CC3_FILIAL	=	'" + xFilial( "CC3" ) + "'"									+ CRLF
	cQryCC3 += " 	AND	CC3.D_E_L_E_T_	<>	'*'"														+ CRLF

	tcQuery cQryCC3 new alias "QRYCC3"

	if !QRYCC3->( EOF() )
		lBlockCNAE	:= .T.
	endif

	QRYCC3->( DBCloseArea() )
return lBlockCNAE

//--------------------------------------------------------------------
// Retorna a sequencia do item da SC6
//--------------------------------------------------------------------
static function getMaxSC6( cC6Filial , cC6Num )
	local cQrySC6		:= ""
	local cMaxSequen	:= strZero ( 0 , tamSX3("C6_ITEM")[1] )

	cQrySC6 := "SELECT"												+ CRLF
	cQrySC6 += " MAX( C6_ITEM ) C6_ITEM"							+ CRLF
	cQrySC6 += " FROM " + retSQLName( "SC6" ) + " SC6"				+ CRLF
	cQrySC6 += " WHERE"												+ CRLF
	cQrySC6 += " 		SC6.C6_NUM		=	'" + cC6Num		+ "'"	+ CRLF
	cQrySC6 += " 	AND SC6.C6_FILIAL	=	'" + cC6Filial	+ "'"	+ CRLF

	tcQuery cQrySC6 new alias "QRYSC6"

	if !QRYSC6->( EOF() )
		cMaxSequen := QRYSC6->C6_ITEM
	endif

	QRYSC6->( DBCloseArea() )
return cMaxSequen
