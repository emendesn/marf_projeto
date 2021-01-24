#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM06
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              30/03/2017
Descricao / Objetivo:   RelatÛrio - RAMI
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM06()	
	if getParam()
		defRelat()
	endif
return

//-------------------------------------------------------------------
/*/{Protheus.doc} getParam()

Exibe tela com par√¢metros

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 30/03/2017
/*/
//-------------------------------------------------------------------
static function getParam()
	local nTamSenha	:= 6
	local aRet		:= {}
	local aParambox	:= {}

	aadd(aParamBox, {1, "Senha de"		, space(nTamSenha)	, 		, , "ZAV" ,	, 070	, .F.})
	aadd(aParamBox, {1, "Senha atÈ"		, space(nTamSenha)	, 		, , "ZAV" ,	, 070	, .F.})

	aadd(aParamBox, {1, "Emiss„o de"	, CToD(space(8))	, 		, , "" ,	, 070	, .F.})
	aadd(aParamBox, {1, "Emiss„o atÈ"	, CToD(space(8))	, 		, , "" ,	, 070	, .F.})

return paramBox(aParambox, "RelatÛrio de RAMI"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)

//-------------------------------------------------------------------
static function defRelat()
	local cLogo		:= ""//iif(cEmpAnt == "05", "\system\TR05.png", "\system\TR04.png")
	local cNomeRel	:= funName()
	local cTitRel	:= "RelatÛrio de An·lise de Mercado Interno"
	local cDescRel	:= "RelatÛrio de An·lise de Mercado Interno"

	private oReport		:= nil
	private oSecZAV		:= nil
	private oSecZAW		:= nil
	private oSecZAX		:= nil

	oReport := TReport():New(cNomeRel, cTitRel, {|| getParam()}, { || impRelat() }, cDescRel)
	oReport:lOnPageBreak := .T.					//Cabe√ßalho das se√ß√µes impressas ap√≥s a quebra de p√°gina
	oReport:setTotalInLine(.F.)					// Define que a impress√£o dos totalizadores ser√° em linha. Falso imprime em linha.
	//oReport:nFontBody := 9
	//oReport:cFontBody := "Arial"
	//oReport:SetLineHeight(55)

	oSecZAV := TRSection():New(oReport, cNomeRel,,,,, /*uTotalText*/,.T.)
	oSecZAV:SetHeaderSection(.T.)				// Define que imprime cabe√ßalho das c√©lulas na quebra de se√ß√£o
	oSecZAV:SetHeaderBreak(.T.)
	oSecZAV:lOnPageBreak := .T.				// Cabe√ßalho das se√ß√µes impressas ap√≥s a quebra de p√°gina
	oSecZAV:setTotalInLine(.F.)				// Define que a impress√£o dos totalizadores ser√° em linha.

	oSecZAW := TRSection():New(oSecZAV, "OcorrÍncias",,,,,,.T.)
	oSecZAW:SetHeaderSection(.T.)				// Define que imprime cabe√ßalho das c√©lulas na quebra de se√ß√£o
	oSecZAW:SetHeaderBreak(.T.)
	oSecZAW:lOnPageBreak := .T.				// Cabe√ßalho das se√ß√µes impressas ap√≥s a quebra de p√°gina

	oSecZAX := TRSection():New(oSecZAW, "ResoluÁıes",,,,,,.T.)
	oSecZAX:SetHeaderSection(.T.)				// Define que imprime cabe√ßalho das c√©lulas na quebra de se√ß√£o
	oSecZAX:SetHeaderBreak(.T.)
	oSecZAX:lOnPageBreak := .T.				// Cabe√ßalho das se√ß√µes impressas ap√≥s a quebra de p√°gina

	TRCell():New(oSecZAV, "ZAV_CODIGO"		, "QRYZAV"	, "Senha"		, , /*tamanho*/, , , "LEFT"				, 		, "LEFT",, 1 /*nColSpace*/)
	TRCell():New(oSecZAV, "ZAV_DTABER"		, "QRYZAV"	, "Abertura"	, , /*tamanho*/, , , "LEFT"				, 		, "LEFT",, 1 /*nColSpace*/)
	TRCell():New(oSecZAV, "ZAV_NOTA"		, "QRYZAV"	, "Nota"		, , /*tamanho*/, , , "LEFT"				, 		, "LEFT",, 1 /*nColSpace*/)
	TRCell():New(oSecZAV, "ZAV_SERIE"		, "QRYZAV"	, "SÈrie"		, , /*tamanho*/, , , "LEFT"				, 		, "LEFT",, 1 /*nColSpace*/)
	TRCell():New(oSecZAV, "ZAV_NFEMIS"		, "QRYZAV"	, "Emiss„o NF"	, , /*tamanho*/, , , "LEFT"				, 		, "LEFT",, 1 /*nColSpace*/)
	TRCell():New(oSecZAV, "ZAV_NOMEUS"		, "QRYZAV"	, "Usu·rio"		, , /*tamanho*/, , , "LEFT"				, .T.	, "LEFT",, 1 /*nColSpace*/)
	TRCell():New(oSecZAV, "ZAV_MAILUS"		, "QRYZAV"	, "E-mail"		, , /*tamanho*/, , , "LEFT"				, .T.	, "LEFT",, 1 /*nColSpace*/)
	TRCell():New(oSecZAV, "ZAV_STATUS"		, "QRYZAV"	, "Status"		, , /*tamanho*/, , , "LEFT"				, 		, "LEFT",, 1 /*nColSpace*/)

	TRCell():New(oSecZAW, "ZAW_ITEMNF"		, "QRYZAV"	, "Item"			, 					, , , , "LEFT"				, 					, "LEFT"					,, 1 /*nColSpace*/)
	TRCell():New(oSecZAW, "ZAW_NOTA"		, "QRYZAV"	, "Nota"			, 					, , , , "LEFT"				, 					, "LEFT"					,, 1 /*nColSpace*/)
	TRCell():New(oSecZAW, "ZAW_SERIE"		, "QRYZAV"	, "SÈrie"			, 					, , , , "LEFT"				, 					, "LEFT"					,, 1 /*nColSpace*/)
	TRCell():New(oSecZAW, "ZAW_CDPROD"		, "QRYZAV"	, "Produto"			, 					, , , , "LEFT"				, 					, "LEFT"					,, 1 /*nColSpace*/)
	TRCell():New(oSecZAW, "ZAW_DESCPR"		, "QRYZAV"	, "DescriÁ„o"		, 					, , , , "LEFT" /*cAlign*/	, .T./*lLineBreak*/	, "LEFT" /*cHeaderAlign*/	,, 1 /*nColSpace*/)
	TRCell():New(oSecZAW, "ZAW_QTD"			, "QRYZAV"	, "Qtd"				, "@E 99,999,999.99", , , , "RIGHT" /*cAlign*/	, /*lLineBreak*/	, "CENTER" /*cHeaderAlign*/	,, 1 /*nColSpace*/)
	TRCell():New(oSecZAW, "ZAW_PRECO"		, "QRYZAV"	, "PreÁo Un"		, "@E 99,999,999.99", , , , "RIGHT" /*cAlign*/	, /*lLineBreak*/	, "CENTER" /*cHeaderAlign*/	,, 1 /*nColSpace*/)
	TRCell():New(oSecZAW, "ZAW_TOTAL"		, "QRYZAV"	, "Total"			, "@E 99,999,999.99", , , , "RIGHT"				, 					, "CENTER"					,, 1 /*nColSpace*/)
	TRCell():New(oSecZAW, "ZAW_MOTIVO"		, "QRYZAV"	, "Motivo"			, 					, , , , "LEFT" /*cAlign*/	, .T./*lLineBreak*/	, "LEFT" /*cHeaderAlign*/	,, 1 /*nColSpace*/)
	TRCell():New(oSecZAW, "ZAW_JUSTIF"		, "QRYZAV"	, "Justificativa"	, 					, , , , "LEFT" /*cAlign*/	, .T./*lLineBreak*/	, "LEFT" /*cHeaderAlign*/	,, 1 /*nColSpace*/)

	TRCell():New(oSecZAX, "ZAX_ITEMNF"		, "QRYZAV"	, "Item"			, 					, , , , "LEFT"				, 					, "LEFT"					,, 1 /*nColSpace*/)
