#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM42
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              05/07/2017
Descricao / Objetivo:   Exporta CSV Categoria de Produtos
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:              

COD_CATEGORIA;DESC_CATEGORIA;TIPO;DT_INICIO;DT_FIM;COD_PRODUTO;DESC_PRODUTO

=====================================================================================
*/
user function MGFCRM42()
	if getParam()
		fwMsgRun(, {|| genArq() }, "Processando", "Aguarde. Gerando arquivo..." )
	endif
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}

	aadd(aParambox, {6, "Salvar arquivo CSV em"	, space(200)		, "@!"	, ""	, ""	, 070, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .F. /*NAO MOSTRA SERVIDOR*/})
	aadd(aParamBox, {1, "Dt Inicio"				, cToD(space(8))	, 		, , 		,	, 070	, .F.	})
	aadd(aParamBox, {1, "Dt Fim"				, cToD(space(8))	, 		, , 		,	, 070	, .F.	})

return paramBox(aParambox, "Exporta Categ Produtos"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function genArq()
	local cNameFile	:= "Categ" + dToS(dDataBase) + ".csv"
	local nHandle	:= 0
	local cStrCSV	:= ""

	if !existDir(allTrim(MV_PAR01))
		msgAlert("Diret�rio inv�lido.")
		return
	endif

	nHandle := fCreate( allTrim(MV_PAR01) + cNameFile )
	if nHandle > 0
		getInfo()

		if !QRYARQ->(EOF())

			//ZBP_CODIGO, ZBP_DESCRI, ZBP_TIPO, ZBP_DTINIC, ZBP_DTFIM , ZBR_PRODUT, B1_DESC
			cStrCSV += "COD_CATEGORIA;DESC_CATEGORIA;TIPO;DT_INICIO;DT_FIM;COD_PRODUTO;DESC_PRODUTO"+ CRLF

			fWrite(nHandle , cStrCSV )

			QRYARQ->(DBGoTop())
			while !QRYARQ->(EOF())
				cStrCSV := ""

				cStrCSV += allTrim(QRYARQ->ZBP_CODIGO)		+ ";"
				cStrCSV += allTrim(QRYARQ->ZBP_DESCRI)		+ ";"
				cStrCSV += allTrim(QRYARQ->ZBP_TIPO)		+ ";"
				cStrCSV += dToc(sTod(QRYARQ->ZBP_DTINIC))	+ ";"
				cStrCSV += dToc(sTod(QRYARQ->ZBP_DTFIM))	+ ";"				
				cStrCSV += allTrim(QRYARQ->ZBR_PRODUT)		+ ";"
				cStrCSV += allTrim(QRYARQ->B1_DESC)

				cStrCSV += CRLF

				fWrite(nHandle , cStrCSV )

				QRYARQ->(DBSkip())
			enddo
			msgInfo("Exportacao gerada com sucesso.")
		else
			msgAlert("Nao  foram encontradas informacoes a serem exportadas.")
		endif
		QRYARQ->(DBCloseArea())
	endif

	fClose(nHandle)
return

//******************************************************
//******************************************************
static function getInfo()
	local cQryArq := ""

	cQryArq += "SELECT ZBP_CODIGO, ZBP_DESCRI, ZBP_TIPO, ZBP_DTINIC, ZBP_DTFIM , ZBR_PRODUT, B1_DESC"	+ CRLF
	cQryArq += "	FROM "			+ retSQLName("ZBP") + " ZBP"			+ CRLF
	cQryArq += "	INNER JOIN "	+ retSQLName("ZBR") + " ZBR"			+ CRLF
	cQryArq += "	ON"														+ CRLF
	cQryArq += " 		ZBR.ZBR_CATEGO	=	ZBP.ZBP_CODIGO"					+ CRLF
	cQryArq += " 	AND	ZBR.ZBR_FILIAL	=	'" + xFilial("ZBR") + "'"		+ CRLF
	cQryArq += " 	AND	ZBR.D_E_L_E_T_	<>	'*'"							+ CRLF
	cQryArq += "	INNER JOIN " + retSQLName("SB1") + " SB1"				+ CRLF
	cQryArq += "	ON"														+ CRLF
	cQryArq += " 		SB1.B1_COD		=	ZBR.ZBR_PRODUT"					+ CRLF
	cQryArq += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"		+ CRLF
	cQryArq += " 	AND	SB1.D_E_L_E_T_	<>	'*'"							+ CRLF
	cQryArq += " WHERE"														+ CRLF
	cQryArq += " 		ZBP.ZBP_FILIAL	=	'" + xFilial("ZBP") + "'"		+ CRLF
	cQryArq += " 	AND	ZBP.D_E_L_E_T_	<>	'*'"							+ CRLF

	if !empty(MV_PAR02)
		cQryArq += " 	AND	ZBP.ZBP_DTINIC >= '" + dToS(MV_PAR02) + "'"	+ CRLF
	endif

	if !empty(MV_PAR03)
		cQryArq += " 	AND	ZBP.ZBP_DTFIM <= '" + dToS(MV_PAR03) + "'"	+ CRLF
	endif

	TcQuery cQryArq New Alias "QRYARQ"
return
