#INCLUDE "MATA271.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA271  � Autor � Marcelo Pimentel      � Data � 19.01.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Monta o arquivo de Bloqueio de movimentacao de produtos que ���
���          �serao inventariados.                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �SigaEst                                                     ���
�������������������������������������������������������������������������Ĵ��
���			ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.		      ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data	� BOPS �  Motivo da Alteracao 				      ���
�������������������������������������������������������������������������Ĵ��
���Patricia Sal�19/07/00�XXXXXX�Revisao do Programa                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function MGFEST45(lBlind)
Local lBlqInvA := SuperGetMV("MV_BLQINVA",.F.,.F.)
Default lBlind := .F.

//��������������������������������������������������������������Ŀ
//� Carrega as perguntas selecionadas                            �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Parametros utilizados:                                       �
//� mv_par01    Quanto ao Invent�rio:(Bloqueia) (Desbloqueia)    �
//� mv_par02    Almoxarifado De                                  �
//� mv_par03    Almoxarifado Ate                                 �
//� mv_par04    Produto De                                       �
//� mv_par05    Produto Ate                                      �
//� mv_par06    Tipo De                                          �
//� mv_par07    Tipo Ate                                         �
//� mv_par08    Grupo De                                         �
//� mv_par09    Grupo Ate                                        �
//� mv_par10    Mascara                                          �
//� mv_par11    Data  De                                         �
//� mv_par12    Data  Ate                                        �
//� mv_par13    Quanto a data:(Informada) (Calculada)            �
//� mv_par14    Data Informada                                   �
//����������������������������������������������������������������
If !lBlind .And. Pergunte("MTA271",.T.)
	//����������������������������������������������������������Ŀ
	//� Chamada da funcao para processamento em tela.            �
	//������������������������������������������������������������
	A271Proces(.F.)
ElseIf lBlind .And. (lBlqInvA) .And. dDataBase > SuperGetMV("MV_DATAINV",.F.,SToD("19800101"))
	//����������������������������������������������������������Ŀ
	//� Chamada da funcao para processamento em job.             �
	//������������������������������������������������������������
	A271Blind()
EndIf

Return NIL

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A271Proces � Autor � Marcelo Pimentel      � Data � 02/06/93 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Monta o arquivo de trabalho                                 ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � MATA271                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function A271Proces(lBlind)
LOCAL nIndex	 := 0
LOCAL nX 		  := 0
LOCAL nOpca 	  := 0
LOCAL nForFilial  := 0
LOCAL nDias       := 1
LOCAL cArqTrab    := ""
LOCAL cIndex1     := ""
LOCAL cKey		  := ""
LOCAL oMark		  := NIL
LOCAL oDlg		  := NIL
LOCAL aStru		  := {}
LOCAL aObjects    := {}
LOCAL aPosObj 	  := {}
LOCAL aSize       := {}
LOCAL aInfo       := {}
LOCAL aFilsCalc   := {}
LOCAL lMt271Fil   := ExistBlock("MT271FIL")
LOCAL cFilBack	  := cFilAnt
LOCAL lMantem     := .F.
LOCAL lRetPE      := .T.
LOCAL lViewFilial := .F.
LOCAL lModoComp   := FWModeAccess("SB1",3)=="C"  // Referente ao X2_MODO

If lBlind .And. FindFunction("A271FillX1")
	A271FillX1()
EndIf

//��������������������������������������������������������������Ŀ
//� Selecao de Multiplas Filiais                                 �
//����������������������������������������������������������������
If mv_par15==1
	If lModoComp
		aFilsCalc   := MatFilCalc(mv_par15==1)
		lViewFilial := .T.
	Else 
		//'MATR935MODO' ; 'Para utiliza��o de Sele��o de Filiais a Tabela de Produtos (SB1) deve estar no modo compartilhado por filial. Para este processo ser� considera somente a filial corrente [' ; ']!'
		Help(nil,1," ",nil,""+cFilAnt+"' ]",3,0)
		aFilsCalc := MatFilCalc(.F.)
	Endif
Else
	aFilsCalc := MatFilCalc(mv_par15==1)
EndIf

