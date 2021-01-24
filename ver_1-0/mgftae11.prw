#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            

#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE11
Autor....:              Marcelo Carneiro         
Data.....:              09/11/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              WebServer Server para Gerar o Encerramento do AR - Carga Fria
==========================================================================================================
*/

WSSTRUCT FTAE11_ENCERRAAR
	WSDATA FILIAL       as String
	WSDATA NUM_AR       as String
	WSDATA ACAO         as String Optional 
ENDWSSTRUCT

WSSTRUCT FTAE11_RETORNO
	WSDATA STATUS  as String
	WSDATA MSG	   as String
ENDWSSTRUCT

WSSERVICE MGFTAE11 DESCRIPTION "Encerra Contagem - Carga Fria" NameSpace "http://www.totvs.com.br/MGFTAE11"	
	WSDATA WSENCERRAAR  as FTAE11_ENCERRAAR
	WSDATA WSRETORNO    as FTAE11_RETORNO

	WSMETHOD EncerrarAR DESCRIPTION "Encerra Contagem - Carga Fria"	
ENDWSSERVICE
WSMETHOD EncerrarAR WSRECEIVE WSENCERRAAR WSSEND WSRETORNO WSSERVICE MGFTAE11

Private aRetorno  := {}
Private wsFILIAL  := ::WSENCERRAAR:FILIAL   
Private wsNUM_AR  := ::WSENCERRAAR:NUM_AR  
Private wsAcao    := ::WSENCERRAAR:ACAO                       
Private bContinua := .T.           
Private bEncerra  := .T.    

Default wsAcao    := 1 

CONOUT ("-------------------------------- INICIO -----------------------------------" + wsNUM_AR + " - " + Time() )

IF !(wsAcao $ '124')
	AAdd(aRetorno ,"2")
	AAdd(aRetorno,'ACAO:Ação deverá ser : 1=Enceramento 2=Reabertura 4=Encerramento Transbordo') 
	bContinua := .F.
	CONOUT("1 - " + wsNUM_AR + " - " + Time() )
Else
	IF !FWFilExist(cEmpAnt,wsFILIAL)
		AAdd(aRetorno ,"2")
		AAdd(aRetorno,'FILIAL:Filial não cadastrada') 
		bContinua := .F.
		CONOUT("2 - " + wsNUM_AR + " - " + Time() )
	Else
		dbSelectArea('ZZH')
		ZZH->(dbSetOrder(1))
		IF ZZH->(!dbSeek(wsFILIAL+ALLTRIM(wsNUM_AR)))
			AAdd(aRetorno ,"2")
			AAdd(aRetorno,'NUM_AR:AR não Cadastrado')
			bContinua := .F.
			CONOUT("3 - " + wsNUM_AR + " - " + Time())
		EndIF
	EndIF
EndIF 

