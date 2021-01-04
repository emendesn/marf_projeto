#Include "PROTHEUS.Ch"

Static lFWCodFil := FindFunction("FWCodFil")
STATIC lUnidNeg	:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa

/*
=========================================================================================================
Programa.................: MGFFIN33
Autor:...................: Flavio Dentello
Data.....................: 14/09/2016
Descricao / Objetivo.....: Relatorio de Baixas
Doc. Origem..............: GAP - FIN_CRE022
Solicitante..............: Cliente
Uso......................: 
Obs......................: alteracao linha 797 e 1296 incluido o filtro de TipoDoc <> ES
=========================================================================================================
*/

User Function MGFFIN33()

Local oReport:= Nil   
Private cChaveInterFun := ""

/* GESTAO - inicio */
Private aSelFil	:= {}
/* GESTAO - fim */

//������������������������������������������������������������������������Ŀ
//�Atualizar o as perguntas "Codigo de" e "Codigo Ate" para nao estavam no �
//�grupo SXG do codigo de Cliente/Fornecedor s� retirar na proxima vers�o  �
//��������������������������������������������������������������������������

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	xFinR190R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Flavio Dentello        � Data �16.11.2016���
�������������������������������������������������������������������������Ĵ��
���Descricao �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relatorio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport	:= Nil
Local oSection	:= Nil
Local oCell		:= Nil        
Local nPlus		:= 0  
Local oBaixas	:= Nil
Local oCabec	:= Nil
Local oTotalx	:= Nil
Local oTotaly	:= Nil
Local cValor	:= ""
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
oReport := TReport():New("MGFFIN33","Relatorio de Baixas por Conta Corrente","XFIN190", {|oReport| ReportPrint(oReport)},"Este programa tem como objetivo , relacionar os Grupos e seus respectivos Fornecedores.") //STR0009##"STR0006+" "+STR0007+" "+STR0008


Pergunte("XFIN190",.F.)

oReport:SetLandScape()

/* GESTAO - inicio */
oReport:SetUseGC(.F.) 
oReport:SetGCVPerg( .F. )
/* GESTAO - fim */ 
oCabec  := TRSection():New(oReport,"Detalhes","Baixas")
oBaixas := TRSection():New(oReport,"Baixas",{"SE5","SED"},{"Baixas"}) 
oTotaly := TRSection():New(oReport,"Total Por Banco","Total por Banco")
oTotalx := TRSection():New(oReport,"Total Geral","Total Geral")

oCabec:SetTotalInLine(.F.)                                        
oBaixas:SetTotalInLine(.F.)
oTotaly:SetTotalInLine(.F.)
oTotalx:SetTotalInLine(.F.)                                                             

TRCell():New(oCabec,"E5_BANCO"		,, "Bco",, TamSX3("E5_BANCO")[1]+1,.f.)	//STR0066***
TRCell():New(oCabec,"E5_AGENCIA"	,, "Ag.",,10, .f.)	//"Agencia****
TRCell():New(oCabec,"E5_CONTA" 		,, "C/C",,10, .f.)	//Conta****
TRCell():New(oCabec,"A6_NOME" 		,, "Nome Banco",,20, .f.)	//Conta****


TRCell():New(oBaixas,"E5_PREFIXO"	,, "Prf",,TamSx3("E5_PREFIXO")[1], .F.)	

If "PTG/MEX" $ cPaisLoc
	TRCell():New(oBaixas,"E5_NUMERO" 	,, "Numero",,TamSx3("E5_NUMERO")[1]+18,.F.)
Else
	TRCell():New(oBaixas,"E5_NUMERO" 	,, "Numero",,TamSx3("E5_NUMERO")[1]+2,.F.)
Endif

If cPaisLoc == "BRA"
	nPlus := 5
Else
	nPlus := 3
Endif
TRCell():New(oBaixas,"E5_PARCELA"	,, "Prc",,TamSx3("E5_PARCELA")[1], .F.)	
TRCell():New(oBaixas,"E5_TIPODOC"	,, "TP" ,,TamSx3("E5_TIPODOC")[1], .F.)	
TRCell():New(oBaixas,"E5_CLIFOR"	,, "Cli/For",,TamSx3("E5_CLIFOR")[1] + 1, .F.)
TRCell():New(oBaixas,"NOME CLI/FOR"	,, "Nome Cli/For",,15, .F.)	
TRCell():New(oBaixas,"E5_NATUREZ"	,, "Natureza",,11, .F.)	
TRCell():New(oBaixas,"E5_VENCTO"	,, "Vencto",,TamSx3("E5_VENCTO")[1] + 2, .F.)	
TRCell():New(oBaixas,"E5_HISTOR"	,, "Historico",, TamSx3("E5_HISTOR")[1]/2+1, .F.,,,.T.)
TRCell():New(oBaixas,"E5_DATA"		,, "Dt Baixa",,TamSx3("E5_DATA")[1] + 2, .F.)	
TRCell():New(oBaixas,"E5_VALOR"		,, "Valor Original","@E 999,999.99", TamSX3("E5_VALOR")[1]+nPlus	,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oBaixas,"JUROSMULTA"	,, "Juros/Multa","@E 999,999.99", TamSX3("E5_VLJUROS")[1]       ,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oBaixas,"CORRECAO"		,, "Correcao","@E 999,999.99", TamSX3("E5_VLCORRE")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oBaixas,"DESCONTO"		,, "Descontos","@E 999,999.99", TamSX3("E5_VLDESCO")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oBaixas,"ABATIMENTO"	,, "Abatim.","@E 999,999.99", TamSX3("E5_VLDESCO")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oBaixas,"IMPOSTOS"		,, "Impostos","@E 999,999.99", TamSX3("E5_VALOR")[1]	,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oBaixas,"E5_VALORPG"	,, "Total Baixado","@E 999,999,999.99", TamSX3("E5_VALOR")[1]+nPlus,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oBaixas,"E5_DTDIGIT"	,, "Dt Dig.",,10, .f.)
TRCell():New(oBaixas,"E5_MOTBX"		,, "Mot",,3, .f.)
TRCell():New(oBaixas,"E5_ORIG"		,, "Orig",,FWSizeFilial()+2, .f.)
                                                     
oBaixas:SetNoFilter({"SED"})

TRFunction():New(oBaixas:Cell("JUROSMULTA"),NIL,"SUM",,,,,.T.,.T.)  
TRFunction():New(oBaixas:Cell("CORRECAO")  ,NIL,"SUM",,,,,.T.,.T.)  
TRFunction():New(oBaixas:Cell("DESCONTO")  ,NIL,"SUM",,,,,.T.,.T.)  
TRFunction():New(oBaixas:Cell("ABATIMENTO"),NIL,"SUM",,,,,.T.,.T.)  
TRFunction():New(oBaixas:Cell("IMPOSTOS")  ,NIL,"SUM",,,,,.T.,.T.)  
TRFunction():New(oBaixas:Cell("E5_VALORPG"),NIL,"SUM",,,,,.T.,.T.,)  


Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Flavio Dentello	    � Data �16.11.2016���
�������������������������������������������������������������������������Ĵ��
���Descricao �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)
Local oCabec	:= oReport:Section(1)
Local oBaixas	:= oReport:Section(2)
Local oTotaly	:= oReport:Section(3)
Local oTotalx	:= oReport:Section(4)
Local nOrdem	:= oReport:Section(1):GetOrder() 
Local cAliasSE5	:= "SE5"
Local cTitulo 	:= "" 
Local cSuf		:= LTrim(Str(mv_par13))
Local cMoeda	:= GetMv("MV_MOEDA"+cSuf)     
Local cCondicao	:= "" 
Local cCond1 	:= ""
Local cChave 	:= ""
Local bFirst
Local oBreak1, oBreak2  := Nil
Local nDecs	   	:= GetMv("MV_CENT"+(IIF(mv_par13 > 1 , STR(mv_par13,1),""))) 
Local cAnterior, cAnt     
Local aRelatx	:={}	   
Local nI  := 0           
Local lVarFil	:= (mv_par18 == 1 .and. SM0->(Reccount()) > 1	) // Cons filiais abaixo
Local nTotBaixado := 0                 
Local aTotais	:={}
Local cTotText	:=	""    
Local nGerOrig	:= 0
Local nRegSM0 := SM0->(Recno())
Local nRegSE5 := SE5->(Recno())
Local nJ		:= 1
Local lMultiNat := .F.
Local cBanco	:= ""
Local cAgencia	:= ""
Local cConta	:= ""
Local nX := 0                                                     
Local nD := 0
Local cValor := ""
Local nValor       := 0
Local nJuros 	   := 0
Local nCorrecao    := 0
Local nDesconto    := 0
Local nAbatimento  := 0
Local nImpostos	   := 0
Local nValorpg	   := 0
Local nValort      := 0
Local nJurost 	   := 0
Local nCorrecaot   := 0
Local nDescontot   := 0
Local nAbatimentot := 0
Local nImpostost   := 0
Local nValorpgt	   := 0
	
Private cNomeArq

cFilterUser := ""       
 

/* GESTAO - inicio */
If MV_PAR41 == 1
	If Empty(aSelFil)
	aSelFil := AdmGetFil(.F.,.F.,"SE5")
		If Empty(aSelFil)
		   Aadd(aSelFil,cFilAnt)
		Endif
	Endif
Else
	Aadd(aSelFil,cFilAnt)
Endif

lVarFil := Len(aSelFil) > 1

/* GESTAO - fim */

//��������������������������������Ŀ
//� Definicao dos cabecalhos       �
//����������������������������������
If mv_par12 == 1
	cTitulo := "Relacao dos Titulos Recebidos em " + cMoeda  
Else
	cTitulo := "Relacao dos Titulos Pagos em "  + cMoeda  
EndIf

/*���������������������������������Ŀ
//�aRelat[x][01]: Prefixo			�
//�         [02]: Numero 			�
//�         [03]: Parcela			�
//�         [04]: Tipo do Documento	�
//�         [05]: Cod Cliente/Fornec�
//�         [06]: Nome Cli/Fornec	�
//�         [07]: Natureza         	�
//�         [08]: Vencimento       	�
//�         [09]: Historico       	�
//�         [10]: Data de Baixa    	�
//�         [11]: Valor Original   	�
//�         [12]: Jur/Multa        	�
//�         [13]: Correcao         	�
//�         [14]: Descontos        	�
//�         [15]: Abatimento       	�
//�         [16]: Impostos         	�
//�         [17]: Total Pago       	�
//�         [18]: Banco            	�
//�         [19]: Data Digitacao   	�
//�         [20]: Motivo           	�
//�         [21]: Filial de Origem 	�
//�         [22]: Filial            �      
//�         [23]: E5_BENEF - cCliFor�
//�         [24]: E5_LOTE          	� 
//�         [25]: E5_DTDISPO        � 
//�����������������������������������*/

aRelatx := MGFFIN331(nOrdem,@aTotais,oReport,@nGerOrig,@lMultiNat)

If Len(aRelatx) = 0
	Return Nil
EndIf

Do Case
Case nOrdem == 1
	nCond1  := 10
	cTitulo += " por data de pagamento"
Case nOrdem == 2
	nCond1  := 18
	cTitulo += " por Banco" 
Case nOrdem == 3
	nCond1  := 7
	cTitulo += " por Natureza" 
Case nOrdem == 4
	nCond1  := 23 
	cTitulo += " Alfabetica" 
Case nOrdem == 5
	nCond1  := 2
	cTitulo += " Nro. dos Titulos" 
Case nOrdem == 6	
	nCond1  := 19
	cTitulo += " Por Data de Digitacao" 
Case nOrdem == 7 
	nCond1  := 24	
	cTitulo += " por Lote"  
OtherWise					
	nCond1  := 25	
	cTitulo += " por data de pagamento"  
EndCase

