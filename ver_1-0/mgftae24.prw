#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            

#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)                                

          
/*
==========================================================================================================
Programa.:              MGFTAE24
Autor....:              Marcelo Carneiro         
Data.....:              12/07/2017 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Programa que processa os movimentos de AR - Colocar no SCHEDULE
==========================================================================================================
*/

User Function MGFTAE24()


conOut("********************************************************************************************************************"+ CRLF)       
 conOut('---------------------- Inicio do processamento - MGFTAE24 - Movimentos de AR - ' + DTOC(date()) + " - " + TIME()  )
conOut("********************************************************************************************************************"+ CRLF)       

Proc_AR() 

conOut("********************************************************************************************************************"+ CRLF)       
conOut('---------------------- Fim  - MGFTAE24 - Movimentos de AR - ' + DTOC(date()) + " - " + TIME()  )
conOut("********************************************************************************************************************"+ CRLF)       

Return

***********************************************************************************************************************************************
Static Function Proc_AR()

Local cIdProc	:= ''
Local cUpd      := ''
Local cQuery    := ''   
Local aRetorno  := {}                                     
Local cChave    := ''       
Local aAR       := {}         
Local nI        := 0 
Local aRecno    := {}
Local nRet      := 0
Local _cFiliais := "" 
Local cString   := ""

                      
dbSelectArea('ZD1')
ZD1->(dbSetOrder(1))
cIdProc	:=GetSXENum("ZD1","ZD1_PROC")

cUpd := "UPDATE "+RetSqlName("ZD1")+" " + CRLF
cUpd += "SET ZD1_STATUS = 0 " + CRLF
cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += " AND ZD1_STATUS = 1  "+CRLF
cUpd += " AND ZD1_PROC   <> '"+cIdProc+"' " + CRLF


If TcSqlExec( cUpd ) == 0
	If "ORACLE" $ TcGetDB()
		TcSqlExec( "COMMIT" )
	EndIf
EndIF

cUpd := "UPDATE "+RetSqlName("ZD1")+" " + CRLF
cUpd += "SET ZD1_STATUS = 1, " + CRLF
cUpd += "	 ZD1_PROC   = '"+cIdProc+"' " + CRLF
cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += " AND ZD1_STATUS = 0  "+CRLF


If TcSqlExec( cUpd ) == 0
	If "ORACLE" $ TcGetDB()
		TcSqlExec( "COMMIT" )
	EndIf

	cQuery := "SELECT R_E_C_N_O_ RECZD1, ZD1.* "+CRLF
	cQuery += "FROM "+RetSqlName("ZD1")+" ZD1"+CRLF
	cQuery += "WHERE D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "	AND ZD1_STATUS = 1 " + CRLF
	cQuery += "	AND ZD1_PROC   = '"+cIdProc+"' " + CRLF
	cQuery += cString + CRLF	
	cQuery += "	ORDER BY ZD1_FILIAL, ZD1_ACAO, ZD1_PRODUT, ZD1_NUM_AR, ZD1_SEQ, ZD1_DATAMO, ZD1_LOTE, ZD1_VALIDA"
	If Select("QRY_ZD1") > 0
		QRY_ZD1->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZD1",.T.,.F.)
	dbSelectArea("QRY_ZD1")
	QRY_ZD1->(dbGoTop())
	IF QRY_ZD1->(!EOF()) 
	    ConfirmSX8()     
	    cChave := ''//QRY_ZD1->(ZD1_FILIAL+ZD1_ACAO+ZD1_PRODUT+ZD1_NUM_AR+ZD1_SEQ+ZD1_DATAMO+ZD1_LOTE+ZD1_VALIDA)
	    aAR    :=  {}
		While QRY_ZD1->(!EOF()) 
		    IF cChave == QRY_ZD1->(ZD1_FILIAL+ZD1_ACAO+ZD1_PRODUT+ZD1_NUM_AR+ZD1_SEQ+ZD1_DATAMO+ZD1_LOTE+ZD1_VALIDA)
		        aAr[Len(aAR),7]  += QRY_ZD1->ZD1_QUANT
		        aAr[Len(aAR),14] += ','+Alltrim(STR(QRY_ZD1->RECZD1))
		    Else 
		        cChave := QRY_ZD1->(ZD1_FILIAL+ZD1_ACAO+ZD1_PRODUT+ZD1_NUM_AR+ZD1_SEQ+ZD1_DATAMO+ZD1_LOTE+ZD1_VALIDA)
		        AAdd(aAR,  {QRY_ZD1->ZD1_ACAO   ,;    //01
							QRY_ZD1->ZD1_GERAOP ,;    //02
							QRY_ZD1->ZD1_FILIAL ,;    //03
							QRY_ZD1->ZD1_NUM_AR ,;    //04
							QRY_ZD1->ZD1_PRODUT ,;    //05
							QRY_ZD1->ZD1_SEQ    ,;    //06
							QRY_ZD1->ZD1_QUANT  ,;    //07
							QRY_ZD1->ZD1_DATAMO ,;    //08
							QRY_ZD1->ZD1_HORAMO ,;    //09
							QRY_ZD1->ZD1_LOTE   ,;    //10
							QRY_ZD1->ZD1_VALIDA ,;    //11
							QRY_ZD1->ZD1_DATAPR ,;    //12
							QRY_ZD1->ZD1_IDMOV  ,;    //13
							Alltrim(STR(QRY_ZD1->RECZD1))})			
			EndIF                                                                                            
		    QRY_ZD1->(dbSkip())
	    End
	    For nI := 1 to Len(aAR)  	

			cfilant := alltrim(QRY_ZD1->ZD1_FILIAL)

			aRetorno := U_MGFTAE10( aAR[nI,01],;
									aAR[nI,02],;
									aAR[nI,03],;
									aAR[nI,04],;
									aAR[nI,05],;
									aAR[nI,06],;
									aAR[nI,07],;
									aAR[nI,08],;
									aAR[nI,09],;
									aAR[nI,10],;
									aAR[nI,11],;
									aAR[nI,12],;
									aAR[nI,13],;
									aAR[nI,14]   )
	   Next  nI
	Else
		RollbackSX8()
	EndIF    
	If Select("QRY_ZD1") > 0
		QRY_ZD1->(dbCloseArea())
	EndIf
Else
	ConOut("## MGFTAE24  ERRO UPDATE ZD1_STATUS ")
	RollbackSX8()
EndIf

Return
