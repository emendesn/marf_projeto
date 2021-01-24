#INCLUDE "MATR285.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR285  � Autor � Marcos V. Ferreira    � Data � 20/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Listagem dos itens inventariados                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MGFEST53()

Local oReport

If TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	MATR285R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Marcos V. Ferreira     � Data �20/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR285			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local aOrdem    := {OemToAnsi(' Por Codigo    '),OemToAnsi(' Por Tipo      '),OemToAnsi(' Por Grupo   '),OemToAnsi(' Por Descricao '),OemToAnsi(' Por Local    ')}		//' Por Codigo    '###' Por Tipo      '###' Por Grupo   '###' Por Descricao '###' Por Local    '
Local cPictQFim := PesqPict("SB2",'B2_QFIM' )
Local cPictQtd  := PesqPict("SB7",'B7_QUANT')
Local cPictVFim := PesqPict("SB2",'B2_VFIM1')
Local cTamQFim  := TamSX3('B2_QFIM' )[1]
Local cTamQtd   := TamSX3('B7_QUANT')[1]
Local cTamVFim  := TamSX3('B2_VFIM1')[1]
Local cAliasSB1 := GetNextAlias()    
Local cAliasSB2 := cAliasSB1
Local cAliasSB7 := cAliasSB1
Local oSection1
//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("MATR285",STR0001,"MGFEST53", {|oReport| ReportPrint(oReport,aOrdem,cAliasSB1,cAliasSB2,cAliasSB7)},STR0002+" "+STR0003+" "+STR0004)
oReport:DisableOrientation()
oReport:SetLandscape() //Define a orientacao de pagina do relatorio como paisagem.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Produto de                           �
//� mv_par02             // Produto ate                          �
//� mv_par03             // Data de Selecao                      �
//� mv_par04             // Data ate Selecao                      �
//� mv_par05             // De  Tipo                             �
//� mv_par06             // Ate Tipo                             �
//� mv_par07             // De  Local                            �
//� mv_par08             // Ate Local                            �
//� mv_par09             // De  Grupo                            �
//� mv_par10             // Ate Grupo                            �
//� mv_par11             // Qual Moeda (1 a 5)                   �
//� mv_par12             // Imprime Lote/Sub-Lote                �
//� mv_par13             // Custo Medio Atual/Ultimo Fechamento  �
//� mv_par14             // Imprime Localizacao ?                �
//� mv_par15             // Lista quais ?                        �
//����������������������������������������������������������������
Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da secao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a secao.                   �
//�ExpA4 : Array com as Ordens do relatorio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Criacao da Sessao 1                                          �
//����������������������������������������������������������������
oSection1:= TRSection():New(oReport,STR0050,{"SB1","SB7","SB2"},aOrdem) // "Lancamentos para Inventario"
oSection1:SetTotalInLine(.F.)
oSection1:SetNoFilter("SB7")
oSection1:SetNoFilter("SB2")

TRCell():New(oSection1,'B1_CODITE'	,cAliasSB1	,STR0027				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_COD'		,cAliasSB1	,STR0027				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC'	,cAliasSB1	,STR0028				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_LOTECTL'	,cAliasSB7	,STR0029				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'B7_NUMLOTE'	,cAliasSB7	,STR0030+CRLF+STR0029	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_LOCALIZ'	,cAliasSB7	,STR0031				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'B7_NUMSERI'	,cAliasSB7	,STR0032				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_TIPO'	,cAliasSB1	,STR0033				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_GRUPO'	,cAliasSB1	,STR0034				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_UM'		,cAliasSB1	,STR0035				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B2_LOCAL'	,cAliasSB2	,STR0036				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_DOC'		,cAliasSB7	,STR0037				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_QUANT'	,cAliasSB7	,STR0038+CRLF+STR0039	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,'B2_CM1'		,cAliasSB2	,'CUSTO UNITARIO'		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,'QUANTDATA'	,'   '		,STR0040+CRLF+STR0041	,cPictQFim	,cTamQFim	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,'DIFQUANT'	,'   '		,STR0042+CRLF+STR0043	,cPictQtd	,cTamQtd	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,'DIFVALOR'	,'   '		,STR0042+CRLF+STR0044	,cPictVFim	,cTamVFim	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,'CUSTOT'		,'   '		,'CUSTO TOTAL'			,cPictVFim	,cTamVFim	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

oSection1:SetHeaderPage()
oSection1:SetTotalText(STR0049) // "T o t a l  G e r a l :"

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Marcos V. Ferreira   � Data �20/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR285			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasSB1,cAliasSB2,cAliasSB7)

