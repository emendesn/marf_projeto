#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFEA0851
Autor:...................: Flavio Dentello
Data.....................: 06/09/2016
Descricao / Objetivo.....: Controle de aprovacoes de ajustes baseado no cadastro de aprovadores
Doc. Origem..............: GAP - GFE02
Solicitante..............: Cliente
Uso......................: 
Obs......................: Criado ponto de entrada para o controle de aprovacoes de ajustes conforme tabela de aprovadores
=========================================================================================================
*/


User Function GFEA0851() 
Local lRet := .T.

If FindFunction("U_GFE0202")
	lRet := U_GFE0202()
Endif      

Return lRet

