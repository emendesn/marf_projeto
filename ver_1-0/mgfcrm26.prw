#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM26
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              07/04/2017
Descricao / Objetivo:   Cadastro de Supervisao - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCRM26(nOpcX, cCodPos, nRecno)
	local aArea		:= getArea()
	local aAreaZBH	:= ZBH->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	DBSelectArea("ZBH")
	//dbSetOrder(2)	
	//ZBH->(DBGoTop())

	if nOpcX == 3
		fwExecView("Inclusão", "MGFCRM25", MODEL_OPERATION_INSERT,, {|| .T.}, , , aButtons)
	else
		//if ZBH->(DBSeek( xFilial("ZBH") + cCodPos ))
		ZBH->(dbGoto(nRecno))
		If ZBH->(Recno()) == nRecno
			if nOpcX == 4
				fwExecView("Alteração", "MGFCRM25", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)
			elseif nOpcX == 5
				if chkRelat()
					fwExecView("Alteração", "MGFCRM25", MODEL_OPERATION_DELETE,, {|| .T.}, , , aButtons)
				else
					msgAlert("Este registro não poderá ser excluído. O mesmo possui Roteiro abaixo dele.")
				endif
			endif
		else
			msgAlert("Registro não encontrado.")
		endif
	endif

	//ZBH->(DBCloseArea())

	restArea(aAreaZBH)
	restArea(aArea)
return

//---------------------------------------------
// Verifica se o registro possui niveis abaixo
//---------------------------------------------
static function chkRelat()
	local lRet	:= .T.
	local cQry	:= ""

	cQry := "SELECT *"
	cQry += " FROM " + retSQLName("ZBI") + " ZBI"
	cQry += " WHERE"
	cQry += " 		ZBI.ZBI_SUPERV	=	'" + ZBH->ZBH_CODIGO	+ "'"
	cQry += " 	AND ZBI.ZBI_REGION	=	'" + ZBH->ZBH_REGION	+ "'"
	cQry += " 	AND ZBI.ZBI_TATICA	=	'" + ZBH->ZBH_TATICA	+ "'"
	cQry += " 	AND ZBI.ZBI_NACION	=	'" + ZBH->ZBH_NACION	+ "'"
	cQry += " 	AND ZBI.ZBI_DIRETO	=	'" + ZBH->ZBH_DIRETO	+ "'"
	cQry += " 	AND ZBI.ZBI_FILIAL	=	'" + xFilial("ZBI")		+ "'"
	cQry += " 	AND ZBI.D_E_L_E_T_	<>	'*'"

	TcQuery cQry New Alias "QRY"

	if !QRY->(EOF())
		lRet := .F.
	endif

	QRY->(DBCloseArea())
return lRet