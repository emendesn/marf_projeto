#INCLUDE "MATR260.CH"
#INCLUDE "PROTHEUS.CH"

//---------------------------------------------------------
/*/{Protheus.doc} MGFEST43
//Alteração do Relatório MATR260 - Posicao dos Estoques
@type function
@author Ferraz
@since 23/10/2018
@version 12.1.17
@return .T.
@example
@history 23/10/2018, Odair Ferraz, Criação cfe. MIT044: 684
/*/
//---------------------------------------------------------


User Function MGFEST43()
Local oReport
Local nTamLOC      := TamSX3("B2_LOCAL")[1]
Private cALL_LOC   := Replicate('*', nTamLOC)
Private cALL_Empty := Replicate(' ', nTamLOC)
Private cALL_ZZ    := Replicate('Z', nTamLOC) 
Private aSB1Ite    := {}
Private lFirst	   := .T.                                                                            
                                                                          
aSB1Ite	:= TAMSX3("B1_CODITE")     

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()
Local aOrdem    := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009)}    //" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "###" Por Almoxarifado   "
Local cAliasTRB := GetNextAlias()
Local aSizeQT	:= TamSX3("B2_QATU")
Local aSizeVL	:= TamSX3("B2_VATU1")
Local nTamProd	:= TamSX3("B1_COD")[1] - 5
Local aSizeLZ   := TamSX3("NNR_DESCRI")
Local cPictQT   := PesqPict("SB2","B2_QATU")
Local cPictVL   := PesqPict("SB2","B2_VATU1")
Local cPictLZ   := PesqPict("NNR","NNR_DESCRI")
Local oSection 

Private lVeic    := Upper(GetMV("MV_VEICULO"))=="S"

while File (cAliasTRB+'.DBF')   // controle para caso o usuario solicite o mesmo relatorio em mais de uma instancias e não causar error.log 
	cAliasTRB:=GetNextAlias()
endDo

