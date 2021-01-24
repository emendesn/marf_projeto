#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              MGFTAE06
Autor....:              Marcelo Carneiro         
Data.....:              20/10/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada MT120FIM para na copia o campo fique como C7_ZTIPO=1
=============================================================================================
*/


User Function MGFTAE06(nTipo,xCNF,xMotDev)

Local cQuery := ''                                              

Private aTipoFrete  := {'CIF','FOB','TERCEIROS'}
Private cTransp     := Space(tamSx3("F1_TRANSP")[1]) 
Private cPlaca      := Space(tamSx3("F1_PLACA")[1])
Private nFrete      := 1

Private cLocalInd := GetMV('MGF_AE6LOC',.F.,'04')
Private cCNF      := Space(10)
//Private cMotDev   := Space(TamSX3("ZZH_DEVCOD")[1]) //Campo transferido para o item RITM0012774                                
Private cObs      := Space(254)
Private oDlg      
Private oSay1      
Private oGet1      
Private oMGet1     
Private oBtn1                 
Private nViaCad   := nTipo // 1= via Documento de Entrada 2= via modulo de AR 
               
dbSelectArea('ZZH')

IF nTipo == 2
    cCNF 	:= xCNF
    //cMotDev	:= IIF(!Empty(xMotDev),xMotDev,cMotDev) //Campo transferido para o item RITM0012774
