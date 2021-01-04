#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "rwmake.ch"
/*
=====================================================================================
Programa.:              F010ORD1 - PE
Autor....:              Leonardo Kume	       
Data.....:              16/03/2017
Descricao / Objetivo:   Ordenar tela de titulos vencidos 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function F010ORD1()

Local cRet := U_MGFF31O()

Return cRet