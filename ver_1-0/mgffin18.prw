#INCLUDE "protheus.ch"
#include "totvs.ch"
#include "topconn.ch"

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3
#DEFINE nIND3 4
#DEFINE nIND4 5
/*
=====================================================================================
Programa............: MGFFIN16
Autor...............: Roberto Sidney
Data................: 06/10/2016
Descricao / Objetivo: Markbrose com tabela temporária para selecção dos titulos e OR para registro de sinistro
aos fornecedores
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function MGFFIN18()

	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	Local _astrus:={}
	Local _carq
	Local oMark
	Local aTRB := {} //Barbieri: Criado variável para manipulação correta de arquivo temporário

	Private arotina := {}
	Private cCadastro
	Private cMark:=GetMark()
	Private aStruS := {}
	Private nRegLoc  := 0
	Private aSituaca := Strtokarr(GetMv("MGF_SITSIN"),";") // K - Código da ocorrencia da situação de sinistro
	Private _cMotBxSin := alltrim(GetMv("MGF_DACSIN"))    // Motixo de baixa para o titulos de sinistro
	//Private aOcorSin := Strtokarr(GetMv("MGF_OCOSIN"),";") // Ocorrencia bancária utilizada no processo de sinisitro - Não protesto
	//Private aBancoBx := Strtokarr(Getmv("MGF_BCOSIN"),";") // Banco utilizado na baixa de sinistro por dação
	//Private _cProcSini := ''
	Private _cFil		:= ''
	Private _cPrefixo := ''
	Private _cTitulo  := ''
	Private _cParcela := ''
	Private _cTipo    := ''
	Private _cCodCli  := ''
	Private _cLojaCli := ''
	Private aCampos:={}
	Private cPath := "\System_Marfrig\"
	Private  _cChaveSEA := ''

	// 2- Normal - Retira do protest
	Private _cOcorren := ''
	Private _cSituaca := ''
	Private cPrxSEG := GetMv("MGF_PRXSEG") // Prefixo para os titulos de seguro
	Private cNatFin := GetMv("MGF_NATSEG") //  Natureza dos titulos de seguradora
	Private aCliente := Strtokarr(GetMv("MGF_CLISEG"),";") // Cliente para titulos de seguro

	// Verifica se o codigo de ocorrência existe

	DbSelectArea("FRV")
	IF ! FRV->(DbSeek(xFilial("FRV") + _cSituaca))
		alert("Ocorrência da situação de Sininistro não informada ou não localizada")
		Return(.F.)
	Endif

	// Valida Natureza
	DbSelectArea("SED")
	IF !SED->(DbSeek(xFilial("SED")+cNatFin))
		alert("Natureza " + alltrim(cNatFin) + " não informada ou não localizada, verifique parâmetro MGF_NATSEG ")
		Return(.F.)
	Endif

	cCadastro := "Titulos Seguradora / Protestos"

	// Cria tabela temporária
	//u_Cria_TRB()
	// Alimenta tabela temporária
	//u_Monta_TRB("P")

	MsgRun("Criando tela de Títulos com Sinistro...",,{|| aTRB := CriaTSeg() } )

	aCores := {}
	AADD(aCores,{"RB_ZORDENT == SPACE(10) .and. RB_ZSINIST = 'Não'","BR_PRETO" })
	AADD(aCores,{"RB_ZORDENT == SPACE(10) .and. RB_ZSINIST = 'Sim'","BR_AMARELO" })
	AADD(aCores,{"RB_ZSINIST == 'Sim'" ,"BR_VERMELHO" })
	AADD(aCores,{"RB_ZSINIST == 'Não'" ,"BR_VERDE" })

	// Gera Array de campos
	aCampos := u_CPOSINIS()

	aRotina   := {	{"Tít. Seguradora"	,"u_MarkSeg(1)"		, 0, 4},;
					{"Voltar carteira"	,"u_MarkSeg(2)"		, 0, 4},;
					{"Visualiza"		,"u_VisuTit"		, 0, 2},;
					{"Pesquisa"			,"u_PESQTITSEG()"	, 0, 1},;
					{"Legenda"			,"u_LEGTITSEG"		, 0, 8}}

	DbSelectArea("TRB")
	DbGotop()

	mBrowse(aCoors[1], aCoors[2], aCoors[3], aCoors[4], "TRB", aCampos	,,,,,aCores,,,,,,,,,,,)
	//MarkBrow('TRB','RB_OK',,aCampos,, cMark,'u_MarkAllTit(1)',,,,'u_MarcarTit()',,,,aCores,,,,.F.)

	//Fecha a área
	TRB->(dbCloseArea())
	//Apaga o arquivo fisicamente
	FErase( aTRB[ nTRB ] + GetDbExtension())
	//Apaga os arquivos de índices fisicamente
	FErase( aTRB[ nIND1 ] + OrdBagExt())
	FErase( aTRB[ nIND2 ] + OrdBagExt()) 
	FErase( aTRB[ nIND3 ] + OrdBagExt())
	FErase( aTRB[ nIND4 ] + OrdBagExt())

Return

/*
=====================================================================================
Programa............: CriaTSeg
Autor...............: Barbieri
Data................: 01/2017
Descricao / Objetivo: Criação da tabela temporária - Tabela titulos com Seguradora
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
Static FUNCTION CriaTSeg()

	Local cArq  := ""
	Local cInd1 := ""
	Local cInd2 := ""
	Local cInd3 := ""
	Local cInd4 := ""
	Local nX	:= 0

	If Select("TRB") <> 0
		TRB->(dbCloseArea())
	Endif

	aStruS := {}
	AADD(aStruS,{"RB_OK"       ,"C",02,0})
	AADD(aStruS,{"RB_FILIAL"   ,"C",06,0}) //Barbieri: Alterar na Marfrig para tamanho 6
	AADD(aStruS,{"RB_ZSINIST"  ,"C",03,0})
	AADD(aStruS,{"RB_PREFIXO"  ,"C",03,0}) 
	AADD(aStruS,{"RB_NUM"      ,"C",09,0})
	AADD(aStruS,{"RB_PARCELA"  ,"C",02,0}) //Barbieri: Alterar na Marfrig para tamanho 2
	AADD(aStruS,{"RB_TIPO"     ,"C",03,0})
	AADD(aStruS,{"RB_ZORDENT"  ,"C",10,0})
	AADD(aStruS,{"RB_ZPRCSIN"  ,"C",10,0})
	AADD(aStruS,{"RB_NATUREZ"  ,"C",10,0})
	AADD(aStruS,{"RB_CLIENTE"  ,"C",06,0})
	AADD(aStruS,{"RB_LOJA"     ,"C",02,0})
	AADD(aStruS,{"RB_NOMCLI"   ,"C",20,0})
	AADD(aStruS,{"RB_PORTADO"  ,"C",03,0})
	AADD(aStruS,{"RB_EMISSAO"  ,"D",08,0})
	AADD(aStruS,{"RB_VENCTO"   ,"D",08,0}) //Barbieri: Estava com tipo C, alterado para D
	AADD(aStruS,{"RB_VENCREA"  ,"D",08,0}) //Barbieri: Estava com tipo C, alterado para D
	AADD(aStruS,{"RB_VALOR"    ,"N",16,2})
	AADD(aStruS,{"RB_BAIXA"    ,"D",08,0})
	AADD(aStruS,{"RB_NUMBOR"   ,"C",06,0})
	AADD(aStruS,{"RB_DATABOR"  ,"D",08,2})
	AADD(aStruS,{"RB_HIST"     ,"C",25,0})
	AADD(aStruS,{"RB_SITUACA"  ,"C",01,0})
	AADD(aStruS,{"RB_OCORREN"  ,"C",02,0})
	AADD(aStruS,{"RB_SALDO"    ,"N",16,2})
	AADD(aStruS,{"RB_PEDIDO"   ,"C",06,0})
	AADD(aStruS,{"RB_NUMNOTA"  ,"C",09,0})
	AADD(aStruS,{"RB_SERIE"    ,"C",03,0})
	AADD(aStruS,{"RB_IDCNAB"   ,"C",10,0})

	cArq := Criatrab(aStruS,.T.)
	cInd1 := Left( cArq, 6 ) + "1"
	cInd2 := Left( cArq, 6 ) + "2"
	cInd3 := Left( cArq, 6 ) + "3"
	cInd4 := Left( cArq, 6 ) + "4"	
	dbUseArea( .T., __LocalDriver, cArq, "TRB", .F., .F. )

	IndRegua( "TRB", cInd1, "RB_FILIAL+RB_NUM", , , "Criando índices (Número)...")
	IndRegua( "TRB", cInd2, "RB_FILIAL+RB_ZORDENT", , , "Criando índices (Embarque)...")
	IndRegua( "TRB", cInd3, "RB_FILIAL+RB_PREFIXO+RB_NUM+RB_PARCELA", , , "Criando índices (Prefixo + Número + Parcela)...")
	IndRegua( "TRB", cInd4, "RB_FILIAL+RB_CLIENTE+RB_LOJA", , , "Criando índices (Cliente + Loja)...")
	dbClearIndex()
	dbSetIndex( cInd1 + OrdBagExt() )
	dbSetIndex( cInd2 + OrdBagExt() )
	dbSetIndex( cInd3 + OrdBagExt() )
	dbSetIndex( cInd4 + OrdBagExt() )

	//Gera dados para o arquivo temporário
	cQuery := ""
	cQuery +="SELECT E1_FILIAL RB_FILIAL,"
	cQuery +="E1_ZORDENT RB_ZORDENT,"
	cQuery +="E1_ZSINIST RB_ZSINIST,"
	cQuery +="E1_ZPRCSIN RB_ZPRCSIN,"
	cQuery +="E1_PREFIXO RB_PREFIXO,"
	cQuery +="E1_NUM RB_NUM,"
	cQuery +="E1_PARCELA RB_PARCELA,"
	cQuery +="E1_TIPO RB_TIPO,"
	cQuery +="E1_NATUREZ RB_NATUREZ,"
	cQuery +="E1_CLIENTE RB_CLIENTE,"
	cQuery +="E1_LOJA RB_LOJA,"
	cQuery +="E1_NOMCLI RB_NOMCLI,"
	cQuery +="E1_PORTADO RB_PORTADO,"
	cQuery +="E1_EMISSAO RB_EMISSAO,"
	cQuery +="E1_VENCTO RB_VENCTO,"
	cQuery +="E1_VENCREA RB_VENCREA,"
	cQuery +="E1_VALOR RB_VALOR,"
	cQuery +="E1_NUMBCO RB_NUMBCO,"
	cQuery +="E1_BAIXA RB_BAIXA,"
	cQuery +="E1_NUMBOR RB_NUMBOR,"
	cQuery +="E1_DATABOR RB_DATABOR,"
	cQuery +="E1_HIST RB_HIST,"
	cQuery +="E1_SITUACA RB_SITUACA,"
	cQuery +="E1_OCORREN RB_OCORREN,"
	cQuery +="E1_SALDO RB_SALDO,"
	cQuery +="E1_PEDIDO RB_PEDIDO,"
	cQuery +="E1_NUMNOTA RB_NUMNOTA,"
	cQuery +="E1_SERIE RB_SERIE,"
	cQuery +="E1_IDCNAB RB_IDCNAB "
	cQuery +="FROM " + RetSqlName("SE1")
	cQuery +="WHERE "
	cQuery +="E1_SALDO > 0 AND E1_TIPO = 'NF '"
	cQuery +="AND E1_ZSINIST = 'S' "
	cQuery +="AND D_E_L_E_T_ = ' ' "
	cQuery +="ORDER BY RB_FILIAL,RB_PREFIXO,RB_NUM,RB_PARCELA "	
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)    

	// Compatibiliza compos data
	TcSetField("CAD","RB_EMISSAO","D",8,0)
	TcSetField("CAD","RB_VENCTO","D",8,0)
	TcSetField("CAD","RB_VENCREA","D",8,0)
	TcSetField("CAD","RB_BAIXA","D",8,0)
	TcSetField("CAD","RB_DATABOR","D",8,0)

	Dbselectarea("CAD")
	//_nReg := 1
	While CAD->(!EOF())
		RecLock("TRB",.T.)
		For nX := 1 To Len(aStruS)
			If !(aStruS[nX,1] $ 'RB_OK')
				If aStruS[nX,2] = 'C'
					_cX := 'TRB->'+aStruS[nX,1]+' := Alltrim(CAD->'+aStruS[nX,1]+')'
				Else 
					_cX := 'TRB->'+aStruS[nX,1]+' := CAD->'+aStruS[nX,1]
				Endif
				_cX := &_cX
			Endif
		Next
		//	TRB->RB_REGIS := _nReg
		TRB->RB_ZSINIST := IIF(alltrim(TRB->RB_ZSINIST) $ "''/N",'Não','Sim')

		MsUnLock()
		//	_nReg ++
		DbSelectArea('CAD')
		CAD->(dBSkip())
	EndDo

	Dbselectarea("CAD")
	DbCloseArea()
	Dbselectarea("TRB")
	//DbGoTop()

Return ({cArq,cInd1,cInd2,cInd3,cInd4}) //Barbieri: Incluído para abertura do arquivo e MarkBrowser

/*
=====================================================================================
Programa............: LEGTITSEG
Autor...............: Roberto Sidney
Data................: 06/10/2016
Descricao / Objetivo: Legenda
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function LEGTITSEG()

	aLegenda := {{"BR_VERMELHO","Sinistro gerado / Cobrança cancelada"},;
	{"BR_VERDE","Sem sinistro / Cobrança em andamendo"},;
	{"BR_AMARELO","Sem O.E / Sinistro gerado / Cobrança cancelada"},;
	{"BR_PRETO","Sem O.E - Ordem de Embarque"}}

	BRWLEGENDA( "Registro de Sinistro", "Legenda", aLegenda )

Return .T.


/*
=====================================================================================
Programa............: PESQTITSEG
Autor...............: Roberto Sidney
Data................: 06/10/2016
Descricao / Objetivo: Função de pesquisa
Doc. Origem.........: CRE24 - GAP MGCRE24
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Alterado por Barbieri em 01/2017
=====================================================================================
*/
User Function PESQTITSEG() //cAlias,nReg,nOpcx)

	Local oDlgPesq, oOrdem, oChave, oBtOk, oBtCan, oBtPar
	Local cOrdem
	Local cChave := Space(255)
	Local aOrdens := {}
	Local nOrdem := 1
	Local nOpcao := 0
	//Local nRecTRB := 0

	AAdd( aOrdens, "Numero" )
	AAdd( aOrdens, "Embarque" )
	AAdd( aOrdens, "Prefixo + Numero + Parcela" )
	AAdd( aOrdens, "Cliente + Loja" )

	DEFINE MSDIALOG oDlgPesq TITLE "Pesquisa" FROM 00,00 TO 100,500 PIXEL

	@ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
	@ 020, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN .F. OF oDlgPesq PIXEL

	ACTIVATE MSDIALOG oDlgPesq CENTER

	If nOpcao == 1
		cChave := AllTrim(cChave)
		TRB->(dbSetOrder(nOrdem)) 
		TRB->(dbSeek(cChave))
	Endif
