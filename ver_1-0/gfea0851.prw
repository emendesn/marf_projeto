#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFEA0851
Autor:...................: Flávio Dentello
Data.....................: 06/09/2016
Descrição / Objetivo.....: Controle de aprovações de ajustes baseado no cadastro de aprovadores
Doc. Origem..............: GAP - GFE02
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: Criado ponto de entrada para o controle de aprovações de ajustes conforme tabela de aprovadores
=========================================================================================================
*/


User Function GFEA0851() 
Local lRet := .T.

If FindFunction("U_GFE0202")
	lRet := U_GFE0202()
Endif      

Return lRet

