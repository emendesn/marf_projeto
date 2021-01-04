#include "protheus.ch"

#DEFINE VALMERC 	1	// Valor total do mercadoria
#DEFINE VALIPI 	    2	// Valor total do IPI
#DEFINE FRETE   	3   // Valor total do Frete
#DEFINE TOTPED		4	// Valor Total do Contrato

/*
=====================================================================================
Programa.:              MGFCOM55
Autor....:              Gresele
Data.....:              Nov/2017
Descricao / Objetivo:   Funcao copiada da funcao padrao MATA125, apenas para se customizar 
						a opcao de Copia do Contrato.
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFCOM55(cAlias,nReg,nOpcx)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �A125Contrato� Autor �Alexandre Inacio Lemes �Data�18/08/2003���
�������������������������������������������������������������������������Ĵ��
���Descricao � Inclusao / Alteracao / Exclusao e Visualizacao de Contrato ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := A125Contrato(ExpC1,ExpN1,ExpN2)                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Opcao selecionada                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F. 	                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGACOM                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//Function A125Contrato(cAlias,nReg,nOpcx)

Local aAreaSM0   := SM0->(GetArea())
Local aArea      := GetArea()
Local cFiltroSC3 := SC3->(dbFilter())
Local aSizeAut   := MsAdvSize()
Local aObj       := {}
Local aTitles	 := {}
Local aRefImpos  := MaFisRelImp('MT100',{"SC3"})
Local aCombo	 := {"F-FOB","C-CIF"}
Local aButtons   := {}
Local aUsButtons := {}
Local aObjects	 := {}
Local aInfo 	 := {}
Local aPosGet	 := {}
Local aPosObj	 := {}
Local aPosObjPE  := {}   
Local aNoFields := {"C3_QTIMP"}
Local nAuxFor	 := 0
Local nPos		 := 0
Local aStruSC3   := {}
Local aValidGet	 := {}
Local cSeek      := ""
Local cWhile     := ""
Local cQuery     := ""
Local lContinua	 := .T.
Local lGravaOk 	 := .T.
Local lQuje      := .T.
Local lQuery     := .F.
Local l125Visual := .F.
Local l125Inclui := .F.
Local l125Altera := .F.
Local l125Deleta := .F.
Local nSaveSX8   := GetSX8Len()
Local nQuje      := 0
Local nOpca      := 0
Local nX         := 0
Local nY         := 0
Local nPosIPI	 := 0
//Local oGetDados
Local oDlg
Local oFolder
Local oca125Forn
Local oca125Loj
Local oCond
Local oDescCond
Local oDescMoed
Local oGetMoeda
Local oFilEnt 
Local lMt125Get  := ExistBlock("MT125GET")
Local lGrade     := Magrade()
Local nPosProd := 0
Local nPosItem := 0
Local nCount := 1

//���������������������������������Ŀ
//� Arrays definidos para a consulta�
//� de Fornecedores                 �
//����������������������������������� 
PRIVATE cRET       := "A2_COD"
PRIVATE aCOD       := { {"Codigo","A2_COD"},{"Lj","A2_LOJA"},{"Nome Fornecedor","A2_NOME"} } //"Codigo"#"Lj"#"Nome Fornecedor"
PRIVATE aCGC       := { {"CNPJ","A2_CGC"},{"Nome Fornecedor","A2_NOME"} }                 	 //CNPJ# "Nome Fornecedor"

Private oGetDados
//Private aObj := {}

cAlias := "SC3"
nReg := SC3->(Recno())
nOpcx := 4

If Type("INCLUI") <> NIL
	INCLUI := nOpcx == 3
	ALTERA := nOpcx == 4
EndIf
aObj := Array(15)	 // Array com os objetos utilizados no Folder
aTitles	:= {"Totais","Inf. Fornecedor","Mensagem/Reajuste","Impostos"}  // "Totais","Inf. Fornecedor","Mensagem/Reajuste","Impostos"

//�����������������������������������������������������������������������Ŀ
//� Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)                �
//�������������������������������������������������������������������������
Do Case
Case aRotina[nOpcX][4] == 2
	l125Visual  := .T.
Case aRotina[nOpcX][4] == 3
	l125Inclui	:= .T.
Case aRotina[nOpcX][4] == 4
	l125Altera	:= .T.
Case aRotina[nOpcX][4] == 5
	l125Deleta	:= .T.
	l125Visual	:= .T.
EndCase

//�����������������������������������������������������������������������Ŀ
//� Botao para PMS integrado com o ERP                                    �
//�������������������������������������������������������������������������
If IntePms()		       
	aButtons := {{'PROJETPMS',{||Eval(bPmsDlgCP)},"Gerenciamento de Projetos", "Ger.Proj" }}
Endif

//�����������������������������������������������������������������������Ŀ
//�ATENCAO!!!Se for PYME retira a consulta a aprovacao dos Contratos      �
//�������������������������������������������������������������������������
If !__lPyme    		
	aadd(aButtons,{"budget",{|| a120Posic(cAlias,nReg,nOpcX,"CP")},"Consulta Aprovacao","Aprovac. "}) //"Consulta Aprovacao"
EndIf

aadd(aButtons,{"S4WB005N",     {|| A125ComView() }					    ,"Consultar Historico do Produto","Hist.Prd"})	//Historico de Produtos

//�����������������������������������������������������������������������Ŀ
//� Botao para exportar dados para EXCEL                                  �
//�������������������������������������������������������������������������
If RemoteType() == 1
	aAdd(aButtons,{PmsBExcel()[1],{|| DlgToExcel({{"CABECALHO","",{RetTitle('C3_NUM'),RetTitle('C3_EMISSAO'),RetTitle('C3_FORNECE'),RetTitle('C3_LOJA'),RetTitle('C3_COND'),RetTitle('C3_CONTATO'),RetTitle('C3_FILENT'),RetTitle('C3_MOEDA')},{cA125Num ,dA125Emis,cA125Forn,cA125Loj,cCondicao,cContato,cFilialEnt,nMoeda}},{"GETDADOS","",aHeader,aCols}})},PmsBExcel()[2],PmsBExcel()[3]})
EndIf

//�����������������������������������������������������������������������Ŀ
//� Adiciona botoes do usuario na EnchoiceBar                             �
//�������������������������������������������������������������������������
If ExistBlock( "MA125BUT" )
	If ValType( aUsButtons := ExecBlock( "MA125BUT", .F., .F., { aRotina[nOpcX][4] } ) ) == "A"
		AEval( aUsButtons, { |x| Aadd( aButtons, x ) } )
	EndIf 	
EndIf 	

PRIVATE aInfForn	    := {"","",CTOD(""),CTOD(""),"","",""}
PRIVATE aValores   	    := {0,0,0,0}
PRIVATE aHeader     	:= {}
PRIVATE aCols	    	:= {}
PRIVATE aColsBkp        := {}
PRIVATE aRatAFL		    := {}
PRIVATE bPMSDlgCP	    := {|| PmsDlgCP(aRotina[nOpcX][4],ca125Num)}
PRIVATE bFolderRefresh	:= {|| ((A125Refresh(@aValores)),(A125FRefresh(aObj)))}
PRIVATE bGDRefresh	    := {|| (oGetDados:oBrowse:Refresh())}
PRIVATE bRefresh		:= {|| (Eval(bFolderRefresh))}
PRIVATE bListRefresh	:= {|| (MaFisToCols(aHeader,aCols,,"MT120")),(Eval(bRefresh),Eval(bGDRefresh)) }
PRIVATE cA125Num   	    := '' //-- O Tratamento desta variavel sera feito abaixo
//PRIVATE dA125Emis  	    := If(l125Inclui,CriaVar("C3_EMISSAO"),SC3->C3_EMISSAO)
PRIVATE dA125Emis  	    := If(l125Inclui,CriaVar("C3_EMISSAO"),ddatabase)
PRIVATE cA125Forn  	    := If(l125Inclui,CriaVar("C3_FORNECE"),SC3->C3_FORNECE)
PRIVATE cA125Loj   	    := If(l125Inclui,CriaVar("C3_LOJA"),SC3->C3_LOJA)
PRIVATE cCondicao  	    := If(l125Inclui,CriaVar("C3_COND"),SC3->C3_COND)
PRIVATE cDescCond  	    := If(l125Inclui,CriaVar("E4_DESCRI"),SE4->E4_DESCRI)
PRIVATE cContato  	    := If(l125Inclui,CriaVar("C3_CONTATO"),SC3->C3_CONTATO)
PRIVATE cReajuste		:= If(l125Inclui,CriaVar("C3_REAJUST"),SC3->C3_REAJUST)
PRIVATE cTpFrete 		:= If(l125Inclui,IF(CriaVar("C3_TPFRETE",.T.)=="C","C-CIF","F-FOB"),SC3->C3_TPFRETE+If(SC3->C3_TPFRETE="C","-CIF","-FOB"))
PRIVATE cFilialEnt 	    := If(l125Inclui,CriaVar("C3_FILENT"),SC3->C3_FILENT)
PRIVATE cMsg			:= If(l125Inclui,CriaVar("C3_MSG"),SC3->C3_MSG)
PRIVATE nMoeda     		:= If(l125Inclui,1,Max(SC3->C3_MOEDA,1))
PRIVATE cDescMoed       := SuperGetMv("MV_MOEDA"+AllTrim(Str(nMoeda,2)))
PRIVATE cDescMsg	    := ""
PRIVATE cDescFor	    := ""
PRIVATE nTotCon         := 0
PRIVATE dA125Inic  	    := If(l125Inclui,CriaVar("C3_DATPRI"),ddatabase)
PRIVATE dA125Fim   	    := If(l125Inclui,CriaVar("C3_DATPRF"),SC3->C3_DATPRF)
PRIVATE oGrade

//������������������������������������������������������������������������Ŀ
//� Tratamento para numera��o contrato via sistema e via rotina automatica �
//��������������������������������������������������������������������������
If l125Inclui
	If l125Auto
		If ProcH('C3_NUM') == 0
			cA125Num := CriaVar('C3_NUM', .T.)      //-- Incrementa a numeracao quando o numero nao eh definido na rotina automatica
		Else
			cA125Num := aAutoCab[ProcH('C3_NUM'),2] //-- Considera o numero passado na rotina automatica
		EndIf
	Else
		cA125Num := CriaVar('C3_NUM', .T.)
	EndIf
Else
	cA125Num := SC3->C3_NUM
EndIf

oGrade	        := MsMatGrade():New('oGrade',,"C3_QUANT",,"A125GValid()",,;
	{{"C3_QUANT",.T., {{"C3_QTSEGUM",{|| ConvUm(AllTrim(oGrade:GetNameProd(,nLinha,nColuna)),aCols[nLinha][nColuna],0,2) } }} },;
	{"C3_ITEM",NIL,NIL},;
	{"C3_DATPRI",NIL,NIL},;
	{"C3_DATPRF",NIL,NIL},;
	{"C3_TOTAL",NIL,NIL},;
	{"C3_QTSEGUM",NIL, {{"C3_QUANT",{|| ConvUm(AllTrim(oGrade:GetNameProd(,nLinha,nColuna)),0,aCols[nLinha][nColuna],1) }}} };
	})

//����������������������������������������������������������Ŀ
//�Se for rotina automatica e inclusao, define o nOpcA como 1�
//������������������������������������������������������������
If l125Auto
	nOpcA := 1
Endif

//����������������������������������������������������������Ŀ
//� Monta aHeader e aCols utilizando a funcao FillGetDados.  �
//������������������������������������������������������������
If l125Inclui
	//����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	//� Sintaxe da FillGetDados(/*nOpcX*/,/*Alias*/,/*nOrdem*/,/*cSeek*/,/*bSeekWhile*/,/*uSeekFor*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/),/*bBeforeCols*/ |
	//������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������	
	FillGetDados(nOpcX,"SC3",1,,,,aNoFields,,,,,.T.,,,)
	aCols[1][aScan(aHeader,{|x| Trim(x[2])=="C3_ITEM"})] := StrZero(1,Len(SC3->C3_ITEM))