Return

/*
=====================================================================================
Programa.:              fExibeTela
Autor....:              Luis Artuso
Data.....:              21/09/2016
Descricao / Objetivo:   Funcao chamadora da tela principal
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MarkSeg(nOpcTit)

	local aCoors		:= 	FWGetDialogSize( oMainWnd )
	Local aSizeAdv	:= MsAdvSize(.F.)
	Local aSizeWnd	:= {aSizeAdv[7],0,aSizeAdv[6],aSizeAdv[5]}
	Local aSizeFld	:= {aSizeAdv[1]+10,aSizeAdv[2]+3,aSizeAdv[3]-3,aSizeAdv[4]-13}
	Local aSizeBrw	:= {aSizeAdv[1]+10,aSizeAdv[2]+3,aSizeAdv[3]-60,aSizeAdv[4]-27}
	Local oButton1
	Local oButton2
	Local oButton3
	Local oButton4
	Local cGet1		:= Space(tamSx3("E1_ZPRCSIN")[1])
	Local oGetFilial
	Local cGetFilial		:= space(tamSx3("E1_FILIAL")[1]+2)
	Local oGetTitu
	Local cGetEmisDe		:= cToD("  /  /  ")
	local oGetEmisAt
	local cGetEmisAt		:= cToD("  /  /  ")
	Local oSay1
	Local cFields	:= ""
	Local cAliasTMP	:= ""
	Local aHeader	:= {}
	Local cStrTran	:= ""
	Local aDados	:= {}
	Local oWBrowse1
	Local oFont
	Local lCodBarra	:= .F.
	local bMark			:= { || iif(aCols1[oBrowMark:nAt][1], 'LBOK', 'LBNO')	}
	local bDblCli		:= { || clickMark(oBrowMark, aCols1), atuSelec()		}
	local bMarkAl		:= { || markAll(oBrowMark, aCols1), atuSelec()			}

	private oOK		:= LoadBitmap(GetResources(),"LBOK")
	private oNO		:= LoadBitmap(GetResources(),"LBNO")
	private aCabLbx	:= {}
	private oBrowMark
	private aCols1	:= {}
	private cSomaT := ""
	private cQtdeT := ""

	aCols1 := {{.F.,"","","","","","","","","","","",cTod(""),cTod(""),0,0,cTod(""),"","",""}}

	cStrTran	:= "SE1."

	cFields		:= "'.F.' AS MARK,SE1.E1_FILIAL,SE1.E1_ZPRCSIN,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_ZORDENT,SE1.E1_NATUREZ,SE1.E1_CLIENTE,SE1.E1_LOJA, "
	cFields		+= "SE1.E1_NOMCLI,SE1.E1_EMISSAO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_BAIXA,SE1.E1_NUMBOR,SE1.E1_SITUACA,SE1.E1_OCORREN,SE1.R_E_C_N_O_ REGISTRO"

	cAliasTMP	:= "SE1"

	aCabLbx	:=  strToKarr(StrTran(cFields , cStrTran , "") , ',')

	_cDescTela := iif(nOpcTit=1,"seguradora","para protesto")

	DEFINE FONT oFont NAME "ARIAL" SIZE 6,15 BOLD

	DEFINE MSDIALOG oDlg TITLE "Localizador de Títulos" FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] COLORS 0, 16777215 PIXEL
	// Cria o conteiner onde serão colocados os browses
	oFWLayer:= FWLayer():New()
	oFWLayer:Init( oDlg, .F., .T. )

	// Define Painel Superior
	oFWLayer:AddLine( 'LINUP', 20, .F. )              // Cria uma 'linha' com 50% da tela.
	oFWLayer:AddCollumn( 'COLUP' , 100, .F., 'LINUP' )   // Na 'linha' criada cria-se uma coluna com 100% do seu tamanho.

	oPnUp := oFWLayer:GetColPanel( 'COLUP', 'LINUP' ) // Criar o objeto dessa parte do container.

	// Painel Inferior
	oFWLayer:AddLine( 'LINDOWN', 80, .F. )                    // Cria uma 'linha' com 50% da tela.
	oFWLayer:AddCollumn( 'COLDOWN'  , 100, .F., 'LINDOWN' )        // Na "linha" criada cria-se uma coluna com 100% de seu tamanho.

	oPnDown := oFWLayer:GetColPanel( 'COLDOWN', 'LINDOWN' ) // Criar o objeto dessa parte do container.

	//@ 010, 008 SAY oSay1 PROMPT " Filial:"					SIZE 070, 007 OF oPnUp COLORS 0, 16777215 PIXEL FONT oFont
	//@ 008, 065 MSGET oGetFilial VAR cGetFilial	F3 "EMP" SIZE 040, 010 OF oPnUp COLORS 0, 16777215 PIXEL

	@ 010, 130 SAY oSay1 PROMPT "Emissão de:"					SIZE 070, 007 OF oPnUp COLORS 0, 16777215 PIXEL FONT oFont
	@ 008, 165 MSGET oGet1 VAR cGetEmisDe		PICTURE "@D"	SIZE 060, 010 OF oPnUp COLORS 0, 16777215 PIXEL

	@ 010, 235 SAY oSay1 PROMPT "Emissão até:"					SIZE 070, 007 OF oPnUp COLORS 0, 16777215 PIXEL FONT oFont
	@ 008, 270 MSGET oGetEmisAt VAR cGetEmisAt	PICTURE "@D"	SIZE 060, 010 OF oPnUp COLORS 0, 16777215 PIXEL

	@ 030, 008 SAY oSay1 PROMPT " Número do Processo:" SIZE 070, 007 OF oPnUp COLORS 0, 16777215 PIXEL FONT oFont
	@ 028, 065 MSGET oGet1 VAR cGet1 SIZE 160, 010 OF oPnUp COLORS 0, 16777215 PIXEL

	@ 027, 250 BUTTON oButton1 PROMPT "Pesquisar" SIZE 037, 015 OF oPnUp PIXEL ACTION fwMsgRun(, {|| cSomaT := "", cQtdeT := "", fGeraQry(cFields , @aDados , @cGet1, oPnUp , oWBrowse1 , @lCodBarra, cGetEmisDe, cGetEmisAt, subStr(cGetFilial, 3, len(cGetFilial))), oBrowMark:setArray(aCols1), oBrowMark:refresh(.T.)}, "Processando", "Aguarde. Selecionando dados..." )

	@ 028, 300 SAY oSaySoma	PROMPT "Somatória: " 			+ cSomaT	SIZE 070, 007 OF oPnUp COLORS 0, 16777215 PIXEL FONT oFont
	@ 037, 300 SAY oSayQtd	PROMPT "Qtde selecionada: "		+ cQtdeT	SIZE 070, 007 OF oPnUp COLORS 0, 16777215 PIXEL FONT oFont

	@ 015, 400 BUTTON oButton1 PROMPT "Marcar todos" SIZE 039, 015 OF oPnUp PIXEL ACTION { || markAll(oBrowMark, aCols1), atuSelec() }

	@ 015, 450 BUTTON oButton2 PROMPT "Limpa Pesquisa" SIZE 039, 015 OF oPnUp PIXEL ACTION {|| cSomaT := "", oSaySoma:refresh(), cQtdeT := "", oSayQtd:refresh(), aCols1 := {{.F.,"","","","","","","","","","","",cTod(""),cTod(""),0,0,cTod(""),"","",""}}, oBrowMark:setArray(aCols1), oBrowMark:refresh(.T.)}

	if nOpcTit = 1
		@ 015, 540 BUTTON oButton3 PROMPT "Gera Seguro" SIZE 039, 015 OF oPnUp PIXEL ACTION {|| fVldGrava(oPnUp , @cGet1 , .F. , lCodBarra,"S"), /*cSomaT := ""*/, oSaySoma:refresh(), /*cQtdeT := ""*/, oSayQtd:refresh(), aCols1 := {{.F.,"","","","","","","","","","","",cTod(""),cTod(""),0,0,cTod(""),"","",""}}, oBrowMark:setArray(aCols1), oBrowMark:refresh(.T.)}
	Else
		@ 015, 540 BUTTON oButton3 PROMPT "Volta Carteira" SIZE 039, 015 OF oPnUp PIXEL ACTION {|| fVldGrava(oPnUp , @cGet1 , .F. , lCodBarra,"P"), cSomaT := "", oSaySoma:refresh(), cQtdeT := "", oSayQtd:refresh(), aCols1 := {{.F.,"","","","","","","","","","","",cTod(""),cTod(""),0,0,cTod(""),"","",""}}, oBrowMark:setArray(aCols1), oBrowMark:refresh(.T.)}
	Endif

	@ 015, 580 BUTTON oButton4 PROMPT "Encerra" SIZE 039, 015 OF oPnUp PIXEL ACTION oDlg:End()

	oBrowMark := fwBrowse():New()
	oBrowMark:setDataArray()
	oBrowMark:setArray(aCols1)
	oBrowMark:disableConfig()
	oBrowMark:disableReport()
	oBrowMark:setOwner(oPnDown)

	oBrowMark:SetProfileID( '1' )        // Identificador (ID) para o Browse
	//oBrowMark:ForceQuitButton()          // Força exibição do botão [Sair]
	//oBrowMark:SetDescription( cxDesc ) // 'Bilhetes'

	oBrowMark:addMarkColumns(bMark, bDblCli, bMarkAl) 
	oBrowMark:addColumn({"Filial"		, { || aCols1[oBrowMark:nAt,02] }, "C"	, pesqPict("SE1","E1_FILIAL")		, 1, tamSx3("E1_FILIAL")[1]		,, .F.,,,,,,,,,"E1_FILIAL"	})
	oBrowMark:addColumn({"Proc.Sinist"	, { || aCols1[oBrowMark:nAt,03] }, "C"	, pesqPict("SE1","E1_ZPRCSIN")		, 1, tamSx3("E1_ZPRCSIN")[1]	,, .F.,,,,,,,,,"E1_ZPRCSIN"	})
	oBrowMark:addColumn({"Prefixo"		, { || aCols1[oBrowMark:nAt,04] }, "C"	, pesqPict("SE1","E1_PREFIXO")		, 1, tamSx3("E1_PREFIXO")[1]	,, .F.,,,,,,,,,"E1_PREFIXO"	})
	oBrowMark:addColumn({"No. Título"	, { || aCols1[oBrowMark:nAt,05] }, "C"	, pesqPict("SE1","E1_NUM")			, 1, tamSx3("E1_NUM")[1]		,, .F.,,,,,,,,,"E1_NUM"		})
	oBrowMark:addColumn({"Parcela"		, { || aCols1[oBrowMark:nAt,06] }, "C"	, pesqPict("SE1","E1_PARCELA")		, 1, tamSx3("E1_PARCELA")[1]	,, .F.,,,,,,,,,"E1_PARCELA"	})
	oBrowMark:addColumn({"Tipo"			, { || aCols1[oBrowMark:nAt,07] }, "C"	, pesqPict("SE1","E1_TIPO")			, 1, tamSx3("E1_TIPO")[1]		,, .F.,,,,,,,,,"E1_TIPO"	})
	oBrowMark:addColumn({"Ord.Embarque"	, { || aCols1[oBrowMark:nAt,08] }, "C"	, pesqPict("SE1","E1_ZORDENT")		, 1, tamSx3("E1_ZORDENT")[1]	,, .F.,,,,,,,,,"E1_ZORDENT"	})
	oBrowMark:addColumn({"Natureza"		, { || aCols1[oBrowMark:nAt,09] }, "C"	, pesqPict("SE1","E1_NATUREZ")		, 1, tamSx3("E1_NATUREZ")[1]	,, .F.,,,,,,,,,"E1_NATUREZ"	})
	oBrowMark:addColumn({"Cliente"		, { || aCols1[oBrowMark:nAt,10] }, "C"	, pesqPict("SE1","E1_CLIENTE")		, 1, tamSx3("E1_CLIENTE")[1]	,, .F.,,,,,,,,,"E1_CLIENTE"	})
	oBrowMark:addColumn({"Loja"			, { || aCols1[oBrowMark:nAt,11] }, "C"	, pesqPict("SE1","E1_LOJA")			, 1, tamSx3("E1_LOJA")[1]		,, .F.,,,,,,,,,"E1_LOJA"	})
	oBrowMark:addColumn({"Nome Cliente"	, { || aCols1[oBrowMark:nAt,12] }, "C"	, pesqPict("SE1","E1_NOMCLI")		, 1, tamSx3("E1_NOMCLI")[1]		,, .F.,,,,,,,,,"E1_NOMCLI"	})
	oBrowMark:addColumn({"Dt Emissao"	, { || aCols1[oBrowMark:nAt,13] }, "D"	, pesqPict("SE1","E1_EMISSAO")		, 1, tamSx3("E1_EMISSAO")[1]	,, .F.,,,,,,,,,"E1_EMISSAO"	})
	oBrowMark:addColumn({"Vencto Real"	, { || aCols1[oBrowMark:nAt,14] }, "D"	, pesqPict("SE1","E1_VENCREA")		, 1, tamSx3("E1_VENCREA")[1]	,, .F.,,,,,,,,,"E1_VENCREA"	})
	oBrowMark:addColumn({"Valor"		, { || aCols1[oBrowMark:nAt,15] }, "N"	, pesqPict("SE1","E1_VALOR")		, 1, tamSx3("E1_VALOR")[1]		,, .F.,,,,,,,,,"E1_VALOR"	})
	oBrowMark:addColumn({"Saldo"		, { || aCols1[oBrowMark:nAt,16] }, "N"	, pesqPict("SE1","E1_SALDO")		, 1, tamSx3("E1_SALDO")[1]		,, .F.,,,,,,,,,"E1_SALDO"	})
	oBrowMark:addColumn({"Data Baixa"	, { || aCols1[oBrowMark:nAt,17] }, "D"	, pesqPict("SE1","E1_BAIXA")		, 1, tamSx3("E1_BAIXA")[1]		,, .F.,,,,,,,,,"E1_BAIXA"	})
	oBrowMark:addColumn({"Num. Bordero"	, { || aCols1[oBrowMark:nAt,18] }, "C"	, pesqPict("SE1","E1_NUMBOR")		, 1, tamSx3("E1_NUMBOR")[1]		,, .F.,,,,,,,,,"E1_NUMBOR"	})
	oBrowMark:addColumn({"Situacao"		, { || aCols1[oBrowMark:nAt,19] }, "C"	, pesqPict("SE1","E1_SITUACA")		, 1, tamSx3("E1_SITUACA")[1]	,, .F.,,,,,,,,,"E1_SITUACA"	})
	oBrowMark:addColumn({"Ocorrencia"	, { || aCols1[oBrowMark:nAt,20] }, "C"	, pesqPict("SE1","E1_OCORREN")		, 1, tamSx3("E1_OCORREN")[1]	,, .F.,,,,,,,,,"E1_OCORREN"	})

	oBrowMark:Activate()

	ACTIVATE MSDIALOG oDlg CENTERED