If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert("Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	
If !Empty(mv_par30) .And. ! ";" $ mv_par30 .And. Len(AllTrim(mv_par30)) > 3
	ApMsgAlert("Separe os tipos que nao deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	

//Validacao no array para que seus tipos nao gerem error log
//no exec block em TrPosition()
aEval(aRelatx, {|e| Iif( e[5] == Nil, e[5] := "", .T. )} )
//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento sera     �
//�realizado antes da impressao de cada linha do relatorio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de codigo para pesquisa. A string sera macroexe-�
//�        cutada.                                                         �
//�                                                                        �				
//��������������������������������������������������������������������������
TRPosition():New(oBaixas,"SED",1,{|| xFilial("SED")+SE5->E5_NATUREZ })

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������

	for nI := 1 to len(aRelatx)
		aadd(aRelatx[nI], aRelatx[nI,18]+aRelatx[nI,30]+aRelatx[nI,31])
	next

	aRelatx := ASORT(aRelatx, , , { | x,y | x[18] < y[18] } )

	
cChave   := ''

For nI := 1 To LEN(aRelatx)
cValor := ""	
	
	IF oReport:Cancel()
		Exit
	Endif
	
	IF cChave <> aRelatx[nI,18]+aRelatx[nI,30]+aRelatx[nI,31] 
	
		dbSelectArea("SA6")
		SA6->(dbSetOrder(1))
		If SA6->(dbSeek(XFILIAL("SA6")+aRelatx[nI,18]+aRelatx[nI,30]+aRelatx[nI,31]))// Filial + Pedido
		EndIf			
		IF cChave <> ''                                              
			oReport:Section(2):Finish()
		EndIF
	
		oReport:IncMeter()
		oReport:Section(1):Init()
		oCabec:Cell("E5_BANCO")	 :SetBlock( { || aRelatx[nI,18] } )
		oCabec:Cell("E5_AGENCIA"):SetBlock( { || aRelatx[nI,30] } )
		oCabec:Cell("E5_CONTA")	 :SetBlock( { || aRelatx[nI,31] } )
		oCabec:Cell("A6_NOME")	 :SetBlock( { || SA6->A6_NOME } )
		oReport:Section(1):PrintLine()
		oReport:Section(1):Finish()
		
		oBaixas:Init()
		
		cChave := aRelatx[nI,18]+aRelatx[nI,30]+aRelatx[nI,31]
			
			oBaixas:Cell("E5_PREFIXO")	:SetBlock( { || aRelatx[nI,01] } )
			oBaixas:Cell("E5_NUMERO")	:SetBlock( { || aRelatx[nI,02] } )
			oBaixas:Cell("E5_PARCELA")	:SetBlock( { || aRelatx[nI,03] } )
			oBaixas:Cell("E5_TIPODOC")	:SetBlock( { || aRelatx[nI,04] } )
			oBaixas:Cell("E5_CLIFOR")	:SetBlock( { || aRelatx[nI,05] } )
			oBaixas:Cell("NOME CLI/FOR"):SetBlock( { || aRelatx[nI,06] } )
			oBaixas:Cell("E5_NATUREZ")	:SetBlock( { || aRelatx[nI,07] } )
			oBaixas:Cell("E5_VENCTO")	:SetBlock( { || aRelatx[nI,08] } )
			oBaixas:Cell("E5_HISTOR")	:SetBlock( { || aRelatx[nI,09] } )
			oBaixas:Cell("E5_DATA")		:SetBlock( { || aRelatx[nI,10] } )
			oBaixas:Cell("E5_VALOR")	:SetBlock( { || aRelatx[nI,11] } )
			oBaixas:Cell("JUROSMULTA")	:SetBlock( { || aRelatx[nI,12] } )
			oBaixas:Cell("CORRECAO")	:SetBlock( { || aRelatx[nI,13] } )
			oBaixas:Cell("DESCONTO")	:SetBlock( { || aRelatx[nI,14] } )
			oBaixas:Cell("ABATIMENTO")	:SetBlock( { || aRelatx[nI,15] } )
			oBaixas:Cell("IMPOSTOS")	:SetBlock( { || aRelatx[nI,16] } )
			oBaixas:Cell("E5_VALORPG")	:SetBlock( { || aRelatx[nI,17] } )
			oBaixas:Cell("E5_DTDIGIT")	:SetBlock( { || aRelatx[nI,25] } )
			oBaixas:Cell("E5_MOTBX")	:SetBlock( { || aRelatx[nI,20] } )
			oBaixas:Cell("E5_ORIG")		:SetBlock( { || aRelatx[nI,21] } )

		If aRelatx[nI,11] <> NIL						
			nValor      += aRelatx[nI,11]
		EndIf
		If aRelatx[nI,12] <> NIL	
			nJuros 	    += aRelatx[nI,12]
		EndIf
		If aRelatx[nI,13] <> NIL	
			nCorrecao   += aRelatx[nI,13]
		EndIf
		If aRelatx[nI,14] <> NIL
			nDesconto   += aRelatx[nI,14]  
		EndIf
		If aRelatx[nI,15] <> NIL   	
			nAbatimento += aRelatx[nI,15]   
		EndIf
		If aRelatx[nI,16] <> NIL	
			nImpostos	+= aRelatx[nI,16]
		EndIf
		If aRelatx[nI,17] <> NIL	 
			nValorpg	+= aRelatx[nI,17] 
		EndIf	                             
			
			If aRelatx[nI,11] <> NIL
				nValort      += aRelatx[nI,11]
			EndIf
			If aRelatx[nI,12] <> NIL
				nJurost 	 += aRelatx[nI,12]
			EndIf
			If aRelatx[nI,13] <> NIL
				nCorrecaot   += aRelatx[nI,13]
			EndIf
			If aRelatx[nI,14] <> NIL  
				nDescontot   += aRelatx[nI,14]  
			EndIf
			If aRelatx[nI,15] <> NIL  
				nAbatimentot += aRelatx[nI,15]   
			EndIf
			If aRelatx[nI,16] <> NIL
				nImpostost	 += aRelatx[nI,16]
			EndIf
			If aRelatx[nI,17] <> NIL
				nValorpgt	 += aRelatx[nI,17]
			EndIf
	EndIf

			oBaixas:PrintLine() 
			
Next                                           
        If Len(aRelatx) > 0 
			oReport:Section(2):Finish()
    	EndIF
		
Return NIL



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � FINR190  � Autor � Flavio Dentello       � Data � 28.11.16 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Relacao das baixas                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FINR190(void)                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xFinR190R3()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

Local wnrel
Local aOrd:={OemToAnsi("Por Data"),OemToAnsi("Por Banco"),OemToAnsi("Por Natureza"),OemToAnsi("Alfabetica"),OemToAnsi("Nro. Titulo"),OemToAnsi("Dt.Digitacao"),OemToAnsi("Por Lote"),"Por Data de Credito"}  //STR0001##STR0002##STR0003##STR0004##STR0032##STR0005##STR0036###### //STR0048
Local cDesc1 := "Este programa ira emitir a relacao dos titulos baixados."  
Local cDesc2 := "Podera ser emitido por data, banco, natureza ou alfab�tica"
Local cDesc3 := "de cliente ou fornecedor e data da digitacao."  
Local tamanho:="G"
Local cString:="SE5"

Private titulo:=OemToAnsi("Relacao de Baixas")  
Private cabec1
Private cabec2
Private cNomeArq
Private aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }
Private nomeprog:="xFINR190"
Private aLinha  := { },nLastKey := 0
Private cPerg   :="XFIN190"


//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("XFIN190",.F.)

wnrel := "XFINR190"       
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return(Nil)
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return(Nil)
EndIf

cFilterUser := aReturn[7]

RptStatus({|lEnd| Fa190Imp(@lEnd,wnRel,cString)},Titulo)
Return(Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � FA190Imp � Autor � Wagner Xavier         � Data � 05.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Relacao das baixas                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA190Imp(lEnd,wnRel,cString)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd    - Acao do Codeblock                                ���
���          � wnRel   - Titulo do relatorio                              ���
���          � cString - Mensagem                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FA190Imp(lEnd,wnRel,cString)

Local cExp 			:= ""
Local CbTxt,CbCont
Local nValor:=0,nDesc:=0,nJuros:=0,nMulta:=0,nJurMul:=0,nCM:=0,dData,nVlMovFin:=0
Local nTotValor:=0,nTotDesc:=0,nTotJurMul:=0,nTotCm:=0,nTotOrig:=0,nTotBaixado:=0,nTotMovFin:=0,nTotComp:=0,nTotFat:=0
Local nGerValor:=0,nGerDesc:=0,nGerJurMul:=0,nGerCm:=0,nGerOrig:=0,nGerBaixado:=0,nGerMovFin:=0,nGerComp:=0,nGerFat:=0
Local nFilOrig:=0,nFilJurMul:=0,nFilCM:=0,nFilDesc:=0
Local nFilAbLiq:=0,nFilAbImp:=0,nFilValor:=0,nFilBaixado:=0,nFilMovFin:=0,nFilComp:=0, nFilFat:=0
Local nAbatLiq := 0,nTotAbImp := 0,nTotImp := 0,nTotAbLiq := 0,nGerAbLiq := 0,nGerAbImp := 0
Local cBanco,cNatureza,cAnterior,cCliFor,nCT:=0,dDigit,cLoja
Local lContinua		:=.T.
Local lBxTit		:=.F.
Local lBxLoja		:=.F.			//Verifica se o titulo foi baixado pelo loja e tem a excecao do MV_LJTROCO = .T.
Local tamanho		:="G"
Local aCampos:= {},cNomArq1:="",nVlr,cLinha,lOriginal:=.T.
Local nAbat 		:= 0
Local cHistorico
Local lManual 		:= .f.
Local cTipodoc
Local nRecSe5 		:= 0
Local dDtMovFin
Local cRecPag
Local nRecEmp 		:= SM0->(Recno())
Local cMotBaixa		:= CRIAVAR("E5_MOTBX")
Local cFilNome 		:= Space(15)
Local cCliFor190	:= ""
Local aTam 			:= IIF(mv_par12 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu 		:= {}
Local nDecs	   		:= GetMv("MV_CENT"+(IIF(mv_par13 > 1 , STR(mv_par13,1),""))) 
Local nMoedaBco		:= 1
Local cCarteira
#IFDEF TOP
	Local aStru		:= SE5->(DbStruct()), nI
	Local cQuery
#ENDIF	
Local cFilTrb
Local lAsTop		:= .F.
Local cFilSe5		:= ".T."
Local cChave, bFirst
Local cFilOrig
Local lAchou		:= .F.
Local lF190Qry		:= ExistBlock("F190QRY")
Local cQueryAdd		:= ""
Local lAjuPar15		:= Len(AllTrim(mv_par15))==Len(mv_par15)
Local lAchouEmp		:= .T.                                
Local lAchouEst		:= .F.                                
Local nTamEH		:= TamSx3("EH_NUMERO")[1]
Local nTamEI		:= TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local cCodUlt		:= SM0->M0_CODIGO
Local cFilUlt		:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local nRecno  
Local nSavOrd 
Local aAreaSE5 
Local cChaveNSE5	:= ""
Local nRecSE2		:= 0
Local aAreaSE2
Local aAreabk

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local nTaxa:= 0 
Local lUltBaixa := .F.
Local cChaveSE1 := ""
Local cChaveSE5 := ""
Local cSeqSE5 := ""
Local cBancoAnt, cAgAnt, cContaAnt
Local lNaturez := .F.

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissao(default))
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPccBxCr := 0 
//Controla o Pis Cofins e Csll na RA (1 = Controla reten��o de impostos no RA; ou 2 = Nao controla reten��o de impostos no RA(default))
Local lRaRtImp  := If (FindFunction("FRaRtImp"),FRaRtImp(),.F.)
Local lConsImp := .T.

If XFIN190()
	If MV_PAR42 == 2   
		lConsImp := .F.
	EndIf
EndIf

Private nIndexSE5	:= 0

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nOrdem 	:= aReturn[8]
cSuf	:= LTrim(Str(mv_par13))
cMoeda	:= GetMv("MV_MOEDA"+cSuf)
cCond3	:= ".T."


//��������������������������������Ŀ
//� Definicao dos cabecalhos       �
//����������������������������������
If mv_par12 == 1
	titulo := OemToAnsi("Relacao dos Titulos Recebidos em ")  + cMoeda  
	cabec1 := iif(aTam[1] > 6 , OemToAnsi("Cliente-Nome Cliente /Forn "),OemToAnsi("xx")) 
	cabec2 := iif(aTam[1] > 6 , OemToAnsi("yy"),"")  
Else
	titulo := OemToAnsi("Relacao dos Titulos Pagos em ")  + cMoeda 
	cabec1 := iif(aTam[1] > 6 , OemToAnsi("hh"),OemToAnsi("ww"))
	cabec2 := iif(aTam[1] > 6 , OemToAnsi("yy"/*STR0040*/),"") 
EndIf

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
If mv_par18 == 2
	cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Else
	cFilDe := mv_par19	
	cFilAte:= mv_par20
EndIf
// Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo
// usuario.
DbSelectArea("SE5")
Do Case
Case nOrdem == 1
	cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
	cCond2 := "E5_DATA"
	cChave := IndexKey(1)
	cChaveInterFun := cChave
	titulo += OemToAnsi(" por data de pagamento") 
	bFirst := {|| MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
Case nOrdem == 2
	cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
	cCond2 := "E5_BANCO"
	cChave := IndexKey(3)
	cChaveInterFun := cChave
	titulo += OemToAnsi(" por Banco") 
	bFirst := {||MsSeek(xFilial("SE5")+mv_par03,.T.)}
Case nOrdem == 3
	cCondicao := "E5_MULTNAT = '1' .Or. (E5_NATUREZ >= mv_par06 .and. E5_NATUREZ <= mv_par07)"
	cCond2 := "E5_NATUREZ"
	cChave := IndexKey(4)
	cChaveInterFun := cChave
	titulo += OemToAnsi(" por Natureza")
	bFirst := {||MsSeek(xFilial("SE5")+mv_par06,.T.)}
Case nOrdem == 4
	cCondicao := ".T."
	cCond2 := "E5_BENEF"
	cChave := "E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	cChaveInterFun := cChave
	titulo += OemToAnsi(" Alfabetica")  
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 5
	cCondicao := ".T."
	cCond2 := "E5_NUMERO"
	cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	titulo += OemToAnsi(" Nro. dos Titulos") 
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 6	//Ordem 6 (Digitacao)
	cCondicao := ".T."
	cCond2 := "E5_DTDIGIT"
	cChave := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	titulo += OemToAnsi(" Por Data de Digitacao")
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 7 // por Lote
	cCondicao := "E5_LOTE >= mv_par21 .and. E5_LOTE <= mv_par22"
	cCond2 := "E5_LOTE"
	cChave := IndexKey(5)
	cChaveInterFun := cChave
	titulo += OemToAnsi(" por Lote")  
	bFirst := {||MsSeek(xFilial("SE5")+mv_par21,.T.)}
OtherWise						// Data de Credito (dtdispo)
	cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
	cCond2 := "E5_DTDISPO"
	cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	cChaveInterFun := cChave
	titulo += OemToAnsi(" por data de pagamento")
	bFirst := {||MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
EndCase

If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert("Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	
If !Empty(mv_par30) .And. ! ";" $ mv_par30 .And. Len(AllTrim(mv_par30)) > 3
	ApMsgAlert("Separe os tipos que nao deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	

#IFDEF TOP
	If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
		lAsTop := .T.
		cCondicao := ".T."
		DbSelectArea("SE5")
		cQuery := ""
		aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
		// Obtem os registros a serem processados
		cQuery := "SELECT " +SubStr(cQuery,2)
		cQuery +=         ",SE5.R_E_C_N_O_ SE5RECNO "
		cQuery += "FROM " + RetSqlName("SE5")+" SE5 "
		cQuery += "WHERE E5_RECPAG = '" + IIF( mv_par12 == 1, "R","P") + "' AND "
		cQuery += "      E5_DATA    between '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND "
		cQuery += "      E5_DATA    <= '" + DTOS(dDataBase) + "' AND "

		If cPaisLoc == "ARG" .and. mv_par03 == mv_par04
			cQuery += "      (E5_BANCO = '" + mv_par03 + "' OR E5_BANCO = '" + Space(TamSX3("A6_COD")[1]) + "') AND "
		Else
			cQuery += " E5_BANCO IN ('" + MV_PAR03 + "') AND " //  between '" + mv_par03 + "' AND '" + mv_par04 + "' AND "		
			cQuery += " E5_AGENCIA IN ('" + MV_PAR04 + "') AND " // between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "		
			cQuery += " E5_CONTA IN ('" + MV_PAR05 + "') AND " //   between '" + mv_par07 + "' AND '" + mv_par08 + "' AND "		
		EndIf

		If cPaisLoc == "ARG" .and. mv_par12 == 2 // pagar
			cQuery += " (E5_DOCUMEN <> '' AND E5_TIPO <> 'CH') AND "
		Endif

		//-- Realiza filtragem pela natureza principal
		If mv_par40 == 2
			cQuery +=  " E5_NATUREZ between '" + mv_par06       + "' AND '" + mv_par07     	+ "' AND "
		Else
			cQuery +=  " (E5_NATUREZ between '" + mv_par06       + "' AND '" + mv_par07     	+ "' OR "
			cQuery +=  " EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA "
			cQuery +=            " FROM "+RetSqlName("SEV")+" SEV "
			cQuery +=           " WHERE E5_FILIAL  = EV_FILIAL  AND "
			cQuery +=                  "E5_PREFIXO = EV_PREFIXO AND "
			cQuery +=                  "E5_NUMERO  = EV_NUM     AND "
			cQuery +=                  "E5_PARCELA = EV_PARCELA AND "
			cQuery +=                  "E5_TIPO    = EV_TIPO    AND "
			cQuery +=                  "E5_CLIFOR  = EV_CLIFOR  AND "
			cQuery +=                  "E5_LOJA    = EV_LOJA    AND "
			cQuery +=                  "EV_NATUREZ between '" + mv_par06 + "' AND '" + mv_par07 + "' AND "
			cQuery +=                  "SEV.D_E_L_E_T_ = ' ')) AND "
		EndIf	
		cQuery += "      E5_CLIFOR  between '" + mv_par08       + "' AND '" + mv_par09       + "' AND "
		cQuery += "      E5_DTDIGIT between '" + DTOS(mv_par10) + "' AND '" + DTOS(mv_par11) + "' AND "
		cQuery += "      E5_LOTE    between '" + mv_par21       + "' AND '" + mv_par22       + "' AND "
		cQuery += "      E5_LOJA    between '" + mv_par23       + "' AND '" + mv_par24 	     + "' AND "
		cQuery += "      E5_PREFIXO between '" + mv_par27       + "' AND '" + mv_par28 	     + "' AND "
		cQuery += "      SE5.D_E_L_E_T_ = ' '  AND "
		cQuery += "		  E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND "
		cQuery += " 	  E5_SITUACA NOT IN ('C','E','X') AND "
		cQuery += "      ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR "
		cQuery += "      (E5_TIPODOC <> 'CD')) "                     //ES Estorno AND E5_TIPODOC <> 'ES'
//		cQuery += "		  AND E5_HISTOR NOT LIKE '%"+STR0077+"%'"
		
		If mv_par12 == 2
			cQuery += " AND E5_TIPODOC <> 'E2'"
		EndIf
		
		If !Empty(mv_par29) // Deseja imprimir apenas os tipos do parametro 28
			cQuery += " AND E5_TIPO IN "+FormatIn(mv_par29,";")
		ElseIf !Empty(Mv_par30) // Deseja excluir os tipos do parametro 29
			cQuery += " AND E5_TIPO NOT IN "+FormatIn(mv_par30,";")
		EndIf
		
		If mv_par17 == 2
			cQuery += " AND E5_TIPODOC <> '" + SPACE(LEN(E5_TIPODOC)) + "'"
			cQuery += " AND E5_NUMERO  <> '" + SPACE(LEN(E5_NUMERO)) + "'"
			cQuery += " AND E5_TIPODOC <> 'CH'"
		Endif
		
		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par18 == 2
			cQuery += " AND E5_FILIAL = '" + FwxFilial("SE5") + "'"
		Else
			If Empty( xFilial("SE5") )
				cQuery += " AND E5_FILORIG between '" + mv_par19 + "' AND '" + mv_par20 + "'"
			Else
				cQuery += " AND E5_FILIAL between '" + mv_par19 + "' AND '" + mv_par20 + "'"
			EndIf
		Endif
		
		If lF190Qry
			cQueryAdd := ExecBlock("F190QRY", .F., .F., {aReturn[7]})
			If ValType(cQueryAdd) == "C"
				cQuery += " AND (" + cQueryAdd + ")"
			EndIf
		EndIf

		cQuery += " AND"
		cQuery += " ("
		cQuery += " 	SELECT COUNT(*)"
		cQuery += " 	FROM " + retSQLName("SE5") + " SUBSE5"
		cQuery += " 	WHERE"
		cQuery += " 		 	SUBSE5.E5_TIPODOC	= 'ES'"
		cQuery += " 		AND	SUBSE5.E5_LOJA		= SE5.E5_LOJA"
		cQuery += " 		AND SUBSE5.E5_CLIFOR	= SE5.E5_CLIFOR"
		cQuery += " 		AND SUBSE5.E5_SEQ		= SE5.E5_SEQ"
		cQuery += " 		AND SUBSE5.E5_PARCELA	= SE5.E5_PARCELA"
		cQuery += " 		AND SUBSE5.E5_NUMERO	= SE5.E5_NUMERO"
		cQuery += " 		AND SUBSE5.E5_PREFIXO	= SE5.E5_PREFIXO"
		cQuery += " 		AND SUBSE5.E5_FILIAL	= SE5.E5_FILIAL"
		cQuery += " ) = 0"

		// seta a ordem de acordo com a opcao do usuario
		cQuery += " ORDER BY " + SqlOrder(cChave) 
		cQuery := ChangeQuery(cQuery)                        
		
		//memoWrite("C:\TEMP\MGFFIN33.sql", cQuery)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .F., .T.)
		For nI := 1 TO LEN(aStru)
			If aStru[nI][2] != "C"
				TCSetField("NEWSE5", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
			EndIf
		Next
		DbGoTop()
	Else
#ENDIF
		//�������������������������������������������������������������Ŀ
		//� Abre o SE5 com outro alias para ser filtrado porque a funcao�
		//� TemBxCanc() utilizara o SE5 sem filtro.							 �
		//���������������������������������������������������������������
		If Select("NEWSE5") == 0 .And. !( ChkFile("SE5",.F.,"NEWSE5") )
			Return(Nil)
		EndIf		
		lAsTop := .F.
		DbSelectArea("NEWSE5")
		cFilSE5 := 'E5_RECPAG=='+IIF(mv_par12 == 1,'"R"','"P"')+'.and.'
		cFilSE5 += 'DTOS(E5_DATA)>='+'"'+dtos(mv_par01)+'"'+'.and.DTOS(E5_DATA)<='+'"'+dtos(mv_par02)+'".and.'
		cFilSE5 += 'DTOS(E5_DATA)<='+'"'+dtos(dDataBase)+'".and.'
		If nOrdem == 3
   			cFilSE5 += '(E5_MULTNAT = "1" .Or. (E5_NATUREZ>='+'"'+mv_par06+'"'+'.and.E5_NATUREZ<='+'"'+mv_par07+'")).and.'
		Else
			cFilSE5 += '(E5_NATUREZ>='+'"'+mv_par06+'"'+'.and.E5_NATUREZ<='+'"'+mv_par07+'").and.'
		Endif		
		cFilSE5 += 'E5_CLIFOR>='+'"'+mv_par08+'"'+'.and.E5_CLIFOR<='+'"'+mv_par09+'".and.'
		cFilSE5 += 'DTOS(E5_DTDIGIT)>='+'"'+dtos(mv_par10)+'"'+'.and.DTOS(E5_DTDIGIT)<='+'"'+dtos(mv_par11)+'".and.'
		cFilSE5 += 'E5_LOTE>='+'"'+mv_par21+'"'+'.and.E5_LOTE<='+'"'+mv_par22+'".and.'
		cFilSE5 += 'E5_LOJA>='+'"'+mv_par23+'"'+'.and.E5_LOJA<='+'"'+mv_par24+'".and.'
		cFilSe5 += 'E5_PREFIXO>='+'"'+mv_par27+'"'+'.And.E5_PREFIXO<='+'"'+mv_par28+'"'
		If !Empty(mv_par29) // Deseja imprimir apenas os tipos do parametro 28
			cFilSe5 += '.And.E5_TIPO $'+'"'+ALLTRIM(mv_par29)+Space(1)+'"'
		ElseIf !Empty(Mv_par30) // Deseja excluir os tipos do parametro 29
			cFilSe5 += '.And.!(E5_TIPO $'+'"'+ALLTRIM(mv_par30)+Space(1)+'")'
		EndIf

		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par18 == 2
			cFilSe5 +=  " .AND. E5_FILIAL = '" + xFilial("SE5") + "'"
		Else
			If Empty( xFilial("SE5") )
				cFilSe5 += " .AND. E5_FILORIG >= '" + mv_par19 + "' .AND. E5_FILORIG <= '" + mv_par20 + "'"
			Else
				cFilSe5 +=" .AND. E5_FILIAL >= '" + mv_par19 + "' .AND. E5_FILIAL <= '" + mv_par20 + "'"
			EndIf
		Endif
#IFDEF TOP
	Endif
#ENDIF	
// Se nao for TOP, ou se for TOP e for AS400, cria Filtro com IndRegua
// Pois em SQL os registros ja estao filtrados em uma Query
If !lAsTop
	cNomeArq := CriaTrab(Nil,.F.)
	IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi("Selecionando Registros..."))  
Endif

//������������������������������������������Ŀ
//� Define array para arquivo de trabalho    �
//��������������������������������������������
AADD(aCampos,{"LINHA","C",80,0 } )

//����������������������������Ŀ
//� Cria arquivo de Trabalho   �
//������������������������������
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi("Selecionando Registros..."))  //STR0018

aColu := Iif(aTam[1] > 6,{023,027,TamParcela("E1_PARCELA",40,39,38),042,000,022},{000,004,TamParcela("E1_PARCELA",17,16,15),019,023,030})

If MV_PAR17 == 1

	dbSelectArea("SE5")
	dbSetOrder(17) //"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_TIPODOC+E5_SEQ"
	dbGoTop()

Endif

DbSelectArea("SM0")
DbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilNome:= SM0->M0_FILIAL
	DbSelectArea("NEWSE5")
	SetRegua(RecCount())
	// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
	// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
	If !lAsTop
		Eval(bFirst) // Posiciona no primeiro registro a ser processado
	Endif

	dbSelectArea("SM0")
	cCodUlt := SM0->M0_CODIGO
	cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	dbSkip()
Enddo

If li != 80
	// Imprime o cabecalho, caso nao tenha espaco suficiente para impressao do total geral
	If (li+4)>=60
		SM0->(MsSeek(cCodUlt+cFilUlt))		
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	li+=2
	@li,  0 PSAY OemToAnsi("Total Geral : " )  //
	@li,102 PSAY nGerOrig       PicTure tm(nGerOrig,15,nDecs)
	@li,118 PSAY nGerJurMul     PicTure tm(nGerJurMul,11,nDecs)
	@li,130 PSAY nGerCM         PicTure tm(nGerCM ,11,nDecs)
	@li,142 PSAY nGerDesc       PicTure tm(nGerDesc,11,nDecs)
	@li,154 PSAY nGerAbLiq      PicTure tm(nGerAbLiq,11,nDecs)
	@li,166 PSAY nGerAbImp      PicTure tm(nGerAbImp,11,nDecs)	
	@li,178 PSAY nGerValor      PicTure tm(nGerValor,15,nDecs)
	If nGerBaixado > 0 
		@li,195 PSAY OemToAnsi("Baixados") 
		@li,204 PSAY nGerBaixado    PicTure tm(nGerBaixado,15,nDecs)
	Endif
	If nGerMovFin > 0
		li++
		@li,195 PSAY OemToAnsi("Mov Fin.") 
		@li,204 PSAY nGerMovFin   PicTure tm(nGerMovFin,15,nDecs)
	Endif
	If nGerComp > 0
		li++
		@li,195 PSAY "Compens."  
		@li,204 PSAY nGerComp     PicTure tm(nGerComp,15,nDecs)
	Endif
	If nGerFat > 0
		li++
		@li,195 PSAY "Bx.Fatura" 
		@li,204 PSAY nGerFat     PicTure tm(nGerFat,15,nDecs)
	Endif
	li++
	roda(cbcont,cbtxt,"G")
Endif

SM0->(dbgoto(nRecEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
dbSelectArea("TRB")
dbCloseArea()
Ferase(cNomArq1+GetDBExtension())
dbSelectArea("NEWSE5")
dbCloseArea()
If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif
dbSelectArea("SE5")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    � FA190ImpR4 � Autor � Adrianne Furtado      � Data � 05.09.06 ���
���������������������������������������������������������������������������Ĵ��
���Descricao � Relacao das baixas                                           ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA190ImpR4(nOrdem,aTotais)                                   ���
���������������������������������������������������������������������������Ĵ��
���Parametros� nOrdem    - Ordem que sera utilizada na emissao do relatorio ���
���          � aTotais   - Array que retorna o totalizador especifico de    ���
���          � 			   cada quebra de secao                             ���
���          � oReport   - objeto da classe TReport                         ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                     ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function MGFFIN331(nOrdem,aTotais,oReport,nGerOrig,lMultiNat)
Local oBaixas	:= oReport:Section(1)
Local cExp 			:= ""
Local CbTxt,CbCont
Local nValor:=0,nDesc:=0,nJuros:=0,nMulta:=0,nJurMul:=0,nCM:=0,dData,nVlMovFin:=0
Local nTotValor:=0,nTotDesc:=0,nTotJurMul:=0,nTotCm:=0,nTotOrig:=0,nTotBaixado:=0,nTotMovFin:=0,nTotComp:=0,nTotFat:=0
Local nGerValor:=0,nGerDesc:=0,nGerJurMul:=0,nGerCm:=0,nGerBaixado:=0,nGerMovFin:=0,nGerComp:=0,nGerFat:=0
Local nFilOrig:=0,nFilJurMul:=0,nFilCM:=0,nFilDesc:=0
Local nFilAbLiq:=0,nFilAbImp:=0,nFilValor:=0,nFilBaixado:=0,nFilMovFin:=0,nFilComp:=0,nFilFat:=0
Local nAbatLiq := 0,nTotAbImp := 0,nTotImp := 0,nTotAbLiq := 0,nGerAbLiq := 0,nGerAbImp := 0
Local cBanco,cNatureza,cAnterior,cCliFor,nCT:=0,dDigit,cLoja
Local lContinua		:=.T.
Local lBxTit		:=.F.
Local tamanho		:="G"
Local aCampos:= {},cNomArq1:="",nVlr,cLinha,lOriginal:=.T.
Local nAbat 		:= 0
Local cHistorico
Local lManual 		:= .f.
Local cTipodoc
Local nRecSe5 		:= 0
Local dDtMovFin
Local cRecPag
Local nRecEmp 		:= SM0->(Recno())
Local cMotBaixa		:= CRIAVAR("E5_MOTBX")
Local cFilNome 		:= Space(15)
Local cCliFor190	:= ""
Local aTam 			:= IIF(mv_par12 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu 		:= {}
Local nDecs	   		:= GetMv("MV_CENT"+(IIF(mv_par13 > 1 , STR(mv_par13,1),""))) 
Local nMoedaBco		:= 1
Local cCarteira
#IFDEF TOP
	Local aStru		:= SE5->(DbStruct()), nI
	Local cQuery
#ENDIF	
Local cFilTrb
Local lAsTop		:= .F.
Local cFilSe5		:= ".T."
Local cChave, bFirst
Local cFilOrig
Local lAchou		:= .F.
Local lF190Qry		:= ExistBlock("F190QRY")
Local cQueryAdd		:= ""
Local lAjuPar15		:= Len(AllTrim(mv_par15))==Len(mv_par15)
Local lAchouEmp		:= .T.                                
Local lAchouEst		:= .F.                                
Local nTamEH		:= TamSx3("EH_NUMERO")[1]
Local nTamEI		:= TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local cCodUlt		:= SM0->M0_CODIGO
Local cFilUlt		:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local nRecno  
Local nSavOrd 
Local aAreaSE5 
Local cChaveNSE5	:= ""           
Local nRecSE2		:= 0
Local aAreaSE2
Local aAreabk

Local aRet 			:= {}
Local cAuxFilNome
Local cAuxCliFor
Local cAuxLote
Local dAuxDtDispo
Local cFilUser	 	:= ""

Local lPCCBaixa 	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local nTaxa			:= 0   
Local lUltBaixa 	:= .F.
Local cChaveSE1 	:= ""
Local cChaveSE5 	:= ""
Local cSeqSE5 		:= ""
Local lNaturez 		:= .F.  
Local lMVLjTroco	:= SuperGetMV("MV_LJTROCO", ,.F.)				
Local nRecnoSE5		:= 0
Local nValTroco 	:= 0
Local lTroco 		:= .F.

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissao(default))
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPccBxCr := 0
//Controla o Pis Cofins e Csll na RA (1 = Controla reten��o de impostos no RA; ou 2 = Nao controla reten��o de impostos no RA(default))
Local lRaRtImp  := If (FindFunction("FRaRtImp"),FRaRtImp(),.F.)

Local cEmpresa		:= IIF(lUnidNeg,FWCodEmp(),"")
Local cAge, cContaBco
Local cMascNat := ""
Local lConsImp := .T.

/* GESTAO - inicio */
Local cTmpSE5Fil	:= ""                      
Local lNovaGestao	:= .F.
Local nSelFil		:= 0
Local nLenSelFil	:= 0
Local lGestao	    := Iif( lFWCodFil, ( "E" $ FWSM0Layout() .And. "U" $ FWSM0Layout() ), .F. )	// Indica se usa Gestao Corporativa
Local lExclusivo 	:= .F.
Local aModoComp 	:= {}
/* GESTAO - fim */

Default lMultiNat := .F. 

/* GESTAO - inicio */ 
#IFDEF TOP
	lNovaGestao := .T.
#ELSE
	lNovaGestao := .F.
#ENDIF
/* GESTAO - fim */

If lFWCodFil .And. lGestao
	aAdd(aModoComp, FWModeAccess("SE5",1) )
	aAdd(aModoComp, FWModeAccess("SE5",2) )
	aAdd(aModoComp, FWModeAccess("SE5",3) )
	lExclusivo := Ascan(aModoComp, 'E') > 0
Else
	dbSelectArea("SE5")
	lExclusivo := !Empty(xFilial("SE5"))
EndIf

If XFIN190()
	If MV_PAR42 == 2   
		lConsImp := .F.
	EndIf
EndIf

nGerOrig :=0

li := 1

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
/* GESTAO - inicio */
If lNovaGestao
	nLenSelFil := Len(aSelFil)
	If mv_Par41 == 1
		If nLenSelFil > 0
			cFilDe 	:= aSelFil[1]
			cFilAte := aSelFil[nLenSelFil]
		Endif
	Else
		If mv_par18 == 2 // Cons filiais abaixo
			cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
			cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		Else
			cFilDe := mv_par19	// Todas as filiais
			cFilAte:= mv_par20
		EndIf
	EndIf
Else
	If mv_par18 == 2 // Cons filiais abaixo
		cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	Else
		cFilDe := mv_par19	// Todas as filiais
		cFilAte:= mv_par20
	EndIf
Endif
/* GESTAO - fim */

// Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo
// usuario.
DbSelectArea("SE5")
Do Case
Case nOrdem == 1
	cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
	cCond2 := "E5_DATA"
	cChave := IndexKey(1)
	cChaveInterFun := cChave
	bFirst := {|| MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
Case nOrdem == 2
	cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
	cCond2 := "E5_BANCO"
	cChave := IndexKey(3)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par03,.T.)}
Case nOrdem == 3
	cCondicao := "E5_MULTNAT = '1' .Or. (E5_NATUREZ >= mv_par06 .and. E5_NATUREZ <= mv_par07)"
	cCond2 := "E5_NATUREZ"
	cChave := IndexKey(4)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par06,.T.)}
Case nOrdem == 4
	cCondicao := ".T."
	cCond2 := "E5_BENEF"
	cChave := "E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 5
	cCondicao := ".T."
	cCond2 := "E5_NUMERO"
	cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 6	//Ordem 6 (Digitacao)
	cCondicao := ".T."
	cCond2 := "E5_DTDIGIT"
	cChave := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 7 // por Lote
	cCondicao := "E5_LOTE >= '"+mv_par21+"' .and. E5_LOTE <= '"+mv_par22+"'"
	cCond2 := "E5_LOTE"
	cChave := IndexKey(5)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par21,.T.)}
OtherWise						// Data de Credito (dtdispo)
	cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
	cCond2 := "E5_DTDISPO"
	cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
EndCase

If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert("Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")//STR0073)
	Return(Nil)
Endif	
If !Empty(mv_par30) .And. ! ";" $ mv_par30 .And. Len(AllTrim(mv_par30)) > 3
	ApMsgAlert("Separe os tipos que nao deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")//STR0074)
	Return(Nil)
Endif	

#IFDEF TOP
	If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
		
		lAsTop := .T.
		cCondicao := ".T."
		DbSelectArea("SE5")
		cQuery := ""
		aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
		// Obtem os registros a serem processados
		cQuery := "SELECT " +SubStr(cQuery,2)
		cQuery +=         ",SE5.R_E_C_N_O_ SE5RECNO "
		cQuery += "FROM " + RetSqlName("SE5")+" SE5 "
		cQuery += "WHERE E5_RECPAG = '" + IIF( mv_par12 == 1, "R","P") + "' AND "
		cQuery += "      E5_DATA    between '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND "
		cQuery += "      E5_DATA    <= '" + DTOS(dDataBase) + "' AND "

		If cPaisLoc == "ARG" .and. mv_par03 == mv_par04
			cQuery += "      (E5_BANCO = '" + mv_par03 + "' OR E5_BANCO = '" + Space(TamSX3("A6_COD")[1]) + "') AND "
		Else
			cQuery += " E5_BANCO IN ('" + MV_PAR03 + "' ) AND "   //"' AND '" + mv_par04 + "' AND "		
			cQuery += " E5_AGENCIA IN ('" + MV_PAR04 + "') AND " // between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "		/// PARAMETROS INCLUSOS
			cQuery += "  E5_CONTA IN ('" + MV_PAR05 + "') AND "  //   between '" + mv_par07 + "' AND '" + mv_par08 + "' AND "		/// PARAMETROS INCLUSOS			
		EndIf
		If cPaisLoc == "ARG" .and. mv_par12 == 2 // pagar
			cQuery += " (E5_DOCUMEN <> '' AND E5_TIPO <> 'CH') AND "
		Endif
		//-- Realiza filtragem pela natureza principal
		If mv_par40 == 2
			cQuery +=  " E5_NATUREZ between '" + mv_par06       + "' AND '" + mv_par07     	+ "' AND "
		Else
			cQuery +=       " (E5_NATUREZ between '" + mv_par06       + "' AND '" + mv_par07       + "' OR "
			cQuery +=       " EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA "
			cQuery +=                 " FROM "+RetSqlName("SEV")+" SEV "
			cQuery +=                " WHERE E5_FILIAL  = EV_FILIAL AND "
			cQuery +=                       "E5_PREFIXO = EV_PREFIXO AND "
			cQuery +=                       "E5_NUMERO  = EV_NUM AND "
			cQuery +=                       "E5_PARCELA = EV_PARCELA AND "
			cQuery +=                       "E5_TIPO    = EV_TIPO AND "		
			cQuery +=                       "E5_CLIFOR  = EV_CLIFOR AND "
			cQuery +=                       "E5_LOJA    = EV_LOJA AND " 
			cQuery +=                       "EV_NATUREZ between '" + mv_par06 + "' AND '" + mv_par07 + "' AND "
			cQuery +=                       "SEV.D_E_L_E_T_ = ' ')) AND "
		EndIf
		cQuery += "      E5_CLIFOR  between '" + mv_par08       + "' AND '" + mv_par09       + "' AND "
		cQuery += "      E5_DTDIGIT between '" + DTOS(mv_par10) + "' AND '" + DTOS(mv_par11) + "' AND "
		cQuery += "      E5_LOTE    between '" + mv_par21       + "' AND '" + mv_par22       + "' AND "
		cQuery += "      E5_LOJA    between '" + mv_par23       + "' AND '" + mv_par24 	    + "' AND "
		cQuery += "      E5_PREFIXO between '" + mv_par27       + "' AND '" + mv_par28 	    + "' AND "
		cQuery += "      SE5.D_E_L_E_T_ = ' '  AND "
		cQuery += "		  E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND "
		cQuery += " 	  E5_SITUACA NOT IN ('C','E','X') AND "
		cQuery += "      ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR "
		cQuery += "      (E5_TIPODOC <> 'CD' )) "           //ES - Estorno    AND E5_TIPODOC <> 'ES'
//		cQuery += "		  AND E5_HISTOR NOT LIKE '%"+STR0077+"%'"
		
		If mv_par12 == 2
			cQuery += " AND E5_TIPODOC <> 'E2'"
		EndIf
		
		If !Empty(mv_par29) // Deseja imprimir apenas os tipos do parametro 28
			cQuery += " AND E5_TIPO IN "+FormatIn(mv_par29,";")
		ElseIf !Empty(Mv_par30) // Deseja excluir os tipos do parametro 29
			cQuery += " AND E5_TIPO NOT IN "+FormatIn(mv_par30,";")
		EndIf
		
		If mv_par17 == 2
			cQuery += " AND E5_TIPODOC <> '" + SPACE(LEN(E5_TIPODOC)) + "'"
			cQuery += " AND E5_NUMERO  <> '" + SPACE(LEN(E5_NUMERO)) + "'"
			cQuery += " AND E5_TIPODOC <> 'CH'"
		Endif

		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"		
				
		/* GESTAO - inicio */                            
		If mv_par41 == 1 .and. !Empty(aSelFil)
			If lExclusivo
				cQuery += " AND E5_FILIAL " + GetRngFil( aSelFil, "SE5", .T., @cTmpSE5Fil)
			Else
				cQuery += " AND E5_FILORIG " + FR190InFilial()
			Endif
		Else
			If mv_par18 == 2
				cQuery += " AND E5_FILIAL = '" + FwxFilial("SE5") + "'"
			Else
				If !lExclusivo
					cQuery += " AND E5_FILORIG between '" + cFilDe + "' AND '" + cFilAte + "'"
				Else
					cQuery += " AND E5_FILIAL between '" + cFilDe + "' AND '" + cFilAte + "'"
				EndIf
			Endif
		EndIf
		/* GESTAO - fim */
		
		cFilUser := oBaixas:GetSqlExp('SE5')

		If lF190Qry
			cQueryAdd := ExecBlock("F190QRY", .F., .F., {cFilUser})
			If ValType(cQueryAdd) == "C"
				cQuery += " AND (" + cQueryAdd + ")"
			EndIf
		EndIf

		If !Empty(cFilUser)
			cQuery += " AND (" + cFilUser + ") "
		EndIf

		cQuery += " AND"
		cQuery += " ("
		cQuery += " 	SELECT COUNT(*)"
		cQuery += " 	FROM " + retSQLName("SE5") + " SUBSE5"
		cQuery += " 	WHERE"
		cQuery += " 		 	SUBSE5.E5_TIPODOC	= 'ES'"
		cQuery += " 		AND	SUBSE5.E5_LOJA		= SE5.E5_LOJA"
		cQuery += " 		AND SUBSE5.E5_CLIFOR	= SE5.E5_CLIFOR"
		cQuery += " 		AND SUBSE5.E5_SEQ		= SE5.E5_SEQ"
		cQuery += " 		AND SUBSE5.E5_PARCELA	= SE5.E5_PARCELA"
		cQuery += " 		AND SUBSE5.E5_NUMERO	= SE5.E5_NUMERO"
		cQuery += " 		AND SUBSE5.E5_PREFIXO	= SE5.E5_PREFIXO"
		cQuery += " 		AND SUBSE5.E5_FILIAL	= SE5.E5_FILIAL"
		cQuery += " ) = 0"

		// seta a ordem de acordo com a opcao do usuario
		cQuery += " ORDER BY " + SqlOrder(cChave) 
		cQuery := ChangeQuery(cQuery)
		
		//memoWrite("C:\TEMP\MGFFIN33_2.sql", cQuery)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .F., .T.)
		For nI := 1 TO LEN(aStru)
			If aStru[nI][2] != "C"
				TCSetField("NEWSE5", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
			EndIf
		Next
		DbGoTop()
	Else
#ENDIF
		//�������������������������������������������������������������Ŀ
		//� Abre o SE5 com outro alias para ser filtrado porque a funcao�        
		//� TemBxCanc() utilizara o SE5 sem filtro.							 �
		//���������������������������������������������������������������
		If Select("NEWSE5") == 0 .And. !( ChkFile("SE5",.F.,"NEWSE5") )
			Return(Nil)
		EndIf		
		lAsTop := .F.
		DbSelectArea("NEWSE5")
		cFilSE5 := 'E5_RECPAG=='+IIF(mv_par12 == 1,'"R"','"P"')+'.and.'
		cFilSE5 += 'DTOS(E5_DATA)>='+'"'+dtos(mv_par01)+'"'+'.and.DTOS(E5_DATA)<='+'"'+dtos(mv_par02)+'".and.'
		cFilSE5 += 'DTOS(E5_DATA)<='+'"'+dtos(dDataBase)+'".and.'
		If nOrdem == 3
			cFilSE5 += '(E5_MULTNAT = "1" .Or. (E5_NATUREZ>='+'"'+mv_par06+'"'+'.and.E5_NATUREZ<='+'"'+mv_par07+'")).and.'
		Else
			cFilSE5 += '(E5_NATUREZ>='+'"'+mv_par06+'"'+'.and.E5_NATUREZ<='+'"'+mv_par07+'").and.'
		Endif		
		cFilSE5 += 'E5_CLIFOR>='+'"'+mv_par08+'"'+'.and.E5_CLIFOR<='+'"'+mv_par09+'".and.'
		cFilSE5 += 'DTOS(E5_DTDIGIT)>='+'"'+dtos(mv_par10)+'"'+'.and.DTOS(E5_DTDIGIT)<='+'"'+dtos(mv_par11)+'".and.'
		cFilSE5 += 'E5_LOTE>='+'"'+mv_par21+'"'+'.and.E5_LOTE<='+'"'+mv_par22+'".and.'
		cFilSE5 += 'E5_LOJA>='+'"'+mv_par23+'"'+'.and.E5_LOJA<='+'"'+mv_par24+'".and.'
		cFilSe5 += 'E5_PREFIXO>='+'"'+mv_par27+'"'+'.And.E5_PREFIXO<='+'"'+mv_par28+'"'

		If !Empty(mv_par29) // Deseja imprimir apenas os tipos do parametro 28
			cFilSe5 += '.And.E5_TIPO $'+'"'+ALLTRIM(mv_par29)+Space(1)+'"'
		ElseIf !Empty(Mv_par30) // Deseja excluir os tipos do parametro 29
			cFilSe5 += '.And.!(E5_TIPO $'+'"'+ALLTRIM(mv_par30)+Space(1)+'")'
		EndIf

		cFilUser := oBaixas:GetAdvPlExp('SE5')
		If !Empty(cFilUser)
			cFilSe5 += '.And. (' + cFilUser + ')'		
		Endif
		
		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par18 == 2
			cFilSe5 += " .AND. E5_FILIAL = '" + xFilial("SE5") + "'"
		Else
			If Empty( xFilial("SE5") )
				cFilSe5 += " .AND. E5_FILORIG >= '" + mv_par19 + "' .AND. E5_FILORIG <= '" + mv_par20 + "'"
			Else
				cFilSe5 +=" .AND. E5_FILIAL >= '" + mv_par19 + "' .AND. E5_FILIAL <= '" + mv_par20 + "'"
			EndIf
		Endif
#IFDEF TOP
	Endif
#ENDIF	
// Se nao for TOP, ou se for TOP e for AS400, cria Filtro com IndRegua
// Pois em SQL os registros ja estao filtrados em uma Query
If !lAsTop
	cNomeArq := CriaTrab(Nil,.F.)
	IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi("Selecionando Registros..."))  //STR0018
Endif

//������������������������������������������Ŀ
//� Define array para arquivo de trabalho    �
//��������������������������������������������
AADD(aCampos,{"LINHA","C",80,0 } )

//����������������������������Ŀ
//� Cria arquivo de Trabalho   �
//������������������������������
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi("Selecionando Registros..."))  //STR0018

aColu := Iif(aTam[1] > 6,{023,027,TamParcela("E1_PARCELA",40,39,38),042,000,022},{000,004,TamParcela("E1_PARCELA",17,16,15),019,023,030})


If MV_PAR17 == 1

	dbSelectArea("SE5")
	dbSetOrder(17) //"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_TIPODOC+E5_SEQ"
	dbGoTop()

Endif



DbSelectArea("SM0")
/* GESTAO - inicio */
If mv_par41 == 1 .and. lNovaGestao
	nSelFil := 0
Else
	DbSeek(cEmpAnt+If(Empty(cFilDe),"",cFilDe),.T.)
Endif

While !Eof() .and. SM0->M0_CODIGO == cEmpAnt .and.  If(mv_par41 ==1 .And. lNovaGestao,(nSelFil < nLenSelFil) .and. cFilDe <= cFilAte , SM0->M0_CODFIL <= cFilAte)
	If mv_par41 ==1 .and. lNovaGEstao
		nSelFil++
		DbSeek(cEmpAnt+aSelFil[nSelFil],.T.)
	Endif
/* GESTAO - fim */
	
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilNome:= SM0->M0_FILIAL
	DbSelectArea("NEWSE5")

	// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo
	// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
	/* GESTAO - inicio */
	IF !lNovaGestao
		If !lAsTop
			Eval(bFirst) // Posiciona no primeiro registro a ser processado
		Endif

		If lUnidNeg .and. (cEmpresa	<> FWCodEmp())
			SM0->(DbSkip())
			Loop
		Endif
	Endif
	/* GESTAO - fim */

	lMultiNat := .F.//inicializa variavel
	If mv_par12 = 2  //Pagar
		If mv_par40 != 3  //diferente de multinatureza verifica no SE2 se o campo esta preenchido
			SE2->(dbSetOrder(1))
			SE2->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
			lMultiNat := ( SE2->E2_MULTNAT == '1' ) //pq se o campo nao estiver preenchido nao desvia para FINR199
			lMultiNat := ( lMultiNat .And. MV_MULNATP .and. mv_par39 = 2 .and. mv_par40 != 2)
		Else
			lMultiNat := ( MV_MULNATP .and. mv_par39 = 2 .and. mv_par40 != 2)
		EndIf
	ElseIf mv_par12 = 1  //Receber
		lMultiNat := ( MV_MULNATR .and. mv_par39 = 2 .and. mv_par40 != 2 )
	EndIf
	
	If lMultiNat
	
		zFinr199(	@nGerOrig,@nGerValor,@nGerDesc,@nGerJurMul,@nGerCM,@nGerAbLiq,@nGerAbImp,@nGerBaixado,@nGerMovFin,@nGerComp,;
					@nFilOrig,@nFilValor,@nFilDesc,@nFilJurMul,@nFilCM,@nFilAbLiq,@nFilAbImp,@nFilBaixado,@nFilMovFin,@nFilComp,;
					.F.,cCondicao,cCond2,aColu,lContinua,cFilSe5,lAsTop,Tamanho, @aRet, @aTotais, nOrdem, @nGerFat, @nFilFat,lNovaGestao)

		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
				dbSelectArea("SE5")
				dbCloseArea()
				ChKFile("SE5")
				dbSelectArea("SE5")
				dbSetOrder(1)
			Endif
		#ENDIF
		If Empty(xFilial("SE5"))
			Exit
		Endif
		dbSelectArea("SM0")
		cCodUlt := SM0->M0_CODIGO
 		cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		dbSkip()
		Loop

	Else

		While NEWSE5->(!Eof()) .And. &cCondFil .And. &cCondicao .and. lContinua
			
			DbSelectArea("NEWSE5")
			// Testa condicoes de filtro	
/*
			If !XCRE022(cFilSe5,.F.)
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Endif							
  */						
			// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
			// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
			If !lAsTop 
				SE2->(dbSetOrder(1))
				SE2->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
				If SE2->E2_MULTNAT == '1'
					lNaturez := .F.					
					SEV->(dbSetOrder(1))
					SEV->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
					While NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) .and. !lNaturez
						If SEV->EV_NATUREZ >= mv_par06 .and. SEV->EV_NATUREZ <= mv_par07
							lNaturez := .T.
						EndIf
						SEV->(DbSkip())
					EndDo
					If !lNaturez
						NEWSE5->(dbSkip())
						Loop
					EndIf
				Else
					If !(NEWSE5->E5_NATUREZ >= mv_par06 .and. NEWSE5->E5_NATUREZ <= mv_par07)
						NEWSE5->(dbSkip())
						Loop
					EndIf					
				EndIf
			EndIf		 	
			If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
				(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
				cCarteira := "R"
			Else
				cCarteira := "P"
			Endif
	
			dbSelectArea("NEWSE5")
			cAnterior 	:= &cCond2
			nTotValor	:= 0
			nTotDesc	:= 0
			nTotJurMul  := 0
			nTotCM		:= 0
			nCT			:= 0
			nTotOrig	:= 0
			nTotBaixado	:= 0
			nTotAbLiq  	:= 0
			nTotImp		:= 0
			nTotMovFin	:= 0
			nTotComp		:= 0
	
			While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. &cCondFil .and. lContinua
	
				lManual := .f.
				dbSelectArea("NEWSE5")
				
				If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par17 == 1) .Or.;
					(Empty(NEWSE5->E5_NUMERO)  .And. mv_par17 == 1)
					lManual := .t.
				EndIf
				
				// Testa condicoes de filtro	
