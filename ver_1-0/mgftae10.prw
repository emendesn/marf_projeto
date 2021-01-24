#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            

#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MGFTAE10
Autor....:              Marcelo Carneiro         
Data.....:              09/11/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Execução do WebServer Server para Gerar o Movimento de Contagem - Carga Fria
==========================================================================================================
*/

User Function MGFTAE10(	wsACAO     ,; //1
						wsGERAROP  ,; //2
						wsFILIAL   ,; //3
						wsNUM_AR   ,; //4
						wsPRODUTO  ,; //5
						wsSEQ      ,; //6
						wsQUANT    ,; //7
						wsDATAMOV  ,; //8
						wsHORAMOV  ,; //9
						wsLOTE     ,; //10
						wsVALIDADE ,; //11
						wsDATAPROD ,; //12
						wsIDMOV    ,; //13
						wsRECNO)      //14
					

Local aCab      := {}
Local aSD3      := {}
Local aItem	    := {}
Local aSaldo    := {}
Local nOpcAuto  := 3 
Local bContinua := .T. 
Local nI        := 0                 
Local cDoc      := ''
Local cProdutos := ""       
Local cBKFil    := cFilAnt
Local aErro     := {}
Local cErro     := ""
Local nRecTrans := 0 
Local bRecTrans := .T. 
Local nRecDEV   := 0 
Local bRecDEV   := .T.                                                                      
Local cTPMov    := GetMV('MGF_TAE03',.F.,"100") 
Local cLoteAnterior := ''              
Local cLocDest  := ''
Local cLocOrig  := ''  
Local bEncerra   := .F.
Local bDiferenca := .F.

					
Private lGeraEstoque    := .F.
Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.      
Private cLocalInd       := GetMV('MGF_AE6LOC',.F.,'04')            
Private cLocBlq		    := GetMv("MGF_TAPBLQ",,"66")		// Almoxarifado Bloqueio Produção
Private aRetorno        := {}
Private aWSDados        :={	wsACAO     ,;
								wsGERAROP  ,;
								wsFILIAL   ,;
								wsNUM_AR   ,;
								wsPRODUTO  ,;
								wsSEQ      ,;
								wsQUANT    ,;
								wsDATAMOV  ,;
								wsHORAMOV  ,;
								wsLOTE     ,;
								wsVALIDADE ,;
								wsDATAPROD ,;
								wsIDMOV    ,;
								wsRECNO}
		

//Fazer a Validação dos Campos    

wsPRODUTO  := PADR(ALLTRIM(wsPRODUTO),TamSX3("B1_COD")[1])
wsLOTE     := PADR(ALLTRIM(wsLOTE),TamSX3("B8_LOTECTL")[1])

SetFunName("MGFTAE10")

dbSelectArea('SB2')
SB2->(dbsetOrder(1))                                          
dbSelectArea('SD3')
IF !(wsACAO $ '124DB')
	AAdd(aRetorno ,"2")
	AAdd(aRetorno,'ACAO:Ação deverá ser : 1=Inclusão 2=Estorno 4=Transbordo')
	bContinua := .F.
