#include "protheus.ch"

/*
=====================================================================================
Programa............: A020DELE
Autor...............: Mauricio Gresele
Data................: 01/12/2016 
Descricao / Objetivo: Ponto de entrada para permitir a exclusao do Fornecedor
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================

@alteracoes 17/10/2019 - Henrique Vidal
	Chamada da funcao MGFINT38
	RTASK0010137 - Impedir exclusao de registro do cadastro com pendencia na Grade
	             - Verifica se fornecedores cadastrados vinculados a grade de Aprovacao, podem ser exclusos.
*/
User Function A020DELE()

Local lRet := .T.

If FindFunction("U_TAC01VldMnt")
	lRet := U_TAC01VldMnt({SA2->A2_COD,SA2->A2_LOJA})
Endif

IF findfunction("U_MGFINT38") 
	IF U_MGF38_EXC('SA2','A2') 
		Help( ,, 'Pendencia de grade',, 'Exclusao nao realizada.' +  chr(13) + chr(10) + 'Verifique pendencia na Grade de Aprovacao e tente novamente!', 1, 0 )
		lRet := .F.
	EndIf
EndIf  

Return(lRet)