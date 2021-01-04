#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              FA040ALT
Autor....:              Flavio Dentello
Data.....:              21/10/2016
Descricao / Objetivo:   Ponto de entrada para validar alteracao do titulo a receber
Doc. Origem:            GAP FIN_CRE029_V2
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function FA040ALT()

Local lRet := .T.

If FindFunction("U_CRE2904")
	lRet := U_CRE2904()
Endif      

Return(lRet)