Else
	IF !(wsGERAROP $ '12')
		AAdd(aRetorno ,"2")
		AAdd(aRetorno,'GERAROP:Ação deverá ser : 1=Sim 2=Não')
		bContinua := .F.
	Else
		IF  !FWFilExist(cEmpAnt,wsFILIAL)
			AAdd(aRetorno ,"2")
			AAdd(aRetorno,'FILIAL:Filial não cadastrada')
			bContinua := .F.
		Else
			//AR
			dbSelectArea('ZZH')
			ZZH->(dbSetOrder(1))
			IF ZZH->(!dbSeek(wsFILIAL+ALLTRIM(wsNUM_AR)))
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'NUM_AR:AR não Cadastrado')
				bContinua := .F.
			Else
				IF ZZH->ZZH_STATUS=='3'
					AAdd(aRetorno ,"2")
					AAdd(aRetorno,'NUM_AR:AR Encerrado')
					bContinua := .F.
				Else
					IF wsACAO <>  '4'
						DbSelectArea('SB1')
						SB1->(dbSetOrder(1))
						IF SB1->(!DbSeek(xFilial('SB1')+Alltrim(wsPRODUTO)))
							AAdd(aRetorno ,"2")
							AAdd(aRetorno,'PRODUTO:PRODUTO NÃO CADASTRADO!!')
							bContinua := .F.
						Else
							//Verificando  se o AR existe
							DbSelectArea('ZZI')
							ZZI->(dbSetOrder(1))
							//IF ZZI->(DbSeek(wsFILIAL+PADR(ALLTRIM(wsNUM_AR),TamSX3("ZZI_AR")[1])+PADR(ALLTRIM(wsSEQ),TamSX3("ZZI_ITEM")[1])))
							IF !Empty(wsSEQ)
								IF ZZI->(!DbSeek(wsFILIAL+wsNUM_AR+wsSEQ))
									AAdd(aRetorno ,"2")
									AAdd(aRetorno,'E2_SEQ:Sequencia de AR não encontrado !!')
									bContinua := .F.
								Else
									IF SB1->B1_COD <> ZZI->ZZI_PRODUT
										AAdd(aRetorno ,"2")
										AAdd(aRetorno,'PRODUTO:Produto não é o mesmo da sequencia do AR!!')
										bContinua := .F.
									EndIF
								EndIF
							EndIF
						EndIF
					EndIF
				EndIF
			EndIF
		EndIF
	EndIF
EndIF

BEGIN TRANSACTION

