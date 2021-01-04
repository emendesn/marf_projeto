#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            

#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)   

/*
=============================================================================================================
Programa.:              MTE24JOB
Autor....:              Marcelo Moraes
Data.....:              07/05/2018
Descricao / Objetivo:   Integracao PROTHEUS x Taura - JOB - CHAMAR PROCESSO DE ENTRADA DO AR
Doc. Origem:            Contrato - GAP TAURA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              JOB que chama o Programa que processa os movimentos de AR
Pametros passados na
chamada do JOB.:        cPar1 - Obrigatorio - Parametro de controle do sistema,
                                              pode ser qualquer numero inteiro: 1,2,3...
                        cPar2 - Opcional - se passado como C - Compartilhado. O programa rodará para todas as filiais,
                        			           excluindo as filiais definidas nos parametros cPar3 até cPar8
                        		           se passado como E - Exclusivo. O programa rodará somente para as filiais,
                        			           definidas nos parametros cPar3 até cPar8
Observação: Para que o programa rode para todas as filiais, basta não imformar os parametros cPar2 até cPar8                     
=============================================================================================================                             
*/                                 
User Function xProcAr

U_MTE24JOB('9','E','010044')

Return
**************************************************************************************
User Function MTE24JOB(cPar1,cPar2,cPar3,cPar4,cPar5,cPar6,cPar7,cPar8)

	Local aParam	:= {}
	
	If ValType(cPar1) <> "C" .or. Val(cPar1)<=0
		Conout("MGFTAE29 - ERRO! PRIMEIRO PARAMETRO TEM QUE SER UM NUMERO INTEIRO. EX 1,2,3... " + DTOC(date()) + " - " + TIME() )
		Return
	endif
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

	U_MGFTAE24({Val(cPar1),aParam})

Return
          
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

User Function MGFTAE24(aParam)

local nProg        := aParam[01]
local cProg        := ""

Private _aMatriz   := {"01","010001"}  
Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"

IF lIsBlind
   RpcSetType(3)
   RpcSetEnv(_aMatriz[1],_aMatriz[2])  
   cProg := STRZERO(nProg,2)   
   If !LockByName("MGFTAE24_"+cProg)
      Conout("JOB já em Execução : MGFTAE24 " + DTOC(dDATABASE) + " - " + TIME() )
      RpcClearEnv() 
      Return
   EndIf

   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('---------------------- Inicio do processamento - MGFTAE24 - Movimentos de AR - ' + DTOC(dDATABASE) + " - " + TIME()  )
   conOut("********************************************************************************************************************"+ CRLF)       
   Proc_AR(aParam[02]) 
   conOut("********************************************************************************************************************"+ CRLF)       
   conOut('---------------------- Fim  - MGFTAE24 - Movimentos de AR - ' + DTOC(dDATABASE) + " - " + TIME()  )
   conOut("********************************************************************************************************************"+ CRLF)       

EndIF

Return
***********************************************************************************************************************************************
Static Function Proc_AR(aFiliais)
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

//##################################################
//## INICIO - Trata filiais que serao processadas ##
//##################################################
if len(aFiliais)>1 //O array aFiliais precisa ter no mino 2 elementos
	For Y:=1 to len(aFiliais)
		if Y=1 
			loop //Despreza o primeiro item, pois este apenas indica se o processamento sera compartilhado ou exclusivo
		endif
		_cFiliais += "'"+alltrim(aFiliais[Y])+"',"
	next
	
	_cFiliais := substr(_cFiliais,1,len(_cFiliais)-1)
	
	if aFiliais[1]=="C" //Compartilhado
		cString := " AND ZD1_FILIAL NOT IN ("+_cFiliais+") "
	ElseIf aFiliais[1]=="E" //Exclusivo
		cString := " AND ZD1_FILIAL IN ("+_cFiliais+") "
	else
		ConOut("## MGFTAE24 - ERRO NOS PARAMETROS QUE DEFINEM AS FILIAIS A SEREM PROCESSADAS - ")
		return
	endif
else
	cString := "" //Neste caso, serao consideradas todas as filiais
endif
//###############################################
//## FIM - Trata filiais que serao processadas ##
//###############################################
                      
dbSelectArea('ZD1')
ZD1->(dbSetOrder(1))
cIdProc	:=GetSXENum("ZD1","ZD1_PROC")

cUpd := "UPDATE "+RetSqlName("ZD1")+" " + CRLF
cUpd += "SET ZD1_STATUS = 0 " + CRLF
cUpd += "WHERE D_E_L_E_T_ = ' ' "+CRLF
cUpd += " AND ZD1_STATUS = 1  "+CRLF
cUpd += " AND ZD1_PROC   <> '"+cIdProc+"' " + CRLF
cUpd += cString + CRLF
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
cUpd += cString + CRLF
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
	//cQuery += "	ORDER BY R_E_C_N_O_" + CRLF   
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