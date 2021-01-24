#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              MGFFIN28  - PE
Autor....:              Antonio Carlos        
Data.....:              11/10/2016
Descricao / Objetivo:   incluir campos Cliente e Nome no Browse de Faturados 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              incluir campos Cliente e Nome no Browse de Faturados
=====================================================================================
*/
User Function MGFFIN28(aCpos) 
Local aArea    := GetArea()
   
AAdd(aCpos,"F2_CLIENTE")
AAdd(aCpos,"F2_LOJA")
AAdd(aCpos,"A1_NOME")

Return(aCpos)