IF bContinua
	cFilAnt    := wsFILIAL
	IF wsACAO == '4'
	    bEncerra   := .T.
		bDiferenca := .F.
		ZZI->(dbSetOrder(1))
		ZZI->(DbSeek(wsFILIAL+PADR(ALLTRIM(wsNUM_AR),TamSX3("ZZI_AR")[1])))
		While ZZI->(!Eof()) .And. ZZI->ZZI_FILIAL == wsFILIAL .And. ZZI->ZZI_AR == PADR(ALLTRIM(wsNUM_AR),TamSX3("ZZI_AR")[1])
			IF ZZI->ZZI_QNF <> ZZI->ZZI_QCONT
				bDiferenca := .T.
			EndIF         
			IF ZZI->ZZI_QCONT <= 0 
				bEncerra := .F.
			EndIF         
			ZZI->(dbSkip())
		EndDo           
		IF bEncerra
			dbSelectArea("ZZH")
			IF ZZH->(dbSeek(wsFILIAL+PADR(ALLTRIM(wsNUM_AR),TamSX3("ZZI_AR")[1])))
				RecLock("ZZH", .F. )
				IF bDiferenca
					 ZZH->ZZH_STATUS  := '2'
				Else
					ZZH->ZZH_STATUS  := '3'
				EndIF
				ZZH->(MsUnLock())
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
				AAdd(aRetorno ,"1")
				AAdd(aRetorno,'AR encerrado com sucesso')
			Else
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'AR não encerrado - erro na procura do AR')			
			EndIF
		Else
			AAdd(aRetorno ,"2")
			AAdd(aRetorno,'AR não encerrado - Não processou todos os itens')
		EndIF
	Else
		IF wsACAO $ '12DB' .And. wsQUANT > 0
			cProdutos += "('"+ZZI->ZZI_PRODUT+"','"+wsPRODUTO+"')"
			
			IF wsACAO == '1'
			    cLocOrig  := cLocalInd
				cLocDest  := ZZI->ZZI_LOCAL //SD1->D1_LOCAL
			ElseIF wsACAO == '2'
				cLocOrig  := ZZI->ZZI_LOCAL //SD1->D1_LOCAL
				cLocDest  := cLocalInd
			ElseIF wsACAO == 'B'
				cLocOrig  := cLocalInd
				cLocDest  := cLocBlq
			ElseIF wsACAO == 'D'
				cLocOrig  := cLocBlq
				cLocDest  := cLocalInd
			EndiF
			
			
			//U_TAE06_BLQ(wsFILIAL,cProdutos,' ')
			//Sinistro
			IF SUBSTR(wsNUM_AR,1,1) =='S'
					bContinua   := .T.
					AAdd(aRetorno ,"1")
					AAdd(aRetorno ,'Movimento Incluído')
					U_TAE10_TAB()
			ELSEIF Empty(wsSEQ) 
				aSaldo := Gera_Mov(IIF(wsACAO == '1' .OR. wsACAO == 'B','E','S'),SB1->B1_COD,SB1->B1_UM,;
				                   IIF(wsACAO == '1' .OR. wsACAO == '2',SB1->B1_LOCPAD,cLocBlq),wsDATAMOV,wsLOTE, wsVALIDADE,wsQUANT)
				IF !aSaldo[1]
					AAdd(aRetorno ,"2")
					AAdd(aRetorno ,'Erro na Inclusão da Divergencia'+aSaldo[2])
					bContinua   := .F.
				Else
					bContinua   := .T.
					AAdd(aRetorno ,"1")
					AAdd(aRetorno ,'Movimento Incluído')
					U_TAE10_TAB()
				EndIF
			ElseIF SUBSTR(wsNUM_AR,1,1) =='D'
				// Devolução...
				aSaldo := Gera_Mov('E',SB1->B1_COD,SB1->B1_UM,SB1->B1_LOCPAD,wsDATAMOV,wsLOTE, wsVALIDADE,wsQUANT)
				IF !aSaldo[1]
					AAdd(aRetorno ,"2")
					AAdd(aRetorno ,'Erro na Inclusão de Mov de Dev :'+aSaldo[2])
					bContinua   := .F.
				Else
					bContinua   := .T.
					AAdd(aRetorno ,"1")
					AAdd(aRetorno ,'Movimento Incluído')
					U_TAE10_TAB()
				EndIF
			Else
				cFilAnt := wsFILIAL
				SB1->(dbSetOrder(1))
				SB1->(DbSeek(xFilial('SB1')+ZZI->ZZI_PRODUT))
				//SD1->(dbSetOrder(1)) //filial, doc, serie, fornec, loja , produto, item
				//Alterado para Reabertura de AR não existe a nota da D1
				IF 1=2 //SD1->(!dbSeek(xFilial('SD1')+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+SUBSTR(ZZH->ZZH_FORNEC,1,TamSx3('D1_FORNECE')[01])+ZZH->ZZH_LOJA+ZZI->ZZI_PRODUT+ZZI->ZZI_ITEM))
					AAdd(aRetorno ,"2")
					AAdd(aRetorno ,'Não Achado a Nota fiscal')
					bContinua   := .F.
				Else
					aSaldo := Ver_Saldo(ZZI->ZZI_PRODUT,''/*SD1->D1_LOTECTL*/, ''/*DTOS(SD1->D1_DTVALID)*/,wsQUANT,wsDATAMOV,cLocOrig)
					IF !aSaldo[1]
						AAdd(aRetorno ,"2")
						AAdd(aRetorno ,'Erro na Inclusão de Mov de Dev :'+aSaldo[2])
						bContinua   := .F.
					Else
						cDoc :=U_TAE_DOC_D3()
						AAdd(aCab,{cDoc,STOD(wsDATAMOV)})
						aItem	    := {}
						Aadd(aItem,ZZI->ZZI_PRODUT)     //D3_COD
						AAdd(aItem,SB1->B1_DESC)     	//D3_DESCRI
						AAdd(aItem,SB1->B1_UM)          //D3_UM
						AAdd(aItem,cLocOrig)           //D3_LOCAL
						AAdd(aItem,"               ")	//D3_LOCALIZ
						
						SB1->(dbSetOrder(1))
						SB1->(DbSeek(xFilial('SB1')+Alltrim(wsPRODUTO)))
						AAdd(aItem,wsPRODUTO)  			//D3_COD
						AAdd(aItem,SB1->B1_DESC)     	//D3_DESCRI
						AAdd(aItem,SB1->B1_UM)     	    //D3_UM
						AAdd(aItem,cLocDest)    	//D3_LOCAL
						AAdd(aItem,"               ")	//D3_LOCALIZ
						
						AAdd(aItem,"                    ")//D3_NUMSERI
						// Para tratar o Lote necessita de colocar estes campos na ZZI
						//pois não há mais procura na SD1 devido a Reabertura
						If 1=2 //!Empty(SD1->D1_LOTECTL) .And. SB1->B1_RASTRO $ "LS"
							AAdd(aItem,SD1->D1_LOTECTL)   	//D3_LOTECTL
							AAdd(aItem,"      ")         	//D3_NUMLOTE
							AAdd(aItem,SD1->D1_DTVALID)   	//D3_DTVALID
						Else
							AAdd(aItem,CriaVar("D3_LOTECTL",.F.))   	//D3_LOTECTL
							AAdd(aItem,"      ")         	//D3_NUMLOTE
							AAdd(aItem,CriaVar("D1_DTVALID",.F.))   	//D3_DTVALID
						EndIF
						AAdd(aItem,0)					//D3_POTENCI
						
						AAdd(aItem,wsQUANT) 			//D3_QUANT
						AAdd(aItem,0)					//D3_QTSEGUM
						AAdd(aItem,"")   				//D3_ESTORNO
						AAdd(aItem,"      ")         			//D3_NUMSEQ
						
						// Aqui tem o Lote
						If 1=2//!Empty(SD1->D1_LOTECTL) .And. SB1->B1_RASTRO $ "LS"
							AAdd(aItem,wsLOTE)				//D3_LOTECTL
							AAdd(aItem,STOD(wsVALIDADE)) 	//D3_DTVALID
						Else
							AAdd(aItem,CriaVar("D3_LOTECTL",.F.))   	//D3_LOTECTL
							AAdd(aItem,CriaVar("D1_DTVALID",.F.))   	//D3_DTVALID
						EndIF
						AAdd(aItem,"")					//D3_ITEMGRD
						AAdd(aItem,"")   				// CAT 83 Cod. Lanc
						AAdd(aItem,"")         			//CAT 83 Cod. Lanc
