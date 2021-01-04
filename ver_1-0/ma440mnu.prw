#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "RWMAKE.CH"
/*
=====================================================================================
Programa.:              A440BUT
Autor....:              Leonardo Kume        
Data.....:              14/03/2017
Descricao / Objetivo:   Incluir botao  
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MA440MNU()

	If findfunction("u_MGFFI53A")
		u_MGFFI53A()
	EndIf
   
Return 