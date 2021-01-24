#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFEA032E
Autor:...................: Fl�vio Dentello
Data.....................: 06/09/2016
Descri��o / Objetivo.....: Controle de aprova��es de ocorr�ncias baseado no cadastro de al�ada de aprova��o
Doc. Origem..............: GAP - GFE02
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: Criado ponto de entrada para o controle de aprova��es de ocorr�ncias conforme tabela de aprovadores
=========================================================================================================
*/                                                                                                                            

User Function GFEA032E() 
Local lRet := .T.

If FindFunction("U_GFE0203")
	lRet := U_GFE0203()
Endif      

Return lRet 
