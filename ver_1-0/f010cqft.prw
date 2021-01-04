#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   

/*
=====================================================================================
Programa.:              F010CQFT  - PE
Autor....:              Antonio Carlos        
Data.....:              04/10/2016                                                                                                            
Descricao / Objetivo:   incluir informacoes de Notas Fiscais emitidas por Rede 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              incluir informacoes de Notas Fiscais emitidas por Rede
=====================================================================================
*/
User Function  F010CQFT()

LOCAL cQueryori := PARAMIXB[1]
LOCAL cQuery    := ' ' 

If Findfunction("U_MGFFIN29")  
   cQuery := U_MGFFIN29(cQueryori)
Endif
				
Return(cQuery)