//				   	AAdd(aItem,"")         			//D3_IDDCF
						AAdd(aItem,"")         			//D3_OBSERVAC
						AAdd(aCab,aItem)
						
						dbSelectArea('SB2')
						SB2->(dbsetOrder(1))
						IF SB2->(!dbSeek(xFilial('SB2')+PADR(Alltrim(wsPRODUTO),TamSX3("B1_COD")[1])+cLocDest))
							CriaSB2(wsPRODUTO,Alltrim(cLocDest),xFilial('SB2'))
						EndIF
						MSExecAuto({|x,y| mata261(x,y)},aCab,nOpcAuto)
						IF lMsErroAuto
							//DISARMTRANSACTION()
							aErro := GetAutoGRLog()
							cErro := ""
							For nI := 1 to Len(aErro)
								cErro += aErro[nI] + CRLF
							Next nI
							AAdd(aRetorno ,"2")
							AAdd(aRetorno ,'Erro na Inclusão/Exclusão do Mov AR :'+cErro)
							bContinua   := .F.
						Else
							bContinua   := .T.
							AAdd(aRetorno ,"1")
							AAdd(aRetorno ,'Movimento Incluído/Alterado')
							U_TAE10_TAB()
						Endif
					EndIF
				EndIF
			EndIF
		EndIF
	EndIF
EndIF
IF aRetorno[01] =='2'
	U_MGFMONITOR( cFilant   ,;
			      '2',;
			      '001',; //cCodint
		          '012',;//cCodtpint
				  SUBSTR(aRetorno[02],1,TamSX3("Z1_ERRO")[1]),;
			      Alltrim(wsNUM_AR)+'-'+Alltrim(wsPRODUTO)  ,;
		          '0' ,;//cTempo
		          '')
EndIF
Atu_ZD1(wsRECNO)

END TRANSACTION

dbCloseArea('ZD1')
cFilAnt := cBKFil  

aSize ( aCab, 0)
aCab      := NIL

aSize ( aSD3, 0)
aSD3      := NIL

aSize ( aItem, 0)
aItem      := NIL

aSize ( aSaldo, 0)
aSaldo      := NIL                 

aSize ( aWSDados,0)
aWSDados  := NIL

Return 
**********************************************************************************************************************************
Static Function Ver_Saldo(cProdNota,cLoteNota, dValNota,nQuant,cEmissao,cLocOrig)
Local cQuery    := ''
Local bGeraMov  := .F.
Local nQMov     := 0 
Local aRet      := {.T.,'',''}         

SB1->(DbSeek(xFilial('SB1')+cProdNota))
IF !Empty(cLoteNota) .And. SB1->B1_RASTRO $ "LS"
		cQuery  := " SELECT SUM(B8_SALDO) SALDO "
		cQuery  += " FROM "+RetSqlName("SB8")
		cQuery  += " WHERE D_E_L_E_T_ = ' ' "
		cQuery  += "  AND B8_FILIAL   = '"+xFilial('SB8')+"'"         
		cQuery  += "  AND B8_LOCAL    = '"+cLocOrig+"'"         
		cQuery  += "  AND B8_PRODUTO  = '"+cProdNota+"'"         
		cQuery  += "  AND B8_LOTECTL  = '"+cLoteNota+"'"         
		cQuery  += "  AND B8_DTVALID  = '"+dValNota+"'"         
