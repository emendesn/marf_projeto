#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DIALOG.CH"
#INCLUDE "FONT.CH" 

/*
=====================================================================================
Programa.:              FC010LIST - PE
Autor....:              Antonio Carlos        
Data.....:              03/10/2016
Descricao / Objetivo:   incluir informações de Credito da Rede
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              incluir informações de Credito da Rede
=====================================================================================
*/
User Function FC010LIST()  

	Private aCols := paramixb

	If findfunction("U_MGFFIN22")
		U_MGFFIN22(aCols)
	Endif

Return(aCols)