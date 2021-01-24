#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'     
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFFIN88
Autor...............: Marcelo Carneiro
Data................: 07/03/2018
Descricao / Objetivo: Tipo de Valor do Contas a Pagar
Doc. Origem.........: MIT044- CAP016 - Tipo de Valor
Solicitante.........: Cliente - Mauricio CAP
Uso.................: Marfrig
Obs.................: Chamado pelo programa FIN050 onde .T. permite incluir
=====================================================================================
*/
User Function MGFFIN88(bInclui) 
                   
Private oDlg
Private oBrowse
Private oBtn          
Private aLisTV  := {}
Private nValLiq := SE2->E2_VALOR  - SE2->E2_DECRESC + SE2->E2_ACRESC
Private nValA   := SE2->E2_ACRESC
Private nValD   := SE2->E2_DECRESC

ChkFile('ZDR')
ChkFile('ZDS')
dbSelectArea('SA2')
SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial('SA2')+SE2->E2_FORNECE+SE2->E2_LOJA))

Carrega_Dados()

DEFINE MSDIALOG oDlg TITLE "Tipo de Valor" FROM 000, 000  TO 320, 650 COLORS 0, 16777215 PIXEL    
  
  	@ 010, 005 SAY  "Titulo:"           SIZE 041, 010 OF oDLG                       COLORS 0, 16777215 PIXEL
	@ 008, 040 MSGET  SE2->E2_NUM       SIZE 040, 010 OF oDLG When .F. PICTURE "@!" COLORS 0, 16777215 PIXEL
  	@ 010, 095 SAY  "Parcela:"          SIZE 041, 010 OF oDLG                       COLORS 0, 16777215 PIXEL
	@ 008, 120 MSGET  SE2->E2_PARCELA   SIZE 030, 010 OF oDLG When .F. PICTURE "@!" COLORS 0, 16777215 PIXEL
  	@ 025, 005 SAY  "Tipo:"             SIZE 041, 010 OF oDLG                       COLORS 0, 16777215 PIXEL
	@ 023, 040 MSGET  SE2->E2_TIPO      SIZE 020, 010 OF oDLG When .F. PICTURE "@!" COLORS 0, 16777215 PIXEL
  	@ 025, 095 SAY  "Prefixo:"          SIZE 041, 010 OF oDLG                       COLORS 0, 16777215 PIXEL
	@ 023, 120 MSGET  SE2->E2_PREFIXO   SIZE 030, 010 OF oDLG When .F. PICTURE "@!" COLORS 0, 16777215 PIXEL
	@ 040, 005 SAY  "Fornecedor:"       SIZE 041, 010 OF oDLG                       COLORS 0, 16777215 PIXEL
	@ 038, 040 MSGET  SE2->E2_FORNECE   SIZE 040, 010 OF oDLG When .F. PICTURE "@!" COLORS 0, 16777215 PIXEL
  	@ 040, 095 SAY  "Loja:"             SIZE 041, 010 OF oDLG                       COLORS 0, 16777215 PIXEL
	@ 038, 120 MSGET  SE2->E2_LOJA      SIZE 030, 010 OF oDLG When .F. PICTURE "@!" COLORS 0, 16777215 PIXEL
	@ 055, 005 MSGET  SA2->A2_NOME      SIZE 145, 010 OF oDLG When .F. PICTURE "@!" COLORS 0, 16777215 PIXEL

	
	@ 022, 190 SAY  "Valor Original:"   SIZE 061, 010 OF oDLG                                     COLORS 0, 16777215 PIXEL
	@ 020, 240 MSGET  SE2->E2_VALOR     SIZE 070, 010 OF oDLG When .F. PICTURE '@E 99,999,999.99' COLORS 0, 16777215 PIXEL

	@ 037, 190 SAY  "Total Acréscimo:"  SIZE 061, 010 OF oDLG                                     COLORS 0, 16777215 PIXEL
	@ 035, 240 MSGET nValA     			SIZE 070, 010 OF oDLG When .F. PICTURE '@E 99,999,999.99' COLORS 0, 16777215 PIXEL

	@ 052, 190 SAY  "Total Decréscimo:" SIZE 061, 010 OF oDLG                                     COLORS 0, 16777215 PIXEL
	@ 050, 240 MSGET  nValD   			SIZE 070, 010 OF oDLG When .F. PICTURE '@E 99,999,999.99' COLORS 0, 16777215 PIXEL

	@ 067, 190 SAY  "Valor Líquido:"    SIZE 061, 010 OF oDLG                                     COLORS 0, 16777215 PIXEL
	@ 065, 240 MSGET  nValLiq           SIZE 070, 010 OF oDLG When .F. PICTURE '@E 99,999,999.99' COLORS 0, 16777215 PIXEL
	
	//@ 080, 003 LISTBOX oBrowse   SIZE 320,060 OF oDlg PIXEL ColSizes 50,50
	oBrowse := TWBrowse():New( 080, 003,  320, 060,,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oBrowse:SetArray(aLisTV)
	oBrowse:nAt := 1
	oBrowse:bLine := { || {aLisTV[oBrowse:nAt,1], ;
						   aLisTV[oBrowse:nAt,2],; 
						   aLisTV[oBrowse:nAt,3],; 
						   aLisTV[oBrowse:nAt,4],; 
						   aLisTV[oBrowse:nAt,5],; 
						   aLisTV[oBrowse:nAt,6]}}
						   //nColPos
	bColor := &("{|| if(oBrowse:nColPos ==  5,"+Str(CLR_LIGHTGRAY)+","+Str(CLR_WHITE)+")}")
	oBrowse:SetBlkBackColor(bColor)

	bColor := &("{|| if(oBrowse:nColPos ==  5,"+Str(CLR_WHITE)+","+Str(CLR_BLACK)+")}")
	oBrowse:SetBlkColor(bColor)

	
	oBrowse:addColumn(TCColumn():new(""         ,{||aLisTV[oBrowse:nAt][01]},"@!" ,,,"LEFT" , 1,.T.,.F.,,,,,))
	oBrowse:addColumn(TCColumn():new("Cód."     ,{||aLisTV[oBrowse:nAt][02]},"@!" ,,,"LEFT"  ,20,.F.,.F.,,,,,))
	oBrowse:addColumn(TCColumn():new("Descrição",{||aLisTV[oBrowse:nAt][03]},"@!" ,,,"LEFT"  ,70,.F.,.F.,,,,,))
	oBrowse:addColumn(TCColumn():new("Tipo"     ,{||aLisTV[oBrowse:nAt][04]},"@!" ,,,"LEFT"  ,20,.F.,.F.,,,,,))
	oBrowse:addColumn(TCColumn():new("Valor"    ,{||aLisTV[oBrowse:nAt][05]},"@E 999,999,999.99" ,,,"RIGHT" ,40,.F.,.F.,,,,,))
	oBrowse:addColumn(TCColumn():new("Historico",{||aLisTV[oBrowse:nAt][06]},"@!" ,,,"LEFT"  ,100,.F.,.F.,,,,,))

	
	
	IF bInclui .AND. ALTERA
		oBtn := TButton():New( 145, 003, "Incluir"  ,oDlg,{|| Cad_ZDS(1)}   ,050,011,,,,.T.,,"",,,,.F. )
		oBtn := TButton():New( 145, 058, "Alterar"  ,oDlg,{|| Cad_ZDS(2)}   ,050,011,,,,.T.,,"",,,,.F. )
		oBtn := TButton():New( 145, 270, "Excluir"  ,oDlg,{|| Cad_ZDS(3)}   ,050,011,,,,.T.,,"",,,,.F. )
	EndIF
	oBtn := TButton():New( 003, 270, "Sair"     ,oDlg,{|| oDlg:End()}   ,050,011,,,,.T.,,"",,,,.F. )

ACTIVATE MSDIALOG oDlg CENTERED

Return 
*************************************************************************************************************************************************************
Static Function Carrega_dados()

Local aRec      := {}     
Local oVerde    := LoadBitmap(GetResources(),'BR_VERDE') 
Local oRed      := LoadBitmap(GetResources(),'BR_VERMELHO') 


aLisTV := {}
dbSelectArea('ZDR')
ZDR->(dbSetOrder(1))
      
dbSelectArea('ZDS')
ZDS->(dbSetOrder(1))
ZDS->(dbSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
While ZDS->(!Eof()) .And.        ;
      SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) == ;
      ZDS->(ZDS_FILIAL+ZDS_PREFIX+ZDS_NUM+ZDS_PARCEL+ZDS_TIPO+ZDS_FORNEC+ZDS_LOJA ) 
                     
     aRec := {} 
     IF ZDR->(dbSeek(xFilial('ZDR')+ZDS->ZDS_COD))
        AAdd(aRec,IIF(ZDR->ZDR_TIPO == 'A',oVerde,oRed))
        AAdd(aRec,ZDS->ZDS_COD)
        AAdd(aRec,ZDR->ZDR_DESC)
        AAdd(aRec,IIF(ZDR->ZDR_TIPO == 'A','Acréscimo','Decréscimo'))
        AAdd(aRec,ZDS->ZDS_VALOR)
        AAdd(aRec,ZDS->ZDS_HISTOR)
        AAdd(aRec,ZDS->(Recno()))
	    AADD(aLisTV,aRec)
	 EndIF
     ZDS->(dbSkip())
End       
IF Len(aLisTV) == 0 
    aLisTV := {{oVerde,'','','',0,'',0}}
EndIF

Return
*****************************************************************************************************************************************
Static Function Cad_ZDS(nTipo)

Local aRet			:= {}
Local aParambox		:= {}
Local aCampos       := {}
Local cTudoOk 		:= "(U_FIN88VL())"

Private cAlias   := 'ZDS'
Private nOpc     := 4
Private aButtons := {}
Private nReg     :=  0


      
IF SE2->E2_VALOR <> SE2->E2_SALDO
     MsgAlert('Ação não é possivel, motivo : O Titulo sofreu baixa !!')
	 Return
EndIF
IF SE2->E2_MOEDA <> 1
     MsgAlert('Ação não é possivel, motivo : Moeda do Titulo !!')
	 Return
EndIF
IF Alltrim(SE2->E2_TIPO) $ 'PA#NDF'
     MsgAlert('Ação não é possivel, motivo : Adiantamento !!')
	 Return
EndIF

IF nTipo == 1 //Inclusão
		dbSelectArea('ZDR')
		cAlias   := 'ZDS'
		nOpc     := 3
		aButtons := {}
		nReg     := 0
		aCampos  := {'ZDS_COD','ZDS_DESC','ZDS_VALOR','ZDS_HISTOR','NOUSER'}
		IF AxInclui(cAlias,nReg,nOpc,aCampos,,,cTudoOk) == 1
				/*Reclock("ZDS",.T.)
				ZDS->ZDS_FILIAL := SE2->E2_FILIAL
				ZDS->ZDS_PREFIX := SE2->E2_PREFIXO
				ZDS->ZDS_NUM    := SE2->E2_NUM
				ZDS->ZDS_PARCEL := SE2->E2_PARCELA
				ZDS->ZDS_TIPO   := SE2->E2_TIPO
				ZDS->ZDS_FORNEC := SE2->E2_FORNECE
				ZDS->ZDS_LOJA   := SE2->E2_LOJA
				ZDS->ZDS_COD    := M->ZDS_COD
				ZDS->ZDS_VALOR  := M->ZDS_VALOR
				ZDS->ZDS_HISTOR := M->ZDS_HISTOR
				ZDS->ZDS_LA     := 'N'
				ZDS->ZDS_LAE    := 'N'
				ZDS->(MsUnlock())
				  */
				aRet := U_MFIN88SUM()
				Reclock("SE2",.F.)
				SE2->E2_DECRESC  := aRet[02] + SE2->E2_ZVARPA
				SE2->E2_ACRESC   := aRet[01] + SE2->E2_ZVARAT
				SE2->(MsUnlock())
				
				nValLiq := SE2->E2_VALOR  - SE2->E2_DECRESC + SE2->E2_ACRESC
				nValA   := SE2->E2_ACRESC
				nValD   := SE2->E2_DECRESC
				
				Carrega_Dados()
				Brow_Refresh()
		EndIF
ElseIF nTipo == 2 // Alteração
	IF aLisTV[oBrowse:nAt,7] <> 0
		ZDS->(dbGoTo(aLisTV[oBrowse:nAt,7]))
		cAlias   := 'ZDS'
		nOpc     := 4
		aButtons := {}
		nReg     := aLisTV[oBrowse:nAt,7]
		aCampos  := {'ZDS_VALOR','ZDS_HISTOR'}
		IF AxAltera(cAlias,nReg,nOpc, ,aCampos ,,,,,,aButtons) == 1
			aRet := U_MFIN88SUM()
			Reclock("SE2",.F.)
			SE2->E2_DECRESC  := aRet[02] + SE2->E2_ZVARPA
			SE2->E2_ACRESC   := aRet[01] + SE2->E2_ZVARAT
			SE2->(MsUnlock())
			
			nValLiq := SE2->E2_VALOR  - SE2->E2_DECRESC + SE2->E2_ACRESC
			nValA   := SE2->E2_ACRESC
			nValD   := SE2->E2_DECRESC
			
			Carrega_Dados()
			Brow_Refresh()
		EndIF
	EndIF
ElseIF nTipo == 3 // Exclusão
	IF aLisTV[oBrowse:nAt,7] <> 0 .And. MsgYESNO('Deseja Excluir o Tipo de Valor ?')
		ZDS->(dbGoTo(aLisTV[oBrowse:nAt,7]))
		Reclock("ZDS",.F.)
		ZDS->(dbDelete())
		ZDS->(MsUnlock())
		
		aRet := U_MFIN88SUM()
		Reclock("SE2",.F.)
		SE2->E2_DECRESC  := aRet[02] + SE2->E2_ZVARPA
		SE2->E2_ACRESC   := aRet[01] + SE2->E2_ZVARAT
		SE2->(MsUnlock())
		
		nValLiq := SE2->E2_VALOR  - SE2->E2_DECRESC + SE2->E2_ACRESC
		nValA   := SE2->E2_ACRESC
		nValD   := SE2->E2_DECRESC
		
		Carrega_Dados()
		Brow_Refresh()
	EndIF
EndIF

Return                   
*******************************************************************************************************************************
User Function FIN88VL()

Local lRet := .T.

If !ExistCPO('ZDR',M->ZDS_COD,1)
	//IF AScan(aLisTV,{|x|  Alltrim(x[2]) == Alltrim(M->ZDS_COD) }) <> 0
    //    MsgAlert('Tipo de Valor já Cadastrado !!')
	//	lRet := .F.
	//EndIF
//Else                                              
	MsgAlert('Tipo de Valor não Cadastrado !!')
	lRet := .F.
Endif

IF lRet .And. ZDR->(dbSeek(xFilial('ZDR')+M->ZDS_COD))
	IF ZDR->ZDR_TIPO == 'D'
		IF nValLiq - M->ZDS_VALOR <= 0
			MsgAlert('O Valor de decrescimo irá zerar o valor do Titulo !!')
			Return
		EndIF
	EndIF
EndIF


Return lRet
***********************************************************************************************************************************
Static Function Brow_Refresh
      
oBrowse:SetArray(aLisTV)
oBrowse:nAt := 1
oBrowse:bLine := { || {aLisTV[oBrowse:nAt,1], ;
aLisTV[oBrowse:nAt,2],;
aLisTV[oBrowse:nAt,3],;
aLisTV[oBrowse:nAt,4],;
aLisTV[oBrowse:nAt,5],;
aLisTV[oBrowse:nAt,6]}}
oBrowse:Refresh()


Return
****************************************************************************************************************************************
User Function MFIN88SUM()
Local nPos := 0
Local nNeg := 0 
                  
ZDR->(dbSetOrder(1))
dbSelectArea('ZDS')
ZDS->(dbSetOrder(1))
ZDS->(dbSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
While ZDS->(!Eof()) .And.;
      SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) == ;
      ZDS->(ZDS_FILIAL+ZDS_PREFIX+ZDS_NUM+ZDS_PARCEL+ZDS_TIPO+ZDS_FORNEC+ZDS_LOJA ) 
                     
     IF ZDR->(dbSeek(xFilial('ZDR')+ZDS->ZDS_COD))
        IF ZDR->ZDR_TIPO == 'A'
           nPos += ZDS->ZDS_VALOR
        Else 
           nNeg += ZDS->ZDS_VALOR
        EndIF
	 EndIF
     ZDS->(dbSkip())
End       
Return {nPos,nNeg}


	/*	
	AAdd(aParamBox, {1, "Tipo de Valor :"	, Space(03) , "@!"," U_FIN88VL() "      ,"MGFZDR" ,, 020	, .T.	})
	AAdd(aParamBox, {1, "Valor :"	        , 0         , '@E 99,999,999.99',       ,""	   ,, 070	, .T.	})
	AAdd(aParamBox, {1, "Histórico:"        , Space(100), "@!",                     ,      ,, 100	, .T.	})
	IF ParamBox(aParambox, "Inclusão do Tipo de Valor no Titulo"	, @aRet, , , .T. , 0, 0, , , .T. , .T. )*/
                                                           	