/*
				If !XCRE022(cFilSe5,.T.)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif	 						
  */					
				// Imprime somente cheques
				If mv_par38 == 1 .And. NEWSE5->E5_TIPODOC == "BA"

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.

					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura o cheque aglutinado, se encontrar, marca lAchou := .T. e despreza 
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC == "CH"
							lAchou := .T.
							Exit
						Endif
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif  	

				ElseIf mv_par38 == 2 .And. NEWSE5->E5_TIPODOC == "CH" //somente baixas

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.
					
					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura a baixa aglutinada, se encontrar despreza o movimento bancario
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC $ "BA"
							lAchou := .T.
							Exit
						Endif	
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif
				Endif	

				cNumero    	:= NEWSE5->E5_NUMERO
				cPrefixo   	:= NEWSE5->E5_PREFIXO
				cParcela   	:= NEWSE5->E5_PARCELA
				dBaixa     	:= NEWSE5->E5_DATA
				cBanco     	:= NEWSE5->E5_BANCO
				cAge		:= NEWSE5->E5_AGENCIA
				cContaBco	:= NEWSE5->E5_CONTA
				cNatureza  	:= NEWSE5->E5_NATUREZ
				cCliFor    	:= NEWSE5->E5_BENEF
				cLoja      	:= NEWSE5->E5_LOJA
				cSeq       	:= NEWSE5->E5_SEQ
				cNumCheq   	:= NEWSE5->E5_NUMCHEQ
				cRecPag     := NEWSE5->E5_RECPAG
				cTipodoc   	:= NEWSE5->E5_TIPODOC
				cMotBaixa	:= NEWSE5->E5_MOTBX
				cCheque    	:= NEWSE5->E5_NUMCHEQ
				cTipo      	:= NEWSE5->E5_TIPO
				cFornece   	:= NEWSE5->E5_CLIFOR
				cLoja      	:= NEWSE5->E5_LOJA
				dDigit     	:= NEWSE5->E5_DTDIGIT
				lBxTit	  	:= .F.
				cFilorig    := NEWSE5->E5_FILORIG
				
				If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
					(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
					dbSelectArea("SE1")
					dbSetOrder(1)
					// Procuro SE1 pela filial origem
					lBxTit := MsSeek(cFilorig+cPrefixo+cNumero+cParcela+cTipo)
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
					Endif				
					cCarteira := "R"
					dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
					While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
						If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
							Exit
						Endif                                
						SE1->( dbSkip() )
					EndDo
					If !SE1->(EOF()) .And. mv_par12 == 1 .and. !lManual .and.  ;
						(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
						If SE5->(FieldPos("E5_SITCOB")) > 0
							cExp := "NEWSE5->E5_SITCOB"
						Else
							cExp := "SE1->E1_SITUACA"
						Endif 
						
						If mv_par37 == 2 // Nao imprime titulos em carteira 
							// Retira da comparacao as situacoes branco, 0, F e G
							mv_par15 := AllTrim(mv_par15)       
							mv_par15 := StrTran(mv_par15,"0","")
							mv_par15 := StrTran(mv_par15,"F","")
							mv_par15 := StrTran(mv_par15,"G","")
						Else
							If (NEWSE5->E5_RECPAG == "R") .And. lAjuPar15
								mv_par15  += " "
							Endif
						EndIf	
				
						cExp += " $ mv_par15" 
						If !(&cExp)
							dbSelectArea("NEWSE5")
							NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
							Loop
						Endif
					Endif
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
				Else
					dbSelectArea("SE2")
					DbSetOrder(1)
					cCarteira := "P"
					// Procuro SE2 pela filial origem
				    lBxTit 	:= MsSeek(cFilorig+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				    
				    Iif(lBxTit, nRecSE2	:= SE2->(Recno()), nRecSE2 := 0 )
				    
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
					Endif				
					dDtMovFin := IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.T.))
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
					cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
				Endif
				dbSelectArea("NEWSE5")
				cHistorico := Space(40)
				While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. &cCondFil
					
					dbSelectArea("NEWSE5")
					cTipodoc   := NEWSE5->E5_TIPODOC
					cCheque    := NEWSE5->E5_NUMCHEQ
	
					lAchouEmp := .T.
					lAchouEst := .F.
	
					// Testa condicoes de filtro	

/*					If !XCRE022(cFilSe5,.T.)
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
						Loop
					Endif	  								
  */												
					If NEWSE5->E5_SITUACA $ "C/E/X" 
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					EndIF
					
					If NEWSE5->E5_LOJA != cLoja
						Exit
					Endif
	
					If NEWSE5->E5_FILORIG < mv_par34 .or. NEWSE5->E5_FILORIG > mv_par35
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					Endif
	
					//���������������������������������������������������Ŀ
					//� Nao imprime os registros de emprestimos excluidos �
					//�����������������������������������������������������					
					If NEWSE5->E5_TIPODOC == "EP"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEH")
						dbSetOrder(1)
						lAchouEmp := MsSeek(xFilial("SEH")+Substr(NEWSE5->E5_DOCUMEN,1,nTamEH))
						RestArea(aAreaSE5)
						If !lAchouEmp
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	
					//�����������������������������������������������������������������Ŀ
					//� Nao imprime os registros de pagamento de emprestimos estornados �
					//�������������������������������������������������������������������					
					If NEWSE5->E5_TIPODOC == "PE"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEI")
						dbSetOrder(1)
						If	MsSeek(xFilial("SEI")+"EMP"+Substr(NEWSE5->E5_DOCUMEN,1,nTamEI))
							If SEI->EI_STATUS == "C"
								lAchouEst := .T.
							EndIf
						EndIf
						RestArea(aAreaSE5)
						If lAchouEst
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	  
					//�����������������������������Ŀ
					//� Verifica o vencto do Titulo �
					//�������������������������������
					cFilTrb := If(mv_par12==1,"SE1","SE2")
					If (cFilTrb)->(!Eof()) .And.;
						((cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") < mv_par32 .Or. (!Empty(mv_par33) .And. (cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") > mv_par33))
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())
						Loop
					Endif
	            
					dBaixa     	:= NEWSE5->E5_DATA
					cBanco     	:= NEWSE5->E5_BANCO
					cAge			:= NEWSE5->E5_AGENCIA
					cContaBco		:= NEWSE5->E5_CONTA
					cNatureza  	:= NEWSE5->E5_NATUREZ
					cCliFor    	:= NEWSE5->E5_BENEF
					cSeq       	:= NEWSE5->E5_SEQ
					cNumCheq   	:= NEWSE5->E5_NUMCHEQ
					cRecPag		:= NEWSE5->E5_RECPAG
					cMotBaixa	:= NEWSE5->E5_MOTBX
					cTipo190		:= NEWSE5->E5_TIPO
					cFilorig    := NEWSE5->E5_FILORIG
					//��������������������������������������������������������������Ŀ
					//� Obter moeda da conta no Banco.                               �
					//����������������������������������������������������������������
					If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. ( FindFunction( "FXMultSld" ) .AND. FXMultSld() )
						SA6->(DbSetOrder(1))
						SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
						nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
					Else
						nMoedaBco	:=	1
					Endif
	
					If !Empty(NEWSE5->E5_NUMERO)
						If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
							(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG) .Or.;
							(NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPODOC $ "DB#OD")
							dbSelectArea( "SA1")
							dbSetOrder(1)
							lAchou := .F.
							If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA) //SA1 pode esta comp s� por filial.
								lAchou := .T.
							Endif								
							If !lAchou
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA1 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par31==1,SA1->A1_NREDUZ,SA1->A1_NOME)
							Else
								cCliFor	:= 	Upper(Alltrim(NEWSE5->E5_BENEF))
							Endif
						Else
							dbSelectArea( "SA2")
							dbSetOrder(1)
							lAchou := .F.
							If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .T.
							Endif							
							If !lAchou
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA2 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par31==1,SA2->A2_NREDUZ,SA2->A2_NOME)
							Else
								cCliFor	:= 	Upper(Alltrim(NEWSE5->E5_BENEF))
							Endif
						EndIf
					EndIf
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek(NEWSE5->E5_DATA)
					dbSelectArea("NEWSE5") 
					nTaxa:= 0

					If cPaisLoc=="BRA"
						If !Empty(NEWSE5->E5_TXMOEDA)
							nTaxa:=NEWSE5->E5_TXMOEDA
						Else
							If nMoedaBco == 1
								nTaxa := NEWSE5->E5_VALOR / NEWSE5->E5_VLMOED2
							Else
								nTaxa := NEWSE5->E5_VLMOED2 / NEWSE5->E5_VALOR
							EndIf																
						EndIf
					EndIf
					nRecSe5:=If(lAsTop,NEWSE5->SE5RECNO,Recno())
					nDesc+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
					nJuros+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
					nMulta+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
					nJurMul+= nJuros + nMulta
					nCM+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))

					If lPccBaixa .and. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL)
						If nRecSE2 > 0 
						
							aAreabk  := Getarea()
							aAreaSE2 := SE2->(Getarea())
							SE2->(DbGoto(nRecSE2))
						
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)+;
										SE2->E2_INSS+ SE2->E2_ISS+ SE2->E2_IRRF
										
							Restarea(aAreaSE2)
							Restarea(aAreabk)
						Else
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)
						Endif
					Endif				

					If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
						nValTroco := 0                                          					
						cHistorico := NEWSE5->E5_HISTOR

						If mv_par12 == 2
							If cPaisLoc == "ARG" .and. !EMPTY(NEWSE5->E5_ORDREC)
								nValor += Iif(VAL(NEWSE5->E5_MOEDA)==mv_par13,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,VAL(NEWSE5->E5_MOEDA),mv_par13,NEWSE5->E5_DATA,nDecs+1,NEWSE5->E5_TXMOEDA),nDecs+1))
							Else
							 	nValor += Iif(mv_par13==nMoedaBco,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VLMOED2,SE2->E2_MOEDA,mv_par13,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))+nJurMul-nDesc,nDecs+1))
							Endif
						Else
						 	nValor+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VLMOED2,SE1->E1_MOEDA,mv_par13,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1))
						EndIf						

						If lMVLjTroco
							lTroco := If(Substr(NEWSE5->E5_HISTOR,1,3)=="LOJ",.T.,.F.)
							If lTroco
								nRecnoSE5 := SE5->(Recno())
								DbSelectArea("SE5")
								DbSetOrder(7)
								If dbSeek(xFilial("SE5")+NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+Space(TamSX3("E5_TIPO")[1])+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									While !Eof() .AND. xFilial("SE5") == SE5->E5_FILIAL .AND. NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+Space(TamSX3("E5_TIPO")[1])+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA == SE5->E5_PREFIXO+;
														SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA
										
										If SE5->E5_MOEDA = "TC" .AND. SE5->E5_TIPODOC = "VL" .AND.;
											SE5->E5_RECPAG = "P" 
											nValTroco := SE5->E5_VALOR
										EndIf  
										SE5->(DbSkip())				    					
									EndDo
								EndIf
								SE5->(DbGoTo(nRecnoSE5)) 			   
							Endif
                        Endif                                                              
                        
						dbSelectArea("NEWSE5") 										
						
						nValor -= nValTroco

						//Pcc Baixa CR
						If cCarteira == "R" .and. lPccBxCr .and. cPaisLoc == "BRA" .And. (IiF(lRaRtImp,NEWSE5->E5_TIPO $ MVRECANT,.T.) .OR. lPccBaixa)
							If Empty(NEWSE5->E5_PRETPIS) 
								nPccBxCr += Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VRETPIS,Round(xMoeda(NEWSE5->E5_VRETPIS,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCOF) 
								nPccBxCr += Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VRETCOF,Round(xMoeda(NEWSE5->E5_VRETCOF,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCSL) 
								nPccBxCr += Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VRETCSL,Round(xMoeda(NEWSE5->E5_VRETCSL,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif											
						Endif

					Else
						nVlMovFin+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
						cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
						cNatureza  	:= NEWSE5->E5_NATUREZ
					Endif	

					cAuxFilNome := cFilAnt + " - "+ cFilNome
					cAuxCliFor  := cCliFor					    
					cAuxLote    := E5_LOTE
					dAuxDtDispo := E5_DTDISPO

					dbSkip()
					If lManual		// forca a saida do looping se for mov manual
						Exit
					Endif
				EndDO
	
				If (nDesc+nValor+nJurMul+nCM+nVlMovFin) > 0    
					AAdd(aRet, Array(31))

					// Defaults >>>
					aRet[Li][01] := ""
					aRet[Li][02] := ""
					aRet[Li][03] := ""
					aRet[Li][04] := ""
					aRet[Li][05] := ""
					// <<< Defaults
					
					aRet[Li][22] := cAuxFilNome
					aRet[Li][23] := cAuxCliFor
					aRet[Li][24] := cAuxLote
					aRet[Li][25] := dAuxDtDispo
					//������������������������������Ŀ
					//� Calculo do Abatimento        �
					//��������������������������������
					If cCarteira == "R" .and. !lManual
						dbSelectArea("SE1")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG 
                                 
							//�����������������������������������������������������������������������Ŀ
							//� Encontra a ultima sequencia de baixa na SE5 a partir do titulo da SE1 �
							//�������������������������������������������������������������������������
							aAreaSE1 := SE1->(GetArea())
							dbSelectArea("SE5")
							dbSetOrder(7)
							cChaveSE1 := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
							SE5->(MsSeek(xFilial("SE5")+cChaveSE1))
		               
							cSeqSE5 := SE5->E5_SEQ
                     
							While SE5->(!EOF()) .And. cChaveSE1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
								If SE5->E5_SEQ > cSeqSE5
									cSeqSE5 := SE5->E5_SEQ
								Endif
								SE5->(dbSkip())
							Enddo

							lUltBaixa := .F.							
							SE5->(MsSeek(xFilial("SE5")+cChaveSE1+cSeqSE5))
							cChaveSE5 := cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq							

							If cChaveSE5 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) .And.;
								Empty(SE1->E1_SALDO)
								If SE1->E1_VALOR <> SE1->E1_VALLIQ
									lUltBaixa := .T.                  
								EndIf
							EndIf
							
							//��������������������������������������������������������������������Ŀ
							//� Calcula o valor total de abatimento do titulo e impostos se houver �
							//����������������������������������������������������������������������
							nTotAbImp  := 0  
							If lUltBaixa
								nAbat := SumAbatRec(cPrefixo,cNumero,cParcela,SE1->E1_MOEDA,"V",dBaixa,@nTotAbImp)
								nAbatLiq := nAbat - nTotAbImp
							EndIf

							lUltBaixa := .F.							
							RestArea(aAreaSE1)

							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
                                                                      
							SA1->(DBSetOrder(1))
							If SA1->(DBSeek(xFilial("SA1")+cCliFor190) )
								lCalcIRF := SA1->A1_RECIRRF == "1" .and. SA1->A1_IRBAX == "1" // se for na baixa 
							Else
								lCalcIRF := .F.	
							EndIf	
							If lCalcIRF							
								nTotAbImp += SE1->E1_IRRF
							EndIf	
						EndIf			
						dbSelectArea("SE1")
						dbGoTo(nRecno)
					Elseif !lManual
						dbSelectArea("SE2")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
							nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par13,,cFornece,cLoja)
							nAbatLiq := nAbat	
						EndIf			
						dbSelectArea("SE2")
						dbGoTo(nRecno)
					EndIF
					aRet[li][05]:= " "
					IF mv_par12 == 1 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							aRet[li][05] := SE1->E1_CLIENTE						
						Endif
						aRet[li][06] := AllTrim(cCliFor)
					Elseif mv_par12 == 2 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							aRet[li][05] := SE2->E2_FORNECE
						Endif
						aRet[li][06] := AllTrim(cCliFor)
					Endif
	
					aRet[li][01] := cPrefixo
					aRet[li][02] := cNumero
					aRet[li][03] := cParcela
					aRet[li][04] := cTipo		
	
					If !lManual
						dbSelectArea("TRB")
						lOriginal := .T.
						//������������������������������Ŀ
						//� Baixas a Receber             �
						//��������������������������������
						If cCarteira == "R"
							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
							nVlr:= SE1->E1_VLCRUZ
							If mv_par13 > 1
								nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par13,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1)
							EndIF
							//������������������������������Ŀ
							//� Baixa de PA                  �
							//��������������������������������
						Else
							cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
                                                                      
							If cPaisLoc=="BRA"
								lCalcIRF:= Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == "1" .Or.;//1-Normal, 2-Baixa
								    	   Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == " "
							Else 
								lCalcIRF:=.f.
							EndIf

							// MV_MRETISS "1" retencao do ISS na Emissao, "2" retencao na Baixa.
					   		nVlr:= SE2->E2_VLCRUZ
							If lConsImp   //default soma os impostos no valor original
								nVlr += SE2->E2_INSS+ Iif(GetNewPar('MV_MRETISS',"1")=="1",SE2->E2_ISS,0) +;
									   	Iif(lCalcIRF,SE2->E2_IRRF,0)
								If ! lPccBaixa  // SE PCC NA EMISSAO SOMA PCC
									nVlr += SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL
								EndIf
							EndIf

							If mv_par13 > 1
								nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
							Endif
						Endif
						aRet[li,28] := nRecSE5
						dbgoto(nRecSe5)
						cFilTrb := If(cCarteira=="R","SE1","SE2")
						IF DbSeek( xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo)
							nAbat:=0
							lOriginal := .F.
						Else
							nVlr:=NoRound(nVlr)
							RecLock("TRB",.T.)
							Replace linha With xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo
							MsUnlock()
						EndIF
					Else
						If lAsTop
							dbSelectArea("SE5")
						Else
							dbSelectArea("NEWSE5")
						Endif         
						aRet[li,28] := nRecSE5
						dbgoto(nRecSe5)
						nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par13,E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",E5_TXMOEDA,0)),nDecs+1)
						nAbat:= 0
						lOriginal := .t.
						If lAsTop
							nRecSe5:=NEWSE5->SE5RECNO
						Else
							nRecSe5:=Recno()
							NEWSE5->( dbSkip() )
						Endif
						dbSelectArea("TRB")
					Endif
					IF cCarteira == "R"
						If ( !lManual )
							If mv_par14 == 1  // Utilizar o Historico da Baixa ou Emissao
								cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
							Else
								cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
							Endif
						EndIf
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								aRet[li][05] := SE1->E1_CLIENTE
							Endif
							aRet[li][06] := AllTrim(cCliFor)
						Endif
						cMascNat := MascNat(cNatureza)
						aRet[li][07] := If(Len(Alltrim(cNatureza))>8, cNatureza, cMascNat)  
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						aRet[li][08] := IIf(lManual,dDtMovFin,DataValida(SE1->E1_VENCTO,.T.)) //Vencto
						aRet[li][09] := AllTrim(cHistorico)
						aRet[li][10] := dBaixa
						IF nVlr > 0
							aRet[li][11] := nVlr // Picture tm(nVlr,14,nDecs)
						Endif
					Else
						If mv_par14 == 1  // Utilizar o Historico da Baixa ou Emissao
							cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
						Else
							cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
						Endif
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								aRet[li][05] := SE2->E2_FORNECE
							Endif
							aRet[li][06] := AllTrim(cCliFor)
						Endif
						cMascNat := MascNat(cNatureza)
						aRet[li][07] := If(Len(Alltrim(cNatureza))>8, cNatureza, cMascNat)  
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						aRet[li][08] := IIf(lManual,dDtMovFin,DataValida(SE2->E2_VENCTO,.T.))
						If !Empty(cCheque)
							aRet[li][09] := ALLTRIM(cCheque)+"/"+Trim(cHistorico)
						Else
							aRet[li][09] := ALLTRIM(cHistorico)
						EndIf
						aRet[li][10] := dBaixa
						IF nVlr > 0
							aRet[li][11] := nVlr //Picture tm(nVlr,14,nDecs)
						Endif
					Endif
					nCT++
					aRet[li][12] := nJurMul    //PicTure tm(nJurMul,11,nDecs)
										
					If cCarteira == "R" .and. mv_par13 == SE1->E1_MOEDA					
					   aRet[li][13] := 0
					
					ElseIf cCarteira == "P" .and. mv_par13 == SE2->E2_MOEDA
					   aRet[li][13] := 0
					   
					Else					   
					   aRet[li][13] := nCM        //PicTure tm(nCM ,11,nDecs)
					   
					Endif

					//PCC Baixa CR
					//Somo aos abatimentos de impostos, os impostos PCC na baixa.
					//Caso o calculo do PCC CR seja pela emissao, esta variavel estara zerada
					nTotAbImp := nTotAbImp + nPccBxCr
					   
					aRet[li][14] := nDesc      //PicTure tm(nDesc,11,nDecs)
					aRet[li][15] := nAbatLiq  	//Picture tm(nAbatLiq,11,nDecs)
					aRet[li][16] := nTotAbImp 	//Picture tm(nTotAbImp,11,nDecs)
					If nVlMovFin > 0
						aRet[li][17] := nVlMovFin     //PicTure tm(nVlMovFin,15,nDecs)
					Else
						aRet[li][17] := nValor			//PicTure tm(nValor,15,nDecs)
					Endif
					aRet[li][18] := cBanco
					aRet[li][30] := cAge
					aRet[li][31] := cContaBco
					If Len(DtoC(dDigit)) <= 8
						aRet[li][19] := dDigit
					Else                   
						aRet[li][19] := dDigit
					EndIf
	
					If empty(cMotBaixa)
						cMotBaixa := "NOR"  //NORMAL
					Endif
	
					aRet[li][20] := Substr(cMotBaixa,1,3)
					aRet[li][21] := cFilorig
					
					aRet[li][26] := lOriginal
					aRet[li][27] := If( nVlMovFin <> 0, nVlMovFin , If(MovBcoBx(cMotBaixa),nValor,0))
					nTotOrig   += If(lOriginal,nVlr,0)
					nTotBaixado+= If(cTipodoc $ "CP/BA" .AND. cMotBaixa $ "CMP/FAT",0,nValor)		// nao soma, j� somou no principal
					nTotDesc   += nDesc
					nTotJurMul += nJurMul
					nTotCM     += nCM
					nTotAbLiq  += nAbatLiq
					nTotImp    += nTotAbImp
					nTotValor  += If( nVlMovFin <> 0, nVlMovFin , If(MovBcoBx(cMotBaixa),nValor,0))
					nTotMovFin += nVlMovFin
					nTotComp   += If(cTipodoc == "CP",nValor,0)
					nTotFat    += If(cMotBaixa $ "FAT",nValor,0)
					nDesc := nJurMul := nValor := nCM := nAbat := nTotAbImp := nAbatLiq := nVlMovFin := 0
					nPccBxCr	:= 0		//PCC Baixa CR
					li++
				Endif
				dbSelectArea("NEWSE5")
			Enddo

			If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
				cQuebra := DtoS(cAnterior)
			Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
				cQuebra := cAnterior
			EndIf

			If (nTotValor+nDesc+nJurMul+nCM+nTotOrig+nTotMovFin+nTotComp+nTotFat)>0
				If nCT > 0
						If nTotBaixado > 0
							AAdd(aTotais,{cQuebra,"Baixados",nTotBaixado})  //STR0028
						Endif	
						If nTotMovFin > 0
							AAdd(aTotais,{cQuebra,"Mov Fin.",nTotMovFin})  //STR0031
						Endif
						If nTotComp > 0
							AAdd(aTotais,{cQuebra,"Compens.",nTotComp})  //STR0037
						Endif
						If nTotFat > 0
							AAdd(aTotais,{cQuebra,"Bx.Fatura",nTotFat})  //STR0076
						Endif						
				Endif
			Endif      
	
			//�������������������������Ŀ
			//�Incrementa Totais Gerais �
			//���������������������������
			nGerBaixado += nTotBaixado
			nGerMovFin	+= nTotMovFin
			nGerComp	+= nTotComp
			nGerFat		+= nTotFat

			//�������������������������Ŀ
			//�Incrementa Totais Filial �
			//���������������������������
			nFilOrig	+= nTotOrig
			nFilValor	+= nTotValor
			nFilDesc	+= nTotDesc
			nFilJurMul	+= nTotJurMul
			nFilCM		+= nTotCM
			nFilAbLiq	+= nTotAbLiq 
			nFilAbImp	+= nTotImp 		
			nFilBaixado += nTotBaixado
			nFilMovFin	+= nTotMovFin
			nFilComp	+= nTotComp 
			nFilFat     += nTotFat
		Enddo
	Endif	
	//����������������������������������������Ŀ
	//� Imprimir TOTAL por filial somente quan-�
	//� do houver mais do que 1 filial.        �
	//������������������������������������������
	if mv_par18 == 1 .and. SM0->(Reccount()) > 1
		If nFilBaixado > 0 
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), "Baixados", nFilBaixado } )  //STR0028
		Endif
		If nFilMovFin > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), "Mov Fin.", nFilMovFin } )  //STR0031
		Endif
		If nFilComp > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), "Compens.", nFilComp } )  //STR0037
		Endif
		If nFilFat > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), "Compens.", nFilFat } )  //STR0076
		Endif
		
		If Empty(xFilial("SE5")) .And. mv_par18 == 2
			Exit
		Endif	

		nFilOrig:=nFilJurMul:=nFilCM:=nFilDesc:=nFilAbLiq:=nFilAbImp:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=nFilFat:=0
	Endif
	dbSelectArea("SM0")
	cCodUlt := SM0->M0_CODIGO
	cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	dbSkip()
