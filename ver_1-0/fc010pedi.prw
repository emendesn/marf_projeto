#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              FC010PEDI - PE
Autor....:              Antonio Carlos        
Data.....:              11/10/2016
Descricao / Objetivo:   incluir campos Cliente e Nome no Browse de Pedidos 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              incluir campos Cliente e Nome no Browse de Pedidos
=====================================================================================
*/
User Function FC010PEDI() 
	Local aArea    := GetArea()
	Local aRet     := {}

	If findfunction("U_MGFFIN27")
		aRet := U_MGFFIN27()
	Endif

Return(aRet)