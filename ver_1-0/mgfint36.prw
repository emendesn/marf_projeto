#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE 'FWCALENDARWIDGET.CH'
  
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa............: MGFINT36
Autor...............: Marcelo Carneiro
Data................: 28/03/2017
Descricao / Objetivo: Integração De Cadastros
Doc. Origem.........: Contrato GAPS - MIT044- BLOQUEIO DE CADASTROS
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Cadastro de Feriados e Finais de Semana
=====================================================================================
*/
User Function MGFINT36 
 
Private cCadastro := "Tabela de Feriados e Finais de Semana"     
Private cDelFunc  := ".T."            
Private aRotina   := { {"Pesquisar" ,"AxPesqui" ,0,1},;
		               {"Visualizar","AxVisual" ,0,2},;
		               {"Incluir"   ,"AxInclui" ,0,3},;
		               {"Excluir"   ,"AxDeleta" ,0,5},;
		               {"Horario"   ,"U_INT35_HOR()" ,0,2},;
		               {"Inclui Datas", "U_INT35_DAT()" ,0,3} }
Private aIndexNF   := {}
Private cFiltro    := ''
Private bFiltraBrw := ''
     

ChkFile('ZB5')
dbSelectArea('ZB5')
ZB5->(dbSetOrder(1))

mBrowse( 6,1,22,75,"ZB5")

Return                                                   
**************************************************************************************************************************************************
User Function INT35_DAT
      
Private oDlg
Private cFilData := Space(6)                  
Private aDatSel  := {}             
Private oCalend

DEFINE MSDIALOG oDlg TITLE "Inclui Varias Datas"  FROM 000, 000  TO 220, 295 COLORS 0, 16777215 PIXEL


@ 006, 006 SAY "Filial : " SIZE 052, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 006, 025 MSGet cFilData   SIZE 052, 007 OF oDlg PICTURE "@!" COLORS 0, 16777215 F3 "SM0" VALID Vazio() .Or. ExistCpo("SM0",cEmpAnt+cFilData) PIXEL 


oCalend := MsCalend():New(020, 005, oDlg, .T.)         
oCalend:dDiaAtu := Date()                          
oCalend:ColorDay( 1, CLR_HRED )      
oCalend:bChange    := {|| Inclui_Data()}       
oCalend:bChangeMes := {|| aDatSel  := {}, oCalend:DelAllRestri() }                
oBtn := TButton():New( 92, 006  ,"Confirmar",   oDlg,{|| Grava_Data() }           ,50, 11,,,.F.,.T.,.F.,,.F.,,,.F. )      
oBtn := TButton():New( 92, 095  ,"Sair",        oDlg,{|| oDlg:End() }             ,50, 11,,,.F.,.T.,.F.,,.F.,,,.F. )      

ACTIVATE MSDIALOG oDlg CENTERED
                                           
Return
*****************************************************************************************************************************
Static Function Grava_Data
Local nI   := 0 
               
IF MsgYESNO('Atualizar estas Datas?')
	For nI := 1 to Len(aDatSel)
		IF aDatSel[nI] <> CTOD('01/01/1900')
			IF ZB5->(!dbSeek(cFilData+DTOS(aDatSel[nI])))
				RecLock("ZB5", .T.)
				ZB5->ZB5_DATA   := aDatSel[nI]
				ZB5->ZB5_FILDAT	:= cFilData
				ZB5->(msUnlock())
			EndIF
		EndIF
	Next nI
	oCalend:DelAllRestri()
EndIF

Return
*****************************************************************************************************************************
Static Function Inclui_Data
Local bPassou := .T.
Local nPos    := 0 
               
IF Len(aDatSel) > 0
    nPos := aScan(aDatSel,{|x| x == oCalend:dDiaAtu} ) 
	IF nPos  <> 0
	     bPassou := .F.                             
	     oCalend:DelRestri(DAY(oCalend:dDiaAtu))
	     aDatSel[nPos]:= CTOD('01/01/1900')
	EndIF
EndIF
IF bPassou
	AAdd(aDatSel ,oCalend:dDiaAtu )
	oCalend:AddRestri(DAY(oCalend:dDiaAtu), CLR_GREEN,CLR_GREEN)
EndIF
	
Return
*****************************************************************************************************************************
User Function INT36_Vld()
Local bRet := .T.

IF ZB5->(dbSeek(M->ZB5_FILDAT+DTOS(M->ZB5_DATA)))
      MsgAlert('Data já cadastrada !!')
      bRet := .F.
EndIF
Return bRet                                                                                                                   
                   

*****************************************************************************************************************************
User Function INT35_HOR()

Local aRet			:= {}
Local aParambox		:= {}
Local cHoraIni      := PADR(getMv("MGF_CAD041"),5)
Local cHoraFim      := PADR(getMv("MGF_CAD042"),5)


AAdd(aParamBox, {1, "Hora Inicio"		, cHoraIni, 							, , 		,	, 070	, .T.	})
AAdd(aParamBox, {1, "Hora Final"		, cHoraFim, 							, , 		,	, 070	, .T.	})
IF ParamBox(aParambox, "Hora do Expediente"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
     PutMv("MGF_CAD041",MV_PAR01)
     PutMv("MGF_CAD042",MV_PAR02)
EndIF
Return