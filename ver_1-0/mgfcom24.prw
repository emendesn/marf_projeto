#Include 'Protheus.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MATA161()
Analise da cota��o - Mapa de Cota��o
@author Leonardo Quintania
@since 30/10/2013
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------
User Function MGFCOM24()
	Local oBrowse := Nil
	Local lUsrFilter := ExistBlock("MT161FIL")
	Local cUsrFilter := ""
	Private aRotina := MenuDef()
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SC8")
	
	// Defini��o da legenda
	oBrowse:AddLegend( "Empty(C8_NUMPED).And.C8_PRECO<>0.And.!Empty(C8_COND)", "GREEN"	, "Em Analise" )//"Em Analise"//'Em Analise'
	oBrowse:AddLegend( "!Empty(C8_NUMPED)", "RED" 	, "Analisada" )//"Analisada"//'Analisada'
	oBrowse:AddLegend( "C8_PRECO==0.And.Empty(C8_NUMPED)", "YELLOW" 	, "Em Aberto - N�o Cotada" )//"Em Aberto - N�o Cotada"//'Em Aberto - N�o Cotada'
	oBrowse:AddLegend( "(SC8->(FieldPos('C8_ACCNUM'))>0 .And. !Empty(SC8->C8_ACCNUM) .And. !Empty(SC8->C8_NUMPED)", "BLUE" 	, "Cota��o do MarketPlace" )//"Cota��o do MarketPlace"//'Cota��o do MarketPlace'
	
	oBrowse:SetDescription('Mapa de Cota��o') ////'Mapa de Cota��o'
	oBrowse:DisableDetails()
	
	//Adicionado por ser requisito prometido aos clientes
	AjustaSX1()
	AjustaSX3()
	
	SetKey(VK_F12,{|| Pergunte("MTA161",.T.)})
	Pergunte("MTA161",.F.)
	
	// Ponto de entrada para filtragem da Browse
	If lUsrFilter
		cUsrFilter := ExecBlock("MT161FIL",.F.,.F.,{"SC8"})
		If ValType(cUsrFilter) == "C" .And. !Empty(cUsrFilter)
			oBrowse:SetFilterDefault(cUsrFilter)
		EndIf
	EndIf
	
	oBrowse:Activate()
	
	//-- Limpa atalho
	SetKey(VK_F12,Nil)
	
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef()
Definicao do Menu
@author Leonardo Quintania
@since 30/10/2013
@version 1.0
@return aRotina (vetor com botoes da EnchoiceBar)
/*/
//-------------------------------------------------------------------
Static Function MenuDef()
	
	Local aRotina := {} //Array utilizado para controlar opcao selecionada
	Local aAcoes	:= {}
	
	ADD OPTION aRotina Title "Pesquisar"		Action 'PesqBrw'  		OPERATION 1 ACCESS 0 	//"Pesquisar"//'Pesquisar'
	ADD OPTION aRotina Title 'An�lise da Cota��o'		Action 'U_xM24MAPCot'		OPERATION 4 ACCESS 0  	//"Mapa de Cota��o//'Mapa de Cota��o'
	ADD OPTION aRotina Title "Conhecimento"		Action "MsDocument('SC8',SC8->(RecNo()),2)"		OPERATION 2 ACCESS 0  	//"Conhecimento
	
	//������������������������������������������������������������������������Ŀ
	//� Ponto de entrada utilizado para inserir novas opcoes no array aRotina  �
	//��������������������������������������������������������������������������
	If ExistBlock("MTA161BUT")
		If ValType(aAcoes := ExecBlock( "MTA161BUT", .F., .F., {aRotina}) ) == "A"
			aRotina:= aAcoes
		EndIf
	EndIf
	
Return aRotina

//-------------------------------------------------------------------
/*{Protheus.doc} A161MapCot
Fun��o que efetua a montagem da tela de mapa de cota��o
@author antenor.silva
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
User Function xM24MAPCot()//A161MapCot()
	
	Local aArea    := GetArea()
	Local aAreaSC8 := SC8->(GetArea())
	
	Local oDlg
	
	Local aItens		:= {}
	Local aPropostas	:= {}
	Local aItensC		:= {"Pedido de Compra","Contrato"}//"Pedido de Compra"//"Contrato"
	
	Local cTpDoc 		:= If(Val(SC8->C8_TPDOC)== 1,"Pedido de Compra","Contrato")//"Pedido de Compra"//"Contrato"
	
	Local nTpDoc
	
	Local oSize		:= FWDefSize():New(.T.)
	Local lOk			:= .F.
	Local lContinua	:= .T.
	Local aGrpComp	:= {}
	Local lRestCom	:= SuperGetMv("MV_RESTCOM",.F.,"N")=="S"
	Local lMT161Ok	:= .F.
	
	PRIVATE cCadastro := "An�lise de Cota��o" //"An�lise de Cota��o"
	
	//aCoors := FWGetDialogSize(oMainWnd)
	SC8->(DbSetOrder(1))
	
	//Valida se usuario tem permiss�o para fazer a analise
	If lRestcom .And. !Empty(SC8->C8_GRUPCOM) .And. !VldAnCot(__cUserId,SC8->C8_GRUPCOM)
		Aviso("Acesso Restrito","O  acesso  e  a utilizacao desta rotina e destinada apenas aos usuarios pertencentes ao grupo de compras : "+SC8->C8_GRUPCOM+ ". com direito de analise de cotacao. ",{"Voltar"},2) //"Acesso Restrito"###"O  acesso  e  a utilizacao desta rotina e destinada apenas aos usuarios pertencentes ao grupo de compras : "###". com direito de analise de cotacao. "###"Voltar"
		lContinua := .F.
	EndIf
	
	If lContinua
		//����������������������������������������������������������������Ŀ
		//�Iniciar lancamento do PCO                                       �
		//������������������������������������������������������������������
		PcoIniLan("000051")
		PcoIniLan("000052")
		
		DEFINE MSDIALOG oDlg TITLE cCadastro FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL
		
		ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||Iif(VALIDAOK(aPropostas),(lOk := .T.,aItens:=aClone(aItens) ,aPropostas:=aClone(aPropostas),oDlg:End()),.T.)},{||lOk:= .F., oDlg:End()}),ConstLayer(oDlg, @aItens, @aPropostas,@aItensC,@cTpDoc))
		
		If lOk .AND. ExistBlock("MT161OK")
			lMT161Ok := ExecBlock("MT161OK",.F.,.F.,aPropostas)
			If ValType( lMT161Ok ) == "L"
				lOk := lMT161Ok
			EndIf
		EndIf
		
		If lOk
			nTpDoc := aScan(aItensC,{|x| x == cTpDoc})
			U_xM24GerDoc(aItens,aPropostas,nTpDoc) //Efetua a gera��o do pedido de compra ou contrato
		EndIf
		
		//�����������������������������������������������������������Ŀ
		//� Finaliza processo de lancamento do PCO                    �
		//�������������������������������������������������������������
		PcoFinLan("000051")
		PcoFinLan("000052")
		PcoFreeBlq("000051")
		PcoFreeBlq("000052")
		
	Endif
	
	SetKey( VK_F4,{||NIL} )
	SetKey( VK_F5,{||NIL} )
	SetKey( VK_F6,{||NIL} )
	SetKey( VK_F7,{||NIL} )
	
	RestArea(aArea)
	RestArea(aAreaSC8)
	
Return Nil

Static Function ConstLayer(oDlg, aItens, aPropostas,aItensC,cTpDoc)
	
	Local oFWLayer
	Local oPanel0
	Local oPanel1
	Local oPanel2
	Local oPanel3
	Local oBrowse1
	Local oBrowse2
	Local oBrowse3
	Local oVlrFinal
	
	Local aCoors		:= {}
	
	Local dDataVld 	:= SC8->C8_VALIDA
	Local cCotacao 	:= SC8->C8_NUM
	
	Local cFor1		:= ''
	Local cFor2		:= ''
	Local cCondPag1	:= SC8->C8_COND
	Local cCondPag2	:= Space(30)
	Local cTpFrete1	:= Space(30)
	Local cTpFrete2	:= Space(30)
	
	Local nVlrFinal		:= 0
	Local nPag			:= 1
	Local nNumPag		:= 0
	Local nProp1		:= 0
	Local nProp2		:= 0
	Local nVlTot1		:= 0
	Local nVlTot2		:= 0
	Local nI			:= 0
	Local nOpcA			:= 0
	
	Local nPercent1
	Local nPercent2
	Local nAltura
	
	Local lSugere		:= MV_PAR03==1
	Local aCamposPE		:= {}
	Local aCposProd		:= {}	
	
	Setkey( VK_F4,{||U_xM24HPro(aItens[oBrowse1:At()][1])})
	Setkey( VK_F5,{||U_xM24MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(nPag > 1,--nPag,1), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1)})
	Setkey( VK_F6,{||U_xM24MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(Len(aPropostas) <= nPag,nPag,++nPag), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1)})
	SetKey( VK_F7,{||U_xM24HForn(aPropostas[nPag][1][1][1],aPropostas[nPag][1][1][2])})
	SetKey( VK_F8,{||U_xM24HForn(aPropostas[nPag][2][1][1],aPropostas[nPag][2][1][2])})
	
	A161Prop(cCotacao, @aItens, @aPropostas ) //Efetua a montagem do array para ser usado na interface do Mapa de Cota��o

	// Ponto de entrada para adicionar campos nas grids de dados das propostas dos fornecedores
	If ExistBlock("MT161CPO")
		nTamProp := Len(aPropostas[1,1,2,1])
		nTamProd := Len(aItens[1])
		aRetPE := ExecBlock("MT161CPO",.F.,.F.,{aPropostas,aItens})
		If ValType(aRetPE) == "A"
			aPropostas := aRetPE[1]
			aCamposPE  := aRetPE[2]
			aItens     := aRetPE[3]
			aCposProd  := aRetPE[4]
		EndIf
	EndIf
	
	nNumPag := Len(aPropostas)
	
	oPanel0:= tPanel():New(0,0,,oDlg,,,,,,0,0)
	oPanel0:Align := CONTROL_ALIGN_ALLCLIENT
	
	// Cria instancia do fwlayer
	oFWLayer := FWLayer():New()
	
	// Inicializa componente passa a Dialog criada,o segundo parametro � para
	// cria��o de um botao de fechar utilizado para Dlg sem cabe�alho
	oFWLayer:Init(oPanel0,.F./*,.T.*/)
	
	oPanel0:ReadClientCoors(.T.,.T.)
	nAltura := oPanel0:nHeight
	
	nPercent1 := (210 * 100) / nAltura
	nPercent2 := 100 - nPercent1
	
	// Efetua a montagem das linhas das telas
	
	oFWLayer:addLine("LINHA1",nPercent1,.T.)
	oFWLayer:addLine("LINHA2",nPercent2,.F.)
	
	// Efetua a montagem das colunas das telas
	oFWLayer:AddCollumn("BOX1",34,.T.,"LINHA1")
	oFWLayer:AddCollumn("BOX2",33,.T.,"LINHA1")
	oFWLayer:AddCollumn("BOX3",33,.T.,"LINHA1")
	
	oFWLayer:AddCollumn("BOX4",34,.T.,"LINHA2")
	oFWLayer:AddCollumn("BOX5",33,.T.,"LINHA2")
	oFWLayer:AddCollumn("BOX6",33,.T.,"LINHA2")
	
	// Cria a window passando, nome da coluna onde sera criada, nome da window
	// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
	// se � redimensionada em caso de minimizar outras janelas e a a��o no click do split
	oFWLayer:AddWindow("BOX1","oPanel1","Dados da Cota��o"	,100,.F.,.T.,,"LINHA1",{ || })//"Dados da Cota��o"
	oFWLayer:AddWindow("BOX2","oPanel2","Dados da Proposta"	,100,.F.,.T.,,"LINHA1",{ || })//"Dados da Proposta"
	oFWLayer:AddWindow("BOX3","oPanel3","Dados da Proposta"	,100,.F.,.T.,,"LINHA1",{ || })//"Dados da Proposta"
	
	oFWLayer:AddWindow("BOX4","oPanel4","Produtos"			,100,.F.,.T.,,"LINHA2",{ || })//"Produtos"
	oFWLayer:AddWindow("BOX5","oPanel5","Item da Proposta"	,100,.F.,.T.,,"LINHA2",{ || })//"Item da Proposta"
	oFWLayer:AddWindow("BOX6","oPanel6","Item da Proposta"	,100,.F.,.T.,,"LINHA2",{ || })//"Item da Proposta"
	
	// Retorna o objeto do painel da Janela
	oPanel1 := oFWLayer:GetWinPanel("BOX1","oPanel1","LINHA1")
	oPanel2 := oFWLayer:GetWinPanel("BOX2","oPanel2","LINHA1")
	oPanel3 := oFWLayer:GetWinPanel("BOX3","oPanel3","LINHA1")
	
	oPanel4 := oFWLayer:GetWinPanel("BOX4","oPanel4","LINHA2")
	oPanel5 := oFWLayer:GetWinPanel("BOX5","oPanel5","LINHA2")
	oPanel6 := oFWLayer:GetWinPanel("BOX6","oPanel6","LINHA2")
	
	// Dados da cota��o
	@ 7,2 SAY RetTitle("C8_NUM") OF oPanel1 PIXEL
	@ 5,37 MSGET cCotacao SIZE 30,10 WHEN .F. OF oPanel1 PIXEL
	
	@ 27,2 SAY RetTitle("C8_VALIDA") OF oPanel1 PIXEL
	@ 25,37 MSGET dDataVld SIZE 50,10 WHEN .F. OF oPanel1 PIXEL
	
	@ 47,2 SAY "Valor Final"  OF oPanel1 PIXEL //"Valor Final"
	@ 45,37 MSGET oVlrFinal VAR nVlrFinal SIZE 50,10 WHEN .F. PICTURE PesqPict("SC8","C8_TOTAL") OF oPanel1 PIXEL
	
	@ 7,96 SAY RetTitle("C8_TPDOC") OF oPanel1 PIXEL
	@ 5,120 MSCOMBOBOX cTpDoc ITEMS aItensC SIZE 68,14 WHEN .T./*aScan(aItens,{|x| x[9] == .F.  }) >0*/ OF oPanel1 PIXEL
	
	@ 27,96 SAY 'P�gina' OF oPanel1 PIXEL//'P�gina'
	@ 25,120 MSGET nPag SIZE 20,10 VALID nPag > 0 .And. nPag <= nNumPag .And. ;
		U_xM24MovPag(aPropostas, @oBrowse2, @oBrowse3, nPag, @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2,@oPanel3,oBrowse1);
		OF oPanel1 PIXEL
	
	@ 27,143 SAY '/' OF oPanel1 PIXEL//'/'
	@ 25,148 MSGET nNumPag SIZE 20,10 WHEN .F. OF oPanel1 PIXEL
	
	TButton():Create(oPanel1,63,2,'Hist�rico do Produto (F4)',{||U_xM24HPro(aItens[oBrowse1:At()][1])},85,13,,,,.T.,,'Hist�rico do Produto (F4)',,,,)//STR0022//'Hist�rico do Produto (F4)'
	TButton():Create(oPanel1,45,120,'P�gina Anterior (F5)',{|| U_xM24MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(nPag > 1,--nPag,1), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1 )},67,13,,,,.T.,,'P�gina Anterior (F5)',,,,)//STR0024//'P�gina Anterior (F5)'
	TButton():Create(oPanel1,63,120,'Pr�xima P�gina (F6)' ,{|| U_xM24MovPag(aPropostas, @oBrowse2, @oBrowse3, IIF(Len(aPropostas) <= nPag,nPag,++nPag), @cFor1, @nProp1, @cCondPag1, @cTpFrete1, @nVlTot1,@cFor2, @nProp2, @cCondPag2, @cTpFrete2, @nVlTot2, @oPanel3,oBrowse1)},67,13,,,,.T.,,'Pr�xima P�gina (F6)',,,,)//STR0026//'Pr�xima P�gina (F6)'
	
	// Dados do PRIMEIRO fornecedor na tela
	if !Empty(aPropostas[1][1][1])
		cFor1 		:= aPropostas[1][1][1][3]
		nProp1		:= aPropostas[1][1][1][4]
		cCondPag1	:= aPropostas[1][1][1][5]
		cTpFrete1	:= U_xM24DscFrt(aPropostas[1][1][1][6])
		nVlTot1	:= aPropostas[1][1][1][7]
	Else
		oPanel3:lVisible := .F.
		oPanel6:lVisible := .F.
		SetKey( VK_F8,{||NIL} )
	EndIf
	
	@ 7,2 SAY 'Fornecedor' OF oPanel2 PIXEL//'Fornecedor'
	@ 5,35 MSGET cFor1 SIZE 153,10 WHEN .F. OF oPanel2 PIXEL
	
	@ 27,2 SAY 'Proposta' OF oPanel2 PIXEL//'Proposta'
	@ 25,35 MSGET nProp1 SIZE 30,10 WHEN .F. OF oPanel2 PIXEL
	
	@ 47,2 SAY 'Tp. Frete'	OF oPanel2 PIXEL//'Tp. Frete'
	@ 45,35 MSGET cTpFrete1 SIZE 30,10 WHEN .F. OF oPanel2 PIXEL
	
	@ 27,90 SAY 'Cond. Pagto' OF oPanel2 PIXEL//'Cond. Pagto'
	@ 25,125 MSGET cCondPag1 SIZE 63,10 WHEN .F. OF oPanel2 PIXEL
	
	
	@ 47,90 SAY 'Vl. Total' OF oPanel2 PIXEL//'Vl. Total'
	@ 45,125 MSGET nVlTot1 SIZE 63,10 WHEN .F. PICTURE PesqPict("SC8","C8_TOTAL") OF oPanel2 PIXEL
	
	TButton():Create(oPanel2,63,35,'Hist�rico do Fornecedor (F7)',{||U_xM24HForn(aPropostas[nPag][1][1][1],aPropostas[nPag][1][1][2])},153,13,,,,.T.,,'Hist�rico do Fornecedor (F7)',,,,)//STR0033//'Hist�rico do Fornecedor (F7)'
	
	// Dados do SEGUNDO fornecedor na tela
	If !Empty(aPropostas[1,2,1])
		cFor2 		:= aPropostas[1][2][1][3]
		nProp2		:= aPropostas[1][2][1][4]
		cCondPag2	:= aPropostas[1][2][1][5]
		cTpFrete2	:= U_xM24DscFrt(aPropostas[1][2][1][6])
		nVlTot2	:= aPropostas[1][2][1][7]
		SetKey(VK_F8,{||U_xM24HForn(aPropostas[nPag][2][1][1],aPropostas[nPag][2][1][2])})
	Else
		oPanel3:lVisible := .F.
		oPanel6:lVisible := .F.
		SetKey( VK_F8,{||NIL} )
	EndIf
	
	@ 7,2 SAY 'Fornecedor' OF oPanel3 PIXEL//'Fornecedor'
	@ 5,35 MSGET cFor2 SIZE 153,10 WHEN .F. OF oPanel3 PIXEL
	
	@ 27,2 SAY 'Proposta' OF oPanel3 PIXEL//'Proposta'
	@ 25,35 MSGET nProp2 SIZE 30,10 WHEN	 .F. OF oPanel3 PIXEL
	
	@ 47,2 SAY 'Tp. Frete'	OF oPanel3 PIXEL//'Tp. Frete'
	@ 45,35 MSGET cTpFrete2 SIZE 30,10 WHEN .F. OF oPanel3 PIXEL
	
	@ 27,90 SAY 'Cond. Pagto' OF oPanel3 PIXEL//'Cond. Pagto'
	@ 25,125 MSGET cCondPag2 SIZE 63,10 WHEN .F. OF oPanel3 PIXEL
	
	@ 47,90 SAY 'Vl. Total' OF oPanel3 PIXEL//'Vl. Total'
	@ 45,125 MSGET nVlTot2 SIZE 63,10 WHEN .F. PICTURE PesqPict("SC8","C8_TOTAL") OF oPanel3 PIXEL
	
	TButton():Create(oPanel3,63,35,'Hist�rico do Fornecedor (F8)',{||U_xM24HForn(aPropostas[nPag][2][1][1],aPropostas[nPag][2][1][2])},153,13,,,,.T.,,'Hist�rico do Fornecedor (F8)',,,,)//STR0040//'Hist�rico do Fornecedor (F8)'
	
	// Carga de dados dos produtos
	DEFINE FWBROWSE oBrowse1 DATA ARRAY ARRAY aItens NO CONFIG  NO REPORT NO LOCATE OF oPanel4
	
	ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),1] } TITLE "Cod. Produto" HEADERCLICK�{�||�.T.�} OF oBrowse1//"Cod. Produto"
	ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),8] } TITLE "Descri��o" 	HEADERCLICK�{�||�.T.�}	OF oBrowse1//"Descri��o"
	ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),3] } TITLE "Quantidade" PICTURE PesqPict("SC8","C8_QUANT") HEADERCLICK�{�||�.T.�} OF oBrowse1//"Quantidade"
	
	//ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),15] } TITLE "Prc Unit�rio" PICTURE PesqPict("SC8","C8_PRECO") HEADERCLICK�{�||�.T.�} OF oBrowse1//"Prc Unit�rio"
	
	ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),4] } TITLE "UM" HEADERCLICK�{�||�.T.�} OF oBrowse1//"UM"
	ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),5] } TITLE "Necessidade" HEADERCLICK�{�||�.T.�} OF oBrowse1//"Necessidade"
	ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),6] } TITLE "Entrega" HEADERCLICK�{�||�.T.�} OF oBrowse1//"Entrega"
	//ADD COLUMN oColumn DATA { || aItens[oBrowse1:At(),7] } TITLE "Valor Final" PICTURE PesqPict("SC8","C8_TOTAL") HEADERCLICK�{�||�.T.�} OF oBrowse1//"Valor Final"
	
	For nX := 1 To Len(aCposProd)
		bBlocoPE := &( "{ || IIf(oBrowse1:At()  > 0 .and. oBrowse1:At() <= Len(aItens) , aItens[oBrowse1:At()," + cValToChar(nTamProd+nX) + "],Nil )}" )
		ADD COLUMN oColumn DATA bBlocoPE TITLE RetTitle(aCposProd[nX]) HEADERCLICK�{�||�.T.�} OF oBrowse1
	Next nX
	
	oBrowse1:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| U_xM24OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)}
	oBrowse1:SetLineHeight(25)
	
	ACTIVATE FWBROWSE oBrowse1
	
	// Carga de dados da primeira proposta na tela
	DEFINE FWBROWSE oBrowse2 DATA ARRAY ARRAY aPropostas[nPag,1,2] NO CONFIG  NO REPORT NO LOCATE OF oPanel5
	oBrowse2:AddMarkColumns( { || IIf( aPropostas[nPag,1,2,oBrowse2:At(),1], "AVGLBPAR1","" ) },;
		{ || A161DesMark(nPag,1,oBrowse2:At(),@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3,.F.),;
		nVlrFinal:= A161CalTot(aItens),oVlrFinal:Refresh()},;
		{ || A161MarkAll(nPag,1,@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
		nVlrFinal:= A161CalTot(aItens),oVlrFinal:Refresh()})
	
	ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,1,2,oBrowse2:At(),2]),Transform(aPropostas[nPag,1,2,oBrowse2:At(),4], PesqPict("SC8","C8_TOTAL")),'') } TITLE 'Valor Total' SIZE 12 HEADERCLICK�{�||�.T.�} OF oBrowse2//'Valor Total'
	ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,1,2,oBrowse2:At(),2]),Transform(aPropostas[nPag,1,2,oBrowse2:At(),4], PesqPict("SC8","C8_PRECO")),'') } TITLE 'Preco Unitar' SIZE 12 HEADERCLICK�{�||�.T.�} OF oBrowse2//'Preco Unitario'
	ADD COLUMN oColumn DATA { || aPropostas[nPag,1,2,oBrowse2:At(),5] } PICTURE PesqPict("SC8","C8_DATPRF") Type 'D' TITLE 'Entrega' SIZE 20 HEADERCLICK�{�||�.T.�} OF oBrowse2//'Entrega'
	ADD COLUMN oColumn DATA {||'Memo'} PICTURE '@!' TITLE RetTitle("C8_OBS") SIZE 20 HEADERCLICK�{�||�.T.�} DOUBLECLICK {|| ShowBMemo(@aPropostas[nPag,1,2,oBrowse2:At(),6])}   OF oBrowse2

	For nX := 1 To Len(aCamposPE)
		bBlocoPE := &( "{ || aPropostas[nPag,1,2,oBrowse2:At()," + cValToChar(nTamProp+nX) + "] }" )
		ADD COLUMN oColumn DATA bBlocoPE PICTURE PesqPict("SC8",aCamposPE[nX]) TITLE RetTitle(aCamposPE[nX]) SIZE 20 HEADERCLICK�{�||�.T.�} OF oBrowse2
	Next nX
	
	oBrowse2:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| U_xM24OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)}
	oBrowse2:SetLineHeight(25)
	oBrowse2:SetBlkBackColor({|| IIf(Empty(aPropostas[nPag,1,2,oBrowse2:At(),5]), CLR_LIGHTGRAY, Nil) })
	
	ACTIVATE FWBROWSE oBrowse2
	
	// Carga de dados da segunda proposta na tela
	DEFINE FWBROWSE oBrowse3 DATA ARRAY ARRAY aPropostas[nPag,2,2] NO CONFIG  NO REPORT NO LOCATE OF oPanel6
	oBrowse3:AddMarkColumns(	{ || IIf( !Empty(aPropostas[nPag,2,2]) .And. aPropostas[nPag,2,2,oBrowse3:At(),1], 'AVGLBPAR1','' ) },;
		{ || A161DesMark(nPag,2,oBrowse3:At(),@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3,.F.),;
		nVlrFinal:= A161CalTot(aItens), oVlrFinal:Refresh()},;
		{ || A161MarkAll(nPag,2,@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3),;
		nVlrFinal:= A161CalTot(aItens), oVlrFinal:Refresh()})
	
	ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,2,2]) .And. !Empty(aPropostas[nPag,2,2,oBrowse3:At(),2]),Transform(aPropostas[nPag,2,2,oBrowse3:At(),4], PesqPict("SC8","C8_TOTAL")),'') } TITLE 'Valor Total' SIZE 12 HEADERCLICK�{�||�.T.�} OF oBrowse3//'Valor Total'
	ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,2,2]) .And. !Empty(aPropostas[nPag,2,2,oBrowse3:At(),2]),Transform(aPropostas[nPag,2,2,oBrowse3:At(),4], PesqPict("SC8","C8_PRECO")),'') } TITLE 'Preco Unitar' SIZE 12 HEADERCLICK�{�||�.T.�} OF oBrowse3//'Preco Unitar'	
	ADD COLUMN oColumn DATA { || IIf(!Empty(aPropostas[nPag,2,2]),aPropostas[nPag,2,2,oBrowse3:At(),5],'') } PICTURE PesqPict("SC8","C8_DATPRF") TITLE 'Entrega' SIZE 20 HEADERCLICK�{�||�.T.�} OF oBrowse3//'Entrega'
	ADD COLUMN oColumn DATA {||'Memo'} PICTURE '@!' TITLE RetTitle("C8_OBS") SIZE 20 HEADERCLICK�{�||�.T.�} DOUBLECLICK {|| ShowBMemo(@aPropostas[nPag,2,2,oBrowse3:At(),6])}   OF oBrowse3

	For nX := 1 To Len(aCamposPE)
		bBlocoPE := &( "{ || aPropostas[nPag,2,2,oBrowse3:At()," + cValToChar(nTamProp+nX) + "] }" )
		ADD COLUMN oColumn DATA bBlocoPE PICTURE PesqPict("SC8",aCamposPE[nX]) TITLE RetTitle(aCamposPE[nX]) SIZE 20 HEADERCLICK�{�||�.T.�} OF oBrowse3
	Next nX
	
	oBrowse3:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| U_xM24OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)}
	oBrowse3:SetLineHeight(25)
	oBrowse3:SetBlkBackColor({|| IIf(Empty(aPropostas[nPag,2,2,oBrowse3:At(),5]), CLR_LIGHTGRAY, Nil) })
	
	ACTIVATE FWBROWSE oBrowse3
	
	// -----------------------------------------------------------------------
	// Sugest�o do Vencedor
	// -----------------------------------------------------------------------
	If lSugere
		If MV_PAR05 == 0 .And. MV_PAR06 == 0 .And. MV_PAR07 == 0
			Help("",1,"U_xM24CotVen",,'Linha 414, Problema Sugest�o',4,1)
		Else
			U_xM24CotVen(aItens,aPropostas,oBrowse1,oBrowse2,oBrowse3)
		EndIf
	EndIf
	
	nVlrFinal:= A161CalTot(aItens)
	
	oPanel1:Refresh()
	oVlrFinal:Refresh() // Atualiza o campo Valor Final.
	
