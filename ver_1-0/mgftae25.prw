#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#define CRLF chr(13) + chr(10)             

/*
=====================================================================================
Programa.:              MGFTAE25
Autor....:              Marcelo Carneiro
Data.....:              12/07/2017
Descricao / Objetivo:   Integracao PROTHEUS x Taura - Retorno AR
Doc. Origem:            Contrato - GAP TAURA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Retorno de Job de Integracao de AR
						Envia ao Taura o status de cada processamento
=====================================================================================
*/                                 
/*
[OnStart]
jobs=MGFTAE24,MTE25JOBGRP01,MTE25JOBGRP02,MTE25JOBGRP03,MTE25JOBGRP04,MTE25JOBGRP05,MTE25JOBGRP06,MTE25JOBGRP07,MTE25JOBGRP08,MTE25JOBGRP09
RefreshRate=300

[MGFTAE24]
Environment=SCHD14
Main=U_MGFTAE24
nParms=6

[MTE25JOBGRP01]
Environment=SCHD14
Main=U_MTE25JOB
nParms=6
Parm1=1
Parm2=010050
Parm3=010013
Parm4=010060
Parm5=010006
Parm6=010013

[MTE25JOBGRP02]
Environment=SCHD14
Main=U_MTE25JOB
nParms=8
Parm1=2
Parm2=010056
Parm3=010002
Parm4=010004
Parm5=010009
Parm6=010010
Parm7=010027
Parm8=010025

[MTE25JOBGRP03]
Environment=SCHD14
Main=U_MTE25JOB
nParms=5
Parm1=3
Parm2=010041
Parm3=010039
Parm4=010049
Parm5=010058

[MTE25JOBGRP04]
Environment=SCHD14
Main=U_MTE25JOB
nParms=6
Parm1=4
Parm2=010047
Parm3=010038
Parm4=010061
Parm5=010007
Parm6=010005

[MTE25JOBGRP05]
Environment=SCHD14
Main=U_MTE25JOB
nParms=7
Parm1=5
Parm2=010024
Parm3=010053
Parm4=010012
Parm5=010043
Parm6=010022
Parm7=010062

[MTE25JOBGRP06]
Environment=SCHD14
Main=U_MTE25JOB
nParms=6
Parm1=6
Parm2=010001
Parm3=010051
Parm4=010008
Parm5=010064
Parm6=010052

[MTE25JOBGRP07]
Environment=SCHD14
Main=U_MTE25JOB
nParms=7
Parm1=7
Parm2=010029
Parm3=010055
Parm4=010063
Parm5=010057
Parm6=010015
Parm7=040002

[MTE25JOBGRP08]
Environment=SCHD14
Main=U_MTE25JOB
nParms=6
Parm1=8
Parm2=010016
Parm3=010045
Parm4=010059
Parm5=010048
Parm6=020003

[MTE25JOBGRP09]
Environment=SCHD14
Main=U_MTE25JOB
nParms=6
Parm1=9
Parm2=010054
Parm3=010042
Parm4=010044
Parm5=010046
Parm6=020001

*/
User Function MTE25JOB(cPar1,cPar2,cPar3,cPar4,cPar5,cPar6,cPar7,cPar8)

	Local aParam	:= {}
	
	If ValType(cPar2) == "C"
		aAdd( aParam , cPar2) 
	EndIf
	If ValType(cPar3) == "C"
		aAdd( aParam , cPar3) 
	EndIf
	If ValType(cPar4) == "C"
		aAdd( aParam , cPar4)
	EndIf
	If ValType(cPar5) == "C"
		aAdd( aParam , cPar5)
	EndIf
	If ValType(cPar6) == "C"
		aAdd( aParam , cPar6)
	EndIf
	If ValType(cPar7) == "C"
		aAdd( aParam , cPar7)
	EndIf
	If ValType(cPar8) == "C"
		aAdd( aParam , cPar8)
	EndIf

	U_MGFTAE25({Val(cPar1),aParam})

Return


User Function zCallTAE25()

U_MGFTAE25({99,{'010048'}})	

Return                                    



User Function MGFTAE25(aParam)                                

Private _aMatriz   := {"01","010001"}  
Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"
Private cTipo      := aParam[01]                       

//Private cTempo     := ''


