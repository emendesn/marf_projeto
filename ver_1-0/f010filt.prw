#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "rwmake.ch"
/*
=====================================================================================
Programa.:              FC010BTN - PE
Autor....:              Antonio Carlos        
Data.....:              06/10/2016
Descricao / Objetivo:   selecionar somentes titulos vencidos 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              titulos em aberto selecionar somente os vencidos
=====================================================================================
*/
User Function F010FILT()

	Local aParam 	:= {}
	LOCAL cQuery    := '' 

	If findfunction("U_MGFFIN25")
		U_MGFFIN25(cQuery)
	Endif

Return(cQuery)