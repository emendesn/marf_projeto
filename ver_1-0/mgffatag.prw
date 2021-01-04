#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
-----------------------------------------------------
	Chamado pelo PE M460FIM

	Atualiza o Titulo gerado na SE1 com os dados especifcos de uma compra feita no e-commerce
-----------------------------------------------------
*/
user function MGFFATAG()

	if FieldPos("F2_XINTECO") > 0
		chkECOM()
	endif
return

//-----------------------------------------------------------
// Verifica se a Nota gerada é de E-Commerce
//-----------------------------------------------------------
static function chkECOM()
	local cQrySF2		:= ""
	local lRetSF2		:= .F.
	local aAreaX		:= getArea()
	local aAreaZE6		:= ZE6->(getArea())
	local cUpdZE6		:= ""
	local cUpdSE1		:= ""
	local cNaturezE1	:= allTrim( superGetMv( "MGFNATECOM", , "" ) )

	cQrySF2 := "SELECT DISTINCT"																			+ CRLF

	cQrySF2 += " F2_FILIAL					, F2_DOC		, F2_SERIE		, F2_CLIENTE	, F2_LOJA	,"	+ CRLF
	cQrySF2 += " F2_EMISSAO					,"																+ CRLF
	cQrySF2 += " C5_NUM						, C5_ZIDECOM	, C5_ZNSU		,"								+ CRLF
	cQrySF2 += " E1_PREFIXO					, E1_NUM		, E1_LOJA		, E1_CLIENTE	, E1_PARCELA,"	+ CRLF
	cQrySF2 += " E1_VENCTO					, E1_VENCREA	, E1_VENCREA	, E1_TIPO		, E1_VALOR	,"	+ CRLF
	cQrySF2 += " ZEC_DIAS					, ZEC_TAXA		, ZEC_VENCTO	,"								+ CRLF
	cQrySF2 += " SE1.R_E_C_N_O_ SE1RECNO	,"																+ CRLF
	cQrySF2 += " ZE6.R_E_C_N_O_ ZE6RECNO"																	+ CRLF

	cQrySF2 += " FROM "			+ retSQLName("SF2") + " SF2"							+ CRLF
	cQrySF2 += " INNER JOIN "	+ retSQLName("SD2") + " SD2"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SD2.D2_SERIE	=	SF2.F2_SERIE"								+ CRLF
	cQrySF2 += "	AND	SD2.D2_DOC		=	SF2.F2_DOC"									+ CRLF
	cQrySF2 += "	AND	SD2.D2_FILIAL	=	'" + xFilial("SD2") + "'"					+ CRLF
	cQrySF2 += "	AND	SD2.D_E_L_E_T_	<>	'*'"										+ CRLF
	cQrySF2 += " INNER JOIN "	+ retSQLName("SC5") + " SC5"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SC5.C5_ZIDECOM	<>	' '"										+ CRLF
	cQrySF2 += "	AND	SD2.D2_PEDIDO	=	SC5.C5_NUM"									+ CRLF
	cQrySF2 += "	AND	SC5.C5_FILIAL	=	'" + xFilial("SC5") + "'"					+ CRLF
	cQrySF2 += "	AND	SC5.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("SA1") + " SA1"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SA1.A1_LOJA		=	SF2.F2_LOJA"								+ CRLF
	cQrySF2 += "	AND	SA1.A1_COD		=	SF2.F2_CLIENTE"								+ CRLF
	cQrySF2 += "	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"					+ CRLF
	cQrySF2 += "	AND	SA1.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " INNER JOIN "	+ retSQLName("SE1") + " SE1"							+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += "		SE1.E1_TIPO		=	'NF'"										+ CRLF
	cQrySF2 += "	AND	SE1.E1_PREFIXO	=	SF2.F2_SERIE"								+ CRLF
	cQrySF2 += "	AND	SE1.E1_NUM		=	SF2.F2_DOC"									+ CRLF
	cQrySF2 += "	AND	SE1.E1_LOJA		=	SF2.F2_LOJA"								+ CRLF
	cQrySF2 += "	AND	SE1.E1_CLIENTE	=	SF2.F2_CLIENTE"								+ CRLF
	cQrySF2 += "	AND	SE1.E1_FILIAL	=	'" + xFilial("SE1") + "'"					+ CRLF
	cQrySF2 += "	AND	SE1.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " LEFT JOIN " + retSQLName("ZE6") + " ZE6"								+ CRLF // ZE6 - DEVE ESTAR COM LEFT JOIN - POIS TITULO PODE SER DE BOLETO
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += " 		ZE6.ZE6_LOJACL	=	SF2.F2_LOJA"								+ CRLF
	cQrySF2 += " 	AND	ZE6.ZE6_CLIENT	=	SF2.F2_CLIENTE"								+ CRLF
	cQrySF2 += " 	AND	ZE6.ZE6_NSU		=	SC5.C5_ZNSU"								+ CRLF
	cQrySF2 += " 	AND	ZE6.ZE6_FILIAL	=	'" + xFilial("ZE6")		+ "'"				+ CRLF
	cQrySF2 += " 	AND	ZE6.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " LEFT JOIN " + retSQLName("ZEC") + " ZEC"								+ CRLF
	cQrySF2 += " ON"																	+ CRLF
	cQrySF2 += " 		ZEC.ZEC_CODIGO	=	ZE6.ZE6_CODADM"								+ CRLF
	cQrySF2 += " 	AND	ZEC.ZEC_FILIAL	=	'" + xFilial("ZEC")		+ "'"				+ CRLF
	cQrySF2 += " 	AND	ZEC.D_E_L_E_T_	<>	'*'"										+ CRLF

	cQrySF2 += " WHERE"																	+ CRLF
	cQrySF2 += " 		SF2.F2_LOJA		=	'" + SF2->F2_LOJA		+ "'"				+ CRLF
	cQrySF2 += " 	AND	SF2.F2_CLIENTE	=	'" + SF2->F2_CLIENTE	+ "'"				+ CRLF
	cQrySF2 += " 	AND	SF2.F2_SERIE	=	'" + SF2->F2_SERIE		+ "'"				+ CRLF
	cQrySF2 += " 	AND	SF2.F2_DOC		=	'" + SF2->F2_DOC		+ "'"				+ CRLF
	cQrySF2 += " 	AND	SF2.F2_FILIAL	=	'" + xFilial("SF2")		+ "'"				+ CRLF
	cQrySF2 += " 	AND	SF2.D_E_L_E_T_	<>	'*'"										+ CRLF

	conout( "[E-COM] [MGFFATAG] [chkECOM] " + CRLF + cQrySF2 )

	tcQuery cQrySF2 New Alias "QRYSF2"

	if !QRYSF2->(EOF())
		lRetSF2 := .T.

		recLock( "SF2", .F. )
			SF2->F2_XINTECO := "0"
		SF2->( msUnlock() )

		ecomXC5( xFilial("SC5"), QRYSF2->C5_NUM )

		if !empty( QRYSF2->C5_ZNSU )
			nValorSE1 := 0
			nValorSE1 := ( QRYSF2->E1_VALOR - ( QRYSF2->E1_VALOR * ( QRYSF2->ZEC_TAXA / 100 ) ) ) // Valor Liquido (Valor do Titulo menos a taxa)

			cUpdZE6	:= ""

			cUpdZE6 := "UPDATE " + retSQLName("ZE6")																				+ CRLF
			cUpdZE6 += "	SET"																									+ CRLF
			cUpdZE6 += " 		ZE6_STATUS	=	'1'																		,"			+ CRLF // 0-Caução / 1-Título Gerado / 2-Título Baixado / 3-Erro
			cUpdZE6 += " 		ZE6_NOTA	=	'" + QRYSF2->F2_DOC												+ "'	,"			+ CRLF
			cUpdZE6 += " 		ZE6_SERIE	=	'" + QRYSF2->F2_SERIE											+ "'	,"			+ CRLF
			cUpdZE6 += " 		ZE6_DTNOTA	=	'" + QRYSF2->F2_EMISSAO											+ "'	,"			+ CRLF
			cUpdZE6 += " 		ZE6_VALEFE	=	" + str( nValorSE1 )											+ "	,"			+ CRLF
			cUpdZE6 += " 		ZE6_VALREA	=	" + str( QRYSF2->E1_VALOR )										+ "	,"			+ CRLF // Valor Real [descontando a taxa da administradora financeira]			
			cUpdZE6 += " 		ZE6_VENCTO	=	'" + dToS( sToD( QRYSF2->F2_EMISSAO ) + QRYSF2->ZEC_DIAS )						+ "'	,"			+ CRLF
			cUpdZE6 += " 		ZE6_VENCRE	=	'" + dToS( dataValida( sToD( QRYSF2->F2_EMISSAO ) + QRYSF2->ZEC_DIAS , .T. ) )	+ "'	,"			+ CRLF
			cUpdZE6 += " 		ZE6_OBS		=	'Título Gerado'															,"			+ CRLF
			cUpdZE6 += " 		ZE6_PREFIX	=	'" + QRYSF2->E1_PREFIXO											+ "'	,"			+ CRLF
			cUpdZE6 += " 		ZE6_TITULO	=	'" + QRYSF2->E1_NUM												+ "'	,"			+ CRLF
			cUpdZE6 += " 		ZE6_PARCEL	=	'" + QRYSF2->E1_PARCELA											+ "'	,"			+ CRLF
			cUpdZE6 += " 		ZE6_TIPO	=	'CC'"																				+ CRLF
			cUpdZE6 += " WHERE"																+ CRLF
			cUpdZE6 += " 		R_E_C_N_O_ = " + allTrim( str( QRYSF2->ZE6RECNO ) ) + ""	+ CRLF

			if tcSQLExec( cUpdZE6 ) < 0
				conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
			endif

			cUpdSE1	:= ""

			cUpdSE1 := "UPDATE " + retSQLName("SE1")																					+ CRLF
			cUpdSE1 += "	SET"																										+ CRLF
			cUpdSE1 += " 		E1_TIPO		=	'CC'															,"							+ CRLF
			cUpdSE1 += " 		E1_NATUREZ	=	'"	+ cNaturezE1				+ "'							,"							+ CRLF

			// Bruto
			cUpdSE1 += " 		E1_VLRREAL	=	"	+ str( QRYSF2->E1_VALOR )			+ "								,"							+ CRLF // valor da venda (sem o desconto da taxa)

			// Liquido
			cUpdSE1 += " 		E1_VALOR	=	"	+ str( nValorSE1 )	+ "								,"							+ CRLF // valor da venda descontada o percentual da taxa da administradora
			cUpdSE1 += " 		E1_VALLIQ	=	"	+ str( nValorSE1 )	+ "								,"							+ CRLF // valor da venda descontada o percentual da taxa da administradora
			cUpdSE1 += " 		E1_VLCRUZ	=	"	+ str( nValorSE1 )	+ "								,"							+ CRLF // valor da venda descontada o percentual da taxa da administradora

			cUpdSE1 += " 		E1_VENCTO	=	'"	+ dToS( sToD( QRYSF2->F2_EMISSAO ) + QRYSF2->ZEC_DIAS )	+ "'	,"					+ CRLF // data faturamento + Dias de Vencimento (ZEC_VENCTO)
			cUpdSE1 += " 		E1_VENCREA	=	'"	+ dToS( dataValida( sToD( QRYSF2->F2_EMISSAO ) + QRYSF2->ZEC_DIAS , .T. ) )	+ "',"	+ CRLF // Vencimento real (dia util) ?
			cUpdSE1 += " 		E1_ZPEDIDO	=	'"	+ allTrim( QRYSF2->C5_NUM )	+ "',"													+ CRLF
			cUpdSE1 += " 		E1_ZNSU		=	'"	+ allTrim( QRYSF2->C5_ZNSU )	+ "'"													+ CRLF
			cUpdSE1 += " WHERE"																											+ CRLF
			cUpdSE1 += " 		R_E_C_N_O_ = " + allTrim( str( QRYSF2->SE1RECNO ) ) + ""												+ CRLF

			if tcSQLExec( cUpdSE1 ) < 0
				conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
			endif
		else
			cUpdSE1	:= ""

			cUpdSE1 := "UPDATE " + retSQLName("SE1")										+ CRLF
			cUpdSE1 += "	SET"															+ CRLF
			//cUpdSE1 += " 		E1_TIPO		=	'BOL',"										+ CRLF
			cUpdSE1 += " 		E1_NATUREZ	=	'" + cNaturezE1	+ "',"						+ CRLF
			cUpdSE1 += " 		E1_ZPEDIDO	=	'" + allTrim( QRYSF2->C5_NUM )	+ "'"		+ CRLF
			cUpdSE1 += " WHERE"																+ CRLF
			cUpdSE1 += " 		R_E_C_N_O_ = " + allTrim( str( QRYSF2->SE1RECNO ) ) + ""	+ CRLF

			if tcSQLExec( cUpdSE1 ) < 0
				conout( "Não foi possível executar UPDATE." + CRLF + tcSqlError() )
			endif
		endif
	endif

	QRYSF2->(DBCloseArea())

	restArea( aAreaZE6 )
	restArea( aAreaX )
return lRetSF2

//-----------------------------------------------------------------
// Atualiza XC5 para Tracking do E-Commerce
//-----------------------------------------------------------------
static function ecomXC5( cFilPed, cPedidoXC5 )
	local cUpdXC5 := ""

	cUpdXC5 := "UPDATE " + retSQLName("XC5")
	cUpdXC5 += " SET "
	cUpdXC5 += "	XC5_INTEGR = 'P'"
	cUpdXC5 += " WHERE"
	cUpdXC5 += "		XC5_FILIAL	=	'" + cFilPed	+ "'"
	cUpdXC5 += "	AND	XC5_PVPROT	=	'" + cPedidoXC5	+ "'"
	cUpdXC5 += "	AND	D_E_L_E_T_	<>	'*'"

	tcSQLExec( cUpdXC5 )
return