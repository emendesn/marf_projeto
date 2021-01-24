#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM24
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              07/04/2017
Descricao / Objetivo:   Cadastro de Regional - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM24(nOpcX, cCodPos, nRecno)
	local aArea		:= getArea()
	local aAreaZBG	:= ZBG->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	DBSelectArea("ZBG")
	//dbSetOrder(2)	
	//ZBG->(DBGoTop())

	if nOpcX == 3
		fwExecView("Inclusão", "MGFCRM23", MODEL_OPERATION_INSERT,, {|| .T.}, , , aButtons)
	else
		//if ZBG->(DBSeek( xFilial("ZBG") + cCodPos ))
		ZBG->(dbGoto(nRecno))
		If ZBG->(Recno()) == nRecno
			if nOpcX == 4
				fwExecView("Alteração", "MGFCRM23", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)
			elseif nOpcX == 5
				if chkRelat()
					fwExecView("Alteração", "MGFCRM23", MODEL_OPERATION_DELETE,, {|| .T.}, , , aButtons)
				else
					msgAlert("Este registro não poderá ser excluído. O mesmo possui Supervisão abaixo dele.")
				endif
			endif
		else
			msgAlert("Registro não encontrado.")
		endif
	endif

	//ZBG->(DBCloseArea())

	restArea(aAreaZBG)
	restArea(aArea)
return

//---------------------------------------------
// Verifica se o registro possui niveis abaixo
//---------------------------------------------
static function chkRelat()
	local lRet	:= .T.
	local cQry	:= ""

	cQry := "SELECT *"
	cQry += " FROM " + retSQLName("ZBH") + " ZBH"
	cQry += " WHERE"
	cQry += " 		ZBH.ZBH_REGION	=	'" + ZBG->ZBG_CODIGO	+ "'"
	cQry += " 	AND ZBH.ZBH_TATICA	=	'" + ZBG->ZBG_TATICA	+ "'"
	cQry += " 	AND ZBH.ZBH_NACION	=	'" + ZBG->ZBG_NACION	+ "'"
	cQry += " 	AND ZBH.ZBH_DIRETO	=	'" + ZBG->ZBG_DIRETO	+ "'"
	cQry += " 	AND ZBH.ZBH_FILIAL	=	'" + xFilial("ZBH")		+ "'"
	cQry += " 	AND ZBH.D_E_L_E_T_	<>	'*'"

	TcQuery cQry New Alias "QRY"

	if !QRY->(EOF())
		lRet := .F.
	endif

	QRY->(DBCloseArea())
return lRet