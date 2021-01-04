#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
/*
==========================================================================================
Programa.:              SD1100E
Autor....:              Marcelo Carneiro         
Data.....:              14/08/2019 
Descricao / Objetivo:   Reabertura da RAMI apos exclusao da Nota
Doc. Origem:            RITM0015705
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de entrada SD1100E � executado na exclusao de cd item da NF
==========================================================================================
*/                                                            
	
User Function SD1100E()

///Alterar o estado da Rami
IF FindFunction("U_CRM05_VLEX")
	U_CRM05_VLEX()
EndIF

Return 