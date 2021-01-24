#include "totvs.ch"
#Include "Protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"

static _aErr

/*/
==============================================================================================================================================================================
Descrição   : Job de retorno de pedidos para o SFA

@author     : Totvs
@since      : 02/10/2019
/*/   
User Function MGFFAT54()

	conout("[MGFFAT54] Iniciando retorno de pedidos para o SFA - " + dToC(date()) + " - " + time())

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

	runFat54()

	conout("[MGFFAT54] Completado retorno de pedidos para o SFA - " + dToC(date()) + " - " + time())

	RESET ENVIRONMENT

Return

/*/
==============================================================================================================================================================================
Descrição   : Execução retorno de pedidos para o SFA

@author     : Totvs
@since      : 02/10/2019
/*/   
static function runFat54()

	local cURLPost		:= allTrim(getMv("MGF_SFA22"))
	local oWSSFA		:= nil
	local cC5Fil		:= ""
	local cC5Num		:= ""
	local nZC5Recno		:= 0
	local lZC5Invali	:= .F.

	private oRetSalOrd	:= nil
	private oRetItSO	:= nil

	private cQryZC5Ret	:= ""
	private cQrySZVRet	:= ""

	conout("[MGFFAT54] Carregando pedidos pendentes de retorno - " + dToC(dDataBase) + " - " + time())
	getZC5( )

	If (cQryZC5Ret)->(EOF())

		conout("[MGFFAT54] Não localizou pedidos pendentes de retorno - " + dtoc(dDataBase) + " - " + time())
		Return

	else

		//Conta cargas para enviar
		(cQryZC5Ret)->(DBGOTOP())
		_ntot := 0
		Do while !((cQryZC5Ret)->(EOF()))
			_ntot++
			(cQryZC5Ret)->(Dbskip())
		Enddo

	Endif

	_nni := 1
	(cQryZC5Ret)->(DBGOTOP())

	while !(cQryZC5Ret)->(EOF())

		BEGIN SEQUENCE
	
			conout("[MGFFAT54] Processando retorno de pedido " + strzero(_nni,6) + " de " +  strzero(_ntot,6) +;
					 " - " +  (cQryZC5Ret)->ZC5_IDSFA + " - ";
					  + dToC(dDataBase) + " - " + time())

			cC5Fil	:= (cQryZC5Ret)->C5_FILIAL
			cC5Num	:= (cQryZC5Ret)->C5_NUM
			cfilant := alltrim((cQryZC5Ret)->C5_FILIAL)

			oRetSalOrd := nil
			oRetSalOrd := retSalOrde():new()

			oRetSalOrd:setSalesOr()

			nZC5Recno := (cQryZC5Ret)->ZC5RECNO

			lZC5Invali := .F.

			if (cQryZC5Ret)->ZC5_STATUS == "4"
				oRetSalOrd:mensagem			:= allTrim((cQryZC5Ret)->ZC5_OBS)
				oRetSalOrd:mensagemBloqueio	:= allTrim((cQryZC5Ret)->ZC5_OBS)
				oRetSalOrd:status			:= "I"

				lZC5Invali := .T.
		
			endif

			while !(cQryZC5Ret)->(EOF()) .AND.  cC5Fil	== (cQryZC5Ret)->C5_FILIAL .AND.  cC5Num == (cQryZC5Ret)->C5_NUM
				oRetItSO := nil
				oRetItSO := retItemSO():new()

				oRetItSO:setItensSO()

				aadd( oRetSalOrd:itens, oRetItSO )

				(cQryZC5Ret)->( DBSkip() )
				_nni++
	
			enddo

			if !lZC5Invali

				conout("[MGFFAT54] Validando bloqueios de pedido " + strzero(_nni,6) + " de " +  strzero(_ntot,6) +;
				 " - " +  (cQryZC5Ret)->ZC5_IDSFA + " - ";
				  + dToC(dDataBase) + " - " + time())


				getSZV( )

				if (cQrySZVRet)->(EOF())
					oRetSalOrd:mensagem		:= "Pedido de Venda sem bloqueios"
					oRetSalOrd:status	:= "0"

					for nI := 1 to len(oRetSalOrd:itens)
						oRetSalOrd:itens[nI]:statusPedido := "N"
					next
				elseif !(cQrySZVRet)->(EOF())
					oRetSalOrd:mensagem		:= "Pedido de Venda bloqueado"
					oRetSalOrd:status		:= "1"

					for nI := 1 to len(oRetSalOrd:itens)
						oRetSalOrd:itens[nI]:statusPedido := "B"
					next

					while !(cQrySZVRet)->(EOF())

						if (cQrySZVRet)->ZT_TIPO == "1" .OR.  (cQrySZVRet)->ZT_TIPO == "2"
							oRetSalOrd:mensagemBloqueio	+= allTrim( (cQrySZVRet)->ZT_DESCRI ) + chr(13) + chr(10)
						elseif (cQrySZVRet)->ZT_TIPO == "3"
							oRetSalOrd:mensagemBloqueio	+= allTrim( (cQrySZVRet)->C6_ITEM ) + " - " + allTrim( (cQrySZVRet)->ZT_DESCRI ) + chr(13) + chr(10)
						endif

						(cQrySZVRet)->( DBSkip() )
					enddo
				endif

				(cQrySZVRet)->( DBCloseArea() )
			else
				for nI := 1 to len(oRetSalOrd:itens)
					oRetSalOrd:itens[nI]:statusPedido := "I"
				next
			endif


			conout("[MGFFAT54] Enviando retorno de pedido " + strzero(_nni,6) + " de " +  strzero(_ntot,6) +;
					 " - " +  (cQryZC5Ret)->ZC5_IDSFA + " - ";
					  + dToC(dDataBase) + " - " + time())


			oWSSFA := nil
			oWSSFA := MGFINT23():new(cURLPost, oRetSalOrd , nZC5Recno, "ZC5", "ZC5_INTEGR", allTrim(getMv("MGF_SFACOD")) , allTrim(getMv("MGF_SFA22T")) )
			oWSSFA:lLogInCons := .T.
			oWSSFA:sendByHttpPost()

			conout("[MGFFAT54] Enviou retorno de pedido " + strzero(_nni,6) + " de " +  strzero(_ntot,6) +;
					 " - " +  (cQryZC5Ret)->ZC5_IDSFA + " - ";
					  + dToC(dDataBase) + " - " + time())
	
		END SEQUENCE

	enddo

	(cQryZC5Ret)->(DBCloseArea())

	delClassINTF()