IF lIsBlind
   //cTempo      += 'Antes da abertura empresa :' + TIME() +CRLF

   RpcSetType(3)
   RpcSetEnv(_aMatriz[1],_aMatriz[2])          

   //cTempo      += 'Fim abertura Empresa :' + TIME() +CRLF

   cTipo := STRZERO(cTipo,2)
   
   If !LockByName("TAE25_"+cTipo)
      Conout("JOB j� em Execucao : MGFTAE25_"+cTipo +" "+ DTOC(dDATABASE) + " - " + TIME() )
      RpcClearEnv() 
      Return
   EndIf
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('---------------------- Inicio do processamento - MGFTAE25_'+cTipo +'  - Envio Mov de AR - ' + DTOC(dDATABASE) + " - " + TIME()  )
   conOut("********************************************************************************************************************"+ CRLF)       
   Envia_AR(aParam[02])                                                                       
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('---------------------- Fim  - MGFTAE25_'+cTipo +' - Envio Mov de AR - ' + DTOC(dDATABASE) + " - " + TIME()  )
   conOut("********************************************************************************************************************"+ CRLF)       

EndIF
RpcClearEnv()

Return                                                                                                                                            

**************************************************************************************************************************************************
Static Function Envia_AR(aEmpSel)

Local cQuery        := ""
Local nLimReg       := 100
Local nQtdReg       := 0    
Local cURLPost      := GetMv("MGF_TAE24",,"")
Local cCodInt	    := AllTrim(GetMv("MGF_MONI01"))
Local cTipInt	    := AllTrim(GetMv("MGF_MONT12"))                                                                             
Local cEmpSel       := "'x'"
Local aEnvia        := {}

Private nI            := 0 

For nI := 1 To Len(aEmpSel)
    cEmpSel += ",'"+aEmpSel[nI]+"'"
Next nI

dbSelectArea('ZD1')
ZD1->(dbSetOrder(1))
cQuery := "SELECT R_E_C_N_O_ RECZD1,   ZD1.* "+CRLF
cQuery += "FROM "+RetSqlName("ZD1")+" ZD1"+CRLF
cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cQuery += "	AND ZD1_STATUS in (2,3) " + CRLF
cQuery += "	AND ZD1_INTEGR = 'N' " + CRLF          
cQuery += "	AND ZD1_CHAVEU <> ' '"
cQuery += "	AND ZD1_FILIAL in ("+cEmpSel+")"
If Select("QRY_ZD1") > 0
	QRY_ZD1->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZD1",.T.,.F.)
dbSelectArea("QRY_ZD1")
QRY_ZD1->(dbGoTop())
nQtdReg       := 0    
While QRY_ZD1->(!EOF())
    nQtdReg++
	If nQtdReg >= nLimReg 
		nQtdReg  := 0 
		U_TAE25_ENV(aEnvia)
	    aEnvia   := {}
	Else         
	   ZD1->(dbGoTo(QRY_ZD1->RECZD1))
	   AAdd(aEnvia,{QRY_ZD1->ZD1_PROC,    ; //01
	    			QRY_ZD1->RECZD1,      ; //02
	    			QRY_ZD1->ZD1_STATUS,  ; //03
	    			QRY_ZD1->ZD1_ID,      ; //04
	    			QRY_ZD1->ZD1_IDOPER,  ; //05
	    			QRY_ZD1->ZD1_IDEMPR,  ; //06
	    			ZD1->ZD1_ERRO         ,; //07
	    			QRY_ZD1->ZD1_CHAVEU,  ; //08
	    			cURLPost,             ; //09
	    			cCodInt,              ; //10
	    			cTipInt	} )
	EndIF 												
	QRY_ZD1->(DBSkip())
    IF QRY_ZD1->(EOF()) .And. nQtdReg <> 0 
    	U_TAE25_ENV(aEnvia)
    EndIF
EndDo
If Select("QRY_ZD1") > 0
	QRY_ZD1->(dbCloseArea())
EndIf

Return
********************************************************************************************************************************************************************
User Function TAE25_ENV(aParJob)

Local cJson			:= ""
Local lMonitor      := .F.
Local oWSRetTP25	:= nil     
Local cUpd          := ''       
//Local cFunName	    := "TAE25_ENV"
Local cRet          := "-1" 

