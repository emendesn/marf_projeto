#include 'parmtype.ch'   
#include "topconn.ch"  
#INCLUDE "MGFFIN78.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWMVCDEF.CH"

#define ORDEM_BROWSE    8
Static dLastPcc  := CTOD("22/06/2015")
Static lIsIssBx := FindFunction("IsIssBx")

// Gest„o
Static lAbatiment := .F.
Static _oFina2901

/*/{Protheus.doc} MGFFIN78
//TODO geraÁ„o de Faturas por data de vencimento e Natureza financeiras com a mesma conta cont·bil crÈdito.
@author Eugenio Arcanjo
@since 24/01/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function MGFFIN78(aFatPag,lAutomato)

	Local lPanelFin		:= IsPanelFin()
	Local xRet	    	:= ''

	Private aRotina		:= MenuDef()
	Private cFatura		:= CRIAVAR("E2_FATURA")
	Private cForn		:= CriaVar("A2_COD")
	Private cLoja		:= CriaVar("A2_LOJA")
	Private cPrefix 	:= CRIAVAR("E2_PREFIXO",.T.)
	Private dVencto		:= Ctod(Space(8))
	Private dDataDe	    := dDataBase
	Private dDataAte	:= dDataBase
	Private dDataE1	    := dDataBase
	Private dDataE2  	:= dDataBase
	Private cFat		:= ""
	Private cTip		:= ""
	Private nValor 		:= 0
	Private nValorFat	:= 0
	Private cNat		:= Space(10)
	Private nTotAbat	:= 0
	Private nValCruz	:= 0
	Private aVlCruz		:= {}
	Private aDupl		:= {}
	Private nValtot		:= 0
	Private aVenc		:= {}
	Private nMoeda 		:= 1
	Private nIndex 		:= 0
	Private cFil290 	:= ""
	Private cLote
	PRIVATE oFatura 	:= NIL
	Private lFocus 		:= .F.
	Private oTipo		:= NIL
	Private oNat
	Private oMark 
	Private oOK       	:= LoadBitmap(GetResources(),'LBOK')
	Private oNO       	:= LoadBitmap(GetResources(),'LBNO')

	PRIVATE lMarkNDF 	:= .F.

	/* 
	Campos usados para amarracao das faturas geradas com o mesmo prefixo, 
	tipo e numeraÁ„o, mas para fornecedores e lojas diferentes.
	*/

	//Define o cabecalho da tela de baixas
	Private cCadastro 	:= OemToAnsi(STR0005) 	// "AglutinaÁ„o de Titulos"
	Private nMoedaBco	:= 1 					// Variavel necessaria para n„o ocorrer error.log na funcao fa090Correc()

	DEFAULT aFatPag     	:= {}
	DEFAULT lAutomato		:= .F.

	Fa290MotBx("FAT","FATURAS   ","ANNS")   

	If FunName() <> "FINA750" .And. !lPanelFin .And. Empty(aFatPag)
		dbSelectArea("SE2")
		dbSetOrder(1)
		dbGoTop()
	EndIf

	// Carrega a funcao pergunte
	Pergunte("AFI290",.F.)      
	SetF12()

	// Endereca a FunÁ„o de BROWSE
	mBrowse( 6, 1,22,75,"SE2",,,,,,Fa040Legenda("SE2"),,,,,,,,.f.,NIL)

	// Recupera a Integridade dos dados
	dbSelectArea("SE2")
	dbSetOrder(1)

Return xRet

