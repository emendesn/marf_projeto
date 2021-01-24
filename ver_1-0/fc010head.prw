#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              FC010HEAD - PE
Autor....:              Antonio Carlos        
Data.....:              11/10/2016
Descricao / Objetivo:   incluir campos Cliente e Nome no Browse de Títulos Abertos 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              incluir campos Cliente e Nome no Browse de Títulos Abertos 
=====================================================================================
*/
User Function FC010HEAD() 

	If findfunction("U_MGFFIN26")
		U_MGFFIN26(aHeader)
	Endif

Return(aHeader)