#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch" 

#define CRLF chr(13) + chr(10)
/*
==========================================================================================================
Programa.:              MGFTAU04
Autor....:              Marcelo Carneiro         
Data.....:              10/03/2017 
Descricao / Objetivo:   TAURA - JOB DE CADASTROS
Doc. Origem:            
Solicitante:            Totvs
Uso......:              Marfrig
Obs......:              Programa para colocar no Schedule.
==========================================================================================================
*/

User Function MGFTAU04
                                                                            
Private _aMatriz   := {"01","010001"}  
Private _aEmpresa  := 	{}  
Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"
//Private lIsBlind   := IIf(GetRemoteType() == -1, .T., .F.)

if lIsBlind
   RpcSetType(3)
   RpcSetEnv(_aMatriz[1],_aMatriz[2])     
   

   If !LockByName("MGFTAU04")
      Conout("JOB já em Execução : MGFTAU04 " + DTOC(dDATABASE) + " - " + TIME() )
      RpcClearEnv() 
      Return
   EndIf

   conOut("********************************************************************************************************************"+ CRLF)       
   conOut("********************************************************************************************************************")       
   conOut('---------------------- Inicio do processamento - MGFTAU04 - Rotinas PV e NFs - ' + DTOC(dDATABASE) + " - " + TIME()  )
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('Inicio do processamento - MGFTAS01 - Pedido de Venda ' + DTOC(dDATABASE) + " - " + TIME()  )    
   conOut("********************************************************************************************************************"+ CRLF)       
   U_MGFTAS01() //
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('Final do processamento - MGFTAS01 - Pedido de Venda ' + DTOC(dDATABASE) + " - " + TIME()  )    
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('Inicio do processamento - MGFTAS03 - Nota Fiscal de Saida ' + DTOC(dDATABASE) + " - " + TIME()  )    
   conOut("********************************************************************************************************************"+ CRLF)       
   U_MGFTAS03() //
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('Final do processamento - MGFTAS03 - Nota Fiscal de Saida ' + DTOC(dDATABASE) + " - " + TIME()  )    
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('Inicio do processamento - TAE15 - Nota Fiscal Boletim Abate ' + DTOC(dDATABASE) + " - " + TIME()  )    
   conOut("********************************************************************************************************************"+ CRLF)       
   U_TAE15ENV()
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('Final do processamento - FTAS15 - Nota Fiscal Boletim de Abate ' + DTOC(dDATABASE) + " - " + TIME()  )    
   
   
EndIf   

Return