Else
	//��������������������������������������������������������������Ŀ
	//� Inicializa as veriaveis utilizadas na exibicao do Pedido     �
	//����������������������������������������������������������������
	A125Forn(SC3->C3_FORNECE,SC3->C3_LOJA,@aInfForn,.F.)
	A125CabOk(@oCond,@oca125Forn,@oca125Loj,aRefImpos)
	A125Formula(cMsg,@cDescMsg)
	A125Formula(cReajuste,@cDescFor,"N")
	A125DescCnd(cCondicao,,@cDescCond)	
	A125DescMoed(nMoeda,,@cDescMoed)
	//��������������������������������������������������������������Ŀ
	//� Faz a montagem do aCols com os dados do SC3                  �
	//����������������������������������������������������������������
	nX := 0
	nY := 0
	cContrato := SC3->C3_NUM
	dbSelectArea("SC3")
	dbSetOrder(1)
	aStruSC3 := SC3->(dbStruct())


	If !InTransact() .And. !(l125Altera .Or. l125Deleta) .And. Empty(Ascan(aStruSC3,{|x| x[2]=="M"}))
		lQuery := .T.
		cQuery := "SELECT SC3.*,SC3.R_E_C_N_O_ SC3RECNO "
		cQuery += "FROM "+RetSqlName("SC3")+" SC3 "
		cQuery += "WHERE SC3.C3_FILIAL='"+xFilial("SC3")+"' AND "
		cQuery += "SC3.C3_NUM = '"+cContrato+"' AND "
		cQuery += "SC3.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY "+SqlOrder(SC3->(IndexKey()))		
		cQuery := ChangeQuery(cQuery)		

		dbSelectArea("SC3")
		dbCloseArea()
	EndIf

	cSeek  := xFilial("SC3")+cContrato
	cWhile := "SC3->C3_FILIAL+SC3->C3_NUM"
	//����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	//� Sintaxe da FillGetDados(nOpcX,Alias,nOrdem,cSeek,bSeekWhile,uSeekFor,aNoFields,aYesFields,lOnlyYes,cQuery,bMontCols,lEmpty,aHeaderAux,aColsAux,bAfterCols,bBeforeCols,bAfterHeader,cAliasQry |
	//������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������	
	// muda conteudo da variavel l125Altera, pois a funcao padrao A125After faz lock dos registros da sc3, quando esta variavel estah .T. e como estamos gerando um novo contrato,
	// nao hah necessidade de lock da sc3
	l125Altera := .F.
	FillGetDados(nOpcX,"SC3",1,cSeek,{|| &cWhile },,aNoFields,,,cQuery,,,,, {|aColsX| A125After(aColsX,aRefImpos,l125Altera,l125Deleta,@lQuje,@nQuje,@lContinua,lGrade)},,,"SC3")
	l125Altera := .T.
	
	// zera recno do acols, senao funcao padrao A125Grava entende que eh alteracao e nao inclusao
	aEval(aCols,{|x,y| aCols[y][Len(aHeader)] := 0})
	// reordena acols pelo produto
	nPosProd := aScan(aHeader,{|x| Alltrim(x[2])=="C3_PRODUTO"})
	aSort(aCols,,,{ |x,y| x[nPosProd] < y[nPosProd]})
	// regrava campo de item 
	nPosItem := aScan(aHeader,{|x| Alltrim(x[2])=="C3_ITEM"})
	nCount := 1
	aEval(aCols,{|x,y| aCols[y][nPosItem] := StrZero(nCount,Len(SC3->C3_ITEM)),nCount++})
    //
    
	nPosIPI	:= aScan(aHeader,{|x| Trim(x[2])=="C3_IPI"})

	If lQuery
		dbSelectArea("SC3")
		dbCloseArea()
		ChkFile("SC3",.F.)
	EndIf
    /*
	If lQuje .And. l125Altera
		Help(" ",1,"A125ALT")
		lContinua := .F.
	Endif
    */
	If lContinua
		//���������������������������������������������Ŀ
		//� Executa o Refresh nos valores de impostos.  �
		//�����������������������������������������������
		A125Refresh(@aValores)
	EndIf
