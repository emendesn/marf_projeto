#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#DEFINE CRLF		chr(13) + chr(10)

/*/{Protheus.doc} MGFEEC67

Exibe as Despesas de Pré Cálculo para a EXP corrente

@type function
@author TOTVS
@since JUNHO/2019
@version P12
/*/
user function MGFEEC67()
	local	cDespFrete	:= allTrim( superGetMv( "MGF_EEC67A", , "416,419" ) )
	private aExps		:= {}
	private aDespes		:= {}
	private aDespesLan	:= {}
	private aCamposObr	:= { "xEETDOCTO" , "xC7XSERIE" , "xC7XESPECI" , "xC7XOPER" , "xEETDESADI" , "xEETVALORR" , "xEETDTVENC" , "xEETNATURE" , "xEETZCCUST" , "xEETZITEMD" , "xEETZNFORN" , "xZEETIPODE" , "xY5COD" }
	private lWeston		:= .F.
	private lFobFob		:= .F.

	fwMsgRun(, { || getExps() }		, "Verificando EXPs"					, "Aguarde. Selecionando EXPs..." )

	while !QRYEXP->(EOF())
		if QRYEXP->EEC_INCOTE == "FOB" .and. QRYEXP->EEC_INCO2 == "CFR"
			// Caso seja Weston somente lançar os Pedidos de Compra
			// Não serão lançados Pré Nota de Entrada e Financeiro
			lWeston := .T.
		elseif QRYEXP->EEC_INCOTE == "FOB" .and. QRYEXP->EEC_INCO2 == "FOB"
			// Não permite o lançamento de frete
			lFobFob := .T.
		endif

		aadd( aExps, {	QRYEXP->EEC_FILIAL																	,;	//[01]
						QRYEXP->EEC_PEDREF																	,;	//[02]
						QRYEXP->EEC_IMPORT																	,;	//[03]
						QRYEXP->EEC_IMLOJA																	,;	//[04]
						QRYEXP->EEC_IMPODE																	,;	//[05]
						QRYEXP->EEC_ORIGEM																	,;	//[06]
						GetAdvFVal("SY9" , "Y9_DESCR"	, xFilial("SY9") + QRYEXP->EEC_ORIGEM	, 2 , "")	,;	//[07]
						QRYEXP->EEC_DEST																	,;	//[08]
						GetAdvFVal("SY9" , "Y9_DESCR"	, xFilial("SY9") + QRYEXP->EEC_DEST		, 2 , "")	,;	//[09]
						QRYEXP->EEC_ZARMAD																	,;	//[10]
						GetAdvFVal("SY5" , "Y5_NOME"	, xFilial("SY5") + QRYEXP->EEC_ZARMAD	, 1 , "")	,;	//[11]
						GetAdvFVal("SY5" , "Y5_FORNECE"	, xFilial("SY5") + QRYEXP->EEC_ZARMAD	, 1 , "")	,;	//[12]
						GetAdvFVal("SY5" , "Y5_LOJAF"	, xFilial("SY5") + QRYEXP->EEC_ZARMAD	, 1 , "")	,;	//[13]
						QRYEXP->EEC_XAGEMB																	,;	//[14]
						GetAdvFVal("SY5" , "Y5_NOME"	, xFilial("SY5") + QRYEXP->EEC_XAGEMB	, 1 , "")	,;	//[15]
						GetAdvFVal("SY5" , "Y5_FORNECE"	, xFilial("SY5") + QRYEXP->EEC_XAGEMB	, 1 , "")	,;	//[16]
						GetAdvFVal("SY5" , "Y5_LOJAF"	, xFilial("SY5") + QRYEXP->EEC_XAGEMB	, 1 , "")	,;	//[17]
						QRYEXP->EEC_TERMIN																	,;	//[18]
						GetAdvFVal("SY5" , "Y5_NOME"	, xFilial("SY5") + QRYEXP->EEC_TERMIN	, 1 , "")	,;	//[19]
						GetAdvFVal("SY5" , "Y5_FORNECE"	, xFilial("SY5") + QRYEXP->EEC_TERMIN	, 1 , "")	,;	//[20]
						GetAdvFVal("SY5" , "Y5_LOJAF"	, xFilial("SY5") + QRYEXP->EEC_TERMIN	, 1 , "")	,;	//[21]
						QRYEXP->EEC_REDEX																	,;	//[22]
						GetAdvFVal("SY5" , "Y5_NOME"	, xFilial("SY5") + QRYEXP->EEC_REDEX	, 1 , "")	,;	//[23]
						GetAdvFVal("SY5" , "Y5_FORNECE"	, xFilial("SY5") + QRYEXP->EEC_REDEX	, 1 , "")	,;	//[24]
						GetAdvFVal("SY5" , "Y5_LOJAF"	, xFilial("SY5") + QRYEXP->EEC_REDEX	, 1 , "")	} )	//[25]

		QRYEXP->(DBSkip())
	enddo

	QRYEXP->(DBCloseArea())

	fwMsgRun(, { || getDesp() }		, "Verificando despesas"				, "Aguarde. Selecionando despesas de Pré Cálculo..." )

	while !QRYZED->(EOF())

		if lFobFob .and. QRYZED->ZEE_CODDES $ cDespFrete
			QRYZED->(DBSkip())
			loop
		endif

		aadd( aDespes, {	QRYZED->ZEE_CODDES																											,; //[01] - "Despesa"
							QRYZED->YB_DESCR																											,; //[02] - "Descrição"
							QRYZED->ZEE_CODIGO																											,; //[03] - "Tabela Pré Cálculo"
							QRYZED->ZEE_MOEDA																											,; //[04] - "Moeda Pré Cálculo"
							iif( QRYZED->ZEE_TIPODE == "D" .and. QRYZED->ZEE_FATOR > 0 , calcDesp( QRYZED->ZEE_CODDES , , QRYZED->ZEE_MOEDA ) , QRYZED->ZEE_VALOR * len( aExps ) )	,; //[05] - "Valor Pré Cálculo"
							space( tamSx3("E2_NUM")[1] )																								,; //[06] - "Documento"
							space( tamSx3("F1_SERIE")[1] )																								,; //[07] - "Série"
							space( tamSx3("F1_ESPECIE")[1] )																							,; //[08] - "Espécie"
							space( tamSx3("D1_OPER")[1] )																								,; //[09] - "Operação"
							cToD("//")																													,; //[10] - "Emissão"
							cToD("//")																													,; //[11] - "Emissão Certificado"
							iif( QRYZED->ZEE_TIPODE == "D" .and. QRYZED->ZEE_FATOR > 0 , calcDesp( QRYZED->ZEE_CODDES , , QRYZED->ZEE_MOEDA ) , QRYZED->ZEE_VALOR * len( aExps ) )	,; //[12] - "Valor Documento"
							space( tamSx3("EET_ZMOED")[1] )																								,; //[13] - "Moeda"
							0																															,; //[14] - "Taxa Neg."
							0																															,; //[15] - "Valor Moeda"
							cToD("//")																													,; //[16] - "Vencimento"
							getAdvFVal( "SYB" , "YB_NATURE" , xFilial("SYB") + QRYZED->ZEE_CODDES , 1 , "")												,; //[17] - "Natureza"
							space( tamSx3("EET_PREFIX")[1] )																							,; //[18] - "Prefixo"
							"2404"																														,; //[19] - "Centro Custo"
							"12"																														,; //[20] - "Item Ctb.Deb"
							space( tamSx3("EET_ZNFORN")[1] )																							,; //[21] - "NF FORNEC"
							space( tamSx3("EET_ZOBS")[1] )																								,; //[22] - "Observação"
							QRYZED->ZEE_TIPODE /*space( tamSx3("ZEE_TIPODE")[1] )*/																		,; //[23] - "Tipo Despesa"
							iif( QRYZED->ZEE_TIPODE == "A" , aExps[ 1 , 10 ] , aExps[ 1 , 14 ] ) 														,; //[24] - "Fornecedor"
							iif( QRYZED->ZEE_TIPODE == "A" , aExps[ 1 , 11 ] , aExps[ 1 , 15 ] ) 														}) //[25] - "Desc. Fornecedor"

		QRYZED->(DBSkip())
	enddo

	QRYZED->( DBCloseArea() )

	fwMsgRun(, { || getDespLan() }	, "Verificando despesas já lançadas"	, "Aguarde. Selecionando histórico de lançamento..." )

	while !QRYHIST->(EOF())
		aadd( aDespesLan, {	QRYHIST->EET_DESPES				,;
							QRYHIST->YB_DESCR				,;
							QRYHIST->EET_XTABPR				,;
							QRYHIST->EET_XMOEPR				,;
							QRYHIST->EET_XPRECA				,;
							QRYHIST->EET_DOCTO				,;
							""								,;
							""								,;
							""								,;
							sToD( QRYHIST->EET_DESADI )		,;
							QRYHIST->EET_VALORR				,;
							QRYHIST->EET_ZMOED				,;
							QRYHIST->EET_ZTX				,;
							QRYHIST->EET_ZVLMOE				,;
							sToD( QRYHIST->EET_DTVENC )		,;
							QRYHIST->EET_NATURE				,;
							QRYHIST->EET_PREFIX				,;
							QRYHIST->EET_ZCCUST				,;
							QRYHIST->EET_ZITEMD				,;
							QRYHIST->EET_ZNFORN } )
		QRYHIST->(DBSkip())
	enddo

	QRYHIST->(DBCloseArea())

	if !empty(aDespes)
		showDespes()
	else
		msgAlert("Não foram encontrados Despesas de Pré Cálculo.")
	endif
return

//-----------------------------------------
// Seleciona EXPs
//-----------------------------------------
static function getExps()
	local cQryEXP := ""

	cQryEXP := "SELECT "												+ CRLF
	cQryEXP += " EEC_FILIAL	,"											+ CRLF
	cQryEXP += " EEC_PEDREF	,"											+ CRLF
	cQryEXP += " EEC_IMPORT	,"											+ CRLF
	cQryEXP += " EEC_IMLOJA	,"											+ CRLF
	cQryEXP += " EEC_IMPODE	,"											+ CRLF
	cQryEXP += " EEC_ORIGEM	,"											+ CRLF
	cQryEXP += " EEC_ORIGEM	,"											+ CRLF
	cQryEXP += " EEC_DEST	,"											+ CRLF
	cQryEXP += " EEC_ZARMAD	,"											+ CRLF
	cQryEXP += " EEC_INCOTE	,"											+ CRLF
	cQryEXP += " EEC_INCO2	,"											+ CRLF
	cQryEXP += " EEC_XAGEMB	,"											+ CRLF
	cQryEXP += " EEC_TERMIN	,"											+ CRLF
	cQryEXP += " EEC_REDEX"												+ CRLF
	cQryEXP += " FROM "	+ retSQLName("EEC") + " EEC"					+ CRLF
	cQryEXP += " WHERE"													+ CRLF
	cQryEXP += " 		EEC.EEC_ZOK		=	'" + oBrowse:Mark()	+ "'"	+ CRLF
	cQryEXP += " 	AND	EEC.EEC_ZUMARK	=	'" + RetCodUsr()	+ "'"	+ CRLF
	cQryEXP += " 	AND	EEC.D_E_L_E_T_	<>	'*'"						+ CRLF

	tcQuery cQryEXP New Alias "QRYEXP"
return

