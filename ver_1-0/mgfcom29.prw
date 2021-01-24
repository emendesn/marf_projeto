#Include 'Protheus.ch'
#Include 'Rwmake.ch'

/*
=====================================================================================
Programa............: MA110BAR
Autor...............: Flávio Dentello
Data................: 17/04/2017
Descrição / Objetivo: GAP COM02
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=51249528
=====================================================================================
*/     

/// Função que apresenta a descrição do produto na solicitação de compras
User Function MGFCOM29() 
Local cDescr := ""                    
Local oDlgLog
Local cMemLog
Local cNewFil := ""
//Local cMskFil := STR0026
Local oFntLog  
local oDesc                                      
Local cProd := SC1->C1_PRODUTO

//If ACOLS[n,1]<>""
If SC1->C1_PRODUTO <> ""     
	dBSelectArea("SB1")
	SB1->(dbSetOrder(1))
  //	If SB1->(dbSeek( XFILIAL("SB1")+ acols[n,2])) 
	If SB1->(dbSeek( XFILIAL("SB1")+ cProd)) 
		cDescr := SB1->B1_ZPRODES
		U_COM29A(cDescr)
	EndIf
EndIf
Return                   

User Function COM29A(cDescr)

Local 	cDescri  := Space(500)
Local	Odlg
Private lOk,lCancel

	cDescri := cDescr 
	DEFINE DIALOG oDlg TITLE "Descrição do Produto" FROM 180,180 TO 450,1000 PIXEL 

	@ 25,58 GET oDesc var cDescri memo SIZE 300,80 OF oDlg PIXEL
	@ 26,08 SAY "Descrição:" SIZE  260,80 OF oDlg PIXEL                                                                                                                  
	oTButton := TButton():New( 120, 270, "&OK",oDlg	,{|| lOk:= .T., oDlg:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	ACTIVATE DIALOG oDlg CENTERED

Return                                                                   


//// Função que apresenta a descrição do produto no pedido de compras

User Function MGFCOMP() 
Local cDescr := ""                    
Local oDlgLog
Local cMemLog
Local cNewFil := ""
//Local cMskFil := STR0026
Local oFntLog  
local oDesc

//If ACOLS[n,1]<>""
If SC7->C7_PRODUTO <> ""     
	dBSelectArea("SB1")
	SB1->(dbSetOrder(1))
  //	If SB1->(dbSeek( XFILIAL("SB1")+ acols[n,2])) 
	If SB1->(dbSeek( XFILIAL("SB1")+ SC7->C7_PRODUTO)) 
		cDescr := SB1->B1_ZPRODES
		U_MGFCOM(cDescr)
	EndIf
EndIf
Return                           

User Function MGFCOM(cDescr)

Local 	cDescri  := Space(500)
Local	Odlg
Private lOk,lCancel

	cDescri := cDescr 
	DEFINE DIALOG oDlg TITLE "Descrição do Produto" FROM 180,180 TO 450,1000 PIXEL 

	@ 25,58 GET oDesc var cDescri memo SIZE 300,80 OF oDlg PIXEL
	@ 26,08 SAY "Descrição:" SIZE  260,80 OF oDlg PIXEL                                                                                                                  
	oTButton := TButton():New( 120, 270, "&OK",oDlg	,{|| lOk:= .T., oDlg:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	ACTIVATE DIALOG oDlg CENTERED

Return                                                                   
