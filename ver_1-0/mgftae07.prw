#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"

//Constantes
#define CRLF chr(13) + chr(10)                               
#Define STR_PULA        Chr(13)+ Chr(10)

/*
============================================================================================
Programa.:              MGFTAE07
Autor....:              Marcelo Carneiro         
Data.....:              04/11/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              MANUTENÇÃO DO AR
===============================================================================================
=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Histórico de Alterações <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<|
===============================================================================================
|   Data    |               Alteração              				 |    Autor     |  Chamado    |
===============================================================================================
|17/12/2018 |Inclusao de botão para selecionar a nf de Perda     |Eduardo Donato| RITM0013768 |
|  /  /     |                                                    |              |             | 
===============================================================================================
*/
User Function MGFTAE07
                                                  
Local oFont1
Local oDlgMnu
Local oSay1
Local oEscolha
Local oBtn1
Local bPassou := .F.

Private nEscolha  

oFont1     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )

DEFINE MSDIALOG oDlgMnu TITLE "" FROM 000, 000  TO 150, 370 COLORS 0, 16777215 PIXEL
	oSay1      := TSay():New( 004,008,{||"Escolha o Tipo de Aviso de Recebimento"},oDlgMnu,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,012)
	oGEscolha  := TGroup():New ( 020,008,050,176,"",oDlgMnu,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oEscolha   := TRadMenu():New( 024,014,{"Carga Seca","Carga Fria"},{|u| If(PCount()>0,nEscolha:=u,nEscolha)},oDlgMnu,,,CLR_BLACK,CLR_WHITE,"",,,198,126,,.F.,.F.,.T. )
	oBtn1      := TButton():New ( 055,121,"Entrar"  ,oDlgMnu,{|| bPassou := .T.,oDlgMnu:End() } ,55, 012,,,,.T.,,"",,,,.F. )
ACTIVATE MSDIALOG oDlgMnu CENTERED

IF bPassou 
    IF nEscolha == 1
       MATA145()
    ElseIF nEscolha == 2
       TAE07_FRIA()
    EndIF                                                                                                             
EndIF
Return


*****************************************************************************************************************
Static Function TAE07_FRIA
_bFinalAr := { || MsAguarde({|| TAE07_FAR() },,) } 

Private cCadastro := "Aviso de  Recebimento"
Private aRotina   := { {"Pesquisar" 		,"AxPesqui"			,0,1		} ,;       
		               {"Visualizar"		,"U_TAE07_MAN"		,0,2,0,NIL	},;
		               {"Incluir"   		,"U_TAE07_INC"		,0,3		} ,;
		               {"Alterar"   		,"U_TAE07_MAN"		,0,4,0,NIL	},;
		               {"Excluir"   		,"U_TAE07_EXC"		,0,5		} ,;
		               {"Imprimir"  		,"U_MGFTAE22"		,0,6		} ,;
		               {"Emite NF Entrada"	,"U_TAE07_ENF"		,0,5		} ,;
					   {"Log Integracao"	,"U_TAE07_LOG"		,0,1		} ,; //ALTERADO RAFAEL 10/10/2018
					   {"Desvincular NF"	,"U_TAE07_NF"		,0,1		} ,;
					   {"Vincular NF"		,"U_TAE07_VF"		,0,1		} ,;
					   {"Finalizar AR"		,"EVAL(_bFinalAr)"	,0,1		} ,;
					   {"Legenda"   		,"U_TAE07_Legenda"	,0,6		}} 		
		               
Private cDelFunc  := ".T."            
Private aCores    := { {'ZZH_STATUS=="0"','ENABLE' 		},; 
					   {'ZZH_STATUS=="1"','BR_AMARELO' 	},;
					   {'ZZH_STATUS=="2"','DISABLE' 	},;
					   {'ZZH_STATUS=="3"','BR_CINZA' 	},;
					   {'ZZH_STATUS=="4"','BR_PINK' 	}} 
ChkFile("ZZI")
ChkFile("ZZH")
dbSelectArea("ZZH")
dbSetOrder(1)

mBrowse( 6,1,22,75,"ZZH",,,,,,aCores)

Return



**************************************************************************************************
User Function TAE07_Legenda()

Local aLegenda:= {}             
                                      
AADD(aLegenda, {"ENABLE"	 ,'AR Criado'})
AADD(aLegenda, {"BR_AMARELO" ,'Em Processo de Contagem'})
AADD(aLegenda, {"DISABLE"	 ,'Diferença de Contagem ou Aguardando NF(Sinistro)'})
AADD(aLegenda, {"BR_CINZA"	 ,'Encerrado'})
AADD(aLegenda, {"BR_PINK"	 ,'AR Reaberto'})

BrwLegenda('Aviso de Recebimento','Taura',aLegenda)

Return 



**************************************************************************************************
User Function TAE07_MAN( cAlias, nReg, nOpc )

Local nI        := 0
Local nOpcA     := 0
Local bEncerra  := .F.

Private aHeader := {}
Private aCols   := {}
Private aREG    := {}
Private aRegNF  := {} 
Private aRegAJ  := {}
Private bCampo  := { | nField | FieldName(nField) }
Private aSize   := {}
Private aOBJ    := {}
Private aInfo   := {}
Private aPObj   := {}
Private aAlter  := {'ZZI_OBS'}
Private oDlg
Private oGet
Private aButtons :={}

IF nOpc == 4 //Alteração                                                           
	IF SUBSTR(ZZH->ZZH_AR,1,1) =='S' 
		MsgAlert('Não é possivel alterar AR de Sinistro!!')
		Return
	EndIF
	IF ZZH->ZZH_STATUS == '3'
		MsgAlert('Não é possivel alterar, AR encerrado !!')
		Return
	EndIF
	IF ZZH->ZZH_STATUS == '4'
		MsgAlert('Não é possivel alterar, AR Reaberto !!')
		Return
	ELSEIF ZZH->ZZH_STATUS == '2' 
	    IF SUBSTR(ZZH->ZZH_AR,1,1) <>'D' // Devolução formulario proprio não altera
			SetKey( VK_F5, { || U_TAE07_AJ(1) } )
	  	    SetKey( VK_F6, { || U_TAE07_AJ(2) } )	
	  	    SetKey( VK_F6, { || U_TAE07_AJ(3) } )	
	  	    AAdd(aButtons , {"Procura Notas" ,{|| U_TAE07_AJ(1)},"Procura Notas","Procura Notas",{|| .T.}})
			AAdd(aButtons , {"Procura Ajuste",{|| U_TAE07_AJ(2)},"Procura Ajuste","Procura Ajuste",{|| .T.}})
	  	    AAdd(aButtons , {"Procura Perda" ,{|| U_TAE07_AJ(3)},"Procura Perda","Procura Perda",{|| .T.}})
	    Else
	        Ver_PreNota()
	    EndIF
	EndIF
EndIF                                                               
IF ZZH->ZZH_STATUS == '1' .OR. ZZH->ZZH_STATUS == '0' .OR. ZZH->ZZH_STATUS == '4'
	aAlter  := {}
EndIF
aSize := MsAdvSize()
AAdd(aOBJ,{100,080,.T.,.F.})
AAdd(aOBJ,{100,115,.T.,.T.})
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 2, 2 }
aPObj := MsObjSize( aInfo, aObj )

//Montando o cabeçalho
dbSelectArea( cAlias )
dbSetOrder(1)
For nI := 1 To FCount()
	M->&( Eval( bCampo, nI ) ) := FieldGet( nI )
Next nI   

//Montando o Header do Itens
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("ZZI"))
While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "ZZI"
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .AND. Alltrim(SX3->X3_CAMPO) <> 'ZZI_AR' .AND. Alltrim(SX3->X3_CAMPO) <> 'ZZI_RECNO' ;
	   .AND. Alltrim(SX3->X3_CAMPO) <> 'ZZI_RECNOA' 
		AADD( aHeader, { Trim( X3Titulo() ),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_ARQUIVO,;
						SX3->X3_CONTEXT})                          
		IF Alltrim(SX3->X3_CAMPO) ='ZZI_QCONT'
		   AADD( aHeader, { 'Diferença',;
						    'xDIF',;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_ARQUIVO,;
						SX3->X3_CONTEXT})                          
		EndIF 
	Endif
	SX3->(dbSkip())
EndDo

// Preenche os Itens do AR
dbSelectArea('ZZI')
dbSetOrder(1)
ZZI->(dbSeek( xFilial('ZZI')+ZZH->ZZH_AR ))
While ZZI->(!EOF()) .And. ZZI->ZZI_FILIAL + ZZI->ZZI_AR  == xFilial('ZZI')+ZZH->ZZH_AR
	AAdd( aREG, ZZI->( RecNo() ) )
	AAdd( aRegNF, IIF(Empty(ZZI->ZZI_RECNO),0,ZZI->ZZI_RECNO) )
	AAdd( aRegAJ, IIF(Empty(ZZI->ZZI_RECNO),0,ZZI->ZZI_RECNOA) )
	AAdd( aCols, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		IF aHeader[nI,02] == 'xDIF'
		    aCols[Len(aCols),nI] := ZZI->ZZI_QNF - ZZI->ZZI_QCONT 
		ElseIf aHeader[nI,10] == "V"
			aCols[Len(aCols),nI] := CriaVar(aHeader[nI,2],.T.)
		Else
			aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
		Endif
	Next nI
	aCols[Len(aCols),Len(aHeader)+1] := .F.
    ZZI->(dbSkip())
End

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd Pixel

	EnChoice( cAlias, nReg, nOpc, , , , , aPObj[1])

	oGet := MsNewGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4],GD_UPDATE ,"AllwaysTrue","AllwaysTrue",,aAlter,0,999 ,"U_TAE07_VAL","","AllwaysTrue",oDlg,aHeader,aCols)
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,;
					  {||  nOpcA := 1, oDlg:End() ,NIL  },;
	                  {|| oDlg:End() },,@aButtons)
