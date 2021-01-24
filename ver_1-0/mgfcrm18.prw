#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM18
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              07/04/2017
Descricao / Objetivo:   Cadastro de Diretoria - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM18(nOpcX, cCodPos)
	local aArea		:= getArea()
	local aAreaZBD	:= ZBD->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	DBSelectArea("ZBD")
	ZBD->(DBGoTop())

	if nOpcX == 3
		fwExecView("Inclusão", "MGFCRM17", MODEL_OPERATION_INSERT,, {|| .T.}, , , aButtons)
	else
		if ZBD->(DBSeek( xFilial("ZBD") + cCodPos ))
			if nOpcX == 4
				fwExecView("Alteração", "MGFCRM17", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)
			elseif nOpcX == 5
				if chkRelat()
					fwExecView("Alteração", "MGFCRM17", MODEL_OPERATION_DELETE,, {|| .T.}, , , aButtons)
				else
					msgAlert("Este registro não poderá ser excluído. O mesmo possui Nacionais abaixo dele.")
				endif
			endif
		else
			msgAlert("Registro não encontrado.")
		endif
	endif

	ZBD->(DBCloseArea())

	restArea(aAreaZBD)
	restArea(aArea)
return

//---------------------------------------------
// Verifica se o registro possui niveis abaixo
//---------------------------------------------
static function chkRelat()
	local lRet	:= .T.
	local cQry	:= ""

	cQry := "SELECT *"
	cQry += " FROM " + retSQLName("ZBE") + " ZBE"
	cQry += " WHERE"
	cQry += " 		ZBE.ZBE_DIRETO	=	'" + ZBD->ZBD_CODIGO	+ "'"
	cQry += " 	AND ZBE.ZBE_FILIAL	=	'" + xFilial("ZBE")		+ "'"
	cQry += " 	AND ZBE.D_E_L_E_T_	<>	'*'"

	TcQuery cQry New Alias "QRY"

	if !QRY->(EOF())
		lRet := .F.
	endif

	QRY->(DBCloseArea())
return lRet