return


Class retSalOrde
	Data applicationArea AS ApplicationArea
	Data idsfa AS string
	Data idprotheus AS string
	Data itens AS array
	Data mensagem AS string
	Data status AS string
	Data mensagemBloqueio AS string
	Data statusPedido AS string
	Data statusFaturamento AS string
	Data entregaEnd AS string
	Data entregaCEP AS string
	Data entregaEstado AS string
	Data entregaCidade AS string
	Data filial AS string
	
	Method New()
	Method setSalesOr()
EndClass

Method new() Class retSalOrde
	self:applicationArea	:= ApplicationArea():new()
	self:itens				:= {}
return

Method setSalesOr() Class retSalOrde
	self:idsfa				:= (cQryZC5Ret)->ZC5_IDSFA
	self:idprotheus			:= (cQryZC5Ret)->C5_NUM
	self:mensagem			:= ""
	self:status				:= ""
	self:mensagemBloqueio	:= ""
	self:filial             := (cQryZC5Ret)->ZC5_FILIAL

	self:statusPedido		:= ""
	self:statusFaturamento	:= ""
	self:entregaEnd			:= (cQryZC5Ret)->ENDERECO
	self:entregaCEP			:= (cQryZC5Ret)->CEP
	self:entregaEstado		:= (cQryZC5Ret)->ESTADO
	self:entregaCidade		:= (cQryZC5Ret)->MUNICIPIO
