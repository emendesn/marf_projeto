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
User Function MGFTAE25()                                
  
Local cQuery        := ""
Local nLimReg       := 100
Local nQtdReg       := 0    
Local cURLPost      := ""
Local cCodInt	    := ""
Local cTipInt	    := ""                                                                            
Local cEmpSel       := "'x'"
Local aEnvia        := {}

Private nI            := 0 

cURLPost      := GetMv("MGF_TAE24",,"")
cCodInt	    := AllTrim(GetMv("MGF_MONI01"))
cTipInt	    := AllTrim(GetMv("MGF_MONT12"))     

U_MFCONOUT("Iniciando retorno de movimentos de AR para o Taura...")


dbSelectArea('ZD1')
ZD1->(dbSetOrder(1))
cQuery := "SELECT R_E_C_N_O_ RECZD1,   ZD1.* "+CRLF
cQuery += "FROM "+RetSqlName("ZD1")+" ZD1"+CRLF
cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cQuery += "	AND ZD1_STATUS in (2,3) " + CRLF
cQuery += "	AND ZD1_INTEGR = 'N' " + CRLF          
cQuery += "	AND ZD1_CHAVEU <> ' '"

If Select("QRY_ZD1") > 0
	QRY_ZD1->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZD1",.T.,.F.)
dbSelectArea("QRY_ZD1")
QRY_ZD1->(dbGoTop())

_ntot := 0

While QRY_ZD1->(!EOF())
   ZD1->(dbGoTo(QRY_ZD1->RECZD1))
   U_MFCONOUT("Carregando " + strzero(_ntot,6) + " ARs...")
   _ntot++
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
	QRY_ZD1->(DBSkip())
EndDo

U_TAE25_ENV(aEnvia)

If Select("QRY_ZD1") > 0
	QRY_ZD1->(dbCloseArea())
EndIf

U_MFCONOUT("Completou envio de ARs para o Taura!")

Return

********************************************************************************************************************************************************************
User Function TAE25_ENV(aParJob)

Local cJson			:= ""
Local lMonitor      := .F.
Local oWSRetTP25	:= nil     
Local cUpd          := ''       
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
_npos := 1  
_ncont := 0                   

For nI := 1  To Len(aParJob)

	U_MFCONOUT("Processando AR " + strzero(_npos,6) + " de " + strzero(_ntot,6) + "...")
	_ncont++

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

	If _ncont > 10

		U_MFCONOUT("Enviando AR  ate " + strzero(_npos,6) + " de " + strzero(_ntot,6) + "...")
		cJson := fwJsonSerialize(oRet25, .F., .T.)

		oWSRetTP25 := nil
		oWSRetTP25 := MGFINT23():new(cURLPost, oRet25, , ,'', cCodInt , cTipInt, 'RET AR' /*cChave*/,.F.,.F.,lMonitor)

		cSavcInternet := Nil
		cSavcInternet := __cInternet
		__cInternet := "AUTOMATICO"

		oWSRetTP25:SendByHttpPost()

		__cInternet := cSavcInternet

		IF oWSRetTP25:lOk // Resultado  
                    
			cUpd := " UPDATE "+RetSqlName("ZD1")+" " + CRLF
			cUpd += " SET ZD1_INTEGR = 'S' ," + CRLF          
			cUpd += "	  ZD1_DTENV = '"+dTos(Date())+"', " + CRLF
			cUpd += "	  ZD1_HRENV = '"+Time()+"' " + CRLF
			cUpd += " WHERE R_E_C_N_O_ in ("+cRet+")"+CRLF 

			U_MFCONOUT("Gravando AR ate " + strzero(_npos,6) + " de " + strzero(_ntot,6) + "...")

			IF (TcSQLExec(cUpd) < 0)
				ConOut("## MGFTAE25"+TcSQLError())
			EndIF 

		ELSE
			U_MFCONOUT("Erro no retorno do TAURA!" +' - ' + cRet + '-' + CRLF + cPostRet)
		EndIF

		oRet25 := nil
		oRet25 := RetMovAR():new()
		oRet25:CHAVES := {}   
		_ncont := 0    
		cRet := "-1"    

	Endif

	_npos++

Next nI	


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
Self:CHAVES[_ncont]:ChaveUID := Alltrim(xZD1_CHAVEU)
Self:CHAVES[_ncont]:Mensagem := IIF( xZD1_STATUS==3,Alltrim(xMSG_ERRO),'ACAO EFETIVADA') 
Self:CHAVES[_ncont]:Sucesso  := IIF( xZD1_STATUS==3,.F.,.T.) 

Return
************************************************************************************************************************************************************