//��������������������������������������������������������������Ŀ
//� Cria Arquivo de Trabalho                                     �
//����������������������������������������������������������������
If lViewFilial
	Aadd( aStru,{ "TB_OK"   	, "C",01,0} )
	Aadd( aStru,{ "TB_FILIAL"	, "C",TamSX3("B1_FILIAL")[1],0} )
	Aadd( aStru,{ "TB_PRODUTO"	, "C",TamSX3("B1_COD")[1],0} )
	Aadd( aStru,{ "TB_DESCR"   	, "C",30,0} )
	Aadd( aStru,{ "TB_TIPO"		, "C",02,0} )
	Aadd( aStru,{ "TB_ALMOX"	, "C",TamSX3("B2_LOCAL")[1],0} )
	Aadd( aStru,{ "TB_DIAS" 	, "N",03,0} )
Else
	Aadd( aStru,{ "TB_OK"   	, "C",01,0} )
	Aadd( aStru,{ "TB_PRODUTO"	, "C",TamSX3("B1_COD")[1],0} )
	Aadd( aStru,{ "TB_DESCR"   	, "C",30,0} )
	Aadd( aStru,{ "TB_TIPO"		, "C",02,0} )
	Aadd( aStru,{ "TB_ALMOX"	, "C",TamSX3("B2_LOCAL")[1],0} )
	Aadd( aStru,{ "TB_DIAS" 	, "N",03,0} )
EndIf	
cArqTrab := CriaTrab(aStru)
USE &cArqTrab ALIAS TRB NEW EXCL

//��������������������������������������������������������������Ŀ
//� Redefinicao do aCampos para utilizar no MarkBrow             �
//����������������������������������������������������������������
If lViewFilial
	aCampos := {{"TB_OK"	 ,""," "},;						//"Ok"
				{"TB_FILIAL","" ,OemToAnsi("Filial")},;		//"Filial"
				{"TB_PRODUTO","",OemToAnsi("Produto")},;		//"Produto"
				{"TB_DESCR"	 ,"",OemToAnsi("Descricao")},;		//"Descri�ao"
				{"TB_TIPO"	 ,"",OemToAnsi("Tipo")},;		//"Tipo"
				{"TB_ALMOX"	 ,"",OemToAnsi("Local")},;		//"Local"
				{"TB_DIAS" 	 ,"",OemToAnsi("Quantidade de Dias Bloqueados")} }     //"Quantidade de Dias Bloqueados"
Else
	aCampos := {{"TB_OK"	 ,""," "},;						//"Ok"
				{"TB_PRODUTO","",OemToAnsi("Produto")},;		//"Produto"
				{"TB_DESCR"	 ,"",OemToAnsi("Descricao")},;		//"Descri�ao"
				{"TB_TIPO"	 ,"",OemToAnsi("Tipo")},;		//"Tipo"
				{"TB_ALMOX"	 ,"",OemToAnsi("Local")},;		//"Local"
				{"TB_DIAS" 	 ,"",OemToAnsi("Quantidade de Dias Bloqueados")} }     //"Quantidade de Dias Bloqueados"
EndIf	