Return


//-------------------------------------------------------------------
/*{Protheus.doc} A161OnMove
Fun��o responsavel por atualizar cursor nas linhas do Browser
@author antenor.silva
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
User Function xM24OnMove(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2,oBrowse3)//A161OnMove
	
	oBrowse1:OnMove(oBrowse1:oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow)
	oBrowse2:OnMove(oBrowse2:oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow)
	oBrowse3:OnMove(oBrowse3:oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow)
	
Return Nil

//-------------------------------------------------------------------
/*{Protheus.doc} A161Prop
Efetua montagem do array de tens para a grid fixa e o array para as propostas.

@author Jos� Eul�lio
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function A161Prop(cNum, aItens, aPropostas )
	Local nPag 		:= 1
	Local nProp 		:= 1
	Local nX 			:= 0
	Local nPg 			:= 0
	Local nNumPro 	:= 0
	Local nY 			:= 1
	Local nPosRef1 	:= 0
	Local nPosRef2 	:= 0
	Local nCusto 		:= ''
	Local nPosRef 	:= 0
	Local nPa 			:= 0
	Local nPo 			:= 0
	
	Local cPgto		:= ''
	Local cQuery		:= ''
	Local cCodRef 	:= ''
	Local cMsg 		:= ''
	Local cAtuPos 	:= ''
	
	Local lWin 		:= .F.
	Local lFim 		:= .F.
	Local lGrdOk 		:= .F.
	
	Local aRefImpos 	:= {}
	
	Local nP     := 0
	Local nR     := 0
	Local nI     := 0
	Local nDif   := 0
	Local nPosId := 0
	
	Local aPags   := {} // Armazena a pagina e proposta utilizada para cada fornecedor.
	Local nArmPg  := 0 // Controle do AScan.
	Local nUltPag := 0 // Ultima pagina utilizada por um fornecedor.
	Local nUltPro := 0 // Ultima proposta utilizada por um fornecedor.
	
	//Query que retorna quantidade de propostas
	BeginSQL Alias "SC8PRO"
		SELECT C8_FORNECE,C8_LOJA,C8_NUMPRO
		FROM %Table:SC8%
		WHERE %NotDel% AND
		C8_FILIAL = %xFilial:SC8% AND
		C8_NUM = %Exp:cNum%
		GROUP BY C8_FORNECE,C8_LOJA,C8_NUMPRO
	EndSQL
	Do While SC8PRO->(!EOF())
		nNumPro += 1
		SC8PRO->(dbSkip())
	EndDo
	SC8PRO->(dbCloseArea())
	
	//Query que organiza as cota��es para o Array
	cQuery := "SELECT C8_PRODUTO, "
	cQuery += "R_E_C_N_O_ SC8REC, "
	cQuery += "C8_IDENT, "
	cQuery += "C8_ITEMGRD, "
	cQuery += "C8_NUMPRO, "
	cQuery += "C8_QUANT, "
	cQuery += "C8_UM, "
	cQuery += "C8_DATPRF, "
	cQuery += "C8_FILENT, "
	cQuery += "C8_NUMPED, "
	cQuery += "C8_NUMCON, "
	cQuery += "C8_FORNECE, "
	cQuery += "C8_LOJA, "
	cQuery += "C8_ITEM, "
	cQuery += "C8_NUM, "
	cQuery += "C8_COND, "
	cQuery += "C8_FORNOME, "
	cQuery += "C8_TPFRETE, "
	cQuery += "C8_PRAZO, "
	cQuery += "C8_ITEMSC, "
	cQuery += "C8_PRECO"
	cQuery += "FROM " + RetSQLName("SC8") + " "
	cQuery += "WHERE D_E_L_E_T_ = ' ' AND "
	cQuery += "C8_FILIAL = '" + xFilial("SC8") + "' AND "
	cQuery += "C8_NUM = '" + cNum + "' "
	cQuery += "ORDER BY C8_PRODUTO, C8_NUMPRO, C8_FORNECE, C8_LOJA"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SC8MAPA",.F.,.T.)
	
	//Quantidade de p�ginas
	nPg := Int(nNumPro / 2)
	If Mod(nNumPro,2) > 0
		nPg++
	EndIf
	
	//Array para a Refer�ncia do Imposto
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SC8"))
	While ( !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SC8" )
		nPosRef1 := At("MAFISREF(",Upper(SX3->X3_VALID))
		
		If ( nPosRef1 > 0 )
			
			nPosRef1 += 10
			nPosRef2 := At(",", SubStr(SX3->X3_VALID, nPosRef1)) - 2
			
			AAdd(aRefImpos,{"SC8", SX3->X3_CAMPO, SubStr(SX3->X3_VALID, nPosRef1, nPosRef2)})
			
		EndIf
		
		SX3->(dbSkip())
		
	EndDo
	
	/*------- Estrutura do Array de aItens --------*/
	
	//aItens[n,x]: Numero do item
	//aItens[n,1]: C8_PRODUTO
	//aItens[n,2]: C8_IDENT
	//aItens[n,3]: C8_QUANT
	//aItens[n,4]: C8_ UM
	//aItens[n,5]: C8_ DATPRF
	//aItens[n,6]: C8_ FILENT
	//aItens[n,7]: valor do produto por proposta escolhida
	//aItens[n,8]: Descri��o do Produto
	//aItens[n,9]: Flag finalizado
	//aItens[n,10]: Fornecedor
	//aItens[n,11]: Loja
	//aItens[n,12]: Item
	//aItens[n,13]: Numero da proposta
	//aItens[n,14]: Item da solicitacao
	//aItens[n,15]: PRECO UNITARIO
	
	/*------- Estrutura do Array de aPropostas --------*/
	
	//CABE�ALHO//
	//aPropostas[n]			: n�mero da p�gina
	//aPropostas[n,p]			: posi��o do pedido na p�gina (1,2)
	//aPropostas[n,p,1,x]	: Dados do cabe�alho da proposta
	//aPropostas[n,p,1,1 ]	: Cod Fornecedor
	//aPropostas[n,p,1,2 ]	: Loja
	//aPropostas[n,p,1,3 ]	: Nome
	//aPropostas[n,p,1,4 ]	: Proposta
	//aPropostas[n,p,1,5 ]	: Cond pagto
	//aPropostas[n,p,1,6 ]	: Frete
	//aPropostas[n,p,1,7 ]	: Valor total (soma de nCusto dos itens)
	//ITENS DA PROPOSTA//
	//aPropostas[n,p,2,x]	: Itens da proposta
	//aPropostas[n,p,2,x,1]	: Flag vencendor
	//aPropostas[n,p,2,x,2]	: Item
	//aPropostas[n,p,2,x,3]	: Cod produto
	//aPropostas[n,p,2,x,4]	: Valor total (nCusto)
	//aPropostas[n,p,2,x,5]	: Data de entrega
	//aPropostas[n,p,2,x,6]	: Observa��es
	//aPropostas[n,p,2,x,7]	: Filial Entrega
	//aPropostas[n,p,2,x,8]	: Flag finalizado
	//aPropostas[n,p,2,x,9]	: Recno SC8
	
	/*------- -------------------------------------- --------*/
	//Adiciona Array com quantidade de p�ginas, propostas e cabe�alho e itens de proposta pra cada
	For nX := 1 To nPg
		aAdd(aPropostas,{{{},{}},{{},{}}})
	Next nX
	
	// Variaveis de controle da pagina e proposta na tela.
	nPag    := 1
	nProp   := 1
	nUltPag := nPag
	nUltPro := nProp
	
	//Array de Itens na grid de Produtos
	While SC8MAPA->(!EOF())
		
		//Quebra do While de Propostas
		cQuebra := SC8MAPA->(C8_PRODUTO)
		
		While !SC8MAPA->(EOF()) .And. SC8MAPA->(C8_PRODUTO) == cQuebra
			
			SC8->(DbGoTo(SC8MAPA->SC8REC))
			
			cProduto := SC8MAPA->C8_PRODUTO
			
			If SC8->C8_GRADE == 'S'
				MatGrdPrRf(@cProduto, .T.)
				
				cDesc := MaGetDescGrd(cProduto) //Recupera nome do produto
				
			Else
				
				cDesc := Posicione("SB1", 1, xFilial("SB1")+cProduto, "B1_DESC")
				
			EndIf
			
			nPosPro := AScan(aItens, {|i| i[1] == SC8MAPA->C8_PRODUTO })
			
			If nPosPro == 0
				
				AAdd(aItens, {cProduto, SC8MAPA->C8_IDENT, SC8MAPA->C8_QUANT, SC8MAPA->C8_UM, SToD(SC8MAPA->C8_DATPRF), SC8MAPA->C8_FILENT, 0, cDesc, !Empty(SC8MAPA->C8_NUMPED), SC8MAPA->C8_FORNECE, SC8MAPA->C8_LOJA, SC8MAPA->C8_ITEM, SC8MAPA->C8_NUMPRO, SC8MAPA->C8_ITEMSC, SC8MAPA->C8_PRECO })
				
			Else
				
				If aItens[nPosPro][10] == SC8MAPA->C8_FORNECE .And. aItens[nPosPro][11] == SC8MAPA->C8_LOJA .And. aItens[nPosPro][13] == SC8MAPA->C8_NUMPRO
					
					AAdd(aItens, {cProduto, SC8MAPA->C8_IDENT, SC8MAPA->C8_QUANT, SC8MAPA->C8_UM, SToD(SC8MAPA->C8_DATPRF), SC8MAPA->C8_FILENT, 0, cDesc, !Empty(SC8MAPA->C8_NUMPED), SC8MAPA->C8_FORNECE, SC8MAPA->C8_LOJA, SC8MAPA->C8_ITEM, SC8MAPA->C8_NUMPRO, SC8MAPA->C8_ITEMSC, SC8MAPA->C8_PRECO })
					
				EndIf
				
			EndIf
			
			// Controle de paginas para o caso de produtos cotados somente para alguns fornecedores dentro da mesma cotacao.
			nArmPg := AScan(aPags, {|f| f[1] == SC8MAPA->C8_FORNECE .And. f[2] == SC8MAPA->C8_LOJA .And. f[5] == SC8MAPA->C8_NUMPRO})
			
			If nArmPg == 0
				
				nPag  := nUltPag
				nProp := nUltPro
				
				If !(nPag == 1 .And. Len(aPags) == 0)
					
					If nProp == 1
						
						nProp := 2
						
					Else
						
						nPag++
						
						nProp := 1
						
					EndIf
					
				EndIf
				
				AAdd(aPags, {SC8MAPA->C8_FORNECE, SC8MAPA->C8_LOJA, nPag, nProp, SC8MAPA->C8_NUMPRO})
				
				nUltPag := nPag
				nUltPro := nProp
				
			Else
				
				nPag  := aPags[nArmPg][3]
				nProp := aPags[nArmPg][4]
				
			EndIf
			
			//Adiciona posi��o no Array na primeira passagem
			If Empty(SC8MAPA->C8_ITEMGRD) .Or. SC8MAPA->C8_ITEMGRD == StrZero(1, Len(SC8MAPA->C8_ITEMGRD))
				
				AAdd(aPropostas[nPag, nProp, 2], {})
				
			EndIf
			
			//Tratamento para Preenche Array de aPropostas
			If SC8->(DbSeek(xFilial("SC8")+cNum+SC8MAPA->(C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD)))
				
				//Inicia o Valor
				lWin := .F.
				lFim := .F.
				
				//Verifica se tem numero de pedido e marca como vencedor
				If !Empty(SC8->C8_NUMPED) .Or. !Empty(SC8->C8_NUMCON)
					
					//Marca como Finalizado
					lFim := .T.
					
					//Marca como Vencedor/Perdedor
					If SC8->C8_NUMPED # Replicate('X', Len(SC8->C8_NUMPED)) .Or.;
							(SC8->C8_NUMCON # Replicate('X', Len(SC8->C8_NUMCON)) .And. !Empty(SC8->C8_NUMCON))
						
						lWin := .T.
						
					Else
						
						lWin := .F.
						
					EndIf
					
				EndIf
				
				//Calcula o Custo para o valor total do produto
				MaFisIni(SC8->C8_FORNECE, SC8->C8_LOJA, "F", "N", "R")
				MaFisIniLoad(1)
				
				For nY := 1 To Len(aRefImpos)
					
					MaFisLoad(aRefImpos[nY, 3], SC8->(FieldGet(FieldPos(aRefImpos[nY, 2]))), 1)
					
				Next nY
				
				MaFisEndLoad(1)
				
				nCusto := Ma160Custo("SC8",1)
				
				MaFisEnd()
				
				// Tratamento para adicionar cabe�alho somente uma vez
				If Empty(aPropostas[nPag, nProp, 1])
					
					//Recupera condi��o de pagamento
					cPgto := Posicione("SE4", 1, xFilial("SE4")+SC8->C8_COND, "E4_DESCRI")
					
					//Preenche Array do Cabe�alho
					aPropostas[nPag, nProp, 1] := {SC8->C8_FORNECE, SC8->C8_LOJA, SC8->C8_FORNOME, SC8->C8_NUMPRO, cPgto, SC8->C8_TPFRETE, 0}
					
				EndIf
				
				//Tratamento para Itens de Grade
				If SC8->C8_GRADE == 'S'
					
					cCodRef := SC8->C8_PRODUTO
					cFrnRef := SC8->C8_FORNECE
					cLojRef := SC8->C8_LOJA
					
					lReferencia := MatGrdPrRf(@cCodRef, .T.)
					
					//Caso exista Item de Grade, apenas soma nCusto ao produto existente na Proposta
					If !Empty(aPropostas[nPag, nProp, 2]) .And. !Empty(aPropostas[nPag, nProp, 2, 1]) .And. Type("aPropostas[nPag, nProp, 2, 3]") <> 'U' .And. (nPosRef := AScan(aPropostas[nPag, nProp, 2], {|x| x[3] == cCodRef} )) > 0
						
						aPropostas[nPag, nProp, 2, nPosRef, 4] += nCusto
						
						//Soma nCusto no Valor total do Cabe�alho
						aPropostas[nPag, nProp, 1, 7] += nCusto
						
					Else
						
						//Preenche Array dos Produtos de cada proposta
						aTail(aPropostas[nPag, nProp, 2]) := {lWin, SC8->C8_ITEM, cCodRef, nCusto, (DATE()+SC8->C8_PRAZO), SC8->C8_OBS, SC8->C8_FILENT, lFim, SC8->(Recno()), SC8->C8_IDENT, Len(aItens), SC8->C8_NUMPRO}
						
						//Soma nCusto no Valor total do Cabe�alho
						aPropostas[nPag, nProp, 1, 7] += nCusto
						
					EndIf
					
				Else
					
					//Preenche Array dos Produtos de cada proposta
					aTail(aPropostas[nPag, nProp, 2]) := {lWin, SC8->C8_ITEM, SC8->C8_PRODUTO, nCusto, (DATE()+SC8->C8_PRAZO), SC8->C8_OBS, SC8->C8_FILENT, lFim, SC8->(Recno()), SC8->C8_IDENT, Len(aItens), SC8->C8_NUMPRO}
					
					//Soma nCusto no Valor total do Cabe�alho
					aPropostas[nPag, nProp, 1, 7] += nCusto
					
				EndIf
				
			ElseIf Empty(SC8MAPA->C8_ITEMGRD)
				
				//Preenche Vazio Array de aProspostas, caso n�o hava o produto para aquela proposta
				aTail(aPropostas[nPag, nProp, 2]) := {.F., '' , '', 0, CToD('//'), '', '', .F., 0, '', Len(aItens),""}
				
			EndIf
			
			If lWin
				
				aItens[Len(aItens), 7] := aPropostas[nPag, nProp, 2, Len(aPropostas[nPag, nProp, 2]), 4]
				
			EndIf
			
			//Preenche vari�veis para verificar se � uma proposta (fornecedor) diferente
			cAtuPos := SC8MAPA->(C8_FORNECE+C8_LOJA+C8_NUMPRO)
			
			//Skip para a pr�xima linha da busca
			SC8MAPA->(DbSkip())
			
			//Atualiza a posi��o do Array, caso n�o seja o mesmo item de Grade
			/*If (SC8MAPA->(C8_FORNECE+C8_LOJA+C8_NUMPRO)) # cAtuPos
			
			If nProp == 1
				
				nProp := 2
				
			Else
				
				nPag++
				
				nProp := 1
				
			EndIf
			
		EndIf*/
		
	EndDo
	
EndDo

// Tratamento para incluir linhas em branco no array aProposta, pois podemos ter uma proposta com mais produtos do que a outra.
For nP := 1 To Len(aPropostas)
	
	For nR := 1 To Len(aPropostas[nP])
		
		If Len(aPropostas[nP][nR][2]) < Len(aItens)
			
			nDif := Len(aItens) - Len(aPropostas[nP][nR][2]) // Quantos itens faltam para igualar as linhas entre as propostas.
			
			For nI := 1 To nDif
				
				// Adiciona posicoes faltantes para igualar as propostas, caso necessario.
				AAdd(aPropostas[nP, nR, 2], {})
				
				aTail(aPropostas[nP, nR, 2]) := {.F., '' , '', 0, CToD('//'), '', '', .F., 0, '',0,""}
				
			Next nI
			
			For nI := 1 To Len(aPropostas[nP][nR][2])
				
				If aPropostas[nP, nR, 2, nI, 9] > 0
					
					// Aqui verifico qual a posicao correta do item com proposta no array de itens vazios (sem proposta).
					SC8->(DbGoTo(aPropostas[nP, nR, 2, nI, 9])) // Item com proposta.
					
					nPosId := AScan(aItens, {|i| i[2] == SC8->C8_IDENT})
					
					If nPosId # nI
						
						// Posiciona o item na ordem correta dentro do array de propostas.
						aPropostas[nP, nR, 2, nPosId] := aPropostas[nP, nR, 2, nI]
						
						// Como o item estava na posi��o errada, limpo as colunas do array.
						aPropostas[nP, nR, 2, nI] := {.F., '' , '', 0, CToD('//'), '', '', .F., 0, '',0,""}
						
					EndIf
					
				EndIf
				
			Next nI
			
		EndIf
		
	Next nR
	
Next nP

SC8MAPA->(DbCloseArea())

Return NIL

//-------------------------------------------------------------------
/*{Protheus.doc} A161GerDoc
Fun��o responsavel por gerar pedidos utilizando a fun��o MaAvalCot
@param aItens Array de Itens da cota��o
@param aPropostas Array de propostas da cota��o
@author Leonardo Quintania
@since 29/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
User Function xM24GerDoc(aItens,aPropostas,nTipDoc)//A161GerDoc
	Local cAliasSC8	:= 'SC8'
	Local cProduto	:= ''
	Local cVencedor	:= ''
	Local cSeek		:= ''
	Local cNumCot		:= SC8->C8_NUM
	
	Local nEvento 	:= 4
	Local nSaveSX8  	:= GetSX8Len()
	Local nX			:= 0
	Local nY			:= 0
	Local nZ			:= 0
	Local nRet			:= 0
	Local nItem		:= 0
	Local nIProp		:= 0
	Local nWin			:= 0
	Local nIWin		:= 0
	
	Local aAux			:= U_xM24SemPag(aPropostas) //Retira o array de paginas deixando as propostas sequenciais
	Local aHeadSCE	:= {}
	Local aSC8			:= {}
	Local aWinProp	:= {}
	Local aButtons	:= {}
	Local aArea
	
	Local lRet			:= .T.
	Local lExit		:= .F.
	Local lClicB		:= A131VerInt()
	Private cCadastro	:= 'Cadastro de Fornecedores'//'Cadastro de Fornecedores'
	
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SCE"))
	While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SCE"
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) .Or. AllTrim(SX3->X3_CAMPO) == "CE_NUMPRO"
			If !(AllTrim(SX3->X3_CAMPO) $ "CE_NUMCOT;CE_ITEMCOT")
				AADD(aHeadSCE,{ TRIM(X3Titulo()),;
					Trim(SX3->X3_CAMPO),;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT } )
			Endif
		EndIf
		SX3->(dbSkip())
	EndDo
	
	
	//Realiza preenchimento no array aSC8 para utiliza��o na fun��o MaAvalCOT.
	
	For nX:= 1 To Len(aItens)
		
		If !aItens[nX,9]
			AADD(aSC8,{} 		)
			AADD(aWinProp,{}	)
			
			nItem 	:= Len(aSC8)
			nWin 	:= Len(aWinProp)
			
			For nY:= 1 To Len(aAux)	 //Array aPropostas desconsiderando paginas
				
				For nZ:= 1 To Len(aAux[nY,2]) //Array de Itens das aPropostas
					
					If aItens[nX,2] == aAux[nY,2,nZ,10] .And. aItens[nX,13] ==  aAux[nY,2,nZ,12] //Verifico se existe proposta para o item posicionado
						
						SC8->(dbGoTo(aAux[nY,2,nZ,9])) //Posiciono no SC8 para verificar se o fornecedor est� preenchido
						
						If aAux[nY,2,nZ,1] //Verifico se foi marcado o item como vencedor
							cVencedor:= SC8->(C8_FORNECE+C8_LOJA)
							If Empty(cVencedor)//Se estiver em branco esse fornecedor � um participante e deve ser cadastrado como fornecedor
								aButtons:= {'Sim','N�o','Sim p/ Todos','N�o p/ Todos'} //STR0053,STR0054,STR0055,STR0056//'Sim'//'N�o'//'Sim p/ Todos'//'N�o p/ Todos'
								If nRet < 3 //'Sim','N�o','Sim p/ Todos'
									nRet:= Aviso('Aten��o','O item '+ aAux[nY,2,nZ,2]	+' - '+ AllTrim(aAux[nY,2,nZ,3]) +' - '+AllTrim(aItens[nX,8])+'teve como ganhador um participante n�o cadastrado como fornecedor'+AllTrim(aAux[nY,1,3])+ 'Deseja cadastr�-lo agora? Em caso negativo, este item da cota��o n�o ser� finalizado.',aButtons,2)//'Aten��o'//'O item '//' teve como ganhador um participante n�o cadastrado como fornecedor ('//'). Deseja cadastr�-lo agora? Em caso negativo, este item da cota��o n�o ser� finalizado.'
								EndIf
								
								If nRet==1 .Or. nRet==3 //'Sim','Sim p/ Todos'
									lRet := (A020WebbIc({ {"A2_NREDUZ",SC8->C8_FORNOME},{"A2_EMAIL",SC8->C8_FORMAIL} })) == 1
									If lRet
										A161AtuCot(SC8->C8_FORNOME,SA2->A2_COD,SA2->A2_LOJA)
										cVencedor:= SA2->(A2_COD+A2_LOJA)
									EndIf
									
								Else
									lRet:= .F.
								EndIf
							EndIf
							
						EndIf
						
						If lRet
							
							cRefer := SC8->C8_PRODUTO
							lReferencia := MatGrdPrRf(@cRefer,.T.) .And. AllTrim(cRefer) == AllTrim(aItens[nX,1])
							
							If lReferencia
								SC8->(dbSetOrder(4))//C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO
								cSeek := xFilial('SC8')+SC8->(C8_NUM+C8_IDENT)
								SC8->(dbSeek(cSeek))
							EndIf
							
							While !lReferencia .Or. (!SC8->(EOF()) .And. SC8->(C8_FILIAL+C8_NUM+C8_IDENT) == cSeek)
								AADD(aSC8[nItem],{})
								nIProp := Len(aSC8[nItem])
								
								AADD(aSC8[nItem,nIProp],{'C8_ITEM'		, SC8->C8_ITEM		} )
								AADD(aSC8[nItem,nIProp],{'C8_NUMPRO'	, SC8->C8_NUMPRO		} )
								AADD(aSC8[nItem,nIProp],{'C8_PRODUTO'	, SC8->C8_PRODUTO		} )
								AADD(aSC8[nItem,nIProp],{'C8_COND'		, SC8->C8_COND		} )
								AADD(aSC8[nItem,nIProp],{'C8_FORNECE'	, SC8->C8_FORNECE		} )
								AADD(aSC8[nItem,nIProp],{'C8_LOJA'		, SC8->C8_LOJA		} )
								AADD(aSC8[nItem,nIProp],{'C8_NUM'		, SC8->C8_NUM			} )
								AADD(aSC8[nItem,nIProp],{'C8_ITEMGRD'	, SC8->C8_ITEMGRD		} )
								AADD(aSC8[nItem,nIProp],{'C8_NUMSC'	, SC8->C8_NUMSC		} )
								AADD(aSC8[nItem,nIProp],{'C8_ITEMSC'	, SC8->C8_ITEMSC		} )
								AADD(aSC8[nItem,nIProp],{'C8_FILENT'	, SC8->C8_FILENT		} )
								AADD(aSC8[nItem,nIProp],{'C8_OBS'		, aAux[nY, 2, nZ, 6]	} )
								AADD(aSC8[nItem,nIProp],{'SC8RECNO'	, SC8->(Recno())		} )
								If !aAux[nY,2,nZ,8] //Flag de Finalizado
									AADD(aWinProp[nWin],{} )
									nIWin := Len(aSC8[nWin])
									
									AADD(aWinProp[nWin,nIWin] , SC8->C8_NUMPRO			) //CE_NUMPRO
									AADD(aWinProp[nWin,nIWin] , SC8->C8_FORNECE			) //CE_FORNECE
									AADD(aWinProp[nWin,nIWin] , SC8->C8_LOJA	 			) //CE_LOJA
									If cVencedor == SC8->(C8_FORNECE+C8_LOJA) .and. aAux[nY,2,nZ,1] 			//Verifica se � o fornecedor vencedor posicionado
										AADD(aWinProp[nWin,nIWin] , SC8->C8_QUANT	 		) //CE_QUANT
										cVencedor:= ''
										aAux[nY,2,nZ,1]:=.F.
									Else
										AADD(aWinProp[nWin,nIWin] , 0				 		) //CE_QUANT com quantidade zero para marcar XXXXXXXX
										cVencedor:= ''
									EndIf
									AADD(aWinProp[nWin,nIWin] , SC8->C8_MOTIVO 			) //CE_MOTIVO
									AADD(aWinProp[nWin,nIWin] , (Date()+SC8->C8_PRAZO) 	) //CE_ENTREGA
									AADD(aWinProp[nWin,nIWin] , 0				 			) //CE_REGIST
									AADD(aWinProp[nWin,nIWin] , SC8->C8_ITEMGRD			) //CE_ITEMGRD
									AADD(aWinProp[nWin,nIWin] , SC8->C8_ITEM				) //CE_ITEMCOT
									AADD(aWinProp[nWin,nIWin] , SC8->C8_NUM				) //CE_NUMCOT
									AADD(aWinProp[nWin,nIWin] , 'SC8'						) //CE_ALI_WT
									AADD(aWinProp[nWin,nIWin] , SC8->(Recno())			) //CE_REC_WT
								EndIf
								
								If !lReferencia
									Exit
								Else
									SC8->(dbSkip())
									lExit:= .T.
								EndIf
							End
							
						Else
							If nRet > 2 //'Sim p/ Todos','N�o p/ Todos'
								Aviso('Aten��o','O cadastro do participante '+AllTrim(aAux[nY,1,3])+' foi cancelado e a cota��o do item '+ aAux[nY,2,nZ,2]	+' - '+ AllTrim(aAux[nY,2,nZ,3]) +' - '+AllTrim(aItens[nX,8])+' n�o ser� finalizada.',{'OK'})//'Aten��o'//'O cadastro do participante '//' foi cancelado e a cota��o do item '//' n�o ser� finalizada.'//'Ok'
							EndIf
							lExit:= .T.
						EndIf
						
					EndIf
					If lExit
						Exit
					EndIf
				Next nZ
				If lExit
					Exit
				EndIf
			Next nY
			
		EndIf
		
	Next nX
	
	aArea := GetArea()
	Begin Transaction
		
		If nTipDoc == 1
			//Pedido de Compra
			If lRet .And. Len(aSC8) > 0 .And. ( U_xM24AvCot(cAliasSC8, nEvento, aSC8, aHeadSCE, aWinProp, .F., Nil, {|| .T.}) ) //Executa fun��o que gera pedidos de compra.
				EvalTrigger()
				While ( GetSX8Len() > nSaveSX8 )
					ConfirmSx8()
				EndDo
			Else
				While ( GetSX8Len() > nSaveSX8 )
					RollBackSx8()
				EndDo
			EndIf
		Else
			If lRet .And. U_xM24Cntr(aWinProp)
				While ( GetSX8Len() > nSaveSX8 )
					ConfirmSx8()
				EndDo
			Else
				While ( GetSX8Len() > nSaveSX8 )
					RollBackSx8()
				EndDo
			EndIf
		EndIf
		
		//Ponto de entrada para Workflow
		If ExistBlock( "MT160WF" )
			SC8->(dbSetOrder(1))
			SC8->(dbSeek(xFilial("SC8")+cNumCot))
			ExecBlock( "MT160WF", .f., .f., { cNumCot } )
		EndIf
		
		SC8->(dbSetOrder(4))
		SC8->(dbSeek(xFilial("SC8")+cNumCot))
		While !SC8->(Eof()) .AND. SC8->C8_NUM == cNumCot
			RecLock("SC8",.F.)
			SC8->C8_TPDOC := CvalToChar(nTipDoc)
			MsUnlock()
			SC8->(dbSkip())
		EndDo
	End Transaction
	
	If lClicB
		A311RegCot(cNumCot,2)
	Endif
	RestArea( aArea )
Return NIL

//-------------------------------------------------------------------
/*{Protheus.doc} A161SemPag
Fun��o responsavel por desconsiderar numero de pagina no array de aProposta
@param aPropostas Array de propostas da cota��o
@author Leonardo Quintania
@since 30/10/2013
@version P11.90
*/
//-------------------------------------------------------------------

User Function xM24SemPag(aPropostas) //A161SemPag
	Local aAux	:= {}
	Local nX	:=	0
	Local nY	:= 	0
	
	For nX:= 1 To Len(aPropostas)
		
		For nY:= 1 To Len(aPropostas[nX])
			
			aAdd(aAux, aPropostas[nX,nY] )
			
		Next nY
		
	Next nX
	
Return aAux

//-------------------------------------------------------------------
/*{Protheus.doc} A161HisForn
Fun��o responsavel por trazer o hist�rico do fornecedor
@author antenor.silva
@since 30/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
User Function xM24HForn(cFornece,cLoja)//A161HisForn
	Local aArea	:= GetArea()
	
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial('SA2')+cFornece+cLoja))
		
		If Pergunte("FIC030",.T.)
			Finc030("Fc030Con")
		EndIf
		
		Pergunte("MTA160",.F.)
		
	EndIf
	
	RestArea(aArea)
	
Return NIL

//-------------------------------------------------------------------
/*{Protheus.doc}
Fun��o responsavel por trazer o hist�rico do produto
@author antenor.silva
@since 30/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
User Function xM24HPro(cProduto)//U_xM24HPro
	Local aArea	:=	GetArea()
	
	MaFisSave()
	MaFisEnd()
	
	If !AtIsRotina("MACOMVIEW")
		If !Empty(cProduto)
			MaComView(cProduto)
		EndIf
	EndIf
	
	MaFisRestore()
	
	RestArea(aArea)
	
Return NIL

//-------------------------------------------------------------------
/*{Protheus.doc} A161DesMark
Desmarcar as propostas na sele��o
@param nPag Pagina da proposta Atual para desconsiderar da sele��o
@param nProp Numero da proposta Atual para desconsiderar da sele��o
@param nLinha Linha da proposta Atual
@param aPropostas Array de Propostas disponivel
@author Leonardo Quintania
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function A161DesMark(nPag,nProp,nLinha,aPropostas,aItens,oBrowse1,oBrowse2,oBrowse3,lObs)
	Local nX := 0
	Local nY := 0
	Local nZ := 0
	Local aAux	:= {}
	
	If !Empty(aPropostas[nPag,nProp,2,nLinha,2])
		If aPropostas[nPag, nProp, 2, nLinha, 4] > 0
			If !aPropostas[nPag,nProp,2,nLinha,8] //Verifica se na linha selecionada existe algum flag de finalizado.
				aPropostas[nPag,nProp,2,nLinha,1]:= !aPropostas[nPag,nProp,2,nLinha,1]
				If lObs
					
					aPropostas[nPag,nProp,2,nLinha,6]:= AllTrim(aPropostas[nPag,nProp,2,nLinha,6]) + Space(1) + 'ENCERRADO AUTOMATICAMENTE' // ENCERRADO AUTOMATICAMENTE
					
				EndIf
				If aPropostas[nPag,nProp,2,nLinha,1]
					aItens[nLinha,7] := aItens[nLinha,7] + aPropostas[nPag,nProp,2,nLinha,4]
				Else
					aItens[nLinha,7] := aItens[nLinha,7] - aPropostas[nPag,nProp,2,nLinha,4]
				EndIf
				For nX :=1 To Len(aPropostas)
					If aPropostas[nX,1,2,nLinha,1] .Or. (!Empty(aPropostas[nX,2,2]) .And. aPropostas[nX,2,2,nLinha,1])
						If nX # nPag .Or. nProp == 2
							
							If aPropostas[nX,1,2,nLinha,1]
								aPropostas[nX,1,2,nLinha,1] := .F.
								aItens[nLinha,7] := aItens[nLinha,7] - aPropostas[nX,1,2,nLinha,4]
							EndIf
							
						EndIf
						If (nX # nPag .Or. nProp == 1) .And. !Empty(aPropostas[nX,2,2])
							
							If aPropostas[nX,2,2,nLinha,1]
								aPropostas[nX,2,2,nLinha,1] := .F.
								aItens[nLinha,7] := aItens[nLinha,7] - aPropostas[nX,2,2,nLinha,4]
							EndIf
							
						EndIf
					EndIf
				Next nX
				
				If SuperGetMV("MV_PCOINTE",.F.,"2")=="1"
					SC8->(dbGoTo(aPropostas[nPag,nProp,2,nLinha,9]))
					SC1->(DbSetOrder(1))
					SC1->(dbSeek(xFilial("SC1")+SC8->(C8_NUMSC+C8_ITEMSC)))
					If !A161PcoVld(!aPropostas[nPag,nProp,2,nLinha,1])
						PcoFreeBlq('000051')
						PcoFreeBlq('000052')
						
						aPropostas[nPag,nProp,2,nLinha,1] := .F.
						
						If aPropostas[nPag,nProp,2,nLinha,1]
							aItens[nLinha,7] := aItens[nLinha,7] + aPropostas[nPag,nProp,2,nLinha,4]
						Else
							aItens[nLinha,7] := aItens[nLinha,7] - aPropostas[nPag,nProp,2,nLinha,4]
						EndIf
						For nX :=1 To Len(aPropostas)
							If aPropostas[nX,1,2,nLinha,1] .Or. (!Empty(aPropostas[nX,2,2]) .And. aPropostas[nX,2,2,nLinha,1])
								If nX # nPag .Or. nProp == 2
									If aPropostas[nX,1,2,nLinha,1]
										aPropostas[nX,1,2,nLinha,1] := .F.
										aItens[nLinha,7] := aItens[nLinha,7] - aPropostas[nX,1,2,nLinha,4]
									EndIf
								EndIf
								If (nX # nPag .Or. nProp == 1) .And. !Empty(aPropostas[nX,2,2])
									If aPropostas[nX,2,2,nLinha,1]
										aPropostas[nX,2,2,nLinha,1] := .F.
										aItens[nLinha,7] := aItens[nLinha,7] - aPropostas[nX,2,2,nLinha,4]
									EndIf
								EndIf
							EndIf
						Next nX
						
					EndIf
				EndIf
				
			EndIf
			
			oBrowse1:Refresh(.T.)
			oBrowse2:Refresh(.T.)
			oBrowse3:Refresh(.T.)
			
		Endif
	EndIf
	
Return NIL

//-------------------------------------------------------------------
/*{Protheus.doc} A161MarkAll
Efetua a marca��o de todos os itens da grid da proposta atual

@author Leonardo Quintania
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function A161MarkAll(nPag,nProp,aPropostas,aItens,oBrowse1,oBrowse2,oBrowse3)
	Local nX := 0
	Local lDesmark := .F.
	
	For nX :=1 To Len(aPropostas[nPag,nProp,2])
		If !aPropostas[nPag,nProp,2,nX,1]
			lDesmark := .T.
		EndIf
	Next nX
	
	For nX :=1 To Len(aPropostas[nPag,nProp,2])
		If !aPropostas[nPag,nProp,2,nX,8] .And. !Empty(aPropostas[nPag,nProp,2,nX,2])
			If lDesmark
				If !aPropostas[nPag,nProp,2,nX,1]
					A161DesMark(nPag,nProp,nX,@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3,.F.)
				Endif
			Else
				If aPropostas[nPag,nProp,2,nX,1]
					A161DesMark(nPag,nProp,nX,@aPropostas,@aItens,oBrowse1,oBrowse2,oBrowse3,.F.)
				Endif
			Endif
		EndIf
	Next nX
	
	
	oBrowse1:Refresh(.T.)
	oBrowse2:Refresh(.T.)
	oBrowse3:Refresh(.T.)
	
Return NIL

//-------------------------------------------------------------------
/*{Protheus.doc} A161CalTot
Calcula valor total da analise da cota��o

@author Leonardo Quintania
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function A161CalTot(aItens)
	Local nX 		:= 1
	Local nTotal	:= 0
	
	For nX :=1 To Len(aItens)
		nTotal+= aItens[nX,7]
		
	Next nX
	
	
Return nTotal

//-------------------------------------------------------------------
/*{Protheus.doc} U_xM24MovPag
Altera a pagina de propostas da cota��o
@author Antenor Silva
@since 28/10/2013
@version P11.90 U_xM24MovPag
*/
//-------------------------------------------------------------------
User Function xM24MovPag(aPropostas, oBrowse2, oBrowse3, nPagina, cFor1, nProp1, cCondPag1, cTpFrete1, nVlTot1, cFor2, nProp2, cCondPag2, cTpFrete2, nVlTot2,oPanel3,oBrowse1)
	Local lTam	:= 0
	
	If (Len(aPropostas) >= nPagina) .And. (nPagina > 0)
		
		//if !Empty(aPropostas[nPagina][1][1]) // Comentado, pois esta impedindo o avanco das paginas em alguns casos.
		lTam := !Empty(aPropostas[nPagina,2,1])
		
		oBrowse2:SetArray(aPropostas[nPagina,1,2])
		oBrowse2:Refresh(.T.)
		
		cFor1 		:= aPropostas[nPagina][1][1][3]
		nProp1		:= aPropostas[nPagina][1][1][4]
		cCondPag1	:= aPropostas[nPagina][1][1][5]
		cTpFrete1	:= U_xM24DscFrt(aPropostas[nPagina][1][1][6])
		nVlTot1	:= aPropostas[nPagina][1][1][7]
		
		If !lTam
			//Esconde o segundo browse
			oPanel3:lVisible := .F.
			oBrowse3:Hide()
			SetKey(VK_F8,{||Nil})
		Else
			oBrowse3:Show()
			oPanel3:lVisible := .T.
			oBrowse3:SetArray(aPropostas[nPagina,2,2])
			oBrowse3:Refresh(.T.)
			SetKey( VK_F8,{||U_xM24HForn(aPropostas[nPagina][2][1][1],aPropostas[nPagina][2][1][2])})
			
			cFor2 		:= aPropostas[nPagina][2][1][3]
			nProp2		:= aPropostas[nPagina][2][1][4]
			cCondPag2	:= aPropostas[nPagina][2][1][5]
			cTpFrete2	:= U_xM24DscFrt(aPropostas[nPagina][2][1][6])
			nVlTot2	:= aPropostas[nPagina][2][1][7]
		EndIf
		oBrowse1:Refresh(.T.)
		//EndIf
		
	EndIf
Return NIL

//-------------------------------------------------------------------
/*{Protheus.doc} A161AtuCot
Fun��o que efetua atualiza��o com o numero do fornecedor que foi cadastrado
@param cForNome Nome do fornecedor participante
@param cNewFor Codigo do fornecedor que foi cadastrado
@param cNewLoj Loja do fornecedor que foi cadastrado
@author Leonardo Quintania
@since 28/10/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function A161AtuCot(cForNome,cNewFor,cNewLoj)
	Local cFornece:= CriaVar("C8_FORNECE",.F.)
	Local aAreaSC8 := SC8->(GetArea())
	
	BeginSQL Alias 'SC8TMP'
		
		SELECT R_E_C_N_O_ SC8RECNO
		FROM %Table:SC8% SC8
		WHERE SC8.%NotDel% AND
		SC8.C8_FILIAL = %xFilial:SC8% AND
		SC8.C8_FORNOME = %Exp:cForNome% AND
		SC8.C8_FORNECE = %Exp:cFornece%
		
	EndSql
	
	//Percorrer o resultado do select
	While !SC8TMP->(EOF())
		SC8->(dbGoto(SC8TMP->SC8RECNO))
		RecLock("SC8",.F.)
		SC8->C8_FORNECE	:= cNewFor
		SC8->C8_LOJA		:= cNewLoj
		SC8->(MsUnlock())
		
		SC8TMP->(dbSkip())
	EndDo
	
	SC8TMP->(dbCloseArea())
	
	RestArea(aAreaSC8)
	
Return NIL


//-------------------------------------------------------------------
/*/{Protheus.doc} U_xM24Cntr()
Fun��o para gera��o de Contrato a partir do Mapa de Cota��o
@Param aWinProp Array com resultado das cota��es para a gera��o do
contrato
@author Flavio Lopes Rasta
@since 09/01/2014
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
User Function xM24Cntr(aWinProp)//U_xM24Cntr
	Local aArea := GetArea()
	Local lRet		:= .T.
	Local aDados		:= U_xM24Oderna(aWinProp)
	Local oModel300 	:= FWLoadModel( "CNTA300" )
	Local cTpPla	:= SuperGetMV("MV_TPPLA", .T., "")
	Local nGravou
	Local nTpContr	:= 1
	
	If Len(aDados) > 0
		CNL->(dbSetOrder(1))
		If	Empty(cTpPla)
			Help("",1,"MV_TPPLA",," Par�metro n�o Preenchido. � necess�rio preencher o par�metro MV_TPPLA com um Tipo de Planilha v�lido para a gera��o dos contratos",4,1)	//" Par�metro n�o Preenchido. � necess�rio preencher o par�metro MV_TPPLA com um Tipo de Planilha v�lido para a gera��o dos contratos"
			lRet	:= .F.
		ElseIf CNL->( ! DbSeek(xFilial("CNL")+cTpPla) )
			Help("",1,"Planilha Inv�lida",,"� necess�rio preencher o par�metro MV_TPPLA com um Tipo de Planilha v�lido para a gera��o dos contratos",4,1)//"Planilha Inv�lida"//"� necess�rio preencher o par�metro MV_TPPLA com um Tipo de Planilha v�lido para a gera��o dos contratos"
			lRet	:= .F.
		Endif
		If lRet
			If Len(aDados) > 1
				nTpContr	:= Aviso("Tipo do Contrato","Ser� gerado um contrato em Conjunto(todos os fornecedores) ou Individual(um por fornecedor)?",{"Conjunto","Individual"})//"Tipo do Contrato"//"Ser� gerado um contrato em Conjunto(todos os fornecedores) ou Individual(um por fornecedor)?"//"Conjunto"//"Individual"
			Endif
			If nTpContr == 1
				oModel300:SetOperation(3)
				oModel300:Activate()
				Begin Transaction
					nGravou  := FWExecView ('Incluir' , "CNTA300" , MODEL_OPERATION_INSERT ,, {||.T.},,,,,,, U_xM24MdlCot(oModel300,aDados) )//'Incluir'
					U_xM24AtSC8(aDados,CN9->CN9_NUMERO)
					If nGravou == 1
						lRet := .F.
						DisarmTransaction()
					Endif
				End Transaction
			Else
				nGravou  := U_xM24MdlFor(aDados)
			Endif
		EndIf
	Else
		lRet:= .F.
	Endif
	RestArea( aArea )
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} U_xM24Oderna()
Fun��o para gera��o de Contrato a partir do Mapa de Cota��o
@Param aWinProp Array com resultado das cota��es para a gera��o do
contrato
@author Flavio Lopes Rasta
@since 09/01/2014
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
User Function xM24Oderna(aWinProp)//U_xM24Oderna
	Local aWinners	:=	{}
	Local aFornece	:=	{}
	Local aDados		:=	{}
	Local cFornCor
	Local cLojaCor
	Local nX,nY
	
	//Busca os Fornecedores vencedores da cota��o
	For nX:=1 To Len(aWinProp)
		For nY:=1 To Len(aWinProp[nX])
			If aWinProp[nX][nY][4] > 0
				AADD(aWinners,aWinProp[nX][nY])
			Endif
		Next
	Next
	If Len(aWinners) > 0
		// Agrupa vencedores por fornecedor
		For nX:=1 To Len(aWinners)
			cFornCor := aWinners[nX][2]
			cLojaCor := aWinners[nX][3]
			If aScan(aFornece,{|x| x[1]+x[2] == cFornCor+cLojaCor }) == 0
				Aadd(aDados,cFornCor)
				Aadd(aDados,cLojaCor)
				For nY:=1 To Len(aWinners)
					If cFornCor == aWinners[nY][2] .And. cLojaCor == aWinners[nY][3]
						Aadd(aDados,aWinners[nY])
					Endif
				Next
				Aadd(aFornece,aDados)
				aDados := {}
			Endif
		Next
	Endif
	