If nOpcA == 1 .And. ( nOpc == 4 .Or. nOpc == 5 )
    TAE07_GRV( nOpc, aREG )
Endif
SetKey( VK_F5 , Nil    )
SetKey( VK_F6 , Nil    )   
SetKey( VK_F7 , Nil    )   
Return
*******************************************************************************************************************************
User Function TAE07_VAL()
Local bRet       := .T.

Return bRet
*************************************************************************************************************************
Static Function TAE07_GRV( nOpc, aAltera  )
Local nX := 0
Local nPosAjuste := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_AJUSTE' }) 
Local nPosQDEv   := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_QDEV' }) 
Local nPosQCompl := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_QCOMPL' }) 
Local nPosDoc    := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_DOC' }) 
Local nPosSerie  := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_SERIE' }) 
Local nPosOBS    := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_OBS' }) 
Local nPosTipoNF := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_TIPONF' }) 
Local nPosNF     := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_QNF' }) 
Local nPosCont   := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_QCONT' })
Local nPosCODMOT := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_CODMOT' })  
Local nPosCODJUS := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_CODJUS' }) 

Local nQuantNF      :=  0 
Local nQuantAjuste  := 0 
Local bEncerra   	:= .F.    

If nOpc == 4
	IF 	ZZH->ZZH_STATUS == '2'
		IF SUBSTR(ZZH->ZZH_AR,1,1) == 'D'
			IF Ver_PreNota()
			    bEncerra   := .T.
			Else	
				IF MsgYESNO('AR pode ser encerrado para emissão do Documento de Entrada, encerra-lo?')
					bEncerra   := .T.
				EndIF
			EndIF
		Else
			For nX := 1 To Len( oGet:aCols )
				nQuantNF      :=  oGet:aCols[nX][nPosNF]
				nQuantAjuste  :=  oGet:aCols[nX][nPosCont] + oGet:aCols[nX,nPosAjuste] + oGet:aCols[nX,nPosQDEv] + oGet:aCols[nX,nPosQCompl]
				IF  !(nQuantNF > nQuantAjuste)
					bEncerra   := .T.
				EndIF
			Next nX
			IF bEncerra  
				IF MsgYESNO('AR pode ser encerrado, encerra-lo?')
					bEncerra   := .T.
				EndIF
			EndIF
		EndIF
	EndIF
	dbSelectArea("ZZI")
	ZZI->(dbSetOrder(1))
	For nX := 1 To Len( oGet:aCols )
		If nX <= Len( aREG )
			ZZI->(dbGoto( aREG[nX] ))
			RecLock("ZZI",.F.) 
			ZZI->ZZI_AJUSTE  := oGet:aCols[nX,nPosAjuste]
			ZZI->ZZI_QDEV    := oGet:aCols[nX,nPosQDEv]
			ZZI->ZZI_QCOMPL  := oGet:aCols[nX,nPosQCompl]
			ZZI->ZZI_DOC     := oGet:aCols[nX,nPosDoc]
			ZZI->ZZI_SERIE   := oGet:aCols[nX,nPosSerie]
			ZZI->ZZI_OBS     := oGet:aCols[nX,nPosOBS]
			ZZI->ZZI_RECNO   := aRegNF[oGet:nAt] 
			ZZI->ZZI_RECNOA  := aRegAJ[oGet:nAt]
			ZZI->ZZI_TIPONF  := oGet:aCols[nX,nPosTipoNF]
			ZZI->ZZI_CODMOT  := oGet:aCols[nX,nPosCODMOT]
			ZZI->ZZI_CODJUS  := oGet:aCols[nX,nPosCODJUS]
			ZZI->(MsUnLock())
		Endif
	Next nX
	dbSelectArea("ZZH")
	RecLock("ZZH", .F. )
	ZZH->ZZH_CNF  := M->ZZH_CNF
    ZZH->ZZH_OBS  := M->ZZH_OBS        
    IF bEncerra      
        ZZH->ZZH_STATUS  := '3'
    EndIF
	ZZH->(MsUnLock())
Endif
Return  
 

****************************************************************************************************************************************************************
User Function TAE07_F1

Local cD1Filter := ""
 
cD1Filter += "@#" 
cD1Filter += " SD1->D1_FILIAL   == xFilial('SD1')" 
cD1Filter += " .AND. SD1->D1_FORNECE  == Alltrim(ZZH->ZZH_FORNEC)"
cD1Filter += " .AND. SD1->D1_LOJA     == ZZH->ZZH_LOJA"
cD1Filter += " .AND. SD1->D1_COD      == ZZI->ZZI_PRODUT"
cD1Filter += " .AND. SD1->D1_EMISSAO  >= dEmissao" 
cD1Filter += "@#"  

Return(cD1Filter)
****************************************************************************************************************************************************************

User Function TAE07_F2

Local cD2Filter := ""
 
cD2Filter += "@#" 
cD2Filter += " SD2->D2_FILIAL   == xFilial('SD2')" 
cD2Filter += " .AND. SD2->D2_CLIENTE  == Alltrim(ZZH->ZZH_FORNEC)"
cD2Filter += " .AND. SD2->D2_LOJA     == ZZH->ZZH_LOJA"
cD2Filter += " .AND. SD2->D2_COD      == ZZI->ZZI_PRODUT"
cD2Filter += " .AND. SD2->D2_EMISSAO  >= dEmissao" 
cD2Filter += "@#"  

Return(cD2Filter) 

****************************************************************************************************************************************************************


User Function TAE07_F3
Local cRet := .F.

IF SD3->D3_FILIAL   == xFilial('SD3')    .AND. ;
   SD3->D3_TM       == cTM               .AND. ;
   SD3->D3_COD      == ZZI->ZZI_PRODUT   .AND. ;
   SD3->D3_EMISSAO  >= dEmissao    
    cRet := .T.
EndIF
Return cRet



****************************************************************************************************************************************************************
User Function TAE07_AJ(nTipoSelecao)
Local nPosNF     := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_QNF' }) 
Local nPosCont   := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_QCONT' })  
Local nPosAJuste := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_AJUSTE' })  
Local nPosCod    := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_ITEM' }) 
Local nPosDoc    := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_DOC' }) 
Local nPosSerie  := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_SERIE' }) 
Local nPosQDEv   := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_QDEV' }) 
Local nPosQCompl := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_QCOMPL' }) 
Local nPosTipoNF := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_TIPONF' }) 
Local nPosProdut := aScan( aHeader, { |x| Alltrim(x[2]) == 'ZZI_PRODUT' }) 
Local nDiferenca   := 0      
Local nRecAjuste   := 0
Local bSel         := .F.
   
Private nTipoNota  := 0            
Private dEmissao   := CTOD('  /  /  ')
Private cRecNF     := '' 
Private cRecNFx     := '' 
Private cRecAJ     := ''
Private cTM        := ''        
Private cAJPos     := GetMV('MGF_TAE01',.F.,"100") 
Private cAjNeg     := GetMV('MGF_TAE02',.F.,"500")
      
nDiferenca := oGet:aCols[oGet:nAt][nPosNF] - oGet:aCols[oGet:nAt][nPosCont]
IF nDiferenca == 0 
   MsgAlert('Não há diferença entre a contagem e a nota fiscal !!')
   Return
ElseIF nDiferenca < 0 
   nTipoNota  :=  1                    
ElseIF nDiferenca > 0 
   nTipoNota  :=  2                                                      
EndIF
                    
//Nota Fiscal                              
IF nTipoSelecao == 1
	dbSelectArea('ZZI')
	ZZI->(dbSetOrder(1))
	IF ZZI->(dbSeek( xFilial('ZZI')+ZZH->ZZH_AR+oGet:aCols[oGet:nAt][nPosCod] ))
		dEmissao   := GetAdvFVal( "SF1", "F1_EMISSAO", xFilial('SF1')+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+ALLTRIM(ZZH->ZZH_FORNEC)+ZZH->ZZH_LOJA, 1, "" )
		cRecNF     := Ret_NF(nTipoNota,aRegNF[oGet:nAt], oGet:aCols[oGet:nAt][nPosProdut], dEmissao, ZZH->ZZH_FORNEC , ZZH->ZZH_LOJA )
		
		IF nTipoNota ==  1
			
			WHILE Alltrim(STR(SD1->(Recno())))  $ cRecNF 
			    ALERT("Você selecionou a mesma nota. Favor Verificar!")
			    Return
			ENDDO
		
			ConPad1(,,,'TAE_01')
			bSel := .T.	 

			
		ElseIF nTipoNota ==  2
			//bSel := ConPad1(,,,'TAE_02') 
						  
			WHILE Alltrim(STR(SD2->(Recno())))  $ cRecNF 
			    ALERT("Você selecionou a mesma nota. Favor Verificar!")
			    Return
			ENDDO
		
			ConPad1(,,,'TAE_02')
			bSel := .T.	     
		
		EndIF 
		
		IF bSel  
			oGet:aCols[oGet:nAt][nPosTipoNF] := Alltrim(STR(nTipoNota))
			IF nTipoNota ==  1 .And. SD1->(!EOF())
				oGet:aCols[oGet:nAt][nPosDoc]    := SD1->D1_DOC
				oGet:aCols[oGet:nAt][nPosSerie]  := SD1->D1_SERIE
				IF nDiferenca >= SD1->D1_QUANT
				    oGet:aCols[oGet:nAt][nPosQCompl] := SD1->D1_QUANT
				Else                                                 
				    oGet:aCols[oGet:nAt][nPosQCompl] := nDiferenca
				EndiF
				aRegNF[oGet:nAt] :=  SD1->(RECNO())
				
			ElseIF nTipoNota ==  2 .And. SD2->(!EOF())
				oGet:aCols[oGet:nAt][nPosDoc]    := SD2->D2_DOC
				oGet:aCols[oGet:nAt][nPosSerie]  := SD2->D2_SERIE
				IF nDiferenca >= SD2->D2_QUANT
				    oGet:aCols[oGet:nAt][nPosQDEV]   := SD2->D2_QUANT
				Else                                                 
				    oGet:aCols[oGet:nAt][nPosQDEV]   := nDiferenca
				EndiF
				aRegNF[oGet:nAt] :=  SD2->(RECNO())
			EndIF
			oGet:oBrowse:Refresh()
		EndIF
	ENDIF
