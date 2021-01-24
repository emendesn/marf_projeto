#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch" 

#define CRLF chr(13) + chr(10)
/*
==========================================================================================================
Programa.:              MGFTAU05
Autor....:              Marcelo Carneiro         
Data.....:              10/03/2017 
Descricao / Objetivo:   TAURA - JOB DE aglutinar movimentações
Doc. Origem:            
Solicitante:            Totvs
Uso......:              Marfrig
Obs......:              Programa para colocar no Schedule.
==========================================================================================================
*/

User Function MGFTAU05
                                                                            
Private _aMatriz   := {"01","010001"}  
Private _aEmpresa  := 	{}  
Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"
//Private lIsBlind   := IIf(GetRemoteType() == -1, .T., .F.)

if lIsBlind
   RpcSetType(3)
   RpcSetEnv(_aMatriz[1],_aMatriz[2])     
   

   If !LockByName("MGFTAU05")
      Conout("JOB já em Execução : MGFTAU05 " + DTOC(dDATABASE) + " - " + TIME() )
      RpcClearEnv() 
      Return
   EndIf

   conOut("********************************************************************************************************************")       
   conOut('---------------------- Inicio do processamento - MGFTAU05 - Algutina Movimentações - ' + DTOC(dDATABASE) + " - " + TIME()  )
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('Inicio do processamento - ' + DTOC(dDATABASE) + " - " + TIME()  )    
   conOut("********************************************************************************************************************"+ CRLF)       
   AGL_SD3() //
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('Final do processamento - ' + DTOC(dDATABASE) + " - " + TIME()  )    
   conOut("********************************************************************************************************************"+ CRLF)       
   
EndIf   

Return
**************************************************************************************************************************************************
Static Function AGL_SD3
Local cQuery := ''

cQuery +=" Select  D3_FILIAL,D3_TM,D3_COD,D3_UM,                                                                                             "
cQuery +="         SUM(D3_QUANT) D3_QUANT,                                                                                                   "
cQuery +="         D3_CF,D3_CONTA,D3_OP,D3_LOCAL,                                                                                            "
cQuery +="         MAX(D3_DOC) D3_DOC,                                                                                                       "
cQuery +="         D3_EMISSAO,D3_GRUPO,                                                                                                      "
cQuery +="         0 D3_CUSTO1,                                                                                                              "
cQuery +="         0 D3_CUSTO2,                                                                                                              "
cQuery +="         0 D3_CUSTO3,                                                                                                              "
cQuery +="         0 D3_CUSTO4,                                                                                                              "
cQuery +="         0 D3_CUSTO5,                                                                                                              "
cQuery +="         MAX(D3_NUMSEQ) D3_NUMSEQ,                                                                                                 "
cQuery +="         0 D3_QTSEGUM,"
cQuery +="         D3_TIPO,"
cQuery +="         0 D3_PERDA,"
cQuery +="         D3_CHAVE,                             "
cQuery +="         0 D3_RATEIO,"
cQuery +="         0 D3_CUSFF1,"        
cQuery +="         'AGR_201711' D3_ZIDMOV,"        
cQuery +="         0 D3_CUSFF2,     "
cQuery +="         0 D3_CUSFF3,       "
cQuery +="         0 D3_CUSFF4, 0 D3_CUSFF5,"
cQuery +="         0 D3_POTENCI, 0 D3_CUSRP1, 0 D3_CUSRP2, 0 D3_CUSRP3,0 D3_CUSRP4,        "
cQuery +="         0 D3_CUSRP5,0 D3_CMRP,0 D3_CMFIXO,      "
cQuery +="         0 D3_PMACNUT,0 D3_PMICNUT,0 D3_QTGANHO,0 D3_QTMAIOR, 0 D3_PERIMP, 0 D3_VLRVI,"
cQuery +="         0 D3_VLRPD,0 D3_ZQTDPCS,0 D3_ZQTDCXS,"
cQuery +="         0 D3_ZQTDSA,0 D3_ZSLDSA"
cQuery +=" from SD3NOV                                                                                                              "
cQuery +=" Where D_E_L_E_T_	=	' '                                                                                                          "
cQuery +=" Group by  D3_FILIAL,D3_TM,D3_COD,D3_UM,                                                                                             "
cQuery +="         D3_CF,D3_CONTA,D3_OP,D3_LOCAL,                                                                                            "
cQuery +="         D3_EMISSAO,D3_GRUPO,                                                                                                      "
cQuery +="         D3_TIPO,"
cQuery +="         D3_CHAVE                             "
If Select("QRY_ZD1") > 0
	QRY_ZD1->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZD1",.T.,.F.)
dbSelectArea("QRY_ZD1")
COPY TO 'SD3_SUM11.DTC' VIA "DBFCDX"   

                       
Return