Return aFornece

//-------------------------------------------------------------------
/*/{Protheus.doc} U_xM24MdlCot()
Fun��o para gera��o de Contrato a partir do Mapa de Cota��o
@Param aWinProp Array com resultado das cota��es para a gera��o do
contrato
@author Flavio Lopes Rasta
@since 09/01/2014
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
User Function xM24MdlCot(oModel300,aDados)//U_xM24MdlCot
	Local aArea := GetArea()
	Local nX,nY
	Local oCN9Master	:= oModel300:GetModel('CN9MASTER')
	Local oCNADetail	:= oModel300:GetModel('CNADETAIL')
	Local oCNBDetail	:= oModel300:GetModel('CNBDETAIL')
	Local oCNCDetail	:= oModel300:GetModel('CNCDETAIL')
	Local oCNZDetail	:= oModel300:GetModel('CNZDETAIL')
	Local cItem		:= Replicate("0", (TamSx3('CNB_ITEM')[1]))
	Local cItPla		:= Replicate("0",(TamSx3('CNA_NUMERO')[1]))
	Local cTpPla	:= SuperGetMV("MV_TPPLA", .T., "")
	Local cItemRat
	Local lRateio		:= .F.
	Local cSeekCNZ
	
	
	// Popula o modelo do contrato
	oCN9Master:SetValue('CN9_ESPCTR',"1")//Contrato de Compra
	oCN9Master:SetValue('CN9_DTINIC',dDataBase)
	oCN9Master:SetValue('CN9_UNVIGE',"4")//Ideterminada
	oCN9Master:SetValue('CN9_NUMCOT',SC8->C8_NUM)
	cItPla	:= soma1(cItPla)
	
	For nX:=1 To Len(aDados)
		cItem		:= Replicate("0", (TamSx3('CNB_ITEM')[1]))
		cItem	:= soma1(cItem)
		If nX > 1
			oCNCDetail:AddLine()
			oCNADetail:AddLine()
			cItPla	:= soma1(cItPla)
		Endif
		oCNCDetail:SetValue('CNC_CODIGO',aDados[nX][1])
		oCNCDetail:SetValue('CNC_LOJA',aDados[nX][2])
		oCNADetail:SetValue('CNA_FORNEC',aDados[nX][1])
		oCNADetail:SetValue('CNA_LJFORN',aDados[nX][2])
		oCNADetail:SetValue('CNA_TIPPLA',cTpPla)
		oCNADetail:SetValue('CNA_NUMERO',cItPla)
		//oCNADetail:SetValue('CNA_DTINI',)
		For nY:=3 To Len(aDados[nX])
			If nY > 3
				oCNBDetail:AddLine()
				cItem	:= soma1(cItem)
			Endif
			
			//oCNBDetail:SetValue('CNB_ITEM',cItem)
			SC8->(dbSetOrder(1))
			SC8->(DbSeek(xFilial('SC8')+aDados[nX][nY][10]+aDados[nX][1]+aDados[nX][2]+aDados[nX][nY][9]))
			
			oCNBDetail:SetValue('CNB_ITEM',cItem)
			oCNBDetail:SetValue('CNB_PRODUT',SC8->C8_PRODUTO)
			oCNBDetail:SetValue('CNB_QUANT',aDados[nX][nY][4])
			oCNBDetail:SetValue('CNB_NUMSC',SC8->C8_NUMSC)
			oCNBDetail:SetValue('CNB_ITEMSC',SC8->C8_ITEMSC)
			oCNBDetail:SetValue('CNB_VLUNIT',SC8->C8_PRECO)
			oCNBDetail:SetValue('CNB_VLTOTR',SC8->C8_TOTAL)
			oCNBDetail:SetValue('CNB_IDENT',SC8->C8_IDENT)
			
			//Verifica se possui rateio
			SCX->(DbSetOrder(1))
			lRateio := SCX->(dbSeek(cSeekCNZ := xFilial("SCX")+SC8->(C8_NUMSC+C8_ITEMSC)))
			If lRateio .and. Empty(SCX->CX_ZFILDES)

				SC1->(dbSeek(xFilial("SC1")+SC8->(C8_NUMSC+C8_ITEMSC)))
				oCNBDetail:SetValue('CNB_CC',SC1->C1_CC)

				cItemRat := Replicate("0", (TamSx3('CNZ_ITEM')[1]))
				While SCX->(!Eof()) .And. SCX->(CX_FILIAL+CX_SOLICIT+CX_ITEMSOL) == cSeekCNZ
					If cItemRat <> Replicate("0", (TamSx3('CNZ_ITEM')[1]))
						oCNZDetail:AddLine()
					EndIf
					cItemRat := Soma1(cItemRat)
					
					oCNZDetail:SetValue('CNZ_ITEM',cItemRat)
					oCNZDetail:SetValue('CNZ_PERC',SCX->CX_PERC)
					oCNZDetail:SetValue('CNZ_CC',SCX->CX_CC)
					oCNZDetail:SetValue('CNZ_CONTA',SCX->CX_CONTA)
					oCNZDetail:SetValue('CNZ_ITEMCT',SCX->CX_ITEMCTA)
					oCNZDetail:SetValue('CNZ_CLVL',SCX->CX_CLVL)
					SCX->(dbSkip())
				End
			Else
				SC1->(dbSeek(xFilial("SC1")+SC8->(C8_NUMSC+C8_ITEMSC)))
				oCNBDetail:SetValue('CNB_CC',SC1->C1_CC)
				oCNBDetail:SetValue('CNB_CLVL',SC1->C1_CLVL)
				oCNBDetail:SetValue('CNB_CONTA',SC1->C1_CONTA)
				oCNBDetail:SetValue('CNB_ITEMCT',SC1->C1_ITEMCTA)
			EndIf
		Next
	Next
	oCNADetail:GoLine(1)
	oCNBDetail:GoLine(1)
	oCNCDetail:GoLine(1)
	oCNZDetail:GoLine(1)
	
	CNTA300BlMd(oModel300:GetModel('CNBDETAIL'),.T.)
	CNTA300BlMd(oModel300:GetModel('CNZDETAIL'),.T.)
	CNTA300BlMd(oModel300:GetModel('CNCDETAIL'),.T.)
	CNTA300BlMd(oModel300:GetModel('CNADETAIL'),.T.,.T.)
	
	RestArea( aArea )
Return oModel300

//-------------------------------------------------------------------
/*/{Protheus.doc} U_xM24MdlFor()
Fun��o para gera��o de Contrato a partir do Mapa de Cota��o
@Param aWinProp Array com resultado das cota��es para a gera��o do
contrato
@author Flavio Lopes Rasta
@since 09/01/2014
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
User Function xM24MdlFor(aDados)//U_xM24MdlFor
	Local aForn	:= {}
	Local lRet	:= .F.
	Local nGravou
	Local nX
	Local oModel300
	
	Begin Transaction
		
		For nX:=1 To Len(aDados)
			
			oModel300 	:= FWLoadModel( "CNTA300" )
			oModel300:SetOperation(3)
			oModel300:Activate()
			nGravou := FWExecView ('Incluir' , "CNTA300" , MODEL_OPERATION_INSERT ,, {||.T.},,,,,,, U_xM24MdlCot(oModel300,{aDados[nX]}))//'Incluir'
			U_xM24AtSC8({aDados[nX]},CN9->CN9_NUMERO)
			If nGravou == 1
				lRet := .F.
				DisarmTransaction()
				Exit
			Endif
			oModel300 	:= Nil
		Next
		
	End Transaction
	
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} U_xM24AtSC8()
Fun��o para atualiza��o da cota��o
ap�s gera��o do contrato
@Param aWinProp Array com resultado das cota��es para a gera��o do
contrato
@author Flavio Lopes Rasta
@since 09/01/2014
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
User Function xM24AtSC8(aDados,cContrato)//U_xM24AtSC8
	Local aArea := GetArea()
	Local cChavSC8
	Local cNumSC8
	Local cItem
	Local lRet := .F.
	Local nX,nY
	
	For nX:= 1 To Len(aDados)
		For nY:=3 To Len(aDados[nX])
			cChavSC8	:= xFilial('SC8')+aDados[nX][nY][10]+aDados[nX][1]+aDados[nX][2]+aDados[nX][nY][9] //Numero+Fornecedor+Loja+Item
			cItem		:= aDados[nX][nY][9]
			cNumSC8	:= aDados[nX][nY][10]
			SC8->(dbSetOrder(1))
			SC8->(DbSeek(xFilial('SC8')+cNumSC8))
			//Encerra cota��o
			While !SC8->(Eof()) .And. SC8->C8_NUM == cNumSC8
				RecLock("SC8",.F.)
				If SC8->(C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM)== cChavSC8
					SC8->C8_NUMCON := cContrato
					SC8->C8_NUMPED := Replicate("X", (TamSx3('C8_NUMPED')[1]))
				Else
					If Empty(SC8->C8_NUMCON) .And. SC8->C8_ITEM == cItem
						SC8->C8_NUMCON := Replicate("X", (TamSx3('C8_NUMCON')[1]))
						SC8->C8_NUMPED := Replicate("X", (TamSx3('C8_NUMPED')[1]))
					Endif
				Endif
				MsUnlock()
				SC8->(DbSkip())
			EndDo
		Next
	Next
	
	RestArea( aArea )
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} U_xM24DscFrt()
Fun��o para descrever o frete
ap�s gera��o do contrato