ElseIF nTipoSelecao == 2 // Ajustes
	dbSelectArea('ZZI')
	ZZI->(dbSetOrder(1))
	IF ZZI->(dbSeek( xFilial('ZZI')+ZZH->ZZH_AR+oGet:aCols[oGet:nAt][nPosCod] ))
		dEmissao   := GetAdvFVal( "SF1", "F1_EMISSAO", xFilial('SF1')+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+ALLTRIM(ZZH->ZZH_FORNEC)+ZZH->ZZH_LOJA, 1, "" )
		cRecAJ     := Ret_NF(3,aRegAJ[oGet:nAt], oGet:aCols[oGet:nAt][nPosProdut], dEmissao, ZZH->ZZH_FORNEC , ZZH->ZZH_LOJA )
		IF nTipoNota  ==  1  //Contagem maior que a NF                  
		    cTM        := cAJPos     
        Else
            cTM        := cAjNeg
        EndIF
		
		nRecAjuste   := Sel_Dados(3)
		IF nRecAjuste  <> 0 
		    dbSelectArea('SD3')
		    SD3->(dbGoTo(nRecAjuste))
			oGet:aCols[oGet:nAt][nPosTipoNF] := '3'
			aRegAJ[oGet:nAt] :=  SD3->(RECNO())
			oGet:aCols[oGet:nAt][nPosAJuste]  := SD3->D3_QUANT
			oGet:oBrowse:Refresh()
		EndIF
	EndIF
ELSEIF nTipoSelecao == 3
	dbSelectArea('ZZI')
	ZZI->(dbSetOrder(1))
	IF ZZI->(dbSeek( xFilial('ZZI')+ZZH->ZZH_AR+oGet:aCols[oGet:nAt][nPosCod] ))
		dEmissao   := GetAdvFVal( "SF1", "F1_EMISSAO", xFilial('SF1')+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+ALLTRIM(ZZH->ZZH_FORNEC)+ZZH->ZZH_LOJA, 1, "" )
		cRecNFx     := Ret_NFX(aRegNF[oGet:nAt], oGet:aCols[oGet:nAt][nPosProdut], dEmissao, ZZH->ZZH_FILIAL)
		bSel := ConPad1(,,,'TAE_07')
		IF bSel
			dbSelectArea('SD2')
			SD2->(DbGoto(val(__cRetorno)))
			IF SD2->(!EOF())
				oGet:aCols[oGet:nAt][nPosDoc]    := SD2->D2_DOC
				oGet:aCols[oGet:nAt][nPosSerie]  := SD2->D2_SERIE
				IF nDiferenca >= SD2->D2_QUANT
				    oGet:aCols[oGet:nAt][nPosQDEV]   := SD2->D2_QUANT
				EndiF
				aRegNF[oGet:nAt] :=  SD2->(RECNO())
			EndIF
			oGet:oBrowse:Refresh()
		EndIF
	ENDIF
EndIF

Return 



****************************************************************************************************************************************************************
Static Function Ret_NF(nTipo,nRecAtual,cCod, dDatEmissao,cFOR,cLOJA)
Local cRecs   := ''
Local cQuery  := ''

cQuery  := " SELECT ZZI_RECNO, ZZI_RECNOA "
cQuery  += " FROM "+RetSqlName('ZZH')+" ZZH,"+RetSqlName('ZZI')+" ZZI"
cQuery  += " WHERE ZZH.D_E_L_E_T_  = ' ' "
cQuery  += "   AND ZZI.D_E_L_E_T_  = ' ' "
cQuery  += "   AND ZZH_FILIAL  = ZZI_FILIAL"
cQuery  += "   AND ZZH_AR      = ZZI_AR"
cQuery  += "   AND ZZH_FORNEC  = '"+cFOR+"'"
cQuery  += "   AND ZZH_LOJA    = '"+cLOJA+"'"
cQuery  += "   AND ZZI_PRODUT  = '"+cCod+"'"    
cQuery  += "   AND ZZI_TIPONF  = '"+Alltrim(STR(nTipo))+"'"    
IF nTipo == 3
   cQuery  += "   AND ZZI_RECNOA   <> "+Alltrim(STR(nRecAtual))+""
Else 
   cQuery  += "   AND ZZI_RECNO   <> "+Alltrim(STR(nRecAtual))+""
EndIF
If Select("QRY_SD") > 0
	QRY_SD->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SD",.T.,.F.)
dbSelectArea("QRY_SD")
QRY_SD->(dbGoTop())
While !QRY_SD->(EOF()) 
    IF nTipo == 3
        cRecs   += Alltrim(STR(QRY_SD->ZZI_RECNOA))+'#'  
    Else 
        cRecs   += Alltrim(STR(QRY_SD->ZZI_RECNO))+'#'  
    EndIF
    QRY_SD->(dbSkip())
EndDo       

Return cRecs



****************************************************************************************************************************************************************
Static Function Ret_NFX(nRecAtual,cCod, dDatEmissao, _cFilial)
Local cRecs   := ''
Local cQuery  := ''

cQuery  := " SELECT SD2.R_E_C_N_O_ SD2RECNO"
cQuery  += " FROM "+RetSqlName('SD2')+" SD2 "
cQuery  += " WHERE SD2.D_E_L_E_T_  = ' ' "
cQuery  += "   AND D2_FILIAL  = '"+_cFilial+"'"
cQuery  += "   AND D2_CLIENTE  = '000095'"
cQuery  += "   AND D2_COD  = '"+cCod+"'"
cQuery  += "   AND D2_CF = '5927'" // CFOP DE PERDA
cQuery  += "   AND D2_EMISSAO  >= '"+DTOS(dDatEmissao)+"'"    
If Select("QRY_SD") > 0
	QRY_SD->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SD",.T.,.F.)
dbSelectArea("QRY_SD")
QRY_SD->(dbGoTop())
While !QRY_SD->(EOF()) 
        cRecs   += Alltrim(STR(QRY_SD->SD2RECNO))+'#'  
    QRY_SD->(dbSkip())
EndDo       

Return cRecs



****************************************************************************************************************************************************************
User Function TAE07_F4
Local cRet      := .F.
Local cFornece  := Alltrim(ZZH->ZZH_FORNEC)
                 
