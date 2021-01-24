#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBEX.CH"

/*/
{Protheus.doc} MGFWSS18
WS Integração Protheus-TAURA EXP
@author Paulo da Mata
@since 12/05/2020
@type WS  
/*/   
WSSTRUCT MGFWSS18EXPT

	WSDATA IDEMPRESA as String  OPTIONAL
    WSDATA IDEXP     as String  OPTIONAL
    WSDATA MENSAGEM  as String  OPTIONAL

    WSDATA STATUS    as String  OPTIONAL
    WSDATA ORIGEM    as String  OPTIONAL
 
ENDWSSTRUCT

WSSTRUCT MGFWSS18RESEXPT

    WSDATA IDEXP     as String  OPTIONAL
    WSDATA MENSAGEM  as String  OPTIONAL

    WSDATA STATUS    as String OPTIONAL
    WSDATA ORIGEM    as String OPTIONAL

ENDWSSTRUCT

WSSERVICE MGFWSS18 DESCRIPTION "Retorno de consulta da EXP Taura Assincrona" NameSpace "http://totvs.com.br/MGFWSS18.apw"

	WSDATA MGFWSS18EXPT AS MGFWSS18EXPT

    WSDATA MGFWSS18RESEXPT AS MGFWSS18RESEXPT

	WSMETHOD MGFWSS18R DESCRIPTION "Retorno de consulta da EXP Taura Assincrona"

ENDWSSERVICE

/*/
{Protheus.doc} MGFWSS18R
WS Integração Assincrona Protheus-TAURA EXP

@author Paulo da Mata
@since 12/05/2020
@type WS  
/*/   
WSMETHOD MGFWSS18R WSRECEIVE MGFWSS18EXPT WSSEND MGFWSS18RESEXPT WSSERVICE MGFWSS18

Local lReturn := .T.
Local aRetFuncao := {}

// Salva a Mensagem de retorno da integração da EXP com o TAURA
aRetFuncao := U_MGFWSS18E(::MGFWSS18EXPT)

// Cria e alimenta uma nova instancia de retorno do cliente
::MGFWSS18RESEXPT           :=  WSClassNew( "MGFWSS18EXPT" )
::MGFWSS18RESEXPT:IDEXP	    := ::MGFWSS18EXPT:IDEXP
::MGFWSS18RESEXPT:MENSAGEM  := ::MGFWSS18EXPT:MENSAGEM

::MGFWSS18RESEXPT:STATUS    := ::MGFWSS18EXPT:STATUS
::MGFWSS18RESEXPT:ORIGEM    := ::MGFWSS18EXPT:ORIGEM

Return lReturn


/*/
{Protheus.doc} MGFWSS18E
WS Integração Assincrona Protheus-TAURA EXP
Salva a mensagem de informação do retorno enviado pela integração

@author Paulo da Mata
@since 12/05/2020
@type WS  
/*/   
User Function MGFWSS18E( OOE )

Local aRetorno := {}
Local lOk      := .F.
Local cQuery   := ""
Local cChave   := ""

AADD(aRetorno,"200")
AADD(aRetorno,"Retorno processado com sucesso")
AADD(aRetorno,0)

