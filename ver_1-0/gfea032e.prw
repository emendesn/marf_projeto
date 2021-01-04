#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFEA032E
Autor:...................: Flavio Dentello
Data.....................: 06/09/2016
Descricao / Objetivo.....: Controle de aprovacoes de ocorrencias baseado no cadastro de alcada de Aprovacao
Doc. Origem..............: GAP - GFE02
Solicitante..............: Cliente
Uso......................: 
Obs......................: Criado ponto de entrada para o controle de aprovacoes de ocorrencias conforme tabela de aprovadores
=========================================================================================================
*/                                                                                                                            

User Function GFEA032E() 
Local lRet := .T.

If FindFunction("U_GFE0203")
	lRet := U_GFE0203()
Endif      

Return lRet 
