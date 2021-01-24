#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

user function MGFFAT68()
	local cQrySC5		:= ""
	local aRet			:= {}
	local nPVBloq		:= 0
	local aItemLib		:= {}
	local nSaldoProd	:= 0
	local aArea			:= getArea()
	local aAreaSC5		:= SC5->(getArea())
	local cStockUsr		:= allTrim(getMv("MGF_FAT68A"))

	if !( retCodUsr() $ cStockUsr )
		msgAlert("Usuário sem permissão para liberar estoque!")
		return
	endif

	DBSelectArea("SC5")

	cQrySC5 += " SELECT"																						+ CRLF
	cQrySC5 += " SC5.R_E_C_N_O_ C5RECNO, C5_FILIAL, C5_NUM, C5_ZTIPPED, C6_PRODUTO, C6_ZDTMIN, C6_ZDTMAX, C6_QTDVEN, C6_QTDENT, ZV_CODRGA, C6_ITEM"	+ CRLF
	cQrySC5 += " FROM "			+ retSQLName("SC5") + " SC5"													+ CRLF
	cQrySC5 += " INNER JOIN "	+ retSQLName("SC6") + " SC6"													+ CRLF
	cQrySC5 += " ON"																							+ CRLF
	cQrySC5 += "		SC6.C6_NUM		=	SC5.C5_NUM"															+ CRLF
	cQrySC5 += " 	AND	SC6.C6_FILIAL	=	SC5.C5_FILIAL"														+ CRLF
	cQrySC5 += " 	AND	SC6.D_E_L_E_T_	<>	'*'"																+ CRLF
	cQrySC5 += " INNER JOIN "	+ retSQLName("SZV") + " SZV"													+ CRLF
	cQrySC5 += " ON"																							+ CRLF
	cQrySC5 += "		SZV.ZV_CODRJC	=	'      '"															+ CRLF
	cQrySC5 += "	AND	SZV.ZV_CODAPR	=	'      '"															+ CRLF
	cQrySC5 += "	AND	SZV.ZV_CODRGA	=	'000011'"															+ CRLF
	cQrySC5 += "	AND	SZV.ZV_ITEMPED	=	SC6.C6_ITEM"														+ CRLF
	cQrySC5 += "	AND	SZV.ZV_PEDIDO	=	SC5.C5_NUM"															+ CRLF
	cQrySC5 += " 	AND	SZV.ZV_FILIAL	=	SC5.C5_FILIAL"														+ CRLF
	cQrySC5 += " 	AND	SZV.D_E_L_E_T_	<>	'*'"																+ CRLF
	cQrySC5 += " WHERE"																							+ CRLF
	cQrySC5 += " "																								+ CRLF
	cQrySC5 += " 		SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'"											+ CRLF
	cQrySC5 += " 	AND	SC5.D_E_L_E_T_	<>	'*'"																+ CRLF
	cQrySC5 += " ORDER BY C5_NUM, C6_ITEM"																		+ CRLF

	memoWrite( "C:\TEMP\MGFCRM68.SQL", cQrySC5 )

	tcQuery cQrySC5 New Alias "QRYSC5"

	if !QRYSC5->(EOF())
		while !QRYSC5->(EOF())
			SC5->( DBGoTo( QRYSC5->C5RECNO ) )

			aRetSaldo := { 0 , 0 }
			aRetSaldo := (getSalProt, QRYSC5->C6_PRODUTO, SC5->C5_NUM, SC5->C5_FILIAL, .F., QRYSC5->C6_ZDTMIN, QRYSC5->C6_ZDTMAX )

			if aRetSaldo[1] >= ( QRYSC5->C6_QTDVEN - QRYSC5->C6_QTDENT )
				aItemLib := { { QRYSC5->C5_FILIAL, QRYSC5->C5_NUM, QRYSC5->C6_ITEM, QRYSC5->ZV_CODRGA } }

				staticCall( MGFFAT64, aprovaPv, .T., aItemLib )
			endif

			QRYSC5->(DBSkip())
		enddo

		QRYSC5->(DBCloseArea())

		staticCall( MGFFAT64, buscaPV )
	else
		msgAlert("Nenhum Pedido com bloqueio de estoque encontrado!")
	endif

	if select("QRYSC5") > 0
		QRYSC5->(DBCloseArea())
	endif

	restArea(aAreaSC5)
	restArea(aArea)
return

//Funções antigas mantidas para retrocompatibilidade com fontes que fazem callstatic:
// MGFFAT16, MGFFAT68, MGFLIBPD, MGFWSC27, MGFWSC33
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
			U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos

			U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( QRYSB2->idproduto, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			U_MGFTAE21( @aRet2, cStockFil, QRYSB2->idproduto, .T., dDataMin, dDataMax )

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
				U_MGFTAE21( @aRet, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

				nRetProt := 0
				nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
				nSalProt := 0
				nSalProt := ( aRet[01] - nRetProt )

				// CASO TENHA PARAMETRIZADO DATA, DEVERA VERIFICAR COM VE SEM DATA
				aRet2 := {0}
				U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

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
				U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )
			endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos
			U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

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
	Conout("Parametros enviado para a função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )
	nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	nSalProt := ( aRet[01] - nRetProt )
	qTaura   := aRet[01]
	restArea(aAreaSB1)
	restArea(aAreaSA1)
	restArea(aAreaSZJ)
	restArea(aArea)

	aRetStock := { nSalProt, nPesoMedio }
	Conout("[MGFWSC05] - Resuldado da funcao getSalProt: Saldo: "+ Alltrim(Transform(nSalProt,"@E 999,999,999.9999")) + " Peso Medio: "+ Alltrim(Transform(nPesoMedio,"@E 999,999,999.9999")) )
return aRetStock


//------------------------------------------------------------
// Retorna o saldo de Pedidos
//------------------------------------------------------------
static function getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )

	local nSaldoPV		:= 0
	local cQueryProt	:= ""
	local cQryPv		:= getNextAlias()

	Conout("Parametros recebido na função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )

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

	Conout("[MGFWSC05] - Roda Query funcao getSaldoPv: "+ cQueryProt )
	tcQuery cQueryProt New Alias (cQryPv)

	if !(cQryPv)->(EOF())
		nSaldoPV := (cQryPv)->SALDO
	endif

	If Select(cQryPv) > 0
		(cQryPv)->(DBCloseArea())
	EndIf
	Conout("[MGFWSC05] - Resuldado da Query funcao getSaldoPv saldo pvs: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )

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

		Conout("[MGFWSC05] - Roda Query funcao getSaldoPv: "+ cQueryProt )
		tcQuery cQueryProt New Alias (cQryPv)

		if !(cQryPv)->(EOF())
			nSaldoPV := nSaldoPV - (cQryPv)->SALDO
		endif

		If Select(cQryPv) > 0
			(cQryPv)->(DBCloseArea())
		EndIf
		Conout("[MGFWSC05] - Resuldado da Query funcao getSaldoPv - saldos bloqueados: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )
	ENDIF

return nSaldoPV