Return


//----------------------------------------------
// Atualiza as variaveis de qtde e somatoria
//----------------------------------------------
static function atuSelec()
	
	local nI		:= 0
	local nQtdeT	:= 0
	local nSaldo	:= 0

	for nI := 1 to len(aCols1)
		if aCols1[nI, 1]
			nQtdeT++
			nSaldo += getSaldoE1(aCols1[nI])
		endif
	next

	cQtdeT := Transform(nQtdeT ,"@E 999,999,999")
	cSomaT := Transform(nSaldo ,"@E 999,999,999,999.99")

	oSaySoma:refresh()
	oSayQtd:refresh()

return

//----------------------------------------------
// Retorna o E1_SALDO do titulo
//----------------------------------------------
static function getSaldoE1(aTitulo)

	local cQrySE1	:= ""
	local nSaldoE1	:= 0

	cQrySE1 := "SELECT SUM(E1_SALDO) E1_SALDO"
	cQrySE1 += " FROM " + retSQLName("SE1") + " SE1"
	cQrySE1 += " WHERE"
	cQrySE1 += " 	SE1.E1_TIPO			=	'" + allTrim(aTitulo[7]) + "'"
	cQrySE1 += " 	AND	SE1.E1_PARCELA	=	'" + allTrim(aTitulo[6]) + "'"
	cQrySE1 += " 	AND	SE1.E1_NUM		=	'" + allTrim(aTitulo[5]) + "'"
	cQrySE1 += " 	AND	SE1.E1_PREFIXO	=	'" + allTrim(aTitulo[4]) + "'"
	cQrySE1 += " 	AND	SE1.E1_FILIAL	=	'" + allTrim(aTitulo[2]) + "'"
	cQrySE1 += " 	AND	SE1.D_E_L_E_T_	<>	'*'"
	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	TcQuery CHANGEQUERY(cQrySE1) New Alias "QRYSE1"

	if !QRYSE1->(EOF())
		nSaldoE1 := QRYSE1->E1_SALDO
	endif

	QRYSE1->(DBCloseArea())

