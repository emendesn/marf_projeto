#Include "Protheus.ch"
#Include "GFER061.CH"

//
//
/*/{Protheus.doc} GFER061x
//TODO Descri��o auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function GFER061x()

	Local oReport
	Local aArea := GetArea()
	Private cAliGVA       := ""
	Private cAliGV9       := ""

	If FindFunction("TRepInUse") .And.  TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf

	RestArea( aArea )

Return







Static Function ReportDef()
	Local oReport
	Local oSection1
	Local aOrdem := {}











	oReport:= TReport():New("GFER061",If( cPaisLoc $ "ANG|PTG", "Tabela de Frete", "Tabela De Frete" ),"GFER061", {|oReport| ReportPrint(oReport)},If( cPaisLoc $ "ANG|PTG", "Emite rela��o da tabela de frete conforme os par�metros informados.", "Emite Relacao da Tabela de Frete conforme os parametros informados." ))
	oReport:SetLandscape()
	oReport:HideParamPage()
	oReport:SetTotalInLine( .F. )
	oReport:SetColSpace(2, .F. )


































	aAdd(aOrdem, If( cPaisLoc $ "ANG|PTG", "C�digo", "Codigo" ))

	oSection1 := TRSection():New(oReport, If( cPaisLoc $ "ANG|PTG", "Tabela de Frete", "Tabela De Frete" ), {"GVA","GU3"}, aOrdem)
	oSection1:SetLineStyle()
	oSection1:SetTotalInLine( .F. )
	TRCell():New(oSection1, "GVA_CDEMIT", "GVA", , , , , {||AllTrim((cAliGVA)->GVA_CDEMIT)})
	TRCell():New(oSection1, "GU3_NMEMIT", "GU3", , , , , )
	TRCell():New(oSection1, "GVA_NRTAB" , "GVA", , , , , {||AllTrim((cAliGVA)->GVA_NRTAB)})
	TRCell():New(oSection1, "GVA_DSTAB" , "GVA", , , , , {||AllTrim((cAliGVA)->GVA_DSTAB)})
	TRCell():New(oSection1, "GVA_NMCONT", "GVA", , , , , {||AllTrim((cAliGVA)->GVA_NMCONT)})
	TRCell():New(oSection1, "GVA_NMPROF", "GVA", , , , , {||AllTrim((cAliGVA)->GVA_NMPROF)})
	TRCell():New(oSection1, "GVA_TPARRE", "GVA", , , , , {||AllTrim((cAliGVA)->GVA_TPARRE)})
	TRCell():New(oSection1, "GVA_TPTAB" , "GVA", , , , , {||AllTrim((cAliGVA)->GVA_TPTAB)})
	TRCell():New(oSection1, "GVA_VLMULT", "GVA", , , , , {||AllTrim((cAliGVA)->GVA_VLMULT)})
	TRCell():New(oSection1, "GVA_VLADIC", "GVA", , , , , {||AllTrim((cAliGVA)->GVA_VLADIC)})
	TRCell():New(oSection1, "GVA_DTAPR" , "GVA", , , , , {||AllTrim((cAliGVA)->GVA_DTAPR)})
	TRCell():New(oSection1, "GVA_HRAPR" , "GVA", , , , , {||AllTrim((cAliGVA)->GVA_HRAPR)})
	TRCell():New(oSection1, "GVA_USUAPR", "GVA", , , , , {||AllTrim((cAliGVA)->GVA_USUAPR)})
	TRCell():New(oSection1, "GVA_MTVRPR", "GVA", , , , , {|| GVA->GVA_MTVRPR                })

	TRPosition():New(oSection1, "GU3", 1, {|| xFilial("GU3")+(cAliGVA)->GVA_CDEMIT})

	oSection2 := TRSection():New(oSection1, "Tabela de Frete V�nculo", {"GVB","GU3"}, aOrdem)
	oSection2:SetTotalInLine( .F. )
	oSection2:SetHeaderSection( .T. )
	TRCell():New(oSection2, "GVB_CDEMIT", "GVB", , , , , )
	TRCell():New(oSection2, "GU3_NMEMIT", "GU3", , , , , )
	TRCell():New(oSection2, "GVB_VLMULT", "GVB", , , , , )
	TRCell():New(oSection2, "GVB_VLADIC", "GVB", , , , , )

	TRPosition():New(oSection2, "GU3", 1, {|| xFilial("GU3")+GVB->GVB_CDEMIT})

	oSection3 := TRSection():New(oSection1, "Negocia��o", {"GV9"}, aOrdem)
	oSection3:SetTotalInLine( .F. )
	oSection3:SetHeaderSection( .T. )
	TRCell():New(oSection3, "GV9_NRNEG", "GV9", , , , ,  {||AllTrim((cAliGV9)->GV9_NRNEG)})
	TRCell():New(oSection3, "GV9_CDCLFR", "GV9", , , , ,  {||AllTrim((cAliGV9)->GV9_CDCLFR)})
	TRCell():New(oSection3, "GV9_CDTPOP", "GV9", , , , ,  {||AllTrim((cAliGV9)->GV9_CDTPOP)})
	TRCell():New(oSection3, "GV9_DTVALI", "GV9", , , 25, ,{||AllTrim((cAliGV9)->GV9_DTVALI)})
	TRCell():New(oSection3, "GV9_DTVALF", "GV9", , , 25, ,{||AllTrim((cAliGV9)->GV9_DTVALF)})
	TRCell():New(oSection3, "GV9_QTKGM3", "GV9", , , , ,  {||AllTrim((cAliGV9)->GV9_QTKGM3)})
	TRCell():New(oSection3, "GV9_UNIFAI", "GV9", , , , ,  {||AllTrim((cAliGV9)->GV9_UNIFAI)})
	TRCell():New(oSection3, "GV9_ATRFAI", "GV9", , , , ,  {||AllTrim((cAliGV9)->GV9_ATRFAI)})
	TRCell():New(oSection3, "GV9_DTAPR" , "GV9", , , , ,  {||AllTrim((cAliGV9)->GV9_DTAPR)})
	TRCell():New(oSection3, "GV9_HRAPR" , "GV9", , , , ,  {||AllTrim((cAliGV9)->GV9_HRAPR)})
	TRCell():New(oSection3, "GV9_USUAPR", "GV9", , , , ,  {||AllTrim((cAliGV9)->GV9_USUAPR)})
	TRCell():New(oSection1, "GV9_MTVRPR", "GV9", , , , , {|| GV9->GV9_MTVRPR                })

	oSection4:= TRSection():New(oSection3, "Componentes", {"GUY"}, aOrdem)
	oSection4:SetTotalInLine( .F. )
	oSection4:SetHeaderSection( .T. )
	TRCell():New(oSection4, "GUY_CDCOMP", "GUY", , , , , )
	TRCell():New(oSection4, "GUY_TOTFRE", "GUY", , , , , )
	TRCell():New(oSection4, "GUY_BASIMP", "GUY", , , , , )
	TRCell():New(oSection4, "GUY_BAPICO", "GUY", , , , , )
	TRCell():New(oSection4, "GUY_FREMIN", "GUY", , , , , )

	oSection5 := TRSection():New(oSection3, "Rotas", {"GV8"}, aOrdem)
	oSection5:SetTotalInLine( .F. )
	oSection5:SetHeaderSection( .T. )
	TRCell():New(oSection5,"GV8_NRROTA","GV8",,, ,,)
	TRCell():New(oSection5,"GV8_TPORIG","GV8",,, 18,,)
	TRCell():New(oSection5,"cCdOri", "", "C�digo" ,, 20 ,, {|| cCdOri})
	TRCell():New(oSection5,"cNmOri", "", "Nome"   ,, 30 ,, {|| cNmOri})
	TRCell():New(oSection5,"cOriUF", "", If( cPaisLoc $ "ANG|PTG", "Dist. Ori.", "UF Ori." ),, 5  ,, {|| cOriUF})
	TRCell():New(oSection5,"GV8_TPDEST", "GV8",,, 18,,)
	TRCell():New(oSection5,"cCdDest", "", "C�digo"  ,, 20 ,, {|| cCdDest})
	TRCell():New(oSection5,"cNmDest", "", "Nome"    ,, 30 ,, {|| cNmDest})
	TRCell():New(oSection5,"cDestUF", "", If( cPaisLoc $ "ANG|PTG", "Dist. Dest.", "UF Dest." ),, 5  ,, {|| cDestUF})
	TRCell():New(oSection5,"GV8_DUPSEN","GV8",,, ,,)
	TRCell():New(oSection5,"GV8_PCDEV" ,"GV8",,, ,,)
	TRCell():New(oSection5,"GV8_PCREEN","GV8",,, ,,)
	TRCell():New(oSection5,"GV8_VLMXRE","GV8",,, ,,)
	TRCell():New(oSection5,"GV8_PRIROT","GV8",,, ,,)

	oSection6 := TRSection():New(oSection3, "Faixas/Tipos Ve�culo", {"GV7"}, aOrdem)
	oSection6:SetTotalInLine( .F. )
	oSection6:SetHeaderSection( .T. )
	TRCell():New(oSection6, "GV7_CDFXTV", "GV7", , , , , )
	TRCell():New(oSection6, "cVal1", "", "", , 17, , {|| cVal1})
	TRCell():New(oSection6, "cVal2", "", "", , 50, , {|| cVal2})
	TRCell():New(oSection6, "cVal3", "", "", , 6, , {|| cVal3})

	oSection7:= TRSection():New(oSection3, "Tarifas da Tabela de Frete", {"GV6","GV7"}, aOrdem)
	oSection7:SetTotalInLine( .F. )
	oSection7:SetHeaderSection( .T. )
	TRCell():New(oSection7, "GV6_NRROTA", "GV6", , , , , )
	TRCell():New(oSection7, "GV6_CDFXTV", "GV6", , , , , )
	TRCell():New(oSection7, "cVal1", "", "T�tulo", , 17, , {|| cVal1})
	TRCell():New(oSection7, "GV6_QTMIN" , "GV6", , , , , )
	TRCell():New(oSection7, "GV6_FRMIN" , "GV6", , , , , )
	TRCell():New(oSection7, "GV6_COMFRG", "GV6", , , , , )
	TRCell():New(oSection7, "GV6_CONTPZ", "GV6", , , , , )
	TRCell():New(oSection7, "GV6_QTPRAZ", "GV6", , , , , )
	TRCell():New(oSection7, "GV6_TPPRAZ", "GV6", , , , , )

	TRPosition():New(oSection7, "GV7", 1, {|| xFilial("GV6")+GV6->GV6_NRROTA})

	oSection8:= TRSection():New(oSection7, "Componentes da Tarifa da Tabela de Frete", {"GV1"}, aOrdem)
	oSection8:SetTotalInLine( .F. )
	oSection8:SetHeaderSection( .T. )
	TRCell():New(oSection8, "GV1_CDCOMP", "GV1", , , , , )
	TRCell():New(oSection8, "GV1_VLFIXN", "GV1", , , , , )
	TRCell():New(oSection8, "GV1_PCNORM", "GV1", , , , , )
	TRCell():New(oSection8, "GV1_VLUNIN", "GV1", , , , , )
	TRCell():New(oSection8, "GV1_VLFRAC", "GV1", , , , , )
	TRCell():New(oSection8, "GV1_VLMINN", "GV1", , , , , )
	TRCell():New(oSection8, "GV1_VLLIM" , "GV1", , , , , )
	TRCell():New(oSection8, "GV1_VLFIXE", "GV1", , , , , )
	TRCell():New(oSection8, "GV1_VLUNIE", "GV1", , , , , )

	oSection9 := TRSection():New(oSection7, "Componentes da Tarifa por Emitente da Tabela de Frete", {"GUC"}, aOrdem)
	oSection9:SetTotalInLine( .F. )
	oSection9:SetHeaderSection( .T. )
	TRCell():New(oSection9, "GUC_EMICOM", "GUC", , , , , )
	TRCell():New(oSection9, "GUC_CDCOMP", "GUC", , , , , )
	TRCell():New(oSection9, "GUC_VLFIXN", "GUC", , , , , )
	TRCell():New(oSection9, "GUC_PCNORM", "GUC", , , , , )
	TRCell():New(oSection9, "GUC_VLUNIN", "GUC", , , , , )
	TRCell():New(oSection9, "GUC_VLFRAL", "GUC", , , , , )
	TRCell():New(oSection9, "GUC_VLMINN", "GUC", , , , , )
	TRCell():New(oSection9, "GUC_PLLIM" , "GUC", , , , , )
	TRCell():New(oSection9, "GUC_VLLIM" , "GUC", , , , , )
	TRCell():New(oSection9, "GUC_VLFIXE", "GUC", , , , , )

	oSectioN10:= TRSection():New(oSection3, "Adicionais de Entrega da Tabela de Frete", {"GUZ"}, aOrdem)
	oSection10:SetTotalInLine( .F. )
	oSection10:SetHeaderSection( .T. )
	TRCell():New(oSection10, "GUZ_SEQFAI", "GUZ", , , , , )
	TRCell():New(oSection10, "GUZ_VLFXFI", "GUZ", , , , , )
	TRCell():New(oSection10, "GUZ_PCENTR", "GUZ", , , , , )
	TRCell():New(oSection10, "GUZ_VLENTR", "GUZ", , , , , )

Return (oReport)










Static Function ReportPrint(oReport)
	Local oSection1  := oReport:Section(1)
	Local oSection2  := oReport:Section(1):Section(1)
	Local oSection3  := oReport:Section(1):Section(2)
	Local oSection4  := oReport:Section(1):Section(2):Section(1)
	Local oSection5  := oReport:Section(1):Section(2):Section(2)
	Local oSection6  := oReport:Section(1):Section(2):Section(3)
	Local oSection7  := oReport:Section(1):Section(2):Section(4)
	Local oSection8  := oReport:Section(1):Section(2):Section(4):Section(1)
	Local oSection9  := oReport:Section(1):Section(2):Section(4):Section(2)
	Local oSection10 := oReport:Section(1):Section(2):Section(5)
	Local lNewRote   := .F.
	Local nCont
	Local cQuery := ""

	Private cCdOri  := ""
	Private cNmOri  := ""
	Private cOriUF  := ""
	Private cDestUF := ""
	Private cCdDest := ""
	Private CNMDEST := ""

	Pergunte("GFER061", .F. )

	cAliGVA := GetNextAlias()
	cQuery := " SELECT GVA_FILIAL, GVA_CDEMIT, GVA_EMIVIN, GVA_NRTAB,GVA_TABVIN, GVA_SITVIN, GVA_DSTAB, GVA_NMCONT, GVA_NMPROF, GVA_TPARRE, "
	cQuery += " GVA_TPTAB, GVA_VLMULT, GVA_VLADIC, GVA_DTAPR, GVA_HRAPR, GVA_USUAPR, "
	cQuery += " ' ' GVA_MTVRPR, "
	cQuery += " GVA.R_E_C_N_O_ RECNOGVA"
	cQuery += " FROM " + RetSQLName( "GVA" ) + " GVA WHERE "
	cQuery += " (EXISTS( "
	cQuery += " SELECT * "
	cQuery += " FROM " + RetSQLName( "GV9" ) + " GV9 WHERE "
	cQuery += " GV9.GV9_CDEMIT = GVA.GVA_CDEMIT "
	cQuery += " AND GV9.GV9_FILIAL = GVA.GVA_FILIAL "
	cQuery += " AND GV9.GV9_NRTAB = GVA.GVA_NRTAB "
	cQuery += " AND GV9.GV9_CDCLFR >= '" + MV_PAR12 + "'"
	cQuery += " AND GV9.GV9_CDCLFR <= '" + MV_PAR13 + "'"
	If MV_PAR06 == 1
		cQuery += " AND GV9.GV9_SIT = '2' "
	ElseIf MV_PAR06 == 2
		cQuery += " AND GV9.GV9_SIT = '1' "
	EndIf
	If MV_PAR09 == 1
		cQuery += " AND GV9.GV9_TPLOTA = '1' "
	ElseIf MV_PAR09 == 2
		cQuery += " AND GV9.GV9_TPLOTA = '2' "
	EndIf
	cQuery += " AND GV9.GV9_CDTPOP >= '"+ MV_PAR10 + "'"
	cQuery += " AND GV9.GV9_CDTPOP <= '"+ MV_PAR11 + "'"
	If MV_PAR07 == 2
		If !Empty(MV_PAR08)
			cQuery += " AND GV9.GV9_DTVALI <= '" + DtoS(MV_PAR08) + "' "
			cQuery += " AND (GV9.GV9_DTVALF = '' OR GV9.GV9_DTVALF >= '" + DtoS(MV_PAR08) + "') "
		EndIf
	EndIf
	cQuery += " AND GV9.D_E_L_E_T_ <> '*' ) "
	cQuery += " OR EXISTS("
	cQuery += " SELECT * "
	cQuery += " FROM " + RetSQLName( "GV9" ) + " GV9 WHERE "
	cQuery += " GV9.GV9_CDEMIT = GVA.GVA_EMIVIN "
	cQuery += " AND GV9.GV9_FILIAL = GVA.GVA_FILIAL "
	cQuery += " AND GV9.GV9_NRTAB = GVA.GVA_TABVIN "
	cQuery += " AND GV9.GV9_CDCLFR >= '" + MV_PAR12 + "'"
	cQuery += " AND GV9.GV9_CDCLFR <= '" + MV_PAR13 + "'"
	cQuery += " AND GV9.GV9_CDTPOP >= '"+ MV_PAR10 + "'"
	cQuery += " AND GV9.GV9_CDTPOP <= '"+ MV_PAR11 + "'"
	If MV_PAR07 == 2
		If !Empty(MV_PAR08)
			cQuery += " AND GV9.GV9_DTVALI <= '" + DtoS(MV_PAR08) + "' "
			cQuery += " AND (GV9.GV9_DTVALF = '' OR GV9.GV9_DTVALF >= '" + DtoS(MV_PAR08) + "') "
		EndIf
	EndIf
	cQuery += " AND GV9.D_E_L_E_T_ <> '*' )) "
	cQuery += " AND GVA.GVA_FILIAL = '" + xFilial("GVA") + "'"
	cQuery += " AND GVA.GVA_CDEMIT >= '"+ MV_PAR01 + "'"
	cQuery += " AND GVA.GVA_CDEMIT <= '"+ MV_PAR02 + "'"
	cQuery += " AND GVA.GVA_NRTAB >= '"+  MV_PAR03 + "'"
	cQuery += " AND GVA.GVA_NRTAB <= '"+ MV_PAR04 + "'"
	If MV_PAR05 == 1
		cQuery += " AND GVA.GVA_TPTAB = '1' "
	ElseIf MV_PAR05 == 2
		cQuery += " AND GVA.GVA_TPTAB = '2' "
	EndIf
	cQuery += " AND GVA.D_E_L_E_T_ <> '*'"

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQuery),cAliGVA, .F. , .T. )

	(cAliGVA)->( dbGoTop() )

	oReport:SetMeter((cAliGVA)->( LastRec() ))

	While !oReport:Cancel() .And.  !(cAliGVA)->( Eof() )

		oReport:IncMeter()

		GVA->(DbGoTo((cAliGVA)->RECNOGVA))

		oSection1:Init()
		oSection1:PrintLine()

		If oSection2:lUserVisible = .T.
			If (cAliGVA)->GVA_TPTAB == "2"

				dbSelectArea("GVB")
				GVB->( dbSetOrder(1) )
				GVB->( dbSeek(xFilial("GVB") + (cAliGVA)->GVA_CDEMIT + (cAliGVA)->GVA_NRTAB) )

				oSection2:Init()
				

				While !GVB->( Eof() ) .And.  GVB->GVB_FILIAL == xFilial("GVB") .And.  GVB->GVB_CDEMIT == (cAliGVA)->GVA_CDEMIT .And.  GVB->GVB_NRTAB <= (cAliGVA)->GVA_NRTAB

					oSection2:PrintLine()

					dbSelectArea("GVB")
					GVB->( dbSkip() )
				EndDo

				oSection2:Finish()

			EndIf
		EndIf

		If MV_PAR05 <> 2 .And.  (cAliGVA)->GVA_TPTAB == "1"

			cAliGV9 := GetNextAlias()
			cQuery := " SELECT GV9_FILIAL, GV9_NRNEG, GV9_CDCLFR, GV9_CDTPOP, GV9_DTVALI, GV9_DTVALF, GV9_QTKGM3, GV9_UNIFAI, GV9_ATRFAI,"
			cQuery += " GV9_DTAPR, GV9_HRAPR, GV9_USUAPR, GV9_MTVRPR, GV9_NRTAB, GV9_CDEMIT, GV9_TPLOTA, "
			cQuery += " ' ' GV9_MTVRPR,"
			cQuery += " GV9.R_E_C_N_O_ RECNOGV9"
			cQuery += " FROM " + RetSQLName( "GV9" ) + " GV9 WHERE "
			cQuery += " GV9.GV9_FILIAL = '" + (cAliGVA)->GVA_FILIAL + "'"
			cQuery += " AND GV9.GV9_CDEMIT = '" + (cAliGVA)->GVA_CDEMIT + "'"
			cQuery += " AND GV9.GV9_NRTAB = '" + (cAliGVA)->GVA_NRTAB + "'"
			If !Empty(MV_PAR12)
				cQuery += " AND GV9.GV9_CDCLFR >= '" + MV_PAR12 + "'"
			EndIf
			If !Empty(MV_PAR13)
				cQuery += " AND GV9.GV9_CDCLFR <= '" + MV_PAR13 + "'"
			EndIf
			If MV_PAR06 == 1
				cQuery += " AND GV9.GV9_SIT = '2' "
			ElseIf MV_PAR06 == 2
				cQuery += " AND GV9.GV9_SIT = '1' "
			EndIf
			If MV_PAR09 == 1
				cQuery += " AND GV9.GV9_TPLOTA = '1' "
			ElseIf MV_PAR09 == 2
				cQuery += " AND GV9.GV9_TPLOTA = '2' "
			EndIf
			If !Empty(MV_PAR10)
				cQuery += " AND GV9.GV9_CDTPOP >= '"+ MV_PAR10 + "'"
			EndIf
			If !Empty(MV_PAR11)
				cQuery += " AND GV9.GV9_CDTPOP <= '"+ MV_PAR11 + "'"
			EndIf
			If MV_PAR07 == 2
				If !Empty(MV_PAR08)
					cQuery += " AND GV9.GV9_DTVALI <= '" + DtoS(MV_PAR08) + "' "
					cQuery += " AND (GV9.GV9_DTVALF = '' OR GV9.GV9_DTVALF >= '" + DtoS(MV_PAR08) + "') "
				EndIf
			EndIf
			cQuery += " AND GV9.D_E_L_E_T_ <> '*' "

			cQuery := ChangeQuery(cQuery)

			dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQuery),cAliGV9, .F. , .T. )

			(cAliGV9)->( dbGoTop() )

			oReport:SetMeter((cAliGV9)->( LastRec() ))
			

			While !(cAliGV9)->( Eof() ) .And.  (cAliGV9)->GV9_FILIAL == xFilial("GV9") .And.  (cAliGV9)->GV9_CDEMIT == (cAliGVA)->GVA_CDEMIT .And.  (cAliGV9)->GV9_NRTAB == (cAliGVA)->GVA_NRTAB

				GV9->(DbGoTo((cAliGV9)->RECNOGV9))
				oSection3:Init()
				oSection3:PrintLine()
				lNewRote := .T.

				If (cAliGV9)->GV9_TPLOTA == "1"
					cCab1 := "Faixa"
				Else
					cCab1 := "Tipo Ve�culo"
				EndIf

				If oSection4:lUserVisible = .T.
					dbSelectArea("GUY")
					GUY->( dbSetOrder(1) )
					GUY->( dbSeek(xFilial("GUY") +  (cAliGV9)->GV9_CDEMIT + (cAliGV9)->GV9_NRTAB + (cAliGV9)->GV9_NRNEG) )

					oSection4:Init()
					

					While !GUY->( Eof() ) .And.  GUY->GUY_FILIAL == xFilial("GUY") .And.  GUY->GUY_CDEMIT == (cAliGV9)->GV9_CDEMIT .And.  GUY->GUY_NRTAB == (cAliGV9)->GV9_NRTAB .And.  GUY->GUY_NRNEG == (cAliGV9)->GV9_NRNEG

						oSection4:PrintLine()

						dbSelectArea("GUY")
						GUY->( dbSkip() )
					EndDo

					oSection4:Finish()
				EndIf

				If oSection5:lUserVisible = .T.
					dbSelectArea("GV8")
					GV8->( dbSetOrder(1) )
					GV8->( dbSeek(xFilial("GV8") + (cAliGV9)->GV9_CDEMIT + (cAliGV9)->GV9_NRTAB + (cAliGV9)->GV9_NRNEG) )

					oSection5:Init()
					

					While !GV8->( Eof() ) .And.  GV8->GV8_FILIAL == xFilial("GV8") .And.  GV8->GV8_CDEMIT == (cAliGV9)->GV9_CDEMIT .And.  GV8->GV8_NRTAB == (cAliGV9)->GV9_NRTAB .And.  GV8->GV8_NRNEG == (cAliGV9)->GV9_NRNEG

						cCdOri  := ""
						cNmOri  := ""
						cOriUF  := ""
						cDestUF := ""

						If GV8->GV8_TPORIG == "1"
							cCdOri := GV8->GV8_NRCIOR
							cNmOri := Posicione("GU7", 1, xFilial("GU7") + GV8->GV8_NRCIOR, "GU7_NMCID")
						ElseIf GV8->GV8_TPORIG == "2"
							cCdOri := Transform(GV8->GV8_DSTORI, "@E 999,999,999.99")
							cNmOri := Transform(GV8->GV8_DSTORF, "@E 999,999,999.99")
						ElseIf GV8->GV8_TPORIG == "3"
							cCdOri := GV8->GV8_NRREOR
							cNmOri := Posicione("GU9", 1, xFilial("GU9") + GV8->GV8_NRREOR, "GU9_NMREG")
						ElseIf GV8->GV8_TPORIG == "4"
							cCdOri := GV8->GV8_CDPAOR
							cNmOri := Posicione("SYA", 1, xFilial("SYA")+ GV8->GV8_CDPAOR, "YA_DESCR")
							cOriUF := GV8->GV8_CDUFOR
						ElseIf GV8->GV8_TPORIG == "5"
							cCdOri := GV8->GV8_CDREM
							cNmOri := Posicione("GU3", 1, xFilial("GU3") + GV8->GV8_CDREM, "GU3_NMEMIT")
						EndIf

						If GV8->GV8_TPDEST == "1"
							cCdDest := GV8->GV8_NRCIDS
							cNmDest := Posicione("GU7", 1, xFilial("GU7") + GV8->GV8_NRCIDS, "GU7_NMCID")
						ElseIf GV8->GV8_TPDEST == "2"
							cCdDest := Transform(GV8->GV8_DSTDEI, "@E 999,999,999.99")
							cNmDest := Transform(GV8->GV8_DSTDEF, "@E 999,999,999.99")
						ElseIf GV8->GV8_TPDEST == "3"
							cCdDest := GV8->GV8_NRREDS
							cNmDest := Posicione("GU9", 1, xFilial("GU9") + GV8->GV8_NRREDS, "GU9_NMREG")
						ElseIf GV8->GV8_TPDEST == "4"
							cCdDest := GV8->GV8_CDPADS
							cNmDest := Posicione("SYA", 1, xFilial("SYA") + GV8->GV8_CDPADS, "YA_DESCR")
							cDestUF := GV8->GV8_CDUFDS
						ElseIf GV8->GV8_TPDEST == "5"
							cCdDest := GV8->GV8_CDDEST
							cNmDest := Posicione("GU3", 1, xFilial("GU3") + GV8->GV8_CDDEST, "GU3_NMEMIT")
						EndIf

						oSection5:PrintLine()

						GV8->( dbSkip() )
					EndDo

					oSection5:Finish()
				EndIf

				dbSelectArea("GV7")
				GV7->( dbSetOrder(1) )
				GV7->( dbSeek(xFilial("GV7") + (cAliGV9)->GV9_CDEMIT + (cAliGV9)->GV9_NRTAB + (cAliGV9)->GV9_NRNEG) )

				oSection6:Init()

				If (cAliGV9)->GV9_TPLOTA == "1"
					oSection6:aCell[2]:cTitle     := If( cPaisLoc $ "ANG|PTG", "Qtd. Final", "Qtde. Final" )
					oSection6:aCell[2]:cRealTitle := If( cPaisLoc $ "ANG|PTG", "Qtd. Final", "Qtde. Final" )
					oSection6:aCell[2]:nHeaderAlign := 3
					oSection6:aCell[3]:cTitle     := "Unid. Medida"
					oSection6:aCell[3]:cRealTitle := "Unid. Medida"
					oSection6:aCell[4]:cTitle     := "Faixa Soma"
					oSection6:aCell[4]:cRealTitle := "Faixa Soma"
					oSection6:aCell[4]:lEnabled := .T.
					oSection7:aCell[3]:cTitle     := "Faixa"
					oSection7:aCell[3]:cRealTitle := "Faixa"
					oSection7:aCell[3]:nHeaderAlign := 3
				Else
					oSection6:aCell[2]:cTitle     := "Tipo Ve�culo"
					oSection6:aCell[2]:cRealTitle := "Tipo Ve�culo"
					oSection6:aCell[2]:nHeaderAlign := 1
					oSection6:aCell[3]:cTitle     := If( cPaisLoc $ "ANG|PTG", "Desc. Tp. Ve�c.", "Desc. Tp. Veic." )
					oSection6:aCell[3]:cRealTitle := If( cPaisLoc $ "ANG|PTG", "Desc. Tp. Ve�c.", "Desc. Tp. Veic." )
					oSection6:aCell[4]:lEnabled := .F.
					oSection7:aCell[3]:cTitle     := "Tipo Ve�culo"
					oSection7:aCell[3]:cRealTitle := "Tipo Ve�culo"
					oSection7:aCell[3]:nHeaderAlign := 1
				EndIf


				While !GV7->( Eof() ) .And.  GV7->GV7_FILIAL == xFilial("GV7") .And.  GV7->GV7_CDEMIT == (cAliGV9)->GV9_CDEMIT .And.  GV7->GV7_NRTAB == (cAliGV9)->GV9_NRTAB .And.  GV7->GV7_NRNEG == (cAliGV9)->GV9_NRNEG

					If (cAliGV9)->GV9_TPLOTA == "1"
						cVal1 := Transform(GV7->GV7_QTFXFI,"@E 999,999,999.99999")
						cVal2 := GV7->GV7_UNICAL
						cVal3 := GV7->GV7_FXSOMA
					Else
						cVal1 := GV7->GV7_CDTPVC
						cVal2 := Posicione("GV3",1,xFilial("GV3")+GV7->GV7_CDTPVC,"GV3_DSTPVC")
						cVal3 := ""
					EndIf

					oSection6:PrintLine()

					dbSelectArea("GV7")
					GV7->( dbSkip() )
				EndDo

				oSection6:Finish()

				dbSelectArea("GV6")
				GV6->( dbSetOrder(1) )
				GV6->( dbSeek(xFilial("GV6") + (cAliGV9)->GV9_CDEMIT + (cAliGV9)->GV9_NRTAB + (cAliGV9)->GV9_NRNEG) )


				While !GV6->( Eof() ) .And.  GV6->GV6_FILIAL == xFilial("GV6") .And.  GV6->GV6_CDEMIT == (cAliGV9)->GV9_CDEMIT .And.  GV6->GV6_NRTAB == (cAliGV9)->GV9_NRTAB .And.  GV6->GV6_NRNEG == (cAliGV9)->GV9_NRNEG

					If lNewRote
						oSection7:Init()
					EndIf

					oSection7:PrintLine()
					lNewRote := .F.

					If oSection8:lUserVisible = .T.
						dbSelectArea("GV1")
						GV1->( dbSetOrder(1) )
						GV1->( dbSeek(xFilial("GV1") + GV6->GV6_CDEMIT + GV6->GV6_NRTAB + GV6->GV6_NRNEG + GV6->GV6_CDFXTV + GV6->GV6_NRROTA) )

						oSection8:Init()
						
						

						While !GV1->( Eof() ) .And.  GV6->GV6_FILIAL == xFilial("GV1") .And.  GV1->GV1_CDEMIT == GV6->GV6_CDEMIT .And.  GV1->GV1_NRTAB == GV6->GV6_NRTAB .And.  GV1->GV1_NRNEG == GV6->GV6_NRNEG .And.  GV1->GV1_CDFXTV == GV6->GV6_CDFXTV .And.  GV1->GV1_NRROTA == GV6->GV6_NRROTA

							oSection8:PrintLine()
							lNewRote := .T.

							dbSelectArea("GV1")
							GV1->( dbSkip() )
						EndDo

						oSection8:Finish()
					EndIf

					If oSection9:lUserVisible = .T.
						dbSelectArea("GUC")
						GUC->( dbSetOrder(1) )
						GUC->( dbSeek(xFilial("GUC") + GV6->GV6_CDEMIT + GV6->GV6_NRTAB + GV6->GV6_NRNEG + GV6->GV6_CDFXTV + GV6->GV6_NRROTA) )

						oSection9:Init()
						
						

						While !GUC->( Eof() ) .And.  GV6->GV6_FILIAL == xFilial("GUC") .And.  GUC->GUC_CDEMIT == GV6->GV6_CDEMIT .And.  GUC->GUC_NRTAB == GV6->GV6_NRTAB .And.  GUC->GUC_NRNEG == GV6->GV6_NRNEG .And.  GUC->GUC_CDFXTV == GV6->GV6_CDFXTV .And.  GUC->GUC_NRROTA == GV6->GV6_NRROTA

							oSection9:PrintLine()
							lNewRote := .T.

							dbSelectArea("GUC")
							GUC->( dbSkip() )
						EndDo

						oSection9:Finish()
					EndIf

					dbSelectArea("GV6")
					GV6->( dbSkip() )

					If lNewRote
						oSection7:Finish()
					EndIf
				EndDo

				If !lNewRote
					oSection7:Finish()
				EndIf

				If oSection10:lUserVisible = .T.
					dbSelectArea("GUZ")
					GUZ->( dbSetOrder(1) )
					GUZ->( dbSeek(xFilial("GUZ") + (cAliGV9)->GV9_CDEMIT + (cAliGV9)->GV9_NRTAB + (cAliGV9)->GV9_NRNEG) )

					oSection10:Init()
										

					While !GUZ->( Eof() ) .And.  (cAliGV9)->GV9_FILIAL == xFilial("GUZ") .And.  GUZ->GUZ_CDEMIT == (cAliGV9)->GV9_CDEMIT .And.  GUZ->GUZ_NRTAB == (cAliGV9)->GV9_NRTAB .And.  GUZ->GUZ_NRNEG == (cAliGV9)->GV9_NRNEG

						oSection10:PrintLine()

						dbSelectArea("GUZ")
						GUZ->( dbSkip() )
					EndDo
				EndIf

				(cAliGV9)->( dbSkip() )

				oSection10:Finish()
				oSection3:Finish()
			EndDo

			(cAliGV9)->(dbCloseArea())

		EndIf

		oReport:SkipLine()
		oReport:SkipLine()

		(cAliGVA)->( dbSkip()	)

		oSection1:Finish()
	EndDo

	(cAliGVA)->(dbCloseArea())

Return
