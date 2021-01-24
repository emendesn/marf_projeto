#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM36
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              19/04/2017
Descricao / Objetivo:   Cadastro de Cliente - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM36(nOpcX, cCodPos, nRecno)
	local aArea		:= getArea()
	local aAreaZBJ	:= ZBJ->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	DBSelectArea("ZBJ")
	//ZBJ->(DBSetOrder(3))
	//ZBJ->(DBGoTop())

	if nOpcX == 3
		if valType(nRecno) == "N" .and. nRecno > 0
			ZBJ->(dbGoto(nRecno))
		endif

		fwExecView("Inclusão", "MGFCRM35", MODEL_OPERATION_INSERT,, {|| .T.}, , , aButtons)
	else
		//if ZBJ->(DBSeek( xFilial("ZBJ") + cCodPos ))
		ZBJ->(dbGoto(nRecno))
		If ZBJ->(Recno()) == nRecno
			if nOpcX == 4
				fwExecView("Alteração", "MGFCRM35", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)
			elseif nOpcX == 5
				fwExecView("Alteração", "MGFCRM35", MODEL_OPERATION_DELETE,, {|| .T.}, , , aButtons)
			endif
		else
			msgAlert("Registro não encontrado.")
		endif
	endif

	//ZBJ->(DBCloseArea())

	restArea(aAreaZBJ)
	restArea(aArea)
return

//--------------------------------------------------------
// Inicializador Padrao dos campos ZBJ
//--------------------------------------------------------
user function iniCRM36(cCpoZBI)
	local aArea		:= getArea()
	local aAreaZBD	:= ZBD->(getArea())
	local aAreaZBE	:= ZBE->(getArea())
	local aAreaZBF	:= ZBF->(getArea())
	local aAreaZBG	:= ZBG->(getArea())
	local aAreaZBH	:= ZBH->(getArea())
	local aAreaZBI	:= ZBI->(getArea())
	local cRoteir	:= ""
	local cRet		:= ""
	local nRecnoZBI	:= 0

	DBSelectArea("ZBD")
	DBSelectArea("ZBE")
	DBSelectArea("ZBF")
	DBSelectArea("ZBG")
	DBSelectArea("ZBH")
	DBSelectArea("ZBI")

	ZBD->(DBGoTop())
	ZBE->(DBGoTop())
	ZBF->(DBGoTop())
	ZBG->(DBGoTop())
	ZBH->(DBGoTop())
	ZBI->(DBGoTop())

	if !empty(cGet70)
		//cRoteir	:= subStr(cCombo7, 1, 6)
		//cRepres	:= subStr(cCombo7,At("/",cCombo7)+2,6)
		cRepres	:= cGet70
		nRecnoZBI := getRepZBI(cRepres)

		//cQryZBJ += " 	AND	ZBJ.ZBJ_REPRES	=	'" + subStr(cCombo7,At("/",cCombo7)+2,6) + "'" + CRLF
		//cQryZBJ += " 	AND	ZBJ.ZBJ_ROTEIR	=	'" + subStr(cCombo7,1,6) + "'" + CRLF

		if nRecnoZBI > 0
			ZBI->( DBGoTo( nRecnoZBI ) )
			if cCpoZBI == "ZBJ_ROTEIR"
				cRet := ZBI->ZBI_CODIGO
			elseif cCpoZBI == "ZBJ_DIRETO"
				cRet := ZBI->ZBI_DIRETO
			elseif cCpoZBI == "ZBJ_NACION"
				cRet := ZBI->ZBI_NACION
			elseif cCpoZBI == "ZBJ_TATICA"
				cRet := ZBI->ZBI_TATICA
			elseif cCpoZBI == "ZBJ_REGION"
				cRet := ZBI->ZBI_REGION
			elseif cCpoZBI == "ZBJ_SUPERV"
				cRet := ZBI->ZBI_SUPERV
			elseif cCpoZBI == "ZBJ_REPRES"
				cRet := ZBI->ZBI_REPRES
			elseif cCpoZBI == "ZBJ_DESROT"
				cRet := ZBI->ZBI_DESCRI
			elseif cCpoZBI == "ZBJ_DESREP"
				cRet := Posicione("SA3", 1, xFilial("SA3") + ZBI->ZBI_REPRES, "A3_NOME")
			elseif cCpoZBI == "ZBJ_DESDIR"
				cRet := Posicione("ZBD", 1, xFilial("ZBD") + ZBI->ZBI_DIRETO, "ZBD_DESCRI")
			elseif cCpoZBI == "ZBJ_DESNAC"
				cRet := Posicione("ZBE", 3, xFilial("ZBE") + ZBI->( ZBI_DIRETO + ZBI_NACION ), "ZBE_DESCRI")
			elseif cCpoZBI == "ZBJ_DESTAT"
				//ZBF_FILIAL+ZBF_DIRETO+ZBF_NACION+ZBF_CODIGO
				cRet := Posicione("ZBF", 3, xFilial("ZBF") + ZBI->( ZBI_DIRETO + ZBI_NACION + ZBI_TATICA ), "ZBF_DESCRI")
			elseif cCpoZBI == "ZBJ_DESREG"
				//ZBG_FILIAL+ZBG_DIRETO+ZBG_NACION+ZBG_TATICA+ZBG_CODIGO
				cRet := Posicione("ZBG", 3, xFilial("ZBG") + ZBI->( ZBI_DIRETO + ZBI_NACION + ZBI_TATICA + ZBI_REGION ), "ZBG_DESCRI")
			elseif cCpoZBI == "ZBJ_DESSUP"
				//ZBH_FILIAL+ZBH_DIRETO+ZBH_NACION+ZBH_TATICA+ZBH_REGION+ZBH_CODIGO
				cRet := Posicione("ZBH", 3, xFilial("ZBH") + ZBI->( ZBI_DIRETO + ZBI_NACION + ZBI_TATICA + ZBI_REGION + ZBI_SUPERV ), "ZBH_DESCRI")
			endif
		endif
	else
		cRet := ""
	endif

	restArea(aAreaZBI)
	restArea(aAreaZBH)
	restArea(aAreaZBG)
	restArea(aAreaZBF)
	restArea(aAreaZBE)
	restArea(aAreaZBD)
	restArea(aArea)
return cRet

//-------------------------------------------------------
//-------------------------------------------------------
static function getRepZBI(cRepres)
	local cQryZBI	:= ""
	local nRecnoZBI	:= 0

	cQryZBI := "SELECT R_E_C_N_O_ ZBIRECNO"
	cQryZBI += " FROM " + retSQLName("ZBI") + " ZBI"
	cQryZBI += " WHERE"
	cQryZBI += "		ZBI.ZBI_REPRES	=	'" + cRepres		+ "'"
	cQryZBI += "	AND	ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI") + "'"
	cQryZBI += "	AND	ZBI.D_E_L_E_T_	<>	'*'"

	TcQuery cQryZBI New Alias "QRYZBI"

	if !QRYZBI->(EOF())
		nRecnoZBI := QRYZBI->ZBIRECNO
	endif

	QRYZBI->(DBCloseArea())
return nRecnoZBI
