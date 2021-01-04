#include "protheus.ch"

/*
=====================================================================================
Programa............: OMSA010
Autor...............: Mauricio Gresele
Data................: 22/02/2017 
Descricao / Objetivo: Ponto de entrada na rotina de Cadastro de Tabela e Preco do Faturamento
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function OMSA010()

Local uRet := .T.

If FindFunction("U_OMSA010_PE")
	uRet := U_OMSA010_PE()
Endif		

Return(uRet)