ZZH->(dbSetOrder(3))
IF bDevol  
   IF EMPTY(SF1->F1_STATUS)  ;
      .AND. SF1->F1_TIPO=='D' ;
      .AND. SF1->F1_FORMUL=='S';
      .AND. ZZH->(!dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
       cRet := .T.
   EndIF                     
ELSE
	IF bReabertura 
	 IF !EMPTY(SF1->F1_STATUS) .AND. SF1->F1_TIPO $ 'ND' ;
		    .AND. ALLTRIM(SF1->F1_FORNECE) == cFornece ;
		    .AND. ZZH->(!dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
		    cRet := .T.
		EndIF                     
	ELSE
		IF !EMPTY(SF1->F1_STATUS) .AND. SF1->F1_TIPO $ 'ND' ;
		    .AND. ZZH->(!dbSeek(SF1->F1_FILIAL+PADR(ALLTRIM(SF1->F1_FORNECE),TamSX3("ZZH_FORNEC")[1])+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
		    cRet := .T.
		EndIF                     
	EndIF
ENDIF
	
Return cRet



******************************************************************************************************************************************************************
User Function TAE07_INC
Local bSel        := .F.                            
Local aRet		  := {}
Local aParambox	  := {}
Local bSinistro   := .F.
Local aSM0        :=  {}
Local cCnpj       :=  ''
Local cItem       := '0000'

Private bDevol      := .F.
Private bReabertura := .F.
Private bSinistro   := .F.
Private aTipoFrete  := {'CIF','FOB','TERCEIROS'}
Private cCNF        := Space(10)
Private cTransp     := Space(tamSx3("F1_TRANSP")[1]) 
Private cPlaca      := Space(tamSx3("F1_PLACA")[1])
Private nFrete      := 1
IF MsgNOYES('AR de Devolução ?')  
    bDevol := .T.
EndIF
IF !bDevol
	IF MsgNOYES('AR de Sinistro ?')
    	bSinistro := .T.
 	EndIF
EndIF

IF bSinistro
	bSel := ConPad1(,,,'DAK')
	IF bSel .And. DAK->(!Eof())
		IF MsgNOYES('Confirma a inclusão do AR ?')
		    aSM0   :=  FWArrFilAtu()
		    cCnpj  :=  aSM0[18]
		    SA2->(dbSetOrder(3))
			If SA2->(!DbSeek(xFilial("SA2")+cCnpj))
				MsgAlert('Filial não cadastrada com fornecedor, não é possivel criar o AR !!')
				Return
			EndIf
			SA2->(dbSetOrder(1))
			cAR   := PegaAR()
			Reclock("ZZH",.T.)
			ZZH->ZZH_FILIAL := xFilial('ZZH')
			ZZH->ZZH_AR 	:= cAR
			ZZH->ZZH_FORNEC := SA2->A2_COD
			ZZH->ZZH_LOJA 	:= SA2->A2_LOJA
			ZZH->ZZH_DOC 	:= ' '
			ZZH->ZZH_NOME 	:= SA2->A2_NREDUZ
			ZZH->ZZH_SERIE 	:= ' '
			ZZH->ZZH_STATUS := '0' 
			ZZH->ZZH_DOCMOV := DAK->DAK_COD
			ZZH->(MsUnlock())
			
			cQuery  := " Select D2_COD	, SUM(D2_QUANT) QTDE "
			cQuery  += " From "+RetSqlName('DAI')+" A,"+RetSqlName('SD2')+" B" 
			cQuery  += " Where A.D_E_L_E_T_ = ' ' "
			cQuery  += "   AND B.D_E_L_E_T_ = ' '"
			cQuery  += "   AND DAI_FILIAL	= '"+xFilial('DAI')+"' "
			cQuery  += "   AND DAI_COD      = '"+DAK->DAK_COD+"'"
			cQuery  += "   AND D2_FILIAL    = DAI_FILIAL"
			cQuery  += "   AND D2_DOC       = DAI_NFISCA"	
			cQuery  += "   AND D2_SERIE     = DAI_SERIE"
			cQuery  += " Group by D2_COD	"
			If Select("QRY_DAI") > 0
				QRY_DAI->(dbCloseArea())
			EndIf
			cQuery  := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_DAI",.T.,.F.)
			dbSelectArea("QRY_DAI")
			QRY_DAI->(dbGoTop())
			While !QRY_DAI->(EOF()) 
				cItem := SOMA1(cItem)
				Reclock("ZZI",.T.)
				ZZI->ZZI_FILIAL := xFilial('ZZI')
				ZZI->ZZI_AR     := cAR
				ZZI->ZZI_ITEM   := cItem
				ZZI->ZZI_DESC   := GetAdvFVal( "SB1", "B1_DESC", xFilial('SB1')+QRY_DAI->D2_COD, 1, "" )
				ZZI->ZZI_PRODUT := QRY_DAI->D2_COD
				ZZI->ZZI_QNF    := QRY_DAI->QTDE
				ZZI->ZZI_QCONT  := 0
				ZZI->ZZI_QDEV   := 0
				ZZI->ZZI_QCOMPL := 0
				ZZI->ZZI_AJUSTE := 0
				ZZI->ZZI_LOCAL  := GetAdvFVal( "SB1", "B1_LOCPAD", xFilial('SB1')+QRY_DAI->D2_COD, 1, "" )
				ZZI->(MsUnlock())
				QRY_DAI->(dbSkip())
			End
			MsgAlert('AR criado :'+cAR)
		EndIF
	EndIF
Else
	bSel := ConPad1(,,,'TAE_04')
	
	IF bSel .And. SF1->(!Eof())
		IF !bDevol
			cTransp     := SF1->F1_TRANSP
			cPlaca      := SF1->F1_PLACA
			IF SF1->F1_TPFRETE == 'C' .OR. Empty(SF1->F1_TPFRETE)
				nFrete := 1
			ElSEIF SF1->F1_TPFRETE == 'F'
				nFrete := 2
			ELSE
				nFrete := 3
			EndIF
		EndIF
		AAdd(aParamBox, {2, "Tipo de Frete :"	, nFrete , aTipoFrete, 070	, ,  .T.	})
		AAdd(aParamBox, {1, "Transportadora :"	, cTransp, "@!","ExistCPO('SA4',MV_PAR02,1)","SA4",, 070	, .T.	})
		AAdd(aParamBox, {1, "Placa Veiculo :"	, cPlaca , "@!","U_TAE07Placa()"			,""	  ,, 070	, .T.	})
		AAdd(aParamBox, {1, "CNF:"              , cCNF   , "@!",                           ,      ,, 070	, .T.	})
		//Campo transferido para o item RITM0012774 
		
		IF ParamBox(aParambox, "Informaçãos de Transporte"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
			Reclock("SF1",.F.)
			IF VALTYPE(MV_PAR01) == 'C'
				SF1->F1_TPFRETE   := SUBSTR(MV_PAR01,1,1)
			Else
				SF1->F1_TPFRETE   := SUBSTR(aTipoFrete[MV_PAR01],1,1)
			EndIF
			SF1->F1_TRANSP    := MV_PAR02
			SF1->F1_PLACA     := MV_PAR03
			SF1->(MsUnlock())
			Processa( {|| U_MGFTAE06(2,MV_PAR04,MV_PAR05) },'Aguarde...', 'Gerando',.F. )
		EndIF
	EndIf
EndIF

ZZH->(dbSetOrder(1))
Return



******************************************************************************************************************************************************************
User Function TAE07_EXC
Local aAuto     := {}	
Local cDoc      := ''   
Local cProdutos := "('x'"  
Local bContinua := .T.
Local cPrefixo  := ''
Local nI        := 0                                
Local aErro     := {}
Local cErro 	:= ""  
Local cContinua := .T.               
Local aItem	    := {}
Local aCab	    := {}
Local cDoc      := ''
Local aPos      := ''

Private cLocalInd       := GetMV('MGF_AE6LOC',.F.,'04')
Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.                                         

IF MsgYESNO('Deseja excluir o AR ?')
	IF ZZH->ZZH_STATUS == '0'
		bContinua := .T.
	EndIF
	IF ZZH->ZZH_STATUS == '1'
		IF !U_MGFTAE18(ZZH->ZZH_FILIAL,ZZH->ZZH_AR)  //Verifica_Taura Metodo consulta
			MsgAlert('Não foi aprovada a exclusão pelo Taura')
			bContinua := .F.
		EndIF
	EndIF
	IF bContinua
		IF ZZH->ZZH_STATUS $ '234'
			MsgAlert('Já se realizou a contagem, não é possivel excluir!')
		Else
			IF SUBSTR(ZZH->ZZH_AR,1,1) <>'D' .And. SUBSTR(ZZH->ZZH_AR,1,1) <>'S'
				aCab := {}
				cDoc  := U_TAE_DOC_D3()
				AAdd(aCab,{cDoc,dDataBase})  
				dbSelectArea('SD1')
				SD1->(dbSetOrder(1))
				SD1->(dbSeek(ZZH->ZZH_FILIAL+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+SUBSTR(ZZH->ZZH_FORNEC,1,TamSx3('D1_FORNECE')[01])+ZZH->ZZH_LOJA))
				While SD1->(!EOF()) .And. ;
				      SD1->D1_FILIAL == ZZH->ZZH_FILIAL    .AND.;
				      SD1->D1_DOC    == ZZH->ZZH_DOC       .AND.;
				      SD1->D1_SERIE  == ZZH->ZZH_SERIE     .AND.;
				      Alltrim(SD1->D1_FORNECE) == Alltrim(ZZH->ZZH_FORNEC) .AND.;
				      SD1->D1_LOJA   == ZZH->ZZH_LOJA 
				      
				    IF SD1->D1_COD     <= '500000'  
						nPos := AScan(aCab,{|x|  Alltrim(x[1]) == Alltrim(SD1->D1_COD) })
						IF nPos <> 0                  
							aCab[nPos,16] +=  SD1->D1_QUANT
						Else
						
							aItem	    := {}
							SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
							Aadd(aItem,SD1->D1_COD)     //D3_COD
							AAdd(aItem,SB1->B1_DESC)    //D3_DESCRI
							AAdd(aItem,SD1->D1_UM)      //D3_UM
							AAdd(aItem,cLocalInd)       //D3_LOCAL
							AAdd(aItem,"")				//D3_LOCALIZ
							AAdd(aItem,SD1->D1_COD)  	//D3_COD
							AAdd(aItem,SB1->B1_DESC)    //D3_DESCRI
							AAdd(aItem,SD1->D1_UM)  	//D3_UM
							AAdd(aItem,SD1->D1_LOCAL)   //D3_LOCAL
							AAdd(aItem,"")				//D3_LOCALIZ
							AAdd(aItem,"")          	//D3_NUMSERI
							If !Empty(SD1->D1_LOTECTL) .And. SB1->B1_RASTRO $ "LS"
								AAdd(aItem,SD1->D1_LOTECTL)			//D3_LOTECTL
								AAdd(aItem,"")         				//D3_NUMLOTE
								AAdd(aItem,STOD(SD1->D1_DTVALID))	//D3_DTVALID
							Else
								AAdd(aItem,CriaVar("D3_LOTECTL",.F.))   	//D3_LOTECTL
								AAdd(aItem,"      ")         				//D3_NUMLOTE
								AAdd(aItem,CriaVar("D1_DTVALID",.F.))   	//D3_DTVALID
							EndIF
							AAdd(aItem,0)					//D3_POTENCI
							AAdd(aItem,SD1->D1_QUANT) 		//D3_QUANT
							AAdd(aItem,0)					//D3_QTSEGUM
							AAdd(aItem,"")   				//D3_ESTORNO
							AAdd(aItem,"")         			//D3_NUMSEQ
							If !Empty(SD1->D1_LOTECTL) .And. SB1->B1_RASTRO $ "LS"
								AAdd(aItem,SD1->D1_LOTECTL)	//D3_LOTECTL
								AAdd(aItem,STOD(SD1->D1_DTVALID))	//D3_DTVALID
							Else
								AAdd(aItem,CriaVar("D3_LOTECTL",.F.))   	//D3_LOTECTL
								AAdd(aItem,CriaVar("D1_DTVALID",.F.))   	//D3_DTVALID
							EndIF
							AAdd(aItem,"")					//D3_ITEMGRD
							AAdd(aItem,"")   				//CAT 83 Cod. Lanc
							AAdd(aItem,"")         			//CAT 83 Cod. Lanc
							AAdd(aItem,"")         			//D3_OBSERVAC
							AAdd(aCab,aItem)
						EndIF	
					EndIF
					SD1->(dbSkip())
				End
				cFilBak := cFilAnt
				cFilAnt := ZZH->ZZH_FILIAL
				MSExecAuto({|x,y| mata261(x,y)},aCab,3)
				IF lMsErroAuto
					aErro := GetAutoGRLog()
					cErro := ""
					For nI := 1 to Len(aErro)
						cErro += aErro[nI] + CRLF
					Next nI
					msgAlert(cErro)
					bContinua   := .F.
				Endif
				IF bContinua
					cPrefixo := GetAdvFVal( "SF1", "F1_PREFIXO", xFilial('SF1')+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+ALLTRIM(ZZH->ZZH_FORNEC)+ZZH->ZZH_LOJA, 1, "" )
					cQuery := " Update "+RetSqlName("SE2")
					cQuery += " Set E2_MSBLQL    = '2'"
					cQuery += " Where E2_FILIAL  = '"+xFilial('SE2')+"'"
					cQuery += "   AND E2_PREFIXO = '"+cPrefixo+"'"
					cQuery += "   AND E2_NUM     = '"+ZZH->ZZH_DOC+"'"
					cQuery += "   AND E2_TIPO    = 'NF'"
					cQuery += "   AND E2_FORNECE = '"+ZZH->ZZH_FORNEC+"'"
					cQuery += "   AND E2_LOJA    = '"+ZZH->ZZH_LOJA+"'"
					IF (TcSQLExec(cQuery) < 0)
						bContinua   := .F.
						MsgStop(TcSQLError())
					EndIF
				EndIF
				cFilAnt := cFilBak
			EndIF
			IF bContinua
				// Exclui AR e ITENS
				ZZI->(dbSeek( xFilial('ZZI')+ZZH->ZZH_AR ))
				While ZZI->(!EOF()) .And. ZZI->ZZI_FILIAL + ZZI->ZZI_AR  == xFilial('ZZI')+ZZH->ZZH_AR
					Reclock("ZZI",.F.)
					ZZI->(dbDelete())
					ZZI->(MsUnlock())
					ZZI->(dbSeek( xFilial('ZZI')+ZZH->ZZH_AR ))
				EndDo
				Reclock("ZZH",.F.)
					IF ZZH->ZZH_STATUS == '1'
						ZZH->ZZH_STATUS := "9" // marca AR como 9 = nao enviado, para esta exclusao ser enviada na proxima execucao da rotina de envio
					EndIF
				ZZH->(dbDelete())
				ZZH->(MsUnlock())
				
				MsgAlert('AR excluído, pode-se excluir o (pré)Documento de Entrada !!')
			EndIF
		EndIF
	EndIF
EndIf

Return



****************************************************************************************************************************************************************
Static Function Ver_PreNota
Local cQuery   := ''
Local aAR      := {}
Local aPreNota := {}
Local nI       := 0 
Local cTexto   := ''                 
Local nPos     := 0
Local nRet     := .T.

cQuery  := " SELECT ZZI_PRODUT, SUM(ZZI_QCONT) As CONTAGEM "
cQuery  += " FROM "+RetSqlName('ZZI')+" ZZI"
cQuery  += " WHERE ZZI.D_E_L_E_T_  = ' ' "
cQuery  += "   AND ZZI_FILIAL  = '"+ZZH->ZZH_FILIAL+"'"
cQuery  += "   AND ZZI_AR      = '"+ZZH->ZZH_AR+"'"
cQuery  += " GROUP BY ZZI_PRODUT"
If Select("QRY_ZZI") > 0
	QRY_ZZI->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_ZZI",.T.,.F.)
dbSelectArea("QRY_ZZI")
QRY_ZZI->(dbGoTop())
While !QRY_ZZI->(EOF()) 
    IF QRY_ZZI->CONTAGEM > 0 
        AAdd(aAR , {.F.,QRY_ZZI->ZZI_PRODUT,QRY_ZZI->CONTAGEM})
    EndIF
    QRY_ZZI->(dbSkip())
EndDo       
cQuery  := " SELECT D1_COD , SUM(D1_QUANT) As D1_TOTAL"
cQuery  += " FROM "+RetSqlName('SD1')
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += "   AND D1_FILIAL  = '"+ZZH->ZZH_FILIAL+"'"
cQuery  += "   AND D1_FORNECE = '"+ZZH->ZZH_FORNEC+"'"
cQuery  += "   AND D1_LOJA    = '"+ZZH->ZZH_LOJA+"'"
cQuery  += "   AND D1_DOC     = '"+ZZH->ZZH_DOC+"'"
cQuery  += "   AND D1_SERIE   = '"+ZZH->ZZH_SERIE+"'"
cQuery  += "  GROUP BY D1_COD "
If Select("QRY_PRENOTA") > 0
	QRY_PRENOTA->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PRENOTA",.T.,.F.)
dbSelectArea("QRY_PRENOTA")
QRY_PRENOTA->(dbGoTop())
QRY_ZZI->(dbGoTop())
While !QRY_PRENOTA->(EOF()) 
    AAdd(aPreNota , {.F.,QRY_PRENOTA->D1_COD,QRY_PRENOTA->D1_TOTAL})
    QRY_PRENOTA->(dbSkip())
EndDo       

For nI := 1 To Len(aAR)
   nPos := AScan(aPreNota,{|x|  x[2] ==aAR[nI,2] })
   IF nPos == 0 
       cTexto += 'Produto :'+aAR[nI,2]+' não encontrado na Pré Nota'+CRLF
   Else 
       IF aAR[nI,3] <>  aPreNota[nPos,3] 
           cTexto += 'A Quantidade do Produto :'+aAR[nI,2]+' está com diferença da Pré Nota'+CRLF
       EndIF
   EndIF
Next nI

For nI := 1 To Len(aPreNota)
   nPos := AScan(aAR,{|x|  x[2] ==aPreNota[nI,2] })
   IF nPos == 0 
       cTexto += 'Produto :'+aPreNota[nI,2]+' não encontrado no AR'+CRLF
   EndIF
Next nI

IF !Empty(cTexto)
     MsgAlert('Favor acertar a Pré Nota com os itens :'+CRLF+cTexto)
     nRet     := .F.
EndIF

Return nRet 

**********************************************************************************************************************************************
User Function TAE07Placa()

Local lRet := .T.

If ExistCPO('DA3',MV_PAR03,3)
	lRet := .T.
Else
	lRet := .F.
Endif

Return(lRet)	
**********************************************************************************************************************************
Static Function PegaAR

local aArea		 := GetArea()
local aAreaZZH   := ZZH->(GetArea())
local cAR

While .t.

	cAR := GetSxeNum("ZZH","ZZH_AR")
	cAR := "S"+substr(cAR,2,7)
	
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



*************************************************************************************************************************************************************
User Function TAE07_ENF


IF SUBSTR(ZZH->ZZH_AR,1,1) <>'S'
	MsgAlert('Somente AR de Sinistro pode emitir NF de entrada !!')
	Return
Else
	IF ZZH->ZZH_STATUS <> '2'
		MsgAlert('Situação do AR não permite a emissão da Nota !!')
		Return
	Else
		Processa( {|| Gera_Doc_Entrada() },'Aguarde...', 'Sinistro - Gerando Nota Entrada',.F. )
	EndIF
EndIF

Return
***************************************************************************************************************************************************
Static Function Gera_Doc_Entrada()
	
Local nTamC      := TamSX3("A2_COD")[1]
Local nTamL      := TamSX3("A2_LOJA")[1]
Local nTamP      := TamSX3("B1_COD")[1]
Local cEst       := GetAdvFVal( "SA2", "A2_EST", xFilial('SA2')+PADR(ALLTRIM(ZZH->ZZH_FORNEC),nTamC)+;
										     PADR(ALLTRIM(ZZH->ZZH_LOJA),nTamL), 1, "" )     
Local cTES       := ''
Local nI         := 0
Local aItem      := {} 
Local aCabSF1    := {}           
Local aTotItem   := {}                            
Local cOperTES   := ''                              
Local nTotKG     := 0                                       
Local cRecZZH    := ZZH->(RecNo())

Private cNumero         := ''
Private cSerie  		:= ''
Private bSel    		:= .F.
Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.  
Private aParamBox := {} 
Private aRet      := {}



IF Sx5NumNota()
	SF1->(dbSetOrder(1))
	IF SF1->(dbSeek(ZZH->ZZH_FILIAL+cNumero+cSerie+Alltrim(ZZH->ZZH_FORNEC)+ZZH->ZZH_LOJA))
		msgAlert('Numeração da nota já existe para este fornecedor !!')
	Else
		bSel := ConPad1(,,,'DJ')
		IF bSel
			cOperTES   := SX5->X5_CHAVE
			bSel := ConPad1(,,,'SE4')
			IF bSel
				bSel := ConPad1(,,,'DA1IRP')
				IF bSel
					AAdd(aParamBox, {1, "Volume"      	    ,0 , "@E 999999",                ,     , , 050	, .T.	})
					AAdd(aParamBox, {1, "Especie"           ,SPACE(tamSx3("F1_ESPECI1")[1])  , "@!",  , ,, 060	, .T.	})
					IF ParamBox(aParambox, "Dados de Volume"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
						cNumero := NxtSX5Nota(cSerie)
						SB1->(dbSetOrder(1))
						aCabSF1    := {}
						aTotItem   := {}
						Aadd(aCabSF1,{"F1_FILIAL"     ,ZZH->ZZH_FILIAL   ,Nil})
						Aadd(aCabSF1,{"F1_DOC"        ,cNumero      ,Nil})
						Aadd(aCabSF1,{"F1_SERIE"      ,cSerie    ,Nil})
						Aadd(aCabSF1,{"F1_FORNECE"    ,Alltrim(ZZH->ZZH_FORNEC)  ,Nil})
						Aadd(aCabSF1,{"F1_LOJA"       ,ZZH->ZZH_LOJA    ,Nil})
						Aadd(aCabSF1,{"F1_COND"       ,SC7->C7_COND   ,Nil})
						Aadd(aCabSF1,{"F1_EMISSAO"    ,dDataBase        ,Nil})
						Aadd(aCabSF1,{"F1_FORMUL"     ,'S'              ,Nil})
						Aadd(aCabSF1,{"F1_ESPECIE"    ,'SPED'  			,Nil})
						Aadd(aCabSF1,{"F1_TIPO"       ,'N'     			,Nil})
						Aadd(aCabSF1,{"F1_DTDIGIT"    ,dDataBase  		,Nil})
						Aadd(aCabSF1,{"F1_EST"        ,cEst     		,Nil})
						Aadd(aCabSF1,{"F1_VOLUME1"    ,MV_PAR01         ,Nil})
						Aadd(aCabSF1,{"F1_ESPECI1"    ,MV_PAR02         ,Nil})
						Aadd(aCabSF1,{"F1_PBRUTO"     ,0         ,Nil})
						Aadd(aCabSF1,{"F1_PLIQUI "    ,0         ,Nil})
						dbSelectArea('DA1')
						DA1->(dbSetOrder(1))
						
						SD1->(dbSetOrder(1))
						ZZI->(dbSeek(ZZH->ZZH_FILIAL+ZZH->ZZH_AR))
						While !ZZI->(EOF()).And.;
							ZZI->ZZI_FILIAL == ZZH->ZZH_FILIAL .And.;
							ZZI->ZZI_AR == ZZH->ZZH_AR
							
							IF ZZI->ZZI_QCONT > 0
								aItem	   := {}
								cTes       := MaTesInt(1,Alltrim(cOperTES),PADR(ALLTRIM(ZZH->ZZH_FORNEC),nTamC),PADR(ALLTRIM(ZZH->ZZH_LOJA),nTamL),"F",PADR(ALLTRIM(ZZI->ZZI_PRODUT),nTamP))
								//cTes       := '003'
								IF Empty(cTes)
									cMsg := "Pelas regras cadastradas de 'TES inteligente', não foi encontrado 'TES' para os dados abaixo: "+CRLF+;
									"Tipo de Operação: "+cOperTES+CRLF+;
									"Fornecedor: "+ALLTRIM(ZZH->ZZH_FORNEC)+'-'+ALLTRIM(ZZH->ZZH_LOJA)+CRLF+;
									"Produto: "+ALLTRIM(ZZI->ZZI_PRODUT)
									APMsgStop(cMsg)
									Return
								EndIf
								IF DA1->(!dbSeek(DA0->DA0_FILIAL+DA0->DA0_CODTAB+PADR(ALLTRIM(ZZI->ZZI_PRODUT),nTamP)))
									MsgAlert('Não Encontrado tabela de Preço para o Item '+ALLTRIM(ZZI->ZZI_PRODUT)+'!!')
									Return
								EndIF
								
								SB1->(dbSeek(xFilial('SB1')+ZZI->ZZI_PRODUT))
								Aadd(aItem,{"D1_COD"        , ALLTRIM(ZZI->ZZI_PRODUT)  ,Nil})
								Aadd(aItem,{"D1_QUANT"      , ZZI->ZZI_QCONT  ,Nil})
								Aadd(aItem,{"D1_VUNIT"      , DA1->DA1_PRCVEN  ,Nil})
								Aadd(aItem,{"D1_TOTAL"      , Round(DA1->DA1_PRCVEN* ZZI->ZZI_QCONT, 2) ,Nil})
								Aadd(aItem,{"D1_TES"        ,cTES      		,Nil})
								Aadd(aItem,{"D1_LOCAL"      ,SB1->B1_LOCPAD 	,Nil})
								AAdd(aTotItem,aItem)
								nTotKG     += ZZI->ZZI_QCONT
							EndIF
							ZZI->(dbSkip())
						Enddo
						IF Len(aItem) == 0
							MsgAlert('Não existe itens para efetivar a nota fiscal !!')
							Return
						EndIF
						aCabSF1[15][02] :=  nTotKG
						aCabSF1[15][02] :=  nTotKG
						ZZH->(dbGoto(cRecZZH))
						Reclock("ZZH",.F.)
						ZZH->ZZH_DOC    := cNumero
						ZZH->ZZH_SERIE  := cSerie
						ZZH->ZZH_STATUS := '3'
						ZZH->(MsUnlock())
						MSExecAuto({|x,y| MATA103(x,y)},aCabSF1,aTotItem)
						If lMsErroAuto
							ZZH->(dbGoto(cRecZZH))
							Reclock("ZZH",.F.)
							ZZH->ZZH_DOC    := ' '
							ZZH->ZZH_SERIE  := ' '
							ZZH->ZZH_STATUS := '2'
							ZZH->(MsUnlock())
							
							aErro := GetAutoGRLog()
							cErro := ""
							For nI := 1 to Len(aErro)
								cErro += aErro[nI] + CRLF
							Next nI
							msgStop(cErro)
						Else
						    MsgAlert('Nota Gerada : '+cNumero+'-'+cSerie)
						Endif
					EndIF
				EndIF
			EndIF
		EndIF
	EndIF
EndIF

Return 
**************************************************************************************************************************************************
Static Function Sel_Dados(nTipoDados)

Local oBtn
Local cRecs   := ''
Local cQuery  := ''             
Local aAjuste := {}    
Local aCab    := IIF(nTipoDados==3,{'Emissão','Doc.','TM','Quantidade'},{'Emissão','Doc.','Serie','Quantidade'})
Local aRec    := {}

Private oDlg5
Private oBrowse
Private nReg  := 0 

cQuery  := " SELECT a.*, R_E_C_N_O_ RECMOV"
cQuery  += " FROM "+RetSqlName('SD3')+' a '
cQuery  += " WHERE D_E_L_E_T_  = ' ' "
cQuery  += "   AND D3_FILIAL   = '"+ZZH->ZZH_FILIAL+"'"
cQuery  += "   AND D3_TM       = '"+cTM+"'"
cQuery  += "   AND D3_ESTORNO  <>'S' "
cQuery  += "   AND D3_COD      = '"+ZZI->ZZI_PRODUT+"'"
cQuery  += "   AND D3_EMISSAO  >= '"+DTOS(dEmissao)+"'"

If Select("QRY_SD") > 0
	QRY_SD->(dbCloseArea())
EndIf

cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SD",.T.,.F.)
dbSelectArea("QRY_SD")
QRY_SD->(dbGoTop())
While !QRY_SD->(EOF()) 
    IF !(Alltrim(STR(QRY_SD->RECMOV))  $ cRecAJ )
    	 aRec    := {}
         AAdd(aRec,STOD(QRY_SD->D3_EMISSAO))
         AAdd(aRec,QRY_SD->D3_DOC)
         AAdd(aRec,QRY_SD->D3_TM)
         AAdd(aRec,QRY_SD->D3_QUANT)
         AAdd(aRec,QRY_SD->RECMOV) 
         AAdd(aAjuste,aRec)

    EndIF

    QRY_SD->(dbSkip())
EndDo                                

IF Len(aAjuste) == 0
    MsgAlert(' Sem dados para o Ajuste')
    Return nReg
EndIF

DEFINE MSDIALOG oDlg5 TITLE "Seleciona Ajuste/NF" FROM 000, 000  TO 200, 600 COLORS 0, 16777215 PIXEL

    //@ 004, 004 LISTBOX oBrowse Fields HEADER aCab SIZE 290, 081 OF oDlg5 PIXEL ColSizes 50,50
    oBrowse  := TWBrowse():New( 004, 004,  290, 081,,,,oDlg5, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
    oBrowse:SetArray(aAjuste)
    oBrowse:nAt := 1
    oBrowse:bLine := { || {aAjuste[oBrowse:nAt,1], aAjuste[oBrowse:nAt,2], aAjuste[oBrowse:nAt,3], aAjuste[oBrowse:nAt,4]} }
   
	oBrowse:addColumn(TCColumn():new("Emissão"    ,{||aAjuste[oBrowse:nAt][01]},"@!" ,,,"LEFT"  ,20,.F.,.F.,,,,,))
	oBrowse:addColumn(TCColumn():new("Doc."       ,{||aAjuste[oBrowse:nAt][02]},"@!" ,,,"LEFT"  ,70,.F.,.F.,,,,,))
	oBrowse:addColumn(TCColumn():new("TM"         ,{||aAjuste[oBrowse:nAt][03]},"@!" ,,,"LEFT"  ,20,.F.,.F.,,,,,))
	oBrowse:addColumn(TCColumn():new("Qauntidade" ,{||aAjuste[oBrowse:nAt][04]},"@E 999,999,999.99" ,,,"RIGHT" ,40,.F.,.F.,,,,,))
	oBrowse:DrawSelect()                               
   
	oBtn := TButton():New( 087, 004 ,'Confirmar' , oDlg5,{|| nReg  := aAjuste[oBrowse:nAt,5], oDlg5:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtn := TButton():New( 087, 248 ,'Sair'      , oDlg5,{|| oDlg5:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
    
ACTIVATE MSDIALOG oDlg5 CENTERED                                                                  

Return nReg
************************************************************************************************************************************************
User Function TAE07_NF

Local cCod	    := RetCodUsr()
Local aGrupos   := UsrRetGrp(UsrRetName(cCod)) 
Local nI        := 0
Local cGrupos   := GetMV('MGF_TAE07A',.F.,"000000")  
Local bAcesso   := .F.
Local aRet		  := {}
Local aParambox	  := {}                             

For nI := 1 To Len(aGrupos)
    IF Alltrim(aGrupos[nI]) $ Alltrim(cGrupos)
    	bAcesso := .T.
    EndIF     
Next nI
                     
IF !bAcesso
	MsgAlert('Usuário sem acesso a Tela !!')
	Return
EndIF                     
IF SUBSTR(ZZH->ZZH_AR,1,1) =='S'
	MsgAlert('Não é possivel alterar AR de Sinistro!!')
	Return
EndIF
IF SUBSTR(ZZH->ZZH_AR,1,1) =='D'
	MsgAlert('Não é possivel alterar AR de Devolução!')
	Return
EndIF
IF ZZH->ZZH_STATUS == '1'
	MsgAlert('AR em processo de contagem não é possivel desvincular!!')
	Return
EndIF
IF ZZH->ZZH_STATUS == '0'
	MsgAlert('AR ainda não enviado para o Taura, favor excluir!!')
	Return
EndIF
IF ZZH->ZZH_STATUS == '4'
	MsgAlert('NF do AR já desvinculado !!')
	Return
EndIF

IF !MsgYESNO('Deseja desvincular a NF do AR?')
	Return
EndIF

AAdd(aParamBox, {1, "Motivo:", Space(50), "@!",,,, 120, .T.	})
IF ParamBox(aParambox, "Desvincular NF do AR"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .F. /*lCanSave*/, .F. /*lUserSave*/)
	IF Empty(MV_PAR01)
		MsgAlert('Motivo em branco!!')
		Return
	EndIF
	RecLock("ZZH", .F. )
	ZZH->ZZH_DOCX   := ZZH->ZZH_DOC
	ZZH->ZZH_SERIEX := ZZH->ZZH_SERIE
	ZZH->ZZH_LOJAX  := ZZH->ZZH_LOJA
	ZZH->ZZH_STATX  := ZZH->ZZH_STATUS
	ZZH->ZZH_USRX   := RetCodUsr()
	ZZH->ZZH_DATAX  := DTOC(Date())+'-'+Time()
	ZZH->ZZH_MOTX   := MV_PAR01
	ZZH->ZZH_DOC    := ' '
	ZZH->ZZH_SERIE  := ' '
	ZZH->ZZH_STATUS := '4'
	ZZH->(MsUnLock())
	MsgAlert('Nota desvinculada !!')
EndIF	
Return
***********************************************************************************************************************************************************888
User Function TAE07_VF
Local cCod	    := RetCodUsr()
Local aGrupos   := UsrRetGrp(UsrRetName(cCod)) 
Local nI        := 0
Local cGrupos   := GetMV('MGF_TAE07A',.F.,"000000")  
Local bAcesso   := .F.
Local aRet		  := {}
Local aParambox	  := {}   
local bSel        := .F.
Local nRecno      := 0

Private bDevol      := .F.                            
Private bReabertura := .T.

For nI := 1 To Len(aGrupos)
    IF Alltrim(aGrupos[nI]) $ Alltrim(cGrupos)
    	bAcesso := .T.
    EndIF     
Next nI
                     
IF !bAcesso
	MsgAlert('Usuário sem acesso a Tela !!')
	Return
EndIF                     
IF ZZH->ZZH_STATUS <> '4'
	MsgAlert('Não é possivel vincular nota para AR sem NF !!')
	Return
EndIF
      
nRecno      := Cad_NF()
IF nRecno <> 0
	SF1->(dbSetOrder(1))
	SF1->(dbGoTo(nRecno))
	RecLock("ZZH", .F. )
	ZZH->ZZH_DOC    := SF1->F1_DOC
	ZZH->ZZH_SERIE  := SF1->F1_SERIE
	ZZH->ZZH_STATUS := ZZH->ZZH_STATX
	ZZH->(MsUnLock())
	MsgAlert('Nota Atribuída ao AR !!')
EndIF
  
Return
***********************************************************************************************************************************************************888
Static Function Proc_Reabrir

Local cDocAnt   := ''
Local cSerieAnt := ''
Local nRecno    := 0
Local cTES 	    := GetMV('MGF_TAE07B',.F.,"03P")  

Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.                        
Private l103gAuto       := .T.

SF1->(dbSetOrder(1))
IF SF1->(dbSeek(ZZH->ZZH_FILIAL+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+Alltrim(ZZH->ZZH_FORNEC)+ZZH->ZZH_LOJA))
	cQuery := " Update "+RetSqlName("SD1")
	cQuery += " Set D1_SERVIC = D1_TES , D1_TES    = '"+Alltrim(cTES)+"'"
	cQuery += " Where D1_FILIAL  = '"+ZZH->ZZH_FILIAL+"'"
	cQuery += "   AND D1_DOC     = '"+ZZH->ZZH_DOC+"'"
	cQuery += "   AND D1_SERIE   = '"+ZZH->ZZH_SERIE+"'"
	cQuery += "   AND D1_FORNECE = '"+Alltrim(ZZH->ZZH_FORNEC)+"'"
	cQuery += "   AND D1_LOJA    = '"+ZZH->ZZH_LOJA+"'"
	cQuery += "   AND D_E_L_E_T_ = ' '"

	IF (TcSQLExec(cQuery) < 0)
		MsgStop(TcSQLError())
		Return
	EndIF

	aCabSF1    := {}
	aTotItem   := {}
	Aadd(aCabSF1,{"F1_FILIAL"     ,SF1->F1_FILIAL   ,Nil})
	Aadd(aCabSF1,{"F1_DOC"        ,SF1->F1_DOC      ,Nil})
	Aadd(aCabSF1,{"F1_SERIE"      ,SF1->F1_SERIE    ,Nil})
	Aadd(aCabSF1,{"F1_FORNECE"    ,SF1->F1_FORNECE  ,Nil})
	Aadd(aCabSF1,{"F1_LOJA"       ,SF1->F1_LOJA     ,Nil})
	Aadd(aCabSF1,{"F1_EMISSAO"    ,SF1->F1_EMISSAO  ,Nil})

	SD1->(dbSetOrder(1))
	SD1->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	While SD1->(!EOF()) .And. ;
		SD1->D1_FILIAL  == SF1->F1_FILIAL   .AND.;
		SD1->D1_DOC     == SF1->F1_DOC      .AND.;
		SD1->D1_SERIE   == SF1->F1_SERIE    .AND.;
		SD1->D1_FORNECE == SF1->F1_FORNECE  .AND.;
		SD1->D1_LOJA    == SF1->F1_LOJA
		
		aItem	    := {}
		SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
		//Aadd(aItem,{"D1_ITEM"       , SD1->D1_ITEM   ,Nil})
		Aadd(aItem,{"D1_COD"        ,SD1->D1_COD   ,Nil})
		Aadd(aItem,{"D1_QUANT"      ,SD1->D1_QUANT ,Nil})
		Aadd(aItem,{"D1_VUNIT"      ,SD1->D1_VUNIT ,Nil})
		Aadd(aItem,{"D1_TOTAL"      ,SD1->D1_TOTAL ,Nil})
		Aadd(aItem,{"D1_TES"        ,SD1->D1_TES 	,Nil})
		Aadd(aItem,{"D1_LOCAL"      ,SD1->D1_LOCAL 	,Nil})
		AAdd(aTotItem,aItem)
		SD1->(dbSkip())
	End
	cDocAnt   :=ZZH->ZZH_DOC
	cSerieAnt :=ZZH->ZZH_SERIE
	RecLock("ZZH", .F. )
	ZZH->ZZH_DOC    := ' '
	ZZH->ZZH_SERIE  := ' '
	ZZH->(MsUnLock())                      
	nRecno := ZZH->(Recno())
	MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,a,b)}, aCabSF1, aTotItem, 7,,)
	If lMsErroAuto
		aErro := GetAutoGRLog()
		cErro := ""
		For nI := 1 to Len(aErro)
			cErro += aErro[nI] + CRLF
		Next nI
		ZZH->(dbSetOrder(1))
		ZZH->(dbGoTo(nRecno))
		RecLock("ZZH", .F. )
		ZZH->ZZH_DOC    := cDocAnt
		ZZH->ZZH_SERIE  := cSerieAnt
		ZZH->(MsUnLock())                      
		cQuery := " Update "+RetSqlName("SD1")
		cQuery += " Set D1_TES = D1_SERVIC , D1_SERVIC = ' ' "
		cQuery += " Where D1_FILIAL  = '"+ZZH->ZZH_FILIAL+"'"
		cQuery += "   AND D1_DOC     = '"+ZZH->ZZH_DOC+"'"
		cQuery += "   AND D1_SERIE   = '"+ZZH->ZZH_SERIE+"'"
		cQuery += "   AND D1_FORNECE = '"+Alltrim(ZZH->ZZH_FORNEC)+"'"
		cQuery += "   AND D1_LOJA    = '"+ZZH->ZZH_LOJA+"'"
		cQuery += "   AND D_E_L_E_T_ = ' '"
		IF (TcSQLExec(cQuery) < 0)
			MsgStop(TcSQLError())
			Return
		EndIF
		MsgStop(cErro)
	Else
		ZZH->(dbSetOrder(1))
		ZZH->(dbGoTo(nRecno))
		RecLock("ZZH", .F. )
		ZZH->ZZH_DOCX   := cDocAnt
		ZZH->ZZH_SERIEX := cSerieAnt
		ZZH->ZZH_STATX  := ZZH->ZZH_STATUS
		ZZH->ZZH_DOC    := ' '
		ZZH->ZZH_SERIE  := ' '
		ZZH->ZZH_STATUS := '4'
		ZZH->(MsUnLock())
		MsgAlert('AR Desvinculado')
	Endif
	
EndIF

Return
******************************************************************************************************************************88
//Visualização de Log
USER FUNCTION TAE07_LOG //CRIADO RAFAEL 10/10/2018
	LOCAL cQuery:=""

	cQuery  := " SELECT Z1_ERRO,Z1_ID"
	cQuery  += " FROM "+RetSqlName('SZ1')
	cQuery  += " WHERE D_E_L_E_T_  = ' ' "
	cQuery  += "   AND Z1_FILIAL   = '"+ZZH->ZZH_FILIAL+"'"
	cQuery  += "   AND Z1_INTEGRA = '001'"
	cQuery  += "   and Z1_TPINTEG = '007'"
	cQuery  += "   and Z1_DOCORI  = '"+ZZH->ZZH_AR+"'"
	cQuery  += "   AND Z1_ID=(SELECT MAX(Z1_ID) FROM "+RetSqlName('SZ1')+" where Z1_INTEGRA = '001'
	cQuery  += "    and Z1_TPINTEG = '007'"
	cQuery  += "   and Z1_FILIAL = '"+ZZH->ZZH_FILIAL+"'"
	cQuery  += "    AND Z1_DOCORI = '"+ZZH->ZZH_AR+"'"
	cQuery  += "    AND D_E_L_E_T_= ' ' )"
	If Select("QRY_Z1") > 0
		QRY_Z1->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_Z1",.T.,.F.)
	dbSelectArea("QRY_Z1")
	ALERT("ULTIMO LOG: ID "+ALLTRIM(str(QRY_Z1->Z1_ID))+" - "+(QRY_Z1->Z1_ERRO))
	QRY_Z1->(dbCloseArea())
RETURN
**********************************************************************************************************************************************************
Static Function Cad_NF()

Local oBtn
Local oDlg3            
Local cQuery   := ''                
Local nRecno   := 0 

Private aNFProd    := {}
Private aRecNFProd := {}
Private oBrowNF     	

cQuery := " SELECT F1_FORNECE, F1_LOJA, F1_DOC , F1_SERIE	,F1_EMISSAO , SF1.R_E_C_N_O_ SF1RECNO "
cQuery += " FROM "+RetSQLName("SF1")+' SF1, '+RetSqlName("SD1")+' SD1 '
cQuery += " WHERE SD1.D_E_L_E_T_  = ' '  "
cQuery += "   AND D1_COD     <= '500000'  "
cQuery += "   AND D1_FILIAL  = F1_FILIAL  "
cQuery += "   AND D1_DOC     = F1_DOC     "
cQuery += "   AND D1_SERIE   = F1_SERIE   "
cQuery += "   AND D1_FORNECE = F1_FORNECE "
cQuery += "   AND D1_LOJA    = F1_LOJA    "
cQuery += "   AND F1_FILIAL  = '" + ZZH->ZZH_FILIAL + "' "
cQuery += "   AND F1_FORNECE = '" + Alltrim(ZZH->ZZH_FORNEC) + "' "
cQuery += "   AND SF1.D_E_L_E_T_ = ' ' "
cQuery += "   AND SF1.F1_TIPO in ( 'N','D') "
cQuery += "   AND F1_STATUS      <> ' ' "
cQuery += "   AND NOT EXISTS ( Select * "
cQuery += "                    From  "+RetSQLName("ZZH")+' ZZH'
cQuery += "                    Where ZZH.D_E_L_E_T_ = ' ' "
cQuery += "                      AND ZZH_FILIAL = F1_FILIAL "
cQuery += "                      AND Rtrim(ltrim(ZZH_FORNEC)) = Rtrim(ltrim(F1_FORNECE)) "
cQuery += "                      AND ZZH_LOJA   = F1_LOJA   "
cQuery += "                      AND ZZH_DOC    = F1_DOC    "
cQuery += "                      AND ZZH_SERIE  = F1_SERIE ) "
cQuery += " GROUP BY F1_FORNECE, F1_LOJA, F1_DOC , F1_SERIE	,F1_EMISSAO , SF1.R_E_C_N_O_ "
cQuery += " ORDER BY F1_DOC,F1_SERIE "
If Select("QRY_NF") > 0
	QRY_NF->(dbCloseArea())
EndIf

cQuery  := ChangeQuery(cQuery) 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_NF",.T.,.F.)
dbSelectArea("QRY_NF")

QRY_NF->(dbGoTop())
ZZP->(dbSetOrder(1))
While !QRY_NF->(EOF())
	aRec   := {}
	AAdd(aRec,QRY_NF->F1_FORNECE)
	AAdd(aRec,QRY_NF->F1_LOJA)
	AAdd(aRec,QRY_NF->F1_DOC)
	AAdd(aRec,QRY_NF->F1_SERIE)
	AAdd(aRec,STOD(QRY_NF->F1_EMISSAO))
	AAdd(aRec,QRY_NF->SF1RECNO)
	AADD(aNFProd,aRec)
	QRY_NF->(dbSkip())
EndDo

IF len(aNFProd) == 0 
    msgAlert('Não existe Nota para ser relacionada!!')
Else    

	DEFINE MSDIALOG oDlg3 TITLE "Escolha Nota Fiscal" FROM 000, 000  TO 340, 480 COLORS 0, 16777215 PIXEL
	
		@ 007, 005 LISTBOX oBrowNF	 Fields HEADER "Forncedor","Loja","Documento","Serie","Emissão" SIZE 233,147 OF oDlg3 COLORS 0, 16777215 PIXEL
		oBrowNF:SetArray(aNFProd)
		oBrowNF:nAt := 1
		oBrowNF:bLine := { || {aNFProd[oBrowNF:nAt,1],aNFProd[oBrowNF:nAt,2],aNFProd[oBrowNF:nAt,3],aNFProd[oBrowNF:nAt,4],aNFProd[oBrowNF:nAt,5]}}
		
		oBtn := TButton():New( 157, 005 ,'Confirmar' , oDlg3,{|| nRecno := aNFProd[oBrowNF:nAt,6],oDlg3:End() }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 157, 182 ,'Sair'      , oDlg3,{|| oDlg3:End()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		
	ACTIVATE MSDIALOG oDlg3 CENTERED
EndIF			
	
                   
Return nRecno



/*/{Protheus.doc} TAE07_FAR
Finalizar AR.
@type property

@author Marcos Cesar Donizeti Vieira
@since 01/08/2019
@version P12
/*/
Static Function TAE07_FAR 
Local _cFilial 	:= ZZI->ZZI_FILIAL
Local _cNumAr	:= ZZH->ZZH_AR 
Local _cAcao	:= '1'		// 1=Enceramento 2=Reabertura 4=Encerramento Transbordo      
Local _cPrefixo := ''
Local _cMens	:= ''
Local _lEncerra := .T.

dbSelectArea("ZZH")

IF SUBSTR(ZZH->ZZH_AR,1,1)=='S'
	RecLock("ZZH", .F. )
	ZZH->ZZH_STATUS  := '2'
	ZZH->(MsUnLock())
Else 
	_cAliasZZI	:= GetNextAlias()
	BeginSql Alias _cAliasZZI
		
		SELECT 
			ZZI.ZZI_AR
		FROM 
			%table:ZZI% ZZI
		WHERE
			ZZI.%notDel%
			AND ZZI.ZZI_FILIAL 	=  %exp:_cFilial%     
			AND ZZI.ZZI_AR 		=  %exp:_cNumAr%  
			AND ZZI.ZZI_QNF 	<> ZZI.ZZI_QCONT

	EndSql

	RecLock("ZZH", .F. )
	If (_cAliasZZI)->( Eof())
		ZZH->ZZH_STATUS  := '3'	
		_cMens	:= 'AR ALTERADO PARA O STATUS DE FINALIZADO.'
	Else
		ZZH->ZZH_STATUS  := '2'
		_cMens	:= 'AR ALTERADO PARA O STATUS DE DIVERGÊNCIA.'
	EndIf
	ZZH->(MsUnLock())
	
	_cPrefixo 	:= GetAdvFVal( "SF1", "F1_PREFIXO", _cFilial+ZZH->ZZH_DOC+ZZH->ZZH_SERIE+ALLTRIM(ZZH->ZZH_FORNEC)+ZZH->ZZH_LOJA,1,"" )
	 
	SE2->(dbSetOrder(6))	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO   
	SE2->(DbSeek(_cFilial+ZZH->ZZH_FORNEC+ZZH->ZZH_LOJA+_cPrefixo+ZZH->ZZH_DOC ))
	While SE2->(!Eof()) .And. SE2->E2_FILIAL=_cFilial .And. SE2->E2_FORNECE=ZZH->ZZH_FORNEC .And. SE2->E2_LOJA=ZZH->ZZH_LOJA .And. SE2->E2_PREFIXO=_cPrefixo .And. SE2->E2_NUM=ZZH->ZZH_DOC  
		RecLock("SE2", .F. )     
		SE2->E2_MSBLQL	:= '2'
		SE2->(MsUnLock())
		SE2->(dbSkip())
	EndDo                                                                                       

	MsgInfo(_cMens,'MARFRIG AVISA')

	//---Fechando area de trabalho
	(_cAliasZZI)->(dbcloseArea())
	
EndIF

Return