/*/{Protheus.doc} MGFINAUT
//TODO Marcacao dos titulos para emissao de fatura
@author Eugenio Arcanjo
@since 24/01/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function MGFINAUT(cAlias,cCampo,nOpcE,aFatPag,lAutomato)
	
	// Define Variaveis
	Local lPanelFin 	:= IsPanelFin()
	Local cArquivo
	Local nTotal		:= 0
	Local nHdlPrv		:= 0
	Local lPadrao		:= .F.
	Local cPadrao		:= "587"
	Local nW 			:= 1
	Local dDatCont 		:= dDatabase
	Local cIndex		:= ""
	Local nOpca 		:= 2   
	LOCAL aMoedas		:= {}
	LOCAL cVar			:= ""
	LOCAL nI			:= 0
	LOCAL aCampos 		:= {}
	LOCAL nTamSeq 		:= TamSX3("E5_SEQ")[1]
	LOCAL cSequencia 	:= Replicate("0",nTamSeq)
	LOCAL nRecSe2 		:= 0
	LOCAL cAliasGRV 	:= "SE2"
	Local cSetFilter 	:= SE2->(DBFILTER()) // Salva o filtro atual, para restaurar no final da rotina
	Local nValTotal 	:= 0
	Local lDigita		:= .F.
	Local nX			:= 0
	Local oDlg
	Local oDlg1
	Local oDlg2
	LOCAL oCbx
	Local oTimer
	Local nTimeOut  	:= SuperGetMv("MV_FATOUT",,900)*1000 	// Estabelece 15 minutos para que o usuarios selecione os titulos a faturar
	Local nTimeMsg  	:= SuperGetMv("MV_MSGTIME",,120)*1000 	// Estabelece 02 minutos para exibir a mensagem para o usuùrio

	Local nOldPis 		:= 0
	Local nOldCof 		:= 0
	Local nOldCsl 		:= 0
	Local nTotBase		:= 0
	Local nTotPis 		:= 0
	Local nTotCof 		:= 0
	Local nTotCsl 		:= 0
	Local nTotISS 		:= 0
	Local nTotIRPJ		:= 0
	Local nBaseIrf		:= 0
	Local nTtIRFat		:= 0
	Local aSize 		:= {}
	Local oPanel
	Local lNumFat   	:= .T.
	Local lFatAut   	:= .F.
	Local nDecres   	:= 0
	Local nVlDesc   	:= 0
	Local nSlDesc   	:= 0
	Local nAcresc   	:= 0
	Local nVlAcre   	:= 0
	Local nSlAcre   	:= 0
	Local nIndSE2 		:= SE2->(IndexOrd())
	Local nRecnoSE2		:= SE2->(Recno())
	Local lContab530	:= VerPadrao("530") .And. ( mv_par03 == 1 )
	Local lMostraTela	:=.T.
	Local cKeyTit		:= ""
	Local nPCCRet		:= 0
	Local nPisRet		:= 0
	Local nCofRet		:= 0
	Local nCslRet		:= 0
	Local lCalcIssBx 	:= .F.
	Local aCps 	   		:= {}
	Local lPaBruto		:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terù o valor dos impostos descontados do seu valor
	Local cCond 		:= 1
	Local nFRetISS 		:= ""
	Local nTRetISS 		:= ""
	Local aISSFat		:= {}
	Local nISSFat 		:= 0
	Local lCompNdf  	:= .F.
	Local nTamTip   	:= TamSX3("E2_TIPO")[1]
	Local nTamTit	 	:= TamSX3("E5_PREFIXO")[1]+TamSX3("E5_NUMERO")[1]+TamSX3("E5_PARCELA")[1]

	// Rastreamento
	Local lRastro		:= .T.
	Local aRastroOri	:= {}
	Local aRastroDes	:= {}
	Local aE2CCC     	:= {}
	Local aE2CCD     	:= {}
	Local aCCUSTO    	:= {}
	Local nI         	:= 1

	// Controle de Contabilizacao
	Local aFlagCTB		:= {}
	Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)

	// IRPF na baixa
	Local lIRPFBaixa	:= .F.
	LOCAL lBaseIRPF		:= .F.
	Local nTotIRF		:= 0
	Local nPropIR		:= 1
	Local lUsaBaseIr	:= .F.
	Local cHistFat		:= ""
	Local lFinVDoc		:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
	Local lAWB			:= Left(FunName(),7) == 'TMSA920' //Geracao de Titulos AWB
	Local nMoedaC 	 	:= 1
	Local aArea 	 	:= {}
	Local cCampoAbat 	:= "Abatmts"
	Local nJuros	 	:= 0
	Local aPcc		 	:= Array(4)
	Local nSalTit 		:= 0

	// Gest„o
	Local aSelFil		:= {}
	Local aTmpFil		:= {}
	Local cTmpSE2Fil 	:= ""
	Local lGestao    	:= FWSizeFilial() > 2	// Indica se usa Gest„o Corporativa
	Local lSE2Compart	:= Iif( lGestao, FWModeAccess("SE2",1) == "C", FWModeAccess("SE2",3) == "C")
	Local cQuery		:= ""
	Local aStru			:= {}
	Local nCt			:= 0
	Local cFilAtu		:= cFilAnt
	Local lInssBx 		:= SuperGetMv("MV_INSBXCP",.F.,"2") == "1"  
	Local nTotIns 		:= 0   
	Local nTotBIns		:= 0
	Local lRoundIns		:= GetNewPar("MV_RNDINS",.F.)
	Local nBaseRet		:= 0
	Local nBaseFat		:= 0
	Local nOldIns		:= 0

	// REESTRUTURACAO SE5
	Local oModelBxP
	Local oSubFK2
	Local oSubFK6
	Local oFKA
	Local cLog			:= ""
	Local cChaveTit		:= ""
	Local cChaveFK7		:= ""
	Local cCamposE5		:= ""
	Local lRet			:= .T.
	Local cCodAprov		:= ""
	Local lCtrlAlc		:= (SuperGetMV( "MV_FINCTAL", .T., "1" ) == "2")
	Local lDirf			:= .F. 
	Local cTitpai		:= ""

	// Contabilidade
	Local cContaDB		:= ""
	Local cCCC	  		:= ""
	Local cCCD	  		:= ""
	Local cCCusto 		:= ""
	Local cItemC  		:= ""
	Local cItemD  		:= ""
	Local cClVlCR 		:= ""
	Local cClVlDB 		:= ""

	Local lFAT290SE5 	:= ExistBlock("FAT290SE5")
	Local aTitSE5   	:= {}
	Local cQuery2		:= ''
	Local cCampos		:= ''
	Local aCamposExtras	:= {}
	Local cExcep	 	:= ''
	Local nAutLjFor  	:= SuperGetMV("MGF_FIN78A",.T.,1) //Tipo de seleÁ„o da Loja do Fornecedor: 1 - Manual; 2 - Menor Loja; 3 - Menor CNPJ. Orientaùùo do Mauricio Ferreira, Contas a Pagar Marfrig
	Local _cAlias	 	:= GetNextAlias()
	Local lRetCtaFor 	:= .F. // Paulo Henrique - 25/10/2019

	Private aChaveLbn 	:= {}
	Private oValor		:= 0
	Private oQtdTit		:= 0
	Private oTitAbats	:= 0
	Private oValorFat	:= 0

	// GDN objetos novos na Tela
	Private oVlrTit		:= 0
	Private oVlrAcr		:= 0
	Private oVlrDec		:= 0
	Private oVlrDev		:= 0

	Private lPccBaixa	:= (cPaisLoc == "BRA") .And. (SuperGetMv( "MV_BX10925" ,.T.,"2") == "1") 
	Private cMarca		:= GetMark()
	Private oMark
	Private cAliasSE2 	:= "TRBSE2"
	Private nInsFat		:= 0 
	Private aInsFat		:= {}
	Private aBaseIns	:= {}					 		
	Private oGet
	Private cCondicao	:= Space(3)
	Private nValCorr	:= 0
	Private nBasePCC	:= 0
	Private nPisFat		:= 0
	Private nCofFat		:= 0 
	Private nCslFat		:= 0 
	Private nIrfFat		:= 0 
	Private aBaseFat	:= {}
	Private aPisFat		:= {}
	Private aCofFat		:= {}
	Private aCslFat		:= {}
	Private aIrfFat		:= {}
	Private lInverte	:= .F.
	Private aHeader		:= {}
	Private aCols		:= {}
	Private oValTot		:= 0
	Private nValTot		:= 0
	Private nUsado 		:= 0
	Private cTipo		:= CRIAVAR("E2_TIPOFAT")
	Private cFornP		:= CRIAVAR("E2_FORNECE",.F.)
	Private cLojaP		:= CRIAVAR("E2_LOJA",.F.)
	Private nJur290	    := 0
	Private nDesc290	:= 0
	Private nBaseIrpf	:= 0
	Private aDocsOri	:= {}
	Private aDocsDes	:= {}  
	PRIVATE dEmiss		:= SE2->E2_EMIS1
	Private nTipoOrder 	:= 1
	Private oMark 
	Private aBrowse    	:= {}                      
	Private aHeadBrow  	:= {"","Filial","Prefixo","Tipo","Natureza","Nr Titulo","Parcela","Acrescimo","Decrescimo",;
						   "Abatimentos","Saldo Liq.","Emissao","Vencto","Vencto Real","Cod. Fornec","Loja",;
						   "Fornecedor","Valor","Saldo","Historico","Valor do abatimento considerado na fatura"}
	Private aTamBrow   	:= {10,10,10,20,20,30,10,50,50,50,50,30,30,30,20,15,50,30,30,60,30}
	Private aCab      	:= ACLONE(aHeadBrow)
	Private nCol       	:= 1                                                
	Private dMenorDT   	:= CTOD('31/12/2200')
	Private cOBSSum    	:= ''
	Private nAcre1SUM  	:= 0 
	Private nAcre2SUM  	:= 0 
	Private nDecre1SUM 	:= 0 
	Private nDecre2SUM 	:= 0
	Private aTipoValor 	:= {} 
	Private cFORBCO    	:= '' 
	Private cFCTADV    	:= ''
	Private cFORCTA    	:= ''
	Private cFAGEDV    	:= ''
	Private cFORAGE    	:= ''           
	Private dMaiorVenc 	:= CTOD(Space(08))
	Private	bMultiFilial := .F.
	Private cFilSE2     := ''
	Private _nVlAcr		:= 0
	Private _nVlrDec	:= 0
	pRIVATE _CcoDzDR	:= ""
	Private _nVlrNdf	:= 0
	Private cMoeda	 	:= ""
	Private cForne	 	:= ""
	Private cLojax	 	:= ""
	Private cTpc	 	:= ""

	Default lAutomato 	:= .F.

	If Type("lEmpPub") <> "L"
		lEmpPub	:= IsEmpPub()
	EndIf

	If dDatabase >= dLastPCc
		nVlMinImp	:= 0
	EndIf

	cPrefix := 'FAT'
	cTipo   := 'FT'

	// Verifica se data do movimento n„o È menor que data limite de movimentacao no financeiro    										  ù
	If !DtMovFin(,,"1")
		Return
	EndIf	

	// Verifica se se o processo ser· contabilizado
	lPadrao := VerPadrao(cPadrao) .And. mv_par03 == 1

	aPcc[1]	:= .F.

	// Inicializa alias alternativo para AS400 para ser utilizado apenas no momento da gravaÁ„o dos novos registos gerados
	
	If Select("SE2_FAT") == 0
		ChkFile("SE2",.F.,"SE2_FAT")
	Else
		dbSelectArea("SE2_FAT")
	EndIf
	
	cAliasGRV := "SE2_FAT"

	/*
	POR MAIS ESTRANHO QUE PARE«A, ESTA FUNCAO DEVE SER CHAMADA AQUI!
	                                                                 
	A FunÁ„o SomaAbat reabre o SE2 com outro nome pela ChkFile para
	efeito de performance. Se o alias auxiliar para a SumAbat() n„o
	estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,
	pois o Filtro do SE2 uptrapassa 255 Caracteres.               
	*/
	SomaAbat("","","","P")


	// ACIONA A FUNCAO PERGUNTE
	Pergunte("AFI290",.F.)
	SetF12()

	// Inicializa array com as moedas existentes
	aMoedas := FDescMoed()  

	dbSelectArea( cAlias )

	cPictPref := AllTrim(PesqPict("SE2","E2_PREFIXO"))
	cForn	  := SPACE(TamSX3("E2_FORNECE")[1])
	cLoja	  := SPACE(TamSX3("E2_LOJA")[1])

	//-- Tratamento necessario devido os parametros enviados pela MBrowse
	If ValType(aFatPag) != "A" .Or. Len(aFatPag) < 13 .Or. ValType(aFatPag[13]) != "A"
		aFatPag := {}
	EndIf

	// Descricao do Array aFatPag
	// [01] - Prefixo
	// [02] - Tipo
	// [03] - Numero da Fatura (se o numero estiver em branco obtem pelo FINA290)
	// [04] - Natureza
	// [05] - Data de
	// [06] - Data Ate
	// [07] - Fornecedor
	// [08] - Loja
	// [09] - Fornecedor para geracao
	// [10] - Loja do fornecedor para geracao
	// [11] - Condicao de pagto
	// [12] - Moeda
	// [13] - ARRAY com os titulos da fatura
	// [13,1] Prefixo
	// [13,2] Numero
	// [13,3] Parcela
	// [13,4] Tipo
	// [13,5] tÌtulo localizado na geracao de fatura (lÛgico). Iniciar com falso.
	// [14] - Valor de decrescimo
	// [15] - Valor de acrescimo
	
	// Verifica o numero do Lote
	LoteCont( "FIN" )

	nOpca 		:= 2

	While nOpca == 2
		nOpca 		:= 3
		dbSelectArea(cAlias)

		// Recebe dados a serem digitados

		cVar := aMoedas[1]

		If Len(aFatPag) > 0
			lFatAut := .T.
			If !Empty(aFatPag[3])
				lNumFat := .F.
				cFatura := aFatPag[3]
			EndIf
		EndIf

		If lNumFat
			aTam := TamSx3("E2_NUM")
			cFatura	:= Soma1(GetMv("MV_NUMFATP"), aTam[1])
			cFatura	:= Pad(cFatura,aTam[1])
		EndIf

		cFatAnt	:= cFatura

		// Inicializacao das vari·veis da fatura
		If lFatAut
			cPrefix  := aFatPag[01]
			cTipo    := aFatPag[02]
			cNat     := aFatPag[04]
			dDataDe  := Iif(!Empty(aFatPag[05]),aFatPag[05],dDataDe)
			dDataAte := Iif(!Empty(aFatPag[06]),aFatPag[06],dDataAte)
			cForn    := aFatPag[07]
			cLoja    := aFatPag[08]
			cFornP   := aFatPag[09]
			cLojaP   := aFatPag[10]
			nOpca    := 1
			nDecres  := Iif(Len(aFatPag) > 13 .And. ValType(aFatPag[14]) == "N",aFatPag[14],0)
			nAcresc  := Iif(Len(aFatPag) > 14 .And. ValType(aFatPag[15]) == "N",aFatPag[15],0)

			If lAutomato
				If FindFunction("GetParAuto")
					aRetAuto := GetParAuto("FINA290TestCase")
					nValorFat := aRetAuto[1][1]
				EndIf
			EndIf
		Else
			aSize := MSADVSIZE()
			If lPanelFin  //Chamado pelo Painel Financeiro
				dbSelectArea(cAlias)
				oPanelDados := FinWindow:GetVisPanel()
				oPanelDados:FreeChildren()
				aDim := DLGinPANEL(oPanelDados)

				DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )

				/*
				Observacao Importante quanto as coordenadas calculadas abaixo:
				--------------------------------------------------------------
				a funcao DlgWidthPanel() retorna o dobro do valor da area do
				painel, sendo assim este deve ser dividido por 2 antes da sub-
				tracao e redivisao por 2 para a centralizacao.
				*/

				nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 218) /2
				nEspLin  := 0

			Else

				DEFINE MSDIALOG oDlg FROM	22,9 TO 320,540 TITLE OemToAnsi(STR0009) PIXEL //"Faturas a Pagar"
				nEspLarg := 5
				nEspLin  := 2
			
			EndIf

			cPrefix := 'FAT'
			cTipo   := 'FT'

			oDlg:lMaximized := .F.
			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
			oPanel:Align := CONTROL_ALIGN_ALLCLIENT

			@ 004+nEspLin, nEspLarg TO 036+nEspLin, 218+nEspLarg OF oPanel PIXEL
			@ 038+nEspLin, nEspLarg TO 070+nEspLin, 218+nEspLarg OF oPanel PIXEL
			@ 072+nEspLin, nEspLarg TO 104+nEspLin, 218+nEspLarg OF oPanel PIXEL
			@ 106+nEspLin, nEspLarg TO 138+nEspLin, 218+nEspLarg OF oPanel PIXEL

			nEspLarg := nEspLarg - 7

			@ 020+nEspLin, 014+nEspLarg MSGET cPrefix		Pict cPictPref SIZE 10, 11 OF oPanel PIXEL
			@ 020+nEspLin, 040+nEspLarg MSGET oTipo VAR cTipo F3 "05" Picture "@!" Valid If(nOpca<>0,(!Empty (cTipo) .And. FA290Tipo(@cTipo)),.T.) SIZE 10, 11 OF oPanel PIXEL HASBUTTON
			oTipo:cReadVar := "E2_TIPOFAT"

			@ 020+nEspLin, 075+nEspLarg MSGET oFATURA 	VAR cFatura	Valid If(nOpca<>0,!Empty(cFatura),.T.) SIZE 42, 11 OF oPanel PIXEL
			@ 020+nEspLin, 120+nEspLarg MSGET oNat   	VAR cNat F3 "SED" Valid If(nOpca<>0,Fa290Nat(),.T.) SIZE 55, 11 OF oPanel PIXEL HASBUTTON
			@ 020+nEspLin, 175+nEspLarg MSCOMBOBOX oCbx VAR cVar ITEMS aMoedas 		SIZE 46, 55 OF oPanel PIXEL

			@ 054+nEspLin, 014+nEspLarg MSGET dDataDe	VALID If(nOpca<>0,F290VLDDT("DataDe", dDataDe),.T.)	 SIZE 50, 11 OF oPanel PIXEL HASBUTTON
			@ 054+nEspLin, 068+nEspLarg MSGET dDataAte	Valid If(nOpca<>0, F290VLDDT("DataAte", dDataDe, dDataAte),.T.)  SIZE 50, 11 OF oPanel PIXEL HASBUTTON
			@ 054+nEspLin, 120+nEspLarg MSGET nValorFat Picture "@E 9,999,999,999.99"    SIZE 65, 11 OF oPanel PIXEL HASBUTTON

			@ 088+nEspLin, 014+nEspLarg MSGET dDataE1	Valid If(nOpca<>0,F290VLDDT("DataDe", dDataE1),.T.) SIZE 50, 11 OF oPanel PIXEL HASBUTTON
			@ 088+nEspLin, 068+nEspLarg MSGET dDataE2	Valid If(nOpca<>0, F290VLDDT("DataAte", dDataE1, dDataE2),.T.) SIZE 50, 11 OF oPanel PIXEL HASBUTTON

			If nAutLjFor != 1  //Tipo de seleÁ„o da Loja do Fornecedor: 1 - Manual; 2 - Menor Loja; 3 - Menor CNPJ.
				@ 119+nEspLin, 014+nEspLarg MSGET cForn		F3 "FOR" Picture "@!" Valid If(nOpca<>0,Fa290For(cForn,/*cLoja*/,MV_PAR01 == 1,.F.),.T.) SIZE 65, 11 OF oPanel PIXEL HASBUTTON
			Else
				@ 119+nEspLin, 014+nEspLarg MSGET cForn		F3 "FOR" Picture "@!" Valid If(nOpca<>0,Fa290For(cForn,cLoja,MV_PAR01 == 1,.F.),.T.) SIZE 65, 11 OF oPanel PIXEL HASBUTTON
				@ 119+nEspLin, 079+nEspLarg MSGET cLoja		When mv_par01 == 1 Picture "@!" Valid If(nOpca<>0,Fa290For(cForn,cLoja,MV_PAR01 == 1,.F.) .And. ExistCpo("SA2",cForn+cLoja),.T.) SIZE 21, 11 OF oPanel PIXEL
			EndIf

			@ 010+nEspLin, 014+nEspLarg SAY OemToAnsi(STR0010) SIZE 20, 7 OF oPanel PIXEL //"Prefixo"
			@ 010+nEspLin, 040+nEspLarg SAY OemToAnsi(STR0053) SIZE 12, 7 OF oPanel PIXEL //"Tp"
			@ 010+nEspLin, 075+nEspLarg SAY OemToAnsi(STR0055) SIZE 49, 7 OF oPanel PIXEL //"Nr.Fatura"
			@ 010+nEspLin, 120+nEspLarg SAY OemToAnsi(STR0012) SIZE 25, 7 OF oPanel PIXEL //"Natureza"
			@ 010+nEspLin, 175+nEspLarg SAY OemToAnsi(STR0013) SIZE 25, 7 OF oPanel PIXEL //"Moeda"

			@ 044+nEspLin, 014+nEspLarg SAY OemToAnsi("Vencimento de") SIZE 30, 7 OF oPanel PIXEL //"Emiss„o de"
			@ 044+nEspLin, 068+nEspLarg SAY OemToAnsi("AtÈ") SIZE 10, 7 OF oPanel PIXEL //"AtÈ"
			@ 044+nEspLin, 120+nEspLarg SAY OemToAnsi(STR0016) SIZE 50, 7 OF oPanel PIXEL //"Valor da Fatura"

			@ 078+nEspLin, 014+nEspLarg SAY 'Emiss„o de' SIZE 30, 7 OF oPanel PIXEL //"Emiss„o de"
			@ 078+nEspLin, 068+nEspLarg SAY 'AtÈ'        SIZE 10, 7 OF oPanel PIXEL //"AtÈ"

			@ 109+nEspLin, 014+nEspLarg SAY OemToAnsi(STR0017) SIZE 30, 7 OF oPanel PIXEL //"Fornecedor"

			If nAutLjFor = 1  //Tipo de seleÁ„o da Loja do Fornecedor: 1 - Manual; 2 - Menor Loja; 3 - Menor CNPJ.
				@ 109+nEspLin, 079+nEspLarg SAY OemToAnsi(STR0018) SIZE 30, 7 OF oPanel PIXEL //"Loja"
			EndIf

			aCps := {"cPrefix","cFatura","cNat","cForn",IIF(nAutLjFor = 1,("cLoja"),"")} //,"cFornP","cLojaP"}

			If lPanelFin  //Chamado pelo Painel Financeiro

				oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
				ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
				{||nOpca:=0,IF(If(FA290NUM(cFatAnt), FA290Ok() .And. Iif(MV_PAR01==1, Fa290For(cForn,IIF(nAutLjFor = 1,cLoja,""),.T.,.T.), Fa290For(cFornP,IIF(nAutLjFor = 1,cLojaP,""),.T.,.T.)) ,.F.),nOpca:=1,nOpca:=2),oDlg:End()},;
				{||nOpca:=0,oDlg:End()})

				FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)

			Else

				DEFINE SBUTTON FROM 07, 230 TYPE 1 ACTION (nOpca:=0,IF(If(FA290NUM(cFatAnt),FA290Ok() .And. F290VlCpos(aCps) .And. Iif(MV_PAR01==1, Fa290For(cForn,IIF(nAutLjFor = 1,cLoja,""),.F.,.T.), Fa290For(cFornP,IIF(nAutLjFor = 1,cLoja,""),.F.,.T.)) ,.F.),nOpca:=1,nOpca:=2),oDlg:End()) ENABLE OF oDlg
				DEFINE SBUTTON FROM 21, 230 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oDlg

				ACTIVATE MSDIALOG oDlg CENTERED
	
			EndIf
		EndIf
	EndDo

	If(nOpca<>1,nOpca:=0,.T.)

	// 26-fev-2019, Natanael Filho: Seleciona automaticamente a loja do fornecedor.
	If !(nAutLjFor = 1)
		_ncOpc 	:= IIF(nAutLjFor = 2,1,2)
		cLoja 	:= MGFAltoLj(cForn,_ncOpc)			
	EndIf

	If nOpca == 0
		FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
		Return
	EndIf

	If lFatAut .And. !Empty(aFatPag[12])
		nMoeda := aFatPag[12]
	Else
		nMoeda := Val(Substr(cVar,1,2))
	EndIf

	// Cria indice condicional
	// Selecao de filiais

	If Len( aSelFil ) <= 0 
		aSelFil := AdmGetFil(.F.,.T.,"SE2")
		If Len( aSelFil ) <= 0
			Return
		EndIf	
	EndIf

	aStru 		:= SE2->(DbStruct())
	cAliasSE2 	:= "TRBSE2"
	cOrdem 		:= SE2->(INDEXKEY(INDEXORD()))
	cQuery 		:= U_MGFFINCHK(aSelFil,aTmpFil,cTmpSE2Fil,aStru)
	cQuery 		:= STRTRAN(cQuery,',E2_OK','')
	cQuery 		:= STRTRAN(cQuery,'SELECT E2_FILIAL','SELECT E2_OK,E2_FILIAL')

	Aadd( aStru , { "RECNO" , "N" , 10 , 0 } )
	AADD(aCamposExtras,{ cCampoAbat , "N" , 14 , 2 })
	AADD(aCamposExtras,{ "ABATSOMADO" , "N" , 14 , 2 })
	AADD(aCamposExtras,{ "CALCULADO", "C" , 1 , 0 })
	AADD(aCamposExtras,{ "VLSOMAABAT" , "N" , 14 , 2 })

	cExcep := ''

	For nI := 1 To Len(aCamposExtras)
		AADD(aStru,aCamposExtras[nI])
		cExcep += If(nI>1,'|','')+aCamposExtras[nI,1]
	Next nI

	If _oFina2901 <> Nil
		_oFina2901:Delete()
		_oFina2901 := Nil
	EndIf

	// CriaÁ„o da Tabela Tempor·ria
	MsErase(cAliasSE2)

	_oFina2901 := FWTemporaryTable():New( cAliasSe2 )  
	_oFina2901:SetFields(aStru) 
	_oFina2901:AddIndex("1", {"E2_FILIAL","E2_PREFIXO","E2_NUM","E2_PARCELA","E2_TIPO","E2_FORNECE","E2_LOJA"})

	// Data: 17/12/18 - SolicitaÁ„o Eric, colocar o TIPO na primeira ORDEM para trazer todas as NDFs juntos
	_oFina2901:AddIndex("2", {"E2_TIPO","E2_FILIAL","E2_PREFIXO","E2_NUM","E2_PARCELA","E2_FORNECE","E2_LOJA"})

	_oFina2901:Create()  

	cQuery2 := " INSERT "

	If ALLTRIM(tcGetdb()) == "ORACLE"
		cQuery2 += " /*+ APPEND */ "
	EndIf

	cCampos := ''
	AEVAL(aStru,{|e,i| cCampos += IF(i==1,'E2_OK,'+ALLTRIM(e[1]),IF(ALLTRIM(e[1])$(cExcep+'|E2_OK'),'',","+ALLTRIM(e[1]))) })
	cQuery2 += " INTO "+_oFINA2901:GetRealName()+" ("+cCampos+") " + cQuery

	Processa({|| TcSQLExec(cQuery2)}) 

	(cAliasSE2)->(DbSetOrder(1))  
	(cAliasSE2)->(DbGoTop())  

	If BOF() .And. EOF()

		Help(" ",1,"RECNO")
		Set Filter to
		dbSetOrder(1)
		RetIndex("SE2")

		// Restaura o filtro
		Set Filter To &cSetFilter.
		dbGoTop()

		dbSelectArea(cAliasSe2)
		DbCloseArea()

		// Deleta tabela Tempor·ria criada no banco de dados
		If _oFina2901 <> Nil
			_oFina2901:Delete()
			_oFina2901 := Nil
		EndIf

		// Gest„o
		For nX := 1 TO Len(aTmpFil)
			CtbTmpErase(aTmpFil[nX])
		Next

		FreeUsedCode()  // libera codigos de correlativos reservados pela MayIUseCode()
		Return(.F.)
	EndIf

	nValor		:= 0	// valor total dos titulos,mostrado no rodape do browse
	nValCruz 	:= 0
	nQtdTotTit	:= 0
	nQtdTit		:= 0	// quantidade de titulos,mostrado no rodape do browse
	nTitAbats	:= 0	// valor dos abatimentos dos titulos marcados
	aVlCruz		:= {} 	// Valor na Moeda Nacional correspondente a cada parcela
	lIrpfBaixa	:=  SA2->A2_CALCIRF == "2"

	// GDN - Variaveis relacionadas aos novos objetos na tela
	nTotTit	:= 0
	nTAxTit := 0 // Andy
	nVlrAcr := 0
	nVlrDec := 0
	nVlrDev := 0

	lCalcIssBx	:= IIF(lIsIssBx, IsIssBx("P"), SuperGetMv("MV_MRETISS",.F.,"1") == "2" )

	nOpcA 		:= 0


	/* 
	Monta array com capos a serem mostrados na marcacao de titulos 
	Utiliza os capos em uso do SE2 mais o E2_SALDO que apesar de n„o estar em uso deve ser mostrado na tela.
	*/ 

	AADD(aCampos,{"E2_OK","","  ",""})

	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(MsSeek(cAlias))

	/*
	ordenar os campos conforme MIT
	filial, prefixo, tipo, natureza, nr titulo, acrescimmo, descrescimo, abatimentos, sald liquido, dt emissao, vencimento
	vencto real, fornecedor,loja, nome fornec, vlr titulo, saldo, historico
	*/

	AADD(aCampos,{"E2_FILIAL ","","Filial",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_PREFIXO","","Prefixo",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_TIPO   ","","Tipo",SX3->X3_PICTURE})

	AADD(aCampos,{"E2_NATUREZ","","Natureza",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_NUM    ","","Nr Titulo",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_PARCELA","","Parcela",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_ACRESC ","","Acrescimo",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_DECRESC","","Decrescimo",SX3->X3_PICTURE})
	aAdd(aCampos,{cCampoAbat,"",STR0077,"@E 999,999,999.99"})
	AADD(aCampos,{"E2_SALDO ","","Saldo Liq.",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_EMISSAO","","Emissao",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_VENCTO ","","Vencto",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_VENCREA","","Vencto Real",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_FORNECE","","Cod. Fornec",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_LOJA   ","","Loja",SX3->X3_PICTURE})

	AADD(aCampos,{"E2_NOMFOR ","","Fornecedor",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_VALOR  ","","Valor",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_SALDO  ","","Saldo",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_HIST   ","","Historico",SX3->X3_PICTURE})
	aAdd(aCampos,{"ABATSOMADO","","Valor do abatimento considerado na fatura","@E 999,999,999.99"})

	dbSelectArea(cAliasSe2)

	// Inicia integracao com Modulo SIGAPCO
	PcoInilan("000015")

	// Marca os titulos ate o valor informado para a fatura

	If MV_PAR05 == 1 .Or. lFatAut
		Fa290Marca(cAliasSe2,cMarca,0,lPccBaixa,(cPaisLoc == "BRA"),aChaveLbn,aFatPag,@nValorFat)
	EndIf

	// GDN Somente apresentar Valor Faturar se for positivo.
	nValorF := nValorFat

	If lFatAut
		If Ascan(aFatPag[13],{ | e | e[5] == .F. }) > 0
			IW_MSGBOX(STR0075,,STR0067,'STOP')	//'Existem tÌtulos que n„o foram localizados na geraÁ„o da fatura'###"AtenÁ„o"
			
			// Recupera a Integridade dos dados
			FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
			dbSelectArea("SE2")
			RetIndex( "SE2" )
			
			// Restaura o filtro
			Set Filter To &cSetFilter.
			dbSelectArea(cAliasSe2)
			DbCloseArea()

			// Deleta tabela Tempor·ria criada no banco de dados
			If _oFina2901 <> Nil
				_oFina2901:Delete()
				_oFina2901 := Nil
			EndIf

			// Gest„o
			For nX := 1 TO Len(aTmpFil)
				CtbTmpErase(aTmpFil[nX])
			Next

			dbSelectArea("SE2")
			Return(.F.)
		EndIf		
		nOpca := 1
	Else  

		// Faz o calculo automatico de dimensoes de objetos
		GeraDados()

		nQtdTotTit := Len(aBrowse)

		aSize := MSADVSIZE()
		oSize := FWDefSize():New(.T.)
		oSize:AddObject("MASTER",100,100,.T.,.T.)
		oSize:lLateral := .F.				
		oSize:lProp := .T.

		oSize:Process()

		DEFINE MSDIALOG oDlg1 TITLE STR0020 PIXEL FROM oSize:aWindSize[1],oSize:aWindSize[2] To oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd  //"Fatura a Pagar"
		oTimer:= TTimer():New((nTimeOut-nTimeMsg),{|| MsgTimer(nTimeMsg,oDlg1) },oDlg1) // Ativa timer
		oTimer:Activate()  

		nLinIni := oSize:GetDimension("MASTER","LININI")
		nColIni := oSize:GetDimension("MASTER","COLINI")
		nLinFin := oSize:GetDimension("MASTER","LINEND")
		nColFin := oSize:GetDimension("MASTER","COLEND")

		@ nLinIni + 001, 002  To nLinIni+033,nColFin PIXEL OF oDlg1

		@ nLinIni + 008 , 005		SAY OemToAnsi(STR0021) + cPrefix 				  FONT oDlg1:oFont PIXEL Of oPanel// "Prefixo: "
		@ nLinIni + 017 , 005		Say OemToAnsi(STR0022) + cFatura 				  FONT oDlg1:oFont PIXEL Of oPanel// "N˙mero: "
		@ nLinIni + 008 , 080		SAY OemToAnsi(STR0023) + Substr(cNat,1,10)		  FONT oDlg1:oFont PIXEL Of oPanel// "Natureza: "
		@ nLinIni + 017 , 080		SAY OemToAnsi(STR0024) + AllTrim(Str(nMoeda,2,0)) FONT oDlg1:oFont PIXEL Of oPanel// "Moeda: "

		//==========================================//
		// GDN NOVOS TOTALIZADORES NA TELA          //
		// GAP 585                                  //
		//==========================================//

		// GDN - Refazer a apresentaÁ„o dos campos na TELA mudar posiÁ„o do cpo Tit Selec.
		@ nLinIni + 008 , 135	Say OemToAnsi("Total Tit.") FONT oDlg1:oFont PIXEL Of oPanel	
		@ nLinIni + 017 , 140	Say oTotQtdTit VAR nQtdTotTit Picture "999999" FONT oDlg1:oFont PIXEL Of oPanel

		@ nLinIni + 008 , 170	Say OemToAnsi(STR0027) FONT oDlg1:oFont PIXEL Of oPanel	//"TÌt. Selec."
		@ nLinIni + 017 , 178	Say oQtdTit VAR nQtdTit Picture "999999"  FONT oDlg1:oFont PIXEL Of oPanel

		// GDN - Incluir Novos Campos 
		@ nLinIni + 008 , 200	Say OemToAnsi("Vlr.Tit.Origem") FONT oDlg1:oFont PIXEL Of oPanel // Andy	
		@ nLinIni + 017 , 200	Say oVlrTit  VAR nTAxTit 	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel //Andy
		@ nLinIni + 008 , 250	Say OemToAnsi("Vlr.Acresc.") FONT oDlg1:oFont PIXEL Of oPanel	
		@ nLinIni + 017 , 250	Say oVlrAcr  VAR nVlrAcr 	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 008 , 300	Say OemToAnsi("Vlr.Decres.") FONT oDlg1:oFont PIXEL Of oPanel	
		@ nLinIni + 017 , 300	Say oVlrDec  VAR nVlrDec 	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 008 , 350	Say OemToAnsi("Vlr.DevoluÁıes") FONT oDlg1:oFont PIXEL Of oPanel	
		@ nLinIni + 017 , 350	Say oVlrDev  VAR nVlrDev 	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel

		// Campos j· que existiam na tela Manter o Valor Fatura
		// Ver a regra correta com o Eric.	
		@ nLinIni + 008 , 400	Say OemToAnsi("Vlr.Saldo Fatura") FONT oDlg1:oFont PIXEL Of oPanel	// Andy
		@ nLinIni + 017 , 400	Say oValorFat VAR nValorF	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel

		oBrowseDados := TWBrowse():New( nLinIni + 36, nColIni,  nColFin,nLinFin-70,;
										,aHeadBrow,aTamBrow,oDlg2, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		oBrowseDados:SetArray(aBrowse)                                    
		cbLine := "{||{ If(aBrowse[oBrowseDados:nAt,01],oOK,oNO)"

		For nI := 2 To Len(aHeadBrow)
			cbLine += ",aBrowse[oBrowseDados:nAt,"+STRZERO(nI,2)+"]"
		Next nI         

		cbLine +="  } }"
		oBrowseDados:bLine         := &cbLine          
		oBrowseDados:bHeaderClick  := {|oBrw,nCol| OrdenaCab(nCol,.T.)}
		oBrowseDados:bLDblClick := {|| MudaStatus(1)}         
		oBrowseDados:addColumn(TCColumn():new(aCab[01],{||IIf(aBrowse[oBrowseDados:nAt,01],oOK,oNO)},"@!" ,,,"LEFT" , 1,.T.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[02],{||aBrowse[oBrowseDados:nAt][02]},"@!" ,,,"LEFT"  ,aTamBrow[02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[03],{||aBrowse[oBrowseDados:nAt][03]},"@!" ,,,"LEFT"  ,aTamBrow[03],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[04],{||aBrowse[oBrowseDados:nAt][04]},"@!" ,,,"LEFT"  ,aTamBrow[04],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[05],{||aBrowse[oBrowseDados:nAt][05]},"@!" ,,,"LEFT"  ,aTamBrow[05],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[06],{||aBrowse[oBrowseDados:nAt][06]},"@!" ,,,"LEFT"  ,aTamBrow[06],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[07],{||aBrowse[oBrowseDados:nAt][07]},"@!" ,,,"LEFT"  ,aTamBrow[06],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[08],{||aBrowse[oBrowseDados:nAt][08]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[07],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[09],{||aBrowse[oBrowseDados:nAt][09]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[08],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[10],{||aBrowse[oBrowseDados:nAt][10]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[09],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[11],{||aBrowse[oBrowseDados:nAt][11]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[10],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[12],{||aBrowse[oBrowseDados:nAt][12]},"@!" ,,,"LEFT"  ,aTamBrow[11],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[13],{||aBrowse[oBrowseDados:nAt][13]},"@!" ,,,"LEFT"  ,aTamBrow[12],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[14],{||aBrowse[oBrowseDados:nAt][14]},"@!" ,,,"LEFT"  ,aTamBrow[13],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[15],{||aBrowse[oBrowseDados:nAt][15]},"@!" ,,,"LEFT"  ,aTamBrow[14],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[16],{||aBrowse[oBrowseDados:nAt][16]},"@!" ,,,"LEFT"  ,aTamBrow[15],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[17],{||aBrowse[oBrowseDados:nAt][17]},"@!" ,,,"LEFT"  ,aTamBrow[16],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[18],{||aBrowse[oBrowseDados:nAt][18]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[17],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[19],{||aBrowse[oBrowseDados:nAt][19]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[18],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[20],{||aBrowse[oBrowseDados:nAt][20]},"@!" ,,,"LEFT"  ,aTamBrow[19],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[21],{||aBrowse[oBrowseDados:nAt][21]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[20],.F.,.F.,,,,,))	

		// Colunas Anteriores dos botoes 355,410,465,520
		// GDN - Novo posicionamento dos botıes na Tela
		oBtn := TButton():New( nLinIni + 005, 530 ,'Marcar Todas'    , oDlg2,{|| MudaStatus(3)}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )        
		oBtn := TButton():New( nLinIni + 005, 585 ,'Desmarcar Todas' , oDlg2,{|| MudaStatus(2)}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   

		oBtn := TButton():New( nLinIni + 020, 530 ,'Inverte seleÁ„o' , oDlg2,{|| MudaStatus(1)}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )        
		oBtn := TButton():New( nLinIni + 020, 585 ,'Excel'           , oDlg2,{|| GeraExcel()}   	,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )        

		If lPanelFin  //Chamado pelo Painel Financeiro			
			ACTIVATE MSDIALOG oDlg1 ON INIT FaMyBar(oDlg1,{|| nOpca := 1,;
			IIF(Fa290ValOK(),IF(Fa290Soma(),oDlg1:End(),;
			Iif(Fa290Val(oValorFat),nOpca:=0,nOpca:=0)),nOpca:=0)},;
			{|| nOpca := 2,oDlg1:End()},)     
		Else
			ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| nOpca := 1,;
			IIF(Fa290ValOK(),IF(Fa290Soma(),oDlg1:End(),;
			Iif(Fa290Val(oValorFat),nOpca:=0,nOpca:=0)),nOpca:=0)},;
			{|| nOpca := 2,oDlg1:End()},,)  
		EndIf

	EndIf

	dbSelectArea("SE2")

	If nOpca == 1

		// GDN Somente apresento a Tela de FATURA se n„o TEM NDF e Tem Valor
		If  nValor > 0

			nOpcA := 0

			If lCtrlAlc
				MsgInfo(STR0078 + AllTrim(Str(nMoeda)) + ".",STR0079)		//"Para a fatura ser· adotado o aprovador padr„o para a moeda: " ###"Controle de alùadas ativo" 
			EndIf

			cCond := 1

			If lFatAut .And. !lAWB
				nOpca := 1		
				cCondicao := cCond

				If nModulo == 89 .And. !FWIsInCallStack("TA039EFET")
					aVenc := TA042Vencto(nValor, cCondicao)
				Else
					aVenc := Condicao(nValor, cCondicao, 0)
				EndIf

				nDup	:= Len(aVenc)
				aCols := GravaDup(nDup,cPrefix,cFatura,nValor,dDatabase,aVenc,lFatAut)
			Else

				// Apresenta a Tela de Parcelamento do VALOR da FATURA a SER GERADA
				aSize := MsAdvSize(,.F.,400)
				DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
				oDLg2:lMaximized := .T.

				oPanel1 := TPanel():New(0,0,'',oDlg2, oDlg2:oFont, .T., .T.,, ,45,45,.T.,.T. )
				oPanel1:Align := CONTROL_ALIGN_TOP

				oPanel2 := TPanel():New(0,0,'',oDlg2, oDlg2:oFont, .T., .T.,, ,20,20,.T.,.T. )
				oPanel2:Align := CONTROL_ALIGN_ALLCLIENT

				@ 003,010 TO 040,125 OF oPanel1 Pixel
				@ 003,127 TO 040,500 OF oPanel1 Pixel

				@ 017,015 Say 'Parcelas' Of oPanel1 Pixel                                      
				@ 015,045	MSGET cCond   Picture "999" Of oPanel1 Pixel Hasbutton Valid cCond > 0 when nVlrDev = 0 //n„o pode ser parcelado se houver NDF

				DEFINE SBUTTON FROM 015,085	TYPE 1 ACTION (If(!Empty(cCond)	.And. cCond > 0,;
				nOpca:=F290SelFat(oDlg2,1,@cCond,@nTAxTit,@nValTot,@aVenc,@cPrefix,@cFatura,@cTipo,dDatCont,oPanel2,oPanel1),; // Andy
				nOpca:=0)) ENABLE OF oPanel1

				If lPanelFin  //Chamado pelo Painel Financeiro			
					ACTIVATE MSDIALOG oDlg2 ON INIT FaMyBar(oDlg2,;
					{||nOpca:=1, If( valtype(oget)=="O",if(oGet:TudoOk() .And. Len(aCols) > 0,oDlg2:End(),nOpca := 0), nOpca := 0)},;
					{||oDlg2:End()})																												
				Else				
					ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||nOpca:=1, If( valtype(oget)=="O",if(oGet:TudoOk() .And. Len(aCols) > 0,oDlg2:End(),nOpca := 0), nOpca := 0)},{||oDlg2:End()})
				EndIf				                                  

				cCondicao := If(nOpca=0,1,cCond)
			EndIf

		EndIf

		// Inicia a TRANSACAO para Gerar os Titulos Necess·rios
		// SE2, SE5, FK2, FK6, FK7, FKA, contabilizaÁ„oe atualiza saldos em SA2.
		Begin Transaction

			//==========================================//
			// GDN TRATAMENTO ESPECIAL PARA O TIPOS NDF //
			// GAP 618                                  //
			//==========================================//
			lProcNDF := .F.

			If nOpcA == 1 .And. lMarkNDF 
				lProcNDF := MGFCmpNDF(cAliasSE2,aBrowse,cMarca)
			EndIf

			CursorWait()

			// Criar a fatura
			If nOpcA == 1 .And. nValor > 0
				STRLCTPAD		:= ""		// para contabilizar o historico do LP
				nTotAbat		:= 0
				bMultiFilial	:= .F.		// Variavel para informar se foram selecionado tÌtulo de mais de uma filial. Se sim, gerarù a fatura na matriz '010001'
				cFilSE2 		:= ''		// Filial para geraÁ„o da Fatura 

				//Caso encontre algum tÌtulo com conta divergente dos demais, pergunta se continua ou n„o a geraÁ„o da Fatura.
				lPergCta		:= .T.
				lMultCta		:= .F.

				dbSelectArea( cAliasSE2 )

				aTitCtaFor := {}	// Tratar CONTA do FORNECEDOR x FIL
				aTitCodBar := {}	// Tratar cÛdigo de barras - Paulo Henrique - 10/10/2019
				aTitCodFav := {}	// Tratar cÛdigo do favorecido - Paulo Henrique - 10/10/2019
				cChv01     := ""
				cChv02     := ""

				dbGotop()
				ProcRegua((cAliasSE2)->(RecCount()))

				// Tratamento padr„o caso n„o tenha NDF selecionada, manter o processo como est·.

				While !(cAliasSE2)->(Eof())
					// NESTE PONTO ELE COME«A A AVALIAR OS REGISTROS MARCADOS
					If (cAliasSE2)->E2_OK == cMarca

						cFilOrig := SE2->E2_FILORIG
						cNumero  := SE2->E2_NUM
						cPrefixo := SE2->E2_PREFIXO
						cParcela := SE2->E2_PARCELA
						cMoeda	 := SE2->E2_MOEDA
						cForne	 := SE2->E2_FORNECE
						cLojax	 := SE2->E2_LOJA
						cTpc	 := SE2->E2_TIPO

						//Informar se foram selecionado tÌtulo de mais de uma filial. Se sim, gerarù a fatura na matriz '010001'
						IF !bMultiFilial .And. cFilSE2 <> (cAliasSE2)->E2_FILIAL
							IF Empty(cFilSE2)
								cFilSE2 :=  (cAliasSE2)->E2_FILIAL
							Else
								bMultiFilial := .T.
								cFilSE2 := '010001'
							EndIf
						EndIf

						dbSelectArea("SE2")
						SE2->(DbGoTo((cAliasSE2)->RECNO))

						IncProc(SE2->E2_NUM+" / "+SE2->E2_PREFIXO+" / "+SE2->E2_PARCELA) 

						cChv01 := SE2->(E2_FORBCO+E2_FCTADV+E2_FORCTA+E2_FAGEDV+E2_FORAGE)

						// 06/12/2018 - SolicitaÁ„o MAURICIO / ERIC 
						// Checar se a CONTA do fornecedor È a mesma para os titulos marcados, se sim levar esta conta para a FATURA
						If !(Len(aTitCtaFor) > 1) 
							If ASCAN(aTitCtaFor,{|x|x[1]+x[2]+x[3]+x[4]+x[5] == cChv01 }) == 0 .And. !Empty(cChv01)
								AADD(aTitCtaFor,{E2_FORBCO,E2_FCTADV,E2_FORCTA,E2_FAGEDV,E2_FORAGE})
            
			                    // Paulo Henrique - 24/10/2019 - Rever a condiÁ„o abaixo 
								If Len(aTitCtaFor) > 1 // Se Encontrar conta divergentes nos tÌtulos, pergunta se deve continuar
								   lRetCtaFor := fTitCtaFor(aTitCtaFor)
								   If lRetCtaFor
								      If !MsgYesNo("H· contas banc·rias divergentes entre os tÌtulos. Deseja continuar?","Conta Banc·ria do Fornecedor")
									     lRet := .F.
									     EXIT
								      EndIf
								   EndIf
								EndIf
							EndIf
						EndIf

						// 10/10/2019 - Paulo Henrique - Analisa se existe o cÛdigo de barras
						If !(Len(aTitCodBar) >= 1)
						   If Ascan(aTitCodBar,{|x|x[1] == SE2->E2_CODBAR}) == 0 .And. !Empty(SE2->E2_CODBAR)
						      AADD(aTitCodBar,{E2_CODBAR})
							  If Len(aTitCodBar) >= 1
								   If !MsgYesNo("H· tÌtulos com o cÛdigo de barras preenchido. Deseja continuar?","CÛdigo de barras no tÌtulo")
									  lRet := .F.
									  EXIT
								   EndIf
								EndIf
							 EndIf
						EndIf

						// 10/10/2019 - Paulo Henrique - Analisa se existe o cÛdigo do Favorecido
						If !(Len(aTitCodFav) >= 1)
						   If Ascan(aTitCodFav,{|x|x[1] == SE2->E2_ZCODFAV}) == 0 .And. !Empty(SE2->E2_ZCODFAV)
						      AADD(aTitCodFav,{E2_ZCODFAV})
							  If Len(aTitCodFav) >= 1
								   If !MsgYesNo("H· tÌtulos com o favorecido preenchido. Deseja continuar?","Favorecido do tÌtulo")
									  lRet := .F.
									  EXIT
								   EndIf
								EndIf
							 EndIf
						EndIf

						nX := SE2->(RecNo()) // Variavel nX È o RECNO da TABELA FISICA DO SE2

						// Gravar o HistÛrico correto na FATURA
						cHistFat := (cAliasSE2)->E2_HIST

						IF SE2->E2_EMISSAO < dMenorDT
							dMenorDT := SE2->E2_EMISSAO
						EndIf 

						IF !Empty(SE2->E2_XOBS)
							cOBSSum += Alltrim(SE2->E2_XOBS)+' / '
						EndIf

						//==========================================
						//Inicio da geraÁ„o do tipos de valores.
						//==========================================
                        
						// 02/Abril/2019 - Natanael Filho: Se o tÌtulo sofreu baixa, n„o ser· considerado os tipos de valores.
						If SE2->E2_VALLIQ == 0
							
							_nVlrNdf := SE2->E2_VALOR

							IF SE2->E2_SDACRES <> 0
							   
							   // Paulo Henrique - TOTVS - 28/08/2019
							   // Se a fatura foi parcelada, faz o calculo proporcional do acrÈscimo
							   If cCond > 1 
								  nAcre1SUM  += SE2->E2_ACRESC / cCond 
								  nAcre2SUM  += SE2->E2_SDACRES / cCond
							   Else
								  nAcre1SUM  += SE2->E2_ACRESC 
								  nAcre2SUM  += SE2->E2_SDACRES
							   EndIf

							EndIf

							IF SE2->E2_SDDECRE <> 0

							   // Paulo Henrique - TOTVS - 28/08/2019
							   // Se a fatura foi parcelada, faz o calculo proporcional do decrÈscimo
							   If cCond > 1
								  nDecre1SUM += SE2->E2_DECRESC / cCond
								  nDecre2SUM += SE2->E2_SDDECRE / cCond
							   Else 
								  nDecre1SUM += SE2->E2_DECRESC
								  nDecre2SUM += SE2->E2_SDDECRE
							   EndIf 

							EndIf 
							
							// Agrupamento de Tipo de Valor do tÌtulo
    						IF (SE2->E2_SDACRES <> 0 .Or. SE2->E2_SDDECRE <> 0)
								Atu_TipoValor(aTipoValor) 
							EndIf 

							//-- Caroline Cazela 16/01/19 -> Regra para limpeza de campo E2_FATURA das NDFs
							If SE2->E2_TIPO == "NDF"
								Reclock("ZDS",.T.)
								ZDS->ZDS_FILIAL := xFilial("SE2")
								ZDS->ZDS_PREFIX := cPrefix
								ZDS->ZDS_NUM    := cFatura
								ZDS->ZDS_PARCEL := cParcela
								ZDS->ZDS_TIPO   := cTpc
								ZDS->ZDS_FORNEC := cForne
								ZDS->ZDS_LOJA   := cLojax
								ZDS->ZDS_COD    := "xxx"
								ZDS->ZDS_VALOR  := _nVlrNdf
								ZDS->(MsUnlock())
							EndIf

						EndIf

						//===================================
						// FIM da geraÁ„o do tipos de valoes.
						//===================================

						ABATIMENTO := 0

						cFilAnt	:= SE2->E2_FILORIG

						If (cAliasSE2)->CALCULADO == '1'
							ABATIMENTO := (cAliasSE2)->VLSOMAABAT
						Else
							ABATIMENTO := SomaAbat(cPrefixo,cNumero,cParcela,"P",cMoeda,,cForne,cLojax,,,cTpc)   
						EndIf

						cFilAnt	:= cFilAtu
						nTotAbat += ABATIMENTO

						//Baixo os titulos de abatimento
						If ABATIMENTO > 0 
							dbSelectArea("__SE2")
							__SE2->(dbSetOrder(1))
							__SE2->(MsSeek(xFilial("SE2",cFilOrig)+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)))
							
							While !EOF() .And. __SE2->E2_FILIAL == xFilial("SE2",cFilOrig) ;
							             .And. __SE2->E2_PREFIXO == SE2->E2_PREFIXO ;
										 .And. __SE2->E2_NUM == SE2->E2_NUM ;
										 .And. __SE2->E2_PARCELA == SE2->E2_PARCELA

								IF __SE2->E2_TIPO $ MVABATIM .And. __SE2->E2_FORNECE == SE2->E2_FORNECE .And. ;
								    Empty( __SE2->E2_BAIXA ) .And. !Empty( __SE2->E2_SALDO )
									
									If !( __SE2->E2_FATURA == cFatura .And. __SE2->E2_FATPREF == cPrefix .And. ;
									      __SE2->E2_TIPOFAT == cTipo .And. __SE2->E2_DTFATUR == dDatabase .And. ;
										  __SE2->E2_FLAGFAT == "S" )
										
										RecLock("__SE2")
										__SE2->E2_BAIXA		:= dDataBase
										__SE2->E2_VALLIQ	:= __SE2->E2_SALDO
										__SE2->E2_SALDO		:= 0
										__SE2->E2_MOVIMEN	:= dDataBase
										__SE2->E2_FATURA	:= cFatura
										__SE2->E2_FATPREF	:= cPrefix
										__SE2->E2_TIPOFAT	:= cTipo
										__SE2->E2_DTFATUR	:= dDatabase
										__SE2->E2_FLAGFAT	:= "S"
										__SE2->E2_FATFOR	:= IIF(mv_par01 == 1,cForn,cFornP)
										__SE2->E2_FATLOJ	:= IIF(mv_par01 == 1,cLoja,cLojaP)
										MsUnlock()

										// Tira o saldo do vencimento programado do titulo
										AtuSldNat(__SE2->E2_NATUREZ, __SE2->E2_VENCREA, __SE2->E2_MOEDA, "2", "P", __SE2->E2_VALLIQ, xMoeda(__SE2->E2_VALLIQ, __SE2->E2_MOEDA, 1),"+",,FunName(),"__SE2",__SE2->(Recno()),nOpcE)
									EndIf

								EndIf

								__SE2->(dbSkip())

							EndDo

						EndIf

						dbSelectArea("SE2")
						dbGoto(nX)	// Posiciona novamente no REGISTRO FISICO do SE2

						// Atualiza a Baixa do Titulo
						// Se tem Saldo e TIPO n„o est· nos tipos ABATIMENTO 
						If !(E2_TIPO $ MVABATIM) .And. E2_SALDO > 0
							nJur290	 := SE2->E2_SDACRES
							nDesc290 := SE2->E2_SDDECRE
							nValCorr := fa090Correc( ) 

							// Posiciona no Cadastro de Naturezas
							SED->(dbSetOrder(1))
							SED->(MsSeek(xFilial("SED",cFilOrig)+SE2->E2_NATUREZ))

							SA2->(dbSetOrder(1))
							SA2->(MSSeek(xFilial("SA2",cFilOrig)+SE2->(E2_FORNECE+E2_LOJA)))

							lIRPFBaixa := (SA2->A2_CALCIRF == "2")
							lCalcIssBx := IIF(lIsIssBx, IsIssBx("P"), SuperGetMv("MV_MRETISS",.F.,"1") == "2" )
							lBaseIRPF  := F050BIRPF(2)

							//Tratamento de base e impostos Lei 10925 quando pela baixa
							If lPccBaixa .And. (SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL > 0) 

								nVlrTit := SE2->(E2_VALOR+E2_IRRF+E2_ISS)

								If !lInssBx	
									nVlrTit += SE2->E2_INSS
								EndIf

								nVlrTit += SE2->E2_SEST

								If lCalcIssBx 
									nVlrTit -= SE2->E2_ISS
								EndIf

								// AQUI VERIFICO QUANTO FOI RETIDO E QUANTO FALTA RETER
								nPCCRet	:= 0
								nPisRet	:= 0
								nCofRet	:= 0
								nCslRet	:= 0

								If dDatabase < dLastPcc .Or. lEmpPub

									SE5->(DBSetOrder(7))

									If SE5->(MSSEEK(xFilial("SE5",cFilOrig)+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))

										cKeyTit := xFilial("SE5",cFilOrig)+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)

										While !(SE5->(EOF())) .And. cKeyTit = xFilial("SE5",cFilOrig)+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)

											If (Empty(SE5->E5_PRETPIS) .Or. SE5->E5_PRETPIS=='4' .Or. SE5->E5_PRETPIS=='5') .And. !(SE5->E5_SITUACA=='C')
												// Valida se trata-se de um movimento de estorno, retirando os valores retidos
												If SE5->E5_TIPODOC != "ES"
													//Armazeno os valores calculados por titulo, retirando os valores retidos
													nPisRet += SE5->E5_VRETPIS
													nCofRet += SE5->E5_VRETCOF 
													nCslRet += SE5->E5_VRETCSL
												Else
													// Armazeno os valores calculados por titulo, retirando os valores retidos
													nPisRet -= SE5->E5_VRETPIS
													nCofRet -= SE5->E5_VRETCOF 
													nCslRet -= SE5->E5_VRETCSL
												EndIf

												If SubStr(SE5->E5_DOCUMEN,nTamTit+1,nTamTip) $ MV_CPNEG
													lCompNdf := .T.
												EndIf
											EndIf

											SE5->(dbSkip())

										EndDo

									EndIf

									If (cPaisLoc == "BRA")   //Utilizo a base dos impostos e nao o saldo do titulo
										nBasePCC += IIF(Empty(E2_BASEPIS), E2_SALDO+E2_ISS+E2_IRRF,E2_BASEPIS)

										If !lInssBx	
											nBasePCC += IIF(Empty(E2_BASEPIS),Iif(!lInssBx,E2_INSS,0),0)							
										EndIf

									EndIf

									If lPABruto
										nBasePCC += PABrtComp()
									EndIf					

									If !lCompNdf				
										nPisFat += SE2->E2_PIS - nPisRet
										nCofFat += SE2->E2_COFINS - nCofRet
										nCslFat += SE2->E2_CSLL - nCslRet
									Else
										nPisFat += (SE2->E2_PIS * E2_SALDO+nPisRet) / E2_VALOR
										nCofFat += (SE2->E2_COFINS * E2_SALDO+nCofRet) / E2_VALOR
										nCslFat += (SE2->E2_CSLL * E2_SALDO+nCslRet) / E2_VALOR
									EndIf		

								ElseIf SE2->E2_TIPO <> MVPAGANT .And. Empty(SE2->E2_NUMBOR)

									nSalTit	 := salRefPag(SE2->(E2_FORNECE+E2_LOJA))
									nBasePCC += nSalTit

									aPcc := newMinPcc(dDataBase,nSalTit,SE2->E2_NATUREZ,"P",SE2->(E2_FORNECE+E2_LOJA))

									nPisFat += aPcc[2]	
									nCofFat += aPcc[3] 
									nCslFat += aPcc[4] 

								EndIf

							EndIf

							// Busca a NATUREZA do tÌtulo marcado.
							SED->(DbSeek(xFilial("SED") + SE2->E2_NATUREZ ))				
							
							If SED->ED_CALCINS == "S" .And. SA2->A2_RECINSS == "S" .And. lInssBx .And. cPaisLoc = "BRA" //Inss Baixa						         
								nBaseRet :=	0
								nVlrTit	 :=	0
							
								SE5->(DBSetOrder(7))
							
								If SE5->(Msseek(xFilial("SE5",cFilOrig)+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
									cKeyTit := xFilial("SE5",cFilOrig)+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
							
									While !(SE5->(EOF())) .And. cKeyTit = xFilial("SE5",cFilOrig)+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)

										If (Empty( SE5->E5_PRETINS ) .Or. SE5->E5_PRETINS == '4' ) .And. !(SE5->E5_SITUACA=='C')
											//Armazeno os valores calculados por titulo, retirando os valores retidos
											nBaseRet +=	SE5->(E5_VALOR+E5_VRETINS+E5_VRETIRF+E5_VRETCSL+E5_VRETCOF+E5_VRETPIS+E5_VRETISS)
										EndIf

										SE5->(dbSkip())

									EndDo

								EndIf				

								nVlrTit	+= SE2->E2_VALOR //Impostos na baixa

								If !lIrpfBaixa  
									nVlrTit	+= SE2->E2_IRRF
								EndIf

								If !lPCCBaixa .And.;
									(SE2->E2_BASEPIS > nVlMinImp .Or.; //Somar se o titulo n„o for menor que 5000 que os impostos n„o tenham sido retidos. 
										(SE2->E2_BASEPIS <= nVlMinImp .And.; 
										 SE2->E2_PRETCSL $ " 43" .And. ;
										 SE2->E2_PRETCOF $ " 43" .And. ;
										 SE2->E2_PRETPIS $ " 43") ) 
									nVlrTit	+= SE2->(E2_PIS+E2_COFINS+E2_CSLL)
								EndIf

								If !lCalcIssBx
									nVlrTit	+= SE2->E2_ISS
								EndIf

								nBaseFat +=	(nVlrTit - nBaseRet) // Remontar a base do titulo que j· foi retido.

								If !Empty( SED->ED_BASEINS )// Base reduzida
									nVlrTit := ( nVlrTit * SED->ED_BASEINS ) / 100
								EndIf

								If lRoundIns
									nInsFat	:= nInsFat + Round(( (nVlrTit - nBaseRet) * (SED->ED_PERCINS/100)),2)
								Else
									nInsFat := nInsFat + NoRound(( (nVlrTit - nBaseRet) * (SED->ED_PERCINS/100)),2)
								EndIf

								If !Empty(SE2->E2_BAIXA) // Caso titulo baixado								
									nOldIns	 :=	SE2->E2_INSS
									nOldVret :=	SE2->E2_VRETINS
									cOldIns	 :=	SE2->E2_PRETINS
								Else								
									If lRoundIns //Valor do inss do titulo
										nOldIns	:= Round(( (nVlrTit) * (SED->ED_PERCINS/100)),2)
									Else
										nOldIns	:= NoRound(( (nVlrTit) * (SED->ED_PERCINS/100)),2)
									EndIf		

									nOldVret :=	nOldIns
									cOldIns	 :=	""

								EndIf

							EndIf           		

							// Tratamento de IRRF na Baixa
							If lIrpfBaixa 

								// Tratamento para o total de IR						
								If SA2->A2_TIPO == "J" .And. SED->ED_CALCIRF == "S"
									nTotIRPJ += FCalcIRBx(0,SA2->A2_TIPO,dDatabase,dDataBase)
									nSalTit	 := salRefPag(SE2->(E2_FORNECE+E2_LOJA))
									nBaseIrf += nSalTit
								EndIf

								lUsaBaseIr := .F.

								// Verifico se controla a base de Impostos
								If lBaseIrpf
									If SE2->E2_BASEIRF > 0
										nBaseIrpf += SE2->E2_BASEIRF
										lUsaBaseIr := .T.
									Else
										nBaseIrpf += (SE2->E2_SALDO + Iif(!lInssBx,SE2->E2_INSS,0))
									EndIf
								Else							
									nBaseIrpf += (SE2->E2_SALDO + Iif(!lInssBx,SE2->E2_INSS,0))
								EndIf	

								// Se nao usou o valor do  
								If !lUsaBaseIr
									If !lCalcIssBx
										nBaseIrpf += SE2->E2_ISS
									EndIf

									If !lIRPFBaixa
										nBaseIrpf += SE2->E2_IRRF
									EndIf
								EndIf

								//Se for PF, verifica se reduz o INSS da base do IRRF
								nBaseIrpf -= Iif((SuperGetMv("MV_INSIRF",.F.,"2") == "1" .And. SA2->A2_TIPO != "J"),SE2->E2_INSS,0)

							EndIf	

							// Grava o titulo no SE2 com TIPO e FATURA informados na Tela Inicial.   
							RecLock("SE2")
							SE2->E2_BAIXA := dDataBase

							/* 
							Se j· houve qualquer baixa parcial, os campos de acrescimo e decrescimo 
							j· foram considerados
							*/

							SE2->E2_VALLIQ := IIF(SE2->E2_VALLIQ > 0,;
							                      SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE)-ABATIMENTO,;
							                      SE2->(E2_VALLIQ+E2_SALDO)-ABATIMENTO) 
							SE2->E2_JUROS	:= nJur290
							SE2->E2_DESCONT	:= nDesc290
							SE2->E2_SALDO	:= 0
							SE2->E2_MOVIMEN := dDataBase
							SE2->E2_FATURA  := cFatura
							SE2->E2_FATPREF := cPrefix
							SE2->E2_TIPOFAT := cTipo
							SE2->E2_DTFATUR := dDataBase
							SE2->E2_FLAGFAT := "S"
							SE2->E2_SDACRES := 0
							SE2->E2_SDDECRE := 0
							SE2->E2_CORREC  := 	nValCorr
							SE2->E2_FATFOR  := IIF(mv_par01 == 1,cForn,cFornP)
							SE2->E2_FATLOJ  := IIF(mv_par01 == 1,cLoja,cLojaP)

							// Zero os impostos para que n„o sejam contabilizados neste momento
							// Somente o ser„o na baixa do titulo gerado pela fatura.
							If lPccBaixa
								nOldPis			:= SE2->E2_PIS
								nOldCof 		:= SE2->E2_COFINS
								nOldCsl 		:= SE2->E2_CSLL
								SE2->E2_PIS 	:= 0
								SE2->E2_COFINS	:= 0
								SE2->E2_CSLL	:= 0
							EndIf

							If SED->ED_CALCINS == "S" .And. SA2->A2_RECINSS == "S" .And. lInssBx .And. cPaisLoc = "BRA" // Inss Baixa
								SE2->E2_INSS	:=	0
								SE2->E2_VRETINS	:=	0
								SE2->E2_PRETINS	:= ""
							EndIf

							MsUnlock()
						
							// Rastreamento - Geradores
							If lRastro
								aadd(aRastroOri,{	SE2->E2_FILIAL,;
													SE2->E2_PREFIXO,;
													SE2->E2_NUM,;
													SE2->E2_PARCELA,;
													SE2->E2_TIPO,;
													SE2->E2_FORNECE,;
													SE2->E2_LOJA,;
													SE2->E2_VALLIQ } )
							EndIf

							//Atualiza integraÁ„o com ManutenÁ„o de Ativos
							If SuperGetMV("MV_NGMNTFI",.F.,"N") == "S"  .And. FindFunction("NGVALPGTRX")
								NGVALPGTS1( SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,'',SE2->E2_VALLIQ )
								NGVALPGTRX( SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,'',SE2->E2_VALLIQ )
							EndIf

							dbSelectArea("SE2")

							// Tira o saldo do vencimento programado do titulo
							AtuSldNat(SE2->E2_NATUREZ,SE2->E2_VENCREA,SE2->E2_MOEDA,"2","P",SE2->E2_VALLIQ,xMoeda(SE2->E2_VALLIQ, E2->E2_MOEDA,1),"-",,FunName(),"SE2",SE2->(Recno()),nOpcE)

							aAdd(aE2CCC,SE2->E2_CCC)
							aAdd(aE2CCD,SE2->E2_CCD)
							aAdd(aCCUSTO,SE2->E2_CCUSTO) 

							//Documentos 
							IF lFinVDoc

								If SE2->E2_TEMDOCS = "1"
									aAdd(aDocsOri,{	SE2->E2_FILIAL,;
													SE2->E2_PREFIXO,;
													SE2->E2_NUM,;
													SE2->E2_PARCELA,;
													SE2->E2_TIPO,;
													SE2->E2_FORNECE,;
													SE2->E2_LOJA } )
								EndIf

							EndIf

							If SuperGetMV("MV_MRETISS",,"1") == "2" //Retencao do ISS na baixa
								nISSFat  += SE2->E2_ISS
								nFRetISS := SE2->E2_FRETISS
								nTRetISS := SE2->E2_TRETISS
							EndIf

							// Grava os lancamentos nas contas orcamentarias SIGAPCO
							PcoDetLan("000015","02","FINA290")

							// Localiza a sequencia da baixa ( CP,BA,VL,V2,LJ )
							aTipoDoc := {"CP","BA","VL","V2"}
							SE5->(dbSetOrder(2))
							cSequencia := Replicate("0",nTamSeq)

							For nX := 1 to len(aTipoDoc)
								SE5->(dbSeek(SE2->E2_FILIAL + aTipoDoc[nX] + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO)) )
								While !SE5->(Eof())						    	.And. ;
											SE5->E5_FILIAL  == SE2->E2_FILIAL  	.And. ;
											SE5->E5_TIPODOC == aTipoDoc[nX]   	.And. ;
											SE5->E5_PREFIXO == SE2->E2_PREFIXO 	.And. ;
											SE5->E5_NUMERO  == SE2->E2_NUM		.And. ;
											SE5->E5_PARCELA == SE2->E2_PARCELA 	.And. ;
											SE5->E5_TIPO	== SE2->E2_TIPO

									If ( SE5->(E5_CLIFOR+E5_LOJA) == SE2->(E2_FORNECE+E2_LOJA) .And. SE5->E5_RECPAG == "P" )
										If PadL(AllTrim(cSequencia),nTamSeq,"0") < PadL(AllTrim(SE5->E5_SEQ),nTamSeq,"0")
											cSequencia := SE5->E5_SEQ
										EndIf
									EndIf
									SE5->(dbSkip())
								EndDo
							Next

							If Len(AllTrim(cSequencia)) < nTamSeq
								cSequencia := PadL(AllTrim(cSequencia),nTamSeq,"0")
							EndIf

							// Soma mais um na proxima Sequencia para o SE5
							cSequencia := Soma1(cSequencia,nTamSeq)

							// Define os campos que n„o existem nas FKs e que ser·o gravados apenas na E5, para que a gravaÁ„o da E5 continue igual
							If !Empty(cCamposE5)
								cCamposE5 += "|"
							EndIf

							cCamposE5 += "{"
							cCamposE5 += " {'E5_FILIAL'	, SE2->E2_FILIAL}"
							cCamposE5 += ",{'E5_TIPO'	, SE2->E2_TIPO}"
							cCamposE5 += ",{'E5_PREFIXO', SE2->E2_PREFIXO}"
							cCamposE5 += ",{'E5_NUMERO'	, SE2->E2_NUM}"
							cCamposE5 += ",{'E5_PARCELA', SE2->E2_PARCELA}"
							cCamposE5 += ",{'E5_FORNECE', SE2->E2_FORNECE}"
							cCamposE5 += ",{'E5_CLIFOR'	, SE2->E2_FORNECE}"
							cCamposE5 += ",{'E5_LOJA'	, SE2->E2_LOJA}"
							cCamposE5 += ",{'E5_DTDIGIT', dDataBase}"
							cCamposE5 += ",{'E5_DTDISPO', dDataBase}"
							cCamposE5 += ",{'E5_BENEF'	, SE2->E2_NOMFOR}"
							cCamposE5 += ",{'E5_VLDESCO'," + Str(nDesc290) + "}"
							cCamposE5 += ",{'E5_VLJUROS'," + Str(nJur290)  + "}"

							If !lUsaFlag .And. lPadrao
								cCamposE5 += ",{'E5_LA'	, 'S'}"
							EndIf

							cCamposE5 += "}"

							// MONTA UM MODELO para o PADRAO de BAIXAS A PAGAR 
							oModelBxP	:= FWLoadModel("FINM020") //Model de baixas a pagar
							oModelBxP:SetOperation( 3 ) //Inclusao
							oModelBxP:Activate()	
							oModelBxP:SetValue( "MASTER", "E5_GRV", .T. ) //Informa se vai gravar SE5 ou n„o
							oModelBxP:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que ser·o gravados indepentes de FK5
							oModelBxP:SetValue( "MASTER", "NOVOPROC", .T. ) //Informa que a inclus„o ser· feita com um novo N˙mero de processo

							oSubFK2	:= oModelBxP:GetModel("FK2DETAIL")
							oSubFK6	:= oModelBxP:GetModel("FK6DETAIL")

							cChaveTit	:= xFilial("SE2") + "|" + SE2->E2_PREFIXO + "|" + SE2->E2_NUM + "|" + SE2->E2_PARCELA + "|" + SE2->E2_TIPO + "|" + SE2->E2_FORNECE + "|" + SE2->E2_LOJA
							cChaveFK7	:= FINGRVFK7("SE2", cChaveTit)
							cChaveFk2	:= FWUUIDV4()

							//Dados do Processo - Define a chave da FKA no IDORIG
							oFKA := oModelBxP:GetModel("FKADETAIL")

							If !oFKA:IsEmpty()
								oFKA:AddLine()
							EndIf

							oFKA:SetValue( "FKA_IDORIG", cChaveFk2 )
							oFKA:SetValue( "FKA_TABORI", "FK2" )

							//Dados da baixa a pagar do referido TITULO MARCADO ... no FK2 com HistÛrico
							oSubFK2:SetValue( "FK2_DATA"	, dDataBase )
							oSubFK2:SetValue( "FK2_VALOR"	, xMoeda(SE2->E2_VALLIQ,SE2->E2_MOEDA,1,dDataBase) )
							oSubFK2:LoadValue( "FK2_NATURE"	, SE2->E2_NATUREZ )
							oSubFK2:SetValue( "FK2_RECPAG"	, "P" )
							oSubFK2:SetValue( "FK2_TPDOC"	, "BA")
							oSubFK2:SetValue( "FK2_HISTOR"	, STR0056+cFatura ) //"Bx.p/Emiss.Fatura "
							oSubFK2:SetValue( "FK2_VLMOE2"	, SE2->E2_VALLIQ )
							oSubFK2:SetValue( "FK2_SEQ"		, cSequencia )
							oSubFK2:SetValue( "FK2_FILORI"	, SE2->E2_FILORIG )
							oSubFK2:SetValue( "FK2_CCUSTO"	, SE2->E2_CCUSTO )
							oSubFK2:SetValue( "FK2_MOEDA"	, StrZero(SE2->E2_MOEDA, TamSx3("FK2_MOEDA")[1]) )
							oSubFK2:SetValue( "FK2_MOTBX"	, "FAT" )
							oSubFK2:SetValue( "FK2_IDDOC"	, cChaveFK7 )
							oSubFK2:SetValue( "FK2_ORIGEM"	, Funname() )

							// Atualiza a MovimentaÁ„oo Banc·ria
							For nX := 2 To 4

								If     nX == 2
									   cCpoTp := "nJur290"
									   cTpDoc := "JR"
								Elseif nX == 3
									   cCpoTp := "nDesc290"
									   cTpDoc := "DC"      
								Elseif nX == 4
									   cCpoTp := "nValCorr"
									   cTpDoc := "CM"	
								EndIf

								If &cCpoTp != 0
									
									// Valores AcessÛrios
									If !oSubFK6:IsEmpty()
										oSubFK6:AddLine()					// Inclui a quantidade de linhas necess·rias
										oSubFK6:GoLine( oSubFK6:Length() )	// Vai para linha criada
									EndIf	

									// Grava os DADOS da Tabela FK6 com HistÛrico Emissao Fatura
									oSubFK6:SetValue( "FK6_FILIAL"	, FWxFilial("FK6") )
									oSubFK6:SetValue( "FK6_IDFK6"	, GetSxEnum("FK6","FK6_IDFK6") )                                                                
									oSubFK6:SetValue( "FK6_TABORI"	, "FK2" )
									oSubFK6:SetValue( "FK6_TPDOC"	, cTpDoc )
									oSubFK6:SetValue( "FK6_VALCAL"	, Iif (nX==4,&cCpoTp,xMoeda(&cCpoTp,SE2->E2_MOEDA,1,dDataBase)) )  
									oSubFK6:SetValue( "FK6_VALMOV"	, Iif (nX==4,&cCpoTp,xMoeda(&cCpoTp,SE2->E2_MOEDA,1,dDataBase)) )
									oSubFK6:SetValue( "FK6_RECPAG"	, "P" )
									oSubFK6:SetValue( "FK6_IDORIG"	, cChaveFK2 )								    
									oSubFK6:SetValue( "FK6_HISTOR"	, STR0056+cFatura ) //"Bx.p/Emiss.Fatura "

								EndIf

							Next

							ABATIMENTO := 0

							If oModelBxP:VldData()
								oModelBxP:CommitData()
							Else
								lRet := .F.
								cLog := cValToChar(oModelBxP:GetErrorMessage()[4]) + ' - '
								cLog += cValToChar(oModelBxP:GetErrorMessage()[5]) + ' - '
								cLog += cValToChar(oModelBxP:GetErrorMessage()[6])        	
								Help( ,,"M020VALID",,cLog, 1, 0 )	             
							EndIf

							If lRet 
								// Contabiliza a baixa do titulo
								IF lContab530

									If nHdlPrv <= 0
										nHdlPrv := HeadProva(cLote,"FINA290",SubStr(cUsuario,7,6),@cArquivo)
									EndIf

									If lUsaFlag	// Armazena em aFlagCTB para atualizar no modulo Contabil
										aAdd( aFlagCTB, { "FK2_LA", "S", "FK2", FK2->( RecNo() ), 0, 0, 0} )
										aAdd( aFlagCTB, { "E5_LA" , "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
									EndIf

									// Contabiliza pela variavel VALOR. Nao necessita de controle de flag.
									nTotal += DetProva( nHdlPrv,;
														"530",;
														"FINA290" /*cPrograma*/,;
														cLote,;
														/*nLinha*/,;
														/*lExecuta*/,;
														/*cCriterio*/,;
														/*lRateio*/,;
														/*cChaveBusca*/,;
														/*aCT5*/,;
														/*lPosiciona*/,;
														@aFlagCTB,;
														/*aTabRecOri*/,;
														/*aDadosProva*/ )

									If !lUsaFlag .And. (nTotal > 0)
										oSubFK2:SetValue("FK2_LA","S") // Dados da baixa a pagar
									EndIf	
								EndIf

								// Preenchendo variavel para ponto de entrada
								aadd(aTitSE5,{	{"E5_FILIAL"	, E5_FILIAL     , nil },;
												{"E5_DATA"		, E5_DATA		, nil },;
												{"E5_VALOR"		, E5_VALOR		, nil },;
												{"E5_NATUREZ"	, E5_NATUREZ	, nil },;
												{"E5_RECPAG"	, E5_RECPAG		, nil },;
												{"E5_TIPO"		, E5_TIPO		, nil },;
												{"E5_TIPODOC"	, E5_TIPODOC	, nil },;
												{"E5_HISTOR"	, E5_HISTOR		, nil },;
												{"E5_PREFIXO"	, E5_PREFIXO	, nil },;
												{"E5_NUMERO"	, E5_NUMERO		, nil },;
												{"E5_PARCELA"	, E5_PARCELA	, nil },;
												{"E5_FORNECE"	, E5_FORNECE	, nil },;
												{"E5_CLIFOR"	, E5_CLIFOR		, nil },;
												{"E5_LOJA"		, E5_LOJA		, nil },;
												{"E5_DTDIGIT"	, E5_DTDIGIT	, nil },;
												{"E5_MOTBX"		, E5_MOTBX		, nil },;
												{"E5_VLMOED2"	, E5_VLMOED2	, nil },;
												{"E5_VLCORRE"	, E5_VLCORRE	, nil },;
												{"E5_SEQ"		, E5_SEQ		, nil },;
												{"E5_DTDISPO"	, E5_DTDISPO	, nil },;
												{"E5_BENEF"		, E5_BENEF		, nil },;
												{"E5_FILORIG"	, E5_FILORIG	, nil },;
												{"R_E_C_N_O_"	, SE5->(Recno()), nil }})

								// Restauro os valores dos impostos
								If lPccBaixa
									RecLock("SE2")
									SE2->E2_PIS 	:= nOldPis
									SE2->E2_COFINS 	:= nOldCof
									SE2->E2_CSLL 	:= nOldCsl
									MsUnlock()
								EndIf

								If SED->ED_CALCINS == "S" .And. SA2->A2_RECINSS == "S" .And. lInssBx .And. cPaisLoc = "BRA" //Inss Baixa					         						
									RecLock("SE2")
									SE2->E2_INSS 		:= nOldIns
									SE2->E2_VRETINS 	:= nOldVret
									SE2->E2_PRETINS		:= cOldIns
									MsUnlock()
								EndIf			 

								aArea := GetArea()

								dbSelectArea("SA2")
								SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
								SA2->(RecLock("SA2"))
								
								nMoedaC	 := Int(Val(GetMv("MV_MCUSTO")))

								If !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM)
									SA2->A2_SALDUP  -= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
									SA2->A2_SALDUPM -= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoedaC,SE2->E2_EMISSAO,3),3),2)
								Else
									SA2->A2_SALDUP  += Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
									SA2->A2_SALDUPM += Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,3),3),2)
								EndIf

								RestArea(aArea)

							EndIf

							If ValType(oModelBxP) == "O" 
								oModelBxP:DeActivate()
								oModelBxP:Destroy()
							EndIf
							
							oModelBxP:= Nil
							oSubFK2  := Nil 
							oSubFK6  := Nil
							oFKA     := Nil

						EndIf
					                            
					EndIf

					dbSelectArea(cAliasSE2)

					(cAliasSE2)->(dbSkip())

				EndDo

				If lRet	// Posicionamentos para  GERAR FATURA

					// Posiciono cadastro de fornecedor e natureza 
					// dos titulo a serem gerados pela fatura
					dbSelectArea("SA2")

					If mv_par01 == 1
						MsSeek(xFilial("SA2")+cForn+cLoja)			 
					Else
						MsSeek(xFilial("SA2")+cFornp+cLojap)			 
					EndIf

					SED->(MsSeek(xFilial("SED")+cNat))

					// Somente para compor os valors dos impostos corretamente em cima da Base para a Fatura.	
					If (dDatabase > dLastPcc) .And. SE2->E2_TIPO != MVPAGANT .And. Empty(SE2->E2_NUMBOR) .And. !lEmpPub 
						If MV_PAR01 == 1
							aPcc:= newMinPcc(dDataBase,  nBasePCC ,cnat,"P",SE2->E2_FORNECE+SE2->E2_LOJA,,,,, lPCCBaixa )
						Else
							aPcc:= newMinPcc(dDataBase,  nBasePCC ,cnat,"P",cFornP+cLojaP,,,,, lPCCBaixa )
						EndIf			

						nPisFat := aPcc[2]	
						nCofFat := aPcc[3] 
						nCslFat := aPcc[4] 
					EndIf

					nValTotal := 0
					
					// Recrio as bases e valores de impostos de acordo com as alteracoes efetuadas nas parcelas da fatura
					aBaseFat := aClone(aCols)
					aPisFat  := aClone(aCols)
					aCofFat  := aClone(aCols)
					aCslFat  := aClone(aCols)
					aIrfFat	 := aClone(aCols)
					aISSFat  := aClone(aCols)
					aBaseIR	 := aClone(aCols)
					aInsFat	 := aClone(aCols)
					aBaseIns := aClone(aCols)

					// Obtenho a base do IR para esta parcela
					// Primeiro calculo o valor de base de IR Total (soma dos titulos que tem IR)
					// Segundo, aplico o redutor de base de IR sobre a base total.
					// Tenho a base total de IR da Fatura.
					// Proporcionalizo o valor de cada parcela
					// Exemplo
					// Titulo		Valor		BaseIR
					// 	 A			10.000	10.000
					//	 B			10.000	 8.000
					//	 C			10.000	     0
					//				------	------
					// Totais		30.000	18.000
					//
					// Valor da Fatura = 30.000
					// Valor dos titulos com IR = 20.000 (Soma de A+B (ignoro a base anterior))
					// --------------------------------------------------------
					// Parcelado em 2x com uma natureza com base IR de 80%
					//
					// Base total de IR com reduÁ„o : (20.000 * 0.8) = 16.000
					// Titulo		Valor		BaseIR
					//	 A			15.000	 8.000
					//	 B			15.000	 8.000
					//				------	------
					// Totais		30.000	16.000
					// --------------------------------------------------------										
					// Parcelado em 2x com uma natureza com base IR de 100% (sem redutor)
					//
					// Base total de IR = 20.000
					//
					// Titulo		Valor		BaseIR
					//	 A			15.000	10.000
					//	 B			15.000	10.000
					//				------	------
					// Totais		30.000	20.000
					// -------------------------------------------------------
					
					// Obtenho o redutor de base do IRPF (natureza da fatura)
					lBaseIRPF  := F050BIRPF(3)

					If lIrpfBaixa .And. ( lBaseIrpf .Or. SA2->A2_TIPO == "J" )
						If nBaseIrf > 0
							nBaseIrpf := nBaseIrf
						EndIf

						If nBaseIrpf < nValor
							nPropIR := nBaseIrpf/nValor
							For nW := 1 to Len(aBaseIR)
								aBaseIR[nW,6]	:= (aBaseIR[nW,6] * nPropIr)
							Next
						EndIf

						nPropIr	:= If (SED->ED_BASEIRF > 0, (SED->ED_BASEIRF/100),1)	

						// Reduzo a base do IR para cada parcela 
						// de acordo com a base de IR da natureza da fatura
						If nPropIR < 1
							nBaseIrpf := nBaseIrpf * nPropIr
							For nW := 1 to Len(aBaseIR)
								aBaseIR[nW,6]	:= (aBaseIR[nW,6] * nPropIr)
							Next
						EndIf
					EndIf

					// Acerto os valores de base e impostos de acordo com a nova configuracao do aCols
					For nW := 1 to Len(aCols)
						nProp := aCols[nW,6] / nValor  //Proporcao entre a parcela e o valor total da fatura

						If nW < Len(aCols)
							aBaseFat[nW,6] 	:= nBasePcc * nProp
							aPisFat[nW,6]	:= nPisFat * nProp
							aCofFat[nW,6]	:= nCofFat * nProp
							aCslFat[nW,6]	:= nCslFat * nProp
							aIrfFat[nW,6]	:= nTotIRPJ * nProp
							aBaseIr[nW,6]	:= nBaseIrpf * nProp					
							aISSFat[nW,6]	:= nISSFat * nProp
							aBaseIns[nW,6]	:= nBaseFat * nProp
							aInsFat[nW,6]	:= nInsFat * nProp

							nTotBase +=	aBaseFat[nW,6]							
							nTotPis	 +=	aPisFat[nW,6]
							nTotCof	 +=	aCofFat[nW,6]
							nTotCsl	 +=	aCslFat[nW,6]
							nTotISS	 += aISSFat[nW,6]
							nTtIRFat += Round(NoRound(aIrfFat[nW,6],3),2)
							nTotIRF	 += Round(NoRound(aBaseIr[nW,6],3),2)			
							nTotIns	 += aInsFat[nW,6]
							nTotBIns += Round(NoRound(aBaseIns[nW,6],3),2)								
						Else                                        
							aBaseFat[nW,6] 	:= nBasePcc - nTotBase
							aPisFat[nW,6] 	:= nPisFat - nTotPis
							aCofFat[nW,6] 	:= nCofFat - nTotCof
							aCslFat[nW,6] 	:= nCslFat - nTotCsl
							aISSFat[nW,6] 	:= nISSFat - nTotISS
							aBaseIr[nW,6] 	:= nBaseIrpf - nTotIRF
							aIrfFat[nW,6] 	:= nTotIRPJ - nTtIRFat
							aBaseIns[nW,6]	:= nBaseFat - nTotBIns
							aInsFat[nW,6] 	:= nInsFat - nTotIns
						EndIf
					Next

					cCodAprov := ""
					
					If lCtrlAlc
						cCodAprov := FA050Aprov(nMoeda)
					EndIf

					If lPccBaixa
						If SE2->E2_DIRF=="1"
							lDirf := .T.
						Else 
							cTitpai := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)

							BeginSQL Alias "TMPSE2X"
					
								SELECT E2.E2_DIRF 
								FROM %Table:SE2% E2
								WHERE E2.E2_FILIAL = %xfilial:SE2% AND 
								E2.E2_DIRF  = %exp:"1"% AND
								E2.E2_TITPAI = %exp:cTitpai% AND
								E2.%NotDel%

							EndSQL
							
							// Verifica se existem titulos de impostos com Dirf, caso n„o exista n„o grava o E2_CODRET
							If TMPSE2X->(! Eof())
								lDirf:=.T. 			
							EndIf  

							TMPSE2X->(dbCloseArea())

						EndIf

					EndIf 

					For nW := 1 To Len(aCols)
						If !aCols[nW,Len(aCols[1])]  // .F. == Ativo  .T. == Deletado
							
							nProp    := aCols[nW,6] / nValor  

							cPrefix	 := aCols[nW][1]
							cParcela := aCols[nW][3]
							cTipo    := aCols[nW][4]
							cVencmto := aCols[nW][5]
							nValDup	 := aCols[nW][6]
							nValCruz := xMoeda(aCols[nW,6],nMoeda,1,dDataBase)
							cBanco	 := aCols[nW][7]

							//////////////////////////////////
							// Grava informacoes contabeis  //
							// obs: a conta partida credito //
							// esta contida no fornecedor   //
							//////////////////////////////////
							cContaDB := SE2->E2_CONTAD

							While nI <= Len(aE2CCC)

								If nI <> Len(aE2CCC)
								
									If aE2CCC[nI] <> aE2CCC[nI+1] 
										cCCC := ''
										Exit
									Else
										cCCC := SE2->E2_CCC
									EndIf
								
								EndIf

								nI++

							EndDo	

							nI := 1

							While nI <= Len(aE2CCD)
								
								If nI <> Len(aE2CCD)
								
									If aE2CCD[nI] <> aE2CCD[nI+1] 
										cCCD := ''
										Exit
									Else
										cCCD := SE2->E2_CCD
									EndIf
							
								EndIf
								
								nI++

							EndDo

							nI := 1

							While nI <= Len(aCCUSTO)
								
								If nI <> Len(aCCUSTO)
									If aCCUSTO[nI] <> aCCUSTO[nI+1] 
										cCCUSTO	 := ''
										Exit
									Else
										cCCUSTO	 := SE2->E2_CCUSTO
									EndIf
								EndIf
								
								nI++

							EndDo						

							cItemC	 := SE2->E2_ITEMC
							cItemD	 := SE2->E2_ITEMD
							cClVlCR	 := SE2->E2_CLVLCR
							cClVlDB	 := SE2->E2_CLVLDB

							// Acha conta corrente do fornernecedor
							_cQryFil := ""
							_cTpFil	 := ""

							_cQryFil := "SELECT *"
							_cQryFil += " FROM " + retSQLName("FIL") + " FIL"
							_cQryFil += " WHERE FIL.FIL_FORNEC	=	'" + IIF(mv_par01 == 1,cForn,cFornP)+ "'"
							_cQryFil += "	AND	FIL.FIL_LOJA	=	'" + IIF(mv_par01 == 1,cLoja,cLojaP)+ "'"
							_cQryFil += "	AND	FIL.FIL_FILIAL	=	'" + xFilial("FIL") + "'"
							_cQryFil += "	AND	FIL.FIL_TIPO	=	'1' "
							_cQryFil += "	AND	FIL.D_E_L_E_T_	<>	'*' "

							TcQuery _cQryFil New Alias "QRYFIL"

							If !QRYFIL->(EOF())
								
								If 		QRYFIL->FIL_TIPCTA == '1' // 1=Conta Corrente;2=Conta Poupanca;
										_cTpFil := '01' // 01 - Conta Corrente
								ElseIf 	QRYFIL->FIL_TIPCTA == '2'
										_cTpFil := '11' // 11 - Conta Poupanca
								EndIf

								cFORBCO := QRYFIL->FIL_BANCO 
								cFORCTA := QRYFIL->FIL_CONTA
								cFCTADV := QRYFIL->FIL_DVCTA
								cFORAGE := QRYFIL->FIL_AGENCI
								cFAGEDV := QRYFIL->FIL_DVAGE

							EndIf

							QRYFIL->(DBCloseArea())


							// Implantacao da Fatura - INCLUSAO quando tem VALOR FATURA conf Parcelas
							cFilAnt := cFilSE2
							RecLock(cAliasGRV,.T.)
							Replace E2_FILIAL 	With  cFilSE2
							Replace E2_NUM 		With  cFatura
							Replace E2_PARCELA	With  cParcela
							Replace E2_PREFIXO	With  cPrefix
							Replace E2_NATUREZ	With  cNat
							Replace E2_VENCTO 	With  cVencmto
							Replace E2_VENCREA	With  DataValida(E2_VENCTO,.T.)
							Replace E2_VENCORI	With  SE2->E2_VENCTO					
							Replace E2_EMISSAO	With  dDatabase
							Replace E2_EMIS1	With  dDatabase
							Replace E2_HIST		With  cHistFat
							Replace E2_TIPO		With  cTipo
							Replace E2_FORNECE	With  IIF(mv_par01 == 1,cForn,cFornP)
							Replace E2_LOJA		With  IIF(mv_par01 == 1,cLoja,cLojaP)
							Replace E2_VALOR	With  nValDup
							Replace E2_SALDO	With  nValDup
							Replace E2_MOEDA	With  nMoeda
							Replace E2_PORTADO	With  cBanco
							Replace E2_FATURA 	With  "NOTFAT"
							Replace E2_NOMFOR 	With  SA2->A2_NREDUZ
							Replace E2_VLCRUZ	With  xMoeda(nValDup,nMoeda,1,dDataBase)
							Replace E2_MULTNAT	With	"2"	   

							// 06/12/2018 - CONFORME EMAIL MAURICIO/ERIC
							// Se os tÌtulos marcados tem a mesma conta FORNECEDOR, considerar esta conta, sen„o considerar a conta do FIL
							If Len(aTitCtaFor) == 1
								Replace E2_FORBCO   With aTitCtaFor[1][1]
								Replace E2_FCTADV   With aTitCtaFor[1][2]
								Replace E2_FORCTA   With aTitCtaFor[1][3]
								Replace E2_FAGEDV   With aTitCtaFor[1][4]
								Replace E2_FORAGE   With aTitCtaFor[1][5]
							Else
								Replace E2_FORBCO   With cFORBCO 
								Replace E2_FCTADV   With cFCTADV
								Replace E2_FORCTA   With cFORCTA
								Replace E2_FAGEDV   With cFAGEDV
								Replace E2_FORAGE   With cFORAGE
							EndIf

							Replace E2_XFINALI	With _cTpFil
							Replace E2_ZDTNPR	With dMenorDT	   
							Replace E2_XOBS     With cOBSSum   

							// TRATA VALOR DE ACRESCIMO E DECRESCIMO

							/* 
							Paulo Henrique - 23/08/2019 - PRB0040227
							n„o deve ser calculado o valor acrescimo e do descrescimo com o valor proprocional, 
							mas sim, conforme estava no titulo antes da geraÁ„o da fatura
							*/

							//Replace E2_ACRESC    With nAcre1SUM  * nProp
							//Replace E2_SDACRES   With nAcre2SUM  * nProp
							//Replace E2_DECRESC   With nDecre1SUM * nProp
							//Replace E2_SDDECRE   With nDecre2SUM * nProp

							Replace E2_ACRESC    With nAcre1SUM
							Replace E2_SDACRES   With nAcre2SUM
							Replace E2_DECRESC   With nDecre1SUM
							Replace E2_SDDECRE   With nDecre2SUM

							Replace E2_FILORIG  With cFilAnt	
							Replace E2_CODAPRO	With cCodAprov	
							Replace E2_DATAAGE  With DataValida(E2_VENCTO,.T.)							

							// Grade
							Replace E2_ZCODGRD  With 'ZZZZZZZZZZ'   
							Replace E2_ZBLQFLG  With  'S'                   
							Replace E2_DATALIB  With  dDataBase
							Replace E2_ZIDINTE  With  'ZZZZZZZZZ'
							Replace E2_ZIDGRD   With  'ZZZZZZZZZ'
							Replace E2_ZNEXGRD  With  ''

							// Gest„o						
							If !lSE2Compart .And. mv_par06 == 1
								Replace E2_ORIGEM 	With  "FINA290M"
							Else
								Replace E2_ORIGEM 	With  "FINA290"
							EndIf
							
							// Retencao do ISS na baixa
							If SuperGetMV("MV_MRETISS",,"1")=="2" 
								Replace E2_ISS 		With  aISSFat[nW,6]
								Replace E2_FRETISS 	With  nFRetISS
								Replace E2_TRETISS 	With  nTRetISS
							EndIf

							// Gravar campo de base do IRPF
							If lIrpfBaixa .And. lBaseIrpf
								Replace E2_BASEIRF	With aBaseIR[nW,6]
								Replace E2_PRETIRF 	With "1"						
							EndIf

							If lInssBx //Inss Baixa
								Replace E2_BASEINS	With aBaseIns[nW,6]
								Replace E2_PRETINS 	With "1"
								Replace E2_INSS 	With aInsFat[nW,6]												
							EndIf

							// Grava o valor do IRPJ	
							If lIrpfBaixa .And. SA2->A2_TIPO == "J" .And. Len(aIrfFat) > 0
								Replace E2_IRRF 	With aIrfFat[nW,6]
								Replace E2_BASEIRF	With aBaseIR[nW,6]
								Replace E2_PRETIRF 	With "1"
							EndIf

							// Impostos Lei 10925 para tratamento na baixa.
							If 	lPccBaixa .And. ;
								(Len(aPisFat)+Len(aCofFat)+Len(aCslFat)> 0 ) .And. ;
								(nW <= Len(aPisFat) .And. nW <= Len(aCofFat) .And. nW <= Len(aCslFat)) .And. ;
								(aPisFat[nW,6]+aCofFat[nW,6]+aCslFat[nW,6] > 0)

								Replace E2_PIS		With  aPisFat[nW,6]
								Replace E2_COFINS	With  aCofFat[nW,6]
								Replace E2_CSLL		With  aCslFat[nW,6]
								Replace E2_BASEPIS 	With  aBaseFat[nW,6]
								Replace E2_BASECOF 	With  aBaseFat[nW,6]
								Replace E2_BASECSLL	With  aBaseFat[nW,6]
								Replace E2_PRETPIS	With  "1"
								Replace E2_PRETCOF 	With  "1"
								Replace E2_PRETCSL 	With  "1"
							EndIf
											
							// lDirf - necess·ria pois podemos ter PCC na Bx e IR na Emissao, isso faz com que o E2_DIRF=="2" e n„o podemos gerar cod ret quando n„o houver impostos.
							If lPccBaixa .And. lDirf .And. ( SE2->E2_PIS> 0 .Or. SE2->E2_COFINS > 0 .Or. SE2->E2_CSLL > 0 ) 
								Replace E2_CODRET With "5952"						
							EndIf

							// Grava contas e custos do titulo pai
							Replace E2_CONTAD	With  cContaDB
							Replace E2_CCC		With  cCCC
							Replace E2_CCD		With  cCCD
							Replace E2_CCUSTO	With  cCCUSTO
							Replace E2_ITEMC	With  cItemC
							Replace E2_ITEMD	With  cItemD
							Replace E2_CLVLCR	With  cClVlCR
							Replace E2_CLVLDB	With  cClVlDB	

							// Atualiza Flag de Lancamento contabil
							If lPadrao 
								If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
									aAdd( aFlagCTB, { "E2_LA", "S", "SE2", SE2->( RecNo() ), 0, 0, 0} )
								Else	
									SE2->E2_LA := "S"
								EndIf
							EndIf

							// Documentos 
							IF lFinVDoc

								If Len(aDocsOri) > 0
									SE2->E2_TEMDOCS := "1"
								EndIf

							EndIf                    

							MsUnlock()

							// Rastreamento - Gerados
							If lRastro
								aadd(aRastroDes,{	xFilial("SE2"),;
													cPrefix,;
													cFatura,;
													cPARCELA,;                                                  
													cTIPO,;
													cForn,;
													cLoja,;
													nValDup } )
							EndIf                
							
							// CriaÁ„o dos Tipos de Valores // Carneiro
							For nI := 1 To Len(aTipoValor)
								Reclock("ZDS",.T.)
								ZDS->ZDS_FILIAL := xFilial("SE2")
								ZDS->ZDS_PREFIX := cPrefix
								ZDS->ZDS_NUM    := cFatura
								ZDS->ZDS_PARCEL := cPARCELA
								ZDS->ZDS_TIPO   := cTIPO
								ZDS->ZDS_FORNEC := cForn
								ZDS->ZDS_LOJA   := cLoja
								ZDS->ZDS_COD    := aTipoValor[nI,01]
							    ZDS->ZDS_VALOR  := If(cCond > 1,(aTipoValor[nI,02] / cCond),aTipoValor[nI,02])
								ZDS->(MsUnlock())  
							Next nI

							SE2->(dbGoTo(Recno()))
							// Somo o saldo do vencimento programado do titulo
							AtuSldNat(SE2->E2_NATUREZ, SE2->E2_VENCREA, SE2->E2_MOEDA, "2", "P", SE2->E2_VALOR, SE2->E2_VLCRUZ, "+",,FunName(),"SE2",SE2->(Recno()),nOpcE)
							aArea := GetArea()

							dbSelectArea("SA2")
							SA2->(DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))

							If SA2->(Found())

								SA2->(RecLock("SA2"))
								nMoedaC  := Int(Val(GetMv("MV_MCUSTO")))

								If !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM)
									SA2->A2_SALDUP += Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
									SA2->A2_SALDUPM+= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoedaC,SE2->E2_EMISSAO,3),3),2)
								Else
									SA2->A2_SALDUP -= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
									SA2->A2_SALDUPM-= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,3),3),2)
								EndIf
							
							EndIf
							RestArea(aArea)
							nValTotal += xMoeda(nValDup,nMoeda,1,dDataBase)  // nValCruz

							IF lPadrao

								If nHdlPrv <= 0
									nHdlPrv := HeadProva(cLote,"FINA290",SubStr(cUsuario,7,6),@cArquivo)
								EndIf

								VALOR := 0

								// Contabiliza pela variavel VALOR. Nao necessita de controle de flag.
								nTotal += DetProva( nHdlPrv,;
													cPadrao,;
													"FINA290" /*cPrograma*/,;
													cLote,;
													/*nLinha*/,;
													/*lExecuta*/,;
													/*cCriterio*/,;
													/*lRateio*/,;
													/*cChaveBusca*/,;
													/*aCT5*/,;
													/*lPosiciona*/,;
													@aFlagCTB,;
													/*aTabRecOri*/,;
													/*aDadosProva*/ )
							EndIf

							dbSelectArea("SE2")
							// Grava os lancamentos nas contas orcamentarias SIGAPCO
							PcoDetLan("000015","01","FINA290")

							// Documentos
							IF lFinVDoc
								
								If Len(aDocsOri) > 0
									aAdd(aDocsDes,{	SE2->E2_FILIAL,;
													SE2->E2_PREFIXO,;
													SE2->E2_NUM,;
													SE2->E2_PARCELA,;
													SE2->E2_TIPO,;
													SE2->E2_FORNECE,;
													SE2->E2_LOJA } )
								EndIf

							EndIf

						EndIf

					Next nW

					// Gravacao do rastreamento
					If lRastro
						FINRSTGRV(2,"SE2",aRastroOri,aRastroDes,nValTotal) 
					EndIf

					If Len(aDocsOri) > 0
						CN062GrvFat(aDocsOri,aDocsDes)
					EndIf
				Else
					DisarmTransaction()	
				EndIf

				If nTotal > 0
					dbSelectArea("SE2")
					nRecSe2 := Recno()

					SE2->(DBGoBottom())
					SE2->(dbSkip())

					VALOR := nValTotal

					//Contabiliza pela variavel VALOR. Nao necessita de controle de flag.
					nTotal += DetProva( nHdlPrv,;
										cPadrao,;
										"FINA290" /*cPrograma*/,;
										cLote,;
										/*nLinha*/,;
										/*lExecuta*/,;
										/*cCriterio*/,;
										/*lRateio*/,;
										/*cChaveBusca*/,;
										/*aCT5*/,;
										/*lPosiciona*/,;
										@aFlagCTB,;
										/*aTabRecOri*/,;
										/*aDadosProva*/ )

					RodaProva(nHdlPrv,nTotal)

					// Envia para Lancamento Contabil
					lDigita := IIf( mv_par02 == 1, .T., .F. )
					cA100Incl( 	cArquivo,;
								nHdlPrv,;
								3 /*nOpcx*/,;
								cLote,;
								lDigita,;
								.F.,;
								/*cOnLine*/,;
								/*dData*/,;
								/*dReproc*/,;
								@aFlagCTB,;
								/*aDadosProva*/,;
								/*aDiario*/ )

					aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

					VALOR := 0        
					dbSelectArea("SE2")
					SE2->(DBGoTo(nRecSe2))			
				EndIf

				// Grava no SX6 o numero da ultima fatura gerada.
				If lRet
					GetMv("MV_NUMFATP")
					RecLock( "SX6",.F. )
					SX6->X6_CONTEUD := cFatura
					MsUnlock()
				EndIf
			EndIf
			CursorArrow()
		End Transaction
	Else
		MsUnlockAll()
	EndIf
	
	If Len(aChaveLbn) > 0 
		aEval(aChaveLbn, {|e| UnLockByName(e,.T.,.F.) } ) // Libera Lock
	EndIf
	
	cFatura	 	:= CRIAVAR("E2_FATURA")
	cForn 		:= CriaVar("A2_COD")
	cNat	 	:= Space(10)
	cPrefix  	:= CRIAVAR("E2_PREFIXO",.T.)
	cLoja 	 	:= CriaVar("A2_LOJA")
	dDataDe	 	:= dDatabase
	dDataAte  	:= dDatabase
	nValorFat 	:= 0
	aVlCruz	  	:= {}

	// Recupera a Integridade dos dados
	FreeUsedCode()  // libera codigos de correlativos reservados pela MayIUseCode()

	dbSelectArea("SE2")

	dbSelectArea(cAliasSe2)
	DbCloseArea()

	// Deleta tabela Tempor·ria criada no banco de dados
	If _oFina2901 <> Nil
		_oFina2901:Delete()
		_oFina2901 := Nil
	EndIf

	// Gest„o
	For nX := 1 TO Len(aTmpFil)
		CtbTmpErase(aTmpFil[nX])
	Next

	// Restaura indice original do SE2 que foi selecionado no Browse
	dbSelectArea("SE2")
	SE2->(dbSetOrder(nIndSE2)) 
	SE2->(dbGoto(nRecnoSE2))

	// Finaliza integracao com Modulo PCO
	PcoFinLan("000015")