Else 
		cQuery  := " SELECT SUM(B2_QATU-B2_RESERVA) SALDO "
		cQuery  += " FROM "+RetSqlName("SB2")
		cQuery  += " WHERE D_E_L_E_T_ = ' ' "
		cQuery  += "  AND B2_FILIAL   = '"+xFilial('SB2')+"'"         
		cQuery  += "  AND B2_LOCAL    = '"+cLocOrig+"'"         
		cQuery  += "  AND B2_COD      = '"+cProdNota+"'"         
EndIF
If Select("QRY_SALDO") > 0
	QRY_SALDO->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SALDO",.T.,.F.)
dbSelectArea("QRY_SALDO")
QRY_SALDO->(dbGoTop())
IF QRY_SALDO->(!EOF()) 
     IF QRY_SALDO->SALDO < nQuant
     	 bGeraMov := .T.
		 nQMov    := nQuant - QRY_SALDO->SALDO 
     EndIF
Else
	bGeraMov := .T.
	nQMov    := nQuant 
EndIF

IF bGeraMov 
   aRet := Gera_Mov('E',cProdNota,SB1->B1_UM,cLocOrig,cEmissao,cLoteNota, dValNota,nQMov)     
EndIF

Return aRet                                                
*******************************************************************************************************************************************
Static Function Gera_Mov(cTipo,cProduto,cUM,cLocal,cEmissao,cLote, cValidade,nQuant)     
Local bRet   := .T.
Local aSD3   := {}
Local cTPMov := IIF(cTipo =='E',GetMV('MGF_TAE03',.F.,"100") ,GetMV('MGF_TAE04',.F.,"501") )
Local aErro  := {}
Local cErro  := ""
Local nI     := 0                                                  
Local cDoc   := U_TAE_DOC_D3()

Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.      
       
dbSelectArea('SB2')
SB2->(dbsetOrder(1))

SB1->(DbSeek(xFilial('SB1')+cProduto))

IF SB2->(!dbSeek(xFilial('SB2')+cProduto+Alltrim(cLocal)))
     CriaSB2(cProduto,Alltrim(cLocal),xFilial('SB2'))
EndIF


AAdd(aSD3,{"D3_TM"     ,cTPMov,})
AAdd(aSD3,{"D3_COD"    ,cProduto,})
AAdd(aSD3,{"D3_UM"     ,cUM,}) 
AAdd(aSD3,{"D3_LOCAL"  ,cLocal,})
AAdd(aSD3,{"D3_QUANT"  ,nQuant,})
AAdd(aSD3,{"D3_EMISSAO",STOD(cEmissao),})
If !Empty(cLote) .And. SB1->B1_RASTRO $ "LS"
	 AAdd(aSD3,{"D3_DTVALID",STOD(cValidade),})
	 AAdd(aSD3,{"D3_LOTECTL",cLote,})
EndIf
AAdd(aSD3,{"D3_DOC"    ,cDoc,})
MSExecAuto({|x,y| mata240(x,y)},aSD3,3)
IF lMsErroAuto
	//DISARMTRANSACTION()
	aErro := GetAutoGRLog()
	cErro := ""
	For nI := 1 to Len(aErro)
		cErro += aErro[nI] + CRLF
	Next nI
	bRet   := .F.
Endif

Return {bRet,cErro, cDoc}                                                
******************************************************************************************************************************************************
User Function TAE10_TAB

Local nRecZZI   := 0 
Local bRecZZI   := .F. 
Local aRec      := {}      
Local cSEQAR    := '9000'     
       /*
wsACAO     //1
wsGERAROP  //2
wsFILIAL   //3
wsNUM_AR   //4
wsPRODUTO  //5
wsSEQ      //6
wsQUANT    //7
wsDATAMOV  //8
wsHORAMOV  //9
wsLOTE     //10
wsVALIDADE //11
wsDATAPROD //12
wsIDMOV    //13
         */