//-----------------------------------------
// Seleciona despesas
//-----------------------------------------
static function getDesp( cDespesa )
	local	cQryZED		:= ""
	default	cDespesa	:= ""

	if nParamOpc == 1 // LANÇAMENTO DE DESPESAS DE ARMADORES
		// 1º SELECT - ORIGEM + DESTINO + ARMADOR
		cQryZED := "SELECT ZEE_CODDES, YB_DESCR, ZEE_VALOR, ZEE_MOEDA, ZEE_CODIGO, ZEE_TIPODE, ZEE_FATOR , ZEE_FATOR2 , ZEE_CORTEP"						+ CRLF
		cQryZED += " FROM "			+ retSQLName("ZED") + " ZED"				+ CRLF
		cQryZED += " INNER JOIN "	+ retSQLName("ZEE") + " ZEE"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		ZEE.ZEE_ARMADO	=	'" + EEC->EEC_ZARMAD	+ "'"	+ CRLF // Despesas Vinculadas com ARMADOR
		cQryZED += " 	AND	ZEE.ZEE_TIPODE	=	'A'"							+ CRLF // A=Armador;D=Despachante;T=Terminal
		cQryZED += " 	AND	ZEE.ZEE_DESTIN	=	'" + EEC->EEC_DEST		+ "'"	+ CRLF
		cQryZED += " 	AND	ZEE.ZEE_ORIGEM	=	'" + EEC->EEC_ORIGEM	+ "'"	+ CRLF // Despesas Vinculadas com ORIGEM VS DESTINO
		cQryZED += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"					+ CRLF
		cQryZED += " 	AND	ZEE.ZEE_FILIAL	=	'" + xFilial("ZEE")		+ "'"	+ CRLF
		cQryZED += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"							+ CRLF

		if !empty( cDespesa )
			cQryZED += " 	AND	ZEE.ZEE_CODDES	=	'" + cDespesa	+ "'"		+ CRLF
		endif

		cQryZED += " INNER JOIN "	+ retSQLName("EYG") + " EYG"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		EYG.EYG_XTIPO	=	ZEE.ZEE_TIPOPR"					+ CRLF // Tipo Produto - Refeer / Dry
		cQryZED += " 	AND	EYG.EYG_COMCON	=	ZED.ZED_TAMCON"					+ CRLF // Tamanho do container
		cQryZED += " 	AND	EYG.EYG_CODCON	=	'" + EEC->EEC_ZCONTA	+ "'"	+ CRLF // EEC_ZCONTA - Container com dados de Tipo de Produto e Tamanho
		cQryZED += " 	AND	EYG.EYG_FILIAL	=	'" + xFilial("EYG")		+ "'"	+ CRLF
		cQryZED += " 	AND	EYG.D_E_L_E_T_	<>	'*'"							+ CRLF
		cQryZED += " INNER JOIN "	+ retSQLName("SYB") + " SYB"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		ZEE.ZEE_CODDES	=	SYB.YB_DESP"					+ CRLF
		cQryZED += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"	+ CRLF
		cQryZED += " 	AND	SYB.D_E_L_E_T_	<>	'*'"							+ CRLF
		cQryZED += " WHERE"																		+ CRLF
		cQryZED += " 		'" + dToS( EEC->EEC_ZDTSNA ) + "'	>=	ZED.ZED_DTINIC"				+ CRLF
		cQryZED += " 	AND	'" + dToS( EEC->EEC_ZDTSNA ) + "'	<=	ZED.ZED_DTFIM"				+ CRLF
		cQryZED += " 	AND	ZED.ZED_FILIAL						=	'" + xFilial("ZED") + "'"	+ CRLF
		cQryZED += " 	AND	ZED.D_E_L_E_T_						<>	'*'"						+ CRLF

		cQryZED += " UNION ALL"																	+ CRLF

		// 2º SELECT - ORIGEM BRANCO + DESTINO BRANCO + ARMADOR
		cQryZED += " SELECT ZEE_CODDES, YB_DESCR, ZEE_VALOR, ZEE_MOEDA, ZEE_CODIGO, ZEE_TIPODE, ZEE_FATOR , ZEE_FATOR2 , ZEE_CORTEP"				+ CRLF
		cQryZED += " FROM "			+ retSQLName("ZED") + " ZED"				+ CRLF
		cQryZED += " INNER JOIN "	+ retSQLName("ZEE") + " ZEE"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		ZEE.ZEE_ARMADO	=	'" + EEC->EEC_ZARMAD	+ "'"	+ CRLF // Despesas Vinculadas com ARMADOR
		cQryZED += " 	AND	ZEE.ZEE_TIPODE	=	'A'"							+ CRLF // A=Armador;D=Despachante;T=Terminal
		cQryZED += " 	AND	ZEE.ZEE_DESTIN	=	' '"							+ CRLF // DESTINO EM BRANCO
		cQryZED += " 	AND	ZEE.ZEE_ORIGEM	=	' '"							+ CRLF // ORIGEM EM BRANCO
		cQryZED += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"					+ CRLF
		cQryZED += " 	AND	ZEE.ZEE_FILIAL	=	'" + xFilial("ZEE")		+ "'"	+ CRLF
		cQryZED += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"							+ CRLF

		if !empty( cDespesa )
			cQryZED += " 	AND	ZEE.ZEE_CODDES	=	'" + cDespesa	+ "'"		+ CRLF
		endif

		cQryZED += " INNER JOIN "	+ retSQLName("EYG") + " EYG"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		EYG.EYG_XTIPO	=	ZEE.ZEE_TIPOPR"					+ CRLF // Tipo Produto - Refeer / Dry
		cQryZED += " 	AND	EYG.EYG_COMCON	=	ZED.ZED_TAMCON"					+ CRLF // Tamanho do container
		cQryZED += " 	AND	EYG.EYG_CODCON	=	'" + EEC->EEC_ZCONTA	+ "'"	+ CRLF // EEC_ZCONTA - Container com dados de Tipo de Produto e Tamanho
		cQryZED += " 	AND	EYG.EYG_FILIAL	=	'" + xFilial("EYG")		+ "'"	+ CRLF
		cQryZED += " 	AND	EYG.D_E_L_E_T_	<>	'*'"							+ CRLF

		cQryZED += " INNER JOIN "	+ retSQLName("SYB") + " SYB"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		ZEE.ZEE_CODDES	=	SYB.YB_DESP"					+ CRLF
		cQryZED += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"	+ CRLF
		cQryZED += " 	AND	SYB.D_E_L_E_T_	<>	'*'"							+ CRLF

		cQryZED += " WHERE"																+ CRLF
		cQryZED += " 		'" + dToS( EEC->EEC_ZDTSNA ) + "'	>=	ZED.ZED_DTINIC"				+ CRLF
		cQryZED += " 	AND	'" + dToS( EEC->EEC_ZDTSNA ) + "'	<=	ZED.ZED_DTFIM"				+ CRLF
		cQryZED += " 	AND	ZED.ZED_FILIAL						=	'" + xFilial("ZED") + "'"	+ CRLF
		cQryZED += " 	AND	ZED.D_E_L_E_T_						<>	'*'"						+ CRLF

		cQryZED += " UNION ALL"													+ CRLF

		// 3º SELECT - ORIGEM + DESTINO BRANCO + ARMADOR
		cQryZED += " SELECT ZEE_CODDES, YB_DESCR, ZEE_VALOR, ZEE_MOEDA, ZEE_CODIGO, ZEE_TIPODE, ZEE_FATOR , ZEE_FATOR2 , ZEE_CORTEP"					+ CRLF
		cQryZED += " FROM "			+ retSQLName("ZED") + " ZED"				+ CRLF
		cQryZED += " INNER JOIN "	+ retSQLName("ZEE") + " ZEE"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		ZEE.ZEE_ARMADO	=	'" + EEC->EEC_ZARMAD	+ "'"	+ CRLF // Despesas Vinculadas com ARMADOR
		cQryZED += " 	AND	ZEE.ZEE_TIPODE	=	'A'"							+ CRLF // A=Armador;D=Despachante;T=Terminal
		cQryZED += " 	AND	ZEE.ZEE_DESTIN	=	' '"							+ CRLF // DESTINO EM BRANCO
		cQryZED += " 	AND	ZEE.ZEE_ORIGEM	=	'" + EEC->EEC_ORIGEM	+ "'"	+ CRLF // Despesas Vinculadas com ORIGEM
		cQryZED += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"					+ CRLF
		cQryZED += " 	AND	ZEE.ZEE_FILIAL	=	'" + xFilial("ZEE")		+ "'"	+ CRLF
		cQryZED += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"							+ CRLF

		if !empty( cDespesa )
			cQryZED += " 	AND	ZEE.ZEE_CODDES	=	'" + cDespesa	+ "'"		+ CRLF
		endif

		cQryZED += " INNER JOIN "	+ retSQLName("EYG") + " EYG"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		EYG.EYG_XTIPO	=	ZEE.ZEE_TIPOPR"					+ CRLF // Tipo Produto - Refeer / Dry
		cQryZED += " 	AND	EYG.EYG_COMCON	=	ZED.ZED_TAMCON"					+ CRLF // Tamanho do container
		cQryZED += " 	AND	EYG.EYG_CODCON	=	'" + EEC->EEC_ZCONTA	+ "'"	+ CRLF // EEC_ZCONTA - Container com dados de Tipo de Produto e Tamanho
		cQryZED += " 	AND	EYG.EYG_FILIAL	=	'" + xFilial("EYG")		+ "'"	+ CRLF
		cQryZED += " 	AND	EYG.D_E_L_E_T_	<>	'*'"							+ CRLF

		cQryZED += " INNER JOIN "	+ retSQLName("SYB") + " SYB"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		ZEE.ZEE_CODDES	=	SYB.YB_DESP"					+ CRLF
		cQryZED += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"	+ CRLF
		cQryZED += " 	AND	SYB.D_E_L_E_T_	<>	'*'"							+ CRLF

		cQryZED += " WHERE"																+ CRLF
		cQryZED += " 		'" + dToS( EEC->EEC_ZDTSNA ) + "'	>=	ZED.ZED_DTINIC"				+ CRLF
		cQryZED += " 	AND	'" + dToS( EEC->EEC_ZDTSNA ) + "'	<=	ZED.ZED_DTFIM"				+ CRLF
		cQryZED += " 	AND	ZED.ZED_FILIAL						=	'" + xFilial("ZED") + "'"	+ CRLF
		cQryZED += " 	AND	ZED.D_E_L_E_T_						<>	'*'"						+ CRLF

		cQryZED += " UNION ALL"													+ CRLF

		// 4º SELECT - ORIGEM BRANCO + DESTINO + ARMADOR
		cQryZED += " SELECT ZEE_CODDES, YB_DESCR, ZEE_VALOR, ZEE_MOEDA, ZEE_CODIGO, ZEE_TIPODE, ZEE_FATOR , ZEE_FATOR2 , ZEE_CORTEP"					+ CRLF
		cQryZED += " FROM "			+ retSQLName("ZED") + " ZED"				+ CRLF
		cQryZED += " INNER JOIN "	+ retSQLName("ZEE") + " ZEE"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		ZEE.ZEE_ARMADO	=	'" + EEC->EEC_ZARMAD	+ "'"	+ CRLF // Despesas Vinculadas com ARMADOR
		cQryZED += " 	AND	ZEE.ZEE_TIPODE	=	'A'"							+ CRLF // A=Armador;D=Despachante;T=Terminal
		cQryZED += " 	AND	ZEE.ZEE_DESTIN	=	'" + EEC->EEC_DEST		+ "'"	+ CRLF // Despesas Vinculadas com BRANCO
		cQryZED += " 	AND	ZEE.ZEE_ORIGEM	=	' '"							+ CRLF // ORIGEM EM BRANCO
		cQryZED += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"					+ CRLF
		cQryZED += " 	AND	ZEE.ZEE_FILIAL	=	'" + xFilial("ZEE")		+ "'"	+ CRLF
		cQryZED += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"							+ CRLF

		if !empty( cDespesa )
			cQryZED += " 	AND	ZEE.ZEE_CODDES	=	'" + cDespesa	+ "'"		+ CRLF
		endif

		cQryZED += " INNER JOIN "	+ retSQLName("EYG") + " EYG"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		EYG.EYG_XTIPO	=	ZEE.ZEE_TIPOPR"					+ CRLF // Tipo Produto - Refeer / Dry
		cQryZED += " 	AND	EYG.EYG_COMCON	=	ZED.ZED_TAMCON"					+ CRLF // Tamanho do container
		cQryZED += " 	AND	EYG.EYG_CODCON	=	'" + EEC->EEC_ZCONTA	+ "'"	+ CRLF // EEC_ZCONTA - Container com dados de Tipo de Produto e Tamanho
		cQryZED += " 	AND	EYG.EYG_FILIAL	=	'" + xFilial("EYG")		+ "'"	+ CRLF
		cQryZED += " 	AND	EYG.D_E_L_E_T_	<>	'*'"							+ CRLF

		cQryZED += " INNER JOIN "	+ retSQLName("SYB") + " SYB"				+ CRLF
		cQryZED += " ON"														+ CRLF
		cQryZED += " 		ZEE.ZEE_CODDES	=	SYB.YB_DESP"					+ CRLF
		cQryZED += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"	+ CRLF
		cQryZED += " 	AND	SYB.D_E_L_E_T_	<>	'*'"							+ CRLF

		cQryZED += " WHERE"																+ CRLF
		cQryZED += " 		'" + dToS( EEC->EEC_ZDTSNA ) + "'	>=	ZED.ZED_DTINIC"				+ CRLF
		cQryZED += " 	AND	'" + dToS( EEC->EEC_ZDTSNA ) + "'	<=	ZED.ZED_DTFIM"				+ CRLF
		cQryZED += " 	AND	ZED.ZED_FILIAL						=	'" + xFilial("ZED") + "'"	+ CRLF
		cQryZED += " 	AND	ZED.D_E_L_E_T_						<>	'*'"						+ CRLF

	elseif nParamOpc == 2 // LANÇAMENTO DE DESPESAS DE DESPACHANTES
		// 5º SELECT - DESPACHANTE + PAIS + DESPACHANTE BRANCO
		cQryZED += "SELECT ZEE_CODDES, YB_DESCR, ZEE_VALOR, ZEE_MOEDA, ZEE_CODIGO, ZEE_TIPODE, ZEE_FATOR , ZEE_FATOR2 , ZEE_CORTEP"				+ CRLF
		cQryZED += " FROM "			+ retSQLName("ZED") + " ZED"								+ CRLF
		cQryZED += " INNER JOIN "	+ retSQLName("ZEE") + " ZEE"								+ CRLF
		cQryZED += " ON"																		+ CRLF
		cQryZED += " 		ZEE.ZEE_DESPAC	=	' '"											+ CRLF // Despesas Vinculadas com Despachante
		cQryZED += " 	AND ZEE.ZEE_PAIS	=	'" + EEC->EEC_PAISET	+ "'"					+ CRLF // Pais
		cQryZED += " 	AND	ZEE.ZEE_TIPODE	=	'D'"											+ CRLF // A=Armador;D=Despachante;T=Terminal
		cQryZED += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"									+ CRLF
		cQryZED += " 	AND	ZEE.ZEE_FILIAL	=	'" + xFilial("ZEE")		+ "'"					+ CRLF
		cQryZED += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"											+ CRLF

		if !empty( cDespesa )
			cQryZED += " 	AND	ZEE.ZEE_CODDES	=	'" + cDespesa	+ "'"						+ CRLF
		endif

		cQryZED += " INNER JOIN "	+ retSQLName("SYB") + " SYB"								+ CRLF
		cQryZED += " ON"																		+ CRLF
		cQryZED += " 		ZEE.ZEE_CODDES	=	SYB.YB_DESP"									+ CRLF
		cQryZED += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"					+ CRLF
		cQryZED += " 	AND	SYB.D_E_L_E_T_	<>	'*'"											+ CRLF

		cQryZED += " WHERE"																		+ CRLF
		cQryZED += " 		'" + dToS( EEC->EEC_ZDTSNA ) + "'	>=	ZED.ZED_DTINIC"				+ CRLF
		cQryZED += " 	AND	'" + dToS( EEC->EEC_ZDTSNA ) + "'	<=	ZED.ZED_DTFIM"				+ CRLF
		cQryZED += " 	AND	ZED.ZED_FILIAL						=	'" + xFilial("ZED") + "'"	+ CRLF
		cQryZED += " 	AND	ZED.D_E_L_E_T_						<>	'*'"						+ CRLF

		cQryZED += " UNION ALL"													+ CRLF

		// 6º SELECT - DESPACHANTE + PAIS BRANCO + DESPACHANTE
		cQryZED += "SELECT ZEE_CODDES, YB_DESCR, ZEE_VALOR, ZEE_MOEDA, ZEE_CODIGO, ZEE_TIPODE, ZEE_FATOR , ZEE_FATOR2 , ZEE_CORTEP"				+ CRLF
		cQryZED += " FROM "			+ retSQLName("ZED") + " ZED"								+ CRLF
		cQryZED += " INNER JOIN "	+ retSQLName("ZEE") + " ZEE"								+ CRLF
		cQryZED += " ON"																		+ CRLF
		cQryZED += " 		ZEE.ZEE_DESPAC	=	'" + EEC->EEC_XAGEMB	+ "'"					+ CRLF // Despesas Vinculadas com Despachante
		cQryZED += " 	AND ZEE.ZEE_PAIS	=	' '"											+ CRLF // Pais
		cQryZED += " 	AND	ZEE.ZEE_TIPODE	=	'D'"											+ CRLF // A=Armador;D=Despachante;T=Terminal
		cQryZED += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"									+ CRLF
		cQryZED += " 	AND	ZEE.ZEE_FILIAL	=	'" + xFilial("ZEE")		+ "'"					+ CRLF
		cQryZED += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"											+ CRLF

		if !empty( cDespesa )
			cQryZED += " 	AND	ZEE.ZEE_CODDES	=	'" + cDespesa	+ "'"						+ CRLF
		endif

		cQryZED += " INNER JOIN "	+ retSQLName("SYB") + " SYB"								+ CRLF
		cQryZED += " ON"																		+ CRLF
		cQryZED += " 		ZEE.ZEE_CODDES	=	SYB.YB_DESP"									+ CRLF
		cQryZED += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"					+ CRLF
		cQryZED += " 	AND	SYB.D_E_L_E_T_	<>	'*'"											+ CRLF

		cQryZED += " WHERE"																		+ CRLF
		cQryZED += " 		'" + dToS( EEC->EEC_ZDTSNA ) + "'	>=	ZED.ZED_DTINIC"				+ CRLF
		cQryZED += " 	AND	'" + dToS( EEC->EEC_ZDTSNA ) + "'	<=	ZED.ZED_DTFIM"				+ CRLF
		cQryZED += " 	AND	ZED.ZED_FILIAL						=	'" + xFilial("ZED") + "'"	+ CRLF
		cQryZED += " 	AND	ZED.D_E_L_E_T_						<>	'*'"						+ CRLF
	endif

	// Xº SELECT - TERMINAIS
	// cQryZED += "SELECT ZEE_CODDES, YB_DESCR, ZEE_VALOR, ZEE_MOEDA, ZEE_CODIGO, ZEE_TIPODE, ZEE_FATOR , ZEE_FATOR2 , ZEE_CORTEP"						+ CRLF
	// cQryZED += " FROM "			+ retSQLName("ZED") + " ZED"										+ CRLF
	// cQryZED += " INNER JOIN "	+ retSQLName("ZEE") + " ZEE"										+ CRLF
	// cQryZED += " ON"																				+ CRLF
	// cQryZED += " 		ZEE.ZEE_TERMIN	IN	('" + EEC->EEC_TERMIN + "' , '" + EEC->EEC_REDEX + "')"	+ CRLF // Despesas Vinculadas com Terminal ou REDEX
	// cQryZED += " 	AND	ZEE.ZEE_TIPODE	=	'T'"													+ CRLF // A=Armador;D=Despachante;T=Terminal
	// cQryZED += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"											+ CRLF
	// cQryZED += " 	AND	ZEE.ZEE_FILIAL	=	'" + xFilial("ZEE")		+ "'"							+ CRLF
	// cQryZED += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"													+ CRLF

	// if !empty( cDespesa )
	// 	cQryZED += " 	AND	ZEE.ZEE_CODDES	=	'" + cDespesa	+ "'"						+ CRLF
	// endif

	// cQryZED += " INNER JOIN "	+ retSQLName("SYB") + " SYB"								+ CRLF
	// cQryZED += " ON"																		+ CRLF
	// cQryZED += " 		ZEE.ZEE_CODDES	=	SYB.YB_DESP"									+ CRLF
	// cQryZED += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"					+ CRLF
	// cQryZED += " 	AND	SYB.D_E_L_E_T_	<>	'*'"											+ CRLF

	// cQryZED += " WHERE"																		+ CRLF
	// cQryZED += " 		'" + dToS( EEC->EEC_ZDTSNA ) + "'	>=	ZED.ZED_DTINIC"				+ CRLF
	// cQryZED += " 	AND	'" + dToS( EEC->EEC_ZDTSNA ) + "'	<=	ZED.ZED_DTFIM"				+ CRLF
	// cQryZED += " 	AND	ZED.ZED_FILIAL						=	'" + xFilial("ZED") + "'"	+ CRLF
	// cQryZED += " 	AND	ZED.D_E_L_E_T_						<>	'*'"						+ CRLF

	memoWrite( "C:\TEMP\MGFEEC67.SQL", cQryZED )

	tcQuery cQryZED New Alias "QRYZED"