Local oSection1	:= oReport:Section(1)
Local nOrdem   	:= oSection1:GetOrder()
Local cSeek    	:= ''
Local cCompara 	:= ''
Local cLocaliz 	:= ''
Local cNumSeri 	:= ''
Local cLoteCtl 	:= ''
Local cNumLote 	:= ''
Local cProduto 	:= ''
Local cLocal   	:= ''
Local cTipo     := ''
Local cGrupo    := ''
Local cWhere   	:= ''
Local cOrderBy 	:= ''
Local cFiltro  	:= ''
Local cNomArq	:= ''
Local cOrdem	:= ''
Local nSB7Cnt  	:= 0
Local nTotal   	:= 0
Local nTotalC  	:= 0

Local nX       	:= 0
Local nTotRegs  := 0
Local nCm1		:= 0

Local nCellTot	:= 11
Local aSaldo   	:= {}
Local aSalQtd  	:= {}
Local aCM      	:= {}
Local aRegInv   := {}
Local lImprime  := .T.
Local lContagem	:= SuperGetMv('MV_CONTINV',.F.,.F.)
Local lVeic		:= Upper(GetMV("MV_VEICULO"))=="S"
Local oBreak
Local oBreak01

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas qdo almoxarifado do CQ                  �
//����������������������������������������������������������������
Local   cLocCQ  := GetMV("MV_CQ")
Private	lLocCQ  :=.T.

//������������������������������������������������������������Ŀ
//� Adiciona a ordem escolhida ao titulo do relatorio          �
//��������������������������������������������������������������
oReport:SetTitle(oReport:Title()+' (' + AllTrim(aOrdem[nOrdem]) + ')')

