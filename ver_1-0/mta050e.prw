#include "protheus.ch"

/*
=====================================================================================
Programa............: MTA050E
Autor...............: Mauricio Gresele
Data................: 01/12/2016 
Descricao / Objetivo: Ponto de entrada para permitir a exclusao da Transportadora
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
@altera��es 17/10/2019 - Henrique Vidal
	Chamada da fun��o MGF38_EXC
	RTASK0010137 - Impedir exclus�o de registro do cadastro com pend�ncia na Grade
	             - Verifica se fornecedores cadastrados vinculados a grade de aprova��o, podem ser exclusos.

*/
User Function MTA050E()

Local lRet := .T.

If FindFunction("U_TAC02VldMnt")
	lRet := U_TAC02VldMnt({SA4->A4_COD})
Endif

IF findfunction("U_MGFINT38") 
	IF U_MGF38_EXC('SA4','A4') 
		Help( ,, 'Pend�ncia de grade',, 'Exclus�o n�o realizada.' +  chr(13) + chr(10) + 'Verifique pend�ncia na Grade de Aprova��o e tente novamente!', 1, 0 )
		lRet := .F.
	EndIf
EndIf


Return(lRet)