return

//------------------------------------------------------
// Marca os produtos para venda ou transferencia
//------------------------------------------------------
static function showDespes()
	local aSeek			:= {}
	local oDlgDespes	:= nil
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	local bOk			:= { || iif( chkAllOk() , fwMsgRun(, { || U_MGFEEC68( lWeston ) , oDlgDespes:end()  }, "Incluindo Pedido de Compra / Nota de Entrada", "Aguarde. Incluindo Pedido de Compra /  Nota de Entrada..." ) , ) }
	local bClose		:= { || oDlgDespes:end() }

	private oFWLayer	:= nil
	private oExpsBrw	:= nil
	private oDespesBrw	:= nil
	private oHistorBrw	:= nil

	private xC7XSERIE	:= space( tamSx3("C7_XSERIE")[1] )
	private xC7XESPECI	:= space( tamSx3("C7_XESPECI")[1] )
	private xC7XOPER	:= space( tamSx3("C7_XOPER")[1] )
	private xEETDESPES	:= space( tamSx3("EET_DESPES")[1] )
	private xValPreCal	:= 0
	private xEETDOCTO	:= space( tamSx3("EET_DOCTO")[1] )
	private xEETDESADI	:= cToD("//")
	private xEETVALORR	:= 0
	private xEETZMOED	:= space( tamSx3("EET_ZMOED")[1] )
	private xEETZTX		:= 0
	private xEETZVLMOE	:= 0
	private xEETDTVENC	:= cToD("//")
	private xEETNATURE	:= space( tamSx3("EET_NATURE")[1] )
	private xEETPREFIX	:= space( tamSx3("EET_PREFIX")[1] )
	private xEETZCCUST	:= space( tamSx3("EET_ZCCUST")[1] )
	private xEETZITEMD	:= space( tamSx3("EET_ZITEMD")[1] )
	private xEETZNFORN	:= space( tamSx3("EET_ZNFORN")[1] )
	private xZEETIPODE	:= space( tamSx3("ZEE_TIPODE")[1] )
	private xY5COD		:= space( tamSx3("Y5_COD")[1] )
	private xY5NOME		:= space( tamSx3("Y5_NOME")[1] )
	private xEETZOBS	:= space( tamSx3("EET_ZOBS")[1] )

	DEFINE MSDIALOG oDlgDespes TITLE 'Despesas de Pré Cálculo' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL STYLE DS_MODALFRAME
		oFWLayer := FWLayer():New()
		oFWLayer:Init( oDlgDespes /*oOwner*/, .F. /*lCloseBtn*/)

		oFWLayer:AddLine( 'UP'		/*cID*/, 35 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'MIDDLE'	/*cID*/, 35 /*nPercHeight*/, .F. /*lFixed*/)
		oFWLayer:AddLine( 'DOWN'	/*cID*/, 30 /*nPercHeight*/, .F. /*lFixed*/)

		oFWLayer:AddCollumn( 'ALLUP'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'UP'		/*cIDLine*/)
		oFWLayer:AddCollumn( 'ALLMD'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'MIDDLE'	/*cIDLine*/)
		oFWLayer:AddCollumn( 'ALLDW'	/*cID*/, 100 /*nPercWidth*/, .T. /*lFixed*/, 'DOWN'		/*cIDLine*/)

		oPanelUp	:= oFWLayer:GetColPanel( 'ALLUP', 'UP'		)
		oPanelMd	:= oFWLayer:GetColPanel( 'ALLMD', 'MIDDLE'	)
		oPanelDw	:= oFWLayer:GetColPanel( 'ALLDW', 'DOWN'	)

		// Browse de cima com as EXPs selecionadas
		oExpsBrw := fwBrowse():New()
		oExpsBrw:setDataArray()
		oExpsBrw:setArray( aExps )
		oExpsBrw:disableConfig()
		oExpsBrw:disableReport()
		oExpsBrw:setOwner( oPanelUp )

		oExpsBrw:addColumn({"Filial"				, { || aExps[oExpsBrw:nAt,01] }, "C", pesqPict("EEC","EEC_FILIAL")	, 1, tamSx3("EEC_FILIAL")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"EXP"					, { || aExps[oExpsBrw:nAt,02] }, "C", pesqPict("EEC","EEC_PEDREF")	, 1, tamSx3("EEC_PEDREF")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Código Imp."			, { || aExps[oExpsBrw:nAt,03] }, "C", pesqPict("EEC","EEC_IMPORT")	, 1, tamSx3("EEC_IMPORT")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Loja Imp."				, { || aExps[oExpsBrw:nAt,04] }, "C", pesqPict("EEC","EEC_IMLOJA")	, 1, tamSx3("EEC_IMLOJA")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Importador"			, { || aExps[oExpsBrw:nAt,05] }, "C", pesqPict("EEC","EEC_IMPODE")	, 1, tamSx3("EEC_IMPODE")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Cód. Origem"			, { || aExps[oExpsBrw:nAt,06] }, "C", pesqPict("EEC","EEC_ORIGEM")	, 1, tamSx3("EEC_ORIGEM")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Origem"				, { || aExps[oExpsBrw:nAt,07] }, "C", pesqPict("SY9","Y9_DESCR")	, 1, tamSx3("Y9_DESCR")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Cód Destino"			, { || aExps[oExpsBrw:nAt,08] }, "C", pesqPict("EEC","EEC_DEST")	, 1, tamSx3("EEC_DEST")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Destino"				, { || aExps[oExpsBrw:nAt,09] }, "C", pesqPict("SY9","Y9_DESCR")	, 1, tamSx3("Y9_DESCR")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Cód. Armador"			, { || aExps[oExpsBrw:nAt,10] }, "C", pesqPict("SY5","Y5_COD")		, 1, tamSx3("Y5_COD")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"Armador"				, { || aExps[oExpsBrw:nAt,11] }, "C", pesqPict("SY5","Y5_NOME")		, 1, tamSx3("Y5_NOME")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"Armador Fornec."		, { || aExps[oExpsBrw:nAt,12] }, "C", pesqPict("SY5","Y5_FORNECE")	, 1, tamSx3("Y5_FORNECE")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Armador Loja"			, { || aExps[oExpsBrw:nAt,13] }, "C", pesqPict("SY5","Y5_LOJAF")	, 1, tamSx3("Y5_LOJAF")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Cód. Despachante"		, { || aExps[oExpsBrw:nAt,14] }, "C", pesqPict("SY5","Y5_COD")		, 1, tamSx3("Y5_COD")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"Despachante"			, { || aExps[oExpsBrw:nAt,15] }, "C", pesqPict("SY5","Y5_NOME")		, 1, tamSx3("Y5_NOME")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"Despachante Fornec."	, { || aExps[oExpsBrw:nAt,16] }, "C", pesqPict("SY5","Y5_FORNECE")	, 1, tamSx3("Y5_FORNECE")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Despachante Loja"		, { || aExps[oExpsBrw:nAt,17] }, "C", pesqPict("SY5","Y5_LOJAF")	, 1, tamSx3("Y5_LOJAF")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Cód. Terminal"			, { || aExps[oExpsBrw:nAt,18] }, "C", pesqPict("SY5","Y5_COD")		, 1, tamSx3("Y5_COD")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"Terminal"				, { || aExps[oExpsBrw:nAt,19] }, "C", pesqPict("SY5","Y5_NOME")		, 1, tamSx3("Y5_NOME")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"Terminal Fornec."		, { || aExps[oExpsBrw:nAt,20] }, "C", pesqPict("SY5","Y5_FORNECE")	, 1, tamSx3("Y5_FORNECE")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Terminal Loja"			, { || aExps[oExpsBrw:nAt,21] }, "C", pesqPict("SY5","Y5_LOJAF")	, 1, tamSx3("Y5_LOJAF")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"Cód. REDEX"			, { || aExps[oExpsBrw:nAt,22] }, "C", pesqPict("SY5","Y5_COD")		, 1, tamSx3("Y5_COD")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"REDEX"					, { || aExps[oExpsBrw:nAt,23] }, "C", pesqPict("SY5","Y5_NOME")		, 1, tamSx3("Y5_NOME")[1]/2		,							, .F.})
		oExpsBrw:addColumn({"REDEX Fornec."			, { || aExps[oExpsBrw:nAt,24] }, "C", pesqPict("SY5","Y5_FORNECE")	, 1, tamSx3("Y5_FORNECE")[1]/2	,							, .F.})
		oExpsBrw:addColumn({"REDEX Loja"			, { || aExps[oExpsBrw:nAt,25] }, "C", pesqPict("SY5","Y5_LOJAF")	, 1, tamSx3("Y5_LOJAF")[1]/2	,							, .F.})

		oExpsBrw:activate( .T. )

		// Browse do meio de Despesas
		oDespesBrw := fwBrowse():New()
		oDespesBrw:setDataArray()
		oDespesBrw:setArray( aDespes )
		oDespesBrw:disableConfig()
		oDespesBrw:disableReport()
		oDespesBrw:setOwner( oPanelMd )


/* add(Column
[n][01] Título da coluna
[n][02] Code-Block de carga dos dados
[n][03] Tipo de dados
[n][04] Máscara
[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
[n][06] Tamanho
[n][07] Decimal
[n][08] Indica se permite a edição
[n][09] Code-Block de validação da coluna após a edição
[n][10] Indica se exibe imagem
[n][11] Code-Block de execução do duplo clique
[n][12] Variável a ser utilizada na edição (ReadVar)
[n][13] Code-Block de execução do clique no header
[n][14] Indica se a coluna está deletada
[n][15] Indica se a coluna será exibida nos detalhes do Browse
[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
[n][17] Id da coluna
[n][18] Indica se a coluna é virtual
*/

		oDespesBrw:addColumn({"Despesa"				, {||aDespes[oDespesBrw:nAt,01]}, "C", pesqPict("ZEE","ZEE_CODDES")	, 1, tamSx3("ZEE_CODDES")[1]/2	,							, .T. 				, , .F.,, "xEETDESPES"	,, .F., .T.,												, "xEETDESPES"	})
		oDespesBrw:addColumn({"Descrição"			, {||aDespes[oDespesBrw:nAt,02]}, "C", pesqPict("ZEE","ZEE_DESPES")	, 1, tamSx3("ZEE_DESPES")[1]/2	,							, .F. 				, , .F.,, "xZEEDESPES"	,, .F., .T.,												, "xZEEDESPES"	})
		oDespesBrw:addColumn({"Tabela Pré Cálculo"	, {||aDespes[oDespesBrw:nAt,03]}, "C", pesqPict("ZEE","ZEE_CODIGO")	, 1, tamSx3("ZEE_CODIGO")[1]/2	,							, .F. 				, , .F.,, "xZEECODIGO"	,, .F., .T.,												, "xZEECODIGO"	})
		oDespesBrw:addColumn({"Moeda Pré Cálculo"	, {||aDespes[oDespesBrw:nAt,04]}, "C", pesqPict("ZEE","ZEE_MOEDA")	, 1, tamSx3("ZEE_MOEDA")[1]/2	,							, .F. 				, , .F.,, "xZEEMOEDA"	,, .F., .T.,												, "xZEEMOEDA"	})
		oDespesBrw:addColumn({"Valor Pré Cálculo"	, {||aDespes[oDespesBrw:nAt,05]}, "N", pesqPict("ZEE","ZEE_VALOR")	, 2, tamSx3("ZEE_VALOR")[1]		, tamSx3("ZEE_VALOR")[2]	, .F. 				, , .F.,, "xValPreCal"	,, .F., .T.,												, "xValPreCal"	})
		oDespesBrw:addColumn({"Documento"			, {||aDespes[oDespesBrw:nAt,06]}, "C", pesqPict("SE2","E2_NUM")		, 1, tamSx3("E2_NUM")[1]		, tamSx3("E2_NUM")[2]		, .T. 				, , .F.,, "xEETDOCTO"	,, .F., .T.,												, "xEETDOCTO"	})
		oDespesBrw:addColumn({"Série"				, {||aDespes[oDespesBrw:nAt,07]}, "C", pesqPict("SF1","F1_SERIE")	, 1, tamSx3("F1_SERIE")[1]		, tamSx3("F1_SERIE")[2]		, .T. 				, , .F.,, "xC7XSERIE"	,, .F., .T.,												, "xC7XSERIE"	})
		oDespesBrw:addColumn({"Espécie"				, {||aDespes[oDespesBrw:nAt,08]}, "C", pesqPict("SF1","F1_ESPECIE")	, 1, tamSx3("F1_ESPECIE")[1]	, tamSx3("F1_ESPECIE")[2]	, .T. 				, , .F.,, "xC7XESPECI"	,, .F., .T.,												, "xC7XESPECI"	})
		oDespesBrw:addColumn({"Operação"			, {||aDespes[oDespesBrw:nAt,09]}, "C", pesqPict("SD1","D1_OPER")	, 1, tamSx3("D1_OPER")[1]		, tamSx3("D1_OPER")[2]		, .T. 				, , .F.,, "xC7XOPER"	,, .F., .T.,												, "xC7XOPER"	})
		oDespesBrw:addColumn({"Emissão"				, {||aDespes[oDespesBrw:nAt,10]}, "D", pesqPict("SE2","E2_EMISSAO")	, 1, tamSx3("E2_EMISSAO")[1]	, tamSx3("E2_EMISSAO")[2]	, .T. 				, , .F.,, "xEETDESADI"	,, .F., .T., 												, "xEETDESADI"	})
		oDespesBrw:addColumn({"Emissão Certificado"	, {||aDespes[oDespesBrw:nAt,11]}, "D", pesqPict("SE2","E2_EMISSAO")	, 1, tamSx3("E2_EMISSAO")[1]	, tamSx3("E2_EMISSAO")[2]	, ( nParamOpc == 2 ) , , .F.,, "xEETXEMISC"	,, .F., .T., 												, "xEETXEMISC"	})
		oDespesBrw:addColumn({"Valor Documento"		, {||aDespes[oDespesBrw:nAt,12]}, "N", pesqPict("SE2","E2_VALOR")	, 2, tamSx3("E2_VALOR")[1]		, tamSx3("E2_VALOR")[2]		, .T. 				, , .F.,, "xEETVALORR"	,, .F., .T.,												, "xEETVALORR"	})
		oDespesBrw:addColumn({"Moeda"				, {||aDespes[oDespesBrw:nAt,13]}, "C", pesqPict("EET","EET_ZMOED")	, 1, tamSx3("EET_ZMOED")[1]		, tamSx3("EET_ZMOED")[2]	, .T. 				, , .F.,, "xEETZMOED"	,, .F., .T., { "1=R$","2=US$","3=EUR","4=GBP" }				, "xEETZMOED"	})
		oDespesBrw:addColumn({"Taxa Neg."			, {||aDespes[oDespesBrw:nAt,14]}, "N", pesqPict("EET","EET_ZTX")	, 2, tamSx3("EET_ZTX")[1]		, tamSx3("EET_ZTX")[2]		, .T. 				, , .F.,, "xEETZTX"		,, .F., .T.,												, "xEETZTX"		})
		oDespesBrw:addColumn({"Valor Moeda"			, {||aDespes[oDespesBrw:nAt,15]}, "N", pesqPict("EET","EET_ZVLMOE")	, 2, tamSx3("EET_ZVLMOE")[1]	, tamSx3("EET_ZVLMOE")[2]	, .T. 				, , .F.,, "xEETZVLMOE"	,, .F., .T.,												, "xEETZVLMOE"	})
		oDespesBrw:addColumn({"Vencimento"			, {||aDespes[oDespesBrw:nAt,16]}, "D", pesqPict("EET","EET_DTVENC")	, 1, tamSx3("EET_DTVENC")[1]	, tamSx3("EET_DTVENC")[2]	, .T. 				, , .F.,, "xEETDTVENC"	,, .F., .T.,												, "xEETDTVENC"	})
		oDespesBrw:addColumn({"Natureza"			, {||aDespes[oDespesBrw:nAt,17]}, "C", pesqPict("EET","EET_NATURE")	, 1, tamSx3("EET_NATURE")[1]	, tamSx3("EET_NATURE")[2]	, .T. 				, , .F.,, "xEETNATURE"	,, .F., .T.,												, "xEETNATURE"	})
		oDespesBrw:addColumn({"Prefixo"				, {||aDespes[oDespesBrw:nAt,18]}, "C", pesqPict("EET","EET_PREFIX")	, 1, tamSx3("EET_PREFIX")[1]	, tamSx3("EET_PREFIX")[2]	, .T. 				, , .F.,, "xEETPREFIX"	,, .F., .T.,												, "xEETPREFIX"	})
		oDespesBrw:addColumn({"Centro Custo"		, {||aDespes[oDespesBrw:nAt,19]}, "C", pesqPict("EET","EET_ZCCUST")	, 1, tamSx3("EET_ZCCUST")[1]	, tamSx3("EET_ZCCUST")[2]	, .F. 				, , .F.,, "xEETZCCUST"	,, .F., .T.,												, "xEETZCCUST"	})
		oDespesBrw:addColumn({"Item Ctb.Deb"		, {||aDespes[oDespesBrw:nAt,20]}, "C", pesqPict("EET","EET_ZITEMD")	, 1, tamSx3("EET_ZITEMD")[1]	, tamSx3("EET_ZITEMD")[2]	, .F. 				, , .F.,, "xEETZITEMD"	,, .F., .T.,												, "xEETZITEMD"	})
		oDespesBrw:addColumn({"NF FORNEC"			, {||aDespes[oDespesBrw:nAt,21]}, "C", pesqPict("EET","EET_ZNFORN")	, 1, tamSx3("EET_ZNFORN")[1]	, tamSx3("EET_ZNFORN")[2]	, .T. 				, , .F.,, "xEETZNFORN"	,, .F., .T.,												, "xEETZNFORN"	})
		oDespesBrw:addColumn({"Observação"			, {||aDespes[oDespesBrw:nAt,22]}, "C", pesqPict("EET","EET_ZOBS")	, 1, tamSx3("EET_ZOBS")[1]		, tamSx3("EET_ZOBS")[2]		, .T. 				, , .F.,, "xEETZOBS"	,, .F., .T.,												, "xEETZOBS"	})
		oDespesBrw:addColumn({"Tipo Despesa"		, {||aDespes[oDespesBrw:nAt,23]}, "C", pesqPict("ZEE","ZEE_TIPODE")	, 1, tamSx3("ZEE_TIPODE")[1]	, tamSx3("ZEE_TIPODE")[2]	, .F. 				, , .F.,, "xZEETIPODE"	,, .F., .T., { "A=Armador","D=Despachante","T=Terminal" }	, "xZEETIPODE"	})
		oDespesBrw:addColumn({"Fornecedor"			, {||aDespes[oDespesBrw:nAt,24]}, "C", pesqPict("SY5","Y5_COD")		, 1, tamSx3("Y5_COD")[1]		, tamSx3("Y5_COD")[2]		, ( nParamOpc <> 1 )	, , .F.,, "xY5COD"		,, .F., .T.,												, "xY5COD"		})
		oDespesBrw:addColumn({"Desc. Fornecedor"	, {||aDespes[oDespesBrw:nAt,25]}, "C", pesqPict("SY5","Y5_NOME")	, 1, tamSx3("Y5_NOME")[1]		, tamSx3("Y5_NOME")[2]		, .F. 				, , .F.,, "xY5NOME"		,, .F., .T.,												, "xY5NOME"		})

		oDespesBrw:setEditCell( .T. , { || vldDoc() } )

		oDespesBrw:setInsert( .T. )
		oDespesBrw:setLineOk( { || chkLineOk() } )

		oDespesBrw:aColumns[1]:XF3 := 'SYB'
		oDespesBrw:aColumns[24]:XF3 := 'SY5'

		oDespesBrw:setAfterAddLine( { || posIncLine() } )
		//oDespesBrw:setPreEditCell( { || preEditCel() } )

		oDespesBrw:activate( .T. )

		// Browse do meio de Despesas
		oHistorBrw := fwBrowse():New()
		oHistorBrw:setDataArray()
		oHistorBrw:setArray( aDespesLan )
		oHistorBrw:disableConfig()
		oHistorBrw:disableReport()
		oHistorBrw:setOwner( oPanelDw )

		oHistorBrw:addColumn({"Despesa"				, {||aDespesLan[oHistorBrw:nAt,01]}, "C", pesqPict("ZEE","ZEE_CODDES")	, 1, tamSx3("ZEE_CODDES")[1]/2	,							, .T. , , .F.,, "xEETDESPES",, .F., .T.,									, "xEETDESPES"	})
		oHistorBrw:addColumn({"Descrição"			, {||aDespesLan[oHistorBrw:nAt,02]}, "C", pesqPict("ZEE","ZEE_DESPES")	, 1, tamSx3("ZEE_DESPES")[1]/2	,							, .F. , , .F.,, "xZEEDESPES",, .F., .T.,									, "xZEEDESPES"	})
		oHistorBrw:addColumn({"Tabela Pré Cálculo"	, {||aDespesLan[oHistorBrw:nAt,03]}, "C", pesqPict("ZEE","ZEE_CODIGO")	, 1, tamSx3("ZEE_CODIGO")[1]/2	,							, .F. , , .F.,, "xZEECODIGO",, .F., .T.,									, "xZEECODIGO"	})
		oHistorBrw:addColumn({"Moeda Pré Cálculo"	, {||aDespesLan[oHistorBrw:nAt,04]}, "C", pesqPict("ZEE","ZEE_MOEDA")	, 1, tamSx3("ZEE_MOEDA")[1]/2	,							, .F. , , .F.,, "xZEEMOEDA"	,, .F., .T.,									, "xZEEMOEDA"	})
		oHistorBrw:addColumn({"Valor Pré Cálculo"	, {||aDespesLan[oHistorBrw:nAt,05]}, "N", pesqPict("ZEE","ZEE_VALOR")	, 2, tamSx3("ZEE_VALOR")[1]		, tamSx3("ZEE_VALOR")[2]	, .F. , , .F.,, "xValPreCal",, .F., .T.,									, "xValPreCal"	})
		oHistorBrw:addColumn({"Documento"			, {||aDespesLan[oHistorBrw:nAt,06]}, "C", pesqPict("SE2","E2_NUM")		, 1, tamSx3("E2_NUM")[1]		, tamSx3("E2_NUM")[2]		, .T. , , .F.,, "xEETDOCTO"	,, .F., .T.,									, "xEETDOCTO"	})
		oHistorBrw:addColumn({"Série"				, {||aDespesLan[oHistorBrw:nAt,07]}, "C", pesqPict("SF1","F1_SERIE")	, 1, tamSx3("F1_SERIE")[1]		, tamSx3("F1_SERIE")[2]		, .T. , , .F.,, "xC7XSERIE"	,, .F., .T.,									, "xC7XSERIE"	})
		oHistorBrw:addColumn({"Espécie"				, {||aDespesLan[oHistorBrw:nAt,08]}, "C", pesqPict("SF1","F1_ESPECIE")	, 1, tamSx3("F1_ESPECIE")[1]	, tamSx3("F1_ESPECIE")[2]	, .T. , , .F.,, "xC7XESPECI",, .F., .T.,									, "xC7XESPECI"	})
		oHistorBrw:addColumn({"Operação"			, {||aDespesLan[oHistorBrw:nAt,09]}, "C", pesqPict("SD1","D1_OPER")		, 1, tamSx3("D1_OPER")[1]		, tamSx3("D1_OPER")[2]		, .T. , , .F.,, "xC7XOPER"	,, .F., .T.,									, "xC7XOPER"	})
		oHistorBrw:addColumn({"Emissão"				, {||aDespesLan[oHistorBrw:nAt,10]}, "D", pesqPict("SE2","E2_EMISSAO")	, 1, tamSx3("E2_EMISSAO")[1]	, tamSx3("E2_EMISSAO")[2]	, .T. , , .F.,, "xEETDESADI",, .F., .T., 									, "xEETDESADI"	})
		oHistorBrw:addColumn({"Valor Documento"		, {||aDespesLan[oHistorBrw:nAt,11]}, "N", pesqPict("SE2","E2_VALOR")	, 2, tamSx3("E2_VALOR")[1]		, tamSx3("E2_VALOR")[2]		, .T. , , .F.,, "xEETVALORR",, .F., .T.,									, "xEETVALORR"	})
		oHistorBrw:addColumn({"Moeda"				, {||aDespesLan[oHistorBrw:nAt,12]}, "C", pesqPict("EET","EET_ZMOED")	, 1, tamSx3("EET_ZMOED")[1]		, tamSx3("EET_ZMOED")[2]	, .T. , , .F.,, "xEETZMOED"	,, .F., .T., { "1=R$","2=US$","3=EUR","4=GBP" }	, "xEETZMOED"	})
		oHistorBrw:addColumn({"Taxa Neg."			, {||aDespesLan[oHistorBrw:nAt,13]}, "N", pesqPict("EET","EET_ZTX")		, 2, tamSx3("EET_ZTX")[1]		, tamSx3("EET_ZTX")[2]		, .T. , , .F.,, "xEETZTX"	,, .F., .T.,									, "xEETZTX"		})
		oHistorBrw:addColumn({"Valor Moeda"			, {||aDespesLan[oHistorBrw:nAt,14]}, "N", pesqPict("EET","EET_ZVLMOE")	, 2, tamSx3("EET_ZVLMOE")[1]	, tamSx3("EET_ZVLMOE")[2]	, .T. , , .F.,, "xEETZVLMOE",, .F., .T.,									, "xEETZVLMOE"	})
		oHistorBrw:addColumn({"Vencimento"			, {||aDespesLan[oHistorBrw:nAt,15]}, "D", pesqPict("EET","EET_DTVENC")	, 1, tamSx3("EET_DTVENC")[1]	, tamSx3("EET_DTVENC")[2]	, .T. , , .F.,, "xEETDTVENC",, .F., .T.,									, "xEETDTVENC"	})
		oHistorBrw:addColumn({"Natureza"			, {||aDespesLan[oHistorBrw:nAt,16]}, "C", pesqPict("EET","EET_NATURE")	, 1, tamSx3("EET_NATURE")[1]	, tamSx3("EET_NATURE")[2]	, .T. , , .F.,, "xEETNATURE",, .F., .T.,									, "xEETNATURE"	})
		oHistorBrw:addColumn({"Prefixo"				, {||aDespesLan[oHistorBrw:nAt,17]}, "C", pesqPict("EET","EET_PREFIX")	, 1, tamSx3("EET_PREFIX")[1]	, tamSx3("EET_PREFIX")[2]	, .T. , , .F.,, "xEETPREFIX",, .F., .T.,									, "xEETPREFIX"	})
		oHistorBrw:addColumn({"Centro Custo"		, {||aDespesLan[oHistorBrw:nAt,18]}, "C", pesqPict("EET","EET_ZCCUST")	, 1, tamSx3("EET_ZCCUST")[1]	, tamSx3("EET_ZCCUST")[2]	, .F. , , .F.,, "xEETZCCUST",, .F., .T.,									, "xEETZCCUST"	})
		oHistorBrw:addColumn({"Item Ctb.Deb"		, {||aDespesLan[oHistorBrw:nAt,19]}, "C", pesqPict("EET","EET_ZITEMD")	, 1, tamSx3("EET_ZITEMD")[1]	, tamSx3("EET_ZITEMD")[2]	, .F. , , .F.,, "xEETZITEMD",, .F., .T.,									, "xEETZITEMD"	})
		oHistorBrw:addColumn({"NF FORNEC"			, {||aDespesLan[oHistorBrw:nAt,20]}, "C", pesqPict("EET","EET_ZNFORN")	, 1, tamSx3("EET_ZNFORN")[1]	, tamSx3("EET_ZNFORN")[2]	, .T. , , .F.,, "xEETZNFORN",, .F., .T.,									, "xEETZNFORN"	})

		oHistorBrw:activate( .T. )

		enchoiceBar(oDlgDespes, bOk , bClose)
	ACTIVATE MSDIALOG oDlgDespes CENTER
return

//----------------------------------------------------------------
// Executa apos a inclusao de uma nova linha
// Inicializa o array com os tamanhos para liberar digitacao
//----------------------------------------------------------------
static function posIncLine()
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDESPES"	):nOrder ] := space( tamSx3( "ZEE_CODDES" )[1]		)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEEDESPES"	):nOrder ] := space( tamSx3( "YB_DESCR" )[1]		)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEECODIGO"	):nOrder ] := space( tamSx3( "ZEE_CODIGO" )[1]		)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEEMOEDA"	):nOrder ] := space( tamSx3( "ZEE_MOEDA" )[1]		)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xValPreCal"	):nOrder ] := 0
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDOCTO"	):nOrder ] := space( tamSx3( "E2_NUM" )[1] 		)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xC7XSERIE"	):nOrder ] := space( tamSx3( "F1_SERIE" )[1]	 	)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xC7XESPECI"	):nOrder ] := space( tamSx3( "F1_ESPECIE" )[1] 	)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xC7XOPER"		):nOrder ] := space( tamSx3( "D1_OPER" )[1]		)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDESADI"	):nOrder ] := cToD("//")
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETVALORR"	):nOrder ] := 0
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZMOED"	):nOrder ] := space( tamSx3( "EET_ZMOED" )[1]		)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZTX"		):nOrder ] := 0
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZVLMOE"	):nOrder ] := 0
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDTVENC"	):nOrder ] := cToD("//")
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETNATURE"	):nOrder ] := space( tamSx3( "YB_NATURE" )[1]		)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETPREFIX"	):nOrder ] := space( tamSx3( "EET_PREFIX" )[1] 	)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZCCUST"	):nOrder ] := "2404"
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZITEMD"	):nOrder ] := "12"
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZNFORN"	):nOrder ] := space( tamSx3( "EET_ZNFORN" )[1]		)
	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZOBS"		):nOrder ] := space( tamSx3("EET_ZOBS")[1] )

	if nParamOpc == 1
		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"	):nOrder ]	:= "A"
		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5COD"		):nOrder ]	:= aExps[ 1 , 10 ]
		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5NOME"		):nOrder ]	:= aExps[ 1 , 11 ]
	elseif nParamOpc == 2
		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"	):nOrder ]	:= "D"
		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5COD"		):nOrder ]	:= aExps[ 1 , 14 ]
		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5NOME"		):nOrder ]	:= aExps[ 1 , 15 ]
	elseif nParamOpc == 3
		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"	):nOrder ] := "T"
		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5COD"		):nOrder ] := aExps[ 1 , 18 ]
		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5NOME"		):nOrder ] := aExps[ 1 , 19 ]
	endif

	//aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5COD"		):nOrder ] := space( tamSx3("Y5_COD")[1] )
	//aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5NOME"	):nOrder ] := space( tamSx3("Y5_NOME")[1] )
