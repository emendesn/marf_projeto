#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/
=============================================================================
{Protheus.doc} MGFWSC25
Integração de Clientes - E-commerce
@author
Josué Danich
@since
10/03/2020
*/
user function MGFWSC25()

	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'
	u_mfconout("Iniciando integração de clientes com o E-Commerce...")
	
	u_MWSC25I()

	u_mfconout("Completada integração de clientes com o E-Commerce...")

	RESET ENVIRONMENT

return

/*/
=============================================================================
{Protheus.doc} MWSC25I
Execução da integração de clientes
@author
Josué Danich
@since
10/03/2020
*/
User function MWSC25I( cCnpjCli )
	local cURLInteg		:= allTrim( superGetMv( "MGFECOM25A" , , "http://spdwvapl219:8205/protheuscliente/api/clientes/" ) )
	local cURLUse		:= ""
	local cURLUse1		:= ""
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
	Local _ntot         := 0
	Local _nni          := 1

	private oJson		:= nil

	default cCnpjCli	:= ""

	u_mfconout("Carregando clientes para integrar...")

	MGFWSC25Q( cCnpjCli )

	u_mfconout("Contando clientes para integrar...")

	Do while !QWSC25->(EOF())
		_ntot++
		QWSC25->(Dbskip())
	Enddo

	QWSC25->(Dbgotop())

	aadd( aHeadStr, 'Content-Type: application/json')

	while !QWSC25->(EOF())

		u_mfconout("Integrando cliente " + alltrim(QWSC25->A1_NOME) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")
		_nni++

		oJson := nil
		oJson := JsonObject():new()

		MGFWSC25C() // Carrega dados do cliente no objeto

		cURLUse	:= ""
		cURLUse	:= cURLInteg + allTrim( QWSC25->A1_ZCDECOM) //A1_ZCDECOM )

		cJson	:= ""
		cJson	:= oJson:toJson()

		if !empty( cJson )
			cTimeIni	:= time()
			cHeaderRet	:= ""
			httpQuote( cURLUse /*<cUrl>*/, "PUT" /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
			cTimeFin	:= time()
			cTimeProc	:= elapTime(cTimeIni, cTimeFin)

			nStatuHttp := 0
			nStatuHttp := httpGetStatus()

			conout(" [E-COM] [MGFWSC25] * * * * * Status da integracao * * * * *")
			conout(" [E-COM] [MGFWSC25] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC25] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC25] Tempo de Processamento.......: " + cTimeProc)
			conout(" [E-COM] [MGFWSC25] URL..........................: " + cURLUse)
			conout(" [E-COM] [MGFWSC25] HTTP Method..................: " + "PUT")
			conout(" [E-COM] [MGFWSC25] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [E-COM] [MGFWSC25] Envio........................: " + cJson)
			conout(" [E-COM] [MGFWSC25] * * * * * * * * * * * * * * * * * * * * ")

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				cUpdTbl	:= ""

				cUpdTbl := "UPDATE " + retSQLName("SA1")										+ CRLF
				cUpdTbl += "	SET"															+ CRLF
				cUpdTbl += " 		A1_XINTECO = '1',"											+ CRLF
				cUpdTbl += " 		A1_ZSTATEC = '1'"											+ CRLF
				cUpdTbl += " WHERE"																+ CRLF
				cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( QWSC25->SA1RECNO ) ) + ""	+ CRLF

				if tcSQLExec( cUpdTbl ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif
			endif

		endif

		freeObj( oJson )

		QWSC25->(DBSkip())
	enddo

	QWSC25->(DBCloseArea())

	delClassINTF()
return

/*/
=============================================================================
{Protheus.doc} MGFWSC25Q
Query de carga de clientes
@author
Josué Danich
@since
10/03/2020
*/
static function MGFWSC25Q( cCnpjCli )

	local cQWSC25 := ""

	cQWSC25 := "SELECT"							+ CRLF
	cQWSC25 += " A1_ZINATIV	,"					+ CRLF
	cQWSC25 += " SA1.R_E_C_N_O_ SA1RECNO	,"	+ CRLF
	cQWSC25 += " A1_ZCDECOM	,"					+ CRLF
	cQWSC25 += " A1_ZCDEREQ ,"					+ CRLF
	cQWSC25 += " U5_CONTAT	,"					+ CRLF
	cQWSC25 += " U5_DDD		,"					+ CRLF
	cQWSC25 += " A1_ZPRCECO ,"					+ CRLF
	cQWSC25 += " U5_FCOM2	,"					+ CRLF
	cQWSC25 += " U5_CELULAR	,"					+ CRLF
	cQWSC25 += " A1_ZECOMME ,"     				+ CRLF
	cQWSC25 += " U5_EMAIL	,"					+ CRLF
	cQWSC25 += " A1_COD		,"					+ CRLF
	cQWSC25 += " A1_LOJA	,"					+ CRLF
	cQWSC25 += " A1_TIPO	,"					+ CRLF
	cQWSC25 += " A1_PESSOA	,"					+ CRLF
	cQWSC25 += " A1_NOME	,"					+ CRLF
	cQWSC25 += " A1_NREDUZ	,"					+ CRLF
	cQWSC25 += " A1_CGC		,"					+ CRLF
	cQWSC25 += " A1_INSCR	,"					+ CRLF
	cQWSC25 += " A1_CEP		,"					+ CRLF
	cQWSC25 += " A1_END		,"					+ CRLF
	cQWSC25 += " A1_COMPLEM	,"					+ CRLF
	cQWSC25 += " A1_EST		,"					+ CRLF
	cQWSC25 += " A1_ESTADO	,"					+ CRLF
	cQWSC25 += " A1_COD_MUN	,"					+ CRLF
	cQWSC25 += " A1_MUN		,"					+ CRLF
	cQWSC25 += " A1_DDD		,"					+ CRLF
	cQWSC25 += " A1_BAIRRO	,"					+ CRLF
	cQWSC25 += " A1_DDI		,"					+ CRLF
	cQWSC25 += " A1_NATUREZ	,"					+ CRLF
	cQWSC25 += " A1_ENDENT	,"					+ CRLF
	cQWSC25 += " A1_TEL		,"					+ CRLF
	cQWSC25 += " A1_PAIS	,"					+ CRLF
	cQWSC25 += " A1_VEND	,"					+ CRLF
	cQWSC25 += " A1_CNAE	,"					+ CRLF
	cQWSC25 += " A1_CONTA	,"					+ CRLF
	cQWSC25 += " A1_TPFRET	,"					+ CRLF
	cQWSC25 += " A1_COND	,"					+ CRLF
	cQWSC25 += " A1_LC		,"					+ CRLF
	cQWSC25 += " A1_VENCLC	,"					+ CRLF
	cQWSC25 += " A1_LCFIN	,"					+ CRLF
	cQWSC25 += " A1_MSALDO	,"					+ CRLF
	cQWSC25 += " A1_MCOMPRA	,"					+ CRLF
	cQWSC25 += " A1_ULTCOM	,"					+ CRLF
	cQWSC25 += " A1_ATR		,"					+ CRLF
	cQWSC25 += " A1_SALPED	,"					+ CRLF
	cQWSC25 += " A1_TABELA	,"					+ CRLF
	cQWSC25 += " A1_DTNASC	,"					+ CRLF
	cQWSC25 += " A1_GRPTRIB	,"					+ CRLF
	cQWSC25 += " A1_BAIRROE	,"					+ CRLF
	cQWSC25 += " A1_CEPE	,"					+ CRLF
	cQWSC25 += " A1_MUNE	,"					+ CRLF
	cQWSC25 += " A1_ESTE	,"					+ CRLF
	cQWSC25 += " A1_CODPAIS	,"					+ CRLF
	cQWSC25 += " A1_TPESSOA	,"					+ CRLF
	cQWSC25 += " A1_TIPCLI	,"					+ CRLF
	cQWSC25 += " A1_EMAIL	,"					+ CRLF
	cQWSC25 += " A1_MSBLQL	,"					+ CRLF
	cQWSC25 += " SZP.ZP_CENTDIS	,"					+ CRLF
	cQWSC25 += " A1_SIMPNAC	,"					+ CRLF
	cQWSC25 += " A1_XSFA	,"					+ CRLF
	cQWSC25 += " A1_ZCROAD	,"					+ CRLF
	cQWSC25 += " A1_ZITROAD	,"					+ CRLF
	cQWSC25 += " A1_ZALTROA	,"					+ CRLF
	cQWSC25 += " ZAP.ZAP_CODREG A1_ZREGIAO	,"					+ CRLF

	cQWSC25 += " A1_DSCREG	,"					+ CRLF
	cQWSC25 += " A1_ZREDE	,"					+ CRLF
	cQWSC25 += " AOV_DESSEG	,"					+ CRLF
	cQWSC25 += " A1_ZBOLETO	,"					+ CRLF
	cQWSC25 += " A1_ZCDMGCO	,"					+ CRLF
	cQWSC25 += " A1_XSFAX	,"					+ CRLF
	cQWSC25 += " ZBI_DIRETO	,"					+ CRLF
	cQWSC25 += " ZBI_REGION	,"					+ CRLF
	cQWSC25 += " A1_ZSTATEC ,"					+ CRLF
	cQWSC25 += " A3_EMAIL	"					+ CRLF

	cQWSC25 += " FROM "			+ retSQLName("SA1") + " SA1"					+ CRLF

	cQWSC25 += " LEFT JOIN "	+ retSQLName("AC8") + " AC8"					+ CRLF
	cQWSC25 += " ON"															+ CRLF
	cQWSC25 += " 		AC8.AC8_ENTIDA	=	'SA1'"								+ CRLF
	cQWSC25 += " 	AND	AC8.AC8_CODENT	=	A1_COD || A1_LOJA"					+ CRLF
	cQWSC25 += " 	AND	AC8.AC8_FILIAL	=	'" + xFilial("AC8") + "'"			+ CRLF
	cQWSC25 += " 	AND	AC8.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQWSC25 += " LEFT JOIN "	+ retSQLName("SU5") + " SU5"					+ CRLF
	cQWSC25 += " ON"															+ CRLF
	cQWSC25 += " 		SU5.U5_CODCONT	=	AC8.AC8_CODCON"						+ CRLF
	cQWSC25 += " 	AND	SU5.U5_LOJA		=	SA1.A1_LOJA"						+ CRLF
	cQWSC25 += " 	AND	SU5.U5_FILIAL	=	'" + xFilial("SU5") + "'"			+ CRLF
	cQWSC25 += " 	AND	SU5.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQWSC25 += " LEFT JOIN ZAP010 ZAP "
	cQWSC25 += " ON "
	cQWSC25 += " 	ZAP.ZAP_UF = SA1.A1_EST "
	cQWSC25 += " 	AND ZAP.ZAP_CODMUN = SA1.A1_COD_MUN " 
	cQWSC25 += " 	AND ZAP.ZAP_FILIAL = '      ' "
	cQWSC25 += " 	AND ZAP.D_E_L_E_T_ <> '*' "

 	cQWSC25 += " LEFT JOIN SZP010 SZP "
	cQWSC25 += " ON "
	cQWSC25 += " 	SZP.ZP_CODREG = ZAP.ZAP_CODREG "
	cQWSC25 += " 	AND SZP.ZP_FILIAL = '      ' "
	cQWSC25 += " 	AND SZP.D_E_L_E_T_ <> '*' "

	cQWSC25 += " LEFT JOIN "	+ retSQLName("ZBI") + " ZBI"					+ CRLF
	cQWSC25 += " ON"															+ CRLF
	cQWSC25 += " 		ZBI.ZBI_REPRES	=	SA1.A1_VEND"						+ CRLF
	cQWSC25 += " 	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI") + "'"			+ CRLF
	cQWSC25 += " 	AND	ZBI.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQWSC25 += " LEFT JOIN "	+ retSQLName("AOV") + " AOV"					+ CRLF
	cQWSC25 += " ON"															+ CRLF
	cQWSC25 += " 		AOV.AOV_CODSEG	=	SA1.A1_CODSEG"						+ CRLF
	cQWSC25 += " 	AND	AOV.AOV_FILIAL	=	'" + xFilial("AOV") + "'"			+ CRLF
	cQWSC25 += " 	AND	AOV.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQWSC25 += " LEFT JOIN "	+ retSQLName("SA3") + " SA3"					+ CRLF
	cQWSC25 += " ON"															+ CRLF
	cQWSC25 += " 		SA3.A3_COD		=	SA1.A1_VEND"						+ CRLF
	cQWSC25 += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'"			+ CRLF
	cQWSC25 += " 	AND	SA3.D_E_L_E_T_	<>	'*'"								+ CRLF

	cQWSC25 += " WHERE"															+ CRLF
	cQWSC25 += " 		SA1.A1_XENVECO	=	'1'"								+ CRLF // Envia E-Commerce		-> 0=Nao;1=Sim
	cQWSC25 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"			+ CRLF
	cQWSC25 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQWSC25 += " 	AND A1_ZCDEREQ <> ' '"										+ CRLF
	cQWSC25 += " 	AND A1_COD <> '000095' AND A1_PESSOA = 'J' "				+ CRLF

	if !empty( cCnpjCli )
		cQWSC25 += " 	AND	SA1.A1_CGC = '" + cCnpjCli + "'"					+ CRLF
	endif

	cQWSC25 += " ORDER BY A1_COD, A1_LOJA"										+ CRLF

	tcQuery cQWSC25 New Alias "QWSC25"
return

/*/
=============================================================================
{Protheus.doc} MGFWSC25Q
Carrega dados do cliente no objeto
@author
Josué Danich
@since
10/03/2020
*/
static function MGFWSC25C()


	oJson['u5contat']	:= allTrim( QWSC25->U5_CONTAT )
	oJson['u5ddd']		:= allTrim( QWSC25->U5_DDD )
	oJson['u5fcom2']	:= allTrim( QWSC25->U5_FCOM2 )
	oJson['u5celular']	:= allTrim( QWSC25->U5_CELULAR )
	oJson['u5email']	:= allTrim( QWSC25->U5_EMAIL )
	oJson['a1cod']		:= allTrim( QWSC25->A1_COD )
	oJson['a1loja']		:= allTrim( QWSC25->A1_LOJA )
	oJson['a1tipo']		:= nil
	oJson['a1pessoa']	:= allTrim( QWSC25->A1_PESSOA )
	oJson['a1nome']		:= allTrim( QWSC25->A1_NOME ) + " " + allTrim( QWSC25->A1_COD ) + allTrim( QWSC25->A1_LOJA )
	oJson['a1nreduz']	:= allTrim( QWSC25->A1_NREDUZ )
	oJson['a1cgc']		:= allTrim( QWSC25->A1_CGC )
	oJson['a1inscr']	:= allTrim( QWSC25->A1_INSCR )
	oJson['a1cep']		:= allTrim( QWSC25->A1_CEP )
	oJson['a1end']		:= allTrim( QWSC25->A1_END )
	oJson['a1complem']	:= allTrim( QWSC25->A1_COMPLEM )
	oJson['a1est']		:= allTrim( QWSC25->A1_EST )
	oJson['a1estado']	:= allTrim( QWSC25->A1_ESTADO )
	oJson['a1cod_mun']	:= allTrim( QWSC25->A1_COD_MUN )
	oJson['a1mun']		:= allTrim( QWSC25->A1_MUN )
	oJson['a1ddd']		:= allTrim( QWSC25->A1_DDD )
	oJson['a1bairro']	:= allTrim( QWSC25->A1_BAIRRO )
	oJson['a1ddi']		:= allTrim( QWSC25->A1_DDI )
	oJson['a1naturez']	:= allTrim( QWSC25->A1_NATUREZ )
	oJson['a1endent']	:= allTrim( QWSC25->A1_ENDENT )
	oJson['a1tel']		:= allTrim( QWSC25->A1_TEL )
	oJson['a1pais']		:= "BR"
	oJson['a1vend']		:= allTrim( QWSC25->A1_VEND )
	oJson['a3nome']		:= MGFWSC25V(allTrim( QWSC25->A1_VEND ))
	oJson['a1cnae']		:= allTrim( QWSC25->A1_CNAE )
	oJson['a1conta']	:= allTrim( QWSC25->A1_CONTA )
	oJson['a1tpfret']	:= allTrim( QWSC25->A1_TPFRET )
	oJson['a1cond']		:= MGFWSC25D(QWSC25->A1_COND)//allTrim( QWSC25->A1_COND )
	oJson['a1lc']		:= 0//QWSC25->A1_LC
	oJson['a1venclc']	:= nil//allTrim( QWSC25->A1_VENCLC )
	oJson['a1lcfin']	:= 0//QWSC25->A1_LCFIN
	oJson['a1msaldo']	:= 0//QWSC25->A1_MSALDO
	oJson['a1mcompra']	:= 0//QWSC25->A1_MCOMPRA
	oJson['a1ultcom']	:= nil//allTrim( QWSC25->A1_ULTCOM )
	oJson['a1atr']		:= 0//QWSC25->A1_ATR
	oJson['a1salped']	:= 0//QWSC25->A1_SALPED
	oJson['a1tabela']	:= allTrim( QWSC25->A1_ZPRCECO )
	oJson['a1dtnasc']	:= allTrim( QWSC25->A1_DTNASC )
	oJson['a1grptrib']	:= allTrim( QWSC25->A1_GRPTRIB )
	oJson['a1bairroe']	:= allTrim( QWSC25->A1_BAIRROE )
	oJson['a1cepe']		:= allTrim( QWSC25->A1_CEPE )
	oJson['a1mune']		:= allTrim( QWSC25->A1_MUNE )
	oJson['a1este']		:= allTrim( QWSC25->A1_ESTE )
	oJson['a1codpais']	:= allTrim( QWSC25->A1_CODPAIS )
	oJson['a1tpessoa']	:= allTrim( QWSC25->A1_TPESSOA )
	oJson['a1tipcli']	:= nil
	oJson['a1email']	:= allTrim( QWSC25->A1_EMAIL )
	oJson['a1msblql']	:= ( QWSC25->A1_MSBLQL == "1" ) //1=Inativo;2=Ativo
	oJson['a1loccons']	:= allTrim( QWSC25->ZP_CENTDIS )
	oJson['a1simpnac']	:= allTrim( QWSC25->A1_SIMPNAC )
	oJson['a1xsfa']		:= allTrim( QWSC25->A1_XSFA )
	oJson['a1zcroad']	:= allTrim( QWSC25->A1_ZCROAD )
	oJson['a1zitroad']	:= allTrim( QWSC25->A1_ZITROAD )
	oJson['a1zaltroa']	:= allTrim( QWSC25->A1_ZALTROA )
	oJson['a1zregiao']	:= allTrim( QWSC25->A1_ZREGIAO )
	oJson['a1dscreg']	:= allTrim( QWSC25->A1_DSCREG )
	oJson['a1zrede']	:= allTrim( QWSC25->A1_ZREDE )
	oJson['a1zboleto']	:= allTrim( QWSC25->A1_ZBOLETO )
	oJson['a1zcdmgco']	:= allTrim( QWSC25->A1_ZCDMGCO )
	oJson['a1xsfax']	:= allTrim( QWSC25->A1_XSFAX )
	oJson['a3email']	:= allTrim( QWSC25->A3_EMAIL )
	oJson['zbidireto']	:= allTrim( QWSC25->ZBI_DIRETO )
	oJson['zbiregion']	:= allTrim( QWSC25->ZBI_REGION )
	oJson['aovdesseg']	:= allTrim( QWSC25->AOV_DESSEG )
	oJson['a1zcdereq']	:= allTrim( QWSC25->A1_ZCDEREQ )

	_nreembolso := MGFWSC25R() // busca saldo de NCC menos pedido de vendas

	if ( _nreembolso ) > 0
		oJson['reembolso']	:= ( _nreembolso )
	else
		oJson['reembolso']	:= 0
	endif

	/*
	Aprovação e reprovação são enviados apenas uma vez
	*/
	cStatuCust := ""
	cStatuCust := MGFWSC25S( QWSC25->A1_ZCDEREQ) //A1_ZCDECOM )

	if cStatuCust == "new"
		if QWSC25->A1_MSBLQL == "2" // DESBLOQUEADO
			oJson['aprovacao']	:= .T.
			oJson['reprovacao']	:= .F.
		elseif QWSC25->A1_MSBLQL == "1" // BLOQUEADO
			oJson['aprovacao']	:= .F.
			oJson['reprovacao']	:= .T.
		endif
	else
		oJson['aprovacao']	:= .F.
		oJson['reprovacao']	:= .F.
	endif

	if QWSC25->A1_ZINATIV == "1"  
		oJson['a1zinativ']	:= "inativo"

	elseif QWSC25->A1_ZINATIV == "0" .or. empty( QWSC25->A1_ZINATIV )
		oJson['a1zinativ']	:= "ativo"
	endif

return

/*/
=============================================================================
{Protheus.doc} MGFWSC25D
Descrição da condição de pagamento
@author
Josué Danich
@since
10/03/2020
*/
Static Function MGFWSC25D(cCodCond)

	Local aArea 	:= getArea()
	Local aAreaSE4	:= SE4->(getArea())
	Local cRet := ""

	dbSelectArea("SE4")
	SE4->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO
	If SE4->(DbSeek(xFilial("SE4") + cCodCond))
		cRet := SE4->E4_DESCRI
	EndIf

	RestArea(aAreaSE4)
	RestArea(aArea)

Return cRet

/*/
=============================================================================
{Protheus.doc} MGFWSC25V
Nome do Vendedor
@author
Josué Danich
@since
10/03/2020
*/
Static Function MGFWSC25V(cCodVend)

Local cRet		:= ""

SA3->(dbSetOrder(1))//A3_FILIAL+A3_COD
If SA3->(DbSeek(xFilial("SA3") + cCodVend))
	cRet := SA3->A3_NOME
EndIf

Return cRet

/*/
=============================================================================
{Protheus.doc} MGFWSC25S
Retorna status do cliente no E-Commerce
@author
Josué Danich
@since
10/03/2020
*/
static function MGFWSC25S( cCustomer )
	local cURLInteg		:= allTrim( superGetMv( "MGFECOM25B" , , "http://spdwvapl203:8205/protheuscliente/api/clientesRequisicoes/" ) )
	local cURLUse		:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 600
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local cHttpRet		:= ""
	local jCustomer		:= nil
	local cJsonRet		:= ""
	local cRetStatus	:= ""

	aadd( aHeadStr, 'Content-Type: application/json')

	cTimeIni	:= time()
	cHeaderRet	:= ""

	cURLUse := cURLInteg + allTrim( cCustomer )

	//cHttpRet	:= httpQuote( cURLUse /*<cUrl>*/, "PUT" /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
	cHttpRet := httpQuote( cURLUse /*<cUrl>*/, "GET" /*<cMethod>*/, /*[cGETParms]*/, /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )
	cTimeFin	:= time()
	cTimeProc	:= elapTime(cTimeIni, cTimeFin)

	nStatuHttp := 0
	nStatuHttp := httpGetStatus()

	conout(" [E-COM] [MGFWSC25] * * * * * Status da integracao * * * * *")
	conout(" [E-COM] [MGFWSC25] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
	conout(" [E-COM] [MGFWSC25] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
	conout(" [E-COM] [MGFWSC25] Tempo de Processamento.......: " + cTimeProc)
	conout(" [E-COM] [MGFWSC25] URL..........................: " + cURLUse)
	conout(" [E-COM] [MGFWSC25] HTTP Method..................: " + "GET")
	conout(" [E-COM] [MGFWSC25] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
	conout(" [E-COM] [MGFWSC25] * * * * * * * * * * * * * * * * * * * * ")

	if nStatuHttp >= 200 .and. nStatuHttp <= 299
		jCustomer := nil
		if fwJsonDeserialize( cHttpRet, @jCustomer )
			cJsonRet := cHttpRet
			cRetStatus := jCustomer:status
			conout( " " + jCustomer:status )
		endif
	endif

return cRetStatus


/*/
=============================================================================
{Protheus.doc} MGFWSC25R
Retorna reembolso do cliente
@author
Josué Danich
@since
10/03/2020
*/
Static funcTion MGFWSC25R()

Local _nret := 0

If getmv("MGFWSC25R",,.F.)

	cQWSC25 := " 	SELECT COALESCE( SUM( E1_SALDO ) , 0 ) NCC"				+ CRLF
	cQWSC25 += " 	FROM "	+ retSQLName("SE1") + " SE1"				+ CRLF
	cQWSC25 += " 	WHERE"												+ CRLF
	cQWSC25 += " 		SE1.E1_LOJA		=	'" + allTrim( QWSC25->A1_LOJA ) + "'"			+ CRLF
	cQWSC25 += " 	AND	SE1.E1_CLIENTE	=	'" + allTrim( QWSC25->A1_COD ) + "'"			+ CRLF
	cQWSC25 += " 	AND	SE1.E1_EMISSAO	>=	'" + DTOS(DATE()-getmv("MGFWSC25D",,90)) + "'"	+ CRLF
	cQWSC25 += " 	AND	SE1.E1_FILIAL	=	'" + allTrim( QWSC25->ZP_CENTDIS ) + "' "		+ CRLF
	cQWSC25 += " 	AND	SE1.E1_SALDO    >   0"							+ CRLF
	cQWSC25 += " 	AND	SE1.E1_NUMBOR   =   ' ' "						+ CRLF
	cQWSC25 += " 	AND	SE1.E1_TIPO   	=   'NCC' "						+ CRLF

	// TITULOS DE CARTAO DE CREDITO TERAO VALOR ESTORNADO NO CARTAO DE CREDITO DO CLIENTE
	cQWSC25 += " 	AND	SE1.E1_ZNSU		=   ' '"						+ CRLF

	// E1_ZCREDEC -> NAO TRAZ NCCS QUE SERAO DEPOSITADAS NA CONTA DO CLIENTE
	cQWSC25 += " 	AND	SE1.E1_ZCREDEC	=	'S'"						+ CRLF

	cQWSC25 += " 	AND	SE1.D_E_L_E_T_  =   ' '"						+ CRLF

	If select( "TMPNCC") > 0
		Dbselectarea( "TMPNCC")
		TMPNCC->(Dbclosearea())
	Endif

	tcQuery cQWSC25 New Alias "TMPNCC"

	_nret := TMPNCC->NCC

	cQWSC25 := " 	SELECT COALESCE( SUM( C6_VALOR ) , 0 ) SALDO"		+ CRLF
	cQWSC25 += " 	FROM        " + retSQLName("SC5") + " SC5"			+ CRLF
	cQWSC25 += " 	INNER JOIN  " + retSQLName("SC6") + " SC6"			+ CRLF
	cQWSC25 += " 	ON"													+ CRLF
	cQWSC25 += " 	    SC6.C6_NUM      =   SC5.C5_NUM"					+ CRLF
	cQWSC25 += " 	AND SC6.C6_FILIAL   =   SC5.C5_FILIAL"				+ CRLF
	cQWSC25 += " 	AND SC6.D_E_L_E_T_  =   ' '"						+ CRLF
	cQWSC25 += " 	WHERE"												+ CRLF
	cQWSC25 += " 	    SC5.C5_ZUSANCC  =   '1'"						+ CRLF
	cQWSC25 += " 	AND	SC5.C5_BLQ      =   ' '"						+ CRLF
	cQWSC25 += " 	AND SC5.C5_NOTA     =   ' '"						+ CRLF
	cQWSC25 += " 	AND SC5.C5_LOJACLI  =   '" + allTrim( QWSC25->A1_LOJA ) + "'"		+ CRLF
	cQWSC25 += " 	AND SC5.C5_CLIENT   =   '" + allTrim( QWSC25->A1_COD ) + "'"		+ CRLF
	cQWSC25 += " 	AND SC5.C5_FILIAL   =	'" + allTrim( QWSC25->ZP_CENTDIS ) + "' " + CRLF
	cQWSC25 += " 	AND SC6.C6_FILIAL   =	'" + allTrim( QWSC25->ZP_CENTDIS ) + "' " + CRLF
	cQWSC25 += " 	AND	SC5.C5_EMISSAO	>=	'" + DTOS(DATE()-getmv("MGFWSC25D",,90)) + "'"	+ CRLF
	cQWSC25 += " 	AND SC5.D_E_L_E_T_  =   ' '"						+ CRLF
	cQWSC25 += " 	AND SC6.D_E_L_E_T_  =   ' '"						+ CRLF

	If select( "TMPSPV") > 0
		Dbselectarea( "TMPSPV")
		TMPSPV->(Dbclosearea())
	Endif

	tcQuery cQWSC25 New Alias "TMPSPV"

	_nret := _nret - TMPSPV->SALDO

Endif

Return _nret