oReport:= TReport():New("MGFEST43",STR0001,"MTR260",,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                ³
//³ mv_par01     // Aglutina por: Almoxarifado / Filial / Empresa       ³
//³ mv_par02     // Filial de                                           ³
//³ mv_par03     // Filial ate                                          ³
//³ mv_par04     // almoxarifado de                                     ³
//³ mv_par05     // almoxarifado ate                                    ³
//³ mv_par06     // codigo de                                           ³
//³ mv_par07     // codigo ate                                          ³
//³ mv_par08     // tipo de                                             ³
//³ mv_par09     // tipo ate                                            ³
//³ mv_par10     // grupo de                                            ³
//³ mv_par11     // grupo ate                                           ³
//³ mv_par12     // descricao de                                        ³
//³ mv_par13     // descricao ate                                       ³
//³ mv_par14     // imprime produtos: Todos /Positivos /Negativos       ³
//³ mv_par15     // Saldo a considerar : Atual / Fechamento / Movimento |
//³ mv_par16     // Qual Moeda (1 a 5)                                  ³
//³ mv_par17     // Aglutina por UM ?(S)im (N)ao                        ³
//³ mv_par18     // Lista itens zerados ? (S)im (N)ao                   ³
//³ mv_par19     // Imprimir o Valor ? Custo / Custo Std / Ult Prc Compr³
//³ mv_par20     // Data de Referencia                                  ³
//³ mv_par21     // Lista valores zerados ? (S)im (N)ao                 ³
//³ mv_par22     // QTDE na 2a. U.M. ? (S)im (N)ao                      ³
//³ mv_par23     // Imprime descricao do Armazem ? (S)im (N)ao          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection := TRSection():New(oReport,STR0053,{"SB2","SB1","SBM"},aOrdem) //"Saldos em Estoque"   
MontaTrab(oReport,oSection:GetOrder(),cAliasTRB,oSection,.T.) 
oReport:= TReport():New("MGFEST43",STR0001,"MTR260", {|oReport| ReportPrint(oreport,aOrdem,cAliasTRB)},STR0002+" "+STR0003+" "+STR0004) //"Relacao da Posicao do Estoque"
oReport:SetUseGC(.F.) //-- Desabilita GE para não conflitar com perguntas do relatório

oReport:SetLandscape()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Sessao 1                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection := TRSection():New(oReport,STR0053,{"SB2","SB1","SBM",cAliasTRB},aOrdem) //"Saldos em Estoque"   
oSection:SetTotalInLine(.F.)

TRCell():New(oSection,'B1_COD'		,'SB1',STR0036,/*Picture*/,nTamProd,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'B1_DESC'		,'SB1',STR0039,/*Picture*/,If(oReport:GetOrientation() == 1,40,),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'B1_UM'		,'SB1',STR0040,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,"RIGHT")

TRCell():New(oSection,'B1_TIPO'		,'SB1',STR0037,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'DESCRTP'		,cAliasTRB,"DESCR TIPO",/*Picture*/,33,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection,'B1_GRUPO'	,'SB1',STR0038,/*Picture*/,5,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'GRP_PROD'	,cAliasTRB,"DESCR GRUP",/*Picture*/,38,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection,'B1_SEGUM'	,'SB1',STR0040,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'B2_FILIAL'	,'SB2',STR0041,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'B2_LOCAL'	,'SB2',STR0042,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection,'QUANT'		,cAliasTRB,STR0043+CRLF+STR0044,cPictQT						   ,aSizeQT[1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection,'QUANTR'		,cAliasTRB,STR0045+CRLF+STR0046,cPictQT						   ,aSizeQT[1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection,'DISPON'		,cAliasTRB,STR0047+CRLF+STR0048,cPictQT						   ,aSizeQT[1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection,'VALOR'		,cAliasTRB,STR0049+CRLF+STR0044,If(cPaisLoc=="CHI",'',cPictVL) ,aSizeVL[1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection,'VALORR'		,cAliasTRB,STR0049+CRLF+STR0050,If(cPaisLoc=="CHI",'',cPictVL) ,aSizeVL[1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection,'DESCARM'		,cAliasTRB,STR0051+CRLF+STR0052,cPictLZ						   ,aSizeLZ[1],/*lPixel*/,/*{|| code-block de impressao }*/)

oSection:SetHeaderPage()
oSection:SetNoFilter(cAliasTRB)

Return(oReport)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint ³ Autor ³Marcos V. Ferreira   ³ Data ³16/06/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±³          ³ExpA2: Array com as ordem do relatorio                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR260			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasTRB)

Local oSection   := oReport:Section(1)
Local nOrdem     := oSection:GetOrder()
Local aRegs      := {}
// Local cCodAnt    := ""   // odair
Local lRet       := .T.
Local oBreak01
Local oBreak02
Local oBreak03

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Private                                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lVeic    := Upper(GetMV("MV_VEICULO"))=="S"
//Private aSB1Ite := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por Empresa/Filial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lCusUnif := A330CusFil()
Private nDec     := MsDecimais(mv_par16)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao do titulo do relatorio                             |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title()+" - ("+AllTrim(aOrdem[oSection:GetOrder()])+" - "+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par16))))+")")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSB1Ite	:= TAMSX3("B1_CODITE")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da linha de SubTotal                               |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If StrZero(nOrdem,1) $ "245"
	If nOrdem == 2
		//-- SubtTotal por Tipo
		oBreak01 := TRBreak():New(oSection,oSection:Cell("B1_TIPO"),STR0016+" "+STR0017,.F.)
	ElseIf nOrdem == 4
		//-- SubtTotal por Grupo
		oBreak01 := TRBreak():New(oSection,oSection:Cell("B1_GRUPO"),STR0016+" "+STR0018,.F.)
	ElseIf nOrdem == 5         
		//-- SubtTotal por Armazem
		oBreak01 := TRBreak():New(oSection,oSection:Cell("B2_LOCAL"),STR0033,.F.)
	EndIf
	TRFunction():New(oSection:Cell('QUANT'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell('QUANTR'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell('DISPON'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell('VALOR'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell('VALORR'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da linha de SubTotal da Unidade de Medida          |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par17 == 1
	If mv_par22 == 1 //-- SubTotal pela 2a.U.M.
		oBreak02 := TRBreak():New(oSection,oSection:Cell("B1_SEGUM"),STR0019,.F.)
	Else //-- SubTotal pela 1a. U.M.
		oBreak02 := TRBreak():New(oSection,oSection:Cell("B1_UM"),STR0019,.F.)
	EndIf
	TRFunction():New(oSection:Cell('QUANT'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell('QUANTR'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell('DISPON'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell('VALOR'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection:Cell('VALORR'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da linha de Total Geral                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRFunction():New(oSection:Cell('QUANT'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection:Cell('QUANTR'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection:Cell('DISPON'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection:Cell('VALOR'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection:Cell('VALORR'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Visualizar a coluna B1_UM ou B1_SEGUM conforme parametrizacao |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par22 == 1
	oSection:Cell('B1_UM'):Disable()
Else
	oSection:Cell('B1_SEGUM'):Disable()
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Visualizar "Descricao do Armazem" conforme parametrizacao     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par23 != 1
	oSection:Cell('DESCARM'):Disable()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta as perguntas para Custo Unificado                     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusUnif .And. ((mv_par01==1) .Or. !(mv_par04==cALL_LOC) .Or. !(mv_par05==cALL_LOC) .Or. nOrdem==5)
	If Aviso(STR0024,STR0025+CHR(10)+CHR(13)+STR0029+CHR(10)+CHR(13)+STR0026+CHR(10)+CHR(13)+STR0027+CHR(10)+CHR(13)+STR0028+CHR(10)+CHR(13)+STR0030,{STR0031,STR0032}) == 2
		lRet := .F.
	EndIf	
EndIf

If lRet

	If mv_par04 == cALL_LOC
		mv_par04 := cALL_Empty
	EndIf

	If mv_par05 == cALL_LOC
		mv_par05 := cALL_ZZ
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta parametro de configuracao da Moeda                    |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mv_par16 := If( ((mv_par16 < 1) .Or. (mv_par16 > 5)),1,mv_par16 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta arquivo de trabalho                                    |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	MontaTrab(oReport,nOrdem,cAliasTRB,oSection,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	Processando Impressao                                        |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection:aUserFilter := {}

	dbSelectArea( cAliasTRB )
	dbGoTop()
	oReport:SetMeter(LastRec())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	Posiciona nas tabelas SB1 e SB2 E SBM                             |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TRPosition():New(oSection,"SB1",1,{|| If(mv_par01==3 .And. FWModeAccess("SB1") == "E" .And. FWModeAccess("SB2") == "E",(cAliasTRB)->FILIAL+(cAliasTRB)->CODIGO,xFilial("SB1")+(cAliasTRB)->CODIGO)})
	TRPosition():New(oSection,"SB2",1,{|| (cAliasTRB)->FILIAL+(cAliasTRB)->CODIGO+(cAliasTRB)->LOCAL})
	TRPosition():New(oSection,"SBM",1,{|| (cAliasTRB)->FILIAL+(cAliasTRB)->GRUPO})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	Aglutina por Armazem/Filial/Empresa                          |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par01 == 2
		If !(nOrdem == 5)
			oSection:Cell("B2_LOCAL"):SetValue(cALL_LOC)
		EndIf
	ElseIf mv_par01 == 3
		oSection:Cell("B2_FILIAL"):SetValue(Replicate("*",FWSizeFilial()))
		If !(nOrdem == 5)
			oSection:Cell("B2_LOCAL"):SetValue(cALL_LOC)
		EndIf
	EndIf

	oSection:Init()
    // cCodAnt  := ""   // Odair
	While !oReport:Cancel() .And. !Eof()

		oReport:IncMeter()
	
		If ( (mv_par14 == 1) .Or. ((mv_par14 == 2) .And. (QtdComp(FIELD->QUANT) >= QtdComp(0)) ) .Or. ;
		   ( (mv_par14 == 3) .And. (QtdComp(FIELD->QUANT) < QtdComp(0)) ) )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³	Validacao para Custo Unificado com Qtde. Zerada              |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lCusUnif
				If (mv_par18==2) .And. (QtdComp(FIELD->QUANT)==QtdComp(0))
					dbSkip()
					Loop	
				EndIf	
			EndIf


/*  // odair
		    If (cAliasTRB)->CODIGO == cCodAnt
				oSection:Cell('B1_COD'		):Hide()
				oSection:Cell('B1_TIPO'		):Hide()
				oSection:Cell('B1_GRUPO'	):Hide()
				oSection:Cell('B1_DESC'		):Hide()
				If mv_par22 == 1
					oSection:Cell('B1_SEGUM'):Hide()
				Else
					oSection:Cell('B1_UM'	):Hide()
				EndIf
		    Else
				oSection:Cell('B1_COD'		):Show()
				oSection:Cell('B1_TIPO'		):Show()
				oSection:Cell('B1_GRUPO'	):Show()
				oSection:Cell('B1_DESC'		):Show()
				If mv_par22 == 1
					oSection:Cell('B1_SEGUM'):Show()
				Else
					oSection:Cell('B1_UM'	):Show()
				EndIf	
		    EndIf
*/		
			oSection:PrintLine() 
	
			//cCodAnt := (cAliasTRB)->CODIGO       // odair
		EndIf
		dbSkip()
	EndDo

	oSection:Finish()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	Apagando arquivo de trabalho temporario                      |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( cAliasTRB )
	dbCloseArea()
	FErase( cAliasTRB+GetDBExtension() ) 
	FErase( cAliasTRB+OrdBagExt() )

EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaTrab | Autor ³ Marcos V. Ferreira    ³ Data ³ 16/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preparacao do Arquivo de Trabalho p/ Relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR260                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaTrab(oReport,nOrdem,cAliasTRB,oSection,lVisualiz)
Local cWhere	:= ""
Local cWhereB1  := ""
Local cWhereNNR := ""
Local cIndxKEY	:= ""
Local aSizeQT	:= TamSX3( "B2_QATU" )
Local aSizeVL	:= TamSX3( "B2_VATU1")
Local aSaldo	:= {}
Local nQuant	:= 0
Local nValor	:= 0
Local nQuantR	:= 0
Local nValorR	:= 0
//Local cFilOK	:= cFilAnt   //odair
Local cAliasSB1	:= "SB1"
Local lExcl		:= .F.
Local lAglutLoc := .F.
Local lAglutFil := .F.
Local lAchou    := .F.
Local cSeek     := ""
Local cAliasSB2 := "SB2"
Local cUM    	:= If(mv_par22 == 1,"SEGUM ","UM    ")
Local aCampos 	:= {	{ "FILIAL"	,"C",FWSizeFilial(),00 },;
						{ "CODIGO"	,"C",TamSX3("B1_COD")[1],00 },;
						{ "LOCAL "	,"C",TamSX3("B2_LOCAL")[1],00 },;
						{ "DESCRI"	,"C",If(oReport:GetOrientation() == 1,45,TamSX3("B1_DESC")[1]),00 },;
						{ "TIPO "	,"C",02	,00 },;
						{ "DESCRTP" ,"C",If(oReport:GetOrientation() == 1,40,33),00 },;
						{ cUM     	,"C",02	,00 },;
						{ "GRUPO "	,"C",04	,00 },;
						{ "GRP_PROD" ,"C",If(oReport:GetOrientation() == 1,38,TamSX3("BM_DESC")[1]),00 },;
						{ "VALORR"	,"N",aSizeVL[ 1 ]+1	, aSizeVL[ 2 ] },;
						{ "QUANTR"	,"N",aSizeQT[ 1 ]+1	, aSizeQT[ 2 ] },;
						{ "VALOR "	,"N",aSizeVL[ 1 ]+1	, aSizeVL[ 2 ] },;
						{ "QUANT "	,"N",aSizeQT[ 1 ]+1	, aSizeQT[ 2 ] },;
						{ "DESCARM"	,"C",15	,00 },;
						{ "DISPON"	,"N",aSizeQT[ 1 ]+1	, aSizeQT[ 2 ] };
					 }

Local cFilUser := oSection:GetAdvplExp()
Local dDataRef
Local aStrucSB1 := SB1->(dbStruct())      
Local aStrucSB2 := SB2->(dbStruct())      
Local nX

Local XSB1 := SB1->(XFILIAL("SB1"))
Local XSB2 := SB2->(XFILIAL("SB2"))

Default lVisualiz:= .F. 

If !lFirst
	dbSelectArea( cAliasTRB )
	DBCLOSEAREA()
else
	lfirst := .F.
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Aglutina por Armazem/Filial/Empresa                          |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 2
	If !(nOrdem == 5)
		lAglutLoc := .T.
	EndIf
ElseIf mv_par01 == 3
	lAglutFil := .T.
	If !(nOrdem == 5)
		lAglutLoc := .T.
	EndIf
EndIf

dDataRef := IIf(Empty(mv_par20),dDataBase,mv_par20)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Para SIGAVEI, SIGAPEC e SIGAOFI                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lVeic
	If (mv_par01 == 1)
		If (nOrdem == 5)
			cIndxKEY := "LOCAL"
		Else
			cIndxKEY := "FILIAL"
		EndIf
		Do Case
			Case (nOrdem == 1)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (nOrdem == 2)
				cIndxKEY += "+TIPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+DESCRI+CODIGO+LOCAL"
			Case (nOrdem == 4)
				cIndxKEY += "+GRUPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+FILIAL"
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
		EndCase
	Else //-- (mv_par01 == 1)
		If (nOrdem == 5)
			cIndxKEY := "LOCAL"
		Else
			cIndxKEY := ""
		EndIf

		Do Case
			Case (nOrdem == 1)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODIGO+FILIAL+LOCAL")
			Case (nOrdem == 2)
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "TIPO")
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += "+CODIGO+FILIAL+LOCAL"
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "DESCRI+CODIGO+FILIAL+LOCAL")
			Case (nOrdem == 4)
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "GRUPO")
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += "+CODIGO+FILIAL+LOCAL"
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODIGO+FILIAL")
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODIGO+LOCAL")
		EndCase
	EndIf
Else
	aAdd(aCampos,{"CODITE","C",aSB1Ite[ 1 ],00})
	If (mv_par01 == 1) // ARMAZEN
		If (nOrdem == 5) // ALMOXARIFADO
			cIndxKEY := "LOCAL"
		Else
			cIndxKEY := "FILIAL"
		EndIf
		Do Case
			Case (nOrdem == 1)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (nOrdem == 2)
				cIndxKEY += "+TIPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
 				cIndxKEY += "+DESCRI+CODITE+LOCAL"
			Case (nOrdem == 4)
				cIndxKEY += "+GRUPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+FILIAL"
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
		EndCase
	Else // FILIAL / EMPRESA
		If (nOrdem == 5) // ALMOXARIFADO
			cIndxKEY := "LOCAL"
		Else
			cIndxKEY := ""
		EndIf
		Do Case
			Case (nOrdem == 1) // CODIGO
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (nOrdem == 2)
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "TIPO")
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "DESCRI+CODITE+FILIAL+LOCAL")
			Case (nOrdem == 4)
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "GRUPO")
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+FILIAL")
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+LOCAL")
		EndCase
	EndIf
EndIf

dbSelectArea(0)
dbCreate(cAliasTRB,aCampos)

dbUseArea( .F.,,cAliasTRB,cAliasTRB,.F.,.F. )
IndRegua(cAliasTRB,cAliasTRB,cIndxKEY,,,STR0013)   //"Organizando Arquivo..."

If lVisualiz
	Return
EndIf

dbSelectArea("SB2")
oReport:SetMeter(LastRec())        

    cSelect := "%"
If !Empty(cFilUser)
	For nX := 1 To SB2->(FCount())
		cName := SB2->(FieldName(nX))
	 	If AllTrim( cName ) $ cFilUser
      		If aStrucSB2[nX,2] <> "M"  
      			If !cName $ cSelect 
	        		cSelect += ","+cName+" "
	          	Endif 	
	       	EndIf
		EndIf 			       	
	Next nX 
	For nX := 1 To SB1->(FCount())
		cName := SB1->(FieldName(nX))
	 	If AllTrim( cName ) $ cFilUser
      		If aStrucSB1[nX,2] <> "M"  
      			If !cName $ cSelect 
	        		cSelect += ","+cName+" "
	          	Endif 	
	       	EndIf
		EndIf 			       	
	Next nX 		
Endif	
cSelect += "%"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro adicional no clausula Where                                     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cWhere := "%"
If lVeic
	cWhere += "SB1.B1_CODITE BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' "
Else
	cWhere += "SB1.B1_COD    BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' "
EndIf
cWhere += "%"

cWhereB1 := "%"
If mv_par01 <> 3
	cWhereB1 += ("   B1_FILIAL = '" + xSB1 + "'")
Else	
        If FWModeAccess("SB1") == "E" .And. FWModeAccess("SB2") == "E"
		cWhereB1 += " B1_FILIAL = B2_FILIAL"
	Else
		cWhereB1 += ("   B1_FILIAL = '" + xSB1 + "'")
	EndIf	
Endif	
cWhereB1 += "%"

cWhereNNR := "%"
If mv_par01 <> 3
	cWhereNNR += ("    NNR_FILIAL = '" + xFilial("NNR") + "'")
Else	
        If FWModeAccess("NNR") == "E" .And. FWModeAccess("SB2") == "E"
		cWhereNNR += "  NNR_FILIAL = B2_FILIAL"
	Else
		cWhereNNR += ("    NNR_FILIAL = '" + xFilial("NNR") + "'")
	EndIf	
Endif	
cWhereNNR += "%"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

cAliasSB2 := GetNextAlias()
cAliasSB1 := cAliasSB2 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do Embedded SQL                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginSql Alias cAliasSB2
		SELECT B2_FILIAL, B2_LOCAL, B2_COD, B2_QATU, B2_QTSEGUM, B2_QFIM, B2_QFIM2, B2_VATU1, B2_VATU2, 
				B2_VATU3, B2_VATU4, B2_VATU5, B2_VFIMFF1, B2_VFIMFF2, B2_VFIMFF3, B2_VFIMFF4, B2_VFIMFF5,
				B2_QEMP, B2_QEMP2, B2_QEMPPRE, B2_RESERVA, B2_RESERV2, B2_QEMPSA, B2_QEMPPRJ, B2_VFIM1,
				B2_QEMPPR2, B2_VFIM2, B2_VFIM3, B2_VFIM4, B2_VFIM5, B1_COD, B1_FILIAL, B1_TIPO, B1_GRUPO,
				B1_DESC, B1_GRUPO, B1_CUSTD, B1_UPRC, B1_MCUSTD, B1_SEGUM, B1_UM, B1_CODITE, NNR_DESCRI, 
				B2_SALPPRE, B2_QEPRE2, BM_DESC
				%Exp:cSelect%

		FROM %table:SB2% SB2,%table:SB1% SB1,%table:NNR% NNR,%table:SBM% SBM

		WHERE SB2.B2_FILIAL BETWEEN %Exp:mv_par02% 	AND %Exp:mv_par03% 
			AND SB2.B2_LOCAL BETWEEN %Exp:mv_par04% 	AND %Exp:mv_par05% 
			AND SB2.B2_COD = SB1.B1_COD  
            AND SBM.BM_GRUPO = SB1.B1_GRUPO
			AND SB2.B2_LOCAL = NNR.NNR_CODIGO  
			AND SB1.B1_GRUPO >= %Exp:mv_par10% 		
			AND SB1.B1_GRUPO <= %Exp:mv_par11%	
			AND SB1.B1_DESC >= %Exp:mv_par12% 
			AND SB1.B1_DESC  <= %Exp:mv_par13%	 
			AND SB1.B1_TIPO  BETWEEN %Exp:mv_par08% AND %Exp:mv_par09%	 
			AND %Exp:cWhereB1% 
			AND %Exp:cWhereNNR%  
			AND %Exp:cWhere%   
			AND SB2.%NotDel% 	
			AND	NNR.%NotDel% 
			AND SB1.%NotDel%
			AND SBM.%NotDel%
EndSql		

   	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo de trabalho                              |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAliasSB2 )

   	For nX := 1 To Len(aStrucSB2)
   		If aStrucSB2[nX][2] <> "C"
   			TcSetField(cAliasSB2,aStrucSB2[nX][1],aStrucSB2[nX][2],aStrucSB2[nX][3],aStrucSB2[nX][4])
  		EndIf
  	Next

If xFilial("SB2") != Space(FwSizeFilial()) 
	lExcl := .T.
EndIf

dbSelectArea( cAliasSB2 )

While !oReport:Cancel() .And. !Eof()

 	//odair - tirei o comentário do Odair - Edson Deluca
	//If lExcl
	//	cFilAnt := (cAliasSB2)->B2_FILIAL
	//EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro escolhido                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !Empty(cFilUser)
		SB1->(dbSetOrder(1))
	    SB1->(dbSeek( xFilial("SB1") + (cAliasSB2)->B2_COD) )
	    If !(&(cFilUser))
	       dbSkip()
    	   Loop
    	EndIf   
	EndIf
	
	oReport:IncMeter()
	
	Do Case
		Case (mv_par15 == 1)
			nQuant := If( mv_par22==1, ConvUM( (cAliasSB2)->B2_COD, (cAliasSB2)->B2_QATU, (cAliasSB2)->B2_QTSEGUM, 2 ), (cAliasSB2)->B2_QATU )
		Case (mv_par15 == 2)
			nQuant := If( mv_par22==1, ConvUM( (cAliasSB2)->B2_COD, (cAliasSB2)->B2_QFIM, (cAliasSB2)->B2_QFIM2, 2 ), (cAliasSB2)->B2_QFIM )
		Case (mv_par15 == 3)
			nQuant := (aSaldo := CalcEst( (cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,dDataRef+1,IIf(lExcl,Nil,(cAliasSB2)->B2_FILIAL) ))[ If( mv_par22==1, 7, 1 ) ]
		Case (mv_par15 == 4)
			nQuant := If( mv_par22==1, ConvUM( (cAliasSB2)->B2_COD, (cAliasSB2)->B2_QFIM, (cAliasSB2)->B2_QFIM2, 2 ), (cAliasSB2)->B2_QFIM )
		Case (mv_par15 == 5)
			nQuant := (aSaldo := CalcEstFF( (cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,dDataRef+1,(cAliasSB2)->B2_FILIAL ))[ If( mv_par22==1, 7, 1 ) ]
	EndCase
	
	
	dbSelectArea( cAliasSB1 )

	If (mv_par19 == 1)
		Do Case           
			Case (mv_par15 == 1)
				nValor := (cAliasSB2)->(FieldGet( FieldPos( "B2_VATU"+Str( mv_par16,1 ) ) ))
			Case (mv_par15 == 2)
				nValor := (cAliasSB2)->(FieldGet( FieldPos( "B2_VFIM"+Str( mv_par16,1 ) ) ))
			Case (mv_par15 == 3)
				nValor := aSaldo[ 1+mv_par16 ]
			Case (mv_par15 == 4)
				nValor := (cAliasSB2)->(FieldGet( FieldPos( "B2_VFIMFF"+Str( mv_par16,1 ) ) ))
			Case (mv_par15 == 5)
				nValor := aSaldo[ 1+mv_par16 ]
		EndCase
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Converte valores para a moeda do relatorio (C.St. e U.Pr.Compra)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case (mv_par19 == 2)
				nValor := nQuant * xMoeda( RetFldProd((cAliasSB1)->B1_COD,"B1_CUSTD",cAliasSB1),Val( (cAliasSB1)->B1_MCUSTD ),mv_par16,dDataRef,4 )
			Case (mv_par19 == 3)  // Ult.Pr.Compra sempre na Moeda 1
				nValor := nQuant * xMoeda( RetFldProd((cAliasSB1)->B1_COD,"B1_UPRC" ,cAliasSB1),1,mv_par16,dDataRef,4 )
		EndCase
	EndIf
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se devera ser impresso itens zerados                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (mv_par18==2)  .And. (QtdComp(nQuant)==QtdComp(0))
		dbSelectArea( cAliasSB2 )
		dbSkip()
		Loop
	EndIf					
				
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se devera ser impresso valores zerados              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (mv_par21==2) .And. (QtdComp(nValor)==QtdComp(0))
		dbSelectArea( cAliasSB2 )
		dbSkip()
		Loop
	EndIf

	If (mv_par22==1)
		nQuantR := (cAliasSB2)->B2_QEMP2 + AvalQtdPre("SB2",1,.T.,cAliasSB2) + (cAliasSB2)->B2_RESERV2  + ConvUM( (cAliasSB2)->B2_COD, (cAliasSB2)->B2_QEMPSA, 0, 2)+(cAliasSB2)->B2_QEMPPR2
	Else
		nQuantR := (cAliasSB2)->B2_QEMP + AvalQtdPre("SB2",1,NIL,cAliasSB2) + (cAliasSB2)->B2_RESERVA + (cAliasSB2)->B2_QEMPSA + (cAliasSB2)->B2_QEMPPRJ
	EndIf

	nValorR := (QtdComp(nValor) / QtdComp(nQuant)) * QtdComp(nQuantR)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Chave de pesquisa para aglutinar Armazem/Filial/Empresa ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAglutLoc .Or. lAglutFil
		If (nOrdem == 5)
			cSeek := (cAliasSB2)->B2_LOCAL
		Else
			cSeek := ""
		EndIf
		Do Case
			Case (nOrdem == 1)
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
			Case (nOrdem == 2)
				cSeek += (cAliasSB1)->B1_TIPO
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += (cAliasSB1)->B1_DESC+IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
			Case (nOrdem == 4)
				cSeek += (cAliasSB1)->B1_GRUPO
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)
			OtherWise
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
		EndCase
	EndIf
			
	dbSelectArea( cAliasTRB )
	If lAglutLoc .Or. lAglutFil
	    lAchou := MsSeek(cSeek)
		RecLock(cAliasTRB,!lAchou)
	Else
		RecLock(cAliasTRB,.T.)
	EndIf
				
	FIELD->FILIAL := (cAliasSB2)->B2_FILIAL
	FIELD->CODIGO := (cAliasSB2)->B2_COD
	FIELD->LOCAL  := (cAliasSB2)->B2_LOCAL
	FIELD->DESCRI := (cAliasSB1)->B1_DESC
	If mv_par22 == 1
 	  FIELD->SEGUM  := (cAliasSB1)->B1_SEGUM
 	Else
 	  FIELD->UM     := (cAliasSB1)->B1_UM
 	EndIf 
 	FIELD->TIPO   := (cAliasSB1)->B1_TIPO
  	FIELD->DESCRTP := Posicione("SX5",1,xFilial("SX5")+"02"+(cAliasSB1)->B1_TIPO,"X5_DESCRI")
  	FIELD->GRUPO  := (cAliasSB1)->B1_GRUPO
 	FIELD->GRP_PROD := ALLTRIM((cAliasSB2)->BM_DESC)
	FIELD->QUANTR += nQuantR
	FIELD->VALORR += Round(nValorR,nDec)
	FIELD->QUANT  += nQuant
	FIELD->VALOR  += Round(nValor,nDec)
	FIELD->DISPON += (nQuant - nQuantR)
	If lVeic
		FIELD->CODITE := (cAliasSB1)->B1_CODITE
	EndIf
	If mv_par23 == 1
		FIELD->DESCARM := (cAliasSB2)->NNR_DESCRI
	EndIf
	MsUnlock()
	
	dbSelectArea( cAliasSB2 )
	dbSkip()

EndDo

// cFilAnt := cFilOk   //odair

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga os arquivos de trabalho, cancela os filtros e restabelece as ordens originais.|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasSB2)
dbCloseArea()
ChkFile("SB2",.F.)

dbSelectArea("SB1")
dbClearFilter()

Return