For nForFilial := 1 To Len( aFilsCalc )

	If aFilsCalc[nForFilial,1]

		//-- Muda Filial para processamento
		cFilAnt := aFilsCalc[nForFilial,2]

		//��������������������������������������������������������������Ŀ
		//� Cria Indice Condicional para o MARKBROWSE.                   �
		//����������������������������������������������������������������
		cIndex1 := CriaTrab( Nil,.F. )
		dbSelectArea("SB1")
		cKey:= IndexKey()
		IndRegua( "SB1",cIndex1,cKey,,a271Cond(),OemToAnsi("Selecionando Registros...") )		//"Selecionando Registros..."
		nIndex := RetIndex("SB1")
		dbSelectArea("SB1")
		#IFNDEF TOP
			dbSetIndex(cIndex1+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		dbGoTop()
		SB5->(dbSetOrder(1))
		While !Eof() .And. B1_FILIAL == xFilial("SB1")
			dbSelectArea("SB1")
			SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
			If !ValidMasc(B1_COD,MV_PAR10)
				dbSkip()
				Loop
			EndIf
			If lBlind .And. SB5->(FieldPos("B5_BLQINVA")) > 0 .And. SB5->B5_BLQINVA <> '1'
				dbSkip()
				Loop
			EndIf
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSeek(xFilial("SB2")+SB1->B1_COD)
			While !Eof() .And. B2_FILIAL+B2_COD == xFilial("SB2")+SB1->B1_COD
				If lBlind
					If SB5->(FieldPos("B5_BLQINVD")) > 0 .And. (B2_DINVENT + SB5->B5_BLQINVD) > dDataBase
						dbSkip()
						Loop
					EndIf
				Else			
					If mv_par13 == 2 .And. (mv_par01 == 1 .And. !Empty(B2_DINVFIM) .Or. mv_par01 == 2 .And. Empty(B2_DINVFIM)) .Or. ;
						mv_par13 == 1 .And. (mv_par01 == 1 .And. !Empty(B2_DTINV) .Or. mv_par01 == 2 .And. Empty(B2_DTINV))
						dbSkip()
						Loop
					EndIf
					If B2_LOCAL < mv_par02 .or. B2_LOCAL > mv_par03
						dbSkip()
						Loop
					Endif
					If !Empty(B2_DINVENT)
						If (B2_DINVENT + SB1->B1_PERINV) < mv_par11 .Or. B2_DINVFIM > mv_par12
							dbSkip()
							Loop
						Endif
					EndIf
					If lMt271Fil
				        lRetPe := ExecBlock("MT271FIL",.F.,.F.,{mv_par01})
				        If ValType(lRetPe)=="L" .And. lRetPe==.F.
							dbSelectArea("SB2")
							dbSkip()
							Loop
				        EndIf
					EndIf
				EndIf
				If B2_STATUS $ "2"
					dbSkip()
					Loop
				EndIf
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				If lViewFilial
					Replace 	TB_FILIAL  With cFilAnt,;
								TB_PRODUTO With SB1->B1_COD,;
								TB_TIPO    With SB1->B1_TIPO,;
								TB_ALMOX   With SB2->B2_LOCAL,;
								TB_DESCR   With SB1->B1_DESC
				Else
					Replace 	TB_PRODUTO With SB1->B1_COD,;
								TB_TIPO    With SB1->B1_TIPO,;
								TB_ALMOX   With SB2->B2_LOCAL,;
								TB_DESCR   With SB1->B1_DESC
				EndIf				
				If mv_par01 == 2
					If SB5->(FieldPos("B5_BLQINVD")) > 0 .And. SB5->B5_BLQINVD > 0
						nX := SB5->B5_BLQINVD
					ElseIf !Empty(SB2->B2_DINVFIM) .And. !Empty(SB2->B2_DTINV) .And. SB2->B2_DINVFIM <> SB2->B2_DTINV
						nX := (SB2->B2_DINVFIM-SB2->B2_DTINV) +1
					Else
						nX := 1
					EndIf
					Replace TB_DIAS With nX
				EndIf
				If lBlind
					Replace TB_OK With "x"
				EndIf
				MsUnLock()
				dbSelectArea("SB2")
				dbSkip()
			EndDo
			dbSelectArea("SB1")
			dbSkip()
		EndDo                             
	EndIf	
Next nForFilial

dbSelectArea("TRB")
dbGoTop()
If Bof() .and. EOF()
	If !lBlind
		HELP(" ",1,"RECNO")
		dbSelectArea("TRB")
		dbCloseArea()
		FErase(cArqTrab+GetDBExtension())
	EndIf
	Return
ElseIf !lBlind
	aSize := MsAdvSize()
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	AADD(aObjects,{100,100,.T.,.T.,.F.})
	AADD(aObjects,{100,020,.T.,.F.,.F.})
	aPosObj := MsObjSize(aInfo,aObjects)
	While .T.
		DEFINE MSDIALOG oDlg TITLE If(mv_par01 == 1,"Bloqueio","Desbloqueio") OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5] //"Bloqueio"###"Desbloqueio"
		cAlias := Alias()
		oMark := MsSelect():New(cAlias,"TB_OK",,aCampos,,"x",{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]})
		oMark:bMark := {|| A271Marca(nDias,lMantem)}
		oMark:oBrowse:lHasMark := .T.
		oMark:oBrowse:bAllMark := {| | A271MarkAll(oDlg,nDias,lMantem)}
		@aPosObj[2,1]+5,aPosObj[2,2]+5 BUTTON OemToAnsi("Pesquisa") ACTION IIF(A271Pesqui(),oMark:oBrowse:Refresh(),Nil) SIZE 34,11 OF oDlg FONT oDlg:oFont PIXEL	//"Pesquisa"
		If mv_par01 == 1
			DEFINE SBUTTON FROM aPosObj[2,1]+4,aPosObj[2,4]-100 TYPE 11 ENABLE OF oDlg ACTION (a271Dias(@nDias,@lMantem),oMark:oBrowse:Refresh())
		EndIf	
		DEFINE SBUTTON FROM aPosObj[2,1]+4,aPosObj[2,4]-65  TYPE  1 ENABLE OF oDlg ACTION (If(a271OK(),nOpca:=1,nOpca:=0),oDlg:End())
		DEFINE SBUTTON FROM aPosObj[2,1]+4,aPosObj[2,4]-30  TYPE  2 ENABLE OF oDlg ACTION (oDlg:End())
		ACTIVATE MSDIALOG oDlg CENTERED
		If nOpca == 1
			a271Grava(Nil,lViewFilial)
		Endif
		Exit
	EndDo
