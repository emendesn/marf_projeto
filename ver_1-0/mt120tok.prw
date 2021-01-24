#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
==================================================================================================================================
Programa.:              MT120LOK
Autor....:              Antonio Carlos
Data.....:              09/10/2017 
Descricao / Objetivo:   Bloqueio da alteração do código do produto no PC
Doc. Origem:            Contrato GAPS - MIT044- Pedido de Compras
Solicitante:            Cliente
Uso......:              Marfrigti
Obs......:              Ponto de entrada para Bloquear alteração do código do produto no PC qdo houver SC ou processo de grade
==================================================================================================================================
*/
User Function MT120TOK()
	Local lExecuta := .T. 

	If findfunction("U_MGFCOM44")
		lExecuta := U_MGFCOM44()
	Endif

Return lExecuta 