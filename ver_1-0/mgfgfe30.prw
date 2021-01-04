#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} MGFGFE30
Copia a Tabela de Frete entre Filiais, necessário GVA posicionada

@author Rodrigo dos Santos 
-------------------------------------------------------------------*/
user Function MGFGFE30()
	Local aAreaGVA := GVA->(getArea())
	Local oDlg
	Local oCdTab
	Local oCdTransp
	Local oDsTab
	Local cDsTab := GVA->GVA_DSTAB
	Local oDsTransp
	Local cDsTransp := POSICIONE("GU3",1,XFILIAL("GU3")+GVA->GVA_CDEMIT,"GU3_NMEMIT")
	Local oFolder1
	Local oFolderPage1
	Local oFolderPage2
	Local oGroup1
	Local oGroup2
	Local oNovCdTransp
	Local oNovDsTab
	Local oPanel1
	Local oPanel2
	Local oPanel3
	Local ofili
	
	Private oNovDsTransp
	Private cNovDsTransp := Space(TamSX3("GU3_NMEMIT")[1])
	Private oNovTabDes
	Private cNovTabDes := PadR(GVA->GVA_DSTAB, TamSX3("GVA_DSTAB")[1])
	Private oChkTarifas
	Private oChkZerar
	Private lCopyRotas   := .T.
	Private lCopyFaixas  := .T.
	Private lCopyTarifas := .T.
	Private lCopyZerar   := .F.
	Private cCdTransp 	 := GVA->GVA_CDEMIT
	Private cCdTab 		 := GVA->GVA_NRTAB
	Private cNovCdTab 	 := Space(TamSX3("GVA_NRTAB")[1])
	Private cNovCdTransp := Space(TamSX3("GVA_CDEMIT")[1])
	Private oGetNeg
	Private aHeadNeg := {}
	Private cFili:=Space(6)
	
	If GVA->GVA_TPTAB == "2"
		Help( ,, 'Help' ,, "Não é possível copiar uma tabela do tipo 'Vínculo'.", 1, 0 )
		Return .F.
	EndIf
	
	
	aHeadNeg := DefTabNeg()
	
  	DEFINE MSDIALOG oDlg TITLE "Cópia da Tabela de Frete" FROM 000, 000  TO 520, 700 PIXEL
  		CursorWait()
  		
		@ 000, 000 MSPANEL oPanel1 SIZE 350, 045 OF oDlg  RAISED
		@ 040, 000 MSPANEL oPanel2 SIZE 350, 065 OF oDlg  RAISED    
		@ 080, 000 MSPANEL oPanel3 SIZE 350, 120 OF oDlg  RAISED
		    
		@ 000, 000 GROUP oGroup1 TO 039, 349 PROMPT "Tabela de Frete Base " OF oPanel1 PIXEL
		@ 000, 000 GROUP oGroup2 TO 039, 349 PROMPT "Nova Tabela de Frete " OF oPanel2 PIXEL
			
		@ 010, 004 SAY oSay3 PROMPT "Transportador:" SIZE 037, 007 OF oGroup1 PIXEL
		@ 009, 046 MSGET oCdTransp VAR cCdTransp SIZE 055, 010 OF oGroup1 WHEN .F. PIXEL
		@ 009, 115 MSGET oDsTransp VAR cDsTransp SIZE 135, 010 OF oGroup1 WHEN .F. PIXEL
	    @ 025, 004 SAY oSay4 PROMPT "Tabela:" SIZE 025, 007 OF oGroup1 PIXEL
	    @ 023, 046 MSGET oCdTab VAR cCdTab SIZE 055, 010 OF oGroup1 WHEN .F. PIXEL
	    @ 023, 115 MSGET oDsTab VAR cDsTab SIZE 135, 010 OF oGroup1 WHEN .F. PIXEL 
	    
	    
	    @ 010, 004 SAY oSay5 PROMPT "Transportador:" SIZE 037, 007 OF oGroup2 PIXEL
	    @ 009, 046 MSGET oNovCdTransp VAR cNovCdTransp SIZE 055, 010 OF oGroup2 F3 "GU3TRP" VALID ValidTransp(cNovCdTransp) PIXEL
	    @ 009, 115 MSGET oNovDsTransp VAR cNovDsTransp SIZE 135, 010 OF oGroup2 WHEN .F. PIXEL
	    @ 025, 004 SAY oSay6 PROMPT "Tabela:" SIZE 025, 007 OF oGroup2 PIXEL
	    @ 023, 046 MSGET oNovCdTab VAR cNovCdTab SIZE 055, 010 OF oGroup2 PIXEL
	    
	    @ 025, 130 SAY oSay8 PROMPT "FILIAL:" SIZE 070, 007 OF oGroup2 PIXEl       
	    
	    @ 023, 180 MSGET ofili VAR cfili SIZE 090, 010 OF oGroup2 F3 "FILSM0" Valid FwFilExist(cEmpAnt, cfili) PIXEL 
	    
	    @ 040, 004 SAY oSay9 PROMPT "Descrição:" SIZE 037, 007 OF oGroup2 PIXEL
	    @ 038, 046 MSGET oNovTabDes VAR cNovTabDes SIZE 204, 010 PICTURE "@!" OF oGroup2  PIXEL
	    
	    @ 053, 046 CHECKBOX oCheckBo1   VAR lCopyRotas   PROMPT "Rotas" SIZE 048, 012 OF oGroup2 COLORS 0, 16777215 PIXEL ON CLICK(ChkOpCopy()) 
	    @ 053, 086 CHECKBOX oCheckBo2   VAR lCopyFaixas  PROMPT "Faixas" SIZE 048, 012 OF oGroup2 COLORS 0, 16777215 PIXEL ON CLICK(ChkOpCopy()) 
	    @ 053, 126 CHECKBOX oChkTarifas VAR lCopyTarifas PROMPT "Tarifas" SIZE 048, 012 OF oGroup2 COLORS 0, 16777215 PIXEL
	    @ 053, 166 CHECKBOX oChkZerar   VAR lCopyZerar   PROMPT "Zerar Tarifas" SIZE 048, 012 OF oGroup2 PIXEL
	    
	    
	    @ 000, 000 FOLDER oFolder1 SIZE 300, 119 OF oPanel3 ITEMS "Negociações" COLORS 0, 14215660 PIXEL
	    
	   	oGetNeg := MsNewGetDados():New(05, 05, 60, 160, GD_UPDATE, "AllwaysTrue", "AllwaysTrue",/*[ cIniCpos]*/, {"NDTVALI", "NDTVALF"}	,/* [ nFreeze]*/,/*[ nMax]*/,"AllwaysTrue",/*[ cSuperDel]*/,/*[ cDelOk]*/, oFolder1:ADialogs[1], aHeadNeg, /* aColsFil*/,,/*[ cTela]*/)
	   	oGetNeg:oBrowse:blDblClick 	:= { |x,nCol| IIf( nCol == 1, MrkLinha(), oGetNeg:EditCell()) }
	
	    oPanel1:Align  := CONTROL_ALIGN_TOP
	    oPanel2:Align  := CONTROL_ALIGN_TOP
	    oGroup1:Align  := CONTROL_ALIGN_ALLCLIENT
	    oGroup2:Align  := CONTROL_ALIGN_ALLCLIENT
	    oPanel3:Align  := CONTROL_ALIGN_ALLCLIENT
	    oFolder1:Align := CONTROL_ALIGN_ALLCLIENT
	    oGetNeg:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	    
	    CarregaDados(cCdTransp, cCdTab)
	    oGetNeg:oBrowse:GoBottom()
	    oGetNeg:oBrowse:GoTop()
	    oGetNeg:oBrowse:Refresh()
	    CursorArrow()
	    
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||btOK()}, {||ODlg:End()}) CENTERED

