#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC30
INTEGRACAO E-COMMERCE - FATURAMENTO

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
User function MGFWSC30( )

	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

		U_MFCONOUT('Iniciando ambiente para exportação de faturamento para o E-Commerce...')

		MGFWSC30E()

		U_MFCONOUT('Completou exportação de faturamento para o E-Commerce...')

	RESET ENVIRONMENT
return

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC30E
Execução de integração de faturamento

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
static function MGFWSC30E()

	local cURLPost		:= allTrim( superGetMv( "MGFECOM30A" , , "http://spdwvapl219:8210/protheus-pedido/api/v1/orders/" ) ) // http://spdwvapl219:8210/protheus-pedido/console/
	local cUpdTbl		:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local oJson 		:= nil
	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""
	local _ntot         := 0
	local _nni          := 0
	local cNFAtu		:= ""
	local cIdECom		:= ""
	local nSF2Recno		:= 0

	MGFWSC30Q() //query para buscar faturamento

	If QRYSF2->(EOF())

		U_MFCONOUT("Não foram localizados faturamentos pendentes de exportação!")
		Return

	Endif


	aadd( aHeadStr, 'Content-Type: application/json')

	while !QRYSF2->(EOF())
		_ntot++
		QRYSF2->(Dbskip())
	Enddo
	
	QRYSF2->(Dbgotop())

	while !QRYSF2->(EOF())

		_nni++
		U_MFCONOUT("Exportando faturamento " + allTrim( QRYSF2->F2_FILIAL + '/' + QRYSF2->C5_NUM) + " - " + strzero(_nni,6) + " de " + strzero(_nTot,6) + "...")

		cIdECom := ""
		cIdECom := allTrim( QRYSF2->C5_ZIDECOM )
		oJson := nil
		oJson := JsonObject():new()

		oJson['C5_NUM']						:= allTrim( QRYSF2->C5_NUM							)
		oJson['F2_FILIAL']					:= allTrim( QRYSF2->F2_FILIAL						)
		oJson['ID_CLIENTE']					:= allTrim( QRYSF2->A1_ZCDECOM )
		oJson['SA1']						:= allTrim( QRYSF2->A1_ZCDECOM )
		oJson['C5_FECENT']					:= dToC( sToD( QRYSF2->C5_FECENT ) ) + " 00:00:00" // "C5_FECENT": "22/10/2018 00:00:00",
		oJson['STATUS']						:= "APPROVED"
		oJson['DESCRICAO_STATUS']			:= "Pedido Faturado"
		oJson['F2_DOC']						:= allTrim( QRYSF2->F2_DOC )
		oJson['F2_SERIE']					:= allTrim( QRYSF2->F2_SERIE )
		oJson['F2_EMISSAO']					:= dToC(sToD( QRYSF2->F2_EMISSAO )) + " 00:00:00"
		oJson['F2_CHVNFE']					:= allTrim( QRYSF2->F2_CHVNFE )
		oJson['F2_DOC_BONIFICACAO']			:= allTrim( QRYSF2->F2_DOC )
		oJson['F2_SERIE_BONIFICACAO']		:= allTrim( QRYSF2->F2_SERIE )
		oJson['F2_EMISSAO_BONIFICACAO']		:= dToC(sToD( QRYSF2->F2_EMISSAO )) + " 00:00:00"
		oJson['F2_CHVNFE_BONIFICACAO']		:= allTrim( QRYSF2->F2_CHVNFE )
		oJson['F2_VALMERC']					:= alltrim(str(QRYSF2->F2_VALMERC))
		oJson['F2_VALBRUT']					:= alltrim(str(QRYSF2->F2_VALBRUT))

		oJson['C5_FECENT']					:= left( dToC( sToD( QRYSF2->C5_FECENT	) ) , 6 ) + "20" + right( dToC( sToD( QRYSF2->C5_FECENT ) ) , 2 )  + " 00:00:00"
		oJson['F2_EMISSAO']					:= left( dToC( sToD( QRYSF2->F2_EMISSAO	) ) , 6 ) + "20" + right( dToC( sToD( QRYSF2->C5_FECENT ) ) , 2 )  + " 00:00:00"
		oJson['F2_EMISSAO_BONIFICACAO']		:= left( dToC( sToD( QRYSF2->F2_EMISSAO	) ) , 6 ) + "20" + right( dToC( sToD( QRYSF2->C5_FECENT ) ) , 2 )  + " 00:00:00"

		cNFAtu		:= QRYSF2->F2_FILIAL + QRYSF2->F2_DOC
		nSF2Recno	:= 0
		nSF2Recno	:= QRYSF2->SF2RECNO
		while !QRYSF2->(EOF()) .and. cNFAtu == QRYSF2->F2_FILIAL + QRYSF2->F2_DOC

			oJson['ITEMS']	:= {}

			oJsonItem					:= JsonObject():new()
			oJsonItem['D2_QUANT']		:= alltrim(str(QRYSF2->D2_QUANT))
			oJsonItem['PESO_CAIXA']		:= alltrim(str(QRYSF2->D2_QUANT / QRYSF2->ZZR_TOTCAI))
			oJsonItem['D2_COD']			:= allTrim( QRYSF2->D2_COD )
			oJsonItem['D2_PRCVEN']		:= alltrim(str(QRYSF2->D2_PRCVEN * ( QRYSF2->D2_QUANT / QRYSF2->ZZR_TOTCAI )))

			oJsonPreco	:= nil
			oJsonPreco	:= JsonObject():new()

			oJsonPreco['D2_DESC']		:= allTrim( QRYSF2->D2_DESC )
			oJsonPreco['ZZR_TOTCAI']	:= alltrim(str(QRYSF2->ZZR_TOTCAI))
			oJsonPreco['TOTAL']			:= alltrim(str(QRYSF2->D2_TOTAL))

			oJsonItem['PRECO_INFO']		:= oJsonPreco

			aadd( oJson['ITEMS'] , oJsonItem )

			QRYSF2->(DBSkip())
		enddo

		cJson		:= ""
		cJson		:= oJson:toJson()

		cURLPost	:= ""
		cURLPost	:= allTrim( superGetMv( "MGFECOM29A" , , "http://spdwvapl219:8210/protheus-pedido/api/v1/orders/" ) ) // http://spdwvapl219:8210/protheus-pedido/console/
		cURLPost	:= cURLPost + cIdECom + "/billing"

		if !empty( cJson )
			cTimeIni	:= time()
			cHeaderRet	:= ""
			cHttpRet	:= httpQuote( cURLPost /*<cUrl>*/, "PUT" /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

			nStatuHttp	:= httpGetStatus()
			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni, cTimeFin )

			conout(" [E-COM] [MGFWSC30] * * * * * Status da integracao * * * * *")
			conout(" [E-COM] [MGFWSC30] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC30] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC30] Tempo de Processamento.......: " + cTimeProc)
			conout(" [E-COM] [MGFWSC30] URL..........................: " + cURLPost)
			conout(" [E-COM] [MGFWSC30] HTTP Method..................: " + "PUT")
			conout(" [E-COM] [MGFWSC30] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [E-COM] [MGFWSC30] Envio........................: " + cJson)
			conout(" [E-COM] [MGFWSC30] Retorno......................: " + cHttpRet)
			conout(" [E-COM] [MGFWSC30] * * * * * * * * * * * * * * * * * * * * ")

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				cUpdTbl	:= ""

				cUpdTbl := "UPDATE " + retSQLName("SF2")								+ CRLF
				cUpdTbl += "	SET"													+ CRLF
				cUpdTbl += " 		F2_XINTECO = '2'"									+ CRLF
				cUpdTbl += " WHERE"														+ CRLF
				cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( nSF2Recno ) ) + ""	+ CRLF

				if tcSQLExec( cUpdTbl ) < 0
					conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
				endif
			endif

  		endif

		freeObj( oJson )
	enddo

	QRYSF2->(DBCloseArea())

	delClassINTF()
