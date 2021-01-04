#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              MGFFIN23  - PE
Autor....:              Antonio Carlos        
Data.....:              11/10/2016
Descricao / Objetivo:   incluir campos Cliente e Nome no Browse de Faturados 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              incluir campos Cliente e Nome no Browse de Faturados
=====================================================================================
*/
User Function MGFFIN23(cAliasTmp,cAliasQry) 
Local aArea     := GetArea()
LOCAL cArqTmp   := GetNextAlias()
Local cNome     := Space(40)
  
   cNome    := Posicione("SA1",1,xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA,"A1_NOME")
   Reclock(cAliasTmp,.F.)
   (cAliasTmp)->F2_CLIENTE  := (cAliasQry)->F2_CLIENTE
   (cAliasTmp)->F2_LOJA  	:= (cAliasQry)->F2_LOJA
   (cAliasTmp)->A1_NOME     := cNome
   (cAliasTmp)->(MsUnlock())  

Return()
