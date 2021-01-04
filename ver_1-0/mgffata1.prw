#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

user function MGFFATA1()
	if aviso("Exportação Preços", "Serão exportados os preços de todas as Tabelas de Preço definidas como 'E-Commerce'. Deseja Continuar?", { "Continuar", "Cancelar" }, 1) == 1
		if getParam()
			//genArq()
			fwMsgRun(, {|| genArq() }, "Processando", "Aguarde. Gerando arquivo..." )
		endif
	endif
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}
	local aCoors		:= 	FWGetDialogSize( oMainWnd )

	aadd(aParambox, {6, "Salvar arquivo CSV em"	, space(200)		, "@!"	, ""	, ""	, 070, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .F. /*NAO MOSTRA SERVIDOR*/})

return paramBox(aParambox, "Preços E-Commerce"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function genArq()
	local aArea		:= getArea()
	local cNameFile	:= "Precos_Ecommerce_" + dToS(dDataBase) + ".csv"
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

			cStrCSV += "TABELA;COD_PRODUTO;PRODUTO;PRECO;BASE" + CRLF

			fWrite(nHandle , cStrCSV )

			QRYARQ->(DBGoTop())
			while !QRYARQ->(EOF())
				cStrCSV := ""

				cStrCSV += xClean(allTrim(QRYARQ->DA0_CODTAB))		+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->DA1_CODPRO))		+ ";"
				cStrCSV += xClean(allTrim(QRYARQ->B1_DESC))			+ ";"
				cStrCSV += xClean(allTrim(str(QRYARQ->DA1_PRCVEN)))	+ ";"
				cStrCSV += xClean(allTrim(str(QRYARQ->DA1_XPRCBA)))
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

	cQryArq := "SELECT DA0_CODTAB, DA1_CODPRO, B1_DESC, DA1_PRCVEN, DA1_XPRCBA" 	+ CRLF
	cQryArq += " FROM "			+ retSQLName("DA0") + " DA0" 			+ CRLF
	cQryArq += " INNER JOIN "	+ retSQLName("DA1") + " DA1" 			+ CRLF
	cQryArq += " ON" 													+ CRLF
	cQryArq += " 		DA0.DA0_CODTAB	=	DA1.DA1_CODTAB" 			+ CRLF
	cQryArq += " 	AND	DA1.DA1_FILIAL	=	'" + xFilial("DA1") + "'" 	+ CRLF
	cQryArq += " 	AND	DA1.D_E_L_E_T_	<>	'*'" 						+ CRLF
	cQryArq += " INNER JOIN "	+ retSQLName("SB1") + " SB1" 			+ CRLF
	cQryArq += " ON" 													+ CRLF
	cQryArq += " 		DA1.DA1_CODPRO	=	SB1.B1_COD" 				+ CRLF
	cQryArq += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'" 	+ CRLF
	cQryArq += " 	AND	SB1.D_E_L_E_T_	<>	'*'" 						+ CRLF
	cQryArq += " WHERE" 												+ CRLF
	cQryArq += " 		DA0.DA0_XENVEC	=	'1'" 						+ CRLF
	cQryArq += " 	AND	DA0.DA0_FILIAL	=	'" + xFilial("DA0") + "'" 	+ CRLF
	cQryArq += " 	AND	DA0.D_E_L_E_T_	<>	'*'" 						+ CRLF

	memoWrite("C:\TEMP\MGFFATA1.sql", cQryArq)

	TcQuery cQryArq New Alias "QRYARQ"
return
