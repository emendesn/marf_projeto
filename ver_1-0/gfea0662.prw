#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFEA0662
Autor:...................: Flavio Dentello
Data.....................: 06/09/2016
Descricao / Objetivo.....: Criado ponto de entrada para o controle de aprovacoes de Documentos de Frete
Doc. Origem..............: GAP - GFE02
Solicitante..............: Cliente
Uso......................: 
Obs......................: Criado ponto de entrada para o controle de aprovacoes de Documentos de Frete
=========================================================================================================
*/                                                                                  

User Function GFEA0662() 
Local cFilter := ""

If FindFunction("U_GFE0204")
	cfilter := U_GFE0204()
Endif      

Return cfilter 
