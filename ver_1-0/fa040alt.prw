#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa.:              FA040ALT
Autor....:              Flávio Dentello
Data.....:              21/10/2016
Descricao / Objetivo:   Ponto de entrada para validar alteracao do titulo a receber
Doc. Origem:            GAP FIN_CRE029_V2
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function FA040ALT()

Local lRet := .T.
Local _lEEC	:=	(FunName() == "EECAF200")	// Baixa automatica do EEC nao deve considerar 

If FindFunction("U_CRE2904")	.AND. ! _lEEC
	lRet := U_CRE2904()
Endif      

Return(lRet)