Enddo

If nGerBaixado > 0
	AAdd(aTotais,{"Baixados","aaa",nGerBaixado})  //STR0075
Endif	
If nGerMovFin > 0
	AAdd(aTotais,{"Mov Fin.","bbb",nGerMovFin})  //STR0075 STR0031
Endif
If nGerComp > 0
	AAdd(aTotais,{"Compens.","ccc",nGerComp})  //STR0075 STR0037
EndIf                             
If nGerFat > 0
	AAdd(aTotais,{"Bx.Fatura","ddd",nGerFat})  //STR0075 STR0076
EndIf                             

SM0->(dbgoto(nRecEmp))                                                                            
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
dbSelectArea("TRB")
dbCloseArea()
Ferase(cNomArq1+GetDBExtension())
dbSelectArea("NEWSE5")
dbCloseArea() 

/* GESTAO - inicio */
If !Empty(cTmpSE5Fil)
	CtbTmpErase(cTmpSE5Fil)
Endif
/* GESTAO - fim */

If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif
dbSelectArea("SE5")
dbSetOrder(1)

Return aRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �zFr190TstCo� Autor � Claudio D. de Souza  � Data � 20.07.17 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Testa as condicoes do registro do SE5 para permitir a impr.���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � zFr190TstCon(cFilSe5)									  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cFilSe5 - Filtro em CodBase								  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR190													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function zFr190TstCond(cFilSe5,lInterno)
Local lRet := .T.
Local nMoedaBco
Local lManual := .F.