Return (nOpca == 1)

/*/{Protheus.doc} fa290num
//TODO Verifica se ja' existe numero do titulo.
@author Paulo Boschetti
@since 27/07/1993
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function fa290num(cFatAnt)

	Local aAreaSE2:= SE2->(GetArea())
	Local lRet := .T. 
	Local cFornLoja := IIF(mv_par01 == 1,cForn+cLoja,cFornp+cLojaP)

	If !MayIUseCode( "SE2"+xFilial("SE2")+cPrefix+cFatura+cTipo+cFornLoja)  // verifica se esta na memoria, sendo usado
		// busca o proximo numero disponivel 
		Help(" ",1,"A290EXIST")
		oFatura:SetFocus()
		lFocus := .T.
		lRet := .F.
	Else
		dbSelectArea("SE2")
		dbSetOrder(6)

		If dbSeek(xFilial("SE2")+cFornLoja+cPrefix+cFatura)

			While !Eof() .And. SE2->E2_FILIAL == xFilial("SE2") .And. ;
				cFornLoja+cPrefix+cFatura == SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)

				If 	(SE2->E2_TIPO == cTipo .And. SE2->(E2_FORNECE+E2_LOJA) == cFornLoja)
					Help(" ",1,"A290EXIST")

					// Retorno .T. para que possa focar o campo do numero da
					// fatura para alteraÁ„o e posterior validaÁ„o. 
					// A validaÁ„o neste caso È feita somente no Fornecedor 
					// e ao confirmar a operaÁ„o da fatura.

					oFatura:SetFocus()
					lFocus 	:= .T.
					lRet 	:= .F.
					Exit
				Else
					dbSkip()
				EndIf
			EndDo
		Else
			If cFatura <> cFatAnt
				FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
			EndIf	
			If	!MayIUseCode( "SE2"+xFilial("SE2")+cPrefix+cFatura+cTipo+cFornLoja )
				oFatura:SetFocus()
				lFocus := .T.
				lRet := .F.
			EndIf	
		EndIf
	EndIf
	RestArea(aAreaSe2)

Return lRet

/*/{Protheus.doc} FA290For
//TODO Verifica validade do Fornecedor
@author Paulo Boschetti
@since 27/07/1993
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function Fa290For( cFornecedor, cLoja, lVldForBlq ,lTudoOK)
	Local aArea			:= GetArea()
	Local lRet			:= .T.

	Default cLoja		:= ""
	Default lTudoOK		:= .F.
	Default lVldForBlq	:= .F.

	//------------------------------------------------------------------------------------------
	// Validacao de confirmacao de tela e obrigatoriedade do preenchimento do fornecedor e loja
	//------------------------------------------------------------------------------------------
	If lTudoOK .And. Empty(cFornecedor)
		Help("  ",1,"FA290FOR",,"Informe o cÛdigo do fornecedor.",1,0)
		lRet := .F.

		//---------------------------------------------------------------------------
		// Validacao durante preenchimento do campo para evitar dados nao existentes
		//---------------------------------------------------------------------------

	ElseIf !Empty(cFornecedor)

		dbSelectArea("SA2")
		SA2->(DbSetOrder(1))

		If SA2->(DbSeek(xFilial("SA2")+cFornecedor))
			//------------------------------------------------------------------------
			// Avalia se o fornecedor esta bloqueado se informado o fornecedor e loja
			//------------------------------------------------------------------------
			If lVldForBlq .And. SA2->A2_MSBLQL == "1"
				Help(" ",1,"FA290FOR",,"O cÛdigo de fornecedor informado para geraÁ„o est· bloqueado.",1,0) //"O cÛdigo de fornecedor e loja informados para geraÁ„o est·o bloqueados."
				lRet := .F.
			EndIf
		Else
			Help(" ",1,"FA290FOR",,"O cÚdigo de fornecedor informado n„o est· cadastrado no sistema.",1,0) //"O cÛdigo de fornecedor e loja informados n„o est·o cadastrados no sistema."
			lRet := .F.
		EndIf

	EndIf

	RestArea(aArea)

