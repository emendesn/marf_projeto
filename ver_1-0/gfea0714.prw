#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFEA0714
Autor:...................: Flávio Dentello
Data.....................: 06/09/2016
Descrição / Objetivo.....: Cadastro de alçada de aprovação
Doc. Origem..............: GAP - GFE02
Solicitante..............: Cliente
Uso......................: Marfrig
Obs......................: Criado ponto de entrada para o controle de aprovações de Faturas de Frete conforme tabela de aprovadores
=========================================================================================================
*/              


User Function GFEA0714() 
Local cfilter := ""

If FindFunction("U_GFE0205")
	cfilter := U_GFE0205()
Endif      

Return cfilter
                                                                    
