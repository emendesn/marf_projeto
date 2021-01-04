#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*
	INTEGRACAO SALESFORCE
	VENDEDORES
*/
//-------------------------------------------------------------------
// Para ser chamado em JOB
//-------------------------------------------------------------------
user function JOBWSC37( cFilJob )

	U_MGFWSC37( { "01" , cFilJob } )

return

//-------------------------------------------------------------------
// Para ser chamado em MENU
//-------------------------------------------------------------------
user function MNUWSC37()

	runInteg37()

return

//-------------------------------------------------------------------
user function MGFWSC37( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[ 1 ] FILIAL aEmpX[ 2 ]

	conout( '[MGFWSC37] Iniciada Threads para a empresa' + allTrim( aEmpX[ 2 ] ) + ' - ' + dToC(dDataBase) + " - " + time() )

	runInteg37()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
static function runInteg37( )
	// MOCK - POST 		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}/contatos
	// MOCK - PUT  		- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}/contatos/{id_codigo_c}
	// MOCK - DELETE	- https://anypoint.mulesoft.com/mocking/api/v1/links/a4551bd0-51cd-40f2-9882-fd1e5d9266ea/clientes/{id}/contatos/{id_codigo_c}

	local cURLInteg		:= allTrim( superGetMv( "MGFWSC37A" , , "xxxxxxxxxxxxxxxxxxxx" ) )
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

	private oJson		:= nil

	conout("[SALESFORCE] - MGFWSC37- Selecionando vendedores aptos a integrar com SALESFORCE")

	getSA3()

	aadd( aHeadStr , 'Content-Type: application/json' )

	while !QRYWSC37->(EOF())
		oJson := nil
		oJson := JsonObject():new()

		setSA3()

		cURLUse := ""
		cJson	:= ""
		cJson	:= oJson:toJson()

		if !empty( cJson )
			cURLUse := strTran( cURLInteg , "{id}" , allTrim( QRYWSC37->A3_COD ) )

			if !empty( QRYWSC37->A3_XIDSFOR )
				cURLUse		:= strTran( cURLUse , "{id_codigo_c}" , allTrim( QRYWSC37->A3_XIDSFOR ) )
				cHTTPMetho	:= "PUT"
			else
				cURLUse		:= strTran( cURLUse , "/{id_codigo_c}" , "" )
				cHTTPMetho	:= "POST"
			endif

			cTimeIni	:= time()
			cHeaderRet	:= ""
			httpQuote( cURLUse /*<cUrl>*/, cHTTPMetho /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni , cTimeFin )
			nStatuHttp	:= 0
			nStatuHttp	:= httpGetStatus()

			conout(" [SALESFORCE] [MGFWSC37] * * * * * Status da integracao * * * * *"									)
			conout(" [SALESFORCE] [MGFWSC37] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC37] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase )	)
			conout(" [SALESFORCE] [MGFWSC37] Tempo de Processamento.......: " + cTimeProc 								)
			conout(" [SALESFORCE] [MGFWSC37] URL..........................: " + cURLUse 								)
			conout(" [SALESFORCE] [MGFWSC37] HTTP Method..................: " + "PUT" 									)
			conout(" [SALESFORCE] [MGFWSC37] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 			)
			conout(" [SALESFORCE] [MGFWSC37] Envio........................: " + cJson 									)
			conout(" [SALESFORCE] [MGFWSC37] * * * * * * * * * * * * * * * * * * * * "									)

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				cUpdTbl	:= ""

				cUpdTbl := "UPDATE " + retSQLName("SA3")										+ CRLF
				cUpdTbl += "	SET"															+ CRLF
				cUpdTbl += " 		A3_XINTSFO = '1'"											+ CRLF
				cUpdTbl += " WHERE"																+ CRLF
				cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( QRYWSC37->SA3RECNO ) ) + ""	+ CRLF

				if tcSQLExec( cUpdTbl ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif
			endif
		endif

		freeObj( oJson )

		QRYWSC37->(DBSkip())
	enddo

	QRYWSC37->(DBCloseArea())

	delClassINTF()
return

//-------------------------------------------------------------------
// Seleciona os clientes para exportação
//-------------------------------------------------------------------
static function getSA3()
	local cQRYWSC37 := ""

	cQRYWSC37 += " SELECT SA3.*,"												+ CRLF
	cQRYWSC37 += " SA3.R_E_C_N_O_ SA3RECNO"										+ CRLF
	cQRYWSC37 += " FROM "	+ retSQLName( "SA3" ) + " SA3"						+ CRLF
	cQRYWSC37 += " WHERE"														+ CRLF
	cQRYWSC37 += " 		SA3.A3_XINTSFO	=	'0'"								+ CRLF
	cQRYWSC37 += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'"			+ CRLF
	cQRYWSC37 += " 	AND	SA3.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQRYWSC37 += " ORDER BY A3_CLIENTE, A3_LOJA"								+ CRLF

	conout( "[MGFWSC37] [SALESFORCE] " + cQRYWSC37 )

	tcQuery cQRYWSC37 New Alias "QRYWSC37"
return

//---------------------------------------------------------------------
// Carrega o cliente
//---------------------------------------------------------------------
static function setSA3()
	oJson["A3_COD"	]	:= allTrim( QRYWSC37->A3_COD	)
	oJson["A3_NOME"	]	:= allTrim( QRYWSC37->A3_NOME	)
return