If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
	(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
	lManual := .t.
EndIf

Do Case
Case !&(cFilSe5)           		// Verifico filtro CODEBASE tambem para TOP
	lRet := .F.
Case NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2" 
	lRet := .F.
Case NEWSE5->E5_SITUACA $ "C/E/X" .or. NEWSE5->E5_TIPODOC $ "TE" .or.;
	(NEWSE5->E5_TIPODOC == "CD" .and. NEWSE5->E5_VENCTO > NEWSE5->E5_DATA)
	lRet := .F.
Case NEWSE5->E5_TIPODOC == "E2" .and. mv_par11 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 2
	lRet := .F. 
Case mv_par17 == 2 .and. (NEWSE5->E5_TIPODOC $ "CH" .or. NEWSE5->E5_TIPODOC == "TR")  //era mv_par16
	lRet := .F. 
Case NEWSE5->E5_MOTBX == "DSD"
	lRet := .F.
Case mv_par12 = 1 .And. E5_TIPODOC $ "E2#CB"    //era parametro 11
	lRet := .F.
//Case IIf(mv_par03 == mv_par04,NEWSE5->E5_BANCO != mv_par03 .And. !Empty(NEWSE5->E5_BANCO),NEWSE5->E5_BANCO < mv_par03 .Or. NEWSE5->E5_BANCO > MV_PAR04)
Case mv_par03 <> NEWSE5->E5_BANCO 
	lRet := .F.
	//���������������������������������������������������������������������Ŀ
	//�Se escolhido o parametro "baixas normais", apenas imprime as baixas  �
	//�que gerarem movimentacao bancaria e as movimentacoes financeiras     �
	//�manuais, se consideradas.                                            �
	//�����������������������������������������������������������������������
Case mv_par16 == 1 .and. !MovBcoBx(NEWSE5->E5_MOTBX) .and. !lManual	//mv_par14
	lRet := .F.
	//��������������������������������������������������������������Ŀ
	//� Considera filtro do usuario                                  �
	//����������������������������������������������������������������
Case !Empty(cFilterUser).and.!(&cFilterUser)
	lRet := .F.	
	//������������������������������������������������������������������������Ŀ
	//� Verifica se existe estorno para esta baixa, somente no nivel de quebra �
	//� mais interno, para melhorar a performance 										�
	//��������������������������������������������������������������������������
Case	lInterno .And.;
		!Empty(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)) .And.;
	  	TemBxCanc(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))	
	lRet := .F.
