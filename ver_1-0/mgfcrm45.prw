#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM45
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              05/07/2017
Descricao / Objetivo:   Exporta CSV RAMI
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              

=====================================================================================
*/
user function MGFCRM45()
	if getParam()
		fwMsgRun(, {|| genArq() }, "Processando", "Aguarde. Gerando arquivo..." )
	endif
return

//******************************************************
//******************************************************
static function getParam()
	local aRet			:= {}
	local aParambox		:= {}

	aadd(aParambox, {6, "Salvar arquivo CSV em"	, space(200)						, "@!"	, ""	, ""	, 070, .T., "Todos os Arquivos|*.*", GetTempPath(), GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .F. /*NAO MOSTRA SERVIDOR*/})
	aadd(aParamBox, {1, "RAMI de"				, space(tamSX3("ZAV_CODIGO")[1])	, 		, 		, "ZAV" ,	, 070	, .F.})
	aadd(aParamBox, {1, "RAMI atÈ"				, space(tamSX3("ZAV_CODIGO")[1])	, 		, 		, "ZAV" ,	, 070	, .F.})

	aadd(aParamBox, {1, "Emiss„o de"			, CToD(space(8))					, 		, 		, ""	,	, 070	, .F.})
	aadd(aParamBox, {1, "Emiss„o atÈ"			, CToD(space(8))					, 		, 		, ""	,	, 070	, .F.})
