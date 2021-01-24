#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM29
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              11/04/2017
Descricao / Objetivo:   Gera CSV
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM29()
	private oSay	:= nil

	if getParam()
		//genArq()
		fwMsgRun(, {| oSay | genArq( oSay ) }, "Processando", "Aguarde. Gerando arquivo..." )
	endif
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}
	local aCoors		:= 	FWGetDialogSize( oMainWnd )

	aadd(aParambox, {6, "Salvar arquivo CSV em"	, space(200)		, "@!"	, ""	, ""	, 070, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .F. /*NAO MOSTRA SERVIDOR*/})

return paramBox(aParambox, "Estrutura de Vendas"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function genArq( oSay )
	local aArea		:= getArea()
	local aAreaSZQ	:= SZQ->(getArea())
	local cNameFile	:= "EstrutaVenda" + dToS(dDataBase) + ".csv"
	local nHandle	:= 0
	local cStrCSV	:= ""
	local nLast		:= 0
	local nLinAtu	:= 0

	if !existDir(allTrim(MV_PAR01))
		msgAlert("Diretório inválido.")
		return
	endif

	DBSelectArea("SZQ")
	SZQ->(DBSetOrder(1))

	nHandle := fCreate( allTrim(MV_PAR01) + cNameFile )
	if nHandle > 0
		getInfo()

		if !QRYARQ->(EOF())

			cStrCSV += "CODIGO1;NIVEL1;CODREPRES1;REPRES1;"
			cStrCSV += "CODIGO2;NIVEL2;CODREPRES2;REPRES2;"
			cStrCSV += "CODIGO3;NIVEL3;CODREPRES3;REPRES3;"
			cStrCSV += "CODIGO4;NIVEL4;CODREPRES4;REPRES4;"
			cStrCSV += "CODIGO5;NIVEL5;CODREPRES5;REPRES5;"
			cStrCSV += "CODIGO6;NIVEL6;CODREPRES6;REPRES6;"
			cStrCSV += "CODCLI;LOJACLI;NOME;CNPJ;"
			cStrCSV += "ENDERECO;BAIRRO;CEP;CIDADE;"
			cStrCSV += "UF;TELEFONE;CONTATO;EMAIL;"
			cStrCSV += "CREDITO;SALDO;COD_CONDICAO_PGTO;CONDICAO_PAGTO;"
			cStrCSV += "SITUACAO;ULTIMA_DT_ATUAL;NOME_REDE;GRUPO_COMERCIAL;PORC_PARAMETRIZACAO;COD_ROTEIRIZACAO;SEGMENTO;TIPOLOGIA;CATEGORIA;CANAL"
			cStrCSV += CRLF

			fWrite( nHandle , cStrCSV )

			Count to nLast

			QRYARQ->(DBGoTop())
			while !QRYARQ->(EOF())
				nLinAtu++
				oSay:cCaption := ( "Processando item " + str( nLinAtu ) + " de " + str( nLast ) )

				SZQ->(DBGoTop())

				cStrCSV := ""

				cStrCSV += xClean(allTrim(QRYARQ->CODIGO1))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->NIVEL1))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->CODREPRES1))					+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->REPRES1))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->CODIGO2))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->NIVEL2))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->CODREPRES2))					+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->REPRES2))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->CODIGO3))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->NIVEL3))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->CODREPRES3))					+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->REPRES3))						+ ";"				
				cStrCSV += xClean(allTrim(QRYARQ->CODIGO4))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->NIVEL4))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->CODREPRES4))					+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->REPRES4))						+ ";"				
				cStrCSV += xClean(allTrim(QRYARQ->CODIGO5))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->NIVEL5))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->CODREPRES5))					+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->REPRES5))					+ ";"				
				cStrCSV += xClean(allTrim(QRYARQ->CODIGO6))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->NIVEL6))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->CODREPRES6))					+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->REPRES6))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_COD))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_LOJA))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_NOME))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_CGC))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_END))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_BAIRRO))					+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_CEP))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_MUN))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_EST))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_DDD) + allTrim(A1_TEL))	+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_CONTATO))					+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_EMAIL))					+ ";"
				cStrCSV += xClean(allTrim(str(QRYARQ->A1_LC)))						+ ";"
				cStrCSV += xClean(allTrim(str(QRYARQ->LIMDISPO)))					+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_COND))						+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->E4_COND))						+ ";"
				cStrCSV += iif(QRYARQ->A1_MSBLQL == "1", "Inativo","Ativo") + ";"
				cStrCSV += dToc(sTod(QRYARQ->A1_ULTCOM))				+ ";"
				cStrCSV += xClean(allTrim(Posicione("SZQ",1,xFilial("SZQ")+QRYARQ->A1_ZREDE,"ZQ_DESCR")))  + ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_ZCDMGCO))  		+ ";"
				cStrCSV += xClean(allTrim(str(QRYARQ->A1_ZVIDAUT)))		+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_ZCROAD))			+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->AOV_DESSEG))			+ ";"

				cStrCSV += xClean(allTrim(QRYARQ->ZE9_DESTIP))			+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->ZE9_DESCAT))			+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->ZE9_DESCAN))

				cStrCSV += CRLF

				fWrite(nHandle , cStrCSV )

				QRYARQ->(DBSkip())
			enddo
			msgInfo("Exportação gerada com sucesso.")
		else
			msgAlert("Não foram encontradas informações a serem exportadas.")
		endif
		QRYARQ->(DBCloseArea())
	endif

	fClose(nHandle)

	SZQ->(DBCloseArea())

	restArea(aAreaSZQ)
	restArea(aArea)