Return (lRet)

/*/{Protheus.doc} GravaDup
//TODO Formata Array com os desdobramentos dos titulos
@author Paulo Boschetti
@since 12/11/1993
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function GravaDup(nDup,cPrefixo,cNumero,nValor,dVencto,aVenc)

	Local nTamParcela	:= TamSx3("E2_PARCELA")[1]  
	Local cParcSE2		:= SuperGetMv("MV_1DUP")
	Local cParcela		:= Space(nTamParcela)
	Local cTmpParcela	:= Space(nTamParcela)
	Local nValorTit		:= NoRound((nValor/nDup))
	Local nValDup		:= nValor
	Local nMaxParc		:= 1
	Local nTamBanco		:= TamSx3("A6_COD")[1]
	Local ni			:= 0

	// Montagem da matriz aHeader
	AADD(aHeader,{ OemToAnsi(STR0032),"E2_PREFIXO"	,"@!"                 ,TamSx3("E2_PREFIXO")[1] ,0,"","ù","C","SE2" } )          //"Prf"
	AADD(aHeader,{ OemToAnsi(STR0033),"E2_NUM"		,"@!"                 ,TamSx3("E2_NUM")[1],0,"","ù","C","SE2" } )     			//"N˙mero"
	AADD(aHeader,{ OemToAnsi(STR0034),"E2_PARCELA"	,PesqPict("SE2","E2_PARCELA"),TamSx3("E2_PARCELA")[1],0,"","ù","C","SE2" } ) 	//"Ord"
	AADD(aHeader,{ OemToAnsi(STR0054),"E2_TIPO"		,"@!"                 ,TamSx3("E2_TIPO")[1],0,"","ù","C","SE2" } )          	//"Tipo"
	AADD(aHeader,{ OemToAnsi(STR0035),"E2_DTFATUR"	,"99/99/99"           ,TamSx3("E2_DTFATUR")[1],0,"","ù","D","SE2" } )          	//"Vencimento"
	AADD(aHeader,{ OemToAnsi(STR0036),"E2_VALOR"	,"@E 9,999,999,999.99",TamSx3("E2_VALOR")[1],TamSx3("E2_VALOR")[2],"Fa290AtuVl()","ù","N","SE2"})//"Valor Duplicata"
	AADD(aHeader,{ OemToAnsi(STR0037),"A6_COD"		,"@!"                 ,TamSx3("A6_COD")[1],0,"","ù","C","SA6" })           //"Banco"

	// Grava aCols com os valores das duplicatas
	PRIVATE aCOLS[nDup][8]	

	// Verifica o tamnho da parcela
	If nDup > 1
		
		// Verifica a validade do parametro
		If Len(GetMV("mv_1dup")) >= 1
			cTmpParcela := Substr(GetMV("mv_1dup"),Len(GetMV("mv_1dup"))+1-nTamParcela,nTamParcela)
		Else
			IW_MSGBOX(STR0064 + Str(nMaxParc,2) + CHR(13)+ ;  //"N˙mero m·ximo de parcelas permitido "
			STR0065 + Str(nDup,4) + CHR(13)+; //"N˙mero de parcelas da condiÁ„o de pagto. "
			STR0066, STR0067,"STOP") //"Verifique par‚metro MV_1DUP."###"AtenÁ„o"		
			Return {}
		EndIf

		// Se parcela tiver apenas um digito, ou o parametro tiver apenas um digito, verifica a quantidade maxima de parcelas
		If nTamParcela == 1 .Or. Len(AllTrim(GetMV("mv_1dup"))) == 1
		
			// Verifica a quantidade maxima de parcelas
			cParcela := cTmpParcela
			For ni := 1 To 63
				cParcela:=Soma1( cParcela,, .T. )
				If AllTrim(cParcela) == "*"
					Exit
				EndIf
				nMaxParc++
			Next
		
			If nDup > nMaxParc
				IW_MSGBOX(STR0064 + Str(nMaxParc,2) + CHR(13)+ ;  //"N˙mero m·ximo de parcelas permitido "
				STR0065 + Str(nDup,4) + CHR(13)+; //"N˙mero de parcelas da condiÁ„o de pagto. "
				STR0066, STR0067,"STOP") //"Verifique par‚metro MV_1DUP."###"AtenÁ„o"
				Return {}
			EndIf
		
		EndIf
	
	EndIf

	dMaiorVenc := dDataBase
	dbSelectArea( cAliasSE2 )
	dbGotop()

	While !(cAliasSE2)->(Eof())
	
		If (cAliasSE2)->E2_OK == cMarca
			IF (cAliasSe2)->E2_VENCREA > dMaiorVenc
				dMaiorVenc := (cAliasSe2)->E2_VENCREA
			EndIf
		EndIf
	
		(cAliasSE2)->(dbskip())
	EndDo

	For ni := 1 To nDup
		cParcSE2 := Right("000"+cParcSE2,nTamParcela)
		nValorTit	:= nValorTit//   aVenc[ni][2]
		cParcela	:= cTmpParcela	
		aCols[ni,1]	:= cPrefixo
		aCols[ni,2]	:= cNumero
		aCols[ni,3]	:= cParcSE2
		aCols[ni,4]	:= cTipo
		aCols[ni,5]	:= dMaiorVenc //aVenc[ni,1]
		aCols[ni,6]	:= IIf(ni<nDup,nValorTit,nValDup)
		aCols[ni,7] := Space(nTamBanco)

		aCols[ni,8]	:= .F.	                       

		cParcSE2 := Soma1(cParcSE2,nTamParcela,.F.)

		nValDup -= nValortit

	NEXT ni

Return(aCols)

/*/{Protheus.doc} MGFFINCHK
//TODO Selecao para a criacao do indice condicional
@author Valter G. Nogueira Jr.
@since 14/03/1994
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFFINCHK(aSelFil,aTmpFil,cTmpSE2Fil,aStru,lUsaQry)

	Local cFiltro 		:= ""		
	Local nValmin 		:= 0
	LOcal lVerLibTit	:= .T.
	Local lPrjCni 		:= ValidaCNI()
	Local nCt			:= 0     
	Local cQuery		:= ""
	Local cFil290 		:= ""
	Local cTipoNFat		:= SuperGetMV("MGF_TPNFAT",,"PRE|PR !NDF")

	DEFAULT aSelFil		:= {}
	DEFAULT aTmpFil		:= {}
	DEFAULT cTmpSE2Fil	:= ""
	DEFAULT aStru		:= {}
	DEFAULT lUsaQry		:= .T.

	If lUsaQry

		For nCt= 1 To Len(aStru)                 
			If aStru[nCt,2] <> "M         "
				cQuery+= ","+Alltrim(aStru[nCt,1])
			EndIf
		Next nCt

		cFiltro := "SELECT " 
		cFiltro += SubStr(cQuery,2)
		cFiltro += If(!Empty(cQuery),",","") + " SE2.R_E_C_N_O_ RECNO "
		cFiltro	+= "FROM "+RetSqlName("SE2")+ " SE2 "
		cFiltro	+= "WHERE "                                                                       
		cFiltro 	+= "SUBSTR(E2_FILIAL,1,2)='"	+ SubSTR(xFilial("SE2"),1,2) + "'"

		If Len(aSelFil) > 0
			cFiltro += " AND E2_FILIAL " + GetRngFil( aSelFil, "SE2", .T., @cTmpSE2Fil ) 
			aAdd(aTmpFil, cTmpSE2Fil)
		EndIf         

		cFiltro	+= " AND E2_FORNECE ='"	+ cForn + "'"

		cFiltro	+= " AND E2_VENCREA >='"+DTOS(dDataDe) + "'"
		cFiltro += " AND E2_VENCREA <='"+DTOS(dDataAte)+ "'"

		cFiltro	+= " AND E2_EMISSAO >='"+DTOS(dDataE1) + "'"
		cFiltro += " AND E2_EMISSAO <='"+DTOS(dDataE2)+ "'"

		cFiltro	+= " AND E2_MOEDA = "  + Str(nMoeda,2,0)
		cFiltro	+= " AND E2_FATURA ='" + Space(Len(SE2->E2_FATURA)) + "'"
		cFiltro += " AND E2_NUMBOR ='" + Space( Len(SE2->E2_NUMBOR) )  + "'"
		cFiltro	+= " AND E2_TIPO NOT IN "+FormatIN(MVPAGANT+MVPROVIS,,3)

		/*
		Os abatimentos n„o devem aparecer na seleÁ„o de tÌtulos,
		eles seram baixados de forma automùtica caso o tÌtulo seja selecionado
		*/

		cFiltro	+= " AND E2_TIPO NOT IN "+FormatIn(MVABATIM,"|")
		cFiltro	+= " AND E2_SALDO > 0"

		// Barbieri 07/05/2018 - Criado parametro MGF_TPNFAT para n„o levar E2_TIPO definidos na Fatura
		cFiltro += " AND E2_TIPO NOT IN "+FormatIn(cTipoNFat,"|")

		// AAF - Titulos originados no SIGAEFF n„o devem ser alterados   
		cFiltro += " AND E2_ORIGEM <> 'SIGAEFF ' "
		cFiltro += " AND E2_ORIGEM <> 'FINA667 ' "
		cFiltro += " AND E2_ORIGEM <> 'FINA677 ' "

		//Titulos com DARF gerado n„o devem ser incluidos em Fatura
		cFiltro += " AND E2_IDDARF = '" + Space(Len(SE2->E2_IDDARF)) + "' "  

		If lVerLibTit
			If GetMv("MV_CTLIPAG")
				cFiltro += " AND (E2_DATALIB <> ' '"
				cFiltro += " OR (E2_SALDO+E2_SDACRES-E2_SDDECRE<="+ALLTRIM(STR(GetMv('MV_VLMINPG'),17,2))+"))"
			EndIf
		EndIf	

		If lPrjCni
			cFiltro += " AND E2_NUMSOL = '"+ Space( Len(SE2->E2_NUMSOL ) ) + "' "
		EndIf

		// n„o seleciona titulos com baixas parciais - Paulo Henrique - TOTVS - 01/10/2019
		cFiltro	+= " AND E2_VALLIQ = 0 "

		//-----------------------------------------------------
		// Complemento de filtro - SIAFI
		//-----------------------------------------------------
		cFiltro += FinTemDH(.T. /*lFiltro*/,/*cAlias*/,.F. /*lHelp*/, .T./*lTop*/)
		cFiltro	+= " AND D_E_L_E_T_ = ' ' "

		cFiltro	+= " AND Exists ( Select *                                                                                    "
		cFiltro	+= "              from "+RetSqlName("SED")+" A    "
		cFiltro	+= "              Where A.D_E_L_E_T_ = ' '                                                                    "
		cFiltro	+= "                AND A.ED_FILIAL  = '      '                                                               "
		cFiltro	+= "                AND A.ED_CODIGO = E2_NATUREZ                                                              "
		cFiltro	+= "                AND ED_CALCIRF   || ED_CALCISS   || ED_PERCIRF   || ED_CALCINS   || ED_PERCINS   ||       "
		cFiltro	+= "        ED_CALCCSL   || ED_CALCCOF   || ED_CALCPIS   || ED_PERCCSL   || ED_PERCCOF   ||                   "
		cFiltro	+= "        ED_PERCPIS   || ED_CREDIT = ( Select ED_CALCIRF   || ED_CALCISS   || ED_PERCIRF   || ED_CALCINS   || ED_PERCINS   ||                   "
		cFiltro	+= "        									 ED_CALCCSL   || ED_CALCCOF   || ED_CALCPIS   || ED_PERCCSL   || ED_PERCCOF   ||                   "
		cFiltro	+= "        									 ED_PERCPIS   || ED_CREDIT                                                                         "
		cFiltro	+= " 									  from "+RetSqlName("SED")+" B                                                                                            "
		cFiltro	+= " 									  Where B.D_E_L_E_T_ = ' '                                                                                 "
		cFiltro	+= "   										AND B.ED_FILIAL  = '      '                                                                            "
		cFiltro	+= "   										AND B.ED_CODIGO = '"+cNat+"'  ))                                                                          "
		cFiltro += " ORDER BY E2_FILIAL,E2_FORNECE,E2_LOJA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO DESC "

	Else

		cFiltro += 'E2_FILIAL=="'+xFilial("SE2") + '"'
		cFiltro += '.And.E2_SALDO>0'
		cFiltro += '.And.E2_FORNECE=="' + cForn + '"'
		cFiltro += '.And.DTOS(E2_VENCTO)>="' + DTOS( dDataDe ) + '"'
		cFiltro += '.And.DTOS(E2_VENCTO)<="' + DTOS( dDataAte ) + '"'

		If lVerLibTit
			// controla Liberacao do titulo
			If GetMv("MV_CTLIPAG") 
				nValmin:= GetMV("MV_VLMINPG")	
				cFiltro += ".And. (!(DTOS(SE2->E2_DATALIB) = '        ').Or. (DTOS(SE2->E2_DATALIB) = '        '.And.(E2_SALDO+E2_SDACRES-E2_SDDECRE)< " + str(nValmin)+ "))"
			EndIf
		EndIf         

		// AAF - Titulos originados no SIGAEFF n„o devem ser alterados
		cFiltro += ".And. !('SIGAEFF' $ E2_ORIGEM) "
		cFiltro += ".And. !('FINA667' $ E2_ORIGEM) " 
		cFiltro += ".And. !('FINA677' $ E2_ORIGEM) "
		cFiltro += '.And.E2_MOEDA=' + AllTrim(Str( nMoeda,2 ))
		cFiltro += '.And.E2_FATURA=="' + Space( Len(SE2->E2_FATURA ) ) + '"'   

		if lPrjCni
			cFiltro += "  .And. E2_NUMSOL=='"+ Space( Len(SE2->E2_NUMSOL ) ) + "'  "
		EndIf

		cFiltro += '.And.E2_NUMBOR=="' + Space( Len(SE2->E2_NUMBOR ) ) + '"'
		cFiltro += '.And.!(E2_TIPO $"'+MVPAGANT+"/"+MVPROVIS+'")'
		cFiltro += '.And.!(E2_TIPO $"'+MVABATIM+'")'

		If !Empty(cFil290)
			cFiltro := '(' + cFiltro + ') .And. (' + cFil290 + ')'
		EndIf

	EndIf