return nSaldoE1

	/*
	=====================================================================================
	Programa.:              fGeraQry
	Autor....:              Roberto Sidney
	Data.....:              15/09/2016
	Descricao / Objetivo:   Gera a Query para avaliar se ha titulos para o codigo de barras informado
	Doc. Origem:            CRE24 - GAP MGCRE24
	Solicitante:            Cliente
	Uso......:              Marfrig
	Obs......:
	=====================================================================================
	*/
	Static Function fGeraQry(	cFields		,; // String contendo os campos que serao utilizados para a query e o aHeader da MarkBrowse
	aDados		,; // Este array sera preenchido com o conteudo da Query, caso exista(m) tituluos para o codigo de barras.
	cProcesso	,; // Codigo de barras para pesquisa
	oDlg		,;
	oWBrowse1 	,;
	lCodBarra 	,; // Retorna se o conteudo digitado e' um codigo de barras ou linha digitavel do titulo
	cGetEmisDe	,;
	cGetEmisAt	,;
	cGetFilial	;
	)

	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= ""
	Local lRet		:= .F.
	Local aAreaSE1	:= {}
	Local cAliasSE1	:= ""
	Local aHeader	:= {}
	Local cStrTran	:= ""
	Local lExistCod	:= .F. // Valida se o titulo nao tem codigo de barras gravado anteriormente. Caso positivo, bloqueia a gravacao.
	Local cCodTit	:= ""
	Local aBrowse 	:= {}
	Local cCodTmp	:= ""

	if empty(cProcesso) .and. empty(cGetEmisDe) .and. empty(cGetEmisAt)// .and. empty(cGetFilial)
		msgAlert("Nenhum filtro informado.")
		return
	endif

	cAliasSE1	:= "SE1"
	aAreaSE1	:= (cAliasSE1)->(GetArea())
	cQuery		:= "SELECT "

	cFrom		:= " FROM " + RetSqlName(cAliasSE1) + " SE1 "

	cWhere		:= "WHERE "
	cWhere		+= "SE1.E1_SALDO > 0 "
	// Igora os titulos de seguro
	cWhere		+= " AND SE1.E1_PREFIXO <> '"+ALLTRIM(cPrxSEG)+"'"

	if !empty(cProcesso)
		cWhere		+= "AND SE1.E1_ZPRCSIN LIKE '%" + allTrim(cProcesso) + "%'"
	endif

	if !empty(cGetEmisDe)
		cWhere		+= "AND SE1.E1_EMISSAO >= '" + dToS(cGetEmisDe) + "'"
	endif

	if !empty(cGetEmisAt)
		cWhere		+= "AND SE1.E1_EMISSAO <= '" + dToS(cGetEmisAt) + "'"
	endif

	//if !empty(cGetFilial)
		//cWhere		+= "AND SE1.E1_FILIAL LIKE '%" + allTrim(cGetFilial) + "%'"
		cWhere		+= "AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
	//endif

	cWhere		+= " AND SE1.E1_ZSINIST = 'S' "
	//cWhere		+= " AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
	cWhere		+="  AND SE1.D_E_L_E_T_ <> '*' "

	cWhere		+=" Order By E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA "

	cAliasTMP	:= GetNextAlias()
	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery + cFields + cFrom + cWhere) , cAliasTMP , .F. , .T.)

	TcSetField(cAliasTMP,"E1_EMISSAO","D",8,0)
	TcSetField(cAliasTMP,"E1_VENCREA","D",8,0)
	tcSetField(cAliasTMP,"E1_VALOR",'N',TamSx3("E1_VALOR")[1],TamSx3("E1_VALOR")[2])
	tcSetField(cAliasTMP,"E1_SALDO",'N',TamSx3("E1_SALDO")[1],TamSx3("E1_SALDO")[2])
	TcSetField(cAliasTMP,"E1_BAIXA","D",8,0)
	
	//Memowrite("C:\TEMP\MGF18.SQL", cQuery + cFields + cFrom + cWhere )

	lRet := (cAliasTMP)->(!EOF())

	aCols1 := {}

	If ( lRet )
		(cAliasTMP)->(DBGoTop())
		while !(cAliasTMP)->(EOF())
			aadd(aCols1, {	.F.						, (cAliasTMP)->E1_FILIAL	, (cAliasTMP)->E1_ZPRCSIN   ,;
							(cAliasTMP)->E1_PREFIXO	, (cAliasTMP)->E1_NUM		, (cAliasTMP)->E1_PARCELA	,;
							(cAliasTMP)->E1_TIPO	, (cAliasTMP)->E1_ZORDENT	, (cAliasTMP)->E1_NATUREZ	,;
							(cAliasTMP)->E1_CLIENTE	, (cAliasTMP)->E1_LOJA		, (cAliasTMP)->E1_NOMCLI	,;
							(cAliasTMP)->E1_EMISSAO	, (cAliasTMP)->E1_VENCREA	, (cAliasTMP)->E1_VALOR		,;	
							(cAliasTMP)->E1_SALDO	, (cAliasTMP)->E1_BAIXA		, (cAliasTMP)->E1_NUMBOR	,;								
							(cAliasTMP)->E1_SITUACA	, (cAliasTMP)->E1_OCORREN								 })
			(cAliasTMP)->(DBSkip())
		enddo
	Else
		aCols1 := {{.F.,"","","","","","","","","","","",cTod(""),cTod(""),0,0,cTod(""),"","",""}}
		MsgAlert('Não existem títulos para relacionados a este processo')
	EndIf

	(cAliasTMP)->(dbCloseArea())
	RestArea(aAreaSE1)

	Return lRet