return

//******************************************************
//******************************************************
static function xClean(cStr)
	cStr := StrTran(cStr, "'", "")
	cStr := StrTran(cStr, '"', '')
	cStr := StrTran(cStr, ";", "")
return cStr

//******************************************************
//******************************************************
static function getInfo()
	local cQryArq := ""

	cQryArq += "SELECT A1_ZCDMGCO, A1_ZCROAD," + CRLF
	cQryArq += "	ZBD_CODIGO CODIGO1, ZBD_DESCRI NIVEL1, ZBD_REPRES CODREPRES1," + CRLF
	cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBD.ZBD_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES1," + CRLF
	cQryArq += "	ZBE_CODIGO CODIGO2, ZBE_DESCRI NIVEL2, ZBE_REPRES CODREPRES2," + CRLF
	cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBE.ZBE_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES2," + CRLF
	cQryArq += "	ZBF_CODIGO CODIGO3, ZBF_DESCRI NIVEL3, ZBF_REPRES CODREPRES3," + CRLF
	cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBF.ZBF_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES3," + CRLF
	cQryArq += "	ZBG_CODIGO CODIGO4, ZBG_DESCRI NIVEL4, ZBG_REPRES CODREPRES4," + CRLF
	cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBG.ZBG_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES4," + CRLF
	cQryArq += "	ZBH_CODIGO CODIGO5, ZBH_DESCRI NIVEL5, ZBH_REPRES CODREPRES5," + CRLF
	cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBH.ZBH_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES5," + CRLF
	cQryArq += "	ZBI_CODIGO CODIGO6, ZBI_DESCRI NIVEL6, ZBI_REPRES CODREPRES6," + CRLF
	cQryArq += "	(SELECT A3_NOME FROM " + retSQLName("SA3") + " SUBSA3 WHERE SUBSA3.A3_COD = ZBI.ZBI_REPRES AND SUBSA3.D_E_L_E_T_ <> '*') REPRES6," + CRLF
	cQryArq += "	A1_COD, A1_LOJA, A1_NOME, A1_CGC," + CRLF

	cQryArq += "	A1_END, A1_BAIRRO, A1_CEP, A1_MUN, A1_EST, A1_DDD,"										+ CRLF
	cQryArq += "	A1_TEL, A1_CONTATO, A1_EMAIL, A1_LC, (A1_LC-(A1_SALDUP+A1_SALPEDL)) LIMDISPO, A1_COND,A1_ULTCOM,A1_ZREDE,A1_ZREGIAO,A1_ZVIDAUT,"	+ CRLF

	cQryArq += " ("															+ CRLF
	cQryArq += " SELECT E4_COND"											+ CRLF
	cQryArq += " FROM " + retSQLName("SE4") + " SE4"						+ CRLF
	cQryArq += " WHERE"														+ CRLF
	cQryArq += " 		SE4.E4_CODIGO		=	SA1.A1_COND"				+ CRLF
	cQryArq += " 	AND	SE4.E4_FILIAL		=	'" + xFilial("SE4") + "'"	+ CRLF
	cQryArq += " 	AND	SE4.D_E_L_E_T_	<>	'*'"							+ CRLF
	cQryArq += " ) E4_COND, A1_MSBLQL,"		 								+ CRLF

	cQryArq += " AOV_DESSEG,"		 										+ CRLF

	cQryArq += " ("															+ CRLF
	cQryArq += " SELECT ZE9_DESTIP"											+ CRLF
	cQryArq += " FROM " + retSQLName("ZE9") + " ZE91"						+ CRLF
	cQryArq += " WHERE"														+ CRLF
	cQryArq += "		ZE91.ZE9_TIPOLO =	SA1.A1_SATIV1"					+ CRLF
	cQryArq += "	AND	ZE91.ZE9_FILIAL	=	'" + xFilial("ZE9") + "'" 		+ CRLF
	cQryArq += "	AND	ZE91.D_E_L_E_T_	<>	'*'" 							+ CRLF
	cQryArq += "	AND	ROWNUM = 1"				 							+ CRLF
	cQryArq += " ) ZE9_DESTIP,"												+ CRLF

	cQryArq += " ("															+ CRLF
	cQryArq += " SELECT ZE9_DESCAT"											+ CRLF
	cQryArq += " FROM " + retSQLName("ZE9") + " ZE92"						+ CRLF
	cQryArq += " WHERE"														+ CRLF
	cQryArq += "		ZE92.ZE9_CATEGO	=	SA1.A1_SATIV2"					+ CRLF
	cQryArq += "	AND	ZE92.ZE9_FILIAL	=	'" + xFilial("ZE9") + "'" 		+ CRLF
	cQryArq += "	AND	ZE92.D_E_L_E_T_	<>	'*'" 							+ CRLF
	cQryArq += "	AND	ROWNUM = 1"				 							+ CRLF
	cQryArq += " ) ZE9_DESCAT,"												+ CRLF

	cQryArq += " ("															+ CRLF
	cQryArq += " SELECT ZE9_DESCAN"											+ CRLF
	cQryArq += " FROM " + retSQLName("ZE9") + " ZE93"						+ CRLF
	cQryArq += " WHERE"														+ CRLF
	cQryArq += "		ZE93.ZE9_CANAL 	=	SA1.A1_SATIV3"					+ CRLF
	cQryArq += "	AND	ZE93.ZE9_FILIAL	=	'" + xFilial("ZE9") + "'" 		+ CRLF
	cQryArq += "	AND	ZE93.D_E_L_E_T_	<>	'*'" 							+ CRLF
	cQryArq += "	AND	ROWNUM = 1"				 							+ CRLF
	cQryArq += " ) ZE9_DESCAN"												+ CRLF

    /*
	cQryArq += "FROM " + retSQLName("ZBD") + " ZBD" 		+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBE") + " ZBE" 	+ CRLF
	cQryArq += "ON" 										+ CRLF
	cQryArq += "	ZBD.ZBD_CODIGO = ZBE.ZBE_DIRETO" 		+ CRLF
	cQryArq += "INNER JOIN " + retSQLName("ZBF") + " ZBF" 	+ CRLF
	cQryArq += "ON" 										+ CRLF
	cQryArq += "	ZBE.ZBE_CODIGO = ZBF.ZBF_NACION" 		+ CRLF
	cQryArq += "AND	ZBE.ZBE_DIRETO = ZBF.ZBF_DIRETO" 		+ CRLF		
	cQryArq += "INNER JOIN " + retSQLName("ZBG") + " ZBG" 	+ CRLF
	cQryArq += "ON" 										+ CRLF
	cQryArq += "	ZBF.ZBF_CODIGO = ZBG.ZBG_TATICA" 		+ CRLF
	cQryArq += "AND	ZBF.ZBF_NACION = ZBG.ZBG_NACION"		+ CRLF	
	cQryArq += "INNER JOIN " + retSQLName("ZBH") + " ZBH" 	+ CRLF
	cQryArq += "ON"											+ CRLF
	cQryArq += "	ZBG.ZBG_CODIGO = ZBH.ZBH_REGION"		+ CRLF
	cQryArq += "AND	ZBG.ZBG_TATICA = ZBH.ZBH_TATICA"		+ CRLF	
	cQryArq += "INNER JOIN " + retSQLName("ZBI") + " ZBI"	+ CRLF
	cQryArq += "ON"											+ CRLF
	cQryArq += "	ZBH.ZBH_CODIGO = ZBI.ZBI_SUPERV"		+ CRLF
	cQryArq += "AND	ZBH.ZBH_REGION = ZBI.ZBI_REGION"		+ CRLF	
	*/

	cQryArq += StaticCall(MGFCRM16,QryNivSelEV,.F.)

	cQryArq += "LEFT JOIN " + retSQLName("ZBJ") + " ZBJ"	+ CRLF
	cQryArq += "ON" 										+ CRLF
	cQryArq += "		ZBJ.ZBJ_REPRES	=	ZBI.ZBI_REPRES"		+ CRLF
	cQryArq += "	AND ZBJ.ZBJ_ROTEIR	=	ZBI.ZBI_CODIGO" 		+ CRLF
	cQryArq += "	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'" + CRLF
	cQryArq += "	AND	ZBJ.D_E_L_E_T_	<>	'*'" + CRLF

	cQryArq += "LEFT JOIN " + retSQLName("SA1") + " SA1"	+ CRLF
	cQryArq += "ON"											+ CRLF
	cQryArq += "		ZBJ.ZBJ_CLIENT  =	SA1.A1_COD"		+ CRLF
	cQryArq += "	AND	ZBJ.ZBJ_LOJA  	=	SA1.A1_LOJA"	+ CRLF
	cQryArq += "	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'" + CRLF
	cQryArq += "	AND	SA1.D_E_L_E_T_	<>	'*'" + CRLF

	cQryArq += "LEFT JOIN " + retSQLName("AOV") + " AOV"	+ CRLF
	cQryArq += "ON"											+ CRLF
	cQryArq += "		AOV.AOV_CODSEG  =	SA1.A1_CODSEG"	+ CRLF
	cQryArq += "	AND	AOV.AOV_FILIAL	=	'" + xFilial("AOV") + "'" + CRLF
	cQryArq += "	AND	AOV.D_E_L_E_T_	<>	'*'" + CRLF

    /*
	cQryArq += "WHERE" + CRLF
	cQryArq += "		ZBD.ZBD_FILIAL	=	'" + xFilial("ZBD") + "'" + CRLF
	cQryArq += "	AND	ZBD.D_E_L_E_T_	<>	'*'" + CRLF
	cQryArq += "	AND	ZBE.ZBE_FILIAL	=	'" + xFilial("ZBE") + "'" + CRLF
	cQryArq += "	AND	ZBE.D_E_L_E_T_	<>	'*'" + CRLF
	cQryArq += "	AND	ZBF.ZBF_FILIAL	=	'" + xFilial("ZBF") + "'" + CRLF
	cQryArq += "	AND	ZBF.D_E_L_E_T_	<>	'*'" + CRLF
	cQryArq += "	AND	ZBG.ZBG_FILIAL	=	'" + xFilial("ZBG") + "'" + CRLF
	cQryArq += "	AND	ZBG.D_E_L_E_T_	<>	'*'" + CRLF
	cQryArq += "	AND	ZBH.ZBH_FILIAL	=	'" + xFilial("ZBH") + "'" + CRLF
	cQryArq += "	AND	ZBH.D_E_L_E_T_	<>	'*'" + CRLF
	cQryArq += "	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI") + "'" + CRLF
	cQryArq += "	AND	ZBI.D_E_L_E_T_	<>	'*'" + CRLF
	cQryArq += "	AND	ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBJ") + "'" + CRLF
	cQryArq += "	AND	ZBJ.D_E_L_E_T_	<>	'*'" + CRLF
	*/
	cQryArq += StaticCall(MGFCRM16, QryNivWheEV, .F. /*FILTRO NA ZBJ COLOCADO NO LEFT JOIN*/)

	memoWrite("C:\TEMP\MGFCRM29.sql", cQryArq)

	TcQuery cQryArq New Alias "QRYARQ"
return
