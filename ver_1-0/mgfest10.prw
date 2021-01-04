#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"

#define CRLF chr(13) + chr(10)

static cChaveSD1 := space(tamSx3("D1_FILIAL")[1] + tamSx3("D1_DOC")[1] + tamSx3("D1_SERIE")[1] + tamSx3("D1_FORNECE")[1] + tamSx3("D1_LOJA")[1] + tamSx3("D1_COD")[1] + tamSx3("D1_ITEM")[1])
//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST10

Consulta padrão específica para o fonte MGFEST01

@author Gustavo Ananias Afonso
@since 06/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST10()
	local cQrySD1 	:= ""
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	local lOk			:=.T.
	local cCodigo		:= ""
	local oDlg			:= nil

	private oSxbSD1		:= nil
	private aSD1		:= {}

	cQrySD1 := "SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM"
	cQrySD1 += " FROM "			+ retSQLName("SD1") + " SD1"
	cQrySD1 += " WHERE"
	cQrySD1 += "		SD1.D1_FILIAL	=	'" + xFilial("SD1")	+ "'"
	cQrySD1 += "	AND	SD1.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySD1 New Alias "QRYSD1"

	while !QRYSD1->(EOF())
		aadd(aSD1, {QRYSD1->D1_FILIAL, QRYSD1->D1_DOC, QRYSD1->D1_SERIE, QRYSD1->D1_FORNECE, QRYSD1->D1_LOJA, QRYSD1->D1_COD, QRYSD1->D1_ITEM})
		QRYSD1->(DBSkip())
	enddo

	QRYSD1->(DBCloseArea())

	DEFINE MSDIALOG oDlg TITLE 'Consulta Nota Fiscal de Origem' FROM aCoors[1]/2, aCoors[2]/2 TO aCoors[3]/2, aCoors[4]/2 PIXEL STYLE DS_MODALFRAME
		oSxbSD1 := fwBrowse():New()
		oSxbSD1:setDataArray()
		oSxbSD1:setArray(aSD1)
		oSxbSD1:disableConfig()
		oSxbSD1:disableReport()
		oSxbSD1:setOwner(oDlg)
		oSxbSD1:addColumn({"Filial"		, {||aSD1[oSxbSD1:nAt,1]}, "C", pesqPict("SD1","D1_FILIAL")	, 1, tamSx3("D1_FILIAL")[1]})
		oSxbSD1:addColumn({"Nota"		, {||aSD1[oSxbSD1:nAt,2]}, "C", pesqPict("SD1","D1_DOC")	, 1, tamSx3("D1_DOC")[1]})
		oSxbSD1:addColumn({"S�rie"		, {||aSD1[oSxbSD1:nAt,3]}, "C", pesqPict("SD1","D1_SERIE")	, 1, tamSx3("D1_SERIE")[1]})
		oSxbSD1:addColumn({"Fornecedor"	, {||aSD1[oSxbSD1:nAt,4]}, "C", pesqPict("SD1","D1_FORNECE"), 1, tamSx3("D1_FORNECE")[1]})
		oSxbSD1:addColumn({"Loja"		, {||aSD1[oSxbSD1:nAt,5]}, "C", pesqPict("SD1","D1_LOJA")	, 1, tamSx3("D1_LOJA")[1]})
		oSxbSD1:addColumn({"Produto"	, {||aSD1[oSxbSD1:nAt,6]}, "C", pesqPict("SD1","D1_COD")	, 1, tamSx3("D1_COD")[1]})
		oSxbSD1:addColumn({"Item"		, {||aSD1[oSxbSD1:nAt,7]}, "C", pesqPict("SD1","D1_ITEM")	, 1, tamSx3("D1_ITEM")[1]})
		oSxbSD1:setDoubleClick( { || cChaveSD1 := (aSD1[oSxbSD1:nAt,1] + aSD1[oSxbSD1:nAt,2] + aSD1[oSxbSD1:nAt,3] + aSD1[oSxbSD1:nAt,4] + aSD1[oSxbSD1:nAt,5] + aSD1[oSxbSD1:nAt,6] + aSD1[oSxbSD1:nAt,7]) , oDlg:end() } )
		oSxbSD1:activate(.T.)

		enchoiceBar(oDlg, { || cChaveSD1 := (aSD1[oSxbSD1:nAt,1] + aSD1[oSxbSD1:nAt,2] + aSD1[oSxbSD1:nAt,3] + aSD1[oSxbSD1:nAt,4] + aSD1[oSxbSD1:nAt,5] + aSD1[oSxbSD1:nAt,6] + aSD1[oSxbSD1:nAt,7]), oDlg:end() } , { || cChaveSD1 := "", oDlg:end() })
	ACTIVATE MSDIALOG oDlg CENTER
return (.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST11

Retorno da consulta padrão MGFEST10

@author Gustavo Ananias Afonso
@since 06/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST11()
return (cChaveSD1)