return

Class retItemSO
Data idProduto AS string
	Data dtPedido AS string
	Data centroDistribuicao AS string
	Data bloqueio AS string
	Data statusPedido AS string
	Data statusFaturamento AS string
	Data dtEntrega AS string
	Data qdtItem AS int
	Data unidade AS string
	Data valorContrato AS float
	Data entregaEnd AS string
	Data entregaCEP AS string
	Data entregaEstado AS string
	Data entregaCidade AS string
	Data entregaStatus AS string
	Data idClientesGerais AS string
	Data idVendedor AS string
	Data idNovosPedidos AS string
	Data qtdItemFaturado AS float
	Data nomeProduto AS string
	Data statusDCN AS string
	Data valorNormal AS float
	Data qtdPeca AS int
	Data tipoPedido AS string

	Method new()
	Method setItensSO()
EndClass




Method new( ) Class retItemSO
return

Method setItensSO() Class retItemSO

	self:idProduto			:= (cQryZC5Ret)->C6_PRODUTO

	if (cQryZC5Ret)->ZC5_STATUS <> "4"
		self:dtPedido			:= dToC( sToD( (cQryZC5Ret)->C5_EMISSAO ) )
	elseif (cQryZC5Ret)->ZC5_STATUS == "4"
		self:dtPedido			:= dToC( sToD( left( allTrim( (cQryZC5Ret)->ZC5_IDSFA ), 8 ) ) )
	endif

	self:centroDistribuicao	:= (cQryZC5Ret)->C5_FILIAL
	self:bloqueio			:= 0
	self:statusPedido		:= iif((cQryZC5Ret)->ZC5_STATUS == "4", "I", "")
	self:statusFaturamento	:= ""

	if (cQryZC5Ret)->ZC5_STATUS <> "4"
		self:dtEntrega			:= dToC( sToD( (cQryZC5Ret)->C5_FECENT ) )
	elseif (cQryZC5Ret)->ZC5_STATUS == "4"
		self:dtEntrega			:= dToC( sToD( left( allTrim( (cQryZC5Ret)->ZC5_IDSFA ), 8 ) ) )
	endif

	self:qdtItem			:= (cQryZC5Ret)->C6_QTDVEN
	self:unidade			:= (cQryZC5Ret)->C6_UM
	self:valorContrato		:= 0
	self:entregaEnd			:= getAdvFVal( "SZ9", "Z9_ZENDER"	, xFilial("SZ9") + (cQryZC5Ret)->( C5_CLIENTE + C5_LOJACLI + C5_ZENDER ), 1, "" )
	self:entregaCEP			:= getAdvFVal( "SZ9", "Z9_ZCEP"		, xFilial("SZ9") + (cQryZC5Ret)->( C5_CLIENTE + C5_LOJACLI + C5_ZENDER ), 1, "" )
	self:entregaEstado		:= getAdvFVal( "SZ9", "Z9_ZEST"		, xFilial("SZ9") + (cQryZC5Ret)->( C5_CLIENTE + C5_LOJACLI + C5_ZENDER ), 1, "" )
	self:entregaCidade		:= getAdvFVal( "SZ9", "Z9_ZMUNIC"	, xFilial("SZ9") + (cQryZC5Ret)->( C5_CLIENTE + C5_LOJACLI + C5_ZENDER ), 1, "" )
	self:entregaStatus		:= ""
	self:idClientesGerais	:= (cQryZC5Ret)->A1_CGC
	self:idVendedor			:= (cQryZC5Ret)->C5_VEND1
	self:idNovosPedidos		:= (cQryZC5Ret)->ZC5_IDSFA
	self:qtdItemFaturado	:= (cQryZC5Ret)->ZC6_QTDFAT
	self:nomeProduto		:= (cQryZC5Ret)->DESCPROD
	self:statusDCN			:= iif( (cQryZC5Ret)->C6DELET == "*", "D", "U" )
	self:valorNormal		:= (cQryZC5Ret)->C6_PRCVEN
	self:qtdPeca			:= (cQryZC5Ret)->C6_QTDVEN
	self:tipoPedido			:= (cQryZC5Ret)->C5_ZTIPPED

