#include "protheus.ch"

/*
=====================================================================================
Programa............: ATFA012
Autor...............: Mauricio Gresele
Data................: 22/05/2017 
Descricao / Objetivo: Ponto de entrada na rotina de Cadastro do Ativo Imobilizado
Doc. Origem.........: Protheus
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function ATFA012()

Local uRet := .T.

If FindFunction("U_ATFA012_PE")
	uRet := U_ATFA012_PE()
Endif		

Return(uRet)