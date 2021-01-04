#Include "matr140.ch"
#Include "Protheus.ch"

/*/{Protheus.doc} Matr140
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cAlias, characters, descricao
@param nReg, numeric, descricao
@type function
/*/
User Function Matr140(cAlias,nReg)

	Local oReport

	PRIVATE lAuto     := (nReg<>Nil)




	oReport:= ReportDef(nReg)
	oReport:PrintDialog()

Return
















Static Function ReportDef(nReg)

	Local oReport
	Local oSection1
	Local oCell
	Local oBreak
	Local cTitle := FWI18NLang("MATR140","STR0002",2)
	Local cAliasSC1 := Iif(lAuto,"SC1",GetNextAlias())


















	Pergunte("MTR140", .F. )











	oReport := TReport():New("MTR140",cTitle,If(lAuto,Nil,"MTR140"), {|oReport| ReportPrint(oReport,cAliasSC1,nReg)},FWI18NLang("MATR140","STR0001",1))
	oReport:SetLandscape()


































	oSection1:= TRSection():New(oReport,FWI18NLang("MATR140","STR0064",64),{"SC1","SB1","SB2"},)
	oSection1:SetHeaderPage()


	TRCell():New(oSection1,"C1_ITEM"   ,"SC1",,,,,)
	TRCell():New(oSection1,"C1_PRODUTO","SC1",,,TamSX3("C1_PRODUTO")[1]+10,,)
	TRCell():New(oSection1,"DESCPROD"  ,"   ",FWI18NLang("MATR140","STR0049",49),,30,, {|| cDescPro })
	TRCell():New(oSection1,"B2_QATU"   ,"SB2",    ,PesqPict("SB2","B2_QATU" ,12),,,)
	TRCell():New(oSection1,"B1EMIN"    ,"   ",FWI18NLang("MATR140","STR0050",50)       ,PesqPict("SB1","B1_EMIN" ,12),,,{|| RetFldProd(SB1->B1_COD,"B1_EMIN") })
	TRCell():New(oSection1,"SALDOSC1"  ,"   ",FWI18NLang("MATR140","STR0051",51)       ,PesqPict("SC1","C1_QUANT",12),,,{|| (cAliasSC1)->C1_QUANT-(cAliasSC1)->C1_QUJE })
	TRCell():New(oSection1,"C1_UM"     ,"SC1",    ,PesqPict("SC1","C1_UM"),,,)
	TRCell():New(oSection1,"C1_LOCAL"  ,"SC1",    ,PesqPict("SC1","C1_LOCAL"),,,)
	TRCell():New(oSection1,"B1_QE"     ,"SB1",    ,PesqPict("SB1","B1_QE",09),,,)
	TRCell():New(oSection1,"B1_UPRC"   ,"SB1",    ,PesqPict("SB1","B1_UPRC",12),,,)
	TRCell():New(oSection1,"LEADTIME"  ,"   ",FWI18NLang("MATR140","STR0052",52),,,,{|| CalcPrazo((cAliasSC1)->C1_PRODUTO,(cAliasSC1)->C1_QUANT)})
	TRCell():New(oSection1,"DTNECESS"  ,"   ",FWI18NLang("MATR140","STR0053",53),,,,{|| If(Empty((cAliasSC1)->C1_DATPRF),(cAliasSC1)->C1_EMISSAO,(cAliasSC1)->C1_DATPRF) })
	TRCell():New(oSection1,"DTFORCOMP" ,"   ",FWI18NLang("MATR140","STR0054",54),,,,{||SomaPrazo(If(Empty((cAliasSC1)->C1_DATPRF),(cAliasSC1)->C1_EMISSAO,(cAliasSC1)->C1_DATPRF), -CalcPrazo((cAliasSC1)->C1_PRODUTO,(cAliasSC1)->C1_QUANT)) })
	oSection1:Cell("DESCPROD"):SetLineBreak( .T. )

	oSection2:= TRSection():New(oSection1,FWI18NLang("MATR140","STR0065",65),{"SD4","SC2"},)

	TRCell():New(oSection2,"D4_OP"     ,"SD4",FWI18NLang("MATR140","STR0055",55),,,,)
	TRCell():New(oSection2,"C2_PRODUTO","SC2",FWI18NLang("MATR140","STR0056",56),,,,)
	TRCell():New(oSection2,"D4_DATA"   ,"SD4",FWI18NLang("MATR140","STR0057",57),,,,)
	TRCell():New(oSection2,"D4_QUANT"  ,"SD4",FWI18NLang("MATR140","STR0058",58),PesqPict("SD4","D4_QUANT",12),,,)

	oSection3:= TRSection():New(oSection2,FWI18NLang("MATR140","STR0066",66),{"SB3"},)

	TRCell():New(oSection3,"MES01"		,"   ",,PesqPict("SB3","B3_Q01",11)	,11			,,)
	TRCell():New(oSection3,"MES02"		,"   ",,PesqPict("SB3","B3_Q02",11)	,11			,,)
	TRCell():New(oSection3,"MES03"		,"   ",,PesqPict("SB3","B3_Q03",11)	,11			,,)
	TRCell():New(oSection3,"MES04"		,"   ",,PesqPict("SB3","B3_Q04",11)	,11			,,)
	TRCell():New(oSection3,"MES05"		,"   ",,PesqPict("SB3","B3_Q05",11)	,11			,,)
	TRCell():New(oSection3,"MES06"		,"   ",,PesqPict("SB3","B3_Q06",11)	,11			,,)
	TRCell():New(oSection3,"MES07"		,"   ",,PesqPict("SB3","B3_Q07",11)	,11			,,)
	TRCell():New(oSection3,"MES08"		,"   ",,PesqPict("SB3","B3_Q08",11)	,11			,,)
	TRCell():New(oSection3,"MES09"		,"   ",,PesqPict("SB3","B3_Q09",11)	,11			,,)
	TRCell():New(oSection3,"MES10"		,"   ",,PesqPict("SB3","B3_Q10",11)	,11			,,)
	TRCell():New(oSection3,"MES11"		,"   ",,PesqPict("SB3","B3_Q11",11)	,11			,,)
	TRCell():New(oSection3,"MES12"		,"   ",,PesqPict("SB3","B3_Q12",11)	,11			,,)
	TRCell():New(oSection3,"B3_MEDIA"	,"SB3", ,PesqPict("SB3","B3_MEDIA",8),,,)
	TRCell():New(oSection3,"B3_CLASSE"	,"SB3",,,,,)

	oSection4:= TRSection():New(oSection3,FWI18NLang("MATR140","STR0067",67),{"SC7","SA2"},)
	TRCell():New(oSection4,"C7_NUM"    ,"SC7",FWI18NLang("MATR140","STR0043",43),,,,{|| cNumPc})
	TRCell():New(oSection4,"C7_ITEM"   ,"SC7",FWI18NLang("MATR140","STR0074",74),,,,{|| cItemPc})
	TRCell():New(oSection4,"C7_FORNECE","SC7",FWI18NLang("MATR140","STR0075",75),,,,{|| cFornec})
	TRCell():New(oSection4,"C7_LOJA"   ,"SC7",FWI18NLang("MATR140","STR0076",76),,,,{|| cLojaFor})
	TRCell():New(oSection4,"A2_NOME"   ,"SA2",,,,,{|| cNomeFor})
	TRCell():New(oSection4,"C7_QUANT"  ,"SC7",,PesqPict("SC7","C7_QUANT"),,,{|| nQuant})
	TRCell():New(oSection4,"C7_UM"     ,"SC7",FWI18NLang("MATR140","STR0077",77),,,,{|| cUM})
	TRCell():New(oSection4,"C7_PRECO"  ,"SC7",,PesqPict("SC7","C7_PRECO"),,,{|| nPreco})
	TRCell():New(oSection4,"C7_TOTAL"  ,"SC7",,PesqPict("SC7","C7_TOTAL"),,,{|| nTotal})
	TRCell():New(oSection4,"C7_EMISSAO","SC7",,,,,{|| dEmissao})
	TRCell():New(oSection4,"C7_DATPRF" ,"SC7",,,,,{|| dDATPRF})
	TRCell():New(oSection4,"PRAZO"     ,"   ",FWI18NLang("MATR140","STR0059",59),"999",,,{|| dPrazo })
	TRCell():New(oSection4,"C7_COND"   ,"SC7",FWI18NLang("MATR140","STR0078",78),,,,{|| cCond})
	TRCell():New(oSection4,"C7_QUJE"   ,"SC7",,,,,{|| nQuje})
	TRCell():New(oSection4,"SALDORES"  ,"   ",FWI18NLang("MATR140","STR0060",60),PesqPict("SC7","C7_QUJE"),,,{||nSaldores })
	TRCell():New(oSection4,"RESIDUO"   ,"   ",FWI18NLang("MATR140","STR0061",61),,,,{||cResiduo})


	If mv_par10 == 1
		oSection5:= TRSection():New(oSection4,FWI18NLang("MATR140","STR0068",68),{"SA5","SA2","SC1"},)
		TRCell():New(oSection5,"A5_FORNECE","SA5",,,,,)
		TRCell():New(oSection5,"A5_LOJA"   ,"SA5",,,,,)
		TRCell():New(oSection5,"A2_NOME"   ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_TEL"    ,"SA2",,,41,,)
		TRCell():New(oSection5,"A2_CONTATO","SA2",,,,,)
		TRCell():New(oSection5,"A2_FAX"    ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_ULTCOM" ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_MUN"    ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_EST"    ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_RISCO"  ,"SA2",,,,,)
		TRCell():New(oSection5,"A5_CODPRF" ,"SA5",,,,,)
	Else
		oSection5:= TRSection():New(oSection4,FWI18NLang("MATR140","STR0069",69),{"SAD","SA2","SC1"},)
		TRCell():New(oSection5,"AD_FORNECE","SAD",,,,,)
		TRCell():New(oSection5,"AD_LOJA"   ,"SAD",,,,,)
		TRCell():New(oSection5,"A2_NOME"   ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_TEL"    ,"SA2",,,41,,)
		TRCell():New(oSection5,"A2_CONTATO","SA2",,,,,)
		TRCell():New(oSection5,"A2_FAX"    ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_ULTCOM" ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_MUN"    ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_EST"    ,"SA2",,,,,)
		TRCell():New(oSection5,"A2_RISCO"  ,"SA2",,,,,)
	EndIf

Return(oReport)
















Static Function ReportPrint(oReport,cAliasSC1,nReg)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local oSection3 := oReport:Section(1):Section(1):Section(1)
	Local oSection4 := oReport:Section(1):Section(1):Section(1):Section(1)
	Local oSection5 := oReport:Section(1):Section(1):Section(1):Section(1):Section(1)
	Local aMeses	:= {FWI18NLang("MATR140","STR0005",5),FWI18NLang("MATR140","STR0006",6),FWI18NLang("MATR140","STR0007",7),FWI18NLang("MATR140","STR0008",8),FWI18NLang("MATR140","STR0009",9),FWI18NLang("MATR140","STR0010",10),FWI18NLang("MATR140","STR0011",11),FWI18NLang("MATR140","STR0012",12),FWI18NLang("MATR140","STR0013",13),FWI18NLang("MATR140","STR0014",14),FWI18NLang("MATR140","STR0015",15),FWI18NLang("MATR140","STR0016",16)}
	Local aOrdem    := {}
	Local aSavRec   := {}
	Local cMes      := ""
	Local cCampos   := ""
	Local cEmissao  := ""
	Local cGrupo    := ""
	Local nX        := 0
	Local nY        := 0
	Local nRecnoSD4 := 0
	Local nAno      := Year(dDataBase)
	Local nMes      := Month(dDataBase)
	Local nPrinted  := 0
	Local nVlrMax   := 0
	Local cLmtSol   := ""
	Local cQuery := ""
	Local cWhere := ""
	Local lQuery := .T.

	nVlrMax := val(Replicate("9",TamSX3("C1_QTDREEM")[1]))


	Private cDescPro := ""
	Private cNumPc   := ""
	Private cItemPc  := ""
	Private cFornec  := ""
	Private cLojaFor := ""
	Private cNomeFor := ""
	Private cUM      := ""
	Private cCond    := ""
	Private cResiduo := ""
	Private nQuant   := 0
	Private nPreco   := 0
	Private nTotal   := 0
	Private nQuje    := 0
	Private nSaldoRes:= 0
	Private dEmissao := ctod("")
	Private dDATPRF  := ctod("")
	Private dPrazo   := ctod("")

	dbSelectArea("SC1")
	dbSetOrder(1)

	If lAuto
		dbGoto(nReg)
		mv_par01  := SC1->C1_NUM
		mv_par02  := SC1->C1_NUM
		mv_par03  := 1
		mv_par04  := SC1->C1_EMISSAO
		mv_par05  := SC1->C1_EMISSAO
		mv_par06  := "  "
		mv_par07  := "ZZ"
		mv_par09  := 1
		mv_par13  := 3
	Else

		MakeSqlExpr(oReport:uParam)

		oReport:Section(1):BeginQuery()

		cWhere := "%"
		If mv_par03 == 2
			cWhere += " C1_QUANT <> C1_QUJE AND "
		EndIf
		cWhere += "%"















		__execSql(cAliasSC1," SELECT SC1.*, SC1.R_E_C_N_O_ SC1RECNO FROM  "+RetSqlName('SC1')+" SC1 WHERE C1_FILIAL =  '" +xFilial('SC1')+"'  AND C1_NUM >=  "+___SQLGetValue(MV_PAR01)+" AND C1_NUM <=  "+___SQLGetValue(MV_PAR02)+" AND C1_EMISSAO >=  "+___SQLGetValue(DTOS(MV_PAR04))+" AND C1_EMISSAO <=  "+___SQLGetValue(DTOS(MV_PAR05))+" AND C1_ITEM >=  "+___SQLGetValue(MV_PAR06)+" AND C1_ITEM <=  "+___SQLGetValue(MV_PAR07)+" AND  "+___SQLGetValue(CWHERE)+" SC1.D_E_L_E_T_= ' ' ORDER BY  "+ SqlOrder(SC1->(IndexKey())),{},.F.)

		oReport:Section(1):EndQuery()

	EndIf

	TRPosition():New(oSection1,"SB1",1,{ || xFilial("SB1") + (cAliasSC1)->C1_PRODUTO })
	TRPosition():New(oSection1,"SB2",1,{ || xFilial("SB2") + (cAliasSC1)->C1_PRODUTO + (cAliasSC1)->C1_LOCAL })
	TRPosition():New(oSection1,"SB3",1,{ || xFilial("SB3") + (cAliasSC1)->C1_PRODUTO })
	TRPosition():New(oSection3,"SB3",1,{ || xFilial("SB3") + (cAliasSC1)->C1_PRODUTO })
	TRPosition():New(oSection1,"SD4",1,{ || xFilial("SD4") + (cAliasSC1)->C1_PRODUTO })
	TRPosition():New(oSection1,"SC7",1,{ || xFilial("SC7") + (cAliasSC1)->C1_NUM + (cAliasSC1)->C1_ITEM })
	TRPosition():New(oSection2,"SC2",1,{ || xFilial("SC2") + SD4->D4_OP })
	TRPosition():New(oSection4,"SA2",1,{ || xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA })




	oReport:onPageBreak( { || oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine(), oReport:ThinLine() })

	oReport:SetMeter(SC1->(LastRec()))
	dbSelectArea(cAliasSC1)


	While !oReport:Cancel() .And.  !(cAliasSC1)->(Eof()) .And.  (cAliasSC1)->C1_FILIAL == xFilial("SC1") .And.  (cAliasSC1)->C1_NUM >= mv_par01 .And.  (cAliasSC1)->C1_NUM <= mv_par02

		oReport:IncMeter()

		If oReport:Cancel()
			Exit
		EndIf




		If !MtrAValOP(mv_par13,"SC1",cAliasSC1 )
			dbSkip()
			Loop
		EndIf





		cEmissao := IIf((cAliasSC1)->C1_QTDREEM > 0 , Str(If((cAliasSC1)->C1_QTDREEM < nVlrMax,(cAliasSC1)->C1_QTDREEM + 1,(cAliasSC1)->C1_QTDREEM) ,2) + FWI18NLang("MATR140","STR0045",45) , " " )
		oReport:SetTitle(FWI18NLang("MATR140","STR0002",2)+"     "+FWI18NLang("MATR140","STR0043",43)+" "+Substr((cAliasSC1)->C1_NUM,1,6)+" "+FWI18NLang("MATR140","STR0018",18)+" "+(cAliasSC1)->C1_CC+Space(20)+cEmissao )




		SB1->(dbSetOrder(1))
		SB1->(dbSeek( xFilial("SB1") + (cAliasSC1)->C1_PRODUTO ))
		cDescPro := SB1->B1_DESC
		cGrupo   := SB1->B1_GRUPO

		If AllTrim(mv_par08) == "C1_DESCRI"
			cDescPro := (cAliasSC1)->C1_DESCRI
		ElseIf AllTrim(mv_par08) == "B5_CEME"
			SB5->(dbSetOrder(1))
			If SB5->(dbSeek( xFilial("SB5") + (cAliasSC1)->C1_PRODUTO ))
				cDescPro := SB5->B5_CEME
			EndIf
		EndIf





		oSection1:Init()




		If !Empty((cAliasSC1)->C1_OBS)
			oReport:PrintText(FWI18NLang("MATR140","STR0019",19),,oSection1:Cell("C1_ITEM"):ColPos())

			For nX := 1 To 258 Step 129
				oReport:PrintText(Substr((cAliasSC1)->C1_OBS,nX,129),,oSection1:Cell("C1_ITEM"):ColPos())
				If Empty(Substr((cAliasSC1)->C1_OBS,nX+129,129))
					Exit
				Endif
			next

			oReport:ThinLine()

		Endif




		If mv_par09 == 1
			oReport:SkipLine()
			oReport:PrintText(FWI18NLang("MATR140","STR0020",20),,oSection1:Cell("C1_ITEM"):ColPos())

			dbSelectArea("SD4")
			If !Eof()

				oSection2:Init()

				While !Eof() .And.  SD4->D4_FILIAL + SD4->D4_COD == (cAliasSC1)->C1_FILIAL + (cAliasSC1)->C1_PRODUTO

					nRecnoSD4 := SD4->(Recno())
					If SD4->D4_QUANT <> 0
						oSection2:PrintLine()
					EndIf
					SD4->(dbGoTo(nRecnoSD4))
					SD4->(dbSkip())

				EndDo

				oSection2:Finish()

			Else
				oReport:PrintText(FWI18NLang("MATR140","STR0021",21),,oSection1:Cell("C1_ITEM"):ColPos())
			EndIf

			oReport:SkipLine()
			oReport:ThinLine()

		EndIf




		oReport:SkipLine()
		oReport:PrintText(FWI18NLang("MATR140","STR0024",24),,oSection1:Cell("C1_ITEM"):ColPos())

		dbSelectArea("SB3")
		If !Eof()

			oSection3:Init()

			nAno   := Year(dDataBase)
			nMes   := Month(dDataBase)
			aOrdem := {}
			nY     := 1

			For nX := nMes To 1 Step -1
				oSection3:Cell("MES"+StrZero(nY,2)):SetTitle("|  "+aMeses[nX]+"/"+StrZero(nAno,4))
				AADD(aOrdem,nX)
				nY++
			next

			nAno--

			For nX := 12 To nMes+1 Step -1
				oSection3:Cell("MES"+StrZero(nY,2)):SetTitle("|  "+aMeses[nX]+"/"+StrZero(nAno,4))
				AADD(aOrdem,nX)
				nY++
			next

			For nX := 1 To Len(aOrdem)
				cMes    := StrZero(aOrdem[nX],2)
				cCampos := "SB3->B3_Q"+cMes
				oSection3:Cell("MES"+StrZero(nX,2)):SetValue(&cCampos)
			next

			oSection3:PrintLine()
			oSection3:Finish()

		Else
			oReport:PrintText(FWI18NLang("MATR140","STR0025",25),,oSection1:Cell("C1_ITEM"):ColPos())
		EndIf




		oReport:SkipLine()
		oReport:ThinLine()
		oReport:SkipLine()
		oReport:PrintText(FWI18NLang("MATR140","STR0027",27),,oSection1:Cell("C1_ITEM"):ColPos())

		dbSelectArea("SC7")
		dbSetOrder(4)
		Set( 9,"ON" )
		dbSeek(xFilial("SC7")+(cAliasSC1)->C1_PRODUTO+"z")
		Set( 9,"OFF" )
		dbSkip(-1)
		If (cAliasSC1)->C1_FILIAL + (cAliasSC1)->C1_PRODUTO == SC7->C7_FILIAL + SC7->C7_PRODUTO
			nPrinted := 0

			oSection4:Init()

			While !Bof() .And.  (cAliasSC1)->C1_FILIAL + (cAliasSC1)->C1_PRODUTO == SC7->C7_FILIAL + SC7->C7_PRODUTO
				cNumPc   := SC7->C7_NUM
				cItemPc  := SC7->C7_ITEM
				cFornec  := SC7->C7_FORNECE
				cLojaFor := SC7->C7_LOJA
				cCond    := SC7->C7_COND
				cUM      := SC7->C7_UM
				cResiduo := IIf(Empty(SC7->C7_RESIDUO),FWI18NLang("MATR140","STR0062",62),FWI18NLang("MATR140","STR0063",63))
				nQuant   := SC7->C7_QUANT
				nPreco   := SC7->C7_PRECO
				nTotal   := SC7->C7_TOTAL
				dEmissao := SC7->C7_EMISSAO
				dDATPRF  := SC7->C7_DATPRF
				dPrazo   := SC7->C7_DATPRF - SC7->C7_EMISSAO
				nQuje    := SC7->C7_QUJE
				nSaldoRes:= Iif(Empty(SC7->C7_RESIDUO),SC7->C7_QUANT - SC7->C7_QUJE,0)

				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
				cNomeFor := SA2->A2_NOME

				nPrinted++
				If nPrinted > mv_par11
					Exit
				EndIf

				oSection4:PrintLine()

				dbSkip(-1)
			EndDo

			oSection4:Finish()

		Else
			oReport:PrintText(FWI18NLang("MATR140","STR0028",28),,oSection1:Cell("C1_ITEM"):ColPos())
		EndIf





		aAreaX		:= getArea()
		aAreaSC1	:= SC1->(getArea())

		SC1->( DBGoTo( (cAliasSC1)->SC1RECNO ) )
		if !empty( SC1->C1_CODCOMP )
			oReport:SkipLine()
			oReport:ThinLine()
			oReport:SkipLine()
			oReport:PrintText("COMPRADOR: " + allTrim( SC1->C1_CODCOMP ) + " - " + allTrim( GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+SC1->C1_CODCOMP,1,"") ),,oSection1:Cell("C1_ITEM"):ColPos())
		endif

		restArea(aAreaSC1)
		restArea(aAreaX)




		oReport:SkipLine()
		oReport:ThinLine()
		oReport:SkipLine()
		oReport:PrintText(FWI18NLang("MATR140","STR0030",30),,oSection1:Cell("C1_ITEM"):ColPos())

		If mv_par10 == 1

			dbSelectArea("SA5")
			dbSetOrder(2)
			dbSeek(xFilial("SA5")+(cAliasSC1)->C1_PRODUTO)

			If !Eof()
				nPrinted := 0
				oSection5:Init()

				While !Eof() .And.  xFilial("SA5") + (cAliasSC1)->C1_PRODUTO == SA5->A5_FILIAL + SA5->A5_PRODUTO
					If SA2->(dbSeek(xFilial("SA2")+SA5->A5_FORNECE+SA5->A5_LOJA))
						nPrinted++
						If nPrinted > mv_par12
							Exit
						EndIf
						oSection5:PrintLine()
					EndIf

					dbSkip()
				EndDo
				oSection5:Finish()
			Else
				oReport:PrintText(FWI18NLang("MATR140","STR0031",31),,oSection1:Cell("C1_ITEM"):ColPos())
			EndIf
		Else
			dbSelectArea("SAD")
			dbSetOrder(2)
			dbSeek(xFilial()+cGrupo)

			If !Eof()
				nPrinted := 0
				oSection5:Init()
				While !Eof() .And.  SAD->AD_FILIAL + SAD->AD_GRUPO == xFilial("SAD") + cGrupo
					If SA2->(dbSeek(xFilial("SA2")+SAD->AD_FORNECE+SAD->AD_LOJA))
						nPrinted++
						If nPrinted > mv_par12
							Exit
						EndIf
						oSection5:PrintLine()
					EndIf
					dbSkip()
				EndDo
			Else
				oReport:PrintText(FWI18NLang("MATR140","STR0031",31),,oSection1:Cell("C1_ITEM"):ColPos())
			EndIf
			oSection5:Finish()
		EndIf




		oReport:SkipLine()
		oReport:ThinLine()
		oReport:SkipLine()

		If !Empty(SB1->B1_ALTER)
			SB2->(dbSeek(xFilial("SB2") + SB1->B1_ALTER + (cAliasSC1)->C1_LOCAL ))
			oReport:PrintText(FWI18NLang("MATR140","STR0034",34)+" "+SB1->B1_ALTER+" "+FWI18NLang("MATR140","STR0035",35)+" "+Transform(SB2->B2_QATU,PesqPict("SB2","B2_QATU",12)+" "+SC1->C1_UM ),,oSection1:Cell("C1_ITEM"):ColPos())
		Else
			oReport:PrintText(FWI18NLang("MATR140","STR0034",34) + " " + FWI18NLang("MATR140","STR0036",36),,oSection1:Cell("C1_ITEM"):ColPos())
		EndIf




		dbSelectArea(cAliasSC1)

		oReport:SkipLine()
		oReport:ThinLine()
		oReport:SkipLine()

		oReport:SkipLine()
		oReport:ThinLine()
		oReport:SkipLine()

		oReport:PrintText(FWI18NLang("MATR140","STR0037",37),,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("|---------------------------------------------|-----------------|------------------------------------|------------------|------------------|----------------|-----------------------------|---------|----------------------|",,oSection1:Cell("C1_ITEM"):ColPos())
		For nX :=1 To 4
			oReport:PrintText("|                                             |                 |                                    |                  |                  |                |                             |         |                      |",,oSection1:Cell("C1_ITEM"):ColPos())
			oReport:PrintText("|---------------------------------------------|-----------------|------------------------------------|------------------|------------------|----------------|-----------------------------|---------|----------------------|",,oSection1:Cell("C1_ITEM"):ColPos())
		next
		oReport:SkipLine()
		oReport:PrintText("---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText(FWI18NLang("MATR140","STR0038",38),,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("|                                                                                                            |                                                                                                             |",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("|   ------------------------------------------------------------------------------------------------------   |   -------------------------------------------------------------------------------------------------------   |",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("|                "+PADC(AllTrim((cAliasSC1)->C1_SOLICIT),15)+"                                                                             |                    "+ Padc(AllTrim((cAliasSC1)->C1_NOMAPRO),15)+ "                                                                          |",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("|                                                                                                            |                                                                                                             |",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",,oSection1:Cell("C1_ITEM"):ColPos())




		If Ascan(aSavRec,IIf(lQuery .And.  !lAuto ,(cAliasSC1)->SC1RECNO,Recno())) == 0
			AADD(aSavRec,IIf(lQuery .And.  !lAuto ,(cAliasSC1)->SC1RECNO,Recno()))
		Endif

		dbSelectArea(cAliasSC1)
		dbSkip()
		oSection1:Finish()
		oReport:EndPage()
	EndDo
	
	
	

	dbSelectArea("SC1")
	If Len(aSavRec) > 0
		For nX:=1 to Len(aSavRec)
			dbGoto(aSavRec[nX])
			If C1_QTDREEM < nVlrMax
				RecLock("SC1", .F. )
				_FIELD->C1_QTDREEM := (C1_QTDREEM+1)
				MsUnLock()
			Else
				cLmtSol += SC1->C1_NUM + ","
			EndIf
		next
	EndIf

	If !Empty(cLmtSol)
		Aviso(FWI18NLang("MATR140","STR0073",73),FWI18NLang("MATR140","STR0070",70) + "'" + Alltrim(str(nVlrMax)) + "'" + FWI18NLang("MATR140","STR0071",71) + SubStr(cLmtSol,1,len(cLmtSol)-1) + FWI18NLang("MATR140","STR0072",72),{"OK"})
	EndIf

Return Nil
