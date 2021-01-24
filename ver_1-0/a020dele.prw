#include "protheus.ch"

/*
=====================================================================================
Programa............: A020DELE
Autor...............: Mauricio Gresele
Data................: 01/12/2016 
Descricao / Objetivo: Ponto de entrada para permitir a exclusao do Fornecedor
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================

@altera��es 17/10/2019 - Henrique Vidal
	Chamada da fun��o MGFINT38
	RTASK0010137 - Impedir exclus�o de registro do cadastro com pend�ncia na Grade
	             - Verifica se fornecedores cadastrados vinculados a grade de aprova��o, podem ser exclusos.
*/
User Function A020DELE()

Local lRet := .T.

If FindFunction("U_TAC01VldMnt")
	lRet := U_TAC01VldMnt({SA2->A2_COD,SA2->A2_LOJA})
Endif

IF findfunction("U_MGFINT38") 
	IF U_MGF38_EXC('SA2','A2') 
		Help( ,, 'Pend�ncia de grade',, 'Exclus�o n�o realizada.' +  chr(13) + chr(10) + 'Verifique pend�ncia na Grade de Aprova��o e tente novamente!', 1, 0 )
		lRet := .F.
	EndIf
EndIf  

Return(lRet)