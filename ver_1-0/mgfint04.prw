#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*
=====================================================================================
Programa............: MGFINT04
Autor...............: Tiago Barbieri 
Data................: 15/08/2016 
Descricao / Objetivo: Integra��o Protheus x Inventti
Doc. Origem.........: Contrato - GAP MGFINT04
Solicitante ........: Cliente
Uso.................: Marfrig
Obs.................: Tela de cadastro de integra��es
=====================================================================================
*/

user function MGFINT04()
	//--< vari�veis >---------------------------------------------------------------------------
	//Indica a permiss�o ou n�o para a opera��o (pode-se utilizar 'ExecBlock')

	local cVldAlt := ".T." // Operacao: ALTERACAO
	local cVldExc := ".T." // Operacao: EXCLUSAO

	//trabalho/apoio
	local cAlias

	//--< procedimentos >-----------------------------------------------------------------------
	cAlias := "SZ2"
	chkFile(cAlias)
	dbSelectArea(cAlias)

	//indices
	dbSetOrder(1)
	axCadastro(cAlias, "Cadastro de Integra��es", cVldExc, cVldAlt)

return

/*
========================================================
Valida codigo da SZ2
========================================================
*/
User Function VLD_SZ2COD()  
	Local bRet := .T.


	IF SZ2->(dbSeek(xFilial('SZ2')+M->Z2_CODIGO))
		MsgAlert('C�digo de integra��o j� cadastrado!!!')
		bRet := .F.
	EndIF          

return bRet