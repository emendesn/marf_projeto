#INCLUDE "ATFA070.CH"
//#INCLUDE "PROTHEUS.CH"
//#include "rwmake.ch"
//#include "topconn.ch"
#include "totvs.ch"

//********************************
// Controle de multiplas moedas  *
//********************************
Static lMultMoed := .T.
Static lFWCodFil := .T.

Static __lStruPrj
STATIC lIsRussia	:= If(cPaisLoc$"RUS",.T.,.F.) // CAZARINI - Flag to indicate if is Russia location

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun��o    � ATFA070  � Autor � Vin�cius Barreira           � Data � 21/11/94 ���
�������������������������������������������������������������������������������Ĵ��
���Descri��o � DesCalculo de deprecia��o e corre��o monet�ria do Ativo Imob.    ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                         ���
�������������������������������������������������������������������������������Ĵ��
���                            ATUAIZACOES SOFRIDAS                             ���
�������������������������������������������������������������������������������Ĵ��
���Programador  � Data   �   BOPS   �           Motivo da Alteracao             ���
�������������������������������������������������������������������������������Ĵ��
���Marco A. Glz �18/04/17�  MMI-365 �Se replica llamado TVTXMA, el cual consiste���
���             �        �          �en realizar el calculo de depreciacion,    ���
���             �        �          �cuando el calendario sea diferente al 01 de���
���             �        �          �Enero - 31 Diciembre. (ARG)                ���
���Marco A. Glz �20/07/17� MMI-6418 �Se soluciona error de compilacion, debido a���
���             �        �          �que la variable lPerDepr en V12.1.17 (ARG) ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
User Function MGFATF01(cAlias, lDireto)

Local oDlg
Local nDecimais := Set( _SET_DECIMALS )
Local nOpca 	:= 0 // Entra como Cancelar
Local cPictTxDep:= ""
Local dUltDepr 	:= GetNewPar("MV_ULTDEPR", STOD("19800101"))
Local cMoedaAtf := GetMV("MV_ATFMOED")
Local aSays		:= {}
Local aButtons	:= {}
Local cFunction	:= "ATFA070"
Local cTitle	:= STR0005
Local bProcess	:= {|oSelf,cAlias| A070CALC(cAlias,cMoedaAtf,.F.,oSelf) }
Local cATFCRAT	:= SuperGetMV("MV_ATFCRAT",.F.,"1") //Criterio de atualizacao: 0-Mensal | 1-Anual (Default)
Local dDataBx	:= GetNewPar("MV_ATFULBX","")

//���������������������������������������������������������������������Ŀ
//� Define a descricao para o processameno da rotina com base nos       �
//� par�metros da filial corrente.                                      �
//�����������������������������������������������������������������������
Local cDescription	:= STR0006 + " " + STR0007 + " " + STR0008 + " " + STR0009 + CHR(10) + STR0010 + Dtoc(dUltDepr) +  " - " + SM0->M0_NOME +;
CHR(10) + STR0013 + GETMV("MV_SIMB" + cMoedaAtf) + " ( "+ cMoedaAtf + ")"

Set( _SET_DECIMALS ,4 )

Private aRotina := MenuDef()
Private cCadastro := OemToAnsi(STR0005)  //  "Desc�lculo de Ativos Imobilizados"
//��������������������������������������Ŀ
//� Localiza moeda forte para ativo fixo �
//����������������������������������������
Private cArquivo, nTotal:=0, nHdlPrv:=0
Private cPriDiaMes := "0101"
Private cUltDiaMes := "1231"
Private lPerDepr    := .F.

// Executa validacoes customizadas antes de efetuar o descalculo.
If ExistBlock("ATFA070", .F., .F.)
	If ! ExecBlock("ATFA070")
		Return
	Endif
Endif

If cPaisLoc == "CHI"
	//-----------------------------------------------
	// Valida se o mes de execucao ja sofreu calculo
	//-----------------------------------------------
	If Month(dDatabase) ==	Month(dDataBx) .And. Year(dDataBase) == Year(dDataBx)
		Help(" ",1,"ATFA070",,STR0035,1,0) //"O c�lculo de cr�dito IR j� foi processado para este m�s. Verifique o par�metro MV_ATFULBX."
		Return
	EndIf
EndIf

AcertaSXD(lDireto)

ATFXKERNEL()

Pergunte("AFA070",.F.)

If IsBlind() .Or. lDireto
	BatchProcess(	cCadastro, 	STR0005 + Chr(13) + Chr(10) +;
	STR0006 + Chr(13) + Chr(10) +;
	STR0007 + Chr(13) + Chr(10) +;
	STR0008 + Chr(13) + Chr(10) +;
	STR0009, "ATFA070",;
	{ || A070CALC(cAlias, cMoedaAtf, .T.) }, { || .F. })
	Return .T.
EndIf
SetKey( VK_F12, { |a,b| AcessaPerg("AFA070",.T.) } )
cPictTxDep:= PesqPict("SM2","M2_MOEDA"+cMoedaAtf,12)

tNewProcess():New(cFunction,cTitle,bProcess,cDescription,"AFA070")

SET KEY VK_F12 TO
//�����������������������������������Ŀ
//� Recupera a Integridade dos dados  �
//�������������������������������������
SET( _SET_DECIMALS , nDECIMAIS )

RETURN .T.

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � ATFA070AUT � Autor � Daniel Fonseca de Lira� Data � 12/04/17 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina automatica de recalculo                               ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ATFA070AUT(nContabiliza, nAglutina, nConsFil, cFilDe, cFilAte)

Local nDecimais := Set( _SET_DECIMALS )
Local cMoedaAtf := GetMV("MV_ATFMOED")
Local dDataBx   := GetNewPar("MV_ATFULBX","")
Local lDireto   := .T.
Local cAlias    := ""
Local lRet      := .F.

// backup dos parametros pois irei mexer no MVs
Local aMVBKP    := {MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05}

// mantidas por compatibilidade com o restante do codigo
Private cArquivo
Private nTotal:=0
Private nHdlPrv := 0

// ajuste de default para parametros nao preenchidos
Default cContabiliza := 3                                              // nao contabiliza
Default nAglutina    := 2                                              // nao aglutina
Default nConsFil     := IIf(Empty(cFilDe) .And. Empty(cFilAte), 2, 1)  // verifica se considera filiais
Default cFilDe       := Space(Len(cFilAnt))                            // branco
Default cFilAte      := PadR("", Len(cFilAnt), "Z")                    // ZZZ

// Executa validacoes customizadas antes de efetuar o descalculo.
If ExistBlock("ATFA070", .F., .F.)
	If ! ExecBlock("ATFA070")
		Return
	Endif
Endif

// controle que ja existia
If cPaisLoc == "CHI"
	//-----------------------------------------------
	// Valida se o mes de execucao ja sofreu calculo
	//-----------------------------------------------
	If Month(dDatabase) ==	Month(dDataBx) .And. Year(dDataBase) == Year(dDataBx)
		Help(" ",1,"ATFA070",,STR0035,1,0) //"O c�lculo de cr�dito IR j� foi processado para este m�s. Verifique o par�metro MV_ATFULBX."
		Return
	EndIf
EndIf

// procedimentos que ja existiam sem ser automatico
Set( _SET_DECIMALS ,4 )
AcertaSXD(lDireto)
ATFXKERNEL()

// ajusta parametros
MV_PAR01 := nContabiliza
MV_PAR02 := nAglutina
MV_PAR03 := nConsFil
MV_PAR04 := cFilDe
MV_PAR05 := cFilAte

// chamada a funcao calc que ja era feita
lRet := A070CALC(cAlias, cMoedaAtf, .T.)

// recupera parametros
MV_PAR01 := aMVBKP[1]
MV_PAR02 := aMVBKP[2]
MV_PAR03 := aMVBKP[3]
MV_PAR04 := aMVBKP[4]
MV_PAR05 := aMVBKP[5]

// procedimento que ja existia
SET( _SET_DECIMALS , nDECIMAIS )

RETURN lRet

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � A070CALC   � Autor � Vinicius Barreira     � Data � 21/11/94 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � DESCalculo de deprecia��o e corre��o monet�ria do Ativo Imob.���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                     ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function A070CALC(cAlias,cMoedaAtf,lDireto,oSelf)

Local lResult			:= .T.
LOCAL lmostra			:= iif(mv_par01 == 1,.t.,.f.), nTotRegs
LOCAL cLoteAtf			:= LoteCont("ATF")
LOCAL cMesAno			:= StrZero(Month(dDataBase),2)+'/'+Subs(StrZero(Year(dDataBase),4),3,2)
LOCAL dUltProc			:= GetNewPar("MV_ULTDEPR", STOD("19800101"))
LOCAL aLancam			:= Array( 20 )
LOCAL cQuaisMoedas		:= ""
Local cSubDeb			:= Space(9), cSubCre := Space(9)
Local lPadrao			:= VerPadrao("825")
Local lLP_Rat			:= VerPadrao("828")//acrescentado por Fernando Radu Muscalu em 10/05/2011
Local cSet
Local lHdlProva			:= .F.
Local cData
Local lAjustInf			:= GetNewPar("MV_ATFINFL",.F.)
Local cContaCap			:= GetMv("MV_CONTACO")
Local nCorrec			:= GetMv("MV_CORCAPI")
Local nValCorSX6		:= 0
Local lContabiliza
Local lCtb				:= CtbInUse()
Local cFilDe			:= cFilAnt
Local cFilAte			:= cFilAnt
Local cFilOld			:= cFilAnt
Local cN1TipoNeg		:= Alltrim(SuperGetMv("MV_N1TPNEG",.F.,"")) // Tipos de N1_PATRIM que aceitam Valor originais negativos
Local cN3TipoNeg		:= Alltrim(SuperGetMv("MV_N3TPNEG",.F.,"")) // Tipos de N3_TIPO que aceitam Valor originais negativos
Local nVlAtivo			:= 0
Local nVlDprAc			:= 0
Local nVlResid			:= 0
Local aPFimDepr			:= {} // Devera conter os Ponteiros para atualizacao do N3_FIMDEPR
Local cCalcDep			:= GetNewPar("MV_CALCDEP",'0') //-> '0'-Mensal, '1'-Anual
Local lPutMV			:= .F.
//********************************
// Controle de multiplas moedas  *
//********************************
Local __nQuantas := If(lMultMoed,AtfMoedas(),5)
Local aValorMoed
Local nX
Local cIDFilial			:= " - " + X3FieldName( "N3_FILIAL" ) + ": " + IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local nInc				:= 0
Local aSM0				:= AdmAbreSM0()
Local lAtfa070 			:= ExistBlock("AF070DES")		// Deve ser hamado logo apos o tratamento de correcao do bem.
Local lAtfctap			:= IIF(GetNewPar("MV_ATFCTAP","0")=="0",.F.,.T.)