IF !Empty(ALLTRIM(aWSDados[6]))
	ZZI->(DbSeek(aWSDados[3]+PADR(ALLTRIM(aWSDados[4]),TamSX3("ZZI_AR")[1])+PADR(ALLTRIM(aWSDados[6]),TamSX3("ZZI_ITEM")[1])))                
	Reclock("ZZI",.F.)
	IF aWSDados[1] == '1' .OR.  aWSDados[1] == 'B'
		ZZI->ZZI_QCONT := ZZI->ZZI_QCONT + aWSDados[7]
	Else
		ZZI->ZZI_QCONT := ZZI->ZZI_QCONT - aWSDados[7]
	EndIF
	ZZI->(MsUnlock())
Else
	ZZI->(dbSetOrder(1))
	ZZI->(DbSeek(aWSDados[3]+PADR(ALLTRIM(aWSDados[4]),TamSX3("ZZI_AR")[1])))
	While ZZI->(!Eof()) .And. ZZI->ZZI_FILIAL == xFilial("ZZI") ;
		.And. ZZI->ZZI_AR   == PADR(ALLTRIM(aWSDados[4]),TamSX3("ZZI_AR")[1]) 
		IF SUBSTR(ZZI->ZZI_ITEM,1,1) == '9'
			AAdd(aRec, {ZZI->(Recno()), Alltrim(ZZI->ZZI_PRODUT)} )  
			IF cSEQAR < ZZI->ZZI_ITEM
			     cSEQAR := ZZI->ZZI_ITEM
			EndIF 
		EndIF
		ZZI->(dbSkip())
	EndDo
	nPos := AScan(aRec,{|x|  Alltrim(x[2]) == Alltrim(aWSDados[5]) }) 
	IF nPos <> 0 
		ZZI->(DbGoTo(aRec[nPos,01]))
		Reclock("ZZI",.F.)
		IF aWSDados[1] == '1' .OR.  aWSDados[1] == 'B'
			ZZI->ZZI_QCONT := ZZI->ZZI_QCONT + aWSDados[7]
		Else
			ZZI->ZZI_QCONT := ZZI->ZZI_QCONT - aWSDados[7]
		EndIF
		ZZI->(MsUnlock())
	Else
		Reclock("ZZI",.T.)
		ZZI->ZZI_FILIAL := aWSDados[3]
		ZZI->ZZI_AR     := aWSDados[4]
		ZZI->ZZI_ITEM   := SOMA1(cSEQAR)
		ZZI->ZZI_DESC   := GetAdvFVal( "SB1", "B1_DESC", xFilial('SB1')+aWSDados[5], 1, "" )
		ZZI->ZZI_PRODUT := aWSDados[5]
		ZZI->ZZI_QNF    := 0
		ZZI->ZZI_QCONT  := aWSDados[7]
		ZZI->ZZI_QDEV   := 0
		ZZI->ZZI_QCOMPL := 0
		ZZI->ZZI_AJUSTE := 0
		ZZI->ZZI_LOCAL  := ''
		ZZI->(MsUnlock())
	EndIF
EndIF

