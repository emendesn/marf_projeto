#include 'parmtype.ch'   
#include "topconn.ch"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "MGFFIN78.CH"
#include "apwizard.ch"
#INCLUDE 'FWBROWSE.CH'
#Include "totvs.ch" 

#define ORDEM_BROWSE    8
Static dLastPcc  := CTOD("22/06/2015")
Static lIsIssBx := FindFunction("IsIssBx")

// Gestï¿½o
Static lAbatiment := .F.
Static _oFina2901

/*/{Protheus.doc} MGFFINBV
//TODO Marcacao dos titulos para emissao de fatura - Agrupamento
@author Paulo da Mata
@since 29/07/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

/*/
@alterações 
	@author Henrique Vidal Santos @since 25/09/2020
	RTASK0011409 - Automatização de agrupamento de títulos a pagar
	1.	Na tela principal incluir um botão denominado agrupamento. Esse será responsável por chamar nova rotina.  
	2.	Apresentar tela de filtro contendo filtros de: ( Prefixo, Tipo, Vencimento e Natureza )
	3.	Apresentar tela para escolher as filiais a serem selecionadas
	4.	Apresentar tela para marcar os prefixos que não deverão ser listados para agrupamento.
	5.	Apresentar tela para filtrar os fornecedores a serem considerados no processamento. 
		a) Deverá listar somente os fornecedores que contiverem títulos a partir dos filtros realizados nos itens 1,2 e 3.
		b) Fornecedores que só possuem um título no período não serão listados.
		c) Será listados títulos de todas as lojas dos fornecedores selecionados.
		d) A gravação da fatura ocorrerá sempre na loja 01.
		e) Se a loja 01 do fornecedor estiver bloqueada, será desconsiderado os títulos de todas as lojas desse fornecedor. 
			Nesse caso deverá informar uma tela com os fornecedores bloqueados, perguntando ao usuário se deve seguir processamento para os 
			demais fornecedores
	6.	Tela : Log de verificação dos fornecedores
	a)	Caso algum desses fornecedores esteja com a loja 01 como bloqueada, o sistema deverá listar os fornecedores que se encontram nessa situação.
	b)	O Operador deverá ter a opção de abotar processo para correção do cadastro, ou seguir processamento para os demais fornecedores.  
	c)	Os títulos de fornecedores listados na tela de verificação não poderão ser listados na tela de escolha/processamento.
	7.	Apresentar tela com os títulos disponíveis conforme filtros dos itens (1,2,3,4 e 5.)
	8.	Após marcação dos títulos item 6, apresentar tela com as faturas prevista para geração
	9.	Botões de cancenlamento do processo em todas as etapas e telas do sistemas. 
