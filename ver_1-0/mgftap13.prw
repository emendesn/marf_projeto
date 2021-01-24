#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP13
Retorno de integração de processos produtivos (TAP02)

@author Atilio Amarilla
@since 08/11/2016 
@type Função  
/*/   
User Function MGFTAP13()
                                     
Local nLimReg       := 100
Local nQtdReg       := 0    

Private cURLPost		//:= GetMv("MGF_TAP13A",,"http://spdwvtds002/wsintegracaoShape/api/v0/Integracao")
Private cCodInt		//:= GetMv("MGF_TAP11C",,"001")
Private cTipInt		//:= GetMv("MGF_TAP11D",,"001")
Private cJson			:= ""
Private oWSRetTP13   	:= nil
Private lMonitor        := .F.                                            
Private aEnvia          := {}
Private nI              := 0 

U_MFCONOUT('Iniciando retorno de processamento dos movimentos produtivos...') 

cURLPost	:= GetMv("MGF_TAP13A",,"http://spdwvtds002/wsintegracaoShape/api/v0/Integracao")
cCodInt		:= AllTrim(GetMv("MGF_MONI01"))
cTipInt		:= AllTrim(GetMv("MGF_MONT10"))

U_MFCONOUT('Carregando registros pendentes e retorno...') 

MGFTAP13Q() // Query para busca de registros na tabela ZZE

nQtdReg       := 0   
_ntoti        := 0 
_ntotal       := 0

U_MFCONOUT('Montando dados de retorno de processamento dos movimentos produtivos...') 

QRYZZE->(Dbgotop())

While QRYZZE->(!EOF())

	ZZE->( dbGoTo( QRYZZE->ZZE_RECNO ) )

    nQtdReg++
	_ntoti++
	If nQtdReg >= nLimReg 
		nQtdReg  := 0 
		U_MFCONOUT('Enviando dados de retorno de processamento dos movimentos produtivos...(' + strzero(_ntoti,6)  + ")" ) 
		MGFTAP13E(aEnvia)
	    aEnvia   := {}
	Else
	   AAdd(aEnvia,{QRYZZE->ZZE_RECNO,   ; //01
	    			QRYZZE->ZZE_CHAVEU, ; //02
	    			QRYZZE->ZZE_STATUS, ; //03
	    			QRYZZE->ZZE_DESCER,	;
	    			ZZE->ZZE_MSGERR		} )
	EndIF 												
	QRYZZE->(DBSkip())
    IF QRYZZE->(EOF()) .And. nQtdReg <> 0 
U_MFCONOUT('Enviando dados de retorno de processamento dos movimentos produtivos...(' + strzero(_ntoti,6) + ")" ) 
    	MGFTAP13E(aEnvia) //Realiza envio dos retornos de integração
    EndIF
End

QRYZZE->(DBCloseArea())

U_MFCONOUT('Completou retorno de processamento dos movimentos produtivos...') 

Return

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP13E
Envios do retorno de integração

@author Atilio Amarilla
@since 08/11/2016 
@type Função  
/*/   
Static Function MGFTAP13E(aEnvia)

Local cRet := "-1" 
Local cUpd := ''
Private oRetTP13   := nil
Private oArrTP13   := nil
Private aParJob    := ACLONE(aEnvia)


oRetTP13 := nil
oRetTP13 := RetTP13():new()
oRetTP13:CHAVES := {}                        

For nI := 1  To Len(aParJob)
	cRet        += ","+Alltrim(STR(aParJob[nI,01]))
	oRetTP13:SetRetTP13()
Next nI

cJson := fwJsonSerialize(oRetTP13, .F., .T.)

cJson := StrTran(cJson,"CHAVEUID"		,"ChaveUID")
cJson := StrTran(cJson,"MENSAGEM"		,"Mensagem")
cJson := StrTran(cJson,"SUCESSO"		,"Sucesso")
cJson := StrTran(cJson,"CHAVES"	     	,"Chaves")

oWSRetTP13 := nil
oWSRetTP13 := MGFINT23():new(cURLPost, oRetTP13, , ,""  , cCodInt , cTipInt, 'RET PROD'  ,.F.,.F.,lMonitor)
oWSRetTP13:SendByHttpPost()

IF oWSRetTP13:lOk // Resultado

	cUpd := " UPDATE "+RetSqlName("ZZE")
	cUpd += " SET ZZE_RTAURA = 'I' ," 
	cUpd += "	  ZZE_DTENV = '"+dTos(Date())+"', " + CRLF
	cUpd += "	  ZZE_HRENV = '"+Time()+"' " + CRLF
	cUpd += " WHERE R_E_C_N_O_ in ("+cRet+")"
	TcSQLExec(cUpd) 
EndIF

Return

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFTAP13Q
Carrega registros pendentes de integração

@author Atilio Amarilla
@since 08/11/2016 
@type Função  
/*/   
Static Function MGFTAP13Q()

Local cQryZZE  := ""
Local cStatus  := GetMv("MGF_TAP13D",,"'1','2','4','5'")
Local cEmpSel  := "'x'"
Local nI       := 0

cQryZZE := "SELECT R_E_C_N_O_ ZZE_RECNO, ZZE_GERACA, ZZE_HORA, ZZE_IDTAUR, ZZE_ID, ZZE_RTAURA, ZZE_DESCER, ZZE_STATUS, ZZE_CHAVEU " + CRLF
cQryZZE += " FROM "	+ RetSQLName("ZZE") + " ZZE "	+ CRLF
cQryZZE += " WHERE ZZE.D_E_L_E_T_	=	' ' "	+ CRLF
cQryZZE += " 	AND	ZZE_RTAURA	=	' ' "	+ CRLF 
cQryZZE += " 	AND	ZZE_STATUS	IN	("+cStatus+") "	+ CRLF 
cQryZZE += " 	AND	ZZE_CHAVEU <> ' '"
cQryZZE += " 	AND (ZZE.ZZE_IDTAUR <> ' ' OR  ZZE_TPMOV='04') " 
cQryZZE += "ORDER BY 1"	+ CRLF

TcQuery ChangeQuery(cQryZZE) New Alias "QRYZZE"

Return

/*/
==============================================================================================================================================================================
{Protheus.doc} RetTP13
Classe de envio de retorno de integração de processos produtivos

@author Atilio Amarilla
@since 08/11/2016 
@type Função  
/*/   
Class RetTP13
Data ApplicationArea	as ApplicationArea
Data CHAVES				as Array 

Method New()
Method SetRetTP13()

Return

Class Ret13CHAVEIU

Data ChaveUID           as String
Data Mensagem			as String        
Data Sucesso			as Boolean

Method New()

Return

method New() class RetTP13

Self:ApplicationArea	:= ApplicationArea():new()

Return
 
Method SetRetTP13() Class RetTP13

aAdd(Self:CHAVES,WSClassNew( "Ret13CHAVEIU"))
Self:CHAVES[nI]:ChaveUID := Alltrim(aParJob[nI,02]) // CHAVEU

If	!Empty( AllTrim( aParJob[nI,05] ) )
	Self:CHAVES[nI]:Mensagem := AllTrim(aParJob[nI,05])
Else
	Self:CHAVES[nI]:Mensagem := IIF( At(".LOG",Upper(AllTrim(aParJob[nI,04]))) > 0 , U_zLerTxt(AllTrim(aParJob[nI,04])),AllTrim(aParJob[nI,04]))
EndIf	
Self:CHAVES[nI]:Sucesso  := IIF( aParJob[nI,03]=="2",.F.,.T.) // "1"

Return

