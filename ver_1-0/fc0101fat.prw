#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              FC0101FAT  - PE
Autor....:              Antonio Carlos        
Data.....:              11/10/2016
Descricao / Objetivo:   incluir campos Cliente e Nome no Browse de Faturados 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              incluir campos Cliente e Nome no Browse de Faturados
=====================================================================================
*/
User Function FC0101FAT() 
	Local aCpos    := aClone(ParamIxb[1]) 
	Local aRet1    := {}

	If findfunction("U_MGFFIN28")
		aRet1 := U_MGFFIN28(aCpos)
	Endif

Return(aRet1)