return

//-------------------------------------------------------
//-------------------------------------------------------
static function vldDoc()
	local nLinha		:= oDespesBrw:at()
	local lRetVld		:= .T.
	local nI			:= 0
	local nCalcDesp		:= 0
	local cDespFrete	:= allTrim( superGetMv( "MGF_EEC67A", , "416,419" ) )
	local cDespHalal	:= allTrim( superGetMv( "MGF_EEC67B", , "461,435" ) )

	If oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cID == "xEETDESPES"
		if lFobFob
			if &( oDespesBrw:GetColByID("xEETDESPES"):cReadVar ) $ cDespFrete
				APMsgStop("Não permitido lançar frete para processo de exportação FOB")
				lRetVld := .F.
			endif
		endif

		if lRetVld
			aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEEDESPES"):nOrder ]	:= getAdvFVal( "SYB" , "YB_DESCR"	, xFilial("SYB") + &( oDespesBrw:GetColByID("xEETDESPES"):cReadVar ) , 1 , "" )
			aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETNATURE"):nOrder ]	:= getAdvFVal( "SYB" , "YB_NATURE"	, xFilial("SYB") + &( oDespesBrw:GetColByID("xEETDESPES"):cReadVar ) , 1 , "" )
		endif
	elseif oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cID == "xEETDOCTO"
		if !empty( &( oDespesBrw:GetColByID("xEETDOCTO"):cReadVar ) )
			for nI := 1 to len( aDespes )
				if aDespes[ nI , oDespesBrw:colPos() ] == &( oDespesBrw:GetColByID("xEETDOCTO"):cReadVar )	;
					.and.																					;
					nI <> oDespesBrw:at()																	;
					// SE O DOCUMENTO DIGITADO FOR O MESMO DE UM DOCUMENTO JA EXISTENTE NO ARRAY REPLICA OS DADOS
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xC7XSERIE"):nOrder	] := aDespes[ nI , oDespesBrw:GetColByID("xC7XSERIE"):nOrder	]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xC7XESPECI"):nOrder	] := aDespes[ nI , oDespesBrw:GetColByID("xC7XESPECI"):nOrder	]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xC7XOPER"):nOrder		] := aDespes[ nI , oDespesBrw:GetColByID("xC7XOPER"):nOrder		]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDESADI"):nOrder	] := aDespes[ nI , oDespesBrw:GetColByID("xEETDESADI"):nOrder	]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDTVENC"):nOrder	] := aDespes[ nI , oDespesBrw:GetColByID("xEETDTVENC"):nOrder	]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETNATURE"):nOrder	] := aDespes[ nI , oDespesBrw:GetColByID("xEETNATURE"):nOrder	]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZCCUST"):nOrder	] := aDespes[ nI , oDespesBrw:GetColByID("xEETZCCUST"):nOrder	]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZITEMD"):nOrder	] := aDespes[ nI , oDespesBrw:GetColByID("xEETZITEMD"):nOrder	]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZNFORN"):nOrder	] := aDespes[ nI , oDespesBrw:GetColByID("xEETZNFORN"):nOrder	]

					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZOBS"):nOrder		] := aDespes[ nI , oDespesBrw:GetColByID("xEETZOBS"):nOrder		]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"):nOrder	] := aDespes[ nI , oDespesBrw:GetColByID("xZEETIPODE"):nOrder	]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5COD"):nOrder		] := aDespes[ nI , oDespesBrw:GetColByID("xY5COD"):nOrder		]
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5NOME"):nOrder		] := aDespes[ nI , oDespesBrw:GetColByID("xY5NOME"):nOrder		]

					if aDespes[ nI , oDespesBrw:GetColByID("xEETZTX"):nOrder	] > 0
						aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZMOED"):nOrder	]	:= aDespes[ nI , oDespesBrw:GetColByID("xEETZMOED"):nOrder	]
						aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZTX"):nOrder	]		:= aDespes[ nI , oDespesBrw:GetColByID("xEETZTX"):nOrder	]
						aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZVLMOE"):nOrder	]	:= aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xValPreCal"):nOrder	]
						aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETVALORR"):nOrder	]	:= aDespes[ nI , oDespesBrw:GetColByID("xEETZTX"):nOrder	] * aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xValPreCal"):nOrder	]
					else
						aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETVALORR"):nOrder	]	:= aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xValPreCal"):nOrder	]
					endif

					exit
				endif
			next
		endif

		If ! Empty(	&( oDespesBrw:GetColByID("xEETDOCTO"):cReadVar ))
			lRetVld := RetSldPreC(aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETVALORR"):nOrder	]) // RVBJ
		Endif

	elseif oDespesBrw:GetColByGridID(oDespesBrw:colPos()):cID == "xEETZVLMOE"
		//aDespes[ nLinha , oDespesBrw:colPos( oDespesBrw:GetColByID("xEETVALORR") ) ] := ( &( oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cReadVar ) * &( oDespesBrw:GetColByID("xEETZTX"):cReadVar ) )
		//oDespesBrw:GetColByID("xEETVALORR"):cReadVar := ( &( oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cReadVar ) * &( oDespesBrw:GetColByID("xEETZTX"):cReadVar ) )
		//aDespes[ nLinha , 11 ] := ( &( oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cReadVar ) * &( oDespesBrw:GetColByID("xEETZTX"):cReadVar ) )
		aDespes[ nLinha , oDespesBrw:GetColByID("xEETVALORR"):nOrder ] := ( &( oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cReadVar ) * &( oDespesBrw:GetColByID("xEETZTX"):cReadVar ) )

		// xEETVALORR
		//aDespes[ nLinha , oDespesBrw:colPos() ] := ( &( oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cReadVar ) * &( oDespesBrw:GetColByID("xEETZTX"):cReadVar ) )
		/*
		Campos:
		xEETVALORR	->	valor documento
		xEETZTX		->	taxa
		xEETZVLMOE	->	valor moeda
		*/
		// METHOD GetColByID(cID)
	elseif (	oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cID == "xC7XSERIE"		;
				.or.																	;
				oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cID == "xC7XESPECI" )	;
				.and.																	;
				!empty( &( oDespesBrw:GetColByID( "xC7XSERIE" ):cReadVar ) )			;
				.and.																	;
				!empty( &( oDespesBrw:GetColByID( "xC7XESPECI" ):cReadVar ) )
		// VALIDA SERIE + ESPECIE -> AMARRACAO FEITA PELO FISCAL CORPORTATIVO
		lRetVld := chkSeriEsp()
	elseif (	oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cID == "xC7XOPER"		;
				.or.																	;
				oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cID == "xC7XESPECI" )	;
				.and.																	;
				!empty( &( oDespesBrw:GetColByID( "xC7XOPER" ):cReadVar ) )				;
				.and.																	;
				!empty( &( oDespesBrw:GetColByID( "xC7XESPECI" ):cReadVar ) )
		// VALIDA OPERACAO + ESPECIE -> AMARRACAO FEITA PELO FISCAL CORPORTATIVO
		lRetVld := chkOperac()
	elseif oDespesBrw:GetColByGridID(oDespesBrw:colPos()):cID == "xEETDTVENC"
		if &( oDespesBrw:GetColByID( "xEETDTVENC" ):cReadVar ) < dDataBase
			APMsgStop("Data de Vencimento não pode ser menor que a data atual.")
			lRetVld := .F.
		endif
	elseif oDespesBrw:GetColByGridID(oDespesBrw:colPos()):cID == "xEETXEMISC"
		if !empty( &( oDespesBrw:GetColByID( "xEETXEMISC" ):cReadVar ) )
			if aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"):nOrder ] <> "D"
				APMsgStop("Campo utilizado apenas as Despesas de Despachante e Certificados de Halal e Cibal Halal")
				lRetVld := .F.
			else
				if aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"):nOrder ] == "D" .and. aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDESPES"):nOrder ] $ cDespHalal
					// NA ALTERACAO DA DATA DA EMISSAO RECALCULA DESPESA DE HALAL
					nCalcDesp := 0
					nCalcDesp := calcDesp( aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDESPES"):nOrder ] , &( oDespesBrw:GetColByID("xEETXEMISC"):cReadVar ) , aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEEMOEDA"):nOrder ] )
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xValPreCal"):nOrder	] := nCalcDesp
					aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETVALORR"):nOrder	] := nCalcDesp
				endif
			endif
		endif
	elseif oDespesBrw:GetColByGridID(oDespesBrw:colPos()):cID == "xY5COD"
		if empty( aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"):nOrder ] ) .and. !empty( &( oDespesBrw:GetColByID( "xY5COD" ):cReadVar ) )
			APMsgStop("Informe Tipo da Despesa antes de digitar o Fornecedor")
			lRetVld := .F.
		elseif aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"):nOrder ] == "A" .and. &( oDespesBrw:GetColByID( "xY5COD" ):cReadVar ) <> aExps[ 1 , 10 ]
			APMsgStop("Não permitido alteração de Fornecedor para Armadores")
			lRetVld := .F.
		else
			// DE PARA TIPOS DE FORNECEDOR
			// 4-ARMADOR
			// 6-DESPACHANTE
			// E-ARMAZEM - TERMINAL

			lRetVld := .F.

			if		aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"):nOrder ] == "A"														;
					.and.																																;
					left( GetAdvFVal( "SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + &( oDespesBrw:GetColByID( "xY5COD" ):cReadVar ) , 1 , "" ) , 1 ) == "4"	;

				lRetVld := .T.
			elseif	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"):nOrder ] == "D"														;
					.and.																																;
					left( GetAdvFVal( "SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + &( oDespesBrw:GetColByID( "xY5COD" ):cReadVar ) , 1 , "" ) , 1 ) == "6"	;

				lRetVld := .T.
			elseif	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEETIPODE"):nOrder ] == "T"														;
					.and.																																;
					left( GetAdvFVal( "SY5" , "Y5_TIPOAGE"	, xFilial("SY5") + &( oDespesBrw:GetColByID( "xY5COD" ):cReadVar ) , 1 , "" ) , 1 ) == "E"	;

				lRetVld := .T.
			endif

			if !lRetVld
				APMsgStop("Tipo do Fornecedor digitado não é o mesmo do Tipo da Despesa")
			endif
		endif

		if lRetVld
			aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5NOME"):nOrder ] := GetAdvFVal( "SY5" , "Y5_NOME" , xFilial("SY5") + &( oDespesBrw:GetColByID( "xY5COD" ):cReadVar ) , 1 , "" )
		endif
	endif

	if lRetVld
		aDespes[ nLinha , oDespesBrw:colPos() ] := &( oDespesBrw:GetColByGridID( oDespesBrw:colPos() ):cReadVar )
	endif

	//oDespesBrw:refresh(.F.)
return lRetVld

//---------------------------------------------------------------------------------
// Verifica Série e Espécie do Documento
//---------------------------------------------------------------------------------
static function chkSeriEsp()
	local lChkSerEsp	:= .F.
	local cQrySZW		:= ""

	cQrySZW := "SELECT COUNT( ZW_ESPECIE ) SZWCOUNT"														+ CRLF
	cQrySZW += " FROM " + retSQLName("SZW") + " SZW"														+ CRLF
	cQrySZW += " WHERE"																						+ CRLF

	if nParamOpc == 1
		cQrySZW += "		ZW_FORNECE	=	'" + aExps[ 1 , 12 ]	+ "'"									+ CRLF
		cQrySZW += "	AND ZW_LOJA		=	'" + aExps[ 1 , 13 ]	+ "'"									+ CRLF
	elseif nParamOpc == 2
		cQrySZW += "		ZW_FORNECE	=	'" + getAdvFVal("SY5" , "Y5_FORNECE", xFilial("SY5") + aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5COD"):nOrder ] , 1 , "") + "'"									+ CRLF
		cQrySZW += "	AND ZW_LOJA		=	'" + getAdvFVal("SY5" , "Y5_LOJAF"	, xFilial("SY5") + aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xY5COD"):nOrder ] , 1 , "") + "'"									+ CRLF
	endif

	cQrySZW += "	AND ZW_SERIE	=	'" + &( oDespesBrw:GetColByID( "xC7XSERIE" ):cReadVar )		+ "'"	+ CRLF
	cQrySZW += "	AND ZW_ESPECIE	=	'" + &( oDespesBrw:GetColByID( "xC7XESPECI" ):cReadVar )	+ "'"	+ CRLF
	cQrySZW += " 	AND ZW_FILIAL	=	'" + xFilial("SZW") 										+ "'"	+ CRLF
	cQrySZW += " 	AND	D_E_L_E_T_	<>	'*'"																+ CRLF

	tcQuery cQrySZW New Alias "QRYSZW"

	if QRYSZW->SZWCOUNT > 0
		lChkSerEsp := .T.
	else
		APMsgStop("Espécie deste documento não está cadastrada para este Fornecedor na tabela de 'Amarração de Fornecedor x Especie NFE Talonário'.")
	endif

	QRYSZW->( DBCloseArea() )
return lChkSerEsp

//---------------------------------------------------------------------------------
// Verifica Operacao do Documento
//---------------------------------------------------------------------------------
static function chkOperac()
	local lChkOperac	:= .F.
	local cQryZBT		:= ""

	cQryZBT := "SELECT COUNT(*) ZBTCOUNT"																		+ CRLF
	cQryZBT += " FROM " + retSQLName("ZBT") + " ZBT"															+ CRLF
	cQryZBT += " WHERE"																							+ CRLF
	cQryZBT += "		ZBT.ZBT_OPER	=	'" + &( oDespesBrw:GetColByID( "xC7XOPER" ):cReadVar )		+ "'"	+ CRLF
	cQryZBT += "	AND ZBT.ZBT_ESPEC	=	'" + &( oDespesBrw:GetColByID( "xC7XESPECI" ):cReadVar )	+ "'"	+ CRLF
	cQryZBT += " 	AND ZBT.ZBT_FILIAL	=	'" + xFilial("ZBT") 										+ "'"	+ CRLF
	cQryZBT += " 	AND ZBT.D_E_L_E_T_	<>	'*'"																+ CRLF

	tcQuery cQryZBT New Alias "QRYZBT"

	if QRYZBT->ZBTCOUNT > 0
		lChkOperac := .T.
	else
		APMsgStop( "Não existe amarração do Tipo de Operação X Espécie NFE cadastrada para esta operação." + CRLF + ;
					"Faça o cadastro desta amarração para incluir este Documento de Entrada." )
	endif

	QRYZBT->( DBCloseArea() )
return lChkOperac

//---------------------------------------------------------------------------------
// Verifica tudo esta ok
//---------------------------------------------------------------------------------
static function chkAllOk()
	local lAllOk	:= .T.
	local nI		:= 0

	for nI := 1 to len( aDespes )
		if !chkLineOk( nI )
			lAllOk := .F.
			exit
		endif
	next

return lAllOk

//---------------------------------------------------------------------------------
// Verifica Se a linha esta ok
//---------------------------------------------------------------------------------
static function chkLineOk( nLineToChk )
	local lChkLineOk	:= .T.
	local nI			:= 0
	local cQrySF1		:= ""
	local aAreaX		:= getArea()

	default nLineToChk	:= oDespesBrw:at()

	//oDespesBrw:at()
	//{ "xEETDOCTO" , "xC7XSERIE" , "xC7XESPECI" , "xC7XOPER" , "xEETDESADI" , "xEETVALORR" , "xEETDTVENC" , "xEETNATURE" , "xEETZCCUST" , "xEETZITEMD" , "xEETZNFORN" }

	if !empty( aDespes[ nLineToChk , oDespesBrw:GetColByID( "xEETDOCTO" ):nOrder ] )
		for nI := 1 to len( aCamposObr )
			if empty( aDespes[ nLineToChk , oDespesBrw:GetColByID( aCamposObr[ nI ] ):nOrder ] )
				lChkLineOk := .F.
				exit
			endif
		next
	endif

	if !lChkLineOk
		aviso(	"Campos obrigatórios"																	,;
				"O campo " + oDespesBrw:GetColByID( aCamposObr[nI] ):cTitle + " não foi preenchido."	,;
				{ "Ok" }																				,;
				2																						)
	else
		if !empty( aDespes[ nLineToChk , oDespesBrw:GetColByID( "xEETDOCTO" ):nOrder ] )
			cQrySF1 := "SELECT F1_FILIAL, F1_DOC"
			cQrySF1 += " FROM " + retSQLName("SF1") + " SF1"
			cQrySF1 += " WHERE"
			cQrySF1 += "		SF1.F1_LOJA		=	'" + getAdvFVal("SY5" , "Y5_LOJAF"	, xFilial("SY5") + aDespes[ nLineToChk , oDespesBrw:GetColByID("xY5COD"	):nOrder ]	, 1 , "")	+ "'"
			cQrySF1 += "	AND	SF1.F1_FORNECE	=	'" + getAdvFVal("SY5" , "Y5_FORNECE", xFilial("SY5") + aDespes[ nLineToChk , oDespesBrw:GetColByID("xY5COD"	):nOrder ]	, 1 , "")	+ "'"
			cQrySF1 += "	AND	SF1.F1_SERIE	=	'" + padL( allTrim( aDespes[ nLineToChk , oDespesBrw:GetColByID( "xC7XSERIE" ):nOrder ] ) , tamSX3("F1_DOC")[1] , "0" )				+ "'"
			cQrySF1 += "	AND	SF1.F1_DOC		=	'" + padL( allTrim( aDespes[ nLineToChk , oDespesBrw:GetColByID( "xEETDOCTO" ):nOrder ] ) , tamSX3("F1_DOC")[1] , "0" )				+ "'"
			cQrySF1 += "	AND SF1.F1_FILIAL	=	'" + aExps[ 1 , 1 ] + "'"
			cQrySF1 += "	AND	SF1.D_E_L_E_T_	<>	'*'"

			//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_FORMUL

			tcQuery cQrySF1 New Alias "QRYSF1"

			if !QRYSF1->( EOF() )
				lChkLineOk := .F.
				aviso(	"Documento já lançado"																																,;
						"O Documento " + allTrim( aDespes[ nLineToChk , oDespesBrw:GetColByID( "xEETDOCTO" ):nOrder ] ) + "/" + allTrim( aDespes[ nLineToChk , oDespesBrw:GetColByID( "xC7XSERIE" ):nOrder ] ) + " já está lançado para o fornecedor " + GetAdvFVal( "SY5" , "Y5_NOME" , xFilial("SY5") + &( oDespesBrw:GetColByID( "xY5COD" ):cReadVar ) , 1 , "" )	,;
						{ "Ok" }															,;
						2																	)
			endif

			QRYSF1->( DBCloseArea() )
			// valida se existe documento lançado - RVBJ
		endif
	endif

	restArea( aAreaX )
return lChkLineOk

//---------------------------------------------------------------------------------
// Seleciona historico de lancamento
//---------------------------------------------------------------------------------
static function getDespLan()
	local cQryHist		:= ""
	local cExpsIn		:= ""
	local nI			:= 0
	local cEETLOJAF		:= ""
	local cEETFORNEC	:= ""

	if len( aExps ) >= 1
		cEETLOJAF	:= GetAdvFVal( "SY5" , "Y5_LOJAF"	, xFilial("SY5") + aExps[ 1 , 10 ]	, 1 , "" )
		cEETFORNEC	:= GetAdvFVal( "SY5" , "Y5_FORNECE"	, xFilial("SY5") + aExps[ 1 , 10 ]	, 1 , "" )
	endif

	for nI := 1 to len( aExps )
		cExpsIn += "'" + aExps[ nI , 1 ] + aExps[ nI , 2 ] + "',"
	next

	cExpsIn := left( cExpsIn , len( cExpsIn ) - 1 ) // remove ultima virgula

	cQryHist := "SELECT"															+ CRLF
	cQryHist += " EET_FILIAL		,"												+ CRLF
	cQryHist += " EET_PEDIDO		,"												+ CRLF
	cQryHist += " EET_PEDCOM		,"												+ CRLF
	cQryHist += " EET_FORNEC		,"												+ CRLF
	cQryHist += " EET_LOJAF			,"												+ CRLF
	cQryHist += " EET_CODAGE		,"												+ CRLF
	cQryHist += " EET_TIPOAG		,"												+ CRLF
	cQryHist += " EET_OCORRE		,"												+ CRLF
	cQryHist += " EET_SEQ			,"												+ CRLF
	cQryHist += " EET_DESPES		,"												+ CRLF
	cQryHist += " EET_XTABPR		,"												+ CRLF
	cQryHist += " EET_XMOEPR		,"												+ CRLF
	cQryHist += " EET_XPRECA		,"												+ CRLF
	cQryHist += " EET_DOCTO			,"												+ CRLF
	cQryHist += " EET_DESADI		,"												+ CRLF
	cQryHist += " EET_VALORR		,"												+ CRLF
	cQryHist += " EET_ZMOED			,"												+ CRLF
	cQryHist += " EET_ZTX			,"												+ CRLF
	cQryHist += " EET_ZVLMOE		,"												+ CRLF
	cQryHist += " EET_DTVENC		,"												+ CRLF
	cQryHist += " EET_NATURE		,"												+ CRLF
	cQryHist += " EET_PREFIX		,"												+ CRLF
	cQryHist += " EET_ZCCUST		,"												+ CRLF
	cQryHist += " EET_ZITEMD		,"												+ CRLF
	cQryHist += " EET_ZNFORN		,"												+ CRLF
	cQryHist += " YB_DESCR"															+ CRLF
	cQryHist += " FROM " + retSQLName("EET") + " EET"								+ CRLF
	cQryHist += " INNER JOIN "	+ retSQLName("SYB") + " SYB"						+ CRLF
	cQryHist += " ON"																+ CRLF
	cQryHist += " 		EET.EET_DESPES	=	SYB.YB_DESP"							+ CRLF
	cQryHist += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"			+ CRLF
	cQryHist += " 	AND	SYB.D_E_L_E_T_	<>	'*'"									+ CRLF
	cQryHist += " WHERE"															+ CRLF
	cQryHist += "		EET.EET_FILIAL || EET.EET_PEDIDO	IN	(" + cExpsIn + ")"	+ CRLF
	cQryHist += "	AND	EET.EET_LOJAF	=	'" + cEETLOJAF	+ "'"					+ CRLF
	cQryHist += "	AND	EET.EET_FORNEC	=	'" + cEETFORNEC	+ "'"					+ CRLF
	cQryHist += "	AND	EET.D_E_L_E_T_	<>	'*'"									+ CRLF

	tcQuery cQryHist New Alias "QRYHIST"
return

//---------------------------------------------------------------------------------
// Retorna cotação do dolar / euro do parametro dDtCotacao - 1 dia
//---------------------------------------------------------------------------------
static function getSYE( dDtCotacao , cMoeda )
	local	cQrySYE		:= ""
	local	nCotacao	:= 0
	default dDtCotacao	:= dDatabase
	default cMoeda		:= "US$" //  2 - US$ /  4 - EUR

	cQrySYE := "SELECT YE_VLCON_C"												+ CRLF
	cQrySYE += " FROM " + retSQLName( "SYE" ) + " SYE"							+ CRLF
	cQrySYE += " WHERE"															+ CRLF
	cQrySYE += " 		SYE.YE_MOEDA	=	'" + cMoeda + "'"					+ CRLF
	cQrySYE += " 	AND	SYE.YE_DATA		=	'" + dToS( dDtCotacao ) + "'"		+ CRLF
	cQrySYE += " 	AND SYE.YE_FILIAL	=	' '"								+ CRLF
	cQrySYE += " 	AND	SYE.D_E_L_E_T_	<>	'*'"								+ CRLF

	tcQuery cQrySYE New Alias "QRYSYE"

	if !QRYSYE->( EOF() )
		nCotacao := QRYSYE->YE_VLCON_C
	endif

	QRYSYE->( DBCloseArea() )
return nCotacao

//---------------------------------------------------------------------------------
// Calculo de Despesa de Despachantes
	/*
	Peso líquido maior que 20 toneladas:

		PESO LÍQUIDO DA EXP x FATOR x COTAÇÃO DA MOEDA NO DIA DA EMISSÃO DO DOCUMENTO

	Peso líquido menor ou igual que 20 toneladas:

		COTAÇÃO DA MOEDA NO DIA DA EMISSÃO DO DOCUMENTO x FATOR 2
	*/
//---------------------------------------------------------------------------------
static function calcDesp( cCodDesp , dDtCotacao , cMoeda )
	local nValorDesp	:= 0
	local cValorDesp	:= ""
	local nValReturn	:= 0
	local cQryEXP		:= ""
	local cQryZED2		:= ""
	local cCibalHala	:= allTrim( superGetMv( "MGF_EEC67C", , "435" ) )
	default dDtCotacao	:= dDatabase
	default cMoeda		:= "US$" //  2 - US$ /  4 - EUR

	// "xEETZMOED"	,, .F., .T., { "1=R$","2=US$","3=EUR","4=GBP" }

	// SELECT - DESPACHANTE
	cQryZED2 := "SELECT"																			+ CRLF
	cQryZED2 += "	ZEE_CODDES	, YB_DESCR	, ZEE_VALOR	, ZEE_MOEDA	,"								+ CRLF
	cQryZED2 += " 	ZEE_CODIGO	, ZEE_TIPODE, ZEE_FATOR	, ZEE_FATOR2, ZEE_CORTEP"					+ CRLF
	cQryZED2 += " FROM "			+ retSQLName("ZED") + " ZED"									+ CRLF
	cQryZED2 += " INNER JOIN "	+ retSQLName("ZEE") + " ZEE"										+ CRLF
	cQryZED2 += " ON"																				+ CRLF
	cQryZED2 += " 		ZEE.ZEE_DESPAC	=	' '"													+ CRLF // Despesas Vinculadas com Despachante
	cQryZED2 += " 	AND ZEE.ZEE_PAIS	=	'" + EEC->EEC_PAISET	+ "'"							+ CRLF // Pais
	cQryZED2 += " 	AND	ZEE.ZEE_TIPODE	=	'D'"													+ CRLF // A=Armador;D=Despachante;T=Terminal
	cQryZED2 += " 	AND	ZEE.ZEE_CODDES	=	'" + cCodDesp			+ "'"							+ CRLF
	cQryZED2 += " 	AND	ZEE.ZEE_CODIGO	=	ZED.ZED_CODIGO"											+ CRLF
	cQryZED2 += " 	AND	ZEE.ZEE_FILIAL	=	'" + xFilial("ZEE")		+ "'"							+ CRLF
	cQryZED2 += " 	AND	ZEE.D_E_L_E_T_	<>	'*'"													+ CRLF
	cQryZED2 += " INNER JOIN "	+ retSQLName("SYB") + " SYB"										+ CRLF
	cQryZED2 += " ON"																				+ CRLF
	cQryZED2 += " 		ZEE.ZEE_CODDES	=	SYB.YB_DESP"											+ CRLF
	cQryZED2 += " 	AND	SYB.YB_FILIAL	=	'" + xFilial("SYB")		+ "'"							+ CRLF
	cQryZED2 += " 	AND	SYB.D_E_L_E_T_	<>	'*'"													+ CRLF
	cQryZED2 += " WHERE"																			+ CRLF
	cQryZED2 += " 		'" + dToS( EEC->EEC_ZDTSNA ) + "'	>=	ZED.ZED_DTINIC"						+ CRLF
	cQryZED2 += " 	AND	'" + dToS( EEC->EEC_ZDTSNA ) + "'	<=	ZED.ZED_DTFIM"						+ CRLF
	cQryZED2 += " 	AND	ZED.ZED_FILIAL						=	'" + xFilial("ZED") + "'"			+ CRLF
	cQryZED2 += " 	AND	ZED.D_E_L_E_T_						<>	'*'"								+ CRLF

	tcQuery cQryZED2 New Alias "QRYZED2"

	if !QRYZED2->( EOF() )
		if cCodDesp $ cCibalHala
			// SE DESPESA FOR CIBAL HALAL A FORMULA SERA FATOR * COTACAO (NAO CONSIDERA PESO LIQUIDO)
			nValorDesp := getSYE( dDtCotacao , cMoeda ) * QRYZED2->ZEE_FATOR
		else
			cQryEXP := "SELECT SUM( EEC_PESLIQ ) EEC_PESLIQ"					+ CRLF
			cQryEXP += " FROM "	+ retSQLName("EEC") + " EEC"					+ CRLF
			cQryEXP += " WHERE"													+ CRLF
			cQryEXP += " 		EEC.EEC_ZOK		=	'" + oBrowse:Mark()	+ "'"	+ CRLF
			cQryEXP += " 	AND	EEC.EEC_ZUMARK	=	'" + RetCodUsr()	+ "'"	+ CRLF
			cQryEXP += " 	AND	EEC.D_E_L_E_T_	<>	'*'"						+ CRLF

			tcQuery cQryEXP New Alias "QRYEXP"

			if !QRYEXP->( EOF() )
				if QRYEXP->EEC_PESLIQ <= QRYZED2->ZEE_CORTEP
					nValorDesp := getSYE( dDtCotacao , cMoeda ) * QRYZED2->ZEE_FATOR2
				else
					nValorDesp := QRYEXP->EEC_PESLIQ * QRYZED2->ZEE_FATOR * getSYE( dDtCotacao , cMoeda )
				endif
			endif

			QRYEXP->( DBCloseArea() )
		endif

		if nValorDesp > 0
			cValorDesp := allTrim( str( nValorDesp ) )

			if len( left( cValorDesp , at( "." , cValorDesp ) - 1 ) ) > 6
				// SE VALOR MAIOR QUE 999.999,99 PEGA 6 PRIMEIROS CARACTERES
				cValorDesp := left( cValorDesp , 6 )
				cValorDesp := left( cValorDesp , 4 ) + "." + right( cValorDesp , 2 )
			else
				// SE VALOR MENOR OU IGUAL QUE 999.999,99 PEGA 5 PRIMEIROS CARACTERES
				cValorDesp := left( cValorDesp , 5 )
				cValorDesp := left( cValorDesp , 3 ) + "." + right( cValorDesp , 2 )
			endif

			nValReturn := val( cValorDesp )
		endif
	endif

	QRYZED2->( DBCloseArea() )
return nValReturn


//---------------------------------------------------------------------------------
// RVBJ
// Calculo do Saldo Disponivel no Pré-lançamento
// Recebe parametro , mas so executa se for maior que zero (sem valor pre-calculado ignora)
//---------------------------------------------------------------------------------
static function RetSldPreC(_nValDigit)
Local 	_cCdDespLan		:=	aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDESPES"):nOrder ]
local _lRetSld	:=	.T.

If _nValDigit	> 0
	For nI := 1 to Len(aDespesLan)
		If aDespesLan[nI][1]	==	_cCdDespLan
			APMsgStop("Já existe documento lançado para esta despesa")
			_lRetSld	:=	.F.
			exit
		Endif
	Next
Endif
Return(_lRetSld)
