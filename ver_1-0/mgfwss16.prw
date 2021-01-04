#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"


/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS16
WS Integração Assincrona de estoque SFA

@author Josué Danich Prestes
@since 18/11/2019 
@type WS  
/*/   

 
WSSTRUCT MGFWSS16CONSEST

	WSDATA QUANT   		        AS String OPTIONAL
	WSDATA PECAS 		        as String OPTIONAL
    WSDATA PESO 		        as String OPTIONAL
    WSDATA QUANT_RES 	        as String OPTIONAL
    WSDATA PESO_RES	            as String OPTIONAL
    WSDATA QUANT_PRO            as String OPTIONAL
    WSDATA PESO_PRO	            as String OPTIONAL
    WSDATA QUANT_TRA            as String OPTIONAL
    WSDATA PESO_TRA	            as String OPTIONAL
    WSDATA QUANT_TRA_DISP       as String OPTIONAL
    WSDATA PESO_TRA_DISP        as String OPTIONAL
    WSDATA QUANT_SEQ            as String OPTIONAL
    WSDATA PECAS_SEQ            as String OPTIONAL
    WSDATA PESO_SEQ	            as String OPTIONAL
    WSDATA CHAVES	            as String OPTIONAL
    WSDATA CHAVEUID	            as String OPTIONAL
    WSDATA UUID	                as String OPTIONAL
    WSDATA MENSAGEM             as String OPTIONAL
 
ENDWSSTRUCT

WSSTRUCT MGFWSS16RESEST

	WSDATA UUID		        AS String OPTIONAL
    WSDATA RESULTADO            as String OPTIONAL
	WSDATA STATUS 		        as String OPTIONAL
    WSDATA RECNO 		        as String OPTIONAL

ENDWSSTRUCT

WSSERVICE MGFWSS16 DESCRIPTION "Retorno de consulta de saldo Taura Assincrona" NameSpace "http://totvs.com.br/MGFWSS16.apw"

	WSDATA MGFWSS16CONSEST AS MGFWSS16CONSEST

    WSDATA MGFWSS16RESEST AS MGFWSS16RESEST

	WSMETHOD MGFWSS16R DESCRIPTION "Retorno de consulta de saldo Taura Assincrona"

ENDWSSERVICE

/*/
==============================================================================================================================================================================
{Protheus.doc} MGFWSS16R
Integração Assincrona de estoque SFA

@author Josué Danich Prestes
@since 18/11/2019 
@type WS  
/*/   
WSMETHOD MGFWSS16R WSRECEIVE MGFWSS16CONSEST WSSEND MGFWSS16RESEST WSSERVICE MGFWSS16

Local lReturn	:= .T.
Local aretfuncao := {}
	
aRetFuncao	:= U_MGFWSS16E(::MGFWSS16CONSEST)	// Passagem de parametros para rotina

// Cria e alimenta uma nova instancia de retorno do cliente
::MGFWSS16RESEST :=  WSClassNew( "MGFWSS16RESEST" )
::MGFWSS16RESEST:UUID	    := ::MGFWSS16CONSEST:UUID
::MGFWSS16RESEST:STATUS		:= aRetFuncao[1]
::MGFWSS16RESEST:RESULTADO	:= aRetFuncao[2]
::MGFWSS16RESEST:RECNO	    := strzero(aRetFuncao[3],10)

Return lReturn

user Function MGFWSS16E( OOE )

Local aRetorno := {}

aadd(aRetorno,"200")
aadd(aRetorno,"Retorno processado com sucesso")
aadd(aretorno,0)

BEGIN SEQUENCE

//Valida se existe na ZFQ
ZFQ->(Dbsetorder(1)) //ZFQ_UUID
If !ZFQ->(Dbseek(alltrim(OOE:UUID)))
    aRetorno[1] := "500"
    aRetorno[2] := "UUID não localizada, tente novamente!"
    Break
Endif

aretorno[3] := ZFQ->(Recno())

If ZFQ->ZFQ_STATUS == "C"
    aRetorno[1] := "500"
    aRetorno[2] := "UUID já confirmada!"
    Break
Endif


//Tenta lock do registro e grava resposta recebida
If !(ZFQ->(MsRLock(ZFQ->(RECNO()))))
    aRetorno[1] := "500"
    aRetorno[2] := "UUID indisponivel para retorno, tente novamente!"
    Break
Elseif ZFQ->ZFQ_STATUS == "A"
    Reclock("ZFQ",.F.)
    ZFQ->ZFQ_ESTOQUE        := VAL(OOE:PESO)-VAL(OOE:PESO_SEQ)
    ZFQ->ZFQ_CAIXAS         := VAL(OOE:QUANT)-VAL(OOE:QUANT_SEQ)
    ZFQ->ZFQ_PECAS          := VAL(OOE:PECAS)-VAL(OOE:PECAS_SEQ)
    ZFQ->ZFQ_PESO           := VAL(OOE:PESO_PRO)
    ZFQ->ZFQ_CHAVEU         := ALLTRIM(OOE:CHAVEUID)
    ZFQ->ZFQ_STATUS := "C"
    ZFQ->ZFQ_DTRESP	:= date()
	ZFQ->ZFQ_HRRESP	:= time()
    ZFQ->ZFQ_SECMID := seconds()
    ZFQ->ZFQ_RESREC := ALLTRIM(OOE:MENSAGEM)
    ZFQ->(Msunlock())
Endif

END SEQUENCE

ZFQ->(Msunlock())
ZFQ->(Msunlockall())

return aRetorno