Return cFiltro

/*/{Protheus.doc} MGFINCAN
//TODO Marcacao dos titulos para o de fatura
@author Cesar C S Prado
@since 03/05/1994
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function MGFINCan(cAlias,cCampo,nOpcE,aFatPag)
	// Define Variaveis
	Local lPanelFin 	:= IsPanelFin()
	Local cArquivo
	Local nTotal		:= 0
	Local nHdlPrv		:= 0
	Local lPadrao
	Local cPadrao		:= "593"
	Local oDlg
	Local nOpca			:= 0
	Local nValor		:= 0
	Local l290CalCn		:= .F.
	Local cChaveSE2		:= ""
	Local nValTotal 	:= 0
	Local dBaixa 		:= CTOD(Space(08))
	Local lRet   		:= .T.
	Local lContab531 	:= VerPadrao("531") .And. ( mv_par04 == 1 )
	Local lFatAut		:= .F.
	Local aFatCan		:= {}
	Local lDocFat		:= .F.
	Local aAreaSe2		:= {}      
	Local nAbat			:=	0
	Local nVazio		:= ""

	// Controle de Rastreamento Financeiro
	Local lRastro		:= FVerRstFin()

	// Controle de Contabilizacao
	Local aFlagCTB		:= {}
	Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Local lFinVDoc		:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios
	Local nMoedaC 	 	:= 1
	Local aArea 		:= {}

	// Gest„o
	Local cFatIni		:= SE2->E2_NUM  
	Local lGestao   	:= .T.
	Local lSE2Compart	:= Iif( lGestao, FWModeAccess("SE2",1) == "C", FWModeAccess("SE2",3) == "C")
	Local cAliasQry 	:= cAlias
	Local cOrigem		:= Alltrim(SE2->E2_ORIGEM)    
	Local lRmClass		:= GetNewPar("MV_RMCLASS",.F.)
	Local nX			:= 0
	Local cFilOrig		:= cFilAnt
	Local aTitPai		:= {}
	Local nI			:= 0
	Local lExistFJU		:= FJU->(ColumnPos("FJU_RECPAI")) >0
	Local lBxParcFat	:= .F.
	Local nValTit		:= 0

	// REESTRUTURACAO SE5
	Local aAreaAnt		:= {}
	Local oModelBxP		:= nil
	Local cLog			:= ""
	Local oFKA

	// P03C - Paulo Henrique - 11/10/2019
	Local xg            := 0
	Local aIdOrig       := {}
	Local cFilBsc       := ""
	
	Private oTitulos,oValorCan
	Private cIndex		:= ""
	Private cFilCan     := CriaVar("E2_FILIAL"    , .F.)
	Private cFatCan		:= CriaVar("E2_NUM"    , .F.)
	Private cPrefCan	:= CriaVar("E2_PREFIXO", .F.)
	Private cTipoCan	:= CriaVar("E2_TIPOFAT")
	Private cFornCan	:= CriaVar("E2_FORNECE", .F.)
	Private cLojaCan	:= CriaVar("E2_LOJA"   , .F.)
	Private cLote

	// GDN - USO NA fa340desc()
	PRIVATE nTamTit     := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]
	PRIVATE nTamTip     := TamSX3("E2_TIPO")[1]
	Private lCalcIssBx  := IIF(lIsIssBx, IsIssBx("P"), SuperGetMv("MV_MRETISS",.F.,"1") == "2" )
	Private lPartPA     := .F.
	PRIVATE aTxMoedas   := {}        
	Private _cAlias 	:= GetNextAlias()

	Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1"),1})

	For nA := 2	To MoedFin()
		
		cMoedaTx :=	Str(nA,IIf(nA <= 9,1,2))
		
		If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
			nVlMoeda := RecMoeda(dDataBase,nA)
			Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),nVlMoeda,PesqPict("SM2","M2_MOEDA"+cMoedaTx),nVlMoeda })
		Else
			Exit
		EndIf

	Next

	DEFAULT aFatPag	:= {}

	// ProteÁ„o tabela FJU
	If FindFunction("FinGrvEx")
		If AliasIndic("FJU")
			If (FieldPos("FJU->FJU_RECPAI")) > 0
				lExistFJU:= .T.
			Else
				lExistFJU:= .F.
			EndIf
		EndIf
	EndIf

	// Verifica se data do movimento n„o È menor que data limite de movimentacao no financeiro
	If !DtMovFin(,,"1")
		Return .F.
	EndIf	

	// Verifica se se o processo ser· contabilizado
	lPadrao := VerPadrao(cPadrao) .And. mv_par04 == 1

	// Verifica o numero do Lote
	LoteCont( "FIN" )

	// Verifica se o cancelamento da fatura foi feito via rotina semi-automatica
	// Necess·rio que o SE2 esteja posicionado em um dos titulos gerados 
	If !Empty(aFatPag)
		lFatAut := .T.
	EndIf
	
	// ACIONA A FUNCAO PERGUNTE
	Pergunte("AFI290",.F.)
	SetF12()

	dbSelectArea("SE2")
	cFornCan 	:= SE2->E2_FORNECE
	cLojaCan 	:= SE2->E2_LOJA
	cFatCan	    := SE2->E2_NUM
	cPrefCan 	:= SE2->E2_PREFIXO
	cTipoCan	:= SE2->E2_TIPO
	cFilCan     := SE2->E2_FILIAL

	nValor		:= 0
	nTitulos 	:= 0
	nFaturas 	:= 0
    
    // P01 - FunÁ„o que cria o indice temporario para o cancelamento da fatura
	FA290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.F.,lSE2Compart,@cAliasQry,cOrigem,@lBxParcFat)

	If lFatAut
		nOpca := 1
	Else
		aSize := MSADVSIZE()
		If lPanelFin //Chamado pelo Painel Financeiro				
			dbSelectArea(cAlias)
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							

			// Observacao Importante quanto as coordenadas calculadas abaixo:
			// --------------------------------------------------------------
			// a funcao DlgWidthPanel() retorna o dobro do valor da area do
			// painel, sendo assim este deve ser dividido por 2 antes da sub-
			// tracao e redivisao por 2 para a centralizacao.
			nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 116) /2		 					
			nEspLin  := 0

		Else   
			nEspLarg := 0 
			nEspLin  := 0
			DEFINE MSDIALOG oDlg FROM	15,6 TO 243,345 TITLE OemToAnsi(STR0038) PIXEL // "Cancelamento de Fatura a Pagar"
		EndIf

		oDlg:lMaximized := .F.
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT    		

		@ 39+nEspLin, 11+nEspLarg TO 068+nEspLin, 127+nEspLarg OF oPanel	PIXEL
		@ 72+nEspLin, 11+nEspLarg TO 104+nEspLin, 127+nEspLarg OF oPanel	PIXEL
		@ 07+nEspLin, 11+nEspLarg TO 036+nEspLin, 127+nEspLarg OF oPanel	PIXEL

		@ 22+nEspLin, 14+nEspLarg MSGET cFornCan Valid Fa290For(cFornCan)	SIZE 70, 08 OF oPanel PIXEL
		@ 22+nEspLin, 87+nEspLarg MSGET cLojaCan Valid Fa290For(cFornCan,cLojaCan)	SIZE 20, 08 OF oPanel PIXEL
		@ 54+nEspLin, 14+nEspLarg MSGET cPrefCan 								SIZE 21, 08 OF oPanel PIXEL

		@ 54+nEspLin, 40+nEspLarg MSGET cTipoCan		F3 "05";
		Picture "@!" 		 ;
		SIZE 12, 08 OF oPanel PIXEL hasbutton ;
		Valid If(nOpca<>0,!Empty (cTipoCan) .And. FA290Tipo(cTipoCan),.T.)

		@ 54+nEspLin, 75+nEspLarg MSGET cFatCan Valid If(nOpca<>0,!Empty(cFatCan) .And. ;
		FA290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.T.,lSE2Compart,@cAliasQry,cOrigem,@lBxParcFat),.T.);
		SIZE 49, 08 OF oPanel PIXEL

		@ 88+nEspLin, 14+nEspLarg MSGET nTitulos		When .F. SIZE 28, 08 OF oPanel PIXEL
		@ 88+nEspLin, 53+nEspLarg MSGET nValor		Picture "@E 999,999,999.99" When .F. SIZE 71, 08 OF oPanel PIXEL
		@ 12+nEspLin, 14+nEspLarg SAY OemToAnsi(STR0039) SIZE 70, 7 OF oPanel PIXEL //"Fornecedor"
		@ 12+nEspLin, 87+nEspLarg SAY OemToAnsi(STR0040) SIZE 20, 7 OF oPanel PIXEL //"Loja"
		@ 44+nEspLin, 14+nEspLarg SAY OemToAnsi(STR0041) SIZE 21, 7 OF oPanel PIXEL //"Prefixo"
		@ 44+nEspLin, 43+nEspLarg SAY OemToAnsi(STR0054) SIZE 12, 7 OF oPanel PIXEL //"Tipo"
		@ 44+nEspLin, 74+nEspLarg SAY OemToAnsi(STR0042) SIZE 49, 7 OF oPanel PIXEL //"N˙mero tÌtulo"
		@ 78+nEspLin, 14+nEspLarg SAY OemToAnsi(STR0043) SIZE 35, 7 OF oPanel PIXEL //"Total Notas"
		@ 78+nEspLin, 53+nEspLarg SAY OemToAnsi(STR0044) SIZE 53, 7 OF oPanel PIXEL //"Valor da Fatura"

		If lPanelFin  //Chamado pelo Painel Financeiro			
			oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
			{||nOpca:=1,IF(IF(l290CalCn,.T.,FA290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.T.,lSE2Compart,@cAliasQry,cOrigem,@lBxParcFat)),oDlg:End(),nOpca:=0)},;
			{||oDlg:End()})

			FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)

		Else	
			DEFINE SBUTTON FROM 10, 133 TYPE 1 ACTION (nOpca:=1,;
			IF(IF(l290CalCn,.T.,;
			FA290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.T.,lSE2Compart,@cAliasQry,cOrigem,@lBxParcFat)),;
			oDlg:End(),nOpca:=0)) ENABLE OF oDlg

			DEFINE SBUTTON FROM 23, 133 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
			ACTIVATE MSDIALOG oDlg CENTERED

		EndIf
	EndIf

	If nOpcA == 1
		//Posicionando na fatura... 
		aAreaSe2		:= SE2->(GetArea())
		nAbat			:=	0

		If SE2->(MsSeek(cFilCan+cPrefCan+cFatCan))

			// Encontrando a fatura.... e guardando o campo PARCELA...
			While !EoF() .And. (SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM) == cFilCan+cPrefCan+cFatCan) 

				If SE2->(E2_TIPO+E2_FORNECE+E2_LOJA) == (cTipoCan+cFornCan+cLojaCan)				
					//Verificando se a Fatura tem algum abatimento...				
					nAbat := SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_MOEDA,"V",SE2->E2_BAIXA,SE2->E2_LOJA)
					Exit  			
				EndIf

				SE2->(dbSkip())
			EndDo                                                

		EndIf

		SE2->(RestArea(aAreaSe2))	

		// Verifica se h· documentos vinculados a fatura e os apaga na tabela FRD
		If lFinVDoc
			aFatCan := {}
			dbSelectArea("SE2")
			dbSetOrder(1)
			
			If MsSeek(cFilCan+cPrefCan+cFatCan)
				If SE2->E2_TEMDOCS == "1"
					lDocFat := .T.
					
					While !EoF() .And. (SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM) == cFilCan+cPrefCan+cFatCan) .And. (SE2->(E2_TIPO+E2_FORNECE+E2_LOJA) == cTipoCan+cFornCan+cLojaCan)
						AADD(aFatCan,{SE2->E2_FILIAL,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA})
						SE2->(dbSkip())
					EndDo

				EndIf
			EndIf
		EndIf

		If lRet 
			dbSelectArea("SE2")
			If nAbat > 0
				MsgAlert(STR0048,STR0073)	//'Esta fatura possui um abatimento. Favor exclui-lo antes de cancelar a fatura.'		
			EndIf		

			// GDN - TRATAR ESTORNO NDF
			Pergunte("AFI340",.F.)    

			If FA290CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l290CalCn,.T.,lSE2Compart,@cAliasQry,cOrigem,@lBxParcFat) .And. nAbat == 0
				(cAliasQry)->(dbGoTop())
				nValTotal := 0

				Begin Transaction
					lFirstFA340 := .F.			
					dbSelectArea((cAliasQry))

					While (cAliasQry)->(!Eof()) 

						SE2->(dbGoto((cAliasQry)->RECNO))

						// Gest„o
						cFilOrig := SE2->E2_FILORIG

						If (SE2->E2_FATURA == cFatCan .And. SE2->E2_TIPOFAT == cTipoCan .And.;
							SE2->E2_FORNECE == cFornCan .And. SE2->E2_LOJA == cLojaCan  .Or.;
							SE2->E2_FATFOR == cFornCan .And. SE2->E2_FATLOJ == cLojaCan)
							
							// P03 - Paulo Henrique - 11/10/2019
							cChaveSE2 := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+IIf(mv_par01==1,cFornCan+cLojaCan,E2_FORNECE+E2_LOJA))

							If cFilorig != cFilAnt
							   cFilBsc := cFilorig
							Else
							   cFilBsc := cFilAnt
							EndIf   

							dbSelectArea("SE5")
							dbSetOrder(7)
							If dbSeek(cFilBsc+cChaveSE2)
							    //P03A - Paulo Henrique - 11/10/2019
							    // Tratar aqui, a exclusùo dos acrùdcimos e decrÈscimos
							    // Preenche o vetor, para apagar juros e decrescimos
							    AADD(aIdOrig,{SE5->E5_IDORIG})

								If SE5->E5_MOTBX== "FAT" .And. SE5->E5_RECPAG == "P"
									// Verifica movimentacao de AVP
									FAVPValTit( "SE2", SE5->( RecNo() ) )
									dBaixa		:= SE5->E5_DATA

									// Contabiliza o cancelamento da baixa do titulo, 
									// somente se o tÌtulo foi contabilizado anteriormente.
									If lContab531 .And. SE5->E5_LA == "S "
										If nHdlPrv <= 0
											nHdlPrv:=HeadProva(cLote,"FINA290",Substr(cUsuario,7,6),@cArquivo)
										EndIf
										nTotal+=DetProva(nHdlPrv,"531","FINA290",cLote)
									EndIf

									If AllTrim( SE5->E5_TABORI ) == "FK2"
										oModelBxP := FWLoadModel("FINM020") //Recarrega o Model de baixa para pegar o campo do relacionamento (SE5->E5_IDORIG)
										oModelBxP:SetOperation( 4 ) //AlteraÁ„o
										oModelBxP:Activate()
										oModelBxP:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravaùùo SE5
										oModelBxP:SetValue( "MASTER", "HISTMOV", OemToAnsi( STR0038)) //"Cancelamento de Cheque" 
										//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK2
										//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK2
										//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK2
										oModelBxP:SetValue( "MASTER", "E5_OPERACAO", 3 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK2

										//Posiciona a FKA com base no IDORIG da SE5 posicionada
										oFKA := oModelBxP:GetModel( "FKADETAIL" )
										oFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

										If oModelBxP:VldData()
											oModelBxP:CommitData()
										Else
											lRet := .F.
											cLog := cValToChar(oModelBxP:GetErrorMessage()[MODEL_MSGERR_IDFIELDERR]) + ' - '
											cLog += cValToChar(oModelBxP:GetErrorMessage()[MODEL_MSGERR_ID]) + ' - '
											cLog += cValToChar(oModelBxP:GetErrorMessage()[MODEL_MSGERR_MESSAGE])        	
											Help( ,,"M020VALID",,cLog, 1, 0 )
										EndIf

										If Valtype(oModelBxP) = "O"
											oModelBxP:DeActivate()
											oModelBxP:Destroy()
											oModelBxP:= nil
										EndIf

									EndIf									

								EndIf

								// P05 - Paulo Henrique - 11/10/2019
								While !Eof() .And. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == cChaveSE2

									If SE5->E5_MOTBX == "FAT" .And. SE5->E5_RECPAG == "P"

										If lBxParcFat .And. Empty(SE2->E2_VALLIQ)
											nValTit := SE5->E5_VALOR
										EndIf

										RecLock("SE5")
										dbDelete()
										MsUnlock()
									EndIf

									SE5->(dbSkip())

								EndDo	

							EndIf

							// GDN - TRATAR ESTORNO NDF 

							If !lFirstFA340  
								dbSelectArea("SE2")
								DbSetOrder(1) 

								/* 
								Paulo Henrique - 29/08/2019 - Alt. VH01 
								SÛ faÁo o estorno, somente se for NDF
								*/

								If AllTrim(SE2->E2_TIPO) == "NDF"	
								   cFat	:= alltrim(SE2->E2_FATURA) 
								   cTip	:= "NDF" 

								   FA340Desc("SE2",SE2->(Recno()),5,.T.)
								   lFirstFA340 := .T.
								EndIf

							Else  

								FA340Desc("SE2",SE2->(Recno()),5,.T.)
								lFirstFA340:=.T. 

							EndIf

							// Se for um titulo que gerou a fatura, desfaz o processo
							// Volto o saldo da natureza
							AtuSldNat(SE2->E2_NATUREZ, SE2->E2_VENCREA, SE2->E2_MOEDA, "2", "P", SE2->E2_VALLIQ, xMoeda(SE2->E2_VALLIQ, SE2->E2_MOEDA, 1),If(SE2->E2_TIPO$MVABATIM,"-","+"),,FunName(),"SE2",SE2->(Recno()),nOpcE)

							If lAbatiment .And. !SE2->E2_TIPO $ MV_CPNEG +"/"+ MVABATIM
								nTotAbat := SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_MOEDA,"V",SE2->E2_BAIXA,SE2->E2_LOJA)
							Else
								nTotAbat := 0	
							EndIf						

                            /*
							Paulo Henrique - 29/08/2019 - Alt. VH02
							Limpando os campos do titulo da fatura 
							Preenchendo o campo E2_SALDO com o valor do E2_VALOR
							*/
							dbSelectArea("SE2")
							RecLock("SE2")
							SE2->E2_SALDO	+= SE2->E2_VALOR
							SE2->E2_MOVIMEN	:= dDataBase
							SE2->E2_FATURA	:= " "
							SE2->E2_FATPREF	:= " "
							SE2->E2_TIPOFAT	:= " "
							SE2->E2_FATFOR	:= " "
							SE2->E2_FATLOJ	:= " "
							SE2->E2_DTFATUR	:= CtoD(Space(08))
							SE2->E2_JUROS	:= 0
							SE2->E2_DESCONT	:= 0
							SE2->E2_VALLIQ	:= 0
							SE2->E2_CORREC 	:= 0                    

							If SE2->E2_SALDO == SE2->E2_VALOR
								SE2->E2_BAIXA	:= CtoD(Space(08))
								SE2->E2_SDDECRE := SE2->E2_DECRESC
								SE2->E2_SDACRES := SE2->E2_ACRESC

								dbSelectArea("SE2")  
								DbSetOrder(1)
								RecLock("SE2",.F.)
								SE2->E2_SALDO := SE2->E2_VALOR  
								SE2->(MsUnlock())

							Else 
								
								SE2->E2_SDACRES := IIF(SE2->E2_SDACRES<>0, Round(NoRound(xMoeda(SE2->E2_ACRESC,1,SE2->E2_MOEDA,dBaixa,3),3),2), SE2->E2_SDACRES)
								SE2->E2_SDDECRE := IIF(SE2->E2_SDDECRE<>0, Round(NoRound(xMoeda(SE2->E2_DECRESC,1,SE2->E2_MOEDA,dBaixa,3),3),2), SE2->E2_SDDECRE)
								
								dbSelectArea("SE2")  
								DbSetOrder(1)
								RecLock("SE2",.F.)
								SE2->E2_SALDO := SE2->E2_VALOR
								SE2->(MsUnlock())
							
							EndIf

							SE2->E2_FLAGFAT	:= Space(Len(SE2->E2_FLAGFAT))

							MsUnlock()

							//adiciona no array os titulos pai
							If lExistFJU
								aAdd(aTitPai,{SE2->E2_FILIAL,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->(Recno())})
							EndIf

							aArea := GetArea()
							dbSelectArea("SA2")
							SA2->(MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
							SA2->(RecLock("SA2"))
							nMoedaC := Int(Val(GetMv("MV_MCUSTO")))

							If !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM)
								SA2->A2_SALDUP += Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
								SA2->A2_SALDUPM+= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoedaC,SE2->E2_EMISSAO,3),3),2)
							Else
								SA2->A2_SALDUP -= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
								SA2->A2_SALDUPM-= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,3),3),2)
							EndIf
							RestArea(aArea)

						Else

							nReg := SE2->(RecNo())

							If lPadrao
								If nHdlPrv <= 0
									nHdlPrv:=HeadProva(cLote,"FINA290",Substr(cUsuario,7,6),@cArquivo)
								EndIf
								nTotal+=DetProva(nHdlPrv,cPadrao,"FINA290",cLote)
							EndIf

							dbSelectArea("SE2")
							nReg:=IIf(RecNo() != nReg, dbGoTo(nReg), nReg)
							nValTotal += SE2->E2_VLCRUZ

							aArea := GetArea()
							dbSelectArea("SA2")

							If SA2->(MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
								SA2->(RecLock("SA2"))
								nMoedaC	 := Int(Val(GetMv("MV_MCUSTO")))

								If !(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM)
									SA2->A2_SALDUP -= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
									SA2->A2_SALDUPM-= Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoedaC,SE2->E2_EMISSAO,3),3),2)
								Else
									SA2->A2_SALDUP += Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3),3),2)
									SA2->A2_SALDUPM+= Round(NoRound(xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,3),3),2)
								EndIf

							EndIf
							RestArea(aArea)

							// Volto o saldo da natureza
							AtuSldNat(SE2->E2_NATUREZ, SE2->E2_VENCREA, SE2->E2_MOEDA, "2", "P", SE2->E2_VALOR, SE2->E2_VLCRUZ,If(SE2->E2_TIPO$MVABATIM,"+","-"),,FunName(),"SE2",SE2->(Recno()),nOpcE)
							FINDELFKs(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA, "SE2")

							If lExistFJU
								For ni := 1 to Len(aTitPai)
									FinGrvEx("P",aTitPai[nI][1], aTitPai[nI][2],aTitPai[nI][3],aTitPai[nI][4],aTitPai[nI][5],aTitPai[nI][6],aTitPai[nI][7],aTitPai[nI][8])
								Next ni
							EndIf

							RecLock("SE2",.F.,.T.)
							dbDelete()
							MsUnlock()

						EndIf

						(cAliasQry)->(dbSkip())

						// Cancelamento do rastreamento(FI7/FI8)
						If lRastro
							FINRSTDEL("SE2",cChaveSe2)
						EndIf					

						nValTit := 0

					EndDo

                    // P03B - Paulo Henrique - 11/10/2019
					For xg := 1 to Len(aIdOrig)

						dbSelectArea("SE5")
						dbSetOrder(23)

						If dbSeek(aIdOrig[xg,1])

							If SE5->E5_MOTBX== "FAT" .And. SE5->E5_RECPAG == "P"
								// Verifica movimentacao de AVP
								FAVPValTit( "SE2", SE5->( RecNo() ) )

								// Contabiliza o cancelamento da baixa do titulo, 
								// somente se o tÌtulo foi contabilizado anteriormente.
								If lContab531 .And. SE5->E5_LA == "S "

									If nHdlPrv <= 0
										nHdlPrv := HeadProva(cLote,"FINA290",Substr(cUsuario,7,6),@cArquivo)
									EndIf

									nTotal += DetProva(nHdlPrv,"531","FINA290",cLote)

								EndIf

								If AllTrim( SE5->E5_TABORI ) == "FK2"
									oModelBxP := FWLoadModel("FINM020") //Recarrega o Model de baixa para pegar o campo do relacionamento (SE5->E5_IDORIG)
									oModelBxP:SetOperation( 4 ) //Alteraùùo
									oModelBxP:Activate()
									oModelBxP:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravaùùo SE5
									oModelBxP:SetValue( "MASTER", "HISTMOV", OemToAnsi( STR0038)) //"Cancelamento de Cheque" 
									//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK2
									//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK2
									//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK2
									oModelBxP:SetValue( "MASTER", "E5_OPERACAO", 3 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK2

									//Posiciona a FKA com base no IDORIG da SE5 posicionada
									oFKA := oModelBxP:GetModel( "FKADETAIL" )
									oFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )

									If oModelBxP:VldData()
										oModelBxP:CommitData()
									Else
										lRet := .F.
										cLog := cValToChar(oModelBxP:GetErrorMessage()[MODEL_MSGERR_IDFIELDERR]) + ' - '
										cLog += cValToChar(oModelBxP:GetErrorMessage()[MODEL_MSGERR_ID]) + ' - '
										cLog += cValToChar(oModelBxP:GetErrorMessage()[MODEL_MSGERR_MESSAGE])        	
										Help( ,,"M020VALID",,cLog, 1, 0 )
									EndIf

									If Valtype(oModelBxP) = "O"
										oModelBxP:DeActivate()
										oModelBxP:Destroy()
										oModelBxP:= nil
									EndIf

								EndIf									

							EndIf

							// P05 - Paulo Henrique - 11/10/2019
							While !Eof() .And. SE5->E5_IDORIG == aIdOrig[xg,1]

								If SE5->E5_MOTBX == "FAT" .And. SE5->E5_RECPAG == "P"
									RecLock("SE5")
									dbDelete()
									MsUnlock()
								EndIf
								SE5->(dbSkip())

							EndDo	

						EndIf

					Next

				End Transaction

				//Apaga o registro da fatura na tabela FRD
				IF lDocFat .And. lFinVDoc
					CN062ApagDocs(aFatCan)
				EndIf

				If nTotal > 0
					dbSelectArea("SE2")
					nRecSe2 := Recno()
					SE2->(DBGoBottom())
					SE2->(dbSkip())
					VALOR := nValTotal
					nTotal+=DetProva(nHdlPrv,cPadrao,"FINA290",cLote)
					RodaProva(nHdlPrv,nTotal)

					// Envia para Lancamento Contabil
					lDigita:=IIF(mv_par02==1,.T.,.F.)
					cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)
					VALOR := 0        
					dbSelectArea("SE2")
					SE2->(DBGoTo(nRecSe2))			
				EndIf
			EndIf
		EndIf
	EndIf

	// Recupera a Integridade dos dados
	Pergunte("AFI290",.F.)
	dbSelectArea(cAlias)
	Set Filter to
	RetIndex(cAlias)

	If	!Empty(cIndex)
		fErase(cIndex+OrdBagExt())
		cIndex := ""
	EndIf

	lAbatiment := .F.
	dbSetOrder(1)
	dbSeek(xFilial(cAlias),.T.)

	nOpca == 1 
	//-- Caroline Cazela 15/01/19 -> Regra para limpeza de campo E2_FATURA das NDFs
	dbSelectArea("SE2")
	DbSetOrder(1) 

	_cQuery	:= " SELECT R_E_C_N_O_ RECNO, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FATFOR, E2_FATLOJ, E2_TIPOFAT, E2_FLAGFAT, E2_FATPREF, E2_FATURA" 
	_cQuery	+= " FROM " + RetSqlName( "SE2" ) + " SE2 "
	_cQuery	+= " WHERE " 
	_cQuery	+= "    E2_FATURA     = '" + cFat + "' AND" 
	_cQuery	+= "    E2_TIPO     = '" + cTip + "' AND " 
	_cQuery	+= "     D_E_L_E_T_ = ' ' "
	 
	_cQuery	:= changeQuery(_cQuery)
	dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQuery), _cAlias, .F., .F. )
	
	SE2->(DbGoTop())
	SE2->(DbGoto((_cAlias)->RECNO))
	
	If SE2->(Recno()) == (_cAlias)->RECNO                          
		RecLock("SE2",.F.)
		SE2->E2_FATURA := ""
		SE2->E2_SALDO := SE2->E2_VALOR
		SE2->(MsUnlock())	
	EndIf

	(_cAlias)->(DbCloseArea()) 