@author Flavio Lopes Rasta
@since 22/07/2014
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------

User Function xM24DscFrt(cTpFrete)//U_xM24DscFrt
	Local cRet:=""
	
	If cTpFrete == 'C'
		cRet := "CIF" //"CIF"
	ElseIf cTpFrete == 'F'
		cRet := "FOB" //"FOB"
	ElseIf cTpFrete == 'T'
		cRet := "Terceiros" //"Terceiros"
	ElseIf cTpFrete == 'S' .OR. Empty(cTpFrete)
		cRet := "Sem Frete" //"Sem Frete"
	Endif
	
Return cRet

Static Function ShowBMemo(cString)
	Local oEditor := nil
	Local oSize 	:= nil
	Local oDlMemo := nil
	
	Local bOk     := {|| TRATAMOT(oDlMemo, oEditor, @cString) }
	Local bCancel := {|| oDlMemo:End() }
	
	DEFINE MSDIALOG oDlMemo FROM 180, 180 TO 550, 700 TITLE 'MEMO' PIXEL
	
	oEditor := TSimpleEditor():New(3,0,oDlMemo,263,146)
	oEditor:TextFormat( 2 )
	oEditor:Load(cString)
	oEditor:lReadOnly := .F.
	
	ACTIVATE MSDIALOG oDlMemo CENTERED ON INIT EnchoiceBar(oDlMemo, bOk, bCancel)
	
