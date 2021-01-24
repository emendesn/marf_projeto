#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "rwmake.ch"
/*
=====================================================================================
Programa.:              FO10FILT
Autor....:              Antonio Carlos        
Data.....:              06/10/2016
Descricao / Objetivo:   selecionar somentes titulos vencidos 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              titulos em aberto selecionar somente os vencidos
=====================================================================================
*/
User Function FO10FILT    
Local cQuery := ''

cQuery    := U_MGFFIN25()
_xFilC := " "

Return(cQuery)