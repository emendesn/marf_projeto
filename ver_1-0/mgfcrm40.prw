#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM40
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              04/07/2017
Descricao / Objetivo:   Exporta CSV das Metas
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM40()
	if getParam()
		//genArq()
		fwMsgRun(, {|| genArq() }, "Processando", "Aguarde. Gerando arquivo..." )
	endif
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}

	aadd(aParambox, {6, "Salvar arquivo CSV em"	, space(200)		, "@!"	, ""	, ""	, 070, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .F. /*NAO MOSTRA SERVIDOR*/})

return paramBox(aParambox, "Estrutura de Vendas"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function genArq()
	local cNameFile	:= "Metas" + dToS(dDataBase) + ".csv"
	local nHandle	:= 0
	local cStrCSV	:= ""

	if !existDir(allTrim(MV_PAR01))
		msgAlert("Diretório inválido.")
		return
	endif

	nHandle := fCreate( allTrim(MV_PAR01) + cNameFile )
	if nHandle > 0
		getInfo()

		if !QRYARQ->(EOF())

			cStrCSV += "VENDEDOR;COD_CATEG;CATEGORIA;DESC_CATEGORIA;ATIVO;VALOR;DT_INICIO;DT_FIM"+ CRLF

			fWrite(nHandle , cStrCSV )

			QRYARQ->(DBGoTop())
			while !QRYARQ->(EOF())
				cStrCSV := ""

				cStrCSV += allTrim(QRYARQ->ZBQ_VENDED)		+ ";"
				cStrCSV += allTrim(QRYARQ->VENDEDOR)		+ ";"
				cStrCSV += allTrim(QRYARQ->ZBQ_CATEGO)		+ ";"
				cStrCSV += allTrim(QRYARQ->DESCATEG)		+ ";"
				cStrCSV += iif(QRYARQ->ZBQ_ATIVO == "1", "Sim","Nao") + ";"
				cStrCSV += allTrim(str(QRYARQ->ZBQ_VALOR))		+ ";"
				cStrCSV += dToc(sTod(QRYARQ->ZBQ_DTINIC))	+ ";"
				cStrCSV += dToc(sTod(QRYARQ->ZBQ_DTFIM))

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
return

//******************************************************
//******************************************************
static function getInfo()
	local cQryArq := ""

	cQryArq += "SELECT ZBQ_VENDED, A3_NOME VENDEDOR, ZBQ_CATEGO, ZBP_DESCRI DESCATEG, ZBQ_VALOR, ZBQ_ATIVO, ZBQ_DTINIC, ZBQ_DTFIM"	+ CRLF
	cQryArq += "	FROM "			+ retSQLName("ZBQ") + " ZBQ"			+ CRLF
	cQryArq += "	INNER JOIN "	+ retSQLName("SA3") + " SA3"			+ CRLF
	cQryArq += "	ON"														+ CRLF
	cQryArq += " 		SA3.A3_COD		=	ZBQ.ZBQ_VENDED"					+ CRLF
	cQryArq += " 	AND	SA3.A3_FILIAL	=	'" + xFilial("SA3") + "'"		+ CRLF
	cQryArq += " 	AND	SA3.D_E_L_E_T_	<>	'*'"							+ CRLF
	cQryArq += "	INNER JOIN " + retSQLName("ZBP") + " ZBP"				+ CRLF
	cQryArq += "	ON"														+ CRLF
	cQryArq += " 		ZBP.ZBP_CODIGO	=	ZBQ.ZBQ_CATEGO"					+ CRLF
	cQryArq += " 	AND	ZBP.ZBP_FILIAL	=	'" + xFilial("ZBP") + "'"		+ CRLF
	cQryArq += " 	AND	ZBP.D_E_L_E_T_	<>	'*'"							+ CRLF
	cQryArq += " WHERE"														+ CRLF
	cQryArq += " 		ZBQ.ZBQ_FILIAL	=	'" + xFilial("ZBQ") + "'"		+ CRLF
	cQryArq += " 	AND	ZBQ.D_E_L_E_T_	<>	'*'"							+ CRLF

	TcQuery cQryArq New Alias "QRYARQ"
return
