#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCRM28
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              11/04/2017
Descricao / Objetivo:   Cadastro de Roteiro - Estrutura de Venda
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
user function MGFCRM28(nOpcX, cCodPos, nRecno)
	local aArea		:= getArea()
	local aAreaZBI	:= ZBI->(getArea())
	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	DBSelectArea("ZBI")
	//dbSetOrder(2)
	//ZBI->(DBGoTop())

	if nOpcX == 3
		fwExecView("Inclusao", "MGFCRM27", MODEL_OPERATION_INSERT,, {|| .T.}, , , aButtons)
	else
		//if ZBI->(DBSeek( xFilial("ZBI") + cCodPos ))
		ZBI->(dbGoto(nRecno))
		If ZBI->(Recno()) == nRecno
			if nOpcX == 4
				fwExecView("Alteracao", "MGFCRM27", MODEL_OPERATION_UPDATE,, {|| .T.}, , , aButtons)
			elseif nOpcX == 5
				if chkRelat()
					fwExecView("Alteracao", "MGFCRM27", MODEL_OPERATION_DELETE,, {|| .T.}, , , aButtons)
				else
					msgAlert("Este registro nao podera ser excluido. O mesmo possui Clientes abaixo dele.")
				endif
			endif
		else
			msgAlert("Registro nao encontrado.")
		endif
	endif

	//ZBI->(DBCloseArea())

	restArea(aAreaZBI)
	restArea(aArea)
return

//---------------------------------------------
// Verifica se o registro possui niveis abaixo
//---------------------------------------------
static function chkRelat()
	local lRet	:= .T.
	local cQry	:= ""

	cQry := "SELECT *"
	cQry += " FROM " + retSQLName("ZBJ") + " ZBJ"
	cQry += " WHERE"
	cQry += " 		ZBJ.ZBJ_ROTEIR	=	'" + ZBI->ZBI_CODIGO	+ "'"
	cQry += " 	AND	ZBJ.ZBJ_SUPERV	=	'" + ZBI->ZBI_SUPERV	+ "'"
	cQry += " 	AND ZBJ.ZBJ_REGION	=	'" + ZBI->ZBI_REGION	+ "'"
	cQry += " 	AND ZBJ.ZBJ_TATICA	=	'" + ZBI->ZBI_TATICA	+ "'"
	cQry += " 	AND ZBJ.ZBJ_NACION	=	'" + ZBI->ZBI_NACION	+ "'"
	cQry += " 	AND ZBJ.ZBJ_DIRETO	=	'" + ZBI->ZBI_DIRETO	+ "'"
	cQry += " 	AND ZBJ.ZBJ_REPRES	=	'" + ZBI->ZBI_REPRES	+ "'"
	cQry += " 	AND ZBJ.ZBJ_FILIAL	=	'" + xFilial("ZBI")		+ "'"
	cQry += " 	AND ZBJ.D_E_L_E_T_	<>	'*'"

	TcQuery cQry New Alias "QRY"

	if !QRY->(EOF())
		lRet := .F.
	endif

	QRY->(DBCloseArea())
return lRet