return

static function getZC5( )
	local cQryZC5	:= ""

	cQryZC5Ret	:= ""
	cQryZC5Ret	:= GetNextAlias()


	cQryZC5 += " SELECT DISTINCT"																				+ chr(13) + chr(10)
	cQryZC5 += "	C5_ZIDEND			, ZC5_STATUS, ZC5_FILIAL				,"								+ chr(13) + chr(10)
	cQryZC5 += "	SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZC5_OBS,2000,1)),1,4000) ZC5_OBS	,"		+ chr(13) + chr(10)
	cQryZC5 += "	NVL(SZ9.Z9_ZCEP		, SA1.A1_CEP)  CEP			,"											+ chr(13) + chr(10)
	cQryZC5 += "	NVL(SZ9.Z9_ZENDER	, SA1.A1_END)  ENDERECO		,"											+ chr(13) + chr(10)
	cQryZC5 += "	NVL(SZ9.Z9_ZEST		, SA1.A1_EST)  ESTADO		,"											+ chr(13) + chr(10)
	cQryZC5 += "	NVL(SZ9.Z9_ZMUNIC	, SA1.A1_MUN)  MUNICIPIO	,"											+ chr(13) + chr(10)
	cQryZC5 += "	ZC5_IDSFA	, ZC5.R_E_C_N_O_ ZC5RECNO,"														+ chr(13) + chr(10)
	cQryZC5 += "	C5_FILIAL	, C5_NUM	, C5_EMISSAO, C5_VEND1	, C5_ZTIPPED	,"							+ chr(13) + chr(10)
	cQryZC5 += "	C5_CLIENTE	, C5_LOJACLI, C5_ZENDER	,"														+ chr(13) + chr(10)
	cQryZC5 += "	C6_PRODUTO	, C5_FECENT, C6_ENTREG	, C6_QTDVEN	, C6_UM		, C6_QTDLIB		, C6_PRCVEN, C6_PRUNIT	,"				+ chr(13) + chr(10)
	cQryZC5 += "	SC6.D_E_L_E_T_ C6DELET	,"	+ chr(13) + chr(10)
	cQryZC5 += "		("																						+ chr(13) + chr(10)
	cQryZC5 += " 			SELECT B1_DESC"																		+ chr(13) + chr(10)
	cQryZC5 += " 			FROM " + retSQLName("SB1") + " SUBSB1"												+ chr(13) + chr(10)
	cQryZC5 += " 			WHERE"																				+ chr(13) + chr(10)
	cQryZC5 += "				SUBSB1.B1_COD		=	SC6.C6_PRODUTO"											+ chr(13) + chr(10)
	cQryZC5 += "			AND	SUBSB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"								+ chr(13) + chr(10)
	cQryZC5 += "			AND	SUBSB1.D_E_L_E_T_	<>	'*'"													+ chr(13) + chr(10)
	cQryZC5 += " 		) DESCPROD,"																			+ chr(13) + chr(10)
	cQryZC5 += " A1_CGC, ZC6_QTDFAT"																						+ chr(13) + chr(10)
	cQryZC5 += " FROM "			+ retSQLName("ZC5") + " ZC5"													+ chr(13) + chr(10)

	cQryZC5 += " INNER JOIN " + retSQLName("ZC6") + " ZC6" 					+ chr(13) + chr(10)
	cQryZC5 += " ON" 														+ chr(13) + chr(10)
	cQryZC5 += "        ZC6.ZC6_IDSFA	=   ZC5.ZC5_IDSFA" 					+ chr(13) + chr(10)
	cQryZC5 += "    AND ZC6.ZC6_FILIAL	=   ZC5.ZC5_FILIAL" 				+ chr(13) + chr(10)
	cQryZC5 += "    AND ZC6.D_E_L_E_T_	=   ' '" 							+ chr(13) + chr(10)

	cQryZC5 += " LEFT JOIN " 	+ retSQLName("SC5") + " SC5"													+ chr(13) + chr(10)
	cQryZC5 += " ON"																							+ chr(13) + chr(10)
	cQryZC5 += " 		ZC5.ZC5_PVPROT	=	SC5.C5_NUM"															+ chr(13) + chr(10)
	cQryZC5 += " 	AND	ZC5.ZC5_FILIAL	=	SC5.C5_FILIAL"														+ chr(13) + chr(10)
	cQryZC5 += " 	AND	SC5.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)
	cQryZC5 += " LEFT JOIN " 	+ retSQLName("SC6") + " SC6"													+ chr(13) + chr(10)
	cQryZC5 += " ON"																							+ chr(13) + chr(10)

	cQryZC5 += " 		ZC6.ZC6_PRODUT					=   SC6.C6_PRODUTO"															+ chr(13) + chr(10)
	cQryZC5 += " 	AND	LPAD(TRIM(ZC6.ZC6_ITEM),2,'0')	=   SC6.C6_ITEM"															+ chr(13) + chr(10)

	cQryZC5 += " 	AND	SC6.C6_NUM		=	SC5.C5_NUM"															+ chr(13) + chr(10)
	cQryZC5 += " 	AND	SC6.C6_FILIAL	=	SC5.C5_FILIAL"														+ chr(13) + chr(10)

	cQryZC5 += " LEFT JOIN "	+ retSQLName("SA1") + " SA1"													+ chr(13) + chr(10)
	cQryZC5 += " ON"																							+ chr(13) + chr(10)
	cQryZC5 += " 		SA1.A1_LOJA		=	SC5.C5_LOJACLI"														+ chr(13) + chr(10)
	cQryZC5 += " 	AND	SA1.A1_COD		=	SC5.C5_CLIENTE"														+ chr(13) + chr(10)
	cQryZC5 += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"											+ chr(13) + chr(10)
	cQryZC5 += " 	AND	SA1.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)

	cQryZC5 += " LEFT JOIN "	+ retSQLName("SZ9") + " SZ9"													+ chr(13) + chr(10)
	cQryZC5 += " ON"																							+ chr(13) + chr(10)
	cQryZC5 += "         SZ9.Z9_ZIDEND   =   SC5.C5_ZIDEND"														+ chr(13) + chr(10)
	cQryZC5 += "     AND SZ9.Z9_ZCGC	=	SA1.A1_CGC"															+ chr(13) + chr(10)
	cQryZC5 += "     AND SZ9.Z9_FILIAL   =   '" + xFilial("SZ9") + "'"											+ chr(13) + chr(10)
	cQryZC5 += "     AND SZ9.D_E_L_E_T_  <>  '*'"																+ chr(13) + chr(10)

	cQryZC5 += " WHERE"																							+ chr(13) + chr(10)
	cQryZC5 += " 		ZC5.ZC5_INTEGR	=	'P' AND ZC5.ZC5_STATUS <> '4' AND ZC5_ORIGEM = '004' "										+ chr(13) + chr(10)

	cQryZC5 += " 	AND	SC5.C5_EMISSAO	>=	'" + dtos(date()-getmv("MGF_FAT541",,10))	+ "'"					+ chr(13) + chr(10)

	cQryZC5 += " 	AND	ZC5.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)

	cQryZC5 += " UNION ALL"																						+ chr(13) + chr(10)

	cQryZC5 += " SELECT DISTINCT"													+ chr(13) + chr(10)
	cQryZC5 += "	' ' C5_ZIDEND				,"									+ chr(13) + chr(10)
	cQryZC5 += "	ZC5_STATUS,ZC5_FILIAL				,"							+ chr(13) + chr(10)
	cQryZC5 += "	SUBSTR(UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZC5_OBS,2000,1)),1,4000) ZC5_OBS	,"	+ chr(13) + chr(10)
	cQryZC5 += "	' ' CEP					,"										+ chr(13) + chr(10)
	cQryZC5 += "	' ' ENDERECO			,"										+ chr(13) + chr(10)
	cQryZC5 += "	' ' ESTADO				,"										+ chr(13) + chr(10)
	cQryZC5 += "	' '	MUNICIPIO			,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC5_IDSFA				,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC5.R_E_C_N_O_ ZC5RECNO	,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC5_FILIAL	C5_FILIAL	,"										+ chr(13) + chr(10)

	cQryZC5 += "	TO_CHAR(ZC5.R_E_C_N_O_) C5_NUM	,"								+ chr(13) + chr(10)
	cQryZC5 += "	' '	C5_EMISSAO			,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC5_VENDED C5_VEND1		,"										+ chr(13) + chr(10)
	cQryZC5 += "	' '	C5_ZTIPPED			,"										+ chr(13) + chr(10)
	cQryZC5 += "	' ' C5_CLIENTE			,"										+ chr(13) + chr(10)
	cQryZC5 += "	' ' C5_LOJACLI			,"										+ chr(13) + chr(10)
	cQryZC5 += "	' ' C5_ZENDER			,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC6_PRODUT C6_PRODUTO	,"										+ chr(13) + chr(10)
	cQryZC5 += "	' ' C5_FECENT, ' ' C6_ENTREG			,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC6_QTDVEN C6_QTDVEN	,"										+ chr(13) + chr(10)
	cQryZC5 += "	'' C6_UM				,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC6_QTDVEN C6_QTDLIB	,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC6_PRCVEN C6_PRCVEN	,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC6_PRCVEN C6_PRUNIT	,"										+ chr(13) + chr(10)
	cQryZC5 += "	' ' C6DELET				,"										+ chr(13) + chr(10)
	cQryZC5 += "	' ' DESCPROD			,"										+ chr(13) + chr(10)
	cQryZC5 += "	ZC5_CLIENT A1_CGC, ZC6_QTDFAT"												+ chr(13) + chr(10)
	cQryZC5 += " FROM "			+ retSQLName("ZC5") + " ZC5"						+ chr(13) + chr(10)
	cQryZC5 += " INNER JOIN " 	+ retSQLName("ZC6") + " ZC6"						+ chr(13) + chr(10)
	cQryZC5 += " ON"																+ chr(13) + chr(10)
	cQryZC5 += " 		ZC5.ZC5_IDSFA	=	ZC6.ZC6_IDSFA"							+ chr(13) + chr(10)
	cQryZC5 += " 	AND	ZC5.ZC5_FILIAL	=	ZC6.ZC6_FILIAL"							+ chr(13) + chr(10)
	cQryZC5 += " 	AND	ZC6.D_E_L_E_T_	<>	'*'"									+ chr(13) + chr(10)

	cQryZC5 += " WHERE"																							+ chr(13) + chr(10)
	cQryZC5 += " 		ZC5.ZC5_INTEGR	=	'P' AND ZC5.ZC5_STATUS = '4' AND ZC5_ORIGEM = '004'"										+ chr(13) + chr(10)

	cQryZC5 += "    AND SUBSTR(ZC5_IDSFA,1,8) >= '" + dtos(date()-getmv("MGF_FAT541",,10))	+ "'"			+ chr(13) + chr(10)

	cQryZC5 += " 	AND	ZC5.D_E_L_E_T_	<>	'*'"																+ chr(13) + chr(10)

	cQryZC5 += " ORDER BY C5_FILIAL, C5_NUM"															+ chr(13) + chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQryZC5), (cQryZC5Ret) , .F. , .T. )