Private oRet25	    := Nil
Private xZD1_PROC   := ''
Private xRECZD1     := ''
Private xZD1_STATUS := ''                
Private xZD1_ID     := ''                    
Private xZD1_IDOPER := ''                    
Private xZD1_IDEMPR := ''                                                      
Private xMSG_ERRO   := ''
Private xZD1_CHAVEU := ''
Private cURLPost    := ''
Private cCodInt	    := ''
Private cTipInt	    := ''
Private nI          := 0                            
    
oRet25 := nil
oRet25 := RetMovAR():new()
oRet25:CHAVES := {}                        

For nI := 1  To Len(aParJob)
	xZD1_PROC   := aParJob[nI,01]
	xRECZD1     := aParJob[nI,02]
	xZD1_STATUS := aParJob[nI,03]
	xZD1_ID     := aParJob[nI,04]
	xZD1_IDOPER := aParJob[nI,05]
	xZD1_IDEMPR := aParJob[nI,06]
	xMSG_ERRO   := aParJob[nI,07]
	xZD1_CHAVEU := aParJob[nI,08]
	cURLPost    := aParJob[nI,09]
	cCodInt	    := aParJob[nI,10]
	cTipInt	    := aParJob[nI,11]
	cRet        += ","+Alltrim(STR(xRECZD1))
	oRet25:SetRetMovAR()
Next nI	
cJson := fwJsonSerialize(oRet25, .F., .T.)

oWSRetTP25 := nil
oWSRetTP25 := MGFINT23():new(cURLPost, oRet25, , ,'', cCodInt , cTipInt, 'RET AR' /*cChave*/,.F.,.F.,lMonitor)
StaticCall(MGFTAC01,ForcaIsBlind,oWSRetTP25)
//oWSRetTP25:SendByHttpPost()

//MemoWrite("c:\temp\"+FunName()+"_Result_"+StrTran(Time(),":","")+".txt",oWSRetTP25:CDETAILINT)
//MemoWrite("c:\temp\"+FunName()+"_json_"+StrTran(Time(),":","")+".txt",oWSRetTP25:CJSON)      


IF oWSRetTP25:lOk // Resultado  
                    
	cUpd := " UPDATE "+RetSqlName("ZD1")+" " + CRLF
	cUpd += " SET ZD1_INTEGR = 'S' ," + CRLF          
	cUpd += "	  ZD1_DTENV = '"+dTos(Date())+"', " + CRLF
	cUpd += "	  ZD1_HRENV = '"+Time()+"' " + CRLF
	cUpd += " WHERE R_E_C_N_O_ in ("+cRet+")"+CRLF 
	
	IF (TcSQLExec(cUpd) < 0)
		ConOut("## MGFTAE25"+TcSQLError())
	EndIF 

ELSE
	CONOUT("Erro no retorno do TAURA!" +' - ' + cRet + '-' + CRLF + cPostRet)
EndIF
	


Return .T.
********************************************************************************************************************************************************************
Class RetMovAR

Data ApplicationArea	as ApplicationArea
Data CHAVES				as Array 

Method New()
Method SetRetMovAR()

endclass
Return
*************************************************************************************************************************************************
Class RetCHAVEIU

Data ChaveUID           as String
Data Mensagem			as String        
Data Sucesso			as Boolean

Method New()

endclass
return
*************************************************************************************************************************************************
Method New() class RetMovAR

Self:ApplicationArea	:= ApplicationArea():new()

Return
*************************************************************************************************************************************************
Method SetRetMovAR() Class RetMovAR

aAdd(Self:CHAVES,WSClassNew( "RetCHAVEIU"))
Self:CHAVES[nI]:ChaveUID := Alltrim(xZD1_CHAVEU)
Self:CHAVES[nI]:Mensagem := IIF( xZD1_STATUS==3,Alltrim(xMSG_ERRO),'ACAO EFETIVADA') 
Self:CHAVES[nI]:Sucesso  := IIF( xZD1_STATUS==3,.F.,.T.) 

Return
************************************************************************************************************************************************************
/*Static Function zNumThread(cFunName)

Local nQtdThread	:= 0
Local aThreads		:= GetUserInfoArray()
Local _nQ			:= 0
Local nLenThreads	:= Len(aThreads)

For _nQ := 1 To nLenThreads
	If Upper(AllTrim(aThreads[_nQ,5])) $ cFunName
		nQtdThread++
	EndIf
Next _nQ

Return nQtdThread*/