return paramBox(aParambox, "RAMI"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//******************************************************
//******************************************************
static function genArq()
	local cNameFile	:= "RAMI_" + dToS(dDataBase) + ".csv"
	local nHandle	:= 0
	local cStrCSV	:= ""
	local cVend		:= ""	

	if !existDir(allTrim(MV_PAR01))
		msgAlert("DiretÛrio inv·lido.")
		return
	endif

	nHandle := fCreate( allTrim(MV_PAR01) + cNameFile )
	if nHandle > 0
		getInfo()

		if !QRYARQ->(EOF())
			cStrCSV += "FILIAL;RAMI;DATA_ABERTURA;NOTA;SERIE;EMISSAO_NF;CLIENTE;TRANSPORTADORA;VENDEDOR;USUARIO;EMAIL;STATUS;"
			cStrCSV += "ITEM_OCORRENCIA;PRODUTO_OCORRENCIA;DESC_PRODUTO;QTDE;PRECO;TOTAL;MOTIVO;JUSTIFICATIVA;"
			//cStrCSV += "ITEM_RESOLUCAO;QTDE_RESOLUCAO;PRECO_RESOLUCAO;TOTAL_RESOLUCAO;STATUS_RESOLUCAO;RESOLUCAO" + CRLF
			cStrCSV += "ITEM_RESOLUCAO;QTDE_RESOLUCAO;PRECO_RESOLUCAO;TOTAL_RESOLUCAO" + CRLF

			fWrite(nHandle , cStrCSV )

			QRYARQ->(DBGoTop())
			while !QRYARQ->(EOF())
				cVend	:= RetField("SC5",1,ZAV_FILIAL+ZAV_PEDIDO,"C5_VEND1")
				cVend 	:= RetField("SA3",1,XFILIAL("SA3")+cVend,"A3_NOME")
				cStrCSV := ""

				cStrCSV += allTrim( ZAV_FILIAL +'-'+ FWFilialName(SUBSTR(ZAV_FILIAL,1,2),ZAV_FILIAL) )		+ ";" // FILIAL
				cStrCSV += allTrim( ZAV_CODIGO )			+ ";" // RAMI
				cStrCSV += dToc( sTod( ZAV_DTABER ) )		+ ";" // DATA_ABERTURA
				cStrCSV += allTrim( ZAV_NOTA )				+ ";" // NOTA
				cStrCSV += allTrim( ZAV_SERIE )				+ ";" // SERIE
				cStrCSV += allTrim( ZAV_NFEMIS )			+ ";" // EMISSAO_NF
				cStrCSV += allTrim( ZAV_NMCLI )				+ ";" // NOME CLIENTE
				cStrCSV += allTrim( ZAV_NMTRAN )			+ ";" // TRANSPORTADORA
				cStrCSV += allTrim( cVend )					+ ";" // NOME VENDEDOR
				cStrCSV += allTrim( ZAV_NOMEUS )			+ ";" // USUARIO
				cStrCSV += allTrim( ZAV_MAILUS )			+ ";" // EMAIL
				cStrCSV += iif( allTrim( ZAV_STATUS ) == "0" , "Em Andamento", "Finalizado" )			+ ";" // STATUS 0=Em Andamento;1=Finalizado
				cStrCSV += allTrim( ZAW_ID )				+ ";" // ITEM_OCORRENCIA
				cStrCSV += allTrim( ZAW_CDPROD )			+ ";" // PRODUTO_OCORRENCIA
				cStrCSV += allTrim( ZAW_DESCPR )			+ ";" // DESC_PRODUTO
				cStrCSV += allTrim( str( ZAW_QTD ) )		+ ";" // QTDE
				cStrCSV += allTrim( str( ZAW_PRECO ) )		+ ";" // PRECO
				cStrCSV += allTrim( str( ZAW_TOTAL ) )		+ ";" // TOTAL
				cStrCSV += allTrim( ZAW_MOTIVO )			+ ";" // MOTIVO
				cStrCSV += allTrim( ZAW_JUSTIF )			+ ";" // JUSTIFICATIVA
				cStrCSV += allTrim( ZAX_ID )				+ ";" // ITEM_RESOLUCAO
				cStrCSV += allTrim( str( ZAX_QTD ) )		+ ";" // QTDE_RESOLUCAO
				cStrCSV += allTrim( str( ZAX_PRECO ) )		+ ";" // PRECO_RESOLUCAO
				cStrCSV += allTrim( str( ZAX_TOTAL ) )		+ ";" // TOTAL_RESOLUCAO
				//cStrCSV += iif( allTrim( ZAX_STATUS ) == "1" , "Procedente", "Improcedente" )			+ ";" // STATUS_RESOLUCAO 1=Procedente;2=Improcedente
				//cStrCSV += allTrim( ZAX_RESOLU )			+ ";" // RESOLUCAO

				cStrCSV += CRLF

				fWrite(nHandle , cStrCSV )

				QRYARQ->(DBSkip())
			enddo

			msgInfo("ExportaÁ„o gerada com sucesso.")
		else
			msgAlert("N„o foram encontradas informaÁıes a serem exportadas.")
		endif
		QRYARQ->(DBCloseArea())
	endif

	fClose(nHandle)
return

//-------------------------------------------------------------------
/*/{Protheus.doc} getInfo()

Fun√ß√£o est√°tica, chamada pela defRelat, que seleciona os dados para
impress√£o no relat√≥rio

@author Gustavo Ananias Afonso
@since 24/10/2014
/*/
//-------------------------------------------------------------------
static function getInfo(nCountRegs)
	local cQueryZAV		:= ""

	cQueryZAV += " SELECT *"												+ CRLF
	cQueryZAV += " FROM " + retSQLName("ZAV") + " ZAV"						+ CRLF
	cQueryZAV += " LEFT JOIN " + retSQLName("ZAW") + " ZAW"				+ CRLF
	cQueryZAV += " ON"														+ CRLF
	cQueryZAV += " 		ZAV.ZAV_SERIE	=	ZAW.ZAW_SERIE"					+ CRLF
	cQueryZAV += " 	AND	ZAV.ZAV_NOTA	=	ZAW.ZAW_NOTA"					+ CRLF
	cQueryZAV += " 	AND	ZAW.D_E_L_E_T_	<>	'*'"						    + CRLF
	cQueryZAV += " LEFT JOIN " + retSQLName("ZAX") + " ZAX"				+ CRLF
	cQueryZAV += " ON"														+ CRLF
	cQueryZAV += " 		ZAW.ZAW_ITEMNF	=	ZAX.ZAX_ITEMNF"					+ CRLF
	cQueryZAV += " 	AND	ZAW.ZAW_SERIE	=	ZAX.ZAX_SERIE"					+ CRLF
	cQueryZAV += " 	AND	ZAW.ZAW_NOTA	=	ZAX.ZAX_NOTA"					+ CRLF
	cQueryZAV += " 	AND ZAX.D_E_L_E_T_	<>	'*'"							+ CRLF
	cQueryZAV += " WHERE 1=1"												+ CRLF
	cQueryZAV += " AND	ZAV.D_E_L_E_T_	<>	'*'"							+ CRLF

	if !empty(MV_PAR02)
		cQueryZAV += " AND ZAV_CODIGO >= '" + MV_PAR02 + "'" + CRLF
	endif

	if !empty(MV_PAR03)
		cQueryZAV += " AND ZAV_CODIGO <= '" + MV_PAR03 + "'" + CRLF
	endif

	if !empty(MV_PAR04)
		cQueryZAV += " AND ZAV_DTABER >= '" + dToS(MV_PAR04) + "'" + CRLF
	endif

	if !empty(MV_PAR05)
		cQueryZAV += " AND ZAV_DTABER <= '" + dToS(MV_PAR05) + "'" + CRLF
	endif

	cQueryZAV += " ORDER BY ZAV_NOTA, ZAV_SERIE, "									+ CRLF
	cQueryZAV += " 			ZAW_NOTA, ZAW_SERIE, ZAW_ITEMNF,"									+ CRLF
	cQueryZAV += " 			ZAX_NOTA, ZAX_SERIE, ZAX_ITEMNF"									+ CRLF

	conout(cQueryZAV)

	memoWrite("\" + funName() + "_d.log", cQueryZAV)
	//aviso("Query - " + funName(), cQueryZAV, {"Ok"})

	TcQuery cQueryZAV New Alias "QRYARQ"
return