/*      
IF aWSDados[2] == '2'
	Reclock("ZZI",.F.)
	IF aWSDados[1] == '1'
		ZZI->ZZI_QCONT := ZZI->ZZI_QCONT + aWSDados[7]
	Else
		ZZI->ZZI_QCONT := ZZI->ZZI_QCONT - aWSDados[7]
	EndIF
	ZZI->(MsUnlock())
ElseIF aWSDados[2] == '1'
	ZZI->(dbSetOrder(1))
	ZZI->(DbSeek(aWSDados[3]+PADR(ALLTRIM(aWSDados[4]),TamSX3("ZZI_AR")[1])+PADR(ALLTRIM(aWSDados[6]),TamSX3("ZZI_ITEM")[1])))
	While ZZI->(!Eof()) .And. ZZI->ZZI_FILIAL == xFilial("ZZI") ;
		.And. ZZI->ZZI_AR   == PADR(ALLTRIM(aWSDados[4]),TamSX3("ZZI_AR")[1]) ;
		.And. ZZI->ZZI_ITEM == PADR(ALLTRIM(aWSDados[6]),TamSX3("ZZI_ITEM")[1]);
		.And. !bRecZZI
		IF ZZI->ZZI_PRODUT == aWSDados[5]
			nRecZZI   := ZZI->(Recno())
			bRecZZI   := .T.
		EndIF
		ZZI->(dbSkip())
	EndDo
	IF bRecZZI
		ZZI->(DbGoTo(nRecZZI))
		Reclock("ZZI",.F.)
		IF aWSDados[1] == '1'
			ZZI->ZZI_QCONT := ZZI->ZZI_QCONT + aWSDados[7]
		Else
			ZZI->ZZI_QCONT := ZZI->ZZI_QCONT - aWSDados[7]
		EndIF
		ZZI->(MsUnlock())
	Else
		Reclock("ZZI",.T.)
		ZZI->ZZI_FILIAL := xFilial('ZZI')
		ZZI->ZZI_AR     := aWSDados[4]
		ZZI->ZZI_ITEM   := PADR(ALLTRIM(aWSDados[6]),TamSX3("ZZI_ITEM")[1])
		ZZI->ZZI_DESC   := GetAdvFVal( "SB1", "B1_DESC", xFilial('SB1')+aWSDados[5], 1, "" )
		ZZI->ZZI_PRODUT := aWSDados[5]
		ZZI->ZZI_QNF    := 0
		ZZI->ZZI_QCONT  := aWSDados[7]
		ZZI->ZZI_QDEV   := 0
		ZZI->ZZI_QCOMPL := 0
		ZZI->ZZI_AJUSTE := 0
		ZZI->ZZI_LOCAL  := ''
		ZZI->(MsUnlock())
	EndIF
EndIF
*/
Reclock("ZZH",.F.)
ZZH->ZZH_STATUS := '1'
ZZH->(MsUnlock())

Return  
******************************************************************************************************************************
Static Function Atu_ZD1(aAR)             

Local aRecno :=  StrTokArr(aAR,',')
Local nRet   := 0
Local aBlq   := {}
                                                     
dbSelectArea('ZD1')
For nRet := 1 To Len(aRecno)
	//aBlq   := ZD1->(DBRLockList())
	//IF aScan( aBlq, { |x| x == Val(aRecno[nRet]) }) == 0 
    ZD1->(dbGoTo(Val(aRecno[nRet])))
	IF RecLock('ZD1',.F.,,.F.,.T.) //ZD1->(DBRLock(Val(aRecno[nRet]))) // RecLock('ZD1',.F.)  //varinfo( "ret", DBRLockList() ) RecLock('ZD1',.F.)
		IF aWSDados[01] =='4' //Transbordo
			ZD1->ZD1_STATUS := IIF(aRetorno[1] == '1', 2, 0)
		Else
			ZD1->ZD1_STATUS := IIF(aRetorno[1] == '1', 2, 3)
		EndIF
		ZD1->ZD1_DTPROC := Date()
		ZD1->ZD1_HRPROC := Time()
		ZD1->ZD1_ERRO   := IIF(aRetorno[1] == '1', '', aRetorno[2])
		ZD1->(MsUnlock())
	Else 
    	DisarmTransaction()
    	Break
	EndIF
Next nRet
      
/*			 IF aRetorno[1] == '1'
				cUpd := "UPDATE "+RetSqlName("ZD1")+" " + CRLF
				cUpd += "SET ZD1_STATUS = 2, " + CRLF
				cUpd += "	 ZD1_DTPROC = '"+dTos(Date())+"', " + CRLF
				cUpd += "	 ZD1_HRPROC = '"+Time()+"' " + CRLF
				cUpd += "WHERE R_E_C_N_O_  in ("+aAR[nI,14]+")"
				IF (TcSQLExec(cUpd) < 0)
				    ConOut("## MGFTAE24"+TcSQLError())
				EndIF
			 Else
			 	aRecno :=  StrTokArr(aAR[nI,14],',')
			 	For nRet := 1 To Len(aRecno)
			 		ZD1->(dbGoTo(Val(aRecno[nRet])))
			 	    RecLock('ZD1',.F.)
			 	    ZD1->ZD1_STATUS := 3 
					ZD1->ZD1_DTPROC := Date()
					ZD1->ZD1_HRPROC := Time()
					ZD1->ZD1_ERRO   := aRetorno[2]
					ZD1->(MsUnlock())
			    Next nRet				 
			 EndIF
*/
Return