/*
=====================================================================================
Programa.:              fVldGrava
Autor....:              Roberto Sidney
Data.....:              19/09/2016
Descricao / Objetivo:   Verifica a quantidade de titulos selecionados.
Doc. Origem:            CRE24 - GAP MGCRE24
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fVldGrava(oDlg , cProcesso , lLimpaSel , lCodBarra, cTpProc)

	Local lContinua	:= .F.
	Local nLen		:= 0
	Local nReg		:= 0
	Local nPos      := 0
	Local nGrv      := 0
	Local _cInstr1  := ""
	Local _cInstr2  := ""
	local I
	Local nCnt := 0
	Local lContinua := .F.

	//Private _nRegTit := 0
	Private aTitulos := {}

	//cSomaT := "" // gresele 19/05/17
	//cQtdeT := "" // gresele 19/05/17

	If !(lLimpaSel)

		aTitulos	:= aClone(aCols1)
		
		// verifica se teve pelo menos um titulo marcado
		For nCnt:=1 To Len(aCols1)
			If aCols1[nCnt][1]
				lContinua := .T.
				cProcesso := aCols1[nCnt][3]
				Exit
			Endif
		Next		
	
		If !lContinua
			APMsgStop("Não foram marcados títulos para geração de "+IIf(cTpProc ="S"," Título Seguradora","Protesto"))
			Return()
		Endif	

		If ( MsgYesNo("Confirma geração ?" , "Geração de "+IIf(cTpProc ="S"," Título Seguradora","Protesto")) )
		
			Begin Transaction // gresele 19/05/17	

			// Titulo do seguro   
			ProcRegua(len(aTitulos))
			if cTpProc = "S"
				// Exibe e grava informações do sinistro
				u_MGFVISUSIN(aTitulos,.T.,cQtdeT,cSomaT,cProcesso)
				cProcesso := Space(10)
				oDlg:End()

			Else
				// Altera a situação dos titulos para protesto
				// Retira o situlo da situação de prosteo
				//_cOcorren := aOcorSin[3] //20 - Protesto
				//_cSituaca := aSituaca[2] //F - Proteste  
				//nPosCods := Ascan(_aAux,{|x| x[1]==SE1->E1_PORTADO})  //pesquisar por portador BCO
				//_cOcorren := _aAux[2]    // 2-  10 - Sinistro

				_cSituaca := aSituaca[1]   // 2 - K  - Sinistro

				DbSelectArea("ZA6")
				DbSetOrder(1)
				IF ZA6->(DbSeek(iif(!empty(xFilial("ZA6")), _cFil, xFilial("ZA6"))+SE1->E1_PORTADO+"P"))  
					_cOcorren := ZA6->ZA6_OCOR 
				ELSE    
					//alert("Ocorrencia não encontrada. ")
					_cInstr1 := "  "
					_cInstr2 := "  "
				ENDIF

				For nPos := 1 to len(aTitulos)
					if aTitulos[nPos,1] = .T.
						//_nRegTit := nPos
						_cChvPesq := aTitulos[nPos,2]+aTitulos[nPos,4]+aTitulos[nPos,5]+aTitulos[nPos,6]+aTitulos[nPos,7]+aTitulos[nPos,10]+aTitulos[nPos,11]
						//Filial+Prefixo+titulo+parcela+tipo+Cliente+Loja
						DbSelectArea("SE1")
						DbSetOrder(1)
						IF SE1->(DbSeek(_cChvPesq))
							If (RecLock("SE1",.F.))
								_cBordero := ''
								_cChaveSEA := SE1->E1_NUMBOR+"R"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO//+SE1->E1_CLIENTE+SE1->E1_LOJA
								SE1->(Reclock("SE1",.F.))
								//SE1->E1_ZSINIST := 'S' // Sinistro em protesto
								//SE1->E1_ZPRCSIN := _cProcSini
								SE1->E1_SITUACA := _cSituaca
								SE1->E1_OCORREN := _cOcorren
								SE1->E1_INSTR1  := _cInstr1
								SE1->E1_INSTR2  := _cInstr2
								SE1->E1_ZPRCSIN := SPACE(10)
								SE1->E1_ZSINIST := 'N'
								SE1->(MsUnlock())

								IF SE1->E1_NUMBOR <> " "
									// Ajusta borderô
									u_JusInstCob(_cOcorren,_cBordero,.T.)
									u_JusInstCob(_cOcorren,_cBordero,.F.)
								ENDIF
							Endif
						Endif
					Endif
				Next nPos

				//u_Cria_TRB()
				//u_Monta_TRB("P")
				CriaTSeg()

				APMsgInfo("Título(s) retornado(s) para carteira simples.")
			EndIf
			
			End Transaction 
			
		Endif
	Endif

Return

//-------------------------------------------------------------
// Função de duplo clique na coluna
//-------------------------------------------------------------
static function clickMark(oBrowse, aDados)

	local lRet := aDados[oBrowse:At(),1]//!aDados[oBrowse:At(),1]
	Local cSinistro := ""
	Local nCnt := 0
	Local lContinua := .T.

	// verifica se marcou mais de um sinistro diferente
	If !aDados[oBrowse:At(),1] == .T. // se item estiver sendo marcado no momento
		cSinistro := aDados[oBrowse:At(),3]
		For nCnt:=1 To Len(aDados)
			If oBrowse:At() != nCnt .and. aDados[nCnt,1]
				If cSinistro != aDados[nCnt,3]
					APMsgStop("Sinistros marcados com códigos diferentes."+CRLF+;
					"Escolha apenas títulos com sinistros de mesmo código.")
					lContinua := .F.
					Exit
				Endif
			Endif
		Next
	Endif					
         
	If lContinua
		lRet := !aDados[oBrowse:At(),1]
		aDados[oBrowse:At(),1] := lRet
	Endif	

return lRet

//-------------------------------------------------------------
// Função de duplo clique no cabeçalho
//-------------------------------------------------------------
static function markAll(oBrowse, aDados)

	Local cSinistro := ""
	Local nCnt := 0
	Local lContinua := .T.

	// verifica se marcou mais de um sinistro diferente
	For nCnt:=1 To Len(aDados)
		If !Empty(cSinistro)
			If cSinistro != aDados[nCnt,3]
				APMsgStop("Sinistros marcados com códigos diferentes."+CRLF+;
				"Escolha apenas títulos com sinistros de mesmo código.")
				lContinua := .F.
				Exit
			Endif
		Endif	
		cSinistro := aDados[nCnt,3]
	Next

	If lContinua
		for nCnt:=1 to Len(aDados)
			aDados[nCnt,1] := !aDados[nCnt,1]
		next
	
		oBrowse:refresh(.T.)
	Endif	

return