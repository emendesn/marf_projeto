#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
-----------------------------------------------------
	Comunicação com a GETNET
-----------------------------------------------------
*/
user function xGetNet()

	local nTimeOut	:= 120
	//local cUrl		:= "https://api-sandbox.getnet.com.br/auth/oauth/v2/token"
	local cUrl		:= "https://api-homologacao.getnet.com.br/auth/oauth/v2/token"
	local aHeadOut	:= {}
	local cHeadRet	:= ""
	local xPostRet

	aadd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')
	//aadd( aHeadOut, 'Authorization: Basic MWRmYjM0YzMtOGZiOC00ZGQxLWI2NjYtNzhjMDQzM2E5MTEwOjMxNDZlNzcwLWU5NmUtNGRmYy1iMjAwLTUwYThkOWViNmQ3YQ==')
	aadd( aHeadOut, 'Authorization: Basic OTIyZWQ4NmMtNTNlNy00ZTY1LTljMzAtODE5YWE1ZmJmYTE2OmU3OTE0MjBhLTE3N2YtNGU1NC04NmU3LTVjNTg0NzQ1MmIyZg==')
	aadd( aHeadOut, 'Accept: application/json')

	//aadd( aHeadOut, 'scope: oob')
	//aadd( aHeadOut, 'grant_type: client_credentials')

	//xPostRet := httpPost(cUrl, , ,nTimeOut,aHeadOut,@cHeadRet)
	xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)
	//xPostRet := httpPost(cUrl, , '{"scope":"oob","grant_type":"client_credentials"}', nTimeOut, aHeadOut, @cHeadRet)
	//xPostRet := httpPost(cUrl, , ,nTimeOut,aHeadOut,@cHeadRet)

	varInfo( "httpGetStatus()", httpGetStatus() )

	if !empty(xPostRet)
	  conout("HttpPost Ok")
	  varinfo("WebPage", xPostRet)
	else
	  conout("HttpPost Failed.")
	  varinfo("Header", cHeadRet)
	endif
return

//--------------------------------------------------------------
// Autentica, Recupera cartao e Efetiva transcao
//--------------------------------------------------------------
user function mainGtnt()
	local cAccessTok	:= ""
	local jCard			:= nil

	cAccessTok := u_authGtnt()

	if !empty( cAccessTok )
		jCard := u_recoCard( cAccessTok )
		u_paymGtnt( cAccessTok )
	endif

return