/*/
User Function MGFFINBV(cAlias,cCampo,nOpcE,aFatPag,lAutomato)
	Processa({|| FINBV01(cAlias,cCampo,nOpcE,aFatPag,lAutomato)},"Aguarde...","Processando registros...",.F.)
Return

Static Function FINBV01(cAlias,cCampo,nOpcE,aFatPag,lAutomato)
	
	// Define Variaveis
	Local lPanelFin 	:= IsPanelFin()
	Local cArquivo
	Local nTotal		:= 0
	Local nHdlPrv		:= 0
	Local lPadrao		:= .F.
	Local cPadrao		:= "587"
	Local nxFat 			:= 1
	Local dDatCont 		:= dDatabase
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
	Local nTimeMsg  	:= SuperGetMv("MV_MSGTIME",,120)*1000 	// Estabelece 02 minutos para exibir a mensagem para o usuï¿½rio

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
	Local nIndSE2 		:= SE2->(IndexOrd())
	Local nRecnoSE2		:= SE2->(Recno())
	Local lContab530	:= VerPadrao("530") .And. ( mv_par03 == 1 )
	Local cKeyTit		:= ""
	Local nPCCRet		:= 0
	Local nPisRet		:= 0
	Local nCofRet		:= 0
	Local nCslRet		:= 0
	Local lCalcIssBx 	:= .F.
	Local aCps 	   		:= {}
	Local lPaBruto		:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terï¿½ o valor dos impostos descontados do seu valor
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
	Local aPcc		 	:= Array(4)
	Local nSalTit 		:= 0

	// Gestï¿½o
	Local aSelFil		:= {}
	Local aTmpFil		:= {}
	Local cTmpSE2Fil 	:= ""
	Local lGestao    	:= FWSizeFilial() > 2	// Indica se usa Gestï¿½o Corporativa
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

	Local aTitSE5   	:= {}
	Local cQuery2		:= ''
	Local cCampos		:= ''
	Local aCamposExtras	:= {}
	Local cExcep	 	:= ''
	Local _cAlias	 	:= GetNextAlias()
	Local lRetCtaFor 	:= .F. // Paulo Henrique - 25/10/2019
	Local cQryTip 		:= ""  // Paulo da Mata  - 06/08/2020
	Local nxfat 		:= 1
	Local cQryA2		:= ""
	Local cQryFor		:= "" // Query para retornar fornecedores que podem ser agrupados
	Local cQryPrf		:= "" // Query para retornar prefixos que podem ser agrupados
	Local cForVld		:= ""
	Local cQryGrpN		:= ""
	Local lCtsDif 		:= .F.
		
	Private cForExc		:= "" // Fornecedores com diveregência de dados cadastrais, em que o usário optou por não processar.
	Private cGrpVld 	:= "" // Grupo de natureza fiscal que só apareceram uma vez 
	Private cRecExcl	:= "" // Recnos de títulos que não poderam ser listado, por não conterem títulos da mesma (Natureza e fornecedor) para agrupamento.
	Private aChaveLbn 	:= {}
	Private oValor		:= 0
	Private oQtdTit		:= 0
	Private oValorFat	:= 0

	// GDN objetos novos na Tela
	Private oVlrTit		:= 0
	Private oVlrAcr		:= 0
	Private oVlrDec		:= 0
	Private oVlrDev		:= 0

	Private lPccBaixa	:= (cPaisLoc == "BRA") .And. (SuperGetMv( "MV_BX10925" ,.T.,"2") == "1") 
	Private cMarca		:= GetMark()
	Private  cEof       := Chr(13)+Chr(10)
	Private oMark
	Private cAliasSE2 	:= "TRBSE2"
	Private nInsFat		:= 0 
	Private aInsFat		:= {}
	Private aBaseIns	:= {}					 		
	Private oGet
	Private cCondicao	:= Space(3)
	Private dVctox		:= ctod('  /  /   ')
	Private nValCorr	:= 0
	Private nBasePCC	:= 0
	Private nPisFat		:= 0
	Private nCofFat		:= 0 
	Private nCslFat		:= 0 
	Private aBaseFat	:= {}
	Private aPisFat		:= {}
	Private aCofFat		:= {}
	Private aCslFat		:= {}
	Private aIrfFat		:= {}
	Private aCols		:= {}
	Private nValTot		:= 0
	Private cTipo		:= CRIAVAR("E2_TIPOFAT")
	Private cFornP		:= CRIAVAR("E2_FORNECE",.F.)
	Private cLojaP		:= CRIAVAR("E2_LOJA",.F.)
	Private nJur290	    := 0
	Private nDesc290	:= 0
	Private nBaseIrpf	:= 0
	Private aDocsOri	:= {}
	Private aDocsDes	:= {}  
	Private oMark 
	Private aBrowse    	:= {} 
	Private nTipoOrder 	:= 1                     
	Private aHeadBrow  	:= {"","Filial","Cod. Fornec","Loja","Fornecedor","Prefixo","Nr Titulo","Parcela","Tipo","Natureza",;
							"Historico","Emissao","Vencto","Vencto Real","Valor","Saldo","Acrescimo","Decrescimo","Abatimentos","Saldo Liq.",;
							"Valor do abatimento considerado na fatura", "Grupo Natureza Fiscal"}
	Private aTamBrow := {10,10,20,15,50,10,30,10,20,20,60,30,30,30,30,30,50,50,50,50,30,50}
	Private aCab      	:= ACLONE(aHeadBrow)
	Private nCol       	:= 1                                                
	Private dMenorDT   	:= CTOD('31/12/2200')
	Private cOBSSum    	:= ''
	Private nAcre1SUM  	:= 0 
	Private nAcre2SUM  	:= 0 
	Private nDecre1SUM 	:= 0 
	Private nDecre2SUM 	:= 0
	Private aTipoValor 	:= {} 
	Private cForBco    	:= '' 
	Private cFctaDv    	:= ''
	Private cForCta    	:= ''
	Private cFageDv    	:= ''
	Private cForAge    	:= ''           
	Private	bMultiFilial := .F.
	Private cFilSE2     := ''
	Private _nVlrNdf	:= 0
	Private cMoeda	 	:= ""
	Private cForne	 	:= ""
	Private cLojax	 	:= ""
	Private cTpc	 	:= ""
    Private oFatura
	Private oValTot		:= 0
	Private nValTot		:= 0

	Private oNat1
	Private oNat2

	Private cNat1 := Space(TamSX3("ED_CODIGO")[1])
	Private cNat2 := Replicate('Z' , TamSX3("ED_CODIGO")[1] )
	Private cNat := ""

	Private aHeader		:= {}

	Private cTatTip 	:= ""  // Fornecedores que não deverão ser listados
	Private cIdForne 	:= ""
	Private aErros		:= {}
    Private nPFatPrf  , nPFatNum , nPFatOrd , nPFatTip 	, nPFatVct , nPFatVlr , nPFatBco , nPFatFor , nPFatNt , nPFatRz , nPFatGrp // Variaveís para tratar posição da coluna no Array de faturas à gerar.

	Default lAutomato 	:= .F.
	
	If Type("lEmpPub") <> "L"
		lEmpPub	:= IsEmpPub()
	EndIf

	If dDatabase >= dLastPCc
		nVlMinImp	:= 0
	EndIf

	cPrefix := 'FAT'
	cTipo   := 'FT'

	// Verifica se data do movimento nï¿½o ï¿½ menor que data limite de movimentacao no financeiro 
	If !DtMovFin(,,"1")
		Return
	EndIf	

	// Verifica se se o processo serï¿½ contabilizado
	lPadrao := VerPadrao(cPadrao) .And. mv_par03 == 1

	aPcc[1]	:= .F.

	// Inicializa alias alternativo para AS400 para ser utilizado apenas no momento da gravaï¿½ï¿½o dos novos registos gerados
	
	If Select("SE2_FAT") == 0
		ChkFile("SE2",.F.,"SE2_FAT")
	Else
		dbSelectArea("SE2_FAT")
	EndIf
	
	cAliasGRV := "SE2_FAT"

	/*
	POR MAIS ESTRANHO QUE PAREï¿½A, ESTA FUNCAO DEVE SER CHAMADA AQUI!
	                                                                 
	A Funï¿½ï¿½o SomaAbat reabre o SE2 com outro nome pela ChkFile para
	efeito de performance. Se o alias auxiliar para a SumAbat() nï¿½o
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
	cFornFat  := SPACE(TamSX3("E2_FORNECE")[1])
	cLoja	  := SPACE(TamSX3("E2_LOJA")[1])

	// Tratamento necessario devido os parametros enviados pela MBrowse
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
	// [13,5] tï¿½tulo localizado na geracao de fatura (lï¿½gico). Iniciar com falso.
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
			cFatura	:= GetMv("MV_NUMFATP")
		EndIf

		cFatAnt	:= cFatura

		// Inicializaï¿½ï¿½o das variï¿½veis da fatura
		aSize := MSADVSIZE()

		DEFINE MSDIALOG oDlg FROM 22,9 TO 245,540 TITLE "Faturas a Pagar" PIXEL 
		nEspLarg := 5
		nEspLin  := 2
			cPrefix := 'FAT'
		cTipo   := 'FT'

		oDlg:lMaximized := .F.
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT

		@ 004+nEspLin, nEspLarg TO 036+nEspLin, 218+nEspLarg OF oPanel PIXEL
		@ 038+nEspLin, nEspLarg TO 070+nEspLin, 218+nEspLarg OF oPanel PIXEL
		@ 072+nEspLin, nEspLarg TO 104+nEspLin, 218+nEspLarg OF oPanel PIXEL

		nEspLarg := nEspLarg - 7

		// Tipo da Fatura
		@ 020+nEspLin, 014+nEspLarg MSGET cPrefix	Pict cPictPref SIZE 10, 11 OF oPanel PIXEL
		@ 020+nEspLin, 040+nEspLarg MSGET oTipo VAR cTipo F3 "05" Pict "@!" Valid If(nOpca<>0,(!Empty (cTipo) .And. FA290Tipo(@cTipo)),.T.) SIZE 10, 11 OF oPanel PIXEL HASBUTTON
		oTipo:cReadVar := "E2_TIPOFAT"

		// Numero da Fatura
		@ 020+nEspLin, 075+nEspLarg MSGET oFATURA VAR cFatura Valid If(nOpca<>0,!Empty(cFatura),.T.) SIZE 42, 11 OF oPanel PIXEL  When .F.
			
		// Moeda
		@ 020+nEspLin, 120+nEspLarg MSCOMBOBOX oCbx VAR cVar ITEMS aMoedas 	SIZE 46, 55 OF oPanel PIXEL

		// Periodo - Vencimento
		@ 054+nEspLin, 014+nEspLarg MSGET dDataDe	VALID If(nOpca<>0,F290VLDDT("DataDe", dDataDe),.T.)	 SIZE 50, 11 OF oPanel PIXEL HASBUTTON
		//@ 054+nEspLin, 068+nEspLarg MSGET dDataAte	Valid If(nOpca<>0,F290VLDDT("DataAte", dDataDe, dDataAte),.T.)  SIZE 50, 11 OF oPanel PIXEL HASBUTTON
		@ 054+nEspLin, 068+nEspLarg MSGET dDataAte	 SIZE 50, 11 OF oPanel PIXEL HASBUTTON

		// Dados da Natureza 
		@ 088+nEspLin, 014+nEspLarg MSGET oNat1	VAR cNat1 F3 "SED" Valid ExistCpo("SED",cNat1) .Or. Empty(cNat)  SIZE 50, 11 OF oPanel PIXEL HASBUTTON
		@ 088+nEspLin, 068+nEspLarg MSGET oNat2	VAR cNat2 F3 "SED" Valid IIF (cNat2 == Replicate('Z',TamSX3("ED_CODIGO")[1]) , .T. , ExistCpo("SED",cNat2) ) SIZE 50, 11 OF oPanel PIXEL HASBUTTON

		// Cabeï¿½alho 01 
		@ 010+nEspLin, 014+nEspLarg SAY "Prefixo" 	SIZE 20, 7 OF oPanel PIXEL
		@ 010+nEspLin, 040+nEspLarg SAY "Tp" 		SIZE 12, 7 OF oPanel PIXEL
		@ 010+nEspLin, 075+nEspLarg SAY "Fatura Anterior" SIZE 49, 7 OF oPanel PIXEL
 		@ 010+nEspLin, 120+nEspLarg SAY "Moeda"		SIZE 25, 7 OF oPanel PIXEL

		// Cabeï¿½alho 02
		@ 044+nEspLin, 014+nEspLarg SAY OemToAnsi("Vencimento de") 				SIZE 40, 7 OF oPanel PIXEL
		@ 044+nEspLin, 068+nEspLarg SAY OemToAnsi("Vencimento Até") 			SIZE 40, 7 OF oPanel PIXEL

		// Cabeï¿½alho 03
		@ 078+nEspLin, 014+nEspLarg SAY OemToAnsi("Natureza de")		 SIZE 35, 7 OF oPanel PIXEL
		@ 078+nEspLin, 068+nEspLarg SAY OemToAnsi("Natureza Até") 		 SIZE 35, 7 OF oPanel PIXEL

 		aCps := {"cPrefix","cFatura","cNat1","cNat2"}
                                                               
		DEFINE SBUTTON FROM 07, 230 TYPE 1 ACTION (nOpca:=0,IF(If(FA290NUMQ(cFatAnt),FA290TOk() .And. F290VlCposQ(aCps) ,.F.),nOpca:=1,nOpca:=2),oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 21, 230 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg CENTERED
	
	EndDo

	If(nOpca<>1,nOpca:=0,.T.)

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
	

	/* Henrique Vidal 
	 a) Executa a Query MGFINCHK() , retornando quais fornecedores possuem mais de um título para agrupamento.
	 b) Fornecedores que só possuem um título no período não serão listados.
	 c) Será listados títulos de todas as lojas dos fornecedores selecionados.
	 d) A gravação da fatura ocorrerá sempre na loja 01, conforme premissa da RTASK0011409.
	 e) Se a loja 01 do fornecedor estiver bloqueada, será desconsiderado os títulos  de todas as lojas desse fornecedor. 
	 f) Nesse caso deverá informar uma tela com os fornecedores bloqueados, perguntando ao usuário se deve seguir processamento para os 
	   demais fornecedores. */

	cQryFor	:= U_MGFINCHK(aSelFil,aTmpFil,cTmpSE2Fil,aStru, 1)
	cQryFor := ChangeQuery(cQryFor)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryFor),"QRY_FOR",.T.,.F.)
	dbSelectArea("QRY_FOR")

	IncProc("Coletando dados... " )
	QRY_FOR->(dbGoTop())
	While QRY_FOR->(!Eof())
		
		cBloq 	:= RetField("SA2",1,XFILIAL("SA2")+QRY_FOR->E2_FORNECE+"01","A2_MSBLQL")
					
		If cBloq == '1'
			AADD(aErros , {'Cadastro' ,"Fornecedor : " + QRY_FOR->E2_FORNECE + "-" + "01" + ' - ' + RetField("SA2",1,XFILIAL("SA2")+QRY_FOR->E2_FORNECE+"01","A2_NOME") + " não habilitado. Títulos deste fornecedor não serão agrupados. "})
		Else
			cForVld += Iif( !Empty(cForVld) , ",'" , "'" ) + QRY_FOR->E2_FORNECE + "'"		
		EndIf 

		QRY_FOR->(dbSkip())
	End  
	QRY_FOR->(dbCloseArea())
	
	If !Empty(aErros)
		lContinua := MostraErr(aErros , "Validação de fornecedores ativos ")

		If !lContinua
			MsgInfo("Processo abortado pelo operador.")
			Return 
		EndIf 
	EndIf 

	IF Empty(cForVld)
		MsgInfo("Não há títulos para os parâmetros informados.")
		Return 
	EndIf 

	cQryA2	:= "SELECT A2_COD , A2_LOJA , A2_NOME "
	cQryA2  += "  FROM " +  RetSqlName("SA2") + " SA2 " 
	cQryA2	+= "  WHERE SA2.D_E_L_E_T_ = ' ' "
	cQryA2 += "	  AND A2_COD IN(" + cForVld + ") AND A2_LOJA = '01' "  // Gravação ocorerá sempre na loja 01. 
	If !Empty(cForExc)
		cQryA2 += "	  AND A2_COD NOT IN(" + cForExc + ") "
	EndIf
	cQryA2	+= "  ORDER BY A2_NOME "
	aCpoA2	:=	{	{ "A2_COD"		,"Código"			, 040	} ,;
	aCpoA2	:=		{ "A2_LOJA"		,"Loja"				, 020	} ,;
	aCpoA2	:=		{ "A2_NOME"		,"Razão Social"		, 080	}	} 
	cTitSolici	:= "Marque os Códigos de fornecedores à serem agrupados: "
	nPosRetorn	:= 1		
	_lCancProg	:= .T. 		
	cIdForne	:= U_Array_In( U_MarkGene(cQryA2, aCpoA2, cTitSolici, nPosRetorn, @_lCancProg ) )
	
	IF Empty(cIdForne)  // Garatindo regra da função _MarkGene() Mark All
		cIdForne := "(" + cForVld + ")"
	EndIf

	If _lCancProg
		Return
	Endif 

	cQryPrf	:= U_MGFINCHK(aSelFil,aTmpFil,cTmpSE2Fil,aStru, 2) //2ª Chamada retorna dados dos prefixos

	aCpoTip	:=	{{ "E2_PREFIXO", U_X3Titulo("E2_PREFIXO"), TamSx3("E2_PREFIXO")[1]}} 

	cTitTip	  	:= "EXCETO PREFIXOS - Selecione os prefixos que não devem ser agrupados: "
	nPosRetorn	:= 1

	lCancProg := .T.
	cTatTip   := U_Array_In( U_MarkGene(cQryPrf, aCpoTip, cTitTip, nPosRetorn, @lCancProg ) )

	If lCancProg
		Return
	EndIf

	/* Trata títulos que não poderam ser listado para agrupamento, devido não conter demais títulos com a mesma natureza e fornecedor
	   Verifica grupo de natureza fiscal de cada fornecedor, e exclui títulos onde a natureza é apresentada uma unica vez.
	*/
	cQryGrpN := U_MGFINCHK(aSelFil,aTmpFil,cTmpSE2Fil,aStru, 3)  
	cQryGrpN := ChangeQuery(cQryGrpN)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryGrpN),"QRY_GRPN",.T.,.F.)
	dbSelectArea("QRY_GRPN")

	IncProc("Coletando dados naturezas fiscais... " )
	QRY_GRPN->(dbGoTop())
	While QRY_GRPN->(!Eof())
		cGrpVld += Iif( !Empty(cGrpVld) , ",'" , "'" ) + Alltrim(QRY_GRPN->CHVGRPNAT) + "'"		
		QRY_GRPN->(dbSkip())
	End  
	QRY_GRPN->(dbCloseArea())

	If !Empty(cGrpVld)
		cQuery 		:= U_MGFINCHK(aSelFil,aTmpFil,cTmpSE2Fil,aStru, 4)  
		cQuery 		:= STRTRAN(cQuery,',E2_OK','')
		cQuery 		:= STRTRAN(cQuery,'SELECT E2_FILIAL','SELECT E2_OK,E2_FILIAL')
		
		cQry := Substr(cQuery,at("SELECT",cQuery)+ Len("SELECT") + 1 ,Len(cQuery))
		cQry := " SELECT E2_FORNECE ,  " + cQry 
		cQry := ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"Q_TITEXC",.T.,.F.)
		dbSelectArea("Q_TITEXC")

		Q_TITEXC->(dbGoTop())

		While Q_TITEXC->(!Eof())
		
			If Q_TITEXC->E2_FORNECE + Alltrim(Q_TITEXC->GRPNAT) $ cGrpVld
				cRecExcl += Iif( !Empty(cRecExcl), ",'" , "'" ) + cValtoChar(Q_TITEXC->RECNO) + "'"
			EndIf 
			Q_TITEXC->(dbSkip())
		End  
		Q_TITEXC->(dbCloseArea())

	EndIf 

	//4ª Chamada retorna dados dos títulos para tratar erros cadastrais
	cQuery 		:= U_MGFINCHK(aSelFil,aTmpFil,cTmpSE2Fil,aStru, 4)  
	cQuery 		:= STRTRAN(cQuery,',E2_OK','')
	cQuery 		:= STRTRAN(cQuery,'SELECT E2_FILIAL','SELECT E2_OK,E2_FILIAL')
	aErros		:= MgfChkCad(cQuery)  // Checa regra de cadastros antes 

	If !Empty(aErros)
		lContinua := MostraErr(aErros, "Validação de dados cadastrais ")

		If !lContinua
			MsgInfo("Processo abortado pelo operador.")
			Return 
		EndIf 
	EndIf 

	IncProc("Consultando dados...")
	aStru 		:= SE2->(DbStruct())
	cAliasSE2 	:= "TRBSE2"
	cOrdem 		:= SE2->(INDEXKEY(INDEXORD()))
	cQuery 		:= U_MGFINCHK(aSelFil,aTmpFil,cTmpSE2Fil,aStru, 4)  //4ª Chamada retorna dados dos títulos
	cQuery 		:= STRTRAN(cQuery,',E2_OK','')
	cQuery 		:= STRTRAN(cQuery,'SELECT E2_FILIAL','SELECT E2_OK,E2_FILIAL')

	Aadd( aStru , { "RECNO"  , "N" , 10 , 0 } )
	Aadd( aStru , { "GRPNAT" , "C" , 50 , 0 } )
				
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

	// Criaï¿½ï¿½o da Tabela Temporï¿½ria
	MsErase(cAliasSE2)

	_oFina2901 := FWTemporaryTable():New( cAliasSe2 )  
	_oFina2901:SetFields(aStru) 
	_oFina2901:AddIndex("1", {"E2_FILIAL","E2_FORNECE","E2_LOJA","E2_PREFIXO","E2_NUM","E2_PARCELA","E2_TIPO"})

	// Data: 17/12/18 - Solicitaï¿½ï¿½o Eric, colocar o TIPO na primeira ORDEM para trazer todas as NDFs juntos
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

		// Deleta tabela Temporï¿½ria criada no banco de dados
		If _oFina2901 <> Nil
			_oFina2901:Delete()
			_oFina2901 := Nil
		EndIf

		// Gestï¿½o
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
	Utiliza os capos em uso do SE2 mais o E2_SALDO que apesar de nï¿½o estar em uso deve ser mostrado na tela.
	*/ 

	AADD(aCampos,{"E2_OK","","  ",""})

	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(MsSeek(cAlias))

	/* Paulo da Mata
	ordenar os campos conforme MIT
	filial, prefixo, tipo, natureza, nr titulo, acrescimmo, descrescimo, abatimentos, sald liquido, dt emissao, vencimento
	vencto real, fornecedor,loja, nome fornec, vlr titulo, saldo, historico
	Trocar esta ordem 25/08/2020
	E2_FILIAL,E2_FORNECE,E2_LOJA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO
	*/

	AADD(aCampos,{"E2_FILIAL ","","Filial",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_FORNECE","","Cod. Fornec",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_LOJA   ","","Loja",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_NOMFOR ","","Fornecedor",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_PREFIXO","","Prefixo",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_NUM    ","","Nr Titulo",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_PARCELA","","Parcela",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_TIPO   ","","Tipo",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_NATUREZ","","Natureza",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_HIST   ","","Historico",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_EMISSAO","","Emissao",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_VENCTO ","","Vencto",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_VENCREA","","Vencto Real",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_VALOR  ","","Valor",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_SALDO  ","","Saldo",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_ACRESC ","","Acrescimo",SX3->X3_PICTURE})
	AADD(aCampos,{"E2_DECRESC","","Decrescimo",SX3->X3_PICTURE})
	aAdd(aCampos,{cCampoAbat,"","Abatimentos","@E 999,999,999.99"})
	AADD(aCampos,{"E2_SALDO ","","Saldo Liq.",SX3->X3_PICTURE})
	aAdd(aCampos,{"ABATSOMADO","","Valor do abatimento considerado na fatura","@E 999,999,999.99"})
	aAdd(aCampos,{"GRPNAT","","Grupo Natureza Fiscal","@!"})

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
			IW_MSGBOX("Existem tï¿½tulos que nï¿½o foram localizados na geraï¿½ï¿½o da fatura",,"Atenï¿½ï¿½o",'STOP')
			
			// Recupera a Integridade dos dados
			FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
			dbSelectArea("SE2")
			RetIndex( "SE2" )
			
			// Restaura o filtro
			Set Filter To &cSetFilter.
			dbSelectArea(cAliasSe2)
			DbCloseArea()

			// Deleta tabela Temporï¿½ria criada no banco de dados
			If _oFina2901 <> Nil
				_oFina2901:Delete()
				_oFina2901 := Nil
			EndIf

			// Gestï¿½o
			For nX := 1 TO Len(aTmpFil)
				CtbTmpErase(aTmpFil[nX])
			Next

			dbSelectArea("SE2")
			Return(.F.)
		EndIf		
		nOpca := 1
	Else  

		// Faz o calculo automatico de dimensoes de objetos
		GerDadAgr()

		nQtdTotTit := Len(aBrowse)

		aSize := MSADVSIZE()
		oSize := FWDefSize():New(.T.)
		oSize:AddObject("MASTER",100,100,.T.,.T.)
		oSize:lLateral := .F.				
		oSize:lProp := .T.

		oSize:Process()

		DEFINE MSDIALOG oDlg1 TITLE "Fatura a Pagar" PIXEL FROM oSize:aWindSize[1],oSize:aWindSize[2] To oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd
		oTimer:= TTimer():New((nTimeOut-nTimeMsg),{|| MsgTimer(nTimeMsg,oDlg1) },oDlg1) // Ativa timer
		oTimer:Activate()  

		nLinIni := oSize:GetDimension("MASTER","LININI")
		nColIni := oSize:GetDimension("MASTER","COLINI")
		nLinFin := oSize:GetDimension("MASTER","LINEND")
		nColFin := oSize:GetDimension("MASTER","COLEND")

		@ nLinIni + 001, 002  To nLinIni+033,nColFin PIXEL OF oDlg1

		@ nLinIni + 008 , 005		SAY OemToAnsi("Prefixo: ") + cPrefix 				  FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 017 , 005		Say OemToAnsi("Fat. Ant.: ") + cFatura 				  FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 008 , 080		SAY OemToAnsi("Natureza: ") + Substr(cNat,1,10)		  FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 017 , 080		SAY OemToAnsi("Moeda: ") + AllTrim(Str(nMoeda,2,0)) FONT oDlg1:oFont PIXEL Of oPanel

		//==========================================//
		// GDN NOVOS TOTALIZADORES NA TELA          //
		// GAP 585                                  //
		//==========================================//

		// GDN - Refazer a apresentaï¿½ï¿½o dos campos na TELA mudar posiï¿½ï¿½o do cpo Tit Selec.
		@ nLinIni + 008 , 135	Say OemToAnsi("Total Tit.") FONT oDlg1:oFont PIXEL Of oPanel	
		@ nLinIni + 017 , 140	Say oTotQtdTit VAR nQtdTotTit Picture "999999" FONT oDlg1:oFont PIXEL Of oPanel

		@ nLinIni + 008 , 170	Say OemToAnsi("Tít. Selec.") FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 017 , 178	Say oQtdTit VAR nQtdTit Picture "999999"  FONT oDlg1:oFont PIXEL Of oPanel

		// GDN - Incluir Novos Campos 
		@ nLinIni + 008 , 200	Say OemToAnsi("Vlr.Tit.Origem") FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 017 , 200	Say oVlrTit  VAR nTAxTit 	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 008 , 250	Say OemToAnsi("Vlr.Acresc.") FONT oDlg1:oFont PIXEL Of oPanel	
		@ nLinIni + 017 , 250	Say oVlrAcr  VAR nVlrAcr 	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 008 , 300	Say OemToAnsi("Vlr.Decres.") FONT oDlg1:oFont PIXEL Of oPanel	
		@ nLinIni + 017 , 300	Say oVlrDec  VAR nVlrDec 	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel
		@ nLinIni + 008 , 350	Say OemToAnsi("Vlr.Devoluções") FONT oDlg1:oFont PIXEL Of oPanel	
		@ nLinIni + 017 , 350	Say oVlrDev  VAR nVlrDev 	  Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL Of oPanel

		// Campos jï¿½ que existiam na tela Manter o Valor Fatura
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
		oBrowseDados:bLDblClick := {|| xMudaStatus(1)}         
		oBrowseDados:addColumn(TCColumn():new(aCab[01],{||IIf(aBrowse[oBrowseDados:nAt,01],oOK,oNO)},"@!" ,,,"LEFT" , 1,.T.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[02],{||aBrowse[oBrowseDados:nAt][02]},"@!" ,,,"LEFT"  ,aTamBrow[02],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[03],{||aBrowse[oBrowseDados:nAt][03]},"@!" ,,,"LEFT"  ,aTamBrow[03],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[04],{||aBrowse[oBrowseDados:nAt][04]},"@!" ,,,"LEFT"  ,aTamBrow[04],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[05],{||aBrowse[oBrowseDados:nAt][05]},"@!" ,,,"LEFT"  ,aTamBrow[05],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[06],{||aBrowse[oBrowseDados:nAt][06]},"@!" ,,,"LEFT"  ,aTamBrow[06],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[07],{||aBrowse[oBrowseDados:nAt][07]},"@!" ,,,"LEFT"  ,aTamBrow[07],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[08],{||aBrowse[oBrowseDados:nAt][08]},"@!" ,,,"LEFT"  ,aTamBrow[08],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[09],{||aBrowse[oBrowseDados:nAt][09]},"@!" ,,,"LEFT"  ,aTamBrow[09],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[10],{||aBrowse[oBrowseDados:nAt][10]},"@!" ,,,"LEFT"  ,aTamBrow[10],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[11],{||aBrowse[oBrowseDados:nAt][11]},"@!" ,,,"LEFT"  ,aTamBrow[11],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[12],{||aBrowse[oBrowseDados:nAt][12]},"@!" ,,,"LEFT"  ,aTamBrow[12],.F.,.F.,,,,,)) // data 
		oBrowseDados:addColumn(TCColumn():new(aCab[13],{||aBrowse[oBrowseDados:nAt][13]},"@!" ,,,"LEFT"  ,aTamBrow[13],.F.,.F.,,,,,)) //data 
		oBrowseDados:addColumn(TCColumn():new(aCab[14],{||aBrowse[oBrowseDados:nAt][14]},"@!" ,,,"LEFT"  ,aTamBrow[14],.F.,.F.,,,,,)) //data 
		oBrowseDados:addColumn(TCColumn():new(aCab[15],{||aBrowse[oBrowseDados:nAt][15]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[15],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[16],{||aBrowse[oBrowseDados:nAt][16]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[16],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[17],{||aBrowse[oBrowseDados:nAt][17]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[17],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[18],{||aBrowse[oBrowseDados:nAt][18]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[18],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[19],{||aBrowse[oBrowseDados:nAt][19]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[19],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[20],{||aBrowse[oBrowseDados:nAt][20]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[20],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[21],{||aBrowse[oBrowseDados:nAt][21]},"@E 999,999,999.99" ,,,"RIGHT" ,aTamBrow[21],.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(aCab[22],{||aBrowse[oBrowseDados:nAt][22]},"@!" ,,,"LEFT"  ,aTamBrow[22],.F.,.F.,,,,,)) //Grp natureza fiscal

		// Colunas Anteriores dos botoes 355,410,465,520
		// GDN - Novo posicionamento dos botï¿½es na Tela
		oBtn := TButton():New( nLinIni + 005, 530 ,'Marcar Todas'    , oDlg2,{|| xMudaStatus(3)}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )        
		oBtn := TButton():New( nLinIni + 005, 585 ,'Desmarcar Todas' , oDlg2,{|| xMudaStatus(2)}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   

		oBtn := TButton():New( nLinIni + 020, 530 ,'Inverte seleção' , oDlg2,{|| xMudaStatus(1)}     ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )        
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

		// GDN Somente apresento a Tela de FATURA se nï¿½o TEM NDF e Tem Valor
		If  nValor > 0

			nOpcA := 0

			If lCtrlAlc
				MsgInfo("Para a fatura serï¿½ adotado o aprovador padrï¿½o para a moeda: " + AllTrim(Str(nMoeda)) + ".","Controle de alï¿½adas ativo" )
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
				aCols := GrvDupQ(nDup,cPrefix,cFatura,nValor,dDatabase,aVenc,lFatAut)
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

				@ 025,015 Say 'Parcelas' Of oPanel1 Pixel                                      
				@ 025,047 MSGET cCond   Picture "999" Of oPanel1 Pixel Hasbutton Valid cCond > 0 when .F. //nVlrDev = 0

				@ 007,015 Say 'Alterar vcto' Of oPanel1 Pixel                                      
				@ 013,015 Say '(Opcional)' Of oPanel1 Pixel                                      
				@ 007,047 MSGET dVctox    SIZE 040, 010 Pixel 

				DEFINE SBUTTON FROM 025,085	TYPE 1 ACTION (If(!Empty(cCond)	.And. cCond > 0,;
				nOpca:=FSelFatQ(oDlg2,1,@cCond,@nTAxTit,@nValTot,@aVenc,@cPrefix,@cFatura,@cTipo,dDatCont,oPanel2,oPanel1),;
				nOpca:=0)) ENABLE OF oPanel1

				If lPanelFin
					ACTIVATE MSDIALOG oDlg2 ON INIT FaMyBar(oDlg2,;
					{||nOpca:=1, If( valtype(oget)=="O",if(oGet:TudoOk() .And. Len(aCols) > 0,oDlg2:End(),nOpca := 0), nOpca := 0)},;
					{||oDlg2:End()})																												
				Else				
					ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||nOpca:=1, If( valtype(oget)=="O",if(oGet:TudoOk() .And. Len(aCols) > 0,oDlg2:End(),nOpca := 0), nOpca := 0)},{||oDlg2:End()})
				EndIf				                                  

				cCondicao := If(nOpca=0,1,cCond)
			EndIf

		EndIf

		// Inicia a TRANSACAO para Gerar os Titulos Necessï¿½rios
		// SE2, SE5, FK2, FK6, FK7, FKA, contabilizaï¿½ï¿½oe atualiza saldos em SA2.
		Begin Transaction

			//==========================================//
			// GDN TRATAMENTO ESPECIAL PARA O TIPOS NDF //
			// GAP 618                                  //
			//==========================================//
			lProcNDF := .F.

			If nOpcA == 1 .And. lMarkNDF 
				lProcNDF := MGFCmpNDF(cAliasSE2,aBrowse,cMarca) //MGCmpNDF
			EndIf

			CursorWait()

			// Criar a fatura
			If nOpcA == 1 .And. nValor > 0

				For nxfat := 1 to Len (aCols) 

					/*Henrique Vidal - Recarregar variaveis para gravar prox. títulos.
					                   Forçar fornecedor como 01 - RTASK0011409 */
					aTipoValor := {}
					nHdlPrv	   := 0
					aRastroOri := {}
					aRastroDes := {}
					aDocsOri   := {}
					aDocsDes   := {}
					aPcc	   := Array(4) 
					cOBSSum	   := "" 

					cFatura  := aCols[nxFat][nPFatNum] 
					cFornFat := aCols[nxFat][nPFatFor] 
					cLoja	 := '01'
					cNat 	 := aCols[nxFat][nPFatNt] 
					cGrpNat	 := aCols[nxFat][nPFatGrp] 
					
					cParcela := aCols[nxFat][nPFatOrd ]
					cTipo    := aCols[nxFat][nPFatTip ]
					cVencmto := aCols[nxFat][nPFatVct ]
					nValDup	 := aCols[nxFat][nPFatVlr]
					nValCruz := xMoeda(aCols[nxFat,nPFatVlr],nMoeda,1,dDataBase)
					cBanco	 := aCols[nxFat][nPFatBco ]

					nVlrTit 	:= 0
					nPisRet		:= 0
					nCofRet		:= 0
					nCslRet		:= 0
					nBasePCC	:= 0
					nPisFat		:= 0
					nISSFat		:= 0
					nValCorr	:= 0
					nBasePCC	:= 0
					nBaseRet	:= 0
					nValCorr	:= 0
					nTotIRPJ	:= 0
					nBaseIrf	:= 0
					nBaseIrpf	:= 0
					nDecre1SUM	:= 0
					nDecre2SUM	:= 0
					nAcre1SUM 	:= 0 
					nAcre2SUM 	:= 0
					cCamposE5 	:= ""
					cLog		:= ""
					nTRetISS 	:= 0
					cSequencia 	:= Replicate("0",nTamSeq)
					aFlagCTB 	:= {} 
					nOldPis 	:= 0
					nOldCof 	:= 0
					nOldCsl 	:= 0
					nTotal		:= 0
					nPisFat 	:= 0
					nCofFat 	:= 0
					nCslFat 	:= 0
					nPropIR		:= 1
					cTitpai		:= ""
					lDirf		:= .F. 
					cContaDB	:= ""
					aE2CCC     	:= {}
					aE2CCD     	:= {}
					cCCC	  	:= ""
					cCCD	  	:= ""
					lCtsDif 	:= .F.
					cForBco    	:= '' 
					cFctaDv    	:= ''
					cForCta    	:= ''
					cFageDv    	:= ''
					cForAge    	:= '' 
					_cTpFil	 	:= ""
					ABATIMENTO 	:= 0

					lBaseIRPF	:= .F.
					lCompNdf	:= .F. 
					lCtsDif 	:= .F.
					lIrpfBaixa	:=  SA2->A2_CALCIRF == "2"
					aTitSE5		:= {}

					cOldIns	  	:= ""
					cCCUSTO 	:= ""
					nFRetISS 	:= ""

					nSalTit		:= 0
					nBaseFat	:= 0
					nInsFat 	:= 0
					nOldIns  	:= 0
					nOldVret  	:= 0


					nJur290	  	:= 0
					nDesc290  	:= 0
					_nVlrNdf  	:= 0
					nVlMinImp 	:= 0

					/*Fim do bloco tarefa RTASK0011409*/

					STRLCTPAD		:= ""		// para contabilizar o historico do LP
					nTotAbat		:= 0
					bMultiFilial	:= .F.		// Variavel para informar se foram selecionado tï¿½tulo de mais de uma filial. Se sim, gerarï¿½ a fatura na matriz '010001'
					cFilSE2 		:= ''		// Filial para geraï¿½ï¿½o da Fatura 

					//Caso encontre algum tï¿½tulo com conta divergente dos demais, pergunta se continua ou nï¿½o a geraï¿½ï¿½o da Fatura.
					lPergCta		:= .T.
					lMultCta		:= .F.

					dbSelectArea( cAliasSE2 )

					cChv01     := ""
					cChv02     := ""

					dbGotop()
					ProcRegua((cAliasSE2)->(RecCount()))

					// Tratamento padrï¿½o caso nï¿½o tenha NDF selecionada, manter o processo como estï¿½.

					While !(cAliasSE2)->(Eof())

						IncProc("Processando título " + SE2->E2_NUM )
						// NESTE PONTO ELE COMEï¿½A A AVALIAR OS REGISTROS MARCADOS
						If (cAliasSE2)->E2_OK == cMarca .and. (cAliasSE2)->E2_FORNECE == cFornFat  .and. (cAliasSE2)->GRPNAT == cGrpNat

							If Empty(cForBco)
								cForBco    	:= (cAliasSE2)->E2_FORBCO 
								cFctaDv    	:= (cAliasSE2)->E2_FCTADV
								cForCta    	:= (cAliasSE2)->E2_FORCTA
								cFageDv    	:= (cAliasSE2)->E2_FAGEDV
								cForAge    	:= (cAliasSE2)->E2_FORAGE 
							ElseIf cForBco <> E2_FORBCO
								lCtsDif := .T.
							EndIf 

							cFilOrig := SE2->E2_FILORIG
							cNumero  := SE2->E2_NUM
							cPrefixo := SE2->E2_PREFIXO
							cParcela := SE2->E2_PARCELA
							cMoeda	 := SE2->E2_MOEDA
							cForne	 := SE2->E2_FORNECE
							cLojax	 := SE2->E2_LOJA
							cTpc	 := SE2->E2_TIPO

							//Informar se foram selecionado tï¿½tulo de mais de uma filial. Se sim, gerarï¿½ a fatura na matriz '010001'
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

							nX := SE2->(RecNo()) // Variavel nX ï¿½ o RECNO da TABELA FISICA DO SE2

							// Gravar o Histï¿½rico correto na FATURA
							cHistFat := (cAliasSE2)->E2_HIST

							IF SE2->E2_EMISSAO < dMenorDT
								dMenorDT := SE2->E2_EMISSAO
							EndIf 

							IF !Empty(SE2->E2_XOBS)
								cOBSSum += Alltrim(SE2->E2_XOBS)+' / '
							EndIf

							//==========================================
							//Inicio da geraï¿½ï¿½o do tipos de valores.
							//==========================================
							
							// 02/Abril/2019 - Natanael Filho: Se o tï¿½tulo sofreu baixa, nï¿½o serï¿½ considerado os tipos de valores.
							If SE2->E2_VALLIQ == 0
								
								_nVlrNdf := SE2->E2_VALOR

								IF SE2->E2_SDACRES <> 0
								
								// Paulo Henrique - TOTVS - 28/08/2019
								// Se a fatura foi parcelada, faz o calculo proporcional do acrï¿½scimo
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
								// Se a fatura foi parcelada, faz o calculo proporcional do decrï¿½scimo
								If cCond > 1
									nDecre1SUM += SE2->E2_DECRESC / cCond
									nDecre2SUM += SE2->E2_SDDECRE / cCond
								Else 
									nDecre1SUM += SE2->E2_DECRESC
									nDecre2SUM += SE2->E2_SDDECRE
								EndIf 

								EndIf 
								
								// Agrupamento de Tipo de Valor do tïtulo
								IF (SE2->E2_SDACRES <> 0 .Or. SE2->E2_SDDECRE <> 0)
									Atu_TipV(aTipoValor) 
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
							// FIM da geraï¿½ï¿½o do tipos de valoes.
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
											__SE2->E2_FATFOR	:= IIF(mv_par01 == 1,cFornFat,cFornP)
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
							// Se tem Saldo e TIPO nï¿½o estï¿½ nos tipos ABATIMENTO 
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

								// Busca a NATUREZA do tï¿½tulo marcado.
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
										(SE2->E2_BASEPIS > nVlMinImp .Or.; //Somar se o titulo nï¿½o for menor que 5000 que os impostos nï¿½o tenham sido retidos. 
											(SE2->E2_BASEPIS <= nVlMinImp .And.; 
											SE2->E2_PRETCSL $ " 43" .And. ;
											SE2->E2_PRETCOF $ " 43" .And. ;
											SE2->E2_PRETPIS $ " 43") ) 
										nVlrTit	+= SE2->(E2_PIS+E2_COFINS+E2_CSLL)
									EndIf

									If !lCalcIssBx
										nVlrTit	+= SE2->E2_ISS
									EndIf

									nBaseFat +=	(nVlrTit - nBaseRet) // Remontar a base do titulo que jï¿½ foi retido.

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
								Se jï¿½ houve qualquer baixa parcial, os campos de acrescimo e decrescimo 
								jï¿½ foram considerados
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
								SE2->E2_FATFOR  := IIF(mv_par01 == 1,cFornFat,cFornP)
								SE2->E2_FATLOJ  := IIF(mv_par01 == 1,cLoja,cLojaP)

								// Zero os impostos para que nï¿½o sejam contabilizados neste momento
								// Somente o serï¿½o na baixa do titulo gerado pela fatura.
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

								//Atualiza integraï¿½ï¿½o com Manutenï¿½ï¿½o de Ativos
								If SuperGetMV("MV_NGMNTFI",.F.,"N") == "S"  .And. FindFunction("NGVALPGTRX")
									NGVALPGTS1( SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,'',SE2->E2_VALLIQ )
									NGVALPGTRX( SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,'',SE2->E2_VALLIQ )
								EndIf

								dbSelectArea("SE2")

								// Tira o saldo do vencimento programado do titulo
								AtuSldNat(SE2->E2_NATUREZ,SE2->E2_VENCREA,SE2->E2_MOEDA,"2","P",SE2->E2_VALLIQ,xMoeda(SE2->E2_VALLIQ, SE2->E2_MOEDA,1),"-",,FunName(),"SE2",SE2->(Recno()),nOpcE)

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

								// Define os campos que nï¿½o existem nas FKs e que serï¿½o gravados apenas na E5, para que a gravaï¿½ï¿½o da E5 continue igual
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
								oModelBxP:SetValue( "MASTER", "E5_GRV", .T. ) //Informa se vai gravar SE5 ou nï¿½o
								oModelBxP:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serï¿½o gravados indepentes de FK5
								oModelBxP:SetValue( "MASTER", "NOVOPROC", .T. ) //Informa que a inclusï¿½o serï¿½ feita com um novo Nï¿½mero de processo

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

								//Dados da baixa a pagar do referido TITULO MARCADO ... no FK2 com Histï¿½rico
								oSubFK2:SetValue( "FK2_DATA"	, dDataBase )
								oSubFK2:SetValue( "FK2_VALOR"	, xMoeda(SE2->E2_VALLIQ,SE2->E2_MOEDA,1,dDataBase) )
								oSubFK2:LoadValue( "FK2_NATURE"	, SE2->E2_NATUREZ )
								oSubFK2:SetValue( "FK2_RECPAG"	, "P" )
								oSubFK2:SetValue( "FK2_TPDOC"	, "BA")
								oSubFK2:SetValue( "FK2_HISTOR"	, STR0056+cFatura )
								oSubFK2:SetValue( "FK2_VLMOE2"	, SE2->E2_VALLIQ )
								oSubFK2:SetValue( "FK2_SEQ"		, cSequencia )
								oSubFK2:SetValue( "FK2_FILORI"	, SE2->E2_FILORIG )
								oSubFK2:SetValue( "FK2_CCUSTO"	, SE2->E2_CCUSTO )
								oSubFK2:SetValue( "FK2_MOEDA"	, StrZero(SE2->E2_MOEDA, TamSx3("FK2_MOEDA")[1]) )
								oSubFK2:SetValue( "FK2_MOTBX"	, "FAT" )
								oSubFK2:SetValue( "FK2_IDDOC"	, cChaveFK7 )
								oSubFK2:SetValue( "FK2_ORIGEM"	, Funname() )

								// Atualiza a Movimentaï¿½ï¿½o Bancï¿½ria
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
										
										// Valores Acessï¿½rios
										If !oSubFK6:IsEmpty()
											oSubFK6:AddLine()					// Inclui a quantidade de linhas necessï¿½rias
											oSubFK6:GoLine( oSubFK6:Length() )	// Vai para linha criada
										EndIf	

										// Grava os DADOS da Tabela FK6 com Histï¿½rico Emissao Fatura
										oSubFK6:SetValue( "FK6_FILIAL"	, FWxFilial("FK6") )
										oSubFK6:SetValue( "FK6_IDFK6"	, GetSxEnum("FK6","FK6_IDFK6") )                                                                
										oSubFK6:SetValue( "FK6_TABORI"	, "FK2" )
										oSubFK6:SetValue( "FK6_TPDOC"	, cTpDoc )
										oSubFK6:SetValue( "FK6_VALCAL"	, Iif (nX==4,&cCpoTp,xMoeda(&cCpoTp,SE2->E2_MOEDA,1,dDataBase)) )  
										oSubFK6:SetValue( "FK6_VALMOV"	, Iif (nX==4,&cCpoTp,xMoeda(&cCpoTp,SE2->E2_MOEDA,1,dDataBase)) )
										oSubFK6:SetValue( "FK6_RECPAG"	, "P" )
										oSubFK6:SetValue( "FK6_IDORIG"	, cChaveFK2 )								    
										oSubFK6:SetValue( "FK6_HISTOR"	, STR0056+cFatura )

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
							MsSeek(xFilial("SA2")+cFornFat+cLoja)			 
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
						aBaseFat := aClone(acols)
						aPisFat  := aClone(acols)
						aCofFat  := aClone(acols)
						aCslFat  := aClone(acols)
						aIrfFat	 := aClone(acols)
						aISSFat  := aClone(acols)
						aBaseIR	 := aClone(acols)
						aInsFat	 := aClone(acols)
						aBaseIns := aClone(acols)

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
						// Base total de IR com reduï¿½ï¿½o : (20.000 * 0.8) = 16.000
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
									aBaseIR[nW,nPFatVlr]	:= (aBaseIR[nW,nPFatVlr] * nPropIr)
								Next
							EndIf

							nPropIr	:= If (SED->ED_BASEIRF > 0, (SED->ED_BASEIRF/100),1)	

							// Reduzo a base do IR para cada parcela 
							// de acordo com a base de IR da natureza da fatura
							If nPropIR < 1
								nBaseIrpf := nBaseIrpf * nPropIr
								For nW := 1 to Len(aBaseIR)
									aBaseIR[nW,nPFatVlr]	:= (aBaseIR[nW,nPFatVlr] * nPropIr)
								Next
							EndIf
						EndIf

						// Acerto os valores de base e impostos de acordo com a nova configuracao do aCols
						//For nW := 1 to Len(aCols)
								nW := nxfat

								nProp := aCols[nW,nPFatVlr] / nValor  //Proporcao entre a parcela e o valor total da fatura

								aBaseFat[nW,nPFatVlr] 	:= nBasePcc - nTotBase
								aPisFat[nW,nPFatVlr] 	:= nPisFat - nTotPis
								aCofFat[nW,nPFatVlr] 	:= nCofFat - nTotCof
								aCslFat[nW,nPFatVlr] 	:= nCslFat - nTotCsl
								aISSFat[nW,nPFatVlr] 	:= nISSFat - nTotISS
								aBaseIr[nW,nPFatVlr] 	:= nBaseIrpf - nTotIRF
								aIrfFat[nW,nPFatVlr] 	:= nTotIRPJ - nTtIRFat
								aBaseIns[nW,nPFatVlr]	:= nBaseFat - nTotBIns
								aInsFat[nW,nPFatVlr] 	:= nInsFat - nTotIns
						
						//Next

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
								
								// Verifica se existem titulos de impostos com Dirf, caso nï¿½o exista nï¿½o grava o E2_CODRET
								If TMPSE2X->(! Eof())
									lDirf:=.T. 			
								EndIf  

								TMPSE2X->(dbCloseArea())

							EndIf

						EndIf 

						//For nW := 1 To Len(aCols)
							//If !aCols[nW,Len(aCols[1])]  // .F. == Ativo  .T. == Deletado
							If !aCols[nxFat,Len(aCols[1])]  // .F. == Ativo  .T. == Deletado								
								nProp    := aCols[nxFat,nPFatVlr] / nValor  

								cPrefix	 := aCols[nxFat][nPFatPrf ]
								cFatura	 := aCols[nxFat][nPFatNum ]
								cParcela := aCols[nxFat][nPFatOrd ]
								cTipo    := aCols[nxFat][nPFatTip ]
								cVencmto := aCols[nxFat][nPFatVct ]
								nValDup	 := aCols[nxFat][nPFatVlr]
								nValCruz := xMoeda(aCols[nxFat,nPFatVlr],nMoeda,1,dDataBase)
								cBanco	 := aCols[nxFat][nPFatBco ]

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

								If lCtsDif							
									// Acha conta corrente do fornernecedor
									_cQryFil := ""
									_cTpFil	 := ""

									_cQryFil := "SELECT *"
									_cQryFil += " FROM " + retSQLName("FIL") + " FIL"
									_cQryFil += " WHERE FIL.FIL_FORNEC	=	'" + IIF(mv_par01 == 1,cFornFat,cFornP)+ "'"
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

										cForBco := QRYFIL->FIL_BANCO 
										cForCta := QRYFIL->FIL_CONTA
										cFctaDv := QRYFIL->FIL_DVCTA
										cForAge := QRYFIL->FIL_AGENCI
										cFageDv := QRYFIL->FIL_DVAGE

									EndIf

									QRYFIL->(DBCloseArea())
								EndIf 

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
								Replace E2_FORNECE	With  IIF(mv_par01 == 1,cFornFat,cFornP)
								Replace E2_LOJA		With  IIF(mv_par01 == 1,cLoja,cLojaP)
								Replace E2_VALOR	With  nValDup
								Replace E2_SALDO	With  nValDup
								Replace E2_MOEDA	With  nMoeda
								Replace E2_PORTADO	With  cBanco
								Replace E2_FATURA 	With  "NOTFAT"
								Replace E2_NOMFOR 	With  SA2->A2_NREDUZ
								Replace E2_VLCRUZ	With  xMoeda(nValDup,nMoeda,1,dDataBase)
								Replace E2_MULTNAT	With	"2"	   

								Replace E2_FORBCO   With cForBco 
								Replace E2_FCTADV   With cFctaDv
								Replace E2_FORCTA   With cForCta
								Replace E2_FAGEDV   With cFageDv
								Replace E2_FORAGE   With cForAge
		
								Replace E2_XFINALI	With _cTpFil
								Replace E2_ZDTNPR	With dMenorDT	   
								Replace E2_XOBS     With cOBSSum   

								// TRATA VALOR DE ACRESCIMO E DECRESCIMO

								/* 
								Paulo Henrique - 23/08/2019 - PRB0040227
								nï¿½o deve ser calculado o valor acrescimo e do descrescimo com o valor proprocional, 
								mas sim, conforme estava no titulo antes da geraï¿½ï¿½o da fatura
								*/

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

								// Gestï¿½o						
								If !lSE2Compart .And. mv_par06 == 1
									Replace E2_ORIGEM 	With  "FINA290M"
								Else
									Replace E2_ORIGEM 	With  "FINA290"
								EndIf
								
								// Retencao do ISS na baixa
								If SuperGetMV("MV_MRETISS",,"1")=="2" 
									Replace E2_ISS 		With  aISSFat[nxFat,nPFatVlr]
									Replace E2_FRETISS 	With  nFRetISS
									Replace E2_TRETISS 	With  nTRetISS
								EndIf

								// Gravar campo de base do IRPF
								If lIrpfBaixa .And. lBaseIrpf
									Replace E2_BASEIRF	With aBaseIR[nxFat,nPFatVlr]
									Replace E2_PRETIRF 	With "1"						
								EndIf

								If lInssBx //Inss Baixa
									Replace E2_BASEINS	With aBaseIns[nxFat,nPFatVlr]
									Replace E2_PRETINS 	With "1"
									Replace E2_INSS 	With aInsFat[nxFat,nPFatVlr]												
								EndIf

								// Grava o valor do IRPJ	
								If lIrpfBaixa .And. SA2->A2_TIPO == "J" .And. Len(aIrfFat) > 0
									Replace E2_IRRF 	With aIrfFat[nxFat,nPFatVlr]
									Replace E2_BASEIRF	With aBaseIR[nxFat,nPFatVlr]
									Replace E2_PRETIRF 	With "1"
								EndIf

								// Impostos Lei 10925 para tratamento na baixa.
								If 	lPccBaixa .And. ;
									(Len(aPisFat)+Len(aCofFat)+Len(aCslFat)> 0 ) .And. ;
									(nxFat <= Len(aPisFat) .And. nxFat <= Len(aCofFat) .And. nxFat <= Len(aCslFat)) .And. ;
									(aPisFat[nxFat,nPFatVlr]+aCofFat[nxFat,nPFatVlr]+aCslFat[nxFat,nPFatVlr] > 0)

									Replace E2_PIS		With  aPisFat[nxFat,nPFatVlr]
									Replace E2_COFINS	With  aCofFat[nxFat,nPFatVlr]
									Replace E2_CSLL		With  aCslFat[nxFat,nPFatVlr]
									Replace E2_BASEPIS 	With  aBaseFat[nxFat,nPFatVlr]
									Replace E2_BASECOF 	With  aBaseFat[nxFat,nPFatVlr]
									Replace E2_BASECSLL	With  aBaseFat[nxFat,nPFatVlr]
									Replace E2_PRETPIS	With  "1"
									Replace E2_PRETCOF 	With  "1"
									Replace E2_PRETCSL 	With  "1"
								EndIf
												
								// lDirf - necessï¿½ria pois podemos ter PCC na Bx e IR na Emissao, isso faz com que o E2_DIRF=="2" e nï¿½o podemos gerar cod ret quando nï¿½o houver impostos.
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
														cFornFat,;
														cLoja,;
														nValDup } )
								EndIf                
								
								// Criaï¿½ï¿½o dos Tipos de Valores // Carneiro
								For nI := 1 To Len(aTipoValor)
									Reclock("ZDS",.T.)
									ZDS->ZDS_FILIAL := xFilial("SE2")
									ZDS->ZDS_PREFIX := cPrefix
									ZDS->ZDS_NUM    := cFatura
									ZDS->ZDS_PARCEL := cPARCELA
									ZDS->ZDS_TIPO   := cTIPO
									ZDS->ZDS_FORNEC := cFornFat
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

						//Next nW

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
				Next nxfat

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
	cFornFat 	:= CriaVar("A2_COD")
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

	// Deleta tabela Temporï¿½ria criada no banco de dados
	If _oFina2901 <> Nil
		_oFina2901:Delete()
		_oFina2901 := Nil
	EndIf

	// Gestï¿½o
	For nX := 1 TO Len(aTmpFil)
		CtbTmpErase(aTmpFil[nX])
	Next

	// Restaura indice original do SE2 que foi selecionado no Browse
	dbSelectArea("SE2")
	SE2->(dbSetOrder(nIndSE2)) 
	SE2->(dbGoto(nRecnoSE2))

	// Finaliza integracao com Modulo PCO
	PcoFinLan("000015")

	IF nOpcA == 1 .And. nValor > 0
		MsgInfo("Processamento finalizado.")
	EndIf 
Return (nOpca == 1)

/*/{Protheus.doc} MGFINCHK
//TODO Selecao para a Criaï¿½ï¿½o do indice condicional - Agrupamento
@author Paulo da Mata
@since 31/07/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

/* @alterações :Henrique Vidal 
   @Date:16/10/2020
	a) Melhorada Query MGFINCHK() , para tratar varios típos de retornos sendo :
	  1 - Fornecedores - Retorna quais fornecedores podem ser agrupados de acordo com as regras
	  2 - Prefixos - Retorna quais fornecedores podem ser agrupados de acordo com as regras
	  3 - Grupo natureza Fiscal - Retorna quais títulos podem ser agrupados de acordo com as regras das naturezas fiscais
	  4 - Titulos - Depois de todos os checks, o tipo 4 retorna os títulos disponíveis para agrupamento.
	      ( a. Nessa etapa já foram validados, cadastros, fornecedores, Prefixos, naturezas, grupo de naturezas que podem ser agrupados.
		       tanto para regras pre existentes nas premissas do projeto, quanto para filtros da tela realizados pelo usário.
			b. Regra principal, só permitir apresentar um título para agrupaento, quando o fornecedor do título possuir mais título com 
			   a mesma natureza fiscal para o período.)
*/
User Function MGFINCHK(aSelFil,aTmpFil,cTmpSE2Fil,aStru,lTipRet)

	Local cFiltro 		:= ""		
	LOcal lVerLibTit	:= .T.
	Local lPrjCni 		:= ValidaCNI()
	Local nCt			:= 0     
	Local cQuery		:= ""
	Local cFil290 		:= ""
    Local cTipoNFat		:= SuperGetMV("MGF_TPNFAT",,"PRE|PR |NDF")
	Local cCodFil       := U_Array_In(aSelFil)

	DEFAULT aSelFil		:= {}
	DEFAULT aTmpFil		:= {}
	DEFAULT cTmpSE2Fil	:= ""
	DEFAULT aStru		:= {}
	DEFAULT lTipRet		:= 4  // Tipo do retorno (1 - Fornecedores ; 2 - Prefixos ; 3 - Grupo natureza Fiscal , 4 - Titulos)

    // Inicia a Criação do filtro

	If lTipRet  == 1 // Trata dados para retorno somente dos fornecedores
		cFiltro := " SELECT E2_FORNECE " +cEof
	
	ElseIf lTipRet == 2
		cFiltro := " SELECT E2_PREFIXO " +cEof
	
	ElseIf lTipRet == 3
		cFiltro := " SELECT E2_FORNECE || GRPNAT AS CHVGRPNAT FROM ( " +cEof
		cFiltro	+= " SELECT E2_FORNECE , ( SELECT ED_CALCIRF   || ED_CALCISS   || ED_PERCIRF   || ED_CALCINS   || ED_PERCINS   ||  ED_CALCCSL   || ED_CALCCOF   || ED_CALCPIS   || ED_PERCCSL   || ED_PERCCOF   ||  ED_PERCPIS   || ED_CREDIT   FROM "+RetSqlName("SED")+" XSED WHERE XSED.ED_FILIAL  = '" + xFilial("SED") +"'  AND XSED.ED_CODIGO = E2_NATUREZ  AND XSED.D_E_L_E_T_ =' ' )  AS GRPNAT " +cEof
	
	Else //Trata dados dos titulos
		
		For nCt= 1 To Len(aStru)                 
			If aStru[nCt,2] <> "M         "
				cQuery+= ","+Alltrim(aStru[nCt,1])+cEof
			EndIf
		Next nCt

		cFiltro := "SELECT "+SubStr(cQuery,2)+If(!Empty(cQuery),",","")+" SE2.R_E_C_N_O_ RECNO "+cEof
		cFiltro	+= " , ( SELECT ED_CALCIRF   || ED_CALCISS   || ED_PERCIRF   || ED_CALCINS   || ED_PERCINS   ||  ED_CALCCSL   || ED_CALCCOF   || ED_CALCPIS   || ED_PERCCSL   || ED_PERCCOF   ||  ED_PERCPIS   || ED_CREDIT   FROM "+RetSqlName("SED")+" XSED WHERE XSED.ED_FILIAL  = '" + xFilial("SED") +"'  AND XSED.ED_CODIGO = E2_NATUREZ  AND XSED.D_E_L_E_T_ =' ' ) GRPNAT " +cEof

	EndIF 
	
	cFiltro	+= "FROM "+RetSqlName("SE2")+" SE2 "+cEof
	cFiltro	+= "WHERE SUBSTR(E2_FILIAL,1,2)='"+SubSTR(xFilial("SE2"),1,2)+"'"+cEof

	If Len(aSelFil) > 0
		cFiltro += " AND E2_FILIAL IN "+cCodFil+cEof 
		aAdd(aTmpFil, cTmpSE2Fil)
	EndIf         

	cFiltro	+= " AND E2_VENCREA BETWEEN '"+DTOS(dDataDe)+"' AND '"+DTOS(dDataAte)+"'"+cEof
	cFiltro	+= " AND E2_NATUREZ BETWEEN '"+cNat1+"' AND '"+cNat2+"'"+cEof

	cFiltro	+= " AND E2_MOEDA  =  "+Str(nMoeda,2,0)+cEof
	cFiltro	+= " AND E2_FATURA = '"+Space(Len(SE2->E2_FATURA))+"'"+cEof
	cFiltro += " AND E2_NUMBOR = '"+Space(Len(SE2->E2_NUMBOR))+"'"+cEof
	cFiltro	+= " AND E2_TIPO NOT IN "+FormatIn(cTipoNFat,"|")+cEof
	If !Empty(cTatTip)
    	cFiltro	+= " AND E2_PREFIXO NOT IN "+cTatTip+" "+cEof
	EndIf

	If !Empty(cIdForne)
    	cFiltro	+= " AND E2_FORNECE IN "+cIdForne+" "+cEof
	EndIf 

	If !Empty(cForExc)
		cFiltro += "	  AND E2_FORNECE NOT IN(" + cForExc + ") "
	EndIf

	cFiltro	+= " AND E2_SALDO > 0"+cEof

	// AAF - Titulos originados no SIGAEFF nï¿½o devem ser alterados   
	cFiltro += " AND E2_ORIGEM <> 'SIGAEFF ' "+cEof
	cFiltro += " AND E2_ORIGEM <> 'FINA667 ' "+cEof
	cFiltro += " AND E2_ORIGEM <> 'FINA677 ' "+cEof

	// Titulos com DARF gerado nï¿½o devem ser incluidos em Fatura
	cFiltro += " AND E2_IDDARF = '" + Space(Len(SE2->E2_IDDARF)) + "' "+cEof

	cFiltro += " AND E2_DATALIB <> ' ' "

	If lPrjCni
		cFiltro += " AND E2_NUMSOL = '"+Space(Len(SE2->E2_NUMSOL))+"' "+cEof
	EndIf

	// nï¿½o seleciona titulos com baixas parciais - Paulo Henrique - TOTVS - 01/10/2019
	cFiltro	+= " AND E2_VALLIQ = 0 "+cEof

	cFiltro	+= " AND E2_PREFIXO NOT IN( " +  GetNewpar("MGF_FBVZ","'MAN','JUD','RHE' ") + " ) " +cEof // Solicitação 

	cFiltro	+= " AND SE2.D_E_L_E_T_ =' ' " +cEof

	If !Empty(cRecExcl)
		cFiltro += " AND SE2.R_E_C_N_O_ NOT IN(" + cRecExcl + ") " +cEof
	EndIf 

	If lTipRet == 1
		cFiltro += " GROUP BY E2_FORNECE 	"         +cEof
		cFiltro += " HAVING COUNT(E2_FORNECE) > 1	" +cEof
	ElseIf lTipRet == 2 
		cFiltro += " GROUP BY E2_PREFIXO 	" 		  +cEof
		cFiltro += " HAVING COUNT(E2_FORNECE) > 1	" +cEof
	ElseIf lTipRet == 3
		cFiltro += "  )  " 		 							  +cEof
		cFiltro += " GROUP BY E2_FORNECE || GRPNAT " 		  +cEof
		cFiltro += " HAVING COUNT(E2_FORNECE || GRPNAT) = 1	" +cEof
	Else
		cFiltro += " ORDER BY E2_FILIAL,E2_FORNECE,E2_LOJA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO DESC"+cEof
	EndIf 
	
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() + IIF(lTipRet == 1 ,"-Fornecedores", IIF( lTipRet == 2,"Prefixo", IIF( lTipRet == 3,"Grupo natureza Fiscal","Títulos"))) +".TXT",cFiltro)

Return cFiltro

/*/{Protheus.doc} fa290natq
//TODO Verifica validade da natureza via QUERY
@author Paulo da Mata
@since 04/08
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function FA290NATQ()
	
	Local cAlias	 := Alias()
	Local lRet		 := .T.
	Local lValidBloq := SED->(FieldPos("ED_MSBLQL")) > 0
	Local cQry       := ""
	Local cPesqNat   := ""

	If Empty(cNat)  // Valida somente natureza dos títulos
		Return .T. 
	EndIf 
	cPesqNat := AllTrim(cNat1)

	If !Empty(cNat2) .And. cNat1 != cNat2
		cPesqNat += "/"+AllTrim(cNat2)
	EndIf
	
	If Select("TMPSED") > 0
		TMPSED->(dbCloseArea())
	EndIf

	cQry := "SELECT ED_FILIAL,ED_CODIGO, ED_MSBLQL "
	cQry += "FROM "+RetSqlName("SED")+" "
	cQry += " WHERE D_E_L_E_T_ = ' ' "
	
	If !Empty(cNat2)
		cQry += "AND ED_CODIGO IN "+FormatIn(cPesqNat,"/")+" "
	Else
		cQry += "AND ED_CODIGO = '"+cPesqNat+"' "
	EndIf	

	cQry := ChangeQuery(cQry)
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQry), "TMPSED", .F., .F. )

	If !Empty(cNat2)

		While TMPSED->(!Eof())
	
			If lRet .And. !FinVldNat( .F., TMPSED->ED_CODIGO, 2 )
		   		lRet := .F.
		   		Return lRet
			EndIf

			TMPSED->(dbSkip())

		EndDo
	
	Else
	
		If lRet .And. !FinVldNat( .F., TMPSED->ED_CODIGO, 2 )
			lRet := .F.
		   	Return lRet			
		EndIf
	
	EndIf

	If lRet .And. lValidBloq
		If TMPSED->ED_MSBLQL == "1"
			Help(" ",1,"EDBLOCKED",,"Natureza bloqueada para novas movimentações",1,0)
			lRet := .F.
		EndIf
	EndIf

	dbSelectArea(cAlias)

Return lRet

/*/{Protheus.doc} FA290TOk
//TODO Verifica se a natureza estï¿½ vazia ou nï¿½o - Agrupamento
@author Paulo da Mata
@since 04/08/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290TOk()
	Local lRet := .T.
	lFocus := .F.

	If !lFocus .And. Empty(cTipo)
		// Retorno .T. para que possa focar o campo do numero da fatura para alteraï¿½ï¿½o e posterior validaï¿½ï¿½o. 
		// A validaï¿½ï¿½o neste caso ï¿½ feita somente no Fornecedor e ao confirmar a operaï¿½ï¿½o da fatura.
		Help(" ",1,"TIPOFAT")
		oTipo:SetFocus()
		lFocus := .T.
	EndIf

	If !lFocus .And. Empty(cNat1) .And. Empty(cNat2)
		// Retorno .T. para que possa focar o campo de natureza para alteraï¿½ï¿½o e posterior validaï¿½ï¿½o. 
		// A validacao neste caso ï¿½ feita somente no Fornecedor e ao confirmar a operaï¿½ï¿½o da fatura.
		Help(" ",1,"A290NAT")
		oNat:SetFocus()
		lFocus := .T.
	EndIf

	If	!lFocus .And. !FA290NATQ()
		// Retorno .T. para que possa focar o campo de natureza para alteraï¿½ï¿½o e posterior validaï¿½ï¿½o. 
		// A validacao neste caso ï¿½ feita somente no Fornecedor e ao confirmar a operaï¿½ï¿½o da fatura.
		oNat:SetFocus()
		lFocus := .T.
		lRet := .F.
	EndIf

Return If( lRet, (MsgYesNo(OemToAnsi("Confirma Dados?"),OemToAnsi("Atenção"))), .F.)

/*/{Protheus.doc} FA290ForQ
//TODO Verifica validade do Fornecedor - Agrupamento
@author Paulo da Mata
@since 05/08/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function Fa290ForQ( cFornecedor, cLoja, lVldForBlq ,lTudoOK)
	Local aArea			:= GetArea()
	Local lRet			:= .T.

	Default cLoja		:= ""
	Default lTudoOK		:= .F.
	Default lVldForBlq	:= .F.

	//------------------------------------------------------------------------------------------
	// Validacao de confirmacao de tela e obrigatoriedade do preenchimento do fornecedor e loja
	//------------------------------------------------------------------------------------------
	If lTudoOK .And. Empty(cFornecedor)
		Help("  ",1,"FA290FOR",,"Informe o código do fornecedor.",1,0)
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
				Help(" ",1,"FA290FOR",,"O código de fornecedor informado para geração está bloqueado.",1,0)
				lRet := .F.
			EndIf
		Else
			Help(" ",1,"FA290FOR",,"O còdigo de fornecedor informado não está cadastrado no sistema.",1,0) 
			lRet := .F.
		EndIf

	EndIf

	RestArea(aArea)

Return (lRet)

/*/{Protheus.doc} F290VlCposQ
Funï¿½ï¿½o para varrer os campos preenchidos em busca de caracteres especiais - Agrupamento
@author Paulo da Mata
@since 05/08/2020
@version P12117
@return Retorno Booleano da validaï¿½ï¿½o dos dados
/*/ 
Static Function F290VlCposQ(aCps)

	Local nX := 1
	Local lOk := .T.
	Local xCampo

	Default aCps := {"cPrefix","cFatura","cNat1","cNat2"}

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
		Help("",1,"INVCAR",,"Informe caracteres válidos no preenchimento dos campos",1,0)
	EndIf

Return lOk

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

/*/{Protheus.doc} fa290num
//TODO Verifica se ja' existe numero do titulo. Agrupamento
@author Paulo da Mata
@since 06/08/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function fa290numQ(cFatAnt)

	Local aAreaSE2:= SE2->(GetArea())
	Local lRet := .T. 
	Local cFornLoja := IIF(mv_par01 == 1,cFornFat+cLoja,cFornp+cLojaP)

	If !MayIUseCode( "SE2"+xFilial("SE2")+cPrefix+cFatura+cTipo+cFornLoja)  // verifica se esta na memoria, sendo usado
		// busca o proximo numero disponivel 
		//Help(" ",1,"A290EXIST")
		//oFatura:SetFocus()
		//lFocus := .T.
		//lRet := .F.
	Else
		dbSelectArea("SE2")
		dbSetOrder(6)

		If dbSeek(xFilial("SE2")+cFornLoja+cPrefix+cFatura)

			While !Eof() .And. SE2->E2_FILIAL == xFilial("SE2") .And. ;
				cFornLoja+cPrefix+cFatura == SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)

				If 	(SE2->E2_TIPO == cTipo .And. SE2->(E2_FORNECE+E2_LOJA) == cFornLoja)
					Help(" ",1,"A290EXIST")

					// Retorno .T. para que possa focar o campo do numero da
					// fatura para alteraï¿½ï¿½o e posterior validaï¿½ï¿½o. 
					// A validaï¿½ï¿½o neste caso ï¿½ feita somente no Fornecedor 
					// e ao confirmar a operaï¿½ï¿½o da fatura.

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
/*/{Protheus.doc} GerDadAgr
//TODO Colocar o browse por ORDEM DE TIPO - Agrupamento
@author Paulo da Mata
@since 07/08/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function GerDadAgr()
	Local nTamNUM := TamSX3("E2_NUM")[1]
	Local cNumTit := ""
	Local nSldLiq := 0

	dbSelectArea("SE2")

	// Data: 17/12/2018 - Colocar o browse por ORDEM DE TIPO 
	(cAliasSE2)->(DbSetOrder(2))                   
	(cAliasSe2)->(dbGotop())                  

	While (cAliasSe2)->(!EOF())

		cNumTit := PADL(Alltrim((cAliasSe2)->E2_NUM),nTamNUM)
		nSldLiq := (cAliasSe2)->(E2_SALDO-E2_PIS-E2_COFINS-E2_CSLL-E2_SDDECRE-E2_ZTXBOL+E2_ZJURBOL+E2_SDACRES )

		aReg := {}                        

		IF Alltrim((cAliasSe2)->E2_OK) == Alltrim(cMarca)
			AADD(aReg, .T. )
		Else 
			AADD(aReg, .F. )
		EndIf

		// Alterar a sequï¿½ncia de visualizaï¿½ï¿½o - 25/08/2020
		AADD(aReg,(cAliasSe2)->E2_FILIAL ) 	// "Filial"
		AADD(aReg,(cAliasSe2)->E2_FORNECE) 	// "Cod. Fornec"
		AADD(aReg,(cAliasSe2)->E2_LOJA   ) 	// "Loja"
		AADD(aReg,(cAliasSe2)->E2_NOMFOR )	// "Fornecedor"
		AADD(aReg,(cAliasSe2)->E2_PREFIXO)	// "Prefixo"
		AADD(aReg, cNumTit)					// "Nr Titulo"
		AADD(aReg,(cAliasSe2)->E2_PARCELA) 	// "Parcela"
		AADD(aReg,(cAliasSe2)->E2_TIPO   ) 	// "Tipo"
		AADD(aReg,(cAliasSe2)->E2_NATUREZ) 	// "Natureza"
		AADD(aReg,(cAliasSe2)->E2_HIST   ) 	// "Historico"
		AADD(aReg,(cAliasSe2)->E2_EMISSAO) 	// "Emissao"
		AADD(aReg,(cAliasSe2)->E2_VENCTO ) 	// "Vencto"
		AADD(aReg,(cAliasSe2)->E2_VENCREA) 	// "Vencto Real"
		AADD(aReg,(cAliasSe2)->E2_VALOR  ) 	// "Fornecedor"
		AADD(aReg,(cAliasSe2)->E2_SALDO  ) 	// "Valor"
		AADD(aReg,(cAliasSe2)->E2_ACRESC ) 	// "Acrescimo"
		AADD(aReg,(cAliasSe2)->E2_DECRESC) 	// "Decrescimo"
		AADD(aReg,(cAliasSe2)->ABATMTS   ) 	// "Abatimentos"
		SE2->(dbGoTo((cAliasSe2)->RECNO))
		AADD(aReg,nSldLiq) 					// "Saldo Liq."
		AADD(aReg,(cAliasSe2)->ABATSOMADO) 	// "Valor do abatimento considerado na fatura"
		AADD(aReg,(cAliasSe2)->GRPNAT)
		AADD(aReg,(cAliasSe2)->(Recno()))
		
		AADD(aBrowse,aReg)
	
		(cAliasSe2)->(dbSkip())

	EndDo
	// Data: 17/12/2018 - Voltar a ordem 
	(cAliasSE2)->(DbSetOrder(1))                   

Return             
/*/{Protheus.doc} xMudaStatus
//TODO Muda o status de markbrowse
@author Eugenio Arcanjo
@since 17/12/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function xMudaStatus(nTipo) 
	//1 - Individual
	//2 - Desmarca todas
	//3 - Marca Todas

	Local nI := 0 
	Local nx := 1
	CursorWait() 

	// Marcou um REGISTRO na LINHA      
	IF nTipo == 1                         

		(cAliasSe2)->(dbGoTo(aBrowse[oBrowseDados:nAt][Len(aCab)+1]))		
		
		If (cAliasSE2)->(MsRlock())
			
			If (cAliasSe2)->(FieldPos("RECNO")) > 0
				dbSelectArea("SE2")
				MsGoto((cAliasSe2)->RECNO)
				dbSelectArea(cAliasSe2)
			EndIf	
	
			cFilOrig  := SE2->E2_FILORIG
			cChaveLbn := "FAT" + SE2->(xFilial("SE2",cFilOrig)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
	
			If Ascan(aChaveLbn,cChaveLbn) == 0
				Aadd(aChaveLbn,cChaveLbn)
			EndIf	
		
			RecLock(cAliasSE2,.F.)
			(cAliasSE2)->E2_OK	:= IIF(aBrowse[oBrowseDados:nAt][1],"  ",cMarca)
			(cAliasSE2)->(MsUnlock())

			// Verifica se o registro nao esta sendo utilizado em outro terminal
			If LockByName(cChaveLbn,.T.,.F.)
				If Ascan(aChaveLbn, cChaveLbn) == 0
					Aadd(aChaveLbn,cChaveLbn)
				EndIf
			Else
				IW_MsgBox(STR0068,STR0046,"STOP") //"Este titulo está sendo utilizado em outro terminal, não pode ser utilizado na fatura"###"Atenção"
				CursorArrow()
				Return
			EndIf			

			// ATUALIZA MARCACAO PARA A LINHA
			Atu_Var(1) 
			aBrowse[oBrowseDados:nAt][1] := !aBrowse[oBrowseDados:nAt][1]
			oBrowseDados:DrawSelect()
			
		EndIf	

		
	Else
		CursorWait()

		Processa({|| xMG78MrkTd(nTipo)})   

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
Static Function xMG78MrkTd(nTipo)

	Local cChaveLbn := ""
	Local aChaveLbn := {}
	Local nReg 		:= 0

	Cursorwait()
	ProcRegua(Len(aBrowse))
	// Se ESTA USANDO BOTAO MARCAR TODOS
	(cAliasSE2)->(dbGotop())

	//nReg := (cAliasSE2)->(Recno())
	
	While !(cAliasSE2)->(Eof())
		
		If (cAliasSE2)->(MsRLock())

			If (cAliasSe2)->(FieldPos("RECNO")) > 0
				dbSelectArea("SE2")
				MsGoto((cAliasSe2)->RECNO)
				dbSelectArea(cAliasSe2)
			EndIf	
	
			cFilOrig  := SE2->E2_FILORIG
			cChaveLbn := "FAT" + SE2->(xFilial("SE2",cFilOrig)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
	
			If Ascan(aChaveLbn,cChaveLbn) == 0
				Aadd(aChaveLbn,cChaveLbn)
			EndIf

			If LockByName(cChaveLbn,.T.,.F.)
				If Ascan(aChaveLbn, cChaveLbn) == 0
					Aadd(aChaveLbn,cChaveLbn)
				EndIf

				RecLock(cAliasSE2,.F.)
					(cAliasSE2)->E2_OK	:= IIF(nTipo == 2,"  ",cMarca)
				(cAliasSE2)->(MsUnlock())
				IncProc()
			Else
				IW_MsgBox(STR0068,STR0046,"STOP") //"Este titulo está sendo utilizado em outro terminal, não pode ser utilizado na fatura"###"Atenção"
				CursorArrow()
				Return
			EndIf	
		
		EndIf 

		(cAliasSE2)->(dbSkip())
	EndDo

	For nx := 1 to Len(aBrowse)
		aBrowse[nx][1] := IIF(nTipo==2,.F.,.T.)
	Next nx

	CursorArrow()
Return

/*/{Protheus.doc} Atu_VarQ
//TODO Verifica a MARCA no Titulo do Browse e ajusta as variï¿½veis de Totais e Valores - Agrupamento
@author Paulo da Mata
@since 10/08/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Atu_Var(nTipo)       
	Local lMarkTit := .T.

	// GDN - Esta Funï¿½ï¿½o verifica a MARCA no Titulo do Browse e ajusta as variï¿½veis de Totais e Valores.
	IF nTipo == 1
		
		// ESTA MARCANDO UM REGISTRO NA LINHA
		IF (cAliasSe2)->E2_OK <> cMarca
			
			If (cAliasSE2)->E2_TIPO $ MV_CPNEG
				nValor += Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")//+E2_SDACRES-E2_SDDECRE
			
			Else
			
				If !((cAliasSE2)->E2_TIPO $ MVABATIM)
					nAbatim	  := F290VerAbtQ( cMarca , .F. )
					nValor    -= Moeda((E2_SALDO) - nAbatim,nMoeda,"P") //+E2_SDACRES-E2_SDDECRE
					nTitAbats -= nAbatim
				EndIf
			
			EndIf
			nQtdTit--

			// GDN Novos Campos no HEADER da TELA
			nTotTit -= If(Alltrim(E2_TIPO)!="NDF",(cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_ACRESC-(cAliasSE2)->E2_DECRESC,0)
			nTAxTit -= If(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0) // Andy
			nVlrDec	-= (cAliasSE2)->E2_DECRESC
			nVlrAcr -= (cAliasSE2)->E2_ACRESC
			nVlrDev -= If(Alltrim((cAliasSE2)->E2_TIPO)=="NDF",(cAliasSE2)->E2_SALDO,0)

			// GDN Ajusta o VALOR FATURA
			nValorF := ( nTotTit - nVlrDev )
			nValorF := If(nValorF>0,nValorF,0)

			nValor := nValorF
		Else
			// ESTA DESMARCANDO UM REGISTRO
			If (cAliasSE2)->E2_TIPO $ MV_CPNEG
				nValor -= Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")
			Else
				If !(E2_TIPO $ MVABATIM)
					nAbatim	:= F290VerAbtQ( cMarca , .T. )
					nValor  += Moeda((E2_SALDO) - nAbatim,nMoeda,"P")
					nTitAbats += nAbatim
				EndIf
			EndIf
			nQtdTit++

			// GDN Novos Campos no HEADER da TELA
			nTotTit += If(Alltrim(E2_TIPO)!="NDF",(cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_ACRESC-(cAliasSE2)->E2_DECRESC,0)
			nTAxTit += If(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0)
			nVlrDec	+= (cAliasSE2)->E2_DECRESC
			nVlrAcr += (cAliasSE2)->E2_ACRESC
			nVlrDev += If(Alltrim(E2_TIPO)=="NDF",(cAliasSE2)->E2_SALDO,0)

			// GDN Ajusta o VALOR FATURA
			nValorF := ( nTotTit - nVlrDev )
			nValorF := If(nValorF>0,nValorF,0)
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
		nTAxTit := 0
		nVlrDec	:= 0
		nVlrAcr := 0
		nVlrDev := 0

		dbSelectArea(cAliasSe2)
		DbGoTop()

		While (cAliasSe2)->(!Eof())
			IF (cAliasSe2)->E2_OK <> cMarca
				If (cAliasSE2)->E2_TIPO $ MV_CPNEG
					nValor += Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")
				Else
					If !((cAliasSE2)->E2_TIPO $ MVABATIM)
						nAbatim	  := F290VerAbtQ( cMarca , .F. )
						nValor    -= Moeda((E2_SALDO) - nAbatim,nMoeda,"P")
						nTitAbats -= nAbatim
					EndIf
				EndIf
				nQtdTit--

				// GDN Novos Campos no HEADER da TELA
				nTotTit -= If(Alltrim(E2_TIPO)!="NDF",(cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_ACRESC-(cAliasSE2)->E2_DECRESC,0)
				nTAxTit -= If(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0)
				nVlrDec	-= (cAliasSE2)->E2_DECRESC
				nVlrAcr -= (cAliasSE2)->E2_ACRESC
				nVlrDev -= If(Alltrim((cAliasSE2)->E2_TIPO)=="NDF".And.(cAliasSe2)->E2_OK=cMarca,(cAliasSE2)->E2_SALDO,0)

				// GDN Ajusta o VALOR FATURA
				nValorF := ( nTotTit - nVlrDev )
				nValorF := If(nValorF>0,nValorF,0)

				nValor := nValorF			
			Else
				If (cAliasSE2)->E2_TIPO $ MV_CPNEG
					nValor -= Moeda(SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE),nMoeda,"P")
				Else
					If !(E2_TIPO $ MVABATIM)
						nAbatim	:= F290VerAbtQ( cMarca , .T. )
						nValor  += Moeda((E2_SALDO) - nAbatim,nMoeda,"P")
						nTitAbats += nAbatim
					EndIf
				EndIf
				nQtdTit++

				// GDN Novos Campos no HEADER da TELA
				nTotTit += If(Alltrim(E2_TIPO)!="NDF",(cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_ACRESC-(cAliasSE2)->E2_DECRESC,0)
				nTAxTit += If(Alltrim(E2_TIPO)!="NDF",E2_SALDO,0)
				nVlrDec	+= (cAliasSE2)->E2_DECRESC
				nVlrAcr += (cAliasSE2)->E2_ACRESC
				nVlrDev += If(Alltrim((cAliasSE2)->E2_TIPO)=="NDF".And.(cAliasSe2)->E2_OK=cMarca,(cAliasSE2)->E2_SALDO,0)

				// GDN Ajusta o VALOR FATURA
				nValorF := ( nTotTit - nVlrDev )
				nValorF := If(nValorF>0,nValorF,0)			

				nValor := nValorF
			EndIf
			(cAliasSE2)->(dbSkip())
		EndDo
	EndIf

Return Nil

/*/{Protheus.doc} F290VerAbtQ
//TODO Faz o controle dos valores de abatimentos para tï¿½tulos com a chave igual, exceï¿½ï¿½o para o tipo - Agrupamento
@author Paulo da Mata
@since 10/08/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function F290VerAbtQ( cMarca , lMarcou )

	Local nReturn  := 0
	Local nVlrAbat := 0
	Local nRecNo   := RecNo()
	Local cChave   := SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA)
	Local cKey     := SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA)
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

		(cAlias)->(dbSeek(xFilial('SE2')+E2_PREFIXO+E2_NUM+E2_PARCELA))

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


/*/{Protheus.doc} fTitCtaFor
//TODO Verifica contas divergentes nos tï¿½tulos, na aglutinaï¿½ï¿½o da fatura
@author Paulo Henrique
@since 25/10/2019
@version 1.0
@return ${return}, ${return_description}

@parameters

@type function
/*/

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

Static Function fTitCtaFor(aTCtaFor)

Local lRet    := .F.
Local nRx     := 0
Local aTitFor := {}
Local cCtaFor := ""

aTitFor := aClone(aTCtaFor)
aTitFor := ASORT(aTitFor,,,{ |x, y| x < y } )
cCtaFor := aTitFor[1][1]+aTitFor[1][2]+aTitFor[1][3]+aTitFor[1][4]+aTitFor[1][5]

For nRx := 1 to Len(aTitFor)
     
	// Verifico se o conteï¿½do da variï¿½vel "cCtaFor" ï¿½ diferente do primeiro elemento do array
    If aTitFor[nRx,1]+aTitFor[nRx,2]+aTitFor[nRx,3]+aTitFor[nRx,4]+aTitFor[nRx,5] != cCtaFor
	   lRet := .T.
	   Exit
	EndIf   

	// Carrega a variï¿½vel com o conetudo do array sorteado
	cCtaFor := aTitFor[nRx,1]+aTitFor[nRx,2]+aTitFor[nRx,3]+aTitFor[nRx,4]+aTitFor[nRx,5]
	
Next

Return(lRet)

/*/{Protheus.doc} fa290MarcQ
//TODO Trata o valor para marcar e desmarcar item
@author Paulo da Mata
@since 10/08/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
STATIC Function fa290MarcQ(cAlias,cMarca,nLimite,lPccBaixa,lBaseSE2,aChaveLbn,aFatPag,nValorFat)

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
	
				// Se esta apto a Marcaï¿½ï¿½o;
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

							// Tratamento para os tï¿½tulos que possuem a mesma chave, com exceï¿½ï¿½o do tipo, o sistema considera o mesmo abatimento para ambos
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

/*/{Protheus.doc} MGCmpNDF
//TODO Tratamentos dos tï¿½tulos Selecionados com NDF
@author Eugenio Arcanjo
@since 12/11/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function MGCmpNDF(cAliasSE2,aBrowse,cMarca)
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

	// Varrer o arquivo de Trabalho tratando se estï¿½ Marcado.
	(cAliasSE2)->(dbGoTop())
	While !(cAliasSE2)->(Eof())

		// Se o tï¿½tulo esta marcado, colocar ele no array a processar
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
				//Colocado regra para quando for uma NDF, eu adiciono o Tipo de Valor xxx na E2 para que mostre ao usuï¿½rio o vlr da Compensaï¿½ï¿½o
				//Consulta o tipo no ZDS tï¿½tulo, lï¿½ eu gravo o Nï¿½mero da fatura e o tipo xxx

			Else
				AADD(aRecSE2,SE2->(Recno()))
			EndIf
		EndIf
		(cAliasSE2)->(dbSkip())
	EndDo  

	// Executo a Funï¿½ï¿½o de Compensaï¿½ï¿½o Automï¿½tica ( Contas a Pagar )
	If !MaIntBxCP(2,aRecSE2,,aRecNDF,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,dBaixaCMP)   
		Help("MGFNDF",1,"HELP","MGFNDF","Não foi possível a compensação"+CRLF+" do titulo com NDF.",1,0)
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

/*/{Protheus.doc} fContTit()
//TODO Selecao para a Criaï¿½ï¿½o do indice condicional - Agrupamento
@author Paulo da Mata
@since 31/07/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function fContTit(aSelFil,aTmpFil,cTmpSE2Fil,cFornece)

	Local cFiltro 		:= ""		
	Local nCt			:= 0  
	LOcal lVerLibTit	:= .T.   
    Local cTipoNFat		:= SuperGetMV("MGF_TPNFAT",,"PRE|PR |NDF")
	Local cEof          := Chr(13)+Chr(10)
    Local cCodFil       := U_Array_In(aSelFil)

	DEFAULT aSelFil		:= {}
	DEFAULT aTmpFil		:= {}
	DEFAULT cTmpSE2Fil	:= ""

	cFiltro := "SELECT DISTINCT E2_FORNECE, COUNT(*) AS REGS "+cEof
	cFiltro	+= "FROM "+RetSqlName("SE2")+" SE2 "+cEof
	cFiltro	+= "WHERE SUBSTR(E2_FILIAL,1,2) = '"+SubSTR(xFilial("SE2"),1,2)+"'"+cEof

	If Len(aSelFil) > 0
		cFiltro += " AND E2_FILIAL IN "+cCodFil+cEof 
		aAdd(aTmpFil, cTmpSE2Fil)
	EndIf         

	cFiltro	+= " AND E2_VENCREA BETWEEN '"+DTOS(dDataDe)+"' AND '"+DTOS(dDataAte)+"'"+cEof
	cFiltro	+= " AND E2_EMISSAO BETWEEN '"+DTOS(dDataE1)+"' AND '"+DTOS(dDataE2) +"'"+cEof
	cFiltro	+= " AND E2_NATUREZ BETWEEN '"+AllTrim(cNat1)+"' AND '"+AllTrim(cNat2)+"'"+cEof
    cFiltro	+= " AND E2_FORNECE = '"+cFornece+"'"+cEof
	cFiltro	+= " AND E2_MOEDA   =  "+Str(nMoeda,2,0)+cEof
	cFiltro	+= " AND E2_FATURA  = '"+Space(Len(SE2->E2_FATURA))+"'"+cEof
	cFiltro += " AND E2_NUMBOR  = '"+Space(Len(SE2->E2_NUMBOR))+"'"+cEof
	cFiltro	+= " AND E2_TIPO NOT IN "+FormatIn(cTipoNFat,"|")+cEof
    cFiltro	+= " AND E2_PREFIXO NOT IN "+cTatTip+" "+cEof
	cFiltro	+= " AND E2_SALDO > 0"+cEof

	// AAF - Titulos originados no SIGAEFF nï¿½o devem ser alterados
	cFiltro += " AND E2_ORIGEM NOT IN ('SIGAEFF','FINA667','FINA677')"+cEof

	// Titulos com DARF gerado nï¿½o devem ser incluidos em Fatura
	cFiltro += " AND E2_IDDARF = '"+Space(Len(SE2->E2_IDDARF))+"'"+cEof

	If lVerLibTit
		If GetMv("MV_CTLIPAG")
			cFiltro += " AND (E2_DATALIB <> ' ' OR (E2_SALDO+E2_SDACRES-E2_SDDECRE<="+ALLTRIM(STR(GetMv('MV_VLMINPG'),17,2))+"))"+cEof
		EndIf
	EndIf	

	// nï¿½o seleciona titulos com baixas parciais - Paulo Henrique - TOTVS - 01/10/2019
	cFiltro	+= " AND E2_VALLIQ = 0"+cEof
	cFiltro += " GROUP BY E2_FORNECE"+cEof

	MemoWrite( "C:\TEMP\AAA_CONTIT.TXT",cFiltro)

	dbUseArea( .T., "TOPCONN", TCGenQry(,,cFiltro), "TMP", .F., .F. )

	If TMP->(!Eof())
	   nCt := TMP->REGS
	EndIf   

	TMP->(dbCloseArea())
    
Return nCt

/*/{Protheus.doc} FSelFatQ
//TODO Markbrowse da Faturas a Pagar
@author Paulo da Mata
@since 12/08/2020
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
Static Function FSelFatQ(oDlg,nOpca,cCond,nValor,nValTot,aVenc,cPrefix,cFatura,cTipo,dDatCont,oPanel,oPanel2)

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

	aCols := GrvDupQ(nDup,cPrefix,cFatura,nValor,dDatabase,aVenc,cTipo,"FINA280")

	If !Empty(aCols)
		aVlCruz := {}
		aVlCruz := F280VlCruz(nDup,nValCruz)

		// Mostra tela com os diversos titulos
		For nI:=1 To Len(aCols)
			nValTot += aCols[nI][nPFatVlr ]
		Next

		IF Str(nValor,16,2) != Str(nValTot,16,2)
			nValTot := nValor
		EndIf    

		nOpca := 0		
		@ 015,135	SAY "Data contabilização: " OF oPanel2 SIZE 80,14 Pixel
		@ 015,190	Say dDatCont OF oPanel2 SIZE 80,14  Pixel 	
		@ 015,248	Say 'Parcelas' OF oPanel2 SIZE 80,14 Pixel
		@ 015,315	Say cCondicao OF oPanel2 SIZE 80,14  Pixel
		@ 015,335	Say "Valor geral selecionado:" OF oPanel2 Pixel SIZE 80,14

		@ 015,400 Say oValTot VAR nValTot Picture "@E 9,999,999,999.99" OF oPanel2 PIXEL FONT oFnt COLOR CLR_HBLUE

		oGet := MSGetDados():New(34,5,128,315,3,"u_xFinBvok","Fa290AllOk","",.F.,{"Banco"},,,,,"",,"xFaAtuVl(.F.)")
		oGet:SetEditLine(.F.) 		
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT			
	EndIf  

Return

/*/{Protheus.doc} GrvDupQ
//TODO Formata Array com os desdobramentos dos titulos
@author Paulo Boschetti
@since 12/11/1993
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

Static Function GrvDupQ(nDup,cPrefixo,cNumero,nValor,dVencto,aVenc)

	Local nTamParcela	:= TamSx3("E2_PARCELA")[1]  
	Local cParcSE2		:= SuperGetMv("MV_1DUP")
	Local cParcela		:= Space(nTamParcela)
	Local cTmpParcela	:= Space(nTamParcela)
	Local nValorTit		:= NoRound((nValor/nDup))
	Local nValDup		:= nValor
	Local nMaxParc		:= 1
	Local nTamBanco		:= TamSx3("A6_COD")[1]
	Local ni			:= 0
	Local aTemp 		:= {} 
	Local nPArrFat 		:= 0 // Posição do fornecedor noo array de fatura.
	
	// Montagem da matriz aHeader 
	AADD(aHeader,{ OemToAnsi("Prf")					,"E2_PREFIXO"	,"@!"  				  ,TamSx3("E2_PREFIXO")[1] ,0,"","ï¿½","C","SE2" } )
	AADD(aHeader,{ OemToAnsi("Fatura")				,"E2_NUM"		,"@!"  				  ,TamSx3("E2_NUM")[1],0,"","ï¿½","C","SE2" } )
	AADD(aHeader,{ OemToAnsi("Parcela")				,"E2_PARCELA"	,PesqPict("SE2","E2_PARCELA")	  ,TamSx3("E2_PARCELA")[1],0,"","ï¿½","C","SE2" } )
	AADD(aHeader,{ OemToAnsi("Tipo")				,"E2_TIPO"		,"@!"  				  ,TamSx3("E2_TIPO")[1],0,"","ï¿½","C","SE2" } )
	AADD(aHeader,{ OemToAnsi("Fornecedor")			,"E2_FORNECE"	,"@!"                 ,TamSx3("E2_FORNECE")[1],0,"","ï¿½","C","SE2" })
	AADD(aHeader,{ OemToAnsi("Loja")				,"E2_LOJA"		,"@!"                 ,TamSx3("E2_LOJA")[1],0,"","ï¿½","C","SE2" })
	AADD(aHeader,{ OemToAnsi("Razão")				,"E2_NOMFOR"	,"@!"                 ,TamSx3("E2_NOMFOR")[1],0,"","ï¿½","C","SE2" })
	AADD(aHeader,{ OemToAnsi("Natureza")			,"E2_NATUREZ"	,"@!"                 ,TamSx3("E2_NATUREZ")[1],0,"","ï¿½","C","SE2" })
	AADD(aHeader,{ OemToAnsi("Vencimento")			,"E2_DTFATUR"	,"99/99/99"           ,TamSx3("E2_DTFATUR")[1],0,"","ï¿½","D","SE2" } )
	AADD(aHeader,{ OemToAnsi("Valor Duplicata")		,"E2_VALOR"		,"@E 9,999,999,999.99",TamSx3("E2_VALOR")[1],TamSx3("E2_VALOR")[2],"xFaAtuVl()","ï¿½","N","SE2"})
	AADD(aHeader,{ OemToAnsi("Banco")				,"A6_COD"		,"@!"                 ,TamSx3("A6_COD")[1],0,"","ï¿½","C","SA6" })
	AADD(aHeader,{ OemToAnsi("Grupo Natureza Fiscal"),""			,"@!"                 ,50,0,"","ï¿½","C","SE2" })

	nPFatPrf 		:= aScan(aHeader,{|x| x[1] == "Prf" })
	nPFatNum 		:= aScan(aHeader,{|x| x[1] == "Fatura" })
	nPFatOrd 		:= aScan(aHeader,{|x| x[1] == "Parcela" })
	nPFatTip 		:= aScan(aHeader,{|x| x[1] == "Tipo" })
	nPFatVct 		:= aScan(aHeader,{|x| x[1] == "Vencimento" })
	nPFatVlr 		:= aScan(aHeader,{|x| x[1] == "Valor Duplicata" })
	nPFatBco 		:= aScan(aHeader,{|x| x[1] == "Banco" })
	nPFatFor 		:= aScan(aHeader,{|x| x[1] == "Fornecedor" })
	
	nPFatLj 		:= aScan(aHeader,{|x| x[1] == "Loja" })    // Loja será sempre 01, conforme premissa;
	nPFatRz			:= aScan(aHeader,{|x| x[1] == "Razão" })
	nPFatNt			:= aScan(aHeader,{|x| x[1] == "Natureza" })
	nPFatGrp		:= aScan(aHeader,{|x| x[1] == "Grupo Natureza Fiscal" })

	// Grava aCols com os valores das duplicatas
	PRIVATE aCOLS[nDup][9]	

	cFatura := cFatAnt

	// Verifica o tamnho da parcela
	If nDup > 1
		
		// Verifica a validade do parametro
		If Len(GetMV("mv_1dup")) >= 1
			cTmpParcela := Substr(GetMV("mv_1dup"),Len(GetMV("mv_1dup"))+1-nTamParcela,nTamParcela)
		Else
			IW_MSGBOX("Nï¿½mero mï¿½ximo de parcelas permitido " + Str(nMaxParc,2) + CHR(13)+ ;
			"Nï¿½mero de parcelas da condiï¿½ï¿½o de pagto. " + Str(nDup,4) + CHR(13)+;
			"Verifique parï¿½metro MV_1DUP.", "Atenï¿½ï¿½o","STOP")
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
				IW_MSGBOX("Número máximo de parcelas permitido " + Str(nMaxParc,2) + CHR(13)+ ;
				"Número de parcelas da condiçãoo de pagto. " + Str(nDup,4) + CHR(13)+; //
				"Verifique parâmetro MV_1DUP.", "Atenção","STOP")
				Return {}
			EndIf
		
		EndIf
	
	EndIf

	dMaiorVenc := dDataBase
	dbSelectArea( cAliasSE2 )
	dbGotop()

	While !(cAliasSE2)->(Eof())
	
		If (cAliasSE2)->E2_OK == cMarca
				
			If ( nPArrFat	:=	aScan(aTemp,{|x| Alltrim(x[nPFatFor]+x[nPFatGrp]) == Alltrim((cAliasSE2)->E2_FORNECE + (cAliasSE2)->GRPNAT)  } )) > 0
				aTemp[nPArrFat][nPFatVlr] += (cAliasSE2)->E2_SALDO
				
				If Empty(dVctox)
					IF (cAliasSe2)->E2_VENCREA > aTemp[nPArrFat][nPFatVct]
						aTemp[nPArrFat][nPFatVct] := (cAliasSe2)->E2_VENCREA
					EndIf
				EndIf

				IF (cAliasSe2)->E2_NATUREZ < aTemp[nPArrFat][nPFatNt]
					aTemp[nPArrFat][nPFatNt] := (cAliasSe2)->E2_NATUREZ
				EndIf 
			Else
				aTam := TamSx3("E2_NUM")
				cFatura	:= Soma1(Alltrim(cFatura), aTam[1])
				cFatura	:= Pad(cFatura,aTam[1])
				AADD(aTemp , {cPrefixo , cFatura , cParcSE2 , cTipo , (cAliasSE2)->E2_FORNECE , '01' , (cAliasSE2)->E2_NOMFOR , (cAliasSE2)->E2_NATUREZ ,  IIF( Empty(dVctox) , dMaiorVenc, dVctox ) , (cAliasSE2)->E2_SALDO , Space(nTamBanco) , (cAliasSE2)->GRPNAT, .F. })
			EndIF 
		EndIf
	
		(cAliasSE2)->(dbskip())
	EndDo

	aCols := aTemp

Return(aCols)

/*/{Protheus.doc} xFaAtuVl
//TODO Atualiza valor da fatura na tela
@author Pilar S. Albaladejo
@since 27/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static FuncTion xFaAtuVl(lVldCampo)

	Local nx
	DEFAULT lVldCampo := .T.
	nValTot := 0

	For nx:=1 To Len(aCols)
		If !aCols[nx,Len(aCols[1])]
			If nx == n .And. lVldCampo // Se estiver somando a posicao que alterei
				nValtot+= &(ReadVar())
			Else
				nValTot += aCols[nx][nPFatVlr]
			EndIf
		EndIf
	Next nx

	oValTot:Refresh()

Return .T.

/*/{Protheus.doc} GeraExcel
//TODO Gera relatï¿½rio em planilha excel
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
		MsgAlert("Microsoft Excel nï¿½o instalado!")
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
		aAux[03] := CHR(160)+aAux[06]		// Prefixo
		aAux[06] := CHR(160)+aAux[07]		// Num. Titulo
		aAux[14] := CHR(160)+aAux[03]		// Cod. Fornecedor
		aAux[15] := CHR(160)+aAux[04]		// Loja
		Aadd(aDadosExcel, aAux)
	Next

	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({ {"ARRAY", cLote, aCabExcel, aDadosExcel} }) })                                          

Return

/*/{Protheus.doc} Fa290AllOK
//TODO Verifica se aCols esta preenchida corretamente
@author Pilar S. Albaladejo
@since 27/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Fa290AllOk()

	Local nX, nValTot := 0
	LOCAL lRet := .T.
	Local aArea 	:= GetArea()
	Local aAreaSe2 := SE2->(GetArea())
	Local nCol	   := Len(aCols[1])

	For nx:=1 To Len(aCols)
		If !aCols[nx,nCol]
			nValTot += aCols[nx][nPFatVlr]

			// Verifica se o titulo esta cadastrado
			dbSelectArea("SE2")
			DbSetOrder(1)

			If Msseek(xFilial("SE2")+aCols[nX][nPFatPrf]+aCols[nX][nPFatNum]+aCols[nX][nPFatOrd]+aCols[nX][nPFatTip]+If(mv_par01 == 1,cFornFat,cFornP)+If(mv_par01 == 1,cLoja,cLojaP))
				lRet := .F.
				// Nao permite duplicar o numero !
				Help(" ",1,"A290EXIST")
				Exit
			EndIf
		EndIf
	Next nx

	IF Str(nTAxTit,16,2) != Str(nValTot,16,2) // Andy
		Help(" ",1,"VALFAT1",,"Valor das notas " + Transform(nValor,"@E 99,999,999,999.99")+chr(13)+; //
		"Valor da fatura  " + Transform(nValTot,"@E 99,999,999,999.99"),4,0) //
		lRet := .F.
	EndIf

	oValTot:Refresh()
	SE2->(RestArea(aAreaSe2))
	RestArea(aArea)

Return lRet

/*/{Protheus.doc} Atu_TipV
//TODO Agrupamento dos tipos de valores dos títulos selecionado.
@author Eugenio Arcanjo
@since 12/11/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function Atu_TipV(aTipoValor) 

	dbSelectArea('ZDS')
	ZDS->(dbSetOrder(1))
	ZDS->(dbSeek(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
	
		While ZDS->(!Eof()) .And. ;
		  	SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) == ;
			ZDS->(ZDS_FILIAL+ZDS_PREFIX+ZDS_NUM+ZDS_PARCEL+ZDS_TIPO+ZDS_FORNEC+ZDS_LOJA ) ;
			.And. SE2->E2_FORNECE == cFornFat 

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

/*/{Protheus.doc} u_valor duplicataok
//TODO Confere se a linha digitada esta OK
@author Pilar S. Albaladejo
@since 27/11/1995
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User FuncTion xFinBvok()

	Local lRet := .T.
	Local nX, lDuplicado := .F.
	Local aArea 	:= GetArea()
	Local aAreaSe2 := SE2->(GetArea())
	Local nCol	   := Len(aCols[1])

	// Se a linha nao estiver deletada e o prefixo foi alterado
	IF !(aCols[n,nCol]) .And. aCols[n][nPFatPrf ] != cPrefix
		// Nao permite alterar PREFIXO !
		Help(" ",1,"IGUALPREF")
		lRet := .F.
	EndIf

	// Se a linha nao estiver deletada e o TIPO foi alterado
	IF !(aCols[n,nCol]) .And. aCols[n][nPFatTip ] != cTipo
		// Nao permite alterar PREFIXO !
		Help(" ",1,"IGUALTIPO",,STR0058,1,0)  //"Nao e permitida alteracao do tipo do titulo."+CHR(13)+"Deve-se manter o tipo definido no inicio da rotina")
		lRet := .F.
	EndIf

	// Verificar o vencimento da parcela
	IF (aCols[n,nPFatVct]) < dDataBase
		// O vencimento deve ser maior que a database
		Help(" ",1,"NOVENCREA") 
		lRet := .F.
	EndIf 

	// Pesquisa por titulos ja cadastrados
	For nX := 1 To Len(aCols)
		// Se encontrou um titulo igual ao ja cadastrado, avisa e nao permite continuar
		If !aCols[nX][Len(aCols[nX])] .And. ;
			aCols[nX][nPFatPrf]+aCols[nX][nPFatNum]+aCols[nX][nPFatOrd ]+aCols[nX][nPFatTip ] == aCols[n][nPFatPrf ]+aCols[n][nPFatNum ]+aCols[n][nPFatOrd ]+aCols[n][nPFatTip ] .And. ;
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
		If Msseek(xFilial("SE2")+aCols[n][nPFatPrf ]+aCols[n][nPFatNum ]+aCols[n][nPFatOrd ]+aCols[n][nPFatTip ]+;
		If(mv_par01 == 1,cFornFat,cFornP)+If(mv_par01 == 1,cLoja,cLojaP))
			lRet := .F.
			// Nao permite duplicar o numero !
			Help(" ",1,"A290EXIST")
		EndIf
	EndIf

	// Se passou por todas as validacoes, valida o valor
	If lRet .And. !(aCols[n,nCol]) 
		lRet := NaoVazio(aCols[n][nPFatVlr ])
	EndIf	

	SE2->(RestArea(aAreaSe2))
	RestArea(aArea)

Return lRet

/*/MostraErr : Exibe erros na validação do fornecedor.
@author Henrique Vidal
@since 23/07/2020 /*/	
Static Function MostraErr(aErros , cTit)

	Local aSizeAut    := MsAdvSize(,.F.,400)
	Local oDlg                    
	Local aBrwErr    	:= aErros 
	Local aObjects
	Local aInfo
	Local aPosObj
	Local lRet := .T.
	
	aObjects := {}
	AAdd( aObjects, { 0		,  20, .T., .F. } )
	AAdd( aObjects, { 100	, 100, .T., .T. } )
	AAdd( aObjects, { 0		, 10, .T., .T. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects ,.T. )


	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Log: " + cTit  PIXEL
			  
		oBrw_Log := TWBrowse():New( 004,4,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]+10,;
								  ,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		oBrw_Log:SetArray(aBrwErr)                                    
		oBrw_Log:bLine := {|| aEval(aBrwErr[oBrw_Log:nAt],{|z,w| aBrwErr[oBrw_Log:nAt,w] } ) }
		
		oBrw_Log:addColumn(TCColumn():new('Tipo'			 ,{||aBrwErr[oBrw_Log:nAt][01]},"@!"        ,,,"LEFT"   ,020,.F.,.F.,,,,,))
		oBrw_Log:addColumn(TCColumn():new('Descrição do Erro',{||aBrwErr[oBrw_Log:nAt][02]},"@!"        ,,,"LEFT"   ,050,.F.,.F.,,,,,))

		oBrw_Log:Setfocus() 
		oBtn := TButton():New( aSizeAut[4]-25	, 500,'Processar demais fornecedores'	, oDlg,{|| lRet := .T. , oDlg:End()       }  ,85, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( aSizeAut[4]-25	, 400,'Abortar'							, oDlg,{|| lRet := .F. , oDlg:End()       }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		
	ACTIVATE MSDIALOG oDlg CENTERED

Return( lRet)

Static Function MgfChkCad(cQuery)

	Local lRetcad := .T.
	Local aTCodBar := {} 
	Local aTCodFav := {}
	Local aTCtaFor := {}
	Local cQry 		 := ""
	Local aErrcad	 := {} 
	Local cFornAnt 	 := ""

	cQry := Substr(cQuery,Rat("FROM",cQuery),Len(cQuery))
	cQry := " SELECT * " + cQry 
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"QRY_TIT",.T.,.F.)
	dbSelectArea("QRY_TIT")

	QRY_TIT->(dbGoTop())

	While QRY_TIT->(!Eof())

		If cFornAnt <> QRY_TIT->E2_FORNECE	
			aTCtaFor := {}
		EndIf 
		
		If !Empty(QRY_TIT->E2_CODBAR)
			
			If Ascan(aErrcad , {|x| x[1]+x[3] == 'Código de barras no título'+QRY_TIT->E2_FORNECE  }) == 0
				
				//If !MsgYesNo("Fornecedor : " + QRY_TIT->E2_FORNECE + "-" + QRY_TIT->E2_LOJA + ' - ' + Alltrim(RetField("SA2",1,XFILIAL("SA2")+QRY_TIT->E2_FORNECE+"01","A2_NOME")) + " Há títulos com o código de barras preenchido." + ' - ' + QRY_TIT->E2_CODBAR + cEof + cEof+ cEof + "Deseja processar esse fornecedor ?")
					
						AADD(aErrcad , {'Código de barras no título' ,;
							"Fornecedor : " + QRY_TIT->E2_FORNECE +' - ' + Alltrim(RetField("SA2",1,XFILIAL("SA2")+QRY_TIT->E2_FORNECE+"01","A2_NOME")) + " Há títulos com o código de barras preenchido." + ' - ' + QRY_TIT->E2_CODBAR + ". Títulos desse fornecedor não serão listados",;
							QRY_TIT->E2_FORNECE})	

						cForExc += Iif( !Empty(cForExc) , ",'" , "'" ) + QRY_TIT->E2_FORNECE + "'"
				//EndIF // Desvio 03: Solicitado para tirar confirmação de msg favorecido e codigo de barras. Deve excluir título sem perguntar. 
			EndIf

		EndIf


		If !Empty(QRY_TIT->E2_ZCODFAV)
		
			If Ascan(aErrcad , {|x| x[1]+x[3] == 'Código do favorecido'+QRY_TIT->E2_FORNECE  }) == 0
				//If !MsgYesNo("Fornecedor : " + QRY_TIT->E2_FORNECE + "-" + QRY_TIT->E2_LOJA + ' - ' + Alltrim(RetField("SA2",1,XFILIAL("SA2")+QRY_TIT->E2_FORNECE+"01","A2_NOME")) + " Há títulos com o favorecido preenchido." + cEof + cEof+ cEof + "Deseja processar esse fornecedor ?")
						
						AADD(aErrcad , {'Código do favorecido' ,;
									"Fornecedor : " + QRY_TIT->E2_FORNECE +' - ' + Alltrim(RetField("SA2",1,XFILIAL("SA2")+QRY_TIT->E2_FORNECE+"01","A2_NOME")) + " Há títulos com o favorecido preenchido." + " Títulos desse fornecedor não serão listados",;
									QRY_TIT->E2_FORNECE})	

						cForExc += Iif( !Empty(cForExc) , ",'" , "'" ) + QRY_TIT->E2_FORNECE + "'"
				//EndIf // Desvio 03: Solicitado para tirar confirmação de msg favorecido e codigo de barras. Deve excluir título sem perguntar.  
			EndIf

		EndIf


		cChv01 := QRY_TIT->(E2_FORBCO+E2_FCTADV+E2_FORCTA+E2_FAGEDV+E2_FORAGE)

		If !(Len(aTCtaFor) > 1) 
			If ASCAN(aTCtaFor,{|x|x[1]+x[2]+x[3]+x[4]+x[5] == cChv01 }) == 0 .And. !Empty(cChv01)
				AADD(aTCtaFor,{E2_FORBCO,E2_FCTADV,E2_FORCTA,E2_FAGEDV,E2_FORAGE})
			
				// Paulo Henrique - 24/10/2019 - Rever a condiï¿½ï¿½o abaixo 
				If Len(aTCtaFor) > 1 // Se Encontrar conta divergentes nos tï¿½tulos, pergunta se deve continuar
					lRetCtaFor := fTitCtaFor(aTCtaFor)
					If lRetCtaFor
						If !MsgYesNo("Fornecedor : " + QRY_TIT->E2_FORNECE + "-" + QRY_TIT->E2_LOJA + ' - ' + Alltrim(RetField("SA2",1,XFILIAL("SA2")+QRY_TIT->E2_FORNECE+"01","A2_NOME")) + " - Natureza: " + QRY_TIT->E2_NATUREZ  + " Há contas bancárias divergentes entre os títulos." + cEof + cEof+ cEof + "Deseja processar esse fornecedor ?")

							If Ascan(aErrcad , {|x| x[1]+x[3] == 'Contas bancárias'+QRY_TIT->E2_FORNECE  }) == 0
								AADD(aErrcad , {'Contas bancárias' ,;
								"Fornecedor : " + QRY_TIT->E2_FORNECE +' - ' + Alltrim(RetField("SA2",1,XFILIAL("SA2")+QRY_TIT->E2_FORNECE+"01","A2_NOME")) + " - Natureza: " + QRY_TIT->E2_NATUREZ  + "Há contas bancárias divergentes entre os títulos. " + " Títulos desse fornecedor não serão listados",;
								QRY_TIT->E2_FORNECE})	

								cForExc += Iif( !Empty(cForExc) , ",'" , "'" ) + QRY_TIT->E2_FORNECE + "'"
							EndIF
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		cFornAnt := QRY_TIT->E2_FORNECE	

		QRY_TIT->(dbSkip())
	End  
	QRY_TIT->(dbCloseArea())

Return aErrcad
	