#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              SF1100E
Autor....:              Marcelo Carneiro         
Data.....:              03/08/2017 
Descricao / Objetivo:   Integra��o TAURA - ENTRADAS
Doc. Origem:            PEDIDO DE ABATE - 
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de entrada SF1100E Para voltar a situa��o do Abate
=====================================================================================
*/                                                            '

User Function SF1100E()

IF FindFunction("U_TAE15CAN")
	U_TAE15CAN()
EndIF

//Atualiza SZ5 na exclus�o do documento de entrada (triangula��o faturamento)
If FindFunction("u_MGFFAT75")
	u_MGFFAT75()
EndIf

Return 