EndIf

//�������������������������������������������������������������Ŀ
//�Se o Recurso de Grade de Produtos estiver Ativado, o aCols   �
//�sera processado pela funcao aColsGrade e a MatxFis sera      �
//�Finalizada e Reiniciada para sincronizar o novo aCols formado�
//�pela aColsGrade().                                           �
//���������������������������������������������������������������
If lGrade
	If !l125inclui
		aColsBkp :=aClone(acols)
		aCols    := aColsGrade(oGrade, aCols, aHeader, "C3_PRODUTO", "C3_ITEM", "C3_ITEMGRD")
	Endif

	MaFisEnd()
	MaFisIni(ca125Forn,ca125Loj,"F","N",Nil,aRefImpos,,.T.,,,,,,,)

	For nX := 1 to Len(aCols)
		MaFisIniLoad(nX,,.T.)
		For nY	:= 1 To Len(aHeader)
			cValid	:= AllTrim(UPPER(aHeader[nY][6]))
			cRefCols := MaFisGetRf(cValid)[1]
			If !Empty(cRefCols) .AND. MaFisFound("IT",nX)
				MaFisLoad(cRefCols,aCols[nX][nY],nX)
			EndIf
		Next nY
		MaFisEndLoad(nX,1)
	Next nX

	If nPosIpi > 0
		MaFisAlt("NF_BASEIPI",nTotCon)
	EndIf    