Return .T.

/*------- Estrutura do Array aPrdXFor --------*/

//aPrdXFor[n,X]: Produto
//aPrdXFor[n,X,Y]: Fornecedor
//aPrdXFor[n,X,Y,1]: Pre�o
//aPrdXFor[n,X,Y,2]: Prazo
//aPrdXFor[n,X,Y,3]: Nota
//aPrdXFor[n,X,Y,4]: Nota Final (menor vence)
//aPrdXFor[n,X,Y,5]: Refer�ncia ao aProposta
//aPrdXFor[n,X,Y,5,1]: p�gina
//aPrdXFor[n,X,Y,5,2]: Refer�ncia ao aProposta
//aPrdXFor[n,X,Y,5,3]: Refer�ncia ao aProposta

/*------- Estrutura do Array de aPrdMinMax --------*/

//aPrdXFor[n,X]: Produto
//aPrdXFor[n,X,1]: Maior Nota
//aPrdXFor[n,X,2]: Menor Nota
//aPrdXFor[n,X,3]: Qtd. Part
//aPrdXFor[n,X,4]: M�dia
//aPrdXFor[n,X,5]: Melhor Fator


//-------------------------------------------------------------------
/*/{Protheus.doc} U_xM24CotVen()
Sugest�o da cota��o vencedora

@author guilherme.pimentel

@since 04/11/2015
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------

User Function xM24CotVen(aItens, aPropostas,oBrowse1,oBrowse2,oBrowse3)//U_xM24CotVen
	
	Local aPrdXFor	:= {}
	Local aPrdMinMax	:= {}
	Local aAux 		:= {}
	Local aRank 		:= {}
	Local aForVenc 	:= {}
	
	Local nX := 1
	Local nY := 1
	Local nZ := 1
	Local nJ := 1
	Local nC := 1
	Local nI := 0
	
	Local nMax := 1
	Local nMin := 1
	
	Local aPosPrc := {}
	Local aPosPrz := {}
	Local aPosNot := {}
	
	Local nMenPrc := 0 // Menor preco.
	Local nMenPrz := 0 // Menor prazo.
	Local nMaiNot := 0 // Maior nota.
	
	Local lAchou := .F.
	
	Local aBkpRank := {}
	
	// -----------------------------------------------------------------------
	// Montagem do array de Produtos X Propostas e de Valores M�ximos e Minimos
	// -----------------------------------------------------------------------
	
	For nX := 1 To Len(aItens)
		
		aAdd(aPrdXFor, {aItens[nX,1]} )
		
		aAdd(aPrdMinMax, {aItens[nX,1]} )
		aAdd(aPrdMinMax[nX], {,,0,0,0} ) // Pre�o
		aAdd(aPrdMinMax[nX], {,,0,0,0} ) // Prazo
		aAdd(aPrdMinMax[nX], {,,0,0,0} ) // Nota
		
		For nY := 1 To Len(aPropostas)
			//Verifica��o das duas propostas
			For nJ := 1 To 2
				//Verifica��o de todos os itens das propostas
				For nZ := 1 To Len(aPropostas[nY][nJ][2])
					//Se encontrar proposta para aquele produto adiciona no Array
					If aPropostas[nY][nJ][2][nZ][3] == aItens[nX,1] .And. aPropostas[nY][nJ][2][nZ][11] == nX
						
						//Adiciona o Fornecedor
						aAdd(aAux,aPropostas[nY][nJ][1][1])
						aAdd(aAux,{})
						
						//Adiciona itens
						aAdd(aAux[2],aPropostas[nY][nJ][1][4]) //Proposta
						aAdd(aAux[2],aPropostas[nY][nJ][2][nZ][4]) //Pre�o
						aAdd(aAux[2],U_xM24DToI(aPropostas[nY][nJ][2][nZ][5])) // Prazo
						
						If SA5->(DbSeek(xFilial("SA5")+aPropostas[nY][nJ][1][1]+aPropostas[nY][nJ][1][2]+aItens[nX,1])) //Filial+Fornecedor+Loja+Produto
							aAdd(aAux[2],SA5->A5_NOTA) //Nota
						Else
							aAdd(aAux[2],0) //Nota
						EndIf
						
						aAdd(aAux[2],0) //Nota Final
						
						aAdd(aAux[2],{nY,nJ,nZ}) //Refer�ncia ao aProposta
						
						//Verifica��o de m�ximo e minimo para o Item adicionado
						U_xM24MinMax(aPropostas[nY][nJ],aPropostas[nY][nJ][2][nZ],@aPrdMinMax[nX],nZ)
						
					EndIf
					
					If !Empty(aAux)
						aAdd(aPrdXFor[nX],aAux)
						aAux := {}
					EndIf
					
				Next nZ
				
			Next nJ
			
		Next nY
		
	Next nX
	
	
	// -----------------------------------------------------------------------
	// Fator de multiplica��o e Coloca��o da Nota de cada forncedor
	// -----------------------------------------------------------------------
	
	// Todos os Produtos
	For nX := 1 To Len(aPrdXFor)
		// Todos os Fornecedores
		For nY := 2 to Len(aPrdXFor[nX])
			//Todos os quesitos
			For nZ := 2 to Len(aPrdXFor[nX][nY])
				//Pre�o
				aPrdXFor[nX][nY][nZ][2] := aPrdXFor[nX][nY][nZ][2] * aPrdMinMax[nX][2][4]
				If (aPrdXFor[nX][nY][nZ][2] < aPrdMinMax[nX][2][5] .And. aPrdXFor[nX][nY][nZ][2] > 0) .Or. aPrdMinMax[nX][2][5] == 0
					aPrdMinMax[nX][2][5] := aPrdXFor[nX][nY][nZ][2]
				EndIf
				
				//Prazo
				aPrdXFor[nX][nY][nZ][3] := aPrdXFor[nX][nY][nZ][3] * aPrdMinMax[nX][3][4]
				If (aPrdXFor[nX][nY][nZ][3] < aPrdMinMax[nX][3][5] .And. aPrdXFor[nX][nY][nZ][3] > 0)  .Or. aPrdMinMax[nX][3][5] == 0
					aPrdMinMax[nX][3][5] := aPrdXFor[nX][nY][nZ][3]
				EndIf
				
				//Nota
				aPrdXFor[nX][nY][nZ][4] := aPrdXFor[nX][nY][nZ][4] * aPrdMinMax[nX][4][4]
				If aPrdXFor[nX][nY][nZ][4] > aPrdMinMax[nX][4][5] .Or. aPrdMinMax[nX][4][5] == 0
					aPrdMinMax[nX][4][5] := aPrdXFor[nX][nY][nZ][4]
				EndIf
			Next nZ
		Next nY
	Next nX
	
	// -----------------------------------------------------------------------
	// Necess�rio mais uma verifica��o para aplica��o do fator de multiplica��o
	// ap�s identifica��o da melhor proposta e aplica��o do peso
	// -----------------------------------------------------------------------
	
	// Todos os Produtos
	For nX := 1 To Len(aPrdXFor)
		// Todos os Fornecedores
		For nY := 2 to Len(aPrdXFor[nX])
			//Todos os quesitos
			For nZ := 2 to Len(aPrdXFor[nX][nY])
				//Pre�o
				aPrdXFor[nX][nY][nZ][2] := If(MV_PAR05==0,0,(aPrdXFor[nX][nY][nZ][2] / aPrdMinMax[nX][2][5]) * MV_PAR05)
				
				//Prazo
				aPrdXFor[nX][nY][nZ][3] := If(MV_PAR06==0,0,(aPrdXFor[nX][nY][nZ][3] / aPrdMinMax[nX][3][5]) * MV_PAR06)
				
				//Nota
				aPrdXFor[nX][nY][nZ][4] := If(MV_PAR07==0,0,(aPrdMinMax[nX][4][5] / aPrdXFor[nX][nY][nZ][4]) * MV_PAR07)
				
				//Soma das Notas
				aPrdXFor[nX][nY][nZ][5] := aPrdXFor[nX][nY][nZ][2] + aPrdXFor[nX][nY][nZ][3] + aPrdXFor[nX][nY][nZ][4]
			Next nZ
		Next nY
	Next nX
	
	
	// -----------------------------------------------------------------------
	// Escolha do vencedor - Por Item
	// obs: Sera verifica os propostas de cada fornecedor por produtos
	//	e caso seja encontrada uma proposta melhor a primeira ser� substituida
	// -----------------------------------------------------------------------
	If MV_PAR04 == 1
		// Todos os Produtos
		aAux := {}
		For nX := 1 To Len(aPrdXFor)
			nMenPrc := 0 // Menor preco.
			nMenPrz := 0 // Menor prazo.
			nMaiNot := 0 // Maior nota.
			
			aPosPrc := {}
			aPosPrz := {}
			aPosNot := {}
			
			aAux := {}
			aAdd(aForVenc,{aPrdXFor[nX][1]})
			
			// Todos os Fornecedores
			For nY := 2 to Len(aPrdXFor[nX])
				
				Aadd(aPrdXFor[nX][nY][2], {0, 0, 0}) // Armazena os pesos de cada criterio.
				
				For nC := Len(aPrdXFor[nX]) To 2 Step -1
					
					// Preco.
					If (aPrdXFor[nX][nY][2][2] < aPrdXFor[nX][nC][2][2] .And. aPrdXFor[nX][nY][2][2] < nMenPrc .And. aPrdXFor[nX][nY][2][2] > 0) .Or. nMenPrc == 0
						
						If aPrdXFor[nX][nY][2][2] > 0
							
							aPrdXFor[nX][nY][2][7][1] := MV_PAR05 // Preco.
							
						EndIf
						
						nMenPrc := aPrdXFor[nX][nY][2][2]
						
						If Len(aPosPrc) > 0
							
							aPrdXFor[aPosPrc[1]][aPosPrc[2]][2][7][1] := 0
							
						EndIf
						
						aPosPrc := {}
						aPosPrc := {nX, nY}
						
					EndIf
					
					// Prazo.
					If (aPrdXFor[nX][nY][2][3] < aPrdXFor[nX][nC][2][3] .And. aPrdXFor[nX][nY][2][3] < nMenPrz .And. aPrdXFor[nX][nY][2][3] > 0) .Or. nMenPrz == 0
						
						If aPrdXFor[nX][nY][2][3] > 0
							
							aPrdXFor[nX][nY][2][7][2] := MV_PAR06 // Prazo.
							
						EndIf
						
						nMenPrz := aPrdXFor[nX][nY][2][3]
						
						If Len(aPosPrz) > 0
							
							aPrdXFor[aPosPrz[1]][aPosPrz[2]][2][7][2] := 0
							
						EndIf
						
						aPosPrz := {}
						aPosPrz := {nX, nY}
						
					EndIf
					
					// Nota.
					If (aPrdXFor[nX][nY][2][4] > aPrdXFor[nX][nC][2][4] .And. aPrdXFor[nX][nY][2][4] > nMaiNot) .Or. nMaiNot == 0
						
						If aPrdXFor[nX][nY][2][4] > 0
							
							aPrdXFor[nX][nY][2][7][3] := MV_PAR07 // Nota.
							
						EndIf
						
						nMaiNot := aPrdXFor[nX][nY][2][4]
						
						If Len(aPosNot) > 0
							
							aPrdXFor[aPosNot[1]][aPosNot[2]][2][7][3] := 0
							
						EndIf
						
						aPosNot := {}
						aPosNot := {nX, nY}
						
					EndIf
					
					If Len(aPrdXFor[nX][nC][2]) < 7
						
						Aadd(aPrdXFor[nX][nC][2], {0, 0, 0}) // Armazena os pesos de cada criterio.
						
					EndIf
					
					If (aPrdXFor[nX][nY][2][7][1] + aPrdXFor[nX][nY][2][7][2] + aPrdXFor[nX][nY][2][7][3] > aPrdXFor[nX][nC][2][7][1] + aPrdXFor[nX][nC][2][7][2] + aPrdXFor[nX][nC][2][7][3]) .Or. Len(aPrdXFor[nX]) <= 2
						
						aAux := {}
						aAdd(aAux,aPrdXFor[nX][nY][2][5])
						aAdd(aAux,nY)
						
					EndIf
					
				Next nC
				
			Next nY
			
			//Adiciona todos os vencedores no array de vencedores por produto
			//Desconsiderando a primeira posi��o que a refer�ncia do melhor
			For nZ := 1 to Len(aAux)-1
				aAdd(aForVenc[nX],aPrdXFor[nX][aAux[nZ+1]])
			Next nZ
			
		Next nX
		
		// -----------------------------------------------------------------------
		// Marca��o do vencedor
		// -----------------------------------------------------------------------
		For nX := 1 To Len(aForVenc)
			
			If Len(aForVenc[nX]) > 1
				
				/*posi��o 1, 2, 4 do aPropostas*/
				A161DesMark(aForVenc[nX][2][2][6][1],aForVenc[nX][2][2][6][2],aForVenc[nX][2][2][6][3],aPropostas,aItens,oBrowse1,oBrowse2,oBrowse3,.T.)
				
			EndIf
			
		Next nX
		
	Else
		
		// -----------------------------------------------------------------------
		// Escolha do vencedor - Por Cota��o
		// Obs: Ser� soma a  pontua��o de cada fornecedor, formando um Ranking
		//	com a classifica��o de todos os fornecedores, dividido pela quantidade
		//	de itens que ele participa
		// -----------------------------------------------------------------------
		
		// Todos os Produtos
		For nX := 1 To Len(aPrdXFor)
			
			// Todos os Fornecedores
			For nY := 2 to Len(aPrdXFor[nX])
				aAux := {}
				
				If Empty(aRank) .Or. (nZ := aScan(aRank,{|x| x[1] = aPrdXFor[nX][nY][1]+"|"+aPrdXFor[nX][nY][2][1]})) == 0
					
					aAdd(aAux,aPrdXFor[nX][nY][2][5]) //Pontua��o
					aAdd(aAux,1)//Quantidade de Itens
					
					aAdd(aRank,{aPrdXFor[nX][nY][1]+"|"+aPrdXFor[nX][nY][2][1],aAux}) // Fornecedor+Proposta
					
				Else
					//Aumenta a pontua��o
					aRank[nZ][2][1] := aRank[nZ][2][1] + aPrdXFor[nX][nY][2][5]
					//Aumenta a quantidade de itens
					aRank[nZ][2][2] := aRank[nZ][2][2]++
				EndIf
				
			Next nY
			
		Next nX
		
		aBkpRank := AClone(aRank)
		aRank    := {}
		
		// Somente aceita propostas que atendam todos os produtos.
		For nI := 1 To Len(aBkpRank)
			
			If Len(aItens) == aBkpRank[nI][2][2]
				
				Aadd(aRank, aBkpRank[nI])
				
			EndIf
			
		Next nI
		
		// Divide a pontua��o pela quantidade de itens.
		For nX :=1 To len(aRank)
			aRank[nX][2][1] := aRank[nX][2][1] / aRank[nX][2][2]
		Next nX
		
		// Ordena pela maior pontuacao.
		ASORT(aRank, , , { | x,y | x[2][1] < y[2][1] } )
		
		
		// -----------------------------------------------------------------------
		// Marca��o do vencedor
		// -----------------------------------------------------------------------
		
		// Todos os Produtos
		For nX := 1 to Len(aPrdXFor)
			lAchou := .F.
			// Verifica os vencedores pela ordem
			For nZ := 1 to Len(aRank)
				// Todos os Fornecedores
				For nY := 2 To Len(aPrdXFor[nX])
					// Compara fornecedor e proposta
					If aPrdXFor[nX][nY][1] == Substr(aRank[nZ][1],1,At("|",aRank[nZ][1])-1) .And. aPrdXFor[nX][nY][2][1] == Substr(aRank[nZ][1],At("|",aRank[nZ][1])+1,Len(aRank[nZ][1]))
						
						A161DesMark(aPrdXFor[nX][nY][2][6][1],aPrdXFor[nX][nY][2][6][2],aPrdXFor[nX][nY][2][6][3],aPropostas,aItens,oBrowse1,oBrowse2,oBrowse3,.T.)
						lAchou := .T.
						Exit
					EndIf
				Next nZ
				
				// Caso ja tenha marcado o vencedor nao verifica os demais
				If lAchou
					Exit
				EndIf
			Next nY
		Next nX
		
	EndIf
	
	oBrowse1:LineRefresh()
	oBrowse2:LineRefresh()
	oBrowse3:LineRefresh()
	
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} U_xM24MinMax()
Verifica��o de m�ximos e minimo para todos os crit�rios avaliados

@author guilherme.pimentel

@Obs Estrutura do Array

aPrdXFor[n,X]: Produto
aPrdXFor[n,X,1]: Maior Nota
aPrdXFor[n,X,2]: Menor Nota
aPrdXFor[n,X,3]: Qtd. Part
aPrdXFor[n,X,4]: M�dia
aPrdXFor[n,X,5]: Melhor Fator

@since 06/11/2015
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
User Function xM24MinMax(aPropostas,aPropAux,aPrdMinMax,nZ)//U_xM24MinMax
	
	// -----------------------------------------------------------------------
	// Pre�o
	// -----------------------------------------------------------------------
	If (Empty(aPrdMinMax[2][1])) .Or. (aPropostas[2][nZ][4] > aPrdMinMax[2][1])
		aPrdMinMax[2][1] := aPropostas[2][nZ][4]
	EndIf
	
	If (Empty(aPrdMinMax[2][2])) .Or. (aPropostas[2][nZ][4] < aPrdMinMax[2][2])
		aPrdMinMax[2][2] := aPropostas[2][nZ][4]
	EndIf
	
	aPrdMinMax[2][3] := aPrdMinMax[2][3]++
	
	aPrdMinMax[2][4] := (aPrdMinMax[2][1]-aPrdMinMax[2][2])/aPrdMinMax[2][3]
	
	// -----------------------------------------------------------------------
	// Prazo
	// -----------------------------------------------------------------------
	If (Empty(aPrdMinMax[3][1])) .Or. (U_xM24DToI(aPropAux[5]) > aPrdMinMax[3][1])
		aPrdMinMax[3][1] := U_xM24DToI(aPropAux[5])
	EndIf
	
	If (Empty(aPrdMinMax[3][2])) .Or. (U_xM24DToI(aPropAux[5]) < aPrdMinMax[3][2])
		aPrdMinMax[3][2] := U_xM24DToI(aPropAux[5])
	EndIf
	
	aPrdMinMax[3][3] := aPrdMinMax[3][3]++
	
	aPrdMinMax[3][4] := (aPrdMinMax[3][1]-aPrdMinMax[3][2])/aPrdMinMax[3][3]
	
	// -----------------------------------------------------------------------
	// Nota
	// -----------------------------------------------------------------------
	If (Empty(aPrdMinMax[4][1])) .Or. (SA5->A5_NOTA > aPrdMinMax[4][1])
		aPrdMinMax[4][1] := SA5->A5_NOTA
	EndIf
	
	If (Empty(aPrdMinMax[4][2])) .Or. (SA5->A5_NOTA < aPrdMinMax[4][2])
		aPrdMinMax[4][2] := SA5->A5_NOTA
	EndIf
	
	aPrdMinMax[4][3] := aPrdMinMax[4][3]++
	
	aPrdMinMax[4][4] := (aPrdMinMax[4][1]-aPrdMinMax[4][2])/aPrdMinMax[4][3]
	
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} U_xM24DToI()
Convers�o de Data pra Inteiro

