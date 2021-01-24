#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} JOBWSC74
Gatilho para Taura enviar o estoque
@description
Gatilho para Taura enviar o estoque
@author TOTVS
@since 14/02/2020
@type Function
@table

@param
 cFilJob - Caracter informa a filial que será usada
@return
 Sem retorno
@menu
 Sem menu
/*/
user function JOBWSC74( cFilJob )

	U_MGFWSC74( { "01" , cFilJob } )

return

/*/
=============================================================================
{Protheus.doc} MNUWSC74
Gatilho para Taura enviar o estoque
@description
Gatilho para Taura enviar o estoque
@author TOTVS
@since 14/02/2020
@type Function
@table

@param
 Sem parametro
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MNUWSC74()

	runInteg74()

return

/*/
=============================================================================
{Protheus.doc} MGFWSC74
Gatilho para Taura enviar o estoque
@description
Gatilho para Taura enviar o estoque
@author TOTVS
@since 14/02/2020
@type Function
@table
@param
 aEmpX - Array com Empresa e Filial que serão configuradas
@return
 Sem retorno
@menu
 Sem menu
/*/
user function MGFWSC74( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC74] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg74()

	RESET ENVIRONMENT
return

/*/
=============================================================================
{Protheus.doc} runInteg74
Integração de Clientes com Salesforce
@description
Integração de Clientes com Salesforce
@author TOTVS
@since 14/02/2020
@type Function
@table
@param
@return
 Sem retorno
@menu
 Sem menu
/*/
static function runInteg74()
	local cIDMgf		:= allTrim( superGetMv( "MGFIDINTEG"	, , "7899b75c-c6fc-42cb-99c5-7930166b121f" ) )
	local cURLInteg		:= allTrim( superGetMv( "MGFWSC74A"		, , "https://spdwvapl203/processo-estoque/api/v2/empresa/{IdFilial}/atualizar-posicao-estoque" ) )
	local cIdInteg		:= FWUUIDV4()
	local cURLUse		:= ""
	local cHTTPMetho	:= "POST"
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
	local cCodTpInt		:= allTrim( superGetMv( "MGFWSC74B"		, , "001" ) ) // SZ3 - ENTIDADE

	local cHeadHttp		:= ""

	aadd( aHeadStr , 'x-marfrig-client-id: ' + cIDMgf	)
	aadd( aHeadStr , 'x-correlation-id: ' + cIdInteg	)
	aadd( aHeadStr , 'Content-Type: application/json'	)

	cURLUse		:= strTran( cURLInteg , "{IdFilial}" , allTrim( cFilAnt ) )

	cTimeIni	:= time()
	cHeaderRet	:= ""
	xRetHttp	:= ""
	xRetHttp	:= httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni , cTimeFin )
	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	conout(" [SALESFORCE] [MGFWSC74] * * * * * Status da integracao * * * * *"									)
	conout(" [SALESFORCE] [MGFWSC74] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
	conout(" [SALESFORCE] [MGFWSC74] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
	conout(" [SALESFORCE] [MGFWSC74] Tempo de Processamento.......: " + cTimeProc 								)
	conout(" [SALESFORCE] [MGFWSC74] URL..........................: " + cURLUse 								)
	conout(" [SALESFORCE] [MGFWSC74] HTTP Method..................: " + cHTTPMetho								)
	conout(" [SALESFORCE] [MGFWSC74] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
	conout(" [SALESFORCE] [MGFWSC74] Retorno......................: " + xRetHttp 								)
	conout(" [SALESFORCE] [MGFWSC74] * * * * * * * * * * * * * * * * * * * * "									)

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
	iif( ( nStatuHttp >= 200 .and. nStatuHttp <= 299 ) , "Requisição de estoque feita!" , xRetHttp )			/*cErro*/					,;
	" "																											/*cDocori*/				     ,;
	cTimeProc																									/*cTempo*/	 ,;
	"" 																											/*cJSON*/		     ,;
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

	restArea( aAreaX )
return