return

static function getSZV( )
	local cQrySZV	:= ""

	cQrySZVRet	:= ""
	cQrySZVRet	:= GetNextAlias()

	cQrySZV += " SELECT ZC5_FILIAL	, ZC5_IDSFA		, ZC5_PVPROT	, ZC5_CLIENT	,"			+ chr(13) + chr(10)
	cQrySZV += " 		C5_FILIAL	, C5_NUM		, C5_EMISSAO	, C5_ZTIPPED	,"			+ chr(13) + chr(10)
	cQrySZV += " 		C5_CLIENTE	, C5_LOJACLI	, C5_ZENDER		, C5_VEND1		,"			+ chr(13) + chr(10)
	cQrySZV += " 		'00' C6_ITEM, '' C6_PRODUTO	, '' C6_ENTREG	, 0 C6_QTDVEN	,"			+ chr(13) + chr(10)
	cQrySZV += " 		'' C6_UM	, 0 C6_PRUNIT	, 0 C6_QTDLIB	,"							+ chr(13) + chr(10)
	cQrySZV += " 		ZT_TIPO		, ZT_DESCRI		, ZV_CODRGA"								+ chr(13) + chr(10)
	cQrySZV += " FROM "			+ retSQLName("ZC5") + " ZC5"									+ chr(13) + chr(10)
	cQrySZV += " INNER JOIN " 	+ retSQLName("SC5") + " SC5"									+ chr(13) + chr(10)
	cQrySZV += " ON"																			+ chr(13) + chr(10)
	cQrySZV += " 		ZC5.ZC5_PVPROT	=	SC5.C5_NUM"											+ chr(13) + chr(10)
	cQrySZV += " 	AND	ZC5.ZC5_FILIAL	=	SC5.C5_FILIAL"										+ chr(13) + chr(10)
	cQrySZV += " 	AND	SC5.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
	cQrySZV += " INNER JOIN "	+ retSQLName("SZV") + " SZV"									+ chr(13) + chr(10)
	cQrySZV += " ON"																			+ chr(13) + chr(10)
	cQrySZV += " 		SZV.ZV_ITEMPED  =   '01'"												+ chr(13) + chr(10)
	cQrySZV += " 	AND SZV.ZV_PEDIDO	=	ZC5.ZC5_PVPROT"										+ chr(13) + chr(10)
	cQrySZV += " 	AND	SZV.ZV_FILIAL	=	ZC5.ZC5_FILIAL"										+ chr(13) + chr(10)
	cQrySZV += " 	AND	SZV.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
	cQrySZV += " INNER JOIN "	+ retSQLName("SZT") + " SZT"									+ chr(13) + chr(10)
	cQrySZV += " ON"																			+ chr(13) + chr(10)
	cQrySZV += " 		SZV.ZV_CODRGA	=	SZT.ZT_CODIGO"										+ chr(13) + chr(10)
	cQrySZV += " 	AND	SZT.ZT_FILIAL	=	'" + xFilial("SZT") + "'"							+ chr(13) + chr(10)
	cQrySZV += " 	AND	SZT.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
	cQrySZV += " WHERE"																			+ chr(13) + chr(10)
	cQrySZV += " 		SZV.ZV_CODAPR	=	' '"												+ chr(13) + chr(10)
	cQrySZV += " 	AND	ZC5.ZC5_IDSFA	=	'" + oRetSalOrd:idsfa + "'"							+ chr(13) + chr(10)
	cQrySZV += " 	AND	ZC5.ZC5_FILIAL	=	'" + oRetSalOrd:filial + "'"						+ chr(13) + chr(10)
	cQrySZV += " 	AND	ZC5.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)

	cQrySZV += " UNION ALL"																		+ chr(13) + chr(10)

	cQrySZV += " SELECT ZC5_FILIAL	, ZC5_IDSFA		, ZC5_PVPROT	, ZC5_CLIENT	,"			+ chr(13) + chr(10)
	cQrySZV += " 		C5_FILIAL	, C5_NUM		, C5_EMISSAO	, C5_ZTIPPED	,"			+ chr(13) + chr(10)
	cQrySZV += " 		C5_CLIENTE	, C5_LOJACLI	, C5_ZENDER		, C5_VEND1		,"			+ chr(13) + chr(10)
	cQrySZV += " 		C6_ITEM		, C6_PRODUTO	, C6_ENTREG		, C6_QTDVEN		,"			+ chr(13) + chr(10)
	cQrySZV += " 		C6_UM		, C6_PRUNIT		, C6_QTDLIB		,"							+ chr(13) + chr(10)
	cQrySZV += " 		ZT_TIPO		, ZT_DESCRI		, ZV_CODRGA"								+ chr(13) + chr(10)
	cQrySZV += " FROM "			+ retSQLName("ZC5") + " ZC5"									+ chr(13) + chr(10)
	cQrySZV += " INNER JOIN " 	+ retSQLName("SC5") + " SC5"									+ chr(13) + chr(10)
	cQrySZV += " ON"																			+ chr(13) + chr(10)
	cQrySZV += " 		ZC5.ZC5_PVPROT	=	SC5.C5_NUM"											+ chr(13) + chr(10)
	cQrySZV += " 	AND	ZC5.ZC5_FILIAL	=	SC5.C5_FILIAL"										+ chr(13) + chr(10)
	cQrySZV += " 	AND	SC5.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
	cQrySZV += " INNER JOIN " 	+ retSQLName("SC6") + " SC6"									+ chr(13) + chr(10)
	cQrySZV += " ON"																			+ chr(13) + chr(10)
	cQrySZV += " 		SC6.C6_NUM		=	SC5.C5_NUM"											+ chr(13) + chr(10)
	cQrySZV += " 	AND	SC6.C6_FILIAL	=	SC5.C5_FILIAL"										+ chr(13) + chr(10)
	cQrySZV += " 	AND	SC6.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
	cQrySZV += " INNER JOIN "	+ retSQLName("SZV") + " SZV"									+ chr(13) + chr(10)
	cQrySZV += " ON"																			+ chr(13) + chr(10)
	cQrySZV += " 		SZV.ZV_ITEMPED  =   SC6.C6_ITEM "										+ chr(13) + chr(10)
	cQrySZV += " 	AND SZV.ZV_PEDIDO	=	ZC5.ZC5_PVPROT"										+ chr(13) + chr(10)
	cQrySZV += " 	AND	SZV.ZV_FILIAL	=	ZC5.ZC5_FILIAL"										+ chr(13) + chr(10)
	cQrySZV += " 	AND	SZV.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
	cQrySZV += " INNER JOIN "	+ retSQLName("SZT") + " SZT"									+ chr(13) + chr(10)
	cQrySZV += " ON"																			+ chr(13) + chr(10)
	cQrySZV += " 		SZV.ZV_CODRGA	=	SZT.ZT_CODIGO"										+ chr(13) + chr(10)
	cQrySZV += " 	AND	SZT.ZT_FILIAL	=	'" + xFilial("SZT") + "'"							+ chr(13) + chr(10)
	cQrySZV += " 	AND	SZT.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)
	cQrySZV += " WHERE"																			+ chr(13) + chr(10)
	cQrySZV += " 		SZV.ZV_CODAPR	=	' '"												+ chr(13) + chr(10)
	cQrySZV += " 	AND	ZC5.ZC5_IDSFA	=	'" + oRetSalOrd:idsfa + "'"							+ chr(13) + chr(10)
	cQrySZV += " 	AND	ZC5.ZC5_FILIAL	=	'" + oRetSalOrd:filial + "'"						+ chr(13) + chr(10)
	cQrySZV += " 	AND	ZC5.D_E_L_E_T_	<>	'*'"												+ chr(13) + chr(10)

	cQrySZV += " ORDER BY C5_FILIAL, C5_NUM, ZT_TIPO, C6_ITEM, ZV_CODRGA"						+ chr(13) + chr(10)

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQrySZV), (cQrySZVRet) , .F. , .T. )

return
