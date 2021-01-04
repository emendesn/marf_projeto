#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

#DEFINE TAM_VALOR  20
#DEFINE TAM_QUANT  20
/*---------------------------------------------------------------------------------------
{Protheus.doc} MGFEST40
Posição de Estoque por Grupo / Conta

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@author     Atilio Amarilla
@version    P.12
@since      11/06/2018
@return    	Nenhum
@sample   	Nenhum
@obs      	
@project    MIT044 - GAP2

@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------
@alterações: 	RTASK0010061 -  - Henrique Vidal 01/10/2019 
           :  Exibe movimentos DE4, para qdo for realizado transferência entre produtos. 
	        	Opção da equipe interna por tratar direto no relatório, outra opção é 
	        	tratar por P.E
*/

User Function MGFEST40()
	Local oReport := nil
	Local cPerg:= Padr("MGFEST40",10)
	
	Private cNomPrg  	:= "MGFEST40"

	Private cMascara1 := GetMv("MV_MASCARA")
	Private cSepara1	:= ""
	
	Private nTamConta	:= 5 + TamCpoMask( "CT1_CONTA" , cMascara1 ) // Len(CriaVar("CT1_CONTA"))
	Private lPar03	:= .F.
	Private dFecAnt, cFecAnt, cFecAtu
	Private dDataRef := cTod("")

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		Return
	Endif

	dDataRef := mv_par03
	While !lPar03
		If Month(MV_PAR03) == Month(MV_PAR03+1)
			MV_PAR03++
		Else
			lPar03	:= .T.
		EndIf
	EndDo
	dFecAnt	:=  STOD(SUBS(DTOS(MV_PAR03),1,6)+"01") -1 
	cFecAnt	:= DTOC(dFecAnt)
	cFecAtu	:= DTOC(MV_PAR03)
	
	// gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	// Pergunte(cPerg,.F.)	          

	oReport := RptDef(cNomPrg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction
	Local nTamProd	:= TamSX3("B1_COD")[1]
	Local nTamDesc	:= TamSX3("B1_DESC")[1] / 2
	Local nTamFilial:= TamSX3("B1_FILIAL")[1]

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNomPrg,"Relatório Posição de Estoque",""/*cNomPrg*/,{|oReport| ReportPrint(oReport)},"Relatório Posição de Estoque")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	// oSection0
	//oSection0 := TRSection():New(oReport,"CabRelatorio",{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) 
	//oSection0:SetHeaderPage(.T.)
	

	//TRCell():New(oSection0,"PRODUTO"	,"cArqTmp" ,Upper("Produto")	,/*Picture*/,nTamProd + 2 ,/*lPixel*/, )
	//TRCell():New(oSection0,"DESCPRO"	,"cArqTmp" ,Upper("Descrição")	,/*Picture*/,nTamDesc + 2 ,/*lPixel*/,/*{|| }*/)
	//TRCell():New(oSection0,"UNIDMED"	,"cArqTmp" ,"U.M"				,/*Picture*/ , 5			,/*lPixel*/ ,/*{|| }*/)
	//TRCell():New(oSection0,"SALDANT"	,"cArqTmp" , "SALDO ANTERIOR"	,/*Picture*/ , TAM_VALOR	,/*lPixel*/ ,)
	//TRCell():New(oSection0,"ENTRMES"	,"cArqTmp"	,"ENTRADAS MES"		,/*Picture*/ , TAM_VALOR	,/*lPixel*/ ,)
	//TRCell():New(oSection0,"SAIDMES"	,"cArqTmp"	,"SAIDAS MES"		,/*Picture*/ , TAM_VALOR	,/*lPixel*/ ,)
	//TRCell():New(oSection0,"SALDQTD"	,"cArqTmp" , "QTDE ESTOQUE"		,/*Picture*/ , TAM_VALOR	,/*lPixel*/ ,)
	//TRCell():New(oSection0,"CUSTUNI"	,"cArqTmp" , "CUSTO MEDIO"		,/*Picture*/ , TAM_QUANT 	,/*lPixel*/ ,/*{|| }*/)
	//TRCell():New(oSection0,"SALDATU"	,"cArqTmp" , "SALDO ATUAL" 		,/*Picture*/ , TAM_VALOR  	,/*lPixel*/ ,/*{|| }*/)// Item Contabil

	// oSection1
	oSection1 := TRSection():New(oReport,"Filial",{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) 

	//MemoWrite("C:\TEMP\oTReport.TXT",U_xMethObj(oReport))
	//MemoWrite("C:\TEMP\oTRSection.TXT",U_xMethObj(oSection1))
	//	If lSalto
	oSection1:SetPageBreak(.T.)
	//	EndIf

	TRCell():New(oSection1,"LEGENDA"	,"cArqTmp",Upper("LEGENDA"),/*Picture*/,nTamFilial + 2 ,/*lPixel*/,{|| "FILIAL" })
	TRCell():New(oSection1,"FILIAL"		,"cArqTmp",Upper("FILIAL"),/*Picture*/,nTamProd + 2 ,/*lPixel*/,/*{|| }*/)
	TRCell():New(oSection1,"DESCFIL"    ,""		  ,,/*Picture*/, nTamDesc + 2 ,/*lPixel*/,/*{|| }*/,/*"RIGHT"*/,.T.,/*"RIGHT"*/,,,.T.)	//"DESCRICAO"
	//oSection1:Cell("FILIAL"):HideHeader()
	//oSection1:Cell("DESCFIL"):HideHeader()
	oSection1:SetHeaderSection(.F.)

	// oSection2
	oSection2 := TRSection():New(oReport,"Conta",{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) 

	TRCell():New(oSection2,"LEGENDA"	,"cArqTmp",Upper("LEGENDA"),/*Picture*/,nTamFilial + 2 ,/*lPixel*/,{|| "CONTA" })
	TRCell():New(oSection2,"CONTA"		,"cArqTmp",Upper("Conta"),/*Picture*/,nTamProd + 2 ,/*lPixel*/,/*{|| }*/)
	TRCell():New(oSection2,"DESCCTA"    ,""		  ,,/*Picture*/, nTamDesc + 2 ,/*lPixel*/,/*{|| }*/,/*"RIGHT"*/,.T.,/*"RIGHT"*/,,,.T.)	//"DESCRICAO"
	oSection2:SetHeaderSection(.F.)

	// oSection3
	oSection3 := TRSection():New(oReport,"Grupo",{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) 

	TRCell():New(oSection3,"LEGENDA"	,"cArqTmp",Upper("LEGENDA"),/*Picture*/,nTamFilial + 2 ,/*lPixel*/,{|| "GRUPO" })
	TRCell():New(oSection3,"GRUPO"		,"cArqTmp",Upper("Grupo"),/*Picture*/,nTamProd + 2 ,/*lPixel*/,/*{|| }*/)
	TRCell():New(oSection3,"DESCGRP"    ,""		  ,,/*Picture*/, nTamDesc + 2 ,/*lPixel*/,/*{|| }*/,/*"RIGHT"*/,.T.,/*"RIGHT"*/,,,.T.)	//"DESCRICAO"
	oSection3:SetHeaderSection(.F.)

	// oSection4
	//oSection4 := TRSection():New(oReport,"Armazem",{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) 

	//TRCell():New(oSection4,"LEGENDA"	,"cArqTmp",Upper("LEGENDA"),/*Picture*/,nTamFilial + 2 ,/*lPixel*/,{|| "LOCAL" })
	//TRCell():New(oSection4,"LOCAL"		,"cArqTmp",Upper("Armazem"),/*Picture*/,nTamProd + 2 ,/*lPixel*/,/*{|| }*/)
	//TRCell():New(oSection4,"DESCLOC"    ,""		  ,,/*Picture*/, nTamDesc + 2 ,/*lPixel*/,/*{|| }*/,/*"RIGHT"*/,.T.,/*"RIGHT"*/,,,.T.)	//"DESCRICAO"
	//oSection4:SetHeaderSection(.F.)

	// oSection5
	oSection4 := TRSection():New(oReport,"Produto",{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) 
	//oSection5:SetHeaderPage(.T.)
	
	TRCell():New(oSection4,"FILIAL"		,"cArqTmp" ,Upper("FILIAL")						,/*Picture*/,nTamFilial + 2 ,/*lPixel*/,/*{|| }*/)
	TRCell():New(oSection4,"PRODUTO"	,"cArqTmp" ,Upper("Produto")					,/*Picture*/,nTamProd + 2 ,/*lPixel*/, )
	TRCell():New(oSection4,"DESCPRO"	,"cArqTmp" ,Upper("Descrição")					,/*Picture*/,nTamDesc + 2 ,/*lPixel*/,/*{|| }*/)
	TRCell():New(oSection4,"UNIDMED"	,"cArqTmp" ,"U.M"								,/*Picture*/ , 5			,/*lPixel*/ ,/*{|| }*/)
	TRCell():New(oSection4,"SALDANT"	,"cArqTmp" ,"SALDO " + CFecAnt					,PesqPict("SD3","D3_CUSTO1") , TAM_VALOR	,/*lPixel*/ ,)
	TRCell():New(oSection4,"ENTRMES"	,"cArqTmp" ,"ENTRADAS " + Subs( cFecAtu , 4 )	,PesqPict("SD3","D3_CUSTO1") , TAM_VALOR	,/*lPixel*/ ,)
	TRCell():New(oSection4,"SAIDMES"	,"cArqTmp" ,"SAIDAS " + Subs( cFecAtu , 4 )		,PesqPict("SD3","D3_CUSTO1") , TAM_VALOR	,/*lPixel*/ ,)
	TRCell():New(oSection4,"SALDQTD"	,"cArqTmp" ,"QTDE ESTOQUE"						,PesqPict("SD3","D3_QUANT") , TAM_VALOR	,/*lPixel*/ ,)
	TRCell():New(oSection4,"CUSTUNI"	,"cArqTmp" ,"CUSTO MEDIO"						,PesqPict("SD3","D3_CUSTO1") , TAM_QUANT 	,/*lPixel*/ ,/*{|| }*/)
	//TRCell():New(oSection4,"SALDATU"	,"cArqTmp" ,"SALDO " + cFecAtu					,/*Picture*/ , TAM_VALOR  	,/*lPixel*/ ,/*{|| }*/)// Item Contabil
	TRCell():New(oSection4,"SALDATU"	,"cArqTmp" ,"SALDO " + dToc(dDataRef)			,PesqPict("SD3","D3_CUSTO1") , TAM_VALOR  	,/*lPixel*/ ,/*{|| }*/)// Item Contabil	

	
//	TRFunction():New(oSection5:Cell("SALDANT")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/PesqPict("SB9","B9_VINI1"),/*uFormula*/,.T.,.T.,,oSection4)
//	TRFunction():New(oSection5:Cell("ENTRMES")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/PesqPict("SB9","B9_VINI1"),/*uFormula*/,.T.,.T.,,oSection4)
//	TRFunction():New(oSection5:Cell("SAIDMES")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/PesqPict("SB9","B9_VINI1"),/*uFormula*/,.T.,.T.,,oSection4)
//	TRFunction():New(oSection5:Cell("SALDATU")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/PesqPict("SB9","B9_VINI1"),/*uFormula*/,.T.,.T.,,oSection4)

	//TRFunction():New(oSection2:Cell("B1_COD"),NIL,"COUNT",,,,,.F.,.T.)

	// oSection6 - Total Local/Armazem	
	oSection5 := TRSection():New( oReport,"TotalProduto",,, .F., .F. )	
	TRCell():New(oSection5,"TOT_000"	,"" ,""			,/*Picture*/ , nTamFilial + 2 ,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/)//,.T.,/*"RIGHT"*/,,,.T.)
	TRCell():New(oSection5,"TOT_001"	,"" ,""			,/*Picture*/ , nTamProd + 2 ,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/)//,.T.,/*"RIGHT"*/,,,.T.)
	TRCell():New(oSection5,"TOT_002"	,"" ,""			,/*Picture*/ , nTamDesc + 2 ,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/)//,.T.,/*"RIGHT"*/,,,.T.)
	TRCell():New(oSection5,"TOT_003"	,"" ,""			,/*Picture*/ , 5 ,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/)//,.T.,/*"RIGHT"*/,,,.T.)
	TRCell():New(oSection5,"TOT_ANT"	,"" ,"TOT_ANT"	,PesqPict("SD3","D3_CUSTO1") , TAM_VALOR				,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/)//,.T.,/*"RIGHT"*/,,,.T.)
	TRCell():New(oSection5,"TOT_ENT"	,""	,"TOT_ENT"	,PesqPict("SD3","D3_CUSTO1") , TAM_VALOR				,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/)//,,"RIGHT")
	TRCell():New(oSection5,"TOT_SAI"	,"" ,"TOT_SAI"	,PesqPict("SD3","D3_CUSTO1") , TAM_VALOR				,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/)//,,"RIGHT")
	TRCell():New(oSection5,"TOT_004"	,"" ,			,PesqPict("SD3","D3_QUANT") , TAM_VALOR	,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,.T.,/*"RIGHT"*/)//,,,.T.)
	TRCell():New(oSection5,"TOT_005"	,"" ,			,PesqPict("SD3","D3_CUSTO1") , TAM_QUANT 	,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,.T.,/*"RIGHT"*/)//,,,.T.)
	TRCell():New(oSection5,"TOT_ATU"	,"" ,"TOT_ATU"	,PesqPict("SD3","D3_CUSTO1") , TAM_VALOR				,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/)//,,"RIGHT")

	oSection5:Cell( "TOT_000"	):HideHeader()
	oSection5:Cell( "TOT_001"	):HideHeader() 
	oSection5:Cell( "TOT_002"	):HideHeader()
	oSection5:Cell( "TOT_003"	):HideHeader()
	oSection5:Cell( "TOT_004"	):HideHeader()
	oSection5:Cell( "TOT_005"	):HideHeader()
	oSection5:Cell( "TOT_ANT"	):HideHeader()
	oSection5:Cell( "TOT_ENT"	):HideHeader() 
	oSection5:Cell( "TOT_SAI"	):HideHeader()
	oSection5:Cell( "TOT_ATU"	):HideHeader() 

	// oSection7 - Total Grupo	
	//oSection7 := TRSection():New( oReport,"TotalGrupo",,, .F., .F. )	
	//TRCell():New(oSection7,"TOT_LEG"	,"" ,			,/*Picture*/ , nTamProd + 2 + nTamDesc + 2 + 5 ,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,.T.,/*"RIGHT"*/,,,.T.)
	//TRCell():New(oSection7,"TOT_ANT"	,"" ,"TOT_ANT"	,/*Picture*/ , TAM_VALOR				,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,.T.,/*"RIGHT"*/,,,.T.)
	//TRCell():New(oSection7,"TOT_ENT"	,""	,"TOT_ENT"	,/*Picture*/ , TAM_VALOR				,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"RIGHT")
	//TRCell():New(oSection7,"TOT_SAI"	,"" ,"TOT_SAI"	,/*Picture*/ , TAM_VALOR				,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"RIGHT")
	//TRCell():New(oSection7,"TOT_BLK"	,"" ,			,/*Picture*/ , TAM_VALOR + TAM_QUANT 	,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,.T.,/*"RIGHT"*/,,,.T.)
	//TRCell():New(oSection7,"TOT_ATU"	,"" ,"TOT_ATU"	,/*Picture*/ , TAM_VALOR				,/*lPixel*/,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,"RIGHT")
	
	//oSection6:Cell( "TOT_ANT"	):HideHeader() 
	//oSection6:Cell( "TOT_ENT"	):HideHeader() 
	//oSection6:Cell( "TOT_SAI"	):HideHeader()
	//oSection6:Cell( "TOT_ATU"	):HideHeader() 


	oReport:SetTotalInLine(.F.)

	//Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")				

Return(oReport)

Static Function ReportPrint(oReport)
	//Local oSection0 := oReport:Section(1)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local oSection3 := oReport:Section(3)
	Local oSection4 := oReport:Section(4)	 
	Local oSection5 := oReport:Section(5)
	//Local oSection6 := oReport:Section(6)
	Local cQuery    := ""		
	Local lPrim 	:= .T.
	Local cDesCT1	:= Space(TamSX3("CT1_DESC01")[1])
	Local lCalcula := .T.

	/* aberto por armazem	
	cQuery := "SELECT SB2.B2_FILIAL FILIAL, " + CRLF		//[01] - Filial
	cQuery += "			SM0.M0_FILIAL DESCFIL, " + CRLF		//[02] - Desc Filial
	cQuery += "			SB1.B1_CONTA CONTA, " + CRLF		//[03] - Conta
	cQuery += "			CASE WHEN CT1.CT1_DESC01 IS NULL THEN '"+cDesCT1+"' ELSE CT1.CT1_DESC01 END DESCCTA, " + CRLF	//[04] - Desc Conta
	cQuery += "			SB1.B1_GRUPO GRUPO, " + CRLF		//[03] - Grupo
	cQuery += "			SBM.BM_DESC DESCGRP, " + CRLF		//[03] - Grupo
	cQuery += "			SB2.B2_LOCAL LOCAL, " + CRLF		//[04] - Armazem
	cQuery += "			NNR.NNR_DESCRI DESCLOC, " + CRLF		//[04] - Armazem
	cQuery += "			SB2.B2_COD PRODUTO, " + CRLF		//[05] - Produto
	cQuery += "			SB1.B1_DESC DESCPRO, " + CRLF		//[06] - Produto
	cQuery += "			CASE WHEN ANT.B9_QINI IS NULL THEN 0 ELSE ANT.B9_QINI END QTDANT, " + CRLF	//[07] - Saldo Anterior
	cQuery += "			CASE WHEN ANT.B9_VINI1 IS NULL THEN 0 ELSE ANT.B9_VINI1 END CUSANT, " + CRLF	//[07] - Saldo Anterior
	//cQuery += "			QTDENT, " + CRLF															//[08] - Entradas Mes
	//cQuery += "			0 SAIDMES, " + CRLF															//[09] - Saidas Mes
	cQuery += "			CASE WHEN ATU.B9_CM1 IS NULL THEN SB2.B2_CM1 ELSE ATU.B9_CM1 END B9_CM1, " + CRLF															//[11] - Custo Unitario
	cQuery += "			B1_UPRC, " + CRLF													//[12] - Saldo Atual
	cQuery += "			B1_UM UNIDMED " + CRLF													//[12] - Saldo Atual

	cQuery += "FROM "+RETSQLNAME("SB1")+" SB1 " + CRLF

	cQuery += "INNER JOIN SYS_COMPANY SM0 ON SM0.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND SM0.M0_CODIGO = '" + cEmpAnt + "' " + CRLF
	cQuery += "		AND SM0.M0_CODFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF

	cQuery += "INNER JOIN "+RETSQLNAME("SB2")+" SB2 ON SB2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND SB2.B2_FILIAL = SM0.M0_CODFIL " + CRLF
	cQuery += "		AND SB2.B2_COD = B1_COD " + CRLF

	cQuery += "INNER JOIN "+RETSQLNAME("NNR")+" NNR ON NNR.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND NNR.NNR_FILIAL = '" + xFilial("NNR") + "' " + CRLF
	cQuery += "		AND NNR.NNR_CODIGO = SB2.B2_LOCAL " + CRLF

	cQuery += "LEFT JOIN "+RETSQLNAME("CT1")+" CT1 ON CT1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND CT1.CT1_FILIAL = '" + xFilial("CT1") + "' " + CRLF
	cQuery += "		AND CT1.CT1_CONTA = SB1.B1_CONTA " + CRLF

	cQuery += "INNER JOIN "+RETSQLNAME("SBM")+" SBM ON SBM.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND SBM.BM_FILIAL = '" + xFilial("SBM") + "' " + CRLF
	cQuery += "		AND SBM.BM_GRUPO = SB1.B1_GRUPO " + CRLF

	cQuery += "LEFT JOIN "+RETSQLNAME("SB9")+" ATU ON ATU.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND ATU.B9_FILIAL = SM0.M0_CODFIL " + CRLF
	cQuery += "		AND ATU.B9_COD = SB2.B2_COD " + CRLF
	cQuery += "		AND ATU.B9_LOCAL = SB2.B2_LOCAL " + CRLF
	cQuery += "		AND ATU.B9_DATA = '" + DTOS(MV_PAR03) + "' " + CRLF
//	cQuery += "		AND ATU.B9_COD = '073272         ' " + CRLF
//	cQuery += "		AND ATU.B9_LOCAL = '90' " + CRLF

	cQuery += "LEFT JOIN "+RETSQLNAME("SB9")+" ANT ON ANT.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND ANT.B9_FILIAL = SB2.B2_FILIAL " + CRLF
	cQuery += "		AND ANT.B9_COD = SB2.B2_COD " + CRLF
	cQuery += "		AND ANT.B9_LOCAL = SB2.B2_LOCAL " + CRLF
	cQuery += "		AND ANT.B9_DATA = '"+DTOS(dFecAnt)+"' " + CRLF

	cQuery += "WHERE SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND B1_FILIAL =  '" + xFilial("SB1") + "' " + CRLF
	cQuery += "		AND B1_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' " + CRLF
	cQuery += "		AND B1_CONTA BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' " + CRLF
	cQuery += "		AND B1_TIPO BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' " + CRLF
	cQuery += "		AND B1_GRUPO BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR11 + "' " + CRLF
    */
    
    // aglutinado por armazem
	cQuery := "SELECT SB2.B2_FILIAL FILIAL, " + CRLF		//[01] - Filial
	cQuery += "			SM0.M0_FILIAL DESCFIL, " + CRLF		//[02] - Desc Filial
	cQuery += "			SB1.B1_CONTA CONTA, " + CRLF		//[03] - Conta
	cQuery += "			CASE WHEN CT1.CT1_DESC01 IS NULL THEN '"+cDesCT1+"' ELSE CT1.CT1_DESC01 END DESCCTA, " + CRLF	//[04] - Desc Conta
	cQuery += "			SB1.B1_GRUPO GRUPO, " + CRLF		//[03] - Grupo
	cQuery += "			SBM.BM_DESC DESCGRP, " + CRLF		//[03] - Grupo
//	cQuery += "			SB2.B2_LOCAL LOCAL, " + CRLF		//[04] - Armazem
//	cQuery += "			NNR.NNR_DESCRI DESCLOC, " + CRLF		//[04] - Armazem
	cQuery += "			SB2.B2_COD PRODUTO, " + CRLF		//[05] - Produto
	cQuery += "			SB1.B1_DESC DESCPRO, " + CRLF		//[06] - Produto
	cQuery += "			CASE WHEN SUM(ANT.B9_QINI) IS NULL THEN 0 ELSE SUM(ANT.B9_QINI) END QTDANT, " + CRLF	//[07] - Saldo Anterior
	cQuery += "			CASE WHEN SUM(ANT.B9_VINI1) IS NULL THEN 0 ELSE SUM(ANT.B9_VINI1) END CUSANT, " + CRLF	//[07] - Saldo Anterior
	//cQuery += "			QTDENT, " + CRLF															//[08] - Entradas Mes
	//cQuery += "			0 SAIDMES, " + CRLF															//[09] - Saidas Mes
	//cQuery += "			CASE WHEN SUM(ATU.B9_CM1) IS NULL THEN ( SUM(SB2.B2_CM1) / COUNT(CASE WHEN SB2.B2_CM1 > 0 THEN SB2.B2_CM1 ELSE Null END	)) ELSE ( SUM(ATU.B9_CM1) / COUNT(CASE WHEN ATU.B9_CM1 > 0 THEN ATU.B9_CM1 ELSE Null END) ) END B9_CM1, " + CRLF															//[11] - Custo Unitario

	cQuery += "			CASE WHEN SUM(ATU.B9_CM1) IS NULL " + CRLF
	cQuery += "			THEN ( SUM(SB2.B2_CM1) / CASE WHEN COUNT(CASE WHEN SB2.B2_CM1 > 0 THEN SB2.B2_CM1 ELSE Null END) = 0 THEN 1 ELSE COUNT(CASE WHEN SB2.B2_CM1 > 0 THEN SB2.B2_CM1 ELSE Null END) END ) " + CRLF
	cQuery += "			ELSE ( SUM(ATU.B9_CM1) / CASE WHEN COUNT(CASE WHEN ATU.B9_CM1 > 0 THEN ATU.B9_CM1 ELSE Null END) = 0 THEN 1 ELSE COUNT(CASE WHEN ATU.B9_CM1 > 0 THEN ATU.B9_CM1 ELSE Null END) END ) " + CRLF 
	cQuery += "			END B9_CM1, " + CRLF 	
	
	cQuery += "			B1_UPRC, " + CRLF													//[12] - Saldo Atual
	cQuery += "			B1_UM UNIDMED " + CRLF													//[12] - Saldo Atual

	cQuery += "FROM "+RETSQLNAME("SB1")+" SB1 " + CRLF

	cQuery += "INNER JOIN SYS_COMPANY SM0 ON SM0.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND SM0.M0_CODIGO = '" + cEmpAnt + "' " + CRLF
	cQuery += "		AND SM0.M0_CODFIL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + CRLF

	cQuery += "INNER JOIN "+RETSQLNAME("SB2")+" SB2 ON SB2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND SB2.B2_FILIAL = SM0.M0_CODFIL " + CRLF
	cQuery += "		AND SB2.B2_COD = B1_COD " + CRLF

	//cQuery += "INNER JOIN "+RETSQLNAME("NNR")+" NNR ON NNR.D_E_L_E_T_ = ' ' " + CRLF
	//cQuery += "		AND NNR.NNR_FILIAL = '" + xFilial("NNR") + "' " + CRLF
	//cQuery += "		AND NNR.NNR_CODIGO = SB2.B2_LOCAL " + CRLF

	cQuery += "LEFT JOIN "+RETSQLNAME("CT1")+" CT1 ON CT1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND CT1.CT1_FILIAL = '" + xFilial("CT1") + "' " + CRLF
	cQuery += "		AND CT1.CT1_CONTA = SB1.B1_CONTA " + CRLF

	cQuery += "INNER JOIN "+RETSQLNAME("SBM")+" SBM ON SBM.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND SBM.BM_FILIAL = '" + xFilial("SBM") + "' " + CRLF
	cQuery += "		AND SBM.BM_GRUPO = SB1.B1_GRUPO " + CRLF

	cQuery += "LEFT JOIN "+RETSQLNAME("SB9")+" ATU ON ATU.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND ATU.B9_FILIAL = SM0.M0_CODFIL " + CRLF
	cQuery += "		AND ATU.B9_COD = SB2.B2_COD " + CRLF
	cQuery += "		AND ATU.B9_LOCAL = SB2.B2_LOCAL " + CRLF
	cQuery += "		AND ATU.B9_DATA = '" + DTOS(MV_PAR03) + "' " + CRLF
//	cQuery += "		AND ATU.B9_COD = '073272         ' " + CRLF
//	cQuery += "		AND ATU.B9_LOCAL = '90' " + CRLF

	cQuery += "LEFT JOIN "+RETSQLNAME("SB9")+" ANT ON ANT.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND ANT.B9_FILIAL = SB2.B2_FILIAL " + CRLF
	cQuery += "		AND ANT.B9_COD = SB2.B2_COD " + CRLF
	cQuery += "		AND ANT.B9_LOCAL = SB2.B2_LOCAL " + CRLF
	cQuery += "		AND ANT.B9_DATA = '"+DTOS(dFecAnt)+"' " + CRLF

	cQuery += "WHERE SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND B1_FILIAL =  '" + xFilial("SB1") + "' " + CRLF
	cQuery += "		AND B1_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' " + CRLF
	cQuery += "		AND B1_CONTA BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' " + CRLF
	cQuery += "		AND B1_TIPO BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' " + CRLF
	cQuery += "		AND B1_GRUPO BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR11 + "' " + CRLF

	cQuery += "GROUP BY " + CRLF
	cQuery += "		B2_FILIAL, " + CRLF
	cQuery += "		M0_FILIAL, " + CRLF
	cQuery += "		B1_CONTA, " + CRLF
	cQuery += "		CT1_DESC01, " + CRLF
	cQuery += "		B1_GRUPO, " + CRLF
	cQuery += "		BM_DESC, " + CRLF
	cQuery += "		B2_COD, " + CRLF
	cQuery += "		B1_DESC, " + CRLF
	cQuery += "		B1_UPRC, " + CRLF
	cQuery += "		B1_UM " + CRLF

//	cQuery += "ORDER BY FILIAL, CONTA, GRUPO, LOCAL, PRODUTO "
	cQuery += "ORDER BY FILIAL, CONTA, GRUPO, PRODUTO "

	MemoWrit("C:\TEMP\MGFEST40.SQL",cQuery)

	IF Select("TRBEST")
		DbSelectArea("TRBEST")
		DbCloseArea()
	ENDIF

	TCQUERY cQuery NEW ALIAS "TRBEST"	
	
	tcSetField("TRBEST","QTDANT","N",TamSX3("B9_QINI")[1],TamSX3("B9_QINI")[2])
	tcSetField("TRBEST","CUSANT","N",TamSX3("B9_VINI1")[1],TamSX3("B9_VINI1")[2])	
	tcSetField("TRBEST","B9_CM1","N",TamSX3("B9_CM1")[1],TamSX3("B9_CM1")[2])		

	dbSelectArea("TRBEST")
	TRBEST->(dbGoTop())
	
	If TRBEST->(Eof())
		DbSelectArea("TRBEST")
		DbCloseArea()
		Return
	EndIf
	
	oReport:SetMeter(TRBEST->(LastRec()))	

	nGerAnt	:= 0
	nGerEnt	:= 0
	nGerSai	:= 0
	nGerAtu	:= 0

	cFil40 	:= "" 
	
	nFilAnt	:= 0
	nFilEnt	:= 0
	nFilSai	:= 0
	nFilAtu	:= 0

	While !TRBEST->(Eof())

		If oReport:Cancel()
			Exit
		EndIf
		
		oSection1:Init()

		oReport:IncMeter()

		If !Empty(cFil40)
			oReport:SkipLine()
		EndIf

		cFil40 	:= TRBEST->FILIAL

		If lCalcula
			lCalcula := .F.
			//aMovEnt	:= EST40MOVTO("E",cFil40,TRBEST->PRODUTO,TRBEST->LOCAL,MV_PAR03)
			aMovEnt	:= EST40MOVTO("E",cFil40,TRBEST->PRODUTO,MV_PAR03)
			//aMovSai	:= EST40MOVTO("S",cFil40,TRBEST->PRODUTO,TRBEST->LOCAL,MV_PAR03)
			aMovSai	:= EST40MOVTO("S",cFil40,TRBEST->PRODUTO,MV_PAR03)
						
			nCusAnt	:= TRBEST->CUSANT
			nCusEnt := aMovEnt[2]
			nCusSai := aMovSai[2]
			nCusAtu := nCusAnt + nCusEnt - nCusSai

			nQtdAnt	:= TRBEST->QTDANT
			nQtdEnt := aMovEnt[1]
			nQtdSai := aMovSai[1]
			nQtdAtu := nQtdAnt + nQtdEnt - nQtdSai
						
			nCusMed := TRBEST->B9_CM1
		Endif
		
		If mv_par12 = 2
			If Empty(nCusAtu) .and. Empty(nQtdEnt) .and. Empty(nQtdSai)
				TRBEST->(dbSkip())
				lCalcula := .T.
				Loop
			Endif
		Endif		

		IncProc("Imprimindo Filial "+alltrim(TRBEST->FILIAL))

		oSection1:Cell("FILIAL"):SetValue(TRBEST->FILIAL)
		oSection1:Cell("DESCFIL"):SetValue(TRBEST->DESCFIL)				
		oSection1:Printline()

		//oSection2:init()

		nFilAnt	:= 0
		nFilEnt	:= 0
		nFilSai	:= 0
		nFilAtu	:= 0

		cConta	:= ""
		While !TRBEST->(Eof()) .And. TRBEST->FILIAL == cFil40

			If lCalcula
				lCalcula := .F.
				//aMovEnt	:= EST40MOVTO("E",cFil40,TRBEST->PRODUTO,TRBEST->LOCAL,MV_PAR03)
				aMovEnt	:= EST40MOVTO("E",cFil40,TRBEST->PRODUTO,MV_PAR03)
				//aMovSai	:= EST40MOVTO("S",cFil40,TRBEST->PRODUTO,TRBEST->LOCAL,MV_PAR03)
				aMovSai	:= EST40MOVTO("S",cFil40,TRBEST->PRODUTO,MV_PAR03)
						
				nCusAnt	:= TRBEST->CUSANT
				nCusEnt := aMovEnt[2]
				nCusSai := aMovSai[2]
				nCusAtu := nCusAnt + nCusEnt - nCusSai

				nQtdAnt	:= TRBEST->QTDANT
				nQtdEnt := aMovEnt[1]
				nQtdSai := aMovSai[1]
				nQtdAtu := nQtdAnt + nQtdEnt - nQtdSai
						
				nCusMed := TRBEST->B9_CM1
			Endif

			If mv_par12 = 2
				If Empty(nCusAtu) .and. Empty(nQtdEnt) .and. Empty(nQtdSai)
					TRBEST->(dbSkip())
					lCalcula := .T.
					Loop
				Endif
			Endif		

			If Empty(cConta)
				oSection2:init()
			Else
				oReport:SkipLine()
			EndIf

			cConta 	:= TRBEST->CONTA

			IncProc("Imprimindo Conta "+alltrim(TRBEST->CONTA))

			cCtaMas	:= AllTrim(EntidadeCTB(TRBEST->CONTA,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.))
			oSection2:Cell("CONTA"):SetValue(cCtaMas)//SetValue(TRBEST->CONTA)
			oSection2:Cell("DESCCTA"):SetValue({|| TRBEST->DESCCTA })				
			oSection2:Printline()

			//oSection3:init()

			nCtaAnt	:= 0
			nCtaEnt	:= 0
			nCtaSai	:= 0
			nCtaAtu	:= 0
			cGrupo := ""
			While !TRBEST->(Eof()) .And. TRBEST->(FILIAL+CONTA) == cFil40+cConta

				If lCalcula
					lCalcula := .F.
					//aMovEnt	:= EST40MOVTO("E",cFil40,TRBEST->PRODUTO,TRBEST->LOCAL,MV_PAR03)
					aMovEnt	:= EST40MOVTO("E",cFil40,TRBEST->PRODUTO,MV_PAR03)
					//aMovSai	:= EST40MOVTO("S",cFil40,TRBEST->PRODUTO,TRBEST->LOCAL,MV_PAR03)
					aMovSai	:= EST40MOVTO("S",cFil40,TRBEST->PRODUTO,MV_PAR03)
						
					nCusAnt	:= TRBEST->CUSANT
					nCusEnt := aMovEnt[2]
					nCusSai := aMovSai[2]
					nCusAtu := nCusAnt + nCusEnt - nCusSai

					nQtdAnt	:= TRBEST->QTDANT
					nQtdEnt := aMovEnt[1]
					nQtdSai := aMovSai[1]
					nQtdAtu := nQtdAnt + nQtdEnt - nQtdSai
						
					nCusMed := TRBEST->B9_CM1
				Endif
				
				If mv_par12 = 2
					If Empty(nCusAtu) .and. Empty(nQtdEnt) .and. Empty(nQtdSai)
						TRBEST->(dbSkip())
						lCalcula := .T.
						Loop
					Endif
				Endif		

				If Empty(cGrupo)
					oSection3:init()
				Else
					oReport:SkipLine()
				EndIf

				cGrupo 	:= TRBEST->GRUPO

				IncProc("Imprimindo Grupo "+alltrim(TRBEST->GRUPO))

				oSection3:Cell("GRUPO"):SetValue(TRBEST->GRUPO)
				oSection3:Cell("DESCGRP"):SetValue( TRBEST->DESCGRP)				
				oSection3:Printline()

				//oSection4:init()

				nGrpAnt	:= 0
				nGrpEnt	:= 0
				nGrpSai	:= 0
				nGrpAtu	:= 0

				//cLocal	:= ""
				oSection4:init()
				While !TRBEST->(Eof()) .And. TRBEST->(FILIAL+CONTA+GRUPO) == cFil40+cConta+cGrupo
					
					//If Empty(cLocal)
					//	oSection4:init()
					//Else
					//	oReport:SkipLine()
					//EndIf
					
					//cLocal 	:= TRBEST->LOCAL

					//IncProc("Imprimindo Armazem "+alltrim(TRBEST->LOCAL))

					//oSection4:Cell("LOCAL"):SetValue(TRBEST->LOCAL)
					//oSection4:Cell("DESCLOC"):SetValue( TRBEST->DESCLOC)				
					//oSection4:Printline()

					//oSection4:init()

					nLocAnt	:= 0
					nLocEnt	:= 0
					nLocSai	:= 0
					nLocAtu	:= 0

					//oReport:FatLine()
					
					//While !TRBEST->(Eof()) .And. TRBEST->(FILIAL+CONTA+GRUPO+LOCAL) == cFil40+cConta+cGrupo+cLocal

						oReport:IncMeter()		

						IncProc("Imprimindo Produto "+alltrim(TRBEST->PRODUTO))
						
						//EST40MOVTO(cMov,cFil,cPrd,cLocal,dDat)
						
						If lCalcula
							//aMovEnt	:= EST40MOVTO("E",cFil40,TRBEST->PRODUTO,TRBEST->LOCAL,MV_PAR03)
							aMovEnt	:= EST40MOVTO("E",cFil40,TRBEST->PRODUTO,MV_PAR03)
							//aMovSai	:= EST40MOVTO("S",cFil40,TRBEST->PRODUTO,TRBEST->LOCAL,MV_PAR03)
							aMovSai	:= EST40MOVTO("S",cFil40,TRBEST->PRODUTO,MV_PAR03)
						
							nCusAnt	:= TRBEST->CUSANT
							nCusEnt := aMovEnt[2]
							nCusSai := aMovSai[2]
							nCusAtu := nCusAnt + nCusEnt - nCusSai

							nQtdAnt	:= TRBEST->QTDANT
							nQtdEnt := aMovEnt[1]
							nQtdSai := aMovSai[1]
							nQtdAtu := nQtdAnt + nQtdEnt - nQtdSai
						
							nCusMed := TRBEST->B9_CM1
						Endif
						
						If mv_par12 = 2
							If Empty(nCusAtu) .and. Empty(nQtdEnt) .and. Empty(nQtdSai)
								TRBEST->(dbSkip())
								lCalcula := .T.
								Loop
							Endif
						Endif		
										
						lCalcula := .T.

						nLocAnt	+= nCusAnt
						nLocEnt	+= nCusEnt
						nLocSai	+= nCusSai
						nLocAtu	+= nCusAtu
						
						oSection4:Cell("FILIAL"):SetValue(TRBEST->FILIAL)
						oSection4:Cell("PRODUTO"):SetValue(TRBEST->PRODUTO)
						oSection4:Cell("DESCPRO"):SetValue(TRBEST->DESCPRO)
						oSection4:Cell("UNIDMED"):SetValue(TRBEST->UNIDMED)			
						oSection4:Cell("SALDANT"):SetValue(nCusAnt)			
						oSection4:Cell("ENTRMES"):SetValue(nCusEnt)			
						oSection4:Cell("SAIDMES"):SetValue(nCusSai)			
						oSection4:Cell("SALDQTD"):SetValue(nQtdAtu)			
						oSection4:Cell("CUSTUNI"):SetValue(nCusMed)			
						oSection4:Cell("SALDATU"):SetValue(nCusAtu)			
						oSection4:Printline()

						TRBEST->(dbSkip())

					//EndDo

					//oSection4:Finish()

					//oReport:ThinLine()
					
				//	oSection4:Finish()
					
					// Total Armazem 
					//oSection5:Init()
					
					//oSection6:Cell("TOT_000"):SetBlock( { || OemToAnsi("TOTAL") } )
					//oSection6:Cell("TOT_001"):SetBlock( { || OemToAnsi("     ") } )			
					//oSection6:Cell("TOT_002"):SetBlock( { || OemToAnsi("A r m a z e m  "+cLocal+"  ==> ") } )
					//oSection5:Cell("TOT_003"):SetBlock( { || OemToAnsi("     ") } )
					//oSection6:Cell("TOT_ANT"):SetValue(nLocAnt)			
					//oSection6:Cell("TOT_ENT"):SetValue(nLocEnt)			
					//oSection6:Cell("TOT_SAI"):SetValue(nLocSai)			
					//oSection6:Cell("TOT_ATU"):SetValue(nLocAtu)			
					//oSection6:Printline()
					
					nGrpAnt	+= nLocAnt
					nGrpEnt	+= nLocEnt
					nGrpSai	+= nLocSai
					nGrpAtu	+= nLocAtu

					//oSection6:Finish()

				EndDo

			//	oSection3:Finish()

				oSection4:Finish()
									
				// Total Grupo
				oSection5:Init()

				oSection5:Cell("TOT_000"):SetBlock( { || "TOTAL" } )
				oSection5:Cell("TOT_001"):SetBlock( { || Space(TamSX3("B1_COD")[1] + 2) } )
				oSection5:Cell("TOT_002"):SetBlock( { || "G r u p o  "+cGrupo+"  ==> " } )			
				oSection5:Cell("TOT_003"):SetBlock( { || Space(5) } )
				oSection5:Cell("TOT_ANT"):SetValue(nGrpAnt)			
				oSection5:Cell("TOT_ENT"):SetValue(nGrpEnt)			
				oSection5:Cell("TOT_SAI"):SetValue(nGrpSai)			
				oSection5:Cell("TOT_ATU"):SetValue(nGrpAtu)			
				oSection5:Printline()
				
				nCtaAnt	+= nGrpAnt
				nCtaEnt	+= nGrpEnt
				nCtaSai	+= nGrpSai
				nCtaAtu	+= nGrpAtu

				oSection5:Finish()

				
			EndDo
			
		//	oSection2:Finish()

			oSection3:Finish()

			// Total Conta
			oSection5:Init()
			
			oSection5:Cell("TOT_000"):SetBlock( { || OemToAnsi("TOTAL") } )
			oSection5:Cell("TOT_001"):SetBlock( { || OemToAnsi("     ") } )
			oSection5:Cell("TOT_002"):SetBlock( { || OemToAnsi("C o n t a  "+cCtaMas+"  ==> ") } )			
			oSection5:Cell("TOT_003"):SetBlock( { || OemToAnsi("     ") } )
			oSection5:Cell("TOT_ANT"):SetValue(nCtaAnt)			
			oSection5:Cell("TOT_ENT"):SetValue(nCtaEnt)			
			oSection5:Cell("TOT_SAI"):SetValue(nCtaSai)			
			oSection5:Cell("TOT_ATU"):SetValue(nCtaAtu)			
			oSection5:Printline()
			
			nFilAnt	+= nCtaAnt
			nFilEnt	+= nCtaEnt
			nFilSai	+= nCtaSai
			nFilAtu	+= nCtaAtu

			oSection5:Finish()

		EndDo		

		oSection2:Finish()

		oReport:ThinLine()

		oSection1:Finish()

		// Total Filial
		oSection5:Init()
		
		oSection5:Cell("TOT_000"):SetBlock( { || OemToAnsi("TOTAL") } )
		oSection5:Cell("TOT_001"):SetBlock( { || OemToAnsi("     ") } )
		oSection5:Cell("TOT_002"):SetBlock( { || OemToAnsi("F i l i a l  "+cFil40+"  ==> ") } )			
		oSection5:Cell("TOT_003"):SetBlock( { || OemToAnsi("     ") } )
		oSection5:Cell("TOT_ANT"):SetValue(nFilAnt)			
		oSection5:Cell("TOT_ENT"):SetValue(nFilEnt)			
		oSection5:Cell("TOT_SAI"):SetValue(nFilSai)			
		oSection5:Cell("TOT_ATU"):SetValue(nFilAtu)			
		oSection5:Printline()
		
		nGerAnt	+= nFilAnt
		nGerEnt	+= nFilEnt
		nGerSai	+= nFilSai
		nGerAtu	+= nFilAtu

		oSection5:Finish()

	Enddo

	// Total Geral
	oSection5:Init()
	
	oSection5:Cell("TOT_000"):SetBlock( { || OemToAnsi("TOTAL") } )
	oSection5:Cell("TOT_001"):SetBlock( { || OemToAnsi("     ") } )
	oSection5:Cell("TOT_002"):SetBlock( { || OemToAnsi("G e r a l  ==> ") } )			
	oSection5:Cell("TOT_003"):SetBlock( { || OemToAnsi("     ") } )	
	oSection5:Cell("TOT_ANT"):SetValue(nFilAnt)			
	oSection5:Cell("TOT_ENT"):SetValue(nFilEnt)			
	oSection5:Cell("TOT_SAI"):SetValue(nFilSai)			
	oSection5:Cell("TOT_ATU"):SetValue(nFilAtu)			
	oSection5:Printline()
	
	nGerAnt	+= nFilAnt
	nGerEnt	+= nFilEnt
	nGerSai	+= nFilSai
	nGerAtu	+= nFilAtu

	oSection5:Finish()

Return

//Static Function EST40MOVTO(cMov,cFil,cPrd,cLoc,dDat)
Static Function EST40MOVTO(cMov,cFil,cPrd,dDat)

	Local aRet := {0,0}
	
	dDat := dDataRef

	If cMov == "E"

		cQuery := "SELECT SUM(D1_QUANT) QUANT, SUM(D1_CUSTO) CUSTO " + CRLF		//[01] - Filial
		cQuery += "FROM "+RETSQLNAME("SD1")+" SD1 " + CRLF

		cQuery += "INNER JOIN "+RETSQLNAME("SF4")+" SF4 ON SF4.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "		AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' " + CRLF
		cQuery += "		AND SF4.F4_CODIGO = SD1.D1_TES " + CRLF
		cQuery += "		AND SF4.F4_ESTOQUE = 'S' " + CRLF

		cQuery += "WHERE SD1.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "		AND D1_FILIAL =  '" + cFil + "' " + CRLF
		cQuery += "		AND D1_COD = '" + cPrd + "' " + CRLF
		//cQuery += "		AND D1_LOCAL = '" + cLoc + "' " + CRLF
		cQuery += "		AND D1_ORIGLAN <> 'LF' " + CRLF
		cQuery += "		AND D1_DTDIGIT BETWEEN '" + Subs(DTOS(dDat),1,6)+"01" + "' AND '" + DTOS(dDat) + "' " + CRLF

		MemoWrit("C:\TEMP\MGFEST40D1.SQL",cQuery)

		IF Select("TRBMOV")
			DbSelectArea("TRBMOV")
			DbCloseArea()
		ENDIF

		TCQUERY cQuery NEW ALIAS "TRBMOV"	

		dbSelectArea("TRBEST")
	
		aRet[1] += TRBMOV->QUANT
		aRet[2] += TRBMOV->CUSTO
	
	EndIf
	

	If cMov == "S"

		cQuery := "SELECT SUM(D2_QUANT) QUANT, SUM(D2_CUSTO1) CUSTO " + CRLF		//[01] - Filial
		cQuery += "FROM "+RETSQLNAME("SD2")+" SD2 " + CRLF

		cQuery += "INNER JOIN "+RETSQLNAME("SF4")+" SF4 ON SF4.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "		AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' " + CRLF
		cQuery += "		AND SF4.F4_CODIGO = SD2.D2_TES " + CRLF
		cQuery += "		AND SF4.F4_ESTOQUE = 'S' " + CRLF

		cQuery += "WHERE SD2.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "		AND D2_FILIAL =  '" + cFil + "' " + CRLF
		cQuery += "		AND D2_COD = '" + cPrd + "' " + CRLF
		//cQuery += "		AND D2_LOCAL = '" + cLoc + "' " + CRLF
		cQuery += "		AND D2_ORIGLAN <> 'LF' " + CRLF
		cQuery += "		AND D2_EMISSAO BETWEEN '" + Subs(DTOS(dDat),1,6)+"01" + "' AND '" + DTOS(dDat) + "' " + CRLF

		MemoWrit("C:\TEMP\MGFEST40D2.SQL",cQuery)

		IF Select("TRBMOV")
			DbSelectArea("TRBMOV")
			DbCloseArea()
		ENDIF

		TCQUERY cQuery NEW ALIAS "TRBMOV"	

		dbSelectArea("TRBEST")
	
		aRet[1] += TRBMOV->QUANT
		aRet[2] += TRBMOV->CUSTO
	
	EndIf

	cQuery := "SELECT SUM(D3_QUANT) QUANT, SUM(D3_CUSTO1) CUSTO " + CRLF		//[01] - Filial
	cQuery += "FROM "+RETSQLNAME("SD3")+" SD3 " + CRLF

	cQuery += "WHERE SD3.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND D3_FILIAL =  '" + cFil + "' " + CRLF
	cQuery += "		AND D3_COD = '" + cPrd + "' " + CRLF
	//cQuery += "		AND D3_LOCAL = '" + cLoc + "' " + CRLF
	cQuery += "		AND D3_ESTORNO = ' ' " + CRLF
	cQuery += "		AND D3_EMISSAO BETWEEN '" + Subs(DTOS(dDat),1,6)+"01" + "' AND '" + DTOS(dDat) + "' " + CRLF
	If cMov == "E"
		cQuery += "		AND D3_TM <= '500' " + CRLF
		cQuery += "		AND D3_CF <> 'DE4' " + CRLF // Transferência
		//cQuery += "		AND D3_TM || D3_CF || D3_ESTORNO <> '499DE0S' " + CRLF // Estorno de Consumo
	Else
		cQuery += "		AND D3_TM > '500' " + CRLF
		cQuery += "		AND D3_CF <> 'RE4' " + CRLF // Transferência)
		//cQuery += "		AND D3_TM || D3_CF || D3_ESTORNO <> '999RE0S' " + CRLF // Consumo Estornado
	EndIf

	MemoWrit("C:\TEMP\MGFEST40D3.SQL",cQuery)

	IF Select("TRBMOV")
		DbSelectArea("TRBMOV")
		DbCloseArea()
	ENDIF

	TCQUERY cQuery NEW ALIAS "TRBMOV"	

	tcSetField("TRBMOV","QUANT","N",TamSX3("D3_QUANT")[1],TamSX3("D3_QUANT")[2])
	tcSetField("TRBMOV","CUSTO","N",TamSX3("D3_CUSTO1")[1],TamSX3("D3_CUSTO1")[2])	

	dbSelectArea("TRBEST")
	
	aRet[1] += TRBMOV->QUANT
	aRet[2] += TRBMOV->CUSTO
	
	/*RTASK0010061 - Listar transferência realizadas entre produtos - Henrique Vidal 01/10/2019 					 
					 : Exibe movimentos DE4, para qdo for realizado transferência entre produtos. 
	                 Opção da equipe interna por tratar direto no chamado */
	
	cQuery := "SELECT SUM(D3_QUANT) QUANT, SUM(D3_CUSTO1) CUSTO , COUNT(D3_COD) AS PRODREP " + CRLF		
	cQuery += "FROM "+RETSQLNAME("SD3")+" SD3 " + CRLF

	cQuery += "WHERE SD3.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND D3_FILIAL =  '" + cFil + "' " + CRLF
	cQuery += "		AND D3_COD = '" + cPrd + "' " + CRLF
	cQuery += "		AND D3_ESTORNO = ' ' " + CRLF
	cQuery += "		AND D3_EMISSAO BETWEEN '" + Subs(DTOS(dDat),1,6)+"01" + "' AND '" + DTOS(dDat) + "' " + CRLF
	If cMov == "E"
		cQuery += "		AND D3_TM <= '500' " + CRLF
		cQuery += "		AND D3_CF = 'DE4' " + CRLF 
	Else
		cQuery += "		AND D3_TM > '500' " + CRLF
		cQuery += "		AND D3_CF = 'RE4' " + CRLF 
	EndIf
	
	cQuery += "		AND EXISTS (

	cQuery += "			SELECT  PRODREP " 
	cQuery += "			FROM( " 
	cQuery += "				SELECT  COUNT(D3_COD) AS PRODREP 	" 		+ CRLF
	cQuery += "				FROM " +RETSQLNAME("SD3")+" SD3A 	" 		+ CRLF 
	cQuery += "				WHERE SD3A.D_E_L_E_T_ = ' ' 		" 		+ CRLF
	cQuery += "					AND SD3A.D3_FILIAL  = SD3.D3_FILIAL " 	+ CRLF
	cQuery += "					AND SD3A.D3_COD     = SD3.D3_COD " 	+ CRLF
	cQuery += "					AND SD3A.D3_DOC     = SD3.D3_DOC " 	+ CRLF
	cQuery += "					AND SD3A.D3_ESTORNO = ' ' " 			+ CRLF
	cQuery += "					AND SD3A.D3_EMISSAO = SD3.D3_EMISSAO " + CRLF
	cQuery += "				GROUP BY D3_COD		" 						+ CRLF
	cQuery += "			) 	" 												+ CRLF
	cQuery += "			WHERE PRODREP = 1 " 								+ CRLF    // Garante que não foi transferência de almoxarifados para o mesmo produto.
	
	cQuery += "		) " + CRLF
	
	MemoWrit("C:\TEMP\MGFEST40D3A.SQL",cQuery)

	IF Select("TRBMOV")
		DbSelectArea("TRBMOV")
		DbCloseArea()
	ENDIF

	TCQUERY cQuery NEW ALIAS "TRBMOV"	

	tcSetField("TRBMOV","QUANT","N",TamSX3("D3_QUANT")[1],TamSX3("D3_QUANT")[2])
	tcSetField("TRBMOV","CUSTO","N",TamSX3("D3_CUSTO1")[1],TamSX3("D3_CUSTO1")[2])	

	dbSelectArea("TRBEST")
	
	aRet[1] += TRBMOV->QUANT
	aRet[2] += TRBMOV->CUSTO
	
	/* Fim RTASK001061*/

Return aRet

Static Function ValidPerg( cPerg )
	Local _nLaco := 0
	Local aArea  := GetArea()
	Local aPerg  := {}

	aAdd(aPerg,{cPerg,"01","Filial De ?"			,"mv_ch1","C",06					,0,1,"G","","mv_par01","","","","","","","","","","","","","","","SM0",})
	aAdd(aPerg,{cPerg,"02","Filial Até ?"			,"mv_ch2","C",06					,0,1,"G","","mv_par02","","","","","","","","","","","","","","","SM0",})
	aAdd(aPerg,{cPerg,"03","Data de Referência ?"	,"mv_ch3","D",08					,0,1,"G","","mv_par03","","","","","","","","","","","","","","","  ",})
	aAdd(aPerg,{cPerg,"04","Conta De ?"				,"mv_ch4","C",TamSX3("CT1_CONTA")[1],0,1,"G","","mv_par04","","","","","","","","","","","","","","","CT1",})
	aAdd(aPerg,{cPerg,"05","Conta Até ?"			,"mv_ch5","C",TamSX3("CT1_CONTA")[1],0,1,"G","","mv_par05","","","","","","","","","","","","","","","CT1",})
	aAdd(aPerg,{cPerg,"06","Produto De ?"			,"mv_ch6","C",TamSX3("B1_COD")[1]	,0,1,"G","","mv_par06","","","","","","","","","","","","","","","SB1",})
	aAdd(aPerg,{cPerg,"07","Produto Até ?"			,"mv_ch7","C",TamSX3("B1_COD")[1]	,0,1,"G","","mv_par07","","","","","","","","","","","","","","","SB1",})
	aAdd(aPerg,{cPerg,"08","Tipo De ?"				,"mv_ch8","C",TamSX3("B1_TIPO")[1]	,0,1,"G","","mv_par08","","","","","","","","","","","","","","","02",})
	aAdd(aPerg,{cPerg,"09","Tipo Até ?"				,"mv_ch9","C",TamSX3("B1_TIPO")[1]	,0,1,"G","","mv_par09","","","","","","","","","","","","","","","02",})
	aAdd(aPerg,{cPerg,"10","Grupo De ?"				,"mv_cha","C",TamSX3("B1_GRUPO")[1]	,0,1,"G","","mv_par10","","","","","","","","","","","","","","","SBM",})
	aAdd(aPerg,{cPerg,"11","Grupo Até ?"			,"mv_chb","C",TamSX3("B1_GRUPO")[1]	,0,1,"G","","mv_par11","","","","","","","","","","","","","","","SBM",})
	//aAdd(aPerg,{cPerg,"12","Tipo de Selecao ?"		,"mv_chc","N",1						,0,1,"C","","mv_par12","Todos","Todos","Todos","Somente c/ Movimento","Somente c/ Movimento","Somente c/ Movimento","","","","","","","","","",})
	//aAdd(aPerg,{cPerg,"13","Valor Zerado ?"			,"mv_chd","N",1						,0,1,"C","","mv_par13","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","",})	
	aAdd(aPerg,{cPerg,"12","Tipo de Selecao ?"		,"mv_chc","N",1						,0,1,"C","","mv_par12","Todos","Todos","Todos","Mov. maior zero","Mov. maior zero","Mov. maior zero","","","","","","","","","",})	

	DbSelectArea("SX1")	
    DbSetOrder(1)                            
	For _nLaco:=1 to LEN(aPerg)                                   
		If !dbSeek(PADR(aPerg[_nLaco,1],10)+aPerg[_nLaco,2])
	    	RecLock("SX1",.T.)
				SX1->X1_Grupo     := aPerg[_nLaco,01]
				SX1->X1_Ordem     := aPerg[_nLaco,02]
				SX1->X1_Pergunt   := aPerg[_nLaco,03]
				SX1->X1_PerSpa    := aPerg[_nLaco,03]
				SX1->X1_PerEng    := aPerg[_nLaco,03]				
				SX1->X1_Variavl   := aPerg[_nLaco,04]
				SX1->X1_Tipo      := aPerg[_nLaco,05]
				SX1->X1_Tamanho   := aPerg[_nLaco,06]
				SX1->X1_Decimal   := aPerg[_nLaco,07]
				SX1->X1_Presel    := aPerg[_nLaco,08]
				SX1->X1_Gsc       := aPerg[_nLaco,09]
				SX1->X1_Valid     := aPerg[_nLaco,10]
				SX1->X1_Var01     := aPerg[_nLaco,11]
				SX1->X1_Def01     := aPerg[_nLaco,12]
				SX1->X1_Cnt01     := aPerg[_nLaco,13]
				SX1->X1_Var02     := aPerg[_nLaco,14]
				SX1->X1_Def02     := aPerg[_nLaco,15]
				SX1->X1_Cnt02     := aPerg[_nLaco,16]
				SX1->X1_Var03     := aPerg[_nLaco,17]
				SX1->X1_Def03     := aPerg[_nLaco,18]
				SX1->X1_Cnt03     := aPerg[_nLaco,19]
				SX1->X1_Var04     := aPerg[_nLaco,20]
				SX1->X1_Def04     := aPerg[_nLaco,21]
				SX1->X1_Cnt04     := aPerg[_nLaco,22]
				SX1->X1_Var05     := aPerg[_nLaco,23]
				SX1->X1_Def05     := aPerg[_nLaco,24]
				SX1->X1_Cnt05     := aPerg[_nLaco,25]
				SX1->X1_F3        := aPerg[_nLaco,26]
			MsUnLock()
		EndIf
	Next

	RestArea( aArea )

Return