@author guilherme.pimentel

@since 11/11/2015
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------

User Function xM24DToI(dDate)//U_xM24DToI
	Local nRet := 0
	Local nDia := 0
	Local nMes := 0
	Local nAno := 0
	
	nDia := Day(dDate)
	nMes := Month(dDate) * 30
	nAno := Year(dDate) * 365
	
	nRet := nDia + nMes + nAno
	
Return nRet

//-------------------------------------------------------------------
/*/{Protheus.doc} AjustaSX1()
Ajusta SX1

@author guilherme.pimentel

@since 13/11/2015
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------
Static Function AjustaSX1()
	
	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}
	
	// -----------------------------------------------------------------------
	// Help
	// -----------------------------------------------------------------------
	//P.MTA16103.
	Aadd( aHelpPor, "Indica se haver� sugest�o da melhor ")
	Aadd( aHelpPor, "alternativa na cota��o.")
	Aadd( aHelpEng, "")
	Aadd( aHelpSpa, "")
	
	PutHelp("P.MTA16103.",aHelpPor,aHelpEng,aHelpSpa,.T.)
	
	//P.MTA16104.
	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}
	
	Aadd( aHelpPor, "Indica a forma de avalia��o da melhor proposta ")
	Aadd( aHelpPor, "Item: Ser� marcado o melhor item ")
	Aadd( aHelpPor, "individualmente - Proposta: Ser� marcada a  ")
	Aadd( aHelpPor, "melhor proposta como um todo. ")
	Aadd( aHelpEng, "")
	Aadd( aHelpSpa, "")
	
	PutHelp("P.MTA16104.",aHelpPor,aHelpEng,aHelpSpa,.T.)
	
	//P.MTA16105.
	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}
	
	Aadd( aHelpPor, "Peso do crit�rio Pre�o na verifica��o ")
	Aadd( aHelpPor, " do vencedor.")
	Aadd( aHelpEng, "")
	Aadd( aHelpSpa, "")
	
	PutHelp("P.MTA16105.",aHelpPor,aHelpEng,aHelpSpa,.T.)
	
	//P.MTA16106.
	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}
	
	Aadd( aHelpPor, "Peso do crit�rio Prazo na verifica��o ")
	Aadd( aHelpPor, " do vencedor.")
	Aadd( aHelpEng, "")
	Aadd( aHelpSpa, "")
	
	PutHelp("P.MTA16106.",aHelpPor,aHelpEng,aHelpSpa,.T.)
	
	//P.MTA16107.
	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}
	
	Aadd( aHelpPor, "Peso do crit�rio Nota na verifica��o ")
	Aadd( aHelpPor, " do vencedor.")
	Aadd( aHelpEng, "")
	Aadd( aHelpSpa, "")
	
	PutHelp("P.MTA16107.",aHelpPor,aHelpEng,aHelpSpa,.T.)
	
	// -----------------------------------------------------------------------
	// Pergunte
	// -----------------------------------------------------------------------
	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}
	PutSx1( "MTA161","03","Traz Cotac. Marcada:","Traz Cotac. Marcada:","Traz Cotac. Marcada:","mv_ch3",;
		"N",1,0,2,"C","","","","","mv_par03","Sim","S�","Yes","","Nao","No","No","","","","","","","","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	
	
	PutSx1( "MTA161","04","Analise de proposta por:","Analise de proposta por:","Analise de proposta por:","mv_ch4",;
		"N",1,0,1,"C","","","","","mv_par04","Por Item","Por Item","Por Item","","Por Proposta","Por Proposta","Por Proposta","","","","","","","","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	
	
	PutSx1( "MTA161","05","Peso Preco:","Peso Preco:","Peso Preco:","mv_ch5",;
		"N",1,0,1,"G","","","","","mv_par05","","","","1","","","","","","","","","","","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	
	
	PutSx1( "MTA161","06","Peso Prazo:","Peso Prazo:","Peso Prazo:","mv_ch6",;
		"N",1,0,1,"G","","","","","mv_par06","","","","1","","","","","","","","","","","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	
	
	PutSx1( "MTA161","07","Peso Nota:","Peso Nota:","Peso Nota:","mv_ch7",;
		"N",1,0,1,"G","","","","","mv_par07","","","","1","","","","","","","","","","","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	
	
Return Nil

//-------------------------------------------------------------------
/*{Protheus.doc} AjustaSX3
Ajusta SX3

@author Carlos Capeli
@since 03/02/2016
@version P12.1.7
*/
//-------------------------------------------------------------------

Static Function AjustaSX3()
	
	Local aAreaSX3 := SX3->(GetArea())
	Local cInibrw  := 'POSICIONE("SC1",1,XFILIAL("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC,"SC1->C1_DESCRI")'
	
	dbSelectArea("SX3")
	dbsetOrder(2)
	
	If MsSeek("C8_DESCRI")
		If cInibrw <> AllTrim(SX3->X3_INIBRW)
			RecLock('SX3',.F.)
			X3_INIBRW := cInibrw
			MsUnLock()
		EndIf
	EndIf
	
	RestArea(aAreaSX3)
	
Return Nil

//-------------------------------------------------------------------
/*{Protheus.doc} A161PcoVld
Valida bloqueios na integracao com SIGAPCO

@author Carlos Capeli
@since 13/11/2015
@version P12.1.7
*/
//-------------------------------------------------------------------

Static Function A161PcoVld(lDeleta)
	
	Local aAreaAnt	:= GetArea()
	Local lRetPCO		:= .T.
	Local lRetorno	:= .T.
	Local nX		:= 0
	
	Default lDeleta := .F.
	
	// Verifica se Solicitacao de Compra possui rateio e gera lancamentos no PCO
	SCX->(dbSetOrder(1))
	If SCX->(MsSeek(xFilial("SCX")+SC1->(C1_NUM+C1_ITEM)))
		While SCX->(!Eof()) .And. SCX->(CX_FILIAL+CX_SOLICIT+CX_ITEMSOL) == xFilial("SCX")+SC1->(C1_NUM+C1_ITEM)
			
			lRetPCO := PcoVldLan('000051','03',,,lDeleta)	// Solicitacao de compras - Rateio por CC na cotacao
			If !lRetPCO
				lRetorno := .F.
			EndIf
			
			SCX->(DbSkip())
		End
	EndIf
	
	// Inclusao de pedido de compras por cotacao"
	lRetPCO := PcoVldLan('000052','02',,,lDeleta)
	If !lRetPCO
		lRetorno := .F.
	EndIf
	
	RestArea(aAreaAnt)
	
Return lRetorno

/*--------------------------------------------
Trata o campo memo de observacao.
--------------------------------------------*/

Static Function TRATAMOT(oDlMemo, oEditor, cTexto)
	
	Local lMot := GetNewPar("MV_MOTIVOK",.F.)
	
	cTexto := oEditor:RetText()
	
	If lMot
		
		If Empty(cTexto)
			
			Alert('Motivo em Branco')
			
		Else
			
			oDlMemo:End()
			
		EndIf
		
	EndIf
	
Return

/*--------------------------------------------
Valida a tela de analise da cotacao.
--------------------------------------------*/

Static Function VALIDAOK(aPropostas)
	
	Local aArea    := GetArea()
	Local aAreaSc8 := SC8->(GetArea())
	
	Local lRet := .T.
	Local lMot := GetNewPar("MV_MOTIVOK",.F.)
	
	Local nP := 0
	Local nI := 0
	Local nH := 0
	
	For nP := 1 To Len(aPropostas)
		
		For nI := 1 To Len(aPropostas[nP])
			
			For nH := 1 To Len(aPropostas[nP][nI][2])
				
				// Trava no registro da SC8 para verificar se o item ja foi encerrado anteriormente.
				// Caso ja tenha pedido, nao verifica observacao, pois pode ser um encerramento parcial.
				// Ou o parametro pode ser ativo durante o processo de analise da cotacao.
				SC8->(DbGoTo(aPropostas[nP, nI, 2, nH, 9]))
				
				If aPropostas[nP, nI, 2, nH, 1] .And. lMot .And. Empty(aPropostas[nP, nI, 2, nH, 6]) .And. Empty(SC8->C8_NUMPED)
					
					lRet := .F.
					
				EndIf
				
			Next nH
			
		Next nI
		
	Next nP
	
	If !lRet
		
		Alert('Motivo em Branco')
		
	EndIf
	
	RestArea(aArea)
	RestArea(aAreaSc8)
	
Return lRet