//--------------------------------------------------------------
// Autentica conexao na getnet
//--------------------------------------------------------------
user function authGtnt()
	local cSellerID		:= allTrim( superGetMv( "MGFGTNTSEL" , , "384f0f3e-1f4d-4417-8454-a323f331b89f" ) )
	local cClientID		:= allTrim( superGetMv( "MGFGTNTCLI" , , "922ed86c-53e7-4e65-9c30-819aa5fbfa16" ) )
	local cClientSec	:= allTrim( superGetMv( "MGFGTNTSEC" , , "e791420a-177f-4e54-86e7-5c5847452b2f" ) )
	local cAutorizat	:= ""
	local nTimeOut		:= 120
	local cUrl			:= allTrim( superGetMv( "MGFGTNTURL" , , "https://api-homologacao.getnet.com.br/auth/oauth/v2/token" ) )
	local aHeadOut		:= {}
	local cHeadRet		:= ""
	local xPostRet		:= ""
	local nStatuHttp	:= 0
	local oAuthGtNt		:= nil
	local cAccessTok	:= ""

	local cProxyMgf		:= allTrim( superGetMv( "MGFPROXY"		, , "proxy-websense" ) )
	local nProxyPort	:= superGetMv( "MGFPROXPOR"	, , 8080 )

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	/*
	Chaves de Autenticação (Enviada em 24/09/18) *
	Seller ID: 384f0f3e-1f4d-4417-8454-a323f331b89f
	Client ID: 922ed86c-53e7-4e65-9c30-819aa5fbfa16
	Client Secret: e791420a-177f-4e54-86e7-5c5847452b2f
	*/

	cAutorizat := encode64( cClientID + ":" + cClientSec )

	aadd( aHeadOut, 'Content-Type: application/x-www-form-urlencoded')
	aadd( aHeadOut, 'Authorization: Basic ' + cAutorizat )
	aadd( aHeadOut, 'Accept: application/json')

	setProxy( cProxyMgf, nProxyPort )

	cTimeIni := time()

	//xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)
	xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, "scope=oob&grant_type=client_credentials"/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )

	conout(" [E-COM] [GETNET] [AUTHGTNT] * * * * * Status da integracao * * * * *")
	conout(" [E-COM] [GETNET] [AUTHGTNT] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [AUTHGTNT] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [AUTHGTNT] Tempo de Processamento.......: " + cTimeProc )
	conout(" [E-COM] [GETNET] [AUTHGTNT] URL..........................: " + cUrl)
	conout(" [E-COM] [GETNET] [AUTHGTNT] HTTP Method..................: " + "POST" )
	conout(" [E-COM] [GETNET] [AUTHGTNT] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
	conout(" [E-COM] [GETNET] [AUTHGTNT] Retorno......................: " + allTrim( xPostRet ) )
	conout(" [E-COM] [GETNET] [AUTHGTNT] * * * * * * * * * * * * * * * * * * * * ")

	if nStatuHttp >= 200 .and. nStatuHttp <= 299
		oAuthGtNt := nil
		if fwJsonDeserialize( xPostRet, @oAuthGtNt )
			cAccessTok := oAuthGtNt:access_token
		endif
	endif

	varInfo( " [E-COM] [GETNET] [AUTHGTNT] aHeadOut....."		, aHeadOut		)
	varInfo( " [E-COM] [GETNET] [AUTHGTNT] nStatuHttp..."		, nStatuHttp	)
	varInfo( " [E-COM] [GETNET] [AUTHGTNT] xPostRet....."		, xPostRet		)
	varInfo( " [E-COM] [GETNET] [AUTHGTNT] cHeadRet....."		, cHeadRet		)
return cAccessTok

//--------------------------------------------------------------
// Recupera cartao de credito armazenado no cofre
//--------------------------------------------------------------
user function recoCard( cAccessTok, cCardID )
	local cSellerID		:= allTrim( superGetMv( "MGFGTNTSEL" , , "384f0f3e-1f4d-4417-8454-a323f331b89f" ) )
	local cClientID		:= allTrim( superGetMv( "MGFGTNTCLI" , , "922ed86c-53e7-4e65-9c30-819aa5fbfa16" ) )
	local cClientSec	:= allTrim( superGetMv( "MGFGTNTSEC" , , "e791420a-177f-4e54-86e7-5c5847452b2f" ) )
	local cAutorizat	:= ""
	local nTimeOut		:= 120
	local cUrl			:= allTrim( superGetMv( "MGFGTNTCAR" , , "https://api-homologacao.getnet.com.br/v1/cards/{card_id}" ) )
	local aHeadOut		:= {}
	local cHeadRet		:= ""
	local xPostRet		:= ""
	local nStatuHttp	:= 0
	local jCardGtNt		:= nil
	local cJsonRet		:= ""

	local cProxyMgf		:= allTrim( superGetMv( "MGFPROXY"		, , "proxy-websense" ) )
	local nProxyPort	:= superGetMv( "MGFPROXPOR"	, , 8080 )

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	default cCardID		:= ""

	aadd( aHeadOut, 'Authorization: Bearer ' + cAccessTok )
	aadd( aHeadOut, 'seller_id: ' + cSellerID )
	aadd( aHeadOut, 'Accept: application/json')
	aadd( aHeadOut, 'Content-Type: application/json')

	// insere payment id
	cUrl := strTran( cUrl, "{card_id}", cCardID )

	setProxy( cProxyMgf, nProxyPort )

	cTimeIni := time()

	//xPostRet := httpPost(cUrl, , "scope=oob&grant_type=client_credentials",nTimeOut,aHeadOut,@cHeadRet)
	xPostRet := httpQuote( cUrl /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )

	conout(" [E-COM] [GETNET] [RECOCARD] * * * * * Status da integracao * * * * *")
	conout(" [E-COM] [GETNET] [RECOCARD] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [RECOCARD] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [RECOCARD] Tempo de Processamento.......: " + cTimeProc )
	conout(" [E-COM] [GETNET] [RECOCARD] URL..........................: " + cUrl)
	conout(" [E-COM] [GETNET] [RECOCARD] HTTP Method..................: " + "GET" )
	conout(" [E-COM] [GETNET] [RECOCARD] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
	conout(" [E-COM] [GETNET] [RECOCARD] Retorno......................: " + allTrim( xPostRet ) )
	conout(" [E-COM] [GETNET] [RECOCARD] * * * * * * * * * * * * * * * * * * * * ")

	if nStatuHttp >= 200 .and. nStatuHttp <= 299
		jCardGtNt := nil
		if fwJsonDeserialize( xPostRet, @jCardGtNt )
			cJsonRet := xPostRet
			conout( "Cartao recuperado do cofre com titularidade de: " + jCardGtNt:cardholder_name )
		endif
	endif

	varInfo( " [E-COM] [GETNET] [RECOCARD] aHeadOut....."		, aHeadOut		)
	varInfo( " [E-COM] [GETNET] [RECOCARD] nStatuHttp..."		, nStatuHttp	)
	varInfo( " [E-COM] [GETNET] [RECOCARD] xPostRet....."		, xPostRet		)
	varInfo( " [E-COM] [GETNET] [RECOCARD] cHeadRet....."		, cHeadRet		)
return cJsonRet

//--------------------------------------------------------------
// Verifica Cartao
//--------------------------------------------------------------
user function chkCard( cAccessTok, cCardName, cExpiMonth, cExpiYear, cNumberTok, _cretorno )
	local cSellerID		:= allTrim( superGetMv( "MGFGTNTSEL" , , "384f0f3e-1f4d-4417-8454-a323f331b89f" ) )
	local cClientID		:= allTrim( superGetMv( "MGFGTNTCLI" , , "922ed86c-53e7-4e65-9c30-819aa5fbfa16" ) )
	local cClientSec	:= allTrim( superGetMv( "MGFGTNTSEC" , , "e791420a-177f-4e54-86e7-5c5847452b2f" ) )
	local cAutorizat	:= ""
	local nTimeOut		:= 120
	local cUrl			:= allTrim( superGetMv( "MGFGTNTCKC" , , "https://api-homologacao.getnet.com.br/v1/cards/verification" ) )
	local aHeadOut		:= {}
	local cHeadRet		:= ""
	local xPostRet		:= ""
	local nStatuHttp	:= 0
	local jCardGtNt		:= nil
	local jRetCard		:= nil
	local oJson			:= nil
	local cJson			:= nil
	local lRetChkCar	:= .F.
	local aRetChkCar	:= { .F. , "" }

	local cProxyMgf		:= allTrim( superGetMv( "MGFPROXY"		, , "proxy-websense" ) )
	local nProxyPort	:= superGetMv( "MGFPROXPOR"	, , 8080 )

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	Default _cretorno   := ""

	aadd( aHeadOut, 'Authorization: Bearer ' + cAccessTok )
	aadd( aHeadOut, 'seller_id: ' + cSellerID )
	aadd( aHeadOut, 'Content-Type: application/json')

	oJson						:= JsonObject():new()
	oJson['cardholder_name']	:= cCardName
	oJson['expiration_month']	:= padL( cExpiMonth , 2, "0")
	oJson['expiration_year']	:= cExpiYear
	oJson['number_token']		:= cNumberTok

	cJson	:= ""
	cJson	:= oJson:toJson()

	setProxy( cProxyMgf, nProxyPort )

	cTimeIni := time()

	xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	_cretorno := "URL: " + alltrim(cUrl) + CHR(10)+CHR(13)
	_cretorno += "JSON ENVIADO: " + allTrim( cJson ) + CHR(10)+CHR(13)
	_cretorno += "STATUS DO RETORNO: " + alltrim(str(nStatuHttp))  + CHR(10)+CHR(13)
	_cretorno += "JSON RETORNADO: "  + alltrim(xPostRet)

	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )

	conout(" [E-COM] [GETNET] [CHKCARD] * * * * * Status da integracao * * * * *")
	conout(" [E-COM] [GETNET] [CHKCARD] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [CHKCARD] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [CHKCARD] Tempo de Processamento.......: " + cTimeProc )
	conout(" [E-COM] [GETNET] [CHKCARD] URL..........................: " + cUrl)
	conout(" [E-COM] [GETNET] [CHKCARD] HTTP Method..................: " + "POST" )
	conout(" [E-COM] [GETNET] [CHKCARD] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
	conout(" [E-COM] [GETNET] [CHKCARD] Envio........................: " + allTrim( cJson ) )
	conout(" [E-COM] [GETNET] [CHKCARD] Retorno......................: " + allTrim( xPostRet ) )
	conout(" [E-COM] [GETNET] [CHKCARD] * * * * * * * * * * * * * * * * * * * * ")

	if nStatuHttp >= 200 .and. nStatuHttp <= 299
		jCardGtNt := nil
		if fwJsonDeserialize( xPostRet, @jCardGtNt )
			if jCardGtNt:status == "VERIFIED"
				lRetChkCar := .T.
			endif
		endif
	endif

	varInfo( " [E-COM] [GETNET] [CHKCARD] aHeadOut....."		, aHeadOut		)
	varInfo( " [E-COM] [GETNET] [CHKCARD] nStatuHttp..."		, nStatuHttp	)
	varInfo( " [E-COM] [GETNET] [CHKCARD] xPostRet....."		, xPostRet		)
	varInfo( " [E-COM] [GETNET] [CHKCARD] cHeadRet....."		, cHeadRet		)

return lRetChkCar

//--------------------------------------------------------------
// Efetiva transacao
//--------------------------------------------------------------
user function paymGtnt( cAccessTok, cPaymentID, nAmount )
	local cSellerID		:= allTrim( superGetMv( "MGFGTNTSEL" , , "384f0f3e-1f4d-4417-8454-a323f331b89f" ) )
	local cClientID		:= allTrim( superGetMv( "MGFGTNTCLI" , , "922ed86c-53e7-4e65-9c30-819aa5fbfa16" ) )
	local cClientSec	:= allTrim( superGetMv( "MGFGTNTSEC" , , "e791420a-177f-4e54-86e7-5c5847452b2f" ) )
	local cAutorizat	:= ""
	local nTimeOut		:= 120
	local cUrl			:= allTrim( superGetMv( "MGFGTNTPAY" , , "https://api-homologacao.getnet.com.br/v1/payments/credit/{payment_id}/confirm" ) )
	local aHeadOut		:= {}
	local cHeadRet		:= ""
	local xPostRet		:= ""
	local nStatuHttp	:= 0
	local jPayment		:= nil
	local oJson			:= nil
	local cJson			:= ""
	local aRetPaym		:= { .F. , "" }

	local cProxyMgf		:= allTrim( superGetMv( "MGFPROXY"		, , "proxy-websense" ) )
	local nProxyPort	:= superGetMv( "MGFPROXPOR"	, , 8080 )

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	default nAmount		:= 0

	aadd( aHeadOut, 'Authorization: Bearer ' + cAccessTok )
	aadd( aHeadOut, 'Content-Type: application/json')

	if nAmount > 0
		oJson			:= JsonObject():new()
		oJson['amount']	:= nAmount

		cJson			:= ""
		cJson			:= oJson:toJson()
	endif

	// insere payment id
	cUrl := strTran( cUrl, "{payment_id}", cPaymentID )

	setProxy( cProxyMgf, nProxyPort )

	cTimeIni := time()

	if !empty( cJson )
		xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
	else
		xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
	endif

	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	conout(" [E-COM] [GETNET] [PAYMGTNT] * * * * * Status da integracao * * * * *")
	conout(" [E-COM] [GETNET] [PAYMGTNT] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [PAYMGTNT] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [PAYMGTNT] Tempo de Processamento.......: " + cTimeProc )
	conout(" [E-COM] [GETNET] [PAYMGTNT] URL..........................: " + cUrl)
	conout(" [E-COM] [GETNET] [PAYMGTNT] HTTP Method..................: " + "POST" )
	conout(" [E-COM] [GETNET] [PAYMGTNT] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
	conout(" [E-COM] [GETNET] [PAYMGTNT] Envio........................: " + allTrim( cJson ) )
	conout(" [E-COM] [GETNET] [PAYMGTNT] Retorno......................: " + allTrim( xPostRet ) )
	conout(" [E-COM] [GETNET] [PAYMGTNT] * * * * * * * * * * * * * * * * * * * * ")

	if nStatuHttp >= 200 .and. nStatuHttp <= 299
		jPayment := nil
		if fwJsonDeserialize( xPostRet, @jPayment )
			if jPayment:status == "CONFIRMED"
				aRetPaym := { .T. , xPostRet }
			endif
		endif
	endif

	varInfo( " [E-COM] [GETNET] [PAYMGTNT] aHeadOut....."		, aHeadOut		)
	varInfo( " [E-COM] [GETNET] [PAYMGTNT] nStatuHttp..."		, nStatuHttp	)
	varInfo( " [E-COM] [GETNET] [PAYMGTNT] xPostRet....."		, xPostRet		)
	varInfo( " [E-COM] [GETNET] [PAYMGTNT] cHeadRet....."		, cHeadRet		)
return aRetPaym

//--------------------------------------------------------------
// Estorna ou desfaz transações feitas no mesmo dia (D0)
//--------------------------------------------------------------
user function canGtnt0( cAccessTok, cPaymentID, nAmount, cCancelKey )
	local cSellerID		:= allTrim( superGetMv( "MGFGTNTSEL" , , "384f0f3e-1f4d-4417-8454-a323f331b89f" ) )
	local cClientID		:= allTrim( superGetMv( "MGFGTNTCLI" , , "922ed86c-53e7-4e65-9c30-819aa5fbfa16" ) )
	local cClientSec	:= allTrim( superGetMv( "MGFGTNTSEC" , , "e791420a-177f-4e54-86e7-5c5847452b2f" ) )
	local cAutorizat	:= ""
	local nTimeOut		:= 120
	local cUrl			:= allTrim( superGetMv( "MGFGTNCAN2" , , "https://api-homologacao.getnet.com.br/v1/payments/credit/{payment_id}/cancel" ) )
	local aHeadOut		:= {}
	local cHeadRet		:= ""
	local xPostRet		:= ""
	local nStatuHttp	:= 0
	local jPayment		:= nil
	local oJson			:= nil
	local cJson			:= ""
	local aRetPaym		:= { .F. , "" }

	local cProxyMgf		:= allTrim( superGetMv( "MGFPROXY"		, , "proxy-websense" ) )
	local nProxyPort	:= superGetMv( "MGFPROXPOR"				, , 8080 )

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	cUrl := strTran( cUrl, "{payment_id}", cPaymentID )

	aadd( aHeadOut, 'Authorization: Bearer ' + cAccessTok )
	aadd( aHeadOut, 'Content-Type: application/json' )
	aadd( aHeadOut, 'seller_id: ' + cSellerID )

	if nAmount > 0
		oJson						:= JsonObject():new()
		oJson['payment_id']			:= cPaymentID
		oJson['cancel_amount']		:= nAmount
		oJson['cancel_custom_key']	:= cCancelKey

		cJson	:= ""
		cJson	:= oJson:toJson()

		setProxy( cProxyMgf, nProxyPort )

		cTimeIni := time()

		if !empty( cJson )
			xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
		endif

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )

		conout(" [E-COM] [GETNET] [CANGTNT0] * * * * * Status da integracao * * * * *")
		conout(" [E-COM] [GETNET] [CANGTNT0] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
		conout(" [E-COM] [GETNET] [CANGTNT0] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
		conout(" [E-COM] [GETNET] [CANGTNT0] Tempo de Processamento.......: " + cTimeProc )
		conout(" [E-COM] [GETNET] [CANGTNT0] URL..........................: " + cUrl)
		conout(" [E-COM] [GETNET] [CANGTNT0] HTTP Method..................: " + "POST" )
		conout(" [E-COM] [GETNET] [CANGTNT0] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
		conout(" [E-COM] [GETNET] [CANGTNT0] Envio........................: " + allTrim( cJson ) )
		conout(" [E-COM] [GETNET] [CANGTNT0] Retorno......................: " + allTrim( xPostRet ) )
		conout(" [E-COM] [GETNET] [CANGTNT0] * * * * * * * * * * * * * * * * * * * * ")

		if nStatuHttp >= 200 .and. nStatuHttp <= 299
			jPayment := nil
			if fwJsonDeserialize( xPostRet, @jPayment )
				if jPayment:status == "CANCELED"
					aRetPaym := { .T. , xPostRet }
				endif
			endif
		endif

	endif

	varInfo( " [E-COM] [GETNET] [CANGTNT0] aHeadOut....."		, aHeadOut		)
	varInfo( " [E-COM] [GETNET] [CANGTNT0] nStatuHttp..."		, nStatuHttp	)
	varInfo( " [E-COM] [GETNET] [CANGTNT0] xPostRet....."		, xPostRet		)
	varInfo( " [E-COM] [GETNET] [CANGTNT0] cHeadRet....."		, cHeadRet		)
return aRetPaym

//--------------------------------------------------------------
// Cancela transacao - há mais de 1 dia (D+n) - SOLICITACAO
//--------------------------------------------------------------
user function canGtntN( cAccessTok, cPaymentID, nAmount, cCancelKey )
	local cSellerID		:= allTrim( superGetMv( "MGFGTNTSEL" , , "384f0f3e-1f4d-4417-8454-a323f331b89f" ) )
	local cClientID		:= allTrim( superGetMv( "MGFGTNTCLI" , , "922ed86c-53e7-4e65-9c30-819aa5fbfa16" ) )
	local cClientSec	:= allTrim( superGetMv( "MGFGTNTSEC" , , "e791420a-177f-4e54-86e7-5c5847452b2f" ) )
	local cAutorizat	:= ""
	local nTimeOut		:= 120
	local cUrl			:= allTrim( superGetMv( "MGFGTNCAN1" , , "https://api-homologacao.getnet.com.br/v1/payments/cancel/request" ) )
	local aHeadOut		:= {}
	local cHeadRet		:= ""
	local xPostRet		:= ""
	local nStatuHttp	:= 0
	local jPayment		:= nil
	local oJson			:= nil
	local cJson			:= ""
	local aRetPaym		:= { .F. , "" }

	local cProxyMgf		:= allTrim( superGetMv( "MGFPROXY"		, , "proxy-websense" ) )
	local nProxyPort	:= superGetMv( "MGFPROXPOR"				, , 8080 )

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	aadd( aHeadOut, 'Authorization: Bearer ' + cAccessTok )
	aadd( aHeadOut, 'Content-Type: application/json' )
	aadd( aHeadOut, 'seller_id: ' + cSellerID )

	aadd( aHeadOut, 'Accept-Charset: utf-8' )

	if nAmount > 0
		oJson						:= JsonObject():new()
		oJson['payment_id']			:= cPaymentID
		oJson['cancel_amount']		:= nAmount
		oJson['cancel_custom_key']	:= cCancelKey

		cJson	:= ""
		cJson	:= oJson:toJson()

		setProxy( cProxyMgf, nProxyPort )

		cTimeIni := time()

		if !empty( cJson )
			xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
		endif

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )
	
		conout(" [E-COM] [GETNET] [CANGTNTN] * * * * * Status da integracao * * * * *")
		conout(" [E-COM] [GETNET] [CANGTNTN] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
		conout(" [E-COM] [GETNET] [CANGTNTN] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
		conout(" [E-COM] [GETNET] [CANGTNTN] Tempo de Processamento.......: " + cTimeProc )
		conout(" [E-COM] [GETNET] [CANGTNTN] URL..........................: " + cUrl)
		conout(" [E-COM] [GETNET] [CANGTNTN] HTTP Method..................: " + "POST" )
		conout(" [E-COM] [GETNET] [CANGTNTN] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
		conout(" [E-COM] [GETNET] [CANGTNTN] cJson........................: " + allTrim( cJson ) )
		conout(" [E-COM] [GETNET] [CANGTNTN] Retorno......................: " + allTrim( xPostRet ) )
		conout(" [E-COM] [GETNET] [CANGTNTN] * * * * * * * * * * * * * * * * * * * * ")

		if nStatuHttp >= 200 .and. nStatuHttp <= 299
			/*jPayment := nil
			if fwJsonDeserialize( xPostRet, @jPayment )
				if jPayment:status == "ACCEPTED"
					aRetPaym := { .T. , xPostRet }
				endif
			endif*/
			aRetPaym := { .T. , xPostRet }
		endif
	endif

	varInfo( " [E-COM] [GETNET] [CANGTNTN] aHeadOut....."		, aHeadOut		)
	varInfo( " [E-COM] [GETNET] [CANGTNTN] nStatuHttp..."		, nStatuHttp	)
	varInfo( " [E-COM] [GETNET] [CANGTNTN] xPostRet....."		, xPostRet		)
	varInfo( " [E-COM] [GETNET] [CANGTNTN] cHeadRet....."		, cHeadRet		)
return aRetPaym

//--------------------------------------------------------------
// Cancela transacao - há mais de 1 dia (D+n) - SOLICITACAO
//--------------------------------------------------------------
user function retCanGt( cAccessTok, cReqCancID )
	local cSellerID		:= allTrim( superGetMv( "MGFGTNTSEL" , , "384f0f3e-1f4d-4417-8454-a323f331b89f" ) )
	local cClientID		:= allTrim( superGetMv( "MGFGTNTCLI" , , "922ed86c-53e7-4e65-9c30-819aa5fbfa16" ) )
	local cClientSec	:= allTrim( superGetMv( "MGFGTNTSEC" , , "e791420a-177f-4e54-86e7-5c5847452b2f" ) )
	local cAutorizat	:= ""
	local nTimeOut		:= 120
	local cUrl			:= allTrim( superGetMv( "MGFGTNRETC" , , "https://api-homologacao.getnet.com.br/v1/payments/cancel/request/{cancel_request_id}" ) )
	local aHeadOut		:= {}
	local cHeadRet		:= ""
	local xPostRet		:= ""
	local nStatuHttp	:= 0
	local jCancel		:= nil
	local aRetPaym		:= { .F. , "" }

	local cProxyMgf		:= allTrim( superGetMv( "MGFPROXY"		, , "proxy-websense" ) )
	local nProxyPort	:= superGetMv( "MGFPROXPOR"				, , 8080 )

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	aadd( aHeadOut, 'Authorization: Bearer ' + cAccessTok )
	aadd( aHeadOut, 'Content-Type: application/json' )
	aadd( aHeadOut, 'seller_id: ' + cSellerID )

	// insere cancel_request_id
	cUrl := strTran( cUrl, "{cancel_request_id}", cReqCancID )

	setProxy( cProxyMgf, nProxyPort )

	cTimeIni := time()

	xPostRet := httpQuote( cUrl /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )

	conout(" [E-COM] [GETNET] [RETCANGT] * * * * * Status da integracao * * * * *")
	conout(" [E-COM] [GETNET] [RETCANGT] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [RETCANGT] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [RETCANGT] Tempo de Processamento.......: " + cTimeProc )
	conout(" [E-COM] [GETNET] [RETCANGT] URL..........................: " + cUrl)
	conout(" [E-COM] [GETNET] [RETCANGT] HTTP Method..................: " + "GET" )
	conout(" [E-COM] [GETNET] [RETCANGT] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
	conout(" [E-COM] [GETNET] [RETCANGT] Retorno......................: " + allTrim( xPostRet ) )
	conout(" [E-COM] [GETNET] [RETCANGT] * * * * * * * * * * * * * * * * * * * * ")

	if nStatuHttp >= 200 .and. nStatuHttp <= 299
		jCancel := nil
		if fwJsonDeserialize( xPostRet, @jCancel )
			if jCancel:status_processing_cancel_code == "100"
				aRetPaym := { .T. , xPostRet }
			endif
		endif
	endif

	varInfo( " [E-COM] [GETNET] [RETCANGT] aHeadOut....."		, aHeadOut		)
	varInfo( " [E-COM] [GETNET] [RETCANGT] nStatuHttp..."		, nStatuHttp	)
	varInfo( " [E-COM] [GETNET] [RETCANGT] xPostRet....."		, xPostRet		)
	varInfo( " [E-COM] [GETNET] [RETCANGT] cHeadRet....."		, cHeadRet		)
return aRetPaym

//--------------------------------------------------------------
// Consulta solicitacao de cancelamento - há mais de 1 dia (D+n)
//--------------------------------------------------------------
user function retCanPV( cAccessTok, cReqCancID )
	local cSellerID		:= allTrim( superGetMv( "MGFGTNTSEL" , , "384f0f3e-1f4d-4417-8454-a323f331b89f" ) )
	local cClientID		:= allTrim( superGetMv( "MGFGTNTCLI" , , "922ed86c-53e7-4e65-9c30-819aa5fbfa16" ) )
	local cClientSec	:= allTrim( superGetMv( "MGFGTNTSEC" , , "e791420a-177f-4e54-86e7-5c5847452b2f" ) )
	local cAutorizat	:= ""
	local nTimeOut		:= 120
	local cUrl			:= allTrim( superGetMv( "MGFGTNRETP" , , "https://api-homologacao.getnet.com.br/v1/payments/cancel/request/?cancel_custom_key={cancel_custom_key}" ) )
	local aHeadOut		:= {}
	local cHeadRet		:= ""
	local xPostRet		:= ""
	local nStatuHttp	:= 0
	local jCancel		:= nil
	local aRetPaym		:= { .F. , "" }

	local cProxyMgf		:= allTrim( superGetMv( "MGFPROXY"		, , "proxy-websense" ) )
	local nProxyPort	:= superGetMv( "MGFPROXPOR"				, , 8080 )

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	aadd( aHeadOut, 'Authorization: Bearer ' + cAccessTok )
	aadd( aHeadOut, 'Content-Type: application/json' )
	aadd( aHeadOut, 'seller_id: ' + cSellerID )

	// insere cancel_request_id
	cUrl := strTran( cUrl, "{cancel_custom_key}", cReqCancID )

	setProxy( cProxyMgf, nProxyPort )

	cTimeIni := time()

	xPostRet := httpQuote( cUrl /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )

	nStatuHttp	:= 0
	nStatuHttp	:= httpGetStatus()

	cTimeFin	:= time()
	cTimeProc	:= elapTime( cTimeIni, cTimeFin )

	conout(" [E-COM] [GETNET] [retCanPV] * * * * * Status da integracao * * * * *")
	conout(" [E-COM] [GETNET] [retCanPV] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [retCanPV] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
	conout(" [E-COM] [GETNET] [retCanPV] Tempo de Processamento.......: " + cTimeProc )
	conout(" [E-COM] [GETNET] [retCanPV] URL..........................: " + cUrl)
	conout(" [E-COM] [GETNET] [retCanPV] HTTP Method..................: " + "GET" )
	conout(" [E-COM] [GETNET] [retCanPV] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
	conout(" [E-COM] [GETNET] [retCanPV] Retorno......................: " + allTrim( xPostRet ) )
	conout(" [E-COM] [GETNET] [retCanPV] * * * * * * * * * * * * * * * * * * * * ")

	if nStatuHttp >= 200 .and. nStatuHttp <= 299
		jCancel := nil
		if fwJsonDeserialize( xPostRet, @jCancel )
			if jCancel:status_processing_cancel_code == "100"
				aRetPaym := { .T. , xPostRet }
			endif
		endif
	endif

	varInfo( " [E-COM] [GETNET] [retCanPV] aHeadOut....."		, aHeadOut		)
	varInfo( " [E-COM] [GETNET] [retCanPV] nStatuHttp..."		, nStatuHttp	)
	varInfo( " [E-COM] [GETNET] [retCanPV] xPostRet....."		, xPostRet		)
	varInfo( " [E-COM] [GETNET] [retCanPV] cHeadRet....."		, cHeadRet		)
return aRetPaym
