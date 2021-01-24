#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              FA080BCO
Autor....:              Barbieri
Data.....:              23/08/2017
Descricao / Objetivo:   Ponto de entrada para validar banco na baixa de contas a pagar
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function FA080BCO()

Local lRet := .T.

If FindFunction("U_MGFFIN58")
	lRet := U_MGFFIN58()
Endif      

Return(lRet) 