//*****************************************************************************
User Function xM24AvCot(cAliasSC8,nEvento,aSC8,aHeadSCE,aCOLSSCE,lNecessid,lLast,bCtbOnLine,cCompACC)//MaAvalCOT
	
	Local aArea 	:= GetArea()
	Local aAreaSC8  := SC8->(GetArea())
	Local aRegSC1   := {}
	Local aVencedor := {}
	Local aPaginas  := {}
	Local aRefImp   := {}
	Local aSCMail	:= {}
	Local aNroItGrd := {}
	Local aPedidos  := {}
	Local aCTBEnt	:= CTBEntArr()
	Local cNumCot   := ""
	Local cProduto  := ""
	Local cIdent    := ""
	Local cQuery    := ""
	Local cCursor   := ""
	Local cNumPed   := ""
	Local cItemPC   := ""
	Local cUsers 	:= ""
	Local cCndCot	:= ""
	Local cNumContr := ""
	Local cItemContr:= ""
	Local cFLuxo    := Criavar("C7_FLUXO")
	Local lQuery    := .F.
	Local lCotSC    := SuperGetMV("MV_COTSC")=="S"
	Local lTrava	:= .T.
	Local nA		:= 0
	Local nB		:= 0
	Local nX        := 0
	Local nY        := 0
	Local nZ		:= 0
	Local nP        := 0
	Local nS        := 0
	Local nH        := 0
	Local lOkS      := .T.
	Local nPQtdSCE  := 0
	Local nPMotSCE  := 0
	Local nPRegSC8  := 0
	Local nPForSC8  := 0
	Local nPLojSC8  := 0
	Local nPCndSC8  := 0
	Local nPPrdSC8  := 0
	Local nPFilSC8  := 0
	Local nScan     := 0
	Local nSaveSX8  := GetSX8Len()
	Local nSaveSX82 := 0
	Local cGrupo	:= SuperGetMv("MV_PCAPROV")
	Local lLiberou  := .F.
	Local lPEGerPC  := ExistBlock("MT160GRPC")
	Local aRatFin	:= {}
	Local lPrjCni   := ValidaCNI()
	Local cGrComPad := Space(Len(SC7->C7_GRUPCOM))
	Local cCotFiAP  := "C"
	Local aBkpFilAdm:= Array(5)
	Local aRetPE	:= {}
	Local lCotSI	:= ExistBlock("MT130SI")
	Local aRetPO	:= {}
	Local aFilSCH	:= {}
	
	Local lCotParc := SuperGetMv('MV_COTPARC',, .T.) // Habilita a analise da cotacao parcial.
	
	Local nPSCCSC8  := 0
	Local nPSCSC8	:= 0
	Local cSolic	:= ''
	Local cCCSC8    := ''
	
	DEFAULT aSC8      := {}
	DEFAULT aHeadSCE  := {}
	DEFAULT aCOLSSCE  := {}
	DEFAULT lNecessid := .T.
	DEFAULT lLast     := .F.
	DEFAULT bCtbOnLine:= {|| .T.}
	DEFAULT cCompACC  := ""
	
	//Variaveis para controle de Al�adas - 06/01/2015.
	aHeadSC7	:= {}
	aColsSC7	:= {}
	aHeadSCH	:= {}
	aColsSCH	:= {}
	lBloqIP		:= .F.
	
	//Verifica o grupo de aprovacao do Comprador.
	dbSelectArea("SY1")
	dbSetOrder(3)
	/*If dbSeek(xFilial("SY1") + If(Empty(cCompACC),RetCodUsr(),cCompACC))
		cGrupo	:= If(!Empty(Y1_GRAPROV),SY1->Y1_GRAPROV,cGrupo)
	EndIf*/
	If dbSeek(xFilial("SY1")+RetCodUsr())
		cGrComPad	:= If(!Empty(Y1_GRUPCOM),SY1->Y1_GRUPCOM,Space(Len(SC7->C7_GRUPCOM)))
	EndIf
	
	Do Case
		
		//Analise da cotacao
	Case nEvento == 4
		
		nPQtdSCE  := aScan(aHeadSCE,{|x| Trim(x[2])=="CE_QUANT"})
		nPMotSCE  := aScan(aHeadSCE,{|x| Trim(x[2])=="CE_MOTIVO"})
		nPEntSCE  := aScan(aHeadSCE,{|x| Trim(x[2])=="CE_ENTREGA"})
		
		// Controle para identificar qual posicao do aSC8 vem preenchida.
		For nS := 1 To Len(aSC8)
			For nH := 1 To Len(aSC8[nS])
				If Len(aSC8[nS][nH]) > 1
					lOkS := .F.
					Exit
				EndIf
			Next nH
			If !lOkS
				Exit
			EndIf
		Next nS
		
		nPRegSC8  := aScan(aSC8[nS][nH],{|x| Trim(x[1])=="SC8RECNO"})
		nPForSC8  := aScan(aSC8[nS][nH],{|x| Trim(x[1])=="C8_FORNECE"})
		nPLojSC8  := aScan(aSC8[nS][nH],{|x| Trim(x[1])=="C8_LOJA"})
		nPCndSC8  := aScan(aSC8[nS][nH],{|x| Trim(x[1])=="C8_COND"})
		nPPrdSC8  := aScan(aSC8[nS][nH],{|x| Trim(x[1])=="C8_PRODUTO"})
		nPFilSC8  := aScan(aSC8[nS][nH],{|x| Trim(x[1])=="C8_FILENT"})
		nPObsSC8  := aScan(aSC8[nS][nH],{|x| Trim(x[1])=="C8_OBS"})
		nPSCSC8   := aScan(aSC8[nS][nH],{|x| Trim(x[1])=="C8_NUMSC"})
		
		For nX := 1 To Len(aSC8)
			For nY := 1 To Len(aSC8[nX])
				cSolic := aSC8[nX][nY][nPSCSC8][2]
				dbSelectArea('SC1')
				SC1->(dbSetOrder(1))//C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD
				If SC1->(dbSeek(xFilial('SC1') + cSolic))
					cCCSC8 := SC1->C1_CC
				EndIf
				AADD(aSC8[nX][nY],{"C8_CC",cCCSC8})
			Next
		Next
		
		nPSCCSC8 := aScan(aSC8[nS][nH],{|x| Trim(x[1])=="C8_CC"})
		
		//Verifico quais fornecedores possuem cotacoes vencedoras
		For nX := 1 To Len(aColsSCE)
			For nY := 1 To Len(aColsSCE[nX])
				dbSelectArea("SC8")
				MsGoto(aSC8[nX][nY][nPRegSC8][2])
				If ( aColsSCE[nX][nY][nPQtdSCE] > 0 )
					If ( RecLock("SC8") )
						nZ := aScan(aVencedor,{|x| x[1]==aSC8[nX][nY][nPForSC8][2].And.;
							x[2]==aSC8[nX][nY][nPLojSC8][2].And.;
							x[3]==aSC8[nX][nY][nPCndSC8][2].And.;
							x[4]==aSC8[nX][nY][nPFilSC8][2] .And. x[5]==aSC8[nX][nY][nPSCCSC8][2]})
						If ( nZ == 0 )
							aadd(aVencedor,{aSC8[nX][nY][nPForSC8][2],;
								aSC8[nX][nY][nPLojSC8][2],;
								aSC8[nX][nY][nPCndSC8][2],;
								aSC8[nX][nY][nPFilSC8][2],aSC8[nX][nY][nPSCCSC8][2]})
						EndIf
					EndIf
				EndIf
			Next nY
		Next nX
		
		//Verifica a quais impostos devem ser gravados.
		aRefImp := MaFisRelImp('MT100',{"SC7"})
		
		//Efetua a gravacao dos pedidos para cada Vencedor
		For nZ := 1 To Len(aVencedor)
			//Travo todos os registros antes de iniciar a gravacao
			lTrava := .T.
			For nX := 1 To Len(aColsSCE)
				For nY := 1 To Len(aColsSCE[nX])
					If ( aVencedor[nZ][1] == aSC8[nX][nY][nPForSC8][2].And.;
							aVencedor[nZ][2] == aSC8[nX][nY][nPLojSC8][2].And.;
							aVencedor[nZ][3] == aSC8[nX][nY][nPCndSC8][2].And.;
							aVencedor[nZ][4] == aSC8[nX][nY][nPFilSC8][2] .And. aVencedor[nZ][5] == aSC8[nX][nY][nPSCCSC8][2])
						
						dbSelectArea("SC8")
						MsGoto(aSC8[nX][nY][nPRegSC8][2])
						
						if lPrjCNI
							if SC8->(!Eof())
								if (!Empty(SC8->C8_XGCT))
									lTrava := .F.
									Exit
								EndIf
							EndIf
						EndIf
						
						If (!RecLock("SC8") )
							lTrava := .F.
							Exit
						EndIf
					EndIf
				Next nY
			Next nX
			
			aBkpFilAdm[1] := cFilAnt
			
			//Inicio o processo de gravacao do Pedido de Compra
			If ( lTrava )
				cCotFiAP  := "C"
				cNumPed   := CriaVar("C7_NUM",.T.)
				While ( GetSX8Len() > nSaveSX8 )
					ConfirmSx8()
				EndDo
				cItemPC   := StrZero(1,Len(SC7->C7_ITEM))
				If ( Empty(cNumPed) )
					cNumPed := GetNumSC7(.F.)
				EndIf
				
				aBkpFilAdm[2] := cNumPed
				aBkpFilAdm[4] := cGrupo
				aBkpFilAdm[5] := cGrComPad
				
				If lPrjCni
					//Esvazia vetor rateio financeiro
					aRatFin := {}
				EndIf
				
				For nX := 1 To Len(aColsSCE)
					For nY := 1 To Len(aColsSCE[nX])
						If ( aVencedor[nZ][1]==aSC8[nX][nY][nPForSC8][2].And.;
								aVencedor[nZ][2]==aSC8[nX][nY][nPLojSC8][2].And.;
								aVencedor[nZ][3]==aSC8[nX][nY][nPCndSC8][2].And.;
								aVencedor[nZ][4]==aSC8[nX][nY][nPFilSC8][2].And. aVencedor[nZ][5]==aSC8[nX][nY][nPSCCSC8][2] .And.;
								aColsSCE[nX][nY][nPQtdSCE]<>0)
							
							//Guarda as paginas que houveram vencedores
							If ( aScan(aPaginas,nX)==0 )
								aadd(aPaginas,nX)
							EndIf
							dbSelectArea("SB1")
							SB1->(dbSetOrder(1))
							MsSeek(xFilial("SB1")+aSC8[nX][nY][nPPrdSC8][2])
							dbSelectArea("SC8")
							MsGoto(aSC8[nX][nY][nPRegSC8][2])
							dbSelectArea("SC1")
							SC1->(dbSetOrder(5))
							MsSeek(xFilial("SC1",aBkpFilAdm[1])+SC8->C8_NUM+SC8->C8_PRODUTO+SC8->C8_IDENT)
							dbSelectArea("SA2")
							SA2->(dbSetOrder(1))
							MsSeek(xFilial("SA2")+aVencedor[nZ][1]+aVencedor[nZ][2])
							
							//Incluo o item do Pedido de Compra
							RecLock("SC7",.T.)
							dbSelectArea("SC7")
							For nA := 1 to SC7->(FCount())
								nB := SC8->(FieldPos("C8"+SubStr(SC7->(FieldName(nA)),3)))
								If ( nB <> 0 )
									FieldPut(nA,SC8->(FieldGet(nB)))
								EndIf
							Next nA
							
							//Controla a numeracao do Item no PC quando for Item de Grade vindo do SC8
							//Observar que o Numero do Item no PC C7_ITEM sera trocado toda vez que na
							//mesma grade o C8_PRECO for diferente, ou seja, somente sera aglutinado
							//na mesma grade (mesmo C7_ITEM) os itens do Grid que possuirem o mesmo
							//preco para preservar os valores,calculos de impostos e afins.
							If SC8->C8_GRADE == "S"
								
								cProdRef := SC8->C8_PRODUTO
								lReferencia := MatGrdPrrf(@cProdRef, .T.)
								
								If (nScan := aScan(aNroItGrd, {|x| x[1] + x[2] + x[3] + x[4] + x[5] + x[6] + x[7] + x[8] == ;
										SC8->C8_ITEM + cProdRef + SC8->C8_NUMPRO + SC8->C8_FORNECE + SC8->C8_LOJA + SC8->C8_NUMSC + SC8->C8_ITEMSC + TransForm(SC8->C8_PRECO,PesqPict("SC8","C8_PRECO")) })) == 0
									
									Aadd(aNroItGrd, { SC8->C8_ITEM , cProdRef , SC8->C8_NUMPRO , SC8->C8_FORNECE , SC8->C8_LOJA ,SC8->C8_NUMSC ,SC8->C8_ITEMSC ,TransForm(SC8->C8_PRECO,PesqPict("SC8","C8_PRECO")) , cItemPc } )
									nScan := Len(aNroItGrd)
									cItemPc	:= Soma1(cItemPc)
									
								Endif
							Else
								nScan := Nil
							EndIf
							
							//-- Verifica filial que ira administrar o pedido de compra
							If (cCotFiAP := SuperGetMV("MV_COTFIAP",.F.,"C")) == "E"
								//-- Valida se o produto existe na filial de entrega
								SB1->(dbSetOrder(1))
								cCotFiAP := If(cCotFiAP == "E" .And. SB1->(dbSeek(xFilial("SB1",SC8->C8_FILENT)+SC8->C8_PRODUTO)),"E","C")
								
								//-- Valida se o fornecedor existe na filial de entrega
								SA2->(dbSetOrder(1))
								cCotFiAP := If(cCotFiAP == "E" .And. SA2->(dbSeek(xFilial("SA2",SC8->C8_FILENT)+aVencedor[nZ,1]+aVencedor[nZ,2])),"E","C")
								
								//-- Valida se a condicao de pagamento existe na filial de entrega
								SE4->(dbSetOrder(1))
								cCotFiAP := If(cCotFiAP == "E" .And. SE4->(dbSeek(xFilial("SE4",SC8->C8_FILENT)+aVencedor[nZ,3])),"E","C")
							EndIf
							
							//-- Se administradora do PC for a filial de entrega
							If cCotFiAP == "E" .And. PadR(cFilAnt,Len(AllTrim(SC8->C8_FILENT))) # AllTrim(SC8->C8_FILENT)
								aBkpFilAdm[3] := cItemPC
								
								//-- Troca filial
								SM0->(dbSetOrder(1))
								SM0->(dbSeek(cEmpAnt+AllTrim(SC8->C8_FILENT)))
								cFilAnt := FWCodFil()
								
								//-- Troca numero do pedido
								nSaveSX82 := GetSX8Len()
								cNumPed := CriaVar("C7_NUM",.T.)
								While (GetSX8Len() > nSaveSX82)
									ConfirmSx8()
								End
								cItemPC := StrZero(1,Len(SC7->C7_ITEM))
								If (Empty(cNumPed))
									cNumPed := GetNumSC7(.F.)
								EndIf
								
								//-- Troca grupo de compra e aprovacao
								/*SY1->(dbSetOrder(3))
								If SY1->(dbSeek(xFilial("SY1")+If(Empty(cCompACC),RetCodUsr(),cCompACC)))
									cGrupo := If(!Empty(SY1->Y1_GRAPROV),SY1->Y1_GRAPROV,SuperGetMv("MV_PCAPROV",.F.,""))
									cGrComPad := If(!Empty(SY1->Y1_GRUPCOM),SY1->Y1_GRUPCOM,CriaVar("C7_GRUPCOM",.F.))
								EndIf*/
							EndIf
							
							SC7->C7_FILIAL  := xFilial("SC7")
							SC7->C7_TIPO    := 1
							SC7->C7_NUM     := cNumPed
							SC7->C7_ITEM    := If(nScan == Nil, cItemPc , aNroItGrd[nScan, 9 ])
							SC7->C7_GRADE   := IIF(Empty(SC8->C8_GRADE),"N",SC8->C8_GRADE)
							SC7->C7_ITEMGRD := SC8->C8_ITEMGRD
							SC7->C7_FORNECE := aVencedor[nZ][1]
							SC7->C7_LOJA    := aVencedor[nZ][2]
							SC7->C7_COND    := aVencedor[nZ][3]
							SC7->C7_OP      := SC1->C1_OP
							SC7->C7_LOCAL   := SC1->C1_LOCAL
							SC7->C7_DESCRI  := SC1->C1_DESCRI
							SC7->C7_UM      := SC1->C1_UM
							SC7->C7_SEGUM   := SC1->C1_SEGUM
							SC7->C7_QUANT   := aColsSCE[nX][nY][nPQtdSCE]
							SC7->C7_QTDSOL  := 0
							SC7->C7_QTSEGUM := IIf(SB1->B1_CONV==0,SC1->C1_QTSEGUM,ConvUm(aSC8[nX][nY][nPPrdSC8][2],aColsSCE[nX][nY][nPQtdSCE],0,2))
							SC7->C7_PRECO   := SC8->C8_PRECO
							SC7->C7_TOTAL   := SC7->C7_QUANT*SC7->C7_PRECO
							SC7->C7_CONTATO := SC8->C8_CONTATO
							SC7->C7_OBS     := SC8->C8_OBS
							SC7->C7_OBSM    := aSC8[nX][nY][nPObsSC8][2]
							SC7->C7_EMISSAO := dDataBase
							SC7->C7_DATPRF  := IIf(lNecessid,aColsSCE[nX][nY][nPentSCE],dDataBase+SC8->C8_PRAZO)
							SC7->C7_CC      := SC1->C1_CC
							SC7->C7_ZCC     := SC1->C1_CC
							SC7->C7_CLVL    := SC1->C1_CLVL
							SC7->C7_CONTA   := SC1->C1_CONTA
							SC7->C7_ITEMCTA := SC1->C1_ITEMCTA
							SC7->C7_ORIGEM  := SC1->C1_ORIGEM
							SC7->C7_DESC1   := SC8->C8_DESC1
							SC7->C7_DESC2   := SC8->C8_DESC2
							SC7->C7_DESC3   := SC8->C8_DESC3
							SC7->C7_REAJUST := SC8->C8_REAJUST
							SC7->C7_IPI     := SC8->C8_ALIIPI
							SC7->C7_FISCORI := SC8->C8_FILIAL
							SC7->C7_NUMSC   := SC8->C8_NUMSC
							SC7->C7_ITEMSC  := SC8->C8_ITEMSC
							SC7->C7_NUMCOT  := SC8->C8_NUM
							SC7->C7_FILENT  := SC8->C8_FILENT
							SC7->C7_TPFRETE := SC8->C8_TPFRETE
							SC7->C7_VLDESC  := ((SC7->C7_TOTAL*SC8->C8_VLDESC)/SC8->C8_TOTAL)
							SC7->C7_IPIBRUT := "B"
							SC7->C7_VALEMB  := SC8->C8_VALEMB
							SC7->C7_FRETE   := SC8->C8_TOTFRE
							SC7->C7_FLUXO   := cFluxo
							SC7->C7_GRUPCOM := If(Empty(C7_GRUPCOM),cGrComPad,C7_GRUPCOM)
							If cPaisLoc == "BRA"
								SC7->C7_ICMSRET := SC8->C8_VALSOL
							EndIf
							//preco original tg 311018
							SC7->C7_ZPRCORI := SC8->C8_ZPRCORI
							
							If lCotSI
								aRetPO := ExecBlock("MT130SI",.F.,.F.,{2})//parametro 2 indica que o PE esta sendo executado para gerar uma P.O
								If ValType(aRetPO) <> "A"
									lCotSI := .F.
								EndIf
							EndIf
							// Criado ponto de entrada para cota��o de produto importado
							// As altera��es abaixo v�o fazer com que o PC vire uma P.O
							If lCotSI
								SC7->C7_TIPO   	:= 3
								SC7->C7_FREPPCC := aRetPO[1] // default = CC
								SC7->C7_DT_IMP	:= aRetPO[2] // Data de importa��o
								SC7->C7_AGENTE	:= aRetPO[3] //Ag embarcador
								SC7->C7_TIPO_EM	:= aRetPO[4] //via de transporte
								SC7->C7_ORIGIMP	:= aRetPO[5] //Origem
								SC7->C7_DEST	:= aRetPO[6] //Destino
								SC7->C7_COMPRA	:= aRetPO[7] //Comprador
								SC7->C7_INCOTER	:= aRetPO[8] //Incorterm
								SC7->C7_IMPORT	:= aRetPO[9] //Importador
								SC7->C7_CONF_PE	:= aRetPO[10]// Data da confirma��o do Pedido //default = data base
								SC7->C7_CONTAIN	:= aRetPO[11] // Desova de Container //default = 1
							EndIf
							
							For nA := 1 To Len(aCTBEnt)
								SC7->&("C7_EC"+aCTBEnt[nA]+"CR") := SC1->&("C1_EC"+aCTBEnt[nA]+"CR")
								SC7->&("C7_EC"+aCTBEnt[nA]+"DB") := SC1->&("C1_EC"+aCTBEnt[nA]+"DB")
							Next nA
							
							SC7->C7_RATEIO  := CriaVar('C7_RATEIO',.T.)
							
							If (SuperGetMv("MV_MKPLACE",.F.,.F.)) .And. !Empty( SC8->C8_ACCNUM )
								SC7->C7_ACCNUM  := aColsSCE[nX][nY][Len(aColsSCE[nX][nY])-1]
								SC7->C7_ACCITEM := aColsSCE[nX][nY][Len(aColsSCE[nX][nY])]
								SC7->C7_USER    := cCompACC
							EndIf
							
							//PE para atualizacao de campos especificos do SC7
							If lPEGerPC
								ExecBlock("MT160GRPC",.F.,.F.,{aVencedor,aSC8})
							EndIf
							
							MaFisIni(aVencedor[nZ][1],aVencedor[nZ][2],"F","N","R",aRefImp)
							
							/*If cItemPC == StrZero(1,Len(SC7->C7_ITEM)) .And. ExistBlock("MT120APV")
								cGrupo := ExecBlock("MT120APV",.F.,.F.,{aVencedor,aSC8})
							EndIf*/
							
							//cGrupo := xM24GrAp(SC7->C7_CC)

							//If !Empty(cGrupo)
							
							xM24PedSCR(SC7->C7_NUM,SC7->C7_CC)
							SC7->C7_CONAPRO := 'B'
							SC7->C7_ZIDINTE := ''
							SC7->C7_ZREJAPR := 'N'
							SC7->C7_ZBLQFLG := 'S'
							SC7->C7_ZHORINC	:= SUBSTR(TIME(),1,5)
							
							lLiberou := .F.
							
							//EndIf
							
							//SC7->C7_APROV   := cGrupo
							
							MaFisIniLoad(1)
							For nA := 1 To Len(aRefImp)
								MaFisLoad(aRefImp[nA][3],FieldGet(FieldPos(aRefImp[nA][2])),1)
							Next nA
							MaFisRecal("",1)
							MaFisEndLoad(1)
							MaFisAlt("IT_ALIQIPI",SC7->C7_IPI,1)
							MaFisAlt("IT_ALIQICM",SC7->C7_PICM,1)
							If cPaisLoc == "BRA"
								MaFisAlt("IT_VALSOL", SC7->C7_ICMSRET,1)
							EndIf
							MaFisWrite(1,"SC7",1)
							MaFisWrite(2,"SC7",1,.F.)
							
							// alimenta o vl do IPI quando informado apenas o valor
							If SC8->C8_ALIIPI == 0 .And. SC8->C8_VALIPI <> 0
								SC7->C7_VALIPI  := SC8->C8_VALIPI
							EndIf
							
							//-- Adiciona pedido gerado no array de controle para chamada
							//-- de fun��es de atualiza��o
							nP := aScan(aPedidos,{|x| xFilial("SC7",x[1])+x[2] == SC7->(C7_FILIAL+C7_NUM)})
							If  nP == 0
								aAdd(aPedidos,{cFilAnt,SC7->C7_NUM,aRatFin,MaFisRet(1,"IT_TOTAL")})
							Else
								aPedidos[nP,4] += MaFisRet(1,"IT_TOTAL")
							EndIf
							
							MaFisEnd()
							
							//Encerro a cotacao vencedora
							dbSelectArea("SC8")
							MsGoto(aSC8[nX][nY][nPRegSC8][2])
							SC8->C8_NUMPED := cNumPed
							SC8->C8_ITEMPED:= If(nScan == Nil, cItemPc , aNroItGrd[nScan, 9 ])
							SC8->C8_MOTIVO := aColsSCE[nX][nY][nPMotSCE]
							
							If nPObsSC8 > 0
								
								SC8->C8_OBS := aSC8[nX][nY][nPObsSC8][2]
								
							EndIf
							
							SC8->C8_DATPRF := IIf(lNecessid,aColsSCE[nX][nY][nPentSCE],dDataBase+SC8->C8_PRAZO)
							SC8->C8_PRAZO  := SC8->C8_DATPRF - dDataBase
							
							//Caio.Santos - 11/01/13 - Req.72
							If lPrjCni
								RSTSCLOG("PED",3,/*cUser*/,SC7->(C7_NUM+C7_ITEM))
							EndIf
							
							RecLock("SCE",.T.)
							SCE->CE_FILIAL := xFilial("SCE",SC8->C8_FILIAL)
							SCE->CE_NUMCOT := SC8->C8_NUM
							SCE->CE_ITEMCOT:= SC8->C8_ITEM
							SCE->CE_NUMPRO := SC8->C8_NUMPRO
							SCE->CE_PRODUTO:= SC8->C8_PRODUTO
							SCE->CE_FORNECE:= SC8->C8_FORNECE
							SCE->CE_LOJA   := SC8->C8_LOJA
							SCE->CE_ITEMGRD:= SC8->C8_ITEMGRD
							For nA := 1 To Len(aHeadSCE)
								//Nao grava campos virutais e de controle (walkthru)
								If !(IsHeadRec(Trim(aHeadSCE[nA][2])) .OR. IsHeadAlias(Trim(aHeadSCE[nA][2])) .OR. aHeadSCE[nA][10] == "V")
									FieldPut(FieldPos(aHeadSCE[nA][2]),aCOLSSCE[nX][nY][nA])
								EndIf
							Next nA
							SCE->CE_MOTIVO := aColsSCE[nX][nY][nPMotSCE]
							SCE->CE_ENTREGA:= IIf(lNecessid,aColsSCE[nX][nY][nPentSCE],dDataBase+SC8->C8_PRAZO)
							If SC8->C8_QTDCTR > 0
								//Gravacao do Contrato de Parceria
								If Empty(cNumContr)
									cNumContr := CriaVar("C3_NUM",.T.)
									cItemContr:= Strzero(1,Len(SC3->C3_ITEM))
									While ( GetSX8Len() > nSaveSX8 )
										ConfirmSx8()
									EndDo
								EndIf
								RecLock("SC3",.T.)
								dbSelectArea("SC3")
								SC3->C3_FILIAL  := xFilial("SC3")
								SC3->C3_NUM     := cNumContr
								SC3->C3_FORNECE := aVencedor[nZ][1]
								SC3->C3_LOJA    := aVencedor[nZ][2]
								SC3->C3_GRADE   := SC8->C8_GRADE
								SC3->C3_ITEMGRD := SC8->C8_ITEMGRD
								SC3->C3_ITEM    := cItemContr
								SC3->C3_PRODUTO := SC8->C8_PRODUTO
								SC3->C3_QUANT   := SC8->C8_QTDCTR
								SC3->C3_PRECO   := SC8->C8_PRECO
								SC3->C3_TOTAL   := SC3->C3_PRECO*SC3->C3_QUANT
								SC3->C3_DATPRI  := dDataBase
								SC3->C3_DATPRF  := IIf(lNecessid,aColsSCE[nX][nY][nPentSCE],dDataBase+SC8->C8_PRAZO)
								SC3->C3_LOCAL   := SC1->C1_LOCAL
								SC3->C3_COND    := aVencedor[nZ][3]
								SC3->C3_CONTATO := SC8->C8_CONTATO
								SC3->C3_FILENT  := SC8->C8_FILENT
								SC3->C3_EMISSAO := dDatabase
								SC3->C3_REAJUST := SC8->C8_REAJUST
								SC3->C3_TPFRETE := SC8->C8_TPFRETE
								SC3->C3_FRETE   := SC8->C8_TOTFRE
								SC3->C3_OBS     := SC8->C8_OBS
								SC3->C3_AVISTA := SC8->C8_AVISTA
								SC3->C3_TAXAFOR := SC8->C8_TAXAFOR
								MsUnLock()
								SB1->(DBSetOrder(1))
								If SB1->(MsSeek(xFilial("SB1")+SC8->C8_PRODUTO))
									RecLock("SB1",.F.)
									Replace SB1->B1_CONTRAT With "S"
									Replace SB1->B1_PROC    With aVencedor[nZ][1]
									Replace SB1->B1_LOJPROC With aVencedor[nZ][2]
									MsUnLock()
								EndIf
								cItemContr  :=  Soma1(cItemContr,Len(SC3->C3_ITEM))
							EndIf
							//Atualizo os acumulados do Pedido de Compra
							MaAvalPC("SC7",1,nZ==Len(aVencedor),Nil,Nil,Nil,bCtbOnLine,.F.)
							
							//Grava o rateio do centro de custo da solicitacao no pedido de compra
							CotGeraSCH(aBkpFilAdm[1])
							
							If nScan == Nil
								cItemPc	:= Soma1(cItemPc)
							EndIf
							
							If (Existblock("AVALCOT"))
								ExecBlock("AVALCOT",.F.,.F.,{nEvento})
							EndIf
						EndIf
					Next nY
				Next nX
			EndIf
			
			//-- Retorna filial
			If cFilAnt # aBkpFilAdm[1]
				SM0->(dbSetOrder(1))
				SM0->(dbSeek(cEmpAnt+aBkpFilAdm[1]))
				cFilAnt := FWCodFil()
				
				//-- Volta backup de variaveis
				cNumPed   := aBkpFilAdm[2]
				cItemPC   := aBkpFilAdm[3]
				cGrupo    := aBkpFilAdm[4]
				cGrComPad := aBkpFilAdm[5]
			EndIf
		Next nZ
		
		For nZ := 1 To Len(aPedidos)
			SM0->(dbSetOrder(1))
			SM0->(dbSeek(cEmpAnt+aPedidos[nZ,1]))
			cFilAnt := aPedidos[nZ,1]
			
			SC7->(dbSetOrder(1))
			SC7->(dbSeek(xFilial("SC7")+aPedidos[nZ,2]))
			cNumPed := SC7->C7_NUM
			
			//- Controle de al�adas.
			If SuperGetMv("MV_APRPCEC",.F.,.F.)
				aAreaBlq := GetArea()
				
				//Gera aHeader e aCols das tabelas SC7 e SCH para utiliza��o no bloqueio por Entidade Contabil.
				If Len(aHeadSC7) > 0 .Or. Len(aColsSC7) > 0 .Or. Len(aHeadSCH) > 0 .Or. Len(aColsSCH) > 0
					aHeadSC7:={}
					aColsSC7:={}
					aHeadSCH:={}
					aColsSCH:={}
					
					COMGerC7Ch(cNumPed,@aFilSCH)
				Else
					COMGerC7Ch(cNumPed,@aFilSCH)
				EndIf
				
				//Bloqueia pedido
				lBloqIP := MaEntCtb("SC7","SCH",cNumPed,"IP",aHeadSC7,aColsSC7,aHeadSCH,aFilSCH,1,SC7->C7_EMISSAO)
				RestArea(aAreaBlq)
			EndIf
			/*If !lBloqIp
				lLiberou := MaAlcDoc({SC7->C7_NUM,"PC",aPedidos[nZ,4],,,SC7->C7_APROV,,SC7->C7_MOEDA,SC7->C7_TXMOEDA,SC7->C7_EMISSAO},dDataBase,1)
			EndIf
			
			//Integracao ACC envia aprovacao do pedido
			If lLiberou .And. WebbConfig(.F.) .And. !Empty(SC7->C7_ACCNUM)
				If IsBlind()
					Webb533(SC7->C7_NUM)
				Else
					MsgRun('Aguarde, comunicando aprova��o ao portal','Portal ACC',{|| Webb533(SC7->C7_NUM)}) //Aguarde, comunicando aprova��o ao portal ## Portal ACC
				EndIf
			EndIf*/
			
			SC7->(dbCommit())
			cQuery := "UPDATE "
			cQuery += RetSqlName("SC7")+" "
			cQuery += "SET C7_CONAPRO = '"+ IIf( !lLiberou , "B" , "L" ) + "' "
			cQuery += "WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
			cQuery += "C7_NUM='"+cNumPed+"' AND "
			cQuery += "D_E_L_E_T_=' ' "
			TcSqlExec(cQuery)
			SC7->(MsGoto(RecNo()))
			
			//Envia e-mail na inclusao do Pedido de Compras.
			SC7->(MsSeek(xFilial("SC7")+cNumPed))
			MEnviaMail("037",{SC7->C7_NUM,SC7->C7_NUMCOT,SC7->C7_APROV,SC7->C7_CONAPRO,Subs(cUsuario,7,15)})

			msgAlert( "Pedido de Compra n�mero " + allTrim( SC7->C7_NUM ) + " gerado com sucesso!" )

			//PE para manipular cada PC gravado pela analise da cotacao.
			If (Existblock("AVALCOPC")) .And. ValType(aRetPE := ExecBlock("AVALCOPC",.F.,.F.,aPedidos)) == "A"
				aPedidos := aClone(aRetPE)
			EndIf
			
		Next nZ
		
		//-- Retorna filial
		If ValType(aBkpFilAdm[1]) # "U" .And. cFilAnt # aBkpFilAdm[1]
			SM0->(dbSetOrder(1))
			SM0->(dbSeek(cEmpAnt+aBkpFilAdm[1]))
			cFilAnt := FWCodFil()
		EndIf
		
		//Tratamento das cotacoes perdedoras que foram analisadas
		If lCotParc // Se a rotina estiver configurada para trabalhar com analise parcial de produtos.
			
			For nZ := 1 To Len(aPaginas)
				
				nX := aPaginas[nZ]
				
				//Inicio o processo de gravacao do Pedido de Compra
				For nY := 1 To Len(aColsSCE[nX])
					
					DbSelectArea("SC8")
					MsGoTo(aSC8[nX][nY][nPRegSC8][2])
					
					If Empty(SC8->C8_NUMPED)
						
						//Encerro as cotacoes perdedoras
						RecLock("SC8")
						
						SC8->C8_NUMPED  := Repl("X", Len(SC8->C8_NUMPED))
						SC8->C8_ITEMPED := Repl("X", Len(SC8->C8_ITEMPED))
						SC8->C8_MOTIVO  := aColsSCE[nX][nY][nPMotSCE]
						
						SC8->(MsUnlock())
						
					EndIf
					
				Next nY
				
			Next nZ
			
		Else
			
			For nZ := 1 To Len(aColsSCE)
				
				//Inicio o processo de gravacao do Pedido de Compra
				For nY := 1 To Len(aColsSCE[nZ])
					
					DbSelectArea("SC8")
					MsGoTo(aSC8[nZ][nY][nPRegSC8][2])
					
					SC1->(DbSetOrder(1)) // Indice 1 - C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD
					If SC1->(DbSeek(xFilial('SC1')+SC8->C8_NUMSC+SC8->C8_ITEMSC))
						
						If Empty(SC8->C8_NUMPED)
							
							//Encerro as cotacoes perdedoras
							RecLock("SC8")
							
							SC8->C8_NUMPED  := Repl("X",Len(SC8->C8_NUMPED))
							SC8->C8_ITEMPED := Repl("X",Len(SC8->C8_ITEMPED))
							SC8->C8_MOTIVO  := aColsSCE[nz][nY][nPMotSCE]
							
							SC8->(MsUnlock())
							
							// Se o item da solicitacao de compras foi encerrado na cotacao (SC8), mas nao gerou pedido, reabre o item na solicitacao (SC1).
							If Empty(SC1->C1_PEDIDO)
								
								RecLock('SC1', .F.)
								
								SC1->C1_COTACAO := CriaVar('C1_COTACAO', .F.)
								
								SC1->(MsUnlock())
								
							EndIf
							
						EndIf
						
					EndIf
					
				Next nY
				
			Next nZ
			
		EndIf
		
	EndCase
	
	RestArea(aAreaSC8)
	RestArea(aArea)
	
