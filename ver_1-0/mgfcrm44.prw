#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"

#define CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFCRM44

Consulta padrao especifica para a RAMI

@author Gustavo Ananias Afonso - TOTVS Campinas
@since 18/07/17

/*/
//-------------------------------------------------------------------
user function MGFCRM44()
	local cQryZAV 		:= ""
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	local oDlg			:= nil
	local aSeek			:= {}

	private oSxbZAV		:= nil
	private aZAV		:= {}

	cQryZAV := "SELECT *"
	cQryZAV += " FROM "			+ retSQLName("ZAV") + " ZAV"
	cQryZAV += " INNER JOIN "	+ retSQLName("SF2") + " SF2"
	cQryZAV += " ON"
	cQryZAV += "		ZAV.ZAV_SERIE	=	SF2.F2_SERIE"
	cQryZAV += "	AND	ZAV.ZAV_NOTA	=	SF2.F2_DOC"
	cQryZAV += ""
	cQryZAV += " WHERE"
	cQryZAV += "		SF2.F2_LOJA		=	'" + cLoja			+ "'"
	cQryZAV += "	AND	SF2.F2_CLIENTE	=	'" + cA100For		+ "'"
	cQryZAV += "	AND	ZAV.ZAV_STATUS	=	'0'" // Em Andamento
	cQryZAV += "	AND	SF2.F2_FILIAL	=	'" + xFilial("SF2")	+ "'"
	cQryZAV += "	AND	ZAV.ZAV_FILIAL	=	'" + xFilial("ZAV")	+ "'"
	cQryZAV += "	AND	SF2.D_E_L_E_T_	<>	'*'"
	cQryZAV += "	AND	ZAV.D_E_L_E_T_	<>	'*'"
	/*	cQryZAV += "	AND	(ZAV.ZAV_CODIGO NOT IN"
	cQryZAV += "	("
	cQryZAV += "		SELECT DISTINCT D1_ZRAMI"
	cQryZAV += "		FROM " + retSQLName("SD1") + " SUBSD1"
	cQryZAV += "		WHERE"
	cQryZAV += "			SUBSD1.D1_ZRAMI		<>	' '"
	cQryZAV += "		AND	SUBSD1.D1_FILIAL	=	'" + xFilial("SD1")	+ "'"
	cQryZAV += "		AND	SUBSD1.D_E_L_E_T_	<>	'*'"
	cQryZAV += "	)"*/

	if select("QRYZAV") > 0
		QRYZAV->(DBCloseArea())
	endif

	TcQuery cQryZAV New Alias "QRYZAV"

	SM0->(dbSetOrder(1))

	if !QRYZAV->(EOF())
		while !QRYZAV->(EOF())
			aadd(aZAV, {QRYZAV->ZAV_FILIAL, QRYZAV->ZAV_CODIGO ,QRYZAV->ZAV_DTABER, QRYZAV->ZAV_NOTA, QRYZAV->ZAV_SERIE, QRYZAV->ZAV_NFEMIS})			
			QRYZAV->(DBSkip())
		enddo
		//Pesquisa que sera exibido
		aadd(aSeek,{"Senha"	, { {"","C",tamSx3("ZAV_CODIGO")[1]	, 0, "Senha"	,,} }})
		aadd(aSeek,{"Nota"	, { {"","C",tamSx3("ZAV_NOTA")[1]	, 0, "Nível 1"	,,} }})

		DEFINE MSDIALOG oDlg TITLE 'Consulta RAMI' FROM aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2, aCoors[4]/2 PIXEL STYLE DS_MODALFRAME
		oSxbZAV := fwBrowse():New()
		oSxbZAV:setDataArray()
		oSxbZAV:setArray(aZAV)
		oSxbZAV:disableConfig()
		oSxbZAV:disableReport()
		oSxbZAV:setOwner(oDlg)
		oSxbZAV:setSeek(, aSeek)

		oSxbZAV:addColumn({"Filial"			, {||aZAV[oSxbZAV:nAt,1]}, "C", , 1, tamSx3("ZAV_FILIAL")[1]})
		oSxbZAV:addColumn({"Senha"			, {||aZAV[oSxbZAV:nAt,2]}, "C", , 1, tamSx3("ZAV_CODIGO")[1]})
		oSxbZAV:addColumn({"Dt. Abertura"	, {||aZAV[oSxbZAV:nAt,3]}, "D", , 1, 10						})
		oSxbZAV:addColumn({"Nota"			, {||aZAV[oSxbZAV:nAt,4]}, "C", , 1, tamSx3("ZAV_NOTA")[1]	})
		oSxbZAV:addColumn({"Série"			, {||aZAV[oSxbZAV:nAt,5]}, "C", , 1, tamSx3("ZAV_SERIE")[1]	})
		oSxbZAV:addColumn({"Emissão NF"		, {||aZAV[oSxbZAV:nAt,6]}, "D",	, 1, 10						})
		oSxbZAV:setDoubleClick( { || MV_PAR01 := aZAV[oSxbZAV:nAt, 2], oDlg:end() } )
		oSxbZAV:activate(.T.)

		enchoiceBar(oDlg, { || MV_PAR01 := aZAV[oSxbZAV:nAt, 2], oDlg:end() } , { || MV_PAR01 := "", oDlg:end() })
		ACTIVATE MSDIALOG oDlg CENTER

	else
		msgAlert("Não foi encontrado RAMI para este cliente.")
	endif

	QRYZAV->(DBCloseArea())

return (.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} crm44ret

Retorno da consulta padrao MGFCRM44

@author Gustavo Ananias Afonso
@since 18/07/17

/*/
//-------------------------------------------------------------------
user function crm44ret()
return (MV_PAR01)