Endif

// obs: altera variaveis para mudar comportamento da rotina e validacoes do padrao
l125Altera := .F.
Altera := .F.
l125Inclui := .T.
Inclui := .T.

If lContinua
	//�����������������������������������������������������������Ŀ
	//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
	//�������������������������������������������������������������
	PcoIniLan("000050")
	If !l125Auto
		aObjects := {}
		AAdd( aObjects, { 100, 50, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )
		AAdd( aObjects, { 100,  75, .T., .F. } )
		aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,;
			{{10,40,111,140,200,234,288,240},;
			{10,40,111,140,223,268,63,175,195},;
			{5,70,160,205,295},;
			{6,34,200,215},;
			{6,34,80,113,160,185},;
			{6,34,245,268,260},;
			{142,293,140,293},;
			{9,47,188,148,9,146} } )

		//����������������������������������������������������������������Ŀ
		//� Ativa tecla F4 para comunicacao com pedidos de compra em aberto�
		//������������������������������������������������������������������
		If lMT125F4
			SetKey( VK_F4,{ || ExecBlock("MT125F4",.F.,.F., 0 ) } )
		Endif
		
		cA125Num := GetSX8Num("SC3","C3_NUM")
		
		DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL
		If lMt125Get
			aPosObj := If(ValType(aPosObjPE:=ExecBlock("MT125GET",.F.,.F.,{aPosObj,nOpcx}))== "A",aPosObjPE,aPosObj)
		Endif
		//��������������������������������������������������������������Ŀ
		//�Define o cabecalho da rotina                                  �
		//����������������������������������������������������������������
		@ aPosObj[1][1],aPosObj[1][2] TO aPosObj[1][3],aPosObj[1][4] LABEL '' OF oDlg PIXEL

		@ aPosObj[1,1]+5,aPosGet[1,1] SAY "Numero" OF oDlg PIXEL SIZE 031,006  // "Numero"
		@ aPosObj[1,1]+4,aPosGet[1,2] MSGET cA125Num  PICTURE PesqPict('SC3','C3_NUM') F3 CpoRetF3('C3_NUM');
			WHEN .F. /*l125Inclui .And. VisualSX3('C3_NUM')*/ VALID CheckSX3('C3_NUM',cA125Num) OF oDlg PIXEL SIZE 031,006

		@ aPosObj[1,1]+5,aPosGet[1,3] SAY "Data de Emissao" OF oDlg PIXEL SIZE 050,006 // "Data de Emissao"
		@ aPosObj[1,1]+4,aPosGet[1,4] MSGET dA125Emis PICTURE PesqPict('SC3','C3_EMISSAO') F3 CpoRetF3('C3_EMISSAO');
			WHEN l125Inclui .And. VisualSX3('C3_EMISSAO') VALID CheckSX3('C3_EMISSAO',dA125Emis) OF oDlg PIXEL SIZE 042,006

		@ aPosObj[1,1]+5,aPosGet[1,5] SAY "Fornecedor" OF oDlg PIXEL SIZE 036,006 // "Fornecedor"
		@ aPosObj[1,1]+4,aPosGet[1,6] MSGET oca125Forn VAR cA125Forn  PICTURE PesqPict('SC3','C3_FORNECE') F3 CpoRetF3('C3_FORNECE','SA2');
			WHEN l125Inclui .And. VisualSX3('C3_FORNECE') Valid A125Forn(cA125Forn,@cA125Loj,@aInfForn) .And. CheckSX3('C3_FORNECE',cA125Forn) ;
			.And. A125VFold('NF_CODCLIFOR',ca125Forn) OF oDlg PIXEL SIZE 095,006
		oca125Forn:lReadOnly := l125Visual

		@ aPosObj[1,1]+4,aPosGet[1,7] MSGET oca125Loj VAR cA125Loj  PICTURE PesqPict('SC3','C3_LOJA') F3 CpoRetF3('C3_LOJA');
			WHEN l125Inclui.And. VisualSX3('C3_LOJA') Valid A125Forn(cA125Forn,@cA125Loj,@aInfForn) .And. CheckSX3('C3_LOJA',cA125Loj) ;
			.And. A125VFold('NF_LOJA',ca125Loj) OF oDlg PIXEL SIZE 009,006

		@ aPosObj[1,1]+20,aPosGet[2,1] SAY "Cond. Pagto" OF oDlg PIXEL SIZE 030,008 // "Cond. Pagto"
		@ aPosObj[1,1]+19,aPosGet[2,2] MSGET oCond VAR cCondicao  PICTURE PesqPict('SC3','C3_COND') F3 CpoRetF3('C3_COND');
			WHEN !l125Visual.And. VisualSX3('C3_COND') Valid CheckSX3('C3_COND',cCondicao) .And. A125DescCnd(cCondicao,@oDescCond,@cDescCond,oGetDados);
			OF oDlg PIXEL SIZE 025,006
		oCond:lReadOnly := l125Visual

		@ aPosObj[1,1]+19,aPosGet[2,7] MSGET oDescCond VAR cDescCond PICTURE PesqPict('SE4','E4_DESCRI') ;
			WHEN .F. OF oDlg PIXEL SIZE 055,006

		@ aPosObj[1,1]+20,aPosGet[2,3] SAY "Contato" OF oDlg PIXEL SIZE 038,006 // "Contato"
		@ aPosObj[1,1]+19,aPosGet[2,4] MSGET cContato  PICTURE PesqPict('SC3','C3_CONTATO') F3 CpoRetF3('C3_CONTATO');
			WHEN !l125Visual .And. VisualSX3('C3_CONTATO') Valid CheckSX3('C3_CONTATO',cContato) ;
			OF oDlg PIXEL SIZE 074,006

		@ aPosObj[1,1]+20,aPosGet[1,5] SAY "Filial p/ Entrega" OF oDlg PIXEL SIZE 050,008 //"Filial p/ Entrega"
		@ aPosObj[1,1]+19,aPosGet[1,6] MSGET oFilEnt VAR cFilialEnt  PICTURE PesqPict('SC3','C3_FILENT') F3 CpoRetF3('C3_FILENT');
			WHEN /*!l125Visual .And. VisualSX3('C3_FILENT').And.!Empty(xFilial("SC3"))*/.T.  Valid CheckSX3('C3_FILENT',cFilialEnt) ;
			OF oDlg PIXEL SIZE 019,006
		oFilEnt:lReadOnly := l125Visual

		@ aPosObj[1,1]+35,aPosGet[1,1] SAY "Moeda" OF oDlg PIXEL SIZE 030,006 // "Moeda"
		@ aPosObj[1,1]+34,aPosGet[1,2] MSGET oGetMoeda VAR nMoeda PICTURE PesqPict("SC3","C3_MOEDA") ;
			VALID M->nMoeda <= MoedFin() .And. M->nMoeda <> 0 .And. A125DescMoed(nMoeda,@oDescMoed,@cDescMoed) WHEN !l125Visual .And. VisualSX3("C3_MOEDA") PIXEL SIZE 25,06 OF oDlg
		@ aPosObj[1,1]+34,aPosGet[2,7] MSGET oDescMoed VAR cDescMoed  WHEN .F. OF oDlg PIXEL SIZE 055,006

		If ExistBlock("MT125TEL")
			ExecBlock("MT125TEL",.F.,.F.,{@oDlg, aPosGet, aObj, nOpcx, nReg} )
		EndIf                       		
		//��������������������������������������������������������������Ŀ
		//�Define a area da getdados da rotina                           �
		//����������������������������������������������������������������
		If l125visual .And. lGrade
			oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],4,,,,,{"C3_QUANT","C3_DATPRI","C3_DATPRF"},,,9999,,,,'A125Del')
		Else
			oGetDados := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcX,'A125LinOk','A125TudOk','+C3_ITEM',!l125Visual,,1,,9999,,,,'A125Del')
		Endif
		oGetDados:oBrowse:bGotFocus	:= {||A125CabOk(@oCond,@oca125Forn,@oca125Loj,aRefImpos) }

		//��������������������������������������������������������������Ŀ
		//�Define a area do rodape da rotina                             �
		//����������������������������������������������������������������
		oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],aTitles,{"HEADER"},oDlg,,,, .T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1],)
		//acerto no folder para nao perder o foco
		For nX := 1 to Len(oFolder:aDialogs)
			DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nX]
		Next nX
		//��������������������������������������������������������������Ŀ
		//�Folder dos totais da rotina                                   �
		//����������������������������������������������������������������
		oFolder:aDialogs[1]:oFont := oDlg:oFont
		@ 006,aPosGet[3,1] SAY "Valor da Mercadoria" OF oFolder:aDialogs[1] PIXEL SIZE 055,009 // "Valor da Mercadoria"
		@ 005,aPosGet[3,2] MSGET aObj[1] VAR aValores[VALMERC] PICTURE PesqPict('SC3','C3_TOTAL',,nMoeda) OF oFolder:aDialogs[1] PIXEL WHEN .F. SIZE 080,009
		@ 006,aPosGet[3,3] SAY "Valor do IPI" OF oFolder:aDialogs[1] PIXEL SIZE 049,009 // "Valor do IPI"
		@ 005,aPosGet[3,4] MSGET aObj[2] VAR aValores[VALIPI] PICTURE PesqPict('SC3','C3_TOTAL',,nMoeda)  OF oFolder:aDialogs[1] PIXEL WHEN .F. SIZE 080,009
		@ 020,aPosGet[3,1] SAY "Tp. Frete" OF oFolder:aDialogs[1] PIXEL SIZE 050,009 // "Tp. Frete"
		@ 019,aPosGet[3,2] MSCOMBOBOX aObj[3] VAR cTpFrete ITEMS aCombo ON CHANGE A125VldCombo(cTpFrete,@aValores);
			.And. A125VFold("NF_FRETE",aValores[FRETE]) WHEN !l125Visual SIZE 045,050 OF oFolder:aDialogs[1] PIXEL
		@ 020,aPosGet[3,3] SAY "Valor do Frete" OF oFolder:aDialogs[1] PIXEL SIZE 035,009 //"Valor do Frete"
		@ 019,aPosGet[3,4] MSGET aObj[4] VAR aValores[FRETE]   PICTURE PesqPict('SC3','C3_FRETE',,nMoeda) OF oFolder:aDialogs[1] PIXEL WHEN !l125Visual .And. cTpFrete=="C-CIF" VALID A125VFold("NF_FRETE",aValores[FRETE]) SIZE 080,009
		@ 051,aPosGet[3,3] SAY "Total do Contrato" OF oFolder:aDialogs[1] PIXEL SIZE 058,009 // "Total do Contrato"
		@ 049,aPosGet[3,4] MSGET aObj[5] VAR aValores[TOTPED]  PICTURE PesqPict('SC3','C3_TOTAL',,nMoeda) OF oFolder:aDialogs[1] PIXEL WHEN .F. SIZE 080,009
		@ 043,003 TO 46 ,aPosGet[3,5] LABEL '' OF oFolder:aDialogs[1] PIXEL

		//��������������������������������������������������������������Ŀ
		//�Folder com as informacoes do fornecedor                       �
		//����������������������������������������������������������������
		oFolder:aDialogs[2]:oFont := oDlg:oFont
		@ 006,aPosGet[4,1] SAY "Nome" OF oFolder:aDialogs[2] PIXEL SIZE 037,009 // "Nome"
		@ 005,aPosGet[4,2] MSGET aObj[6] VAR aInfForn[1]  PICTURE PesqPict('SA2','A2_NOME');
			WHEN .F. OF oFolder:aDialogs[2] PIXEL SIZE 159,009
		@ 006,aPosGet[4,3] SAY "Tel." OF oFolder:aDialogs[2] PIXEL SIZE 023,009 // "Tel."
		@ 005,aPosGet[4,4] MSGET aObj[7] VAR aInfForn[2];
			WHEN .F. OF oFolder:aDialogs[2] PIXEL SIZE 074,009
		@ 043,aPosGet[5,1] SAY "1a Compra" OF oFolder:aDialogs[2] PIXEL SIZE 032,009 // "1a Compra"
		@ 042,aPosGet[5,2] MSGET aObj[8] VAR aInfForn[3]  PICTURE PesqPict('SA2','A2_PRICOM') ;
			WHEN .F. OF oFolder:aDialogs[2] PIXEL SIZE 040,009
		@ 043,aPosGet[5,3] SAY "Ult. Compra" OF oFolder:aDialogs[2] PIXEL SIZE 036,009 // "Ult. Compra"
		@ 042,aPosGet[5,4] MSGET aObj[9] VAR aInfForn[4]  PICTURE PesqPict('SA2','A2_ULTCOM');
			WHEN .F. OF oFolder:aDialogs[2] PIXEL SIZE 040,009
		@ 43 ,aPosGet[5,5] SAY RTrim(RetTitle("A2_CGC")) OF oFolder:aDialogs[2] PIXEL SIZE 31 ,009 // "CNPJ / CPF"
		@ 42 ,aPosGet[5,6] MSGET aObj[10] VAR aInfForn[7] PICTURE PesqPict('SA2','A2_CGC');
			WHEN .F. OF oFolder:aDialogs[2] PIXEL SIZE 076,009
		@ 024,aPosGet[6,1] SAY "Endereco" OF oFolder:aDialogs[2] PIXEL SIZE 049,009 // "Endereco"
		@ 023,aPosGet[6,2] MSGET aObj[11] VAR aInfForn[5]  PICTURE PesqPict('SA2','A2_END');
			WHEN .F. OF oFolder:aDialogs[2] PIXEL SIZE 205,009
		@ 024,aPosGet[6,3] SAY "Estado" OF oFolder:aDialogs[2] PIXEL SIZE 032,009 // "Estado"
		@ 023,aPosGet[6,4] MSGET aObj[12] VAR aInfForn[6] PICTURE PesqPict('SA2','A2_EST');
			WHEN .F. OF oFolder:aDialogs[2] PIXEL SIZE 021,009
		@ 042,aPosGet[6,5] BUTTON "Mais Inf." SIZE 030,010  FONT oDlg:oFont ACTION A120ToFC030()  OF oFolder:aDialogs[2] PIXEL // "Mais Inf."

		//��������������������������������������������������������������Ŀ
		//�Folder de Menssagens                                          �
		//����������������������������������������������������������������
		oFolder:aDialogs[3]:oFont := oDlg:oFont
		@ 005,aPosGet[7,1] TO 055,aPosGet[7,2] LABEL "Reajuste" OF oFolder:aDialogs[3] PIXEL //"Reajuste"
		@ 005,003 TO 055,aPosGet[7,3] LABEL "Mensagem" OF oFolder:aDialogs[3] PIXEL // "Mensagem"
		@ 015,aPosGet[8,1] SAY "Cod. Formula" OF oFolder:aDialogs[3] PIXEL SIZE 040,009 // "Cod. Formula"
		@ 014,aPosGet[8,2] MSGET cMsg PICTURE PesqPict('SC3','C3_MSG') F3 CpoRetF3('C3_MSG');
			WHEN !l125Visual .And.VisualSX3('C3_MSG') Valid CheckSX3('C3_MSG',cMsg).And.A125Formula(cMsg,@cDescMsg).And. A125FRefresh(aObj);
			OF oFolder:aDialogs[3] PIXEL SIZE 023,009
		@ 014,aPosGet[8,3] MSGET cReajuste PICTURE PesqPict('SC3','C3_REAJUST') F3 CpoRetF3('C3_REAJUST');
			WHEN !l125Visual .And.VisualSX3('C3_REAJUST') Valid CheckSX3('C3_REAJUST',cReajuste) .And.A125Formula(cReajuste,@cDescFor,"N").And. A125FRefresh(aObj);
			OF oFolder:aDialogs[3] PIXEL SIZE 023,009
		@ 015,aPosGet[8,4] SAY "Cod.Formula" OF oFolder:aDialogs[3] PIXEL SIZE 040,009 //"Cod.Formula"
		@ 032,aPosGet[8,5] MSGET aObj[13] VAR cDescMsg  PICTURE "@!" OF oFolder:aDialogs[3] WHEN .F. PIXEL SIZE 124,009
		@ 031,aPosGet[8,6] MSGET aObj[14] VAR cDescFor  PICTURE "@!" OF oFolder:aDialogs[3] WHEN .F. PIXEL SIZE 140,009

		//��������������������������������������������������������������Ŀ
		//�MsGets do Folder do Resumo de Impostos                        �
		//����������������������������������������������������������������
		oFolder:aDialogs[4]:oFont := oDlg:oFont
		aObj[15] := MaFisRodape(1,oFolder:aDialogs[4],,{5,3,aPosGet[7,4],53},bListRefresh,l125Visual)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||If(oGetDados:TudoOk().And.If(l125Deleta,A125DelOk(),.T.),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{|| oDlg:End()},,aButtons)

		//����������������������������������������������������������������Ŀ
		//� Desativa tecla F4.                                             �
		//������������������������������������������������������������������
		If lMT125F4
			Set Key VK_F4 To
		Endif
	Else
		//����������������������Ŀ
		//�Validacao do cabecalho�
		//������������������������
		
	 	nPos := ProcH("C3_NUM")
		If l125Inclui
			A125Valid(@aValidGet,	"cA125Num",	If(nPos = 0, cA125Num, aAutoCab[nPos,2]),	"CheckSX3('C3_NUM')",.F.)
		Endif  
		
		nPos := ProcH("C3_FORNECE")
		If nPos > 0
			cA125Forn := aAutoCab[nPos,2]
			If l125Inclui
				A125Valid(@aValidGet,"cA125Forn",cA125Forn,	"CheckSX3('C3_FORNECE',cA125Forn)",	.F.)
			Endif
		Endif

		nPos := ProcH("C3_LOJA")
		If nPos > 0
			cA125Loj := aAutoCab[nPos,2]
			If l125Inclui
				A125Valid(@aValidGet,"cA125Loj",cA125Loj,"A125Forn(cA125Forn,cA125Loj) .And. CheckSX3('C3_LOJA',cA125Loj)",	.F.)
			Endif
		Endif
 
		nPos := ProcH("C3_COND")
		If nPos > 0
			cCondicao := aAutoCab[nPos,2]
			If l125Inclui
				A125Valid(@aValidGet,	"cCondicao",	cCondicao,	"CheckSX3('C3_COND')",		.F.)
			Endif
		Endif

		nPos := ProcH("C3_CONTATO")
		If nPos > 0
			cContato := aAutoCab[nPos,2]
			If l125Inclui
				A125Valid(@aValidGet,	"cContato",		cContato,	"CheckSX3('C3_CONTATO')",	.F.)
			Endif
		Endif

		nPos := ProcH("C3_TPFRETE")
		If nPos > 0
			cTpFrete := aAutoCab[nPos,2]
			If l125Inclui
				A125Valid(@aValidGet,	"cTpFrete",		cTpFrete,	"CheckSX3('C3_TPFRETE')",	.F.)
			Endif
		Endif

		nPos :=	ProcH("C3_REAJUST")
		If nPos > 0
			cReajuste := aAutoCab[nPos,2]
			If l125Inclui
				A125Valid(@aValidGet,	"cReajuste",	cReajuste,	"CheckSX3('C3_REAJUST')",	.F.)
			Endif
		Endif

		nPos := ProcH("C3_MSG")
		If nPos > 0
			cMSG := aAutoCab[nPos,2]
			If l125Inclui
				A125Valid(@aValidGet,	"cMSG",			cMSG,		"CheckSX3('C3_MSG')",		.F.)
			Endif
		Endif

		nPos := ProcH("C3_DATINIC")
		If nPos > 0
			dA125Val := aAutoCab[nPos,2]
			If l125Inclui
				A125Valid(@aValidGet,	"dA125Val",		dA125Val, 	"CheckSX3('C3_DATINIC')",	.F.)
			Endif
		Endif

		If l125Inclui .AND. !SC3->( MsVldGAuto( aValidGet ) )
			lContinua := .F.
		EndIf

		If lContinua
			If !MaFisFound("NF")
				MaFisIni(cA125Forn,cA125Loj,"F","N",Nil,aRefImpos)
				If ProcH("C3_FRETE") > 0
					MaFisAlt("NF_FRETE",aAutoCab[ProcH("C3_FRETE"),2])
				EndIf
				If ProcH("C3_VALFRE") > 0
					MaFisAlt("NF_VALFRE",aAutoCab[ProcH("C3_VALFRE"),2])
				EndIf

				If !MsGetDAuto(aAutoItens,"A125LinOk",{|| A125TudOk()},aAutoCab,aRotina[nOpcx][4])
					nOpcA := 0
				EndIf
			EndIf
		EndIf
	Endif
	//�������������������������������������������������������������������Ŀ
	//�Atualizacao do contrato de parceria                                �
	//���������������������������������������������������������������������
	If nOpcA == 1 .And. lContinua
		If l125Inclui .Or. l125Altera .Or. l125Deleta
			//�����������������������������������������������������������Ŀ
			//� Inicializa a gravacao atraves das funcoes MATXFIS         �
			//�������������������������������������������������������������
			MaFisWrite(1)

			If !l125Inclui
				//�������������������������������������������������������Ŀ
				//� Exibir Help de advertencia para C3_QUJE > 0.          �
				//���������������������������������������������������������
				If nQuje > 0 .And. l125Deleta
					Help(" ",1,"A125QUJE")
					lContinua := .F.
				EndIf

				If lContinua
					Begin Transaction
						A125Grava(l125Deleta,aRefImpos)
						EvalTrigger()
						While ( GetSX8Len() > nSaveSX8 )
							ConFirmSX8()
						EndDo
					End Transaction
				EndIf
			Else
				// so grava se data final for diferente de outro pedido - TG 12/01/2018
				cProdx	:= ""
   				cFil    :=""
   				_cDat 	:= Ascan(aHeader,{|x| AllTrim(x[2])=="C3_DATPRF"})
    			dDatax 	:= aCols[n][_cDat]
  
				cProdx	:= SC3->C3_PRODUTO

   				_cfil 	:= Ascan(aHeader,{|x| AllTrim(x[2])=="C3_FILENT"})
    			cFil 	:= aCols[n][_cfil]
                
				cQuery = " SELECT DISTINCT C3_PRODUTO,C3_FILENT "
				cQuery += " From " + RetSqlName("SC3") + " "
				cQuery += " WHERE C3_DATPRF >= '"+dtos(dDatax)+"' AND C3_PRODUTO='"+cProdx+"' AND C3_FILENT='"+cFil+"' " 	
				cQuery += " AND SC3010.D_E_L_E_T_<>'*' AND C3_RESIDUO=' ' "
				If Select("TEMP11") > 0
					TEMP11->(dbCloseArea())
				EndIf
				cQuery  := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP11",.T.,.F.)
				dbSelectArea("TEMP11")    
				TEMP11->(dbGoTop())
    
				ncont :=0
				While TEMP11->(!Eof())
        			ncont := ncont+1
        			TEMP11->(dbSKIP())
				EndDo
              
   				if ncont > 0   
     				 msgalert("ATENCAO, JA EXISTE UM CONTRATO ATIVO CADASTRADO ")
   					lGravaOk := .F.
				else
					lGravaOk := A125Grava(l125Deleta,aRefImpos)
				endif
				
				If !lGravaOk
					Help(" ",1,"A125NAOREG")
					While ( GetSX8Len() > nSaveSX8 )
						RollBackSX8()
					EndDo
				Else
					EvalTrigger()
					While ( GetSX8Len() > nSaveSX8 )
						ConFirmSX8()
					EndDo
					
					// zera alguns campos da sc3
					SC3->(dbSetOrder(1))
					If SC3->(dbSeek(xFilial("SC3")+cA125Num))
						SC3->(dbEval({|| SC3->(RecLock("SC3",.F.)),SC3->C3_QUJE:=0,SC3->C3_RESIDUO:="",SC3->C3_ENCER:="",SC3->C3_OK:="",SC3->C3_QTIMP := SC3->C3_QUANT,SC3->(MsUnLock())},,{||SC3->C3_NUM == cA125Num}))
						// reposiciona no 1 item para mostrar corretamente na mbrowse
						SC3->(dbSeek(xFilial("SC3")+cA125Num))
					EndIf
					APMsgInfo("Contrato numero: "+cA125Num+" copiado com sucesso.")
				EndIf
			EndIf
		EndIf
	EndIf
	//�����������������������������������������������������������Ŀ
	//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
	//�������������������������������������������������������������
	PcoFinLan("000050")  
	PcoFreeBlq("000050")
EndIf

SetKey( VK_F4,Nil )
SetKey( VK_F5,Nil )

//�����������������������������������������������������������Ŀ
//� Destrava os registros na aletaracao e exclusao            �
//�������������������������������������������������������������
While ( GetSX8Len() > nSaveSX8 )
	RollBackSX8()
EndDo
MsUnLockAll()

//zera variaveis, pois estah mostrando novo contrato jah preenchido
//aHeader := {}
//aCols := {}
//aObj := {}

//�����������������������������������������������������������Ŀ
//� Finaliza o uso das funcoes MATXFIS                        �
//�������������������������������������������������������������
MaFisEnd()

FreeUsedCode()

If !(nOpcA == 1 .And. lContinua .and. lGravaOk)
	RestArea(aArea)
Endif
RestArea(aAreaSM0)
If !Empty(cFiltroSC3)
	SC3->(dbSetFilter({||&cFiltroSC3},cFiltroSC3))
EndIF

Return(lContinua)