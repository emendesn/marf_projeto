#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              FC0103FAT  - PE
Autor....:              Antonio Carlos        
Data.....:              11/10/2016
Descricao / Objetivo:   incluir campos Cliente e Nome no Browse de Faturados 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              incluir campos Cliente e Nome no Browse de Faturados
=====================================================================================
*/
User Function FC0103FAT() 

	Local cAliasTmp := ParamIxb[1]
	Local cAliasQry := ParamIxb[2]

	If findfunction("U_MGFFIN23")
		U_MGFFIN23(cAliasTmp,cAliasQry)
	Endif

Return()