Return(nOpca)

/*/{Protheus.doc} Fa290CAlCn
//TODO Cria o indice temporario para o cancelamento da fatura
@author Cesar C S Prado
@since 27/04/1994
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function FA290CalCn(nTitulos,nValor,cAlias,nFaturas,l290CalCn,lHelpCan,lSE2Compart,cAliasQry,cOrigem,lBxParcFat)

	Local lBanco := .F.
	Local lRet	 := .T.
	Local nValFat := 0

	DEFAULT lHelpCan  	:= .T.
	DEFAULT l290CalCn 	:= .F.
	DEFAULT lSE2Compart := .F.
	DEFAULT cAliasQry 	:= "SE2"
	DEFAULT cOrigem		:= "FINA290"

	If Empty(cFatCan)
		Help(" ",1,"INDVAZIO")
		lRet := .F.
	EndIf

	If lRet

		cAliasQry 	:= "SE2CAN"

		If Select(cAliasQry) > 0 
			dbSelectArea(cAliasQry)
			dbCloseArea()
			dbSelectArea(cAlias)
		EndIf

		// Gest„o
		cQuery := FA290FCAN(lSE2Compart,cOrigem)
		cQuery := ChangeQuery(cQuery)
		dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"SE2CAN",.F.,.T.)
		dbSelectArea(cAliasQry)

		If BOF() .And. EOF()
			If lHelpCan
				Help(" ",1,"INDVAZIO")
			EndIf
			
			// Restaura os indices do SE2 e deleta o arquivo de trabalho
			dbSelectArea(cAliasQry)
			dbCloseArea()
			dbSelectArea("SE2")
			dbSetOrder(1)
			lRet := .F.
		EndIf

		If lRet

			dbSelectArea(cAliasQry)

			// Caso tenha ocorrido a baixa de alguma parcela da fatura, nao sera possivel a operacao de cancelamento.
			nValor		:= 0
			lCancelar	:= .T.
			lBanco 		:= .F.

			While !(cAliasQry)->(Eof())

				SE2->(dbGoto((cAliasQry)->RECNO))

				If 		(SE2->E2_NUM == cFatCan .And. Day(SE2->E2_BAIXA) > 0 .And.;                   
						cPrefCan ==  SE2->E2_PREFIXO .And. SE2->E2_FATURA = "NOTFAT" .And. ;
						SE2->E2_TIPO == cTipoCan )
						lCancelar := .F.
				ElseIf  (SE2->E2_NUM == cFatCan .And. Day(SE2->E2_BAIXA) > 0 .And.;                   
						 cPrefCan ==  SE2->E2_PREFIXO .And. SE2->E2_FATURA = "NOTFAT" .And. ;
						 SE2->E2_TIPO == cTipoCan  .And. SE2->E2_FATFOR == cFornCan .And. ;
						 SE2->E2_FATLOJ == cLojaCan )	
					     lCancelar := .F.
				ElseIf   !Empty(SE2->E2_NUMBOR)
					     lBanco := .T.
				Else
					If SE2->E2_TIPO $ MV_CPNEG +"/"+ MVABATIM
						lAbatiment := .T.
					Else
						nValor += IIF(SE2->E2_SALDO == 0 , SE2->E2_VALLIQ, 0)

						/*
						Faturas compostas por tÌtulos que sofreram baixas parciais e as bxs 
						foram canceladas antes do cancelamento da fatura
						*/
						  
						If AllTrim(SE2->E2_FATURA) == "NOTFAT" .And. SE2->E2_SALDO > 0 .And. ;
						           SE2->E2_VALLIQ == 0 	
							nValFat += SE2->E2_SALDO 
							lBxParcFat := .T.
						EndIf
						
					EndIf
					
					If !(SE2->E2_TIPO $ MVABATIM)
						nTitulos+= IIF(!Empty(SE2->E2_TIPOFAT), 1, 0)
					EndIf
				
				EndIf
				
				(cAliasQry)->(dbSkip())

			EndDo

			If nValFat > 0 .And. nValFat <> nValor   
				nValor := nValFat	
			EndIf		

			If !lCancelar .Or. lBanco
				dbSelectArea(cAliasQry)
				dbCloseArea()

				dbSelectArea("SE2")
				dbSetOrder(1)

				If lHelpCan
					If !lCancelar
					   // Nao aceita se ja houve baixa em fatura
						Help(" ",1,"FATPJABX") 
					ElseIf lBanco
					   /*
					   Esta fatura possui parcela transferida para banco. 
					   Retorne os titulos para carteira antes de cancelar a fatura
					   */  
						Help(" ",1,"TITBCO",,STR0063,1,0) 
					EndIf
				EndIf

				lRet := .F.

			EndIf
		EndIf
	EndIf	

	l290CalCn := lRet

Return lRet

/*/{Protheus.doc} FA290FCAN
//TODO Selecao para a criacao do indice condicional
@author Cesar C S Prado
@since 03/05/1994
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function FA290FCAN(lSE2Compart,cOrigem)

	// Devera selecionar todos os registros que atendam a seguinte condicao :
	// 1. Mesmo fornecedor e loja
	// 2. Prefixo e Numero do Titulo iguais aos selecionados
	// 3. Ou titulos que tenham originado a fatura selecionada

	Local cFiltro := ""
	Local cEmpFil := FwCompany()
	Local nTamEmp := Len(cEmpFil)
	Local cFilIni := Padr(cEmpFil,FWGETTAMFILIAL)
	Local cFilFin := cEmpFil+Replicate('z',(FWGETTAMFILIAL - nTamEmp))

	DEFAULT lSE2Compart := .F.
	DEFAULT cOrigem		:= "FINA280"

	// Gest„o
	cFiltro := "SELECT "
	cFiltro += "R_E_C_N_O_ RECNO "
	cFiltro += " FROM " + RetSqlName("SE2") + " SE2 "
	cFiltro += " WHERE "
	cFiltro += "SUBSTR(E2_FILIAL,1,2)='"+ SubStr(xFilial("SE2"),1,2) + "' AND "
	cFiltro += " E2_FATURA   <> '" + Space(Len(SE2->E2_FATURA))  +"' AND "
	cFiltro += " ((E2_NUM     = '" + Pad(cFatCan,Len(E2_NUM))    +"' AND "
	cFiltro += "   E2_PREFIXO = '" + cPrefCan                    +"' AND "
	cFiltro += "   E2_FATURA  = '" + Pad("NOTFAT",Len(E2_FATURA))+"' AND "
	cFiltro += "   E2_TIPO    = '" + cTipoCan                    +"' AND "
	cFiltro += "   E2_FORNECE = '" + cFornCan                    +"' AND "
	cFiltro += "   E2_LOJA    = '" + cLojaCan                    +"' AND "
	cFiltro += "   E2_ORIGEM  = '" + cOrigem                     +"') OR "
	cFiltro += "  (E2_FATURA  = '" + Pad(cFatCan,Len(E2_FATURA)) +"' AND "
	cFiltro += "   E2_FATPREF = '" + cPrefCan                    +"' AND "
	cFiltro += " E2_FATFOR = '" + cFornCan 					 + "' AND "
	cFiltro += " E2_FATLOJ = '" + cLojaCan					 + "' AND "	
	cFiltro += "   E2_TIPOFAT = '" + cTipoCan                    +"')) AND "	
	cFiltro += " D_E_L_E_T_ = ' '"	
	cFiltro += " Order By R_E_C_N_O_"

Return cFiltro

/*/{Protheus.doc} FA290Ok
//TODO Selecao para a criacao do indice condicional
@author Pilar S. Albaladejo
@since 07/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290Ok()
	Local lRet := .T.
	lFocus := .F.

	If !lFocus .And. Empty(cTipo)
		// Retorno .T. para que possa focar o campo do numero da fatura para alteraÁ„o e posterior validaÁ„o. 
		// A validaÁ„o neste caso È feita somente no Fornecedor e ao confirmar a operaÁ„o da fatura.
		Help(" ",1,"TIPOFAT")
		oTipo:SetFocus()
		lFocus := .T.
	EndIf

	If !lFocus .And. Empty(cNat)
		// Retorno .T. para que possa focar o campo de natureza para alteraÁ„o e posterior validaÁ„o. 
		// A validacao neste caso È feita somente no Fornecedor e ao confirmar a operaÁ„o da fatura.
		Help(" ",1,"A290NAT")
		oNat:SetFocus()
		lFocus := .T.
	EndIf


	If	!lFocus .And. !Fa290Nat()
		// Retorno .T. para que possa focar o campo de natureza para alteraÁ„o e posterior validaÁ„o. 
		// A validacao neste caso È feita somente no Fornecedor e ao confirmar a operaÁ„o da fatura.
		oNat:SetFocus()
		lFocus := .T.
		lRet := .F.
	EndIf

Return If( lRet, (MsgYesNo(OemToAnsi(STR0045),OemToAnsi(STR0046))), .F.) //"Confirma Dados?"###"AtenÁ„o"

/*/{Protheus.doc} fa290Marca
//TODO Trata o valor para marcar e desmarcar item
@author Pilar S. Albaladejo
@since 21/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
STATIC Function fa290Marca(cAlias,cMarca,nLimite,lPccBaixa,lBaseSE2,aChaveLbn,aFatPag,nValorFat)

	LOCAL nRec
	Local cAliasAnt := Alias()
	Local lMarkTit  := .t.
	Local nPosChave	:= 0
	Local cChaveLbn
	Local nAbatim 	:= 0
	Local aChaveTit := {}
	Local nJuros	:= 0

	Default aFatPag := {}

	dbSelectArea(cAlias)
	nRec := Recno()
	
	While !Eof()
		cChaveLbn := "FAT" + (cAlias)->(xFilial("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
	
		If Len(aFatPag) > 0
			lMarkTit := .T.
		EndIf
	
		If LockByName(cChaveLbn,.T.,.F.)

			If  SE2->(MsRLock()) .And. RecLock(cAlias) // Se conseguir travar o registro          
		
				If lMarkTit .And. Len(aFatPag) > 0 
					nPosFat := Ascan(aFatPag[13],{ | e | e[1]+e[2]+e[3]+e[4]+ if(len(e)>=6,e[6]+e[7],"")== (cAlias)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+ if(len(e)>=6,E2_FORNECE+E2_LOJA,""))})
					If nPosFat > 0
						aFatPag[13,nPosFat,5] := .T.
					Else
						lMarkTit := .F.
					EndIf
				EndIf
	
				// Se esta apto a MarcaÁ„o;
				If lMarkTit
					// VARIAVEIS:
					// nValor
					// nLimite
		
					If	(nValor <= nLimite .Or. Empty(nLimite)) .And. (cAlias)->(MsRLock()) // Se conseguir travar o registro
						(cAlias)->E2_OK := cMarca

						If Ascan(aChaveLbn, cChaveLbn) == 0
							Aadd(aChaveLbn,cChaveLbn)
						EndIf

						// Trata os TIPOS 
						If E2_TIPO $ MV_CPNEG+"/"+MVABATIM
							nValor	-= E2_SALDO+E2_SDACRES-E2_SDDECRE
							nValCruz -= E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2)
							nQtdTit++
	
							// Conforme MIT044 29/10/2018
							nTotTit += IIF(Alltrim(E2_TIPO)!="NDF",(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE+E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO),0)
							nTAxTit += IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
							nVlrDec	+= E2_DECRESC
							nVlrAcr += E2_ACRESC
							nVlrDev += IIF(Alltrim(E2_TIPO)=="NDF",E2_SALDO,0)
							nValor := nTotTit
						Else

							If (cAlias)->CALCULADO == '1'
								nAbatim	:= (cAlias)->ABATSOMADO
							Else
								nAbatim	:= SumAbatPag(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_MOEDA,"S",,E2_LOJA)
								(cAlias)->CALCULADO := '1'
							EndIf

							// Tratamento para os tÌtulos que possuem a mesma chave, com exceùùo do tipo, o sistema considera o mesmo abatimento para ambos
							If nAbatim > 0
								If aScan( aChaveTit , E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA ) > 0
									nAbatim := 0
								Else
									aAdd( aChaveTit , E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA )
									ABATSOMADO := nAbatim
								EndIf
							EndIf

							nTitAbats += nAbatim
							nValor   += (E2_SALDO+E2_SDACRES-E2_SDDECRE) - nAbatim
							nValCruz += E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2) - nAbatim
							nQtdTit++

							// GDN Novos Campos no HEADER da TELA
							nTotTit += IIF(Alltrim(E2_TIPO)!="NDF",(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE+E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO),0)
							nTAxTit += IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) //Andy
							nVlrDec	+= E2_DECRESC
							nVlrAcr += E2_ACRESC
							nVlrDev += IIF(Alltrim(E2_TIPO)=="NDF",E2_SALDO,0)
							nValor := nTotTit
						EndIf

					EndIf

				EndIf

			Else
				UnlockByName(cChaveLbn, .T., .F.)
				nPosChave:= Ascan(aChaveLbn, cChaveLbn)
				
				If nPosChave >0
					aDel(aChaveLbn,nPosChave)
					aSize(aChaveLbn,Len(aChaveLbn)-1)
				EndIf

			EndIf

		EndIf

		dbSkip()
		SE2->(dbGoto((cAlias)->Recno))

	EndDo

	dbGoto(nRec)
	SE2->(dbGoto((cAlias)->Recno))
	dbSelectArea(cAliasAnt)

Return

/*/{Protheus.doc} FA290Exibe
//TODO Exibe Totais de titulos selecionados
@author Pilar S. Albaladejo
@since 07/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function

Obs.: Esta FunÁ„o n„o est· em uso na tela Customizada (MARFRIG)
/*/
Static Function Fa290Exibe(cMarca,oValor,oQtdTit,lPccBaixa,lBaseSE2,oTitAbats)

	Local lMarkTit := .t.
	Local nAbatim := 0

	// Se titulo estiver MARCADO,
	If lMarkTit

		If SE2->E2_OK == cMarca

			If E2_TIPO $ MV_CPNEG
				nValor   -= E2_SALDO+E2_SDACRES-E2_SDDECRE
				nValCruz -= E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2)
				nQtdTit++

				// GDN Novos Campos no HEADER da TELA
				nTotTit += IIF(Alltrim(E2_TIPO)!="NDF",(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE+E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO),0)
				nTAxTit += IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
				nVlrDec	+= E2_DECRESC
				nVlrAcr += E2_ACRESC
				nVlrDev += IIF(Alltrim(E2_TIPO)=="NDF",E2_SALDO,0)

			Else
				nAbatim := F290VerAbt( cMarca , .T. )
				nValor   += (E2_SALDO+E2_SDACRES-E2_SDDECRE) - nAbatim
				nValCruz += E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2) - nAbatim
				nTitAbats += nAbatim
				nQtdTit++

				// GDN Novos Campos no HEADER da TELA
				nTotTit += IIF(Alltrim(E2_TIPO)!="NDF",(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE+E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO),0)
				nTAxTit += IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
				nVlrDec	+= E2_DECRES
				nVlrAcr += E2_ACRESC
				nVlrDev += IIF(Alltrim(E2_TIPO)=="NDF",E2_SALDO,0)

			EndIf
		Else
			If E2_TIPO $ MV_CPNEG
				nValor	+= E2_SALDO+E2_SDACRES-E2_SDDECRE
				nValCruz += E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2)
				nQtdTit--

				// GDN Novos Campos no HEADER da TELA
				nTotTit -= IIF(Alltrim(E2_TIPO)!="NDF",(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE+E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO),0)			
				nTAxTit -= IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
				nVlrDec	-= E2_DECRES
				nVlrAcr -= E2_ACRESC
				nVlrDev -= IIF(Alltrim(E2_TIPO)=="NDF",E2_SALDO,0)

			Else
				nAbatim := F290VerAbt( cMarca , .F. )
				nValor   -= (E2_SALDO+E2_SDACRES-E2_SDDECRE) - nAbatim
				nValCruz -= E2_VLCRUZ+Round(NoRound(xMoeda(E2_SDACRES-E2_SDDECRE,E2_MOEDA,1,E2_EMISSAO,3),3),2) - nAbatim
				nTitAbats -= nAbatim
				nQtdTit--

				// GDN Novos Campos no HEADER da TELA
				nTotTit -= IIF(Alltrim(E2_TIPO)!="NDF",(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE+E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO),0)
				nTAxTit -= IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
				nVlrDec	-= E2_DECRES
				nVlrAcr -= E2_ACRESC
				nVlrDev -= IIF(Alltrim(E2_TIPO)=="NDF",E2_SALDO,0)

			EndIf
		EndIf
	EndIf

	nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
	oQtdTit:Refresh()

	If ValType(oTitAbats) == "O"
		oTitAbats:Refresh()
	EndIf

	// GDN - Estaniliza os NOVOS campos da TELA
	oVlrTit:Refresh()
	oVlrAcr:Refresh()
	oVlrDec:Refresh()
	oVlrDev:Refresh()
	oValorFat:Refresh()

Return

/*/{Protheus.doc} fa290Soma
//TODO Verifica se o valor da fatura È o mesmo dos tit. marcados
@author Pilar S. Albaladejo
@since 27/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static  Function Fa290Soma()

	IF Str(nValorF,16,2) != Str(nValor,16,2) .And. nValorF != 0 .And. !lMarkNDF
		Help(" ",1,"VALFAT")
		Return .F.
	EndIf

