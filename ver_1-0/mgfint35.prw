#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'COLORS.CH'
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFINT35
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integração De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Roteiro de Aprovação   
=====================================================================================
*/
User Function MGFINT35 
                
Local GoEscolha
Local oEscolha

Private nEscolha  
Private oDlg1
Private oButton

oDlg1      := MSDialog():New( 092,232,200,560,"Escolha o Tipo de Roteiro",,,.F.,,,,,,.T.,,,.T. )
GoEscolha  := TGroup():New( 004,004,050,096,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oEscolha   := TRadMenu():New( 008,010,{"Normal","Alteracao por Aba"},{|u| If(PCount()>0,nEscolha:=u,nEscolha)},oDlg1,,,CLR_BLACK,CLR_WHITE,"",,,072,26,,.F.,.F.,.T. )
oButton    := TButton():New( 008,104,"Roteiro",oDlg1,{||Def_Roteiro(nEscolha)}, 50,11,,,.F.,.T.,.F.,,.F.,,,.F. )
oDlg1:Activate(,,,.T.)

Return
*******************************************************************************************************************************************************
Static Function Def_Roteiro(nTipo) // nTipo = 1 Inclusão  nTipo = 2 Alteracao

Static oDlg                                                                 

Private aCad         := {}
Private oBrowseDados                                                     
Private aRoteiro     := {}
Private oCombCad     
Private cCombCAd     := ''
Private nTipoRot     := nTipo   
Private aTab         :={{1,'SA1'},{2,'SA2'},{3,'SB1'}}


ChkFile('ZB6')
dbSelectArea('ZB6')
dbSetOrder(1)

ChkFile('ZB4')
dbSelectArea('ZB4')
dbSetOrder(1)             
               
IF nTipoRot == 1
    aCad := {'1=Clientes','2=Endereço de Entrega', '3=Fornecedores','4=Trasportadoras','5=Vendendor','6=Veiculos','7=Motoristas','8=Produto'}
Else 
    aCad := {'1=Clientes', '3=Fornecedores','8=Produto'}
EndIF

DEFINE MSDIALOG oDlg TITLE "Roteiro de Aprovação - "+IIF(nTipoRot==1,'Inclusão','Alteração') FROM 000, 000  TO 310, 370 COLORS 0, 16777215 PIXEL

    cCombCad:= aCad[1]           
	oCombCad := TComboBox():New(06,06,{|u|if(PCount()>0,cCombCad:=u,cCombCad)},aCad,180,20,oDlg,,{||Atualiza_Browse(), Refresh_Browse()},,,,.T.,,,,,,,,,'cCombCad')

	Atualiza_Browse()     

    oBrowseDados := TWBrowse():New( 030, 006,125,120,,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
	oBrowseDados:SetArray(aRoteiro)
	IF nTipoRot == 1
		cbLine := "{||{ aRoteiro[oBrowseDados:nAt,01], aRoteiro[oBrowseDados:nAt,02]} }"
	Else
		cbLine := "{||{ aRoteiro[oBrowseDados:nAt,01], aRoteiro[oBrowseDados:nAt,02], aRoteiro[oBrowseDados:nAt,05]} }"
    EndIF
	oBrowseDados:bLine       := &cbLine            
	
	oBrowseDados:addColumn(TCColumn():new("Seq."    ,{||aRoteiro[oBrowseDados:nAt][01]},"@!",,,"LEFT"  ,20,.F.,.F.,,,,,))
	oBrowseDados:addColumn(TCColumn():new("Setor"   ,{||aRoteiro[oBrowseDados:nAt][02]},"@!",,,"LEFT"  ,50,.F.,.F.,,,,,))
	IF nTipoRot == 2
		oBrowseDados:addColumn(TCColumn():new("Aba"   ,{||aRoteiro[oBrowseDados:nAt][05]},"@!",,,"LEFT"  ,50,.F.,.F.,,,,,))
	EndIF
	oBrowseDados:Setfocus()    
    
    oButton := TButton():New( 030, 135, "Incluir" ,oDlg,{||INT35_Inclui()}, 50,11,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton := TButton():New( 042, 135, "Excluir" ,oDlg,{||INT35_Exclui()}, 50,11,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton := TButton():New( 138, 135, "Sair"    ,oDlg,{||oDlg:End()}, 50,11,,,.F.,.T.,.F.,,.F.,,,.F. )      
                                                 
ACTIVATE MSDIALOG oDlg CENTERED

Return                              
********************************************************************************************************************************
Static Function Atualiza_Browse()
Local aReg     := {}                                           
Local nPos     := 0 
Local cProcura := ''
dbSelectArea('SXA')
SXA->(dbSetOrder(1))      
    
IF nTipoRot == 1               
    cProcura := Alltrim(Str(oCombCad:nAT))   
Else
    cProcura := IIF(oCombCad:nAT == 1, '1',IIF(oCombCad:nAT == 2,'3','8'))                   
EndIF
dbSelectArea('ZB6')
ZB6->(dbSetOrder(1))      
aRoteiro     := {}
ZB4->(dbSeek(cProcura))
While ZB4->(!EOF()) .And.  ZB4->ZB4_CAD == cProcura
	aReg := {} 
	IF nTipoRot == 1 .AND. ZB4->ZB4_TIPO <> 'A' 
	    AAdd(aReg, ZB4->ZB4_SEQ)
	    IF ZB6->(dbSeek(ZB4->ZB4_IDSET))
	        AAdd(aReg, ZB6->ZB6_NOME)
	    Else 
	        AAdd(aReg, 'Não Encontrado')
	    EndIF
	    AAdd(aReg, ZB4->ZB4_IDSET)
	    AAdd(aReg, ZB4->(Recno()))
	    AAdd(aRoteiro,aReg)
    EndIF
    IF nTipoRot == 2 .AND. ZB4->ZB4_TIPO == 'A' 
	    AAdd(aReg, ZB4->ZB4_SEQ)
	    IF ZB6->(dbSeek(ZB4->ZB4_IDSET))
	        AAdd(aReg, ZB6->ZB6_NOME)
	    Else 
	        AAdd(aReg, 'Não Encontrado')
	    EndIF                          
	    AAdd(aReg, ZB4->ZB4_IDSET)
	    AAdd(aReg, ZB4->(Recno()))      
	    nPos := aScan(aTab,{|x| x[1] == oCombCad:nAT} ) 
	    IF SXA->(dbSeek(aTab[nPos,02]+ZB4->ZB4_ABA))
	        AAdd(aReg, SXA->XA_DESCRIC)
	    Else 
	        IF ZB4->ZB4_ABA = ' '
	           AAdd(aReg, 'Outros')
	        Else
	           AAdd(aReg, 'Não Encontrado')
	        EndIF
	    EndIF                          
	    AAdd(aReg, ZB4->ZB4_ABA)
	    AAdd(aRoteiro,aReg)
    EndIF
    ZB4->(dbSkip())                                                                                            
End
IF Len(aRoteiro) == 0 
    aRoteiro :={{'0',"","",0,""}}
EndIF                   

Return
*****************************************************************************************************************
Static Function INT35_Inclui
Local cSeq  := ''
Local aResp := {}
                
IF nTipoRot == 1
	IF ConPad1(,,,'ZB6')       
	    IF aRoteiro[1,1] == '0' 
	        cSeq := '01'
	    Else
	        cSeq := Soma1(aRoteiro[Len(aRoteiro),1])
	    EndIF                                             
	    RecLock("ZB4", .T.)
		ZB4->ZB4_CAD    := Alltrim(Str(oCombCad:nAT))
		ZB4->ZB4_SEQ	:= cSeq 
		ZB4->ZB4_IDSET	:= ZB6->ZB6_ID 
		ZB4->(msUnlock())
		
		Atualiza_Browse()           
		Refresh_Browse()
	EndIF
Else     
	IF ConPad1(,,,'ZB6')       
	    aResp := INT35_ABA()
	    IF aResp[01]
		    IF aRoteiro[1,1] == '0' 
		        cSeq := '01'
		    Else
		        cSeq := Soma1(aRoteiro[Len(aRoteiro),1])
		    EndIF                                             
		    RecLock("ZB4", .T.)
			ZB4->ZB4_CAD    := IIF(oCombCad:nAT == 1, '1',IIF(oCombCad:nAT == 2,'3','8'))
			ZB4->ZB4_SEQ	:= cSeq 
			ZB4->ZB4_IDSET	:= ZB6->ZB6_ID 
			ZB4->ZB4_ABA	:= aResp[02]
			ZB4->ZB4_TIPO	:= 'A'
			ZB4->(msUnlock())
			
			Atualiza_Browse()           
			Refresh_Browse()
		EndIF
	EndIF

EndIF

************************************************************************88
Static Function Refresh_Browse()

oBrowseDados:SetArray(aRoteiro)
IF nTipoRot == 1
	cbLine := "{||{ aRoteiro[oBrowseDados:nAt,01], aRoteiro[oBrowseDados:nAt,02]} }"
Else
	cbLine := "{||{ aRoteiro[oBrowseDados:nAt,01], aRoteiro[oBrowseDados:nAt,02], aRoteiro[oBrowseDados:nAt,05]} }"
EndIF
oBrowseDados:bLine       := &cbLine
oBrowseDados:Refresh()

Return
*****************************************************************************************************************
Static Function INT35_Exclui
Local cSeq := '01'

IF aRoteiro[oBrowseDados:nAt,04] <> 0  .And. MsgYESNO('Exclui Sequencia do Roteiro?')
    ZB4->(dbGoTo(aRoteiro[oBrowseDados:nAt,04]))
    Reclock("ZB4",.F.)
	ZB4->(dbDelete())
	ZB4->(MsUnlock())

	ZB4->(dbSeek(Alltrim(Str(oCombCad:nAT))))
	While ZB4->(!EOF()) .And.  ZB4->ZB4_CAD == Alltrim(STR(oCombCad:nAT))
	    IF nTipoRot == 1 .AND. ZB4->ZB4_TIPO <> 'A' .OR. nTipoRot == 2 .AND. ZB4->ZB4_TIPO == 'A' 
		    RecLock("ZB4", .F.)
			ZB4->ZB4_SEQ	:= cSeq 
			ZB4->(msUnlock())
	        cSeq := Soma1(cSeq)
	    EndIF
	    ZB4->(dbSkip())                                                                                            
	End

	Atualiza_Browse()           
	Refresh_Browse()
	
EndIF                           

Return

******************************************************************************************************************************************************************
Static Function INT35_ABA
Local oBtn
Local oDlg1            
Local aRet := { .F. , ' '}

Private aAba      := {}
Private oListABA  := {}	

Dados_ABA()

DEFINE MSDIALOG oDlg1 TITLE "Escolha a Aba do Cadastro" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL

	@ 007, 005 LISTBOX oListABA	 Fields HEADER "Abas Disponiveis" SIZE 143,127 OF oDlg1 COLORS 0, 16777215 PIXEL
	oListABA:SetArray(aAba)
	oListABA:nAt := 1
	oListABA:bLine := { || {aAba[oListABA:nAt,1]}}
	
	oBtn := TButton():New( 137, 005 ,'Incluir'    , oDlg1,{|| aRet := { .T. , aAba[oListABA:nAt,2]},oDlg1:End()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	
ACTIVATE MSDIALOG oDlg1 CENTERED

Return aRet
*********************************************************************************************************************************************
Static Function Dados_ABA
  
aAba    :={}       
nPos := aScan(aTab,{|x| x[1] == oCombCad:nAT} ) 

SXA->(dbSeek(aTab[nPos,02]))	    
While !SXA->(EOF()) .And. SXA->XA_ALIAS == aTab[nPos,02]
    AADD(aAba,{SXA->XA_DESCRIC,SXA->XA_ORDEM })
    SXA->(dbSkip())
EndDo       

AADD(aAba,{"Outros",' '})

Return