Else 
	A271Grava(lBlind,lViewFilial)
EndIf

//��������������������������������������������������������������Ŀ
//� Restaura para filial de origem.                              �
//����������������������������������������������������������������
If lViewFilial
	cFilAnt := cFilBack
EndIf

//��������������������������������������������������������������Ŀ
//� Deleta Arquivo Temporario e Restaura os Indices Nativos.     �
//����������������������������������������������������������������
dbSelectArea("SB1")
dbClearFilter()
dbSetOrder(1)

dbSelectArea("SB2")
dbClearFilter()
RetIndex("SB2")
dbSetOrder(1)

dbSelectArea("TRB")
dbCloseArea()

FErase(cArqTrab+GetDBExtension())

u_MGFEST45()

Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A271Dias � Autor � Larson Zordan         � Data � 07.05.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Ajusta o numero de Dias de Bloqueio para Inventariar       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Mata271                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A271Dias(nDias,lMantem)
Local oDlg,oChk
Local nQtde    := nDias
Local aAreaAnt := GetArea()
Local aAreaSB2 := SB2->(GetArea())
Local nRecno   := 0

Define MSDialog oDlg Title "INVENTARIO" OF oMainWnd Pixel From 0,0 TO 110,200

@ 05,10 Say "QTDE."	Size 50,20 Pixel Of oDlg
@ 07,62 Get nQtde Picture "999"       		Size 20,09 Pixel Of oDlg Valid( nQtde >= 1 )

@ 25,10 CheckBox oChk Var lMantem PROMPT "" Size 93,29 Of oDlg Pixel 

Define SButton From 40,35 Type 1 Enable Of oDlg Action (nDias:=nQtde,oDlg:End())
Define SButton From 40,68 Type 2 Enable Of oDlg Action (oDlg:End())

Activate MSDialog oDlg Centered

RecLock("TRB",.F.)
Replace	TRB->TB_DIAS With nDias
MsUnlock()

nRecno := TRB->(Recno())

If !lMantem
	dbSelectArea("TRB")
	dbgoTop()
	While !Eof()
		If Recno() <> nRecno
			//-- Posiciona SB2
			SB2->(dbSetOrder(1))
			SB2->(dbSeek(xFilial("SB2")+TRB->TB_PRODUTO+TRB->TB_ALMOX))
			//-- Ajusta TRB
			RecLock("TRB",.F.)
			Replace TB_Ok With " "
			If mv_par01 == 1
				Replace TB_DIAS With 0
			EndIf
			MsUnLock()
		EndIf
		dbSelectArea("TRB")
		dbSkip()
	EndDo
EndIf

