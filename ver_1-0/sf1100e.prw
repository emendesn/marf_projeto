#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              SF1100E
Autor....:              Marcelo Carneiro         
Data.....:              03/08/2017 
Descricao / Objetivo:   Integracao TAURA - ENTRADAS
Doc. Origem:            PEDIDO DE ABATE - 
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de entrada SF1100E Para voltar a situacao do Abate
=====================================================================================
*/                                                            '

User Function SF1100E()

IF FindFunction("U_TAE15CAN")
	U_TAE15CAN()
EndIF

//Atualiza SZ5 na exclusao do documento de entrada (triangulacao faturamento)
If FindFunction("u_MGFFAT75")
	u_MGFFAT75()
EndIf

Return 