// Valores: Taxa de Perda acumulada e Vlr acumulado da Taxa de Perda para PTG
Local nTotValPer		:= 0
Local cFilProc			:= ""
Local lLog				:= .F.
Local cMsg				:= ""


//Acrescentado por Fernando Radu Muscalu em 04/05/2011
//Variaveis utilizadas no estorno dos movimentos de rateio da ficha de ativo
Local aValDepr 		:= {}			//Valores de cada moeda - SN4
Local dDataMov		:= stod("")		//Data do movimento SN4
Local cIdMov		:= ""			//Identificacao do movimento SN4
Local aDadoRat		:= {}			//array com o codigo do rateio e a revisao. Ele estara preenchido caso tenha sido efetuada a movimentacao de estorno do saldo do rateio
Local dDataVir
Local lSldAtf
Local cValRes       := Iif(cPaisLoc == "BOL" .And. GetMv("MV_ZVALRES") == "1","1", "0")
//Tratamento para bens bloqueados, baseado no parametro MV_ATFCLBL
Local lDeprBlq	:= .F.		//determina se bens bloqueados serao depreciados
Local lCorrBlq	:= .F.		//determina se bens bloqueados terao correcao monetaria

Local cQuery
Local cAliasQry

// Verifica��o da classifica��o de Ativo se sofre deprecia��o
Local lAtClDepr := .F.
Local cTypes10		:= IIF(lIsRussia,"*" + AtfNValMod({1}, "*"),"") // CAZARINI - 24/03/2017 - If is Russia, add new valuations models - main models
Local cTypesNM		:= IIF(lIsRussia,"*" + AtfNValMod({3,4}, "*"),"") // CAZARINI - 24/03/2017 - If is Russia, add new valuations models - 17 and 16 models
// verifica controle de transa�?o para for�ar todas filiais
Local lAtivaControle := GetNewPar("MV_ATFCTRL", .F.)

Private cArqLog			:= ""

If cPaisLoc == "ARG"
	lPerDepr := ATFXPerDepr(@cPriDiaMes, @cUltDiaMes)
EndIf

// caso o parametro esteja ativo, fixa os parametros
If lAtivaControle
	MV_PAR01 := 3
	MV_PAR02 := 2
	MV_PAR03 := 1
	MV_PAR04 := Replicate(" ", Len(cFilAnt))
	MV_PAR05 := Replicate("Z", Len(cFilAnt))
	lMostra := .F.
EndIf

//Registrando no log de processos
If ValType(oSelf) == "O"
	oSelf:SaveLog("MENSAGEM: Iniciando processo de desc�lculo de deprecia��o")
EndIf

cContaCap := IIf(Len(cContaCap)<20,Trim(cContaCap)+Space(20-Len(cContaCap)),Substr(cContaCap,1,20))

SN5->(dbSetOrder(1)) //N5_FILIAL+N5_CONTA+DTOS(N5_DATA)+N5_TIPO+N5_TPBEM+N5_TPSALDO

If mv_par01 < 3 .And. ! lPadrao .And. ! lCtb	// 1-Mostra, 2-Nao mostra e 3-Nao contabiliza
	
	//������������������������������������������������������Ŀ
	//� Gera arquivo de Trabalho para fins de contabiliza��o �
	//��������������������������������������������������������
	//********************************
	// Controle de multiplas moedas  *
	//********************************
	aCampos:={}
	aAdd(aCampos,{"CONTA"  , "C" , 40,0})
	aAdd(aCampos,{"DATAX"  , "D" , 08,0})
	aAdd(aCampos,{"DESCR"  , "C" , 40,0})
	//********************************
	// Controle de multiplas moedas  *
	//********************************
	If lMultMoed
		AtfMultMoe(,,{|x| aAdd(aCampos,{"VALOR"+Alltrim(Str(x)) , "N" , 17,If(x=1,2,4)} ) })
	Else
		aAdd(aCampos,{"VALOR1" , "N" , 17,2} )
		aAdd(aCampos,{"VALOR2" , "N" , 17,4} )
		aAdd(aCampos,{"VALOR3" , "N" , 17,4} )
		aAdd(aCampos,{"VALOR4" , "N" , 17,4} )
		aAdd(aCampos,{"VALOR5" , "N" , 17,4} )
	EndIf
	aAdd(aCampos,{"PATRIM" , "C" ,  1,0})
	aAdd(aCampos,{"CCUSTO" , "C" , 09,0})
	aAdd(aCampos,{"SUBCTA" , "C" , 18,0})   //DUAS SUBCONTAS*/
	
	cArqTmp := CriaTrab(aCampos)
	dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )
	IndRegua ( "cArqTmp",cArqTmp,"CONTA+CCUSTO",,,OemToAnsi(STR0014)) // "Selecionando Registros..."
Endif

// Processa todo o arquivo de filiais ou apenas a filial atual
If mv_par03 == 1
	cFilDe  := mv_par04
	cFilAte	:= mv_par05
Endif

