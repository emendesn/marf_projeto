#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              F010CQPE - PE
Autor....:              Antonio Carlos        
Data.....:              04/10/2016
Descricao / Objetivo:   apresentar Pedidos por Rede 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Pedidos por Rede na Posição do Cliente
=====================================================================================
*/
User Function  F010CQPE()
LOCAL cQueryori := PARAMIXB[1]
LOCAL cQuery    := '' 

   cQuery := U_MGFFIN30(cQueryori)
   
Return(cQuery)