//��������������������������������������������������������������Ŀ
//� Definicao da linha de SubTotal                               |
//����������������������������������������������������������������  
oBreak01 := TRBreak():New(oSection1,oSection1:Cell("B1_COD"),STR0045,.F.)                          
TRFunction():New(oSection1:Cell('B7_QUANT'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)  
TRFunction():New(oSection1:Cell('QUANTDATA'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
TRFunction():New(oSection1:Cell('DIFQUANT'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)  
TRFunction():New(oSection1:Cell('DIFVALOR'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)  
TRFunction():New(oSection1:Cell('CUSTOT'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)  

If nOrdem == 2 .Or. nOrdem == 3 .Or. nOrdem == 5
	If nOrdem == 2
		//-- SubtTotal por Tipo
		oBreak := TRBreak():New(oSection1,oSection1:Cell("B1_TIPO"),STR0046,.F.) //"SubTotal do Tipo : "
	ElseIf nOrdem == 3
		//-- SubtTotal por Grupo
		oBreak := TRBreak():New(oSection1,oSection1:Cell("B1_GRUPO"),STR0047,.F.) //"SubTotal do Grupo : "
	ElseIf nOrdem == 5
		//-- SubtTotal por Armazem
		oBreak := TRBreak():New(oSection1,oSection1:Cell("B2_LOCAL"),STR0048,.F.) //"SubTotal do Armazem : "
	EndIf
	TRFunction():New(oSection1:Cell('B7_QUANT'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell('QUANTDATA'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell('DIFQUANT'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell('DIFVALOR'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell('CUSTOT'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)

EndIf

//��������������������������������������������������������������Ŀ
//� Definicao do Total Geral do Relatorio                        �
//����������������������������������������������������������������
TRFunction():New(oSection1:Cell('B7_QUANT'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection1:Cell('QUANTDATA'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection1:Cell('DIFQUANT'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection1:Cell('DIFVALOR'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection1:Cell('CUSTOT'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)

//��������������������������������������������������������������Ŀ
//� Desliga as colunas que nao serao utilizadas no relatorio     �
//����������������������������������������������������������������
If !lVeic
	oSection1:Cell('B1_CODITE'	):Disable()
Else
	oSection1:Cell('B1_COD'		):Disable()
EndIf	

If !(mv_par12 == 1)
	oSection1:Cell('B7_LOTECTL'	):Disable()
//	oSection1:Cell('B7_NUMLOTE'	):Disable()
	nCellTot-= 2
EndIf

If !(mv_par14 == 1)
	oSection1:Cell('B7_LOCALIZ'	):Disable()
	//oSection1:Cell('B7_NUMSERI'	):Disable()
	nCellTot-= 2
EndIf

dbSelectArea('SB2')
dbSetOrder(1)

dbSelectArea('SB7')
dbSetOrder(1)

dbSelectArea('SB1')
dbSetOrder(1)

nTotRegs += SB2->(LastRec())
nTotRegs += SB7->(LastRec())

//��������������������������������������������������������������Ŀ
//� ORDER BY - Adicional                                         �
//����������������������������������������������������������������
cOrderBy := "%"
If nOrdem == 1 //-- Por Codigo
	If lVeic
		cOrderBy += " B1_FILIAL, B1_CODITE "
	Else
		cOrderBy += " B1_FILIAL, B1_COD , B7_LOTECTL, B7_NUMLOTE, B7_LOCALIZ "
	EndIf	
ElseIf nOrdem == 2 //-- Por Tipo
	cOrderBy += " B1_FILIAL, B1_TIPO, B1_COD " 
ElseIf nOrdem == 3 //-- Por Grupo
	If lVeic
		cOrderBy += " B1_FILIAL, B1_GRUPO, B1_CODITE "
	Else
		cOrderBy += " B1_FILIAL, B1_GRUPO, B1_COD "
	EndIf	
	cOrderBy += ", B2_LOCAL" 
ElseIf nOrdem == 4 //-- Por Descricao
	cOrderBy += "B1_FILIAL, B1_DESC, B1_COD"
ElseIf nOrdem == 5 //-- Por Local
	If lVeic
		cOrderBy += " B1_FILIAL, B2_LOCAL, B1_CODITE"
	Else
		cOrderBy += " B1_FILIAL, B2_LOCAL, B1_COD"
	EndIf	
EndIf
cOrderBy += "%"

//��������������������������������������������������������������Ŀ
//� WHERE - Adicional                                            �
//����������������������������������������������������������������
cWhere := "%"
If lVeic
	cWhere+= "SB1.B1_CODITE	>= '"+mv_par01+"' AND SB1.B1_CODITE <= '"+mv_par02+	"' AND "
Else
	cWhere+= "SB1.B1_COD	>= '"+mv_par01+"' AND SB1.B1_COD	<= '"+mv_par02+	"' AND "
EndIf
    If lContagem
      cWhere+= " SB7.B7_ESCOLHA = 'S' AND "
    EndIf  
cWhere += "%"

//������������������������������������������������������������������������Ŀ
//�Inicio da Query do relatorio                                            �
//��������������������������������������������������������������������������
oSection1:BeginQuery()	

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Inicio do Embedded SQL                                                  �
//��������������������������������������������������������������������������
BeginSql Alias cAliasSB1

	SELECT 	SB1.R_E_C_N_O_ SB1REC , SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_LOCPAD, SB1.B1_TIPO, 
	        SB1.B1_GRUPO, SB1.B1_DESC, SB1.B1_UM, SB1.B1_CODITE, SB2.R_E_C_N_O_ SB2REC,
    	    SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL, SB2.B2_DINVENT, SB2.B2_CM1, SB7.R_E_C_N_O_ SB7REC,
        	SB7.B7_FILIAL, SB7.B7_COD, SB7.B7_LOCAL, SB7.B7_DATA,SB7.B7_LOCALIZ,
	        SB7.B7_NUMSERI, SB7.B7_LOTECTL, SB7.B7_NUMLOTE, SB7.B7_DOC, SB7.B7_QUANT,
	        SB7.B7_ESCOLHA, SB7.B7_CONTAGE

	FROM %table:SB1% SB1,%table:SB2% SB2,%table:SB7% SB7

    	WHERE SB1.B1_FILIAL =  %xFilial:SB1%	
    	AND SB1.B1_TIPO  >= %Exp:mv_par05%	AND SB1.B1_TIPO   <= %Exp:mv_par06%	
    	AND SB1.B1_GRUPO >= %Exp:mv_par09%	AND SB1.B1_GRUPO  <= %Exp:mv_par10%	
    	AND SB1.%NotDel%					AND
 			  %Exp:cWhere%
		  SB2.B2_FILIAL =  %xFilial:SB2%	AND SB2.B2_COD   =  SB1.B1_COD		AND
		  SB2.B2_LOCAL  =  SB7.B7_LOCAL		AND SB2.%NotDel%					AND
		  SB7.B7_FILIAL =  %xFilial:SB7%	AND SB7.B7_COD   =  SB1.B1_COD		AND
		  SB7.B7_LOCAL  >= %Exp:mv_par07%	AND SB7.B7_LOCAL <= %Exp:mv_par08% 	AND
		  SB7.B7_DATA   >=  %Exp:Dtos(mv_par03)% AND SB7.B7_DATA   <=  %Exp:Dtos(mv_par04)% AND SB7.%NotDel%

	ORDER BY %Exp:cOrderBy%

EndSql

oSection1:EndQuery()

//��������������������������������������������������������Ŀ
//� Abertura do Arquivo de Trabalho                        �
//����������������������������������������������������������
dbSelectArea(cAliasSB1)
oReport:SetMeter(nTotRegs)

//��������������������������������������������������������Ŀ
//� Processamento do Relatorio                             �
//����������������������������������������������������������
oSection1:Init(.F.)
While !oReport:Cancel() .And. !Eof()

	oReport:IncMeter()

	nTotal   := 0
	nTotalC   := 0

	nSB7Cnt  := 0
	lImprime := .T.
	aRegInv  := {}
	//cSeek    := xFilial('SB7')+DTOS(mv_par03)+(cAliasSB7)->B7_COD+(cAliasSB7)->B7_LOCAL+(cAliasSB7)->B7_LOCALIZ+(cAliasSB7)->B7_NUMSERI+(cAliasSB7)->B7_LOTECTL+(cAliasSB7)->B7_NUMLOTE
	//cCompara := "B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE"
	cSeek    := xFilial('SB7')+(cAliasSB7)->B7_COD+(cAliasSB7)->B7_LOCAL+(cAliasSB7)->B7_LOCALIZ+(cAliasSB7)->B7_NUMSERI+(cAliasSB7)->B7_LOTECTL+(cAliasSB7)->B7_NUMLOTE
	cCompara := "B7_FILIAL+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE"
	cProduto := (cAliasSB2)->B2_COD
	cLocal   := (cAliasSB2)->B2_LOCAL
	cLocaliz := (cAliasSB7)->B7_LOCALIZ
	cNumSeri := (cAliasSB7)->B7_NUMSERI
	cLoteCtl := (cAliasSB7)->B7_LOTECTL
	cNumLote := (cAliasSB7)->B7_NUMLOTE
	cTipo    :=	(cAliasSB1)->B1_TIPO
	cGrupo   :=	(cAliasSB1)->B1_GRUPO
    nCm1	 :=	(cAliasSB2)->B2_CM1
    
	While !oReport:Cancel() .And. !(cAliasSB7)->(Eof())  .And. cSeek == (cAliasSB7)->&(cCompara)
					
		oReport:IncMeter()

		nSB7Cnt++

		aAdd(aRegInv,{	cProduto					,; // B2_COD
						(cAliasSB1)->B1_DESC		,; // B1_DESC
						(cAliasSB7)->B7_LOTECTL		,; // B7_LOTECTL
						(cAliasSB7)->B7_NUMLOTE		,; // B7_NUMLOTE
						(cAliasSB7)->B7_LOCALIZ		,; // B7_LOCALIZ
						(cAliasSB7)->B7_NUMSERI		,; // B7_NUMSERI
						(cAliasSB1)->B1_TIPO		,; // B1_TIPO
						(cAliasSB1)->B1_GRUPO		,; // B1_GRUPO
						(cAliasSB1)->B1_UM 			,; // B1_UM
						(cAliasSB2)->B2_LOCAL		,; // B2_LOCAL
						(cAliasSB7)->B7_DOC			,; // B7_DOC
						(cAliasSB7)->B7_QUANT 		,; // B7_QUANT
						(cAliasSB2)->B2_CM1 		}) // B7_QUANT
		
		nTotal += (cAliasSB7)->B7_QUANT
		nTotalC += (cAliasSB7)->B7_QUANT*(cAliasSB2)->B2_CM1

		dbSelectArea(cAliasSB7)
		dbSkip()

	EndDo
	
   		If nSB7Cnt > 0

		//������������������������������������������������������������������������Ŀ
		//�Verifica a Quantidade Disponivel/Custo Medio                            �
		//��������������������������������������������������������������������������
		If (Localiza(cProduto) .And. !Empty(cLocaliz+cNumSeri)) .Or. (Rastro(cProduto) .And. !Empty(cLotectl+cNumLote))
			aSalQtd   := CalcEstL(cProduto,cLocal,mv_par03+1,cLoteCtl,cNumLote,cLocaliz,cNumSeri)
			aSaldo    := CalcEst(cProduto,cLocal,mv_par03+1)
			aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
			aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
			aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
			aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
			aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
			aSaldo[7] := aSalQtd[7]
			aSaldo[1] := aSalQtd[1]
		Else
			If cLocCQ == cLocal
				aSalQtd	  := A340QtdCQ(cProduto,cLocal,mv_par03+1,"")
				aSaldo	  := CalcEst(cProduto,cLocal,mv_par03+1)
				aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
				aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
				aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
				aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
				aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
				aSaldo[7] := aSalQtd[7]
				aSaldo[1] := aSalQtd[1]
			Else
				aSaldo := CalcEst(cProduto,cLocal,mv_par03+1)
			EndIf
		EndIf
		If mv_par12 == 1
			aCM:={}
			If QtdComp(aSaldo[1]) > QtdComp(0)
				For nX:=2 to Len(aSaldo)
					aAdd(aCM,aSaldo[nX]/aSaldo[1])
				Next nX
          	Else
				aCM := PegaCmAtu(cProduto,cLocal)
          	EndIf
		Else
           	aCM := PegaCMFim(cProduto,cLocal)
		EndIf

		//������������������������������������������������������������������Ŀ
		//� lImprime - Variavel utilizada para verificar se o usuario deseja |
		//| Listar Produto: 1-Com Diferencas / 2-Sem Diferencas / 3-Todos    |                              |
		//��������������������������������������������������������������������
		If nTotal-aSaldo[1] == 0
			If mv_par15 == 1
				lImprime := .F.
				nCellTot-= 1
			EndIf	
		Else 
		    If mv_par15 == 2
			   lImprime := .F.
   					nCellTot-= 1
			EndIf 
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Impressao do Inventario                                      �
		//����������������������������������������������������������������
		If lImprime .Or. mv_par15 == 3
					
			For nX:=1 to Len(aRegInv)

				If nX == 1
					oSection1:Cell('B1_CODITE'	):Show()
					oSection1:Cell('B1_COD'	 	):Show()
					oSection1:Cell('B1_TIPO'	):Show()
					oSection1:Cell('B1_DESC'	):Show()
					oSection1:Cell('B1_GRUPO'	):Show()
					oSection1:Cell('B1_UM'		):Show()
					oSection1:Cell('B2_LOCAL'	):Show()
					oSection1:Cell('B7_LOTECTL'	):Show()
					//oSection1:Cell('B7_NUMLOTE'	):Show()
					oSection1:Cell('B7_LOCALIZ'	):Show()
					//oSection1:Cell('B7_NUMSERI'	):Show()
					oSection1:Cell('QUANTDATA'	):Hide()
					oSection1:Cell('DIFQUANT'	):Hide()
					oSection1:Cell('DIFVALOR'	):Hide()
					oSection1:Cell('CUSTOT'		):Hide()

					oSection1:Cell('QUANTDATA'	):SetValue(aSaldo[1])
					oSection1:Cell('DIFQUANT'	):SetValue(nTotal-aSaldo[1])
					oSection1:Cell('DIFVALOR'	):SetValue((nTotal-aSaldo[1])*aCM[mv_par12])
					oSection1:Cell('B2_CM1'		):Show()
					oSection1:Cell('CUSTOT'		):SetValue(nTotalC)

				Else	
					oSection1:Cell('B1_CODITE'	):Hide()
					oSection1:Cell('B1_COD'		):Hide()
					oSection1:Cell('B1_TIPO'  	):Hide()
					oSection1:Cell('B1_DESC'  	):Hide()
					oSection1:Cell('B1_GRUPO' 	):Hide()
					oSection1:Cell('B1_UM'    	):Hide()
					oSection1:Cell('B2_LOCAL' 	):Hide()
					oSection1:Cell('B7_LOTECTL'	):Hide()
					//oSection1:Cell('B7_NUMLOTE'	):Hide()
					oSection1:Cell('B7_LOCALIZ'	):Hide()
					//oSection1:Cell('B7_NUMSERI'	):Hide()
					oSection1:Cell('QUANTDATA'	):SetValue(0)
					oSection1:Cell('DIFQUANT'	):SetValue(0)
					oSection1:Cell('DIFVALOR'	):SetValue(0)
					oSection1:Cell('CUSTOT'		):SetValue(0)
					
				EndIf 

				If Len(aRegInv) == 1
					oSection1:Cell('QUANTDATA'	):Show()
					oSection1:Cell('DIFQUANT'	):Show()
					oSection1:Cell('DIFVALOR'	):Show()
					oSection1:Cell('CUSTOT'		):Show()
										
				EndIf 
											
				oSection1:Cell('B1_CODITE'	):SetValue(aRegInv[nX,01])
				oSection1:Cell('B1_COD'		):SetValue(aRegInv[nX,01])
				oSection1:Cell('B1_DESC'	):SetValue(aRegInv[nX,02])
				oSection1:Cell('B7_LOTECTL'	):SetValue(aRegInv[nX,03])
				//oSection1:Cell('B7_NUMLOTE'	):SetValue(aRegInv[nX,04])
				oSection1:Cell('B7_LOCALIZ'	):SetValue(aRegInv[nX,05])
				//oSection1:Cell('B7_NUMSERI'	):SetValue(aRegInv[nX,06])
				oSection1:Cell('B1_TIPO'	):SetValue(aRegInv[nX,07])
				oSection1:Cell('B1_GRUPO'	):SetValue(aRegInv[nX,08])
				oSection1:Cell('B1_UM'		):SetValue(aRegInv[nX,09])
				oSection1:Cell('B2_LOCAL'	):SetValue(aRegInv[nX,10])
				oSection1:Cell('B7_DOC'		):SetValue(aRegInv[nX,11])
				oSection1:Cell('B7_QUANT'	):SetValue(aRegInv[nX,12])
				oSection1:Cell('B2_CM1'		):SetValue(aRegInv[nX,13])

				oSection1:PrintLine()
				
			Next nX
		
         EndIf
	Else
		dbSelectArea(cAliasSB2)
		dbSkip()
		Loop
	EndIf

EndDo

oSection1:Finish()


Return


