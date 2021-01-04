#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=========================================================================================================
Programa.................: GFEA0714
Autor:...................: Flavio Dentello
Data.....................: 06/09/2016
Descricao / Objetivo.....: Cadastro de alcada de Aprovacao
Doc. Origem..............: GAP - GFE02
Solicitante..............: Cliente
Uso......................: 
Obs......................: Criado ponto de entrada para o controle de aprovacoes de Faturas de Frete conforme tabela de aprovadores
=========================================================================================================
*/              


User Function GFEA0714() 
Local cfilter := ""

If FindFunction("U_GFE0205")
	cfilter := U_GFE0205()
Endif      

Return cfilter
                                                                    