IF bContinua
	IF SUBSTR(ZZH->ZZH_AR,1,1)=='S'
	    IF wsAcao == '2' .And. ZZH->ZZH_STATUS  == '3'
			AAdd(aRetorno ,"2")
			AAdd(aRetorno,'AR não pode ser Reaberto')
			CONOUT("4 - " + wsNUM_AR + " - " + Time() )
		Else             
			AAdd(aRetorno ,"1")
			RecLock("ZZH", .F. )
			IF wsAcao == '1'
			     ZZH->ZZH_STATUS  := '2'
			     AAdd(aRetorno,'AR encerrado com sucesso')
			     CONOUT("5 - " + wsNUM_AR + " - " + Time() )
			Else
				ZZH->ZZH_STATUS  := '1'
				AAdd(aRetorno,'AR Reaberto com sucesso')
				CONOUT("6 - " + wsNUM_AR + " - " + Time() )
			EndIF
			ZZH->(MsUnLock())
		EndIF
	Else 
	
		IF wsAcao == '4' // Transbordo
		    dbSelectArea("ZD1")
			If RecLock("ZD1",.T.)
				ZD1->ZD1_FILIAL	  := wsFILIAL
				ZD1->ZD1_STATUS	  := 0
				ZD1->ZD1_INTEGR   := 'N'
				ZD1->ZD1_ACAO     := '4'
				ZD1->ZD1_GERAOP   := '2'
				ZD1->ZD1_NUM_AR   := wsNUM_AR
				ZD1->ZD1_DTREC    := dDataBase  
				ZD1->ZD1_HRREC    := Time()
				ZD1->( msUnlock() )
				AAdd(aRetorno ,"1")
				AAdd(aRetorno,'Encerramendo de Transbordo Cadastrado com Sucesso')
		   Else
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'Encerramendo de Transbordo não cadastrado')
		   EndIF
		   
		Else
			ZZI->(dbSetOrder(1))
			ZZI->(DbSeek(wsFILIAL+PADR(ALLTRIM(wsNUM_AR),TamSX3("ZZI_AR")[1])))
			While ZZI->(!Eof()) .And. ZZI->ZZI_FILIAL == wsFILIAL .And. ZZI->ZZI_AR == PADR(ALLTRIM(wsNUM_AR),TamSX3("ZZI_AR")[1])
				IF ZZI->ZZI_QNF <> ZZI->ZZI_QCONT
					bEncerra := .F.
				EndIF
				ZZI->(dbSkip())
			EndDo
			dbSelectArea("ZZH")
			
			IF ZZH->(dbSeek(wsFILIAL+ALLTRIM(wsNUM_AR)))
				RecLock("ZZH", .F. )
				
				CONOUT("A - " + ZZH->ZZH_STATUS + " - " + ZZH->ZZH_AR + " - " + CVALTOCHAR(ZZH->(RECNO())) + " - " + Time() )
				
				IF wsAcao == '1'
					IF bEncerra
						ZZH->ZZH_STATUS  := '3' 
						CONOUT("7 - " + wsNUM_AR + " - " + Time() )
					Else
						ZZH->ZZH_STATUS  := '2'
						CONOUT("8 - " + wsNUM_AR + " - " + Time() )
					EndIF
				Else
					ZZH->ZZH_STATUS  := '1'
					//AAdd(aRetorno ,"2")
					CONOUT("9 - " + wsNUM_AR + " - " + Time() )
				EndIF
				ZZH->(MsUnLock())
				
				CONOUT("B - " + ZZH->ZZH_STATUS + " - " + ZZH->ZZH_AR + " - " + CVALTOCHAR(ZZH->(RECNO())) + " - " + Time() )
				
				cPrefixo := GetAdvFVal( "SF1", "F1_PREFIXO", wsFILIAL+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+ALLTRIM(ZZH->ZZH_FORNEC)+ZZH->ZZH_LOJA, 1, "" )
				cQuery := " Update "+RetSqlName("SE2") 
				
				IF wsAcao == '1'
					cQuery += " Set E2_MSBLQL    = '2'"
				Else
					cQuery += " Set E2_MSBLQL    = '1'"
				EndIF
				cQuery += " Where E2_FILIAL  = '"+wsFILIAL+"'"
				cQuery += "   AND E2_PREFIXO = '"+cPrefixo+"'"
				cQuery += "   AND E2_NUM     = '"+ZZH->ZZH_DOC+"'"
				cQuery += "   AND E2_TIPO    = 'NF'"
				cQuery += "   AND E2_FORNECE = '"+ZZH->ZZH_FORNEC+"'"
				cQuery += "   AND E2_LOJA    = '"+ZZH->ZZH_LOJA+"'"
				IF (TcSQLExec(cQuery) < 0)
					//MsgStop(TcSQLError())
				EndIF
			EndIF
			AAdd(aRetorno ,"1")
			IF wsAcao == '1'
				AAdd(aRetorno,'AR encerrado com sucesso')
			Else
				AAdd(aRetorno,'AR Reaberto com sucesso')
			EndIF
		EndIF
	EndIF
EndIF
U_MGFMONITOR(     wsFILIAL ,;
				  aRetorno[1],;
	              '001',; //cCodint
				  '016' ,;//cCodtpint
				  aRetorno[2]	,;
				  wsAcao+'-'+wsFILIAL+'-'+wsNUM_AR ,; //cDocori
				  '0' ,;//cTempo
				  '',;
				  0)



::WSRETORNO := WSClassNew( "FTAE11_RETORNO")
::WSRETORNO:STATUS  := aRetorno[1]
::WSRETORNO:MSG	    := aRetorno[2]

CONOUT ("-------------------------------- FIM --------------------------------------" + wsNUM_AR + " - " + Time() )


::WSENCERRAAR := NIL
DelClassINTF()

Return .T.     
**********************************************************************************************************************************
