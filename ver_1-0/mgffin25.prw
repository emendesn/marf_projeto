#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"   
#INCLUDE "rwmake.ch"
/*
=====================================================================================
Programa.:              MGFFIN25 - PE
Autor....:              Antonio Carlos        
Data.....:              06/10/2016
Descricao / Objetivo:   selecionar somentes titulos vencidos 
Doc. Origem:            Contrato - GAP MGFCRE007
Solicitante:            Cliente
Uso......:              
Obs......:              titulos em aberto selecionar somente os vencidos
=====================================================================================
*/
User Function MGFFIN25()
Local cQuery := ''

If TYPE("_xFilC") <> 'U'.and. IsInCallStack('U_MGFFIN20')
   IF _xFilC = "9" 
      cQuery += "SE1.E1_VENCREA < '"+DTOS(DATE())+"' AND " 
      _xFilC := " "
   ENDIF
ENDIF
If IsInCallStack("FC010CLI") .And. MV_PAR19 == 2
      cQuery += "SE1.E1_TIPO <> 'NCC' AND " 
Endif


Return(cQuery)