Return .T.

/*/{Protheus.doc} fa290Val
//TODO Pede que se digite o valor correto da fatura
@author Pilar S. Albaladejo
@since 27/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290Val(oValorFat)

	Local oDlg
	Local nOpca := 0

	DEFINE MSDIALOG oDlg FROM 10, 5 TO 17, 33 TITLE OemToAnsi(STR0049) //"Informe valor correto da Fatura"
	@	 .3,1 TO 2.3,11.9 OF oDlg
	@	1.0,2 	Say OemToAnsi(STR0050) //"Valor : "
	@	1.0,4.5	MSGET nValorF Picture "@E 999,999,999.99"

	DEFINE SBUTTON FROM 034,042	TYPE 1 ACTION (nOpca := 1,If(!Empty(nValorF),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
	DEFINE SBUTTON FROM 034,069.1 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg
	oValorFat:Refresh()

Return .F.

/*/{Protheus.doc} Fa290PedCd
//TODO Pede que se digite a condicao de pagamento
@author Pilar S. Albaladejo
@since 27/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290PedCd()

	Local oDlg
	Local nOpca := 0
	Local cCond := Space(3)

	DEFINE MSDIALOG oDlg FROM 10, 5 TO 17, 33 TITLE OemToAnsi(STR0051) //"Informe condiÁ„o de Pagamento"
	@	1.0,2 	Say OemToAnsi(STR0052) //"condiÁ„o: "
	@	1.0,5.5	MSGET cCond F3 "SE4" Picture "!!!"  Valid ExistCpo("SE4",cCond) .And. Fa290Cond(cCond) HASBUTTON
	@	0.3,1 TO 2.3,11.9 OF oDlg

	DEFINE SBUTTON FROM 034,069.1	TYPE 1 ;
	ACTION (nOpca := 1,If(	!Empty(cCond) .And. ;
	ExistCpo("SE4",cCond) .And. ;
	Fa290Cond(cCond),oDlg:End(),nOpca:=0)) ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

Return If(nOpca=0,"   ",cCond)

/*/{Protheus.doc} Fa290LinOk
//TODO Confere se a linha digitada esta OK
@author Pilar S. Albaladejo
@since 27/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static FuncTion Fa290LinOk()

	Local lRet := .T.
	Local nX, lDuplicado := .F.
	Local aArea 	:= GetArea()
	Local aAreaSe2 := SE2->(GetArea())
	Local nCol	   := Len(aCols[1])

	// Se a linha nao estiver deletada e o prefixo foi alterado
	IF !(aCols[n,nCol]) .And. aCols[n][1] != cPrefix
		// Nao permite alterar PREFIXO !
		Help(" ",1,"IGUALPREF")
		lRet := .F.
	EndIf

	// Se a linha nao estiver deletada e o TIPO foi alterado
	IF !(aCols[n,nCol]) .And. aCols[n][4] != cTipo
		// Nao permite alterar PREFIXO !
		Help(" ",1,"IGUALTIPO",,STR0058,1,0)  //"Nao e permitida alteracao do tipo do titulo."+CHR(13)+"Deve-se manter o tipo definido no inicio da rotina")
		lRet := .F.
	EndIf

	// Se a linha nao estiver deletada e o NUMERO foi alterado
	IF !(aCols[n,nCol]) .And. aCols[n][2] != cFatura
		// Nao permite alterar NUMERO !
		Help(" ",1,"IGUALNUM",,STR0059+CHR(13)+STR0060	,1,0)	 //"Nao e permitida alteracao do numero do titulo."###"Deve-se manter o numero definido no inicio da rotina"
		lRet := .F.
	EndIf

	// Verificar o vencimento da parcela
	IF (aCols[n,5]) < dDataBase
		// O vencimento deve ser maior que a database
		Help(" ",1,"NOVENCREA") 
		lRet := .F.
	EndIf 

	// Pesquisa por titulos ja cadastrados
	For nX := 1 To Len(aCols)
		// Se encontrou um titulo igual ao ja cadastrado, avisa e nao permite continuar
		If !aCols[nX][Len(aCols[nX])] .And. ;
			aCols[nX][1]+aCols[nX][2]+aCols[nX][3]+aCols[nX][4] == aCols[n][1]+aCols[n][2]+aCols[n][3]+aCols[n][4] .And. ;
			nX != n
			lDuplicado := .T.
			Exit
		EndIf	
	Next

	// Se encontrou um titulo igual ao ja cadastrado, avisa e nao permite continuar
	If !(aCols[n,nCol]) .And. lDuplicado
		lRet := .F.
		// Nao permite duplicar o numero !
		Help(" ",1,"A290EXIST")
	Elseif !(aCols[n,nCol]) .And. !lDuplicado
		dbSelectArea("SE2")
		DbSetOrder(1)
		If Msseek(xFilial("SE2")+aCols[n][1]+aCols[n][2]+aCols[n][3]+aCols[n][4]+;
		If(mv_par01 == 1,cForn,cFornP)+If(mv_par01 == 1,cLoja,cLojaP))
			lRet := .F.
			// Nao permite duplicar o numero !
			Help(" ",1,"A290EXIST")
		EndIf
	EndIf

	// Se passou por todas as validacoes, valida o valor
	If lRet .And. !(aCols[n,nCol]) 
		lRet := NaoVazio(aCols[n][6])
	EndIf	

	SE2->(RestArea(aAreaSe2))
	RestArea(aArea)

Return lRet

/*/{Protheus.doc} Fa290TudOK
//TODO Verifica se aCols esta preenchida corretamente
@author Pilar S. Albaladejo
@since 27/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290TudOk()

	Local nX, nValTot := 0
	LOCAL lRet := .T.
	Local aArea 	:= GetArea()
	Local aAreaSe2 := SE2->(GetArea())
	Local nCol	   := Len(aCols[1])

	For nx:=1 To Len(aCols)
		If !aCols[nx,nCol]
			nValTot += aCols[nx][6]

			// Verifica se o titulo esta cadastrado
			dbSelectArea("SE2")
			DbSetOrder(1)

			If Msseek(xFilial("SE2")+aCols[nX][1]+aCols[nX][2]+aCols[nX][3]+aCols[nX][4]+If(mv_par01 == 1,cForn,cFornP)+If(mv_par01 == 1,cLoja,cLojaP))
				lRet := .F.
				// Nao permite duplicar o numero !
				Help(" ",1,"A290EXIST")
				Exit
			EndIf
		EndIf
	Next nx

	IF Str(nTAxTit,16,2) != Str(nValTot,16,2) // Andy
		Help(" ",1,"VALFAT1",,STR0061 + Transform(nValor,"@E 99,999,999,999.99")+chr(13)+; //"Valor das notas "
		STR0062 + Transform(nValTot,"@E 99,999,999,999.99"),4,0) //"Valor da fatura  "
		lRet := .F.
	EndIf

	oValTot:Refresh()
	SE2->(RestArea(aAreaSe2))
	RestArea(aArea)

Return lRet

/*/{Protheus.doc} Fa290AtuVl
//TODO Atualiza valor da fatura na tela
@author Pilar S. Albaladejo
@since 27/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static FuncTion Fa290AtuVl(lVldCampo)

	Local nx
	DEFAULT lVldCampo := .T.
	nValTot := 0

	For nx:=1 To Len(aCols)
		If !aCols[nx,Len(aCols[1])]
			If nx == n .And. lVldCampo // Se estiver somando a posicao que alterei
				nValtot+= &(ReadVar())
			Else
				nValTot += aCols[nx][6]
			EndIf
		EndIf
	Next nx

	oValTot:Refresh()

Return .T.

/*/{Protheus.doc} FA290Invert
//TODO Marca / Desmarca	todos os titulos
@author Wagner Xavier
@since 12/05/1997
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290Inverte(cAliasSE2,cMarca,oValor,oQtdTit,lTodos,oMark,lPccBaixa,lBaseSE2,aChaveLbn,cChaveLbn,lAbat,cMarkTit,oTitAbats)

	Local nReg 		:= (cAliasSE2)->(Recno())
	Local lMarkTit	:= .t.
	Local nAbatim	:= 0
	Local cTitAnt	:= ""
	Local nOrderSe2 := (cAliasSE2)->(IndexOrd()) 
	Local cFilAtu	:= cFilAnt
	Local cFilOrig	:= cFilAnt

	DEFAULT lTodos  	:= .T.
	DEFAULT lAbat		:= .F.
	DEFAULT cMarkTit	:= ""

	If !lAbat .And. (cAliasSE2)->E2_TIPO $ MVABATIM+"/"+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
		Msginfo(STR0074,STR0048)	//"Este È um tÌtulo de abatimento, n„o pode ser marcado/desmarcado, posicione sobre o titulo principal para esta operaÁ„o"
		Return
	EndIf   

	dbSelectArea(cAliasSe2)

	If lTodos
		DbGoTop()
	EndIf	

	nReg := (cAliasSE2)->(Recno())

	While !lTodos .Or. ((cAliasSe2)->(!Eof()))

		If (lTodos .And. (cAliasSE2)->(MsRLock())) .Or. !lTodos

			If (cAliasSe2)->(FieldPos("RECNO")) > 0
				dbSelectArea("SE2")
				MsGoto((cAliasSe2)->RECNO)
				dbSelectArea(cAliasSe2)
			EndIf	

			cFilOrig := SE2->E2_FILORIG

			cChaveLbn := "FAT" + SE2->(xFilial("SE2",cFilOrig)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)

			If SE2->(MsRLock()) .And. ( (lTodos .And. LockByName(cChaveLbn,.T.,.F.)) .Or. !lTodos)
				IF (cAliasSe2)->E2_OK == cMarca

					// Valida se o abatimento ja nao foi desmarcado anteriormente e recalcula a base de saldo
					If lAbat .And. cMarkTit == (cAliasSE2)->E2_OK 
						nValor  += Moeda((E2_SALDO),nMoeda,"P")
						lMarkTit := .F.
					Elseif lAbat .And. !empty(cMarkTit) .And. cMarkTit <> (cAliasSE2)->E2_OK
						nValor  += Moeda((E2_SALDO),nMoeda,"P")
						lMarkTit := .F.
					EndIf

					If lMarkTit

						nAscan := Ascan(aChaveLbn, cChaveLbn )

						If nAscan > 0
							UnLockByName(aChaveLbn[nAscan],.T.,.F.) // Libera Lock
							aDel(aChaveLbn,nAscan)
							aSize(aChaveLbn,Len(aChaveLbn)-1)
						EndIf

						RecLock(cAliasSE2)
						(cAliasSE2)->E2_OK	:= "  "
						(cAliasSE2)->(MsUnlock())

						SE2->(MsUnlock())					

						If !lAbat
							cMarkTit := (cAliasSE2)->E2_OK
						EndIf

						//AlT**10
						If (cAliasSE2)->E2_TIPO $ MV_CPNEG
							nValor += Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")//+E2_SDACRES-E2_SDDECRE
						Else
							If !((cAliasSE2)->E2_TIPO $ MVABATIM)
								cFilAnt := cFilOrig
								nAbatim	:= F290VerAbt( cMarca , .F. )
								nValor  -= Moeda((E2_SALDO) - nAbatim,nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
								nTitAbats -= nAbatim
								cFilAnt := cFilAtu
							EndIf
						EndIf

						nQtdTit--

						// GDN Novos Campos no HEADER da TELA
						nTotTit -= IIF(Alltrim(E2_TIPO)!="NDF",(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE+E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO),0)
						nTAxTit -= IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
						nVlrDec	-= E2_DECRESC
						nVlrAcr -= E2_ACRESC
						nVlrDev -= IIF(Alltrim(E2_TIPO)=="NDF",E2_SALDO,0)

					EndIf  
				Else
					lMarkTit := .T.

					// Valida se o abatimento ja nao foi desmarcado anteriormente e recalcula a base de saldo
					If lAbat .And. cMarkTit == (cAliasSE2)->E2_OK 
						nValor  -= Moeda(SE2->(E2_SALDO),nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
						lMarkTit := .F.
					EndIf

					If lMarkTit
						If Ascan(aChaveLbn, cChaveLbn) == 0
							Aadd(aChaveLbn,cChaveLbn)
						EndIf	

						RecLock(cAliasSE2)

						(cAliasSE2)->E2_OK := cMarca

						If !lAbat
							cMarkTit := (cAliasSE2)->E2_OK
						EndIf

						If (cAliasSE2)->E2_TIPO $ MV_CPNEG
							nValor -= Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
						Else
							If !(E2_TIPO $ MVABATIM)
								cFilAnt := cFilOrig
								nAbatim	:= F290VerAbt( cMarca , .T. )
								nValor  += Moeda((E2_SALDO) - nAbatim,nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
								nTitAbats += nAbatim
								cFilAnt := cFilAtu
							EndIf					
						EndIf
						nQtdTit++

						// GDN Novos Campos no HEADER da TELA
						nTotTit += IIF(Alltrim(E2_TIPO)!="NDF",(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE+E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES-E2_XDESCO),0)
						nTAxTit += IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
						nVlrDec	+= E2_DECRESC
						nVlrAcr += E2_ACRESC
						nVlrDev += IIF(Alltrim(E2_TIPO)=="NDF",E2_SALDO,0)
					Else
						(cAliasSE2)->E2_OK	:= "  "
						(cAliasSE2)->(MsUnlock())
					EndIf

				EndIf

			EndIf

			If lTodos
				(cAliasSE2)->(dbSkip())
			Else
				cChaveLbn := "FAT" + (cAliasSE2)->(xFilial("SE2",cFilOrig)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
				nReg := (cAliasSE2)->(Recno())
				Exit
			EndIf  

		EndIf	

	EndDo

	If !(cAliasSE2)->E2_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT

		cFilOrig := SE2->E2_FILORIG
		cChaveLbn := "FAT" + (cAliasSE2)->(xFilial("SE2",cFilOrig)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)

		If !lTodos
			nReg := (cAliasSE2)->(Recno())
		EndIf

		(cAliasSE2)->(DbSetOrder(1))	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA

		If (cAliasSE2)->(dbSeek((cAliasSE2)->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA)))

			cTitAnt := (cAliasSE2)->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA) 		 

			While (cAliasSE2)->(!Eof()) .And. cTitAnt == (cAliasSE2)->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA)

				If !(cAliasSE2)->E2_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
					(cAliasSE2)->(dbSkip())
					Loop
				EndIf

				If (cAliasSE2)->(FieldPos("RECNO")) > 0
					dbSelectArea("SE2")
					MsGoto((cAliasSE2)->RECNO)
					dbSelectArea(cAliasSE2)
				EndIf	

				// Verifica se o registro nao esta sendo utilizado em outro terminal
				If LockByName(cChaveLbn,.T.,.F.)
					If Ascan(aChaveLbn, cChaveLbn) == 0
						Aadd(aChaveLbn,cChaveLbn)
					EndIf
					Fa290Inverte(cAliasSE2,cMarca,oValor,oQtdTit,lTodos,oMark,lPccBaixa,lBaseSE2,aChaveLbn,cChaveLbn,.T.,cMarkTit,oTitAbats)
				Else
					IW_MsgBox(STR0007,STR0061,"STOP") //"Este titulo est· sendo utilizado em outro terminal, n„o pode ser utilizado na fatura"###"AtenÁ„o"
				EndIf	

				(cAliasSE2)->(DbSkip())

			EndDo

		EndIf

		(cAliasSE2)->(DbSetOrder(nOrderSe2))
		(cAliasSE2)->(dbGoto(nReg))
	EndIf
	(cAliasSE2)->(dbGoto(nReg))

	oQtdTit:Refresh()

	If ValType(oTitAbats) == "O"
		oTitAbats:Refresh()
	EndIf

	// GDN - Estaniliza os NOVOS campos da TELA
	oVlrTit:Refresh()
	oVlrAcr:Refresh()
	oVlrDec:Refresh()
	oVlrDev:Refresh()
	oValorFat:Refresh()

Return Nil

/*/{Protheus.doc} fa290ValOK
//TODO Verifica se o valor da fatura È v·lido (maior que zero)
@author Mauricio Pequim Junior
@since 28/09/1999
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290ValOK()
	
	Local lRet	:= .T.
	Local nBrw	:= 1
	Local nTNDF	:= 0
	Local nTTIT	:= 0
	
	IF nValor <= 0 .And. !lMarkNDF
		Help(" ",1,"VLFATNEG")
		lRet:=.F.
	EndIf

	// 28/11/2018 Se tem apenas NDF marcada n„o pode dar sequencia. 
	If lMarkNdf
		
		For nBrw:=1 to Len(aBrowse)
		
			If aBrowse[nBrw][1] 
		
				If aBrowse[nBrw][4] == "NDF"
					nTNDF++
				Else
					nTTIT++
				EndIf
		
			EndIf
		
		Next nBrw

		// Marcou NDF e n„o Marcou Titulo
		If nTNDF > 0 .And. nTTIT==0
			MsgInfo("N„o È permitido selecionar apenas Tipo NDF !","AtenÁ„o")
			lRet:=.F.
		EndIf

	EndIf

Return(lRet)

/*/{Protheus.doc} FA290Tipo
//TODO Verifica se o valor da fatura È v·lido (maior que zero)
@author Mauricio Pequim Jr
@since 19/11/1999
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function FA290Tipo(cTipoDoc)

	LOCAL lRetorna := .T.

	dbSelectArea("SX5")
	
	If !dbSeek(cFilial+"05"+cTipoDoc)
		Help(" ",1,"E2_TIPO")
		lRetorna := .F.
	Elseif !NewTipCart(cTipoDoc,"2")
		Help(" ",1,"TIPOCART")
		lRetorna := .F.
	Else
		If cTipoDoc $ MVRECANT+"/"+MV_CRNEG
			Help(" ",1,"E2_TIPO")
			lRetorna := .F.
		ElseIf cTipoDoc $ MVPAGANT+"/"+MVTAXA+"/"+MV_CPNEG+"/"+MVABATIM
			Help(" ",1,"TIPOFAT")
			lRetorna := .F.
		EndIf
	EndIf

Return lRetorna

/*/{Protheus.doc} fa290nat
//TODO Verifica validade da natureza.
@author Paulo Boschetti
@since 27/07/1993
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function FA290NAT()
	
	Local cAlias	 := Alias()
	Local lRet		 := .T.
	Local lValidBloq := SED->(FieldPos("ED_MSBLQL")) > 0

	dbSelectArea("SED")
	If !(dbSeek(xFilial("SED")+cNat))
		Help(" ",1,"A290NAT")
		lRet := .F.
	EndIf                  

	If lRet .And. !FinVldNat( .F., cNat, 2 ) 
		lRet := .F.
	EndIf

	If lRet .And. lValidBloq
		If SED->ED_MSBLQL == "1"
			Help(" ",1,"EDBLOCKED",,STR0072,1,0)	//"Natureza bloqueada para novas movimentaùùes"
			lRet := .F.
		EndIf
	EndIf

	dbSelectArea(cAlias)

Return lRet

/*/{Protheus.doc} Fa290bAval
//TODO Bloco de marcac„o
@author Mauricio Pequim Jr.
@since 02/04/2003
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290bAval(cAlias,cMarca,oValor,oQtda,oMark,lPccBaixa,lBaseSE2,aChaveLbn,oTitAbats)

	Local lRet 		:= .T.
	Local cChaveLbn 

	// Verifica se o registro nao esta sendo utilizado em outro terminal
	cChaveLbn := "FAT" + (cAlias)->(xFilial("SE2")+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)

	// Verifica se o registro nao esta sendo utilizado em outro terminal
	//-- Parametros da Funcao LockByName() :
	//   1o - Nome da Trava
	//   2o - usa informacoes da Empresa na chave
	//   3o - usa informacoes da Filial na chave 
	If (cAlias)->(MsRLock())
		Fa290Inverte(cAlias,cMarca,oValor,oQtda,.F.,oMark,lPccBaixa,lBaseSE2,aChaveLbn,cChaveLbn,,,oTitAbats) // Marca o registro e trava
		lRet := .T.
	Else
		IW_MsgBox(STR0068,STR0067,"STOP") //"Este titulo est· sendo utilizado em outro terminal, n„o pode ser utilizado na fatura"###"AtenÁ„o"
		lRet := .F.
	EndIf	

Return lRet

/*/{Protheus.doc} Fa290Pesq
//TODO Bloco de marcac„o
@author Paulo Augusto
@since 07/03/2006
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290Pesq(oMark, cAlias)

	Local cAliasAnt	:= Alias()
	Local nRecno
	Local nOrdInd	:= IndexOrd()
	Local cFiltro	:= ""

	dbSelectArea(cAlias)
	nRecno := Recno()

	AxPesqui()

	// Se o que foi digitado para pesquisa nao estiver dentro do filtro
	// Continua no mesmo registro que estava antes de selecionar CTRL-P
	cFiltro := U_MGFFINCHK(,,,,.F.) // AAA01

	If &(cFiltro)
		(cAliasAnt)->(dbSeek((cAlias)->&((cAliasAnt)->(INDEXKEY()))))
	Else
		(cAlias)->(dbGoto(nRecNo))
	EndIf

	dbSelectArea(cAliasAnt)
	(cAliasAnt)->(dbSetOrder(nOrdInd))

	oMark:oBrowse:Refresh(.T.)

Return Nil

/*/{Protheus.doc} MenuDef
//TODO Utilizacao de menu Funcional
@author Ana Paula N. Silva
@since 23/11/2006
@version 1.0
@return 
Array com opcoes da rotina

@parameters 
Parametros do array a Rotina:

	1. Nome a aparecer no cabecalho
	2. Nome da Rotina associada
	3. Reservado
	4. Tipo de TransaÁ„o a ser efetuada:
	  	1 - Pesquisa e Posiciona em um Banco de Dados
      	2 - Simplesmente Mostra os Campos
      	3 - Inclui registros no Bancos de Dados
      	4 - Altera o registro corrente
		5 - Remove o registro corrente do Banco de Dados
	5. Nivel de acesso
	6. Habilita Menu Funcional

@type function
/*/
Static Function MenuDef()

	Local aRotina := { 	{ OemToAnsi(STR0001),"AxPesqui"  	, 0 , 1,,.F. },; 	//"Pesquisar"
						{ OemToAnsi(STR0002),"U_FIN78_VE"   , 0 , 2 },; 		//"Visualizar"
						{ OemToAnsi(STR0003),"u_MGFINAut"   , 0 , 3 },; 		//"Selecionar"
						{ OemToAnsi(STR0004),"u_MGFINCan"   , 0 , 6 },; 		//"Cancelar" 
						{ OemToAnsi(STR0071),"FA040Legenda" , 0 , 7,,.F.}}		//"Legenda"

Return(aRotina)

/*/{Protheus.doc} FinA290T
//TODO Chamada semi-automatica utilizado pelo gestor financeiro
@author Marcelo Celi Marques
@since 26/03/2008
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function FinA290T(aParam)

	cRotinaExec := "FINA290"

	ReCreateBrow("SE2",FinWindow)      		
	FinA290(aParam[1])
	ReCreateBrow("SE2",FinWindow) 
	dbSelectArea("SE2")

	INCLUI := .F.
	ALTERA := .F.	

Return .T.	

/*/{Protheus.doc} F290SelPR
//TODO Markbrowse da Faturas a Pagar
@author Marcelo Celi Marques
@since 13/05/2008
@version 1.0
@return ${return}, ${return_description}

@parameters 
ExpO1 = Objeto onde se encaixara a MarkBrowse
ExpC1 = Tratamento aplicado a outras moedas (<>1)
ExpN1 = Valor dos titulos selecionados
ExpN2 = Quantidade de titulos selecionados
ExpC2 = Marca (GetMark())
ExpO2 = Objeto Valor dos titulos selecionados p/ refresh
ExpO3 = Objeto Quantidade de titulos selecionados p/refresh
ExpN3 = Moeda da Substituicao
ExpO4 = Objeto Painel superior a ser desabilitado

@type function
/*/
Static Function F290SelFat(oDlg,nOpca,cCond,nValor,nValTot,aVenc,cPrefix,cFatura,cTipo,dDatCont,oPanel,oPanel2)

	Local lPanelFin := IsPanelFin()
	Local nI        := 0
	Local oFnt 
	Local oFnt2   

	DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD 
	DEFINE FONT oFnt2 NAME "Arial" SIZE 10,14 BOLD

	aCols 	:= If(Type("aCols")=="A",{},aCols)
	aHeader := If(Type("aHeader")=="A",{},aHeader)

	cCondicao 	:= If(nOpca=0,1,cCond)
	nDup		:= cCond

	aCols := GravaDup(nDup,cPrefix,cFatura,nValor,dDatabase,aVenc,cTipo,"FINA280")

	If !Empty(aCols)
		aVlCruz := {}
		aVlCruz := F280VlCruz(nDup,nValCruz)

		// Mostra tela com os diversos titulos
		For nI:=1 To Len(aCols)
			nValTot += aCols[nI][6]
		Next

		IF Str(nValor,16,2) != Str(nValTot,16,2)
			nValTot := nValor
		EndIf    

		nOpca := 0		
		@ 015,135	SAY STR0029 OF oPanel2 SIZE 80,14 Pixel		// "Data contabilizaÁ„o: "
		@ 015,190	Say dDatCont OF oPanel2 SIZE 80,14  Pixel 	
		@ 015,248	Say 'Parcelas' OF oPanel2 SIZE 80,14 Pixel 	// "condiÁ„o de Pagamento : "
		@ 015,315	Say cCondicao OF oPanel2 SIZE 80,14  Pixel
		@ 015,375	Say STR0031 OF oPanel2 Pixel SIZE 80,14 	// "Valor Total:"

		@ 015,400 Say oValTot VAR nValTot Picture "@E 9,999,999,999.99" OF oPanel2 PIXEL FONT oFnt COLOR CLR_HBLUE

		oGet := MSGetDados():New(34,5,128,315,3,"Fa290LinOk","Fa290TudOk","",.T.,,,,,,"",,"Fa290AtuVl(.F.)")				
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT			
	EndIf  

Return 

/*/{Protheus.doc} FA290MotBX
//TODO Criar automaticamente o motivo de baixa FAT na tabela Mot baixas
@author Marcelo Celi Marques
@since 26/03/2008
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290MotBx(cMot,cNomMot, cConfMot)

	Local aMotbx := ReadMotBx()
	Local nHdlMot, I, cFile := "SIGAADV.MOT"

	If Ascan(aMotbx, {|x| Substr(x,1,3) == Upper(cMot)}) < 1

		nHdlMot := FOPEN(cFile,FO_READWRITE)

		If nHdlMot <0
			HELP(" ",1,"SIGAADV.MOT")
			Final("SIGAADV.MOT")
		EndIf

		nTamArq:=FSEEK(nHdlMot,0,2)	// VerIfica tamanho do arquivo
		FSEEK(nHdlMot,0,0)			// Volta para inicio do arquivo

		For I:= 0 to  nTamArq step 19 // Processo para ir para o final do arquivo	
			xBuffer:=Space(19)
			FREAD(nHdlMot,@xBuffer,19)
		Next		

		fWrite(nHdlMot,cMot+cNomMot+cConfMot+chr(13)+chr(10))	
		fClose(nHdlMot)		
	EndIf	
Return

/*/{Protheus.doc} F290VlCpos
FunÁ„o para varrer os campos preenchidos em busca de caracteres especiais
@author TOTVS S/A
@since 14/07/2014
@version P1180
@return Retorno Booleano da validaÁ„o dos dados
/*/ 
Static Function F290VlCpos(aCps)

	Local nX := 1
	Local lOk := .T.
	Local xCampo

	Default aCps := {"cPrefix","cFatura"}

	While nX <= Len(aCps) .And. lOk

		xCampo := &(aCps[nX])

		If !Empty(xCampo) .And. ValType(xCampo) == "C" 
			If CHR(39) $ xCampo	 .Or. CHR(34) $ xCampo	
				lOk := .F.
			EndIf		
		EndIf	

		nX++

	EndDo 
	
	If !lOk
		Help("",1,"INVCAR",,STR0076,1,0) //"Informe caracteres vùlidos no preenchimento dos campos"
	EndIf

Return lOk

/*/{Protheus.doc} F290VerAbt
//TODO Faz o controle dos valores de abatimentos para tÌtulos com a chave igual, exceÁ„o para o tipo.
@author Marcelo Celi Marques
@since 06/01/2015
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function F290VerAbt( cMarca , lMarcou )

	Local nReturn  := 0
	Local nVlrAbat := 0
	Local nRecNo   := RecNo()
	Local cChave   := E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA
	Local cKey     := E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA
	Local nVlrSoma := ABATSOMADO
	Local cAlias   := Alias()
	Local cFilBckp := cFilAnt

	cFilAnt := E2_FILORIG

	If (cAlias)->CALCULADO == '1'
		nReturn := (cAlias)->VLSOMAABAT
	Else
		nReturn := SomaAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,"P",E2_MOEDA,,E2_FORNECE,E2_LOJA,,,E2_TIPO)
		RecLock( cAlias )
		(cAlias)->VLSOMAABAT := nReturn 
		(cAlias)->CALCULADO := '1'
		MsUnLock( cAlias )
	EndIf

	If nReturn > 0
		If ABATSOMADO > 0 .And. !lMarcou
			RecLock( cAlias )
			ABATSOMADO := nVlrAbat
			MsUnLock( cAlias )
		EndIf

		(cAlias)->(DbSeek(xFilial('SE2')+E2_PREFIXO+E2_NUM+E2_PARCELA))

		While !Eof() .And. (cKey == E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA)
			If ( cChave == E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA ) .And. RecNo() <> nRecNo

				If (cAlias)->CALCULADO == '1'
					nVlrAbat := (cAlias)->VLSOMAABAT
				Else
					nVlrAbat := SomaAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,"P",E2_MOEDA,,E2_FORNECE,E2_LOJA,,,E2_TIPO)
					RecLock( cAlias )
					(cAlias)->VLSOMAABAT := nVlrAbat
					(cAlias)->CALCULADO := '1'
					MsUnLock( cAlias )
				EndIf

				If nVlrAbat > 0 .And. E2_OK == cMarca

					If ABATSOMADO > 0 
						nReturn := 0
						Exit
					ElseIf ABATSOMADO == 0 .And. !lMarcou .And. nVlrSoma > 0
						RecLock( cAlias )
						(cAlias)->ABATSOMADO := nVlrAbat
						(cAlias)->CALCULADO := '1'
						MsUnLock( cAlias )
						nReturn := 0
						Exit
					EndIf

				EndIf

			EndIf

			dbSkip()

		EndDo

		dbGoTo( nRecNo )

		If ABATSOMADO == 0 .And. lMarcou .And. nReturn > 0
			RecLock( cAlias )
			ABATSOMADO := nReturn
			MsUnLock( cAlias )
		EndIf 
	EndIf

	cFilAnt := cFilBckp