BEGIN SEQUENCE

    // Valida se existe na ZB8
    IF AllTrim(OOE:ORIGEM) != "multisoftware" 
        If !Empty(OOE:IDEXP)

       		If Select("TRBZB8") > 0
			    TRBZB8->(dbCloseArea())
		    Endif

            cQuery := "SELECT * FROM "+RetSqlName("ZB8")+" "
            cQuery += "WHERE D_E_L_E_T_ = ' ' "
            cQuery += "AND ZB8_EXP = '"+LEFT(OOE:IDEXP,9)+"' "

       		cQuery := ChangeQuery(cQuery)
		    dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBZB8",.F.,.T.)
		    dbSelectArea("TRBZB8")
   
            If TRBZB8->(!Eof())
                cChave := TRBZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)
            EndIf     
               
            ZB8->(dbSetOrder(3))
            If !ZB8->(dbSeek(cChave))
               aRetorno[1] := "IDEXP não localizada, tente novamente!"
               Break
            Else
               RecLock("ZB8",.F.)
               ZB8->ZB8_ZRETWS := ALLTRIM(OOE:MENSAGEM)
               ZB8->(MsUnLock())
               lOk := .T.
            Endif
        EndIf
    ElseIf AllTrim(OOE:ORIGEM) ==  "multisoftware" 
        If Select("TRBZB8") > 0
	        TRBZB8->(dbCloseArea())
		Endif
        cQuery := "SELECT * FROM "+RetSqlName("ZB8")+" ZB8"
        cQuery += " WHERE"
        cQuery += " ZB8.D_E_L_E_T_     = ' ' "
        cQuery += " AND ZB8.ZB8_EXP    = '"+SUBSTR(OOE:IDEXP,1,9)+"'"
        cQuery += " AND ZB8.ZB8_ANOEXP = '"+SUBSTR(OOE:IDEXP,11,2)+"'"
        cQuery += " AND ZB8.ZB8_SUBEXP = '"+SUBSTR(OOE:IDEXP,14,3)+"'"
        
        //PRB0041064-CALLBACK-EXP-TMS-Multisoftware
        //IDEXP
        //O numeroExp é enviado com: SUBS(ZB8->ZB8_EXP,4,6)+"/"+alltrim(ZB8->ZB8_ANOEXP)+"-"+ZB8->ZB8_SUBEXP
        //Retorno vem com "EXP"+SUBS(ZB8->ZB8_EXP,4,6)+"/"+alltrim(ZB8->ZB8_ANOEXP)+"-"+ZB8->ZB8_SUBEXP
        //EXP129056/20-002 

       	cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBZB8",.F.,.T.)
		dbSelectArea("TRBZB8")
        If TRBZB8->(!Eof())
            cChave := TRBZB8->(ZB8_FILIAL+ZB8_EXP+ZB8_ANOEXP+ZB8_SUBEXP)
        EndIf                    
        ZB8->(dbSetOrder(3))
        If !ZB8->(dbSeek(cChave))
            aRetorno[1] := "IDEXP não localizada, tente novamente!"
            Break
        Else
            IF OOE:STATUS = "1" // DEU CERTO 
                RecLock("ZB8",.F.)
                ZB8->ZB8_ZTMSID := ALLTRIM(OOE:MENSAGEM)
                ZB8->(MsUnLock())
                lOk := .T.
            ELSEIF OOE:STATUS $ "2|3|4"// DEU ERRADO
                RecLock("ZB8",.F.)
                //ZB8->ZB8_ZRETWS := ALLTRIM(OOE:MENSAGEM) - RTASK0011598
                ZB8->ZB8_ZTMSER := ALLTRIM(OOE:MENSAGEM)
                ZB8->(MsUnLock())
                lOk := .T.
            ENDIF
         EndIf                      
    EndIf
    If lOk
        IF OOE:ORIGEM != "multisoftware" 
    	    U_MGFMONITOR(	ZB8->ZB8_FILVEN	                                ,;
					    If(Left(ALLTRIM(OOE:MENSAGEM),1)=="1","1","2")	,;
					    "001" 	                                        ,;
					    "019"                                           ,;
                        ALLTRIM(OOE:MENSAGEM)							,;
						ZB8->ZB8_EXP                         	        ,;
					    SubStr(Time(),1,8)								)
        ELSE
            U_MGFMONITOR(	ZB8->ZB8_FILVEN	                                ,;
					    If(Left(ALLTRIM(OOE:MENSAGEM),1)=="1","1","2")	,;
					    "011" 	                                        ,;
					    "004"                                           ,;
                        ALLTRIM(OOE:MENSAGEM)							,;
						ZB8->ZB8_EXP                         	        ,;
					    SubStr(Time(),1,8)								)
        ENDIF
    EndIf

END SEQUENCE

ZB8->(MsUnlock())
ZB8->(MsUnlockAll())

return aRetorno