//	TRCell():New(oSecZAX, "ZAX_NOTA"		, "QRYZAV"	, "Nota"			, 					, , , , "LEFT"				, 					, "LEFT"					,, 1 /*nColSpace*/)
//	TRCell():New(oSecZAX, "ZAX_SERIE"		, "QRYZAV"	, "SÈrie"			, 					, , , , "LEFT"				, 					, "LEFT"					,, 1 /*nColSpace*/)
	TRCell():New(oSecZAX, "ZAX_CDPROD"		, "QRYZAV"	, "Produto"			, 					, , , , "LEFT"				, 					, "LEFT"					,, 1 /*nColSpace*/)
	TRCell():New(oSecZAX, "ZAX_DESCPR"		, "QRYZAV"	, "DescriÁ„o"		, 					, , , , "LEFT" /*cAlign*/	, .T./*lLineBreak*/	, "LEFT" /*cHeaderAlign*/	,, 1 /*nColSpace*/)
	TRCell():New(oSecZAX, "ZAX_QTD"			, "QRYZAV"	, "Qtd"				, "@E 99,999,999.99", , , , "RIGHT" /*cAlign*/	, /*lLineBreak*/	, "CENTER" /*cHeaderAlign*/	,, 1 /*nColSpace*/)
	TRCell():New(oSecZAX, "ZAX_PRECO"		, "QRYZAV"	, "PreÁo Un"		, "@E 99,999,999.99", , , , "RIGHT" /*cAlign*/	, /*lLineBreak*/	, "CENTER" /*cHeaderAlign*/	,, 1 /*nColSpace*/)
	TRCell():New(oSecZAX, "ZAX_TOTAL"		, "QRYZAV"	, "Total"			, "@E 99,999,999.99", , , , "RIGHT"				, 					, "CENTER"					,, 1 /*nColSpace*/)
	//TRCell():New(oSecZAX, "ZAX_RESOLU"		, "QRYZAV"	, "ResoluÁ„o"		, 					, , , , "LEFT" /*cAlign*/	, .T./*lLineBreak*/	, "LEFT" /*cHeaderAlign*/	,, 1 /*nColSpace*/)
	//TRCell():New(oSecZAX, "ZAX_STATUS"		, "QRYZAV"	, "Status"			, 					, , , , "LEFT" /*cAlign*/	, .T./*lLineBreak*/	, "LEFT" /*cHeaderAlign*/	,, 1 /*nColSpace*/)

	//TRFunction():New(oSecZAW:Cell("C6_VALOR")	, /* cID */,"SUM",/*oBreak*/, "Total do Cliente"/*cTitle*/,pesqPict("SC6","C6_VALOR")/*cPicture*/,/*uFormula*/, .T. /*lEndSection*/	,.T. /*lEndReport*/,/*lEndPage*/)

	oReport:printDialog()
