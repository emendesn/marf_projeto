#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/
=============================================================================
{Protheus.doc} MGFWSC31
Integração de Limites de crédito - E-commerce
@author
Josué Danich
@since
10/03/2020
*/
user function MGFWSC31( )

	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'
	u_mfconout("Iniciando integração de limite de crédito de clientes com o E-Commerce...")
	
	u_MWSC31I()

	u_mfconout("Completada integração de limite de crédito de clientes com o E-Commerce...")

	RESET ENVIRONMENT

return

//-------------------------------------------------------------------
User function MWSC31I( cCGC )

	local cURLInteg		:= allTrim( superGetMv( "MGFECOM31A" , , "http://spdwvapl203:8205/protheuscliente/api/clientes/" ) )
	local cURLUse		:= ""
	local oInteg		:= nil
	local cUpdTbl		:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 600
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	Local _ntot			:= 0
	Local cCliente		:= ""
	Local cLoja			:= ""
	Local _nni			:= 1
	local _aCodSA1		:= {}
	private oJson		:= nil

	default cCGC		:= ""

	If !Empty(cCGC)
		 _aCodSA1 := chkSA1(cCGC)
		 cCliente := _aCodSA1[1]
		 cLoja 	  := _aCodSA1[2]
	EndIf

	u_mfconout("Carregando clientes para integração de limite de crédito...")

	MGFWSC31Q( cCliente,cLoja ) //Carrega clientes para exportação de limite de crédito

	u_mfconout("Contando clientes para integrar...")

	aadd( aHeadStr, 'Content-Type: application/json')

	Do while !QWSC31->(EOF())
		_ntot++
		QWSC31->(Dbskip())
	Enddo

	QWSC31->(Dbgotop())

	while !QWSC31->(EOF())


		u_mfconout("Integrando limite de crédito do cliente " + alltrim(QWSC31->A1_NOME) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")
		_nni++
		
		oJson := nil
		oJson := JsonObject():new()

		MGFWSC31O() // Carrega dados no objeto de integraçãop

		cURLUse	:= ""
		cURLUse	:= cURLInteg + allTrim( QWSC31->A1_ZCDECOM ) + "/atualizaLimiteCredito"

		cJson	:= ""
		cJson	:= oJson:toJson()

		if !empty( cJson )
			cTimeIni	:= time()
			cHeaderRet	:= ""
			//cHttpRet	:= httpQuote( cURLUse /*<cUrl>*/, "PUT" /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			httpQuote( cURLUse /*<cUrl>*/, "PUT" /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime(cTimeIni, cTimeFin)

			nStatuHttp := 0
			nStatuHttp := httpGetStatus()

			conout(" [E-COM] [MGFWSC31] * * * * * Status da integracao * * * * *")
			conout(" [E-COM] [MGFWSC31] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC31] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC31] Tempo de Processamento.......: " + cTimeProc)
			conout(" [E-COM] [MGFWSC31] URL..........................: " + cURLUse)
			conout(" [E-COM] [MGFWSC31] HTTP Method..................: " + "PUT")
			conout(" [E-COM] [MGFWSC31] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [E-COM] [MGFWSC31] Envio........................: " + cJson)
			conout(" [E-COM] [MGFWSC31] * * * * * * * * * * * * * * * * * * * * ")

		endif

		freeObj( oJson )

		QWSC31->(DBSkip())
	enddo

	QWSC31->(DBCloseArea())

	delClassINTF()
return

/*/
=============================================================================
{Protheus.doc} MGFWSC31Q
Carrega clientes para exportação de limite de crédito
@author
Josué Danich
@since
10/03/2020
*/
static function MGFWSC31Q( cCliente,cLoja )
	local cQWSC31 := ""

	cQWSC31 := "SELECT "									+ CRLF
	cQWSC31 += "     A1_NOME, "								+ CRLF
	cQWSC31 += "     A1_ZCDEREQ, "							+ CRLF
	cQWSC31 += "     A1_ZCDECOM, "							+ CRLF
	cQWSC31 += "     A1_VENCLC, "							+ CRLF
	cQWSC31 += "     A1_LCFIN, "							+ CRLF
	cQWSC31 += "     A1_MSALDO, "							+ CRLF
	cQWSC31 += "     A1_MCOMPRA, "							+ CRLF
	cQWSC31 += "     A1_ULTCOM, "							+ CRLF
	cQWSC31 += "     TITULOS_ATRASADOS A1_ATR, "			+ CRLF
	cQWSC31 += "     TOTAL_PEDIDOS A1_SALPED, "				+ CRLF
	cQWSC31 += "     LIMITE_DISPONIVEL A1_LC "				+ CRLF
	cQWSC31 += " FROM "	+ retSQLName("SA1") + " SA1 "		+ CRLF
	cQWSC31 += " INNER JOIN V_LIMITES_CLIENTE VSA1 "		+ CRLF
	cQWSC31 += " ON VSA1.RECNO_CLIENTE = SA1.R_E_C_N_O_ " 	+ CRLF
	cQWSC31 += " WHERE SA1.D_E_L_E_T_ = ' ' "				+ CRLF
	cQWSC31 += " AND (SA1.A1_ZCDECOM <> ' ' or SA1.A1_ZCDEREQ <> ' ' ) "				+ CRLF

	If !empty(cCliente)
		cQWSC31 += " AND SA1.A1_COD = '" + cCliente + "' "	+ CRLF
	Endif

	If !empty(cLoja)
		cQWSC31 += " AND SA1.A1_LOJA = '" + cLoja + "' "	+ CRLF
	Endif

	tcQuery cQWSC31 New Alias "QWSC31"

return

/*/
=============================================================================
{Protheus.doc} MGFWSC31O
Carrega dados do cliente no objeto de integração
@author
Josué Danich
@since
10/03/2020
*/
static function MGFWSC31O()

	oJson['a1lc']		:= QWSC31->A1_LC
	oJson['a1venlc']	:= U_xPdrDt(allTrim( QWSC31->A1_VENCLC))
	oJson['a1lcfin']	:= QWSC31->A1_LCFIN
	oJson['a1msaldo']	:= QWSC31->A1_MSALDO
	oJson['a1mcompra']	:= QWSC31->A1_MCOMPRA
	oJson['a1ultcom']	:= U_xPdrDt(allTrim( QWSC31->A1_ULTCOM ))
	oJson['a1atr']		:= QWSC31->A1_ATR
	oJson['a1salped']	:= QWSC31->A1_SALPED

return

User Function xPdrDt(cDataS)

	Local cRet := ""

	cRet := Substr(cDataS,1,4) + "-" + Substr(cDataS,5,2) + "-" + Substr(cDataS,7,2)

	If cret = "--"
		cret := ""
	Endif

return cRet

static function chkSA1( cA1CNPJ )
	local cQWSC31	:= ""
	local aRetSA1	:= {}
	local aArea		:= getArea()

	cQWSC31 := "SELECT A1_COD, A1_LOJA, A1_ZCDECOM, A1_ZCDEREQ, A1_TIPO, A1_PESSOA, A1_MSBLQL"	+ CRLF
	cQWSC31 += " FROM " + retSQLName("SA1") + " SA1"					+ CRLF
	cQWSC31 += " WHERE"													+ CRLF
	cQWSC31 += " 		SA1.A1_CGC		=	'" + cA1CNPJ		+ "'"	+ CRLF
	cQWSC31 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1")	+ "'"	+ CRLF
	cQWSC31 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"						+ CRLF

	TcQuery cQWSC31 New Alias "QWSC31"

	if !QWSC31->( EOF() )
					//		 1				 2				  3				  	  4					  5				   6				  7	
		aRetSA1 := { QWSC31->A1_COD, QWSC31->A1_LOJA, QWSC31->A1_ZCDECOM, QWSC31->A1_TIPO, QWSC31->A1_PESSOA, QWSC31->A1_MSBLQL, QWSC31->A1_ZCDEREQ }
	endif

	QWSC31->(DBCloseArea())

	restArea( aArea )
return aRetSA1