return



/*/
===========================================================================================================================
{Protheus.doc} MGFWSC30
INTEGRACAO E-COMMERCE - FATURAMENTO

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
static function MGFWSC30Q()
	local cQrySF2 := ""

	cQrySF2 := "SELECT"													+ CRLF
	cQrySF2 += " C5_NUM			,"	+ CRLF
	cQrySF2 += " F2_FILIAL		,"	+ CRLF
	cQrySF2 += " C5_FECENT		,"	+ CRLF
	cQrySF2 += " F2_DOC			,"	+ CRLF
	cQrySF2 += " F2_SERIE		,"	+ CRLF
	cQrySF2 += " F2_CLIENTE		,"	+ CRLF
	cQrySF2 += " F2_LOJA		,"	+ CRLF
	cQrySF2 += " F2_EMISSAO		,"	+ CRLF
	cQrySF2 += " F2_CHVNFE		,"	+ CRLF
	cQrySF2 += " D2_QUANT		,"	+ CRLF
	cQrySF2 += " D2_DESC		,"	+ CRLF
	cQrySF2 += " ZZR_TOTCAI		,"	+ CRLF
	cQrySF2 += " D2_COD			,"	+ CRLF
	cQrySF2 += " D2_PRCVEN		,"	+ CRLF
	cQrySF2 += " F2_VALMERC		,"	+ CRLF
	cQrySF2 += " F2_VALBRUT		,"	+ CRLF
	cQrySF2 += " C5_ZIDECOM     ,"  + CRLF
	cQrySF2 += " A1_ZCDECOM     ,"  + CRLF
  	cQrySF2 += " D2_TOTAL		,"	+ CRLF
  	cQrySF2 += " SF2.R_E_C_N_O_ SF2RECNO		"	+ CRLF
	cQrySF2 += " FROM "			+ retSQLName("SF2") + " SF2"			+ CRLF
	cQrySF2 += " INNER JOIN "	+ retSQLName("SD2") + " SD2"			+ CRLF
	cQrySF2 += " ON"													+ CRLF
	cQrySF2 += "		SD2.D2_SERIE	=	SF2.F2_SERIE"				+ CRLF
	cQrySF2 += "	AND	SD2.D2_DOC		=	SF2.F2_DOC"					+ CRLF
	cQrySF2 += "	AND	SD2.D2_FILIAL	=	SF2.F2_FILIAL"				+ CRLF
	cQrySF2 += "	AND	SD2.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQrySF2 += " INNER JOIN "	+ retSQLName("SC5") + " SC5"			+ CRLF
	cQrySF2 += " ON"													+ CRLF
	cQrySF2 += "		SC5.C5_ZIDECOM	<>	' '"						+ CRLF
	cQrySF2 += "	AND	SD2.D2_PEDIDO	=	SC5.C5_NUM"					+ CRLF
	cQrySF2 += "	AND	SC5.C5_FILIAL	=	SF2.F2_FILIAL"	+ CRLF
	cQrySF2 += "	AND	SC5.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQrySF2 += " INNER JOIN "	+ retSQLName("SA1") + " SA1"			+ CRLF
	cQrySF2 += " ON"													+ CRLF
	cQrySF2 += "		SF2.F2_LOJA		=	SA1.A1_LOJA"				+ CRLF
	cQrySF2 += "	AND	SF2.F2_CLIENTE	=	SA1.A1_COD"					+ CRLF
	cQrySF2 += "	AND	SA1.D_E_L_E_T_	<>	'*'"						+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("ZZR") + " ZZR"			+ CRLF
	cQrySF2 += " ON"													+ CRLF
	cQrySF2 += "		SD2.D2_ITEMPV	=	ZZR.ZZR_ITEM"				+ CRLF
	cQrySF2 += "	AND	SD2.D2_PEDIDO	=	ZZR.ZZR_PEDIDO"				+ CRLF
	cQrySF2 += "	AND	ZZR.ZZR_FILIAL	=	SF2.F2_FILIAL"				+ CRLF
	cQrySF2 += "	AND	ZZR.D_E_L_E_T_	<>	'*'"						+ CRLF

	cQrySF2 += " WHERE"													+ CRLF
	cQrySF2 += " 		SF2.F2_XINTECO	=	'1'"						+ CRLF // F2_XINTECO -> 0 = Pendente / 1= Integrado
	cQrySF2 += " 	AND	SF2.F2_CHVNFE	<>	' '"						+ CRLF
	cQrySF2 += " 	AND	SF2.F2_STATUS	=	' '"						+ CRLF
	cQrySF2 += " 	AND	SF2.D_E_L_E_T_	<>	'*'"						+ CRLF

	tcQuery cQrySF2 New Alias "QRYSF2"
return