Return(.T.)

Static Function CotGeraSCH(cFilOri)
	Local nX		:= 0
	Local nY		:= 0
	Local nTotSCH	:= 0
	Local aSCs		:= {}
	Local cItemCH	:= StrZero(0,TamSX3("CH_ITEM")[1])
	Local cFilSC1 := ""
	Local aCTBEnt	:= CTBEntArr()
	Local lCotRatP  := SuperGetMv("MV_COTRATP",.F.,.F.)
	Local lHasSCX	:= .F.
	Local nTamCHPerc := TamSX3("CH_PERC")[1]
	
	SC1->(dbSetOrder(5))//C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT
	SC1->(dbSeek(xFilial("SC1",cFilOri)+SC8->(C8_NUM+C8_PRODUTO+C8_IDENT)))
	
	cFilSC1 := IIF(Empty(SC1->C1_FILIAL),SC1->C1_FILENT,SC1->C1_FILIAL)
	
	While !SC1->(EOF()) .And. cFilSC1 == xFilial("SC8",cFilOri) .And. SC1->(C1_COTACAO+C1_PRODUTO+C1_IDENT) == SC8->(C8_NUM+C8_PRODUTO+C8_IDENT)
		
		SCX->(dbSetOrder(1))//CX_FILIAL+CX_SOLICIT+CX_ITEMSOL+CX_ITEM                                                                                                                         
		lHasSCX := SCX->(dbSeek(xFilial("SCX",cFilOri)+SC1->(C1_NUM+C1_ITEM)))
		
		If lHasSCX
			lHasSCX := Empty(SCX->CX_ZFILDES)
		EndIf

		
		While SCX->(!EOF()) .And. SCX->(CX_FILIAL+CX_SOLICIT+CX_ITEMSOL) == xFilial("SCX",cFilOri)+SC1->(C1_NUM+C1_ITEM)
			If lHasSCX
				If (nX := aScan(aSCs,{|x| ChaveSCH(1,aCTBEnt,x,"SCX")})) == 0
					ChaveSCH(2,aCTBEnt,aSCs,"SCX")
					nX := Len(aSCs)
				Else
					aTail(aSCs[nX]) += Round((((SC1->C1_QUANT*100)/SC7->C7_QUANT)*SCX->CX_PERC)/100,2)
				Endif
				
				//-- Totaliza rateio da SCH
				nTotSCH += aTail(aSCs[nX])
			EndIf
			SCX->(dbSkip())
		EndDo
		
		//-- Caso nao tenha SCX, gera rateio com os dados da SC1
		If !lHasSCX .And. lCotRatP
			If (nX := aScan(aSCs,{|x| ChaveSCH(1,aCTBEnt,x,"SC1")})) == 0
				ChaveSCH(2,aCTBEnt,aSCs,"SC1")
				nX := Len(aSCs)
			Else
				aTail(aSCs[nX]) += Round((SC1->C1_QUANT / SC8->C8_QUANT) * 100,nTamCHPerc)
			Endif
			
			//-- Totaliza rateio da SCH
			nTotSCH += aTail(aSCs[nX])
		EndIf
		
		SC1->(dbSkip())
	End
	
	//-- So gera rateio quando ha mais de uma quebra contabil
	If Len(aSCs) >= 1
		//-- Caso o arredondamento tenha dado diferenca (ate 0,05), ajusta no ultimo item
		If (Abs(nTotSCH - 100) > 0 .And. (nTotSCH - 100) < 0.05) .Or.;
				(Abs(nTotSCH - 100) < 0 .And. (nTotSCH - 100) > 0.05)
			aTail(aTail(aSCs)) -= nTotSCH - 100
			nTotSCH -= nTotSCH - 100
		EndIf
		
		//-- Grava dados dos rateios
		For nX := 1 To Len(aSCs)
			cItemCH := Soma1(cItemCH)
			RecLock("SCH",.T.)
			SCH->CH_FILIAL	:= xFilial("SCH")
			SCH->CH_PEDIDO  := SC7->C7_NUM
			SCH->CH_FORNECE := SC7->C7_FORNECE
			SCH->CH_LOJA 	:= SC7->C7_LOJA
			SCH->CH_ITEMPD 	:= SC7->C7_ITEM
			SCH->CH_ITEM 	:= cItemCH
			SCH->CH_CC 		:= aSCs[nX,1]
			SCH->CH_CONTA 	:= aSCs[nX,2]
			SCH->CH_ITEMCTA	:= aSCs[nX,3]
			SCH->CH_CLVL	:= aSCs[nX,4]
			SCH->CH_PERC 	:= aTail(aSCs[nX])
			//-- Grava entidades contabeis
			For nY := 1 To Len(aCTBEnt)
				SCH->&("CH_EC"+aCTBEnt[nY]+"CR") := aSCs[nX,nY+6]
				SCH->&("CH_EC"+aCTBEnt[nY]+"DB") := aSCs[nX,nY+7]
			Next nY
			SCH->(MsUnlock())
			SCX->(MsGoto(aSCs[nX,5]))
			SC1->(MsGoto(aSCs[nX,6]))
			LancaPCO("SC1","000051","03")
		Next nX
		
		//-- Gera linha de rateio em branco para a sobra
		If nTotSCH <> 100
			cItemCH := Soma1(cItemCH)
			RecLock("SCH",.T.)
			SCH->CH_FILIAL	:= xFilial("SCH")
			SCH->CH_PEDIDO  := SC7->C7_NUM
			SCH->CH_FORNECE := SC7->C7_FORNECE
			SCH->CH_LOJA 	:= SC7->C7_LOJA
			SCH->CH_ITEMPD 	:= SC7->C7_ITEM
			SCH->CH_ITEM 	:= cItemCH
			SCH->CH_PERC 	:= 100 - nTotSCH
			SCH->(MsUnlock())
			LancaPCO("SC1","000051","03")
		EndIf
		
		//-- Limpa campos da SC7, ja que ha rateio
		SC7->C7_RATEIO 	:= '1'
		SC7->C7_CC		:= CriaVar("C7_CC",.F.)
		SC7->C7_CONTA	:= CriaVar("C7_CONTA",.F.)
		SC7->C7_ITEMCTA	:= CriaVar("C7_ITEMCTA",.F.)
		SC7->C7_CLVL	:= CriaVar("C7_CLVL",.F.)
		For nX := 1 To Len(aCTBEnt)
			SC7->&("C7_EC"+aCTBEnt[nX]+"CR") := CriaVar("C7_EC"+aCTBEnt[nX]+"CR",.F.)
			SC7->&("C7_EC"+aCTBEnt[nX]+"DB") := CriaVar("C7_EC"+aCTBEnt[nX]+"DB",.F.)
		Next nX
	EndIf
	
Return

Static Function xM24GrAp(cCC)
	
	Local aArea := GetArea()
	Local cNextAlias := GetNextAlias()
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	BeginSql Alias cNextAlias
		
		SELECT DISTINCT
			DBL_GRUPO,
			AL_ZCODGRD,
			AL_ZVERSAO
		FROM
			%Table:DBL% DBL
		INNER JOIN %Table:SAL% SAL
		ON SAL.AL_FILIAL = DBL.DBL_FILIAL
			AND SAL.AL_COD = DBL.DBL_GRUPO
			INNER JOIN %Table:ZAB% ZAB
		ON ZAB.ZAB_CODIGO = SAL.AL_ZCODGRD
			AND ZAB.ZAB_VERSAO = SAL.AL_ZVERSAO
		WHERE
			DBL.DBL_FILIAL = %xFilial:DBL% AND
			DBL.%NotDel% AND
			SAL.%NotDel% AND
			ZAB.%NotDel% AND
			SUBSTRING(SAL.AL_ZCODGRD,1,1) = 'P' AND
			DBL.DBL_CC = %Exp:cCC% AND
			ZAB.ZAB_HOMOLO = 'S'
		
		ORDER BY DBL_GRUPO, AL_ZCODGRD, AL_ZVERSAO
		
	EndSql
	
	(cNextAlias)->(DbGoTop())
	
	While (cNextAlias)->(!EOF())
		cRet := (cNextAlias)->DBL_GRUPO
		(cNextAlias)->(dbSkip())
	EndDo
	
	RestArea(aArea)
	
Return cRet

Static Function xM24PedSCR(cChav,cCC)

	Local aArea 		:= GetArea()
	Local aAreaSC7		:= SC7->(GetArea())
	
	Local cDelet   		:= ''
	Local cNextAlias 	:= GetNextAlias()
	Local nIt			:= 1
	Local nTotal		:= xTotPed(cChav)
	
	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif
	
	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
	
	//If SCR->(dbSeek(xFilial('SCR') + 'PC' + PadR(cChav,TamSX3('CR_NUM')[1])))
	If SCR->(dbSeek(xFilial('SCR') + 'PC' + cChav))
		//While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  xFilial('SCR') + 'PC' + PadR(cChav,TamSX3('CR_NUM')[1])	
		While SCR->(!EOF()) .and. Alltrim(SCR->(CR_FILIAL + CR_TIPO + CR_NUM)) ==  Alltrim(xFilial('SCR') + 'PC' + cChav)
			RecLock('SCR',.F.)
				SCR->(dbDelete())
			SCR->(MsUnLock())
			SCR->(dbSkip())
		EndDo
		
		cDelet := "delete " + RetSQLName("SCR") + " SCR " + CRLF 
		cDelet += " WHERE  SCR.D_E_L_E_T_ = '*' AND SCR.CR_FILIAL = '" + xFilial('SCR') + "' AND " + CRLF
		cDelet += " SCR.CR_TIPO = 'PC' AND SCR.CR_NUM = '" + cChav + "' "
		
		TcSQLExec(cDelet)
		
	EndIf

	BeginSql Alias cNextAlias
		
		SELECT DISTINCT
		    ZAD_SEQ,
		    ZAD_NIVEL,
		    ZA2_CODUSU,
		    ZAB_CODIGO,
		    ZAB_VERSAO,
			ZAD_VALINI,
			ZAD_VALFIM
		FROM
			%Table:ZAB% ZAB
		INNER JOIN %Table:ZAD% ZAD
			 ON ZAD.ZAD_FILIAL = ZAB.ZAB_FILIAL
			AND ZAD.ZAD_CODIGO = ZAB.ZAB_CODIGO
			AND ZAD.ZAD_VERSAO = ZAB.ZAB_VERSAO
		INNER JOIN %Table:ZA2% ZA2
			 ON ZA2_FILIAL = ZAD_FILIAL 
			AND ZA2.ZA2_NIVEL = ZAD_NIVEL
			AND ZA2.ZA2_EMPFIL = %xFilial:SC7%
		WHERE
			ZAB.%NotDel% AND
			ZAD.%NotDel% AND
			ZA2.%NotDel% AND
			ZA2.ZA2_LOGIN <> ' ' AND
			ZAB.ZAB_HOMOLO = 'S' AND
			ZAB.ZAB_CC = %Exp:cCC% AND
			ZAB.ZAB_TIPO = 'P'
		ORDER BY ZAD_SEQ

	EndSql

	(cNextAlias)->(DbGoTop())
	
	//preencher antes de alterar a posi��o do registro
	SC7->C7_ZCODGRD := (cNextAlias)->ZAB_CODIGO  
	SC7->C7_ZVERSAO := (cNextAlias)->ZAB_VERSAO
	
	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN
	
	If SC7->(dbSeek(xFilial('SC7') + cChav))
		
		While (cNextAlias)->(!EOF())
			
			If nTotal >= (cNextAlias)->ZAD_VALINI .And. nTotal <= (cNextAlias)->ZAD_VALFIM 
				RecLock('SCR',.T.)
					
					SCR->CR_FILIAL 	:= xFilial('SCR')
					SCR->CR_NUM 	:= cChav
					SCR->CR_TIPO 	:= 'PC'
					SCR->CR_USER 	:= (cNextAlias)->ZA2_CODUSU
					//SCR->CR_APROV 	:= (cNextAlias)->AL_APROV
					//SCR->CR_GRUPO 	:= cGrupo
					SCR->CR_ITGRP 	:= (cNextAlias)->ZAD_SEQ
					SCR->CR_NIVEL 	:= (cNextAlias)->ZAD_SEQ
					SCR->CR_STATUS 	:= IIF(nIt == 1,'02','01')
					SCR->CR_EMISSAO	:= dDataBase
					SCR->CR_TOTAL 	:= nTotal
					SCR->CR_MOEDA 	:= SC7->C7_MOEDA
					SCR->CR_ZCODGRD := (cNextAlias)->ZAB_CODIGO 
					SCR->CR_ZVERSAO := (cNextAlias)->ZAB_VERSAO
					SCR->CR_TXMOEDA	:= SC7->C7_TXMOEDA
					SCR->CR_ZNOMFOR	:= Posicione("SA2", 1, xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA , "A2_NOME") 
					
				SCR->(MsUnlock())
				nIt ++
			EndIf
			
			(cNextAlias)->(dbSkip())
		EndDo
	EndIf
	
	RestArea(aAreaSC7)
	RestArea(aArea)
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ChaveSCH  �Autor  � Andre Anjos		 � Data �  15/03/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Faz busca ou inclui item no array de SCs.                  ���
�������������������������������������������������������������������������͹��
���Uso       � CotGeraSCH                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ChaveSCH(nEvento,aCTBEnt,aSC,cAlias)

	Local lRet 	  := .F.
	Local nX   	  := 0
	Local cPrefix := Substr(cAlias,2,2)+"_"
	
	//-- Buscao no array aSCs (aScan)
	If nEvento == 1
		If (lRet := aSC[1]+aSC[2]+aSC[3]+aSC[4] == (cAlias)->&(cPrefix+"CC+"+cPrefix+"CONTA+"+cPrefix+"ITEMCTA+"+cPrefix+"CLVL"))
			For nX := 1 To Len(aCTBEnt)
				If !(lRet := aSC[nX+6]+aSC[nX+7] == (cAlias)->&(cPrefix+"EC"+aCTBEnt[nX]+"CR")+(cAlias)->&(cPrefix+"EC"+aCTBEnt[nX]+"DB"))
					Exit
				EndIf
			Next nX
		EndIf
		//-- Inclui no array aSCs (aAdd)
	ElseIf nEvento == 2
		aAdd(aSC,Array(6 + (Len(aCTBEnt) * 2) + 1))
		aTail(aSC)[1] := (cAlias)->&(cPrefix+"CC")
		aTail(aSC)[2] := (cAlias)->&(cPrefix+"CONTA")
		aTail(aSC)[3] := (cAlias)->&(cPrefix+"ITEMCTA")
		aTail(aSC)[4] := (cAlias)->&(cPrefix+"CLVL")
		aTail(aSC)[5] := SCX->(Recno())
		aTail(aSC)[6] := SC1->(Recno())
		For nX := 1 To Len(aCTBEnt)
			aTail(aSC)[nX+6] := (cAlias)->&(cPrefix+"EC"+aCTBEnt[nX]+"CR")
			aTail(aSC)[nX+7] := (cAlias)->&(cPrefix+"EC"+aCTBEnt[nX]+"DB")
		Next nX
		If cAlias == "SC1"
			aTail(aTail(aSC)) := Round((SC1->C1_QUANT / SC8->C8_QUANT) * 100,TamSX3("CH_PERC")[1])
		ElseIf cAlias == "SCX"
			aTail(aTail(aSC)) := Round((((SC1->C1_QUANT*100)/SC7->C7_QUANT)*SCX->CX_PERC)/100,2)
		EndIf
	EndIf
	
Return lRet

Static Function xTotPed(cChav)
	
	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	
	Local nRet := 0
	
	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN
	
	If SC7->(dbSeek(xFilial('SC7') + cChav))
		While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == xFilial('SC7') + cChav
				nRet += SC7->C7_TOTAL
			SC7->(dbSkip())
		EndDo
	EndIf
	
	RestArea(aArea)
	RestArea(aAreaSC7)
	
Return nRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LancaPCO �Autor  � Andre Anjos		 � Data �  07/01/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Encapsulamento da PCODetLan para tratar o novo parametro   ���
���          � MV_CFILPCO.                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LancaPCO(cAlias,cProcesso,cItem,cPrograma,lDeleta)
	Local aArea		:= GetArea()
	Local aAreaSM0  := SM0->(GetArea())
	Local lPCOFilen := SuperGetMV("MV_CFILPCO",.F.,.F.)
	Local cFilBkp	:= cFilAnt
	Local cFilEnt	:= AllTrim((cAlias)->&(Substr(cAlias,2,2)+"_FILENT"))
	
	Default lDeleta := .F.
	
	If lPCOFilen
		SM0->(dbSetOrder(1))
		SM0->(dbSeek(cEmpAnt+cFilEnt))
		cFilAnt := FWCodFil()
	EndIf
	
	PcoDetLan(cProcesso,cItem,cPrograma,lDeleta)
	
	SM0->(RestArea(aAreaSM0))
	cFilAnt := cFilBkp
	RestArea(aArea)
Return