EndCase

If lRet .And. NEWSE5->E5_RECPAG == "R"
	If ( NEWSE5->E5_TIPODOC = "RA" .And. mv_par36 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG.and. mv_par25 == 2 .and.;
		NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif
If lRet .And. NEWSE5->E5_RECPAG == "P"
	If ( NEWSE5->E5_TIPODOC = "PA" .And. mv_par36 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par25 == 2 .and.;
		 NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif	

If lRet .And. mv_par26 == 2   //era mv_par25
	If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. FXMultSld()
	   SA6->(DbSetOrder(1))
	   SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
	   nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
	ElseIf !Empty(NEWSE5->E5_ORDREC)
		nMoedaBco:= Val(NEWSE5->E5_MOEDA)
	Else
	   nMoedaBco	:=	1
	Endif
	If nMoedaBco <> mv_par13   //era mv_par12
		lRet := .F.
	EndIf
EndIf 

If lRet
	// Testar se considerar mov bancario e se o cancelamento da baixa tiver sido realizado, nao imprimir o mov.						
	If MV_PAR17 == 1		//era MV_PAR16
		If Fr190MovCan(17,"NEWSE5")
		   lRet := .F.
		Endif   
	Endif
Endif

If lRet
	// Se for um recebimento de Titulo pago em dinheiro originado pelo SIGALOJA, nao imprime o mov.
	If NEWSE5->E5_TIPODOC == "BA" .and. NEWSE5->E5_MOTBX == "LOJ" .And. IsMoney(NEWSE5->E5_MOEDA)
		lRet := .F.	
	EndIf
EndIf

//Tratamento p/ � imp t�t aglutinador quando o mesmo nao estiver sofrido baixa.
If Empty(NEWSE5->(E5_TIPO+E5_DOCUMEN+E5_IDMOVI+E5_FILORIG+E5_MOEDA))
	lRet := .F.	
EndIf

Return lRet     
////

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FR190MovCan� Autor � Marcelo Celi Marques � Data � 05.10.09 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Verifica se o registro selecionado pertente a um titulo    ��� 
���          � cuja baixa foi cancelada, mas, que gerou mov bancario      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FR190MovCan(nIndexSE5,_SE5)								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nIndexSE5 - Filtro provisorio criado no inicio da rotina	  ��� 
���          � E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ    >>	  ��� 
���          � +E5_TIPODOC+E5_SEQ                                   	  ���
���          � 															  ��� 
���          � _SE5 - Nome da tabela temporaria do SE5 gerada       	  ���
���          � no inicio da rotina										  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR190/FINR199											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xFR190MovCan(nIndexSE5,_SE5)
	Local lRet := .F.
	Local aAreaSE5 := (_SE5)->(GetArea())
	
	If Empty((_SE5)->E5_MOTBX)
		dbSelectArea("SE5")
		dbSetOrder(nIndexSE5)
		If dbSeek((_SE5)->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+"EC"+E5_SEQ))
			lRet := .T.
		Endif
		dbSelectArea(_SE5)
		RestArea(aAreaSE5)
	Endif	
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �R190Perg41�Autor  �Microsiga           � Data �  19/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se tem a pergunta                                 ���
���          �  Col.Vlr.Original ? Soma Imposto / Nao Soma Imposto        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function XFIN190()
Local lRet := .F.
SX1->( dbSetOrder(1) )
If SX1->( dbSeek( PadR( "XFIN190", Len(SX1->X1_GRUPO) )+"41" ) )
	lRet := .T.
EndIf
Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} FR190InFilial

Formata uma string com todas as filiais selecionadas pelo usuario,
para que seja usada no parametro "IN" da query

@author daniel.mendes

@since 05/05/2014
@version P1180
 
@return Retorna uma string com as filiais selecionadas
/*/
//-------------------------------------------------------------------
Static Function FR190InFilial()
Local cRetornoIn := ""
Local nFor := 0

	For nFor := 1 To Len(aSelFil)
		cRetornoIn += aSelFil[nFor] + '|' 
	Next nFor

Return " IN " + FormatIn( SubStr( cRetornoIn , 1 , Len( cRetornoIn ) -1 ) , '|' )



/////Mark browse do parametro Bancos/Conta/Agencia//////

User Function GATILHO()
     
Local aBanco     := {}
Local cTransp    := ""
Local cRomaneio  := ""
Local nI		 := 1
Local nY		 := 0
Local nRegua 	 := 0
Local lMark      := .F.                    
Local lRet		 := .F.
Local cDoc 		 := ""
Local cTpdoc     := ""
Local cSerdoc    := ""
Local cEmissor   := ""

	lRet := .T.
	
	dbSelectArea("SA6")
	SA6->(dbSetOrder(1)) 
	SA6->(dbGotop())
	
		While !SA6->(eof()) 
		
		    IF SA6->A6_COD <> "" 

	    	   AADD (aBanco, {lMark,SA6->A6_COD,SA6->A6_AGENCIA, SA6->A6_NUMCON, SA6->A6_NOME})
               
		       aBanco := ASORT(aBanco, , , { | x,y | x[2] < y[2] } )           	
		       
            ENDIF
         
		    SA6->(dbSkip())
		Enddo
		
	ListBoxMar(aBanco)                    

Return lRet

Static Function ListBoxMar(aVetor)

Local cVar     := Nil
Local oDlg     := Nil
Local cTitulo  := "Consulta Bancos"
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local aBanco   := {}
Local oChk     := Nil
Local lMarca   := .T. 
Local cNrom	   := ""
Local nLinha	:= 0  
Local nTotLinha	:= 0  
Local nI := 0 // Banco                     
Local nJ := 0 // Agencia
Local nL := 0 // Conta
Private lChk   := .F.
Private oLbx   := Nil

aVetor1 := aVetor 

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor1 ) == 0
   Aviso( cTitulo, "Nao existe Bancos a consultar", {"Ok"} )
Else


DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
   
@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER ;
   " ", "Codigo", "Nro Agencia", "Nro Conta", "Nome Red Banco";
   SIZE 230,095 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())

oLbx:SetArray( aVetor1 )
oLbx:bLine := {|| {Iif(aVetor1[oLbx:nAt,1],oOk,oNo),;
                       aVetor1[oLbx:nAt,2],;
                       aVetor1[oLbx:nAt,3],;
                       aVetor1[oLbx:nAt,4],;
                       aVetor1[oLbx:nAt,5]}}
	 

@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ;
         ON CLICK(aEval(aVetor1,{|x| x[1]:=lChk}),oLbx:Refresh())

DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER
                                                   
Endif               

For nI := 1 to len(aVetor1)       
	If aVetor1[nI][1] = .T.
		AADD(aBanco,{aVetor1[nI][2], aVetor1[nI][3],aVetor1[nI][4] })
    EndIf
Next nI

nbanco := len(abanco)

MV_PAR03 := ""
MV_PAR04 := ""
MV_PAR05 := ""

For nI := 1 to len(abanco)        
	If nI = 1
		MV_PAR03 += abanco[nI][1]
		MV_PAR04 += abanco[nI][2]
		MV_PAR05 += abanco[nI][3]
	Else                         
		MV_PAR03 += "'" + "," + "'" + abanco[nI][1]
		MV_PAR04 += "'" + "," + "'" + abanco[nI][2]
		MV_PAR05 += "'" + "," + "'" + abanco[nI][3]	
	EndIf	
Next nI

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINR199   �Autor  �Adrianne Furtado    � Data �  11/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime o relatorio de baixas quando escolhida a ordem por ���
���          � por natureza no FINR190, devido a implementacao de         ���
���          � multiplas naturezas por baixa de titulos                   ���
�������������������������������������������������������������������������͹��
���Uso       � FINR190                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION zFinr199(nGerOrig	,nGerValor	,nGerDesc	,nGerJurMul	,nGerCM		,nGerAbLiq,;
			     nGerAbImp	,nGerBaixado,nGerMovFin	,nGerComp	,nFilOrig	,nFilValor,;
			     nFilDesc	,nFilJurMul	,nFilCM		,nFilAbLiq	,nFilAbImp	,nFilBaixado,;
			     nFilMovFin	,nFilComp	,lEnd		,cCondicao	,cCond2		,aColu,;
			     lContinua	,cFilSE5	,lAsTop		,tamanho	,aRet		,aTotais, nOrdem, nGerFat, nFilFat,lNovaGestao)

Local aAreaSm0	:= SM0->(GetArea())
Local aAreaSe5	:= SE5->(GetArea())
Local aStru		:= SE5->(DbStruct())
Local aSaldo	:= {}
Local nValNat
Local nVBxNat
Local nJurNat
Local nAbtNat
Local nAbImpNat
Local nMulNat
Local nCmoNat
Local nDesNat
Local nTamCliFor	:= TamSx3("E5_CLIFOR")[1]
Local nValor	  	:= 0
Local nDesc		  	:= 0
Local nJuros	  	:= 0
Local nAbat 	  	:= 0
Local nCM		  	:= 0
Local nMulta	  	:= 0
Local nVlr 		  	:= 0
Local nVlMovFin  	:= 0
Local cArqTmp
Local nTotOrig   	:= 0
Local nTotValor  	:= 0
Local nTotDesc   	:= 0
Local nTotJurMul 	:= 0
Local nTotCm 	  	:= 0
Local nTotMulta  	:= 0
Local nTotAbat   	:= 0
Local nTotImp 	  	:= 0
Local nTotBaixado 	:= 0
Local nTotMovFin  	:= 0
Local nTotComp    	:= 0
Local nTotFat    	:= 0
Local nTotAbImp   	:= 0
Local cAnterior
Local cCliFor190  	:= ""
Local cCliFor
Local nDecs	  	   	:= GetMv("MV_CENT"+(IIF(mv_par13 > 1 , STR(mv_par13,1),"")))
Local nMoedaBco   	:= 1
Local cCarteira
Local lManual 	   	:=.F.
Local cBanco
Local cNatureza
Local nCT		   	:= 0
Local dDigit
Local cLoja
Local lBxTit	   	:=.F.
Local cHistorico
Local nRecSe5 	   	:= 0
Local dDtMovFin
Local cRecPag
Local cMotBaixa   	:= CRIAVAR("E5_MOTBX")
Local cFilTrb
Local cChave
Local cFilOrig
Local nX 		:= 0
Local nY 		:= 0
Local lTemTit	:=.T.
Local lAchouEmp := .T.
Local lAchouEst := .F.
Local nTamEH    := TamSx3("EH_NUMERO")[1]
Local nTamEI    := TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local lAjuPar15 := Len(AllTrim(mv_par15))==Len(mv_par15)
Local aImpresso := {}
Local nAscan
Local nRecno
Local nSavOrd
Local lAchou
Local nTamRet	:= 0
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"

Local lUltBaixa := .F.
Local cChaveSE1 := ""
Local cChaveSE5 := ""
Local cSeqSE5	:= ""

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissao(default))
Local lPccBxCr	:= FPccBxCr()
Local nPccBxCr	:= 0
Local nPccBxNat := 0
Local cNatur199	:= ""
Local cCodUlt	:= SM0->M0_CODIGO
Local cFilUlt	:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local cEmpresa	:= IIF(lUnidNeg,FWCodEmp(),"")
Local nAbatLiq  := 0
/* GESTAO - inicio */
Default lNovaGestao := .F.
/* GESTAO - fim */
//Campos adicionais para o arquivo temporario
//E5_VALTIT = Valor do titulo
//E5_VLABLIQ = Valor dos abatimentos
//E5_VLABIMP = Valos dos abatimentos de impostos
AADD(aStru,{"E5_VALTIT","N",17,2})
AADD(aStru,{"E5_VLMOVFI","N",17,2})
AADD(aStru,{"E5_VLABLIQ","N",17,2})
AADD(aStru,{"E5_VLABIMP","N",17,2})