For nInc := 1 To Len( aSM0 )
	If aSM0[nInc][1] == cEmpAnt .AND. aSM0[nInc][2] >= cFildE .AND. aSM0[nInc][2] <= cFilAte
		cFilAnt := aSM0[nInc][2]
		
		//Tratamento Gestao Corporativa
		If Len(xFilial("SN3") ) > 2 .and.!Empty(xFilial("SN3"))
			If Alltrim(cFilProc) != Alltrim(xFilial("SN3"))
				cFilProc:= xFilial("SN3")
			Else
				Loop
			EndIf
		EndIf
		
		lDeprBlq	:= (cPaisLoc <> "BRA") .And. (GetMv("MV_ATFCLBL",.F.,"0") $ "1|3")	//determina se bens bloqueados serao depreciados
		lCorrBlq	:= (cPaisLoc <> "BRA") .And. (GetMv("MV_ATFCLBL",.F.,"0") $ "2|3")	//determina se bens bloqueados terao correcao monetaria
		
		dUltProc	:= GetNewPar("MV_ULTDEPR", STOD("19800101"))
		lSldAtf		:= GetNewPar("MV_ATFRSLD",.F.)
		
		//se tem o parametro MV_ATFRSLD (REFAZ SALDO) CONFIGURADO COM .T. e controla data de virada
		If lSldAtf
			dDataVir :=  AtfGetSN0("13","VIRADAATIVO")
			If !Empty(dDataVir)
				dDataVir := STOD(dDataVir)
				
				//data da virada deve ser sempre no primeiro dia do ano
				If lSldAtf
					If ( DTOS(dDataVir) != "19800101" .And. Year(dDataBase) != Year(dDataVir)+1 ) .Or.  dDataBase < dDataVir .Or. dUltProc < dDataVir
						Aviso(STR0025,STR0026+CRLF+;  //"Atencao"##"O descalculo de depreciacao somente pode ser efetuado ap�s a  virada anual no exercicio vigente. "
						STR0028+ cFilAnt+" "+CRLF+; //"Filial : "
						STR0029+DtoC(dDataVir)+Space(10)+;   //"Ultima Virada : "
						STR0030+DtoC(dUltProc), {"Ok"})  //"Ultima Calculo Depreciacao : "
						lResult := .F.		// Invalidar o processo.
						Loop
					EndIf
				Else
					If ( DTOS(dDataVir) != "19800101" .And. Year(dDataBase) != Year(dDataVir) ) .Or.  dDataBase < dDataVir .Or. dUltProc < dDataVir
						Aviso(STR0025,STR0026+;  //"Atencao"##"O descalculo de depreciacao somente pode ser efetuado ap�s a  virada anual no exercicio vigente. "
						STR0027+Space(50)+CRLF+;  //"No Ativo, a virada ocorre ap�s o c�lculo de 31 de Dezembro. "
						STR0028+ cFilAnt+" "+CRLF+; //"Filial : "
						STR0029+DtoC(dDataVir)+Space(10)+;   //"Ultima Virada : "
						STR0030+DtoC(dUltProc), {"Ok"})  //"Ultima Calculo Depreciacao : "
						lResult := .F.		// Invalidar o processo.
						Loop
					EndIf
				EndIf
			Else
				Aviso(STR0025,STR0031+;  //"Atencao"##"N�o encontrada a data da virada anual e o parametro MV_ATFRSLD esta ativo. Verifique! "
				STR0027+Space(50)+CRLF+;  //"No Ativo, a virada ocorre ap�s o c�lculo de 31 de Dezembro. "
				STR0028+ cFilAnt+" ", {"Ok"})  //"Filial : "
				lResult := .F.		// Invalidar o processo.
				Loop
			EndIf
		EndIf
		
		If !AFA070Valid( dUltProc, lAjustInf, aSM0[nInc][7] )
			lResult := .F.		// Invalidar o processo.
			Loop
		EndIf
		
		If dUltProc == dDataBase
			//������������������������������������������������������Ŀ
			//� Desenha o cursor e o salva para poder movimenta'-lo  �
			//��������������������������������������������������������
			dbSelectArea("SN4")
			dbSetOrder(2)
			nTotRegs := SN4->( RecCount() )
			
			If ValType(oSelf) == "O"
				oSelf:SetRegua1(nTotRegs)
			EndIf
			
			cAliasQry := GetNextAlias()
			cQuery := "SELECT SN1.R_E_C_N_O_ SN1RECNO, "
			cQuery += "       SN3.R_E_C_N_O_ SN3RECNO, "
			cQuery += "       SN4.R_E_C_N_O_ SN4RECNO "
			cQuery += "FROM "+RetSqlName("SN4")+" SN4, "
			cQuery +=         RetSqlName("SN3")+" SN3, "
			cQuery +=         RetSqlName("SN1")+" SN1 "
			cQuery += "WHERE "
			cQuery += "SN4.N4_FILIAL='"+xFilial("SN4")+"' AND "
			cQuery += "SN4.N4_DATA = '" + DTOS(dUltProc) + "' AND "
			cQuery += "SN4.N4_MOTIVO = '  ' AND "
			If cPaisLoc == "PTG"
				cQuery += "SN4.N4_OCORR IN ('06','07','08','10','11','12','17','18','20','21') AND "
			Else
				cQuery += "SN4.N4_OCORR IN ('06','07','08','10','11','12','17','18','20') AND "
			Endif
			
			//Ignora bens cujo m�todo de deprecia��o seja exaust�o (4,5,8,9)
			If lAtfctap
				cQuery += "SN3.N3_TPDEPR NOT IN ('4','5','8','9') AND "
			EndIf
			cQuery += "SN3.N3_FILIAL='"+xFilial("SN3")+"' AND "
			cQuery += "SN4.N4_CBASE = SN3.N3_CBASE AND "
			cQuery += "SN4.N4_ITEM  = SN3.N3_ITEM  AND "
			cQuery += "SN4.N4_TIPO  = SN3.N3_TIPO  AND "
			// Tratamento para bens n�o baixados ou baixados pela atfa035
			cQuery += "(SN3.N3_BAIXA IN ( '0', ' ') OR (SN3.N3_BAIXA IN ('1', '2') AND SN3.N3_NOVO = '2' AND SN3.N3_DTBAIXA >= '"+DtoC(FirstDay(dUltProc))+"' AND SN3.N3_DTBAIXA <= '"+DtoC(LastDay(dUltProc))+"')) AND "
			cQuery += "SN4.N4_SEQ = SN3.N3_SEQ AND "
			cQuery += "SN3.D_E_L_E_T_=' ' AND "
			cQuery += "SN4.D_E_L_E_T_=' ' AND "
			cQuery += "SN1.N1_FILIAL='"+xFilial("SN1")+"' AND "
			cQuery += "SN4.N4_CBASE = SN1.N1_CBASE AND "
			cQuery += "SN4.N4_ITEM  = SN1.N1_ITEM  AND "
			cQuery += "SN1.D_E_L_E_T_=' ' "
			dbSelectArea("SN1")
			//Verifica as acoes para itens bloqueados
			If !lDeprBlq .And. !lCorrBlq
				cQuery += "AND SN1.N1_STATUS <> '2' AND SN1.N1_STATUS <> '3' "
			EndIf
			//cQuery += "AND N4_CBASE IN ('0000002698','0000002697') "
			cQuery := ChangeQuery(cQuery)
			
			
			MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)},STR0014) //"Selecionando Registros..."
			
			
			While (cAliasQry)->(!Eof())
				PCOINILAN("000364")
				
				SN1->(MsGoto((cAliasQry)->SN1RECNO))
				SN3->(MsGoto((cAliasQry)->SN3RECNO))
				SN4->(MsGoto((cAliasQry)->SN4RECNO))
				
				//����������������������������������������������������������������������Ŀ
				//� Ponto de entrada que permite a selecao de determinados produtos para �
				//� nao depreciar no calculo de depreciacao mensal                       �
				//������������������������������������������������������������������������
				If ExistBlock("AF050FPR")
					If ExecBlock("AF050FPR",.F.,.F.,{SN3->N3_CBASE+SN3->N3_ITEM})
						DbSelectarea(cAliasQry)
						DbSkip()
						Loop
					endif
				endif
				
				//���������������������������������������������������������������������������Ŀ
				//� A contabilizacao deve ser tratada antes da atualizacao do SN3 para        �
				//� permitir que a regra 825 seja o inverso da 820, que utiliza o N3_VRDMESx  �
				//�����������������������������������������������������������������������������
				//�����������������������������������������������������������������������Ŀ
				//� Cria registros no arquivo temporario para posterior contabiliza��o.   �
				//� Processo semelhante ao atfa050, apenas invertendo as contas.          �
				//�������������������������������������������������������������������������
				If mv_par01 < 3  // 1-Mostra,2-Nao Mostra e 3-Nao Contabiliza
					If !lPadrao .And. ! lCtb
						Do Case
							Case SN4->N4_OCORR $ '06/20' .And. SN4->N4_CONTA != SN3->N3_CCDEPR // Deprecia��o, ou depreciacao Gerencial
								//********************************
								// Controle de multiplas moedas  *
								//********************************
								If lMultMoed
									aValorMoed := AtfMultMoe("SN4","N4_VLROC")
								Else
									aValorMoed := { SN4->N4_VLROC1,SN4->N4_VLROC2,SN4->N4_VLROC3,SN4->N4_VLROC4,SN4->N4_VLROC5 }
								EndIf
								a070Traba( SN3->N3_CCDEPR + SN3->N3_CDEPREC, dDataBase, aValorMoed ,;
								OemToAnsi(STR0015)+cMesAno,SN3->N3_CCUSTO,SN1->N1_PATRIM,SN3->N3_SUBCCDE+SN3->N3_SUBCDEP) //'ESTORNO DEPRECIACAO NO MES '
								
							Case SN4->N4_OCORR == '07' // Corre��o
								//********************************
								// Controle de multiplas moedas  *
								//********************************
								If lMultMoed
									aValorMoed := AtfMultMoe(,,{|x| If(x=1,SN4->N4_VLROC1,0) })
								Else
									aValorMoed := { SN4->N4_VLROC1,0,0,0,0 }
								EndIf
								a070Traba( SN3->N3_CCORREC + SN3->N3_CCONTAB, dDataBase, aValorMoed ,;
								OemToAnsi(STR0016)+cMesAno,SN3->N3_CUSTBEM,SN1->N1_PATRIM,SN3->N3_SUBCCOR+SN3->N3_SUBCCON ) //'ESTORNO CORRECAO NO MES '
								
							Case SN4->N4_OCORR == '08' // Corre��o da deprecia��o
								//********************************
								// Controle de multiplas moedas  *
								//********************************
								If lMultMoed
									aValorMoed := AtfMultMoe(,,{|x| If(x=1,SN4->N4_VLROC1,0) })
								Else
									aValorMoed := { SN4->N4_VLROC1,0,0,0,0 }
								EndIf
								a070Traba( SN3->N3_CCDEPR + SN3->N3_CDESP, dDataBase, aValorMoed,;
								OemToAnsi(STR0017)+cMesAno,SN3->N3_CCUSTO,SN1->N1_PATRIM,SN3->N3_SUBCCDE+SN3->N3_SUBCDES) //'ESTORNO CORRECAO DEPRECIACAO MES '
						EndCase
					Endif
					
					//As regras de cadastros para a contabiliza��o correta fica a cargo do usu�rio - Retirada a validaca SN4->N4_CONTA != SN3->N3_CCDEPR
					
					lContabiliza := ((SN4->N4_OCORR == '06' .Or. SN4->N4_OCORR $ "10,11,12,20")) .Or. SN4->N4_OCORR == '07' .Or. SN4->N4_OCORR == '08'
					
					If lPadrao .And. lContabiliza .or. lLP_Rat //acrescentado por Fernando Radu Muscalu em 10/05/2011
						iF !lHdlProva
							nHdlPrv   := HeadProva(cLoteAtf,"ATFA070",Substr(cUsername,1,6),@cArquivo)
							lHdlProva := .T.
						Endif
						nTotal += DetProva(nHdlPrv,"825","ATFA070",cLoteAtf)
					Endif
				Endif
				
				Reclock("SN3",.F.)
				
				// Forca a atualizacao pois a ocorrencia 07 pode nao ter ocorrido no mes atual.
				// E o valor deste campo participa da composicao do Valor Original Atualizado (ATFR030->Ficha do Ativo)
				SN3->N3_VRCMES1	:= VlMesAnt( "07", "1" , cAliasQry ,"A" )
				
				// Forca a atualizacao pois a ocorrencia 08 pode nao ter ocorrido no mes atual.
				// Para manter compatibilidade com a situacao dos campos SN3->N3_VRCMES1 e SN3->N3_VRDMES1
				SN3->N3_VRCDM1	:= VlMesAnt( "08", "1"  , cAliasQry , "B" )
				
				// Se for um item gerado pelo ATFA035, desfaz a marca que ja foi calculada depreciacao
				// para ser calculada no proximo calculo (no item baixado)
				If  SN3->N3_NOVO == "2"
					SN3->N3_NOVO := "1"
				EndIf
				
				Do Case
					//�������������Ŀ
					//� Deprecia��o �
					//���������������
					Case SN4->N4_OCORR == "06" .Or. SN4->N4_OCORR $ "10,11,12,20" .Or.;	// Aceleracao e Incentivada Positiva/Negativa
						(SN4->N4_OCORR == "21" .And. cPaisLoc == "PTG")
						
						If SN4->N4_CONTA == SN3->N3_CDEPREC .And. SN4->N4_TIPOCNT=='3'		// desp de depr
							
							//********************************
							// Controle de multiplas moedas  *
							//********************************
							If lMultMoed
								
								//AtfMultMoe("SN3","N3_VRDMES",{|x| SN3->&(If(x>9,"N3_VRDME","N3_VRDMES")+Alltrim(Str(x))) - VlMesAnt( SN4->N4_OCORR, Alltrim(Str(x)) ) })
								AtfMultMoe("SN3","N3_VRDMES",{|x| VlMesAnt( SN4->N4_OCORR, Alltrim(Str(x)) , cAliasQry , "C" ) })
							Else
								
								SN3->N3_VRDMES1 := ABS( VlMesAnt( SN4->N4_OCORR, "1"  , cAliasQry ,"D" ) )
								SN3->N3_VRDMES2 := ABS( VlMesAnt( SN4->N4_OCORR, "2"  , cAliasQry ,"D" ) )
								SN3->N3_VRDMES3 := ABS( VlMesAnt( SN4->N4_OCORR, "3"  , cAliasQry ,"D" ) )
								SN3->N3_VRDMES4 := ABS( VlMesAnt( SN4->N4_OCORR, "4"  , cAliasQry ,"D" ) )
								SN3->N3_VRDMES5 := ABS( VlMesAnt( SN4->N4_OCORR, "5"  , cAliasQry ,"D" ) )
								
							EndIf
							
							SN3->N3_PRODMES := FldMesAnt( SN4->N4_OCORR, "N4_QUANTPR" )
							
						EndIf
						
						If SN4->N4_CONTA == SN3->N3_CCDEPR .And. SN4->N4_TIPOCNT=='4'        //depr. acum
							//********************************
							// Controle de multiplas moedas  *
							//********************************
							If lMultMoed
								AtfMultMoe("SN3","N3_VRDBAL",{|x| SN3->&(If(x>9,"N3_VRDBA","N3_VRDBAL")+Alltrim(Str(x))) - SN4->&("N4_VLROC"+Alltrim(Str(x))) })
							Else
								SN3->N3_VRDBAL1 -= SN4->N4_VLROC1
								SN3->N3_VRDBAL2 -= SN4->N4_VLROC2
								SN3->N3_VRDBAL3 -= SN4->N4_VLROC3
								SN3->N3_VRDBAL4 -= SN4->N4_VLROC4
								SN3->N3_VRDBAL5 -= SN4->N4_VLROC5
							EndIf
							//********************************
							// Controle de multiplas moedas  *
							//********************************
							If lMultMoed
								AtfMultMoe("SN3","N3_VRDACM",{|x| SN3->&(If(x>9,"N3_VRDAC","N3_VRDACM")+Alltrim(Str(x))) - SN4->&("N4_VLROC"+Alltrim(Str(x))) })
							Else
								SN3->N3_VRDACM1 -= SN4->N4_VLROC1
								SN3->N3_VRDACM2 -= SN4->N4_VLROC2
								SN3->N3_VRDACM3 -= SN4->N4_VLROC3
								SN3->N3_VRDACM4 -= SN4->N4_VLROC4
								SN3->N3_VRDACM5 -= SN4->N4_VLROC5
							EndIf
							
							AF070AtProj(SN4->N4_CBASE,SN4->N4_ITEM,SN4->N4_TIPO,SN4->N4_TPSALDO,SN4->N4_DATA,SN4->N4_OCORR,SN4->N4_SEQ )
						EndIf
						
						If SN4->N4_OCORR == "21" .And. cPaisLoc == "PTG"	// Taxa Perdida - Desp. deprecia��o
							
							//******************************************************
							// Controle de multiplas moedas                        *
							// Ocorrencia apenas na moeda Fiscal - Nao contabiliza *
							//******************************************************
							nTotValPer := 0
							If lMultMoed
								AtfMultMoe(,,{|x| nTotValPer += SN4->&("N4_VLROC"+Alltrim(Str(x))) })
							Else
								nTotValPer += ABS( SN4->N4_VLROC1 )
								nTotValPer += ABS( SN4->N4_VLROC2 )
								nTotValPer += ABS( SN4->N4_VLROC3 )
								nTotValPer += ABS( SN4->N4_VLROC4 )
								nTotValPer += ABS( SN4->N4_VLROC5 )
							EndIf
							
							If SN4->N4_TIPOCNT == "3"		// Tx Perdida acumulada
								SN3->N3_TXPERDA -= nTotValPer
							Elseif SN4->N4_TIPOCNT == "4"	// Vlr Acumulada da Taxa Perdida
								SN3->N3_VLACTXP -= nTotValPer
							Endif
						Endif
						
						//N3_VRCDB1, N3_VRCDA1
						nVlAtivo	:= Iif( SN1->N1_PATRIM # "C", (SN3->N3_VORIG1 + SN3->N3_VRCACM1 + SN3->N3_AMPLIA1), SN3->N3_VORIG1 )
						nVlDprAc	:= ABS(SN3->N3_VRDACM1) + ABS(SN3->N3_VRCDA1) + ABS(GetSldAcel('1'))
						nVlResid	:= ABS(nVlAtivo) - nVlDprAc
						
						If nVlResid > 0
							// Se o saldo acumulou atraves do tipo 01, deve-se atualizar o tipo 07
							if N3_TIPO $ ("01*10*16*17" + cTypes10 + cTypesNM)
								//Guarda o ID do bem para atualizacao posterior do tipo 07
								AADD( aPFimDepr, N3_FILIAL + N3_CBASE + N3_ITEM + '07' )
							endif
							SN3->N3_FIMDEPR := CTOD("  /  /  ")
						Endif
						
						If SN3->N3_TIPO != "05" .And. !(SN1->N1_PATRIM $ cN1TipoNeg) .And. !(SN3->N3_TIPO $ cN3TipoNeg)
							//********************************
							// Controle de multiplas moedas  *
							//********************************
							For nX := 1 to __nQuantas
								cMoed := Alltrim(Str(nX))
								If SN3->&(If(nX>9,"N3_VRDME","N3_VRDMES")+cMoed) < 0 .AND. SN3->&("N3_VORIG"+cMoed) > 0
									SN3->&(If(nX>9,"N3_VRDME","N3_VRDMES")+cMoed) := 0
								End
							Next
							
							//********************************
							// Controle de multiplas moedas  *
							//********************************
							For nX := 1 to __nQuantas
								cMoed := Alltrim(Str(nX))
								If SN3->&(If(nX>9,"N3_VRDBA","N3_VRDBAL")+cMoed) < 0 .AND. SN3->&("N3_VORIG"+cMoed) > 0
									SN3->&(If(nX>9,"N3_VRDBA","N3_VRDBAL")+cMoed) := 0
								End
							Next
							
							//********************************
							// Controle de multiplas moedas  *
							//********************************
							For nX := 1 to __nQuantas
								cMoed := Alltrim(Str(nX))
								If SN3->&(If(nX>9,"N3_VRDAC","N3_VRDACM")+cMoed) < 0 .AND. SN3->&("N3_VORIG"+cMoed) > 0
									SN3->&(If(nX>9,"N3_VRDAC","N3_VRDACM")+cMoed) := 0
								End
							Next
						Endif
						
						//��������������������������������Ŀ
						//� Atualiza o SN5 - Deprecia��o   �
						//� Referente as contas de deprecia�
						//� ��o.                           �
						//����������������������������������
						If SN4->N4_CONTA = SN3->N3_CDEPREC
							dbSelectArea("SN5")
							
							If SN4->N4_OCORR $ "10,12"
								MsSeek(xFilial("SN5")+SN3->N3_CDEPREC+DTOS(SN4->N4_DATA)+"K" + SN3->N3_TIPO + SN3->N3_TPSALDO)
							ElseIf SN4->N4_OCORR == "11"
								MsSeek(xFilial("SN5")+SN3->N3_CDEPREC+DTOS(SN4->N4_DATA)+"L" + SN3->N3_TIPO + SN3->N3_TPSALDO)
							ElseIf SN4->N4_OCORR == "20"
								MsSeek(xFilial("SN5")+SN3->N3_CDEPREC+DTOS(SN4->N4_DATA)+"Y" + SN3->N3_TIPO + SN3->N3_TPSALDO)
							Else
								MsSeek(xFilial("SN5")+SN3->N3_CDEPREC+DTOS(SN4->N4_DATA)+"4" + SN3->N3_TIPO + SN3->N3_TPSALDO)
							Endif
							a070del(cN1TipoNeg, cN3TipoNeg)  // Trata registro do sn5
						EndIf

						If SN4->N4_CONTA = SN3->N3_CCDEPR
							dbSelectArea("SN5")
							If SN4->N4_OCORR $ "10,12"
								MsSeek(xFilial("SN5")+SN3->N3_CCDEPR+DTOS(SN4->N4_DATA)+"K" + SN3->N3_TIPO + SN3->N3_TPSALDO )
							ElseIf SN4->N4_OCORR == "11"
								MsSeek(xFilial("SN5")+SN3->N3_CCDEPR+DTOS(SN4->N4_DATA)+"L" + SN3->N3_TIPO + SN3->N3_TPSALDO)
							ElseIf SN4->N4_OCORR == "20"
								MsSeek(xFilial("SN5")+SN3->N3_CCDEPR+DTOS(SN4->N4_DATA)+"Y" + SN3->N3_TIPO + SN3->N3_TPSALDO)
							Else
								MsSeek(xFilial("SN5")+SN3->N3_CCDEPR+DTOS(SN4->N4_DATA)+"4" + SN3->N3_TIPO + SN3->N3_TPSALDO)
							Endif
							a070del(cN1TipoNeg, cN3TipoNeg)  // Trata registro do sn5
						Endif
						
						//��������������������������������Ŀ
						//� Corre��o Monetaria             �
						//����������������������������������
					Case SN4->N4_OCORR == "07"
						If (SN4->N4_CONTA==SN3->N3_CCONTAB .And. SN4->N4_TIPOCNT == "1")
							If cPaisloc == "BOL" .And. cValRes == "1"
								nVlrCoAc := (SN3->N3_VRCACM1) - (SN4->N4_VLROC1)
								//	nVlrCoAcu := SN4->N4_VLROC1 - nVlrCoAc
								SN3->N3_VRCACM1 := (SN3->N3_VRCACM1-SN4->N4_VLROC1) - nVlrCoAc
								//	ABS(SN3->N3_VRCACM1) -= (ABS(nVlrCoAc) -= ABS(SN4->N4_VLROC1))
							Else
								SN3->N3_VRCACM1 -= SN4->N4_VLROC1
								SN3->N3_VRCMES1 := VlMesAnt(SN4->N4_OCORR, "1" , cAliasQry,"E")
								SN3->N3_VRCBAL1 -= SN4->N4_VLROC1
							EndIf
							
							// Verifica��o da classifica��o de Ativo se sofre deprecia��o
							lAtClDepr := AtClssVer(SN1->N1_PATRIM )
							
							//����������������������������������Ŀ
							//� Atualiza o SN5 - Corre��o do bem �
							//������������������������������������
							If lAtClDepr .OR. SN1->N1_PATRIM $ " P"
								dbSelectArea("SN5")
								MsSeek(xFilial()+SN4->N4_CONTA+DTOS(SN4->N4_DATA)+"6")
								a070del(cN1TipoNeg, cN3TipoNeg)  // Trata registro do sn5
								//����������������������������������Ŀ
								//� Atualiza o SN5 - Corre��o do bem �
								//������������������������������������
							Else    //Se for correcao de "SCA" procuro pelo tipo "O" no SN5
								dbSelectArea("SN5")
								MsSeek(xFilial()+SN4->N4_CONTA+DTOS(SN4->N4_DATA)+"O")
								a070del(cN1TipoNeg, cN3TipoNeg)  // Trata registro do sn5
							Endif
						Elseif (SN4->N4_CONTA==SN3->N3_CCORREC .And. SN4->N4_TIPOCNT == "2")
							// Verifica��o da classifica��o de Ativo se sofre deprecia��o
							lAtClDepr := AtClssVer(SN1->N1_PATRIM )
							//����������������������������������Ŀ
							//� Atualiza o SN5 - Corre��o do bem �
							//������������������������������������
							If lAtClDepr .OR. SN1->N1_PATRIM $ " P"
								dbSelectArea("SN5")
								MsSeek(xFilial()+SN4->N4_CONTA+DTOS(SN4->N4_DATA)+"6")
								a070del(cN1TipoNeg, cN3TipoNeg)  // Trata registro do sn5
								//����������������������������������Ŀ
								//� Atualiza o SN5 - Corre��o do bem �
								//������������������������������������
							Else    //Se for correcao de "SCA" procuro pelo tipo "O" no SN5
								dbSelectArea("SN5")
								MsSeek(xFilial()+SN4->N4_CONTA+DTOS(SN4->N4_DATA)+"O")
								a070del(cN1TipoNeg, cN3TipoNeg)  // Trata registro do sn5
							Endif
						Elseif (SN4->N4_CONTA==cContaCap .And. SN4->N4_TIPOCNT == "6")
							//�����������������������������������������������������������������Ŀ
							//�Atualiza a cta de corr de Capital Social (X6_CONTACO) nos arqui- �
							//�vos SN5 e SX6                                                    �
							//�������������������������������������������������������������������
							If SN1->N1_PATRIM=="C"
								dbSelectArea("SN5")
								MsSeek(xFilial()+SN4->N4_CONTA+DTOS(SN4->N4_DATA)+"O")
								a070del(cN1TipoNeg, cN3TipoNeg)  // Trata registro do sn5
							Endif
							nValCorSX6 := nCorrec-(SN4->N4_VLROC1)
							PutMv("MV_CORCAPI",nValCorSX6)
						Endif
						
					Case SN4->N4_OCORR == "08"
						If cPaisLoc <> "BRA"
							If SN4->N4_TIPOCNT == "5"
								If SN3->N3_VRCDB1 <> 0
									SN3->N3_VRCDB1 := (SN3->N3_VRCDB1-SN4->N4_VLROC1)
								Endif
								If SN3->N3_VRCDA1 <> 0
									If cPaisloc == "BOL" .And. cValRes == "1"
										nvrcda1 := SN3->N3_VRCDA1-SN4->N4_VLROC1
										SN3->N3_VRCDA1 := (SN3->N3_VRCDA1-SN4->N4_VLROC1) - nvrcda1
									Else
										SN3->N3_VRCDA1 := (SN3->N3_VRCDA1-SN4->N4_VLROC1)
									Endif
								Endif
								If SN3->N3_VRCDM1 <> 0
									SN3->N3_VRCDM1 := VlMesAnt( SN4->N4_OCORR, "1"  , cAliasQry,"F")
								Endif
							EndIf
						Else
							If SN3->N3_VRCDB1 <> 0
								SN3->N3_VRCDB1 := (SN3->N3_VRCDB1-SN4->N4_VLROC1)
							Endif
							If SN3->N3_VRCDA1 <> 0
								SN3->N3_VRCDA1 := (SN3->N3_VRCDA1-SN4->N4_VLROC1)
							Endif
							If SN3->N3_VRCDM1 <> 0
								SN3->N3_VRCDM1 := VlMesAnt( SN4->N4_OCORR, "1"  , cAliasQry,"G")
							Endif
						EndIf
						//��������������������������������Ŀ
						//� Atualiza o SN5 - Corre��o Depr.�
						//����������������������������������
						If SN4->N4_CONTA = SN3->N3_CDESP
							dbSelectArea("SN5")
							MsSeek(xFilial()+SN3->N3_CDESP+DTOS(SN4->N4_DATA) + "7" )
							a070del(cN1TipoNeg, cN3TipoNeg)  // Trata registro do sn5
						EndIf
						If SN4->N4_CONTA = SN3->N3_CCDEPR
							dbSelectArea("SN5")
							MsSeek(xFilial()+SN3->N3_CCDEPR+DTOS(SN4->N4_DATA) + "7" )
							a070del(cN1TipoNeg, cN3TipoNeg)  // Trata registro do sn5
						Endif
						//��������������������������������Ŀ
						//�Depre da Correc Monetaria Mensal�
						//����������������������������������
					Case SN4->N4_OCORR == "17" .And.  cPaisLoc = "ARG"
						//'17' - deprecia��o da corre��o monet�ria mensal
						If !Empty(SN3->N3_CDPCOMM)
							If SN4->N4_TIPOCNT == "7"
								SN3->N3_VDPCOMM -= SN4->N4_VLROC1
								If SN3->N3_VDPCOMM < 0
									SN3->N3_VDPCOMM := 0
								EndIf
							EndIf
							
						EndIf
						//��������������������������������Ŀ
						//� Depr da Corre��o Monet mensal  �
						//����������������������������������
						If SN4->N4_CONTA = SN3->N3_CDPCOMM
							dbSelectArea("SN5")
							dbSeek(xFilial()+SN3->N3_CDPCOMM+DTOS(SN4->N4_DATA) + "W" )
							a070del()  // Trata registro do sn5
						EndIf
						//��������������������������������Ŀ
						//�Depre da Correc Monetaria Mensal�
						//����������������������������������
					Case SN4->N4_OCORR == "18"
						//'18' - deprecia��o acumulada da corre��o monet�ria
						If !Empty(SN3->N3_CDPCOMA)
							If cPaisLoc = "ARG"
								If SN4->N4_TIPOCNT == "8"
									SN3->N3_VDPCOMA  -= SN4->N4_VLROC1
									If SN3->N3_VDPCOMA < 0
										SN3->N3_VDPCOMA := 0
									EndIf
								EndIf
							EndIf
						EndIf
						//��������������������������������Ŀ
						//� Depr da Corre��o Monet mensal  �
						//����������������������������������
						If SN4->N4_CONTA = SN3->N3_CDPCOMA
							dbSelectArea("SN5")
							dbSeek(xFilial()+SN3->N3_CDPCOMA+DTOS(SN4->N4_DATA) + "W" )
							a070del()  // Trata registro do sn5
						EndIf
				EndCase
				
				SN3->(msUnlock())
				
				//ponto de entrada para tratar campos de usuario
				If lAtfa070
					Execblock("AF070DES",.F.,.F.)
				EndIf
				
				//Captar o conteudo de SN4->N4_DATA
				//Captar o conteudo de SN4->N4_IDMOV
				//captar as moedas
				dDataMov	:= SN4->N4_DATA
				cIdMov		:= SN4->N4_IDMOV
				aValDepr 	:= Af070Moeda(__nQuantas,"SN4","N4_VLROC")
				
				PCODETLAN("000364","01")

				PCOFINLAN("000364")

				If SN4->N4_OCORR $ "06/07/10/11/12/17/18/20" .Or. (SN4->N4_OCORR == "21" .And. cPaisLoc == "PTG")
					If RecLock("SN4",.F.)
						// Limpa a chave de relacionamento com SN5 para conseguir excluir o registro
						If ! TcSrvType() $ "AS/400#ADS"
							SN4->N4_DATA  := CTOD("")
							SN4->N4_CONTA := ""
							FkCommit()
						Endif
						SN4->(DbDelete())
						msUnlock()
						FkCommit()
					EndIf
				Endif
				
				If SN4->N4_OCORR == "08"
					RecLock("SN4",.F.)
					// Limpa a chave de relacionamento com SN5 para conseguir excluir o registro
					If ! TcSrvType() $ "AS/400#ADS"
						SN4->N4_DATA  := CTOD("")
						SN4->N4_CONTA := ""
						FkCommit()
					Endif
					SN4->(DbDelete())
					msUnlock()
					FkCommit()
				Endif
				
				//Acrescentado por Fernando Radu Muscalu em 04/05/2011
				//Desfazer movimentacoes dos valores de Rateio das despesas de depreciacao da ficha de ativo
				If FindFunction("ATFRTMOV") .AND. AFXVerRat() .AND. SN3->N3_RATEIO == "1"
					If aScan(aDadoRat,{|x| alltrim(x[1]+x[2]+x[3]+x[4]+x[5]) == Alltrim(SN3->(N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_SEQ))}) == 0
						aAdd(aDadoRat,{	SN3->N3_FILIAL,;
						SN3->N3_CBASE,;
						SN3->N3_ITEM,;
						SN3->N3_TIPO,;
						SN3->N3_SEQ,;
						dDataMov,;
						cIdMov,;
						aValDepr,;
						lCtb,;
						"2",;
						SN3->N3_BAIXA})
					Endif
				Endif
				
				dbSelectArea(cAliasQry)
				dbSkip()
			Enddo
			
			//Atualiza as contas do Tipo 07
			SetFimDepr( aPFimDepr, CTOD('') )
			
			(cAliasQry)->(dbCloseArea()) // Fecha a query
			
			// Retrocede a data da ultima depreciacao
			If cCalcDep == "0"
				cData := DTOS( FirstDay(dDataBase) - 1 )
			Else
				cData := StrZero(Year(dDataBase)-1,4)+cUltDiaMes
			EndIf
			
			AF070AtPar(cFilAnt,cData)
			
			// Se o arquivo for compartilhado, processa apenas uma vez
			If Empty(xFilial("SN3"))
				Exit
			Endif
			
		Endif
		
		//Acrescentado por Fernando Radu Muscalu em 05/05/2011
		//Desfazer movimentacoes dos valores de Rateio das despesas de depreciacao da ficha de ativo
		//Rodar estorno dos movimentos do rateio da ficha do ativo
		If len(aDadoRat) > 0
			Af070UndoMov(aDadoRat,nHdlPrv,cLoteATF,@nTotal)
			aDadoRat := {}
		Endif
		
		//��������������������������������Ŀ
		//� Envia para Lan�amento Cont�bil �
		//����������������������������������
		If (nTotal > 0) .and. (mv_par01 < 3)
			RodaProva( nHdlPrv, nTotal )
			cA100Incl( cArquivo, nHdlPrv, 1, cLoteAtf, lMostra, mv_par02 = 1 )
		Endif
	EndIf
Next

// Restaura a filial
cFilAnt := cFilOld

msUnlockAll()

Pergunte("AFA070",.F.)  //precisa restaurar os mv_par pois pode ser pressionado o botao exp. excel

If lResult .and. mv_par01 == 3 // 1-Mostra,2-Nao Mostra e 3-Nao Contabiliza
	//Registrando no log de processos
	If ValType(oSelf) == "O"
		oSelf:SaveLog("MENSAGEM: Finalizando processo de desc�lculo de deprecia��o")
	EndIf
	Return lResult
Endif

If lResult .and. !lPadrao .And. !lCtb
	dbSelectArea("cArqTmp")
	dbGoTop()
	nHdlPrv := HeadProva( cLoteAtf,"ATFA070",Substr(cUsername,1,6),@cArquivo,.T.)
	//********************************
	// Controle de multiplas moedas  *
	//********************************
	cAtfMoedas := ""
	If lMultMoed
		AtfMultMoe(,,{|x| cAtfMoedas += If(x>1 .and. Empty(GetMV("MV_MOEDA"+Alltrim(Str(x)))),"N","S") })
	Else
		cAtfMoedas += If(Empty(GetMV("MV_MOEDA2")),"N","S")
		cAtfMoedas += If(Empty(GetMV("MV_MOEDA3")),"N","S")
		cAtfMoedas += If(Empty(GetMV("MV_MOEDA4")),"N","S")
		cAtfMoedas += If(Empty(GetMV("MV_MOEDA5")),"N","S")
	Endif
	dbSelectArea("cArqTmp")
	
	If ValType(oSelf) == "O"
		oSelf:SetRegua2(Reccount())
	EndIf
	
	While !Eof()
		
		If ValType(oSelf) == "O" .And. oSelf:lEnd
			Exit
		EndIf
		
		If ValType(oSelf) == "O"
			oSelf:IncRegua2()
		EndIf
		
		cConta  := CONTA
		cCCusto := CCUSTO
		cSubCta := SUBCTA
		
		If Patrim == "N"
			cDebito := SubStr( cConta,  1, 20 )
			cCredito:= SubStr( cConta, 21, 20 )
			cSubDeb := SubStr( cSubCta, 1,  9 )
			cSubCre := SubStr( cSubCta,10,  9 )
		Else
			cDebito := SubStr( cConta, 21, 20 )
			cCredito:= SubStr( cConta,  1, 20 )
			cSubDeb := SubStr( cSubCta,10,  9 )
			cSubCre := SubStr( cSubCta, 1,  9 )
		Endif
		
		cDescr  := Descr
		//********************************
		// Controle de multiplas moedas  *
		//********************************
		aValor	:= If(lMultMoed,AtfMultMoe(,,{|x| 0}), {0,0,0,0,0} )
		
		While !Eof() .and. cConta == CONTA .And. cCCusto == CCUSTO
			
			//********************************
			// Controle de multiplas moedas  *
			//********************************
			If lMultMoed
				AtfMultMoe(,,{|x| aValor[x] += &("VALOR"+Alltrim(Str(x))) })
			Else
				aValor[1] += VALOR1
				aValor[2] += VALOR2
				aValor[3] += VALOR3
				aValor[4] += VALOR4
				aValor[5] += VALOR5
			EndIf
			dbSkip()
		Enddo
		
		cQuaisMoedas := ""
		//********************************
		// Controle de multiplas moedas  *
		//********************************
		If lMultMoed
			AtfMultMoe(,,{|x| cQuaisMoedas += IIf( aValor[x] # 0, "S","N") })
		Else
			cQuaisMoedas += IIf( nValor1 # 0, "S","N")
			cQuaisMoedas += IIf( nValor2 # 0, "S","N")
			cQuaisMoedas += IIf( nValor3 # 0, "S","N")
			cQuaisMoedas += IIf( nValor4 # 0, "S","N")
			cQuaisMoedas += IIf( nValor5 # 0, "S","N")
		EndIf
		
		aLancam[1] := "X"
		aLancam[2] := cDebito
		aLancam[3] := cCredito
		aLancam[4] := nValor1
		aLancam[5] := IIf('CORR' $ cDescr, cQuaisMoedas, cAtfMoedas)
		aLancam[6] := cDescr
		//********************************
		// Controle de multiplas moedas  *
		//********************************
		aLancam[7] := aValor[2]
		aLancam[8] := aValor[3]
		aLancam[9] := aValor[4]
		aLancam[10]:= aValor[5]
		aLancam[11]:= Space( 9 )
		aLancam[12]:= Space( 9 )
		SX3->(DbSetOrder(2))
		
		If SX3->(DbSeek("I2_CCD")) .and. X3USO(SX3->X3_USADO)
			aLancam[11]:= SubStr(cCCusto+Space(9),1,9)
			aLancam[12]:= SubStr(cCCusto+Space(9),1,9)
		EndIf
		
		SX3->(DbSetOrder(1))
		aLancam[13]:= Space( 5 )
		cSet := Set(_SET_DATEFORMAT)
		Set(_SET_DATEFORMAT,"dd/mm/yyyy")
		aLancam[14]:= "  /  /    "
		Set(_SET_DATEFORMAT,cSet)
		aLancam[15]:= Space(40)
		aLancam[16]:= Space( 1 )
		aLancam[17]:= Space(10 )
		aLancam[18]:= Space( 9 )
		aLancam[19]:= cSubCRE
		aLancam[20]:= Space(42)
		nTotal+= af070Detal( nHdlPrv,"ATFA070",cLoteAtf, aLancam )
		dbSelectArea("cArqTmp")
	Enddo
Endif

//���������������������������������Ŀ
//� Envia para Lan�amento Cont�bil  �
//�����������������������������������
If lResult .AND. nTotal > 0
	RodaProva( nHdlPrv, nTotal )
	cA100Incl( cArquivo, nHdlPrv, 1, cLoteAtf, lMostra, mv_par02 = 1 )
Endif

//�������������������������������������������������Ŀ
//� Deleta arquivo de trabalho, se este for criado. �
//���������������������������������������������������
If Select("cArqTmp") > 0
	dbSelectArea( "cArqTmp" )
	cArqTmp->(DbCloseArea())
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+IndexExt())
Endif

dbSelectArea( "SN1" )   // Posiciona no cadastro de bens

//Registrando no log de processos
If ValType(oSelf) == "O"
	oSelf:SaveLog("MENSAGEM: Finalizando processo de desc�lculo de deprecia��o")
EndIf

Return lResult

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � A070del    � Autor � Vinicius Barreira     � Data � 21/11/94 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Deleta registro do SN5 caso esteja zerados os valores       .���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                     ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function A070del(cN1TipoNeg, cN3TipoNeg)

Default cN1TipoNeg := Alltrim(SuperGetMv("MV_N1TPNEG",.F.,"")) // Tipos de N1_PATRIM que aceitam Valor originais negativos
Default cN3TipoNeg := Alltrim(SuperGetMv("MV_N3TPNEG",.F.,"")) // Tipos de N3_TIPO que aceitam Valor originais negativos

If ! SN5->(Eof())
	Reclock("SN5",.F.)
	
	//********************************
	// Controle de multiplas moedas  *
	//********************************
	If lMultMoed
		AtfMultMoe("SN5","N5_VALOR",{|x| SN5->&("N5_VALOR"+Alltrim(Str(x))) -= Round(SN4->&("N4_VLROC"+Alltrim(Str(x))),x3Decimal("N5_VALOR"+Alltrim(Str(x)))) })
	Else
		SN5->N5_VALOR1 -= SN4->N4_VLROC1
		SN5->N5_VALOR2 -= Round(SN4->N4_VLROC2,x3Decimal("N5_VALOR2"))
		SN5->N5_VALOR3 -= Round(SN4->N4_VLROC3,x3Decimal("N5_VALOR3"))
		SN5->N5_VALOR4 -= Round(SN4->N4_VLROC4,x3Decimal("N5_VALOR4"))
		SN5->N5_VALOR5 -= Round(SN4->N4_VLROC5,x3Decimal("N5_VALOR5"))
	EndIf
	// Apaga Registro, se estiver zerado.
	//********************************
	// Controle de multiplas moedas  *
	//********************************
	nTotVlr := 0
	If lMultMoed
		AtfMultMoe(,,{|x| nTotVlr += SN5->&("N5_VALOR"+Alltrim(Str(x))) })
	Else
		nTotVlr += SN5->N5_VALOR1
		nTotVlr += SN5->N5_VALOR2
		nTotVlr += SN5->N5_VALOR3
		nTotVlr += SN5->N5_VALOR4
		nTotVlr += SN5->N5_VALOR5
	EndIf
	If (nTotVlr==0) .Or.;
		(SN3->N3_TIPO != "05" .And. !(SN1->N1_PATRIM $ cN1TipoNeg) .And. !(SN3->N3_TIPO $ cN3TipoNeg) .And.;
		nTotVlr <=0)
		SN5->(FkDelete())
	Endif
	msUnlock()
	FKCOMMIT()
Endif

Return .t.

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � a070Traba  � Autor � Wagner Xavier        � Data � 17/08/93 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Gera um registro no arquivo de trabalho.                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function A070Traba( cConta , dData,   aValor, cDescr, cCCusto, cPatrim, cSubCta )

cSubCta := Iif(cSubCta=NIl,Space(18),cSubCta)
//�������������������������������Ŀ
//� Atualiza arquivo de trabalho  �
//���������������������������������
dbSelectArea( "cArqTmp" )

IF !( cArqTmp -> ( dbSeek ( cConta + cCCusto ) ) )
	Reclock( "cArqTmp" , .t. )
	cArqTmp -> Conta := cConta
	cArqTmp -> DataX := dData
	cArqTmp -> cCusto:= cCCusto
	cArqTmp -> SubCta:= cSubCta
Else
	Reclock( "cArqTmp" )
End

cArqTmp->Descr  := cDescr
//********************************
// Controle de multiplas moedas  *
//********************************
If lMultMoed
	AtfMultMoe(cArqTmp,"Valor",{|x| cArqTmp->&("Valor"+Alltrim(Str(x))) + Iif( aValor[x]=Nil,0,aValor[x] ) })
Else
	cArqTmp->Valor1 += Iif( aValor[1]=Nil,0,aValor[1] )
	cArqTmp->Valor2 += Iif( aValor[2]=Nil,0,aValor[2] )
	cArqTmp->Valor3 += Iif( aValor[3]=Nil,0,aValor[3] )
	cArqTmp->Valor4 += Iif( aValor[4]=Nil,0,aValor[4] )
	cArqTmp->Valor5 += Iif( aValor[5]=Nil,0,aValor[5] )
EndIf
cArqTmp->Patrim := cPatrim
msUnlock()

Return Nil

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �af070Detal  � Autor � Wagner Xavier         � Data �06/05/92 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Grava as linhas de detalhe do arquivo de Contra Prova        ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   �af070Detal(ExpN1,ExpC1,ExpC2,ExpA1)                          ���
��������������������������������������������������������������������������Ĵ��
���Parametros�Arquivo,Programa,Lote,Array com conteudos                    ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function Af070Detal( nHdlPrv,cPrograma,cLote,aCampos )

Local nTotal:=0

IF aCampos [ 4 ] > 0
	FWRITE(nHdlPrv,aCampos[1]+;     // tipo lancto - 1
	aCampos[2]+;                    // cod conta   -20
	aCampos[3]+;                    // contra part -20
	Str(aCampos[4],16,2)+;          // valor 1     -16
	aCampos[5]+;                    // moedas      - 5
	aCampos[6]+;                    // historico   -40
	Str(aCampos[7],16,2)+;          // valor 2     -16
	Str(aCampos[8],16,2)+;          // valor 3     -16
	Str(aCampos[9],16,2)+;          // valor 4     -16
	Str(aCampos[10],16,2)+;         // valor 5     -16
	aCampos[11]+;                   // cc debito   - 9
	aCampos[12]+;                   // cc credito  - 9
	aCampos[13]+;                   // cod seq     - 5
	aCampos[14]+;                   // data vencto - 10
	aCampos[15]+;                   // origem lcto -40
	aCampos[16]+;                   // Inter CP    - 1
	aCampos[17]+;                   // Nome Progr  -10
	aCampos[18]+;                   // item debito   9
	aCampos[19]+;                   // item credito  9
	Space(42)+;
	CHR(13)+;
	CHR(10),312)                    // filler
	dbCommit()
	nTotal+=aCampos[4]
End

Return nTotal

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 � AF070Fil   � Autor � Alice Yamamoto 		  � Data �			���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Criar Indice Condicional da indRegua							���
���������������������������������������������������������������������������Ĵ��
��� Uso		 � IndRegua 													���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function Af070Fil(dUltProc)

Local cFiltro := ""

// Filtra apenas os movimentos de depreciacoes realizados no ultimo calculo de depreciacao
cFiltro :=	"N4_FILIAL == '"+xFilial("SN4")+"' .And. DTOS(N4_DATA) = '"+DTOS(dUltProc)+"' .And. N4_MOTIVO = '  '"

Return cFiltro

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Funcao   �AFA070Valid� Autor � --------------------- � Data � -------- ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o�Efetua as validacoes basicas para o processamento do calculo ���
���          �com filial de/ate                                            ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �ATFA070                                                      ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function AFA070Valid(dUltProc,lAjustInf,cNomeFil)

Local lResult	:= .T.
Local dDataBloq := GetNewPar("MV_ATFBLQM",CTOD(""))
Local lAvpAtf2 := AFAvpAtf2()
Local cAliasQry := ""
Local dUltData

If lResult .AND. dUltProc != dDataBase
	HELP(" ",1,"ATFA070DBA")
	lResult := .F.
Endif

If cPaisLoc =="ARG" .and. lAjustInf .AND. lResult
	If dUltProc <= GetMV("MV_ATFINDT")
		MSGAlert(STR0018,STR0019) //"No se puede hacer el descalculo del activo sin hacer la cancelacion del ajuste de infacion"###"Ajuste"
		lResult := .F.
	Endif
EndIf

//Verifica o par�metro do bloqueio de movimentacao do ativo
If lResult .And. !Empty(dDataBloq) .And. (dDataBase <= dDataBloq)
	HELP(" ",1,"AF070BLQM",,STR0032 + DTOC(dDataBloq) ,1,0)    //"A data do descalculo � igual ou menor que a data de bloqueio de movimenta��o : "
	lResult := .F.
EndIf

//Validacao para o bloquei do proceco
If lResult .And. !CtbValiDt(,dDataBase  ,,,,{"ATF001"},)
	lResult := .F.
EndIf

//AVP2
//Verifica o se existe processo de constituicao de provisao
//Caso exista, o processo de descalculo somente sera permitido
//apos o cancelamento do processo de constituicao de provisao
If lAvpAtf2
	FNN->(dbSetOrder(1))
	If FNN->(MsSeek(xFilial("FNN")+DTOS(dDatabase)))
		While !FNN->(EOF()) .AND. FNN->FNN_FILIAL+DTOS(FNN->FNN_DTPROC) == xFilial("FNN")+DTOS(dDatabase)
			If FNN->FNN_STATUS == '1'
				HELP(" ",1,"AF070T460",,STR0033 +CRLF+ STR0034 +CRLF+ STR0028 +cFilAnt+" - "+cNomeFil ,1,0)    //"Existe processo de constitui��o de provis�o ativo para esta data de desc�lculo."###"� necess�rio que se fa�a o cancelamento dos processos antes do desc�lculo."
				lResult := .F.
				Exit
			Endif
			FNN->(DBSkip())
		Enddo
	Endif
Endif

//verifica se tem movimentos posteriores a data do descalculo e nao deixa prosseguir
If lResult
	cAliasQry := GetNextAlias()
	cQuery := " SELECT "
	cQuery += " 	ISNULL( MAX(N4_DATA), ' ') SN4DTPROC  "
	cQuery += " FROM "  + RetSQLTab("SN4")
	cQuery += " WHERE SN4.N4_FILIAL  = '" + xFilial("SN4") + "' AND "
	cQuery += " N4_OCORR IN ('01','03', '04', '06', '20') AND "
	cQuery += " N4_ORIGEM != 'ATFA012' AND "  //DEPREC ACUMULADA NA INCLUSAO NAO CONSIDERA
	cQuery += " N4_DATA > '" + Dtos(dUltProc) + "'"
	cQuery += " AND D_E_L_E_T_ =  ' ' "
	
	cQuery := ChangeQuery(cQuery)
	
	DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry )
	
	dUltData := STOD((cAliasQry)->SN4DTPROC)
	
	If (cAliasQry)->(!Eof()) .And. dUltData > dUltProc
		Help(" ",1,"050UTDEPR",,"Movimentos posteriores nao permitem descalculo.Verifique!",1,0)		//"Movimentos posteriores nao permitem descalculo.Verifique!"
		lResult := .F.
	Endif
	
	dbSelectArea(cAliasQry)
	dbCloseArea()
Endif

Return lResult

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �AcertaSXD � Autor � Paulo Augusto		 	� Data � 26/08/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria registro no Arq. SXD para execucao do Schedule   	  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 �ATFA050													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AcertaSXD(lAuto)

Local aArea	:= GetArea()

If !lAuto
	SXD->(DbSetOrder(1))
	If !SXD->(DbSeek("ATFA070"))
		DbSelectArea("SXD")
		RecLock("SXD",.T.)
		Replace XD_TIPO 	with "P"
		Replace XD_FUNCAO 	with "ATFA070"
		Replace XD_PERGUNT 	with "AFA070"
		Replace XD_PROPRI 	with "S"
		Replace XD_TITBRZ 	with "Desc�lculo de Ativos Imobilizados"
		Replace XD_TITSPA 	with "Deshace calculo de Activos Inmovilizados"
		Replace XD_TITENG 	with "Fixed Assets Calculation Reverse "
		Replace XD_DESCBRZ 	with "Este programa tem o objetivo de reverter o calculo da Corre��o e Deprecia��o de Ativos Imobilizados."
		Replace XD_DESCSPA 	with "El  objetivo  de  este  programa es revertir el calculo de la Correccion y Depreciacion de Activos Inmovilizados."
		Replace XD_DESCENG 	with "This program has the purpose of reverting the calculation of  Mon.Adj. and Depreciation of Fixed Assets."
		MsUnLock()
	EndIf
EndIf
RestArea(aArea)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Ana Paula N. Silva    � Data �10/12/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados     	  ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
Local aRotina := { {OemToAnsi(STR0004) ,"AllwaysTrue", 0 , 3} } // "Parametros"
Return(aRotina)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �X3FieldName�Autor  �Microsiga           � Data �  01/15/10  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function X3FieldName( cField )

Local cTitulo	:= ""
Local aArea		:= GetArea(  )

dbSelectArea( "SX3" )
dbSetOrder( 2 )

If dbSeek( cField )
	cTitulo := X3Titulo(  )
Endif

RestArea( aArea )

Return AllTrim( cTitulo )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VlMesAnt  �Autor  �Microsiga           � Data �  02/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VlMesAnt( cTipoCNT, cMoeda  , cAliasQry , cId )

Local nResult		:= 0
Local aLstGetArea	:= {}
Local dMesAnt		:= (FirstDay(dDataBase) - 1)
Local i				:= 0
Local cAreas	:= ""

AADD( aLstGetArea, GetArea() )

dbSelectArea("SN4")
AADD( aLstGetArea, GetArea() )
SN4->( DBSetOrder( 1 ) )
If SN4->( DBSeek( SN4->(N4_FILIAL + N4_CBASE + N4_ITEM + N4_TIPO) + DTOS(dMesAnt) + cTipoCNT + SN4->N4_SEQ ) )
	nResult := SN4->&("N4_VLROC"+cMoeda)
Endif

For i := Len( aLstGetArea ) to 1 Step -1
	RestArea( aLstGetArea[ i ] )
Next i

Return nResult

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FldMesAnt �Autor  �Marcelo Akama       � Data �  28/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FldMesAnt( cTipoCNT, cField )

Local uResult	:= nil
Local aArea		:= GetArea()
Local aAreaSN4	:= SN4->(GetArea())
Local dMesAnt	:= (FirstDay(dDataBase) - 1)
Local i			:= 0

dbSelectArea("SN4")
SN4->( DBSetOrder( 1 ) )
If SN4->( DBSeek( SN4->(N4_FILIAL + N4_CBASE + N4_ITEM + N4_TIPO) + DTOS(dMesAnt) + cTipoCNT ) )
	uResult := SN4->&(cField)
Endif

RestArea( aAreaSN4 )
RestArea( aArea )

Return uResult

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AdmAbreSM0� Autor � Orizio                � Data � 22/01/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna um array com as informacoes das filias das empresas ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AdmAbreSM0()

Local aArea			:= SM0->( GetArea() )
Local aAux			:= {}
Local aRetSM0		:= {}
Local lFWLoadSM0	:= .T.
Local lFWCodFilSM0 	:= .T.

If lFWLoadSM0
	aRetSM0	:= FWLoadSM0()
Else
	DbSelectArea( "SM0" )
	SM0->( DbGoTop() )
	While SM0->( !Eof() )
		aAux := { 	SM0->M0_CODIGO,;
		IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
		"",;
		"",;
		"",;
		SM0->M0_NOME,;
		SM0->M0_FILIAL }
		
		aAdd( aRetSM0, aClone( aAux ) )
		SM0->( DbSkip() )
	End
EndIf

RestArea( aArea )

Return aRetSM0

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    �Af070Moeda	� Rev.  �Fernando Radu Muscalu  � Data �09.05.2011���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Carrega vetor de com os valores preenchido no campo, de acordo ���
���          �com a quantidade de moedas. Obs: O Arquivo deve estar 		  ���
���          �posicionado													  ���
�����������������������������������������������������������������������������Ĵ��
���Sintaxe   �Af070Moeda(nQtdMoedas,cAlias,cGrpCampo)					      ���
�����������������������������������������������������������������������������Ĵ��
���Parametros�nQtdMoedas	- Num: Quantidade de moedas utilizada.			  ���
���          �cAlias		- Char: Alias do Arquivo Posicionado			  ���
���          �cGrpCampo		- Char: Nome do campo (grupo) que se repete pelo  ���
���          �prefixo, diferenciando um do outro pelo codigo da moeda	 	  ���
�����������������������������������������������������������������������������Ĵ��
���Retorno   �aValores		- Array: Vetor com os valores correspondentes a	  ���
���          �cada campo pela sua respectiva moeda.  	  					  ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      �SIGAATF - ATFA070 - Localizacao Argentina			      		  ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static Function Af070Moeda(nQtdMoedas,cAlias,cGrpCampo)

Local aValores	:= {}

Local nI		:= 0

Local cCampo	:= ""

For nI := 1 to nQtdMoedas
	cCampo := Alltrim(cGrpCampo) + Alltrim(Str(nI))
	If (cAlias)->(FieldPos(cCampo)) > 0
		aAdd(aValores,(cAlias)->&(cCampo))
	Endif
Next nI

Return (aValores)

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    �Af070UndoMov	� Rev.  �Fernando Radu Muscalu  � Data �05.05.2011���
�����������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao que varre o array aDadoRat, e chama a funcao que desfaz  ���
���          �o movimento de depreciacao do Rateio.					 		  ���
�����������������������������������������������������������������������������Ĵ��
���Sintaxe   �Af070UndoMov(aDadoRat)									      ���
�����������������������������������������������������������������������������Ĵ��
���Parametros�aDadoRat	- Array: Array com os dados de entrada da funcao	  ���
���          �cAlias		- Char: Alias do Arquivo Posicionado			  ���
���          �cGrpCampo		- Char: Nome do campo (grupo) que se repete pelo  ���
���          �prefixo, diferenciando um do outro pelo codigo da moeda	 	  ���
�����������������������������������������������������������������������������Ĵ��
���Retorno   �aValores		- Array: Vetor com os valores correspondentes a	  ���
���          �cada campo pela sua respectiva moeda.  	  					  ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      �SIGAATF - ATFA070 - Localizacao Argentina			      		  ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
Static Function Af070UndoMov(aDadoRat,nHdlPrv,cLoteATF,nTotal)

/*
Acrescentado por Fernando Radu Muscalu em 05/05/2011
Desfazer movimentacoes dos valores de Rateio das despesas de depreciacao da ficha de ativo
Rodar estorno dos movimentos do rateio da ficha do ativo
*/
Local nI	:= 0

For nI := 1 to len(aDadoRat)
	ATFRTMOV(	aDadoRat[nI,1],;
	aDadoRat[nI,2],;
	aDadoRat[nI,3],;
	aDadoRat[nI,4],;
	aDadoRat[nI,5],;
	aDadoRat[nI,6],;
	aDadoRat[nI,7],;
	aDadoRat[nI,8],;
	aDadoRat[nI,9],;
	aDadoRat[nI,10],;
	nHdlPrv,;
	cLoteATF,;
	@nTotal,;
	aDadoRat[nI,11])
Next nI

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AF070AtPar�Autor  �Alvaro Camillo Neto � Data �  09/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza o parametro MV_ULTDEPR dos parametros da filial    ���
���          �corrente dependendo do compartilhamento da tabela SN1       ���
���          �tratamento para gestao corporativa                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AF070AtPar(cFilMov,cData)

Local cFilX 	:= cFilAnt
Local aSM0  	:= AdmAbreSM0()
Local nX		:= 0
Local lExclusivo := ADMTabExc("SN1")

If lExclusivo
	For nX := 1 to Len(aSM0)
		cFilAnt := aSM0[nX][2]
		If Alltrim(aSM0[nX][1]) == Alltrim(cEmpAnt) .And. Alltrim(xFilial("SN3")) == Alltrim(xFilial("SN3",cFilMov))
			PutMv("MV_ULTDEPR", cData)
		EndIf
	Next nX
Else
	PutMv("MV_ULTDEPR", cData)
EndIf

cFilAnt := cFilX

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AF070AtProj�Autor  �Alvaro Camillo Neto � Data �  09/09/11  ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza o parametro MV_ULTDEPR dos parametros da filial    ���
���          �corrente dependendo do compartilhamento da tabela SN1       ���
���          �tratamento para gestao corporativa                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AF070AtProj(cBase,cItem,cTipo,cTipoSld,dData,cOcorr,cSeq )

Local aArea 	:= GetArea()
Local aAreaSN1 := SN1->(GetArea())
Local aAreaSN4 := SN4->(GetArea())
Local cMoeda	:= ""

If __lStruPrj == Nil
	__lStruPrj := .T.
EndIf

If __lStruPrj
	SN1->(DBSetOrder(1)) //N1_FILIAL+N1_CBASE+N1_ITEM
	SN4->(DBSetOrder(1)) //N4_FILIAL+N4_CBASE+N4_ITEM+N4_TIPO+DTOS(N4_DATA)+N4_OCORR+N4_SEQ
	FNE->(DBSetOrder(2)) //FNE_FILIAL+FNE_CODPRJ+FNE_REVIS+FNE_ETAPA+FNE_ITEM+FNE_TPATF+FNE_TPSALD
	If SN1->(MsSeek( xFilial("SN1") + cBase + cItem)) .And. SN4->(MsSeek( xFilial("SN4") + cBase + cItem + cTipo + DTOS(dData) + cOcorr + cSeq ))
		// Acumula tamb�m o tipo 14 que complementa o tipo 10
		cTipo := IIF( cTipo == '14','10', cTipo )
		
		If FNE->(MsSeek( xFilial("FND") + SN1->(N1_PROJETO + N1_PROJREV + N1_PROJETP + N1_PROJITE) + cTipo + cTipoSld ))
			cMoeda := cValtoChar(Val(FNE->FNE_MOEDRF))
			RecLock("FNE",.F.)
			FNE->FNE_VRDACM -= SN4->&("N4_VLROC"+ cMoeda)
			MsUnLock()
		EndIf
	EndIf
EndIf

RestArea(aAreaSN4)
RestArea(aAreaSN1)
RestArea(aArea)

Return

Static Function RestArea( aArea )
If !Empty(aArea[ 1 ] )
    If Select(aArea[ 1 ]) > 0
	   DbSelectArea( aArea[ 1 ] )
	   If aArea[ 2 ] <> IndexOrd()
		   DbSetOrder( aArea[ 2 ] )
       EndIf
	   If ( aArea[ 3 ] <> Nil ) // .And. aArea[ 3 ] <> RecNo() ) // Melhoria de Performace para o Top Connect
		  DbGoTo( aArea[ 3 ] )
	   EndIf
	Endif   
EndIf
Return( nil )
