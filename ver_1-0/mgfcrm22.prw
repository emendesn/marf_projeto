#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM22
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              07/04/2017
Descricao / Objetivo:   Cadastro de Tatica - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM22(nOpcX, cCodPos, nRecno)
	local aArea		:= getArea()
	local aAreaZBF	:= ZBF->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	DBSelectArea("ZBF")
	//dbSetOrder(2)
	//ZBF->(DBGoTop())

	if nOpcX == 3
		fwExecView("Inclusão", "MGFCRM21", MODEL_OPERATION_INSERT,, {|| .T.}, , , aButtons)
	else
		//if ZBF->(DBSeek( xFilial("ZBF") + cCodPos ))
		ZBF->(dbGoto(nRecno))
		If ZBF->(Recno()) == nRecno
			if nOpcX == 4
				fwExecView("Alteração", "MGFCRM21", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)
			elseif nOpcX == 5
				if chkRelat()
					fwExecView("Alteração", "MGFCRM21", MODEL_OPERATION_DELETE,, {|| .T.}, , , aButtons)
				else
					msgAlert("Este registro não poderá ser excluído. O mesmo possui Regional abaixo dele.")
				endif
			endif
		else
			msgAlert("Registro não encontrado.")
		endif
	endif

	//ZBF->(DBCloseArea())

	restArea(aAreaZBF)
	restArea(aArea)
return

//---------------------------------------------
// Verifica se o registro possui niveis abaixo
//---------------------------------------------
static function chkRelat()
	local lRet	:= .T.
	local cQry	:= ""

	cQry := "SELECT *"
	cQry += " FROM " + retSQLName("ZBG") + " ZBG"
	cQry += " WHERE"
	cQry += " 		ZBG.ZBG_TATICA	=	'" + ZBF->ZBF_CODIGO	+ "'"
	cQry += " 	AND ZBG.ZBG_NACION	=	'" + ZBF->ZBF_NACION	+ "'"
	cQry += " 	AND ZBG.ZBG_DIRETO	=	'" + ZBF->ZBF_DIRETO	+ "'"
	cQry += " 	AND ZBG.ZBG_FILIAL	=	'" + xFilial("ZBG")		+ "'"
	cQry += " 	AND ZBG.D_E_L_E_T_	<>	'*'"

	TcQuery cQry New Alias "QRY"

	if !QRY->(EOF())
		lRet := .F.
	endif

	QRY->(DBCloseArea())
return lRet