cArqTmp := CriaTrab(aStru,.T.) //  Cria um arquivo com a mesma estrutura do SE1
dbUseArea(.T.,__LocalDriver,cArqTmp,"cArqTmp",.T.)

If FunName() == "FINR190"
	IndRegua( "cArqTmp",cArqTmp,cChaveInterFun)  //"Selecionando Registros..."
Else
	IndRegua( "cArqTmp",cArqTmp,"E5_FILIAL+E5_NATUREZ+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA")  //"Selecionando Registros..."
Endif

//titulo := titulo + OemToAnsi(STR0021)  //" - Por Natureza"
DbSelectArea("NEWSE5")

// Gera o arquivo temporario por natureza
cE5Filial   := NEWSE5->E5_FILIAL
While NEWSE5->(!Eof()) .And. NEWSE5->E5_FILIAL==xFilial("SE5") .And. &cCondicao .and. lContinua

	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

	If NEWSE5->E5_FILIAL<>xFilial("SE5")
		NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
		Loop
	Endif

	DbSelectArea("NEWSE5")
	// Testa condicoes de filtro
	If !zFr190TstCond(cFilSe5,.F.)
		NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
		Loop
	Endif

	If lUnidNeg .and. (cEmpresa	<> FWCodEmp())
		SM0->(DbSkip())
		Loop
	Endif

	If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
		(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
		cCarteira := "R"
	Else
		cCarteira := "P"
	Endif

	dbSelectArea("NEWSE5")
	cAnterior 	:= &cCond2
	nTotValor	:= 0
	nTotDesc	:= 0
	nTotJurMul	:= 0
	nTotMulta	:= 0
	nTotCM		:= 0
	nCT			:= 0
	nTotOrig	:= 0
	nTotBaixado	:= 0
	nTotAbat  	:= 0
	nTotImp  	:= 0
	nTotMovFin	:= 0
	nTotComp	:= 0
	nTotFat		:= 0

	While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. NEWSE5->E5_FILIAL=xFilial("SE5") .and. lContinua

		lManual := .f.
		lTemTit:=.T.
		dbSelectArea("NEWSE5")

		If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par17 == 1) .Or.;
			(Empty(NEWSE5->E5_NUMERO)  .And. mv_par17 == 1)
			lManual := .t.
		EndIf

		// Testa condicoes de filtro
		If !zFr190TstCond(cFilSe5,.T.)
			dbSelectArea("NEWSE5")
			NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
			Loop
		Endif


		// testa mv_par37 (Imp. mov. cheque aglutinado?Cheque/Baixa/Ambos)
		If ((mv_par38 == 1) .And. ;
		   ((NEWSE5->E5_TIPODOC == "VL") .Or. (NEWSE5->E5_TIPODOC == "BA"))) //somente cheques

			nRecno  := SE5->(Recno())
			nSavOrd := SE5->(INDEXORD())

			SE5->(dbSetOrder(11))
			SE5->(MsSeek(xFilial("SE5")+NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)))
			cChave := SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
			lAchou := .F.

			// Procura o cheque aglutinado, se encontrar despreza o movimento bancario
			WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChave
				If SE5->E5_TIPODOC == "CH"
					lAchou := .T.
					Exit
				Endif
				SE5->(dbSkip())
			Enddo

			SE5->(DbSetOrder(nSavOrd))
			SE5->(dbGoTo(nRecno))
			// Achou cheque aglutinado para a baixa, despreza o registro
			If lAchou
				NEWSE5->(dbSkip())
				Loop
			Endif

		ElseIf ((mv_par38 == 2) .And. (NEWSE5->E5_TIPODOC == "CH")) //somente baixas

			nRecno  := SE5->(Recno())
			nSavOrd := SE5->(INDEXORD())

			SE5->(dbSetOrder(11))
			SE5->(MsSeek(xFilial("SE5")+NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)))
			cChave := SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
			lAchou := .F.

			// Procura a baixa aglutinada, se encontrar despreza o movimento bancario
			WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChave
				If SE5->E5_TIPODOC $ "BA#VL"
					lAchou := .T.
					Exit
				Endif
				SE5->(dbSkip())
			Enddo

			SE5->(DbSetOrder(nSavOrd))
			SE5->(dbGoTo(nRecno))
			// Achou cheque aglutinado para a baixa, despreza o registro

			If lAchou
				NEWSE5->(dbSkip())
				Loop
			Endif
		Endif

		cNumero    	:= NEWSE5->E5_NUMERO
		cPrefixo   	:= NEWSE5->E5_PREFIXO
		cParcela   	:= NEWSE5->E5_PARCELA
		dBaixa     	:= NEWSE5->E5_DATA
		cBanco     	:= NEWSE5->E5_BANCO
		cNatureza  	:= NEWSE5->E5_NATUREZ
		cCliFor    	:= NEWSE5->E5_BENEF
		cLoja      	:= NEWSE5->E5_LOJA
		cSeq       	:= NEWSE5->E5_SEQ
		cNumCheq   	:= NEWSE5->E5_NUMCHEQ
		cRecPag	 	:= NEWSE5->E5_RECPAG
		cMotBaixa	:= NEWSE5->E5_MOTBX
		cCheque    	:= NEWSE5->E5_NUMCHEQ
		cTipo      	:= NEWSE5->E5_TIPO
		cFornece   	:= NEWSE5->E5_CLIFOR
		cLoja      	:= NEWSE5->E5_LOJA
		dDigit     	:= NEWSE5->E5_DTDIGIT
		lBxTit	  	:= .F.
		cFilorig    := NEWSE5->E5_FILORIG

		If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
			(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
			dbSelectArea("SE1")
			dbSetOrder(1)
			lBxTit := MsSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo)
			If !lBxTit
				lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
			Endif
			cCarteira := "R"
			dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
			While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
				If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
					Exit
				Endif
				SE1->( dbSkip() )
			EndDo
			If !SE1->(EOF()) .And. mv_par12 == 1 .and. !lManual .and.  ;
				(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
				cExp := "NEWSE5->E5_SITCOB"

				If mv_par36 == 2 //era mv_par35
					mv_par15:=AllTrim(mv_par15)
				EndIf

				If (NEWSE5->E5_RECPAG == "R") .And. lAjuPar15
					mv_par15  += " "
				Endif

				cExp += " $ mv_par15"
				If !(&cExp)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif
			Endif

			cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
			nDesc := nJuros := nValor := nMulta := nCM := nVlMovFin := 0
		Else
			dbSelectArea("SE2")
			DbSetOrder(1)
			cCarteira := "P"
			lBxTit := MsSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
			If !lBxTit
				lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
			Endif
			dDtMovFin := IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.T.))
			cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
			nDesc := nJuros := nValor := nMulta := nCM := nVlMovFin := 0
			cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
		Endif
		dbSelectArea("NEWSE5")
		cHistorico := Space(40)
		While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. NEWSE5->E5_FILIAL==xFilial("SE5")

			dbSelectArea("NEWSE5")

			lAchouEmp := .T.
			lAchouEst := .F.

			// Testa condicoes de filtro
			If !zFr190TstCond(cFilSe5,.T.)
				dbSelectArea("NEWSE5")
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Endif

			If NEWSE5->E5_SITUACA $ "C/E/X"
				dbSelectArea("NEWSE5")
				NEWSE5->( dbSkip() )
				Loop
			EndIF

			If NEWSE5->E5_LOJA != cLoja
				Exit
			Endif

			If NEWSE5->E5_FILORIG < mv_par34 .or. NEWSE5->E5_FILORIG > mv_par35
				dbSelectArea("NEWSE5")
				NEWSE5->( dbSkip() )
				Loop
			Endif

			//���������������������������������������������������Ŀ
			//� Nao imprime os registros de emprestimos excluidos �
			//�����������������������������������������������������
			If NEWSE5->E5_TIPODOC == "EP"
				aAreaSE5 := NEWSE5->(GetArea())
				dbSelectArea("SEH")
				dbSetOrder(1)
				lAchouEmp := MsSeek(xFilial("SEH")+Substr(NEWSE5->E5_DOCUMEN,1,nTamEH))
				RestArea(aAreaSE5)
				If !lAchouEmp
					NEWSE5->(dbSkip())
					Loop
				EndIf
			EndIf

			//�����������������������������������������������������������������Ŀ
			//� Nao imprime os registros de pagamento de emprestimos estornados �
			//�������������������������������������������������������������������
			If NEWSE5->E5_TIPODOC == "PE"
				aAreaSE5 := NEWSE5->(GetArea())
				dbSelectArea("SEI")
				dbSetOrder(1)
				If	MsSeek(xFilial("SEI")+"EMP"+Substr(NEWSE5->E5_DOCUMEN,1,nTamEI))
					If SEI->EI_STATUS == "C"
						lAchouEst := .T.
					EndIf
				EndIf
				RestArea(aAreaSE5)
				If lAchouEst
					NEWSE5->(dbSkip())
					Loop
				EndIf
			EndIf

			//�����������������������������Ŀ
			//� Verifica o vencto do Titulo �
			//�������������������������������
			cFilTrb := If(mv_par12==1,"SE1","SE2")
			If (cFilTrb)->(!Eof()) .And.;
				((cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") < mv_par32 .Or. (!Empty(mv_par33) .And. (cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") > mv_par33))
				dbSelectArea("NEWSE5")
				NEWSE5->(dbSkip())
				Loop
			Endif

			dBaixa     	:= NEWSE5->E5_DATA
			cBanco     	:= NEWSE5->E5_BANCO
			cNatureza  	:= NEWSE5->E5_NATUREZ
			cCliFor    	:= NEWSE5->E5_BENEF
			cSeq       	:= NEWSE5->E5_SEQ
			cNumCheq   	:= NEWSE5->E5_NUMCHEQ
			cRecPag		:= NEWSE5->E5_RECPAG
			cMotBaixa	:= NEWSE5->E5_MOTBX
			cTipo190		:= NEWSE5->E5_TIPO

			//��������������������������������������������������������������Ŀ
			//� Obter moeda da conta no Banco.                               �
			//����������������������������������������������������������������
			If cPaisLoc	# "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
				SA6->(DbSetOrder(1))
				SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
				nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
			Else
				nMoedaBco	:=	1
			Endif

			If !Empty(NEWSE5->E5_NUMERO)
				If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
					(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG)
					dbSelectArea( "SA1")
					dbSetOrder(1)
					If MsSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
						cCliFor := Iif(mv_par31==1,SA1->A1_NREDUZ,SA1->A1_NOME)
					EndIF
				Else
					dbSelectArea( "SA2")
					dbSetOrder(1)
					If MSSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
						cCliFor := Iif(mv_par31==1,SA2->A2_NREDUZ,SA2->A2_NOME)
					EndIF
				EndIf
			EndIf

			dbSelectArea("SM2")
			dbSetOrder(1)
			dbSeek(NEWSE5->E5_DATA)
			dbSelectArea("NEWSE5")
			nRecSe5:=If(lAsTop,NEWSE5->SE5RECNO,Recno())

			nDesc+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
			nJuros+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
			nMulta+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
			nCM+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))

			If lPccBaixa .and. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL)
				nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)
			Endif

			If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
				cHistorico := NEWSE5->E5_HISTOR
				nValor+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))

				//Pcc Baixa CR
				If cCarteira == "R" .and. lPccBxCr .and. cPaisLoc == "BRA"
					If Empty(NEWSE5->E5_PRETPIS)
						nPccBxCr += Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VRETPIS,Round(xMoeda(NEWSE5->E5_VRETPIS,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
					Endif
					If Empty(NEWSE5->E5_PRETCOF)
						nPccBxCr += Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VRETCOF,Round(xMoeda(NEWSE5->E5_VRETCOF,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
					Endif
					If Empty(NEWSE5->E5_PRETCSL)
						nPccBxCr += Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VRETCSL,Round(xMoeda(NEWSE5->E5_VRETCSL,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
					Endif
				Endif

			Else
				nVlMovFin+=Iif(mv_par13==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par13,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
				cNatureza  	:= NEWSE5->E5_NATUREZ
			Endif
			dbSkip()
			If lManual		// forca a saida do looping se for mov manual
				Exit
			Endif
		EndDO

		If (nDesc+nValor+nJuros+nCM+nMulta+nVlMovFin) > 0
			//������������������������������Ŀ
			//� Calculo do Abatimento        �
			//��������������������������������
			If cCarteira == "R" .and. !lManual
				dbSelectArea("SE1")
				nRecno 		:= Recno()
				nTotAbImp 	:= 0
				nAbatLiq 	:= 0
				lUltBaixa 	:= .F.

				aAreaSE1 := SE1->(GetArea())
				dbSelectArea("SE5")
				dbSetOrder(7)
				cChaveSE1 := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
				SE5->(MsSeek(xFilial("SE5")+cChaveSE1))

				cSeqSE5 := SE5->E5_SEQ

				While SE5->(!EOF()) .And. cChaveSE1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
					If SE5->E5_SEQ > cSeqSE5
						cSeqSE5 := SE5->E5_SEQ
					Endif
					SE5->(dbSkip())
				Enddo

				SE5->(MsSeek(xFilial("SE5")+cChaveSE1+cSeqSE5))
				cChaveSE5 := cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq

				If cChaveSE5 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) .And.;
					Empty(SE1->E1_SALDO)
					lUltBaixa := .T.
				EndIf

				If lUltBaixa
					nAbat := SumAbatRec(cPrefixo,cNumero,cParcela,SE1->E1_MOEDA,"V",dBaixa,@nTotAbImp)
					nAbatLiq := nAbat - nTotAbImp
				EndIf

				lUltBaixa := .F.
				RestArea(aAreaSE1)
				dbSelectArea("SE1")
				dbGoTo(nRecno)
				cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
				nVlr:= SE1->E1_VLCRUZ
				If mv_par13 > 1
					nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par13,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDesc+1)
				EndIF
				If mv_par14 == 1  // Utilizar o Historico da Baixa ou Emissao
					cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
				Else
					cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
				Endif
				dbSelectArea("SE5")
				dbgoto(nRecSe5)
			Elseif !lManual
				dbSelectArea("SE2")
				nRecno := Recno()
				nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par13,,cFornece,cLoja)
				nAbatLiq := nAbat
				dbSelectArea("SE2")
				dbGoTo(nRecno)
				cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
				nVlr:= SE2->E2_VLCRUZ
				If mv_par13 > 1
					nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par13,SE2->E2_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
				Endif
				If mv_par14 == 1  // Utilizar o Historico da Baixa ou Emissao
					cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
				Else
					cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
				Endif
				dbSelectArea("SE5")
				dbgoto(nRecSe5)
			Else
				nAbatLiq := 0
				lTemTit:=.F.
				dbSelectArea("SE5")
				dbgoto(nRecSe5)
				nVlr := Iif(mv_par13==1.And.nMoedaBco==1,SE5->E5_VALOR,Round(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par13,SE5->E5_DATA,nDecs+1,If(cPaisLoc=="BRA",SE5->E5_TXMOEDA,0)),nDecs+1))
			EndIF

			//Calcula a multnat para cada baixa, se houver
			lMultNat := .F.
			If !lManual
				dbSelectArea("SEV")
				dbSetOrder(2)
				cChave:= xFilial("SEV")+cPrefixo+cNumero+cParcela+cTipo+cCliFor190+"2"+cSeq
				bWhile := { || .F. }
				If dbSeek(cChave)
					lMultNat := .T.
					bWhile := { || cChave == xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_IDENT+SEV->EV_SEQ) }
				Else
					// Pesquisa pela distribuicao mult. natureza na emissao, sem a sequencia da baixa
					cChave:= xFilial("SEV")+cPrefixo+cNumero+cParcela+cTipo+cCliFor190+"1"
					If dbSeek(cChave)
						lMultNat := .T.
						bWhile := { || cChave == xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_IDENT) }
					Endif
				Endif
				If lMultNat
					aSaldo := {}
					While Eval(bWhile)
						If SEV->EV_RECPAG == cCarteira .AND. !(SEV->EV_SITUACA $ "X/E")
							nValNat 	 := nVlr //* SEV->EV_PERC
							nVBxNat 	 := nValor * SEV->EV_PERC
							nJurNat 	 := nJuros * SEV->EV_PERC
							nAbtNat 	 := nAbatLiq * SEV->EV_PERC
							nAbImpNat := nTotAbImp * SEV->EV_PERC
							nMulNat   := nMulta * SEV->EV_PERC
							nCmoNat   := nCm * SEV->EV_PERC
							nDesNat   := nDesc * SEV->EV_PERC
							nPccBxNat := nPccBxCr * If(Select("TMPSEV") > 0,TMPSEV->EV_PERC,SEV->EV_PERC)	//Pcc Baixa CR
							AADD(aSaldo,{SEV->EV_NATUREZ,nValNat,nVBxNat,nJurNat,nMulNat,nDesNat,nCmoNat,nAbtNat,nAbImpNat,nVlMovFin,SE5->E5_NATUREZ,nPccBxNat})
						Endif
						SEV->(DbSkip())
						Loop
					Enddo
				Endif
			Endif
			//PCC Baixa CR
			//Somo aos abatimentos de impostos, os impostos PCC na baixa.
			//Caso o calculo do PCC CR seja pela emissao, esta variavel estara zerada
			nTotAbImp := nTotAbImp + nPccBxCR

			If !lMultNat .and. !lManual
				AADD(aSaldo,{cNatureza,nVlr,nValor,nJuros,nMulta,nDesc,nCm,nAbatLiq,nTotAbImp,nVlMovFin,cNatureza,nPccBxCr})
			ElseIf lManual
				AADD(aSaldo,{cNatureza,nVlr,nVlMovFin,nJuros,nMulta,nDesc,nCm,nAbatLiq,nTotAbImp,nVlMovFin,cNatureza,nPccBxCr})
			Endif
			DbSelectArea("cArqTmp")
			For nX := 1 To Len( aSaldo )
				//Verifico a Natureza e gravo no ArqTmp

				If (aSaldo[nX][1] >= MV_PAR06 .And. aSaldo[nX][1]<= MV_PAR07) .or.;
				   (aSaldo[nX][11] >= MV_PAR06 .And. aSaldo[nX][11]<= MV_PAR07)

					RecLock("cArqTmp",.T.) //DbAppend()
					For nY := 1 To SE5->(fCount())
						cArqTmp->(FieldPut(nY,SE5->(FieldGet(nY))))
					Next
					cArqTmp->E5_NATUREZ	:= aSaldo[nX][1]
					cArqTmp->E5_VALTIT	:= aSaldo[nX][2]
					cArqTmp->E5_VALOR   := aSaldo[nX][3]
					cArqTmp->E5_VLJUROS	:= aSaldo[nX][4]
					cArqTmp->E5_VLMULTA	:= aSaldo[nX][5]
					cArqTmp->E5_VLDESCO	:= aSaldo[nX][6]
					cArqTmp->E5_VLCORRE	:= aSaldo[nX][7]
					cArqTmp->E5_VLABLIQ	:= aSaldo[nX][8]
					cArqTmp->E5_VLABIMP	:= aSaldo[nX][9] //+ aSaldo[nX][12]
					cArqTmp->E5_VLMOVFI	:= aSaldo[nX][10]
					cArqTmp->E5_VENCTO	:= dDtMovFin
					cArqTmp->E5_HISTOR	:= cHistorico
				Endif
			Next
			aSaldo := {}
			nDesc := nJuros := nValor := nMulta := nCM := nAbatLiq := nTotAbImp := nVlMovFin := 0
			nPccBxCr := 0		//Pcc Baixa CR
			li++
			dbSelectArea("SE5")
//			cE5Filial := NEWSE5->E5_FILIAL
			dbSkip()
		Endif
		dbSelectArea("NEWSE5")
	Enddo
Enddo
dbSelectArea("cArqTmp")
dbGoTop()
If !EOF() .and. !BOF()
	While !Eof()
		If FunName() == "FINR190"
			If ((MV_MULNATR .and. mv_par12 = 1 .and. mv_par39 = 2 .and. !mv_par40 == 2) .or. (MV_MULNATP .and. mv_par12 = 2 .and. mv_par39 = 2 .and. !mv_par40 == 2) )
				/*cAnterior := cArqTmp->(E5_NATUREZ)
				cCondLaco := "E5_NATUREZ"*/
				cAnterior := cArqTmp->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)
				cCondLaco := "E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO"
			Else
				cAnterior    := cArqTmp->(&cCond2)
				cCondLaco    := cCond2
			EndIf
		Else
			cAnterior := cArqTmp->(E5_NATUREZ)
			cCondLaco := "E5_NATUREZ"
		Endif
		While !Eof() .and. cAnterior == cArqTmp->(&cCondLaco)
			If cCondLaco == "E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO" .And. FunName() == "FINR190"
				If cArqTmp->(E5_NATUREZ) < mv_par06 .Or. cArqTmp->(E5_NATUREZ) > mv_par07
					cArqTmp->(dbSkip())
					Loop
				EndIf
			EndIf
			cNatur199 := ""
			AAdd(aRet, Array(31))
			nTamRet := Len(aRet)
			aRet[nTamRet][22] := cArqTmp->(E5_FILIAL) + " - " + FwFilName(cEmpAnt,cArqTmp->(E5_FILIAL))
			aRet[nTamRet][23] := cArqTmp->(E5_BENEF)
			aRet[nTamRet][24] := cArqTmp->(E5_LOTE)
			aRet[nTamRet][25] := cArqTmp->(E5_DTDISPO)

			cMotBaixa := cArqTmp->(E5_MOTBX)
			lManual := .F.
			If Empty(cArqTmp->E5_TIPODOC) .Or. Empty(cArqTmp->E5_NUMERO)
				lManual := .t.
			EndIf

			IF nTamCliFor > 6 .and. !lManual
				aRet[nTamRet][05] := cArqTmp->(E5_CLIFOR)
				aRet[nTamRet][06] := SUBSTR(cArqTmp->(E5_BENEF),1,18)
				li++
			Endif

			aRet[nTamRet][01] := cArqTmp->(E5_PREFIXO)
			aRet[nTamRet][02] := cArqTmp->(E5_NUMERO)
			aRet[nTamRet][03] := cArqTmp->(E5_PARCELA)
			aRet[nTamRet][04] := cArqTmp->(E5_TIPO)

			If nTamCliFor <= 6 .and. !lManual
				aRet[nTamRet][05] := cArqTmp->(E5_CLIFOR)
				aRet[nTamRet][06] := SUBSTR(cArqTmp->(E5_BENEF),1,18)
			Endif
			aRet[nTamRet][07] := cArqTmp->(E5_NATUREZ)
			aRet[nTamRet][08] := cArqTmp->(E5_VENCTO)

			If !Empty(cArqTmp->(E5_NUMCHEQ))
				aRet[nTamRet][09] := SubStr(ALLTRIM(cArqTmp->(E5_NUMCHEQ))+"/"+Trim(cArqTmp->(E5_HISTOR)),1,18)
			Else
				aRet[nTamRet][09] := SubStr(cArqTmp->(E5_HISTOR),1,40)
			Endif

			aRet[nTamRet][10] := cArqTmp->(E5_DATA)

			IF cArqTmp->(E5_VALTIT) > 0
				aRet[nTamRet][11] := cArqTmp->(E5_VALTIT) //Picture tm(cArqTmp->(E5_VALTIT),14,nDecs)
			Endif

			nJurMul := cArqTmp->(E5_VLJUROS) + cArqTmp->(E5_VLMULTA)

			nCT++
			aRet[nTamRet][12] := nJurMul 				//PicTure tm(cArqTmp->(E5_VLJUROS),12,nDecs)
			aRet[nTamRet][13] := cArqTmp->(E5_VLCORRE) 	//PicTure tm(cArqTmp->(E5_VLCORRE),12,nDecs)
			aRet[nTamRet][14] := cArqTmp->(E5_VLDESCO) 	//PicTure tm(cArqTmp->(E5_VLDESCO),12,nDecs)
			aRet[nTamRet][15] := cArqTmp->(E5_VLABLIQ) 	//Picture tm(cArqTmp->(E5_VLABLIQ) ,12,nDecs)
			aRet[nTamRet][16] := cArqTmp->(E5_VLABIMP) 	//Picture tm(cArqTmp->(E5_VLABIMP) ,12,nDecs)
			aRet[nTamRet][17] := cArqTmp->(E5_VALOR)	//PicTure tm(cArqTmp->(E5_VALOR)  ,14,nDecs)
			aRet[nTamRet][18] := cArqTmp->(E5_BANCO)
			aRet[nTamRet][19] := cArqTmp->(E5_DTDIGIT)
			aRet[nTamRet][20] := IF(Empty(cArqTmp->(E5_MOTBX)),"NOR",cArqTmp->(E5_MOTBX))
			aRet[nTamRet][21] := cArqTmp->(E5_FILORIG)

			nAscan := aScan(aImpresso, cArqTmp->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+If(nOrdem == 3,cArqTmp->E5_NATUREZ,'')) )
			aRet[nTamRet][26] := If(nAscan = 0,.T.,.F.)
			aRet[nTamRet][27] := If( cArqTmp->(E5_VLMOVFI) <> 0, cArqTmp->(E5_VLMOVFI) , If(MovBcoBx(cMotBaixa),cArqTmp->(E5_VALOR),0))
			aRet[nTamRet][28] := If(aScan(aImpresso, cArqTmp->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) ) = 0,.T.,.F.)
			aRet[nTamRet][30] := cArqTmp->(E5_AGENCIA)
			aRet[nTamRet][31] := cArqTmp->(E5_CONTA)

			//Busca no se5 o recno original do registro para abastecer no array
			nRecnoSe5 := SE5->(Recno())
			SE5->(dbSetorder(7))
			SE5->(dbseek(cArqTmp->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)))
			aRet[nTamRet][29] := SE5->(Recno())
			SE5->(dbGoto(nRecnoSe5))
			SE5->(dbSetorder(1))

			nTotOrig   	+= If(nAscan = 0,cArqTmp->(E5_VALTIT),0)
			nGerOrig    += If(aScan(aImpresso, cArqTmp->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))=0,cArqTmp->(E5_VALTIT),0)
			nFilOrig   	+= If(aScan(aImpresso, cArqTmp->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))=0,cArqTmp->(E5_VALTIT),0)
			nTotBaixado += Iif(lManual .or. (cArqTmp->(E5_TIPODOC) $ "CP/BA" .AND. cArqTmp->(E5_MOTBX) $ "CMP/FAT"),0,cArqTmp->(E5_VALOR))		// nao soma, j� somou no principal
			nTotDesc   	+= cArqTmp->(E5_VLDESCO)
			nTotJurMul 	+= nJurMul
			nTotCM     	+= cArqTmp->(E5_VLCORRE)
			nTotAbat   	+= cArqTmp->(E5_VLABLIQ)
			nTotImp    	+= cArqTmp->(E5_VLABIMP)
			nTotValor  	+= If( cArqTmp->(E5_VLMOVFI) <> 0, cArqTmp->(E5_VLMOVFI) , If(MovBcoBx(cMotBaixa),cArqTmp->(E5_VALOR),0))
			nTotMovFin 	+= If(lManual,cArqTmp->(E5_VLMOVFI),0)
			nTotComp	+= If(cArqTmp->(E5_TIPODOC) == "CP",cArqTmp->(E5_VALOR),0)
			nTotFat	    += Iif(cArqTmp->(E5_MOTBX) == "FAT",cArqTmp->(E5_VALOR),0)

			If !lManual
				Aadd(aImpresso, cArqTmp->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_NATUREZ+If(nOrdem == 3,cArqTmp->E5_NATUREZ,'')) )
			Endif
			cNatur199 := cArqTmp->(E5_NATUREZ)
			cArqTmp->(dbSkip())

		Enddo

		If (nTotValor+nDesc+nJuros+nCM+nTotMulta+nTotOrig+nTotMovFin+nTotComp+nTotFat)>0

			cQuebra := cArqTmp->(E5_NATUREZ)

		  	If nTotBaixado > 0
				AAdd(aTotais,{cQuebra,"Baixados",nTotBaixado,cArqTmp->(E5_DATA)})  //STR0028
			Endif
			If nTotMovFin > 0
				AAdd(aTotais,{cQuebra,"Baixados",nTotMovFin,cArqTmp->(E5_DATA)})  //STR0031
			Endif
			If nTotComp > 0
				AAdd(aTotais,{cQuebra,"Compensados",nTotComp,cArqTmp->(E5_DATA)})  //STR0037
			Endif
			If nTotFat > 0
				AAdd(aTotais,{cQuebra,"Bx.Fatura" ,nTotFat,cArqTmp->(E5_DATA)})  //STR0076
			Endif
		Endif                                                                   k
		//�������������������������Ŀ
		//�Incrementa Totais Gerais �
		//���������������������������
//		nGerOrig		+= nTotOrig
		nGerValor	+= nTotValor
		nGerDesc		+= nTotDesc
		nGerJurMul	+= nTotJurMul
		nGerCM		+= nTotCM
		nGerAbLiq	+= nTotAbat
		nGerAbImp	+= nTotImp
		nGerBaixado += nTotBaixado
		nGerMovFin  += nTotMovFin
		nGerComp    += nTotComp
		nGerFat     += nTotFat
		//�������������������������Ŀ
		//�Incrementa Totais Filial �
		//���������������������������
//		nFilOrig		+= nTotOrig
		nFilValor	+= nTotValor
		nFilDesc		+= nTotDesc
		nFilJurMul	+= nTotJurMul
		nFilCM		+= nTotCM
		nFilAbLiq	+= nTotAbat
		nFilAbImp	+= nTotImp
		nFilBaixado += nTotBaixado
		nFilMovFin	+= nTotMovFin
		nFilComp	+= nTotComp
		nFilFat		+= nTotFat

		nTotValor	:= 0
		nTotDesc		:= 0
		nTotJurMul	:= 0
		nTotMulta	:= 0
		nTotCM		:= 0
		nCT			:= 0
		nTotOrig		:= 0
		nTotBaixado	:= 0
		nTotAbat		:= 0
		nTotImp		:= 0
		nTotMovFin	:= 0
		nTotComp		:= 0
		nTotFat		:= 0

		dbSelectArea("cArqTmp")
	EndDo
Endif

DbSelectArea("SM0")
DbSeek(cEmpAnt+cFilAnt,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilNome:= SM0->M0_FILIAL

	If lUnidNeg .AND. (cEmpresa	<> FWCodEmp())
		SM0->(DbSkip())
		Loop
	Endif
	//����������������������������������������Ŀ
	//� Imprimir TOTAL por filial somente quan-�
	//� do houver mais do que 1 filial.        �
	//������������������������������������������
	if mv_par18 == 1 .and. SM0->(Reccount()) > 1
		If nFilBaixado > 0
			AAdd(aTotais,{IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ),"Baixados",nFilBaixado})  //STR0028
		Endif
		If nFilMovFin > 0
			AAdd(aTotais,{IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ),"Mov Fin.",nFilMovFin})  //STR0031
		Endif
		If nFilComp > 0
			AAdd(aTotais,{IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ),"Compens.",nFilComp})  //STR0037
		Endif
		If nFilFat > 0
			AAdd(aTotais,{IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ),"Bx. Fatura",nFilFat})  //STR0076
		Endif

		If Empty(FwFilial("SE5"))
			Exit
		Endif

		nFilOrig:=nFilJurMul:=nFilCM:=nFilDesc:=nFilAbLiq:=nFilAbImp:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=nFilFat:=0
	Endif
	dbSelectArea("SM0")
	cCodUlt := SM0->M0_CODIGO
	cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	dbSkip()

Enddo

If (lNovaGestao .Or. (mv_par18 == 1 .and. SM0->(Reccount()) > 1)) .And. !Empty(cE5Filial)
	DbSelectArea("SM0")
	DbSeek(cCodUlt+cE5Filial,.T.)
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
EndIf
//�����������������������������Ŀ
//� Apaga arquivos temporarios  �
//�������������������������������
dbSelectarea("cArqTmp")
cArqTmp->( dbCloseArea() )
FErase(cArqTmp+OrdBagExt())
FErase(cArqTmp+GetDbExtension())

RestArea(aAreaSm0)
SE5->(RestArea(aAreaSe5))

Return aRet