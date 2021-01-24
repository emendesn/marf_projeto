#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFEA032E
Autor:...................: Flávio Dentello
Data.....................: 06/09/2016
Descrição / Objetivo.....: Controle de aprovações de ocorrências baseado no cadastro de alçada de aprovação
Doc. Origem..............: GAP - GFE02
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: Criado ponto de entrada para o controle de aprovações de ocorrências conforme tabela de aprovadores
=========================================================================================================
*/                                                                                                                            

User Function GFEA032E() 
Local lRet := .T.

If FindFunction("U_GFE0203")
	lRet := U_GFE0203()
Endif      

Return lRet 
