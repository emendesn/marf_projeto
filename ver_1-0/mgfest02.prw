#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"

#define CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST02

Consulta padrão específica para o fonte MGFEST01

@author Gustavo Ananias Afonso
@since 05/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST02()
	local cQrySZ4 	:= ""
	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	local oSxbEsp		:= nil
	local lOk			:=.T.
	local cCodigo		:= ""
	local oDlg			:= nil

	local aArea		:= getArea()
	local aAreaSM0	:= SM0->(getArea())
	Local cGrpEmp := FWGrpCompany()

	private oSxbSZ4		:= nil
	private aSZ4		:= {}

	cQrySZ4 := "SELECT *"
	cQrySZ4 += " FROM "			+ retSQLName("SZ4") + " SZ4"
	cQrySZ4 += " WHERE"
	cQrySZ4 += "		SZ4.Z4_FILIAL	=	'" + xFilial("SZ4")	+ "'"
	cQrySZ4 += "	AND	SZ4.D_E_L_E_T_	<>	'*'"

	If Select("QRYSZ4") > 0
		QRYSZ4->(dbCloseArea())
	Endif	
	TcQuery cQrySZ4 New Alias "QRYSZ4"

	SM0->(dbSetOrder(1))

	while !QRYSZ4->(EOF())
		if SM0->(DBSeek( cGrpEmp+QRYSZ4->Z4_UNIDADE ))
			aadd(aSZ4, {QRYSZ4->Z4_LOCAL, QRYSZ4->Z4_LOCDEST ,QRYSZ4->Z4_EMPRESA, SM0->M0_NOME, QRYSZ4->Z4_UNIDADE, SM0->M0_FILIAL})			
		endif
		QRYSZ4->(DBSkip())
	enddo

	QRYSZ4->(DBCloseArea())

	DEFINE MSDIALOG oDlg TITLE 'Consulta Armaz�ns x Unidades' FROM aCoors[1]/2, aCoors[2] TO aCoors[3]/2, aCoors[4] PIXEL STYLE DS_MODALFRAME
		oSxbSZ4 := fwBrowse():New()
		oSxbSZ4:setDataArray()
		oSxbSZ4:setArray(aSZ4)
		oSxbSZ4:disableConfig()
		oSxbSZ4:disableReport()
		oSxbSZ4:setOwner(oDlg)
		oSxbSZ4:addColumn({"Local Origem"			, {||aSZ4[oSxbSZ4:nAt,1]}, "C", pesqPict("SZ4","Z4_LOCAL")		, 1, tamSx3("Z4_LOCAL")[1]})
		oSxbSZ4:addColumn({"Local Destino"			, {||aSZ4[oSxbSZ4:nAt,2]}, "C", pesqPict("SZ4","Z4_LOCDEST")	, 1, tamSx3("Z4_LOCDEST")[1]})
		oSxbSZ4:addColumn({"C�d. Empresa Destino"	, {||aSZ4[oSxbSZ4:nAt,3]}, "C", pesqPict("SZ4","Z4_EMPRESA")	, 1, tamSx3("Z4_EMPRESA")[1]})
		oSxbSZ4:addColumn({"Empresa Destino"		, {||aSZ4[oSxbSZ4:nAt,4]}, "C", 									, 1, })
		oSxbSZ4:addColumn({"C�d. Unidade Destino"	, {||aSZ4[oSxbSZ4:nAt,5]}, "C", pesqPict("SZ4","Z4_UNIDADE")	, 1, tamSx3("Z4_UNIDADE")[1]})
		oSxbSZ4:addColumn({"Unidade Destino"		, {||aSZ4[oSxbSZ4:nAt,6]}, "C",										, 1, })
		oSxbSZ4:setDoubleClick( { || setVars(), oDlg:end() } )
		oSxbSZ4:activate(.T.)

		enchoiceBar(oDlg, { || setVars(), oDlg:end() } , { || cGetCdArma := "", oDlg:end() })
	ACTIVATE MSDIALOG oDlg CENTER

	restArea(aAreaSM0)
	restArea(aArea)
return (.T.)

//------------------------------------------------
// Alimenta variaveis
//------------------------------------------------
static function setVars()

	cGetCdArma	:= allTrim(aSZ4[oSxbSZ4:nAt,1])
	cCdArmaDes	:= allTrim(aSZ4[oSxbSZ4:nAt,2])
	cCodEmpresa	:= allTrim(aSZ4[oSxbSZ4:nAt,3])
	cGetEmpres	:= allTrim(aSZ4[oSxbSZ4:nAt,4])
	cCodFilial	:= allTrim(aSZ4[oSxbSZ4:nAt,5])
	cGetUnidad	:= allTrim(aSZ4[oSxbSZ4:nAt,6])
return

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST03

Retorno da consulta padrão MGFEST02

@author Gustavo Ananias Afonso
@since 05/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST03()
return (cGetCdArma)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST04

Retorno da consulta padrão MGFEST02

@author Gustavo Ananias Afonso
@since 05/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST04()
return ""

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST05

Retorno da consulta padrão MGFEST02

@author Gustavo Ananias Afonso
@since 05/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST05()
return (cCdArmaDes)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST06

Retorno da consulta padrão MGFEST02

@author Gustavo Ananias Afonso
@since 05/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST06()
return cDscArmDes

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST07

Retorno da consulta padrão MGFEST02

@author Gustavo Ananias Afonso
@since 05/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST07()
return (cCodEmpresa)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST13

Retorno da consulta padrão MGFEST02

@author Gustavo Ananias Afonso
@since 05/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST13()
return (cGetEmpres)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST14

Retorno da consulta padrão MGFEST02

@author Gustavo Ananias Afonso
@since 05/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST14()
return (cCodFilial)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFEST15

Retorno da consulta padrão MGFEST02

@author Gustavo Ananias Afonso
@since 05/09/2016

/*/
//-------------------------------------------------------------------
user function MGFEST15()
return (cGetUnidad)


User Function EST02FilNNR()

Local lRet := .F.

lRet := NNR->NNR_FILIAL == cFilAnt

Return(lRet)


User Function Est02ConPad()

Public _Est02ConPad := ""

//cEmpAnt := IIf(!Empty(Alltrim(M->Z4_EMPRESA)),Alltrim(M->Z4_EMPRESA),cEmpAnt)
cFilAnt := IIf(!Empty(Alltrim(M->Z4_UNIDADE)),Alltrim(M->Z4_UNIDADE),cFilAnt)

ConPad1(,,,"NNR",,,.F.) // ConPad1(,,,"NNRSZ4",,,.F.)
_Est02ConPad := NNR->NNR_CODIGO

cEmpAnt := cEmpSav
cFilAnt := cFilSav

Return(.T.)