Return

/*-------------------------------------------------------------------                                                                           
ValidTransp
Validação do campo Novo Transportador

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function ValidTransp(cNovCdTransp)
	Local lRet
	lRet := ExistCpo("GU3",cNovCdTransp)
	
	If lRet
		cNovDsTransp := POSICIONE("GU3",1,XFILIAL("GU3")+cNovCdTransp,"GU3_NMEMIT")
		oNovDsTransp:CtrlRefresh()
	Else
		cNovDsTransp := ""
		oNovDsTransp:CtrlRefresh()
	EndIf
	
Return (lRet)      


/*-------------------------------------------------------------------                                                                           
ChkOpCopy
Validação dos CheckBoxs de Rota e Faixas
@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function ChkOpCopy()
	If lCopyRotas == .F. .OR. lCopyFaixas == .F.
		lCopyTarifas := .F.
		lCopyZerar   := .F.
		
		oChkTarifas:Disable()
		oChkZerar:Disable()
		
		oChkTarifas:CtrlRefresh()
		oChkZerar:CtrlRefresh()
	Else
		lCopyTarifas := .T.
		lCopyZerar   := .F.
		
		oChkTarifas:SetColor(0, 16777215)
		oChkTarifas:Enable()
		oChkZerar:Enable()
		
		oChkTarifas:CtrlRefresh()
		oChkZerar:CtrlRefresh()	
	EndIf
Return


/*-------------------------------------------------------------------                                                                           
MrkLinha
Evento de duplo clique

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function MrkLinha()
	// Local nId := Val(AllTrim(oGet:aCols[oGet:nAt, Len(oGet:aCols[oGet:nAt]) - 1]))
		
	If GDFieldGet( 'MRK', oGetNeg:nAt,, oGetNeg:aHeader, oGetNeg:aCols ) == 'LBNO'
		GDFieldPut( 'MRK', 'LBOK', oGetNeg:nAt, oGetNeg:aHeader, oGetNeg:aCols )
	Else
		GDFieldPut( 'MRK'       , 'LBNO' , oGetNeg:nAt , oGetNeg:aHeader , oGetNeg:aCols )
	EndIf
Return

/*-------------------------------------------------------------------                                                                           
CarregaDados
Carre dados

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function CarregaDados(cCdTransp, cCdTab)
	Private aCols := {}
	
	dbSelectArea("GV9")
	dbSetOrder(1)
	dbSeek(xFilial("GV9") + cCdTransp + cCdTab)
	While !GV9->(Eof())						 .AND. ;
		   GV9->GV9_FILIAL == xFilial("GV9") .AND. ;
		   GV9->GV9_CDEMIT == cCdTransp		 .AND. ;
		   GV9->GV9_NRTAB  == cCdTab
		   
		AAdd(aCols, Array(Len(aHeadNeg)+2))
		
		aCols[Len(aCols), 1] := "LBOK"
		aCols[Len(aCols), 2] := GV9->GV9_NRNEG
		aCols[Len(aCols), 3] := GV9->GV9_CDCLFR
		aCols[Len(aCols), 4] := Posicione("GUB",1,xFilial("GUB")+GV9->GV9_CDCLFR,"GUB_DSCLFR")
		aCols[Len(aCols), 5] := GV9->GV9_CDTPOP
		aCols[Len(aCols), 6] := Posicione("GV4",1,xFilial("GV4")+GV9->GV9_CDTPOP,"GV4_DSTPOP")
		aCols[Len(aCols), 7] := DToC(GV9->GV9_DTVALI)
		aCols[Len(aCols), 8] := DToC(GV9->GV9_DTVALF)
		aCols[Len(aCols), 9] := GV9->GV9_DTVALI
		aCols[Len(aCols),10] := GV9->GV9_DTVALF
		aCols[Len(aCols),Len(aHeadNeg)+2] := .F.
		
		GV9->(dbSkip())	   
	EndDo

	
	oGetNeg:SetArray(aCols, .T.)
	
	oGetNeg:oBrowse:Refresh()
Return


/*-------------------------------------------------------------------                                                                           
{Protheus.doc} btOK
Ação do botão Confirmar da Janela

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function btOK()
	Local aAreaGVA
	Local aAreaGV9
	Private cErros := ""
	
	If Empty(cNovCdTransp) .OR. Empty(cNovCdTab)
		Help( ,, 'Help' ,, "Informe o Transportador e o Código da tabela para a cópia.", 1, 0 )
		Return .F.
	EndIf
	
	dbSelectArea("GVA")
	dbSetOrder(1)
	If dbSeek(xFilial("GVA") + PadR(cNovCdTransp, TamSX3("GVA_CDEMIT")[1]) + PadR(cNovCdTab, TamSX3("GVA_NRTAB")[1]))
		Help( ,, 'Help' ,, "Já existe uma tabela cadastrada com este Transportador e Código.", 1, 0 )
		Return .F.
	EndIf
	
	aAreaGVA  := GVA->(getArea())
	aAreaGV9 := GV9->(getArea())
	
	Processa({|| CopyTabFrete()}, "Cópia")
	
	RestArea(aAreaGVA)
	RestArea(aAreaGV9)
	
	If Empty(cErros)
		MsgInfo("Tabela copiada", "Cópia")
	Else
		Alert("Processo concluído, porém ocorreram os seguintes erros: " + CHR(10) + CHR(13) + cErros, "Erros")
	EndIf
	
Return		

/*-------------------------------------------------------------------                                                                           
{Protheus.doc} GFEA062CTB
Efetiva a cópia da tabela de frete

@author Rodrigo dos Santos------------------------------------------------------*/
Static Function CopyTabFrete()
	Local aAreaCopy
	Local cNrNeg
	Local dNDTVALI
	Local dNDTVALF
	Local nI
	
	ProcRegua(0)
	
	If dbSeek(xFilial("GVA") + cCdTransp + cCdTab)
		IncProc("Copiando Tabela de Frete...")
		
		CopyReg("GVA")
		dbSelectArea("GVA")
		GVA->GVA_FILIAL	:= 	cFili
		GVA->GVA_CDEMIT	:= 	cNovCdTransp
		GVA->GVA_NRTAB	:= 	cNovCdTab
		GVA->GVA_DSTAB  	:= 	cNovTabDes
		GVA->GVA_DTCRIA	:= 	Date()
		GVA->GVA_HRCRIA	:= 	Time()
		GVA->GVA_USUCRI 	:= 	cUserName
		GVA->GVA_DTATU	:= 	Date()
		GVA->GVA_HRATU	:= 	Time()
		GVA->GVA_USUATU 	:= 	cUserName
		GVA->GVA_DTAPR  	:= 	Stod("  /  /  ")
		GVA->GVA_HRAPR  	:= 	""
		GVA->GVA_USUAPR 	:= 	""
		GVA->GVA_DTNEG  	:= 	DDATABASE
		GVA->GVA_SITVIN	:= 	"1"
		GVA->GVA_ENVAPR 	:= 	"2"
		GVA->GVA_MTVRPR 	:= 	""
		GVA->GVA_OBS    	:= 	"Cópia da tabela de frete pelo usuário '" + cUserName+ "'. Tabela base: Emitente: " + cCdTransp + ", Tabela: " + cCdTab
		If GFE61EXCPL()
			GVA->GVA_CPLSIT	:= "1" //Não enviada
		EndIf
		MsUnlock("GVA")
		//Atualiza situação de integração do cockpit logístico
		GFE61ATDP(cNovCdTransp + cNovCdTab)
		For nI := 1 To Len(oGetNeg:aCols)
			IncProc("Copiando Tabela de Frete...")
			If GDFieldGet( 'MRK', nI,, oGetNeg:aHeader, oGetNeg:aCols ) == 'LBOK'
				cNrNeg		:= GDFieldGet( 'NRNEG', nI,, oGetNeg:aHeader, oGetNeg:aCols )
				dNDTVALI 	:= GDFieldGet( 'NDTVALI', nI,, oGetNeg:aHeader, oGetNeg:aCols )
				dNDTVALF 	:= GDFieldGet( 'NDTVALF', nI,, oGetNeg:aHeader, oGetNeg:aCols )
				
					dbSelectArea("GV9")
					If dbSeek(xFilial("GV9") + cCdTransp + cCdTab + cNrNeg)
						// -- Copia da Negociação -----------------------------------
						CopyReg("GV9")
						dbSelectArea("GV9")
						GV9->GV9_FILIAL 	:= 	cFili
						GV9->GV9_CDEMIT 	:= 	cNovCdTransp
						GV9->GV9_NRTAB	:= 	cNovCdTab     
						GV9->GV9_NRNEG  := Substr(cFili,5,6) +Substr(GV9->GV9_NRNEG,3,6)
						GV9->GV9_DTCRIA 	:= 	DDATABASE
						GV9->GV9_HRCRIA 	:= 	SubStr(TIME(), 1, 5)
						GV9->GV9_USUCRI 	:= 	cUserName
						GV9->GV9_ENVAPR 	:= 	"2"
						GV9->GV9_DTAPR  	:= 	Stod("  /  /  ")
						GV9->GV9_HRAPR  	:= 	""
						GV9->GV9_USUAPR 	:= 	""
						GV9->GV9_MTVRPR 	:= 	""
						GV9->GV9_SIT		:= 	"1"
						GV9->GV9_DTVALI 	:= 	dNDTVALI
						GV9->GV9_DTVALF 	:= 	dNDTVALF
						If GV9->(FieldPos("GV9_CODCOT")) > 0
							GV9->GV9_CODCOT := ""
							GV9->GV9_SEQCOT := ""
						EndIf
						If GV9->(FieldPos("GV9_SITMLA")) > 0
							GV9->GV9_SITMLA := "1"
							GV9->GV9_MOTMLA := ""
						EndIf
						MsUnlock("GV9")
						
						// -- Copia dos Componentes ---------------------------------
						dbSelectArea("GUY")
						dbSetOrder(1)
						dbSeek(xFilial("GUY") + cCdTransp + cCdTab + cNrNeg)	
						While !GUY->(Eof()) .AND. ;
						       GUY->GUY_FILIAL == xFilial("GUY") .AND. ;
						       GUY->GUY_CDEMIT == cCdTransp  	 .AND. ;
						       GUY->GUY_NRTAB  == cCdTab 		 .AND. ;
						       GUY->GUY_NRNEG  == cNrNeg
						       
							aAreaCopy := GUY->(GetArea())						       
						       
							CopyReg("GUY")
							dbSelectArea("GUY")
							GUY->GUY_FILIAL := cFili
							GUY->GUY_NRNEG  :=Substr(cFili,5,6) +Substr(GUY->GUY_NRNEG,3,6)
							GUY->GUY_CDEMIT := cNovCdTransp
							GUY->GUY_NRTAB  := cNovCdTab						       
						    MsUnlock("GUY")
						    
						    RestArea(aAreaCopy)
							GUY->(dbSkip())
						EndDo
						
						// -- Copia das Rotas ---------------------------------------
						If lCopyRotas
							dbSelectArea("GV8")
							dbSetOrder(1)
							dbSeek(xFilial("GV8") + cCdTransp + cCdTab + cNrNeg)	
							While !GV8->(Eof()) .AND. ;
							       GV8->GV8_FILIAL == xFilial("GV8") .AND. ;
							       GV8->GV8_CDEMIT == cCdTransp  	 .AND. ;
							       GV8->GV8_NRTAB  == cCdTab 		 .AND. ;
							       GV8->GV8_NRNEG  == cNrNeg
							       
								aAreaCopy := Gv8->(GetArea())						       
							       
								CopyReg("GV8")
								dbSelectArea("GV8")
								GV8->GV8_FILIAL := cFili
								GV8->GV8_NRNEG  :=Substr(cFili,5,6) +Substr(GV8->GV8_NRNEG,3,6)
								GV8->GV8_CDEMIT := cNovCdTransp
								GV8->GV8_NRTAB  := cNovCdTab						       
							    MsUnlock("GV8")
							    
							    RestArea(aAreaCopy)
								GV8->(dbSkip())
							EndDo
						EndIf
						
						// -- Copia das Faixas---------------------------------------
						If lCopyFaixas 
							
							dbSelectArea("GV7")
							dbSetOrder(1)
							dbSeek(xFilial("GV7") + cCdTransp + cCdTab + cNrNeg)
								
							While !GV7->(Eof()) 							.AND. ;
							       	GV7->GV7_FILIAL == xFilial("GV7")	.AND. ;
							      	GV7->GV7_CDEMIT == cCdTransp  	 	.AND. ;
							       	GV7->GV7_NRTAB  == cCdTab 		 	.AND. ;
							      	GV7->GV7_NRNEG  == cNrNeg
							       
								aAreaCopy := GV7->(GetArea())						       
							       
								CopyReg("GV7")
								dbSelectArea("GV7")
								GV7->GV7_FILIAL := cFili
								GV7->GV7_NRNEG  :=Substr(cFili,5,6) +Substr(GV7->GV7_NRNEG,3,6)
								GV7->GV7_CDEMIT := cNovCdTransp
								GV7->GV7_NRTAB  := cNovCdTab						       
							    MsUnlock("GV7")
							    
							    RestArea(aAreaCopy)
								GV7->(dbSkip())
							EndDo
						EndIf
											
						// -- Copia das Faixas e Entrega ----------------------------
						dbSelectArea("GUZ")
						dbSetOrder(1)
						dbSeek(xFilial("GUZ") + cCdTransp + cCdTab + cNrNeg)	
						While !GUZ->(Eof()) .AND. ;
						       GUZ->GUZ_FILIAL == xFilial("GUZ") .AND. ;
						       GUZ->GUZ_CDEMIT == cCdTransp  	 .AND. ;
						       GUZ->GUZ_NRTAB  == cCdTab 		 .AND. ;
						       GUZ->GUZ_NRNEG  == cNrNeg
							       
							aAreaCopy := GUZ->(GetArea())						       
							       
							CopyReg("GUZ")
							dbSelectArea("GUZ")
							GUZ->GUZ_FILIAL := cFili
							GUZ->GUZ_NRNEG  :=Substr(cFili,5,6) +Substr(GUZ->GUZ_NRNEG,3,6)
							GUZ->GUZ_CDEMIT := cNovCdTransp
							GUZ->GUZ_NRTAB  := cNovCdTab						       
						    MsUnlock("GUZ")
							    
						    RestArea(aAreaCopy)
							GUZ->(dbSkip())
						EndDo
						
						
						// -- Copia das Tarifas -------------------------------------
						If lCopyTarifas .AND. lCopyRotas .AND. lCopyFaixas
							dbSelectArea("GV6")
							dbSetOrder(1)
							dbSeek(xFilial("GV6") + cCdTransp + cCdTab + cNrNeg)	
							While !GV6->(Eof()) .AND. ;
							       GV6->GV6_FILIAL == xFilial("GV6") .AND. ;
							       GV6->GV6_CDEMIT == cCdTransp  	 .AND. ;
							       GV6->GV6_NRTAB  == cCdTab 		 .AND. ;
							       GV6->GV6_NRNEG  == cNrNeg
								       
								aAreaCopy := GV6->(GetArea())						       
								       
								CopyReg("GV6")
								dbSelectArea("GV6")
								GV6->GV6_FILIAL := cFili
								GV6->GV6_CDEMIT := cNovCdTransp
								GV6->GV6_NRNEG  :=Substr(cFili,5,6) +Substr(GV6->GV6_NRNEG,3,6)
								GV6->GV6_NRTAB  := cNovCdTab
								GV6->GV6_DTATU  := DDATABASE
								GV6->GV6_HRATU  := Time()
								GV6->GV6_USUATU := cUserName
							    MsUnlock("GV6")
							    
							    RestArea(aAreaCopy)
								GV6->(dbSkip())
							EndDo
							
							// -- Copia dos Componentes das Tarifas ---------------------
							dbSelectArea("GV1")
							dbSetOrder(1)
							dbSeek(xFilial("GV1") + cCdTransp + cCdTab + cNrNeg)	
							While !GV1->(Eof()) .AND. ;
							       GV1->GV1_FILIAL == xFilial("GV1") .AND. ;
							       GV1->GV1_CDEMIT == cCdTransp  	 .AND. ;
							       GV1->GV1_NRTAB  == cCdTab 		 .AND. ;
							       GV1->GV1_NRNEG  == cNrNeg
								       
								aAreaCopy := GV1->(GetArea())						       
								       
								CopyReg("GV1")
								dbSelectArea("GV1")
								GV1->GV1_FILIAL := cFili
								GV1->GV1_NRNEG  :=Substr(cFili,5,6) +Substr(GV1->GV1_NRNEG,3,6)
								GV1->GV1_CDEMIT := cNovCdTransp
								GV1->GV1_NRTAB  := cNovCdTab
								
								If lCopyZerar
									GV1->GV1_VLFIXN := 0
									GV1->GV1_PCNORM := 0
									GV1->GV1_VLUNIN := 0
									GV1->GV1_VLFRAC := 0
									GV1->GV1_VLMINN := 0
									GV1->GV1_VLLIM  := 0
									GV1->GV1_VLFIXE := 0
									GV1->GV1_PCEXTR := 0
									GV1->GV1_VLUNIE := 0
								EndIf
																	
							    MsUnlock("GV1")
								    
							    RestArea(aAreaCopy)
								GV1->(dbSkip())
							EndDo
							
							// -- Copia dos Componentes Adicionais das Tarifas ----------
							dbSelectArea("GUC")
							dbSetOrder(1)
							dbSeek(xFilial("GUC") + cCdTransp + cCdTab + cNrNeg)	
							While !GUC->(Eof()) .AND. ;
							       GUC->GUC_FILIAL == xFilial("GUC") .AND. ;
							       GUC->GUC_CDEMIT == cCdTransp  	 .AND. ;
							       GUC->GUC_NRTAB  == cCdTab 		 .AND. ;
							       GUC->GUC_NRNEG  == cNrNeg
								       
								aAreaCopy := GUC->(GetArea())						       
								       
								CopyReg("GUC")
								dbSelectArea("GUC")
								GUC->GUC_FILIAL := cFili
								GUC->GUC_NRNEG:=Substr(cFili,5,6) +Substr(GUC->GUC_NRNEG,3,6)
								GUC->GUC_CDEMIT := cNovCdTransp
								GUC->GUC_NRTAB  := cNovCdTab
								
								If lCopyZerar
									GUC->GUC_VLFIXN := 0
									GUC->GUC_PCNORM := 0
									GUC->GUC_VLUNIN := 0
									GUC->GUC_VLFRAC := 0
									GUC->GUC_VLMINN := 0
									GUC->GUC_PCLIM  := 0
									GUC->GUC_VLLIM  := 0
									GUC->GUC_VLFIXE := 0
									GUC->GUC_PCEXTR := 0
									GUC->GUC_VLUNIE := 0
								EndIf
							    MsUnlock("GUC")
								    
							    RestArea(aAreaCopy)
								GUC->(dbSkip())
							EndDo							
						EndIf
					Else
						cErros := cErros + "** Negociação não encontrada. Emitente: " + cCdTransp + ", Tabela: " + cCdTab + ", Negociação: " + cNrNeg + CHR(10) + CHR(13) + CHR(10) + CHR(13)
					EndIf
			EndIf
		Next
	Else
		cErros := cErros + "** Tabela não encontrada. Emitente: " + cCdTransp + ", Tabela: " + cCdTab + CHR(10) + CHR(13) + CHR(10) + CHR(13)
		Return .F.
	EndIf
	