return

//-------------------------------------------------------------------
static function impRelat()
	local nCountRegs	:= 0
	local cPedido	:= ""

	getInfo(@nCountRegs)
	oReport:SetMeter(nCountRegs)

	if nCountRegs > 0
		while !QRYZAV->(EOF())
			oSecZAV:init()

			oSecZAV:cell("ZAV_DTABER"):setValue( dToC( sToD( QRYZAV->ZAV_DTABER ) ) )
			oSecZAV:cell("ZAV_NFEMIS"):setValue( dToC( sToD( QRYZAV->ZAV_NFEMIS ) ) )

			oSecZAV:printLine()

			oSecZAW:init()
			while !QRYZAV->(EOF())
				oSecZAW:printLine()

				cNotaZAX	:= QRYZAV->ZAX_NOTA
				cSerieZAX	:= QRYZAV->ZAX_SERIE
				cItemZAX	:= QRYZAV->ZAX_ITEMNF
				oSecZAX:init()
				while !QRYZAV->(EOF()) .and. cNotaZAX == QRYZAV->ZAX_NOTA .and.;
											cSerieZAX == QRYZAV->ZAX_SERIE .and.;
											cItemZAX == QRYZAV->ZAX_ITEMNF
	
					oReport:incMeter(1)
	
					oSecZAX:printLine()
					QRYZAV->(DBSkip())
				enddo

				oSecZAX:finish()


				QRYZAV->(DBSkip())
			enddo
			oSecZAW:finish()

			oSecZAV:finish()
		enddo
	else
		msgAlert("Nao ha com os parametros informados!")
	endif

	QRYZAV->(DBCloseArea())
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

	cQueryZAV += " SELECT *"													+ CRLF
	cQueryZAV += " FROM " + retSQLName("ZAV") + " ZAV"						+ CRLF
	cQueryZAV += " INNER JOIN " + retSQLName("ZAW") + " ZAW"						+ CRLF
	cQueryZAV += " ON"						+ CRLF
	cQueryZAV += " 		ZAV.ZAV_SERIE	=	ZAW.ZAW_SERIE"						+ CRLF
	cQueryZAV += " 	AND	ZAV.ZAV_NOTA	=	ZAW.ZAW_NOTA"						+ CRLF
	cQueryZAV += " INNER JOIN " + retSQLName("ZAX") + " ZAX"						+ CRLF
	cQueryZAV += " ON"						+ CRLF
	cQueryZAV += " 		ZAW.ZAW_ITEMNF	=	ZAX.ZAX_ITEMNF"						+ CRLF
	cQueryZAV += " 	AND	ZAW.ZAW_SERIE	=	ZAX.ZAX_SERIE"						+ CRLF
	cQueryZAV += " 	AND	ZAW.ZAW_NOTA	=	ZAX.ZAX_NOTA"						+ CRLF

	cQueryZAV += " WHERE"													+ CRLF
	cQueryZAV += " 		ZAX.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQueryZAV += " 	AND	ZAW.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQueryZAV += " 	AND	ZAV.D_E_L_E_T_	<>	'*'"						+ CRLF

	if !empty(MV_PAR01)
		cQueryZAV += " AND ZAV_CODIGO >= '" + MV_PAR01 + "'" + CRLF
	endif

	if !empty(MV_PAR02)
		cQueryZAV += " AND ZAV_CODIGO <= '" + MV_PAR02 + "'" + CRLF
	endif

	if !empty(MV_PAR03)
		cQueryZAV += " AND ZAV_DTABER >= '" + dToS(MV_PAR03) + "'" + CRLF
	endif

	if !empty(MV_PAR04)
		cQueryZAV += " AND ZAV_DTABER <= '" + dToS(MV_PAR04) + "'" + CRLF
	endif

	cQueryZAV += " ORDER BY ZAV_NOTA, ZAV_SERIE, "									+ CRLF
	cQueryZAV += " 			ZAW_NOTA, ZAW_SERIE, ZAW_ITEMNF,"									+ CRLF
	cQueryZAV += " 			ZAX_NOTA, ZAX_SERIE, ZAX_ITEMNF"									+ CRLF

	conout(cQueryZAV)

	memoWrite("\" + funName() + "_d.log", cQueryZAV)
	//aviso("Query - " + funName(), cQueryZAV, {"Ok"})

	TcQuery cQueryZAV New Alias "QRYZAV"

	Count to nCountRegs

	QRYZAV->(DBGoTop())
return
