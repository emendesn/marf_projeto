#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              FA040INC
Autor....:              Flávio Dentello
Data.....:              21/10/2016
Descricao / Objetivo:   Ponto de entrada para validar inclusao do titulo a receber
Doc. Origem:            GAP FIN_CRE029_V2
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function FA040INC()

Local lRet := .T.

If FindFunction("U_CRE2904")
	lRet := U_CRE2904()
Endif      

Return(lRet) 