RestArea(aAreaSB2)
RestArea(aAreaAnt)
Return Nil

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A271Pesqui� Autor � Marcelo Pimentel      � Data � 19.01.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pesquisas pelos index's abertos                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MATA271                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A271Pesqui()

Local cAlias,cCampo,cIndex,cKey,cOrd
Local nReg,nI,nOpca:=0
Local oDlg,oCbx,lRet := .T.
Local aOrd := { }

dbSelectArea("TRB")
//����������������������������������������������������������������������Ŀ
//�Salva a Integridade dos Dados                                         �
//������������������������������������������������������������������������
cAlias  := ALIAS()

AADD(aOrd," "+"Codigo")

//��������������������������������������������������������Ŀ
//� Processa Choices dos Campos do Banco de Dados          �
//����������������������������������������������������������
cOrd := aOrd[1]
cCampo:=SPACE(40)
For ni:=1 to Len(aOrd)
	aOrd[nI] := OemToAnsi(aOrd[nI])
Next
If IndexOrd() >= Len(aOrd)
	cOrd := aOrd[Len(aOrd)]
ElseIf IndexOrd() <= 1
	cOrd := aOrd[1]
Else
	cOrd := aOrd[IndexOrd()]
Endif
DEFINE MSDIALOG oDlg FROM 5, 5 TO 14, 50 TITLE OemToAnsi("Pesquisa")

@ 0.6,1.3 COMBOBOX oCBX VAR cOrd ITEMS aOrd  SIZE 165,44 OF oDlg FONT oDlg:oFont
@ 2.1,1.3 MSGET cCampo SIZE 165,10
DEFINE SBUTTON FROM 055,122   TYPE 1 ACTION (nOpca := 1,A271OK(),oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 055,149.1 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 0
	lRet := .F.
Endif

nReg := RecNo()

If lRet
	cIndex1:=CriaTrab(nil,.f.)
	dbSelectArea("TRB")
	cKey   := "TB_PRODUTO"
	IndRegua("TRB",cIndex1,cKey,,,OemToAnsi("Selecionando Registros..."))
	dbSetOrder(1)
	dbGotop()
	lRet := IIf(dbSeek(Trim(cCampo),.T.),.T.,.F.)
	If  !lRet
		Go nReg
		Help(" ",1,"PESQ01")
	EndIf
Endif

Return lRet

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A271Cond � Autor � Marcelo Pimentel      � Data � 19/01/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna condicao para indexacao condicional                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MATA271                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function A271Cond()
Local cCond:=NIL
cCond := 'B1_FILIAL== "'+xFilial("SB1")+'"'
cCond += '.And.B1_COD  >= "'+mv_par04 +'".And. B1_COD  <= "'+mv_par05+'"'
cCond += '.And.B1_TIPO >= "'+mv_par06 +'".And. B1_TIPO <= "'+mv_par07+'"'
cCond += '.And.B1_GRUPO>= "'+mv_par08 +'".And. B1_GRUPO<= "'+mv_par09+'"'
Return cCond

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A271Marca  � Autor �Rodrigo de A.Sartorio� Data � 04/01/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Avalia Marca.                                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MATA271                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A271Marca(nDias,lMantem)
If mv_par01 == 1
	RecLock("TRB",.F.)
	Replace	TRB->TB_DIAS With If(!Empty(TRB->TB_OK),If(lMantem.And.TRB->TB_DIAS>0,TRB->TB_DIAS,nDias),0)
	MsUnlock()
Endif	
Return( Nil )

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A271MarkAll� Autor �Marcelo Pimentel     � Data � 19/01/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inverte Marcadas/Desmarcadas                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MATA271                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A271MarkAll(oDlg,nDias,lMantem)
Local nRecno:=Recno()

dbGotop()
While !Eof()
	RecLock("TRB",.F.)
	If Empty(TRB->TB_OK)
		Replace TRB->TB_OK 	 With "x" ,;
				TRB->TB_DIAS With If(mv_par01==1,nDias,TRB->TB_DIAS)
	Else
		If !lMantem //-- Nao mantem os itens marcados (.F.)
			Replace TRB->TB_OK   With " ",;
					TRB->TB_DIAS With If(mv_par01==1,0,TRB->TB_DIAS)
		EndIf			
	Endif
	MsUnlock()
	dbSkip()
EndDo
dbGoto(nRecno)
oDlg:Refresh()
Return .T.

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A271Grava� Autor � Marcelo Pimentel      � Data � 19.01.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Bloqueia / Desbloqueia itens para Inventario               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � MATA271                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A271Grava(lBlind,lViewFilial)
Local nDias		:= 0
Local cBkpFilial:= cFilAnt
Local lMt271Grv := ExistBlock("MT271GRV")

Default lBlind := .F.

dbSelectArea("TRB")
dbGoTop()
While !Eof()
	If Empty(TB_OK)
		dbSkip()
		Loop
	EndIf
	// Posiciona na Filial Selecionada
	If lViewFilial
		cFilAnt := TRB->TB_FILIAL
	EndIf
	nDias := TB_DIAS
	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial("SB2")+TRB->TB_PRODUTO+TRB->TB_ALMOX)
		RecLock("SB2",.F.)
		If mv_par01 == 1
			If mv_par13 == 1 .and. !Empty(mv_par14)
				Replace B2_DTINV With mv_par14
				Replace B2_DINVFIM With mv_par14 + nDias -1
			Else
				If lBlind
					SB5->(dbSetOrder(1))
					If SB5->(dbSeek(xFilial("SB5")+TRB->TB_PRODUTO)) .And. SB5->B5_BLQINVA == "1"
						Replace B2_DTINV With If(!Empty(B2_DINVENT),B2_DINVENT+SB5->B5_BLQINVD,dDataBase)  ,;
							    B2_DINVFIM With B2_DTINV
					EndIf
				Else
					SB1->(dbSetOrder(1))
					If SB1->(dbSeek( xFilial("SB1")+TRB->TB_PRODUTO))
						Replace B2_DTINV With If(!Empty(B2_DINVENT),B2_DINVENT,dDataBase) + SB1->B1_PERINV ,;
							    B2_DINVFIM With B2_DTINV + nDias
					EndIf
				EndIf
			Endif
		Else
			Replace B2_DTINV With Ctod("  /  /  "),;
			      B2_DINVFIM With Ctod("  /  /  ")
		EndIf
		MsUnlock()
	EndIf
	If lMt271Grv
		ExecBlock("MT271GRV",.F.,.F.)
	EndIf
	dbSelectArea("TRB")
	dbSkip()