Return


/*-------------------------------------------------------------------                                                                           
CopyReg
Copia todos os campos da tabela especificada do registro atual

@author Rodrigo dos Santos
-------------------------------------------------------------------*/ 
Static Function CopyReg(cTab)
	Local aTab := {}
	Local nCount
	
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek(cTab))
	
	While !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == cTab
		If SX3->X3_CONTEXT == "R"
			AAdd(aTab,&(cTab + "->" + SX3->X3_CAMPO))
		EndIf
		SX3->(dbSkip())
	End
	
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek(cTab))
	
	RecLock(cTab, .T.)
	nCount := 0
	While !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == cTab
		If SX3->X3_CONTEXT == "R"
			nCount++
			&(cTab+"->"+ALLTRIM(SX3->X3_CAMPO))  := aTab[nCount]
		EndIf
		SX3->(dbSkip())
	End	
Return aTab



/*-------------------------------------------------------------------                                                                           
DefTabNeg
Definição do Grid de Negociações

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function DefTabNeg()

	Local aHead    := {}	// Campos da temp-table de Tabela de Frete
	
	aAdd( aHead, { ;
		''                 , ;    // 01 - Titulo
		'MRK'            , ;    // 02 - Campo
		'@BMP'             , ;    // 03 - Picture
		10                 , ;    // 04 - Tamanho
		0                  , ;    // 05 - Decimal
		''                 , ;    // 06 - Valid
		''                 , ;    // 07 - Usado
		'C'                , ;    // 08 - Tipo
		''                 , ;    // 09 - F3
		'R'                , ;    // 10 - Contexto
		''                 , ;    // 11 - ComboBox
		''             , ;    // 12 - Relacao
		''                 , ;    // 13 - Alterar
		'V'                , ;    // 14 - Visual
		''                 } )    // 15 - Valid Usuario
		
	AddTabHead(@aHead, "Negociação"   ,	"NRNEG"  , "C", TamSX3("GV9_NRNEG")[1] , 0, "@!")
	AddTabHead(@aHead, "Class.Frete"  , "CDCLFR" , "C", TamSX3("GV9_CDCLFR")[1], 0, "@!")
	AddTabHead(@aHead, "Descrição"    , "DSCLFR" , "C", 30, 0, "@!")
	AddTabHead(@aHead, "Tipo Oper."	  , "CDTPOP" , "C", TamSX3("GV9_CDTPOP")[1], 0, "@!")
	AddTabHead(@aHead, "Descrição"    , "DSOPER" , "C", 30, 0, "@!")
	AddTabHead(@aHead, "Vigencia De"  , "DTVALI" , "D", 08, 0, "")
	AddTabHead(@aHead, "Vigencia Ate" , "DTVALF" , "D", 08, 0, "")
	AddTabHead(@aHead, "Nova Vigencia De"  , "NDTVALI" , "D", 08, 0, "")
	AddTabHead(@aHead, "Nova Vigencia Ate" , "NDTVALF" , "D", 08, 0, "")

Return aHead


/*-------------------------------------------------------------------                                                                           
AddTabHead
Função para auxiliar a criação do Array de cabeçalho do Grid

@author Rodrigo dos Santos
-------------------------------------------------------------------*/
Static Function AddTabHead(aHead, Titulo, Nome, TipoDado, Tamanho, Decimal, Mascara,cValid,cUsado,cF3)
	Default cValid := ''
	Default cUsado := ''
	Default cF3     := ''
	
	aAdd( aHead, { ;	
	Titulo			, ;    // 01 - Titulo
	Nome    		, ;    // 02 - Campo
	Mascara        	, ;    // 03 - Picture
	Tamanho        	, ;    // 04 - Tamanho
	Decimal        	, ;    // 05 - Decimal
	cValid         	, ;    // 06 - Valid
	cUsado          	, ;    // 07 - Usado
	TipoDado       	, ;    // 08 - Tipo
	cF3          	, ;    // 09 - F3
	'R'         	, ;    // 10 - Contexto
	''          	, ;    // 11 - ComboBox
	''      		, ;    // 12 - Relacao
	'.T.'          	, ;    // 13 - Alterar
	''         		, ;    // 14 - Visual
	''          	} )    // 15 - Valid Usuario
Return


