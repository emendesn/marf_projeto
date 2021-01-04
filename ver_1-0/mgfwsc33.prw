#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
	INTEGRACAO E-COMMERCE
	SOMATÓRIA DE ESTOQUE
*/

//-------------------------------------------------------------------
user function MGFWSC33()


	U_MFCONOUT("Iniciando ambiente de exportação de estoques globais para o E-Commerce")

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL '010041'

	runInteg33()

	U_MFCONOUT("Completou exportação de estoques globais para o E-Commerce")

	RESET ENVIRONMENT

return

//-------------------------------------------------------------------
static function runInteg33()

	local cURLPost		:= ""
	local cUpdTbl		:= ""
	local cJson			:= ""
	local nStatuHttp	:= 0
	local aHeadStr		:= {}
	local cHeaderRet	:= ""
	local nTimeOut		:= 120
	local bError 		:= ErrorBlock( { |oError| errorWSC33( oError ) } )

	local cTimeIni		:= ""
	local cTimeFin		:= ""
	local cTimeProc		:= ""

	private oJson		:= nil

	U_MFCONOUT('Carregando produtos para exportar...')
	getStock()

	aadd( aHeadStr, 'Content-Type: application/json')

	_ntot := 0

	while !QRYSB2->(EOF())
		_ntot++
		QRYSB2->(Dbskip())
	enddo

	_nni := 0
	QRYSB2->(Dbgotop())

	while !QRYSB2->(EOF())

			_nni++
			U_MFCONOUT('Exportando estoque global do produto ' + allTrim( QRYSB2->IDPRODUTO ) + " - " + strzero(_nni,6) + " de " + strzero(_ntot,6) + "...")

			oJson := nil
			oJson := JsonObject():new()

			setStock()

			cURLPost	:= ""
			cURLPost	:= allTrim( superGetMv( "MGFECOM27A" , , "http://spdwvapl219:8206/protheusestoque/api/inventario/" ) )
			cURLPost	:= cURLPost + allTrim( QRYSB2->IDPRODUTO )

			cJson		:= ""
			cJson		:= oJson:toJson()

			_nsaldo := val(ojson:GetJsonText("bqtdeestoque"))

			if !empty( cJson )
				cTimeIni	:= time()
				cHeaderRet	:= ""
				httpQuote( cURLPost /*<cUrl>*/, "PUT" /*<cMethod>*/, /*[cGETParms]*/, cJson /*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadStr /*[aHeadStr]*/, cHeaderRet /*[@cHeaderRet]*/ )

				nStatuHttp	:= httpGetStatus()
				cTimeFin	:= time()
				cTimeProc	:= elapTime( cTimeIni, cTimeFin )

				conout(" [E-COM] [MGFWSC33] * * * * * Status da integracao * * * * *")
				conout(" [E-COM] [MGFWSC33] Inicio.......................: " + cTimeIni + " - " + dToC(dDataBase))
				conout(" [E-COM] [MGFWSC33] Fim..........................: " + cTimeFin + " - " + dToC(dDataBase))
				conout(" [E-COM] [MGFWSC33] Tempo de Processamento.......: " + cTimeProc)
				conout(" [E-COM] [MGFWSC33] URL..........................: " + cURLPost)
				conout(" [E-COM] [MGFWSC33] HTTP Method..................: " + "PUT")
				conout(" [E-COM] [MGFWSC33] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) )
				conout(" [E-COM] [MGFWSC33] Envio........................: " + cJson)
				conout(" [E-COM] [MGFWSC33] * * * * * * * * * * * * * * * * * * * * ")

				//Se mandou valor global zerado move o produto para coleção que não aparece na vitrine
				If _nsaldo == 0
					
					SB1->(Dbsetorder(1))
					
					If SB1->(Dbseek(xfilial("SB1")+allTrim( QRYSB2->IDPRODUTO)))

						If SB1->B1_ZCCATEG != '007'

							Reclock("SB1",.F.)
							SB1->B1_XINTECO := ALLTRIM(STR(VAL(SB1->B1_ZCCATEG)))
							SB1->B1_ZCCATEG := '007'
							SB1->(Msunlock())

						Endif

					Endif
				
				//Se mandou valor global maior que  move o produto para coleção que aparece na vitrine
				Elseif _nsaldo > 0 .and. allTrim( QRYSB2->B1_ZCCATEG ) == '007' .and. val(SB1->B1_XINTECO) > 0

					SB1->(Dbsetorder(1))
					
					If SB1->(Dbseek(xfilial("SB1")+allTrim( QRYSB2->IDPRODUTO)))

							Reclock("SB1",.F.)
							SB1->B1_ZCCATEG := strzero(val(SB1->B1_XINTECO),3)
							SB1->(Msunlock())

					Endif

				Endif


	  		endif

			freeObj( oJson )

			QRYSB2->(DBSkip())

	enddo

	QRYSB2->(DBCloseArea())

	delClassINTF()
return

//-------------------------------------------------------
//-------------------------------------------------------
static function errorWSC33(oError)
	local nQtd := MLCount(oError:ERRORSTACK)
	local ni
	local cEr := ''

	for ni:=1 to nQtd
		cEr += memoLine(oError:ERRORSTACK,,ni)
	next ni

	conout( cEr )

	_aErr := { '0', cEr }
return .T.

//----------------------------------------------------------------
// Carrega saldo no objeto
//----------------------------------------------------------------
static function setStock()
	local aRetSaldo		:= {}
	local nPorcEcom		:= superGetMv( "MGFECOM27B" , , 10 )
	local cEcoFilial	:= allTrim( superGetMv( "MFG_ECOFIL" , , "010041;010050" ) )
	local aEcoFilial	:= {}
	local nSumStock		:= 0
	local nI			:= 0

	aEcoFilial := strTokArr( cEcoFilial , ";" )

	for nI := 1 to len( aEcoFilial )
		aRetSaldo := { 0 , 0 }
		aRetSaldo := getSalProt(allTrim( QRYSB2->idproduto ), ""    , aEcoFilial[nI], .T.      ,       , )
	
		if aRetSaldo[1] > 0
			nSumStock += aRetSaldo[1]
		endif
	next

	oJson['bfilial']		:= ""
	oJson['produto']		:= allTrim( QRYSB2->idproduto )

	if nSumStock > 0
		oJson['bqtdeestoque'] := round( ( ( nPorcEcom / 100 ) * nSumStock / QRYSB2->B1_ZPESMED ) , 0 )
	else
		oJson['bqtdeestoque'] := 0
	endif
return

//------------------------------------------------------
// Seleciona produtos em estoque 
//------------------------------------------------------
static function getStock()
	local cQRYSB2		:= ""

	cQRYSB2 := " SELECT DISTINCT DA1_FILIAL, DA1_CODPRO IDPRODUTO, 'EC' idtipopedi, 'N' ZJ_FEFO, COALESCE( B1_ZPESMED, 0 ) B1_ZPESMED, B1_ZCCATEG"						+ CRLF
	cQRYSB2 += " FROM "			+ retSQLName("DA0") + " DA0"					+ CRLF
	cQRYSB2 += " INNER JOIN "	+ retSQLName("DA1") + " DA1"					+ CRLF
	cQRYSB2 += " ON"															+ CRLF
	cQRYSB2 += " 		DA1.DA1_CODTAB	=	DA0.DA0_CODTAB"						+ CRLF
	cQRYSB2 += " 	AND	DA1.DA1_CODPRO	<=	'500000'"							+ CRLF
	cQRYSB2 += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1") + "'"			+ CRLF
	cQRYSB2 += " 	AND	DA1.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQRYSB2 += " INNER JOIN "	+ retSQLName("SB1") + " SB1"					+ CRLF
	cQRYSB2 += " ON"															+ CRLF
	cQRYSB2 += " 		DA1.DA1_CODPRO	=	SB1.B1_COD"							+ CRLF
	cQRYSB2 += " 	AND	SB1.B1_ZPESMED	>	0"									+ CRLF
	cQRYSB2 += " 	AND	SB1.B1_COD		<=	'500000'  "							+ CRLF
	cQRYSB2 += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"			+ CRLF
	cQRYSB2 += " 	AND	DA1.D_E_L_E_T_	<>	'*'"								+ CRLF
	cQRYSB2 += " WHERE"															+ CRLF
	cQRYSB2 += " 		DA0.DA0_XENVEC	=	'1'"								+ CRLF // Envia E-Commerce		-> 0=Nao;1=Sim
	cQRYSB2 += " 	AND	DA0.DA0_XINTEC	=	'1'"								+ CRLF // Integrado E-Commerce	-> 0=Nao;1=Sim
	cQRYSB2 += " 	AND	DA0.DA0_ATIVO	=	'1'"								+ CRLF // 1=Sim;2=Nao
	cQRYSB2 += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial("DA0") + "'"			+ CRLF
	cQRYSB2 += " 	AND	DA1.DA1_PRCVEN	>	1   "	+ CRLF
	cQRYSB2 += " 	AND	DA0.D_E_L_E_T_	<>	'*'"								+ CRLF

	TcQuery cQRYSB2 New Alias "QRYSB2"
return

//------------------------------------------------------
// Retorna saldo do Produto apos consulta com Taura - Pedido deve estar posicionado
// [1] = Saldo (Taura - Protheus)
// [2] = Peso Medio
//------------------------------------------------------
static function getSalProt( cB1Cod, cC5Num, cStockFil, lJobStock, dDtMin, dDtMax, _BlqEst )
	local cQueryProt	:= ""
	local nRetProt		:= 0
	local nRetProt2		:= 0
	local aArea			:= getArea()
	local aAreaSZJ		:= SZJ->(getArea())
	local aAreaSA1		:= SA1->(getArea())
	local aAreaSB1		:= SB1->(getArea())

	local aRet			:= {}
	local aRet2			:= {}
	local nSalProt		:= 0
	local nSalProt2		:= 0
	local nPesoMedio	:= 0
	local aRetStock		:= { 0 , 0 }

	local lRet			:= .F.
	local lFefo			:= .F.

	local nMGFDTMIN		:= 0
	local nMGFDTMAX		:= 0

	local dDataMin		:= CTOD("  /  /  ")
	local dDataMax		:= CTOD("  /  /  ")

	local nDtMin		:= superGetMv("MGF_DTMIN", , 0 )
	local nDtMax		:= superGetMv("MGF_DTMAX", , 0 )

	local nDtMinPr		:= superGetMv( "MGF_MINPR", , 0 )
	local nDtMaxPr		:= superGetMv( "MGF_MAXPR", , 0 )

	default lJobStock	:= .F.
	default cC5Num		:= space(06)
	default cStockFil	:= cFilAnt

	default dDtMin		:= CTOD("  /  /  ")
	default dDtMax		:= CTOD("  /  /  ")
	default _BlqEst		:= .F.

	if !empty( dDtMin )
		dDataMin := dDtMin
	endif

	if !empty( dDtMax )
		dDataMax := dDtMax
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		lFefo := .T.
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			// Para o tipo VE as datas nao importam na consulta ao Taura, mas na conta para debitar Pedidos do Protheus sim
			dDataMin := CTOD("  /  /  ")
			dDataMax := CTOD("  /  /  ")
		elseif QRYSB2->ZJ_FEFO == 'S'
			dDataMin := dDataBase + QRYSB2->ZJ_MINIMO
			dDataMax := dDataBase + QRYSB2->ZJ_MAXIMO
		endif
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			MFWSC33D( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos

			MFWSC33D( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( QRYSB2->idproduto, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			MFWSC33D( @aRet2, cStockFil, QRYSB2->idproduto, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( QRYSB2->idproduto, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	else
		DBSelectArea('SZJ')
		SZJ->(DBSetOrder(1))
		SZJ->(DBSeek(xFilial('SZJ') + SC5->C5_ZTIPPED))

		if SZJ->ZJ_FEFO <> 'S'
			if !empty( dDataMin ) .and. !empty( dDataMax )
				MFWSC33D( @aRet, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

				nRetProt := 0
				nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
				nSalProt := 0
				nSalProt := ( aRet[01] - nRetProt )

				// CASO TENHA PARAMETRIZADO DATA, DEVERA VERIFICAR COM VE SEM DATA
				aRet2 := {0}
				MFWSC33D( @aRet2, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

				nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
				nSalProt2 := ( aRet2[01] - nRetProt2 )

				// SE - 'VE com Data' for maior que 'VE sem Data' - Considera SEM DATA
				//if nSalProt2 > nSalProt
				if nSalProt > nSalProt2
					aRet := {}
					aRet := aClone( aRet2 )

					dDataMin := CTOD("  /  /  ")
					dDataMax := CTOD("  /  /  ")
				endif

			else
				MFWSC33D( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )
			endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos
			MFWSC33D( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			MFWSC33D( @aRet2, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	endif

	if aRet[2] > 0
		nPesoMedio := ( aRet[1] / aRet[2] )
	endif

	nRetProt := 0
	nSalProt := 0
	nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	nSalProt := ( aRet[01] - nRetProt )
	qTaura   := aRet[01]
	restArea(aAreaSB1)
	restArea(aAreaSA1)
	restArea(aAreaSZJ)
	restArea(aArea)

	aRetStock := { nSalProt, nPesoMedio }
return aRetStock

//------------------------------------------------------------
// Retorna o saldo de Pedidos
//------------------------------------------------------------
static function getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	local nSaldoPV		:= 0
	local cQueryProt	:= ""
	local cQryPv		:= getNextAlias()


	// a query abaixo para trazer o saldo que o Protheus tem de pedidos, por produto
	// desconsidera o pedido que está sendo manipulado no momento ou analisado
	// mas considera todos os pedidos que estão com bloqueio seja de estoque o não no sistema
	// gerando erro. Criado um parametro no final para informar se deve ou não descosiderar
	// pedidos com bloqueio de estoque.

	cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
	cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "

	cQueryProt  += " WHERE"
	cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
	cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
	cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
	cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
	cQueryProt  += "  	AND C6_NOTA			=	'         '"
	cQueryProt  += "  	AND C6_BLQ			<>	'R'"

	if !empty( cC5Num )
		cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		cQueryProt  += " AND"
		cQueryProt  += "     ("
		cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "         OR"
		cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "     )"
	endif

	tcQuery cQueryProt New Alias (cQryPv)

	if !(cQryPv)->(EOF())
		nSaldoPV := (cQryPv)->SALDO
	endif

	If Select(cQryPv) > 0
		(cQryPv)->(DBCloseArea())
	EndIf

	// agora processo o saldo de pedidos que estão com bloqueio de estoque
	// e desconto essa quantidade na quantidade de pedido que a query anterior trouxe pois havia contemplado
	// erroneamente todos os pedidos mesmos os que estão com bloqueio de estoque

	if _BlqEst
		cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
		cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SZV") + " SZV ON SZV.ZV_FILIAL = C5.C5_FILIAL AND SZV.ZV_PEDIDO = C5.C5_NUM AND SZV.D_E_L_E_T_ = ' ' AND SZV.ZV_CODRGA IN ('000011') AND SZV.ZV_ITEMPED = C6.C6_ITEM "
		cQueryProt  += " WHERE"
		cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
		cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
		cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
		cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
		cQueryProt  += "  	AND C6_NOTA			=	'         '"
		cQueryProt  += "  	AND C6_BLQ			<>	'R'"
		cQueryProt  += "  	AND C5.C5_ZBLQRGA = 'B' "
		cQueryProt  += "  	AND SZV.ZV_CODAPR = ' ' "
		if !empty( cC5Num )
			cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
		endif

		if !empty( dDataMin ) .and. !empty( dDataMax )
			cQueryProt  += " AND"
			cQueryProt  += "     ("
			cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "         OR"
			cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "     )"
		endif

		tcQuery cQueryProt New Alias (cQryPv)

		if !(cQryPv)->(EOF())
			nSaldoPV := nSaldoPV - (cQryPv)->SALDO
		endif

		If Select(cQryPv) > 0
			(cQryPv)->(DBCloseArea())
		EndIf
	ENDIF

return nSaldoPV

/*
=====================================================================================
Programa.:              MFWSC33D
Autor....:              Josué Danich Prestes
Data.....:              18/11/2019
Descricao / Objetivo:   Consulta de resposta de estoque assincrono na tabela ZFP
=====================================================================================
*/
Static Function MFWSC33D(xRet,xFilProd,xProd,xFEFO,xDTInicial,xDTFinal)
              //MFWSC33D( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

Local _aRet  := {0,0,0,0,0,"","",""}
Local _lret := .T.

If xFEFO
	_ctipo := "F"
Else
	_ctipo := "N"
Endif

//Verifica se tem resposta válida nos últimos 60 minutos
cQryZFQ := " select R_E_C_N_O_ AS REC FROM " + retsqlname("ZFQ") + " where d_e_l_e_t_ <> '*' and "
cQryZFQ += " ZFQ_PROD = '" + alltrim(xProd) + "' AND ZFQ_FILIAL = '" + xFilProd + "' and "
cQryZFQ += " ZFQ_STATUS = 'C' AND ZFQ_TIPOCO = '" + _ctipo + "' and " 
cQryZFQ += " ZFQ_DTRESP = '" + dtos(date()) + "' AND ZFQ_SECMID >= " + alltrim(str(seconds() - 3600)) 

If xFEFO

    cQryZFQ += " AND ZFQ_DTVALI = '" + dtos(xDTInicial) + "' AND ZFQ_DTVALF = '" + dtos(xDTFinal) + "'"

Endif

cQryZFQ += " ORDER BY  ZFQ_DTRESP,ZFQ_HRRESP DESC"

TcQuery cQryZFQ New Alias "QRYZFQ"


If !(QRYZFQ->(EOF()))

    //Retorna resposta válida
	ZFQ->(Dbgoto(QRYZFQ->REC))
	_aRet  := {ZFQ->ZFQ_ESTOQU,ZFQ->ZFQ_CAIXAS,ZFQ->ZFQ_PECAS ,0,ZFQ->ZFQ_PESO,ZFQ->ZFQ_SOLENV,ZFQ->ZFQ_UUID,ZFQ->ZFQ_RESREC}

Else

    //Retorna erro de consulta
	_aRet  := {0,0,0,0,0,"","",""}
	_lret := .F.

Endif

Dbselectarea("QRYZFQ")
Dbclosearea()

xret := _aret

Return _lret