Return nReturn

/*/{Protheus.doc} F290VLDDT
//TODO Valida data de/AtÈ.
@author lucas.oliveira
@version 1.0
@since	26/02/2015
@return ${return}, ${return_description}

@type function
/*/
Static Function F290VLDDT(cCampo, dDataDe, dDataAte )  
	local lRet := .T.

	If cCampo == "DataDe"
		If Empty(dDataDe)
			Help(" ",1,"DTVAZIA",,STR0080,1,0)//"O campo Emiss„o De deve ser preenchido."
			lRet := .F.		
		EndIf
	Else
		If Empty(dDataAte)
			Help(" ",1,"DTVAZIA",,STR0083,1,0)//"O campo AtÈ deve ser preenchido."
			lRet := .F.
		EndIf
	EndIf

Return lRet

/*/{Protheus.doc} OrdenaCab
//TODO 
@author Eugenio Arcanjo
@since 24/01/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function OrdenaCab(nCol,bMudaOrder,oMark)

	Local aOrdena := {}       
	Local aTotal  := {}

	aOrdena := AClone(aBrowse)                                         
	
	IF nTipoOrder == 1                              
		IF bMudaOrder
			nTipoOrder := 2
		EndIf                                                           
		aOrdena := aSort(aOrdena,,,{|x,y| x[nCol] < y[nCol]})                    
	Else              
		IF bMudaOrder
			nTipoOrder := 1
		EndIf                                                                                               
		aOrdena := aSort(aOrdena,,,{|x,y| x[nCol] > y[nCol]})                    
	EndIf

	aBrowse    := aOrdena
	nColOrder  := nCol
	
	oBrowseDados:DrawSelect()
	oBrowseDados:Refresh()          

Return

/*/{Protheus.doc} EX400OrdEventos
//TODO Ordena os eventos de acordo com a coluna selecionada.
@author Felipe S. Martinez - FSM
@since 24/04/2012
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function EX400OrdEventos(oBrw,nCol)

	Local cColCpo := ""

	If Type("aSelCpos") == "A"
		cColCpo := Upper(AllTrim(aCampos[nCol][1]))
	EndIf

	If ncol == 1
		TRBSE2->(DBSetOrder(1)) //"E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"
	ElseIf nCol == 2
		TRBSE2->(DBSetOrder(2)) //"E2_FILIAL+E2_NATUREZ+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE"
	ElseIf nCol == 3
		TRBSE2->(DBSetOrder(3)) //"E2_FILIAL+DTOS(E2_VENCREA)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FILORIG"
	EndIf

Return .T.

/*/{Protheus.doc} AtualizaMark
//TODO 
@author Eugenio Arcanjo
@since 24/01/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function AtualizaMark

	oMark:SetFocus()

Return

/*/{Protheus.doc} GeraDados
//TODO Colocar o browse por ORDEM DE TIPO 
@author Eugenio Arcanjo
@since 17/12/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function GeraDados()
	Local nTamNUM 		:= TamSX3("E2_NUM")[1]      

	dbSelectArea("SE2")

	// Data: 17/12/2018 - Colocar o browse por ORDEM DE TIPO 
	(cAliasSE2)->(DbSetOrder(2))                   
	(cAliasSe2)->(dbGotop())                  

	While (cAliasSe2)->(!EOF())

		aReg := {}                        

		IF Alltrim((cAliasSe2)->E2_OK) == Alltrim(cMarca)
			AADD(aReg, .T. )
		Else 
			AADD(aReg, .F. )
		EndIf

		AADD(aReg,(cAliasSe2)->E2_FILIAL )
		AADD(aReg,(cAliasSe2)->E2_PREFIXO)
		AADD(aReg,(cAliasSe2)->E2_TIPO   )
		AADD(aReg,(cAliasSe2)->E2_NATUREZ)
		AADD(aReg, PADL(Alltrim((cAliasSe2)->E2_NUM),nTamNUM)    )
		AADD(aReg,(cAliasSe2)->E2_PARCELA)
		AADD(aReg,(cAliasSe2)->E2_ACRESC )
		AADD(aReg,(cAliasSe2)->E2_DECRESC)
		AADD(aReg,(cAliasSe2)->ABATMTS   )
		SE2->(dbGoTo((cAliasSe2)->RECNO))
		AADD(aReg,SE2->(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE-E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES ))
		AADD(aReg,(cAliasSe2)->E2_EMISSAO)
		AADD(aReg,(cAliasSe2)->E2_VENCTO )
		AADD(aReg,(cAliasSe2)->E2_VENCREA)
		AADD(aReg,(cAliasSe2)->E2_FORNECE)
		AADD(aReg,(cAliasSe2)->E2_LOJA   )
		AADD(aReg,(cAliasSe2)->E2_NOMFOR )
		AADD(aReg,(cAliasSe2)->E2_VALOR  )
		AADD(aReg,(cAliasSe2)->E2_SALDO  )
		AADD(aReg,(cAliasSe2)->E2_HIST   )
		AADD(aReg,(cAliasSe2)->ABATSOMADO)
		AADD(aReg,(cAliasSe2)->(Recno()))

		AADD(aBrowse,aReg)
		(cAliasSe2)->(dbSkip())
	End
	// Data: 17/12/2018 - Voltar a ordem 
	(cAliasSE2)->(DbSetOrder(1))                   

Return             

/*/{Protheus.doc} MudaStatus
//TODO Muda o status de markbrowse
@author Eugenio Arcanjo
@since 17/12/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function MudaStatus(nTipo) 
	//1 - Individual
	//2 - Desmarca todas
	//3 - Marca Todas

	Local nI := 0 
	Local nx := 1
	CursorWait() 

	// Marcou um REGISTRO na LINHA      
	IF nTipo == 1                         
		(cAliasSe2)->(dbGoTo(aBrowse[oBrowseDados:nAt][Len(aCab)+1]))
		RecLock(cAliasSE2,.F.)
		(cAliasSE2)->E2_OK	:= IIF(aBrowse[oBrowseDados:nAt][1],"  ",cMarca)
		(cAliasSE2)->(MsUnlock())                                          

		// ATUALIZA MARCACAO PARA A LINHA
		Atu_Var(1) 
		aBrowse[oBrowseDados:nAt][1] := !aBrowse[oBrowseDados:nAt][1]
		oBrowseDados:DrawSelect()
	Else
		CursorWait()

		Processa({|| MG78MrkTd(nTipo)})   

		// Se ESTA USANDO BOTAO DESMARCAR                        
		IF nTipo == 2

			nAbatim   := 0
			nValor    := 0
			nValCruz  := 0
			nTitAbats := 0
			nQtdTit   := 0
			nValorF   := 0

			// GDN Novos Campos no HEADER da TELA
			nTotTit := 0
			nTAxTit := 0 // Andy
			nVlrDec	:= 0
			nVlrAcr := 0
			nVlrDev := 0
			lMarkNDF := .F.

		Else
			// SE ESTA USANDO BOTAO PARA MARCAR/DESMARCAR TODOS
			Atu_Var(2)       
		EndIf
		oBrowseDados:DrawSelect()
		oBrowseDados:Refresh()          
	EndIf

	For nx := 1 to Len(aBrowse)
		If aBrowse[nx][1] .And. aBrowse[nx][4]=="NDF"
			lMarkNDF := .T.
			Exit
		EndIf
	Next nx

	CursorArrow()

	oValorFat:Refresh()
	oQtdTit:Refresh()

	// GDN - Estabiliza os NOVOS campos da TELA
	oVlrTit:Refresh()
	oVlrAcr:Refresh()
	oVlrDec:Refresh()
	oVlrDev:Refresh()
	oValorFat:Refresh()

Return

/*/{Protheus.doc} MG78MrkTd
//TODO Muda o status de markbrowse (Marca Todos os itens)
@author Eugenio Arcanjo
@since 17/12/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function MG78MrkTd(nTipo)
	Cursorwait()
	ProcRegua(Len(aBrowse))
	// Se ESTA USANDO BOTAO MARCAR TODOS
	(cAliasSE2)->(dbGotop())

	While !(cAliasSE2)->(Eof())

		RecLock(cAliasSE2,.F.)
		(cAliasSE2)->E2_OK	:= IIF(nTipo == 2,"  ",cMarca)
		nPosBrw:=Ascan(aBrowse,{|x|x[2]+x[3]+x[4]+x[6]+x[7]==(cAliasSE2)->E2_FILIAL+(cAliasSE2)->E2_PREFIXO+(cAliasSE2)->E2_TIPO+PadL(Alltrim((cAliasSE2)->E2_NUM),Len((cAliasSE2)->E2_NUM))+(cAliasSE2)->E2_PARCELA})

		If nPosBrw>0
			aBrowse[nPosBrw][1] := IIF(nTipo==2,.F.,.T.)
			If alltrim(aBrowse[nPosBrw][4])=="NDF" .And. aBrowse[nPosBrw][1]
				lMarkNDF := .T.
			EndIf
		EndIf

		(cAliasSE2)->(MsUnlock())
		IncProc()
		(cAliasSE2)->(dbSkip())

	EndDo
	CursorArrow()
Return

/*/{Protheus.doc} GeraExcel
//TODO Gera relatÛrio em planilha excel
@author Eugenio Arcanjo
@since 17/12/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function GeraExcel()            

	Local aCabExcel   := {}
	Local aDadosExcel := {}
	Local nI          := 0 
	Local nC          := 0 
	Local nL          := 0 

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel n„o instalado!")
		Return
	EndIf

	For nI := 1 To Len(aCab)
		Aadd(aCabExcel,aCab[nI] )
	Next            

	aCabExcel[01] := 'Marcado'

	For nL := 1 To Len(aBrowse)
		aAux := {}

		For nC := 1 To Len(aCab)
			Aadd(aAux, aBrowse[nL,nC])
		Next
		
		IF aAux[01]
			aAux[01] := 'X'
		Else
			aAux[01] := ' '
		EndIf
		
		aAux[02] := CHR(160)+aAux[02]		// Filial
		aAux[03] := CHR(160)+aAux[03]		// Prefixo
		aAux[06] := CHR(160)+aAux[06]		// Num. Titulo
		aAux[14] := CHR(160)+aAux[15]		// Cod. Fornecedor
		aAux[15] := CHR(160)+aAux[16]		// Loja
		Aadd(aDadosExcel, aAux)
	Next

	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({ {"ARRAY", cLote, aCabExcel, aDadosExcel} }) })                                          

Return

/*/{Protheus.doc} SetF12
//TODO 
@author Eugenio Arcanjo
@since 17/12/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function SetF12

	MV_PAR01 := 1 
	MV_PAR02 := 2
	MV_PAR03 := 2
	MV_PAR04 := 2
	MV_PAR05 := 2							
	MV_PAR06 := 2

Return

/*/{Protheus.doc} FIN78_VE
//TODO 
@author Eugenio Arcanjo
@since 17/12/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function FIN78_VE(cAlias,nReg,nOpc)
	LOCAL nOpcA
	Local aBut050   := {}

	PRIVATE aRatAFR		:= {}
	PRIVATE _Opc 		:= nOpc
	Private aSE2FI2		:=	{} // Utilizada para gravacao das justificativas
	Private aCposAlter  :=  {}        

	dbSelectArea("SA2")
	dbSeek(cFilial+SE2->E2_FORNECE+SE2->E2_LOJA)

	AADD(aBut050, {"HISTORIC", {|| Fc050Con() }		, 'PosiÁ„o'})
	AADD(aBut050, {"HISTORIC", {|| Fin250Pag(2) }	, "Rastreamento"})

	dbSelectArea('SE2')

	nOpca := AxVisual(cAlias,nReg,nOpc,,4,SA2->A2_NOME,"FA050MCPOS",aBut050)

Return                           

/*/{Protheus.doc} Atu_Var
//TODO Verifica a MARCA no Titulo do Browse e ajusta as vari·veis de Totais e Valores.
@author Eugenio Arcanjo
@since 17/12/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Atu_Var(nTipo)       
	Local lMarkTit := .T.

	// GDN - Esta FunÁ„o verifica a MARCA no Titulo do Browse e ajusta as variùveis de Totais e Valores.
	IF nTipo == 1
		// ESTA MARCANDO UM REGISTRO NA LINHA
		IF (cAliasSe2)->E2_OK <> cMarca
			If (cAliasSE2)->E2_TIPO $ MV_CPNEG
				nValor += Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")//+E2_SDACRES-E2_SDDECRE
			Else
				If !((cAliasSE2)->E2_TIPO $ MVABATIM)
					nAbatim	  := F290VerAbt( cMarca , .F. )
					nValor    -= Moeda((E2_SALDO) - nAbatim,nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
					nTitAbats -= nAbatim
				EndIf
			EndIf
			nQtdTit--

			// GDN Novos Campos no HEADER da TELA
			nTotTit -= IIF(Alltrim(E2_TIPO)!="NDF",(cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_ACRESC-(cAliasSE2)->E2_DECRESC,0)
			nTAxTit -= IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
			nVlrDec	-= (cAliasSE2)->E2_DECRESC
			nVlrAcr -= (cAliasSE2)->E2_ACRESC
			nVlrDev -= IIF(Alltrim((cAliasSE2)->E2_TIPO)=="NDF",(cAliasSE2)->E2_SALDO,0)

			// GDN Ajusta o VALOR FATURA
			nValorF := ( nTotTit - nVlrDev )
			nValorF := Iif(nValorF>0,nValorF,0)

			nValor := nValorF
		Else
			// ESTA DESMARCANDO UM REGISTRO
			If (cAliasSE2)->E2_TIPO $ MV_CPNEG
				nValor -= Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
			Else
				If !(E2_TIPO $ MVABATIM)
					nAbatim	:= F290VerAbt( cMarca , .T. )
					nValor  += Moeda((E2_SALDO) - nAbatim,nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
					nTitAbats += nAbatim
				EndIf
			EndIf
			nQtdTit++

			// GDN Novos Campos no HEADER da TELA
			nTotTit += IIF(Alltrim(E2_TIPO)!="NDF",(cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_ACRESC-(cAliasSE2)->E2_DECRESC,0)
			nTAxTit += IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
			nVlrDec	+= (cAliasSE2)->E2_DECRESC
			nVlrAcr += (cAliasSE2)->E2_ACRESC
			nVlrDev += IIF(Alltrim(E2_TIPO)=="NDF",(cAliasSE2)->E2_SALDO,0)

			// GDN Ajusta o VALOR FATURA
			nValorF := ( nTotTit - nVlrDev )
			nValorF := Iif(nValorF>0,nValorF,0)

			nValor := nValorF				
		EndIf

	ElseIF nTipo == 2
		// ESTA DESMARCANDO TODOS REGISTROS - LIMPAR AS VARIAVEIS.
		nAbatim   := 0
		nValor    := 0
		nValCruz  := 0
		nTitAbats := 0
		nQtdTit   := 0

		// GDN Novos Campos no HEADER da TELA
		nTotTit := 0
		nTAxTit := 0 // Andy
		nVlrDec	:= 0
		nVlrAcr := 0
		nVlrDev := 0

		dbSelectArea(cAliasSe2)
		DbGoTop()

		While (cAliasSe2)->(!Eof())
			IF (cAliasSe2)->E2_OK <> cMarca
				If (cAliasSE2)->E2_TIPO $ MV_CPNEG
					nValor += Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")			//+E2_SDACRES-E2_SDDECRE
				Else
					If !((cAliasSE2)->E2_TIPO $ MVABATIM)
						nAbatim	  := F290VerAbt( cMarca , .F. )
						nValor    -= Moeda((E2_SALDO) - nAbatim,nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
						nTitAbats -= nAbatim
					EndIf
				EndIf
				nQtdTit--

				// GDN Novos Campos no HEADER da TELA
				nTotTit -= IIF(Alltrim(E2_TIPO)!="NDF",(cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_ACRESC-(cAliasSE2)->E2_DECRESC,0)
				nTAxTit -= IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
				nVlrDec	-= (cAliasSE2)->E2_DECRESC
				nVlrAcr -= (cAliasSE2)->E2_ACRESC
				nVlrDev -= IIF(Alltrim((cAliasSE2)->E2_TIPO)=="NDF".And.(cAliasSe2)->E2_OK=cMarca,(cAliasSE2)->E2_SALDO,0)

				// GDN Ajusta o VALOR FATURA
				nValorF := ( nTotTit - nVlrDev )
				nValorF := Iif(nValorF>0,nValorF,0)

				nValor := nValorF			
			Else
				If (cAliasSE2)->E2_TIPO $ MV_CPNEG
					nValor -= Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
				Else
					If !(E2_TIPO $ MVABATIM)
						nAbatim	:= F290VerAbt( cMarca , .T. )
						nValor  += Moeda((E2_SALDO) - nAbatim,nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
						nTitAbats += nAbatim
					EndIf
				EndIf
				nQtdTit++

				// GDN Novos Campos no HEADER da TELA
				nTotTit += IIF(Alltrim(E2_TIPO)!="NDF",(cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_ACRESC-(cAliasSE2)->E2_DECRESC,0)
				nTAxTit += IIF(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
				nVlrDec	+= (cAliasSE2)->E2_DECRESC
				nVlrAcr += (cAliasSE2)->E2_ACRESC
				nVlrDev += IIF(Alltrim((cAliasSE2)->E2_TIPO)=="NDF".And.(cAliasSe2)->E2_OK=cMarca,(cAliasSE2)->E2_SALDO,0)

				// GDN Ajusta o VALOR FATURA
				nValorF := ( nTotTit - nVlrDev )
				nValorF := Iif(nValorF>0,nValorF,0)			

				nValor := nValorF
			EndIf
			(cAliasSE2)->(dbSkip())
		EndDo
	EndIf

Return Nil

/*/{Protheus.doc} Atu_TipoValor
//TODO Agrupamento dos tipos de valores dos tÌtulos selecionado.
@author Eugenio Arcanjo
@since 12/11/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Atu_TipoValor(aTipoValor) 

	dbSelectArea('ZDS')
	ZDS->(dbSetOrder(1))
	ZDS->(dbSeek(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
	
		While ZDS->(!Eof()) .And. ;
		  	SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) == ;
	      	ZDS->(ZDS_FILIAL+ZDS_PREFIX+ZDS_NUM+ZDS_PARCEL+ZDS_TIPO+ZDS_FORNEC+ZDS_LOJA ) 

	        nPos := AScan(aTipoValor , {|x|  x[1] == ZDS->ZDS_COD  })

			IF nPos == 0
		   		aRec := {} 
		   		AAdd(aRec,ZDS->ZDS_COD)
		   		AAdd(aRec,ZDS->ZDS_VALOR)
		   		AADD(aTipoValor,aRec)
			Else 
		   		aTipoValor[nPos,02] += ZDS->ZDS_VALOR
			EndIf
		
		    ZDS->(dbSkip())
		EndDo

Return

/*/{Protheus.doc} MGFCmpNDF
//TODO Tratamentos dos tÌtulos Selecionados com NDF
@author Eugenio Arcanjo
@since 12/11/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function MGFCmpNDF(cAliasSE2,aBrowse,cMarca)
	Local aArea			:= GetArea()
	Local lRet			:= .T.
	Local nTrbRec		:= (cAliasSE2)->(Recno())
	Local nSE2Rec		:= SE2->(Recno())
	Local aRegTrb 		:= {}
	Local aRecSE2 		:= {}
	Local aRecNDF 		:= {}
	Local aFatRecNDF	:= {}
	Local nVlrABat 		:= 0
	Local lContabiliza	:= .F.
	Local lAglutina		:=.F.
	Local lDigita		:=.F.
	Local dBaixaCMP 	:= dDataBase
	Local xy			:= 1   
	Local nVlTo			:= 0
	Local nVl			:= 0
	Local _cAlias 		:= GetNextAlias()

	CursorWait()

	// Varrer o arquivo de Trabalho tratando se est· Marcado.
	(cAliasSE2)->(dbGoTop())
	While !(cAliasSE2)->(Eof())

		// Se o tÌtulo esta marcado, colocar ele no array a processar
		If (cAliasSE2)->(E2_OK) == cMarca

			// Salvo o Titulo Marcado no Array a ser processado
			AADD(aRegTrb,(cAliasSE2)->(Recno()))

			// Posiciono e Salvo o Titulo Fisico no Array a Ser Processado
			SE2->(DbGoTo((cAliasSE2)->RECNO))

			If Alltrim(SE2->(E2_TIPO))=="NDF"
				AADD(aRecNDF,SE2->(Recno()))
				AADD(aFatRecNDF,SE2->(Recno()))

				// Valor das NDFs selecionadas no Browse.
				nVlrABat+=SE2->E2_SALDO
				//Caroline Cazela - 15/01/2019
				//Colocado regra para quando for uma NDF, eu adiciono o Tipo de Valor xxx na E2 para que mostre ao usuùrio o vlr da compensaùùo
				//Consulta o tipo no ZDS tÌtulo, lù eu gravo o N˙mero da fatura e o tipo xxx

			Else
				AADD(aRecSE2,SE2->(Recno()))
			EndIf
		EndIf
		(cAliasSE2)->(dbSkip())
	EndDo  

	// Executo a FunÁ„o de CompensaÁ„o Autom·tica ( Contas a Pagar )
	If !MaIntBxCP(2,aRecSE2,,aRecNDF,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,dBaixaCMP)   
		Help("MGFNDF",1,"HELP","MGFNDF","N„o foi possÌvel a compensaÁ„o"+CRLF+" do titulo com NDF.",1,0)
	Else
		// Se tem FATURA a Gerar, gravar a Fatura na NDF.
		If !Empty(cFatura) .And. nValor > 0
			For xy:=1 to Len(aFatRecNDF)
				dbSelectArea("SE2")
				dbGoTo(aFatRecNDF[xy])
				If RecLock("SE2")
					SE2->E2_FATURA   := cFatura
					MsUnLock()
				EndIf 
				//-- Caroline Cazela 16/01/19 -> Regra para limpeza de campo E2_FATURA das NDFs
			Next xy
		EndIf

	EndIf    
	CursorArrow()
	// Volto no Alias do SE2
	SE2->(dbGoTop(nSE2Rec))

	// Volto no Alias do TRB
	(cAliasSE2)->(dbGoTop(nTrbRec))
	RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} MGFCmpNDF
//TODO Tratamentos dos tÌtulos Selecionados com NDF
@author Eugenio Arcanjo
@since 12/11/2018
@version 1.0
@return ${return}, ${return_description}

@parameters
_cFornece: cÛdigo do Fornecedor
_nOpc: 1 - Retorna a menor loja; 2 - Retorna a loja com menor CNPJ

@type function
/*/

Static Function MGFAltoLj(_cFornece,_nOpc)

	Local _cLoja
	Local _cCGC

	//Realiza a consulta da SA2 pelo codigo do fornecedor
	BeginSQL Alias "SA2TMP"
		SELECT
		A2_CGC,A2_LOJA,A2_TIPO
		FROM
		%Table:SA2% SA2
		WHERE
		SA2.A2_MSBLQL <> '1'
		AND SA2.A2_COD = %Exp:_cFornece%
		AND SA2.%notDel%
	EndSQL

	SA2TMP->(DbGoTop())
	If SA2TMP->(!EOF())
		_cLoja := SA2TMP->A2_LOJA
		_cCGC := SA2TMP->A2_CGC
		SA2TMP->(DbSkip())

		While SA2TMP->(!EOF())
			If _nOpc = 1 .And. (_cLoja > SA2TMP->A2_LOJA)
				_cLoja := SA2TMP->A2_LOJA
			ElseIf _nOpc = 2 .And. (_cCGC > SA2TMP->A2_CGC) .And. SA2TMP->A2_TIPO = 'J'
				_cCGC := SA2TMP->A2_CGC
				_cLoja := SA2TMP->A2_LOJA
			EndIf
			SA2TMP->(DbSkip())
		EndDo

	Else
		_cLoja := ' '	
	EndIf

	SA2TMP->(DbCloseArea())

Return _cLoja

/*/{Protheus.doc} fTitCtaFor
//TODO Verifica contas divergentes nos tÌtulos, na aglutinaÁ„o da fatura
@author Paulo Henrique
@since 25/10/2019
@version 1.0
@return ${return}, ${return_description}

@parameters

@type function
/*/
Static Function fTitCtaFor(aTitCtaFor)

Local lRet    := .F.
Local nRx     := 0
Local aTitFor := {}
Local cCtaFor := ""

aTitFor := aClone(aTitCtaFor)
aTitFor := ASORT(aTitFor,,,{ |x, y| x < y } )
cCtaFor := aTitFor[1][1]+aTitFor[1][2]+aTitFor[1][3]+aTitFor[1][4]+aTitFor[1][5]

For nRx := 1 to Len(aTitFor)
     
	// Verifico se o conte˙do da vari·vel "cCtaFor" È diferente do primeiro elemento do array
    If aTitFor[nRx,1]+aTitFor[nRx,2]+aTitFor[nRx,3]+aTitFor[nRx,4]+aTitFor[nRx,5] != cCtaFor
	   lRet := .T.
	   Exit
	EndIf   

	// Carrega a vari·vel com o conetudo do array sorteado
	cCtaFor := aTitFor[nRx,1]+aTitFor[nRx,2]+aTitFor[nRx,3]+aTitFor[nRx,4]+aTitFor[nRx,5]
	
Next

Return(lRet)
