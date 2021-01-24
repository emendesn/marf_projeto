#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFFINCRE29
Autor....:              Flávio Dentello
Data.....:              21/10/2016
Descricao / Objetivo:   Cadastro de tipos de desconto
Doc. Origem:            GAP FIN_CRE029_V2
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/

User Function FA070BTN() 
Local aButtons := []

If FindFunction("U_CRE2902")
	aButtons := U_CRE2902()
Endif      

Return aButtons 
