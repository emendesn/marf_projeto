#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFEA0714
Autor:...................: Fl�vio Dentello
Data.....................: 06/09/2016
Descri��o / Objetivo.....: Cadastro de al�ada de aprova��o
Doc. Origem..............: GAP - GFE02
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: Criado ponto de entrada para o controle de aprova��es de Faturas de Frete conforme tabela de aprovadores
=========================================================================================================
*/              


User Function GFEA0714() 
Local cfilter := ""

If FindFunction("U_GFE0205")
	cfilter := U_GFE0205()
Endif      

Return cfilter
                                                                    
