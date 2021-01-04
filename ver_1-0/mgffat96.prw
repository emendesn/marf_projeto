#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

user function MGFFAT96()
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
	local aCoors		:= 	FWGetDialogSize( oMainWnd )

	aadd(aParambox, {6, "Salvar arquivo CSV em"	, space(200)		, "@!"	, ""	, ""	, 070, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .F. /*NAO MOSTRA SERVIDOR*/})

return paramBox(aParambox, "Tabela de Preço E-Commerce"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function genArq()
	local aArea		:= getArea()
	local cNameFile	:= "Tabela_Ecommerce_" + dToS(dDataBase) + ".csv"
	local nHandle	:= 0
	local cStrCSV	:= ""

	if !existDir( allTrim( MV_PAR01 ) )
		msgAlert("Diretório inválido.")
		return
	endif

	nHandle := fCreate( allTrim(MV_PAR01) + cNameFile )
	if nHandle > 0
		getInfo()

		if !QRYARQ->(EOF())

			cStrCSV += "TABELA;CLIENTE;LOJA;CNPJ;NOME" + CRLF

			fWrite(nHandle , cStrCSV )

			QRYARQ->(DBGoTop())
			while !QRYARQ->(EOF())
				cStrCSV := ""

				cStrCSV += xClean(allTrim(QRYARQ->DA0_CODTAB))	+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_COD))		+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_LOJA))		+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_CGC))		+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->A1_NOME))		+ ""
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

	cQryArq := "SELECT DA0_CODTAB, A1_COD, A1_LOJA, A1_CGC, A1_NOME" 	+ CRLF
	cQryArq += " FROM "			+ retSQLName("DA0") + " DA0" 			+ CRLF
	cQryArq += " INNER JOIN "	+ retSQLName("SA1") + " SA1" 			+ CRLF
	cQryArq += " ON" 													+ CRLF
	cQryArq += " 		DA0.DA0_CODTAB	=	SA1.A1_ZPRCECO" 			+ CRLF
	cQryArq += " 	AND	SA1.A1_ZPRCECO	<>	' '" 						+ CRLF
	cQryArq += " 	AND	SA1.D_E_L_E_T_	<>	'*'" 						+ CRLF
	cQryArq += " WHERE" 												+ CRLF
	cQryArq += " 	DA0.D_E_L_E_T_	<>	'*'" 							+ CRLF

	memoWrite("C:\TEMP\MGFFAT96.sql", cQryArq)

	TcQuery cQryArq New Alias "QRYARQ"
return