EndIF
If !IsInCallStack("GFEA065")
	cQuery  := " SELECT * "
	cQuery  += " FROM "+RetSqlName("SD1")
	cQuery  += " WHERE D_E_L_E_T_  = ' ' "
	cQuery  += "  AND D1_COD     <= '500000'"
	cQuery  += "  AND D1_FILIAL  = '"+SF1->F1_FILIAL+"'"
	cQuery  += "  AND D1_DOC     = '"+SF1->F1_DOC+"'"
	cQuery  += "  AND D1_SERIE   = '"+SF1->F1_SERIE+"'"
	cQuery  += "  AND D1_FORNECE = '"+SF1->F1_FORNECE+"'"
	cQuery  += "  AND D1_LOJA    = '"+SF1->F1_LOJA+"'"
	
	If Select("QRY_SD1") > 0
		QRY_SD1->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SD1",.T.,.F.)
	dbSelectArea("QRY_SD1")
	QRY_SD1->(dbGoTop())
	IF !QRY_SD1->(EOF()) 
	    IF .T. // AR_Reaberto()// Verifica se o AR foi Reaberto.
			IF nViaCad == 1    // Via Documento de Entrada
			   ZZH->(dbSetOrder(3))
			   IF ZZH->(!dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
					IF MsgNoYes("Recebimento Industrial ?","Integração Taura")
						oDlg      := MSDialog():New( 092,232,311,645,"AR",,,.F.,,,,,,.T.,,,.T. )
						oSay1      := TSay():New( 012,012,{||"CNF :"},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
						oSay1      := TSay():New( 032,012,{||"Observação :"},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
						oGet1      := TGet():New( 012,048,{ | u | If( PCount() == 0, cCNF, cCNF := u ) },oDlg,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
						oMGet1     := TMultiGet():New( 032,048,{ | u | If( PCount() == 0, cObs, cObs := u ) },oDlg,148,044,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
						oBtn1      := TButton():New( 081,112,"Confirmar",oDlg,{|| Valida_CNF()} ,040,012,,,,.T.,,"",,,,.F. )
						oBtn1      := TButton():New( 081,157,"Sair"     ,oDlg,{|| IIF(MsgNoYes("Se sair não será gerado o AR e não integrará com o Taura!!","Integração Taura") , oDlg:End(), ) } ,040,012,,,,.T.,,"",,,,.F. )
						oDlg:Activate(,,,.T.)
					EndIF
			   EndIF
			ElseIF nViaCad == 2 //Via tela de AR                                           
			   		Confirma_AR()
			EndIF          
		EndIF
	Else
	   IF nViaCad == 2
	        MsgAlert('Documento de Entrada não gera industrial !')
	   EndIF
	EndIF
EndIF 
	
Return                                                                                
******************************************************************************************************************************************************888
Static Function Valida_CNF                 
Local aRet			:= {}
Local aParambox		:= {}

IF Empty(cCNF)
	MsgAlert('CNF em branco, é necessario ter o CNF para integração com o Taura !')
Else
	cTransp     := SF1->F1_TRANSP
	cPlaca      := SF1->F1_PLACA
	IF SF1->F1_TPFRETE == 'C' .OR. Empty(SF1->F1_TPFRETE)
		nFrete := 1
	ElSEIF SF1->F1_TPFRETE == 'F'
		nFrete := 2
	ELSE
		nFrete := 3
	EndIF
	AAdd(aParamBox, {2, "Tipo de Frete :"	, nFrete , aTipoFrete, 070	, ,  .T.	})
	AAdd(aParamBox, {1, "Transportadora :"	, cTransp, "@!","ExistCPO('SA4',MV_PAR02,1)","SA4",, 070	, .T.	})
	AAdd(aParamBox, {1, "Placa Veiculo :"	, cPlaca , "@!","U_TAE06Placa()"			,""	  ,, 070	, .T.	})
	AAdd(aParamBox, {1, "CNF:"              , cCNF   , "@!",                           ,      ,, 070	, .T.	})
	IF ParamBox(aParambox, "Informações de Transporte"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
		Reclock("SF1",.F.)
		IF VALTYPE(MV_PAR01) == 'C'
			SF1->F1_TPFRETE   := SUBSTR(MV_PAR01,1,1)
		Else
			SF1->F1_TPFRETE   := SUBSTR(aTipoFrete[MV_PAR01],1,1)
		EndIF
		SF1->F1_TRANSP    := MV_PAR02
		SF1->F1_PLACA     := MV_PAR03
		SF1->(MsUnlock())
		Confirma_AR()
	EndIF
EndIF

Return
******************************************************************************************************************************************************888
Static Function Confirma_AR
	Local aCab      := {}
	Local aItem	    := {}
	Local nOpcAuto  := 3 
	Local bContinua := .T. 
	Local nI        := 0                 
	Local cDoc      := ''
	Local cAR       := ''
	Local cProdutos := "('x'"
	Local aProd     := {}
	Local nPos      := 0 

	Local _lVldGerAR 	:= .F.
	Local _lGeraAR		:= .T.
	Local _cMensAR		:= ""
	Local _cMenRevAR	:= ""
	Local _aErro		:= {}
	Local _cErro		:= ""

	Private lMsHelpAuto     := .T.
	Private lMsErroAuto     := .F.
	Private lAutoErrNoFile  := .T.      

	//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------\\
	If !ExisteSx6("MGF_TAE06A")
		CriarSX6("MGF_TAE06A", "L", "Valida revenda para geração do AR(.T./.F.)?" , '.T.' )	
	EndIf

	_lVldGerAR := SuperGetMV("MGF_TAE06A",.F., '.F.' )	//Se valida a revenda para geração de AR

	CHKFILE('ZZH')
	CHKFILE('ZZ1')

	BEGIN TRANSACTION

		//-----| Criar AR |------\\
		cAR   := PegaAR()
		cDoc  := U_TAE_DOC_D3()

		Reclock("ZZH",.T.)
			ZZH->ZZH_FILIAL := xFilial('ZZH')
			ZZH->ZZH_AR 	:= cAR
			ZZH->ZZH_FORNEC := SF1->F1_FORNECE
			ZZH->ZZH_LOJA 	:= SF1->F1_LOJA
			ZZH->ZZH_DOC 	:= SF1->F1_DOC 
			IF SF1->F1_TIPO=='D'
				ZZH->ZZH_NOME 	:= GetAdvFVal( "SA1", "A1_NREDUZ", xFilial('SA1')+ALLTRIM(SF1->F1_FORNECE)+SF1->F1_LOJA, 1, "" )     
			Else
				ZZH->ZZH_NOME 	:= GetAdvFVal( "SA2", "A2_NREDUZ", xFilial('SA2')+ALLTRIM(SF1->F1_FORNECE)+SF1->F1_LOJA, 1, "" )     
			EndIF
			ZZH->ZZH_SERIE 	:= SF1->F1_SERIE
			ZZH->ZZH_OBS 	:= cObs
			ZZH->ZZH_STATUS := '0'
			ZZH->ZZH_CNF 	:= cCNF
			ZZH->ZZH_DOCMOV := cDoc
		ZZH->(MsUnlock())

		//-----| transferencia para o Local |-----\\
		dbSelectArea("SB2")
		SB2->( dbsetOrder(1) )
		
		aCab := {}
		AAdd(aCab,{cDoc,dDataBase})  
			
		QRY_SD1->(dbGoTop())
		While !QRY_SD1->( EOF() )
			_lGeraAR := .T.

			If _lVldGerAR	//Se valida a revenda para geração de AR.
				ZAV->( dbsetOrder(1) )
				If ZAV->( dbSeek(xFilial("ZAV")+QRY_SD1->D1_ZRAMI) )
					If ZAV->ZAV_REVEND = "S"	//Verifica na RAMI se é revenda, se for, não gera AR.
						_lGeraAR := .F.
					EndIF
				EndIf
			EndIf

			SB1->( DbSetOrder(1) )
			SB1->(dbSeek(xFilial("SB1")+QRY_SD1->D1_COD))

			If _lGeraAR
				aItem 	:= {}
				nPos	:= AScan(aCab,{|x|  Alltrim(x[1]) == Alltrim(QRY_SD1->D1_COD) })
				IF nPos <> 0                  
					aCab[nPos,16] +=  QRY_SD1->D1_QUANT
				Else
					Aadd(aItem,QRY_SD1->D1_COD)     //D3_COD
					AAdd(aItem,SB1->B1_DESC)     	//D3_DESCRI
					AAdd(aItem,QRY_SD1->D1_UM)      //D3_UM
					AAdd(aItem,QRY_SD1->D1_LOCAL)   //D3_LOCAL
					AAdd(aItem,"")					//D3_LOCALIZ
					AAdd(aItem,QRY_SD1->D1_COD)  	//D3_COD
					AAdd(aItem,SB1->B1_DESC)     	//D3_DESCRI
					AAdd(aItem,QRY_SD1->D1_UM)  	//D3_UM
					AAdd(aItem,cLocalInd)      		//D3_LOCAL
					AAdd(aItem,"")					//D3_LOCALIZ
					AAdd(aItem,"")          		//D3_NUMSERI
					If !Empty(QRY_SD1->D1_LOTECTL) .And. SB1->B1_RASTRO $ "LS"
						AAdd(aItem,QRY_SD1->D1_LOTECTL)			//D3_LOTECTL
						AAdd(aItem,"")         					//D3_NUMLOTE
						AAdd(aItem,STOD(QRY_SD1->D1_DTVALID))	//D3_DTVALID
					Else
						AAdd(aItem,CriaVar("D3_LOTECTL",.F.))   	//D3_LOTECTL
						AAdd(aItem,"      ")         				//D3_NUMLOTE
						AAdd(aItem,CriaVar("D1_DTVALID",.F.))   	//D3_DTVALID
					EndIF
					
					AAdd(aItem,0)					//D3_POTENCI
					AAdd(aItem,QRY_SD1->D1_QUANT) 	//D3_QUANT
					AAdd(aItem,0)					//D3_QTSEGUM
					AAdd(aItem,"")   				//D3_ESTORNO
					AAdd(aItem,"")         			//D3_NUMSEQ
					
					If !Empty(QRY_SD1->D1_LOTECTL) .And. SB1->B1_RASTRO $ "LS"
						AAdd(aItem,QRY_SD1->D1_LOTECTL)				//D3_LOTECTL
						AAdd(aItem,STOD(QRY_SD1->D1_DTVALID))		//D3_DTVALID
					Else
						AAdd(aItem,CriaVar("D3_LOTECTL",.F.))   	//D3_LOTECTL
						AAdd(aItem,CriaVar("D1_DTVALID",.F.))   	//D3_DTVALID
					EndIF
					
					AAdd(aItem,"")					//D3_ITEMGRD
					AAdd(aItem,"")   				//CAT 83 Cod. Lanc
					AAdd(aItem,"")         			//CAT 83 Cod. Lanc
					AAdd(aItem,"")         			//D3_OBSERVAC
					AAdd(aCab,aItem)
					cProdutos += ",'"+QRY_SD1->D1_COD+"'"
					
					IF SB2->(!dbSeek(xFilial('SB2')+QRY_SD1->D1_COD+Alltrim(cLocalInd)))
						CriaSB2(QRY_SD1->D1_COD,Alltrim(cLocalInd),xFilial('SB2'))
					EndIF
				EndIF
				nPos := AScan(aProd,{|x|  Alltrim(x[1]) == Alltrim(QRY_SD1->D1_COD) })
				IF nPos == 0                  
					Reclock("ZZI",.T.)
						ZZI->ZZI_FILIAL := xFilial('ZZI')
						ZZI->ZZI_AR     := cAR
						ZZI->ZZI_ITEM   := QRY_SD1->D1_ITEM
						ZZI->ZZI_DESC   := GetAdvFVal( "SB1", "B1_DESC", xFilial('SB1')+QRY_SD1->D1_COD, 1, "" )     
						ZZI->ZZI_PRODUT := QRY_SD1->D1_COD
						ZZI->ZZI_QNF    := QRY_SD1->D1_QUANT
						ZZI->ZZI_QCONT  := 0 
						ZZI->ZZI_QDEV   := 0
						ZZI->ZZI_QCOMPL := 0
						ZZI->ZZI_AJUSTE := 0 
						ZZI->ZZI_LOCAL  := QRY_SD1->D1_LOCAL
						ZZI->ZZI_CODMOT	:= QRY_SD1->D1_ZCODMOT
						ZZI->ZZI_CODJUS	:= QRY_SD1->D1_ZCODJUS
					ZZI->(MsUnlock())  

					AAdd(aProd,{QRY_SD1->D1_COD,ZZI->(Recno())})

					If Empty(_cMensAR)
						_cMensAR := "AR GERADO PARA OS ITENS ABAIXO:"+CRLF
					EndIF
					_cMensAR += "| "+Alltrim(QRY_SD1->D1_COD)+" - "+AllTrim(SB1->B1_DESC)+"| "+QRY_SD1->D1_SERIE+"-"+QRY_SD1->D1_DOC+"|"+CRLF
				Else
					ZZI->(dbGoto(aProd[nPos,02]))
					Reclock("ZZI",.F.)
					ZZI->ZZI_QNF    := ZZI->ZZI_QNF +QRY_SD1->D1_QUANT
					ZZI->(MsUnlock())  
				EndIF
			Else
				If Empty(_cMenRevAR)
					_cMenRevAR := "AR NÃO GERADO PARA RAMI DE REVENDA, ITENS ABAIXO:"+CRLF
				EndIF
				_cMenRevAR += "| "+Alltrim(QRY_SD1->D1_COD)+" - "+AllTrim(SB1->B1_DESC)+"| "+QRY_SD1->D1_SERIE+"-"+QRY_SD1->D1_DOC+"|"+CRLF
			EndIf
			
			QRY_SD1->(dbSkip())
		EndDo
			
		If Len(aProd) > 0	//Se populou array aprod, houve geração de itens de AR.
			IF nViaCad == 1 .OR. !Empty(SF1->F1_STATUS)
				cProdutos += ")"
				
				MSExecAuto({|x,y| mata261(x,y)},aCab,nOpcAuto)
				IF lMsErroAuto
					DISARMTRANSACTION()
					_aErro := GetAutoGRLog()
					_cErro := ""
					For nI := 1 to Len(_aErro)
						_cErro += _aErro[nI] + CRLF
					Next nI
					fShowLog(_cErro,"NÃO HÁ SALDO EM ESTOQUE PARA A GERAÇÃO DO AR")
					
					bContinua   := .F.
					_cMensAR	:= ""
					_cMenRevAR	:= ""
				Endif
				
				IF bContinua	//Bloqueia as Duplicatas...
					cQuery := " UPDATE "+RetSqlName("SE2")
					cQuery += " SET E2_MSBLQL    = '1'"
					cQuery += " WHERE E2_FILIAL  = '"+xFilial('SE2')+"'"
					cQuery += "   AND E2_PREFIXO = '"+SF1->F1_PREFIXO+"'"
					cQuery += "   AND E2_NUM     = '"+SF1->F1_DOC+"'"
					cQuery += "   AND E2_TIPO    = 'NF'"
					cQuery += "   AND E2_FORNECE = '"+SF1->F1_FORNECE+"'"
					cQuery += "   AND E2_LOJA    = '"+SF1->F1_LOJA+"'"
					IF (TcSQLExec(cQuery) < 0)
						bContinua   := .F.
						MsgStop(TcSQLError())
					EndIF
				EndIF
			EndIF
		Else
			DISARMTRANSACTION()	//Se não populou o array aprod, não gerou nenhum item, portanto, temos que desarmar a transação para não gerar o cabeçalho do AR.
		EndIf

	END TRANSACTION

	IF nViaCad == 1
		oDlg:End()            
	EndIF	

	If !Empty(_cMensAR) .AND. !Empty(_cMenRevAR)
		fShowLog(_cMensAR+CRLF+CRLF+CRLF+_cMenRevAR,"GERAÇÃO DE AR")
	ElseIf !Empty(_cMensAR) 
		fShowLog(_cMensAR,"GERAÇÃO DE AR")
	ElseIf !Empty(_cMenRevAR) 	
		fShowLog(_cMenRevAR,"GERAÇÃO DE AR")
	EndIf

Return



**********************************************************************************************************************************
User Function TAE06_BLQ(cFILBLQ, cProdutos,cSituacao)
Local cQuery := ''

cQuery := " Update "+RetSqlName("SB2")
cQuery += " Set B2_STATUS   = '"+cSituacao+"'"
cQuery += " Where B2_FILIAL = '"+cFILBLQ+"'"
cQuery += "   AND B2_COD    in "+cProdutos
cQuery += "   AND B2_LOCAL  = '"+cLocalInd+"'"
IF (TcSQLExec(cQuery) < 0)
     Return(msgStop(TcSQLError()))
EndIF                             

Return
**********************************************************************************************************************************
Static Function PegaAR

local aArea		 := GetArea()
local aAreaZZH   := ZZH->(GetArea())
Local cQuery := ''
Local cAR    := ''

While .t.

	cAR := GetSxeNum("ZZH","ZZH_AR")
	
	IF !Empty(SF1->F1_STATUS)
	    cAR := "0"+substr(cAR,2,7)
	Else
	    cAR := "D"+substr(cAR,2,7)
	EndIF
	
	//Verifica se o número ja existe na base, se ja existir, pega o próximo
	ZZH->(DbSetOrder(1)) //ZZH_FILIAL + ZZH_AR 
	ZZH->(DbSeek(XFILIAL("ZZH")+cAR)) 
	if ZZH->(Found())
		ConfirmSX8()
	else
		exit
	endif

end

ConfirmSX8()

RestArea(aAreaZZH)
RestArea(aArea)

Return cAR



**********************************************************************************************************************************
User Function TAE_DOC_D3()
Local cQuery := ''
Local cDoc   := 'AR0000001'

cQuery  := " SELECT Max(D3_DOC) As MAXDOC "
cQuery  += " FROM "+RetSqlName("SD3")
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += "  AND D3_FILIAL  = '"+xFilial('SD3')+"'"         
cQuery  += "  AND D3_DOC Like 'AR%' "         

If Select("QRY_DOC") > 0
	QRY_DOC->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_DOC",.T.,.F.)
dbSelectArea("QRY_DOC")
QRY_DOC->(dbGoTop())
IF !QRY_DOC->(EOF()) .And. !Empty(QRY_DOC->MAXDOC)
    cDoc    := SOMA1(QRY_DOC->MAXDOC)
EndIF

Return cDoc


User Function TAE06Placa()

Local lRet := .T.

If ExistCPO('DA3',MV_PAR03,3)
	lRet := .T.
Else
	lRet := .F.
Endif                                                 	

Return(lRet)	

***********************************************************************************************************************************
Static Function AR_Reaberto
Local bRet  := .T.                        
Local nOpAR := 0          
Local aRec  := {}     

Private aNFAR    := {}
Private oBrowAR     	                                          
Private nEscolha := 0


//ZZH_FILIAL+ZZH_FORNEC+ZZH_DOCX                                                                                                                                  
ZZH->(dbSetOrder(4))
IF ZZH->(dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_DOC))
    While ZZH->(!Eof()) .And. ;
    	  ZZH->ZZH_FILIAL  == SF1->F1_FILIAL .And. ;
    	  ZZH->ZZH_FORNEC  == PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1]) .And. ;
    	  ZZH->ZZH_DOCX    == SF1->F1_DOC
    
    	aRec   := {}
		AAdd(aRec,ZZH->ZZH_AR)
	    AAdd(aRec,ZZH->ZZH_FORNEC)
	    AAdd(aRec,ZZH->ZZH_LOJA)
	    AAdd(aRec,ZZH->ZZH_DOCX )
	    AAdd(aRec,ZZH->ZZH_SERIEX )
	    AAdd(aRec,ZZH->(Recno()) )
	    AADD(aNFAR,aRec)
        ZZH->(dbSkip())
    End 
    MsgAlert('Já existe AR para este fornecedor/Nota fiscal que se encontra em status Reaberto !!')
	DEFINE MSDIALOG oDlg3 TITLE "Escolha o AR " FROM 000, 000  TO 340, 400 COLORS 0, 16777215 PIXEL
		@ 007, 005 LISTBOX oBrowAR	 Fields HEADER "AR","Fornecedor","Loja","NF","Serie" SIZE 193,147 OF oDlg3 COLORS 0, 16777215 PIXEL
		oBrowAR:SetArray(aNFAR)
		oBrowAR:nAt := 1
		oBrowAR:bLine := { || {aNFAR[oBrowAR:nAt,1],aNFAR[oBrowAR:nAt,2],aNFAR[oBrowAR:nAt,3],aNFAR[oBrowAR:nAt,4],aNFAR[oBrowAR:nAt,5]}}
		
		oBtn := TButton():New( 157, 005 ,'Confirmar' , oDlg3,{|| nOpAR := 1,nEscolha := oBrowAR:nAt, oDlg3:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 157, 142 ,'Sair'      , oDlg3,{|| oDlg3:End()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	ACTIVATE MSDIALOG oDlg3 CENTERED
    IF nOpAR == 1
        ZZH->(dbSetOrder(1))
        ZZH->(dbGoTo(aNFAR[nEscolha,06]))
        
    	Reclock("ZZH",.F.)
		ZZH->ZZH_FORNEC := SF1->F1_FORNECE
		ZZH->ZZH_LOJA 	:= SF1->F1_LOJA
		ZZH->ZZH_DOC 	:= SF1->F1_DOC 
		IF SF1->F1_TIPO=='D'
		    ZZH->ZZH_NOME 	:= GetAdvFVal( "SA1", "A1_NREDUZ", xFilial('SA1')+ALLTRIM(SF1->F1_FORNECE)+SF1->F1_LOJA, 1, "" )     
		Else
		    ZZH->ZZH_NOME 	:= GetAdvFVal( "SA2", "A2_NREDUZ", xFilial('SA2')+ALLTRIM(SF1->F1_FORNECE)+SF1->F1_LOJA, 1, "" )     
		EndIF
		ZZH->ZZH_SERIE 	:= SF1->F1_SERIE
		ZZH->ZZH_DOCX   := ' '
		ZZH->ZZH_SERIEX := ' '
		ZZH->ZZH_STATUS := ZZH->ZZH_STATX
		ZZH->(MsUnlock())
    	bRet  := .F.                    
    EndIF
EndIF
ZZH->(dbSetOrder(1))		         
Return bRet		



/*/
{Protheus.doc} fShowLog()
	Função para Mostrar tela com Error Log

@author Marcos Cesar Donizeti Vieira
@since 28/12/2020
@type Function

@param
	
@return

/*/
Static Function fShowLog( xMsg, cTitulo, cLabel, aButtons, bValid, lQuebraLinha )

	local oDlg
	local oMemo
	local oFont				:= TFont():New("Courier New",09,15)
	local bOk				:= { || oDlg:end() }
	local bCancel			:= { || oDlg:end() }
	local cMsg				:= ""
	local nQuebra			:= 68
	local i                 := 0
	local j                 := 0

	default xMsg			:= ""
	default cTitulo			:= ""
	default cLabel			:= ""
	default aButtons		:= {}
	default bValid			:= {|| .T. }
	default lQuebraLinha	:= .F.

   If ValType(xMsg) = "C"
      cMsg := xMsg
   ElseIf ValType(xMsg) = "A"
      For i := 1 To Len(xMsg)
         If xMsg[i][2] 	// Posição que define se fará quebra de linha
            For j := 1 To MLCount(xMsg[i][1],nQuebra)
               cMsg += MemoLine(xMsg[i][1], nQuebra, j) + CRLF
            Next
         Else
            cMsg += xMsg[i][1]
         EndIf
      Next I
   EndIf

   Define MsDialog oDlg Title cTitulo From 9,0 To 39,85 of oDlg

      oPanel:= TPanel():New(0, 0, "", oDlg,, .F., .F.,,, 90, 165)
      oPanel:Align:= CONTROL_ALIGN_ALLCLIENT

      @ 05,05 To 190,330 Label cLabel Pixel Of oPanel
      @ 10,10 Get oMemo Var cMsg MEMO HSCROLL FONT oFont Size 315,175 READONLY Of oPanel  Pixel

      oMemo:lWordWrap := lQuebraLinha
      oMemo:EnableVScroll(.t.)
      oMemo:EnableHScroll(.t.)

   Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel,,,,,,aButtons,) Centered

Return