EndDo
// Restaura a filial 
If lViewFilial
	cFilAnt := cBkpFilial
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � A271OK   � Autor � Cristina M. Ogura     � Data �28.11.95  ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Mensagem de OK antes de executar o processamento           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA271                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A271OK()
Return (MsgYesNo(OemToAnsi("Confirma Selecao?"),OemToAnsi("Atencao")))			//"Confirma Sele��o?"###"Aten��o"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A271Blind�Autor  � Andre Anjos		 � Data �  02/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Processa bloqueio as cegas                                 ���
�������������������������������������������������������������������������͹��
���Uso       � MATA271                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC Function A271Blind()
//-- Ajusta perguntas para processamento as cegas e da data corrente.
Pergunte("MTA271",.F.)

mv_par01 := 1
mv_par02 := Space(TamSX3("B2_LOCAL")[1])
mv_par03 := Replicate("Z", TamSX3("B2_LOCAL")[1])
mv_par04 := Space(TamSX3("B1_COD")[1])
mv_par05 := Replicate("Z",TamSX3("B1_COD")[1])
mv_par06 := Space(TamSX3("B1_TIPO")[1])
mv_par07 := Replicate("Z",TamSX3("B1_TIPO")[1])
mv_par08 := Space(TamSX3("B1_GRUPO")[1])
mv_par09 := Replicate("Z",TamSX3("B1_GRUPO")[1])
mv_par10 := "*"
mv_par11 := dDataBase
mv_par12 := dDataBase
mv_par13 := 2
mv_par14 := dDataBase

//-- Faz chamada ao processamento
A271Proces(.T.)

//-- Atualiza MV_DATAINV com a data de processamento
PutMV("MV_DATAINV",dDataBase)

Return
