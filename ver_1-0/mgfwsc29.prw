#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC29
INTEGRACAO E-COMMERCE - TRACKING PEDIDOS

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
user function MGFWSC29(  )

	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

		U_MFCONOUT('Iniciando ambiente para exportação de tracking de pedidos para o E-Commerce...')

		MGFWSC29E()

		U_MFCONOUT('Completou exportação de tracking de pedidos para o E-Commerce...')

	RESET ENVIRONMENT
return

/*/
===========================================================================================================================
{Protheus.doc} MGFWSC24E
Execução da exportação de tracking de pedidos

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
static function MGFWSC29E()

	local cURLPost		:= allTrim( superGetMv( "MGFECOM29A" , , "http://spdwvapl219:8210/protheus-pedido/api/v1/orders/" ) ) // http://spdwvapl219:8210/protheus-pedido/console/
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
	local cPedAtu		:= ""
	local cIdECom		:= ""
	local nXC5Recno		:= 0
	Local _ctracking    := ""
	Local _cembarque    := ""

	U_MFCONOUT("Carregando pedidos com tracking pendente de exportação...")
	MGFWSC29Q() //Execução de query de pedidos para exportar

	If QRYXC5->(EOF())

		U_MFCONOUT("Não foram localizados pedidos com tracking pendente de exportação!")
		Return

	Endif

	aadd( aHeadStr, 'Content-Type: application/json')

	while !QRYXC5->(EOF())
		_ntot++
		QRYXC5->(Dbskip())
	Enddo
	
	QRYXC5->(Dbgotop())

	while !QRYXC5->(EOF())

		_nni++
		U_MFCONOUT("Exportando tracking " + allTrim( QRYXC5->C5_FILIAL + '/' + QRYXC5->C5_NUM) + " - " + strzero(_nni,6) + " de " + strzero(_nTot,6) + "...")

		cIdECom := ""
		cIdECom := allTrim( QRYXC5->XC5_IDECOM )
	
		cPedAtu := ""
		cPedAtu := QRYXC5->C5_FILIAL + QRYXC5->C5_NUM

		oJson := nil
		oJson := JsonObject():new()

		

		//DEFINE TRACKING
		If allTrim( QRYXC5->C5_ZBLQRGA ) == "SUBMITTED" .AND. allTrim( QRYXC5->C5_ZROAD  ) == "AUTHORIZED"
			_ctracking := "Pedido Submetido"
			_cembarque := "INITIAL"
		Endif
		If allTrim( QRYXC5->C5_ZBLQRGA ) == "SUBMITTED" .AND. allTrim( QRYXC5->C5_ZROAD ) == "SETTLED"
			_ctracking := "Pedido Confirmado"
			_cembarque := "INITIAL"
		Endif
		If allTrim( QRYXC5->C5_ZBLQRGA ) == "PROCESSING" .AND. allTrim( QRYXC5->C5_ZROAD ) == "AUTHORIZED"
			_ctracking := "Pedido Bloqueado"
			_cembarque := "INITIAL"
		Endif
		If allTrim( QRYXC5->C5_ZBLQRGA ) == "REJECTED" .AND. allTrim( QRYXC5->C5_ZROAD ) == "REMOVED"
			_ctracking := "Pedido Rejeitado"
			_cembarque := "REMOVED"
		Endif
		If allTrim( QRYXC5->C5_ZBLQRGA ) == "PROCESSING" .AND. allTrim( QRYXC5->C5_ZROAD ) == "SETTLED"
			_ctracking := "Pedido em Separação"
			_cembarque := "PROCESSING"
		Endif
		If allTrim( QRYXC5->C5_ZBLQRGA ) == "NO_PENDING_ACTION" .AND. allTrim( QRYXC5->C5_ZROAD ) == "AUTHORIZED"
			_ctracking := "Enviado a Transportadora"
			_cembarque := "PENDING_SHIPMENT"
		Endif

		oJson['C5_FILIAL']			:= allTrim( QRYXC5->C5_FILIAL )
		oJson['C5_NUM']				:= allTrim( QRYXC5->C5_NUM )
		oJson['STATUS']				:= allTrim( QRYXC5->C5_ZBLQRGA )
		oJson['C5_ZROAD']			:= _cembarque
		oJson['STATUS_EMBARQUE']	:= _cembarque
		oJson['STATUS_PAGAMENTO']	:= allTrim( QRYXC5->C5_ZROAD )
		oJson['TRACKING']			:= _ctracking

		

		oJson['DESCRICAO_STATUS']	:= ""

		nXC5Recno := 0
		nXC5Recno := QRYXC5->XC5RECNO
		while !QRYXC5->(EOF()) .and. cPedAtu == QRYXC5->C5_FILIAL + QRYXC5->C5_NUM

			if !empty( QRYXC5->MOTIVO )
				//1=Fiscal;2=Financeiro;3=Estoque;4=Comercial
				if allTrim( QRYXC5->MOTIVO ) == "1"
					oJson['DESCRICAO_STATUS'] := allTrim( oJson['DESCRICAO_STATUS'] + "\Fiscal" )
				elseif allTrim( QRYXC5->MOTIVO ) == "2"
					oJson['DESCRICAO_STATUS'] := allTrim( oJson['DESCRICAO_STATUS'] + "\Financeiro" )
				elseif allTrim( QRYXC5->MOTIVO ) == "3"
					oJson['DESCRICAO_STATUS'] := allTrim( oJson['DESCRICAO_STATUS'] + "\Estoque" )
				elseif allTrim( QRYXC5->MOTIVO ) == "4"
					oJson['DESCRICAO_STATUS'] := allTrim( oJson['DESCRICAO_STATUS'] + "\Comercial" )
				endif
			endif

			QRYXC5->(DBSkip())
		enddo

		if !empty( oJson['DESCRICAO_STATUS'] )
			oJson['DESCRICAO_STATUS'] := subStr( oJson['DESCRICAO_STATUS'], 2, len( oJson['DESCRICAO_STATUS'] ) ) // Remove barra inicial
		endif

		cJson		:= ""
		cJson		:= oJson:toJson()

		cURLPost	:= ""
		cURLPost	:= allTrim( superGetMv( "MGFECOM29A" , , "http://spdwvapl219:8210/protheus-pedido/api/v1/orders/" ) ) // http://spdwvapl219:8210/protheus-pedido/console/
		cURLPost	:= cURLPost + cIdECom

		if !empty( cJson )
			
			cHeaderRet	:= ""
			
			cTimeIni	:= time()
	
			cHttpRet := httpQuote( cURLPost /*<cUrl>*/, "PUT" /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

			cTimeFin	:= time()
			cTimeProc	:= elapTime( cTimeIni, cTimeFin )

			nStatuHttp	:= httpGetStatus()

			conout(" [E-COM] [MGFWSC29] * * * * * Status da integracao * * * * *")
			conout(" [E-COM] [MGFWSC29] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC29] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
			conout(" [E-COM] [MGFWSC29] Tempo de Processamento.......: " + cTimeProc)
			conout(" [E-COM] [MGFWSC29] URL..........................: " + cURLPost)
			conout(" [E-COM] [MGFWSC29] HTTP Method..................: " + "PUT")
			conout(" [E-COM] [MGFWSC29] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
			conout(" [E-COM] [MGFWSC29] Envio........................: " + cJson)
			conout(" [E-COM] [MGFWSC29] Retorno......................: " + cHttpRet)
			conout(" [E-COM] [MGFWSC29] * * * * * * * * * * * * * * * * * * * * ")

			if nStatuHttp >= 200 .and. nStatuHttp <= 299
				cUpdTbl	:= ""

				cUpdTbl := "UPDATE " + retSQLName("XC5")								+ CRLF
				cUpdTbl += "	SET"													+ CRLF
				cUpdTbl += " 		XC5_INTEGR = 'I'"									+ CRLF
				cUpdTbl += " WHERE"														+ CRLF
				cUpdTbl += " 		R_E_C_N_O_ = " + allTrim( str( nXC5Recno ) ) + ""	+ CRLF

				if tcSQLExec( cUpdTbl ) < 0
					U_MFCONOUT("Pedido " + allTrim( QRYXC5->C5_FILIAL + '/' + QRYXC5->C5_NUM) + " com falha de atualização, tracking será reenviado!")
				else
					U_MFCONOUT("Pedido " + allTrim( QRYXC5->C5_FILIAL + '/' + QRYXC5->C5_NUM) + " atualizado com sucesso!")
				endif
			endif

   		endif

		freeObj( oJson )
	enddo

	QRYXC5->(DBCloseArea())

	delClassINTF()
return



/*/
===========================================================================================================================
{Protheus.doc} MGFWSC24Q
Execução da exportação de tracking de pedidos

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
/*/
===========================================================================================================================
{Protheus.doc} MGFWSC24Q
Execução da exportação de tracking de pedidos

@author Josué Danich Prestes
@since 19/12/2019 
@type Job  
*/
static function MGFWSC29Q()
	local cQryTrack	:= ""

	/*
		Rejeitado
	*/
	cQryTrack += " SELECT"																					+ CRLF
	cQryTrack += "     XC5_FILIAL C5_FILIAL, XC5_IDECOM C5_NUM, 'REJECTED' C5_ZBLQRGA,"						+ CRLF
	cQryTrack += "     SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XC5_OBS,2000,1)),1,4000) MOTIVO,"	+ CRLF
	cQryTrack += "     'REMOVED' C5_ZROAD, XC5_IDECOM,"														+ CRLF
	cQryTrack += " 		'PAYMENT_DEFERRED' PAYMENT, XC5.R_E_C_N_O_ XC5RECNO"								+ CRLF
	cQryTrack += "  FROM XC5010 XC5"																		+ CRLF
	cQryTrack += "  WHERE"																					+ CRLF
	cQryTrack += "		XC5.XC5_INTEGR	=	'P'"															+ CRLF
	cQryTrack += "	AND XC5.XC5_STATUS	=	'4'"															+ CRLF
	cQryTrack += "	AND	XC5.D_E_L_E_T_	<>	'*'"															+ CRLF

 	cQryTrack += "  UNION ALL"		
	 
	 //Rejeitado por pedido apagado  
  	cQryTrack += " SELECT"																					+ CRLF
	cQryTrack += "     XC5_FILIAL C5_FILIAL, XC5_IDECOM C5_NUM, 'REJECTED' C5_ZBLQRGA,"						+ CRLF
	cQryTrack += "     SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(XC5_OBS,2000,1)),1,4000) MOTIVO,"	+ CRLF
	cQryTrack += "     'REMOVED' C5_ZROAD, XC5_IDECOM,"														+ CRLF
	cQryTrack += " 		'PAYMENT_DEFERRED' PAYMENT, XC5.R_E_C_N_O_ XC5RECNO"								+ CRLF
	cQryTrack += "  FROM XC5010 XC5"																		+ CRLF
	cQryTrack += "  WHERE"																					+ CRLF
	cQryTrack += "		XC5.XC5_INTEGR	=	'P'"															+ CRLF
	cQryTrack += "	AND XC5.XC5_STATUS	=	'3'"															+ CRLF
	cQryTrack += " 	AND NOT EXISTS(SELECT C5_NUM FROM SC5010 C5A WHERE C5A.C5_FILIAL=XC5.XC5_FILIAL "
	cQryTrack += "                  AND C5A.C5_NUM = XC5.XC5_PVPROT AND C5A.D_E_L_E_T_ <> '*') "			+ CRLF
	cQryTrack += "	AND	XC5.D_E_L_E_T_	<>	'*'"															+ CRLF
	cQryTrack += "  UNION ALL"	

	/*
		Liberados NAO ROTEIRIZADOS
	*/
	cQryTrack += " SELECT C5_FILIAL, C5_NUM, 'SUBMITTED' C5_ZBLQRGA, '' MOTIVO, 'SETTLED' C5_ZROAD, XC5_IDECOM,"		+ CRLF
	cQryTrack += " 'PAYMENT_DEFERRED' PAYMENT, XC5.R_E_C_N_O_ XC5RECNO"							+ CRLF
	cQryTrack += "  FROM "			+ retSQLName("XC5") + " XC5"								+ CRLF
	cQryTrack += "  INNER JOIN "	+ retSQLName("SC5") + " SC5"								+ CRLF
	cQryTrack += "  ON"																			+ CRLF
	cQryTrack += "  		SC5.C5_ZBLQRGA	=	'L'"											+ CRLF
	cQryTrack += "  	AND	SC5.C5_ZROAD	=	'N'"											+ CRLF // NAO ROTEIRIZADOS
	cQryTrack += "  	AND	XC5.XC5_PVPROT	=	SC5.C5_NUM"										+ CRLF
	cQryTrack += "  	AND	XC5.XC5_FILIAL	=	SC5.C5_FILIAL"									+ CRLF
	cQryTrack += "  	AND	SC5.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryTrack += "  WHERE"																		+ CRLF
	cQryTrack += "  		XC5.XC5_INTEGR	=	'P'"											+ CRLF
	cQryTrack += "  	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF

	cQryTrack += "  UNION ALL"																	+ CRLF

	/*
		Liberados ROTEIRIZADOS
	*/
	cQryTrack += " SELECT C5_FILIAL, C5_NUM, 'PROCESSING' C5_ZBLQRGA, '' MOTIVO, 'SETTLED' C5_ZROAD, XC5_IDECOM,"		+ CRLF
	cQryTrack += " 'PAYMENT_DEFERRED' PAYMENT, XC5.R_E_C_N_O_ XC5RECNO"													+ CRLF
	cQryTrack += "  FROM "			+ retSQLName("XC5") + " XC5"								+ CRLF
	cQryTrack += "  INNER JOIN "	+ retSQLName("SC5") + " SC5"								+ CRLF
	cQryTrack += "  ON"																			+ CRLF
	cQryTrack += "  		SC5.C5_ZBLQRGA	=	'L'"											+ CRLF
	cQryTrack += "  	AND	SC5.C5_ZROAD	=	'S'"											+ CRLF // NAO ROTEIRIZADOS
	cQryTrack += "  	AND	XC5.XC5_PVPROT	=	SC5.C5_NUM"										+ CRLF
	cQryTrack += "  	AND	XC5.XC5_FILIAL	=	SC5.C5_FILIAL"									+ CRLF
	cQryTrack += "  	AND	SC5.D_E_L_E_T_	<>	'*'"											+ CRLF

	cQryTrack += " LEFT JOIN "	+ retSQLName("SD2") + " SD2"									+ CRLF
	cQryTrack += " ON"																			+ CRLF
	cQryTrack += "		SD2.D2_PEDIDO	=	SC5.C5_NUM"											+ CRLF
	cQryTrack += "	AND	SD2.D2_FILIAL	=	XC5.XC5_FILIAL"										+ CRLF
	cQryTrack += "	AND	SD2.D_E_L_E_T_	<>	'*'"												+ CRLF

	cQryTrack += "  WHERE"																		+ CRLF
	cQryTrack += "  		XC5.XC5_INTEGR	=	'P'"											+ CRLF
	cQryTrack += "  	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF

	cQryTrack += "		AND	SD2.D2_PEDIDO	IS NULL"											+ CRLF

	cQryTrack += "  UNION ALL"																	+ CRLF


	/*
		Liberados ROTEIRIZADOS COM NOTA - Enviado Transportadora 
	*/
	cQryTrack += " SELECT C5_FILIAL, C5_NUM, 'NO_PENDING_ACTION' C5_ZBLQRGA, '' MOTIVO, 'AUTHORIZED' C5_ZROAD, XC5_IDECOM,"		+ CRLF
	cQryTrack += " 'SETTLED' PAYMENT, XC5.R_E_C_N_O_ XC5RECNO"									+ CRLF
	cQryTrack += "  FROM "			+ retSQLName("XC5") + " XC5"								+ CRLF
	cQryTrack += "  INNER JOIN "	+ retSQLName("SC5") + " SC5"								+ CRLF
	cQryTrack += "  ON"																			+ CRLF
	cQryTrack += "  		SC5.C5_ZBLQRGA	=	'L'"											+ CRLF
	cQryTrack += "  	AND	SC5.C5_ZROAD	=	'S'"											+ CRLF // ROTEIRIZADOS
	cQryTrack += "  	AND	XC5.XC5_PVPROT	=	SC5.C5_NUM"										+ CRLF
	cQryTrack += "  	AND	XC5.XC5_FILIAL	=	SC5.C5_FILIAL"									+ CRLF
	cQryTrack += "  	AND	SC5.D_E_L_E_T_	<>	'*'"											+ CRLF

	cQryTrack += " INNER JOIN "	+ retSQLName("SD2") + " SD2"									+ CRLF
	cQryTrack += " ON"																			+ CRLF
	cQryTrack += "		SD2.D2_PEDIDO	=	SC5.C5_NUM"											+ CRLF
	cQryTrack += "	AND	SD2.D2_FILIAL	=	XC5.XC5_FILIAL"										+ CRLF
	cQryTrack += "	AND	SD2.D_E_L_E_T_	<>	'*'"												+ CRLF

	cQryTrack += " INNER JOIN "	+ retSQLName("SF2") + " SF2"									+ CRLF
	cQryTrack += " ON"																			+ CRLF
	cQryTrack += "		SF2.F2_LOJA		=	SD2.D2_LOJA"										+ CRLF
	cQryTrack += "	AND	SF2.F2_CLIENTE	=	SD2.D2_CLIENTE"										+ CRLF
	cQryTrack += "	AND	SF2.F2_SERIE	=	SD2.D2_SERIE"										+ CRLF
	cQryTrack += "	AND	SF2.F2_DOC		=	SD2.D2_DOC"											+ CRLF
	cQryTrack += "	AND	SF2.F2_FILIAL	=	XC5.XC5_FILIAL"										+ CRLF
	cQryTrack += "	AND	SF2.D_E_L_E_T_	<>	'*'"												+ CRLF

	cQryTrack += "  WHERE"																		+ CRLF
	cQryTrack += "  		XC5.XC5_INTEGR	=	'P'"											+ CRLF
	cQryTrack += "  	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF

	cQryTrack += "  UNION ALL"																	+ CRLF

	/*
		Bloqueados SEM rejeicao
	*/

	cQryTrack += "  SELECT DISTINCT SC5.C5_FILIAL, SC5.C5_NUM, 'PROCESSING' C5_ZBLQRGA, SZT.ZT_TIPOREG MOTIVO, 'AUTHORIZED' C5_ZROAD, XC5_IDECOM,"		+ CRLF
	cQryTrack += " 'PAYMENT_DEFERRED' PAYMENT, XC5.R_E_C_N_O_ XC5RECNO"							+ CRLF
	cQryTrack += "  FROM "			+ retSQLName("XC5") + " XC5"								+ CRLF
	cQryTrack += "  INNER JOIN "	+ retSQLName("SC5") + " SC5"								+ CRLF
	cQryTrack += "  ON"																			+ CRLF
	cQryTrack += "  		SC5.C5_ZBLQRGA	=	'B'"											+ CRLF
	cQryTrack += "  	AND	XC5.XC5_PVPROT	=	SC5.C5_NUM"										+ CRLF
	cQryTrack += "  	AND	XC5.XC5_FILIAL	=	SC5.C5_FILIAL"									+ CRLF
	cQryTrack += "  	AND	SC5.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryTrack += "  INNER JOIN "	+ retSQLName("SZV") + " SZV"								+ CRLF
	cQryTrack += "  ON"								+ CRLF										+ CRLF
	cQryTrack += "  		SZV.ZV_PEDIDO	=	XC5.XC5_PVPROT"									+ CRLF
	cQryTrack += "  	AND	SZV.ZV_FILIAL	=	SC5.C5_FILIAL"									+ CRLF
	cQryTrack += "  	AND	SZV.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryTrack += "  INNER JOIN "	+ retSQLName("SZT") + " SZT"								+ CRLF
	cQryTrack += "  ON"																			+ CRLF
	cQryTrack += " 		SZV.ZV_CODRGA		=   SZT.ZT_CODIGO"									+ CRLF
	cQryTrack += " 	AND	TRIM(SZT.ZT_FILIAL)	=	SUBSTR(SC5.C5_FILIAL, 1, 2)"					+ CRLF
	cQryTrack += " 	AND	SZT.D_E_L_E_T_		<>	'*'"											+ CRLF
	cQryTrack += " LEFT JOIN"																	+ CRLF
	cQryTrack += " 	("																			+ CRLF
	cQryTrack += " 		SELECT C5_FILIAL, C5_NUM"												+ CRLF
	cQryTrack += " 		FROM "			+ retSQLName("XC5") + " SUBXC5"							+ CRLF
	cQryTrack += " 		INNER JOIN	"	+ retSQLName("SC5") + " SUBSC5"							+ CRLF
	cQryTrack += " 		ON"								+ CRLF									+ CRLF
	cQryTrack += " 			SUBSC5.C5_ZBLQRGA	=	'B'"										+ CRLF
	cQryTrack += " 		AND	SUBXC5.XC5_PVPROT	=	SUBSC5.C5_NUM"								+ CRLF
	cQryTrack += " 		AND	SUBXC5.XC5_FILIAL	=	SUBSC5.C5_FILIAL"							+ CRLF
	cQryTrack += " 		AND	SUBSC5.D_E_L_E_T_	<>	'*'"										+ CRLF
	cQryTrack += "  		INNER JOIN "	+ retSQLName("SZV") + " SUBSZV"						+ CRLF
	cQryTrack += "  		ON"																	+ CRLF
	cQryTrack += "  			SUBSZV.ZV_CODRJC	<>	' '"									+ CRLF
	cQryTrack += "  		AND	SUBSZV.ZV_PEDIDO	=	SUBSC5.C5_NUM"							+ CRLF
	cQryTrack += "  		AND	SUBSZV.ZV_FILIAL	=	SUBSC5.C5_FILIAL"						+ CRLF
	cQryTrack += "  		AND	SUBSZV.D_E_L_E_T_	<>	'*'"									+ CRLF
	cQryTrack += "  		WHERE"																+ CRLF
	cQryTrack += " 				SUBXC5.XC5_INTEGR	=	'P'"									+ CRLF
	cQryTrack += "  		AND	SUBXC5.D_E_L_E_T_	<>	'*'"									+ CRLF
	cQryTrack += " 	) TABA"																		+ CRLF
	cQryTrack += " ON"																			+ CRLF
	cQryTrack += "  		SC5.C5_NUM		=	TABA.C5_NUM"									+ CRLF
	cQryTrack += "  	AND	SC5.C5_FILIAL	=	TABA.C5_FILIAL"									+ CRLF
	cQryTrack += "  WHERE"																		+ CRLF
	cQryTrack += "  		XC5.XC5_INTEGR	=	'P'"											+ CRLF
	cQryTrack += "  	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryTrack += "  	AND	TABA.C5_NUM IS NULL"												+ CRLF

	cQryTrack += "  UNION ALL"																	+ CRLF

	/*
		Bloqueados COM rejeicao
	*/

	cQryTrack += "  SELECT DISTINCT SC5.C5_FILIAL, SC5.C5_NUM, 'REJECTED' C5_ZBLQRGA, SZT.ZT_TIPOREG MOTIVO, 'REMOVED' C5_ZROAD, XC5_IDECOM,"		+ CRLF
	cQryTrack += " 'PAYMENT_DEFERRED' PAYMENT, XC5.R_E_C_N_O_ XC5RECNO"							+ CRLF
	cQryTrack += "  FROM "			+ retSQLName("XC5") + " XC5"								+ CRLF
	cQryTrack += "  INNER JOIN "	+ retSQLName("SC5") + " SC5"								+ CRLF
	cQryTrack += "  ON"																			+ CRLF
	cQryTrack += "  		SC5.C5_ZBLQRGA	=	'B'"											+ CRLF
	cQryTrack += "  	AND	XC5.XC5_PVPROT	=	SC5.C5_NUM"										+ CRLF
	cQryTrack += "  	AND	XC5.XC5_FILIAL	=	SC5.C5_FILIAL"									+ CRLF
	cQryTrack += "  	AND	SC5.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryTrack += "  INNER JOIN "	+ retSQLName("SZV") + " SZV"								+ CRLF
	cQryTrack += "  ON"																			+ CRLF
	cQryTrack += "  		SZV.ZV_PEDIDO	=	XC5.XC5_PVPROT"									+ CRLF
	cQryTrack += "  	AND	SZV.ZV_FILIAL	=	SC5.C5_FILIAL"									+ CRLF
	cQryTrack += "  	AND	SZV.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryTrack += "  INNER JOIN "	+ retSQLName("SZT") + " SZT"								+ CRLF
	cQryTrack += "  ON"								+ CRLF										+ CRLF
	cQryTrack += " 		SZV.ZV_CODRGA		=   SZT.ZT_CODIGO"									+ CRLF
	cQryTrack += " 	AND	TRIM(SZT.ZT_FILIAL)	=	SUBSTR(SC5.C5_FILIAL, 1, 2)"					+ CRLF
	cQryTrack += " 	AND	SZT.D_E_L_E_T_		<>	'*'"											+ CRLF
	cQryTrack += " INNER JOIN"																	+ CRLF
	cQryTrack += "  	("																		+ CRLF
	cQryTrack += " 		SELECT DISTINCT C5_FILIAL , C5_NUM"										+ CRLF
	cQryTrack += " 		FROM		"	+ retSQLName("XC5") + " SUBXC5"							+ CRLF
	cQryTrack += " 		INNER JOIN	"	+ retSQLName("SC5") + " SUBSC5"							+ CRLF
	cQryTrack += " 		ON"																		+ CRLF
	cQryTrack += " 			SUBSC5.C5_ZBLQRGA	=	'B'"										+ CRLF
	cQryTrack += " 		AND	SUBXC5.XC5_PVPROT	=	SUBSC5.C5_NUM"								+ CRLF
	cQryTrack += " 		AND	SUBXC5.XC5_FILIAL	=	SUBSC5.C5_FILIAL"							+ CRLF
	cQryTrack += " 		AND	SUBSC5.D_E_L_E_T_	<>	'*'"										+ CRLF
	cQryTrack += "  	INNER JOIN "	+ retSQLName("SZV") + " SUBSZV"							+ CRLF
	cQryTrack += "  		ON"																	+ CRLF
	cQryTrack += "  			SUBSZV.ZV_CODRJC	<>	' '"									+ CRLF
	cQryTrack += "  		AND	SUBSZV.ZV_PEDIDO	=	SUBSC5.C5_NUM"							+ CRLF
	cQryTrack += "  		AND	SUBSZV.ZV_FILIAL	=	SUBSC5.C5_FILIAL"						+ CRLF
	cQryTrack += "  		AND	SUBSZV.D_E_L_E_T_	<>	'*'"									+ CRLF
	cQryTrack += "  		WHERE"																+ CRLF
	cQryTrack += " 			SUBXC5.XC5_INTEGR	=	'P'"										+ CRLF
	cQryTrack += "  		AND	SUBXC5.D_E_L_E_T_	<>	'*'"									+ CRLF
	cQryTrack += " 		AND	SUBXC5.XC5_FILIAL	=	SUBSC5.C5_FILIAL"							+ CRLF
	cQryTrack += " 	) TABB"																		+ CRLF
	cQryTrack += "  ON"																			+ CRLF
	cQryTrack += " 		SC5.C5_NUM		= TABB.C5_NUM"											+ CRLF
	cQryTrack += " 	AND	SC5.C5_FILIAL	= TABB.C5_FILIAL"										+ CRLF
	cQryTrack += "  WHERE"																		+ CRLF
	cQryTrack += " 			XC5.XC5_INTEGR	=	'P'"											+ CRLF
	cQryTrack += "  	AND	XC5.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryTrack += "  ORDER BY C5_FILIAL, C5_NUM, C5_ZBLQRGA"										+ CRLF

	TcQuery cQryTrack New Alias "QRYXC5"

return