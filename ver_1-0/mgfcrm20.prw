#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM20
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              07/04/2017
Descricao / Objetivo:   Cadastro de Nacional - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM20(nOpcX, cCodPos, nRecno)
	local aArea		:= getArea()
	local aAreaZBE	:= ZBE->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	DBSelectArea("ZBE")
	//dbSetOrder(2)
	//ZBE->(DBGoTop())

	if nOpcX == 3
		fwExecView("Inclusão", "MGFCRM19", MODEL_OPERATION_INSERT,, {|| .T.}, , , aButtons)
	else
		//if ZBE->(DBSeek( xFilial("ZBE") + cCodPos ))
		ZBE->(dbGoto(nRecno))
		If ZBE->(Recno()) == nRecno
			if nOpcX == 4
				fwExecView("Alteração", "MGFCRM19", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)
			elseif nOpcX == 5
				if chkRelat()
					fwExecView("Alteração", "MGFCRM19", MODEL_OPERATION_DELETE,, {|| .T.}, , , aButtons)
				else
					msgAlert("Este registro não poderá ser excluído. O mesmo possui Tática abaixo dele.")
				endif
			endif
		else
			msgAlert("Registro não encontrado.")
		endif
	endif

	//ZBE->(DBCloseArea())

	restArea(aAreaZBE)
	restArea(aArea)
return

//---------------------------------------------
// Verifica se o registro possui niveis abaixo
//---------------------------------------------
static function chkRelat()
	local lRet	:= .T.
	local cQry	:= ""

	cQry := "SELECT *"
	cQry += " FROM " + retSQLName("ZBF") + " ZBF"
	cQry += " WHERE"
	cQry += " 		ZBF.ZBF_NACION	=	'" + ZBE->ZBE_CODIGO	+ "'"
	cQry += " 	AND ZBF.ZBF_DIRETO	=	'" + ZBE->ZBE_DIRETO	+ "'"
	cQry += " 	AND ZBF.ZBF_FILIAL	=	'" + xFilial("ZBF")		+ "'"
	cQry += " 	AND ZBF.D_E_L_E_T_	<>	'*'"

	TcQuery cQry New Alias "QRY"

	if !QRY->(EOF())
		lRet := .F.
	endif

	QRY->(DBCloseArea())
return lRet