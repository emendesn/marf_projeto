#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              FA040B01
Autor....:              Flavio Dentello
Data.....:              21/10/2016
Descricao / Objetivo:   Ponto de entrada antes da exclusao do titulo a receber, para
						complementar gravacao da exclusao
Doc. Origem:            GAP FIN_CRE029_V2
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function FA040B01()

Local lRet := .T.

If FindFunction("U_CRE2905")
	U_CRE2905("2")
Endif      

Return(lRet)
