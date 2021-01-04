#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*
=====================================================================================
Programa............: MGFINT05
Autor...............: Tiago Barbieri 
Data................: 15/08/2016 
Descricao / Objetivo: Integração Protheus x Inventti
Doc. Origem.........: Contrato - GAP MGFINT05
Solicitante ........: Cliente
Uso.................: Marfrig
Obs.................: Tela de cadastro de tipo de integrações
=====================================================================================
*/

user function MGFINT05()
	//--< variáveis >---------------------------------------------------------------------------
	//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')

	local cVldAlt := ".T." // Operacao: ALTERACAO
	local cVldExc := ".T." // Operacao: EXCLUSAO

	//trabalho/apoio
	local cAlias

	//--< procedimentos >-----------------------------------------------------------------------
	cAlias := "SZ3"
	chkFile(cAlias)
	dbSelectArea(cAlias)

	//indices
	dbSetOrder(1)
	axCadastro(cAlias, "Cadastro de Tipo de Integrações", cVldExc, cVldAlt)

return

/*
========================================================
Valida codigo da SZ3
========================================================
*/
User Function VLD_SZ3COD()  
	Local bRet := .T.


	IF SZ3->(dbSeek(xFilial('SZ3')+M->Z3_CODINTG+M->Z3_CODTINT))
		MsgAlert('Combinação de tipo de integração já cadastrada!!!')
		bRet := .F.
	EndIF          

return bRet
