#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FINA550.CH"


Static lPmsInt:= IsIntegTop(,.T.)
//Permite reposição manual do caixinha com valores acima do limite: 1 - Permite; 2 - Não permite.
STATIC lRpMnAcLim	:= SuperGetMV("MV_RPCXMN",.T.,"1") == "1"
//Permite que sejam realizadas reposições acima do valor do caixinha: T - Permite; F - Não Permite
STATIC lRpAcVlCx	:= SuperGetMV("MV_RPVLMA",.T.,.F.)

user function MGFFIN94()
	Local aArea	:= GetArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega funcao Pergunte									         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte("FIA550",.F.)
	
//		RecLock("SET",.F.)
//			SET->ET_SALDO := 0
//		SET->(MSUNLOCK())
		U_MGFRepos("SET",SET->(RECNO()),4,.F.) // cAlias,nReg,nOpc,lAutomato
	RestArea( aArea )
return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FA550Repos³ Autor ³ Leonardo Ruben        ³ Data ³ 26.06.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reposicao manual dos comprovantes do caixinha              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fa550Repos()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA550                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Comentar. ³ A reposicao manual pode ocorer em duas situacoes:          ³±±
±±³          ³ 1.Caso se deseje baixar os comprovantes em aberto e repor  ³±±
±±³          ³   o saldo do caixinha.                                     ³±±
±±³          ³ 2.Caso o caixa esteja aberto, sem comprovantes para serem  ³±±
±±³          ³   baixados e o saldo eh inferior ao valor do caixa         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MGFRepos(cAlias,nReg,nOpc,lAutomato)

Local aAreaAnt		:= GetArea()
Local cCaixa   		:= SET->ET_CODIGO
Local lAbertos 		:= .F.
Local nVlrRep  		:= 0
Local lPanelFin 	   := IsPanelFin()
Local lRet     		:= .T.
DEFAULT lAutomato    := .F.

Private lEsModII    := Iif(SuperGetMV( "MV_FINCTMD", .T., 1 )==1,.F.,.T.) //Solo aplica para modelo II


If  Type( "lArgTAL" ) <> "U" .And.  lArgTAL      
	lArgTAL := lEsModII
Endif

If !CtbValiDt(,dDatabase,,,,{"FIN001"},)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se permite repósicao                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("F550REPOS")
	lRet := ExecBlock("F550REPOS",.F.,.F.,{cCaixa})
	If !lRet
		Return
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ A reposicao manual pode ocorrer em duas situacoes:                ³
//³ 1.Caso se deseje baixar os comprovantes em aberto e repor o saldo ³
//³ 2.Caso o caixa esteja aberto, sem comprovantes para serem baixados³
//³   e o saldo seja inferior ao valor do caixa.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Fa550ConfDT(cCaixa)
	Help(" ",1,"FA550DATA")
	Return .F.
Endif


PcoIniLan("000359")

lAbertos := Fa550ComAbe(cCaixa)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa se existem comprovantes nao baixados para o caixinha   ³
//³ caso o parametro esteja ativado                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lAbertos
	If Fa550Verif()
		nVlrRep := U_MGFRep20(cCaixa,.F.,.T.,,,,lAutomato)  // repoe sem baixar //Bruno
	Else
		nVlrRep := U_MGFRepor( cCaixa,.F.,.T.,,,lAutomato)  // repoe sem baixar //Bruno
	Endif
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Existem comprovantes nao baixados, portanto eh possivel fazer a ³
	//³ reposicao manual.                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Fa550Verif()
		nVlrRep := U_MGFRep20(cCaixa,.T.,.T.,,,,lAutomato)  // Baixa e repoe
	Else
		nVlrRep := U_MGFRepor( cCaixa,.T.,.T.,,,lAutomato)  // Baixa e repoe
	Endif
EndIf

RestArea(aAreaAnt)

PcoFinLan("000359")

If lPanelFin  //Chamado pelo Painel Financeiro
	cAlias := FinWindow:cAliasFile
	dbSelectArea(cAlias)
	FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)
Endif
Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MGFRepor ³ Autor ³ Leonardo Ruben        ³ Data ³ 26.06.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a reposicao do caixinha                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fa550Repor(ExpC1,ExpL1,ExpL2,ExpL3,ExpL4)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Caixinha											  ³±±
±±³          ³ ExpL1 = Baixa de Movimentos										  ³±±
±±³          ³ ExpL2 = Reposicao de saldo do caixinha							  ³±±
±±³          ³ ExpL3 = Reposicao Originada pela Inclusao do Caixinha 	  ³±±
±±³          ³ ExpL4 = Baixa de Movimentos no Fechamento						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA550/FINA560                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MGFRepor(cCaixa,lBaixa,lRepor,lOriMv,lFecha,lAutomato)

Local aAreaAnt		:= GetArea()
Local aRegBaix 		:= {}
Local nx 			:= 0
Local nVlrBaix 		:= 0
Local nVlrRep 		:= 0
Local cSeqCxa
Local lFirstRep 	:= .T.
Local nHdlPrv 		:= 0
Local aSEUCont		:=	{}
Local lDigita   	:= IIF(mv_par01==1,.T.,.F.)
Local lAglutina 	:= IIf(mv_par02==1,.T.,.F.)
Local lGeraLanc 	:= IIf(mv_par03==1,.T.,.F.)
Local cArquivo
Local nTotal 		:= 0
Local lPadrao572
Local lPadrao573
Local lLimite 		:= IIf(mv_par04==1,.T.,.F.)	// Considerar ou nao o Limite de conta
Local nSaldoAnt 	:= 0
Local lSai 			:= .F.
Local lAbriu 		:= .F.
Local lF550SBCO 	:= ExistBlock("F550SBCO")
Local lRegMovBco 	:= .T.
Local lVerSaldo 	:= .T.
Local aAlias 		:= {}
Local cNumAd		:= " "
Local aFlagCTB 		:= {}
Local lUsaFlag		:= SuperGetMV("MV_CTBFLAG", .T. /*lHelp*/, .F. /*cPadrao*/)
Local lFindITF 		:= .T.
Local lFA550REP		:= Existblock("FA550REP")
Local cTipoLib      := SuperGetMV( "MV_FINCTAL", .T., "1" )
Local nOpcLib       := 0
Local lTemBaixa := .T.
Local nVlPend   := 0
Local lAtuSldNat := FindFunction("AtuSldNat") .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
Local aAreaSET   := {}
Local nValLim		:= 0

Default lAutomato := .F.

Private cLote
Private aReposi:={}
lBaixa := If( lBaixa = nil, .F., lBaixa)  // Baixa movimentos
lRepor := If( lRepor = nil, .F., lRepor)  // Repoe
lOriMv := If( lOriMv = nil, .F., lOriMv)  // Reposicao originada pela entrada de movimento (atingiu limite)
lFecha := If( lFecha = nil, .F., lFecha)  // Baixa movimentos

nMoedaBco := IIf( Type('nMoedaBco') == 'U',0,nMoedaBco )

If lRepor .and. cPaisLoc $'ARG|BRA' .and. lRpMnAcLim
	If !U_MGFBcRep(cCaixa,,@aReposi,0,,lLimite) // Fa550BcRep MGFBcRep
		Return(0) /*Function Fa550Rep20*/
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Solicita aprovação para reposição de saldo do caixinha.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Se configurado para aprovação de alçadas 
	If ( cTipoLib == "2" )
		nOpcLib := Fa550Libera(aReposi)

		//Se não foi aprovado termina
		If nOpcLib == 0
			Return 0
		EndIf

	EndIf
Endif

LoteCont("FIN")



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se gera movimentacao bancaria.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("F55CMBCO")
	lRegMovBco := ExecBlock("F55CMBCO",.F.,.F.)
	If ValType(lRegMovBco) <> 'L'
		lRegMovBco := .T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de lanc. Padronizados                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lPadrao572:=If( lGeraLanc , VerPadrao("572"), .F.)
lPadrao573:=If( lGeraLanc , VerPadrao("573"), .F.)

If !lFecha
	If !lAutomato
		If  !MsgYesNo(STR0035,OemToAnsi(STR0006)) //"Confirma Reposição do Caixinha ?"
			Return 0 /*Function Fa550Repor*/
		Endif
	EndIf
Endif

If !DtMovFin(,,"1")
	Return 0 /*Function Fa550Repor*/
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controlo se existe saldo no banco para repor.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SET")
dbSetOrder(1)  // filial + caixa
dbSeek( xFilial()+cCaixa)

If lF550SBCO
	lVerSaldo := ExecBlock("F550SBCO",.F.,.F.,{SET->ET_CODIGO,SET->ET_BANCO,SET->ET_AGEBCO,SET->ET_CTABCO})
Endif

If !GetNewPar("MV_CXSLBCO",.F.)
	If lVerSaldo .and. lRepor .And. SldBco(SET->ET_BANCO,SET->ET_AGEBCO,SET->ET_CTABCO,,,lLimite) <= 0
		Help(" ",1,"SldBco")
		Return  0 /*Function Fa550Repor*/
	Endif
Endif

//VERIFICA BLOQUEIO DE CONTA CORRENTE
If lRepor .and. CCBLOCKED(SET->ET_BANCO,SET->ET_AGEBCO,SET->ET_CTABCO)
	Return  0 /*Function Fa550Repor*/
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controlo se o saldo do caixinha ja esta reposto, ou  ³
//³ seja, eh igual ao valor do mesmo.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SEU")
dbSetOrder(5)  // filial + caixa + sequencia + num
dbSeek( xFilial()+ cCaixa )
While !Eof() .And. xFilial()+cCaixa == EU_FILIAL+EU_CAIXA
	If (EU_TIPO == "01") .And. Empty(EU_BAIXA)
			nVlPend += EU_SLDADIA	// Saldo do adiantamento
			cNumAd  += IIF(!Empty(cNumAd),"/","") + Alltrim(EU_NUM)
	EndIf
	SEU->(DbSkip())
End

IF SET->ET_TPREP = "0"	// Tipo de reposição: 0=Por Valor Limite;1=Por Porcentagem
	nValLim := SET->ET_LIMREP	// Valor/Percentual de reposição
Else
	nValLim := SET->ET_LIMREP/100 * SET->ET_VALOR
EndIf

If !lOriMv .And. lRepor .And. (nValLim <= (SET->ET_SALDO+nVlPend) .AND. !lRpAcVlCx)
	If nVlPend > 0	// Saldo do adiantamento
		Aviso(STR0067,STR0068 + Alltrim(cNumAd) + STR0069,{STR0070})
		cNumAd := ""
	Else
		HELP(' ',1, "F550NOREP",, STR0127 ,2,0,,,,,,{STR0128})  //"Caixinha possui saldo superior ao limite estabelecido para reposição. Não é necessário reposição."###"Verifique se o caixinha selecionado é o que necessita de reposição, ou se a operação do menu é a desejada."
	EndIf
	Return  0 /*Function Fa550Repor*/
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona-se no cadastro de caixinhas                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SET")
dbSetOrder(1)  // filial + caixa
dbSeek( xFilial()+cCaixa)
If SET->ET_SITUAC == "1"
	If !lAutomato
		If !MsgYesNo(OemToAnsi(STR0018),OemToAnsi(STR0017)) //"Deseja abrir o Caixinha?"###"Caixinha Fechado"
			Return  0 /*Function Fa550Repor*/
		Else
			lAbriu := .T.
			RecLock("SET",.F.)
			Replace ET_SITUAC With "0"
			Replace ET_SEQCXA With SOMA1(ET_SEQCXA)
			MsUnLock()
			PcoDetLan("000359","01","FINA550")
		Endif
	Else 
			lAbriu := .T.
			RecLock("SET",.F.)
			Replace ET_SITUAC With "0"
			Replace ET_SEQCXA With SOMA1(ET_SEQCXA)
			MsUnLock()
			PcoDetLan("000359","01","FINA550")
	EndIf
Else
	lAbriu := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Checar se existem os lancamentos padrao e se nao foi       ³
//³inicializado e inicializar o HeadProva caso for necesario  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdlPrv <= 0 .And. (lPadrao572.Or.lPadrao573)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Lancamento Contabil                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nHdlPrv := HeadProva( cLote,;
		                      "FINA550" /*cPrograma*/,;
		                      Substr( cUsuario, 7, 6 ),;
		                      @cArquivo )
Endif

Begin Transaction
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retorna a sequencia atual do caixinha                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSeqCxa := Fa570SeqAtu( cCaixa)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pesquisa comprovantes                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEU")
	dbSetOrder(5)  // filial + caixa + sequencia + num
	dbSeek( xFilial()+ cCaixa + cSeqCxa)
	While !Eof() .And. xFilial()+cCaixa+cSeqCxa == EU_FILIAL+EU_CAIXA+EU_SEQCXA
		lFirstRep := .F.  // nao eh primeira reposicao do caixinha
		If !( SEU->EU_TIPO $ "10/11")
			AAdd(aSEUCont,SEU->(RECNO()))
		Endif
		If EU_TIPO == "10"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Reposicao incial da ultima sequencia (abertura)   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotRep := SET->ET_VALOR - SET->ET_SALDO
			dbSkip()
			Loop
		ElseIf EU_TIPO == "11"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³fechou-se a sequencia (caixa fechado, pois esta   ³
			//³eh a ultimia sequencia). Saldo zero.              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotRep  := 0
			nVlrBaix := 0
			Exit
		ElseIf (EU_TIPO == "00" .And. !Empty(EU_BAIXA))
		     aAlias:= GetArea()
		     cNumAd:= EU_NUM
		     cNroAd:= EU_NROADIA

		     SEU->(DbSetOrder(1))
		   	 If DbSeek(xFilial("SEU")+cNroAd+cCaixa+"01")
		     	If EU_SEQCXA < cSeqCxa
		   	 		RestArea(aAlias)
				  	nVlrBaix += EU_VALOR
					dbSkip()
					Loop
		   		EndIf
             EndIf

		     SEU->(DbSetOrder(6))
		     If !(Dbseek(xFilial("SEU")+cCaixa+"02"+ cNumAd)) // Verifica se se a depesa nao foi cancelada
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gastos/despesas baixados nao sao somados          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RestArea(aAlias)
				dbSkip()
				Loop
			Else
				RestArea(aAlias)
			EndIf
		//ElseIf (EU_TIPO == "00" .And. !Empty(EU_NROADIA))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gastos/despesas de adiantamentos nao sao somados  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//dbSkip()
			//Loop
		ElseIf (EU_TIPO == "01")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiantamentos: Tendo ou nao saldo, considero o valor   ³
			//³total como despesa/gasto. Porem nao armanzeno no vetor ³
			//³de registros a serem baixados (aRegBaix)               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  		If Empty(EU_BAIXA)
		   		Aviso(STR0067,STR0068 + aLLTRIM(SEU->EU_NUM) + STR0069,{STR0070})//"Atenção"##"O movimento de adiantamento "##" esta pendênte de prestação de contas e não será baixado, com esta pendência o caixinha não será finalizado."##"Ok"
				lTemBaixa:= .F.
				dbSkip()
				Loop
			Else
				nVlrBaix += EU_VALOR
			EndIf

			dbSkip()
			Loop
		ElseIf EU_TIPO == "02"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o tipo for devolucao de adiantamento, o mesmo foi   ³
			//³rendido/baixado, logo considero o quanto foi devolvido ³
			//³como reposicao para o caixinha. Desconto do total de   ³
			//³comprovantes (pois considerei o adiantamento inicial)  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nVlrBaix -= EU_VALOR

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Este bloco testa se a devolução é referente a um adiantamento ³
			//³em aberto, feito antes da última reposição, pois este é ³
			//³desconsiderado.                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAlias:= GetArea()
			cNroAd:= EU_NROADIA
			SEU->(DbSetOrder(1))
			If DbSeek(xFilial("SEU")+cNroAd+cCaixa+"01")
		     	If EU_SEQCXA < cSeqCxa
		   			RestArea(aAlias)
				  	nVlrBaix += EU_VALOR
					dbSkip()
					Loop
			   	Else
				   	RestArea(aAlias)
			   		dbSkip()
					Loop
			   	EndIf
		   Else
		   		RestArea(aAlias)
		   		dbSkip()
				Loop
		   EndIf
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Aqui estao sendo somados   :                           ³
		//³- Gastos/despesas em aberto (tipo 00)                  ³
		//³- Adiantamentos fechados/rendidos (tipo 01)            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD( aRegBaix, Recno())
		nVlrBaix += EU_VALOR
		dbSkip()
	EndDo

	If lBaixa .and. Len( aRegBaix)>0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pediu-se para baixar e existem comprovantes para tal  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx := 1 to Len( aRegBaix)
			dbGoto( aRegBaix[nx])
			RecLock("SEU",.F.)
			REPLACE EU_BAIXA WITH dDataBase
			MsUnlock()
			PcoDetLan("000359","02","FINA550")
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valor reposto eh exatamente o montante que foi baixado/rendido     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRpMnAcLim .and. LEN(aReposi) > 0
			nVlrRep := aReposi[7] - SET->ET_SALDO
		Else
		nVlrRep := nValLim - SET->ET_SALDO
		EndIf
		
	ElseIf nVlrBaix > 0 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valor reposto eh exatamente o montante que foi baixado/rendido     ³
		//³ Se aRegBaix for nulo, eh porque esta sequencia do caixinha compoe- ³
		//³ se estritamente de adiantamentos.                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nVlrRep := nVlrBaix
	ElseIf nVlrBaix = 0 .And. lTemBaixa
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valor reposto eh exatamente o total do caixinha                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF	FWIsInCallStack('FA550REPAUT')
			// Criação do Caixinha
			nVlrRep := SET->ET_VALOR
		Else
			nVlrRep := nValLim - SET->ET_SALDO
		Endif
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada para validar ou não o saldo do banco vinculado    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lF550SBCO
		lVerSaldo := ExecBlock("F550SBCO",.F.,.F.,{SET->ET_CODIGO,SET->ET_BANCO,SET->ET_AGEBCO,SET->ET_CTABCO})
	Endif

	//Verifico se o banco tem saldo para repor ao caixinha
	If !GetNewPar("MV_CXSLBCO",.F.)
		If lVerSaldo .and. lRepor .And. SldBco(SET->ET_BANCO,SET->ET_AGEBCO,SET->ET_CTABCO,,,lLimite) < nVlrRep
			Help(" ",1,"SldBco")
			nVlrRep := 0
			lSai := .T.
			DisarmTransaction()
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada para validar se continua a reposicao
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("F550VRPS")
		lSai := ExecBlock("F550VRPS",.F.,.F.,{nVlrRep})
		If ValType(lSai) <> 'L'
			lSai := .F.
		Else // Se o PE retornar falso não deve continuar
			lSai := !lSai
		EndIf
	Endif

	//Contabilizar
	If !lSai
		For nX	:= 1	To Len(aSEUCont)
			SEU->(DbGoTo(aSEUCont[nX]))
			If lPadrao572 .and.  nHdlPrv > 0 .And. Empty(SEU->EU_LA)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Prepara Lancamento Contabil                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, {"EU_LA", "S", "SEU", SEU->( Recno() ), 0, 0, 0} )
					Endif
					nTotal += DetProva( nHdlPrv,;
					                    "572" /*cPadrao*/,;
					                    "FINA550" /*cPrograma*/,;
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
			Endif
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a reposicao do caixinha                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRepor
			nSaldoAnt := SET->ET_SALDO

			If ExistBlock("F550VREP")
				nVlrRep := ExecBlock("F550VREP",.F.,.F.,{nVlrRep,nSaldoAnt})
				While ((SET->ET_SALDO+nVlrRep)>SET->ET_VALOR) .and. !lRpMnAcLim
					Help(" ",1,"VLRMAIOR",,STR0044 +' [F550VREP]',1,0) //"Valor maior que o permitido."
				EndDo
			Endif

			RecLock("SET",.F.)

			If cPaisLoc <> "BRA"
				REPLACE SET->ET_SALANT with nSaldoAnt
			EndIf
			
			If nSaldoAnt > 0
				REPLACE ET_SALANT 	WITH  ET_SALDO	
			EndIf			

			REPLACE ET_SALDO 	WITH   nSaldoAnt+ nVlrRep
			If !lAbriu
				REPLACE ET_SEQCXA WITH SOMA1(ET_SEQCXA)
			Endif
			REPLACE ET_ULTREP WITH dDataBase
			MsUnlock()
			PcoDetLan("000359","01","FINA550")

		EndIf

		If lAtuSldNat .And. !lFirstRep
		
			aAreaSET := SET->(GetArea())
			dbSelectArea("SA6")
			If SA6->A6_COD == SET->ET_BANCO
				nMoedaBco := SA6->A6_MOEDA
			Else
				dbSetOrder(1)
				If dbSeek(xFilial("SA6")+SET->ET_BANCO+SET->ET_AGEBCO+SET->ET_CTABCO)
					nMoedaBco := SA6->A6_MOEDA
				EndIf
			EndIf
			RestArea(aAreaSET)
		
			AtuSldNat(SET->ET_NATUREZ, dDataBase, nMoedaBco, "3", "P", nVlrRep,xMoeda(nVlrRep, nMoedaBco, 1,dDataBase,3,RecMoeda(dDataBase, nMoedaBco)), "+",,FunName(),"SET", SET->(Recno()),0)
		EndIf
		
		dbSelectArea("SET")
		dbSetOrder(1)
		dbSeek( xFilial("SET")+cCaixa)
		If lRepor
		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ Registra movimento de reposicao (tipo 10)                      ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Fa550Mov( ET_CODIGO, "10", nVlrRep,STR0019+SET->ET_BANCO)  //"Reposicion de banco "
			// SAIDA EM BANCO
		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ Registra movimento no banco				                       ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRegMovBco // Por movimentação financeira
				Fa550MvBco("S", nVlrRep, STR0020) //"REPOSICAO DE CAIXA"
				If lFindITF .And. FinProcITF( SE5->( Recno() ),1 ) .AND. lRetCkPG(3,,SET->ET_BANCO)
					FinProcITF( SE5->( Recno() ),3,, .F.,{ nHdlPrv, "573", "", "FINA550", cLote } , @aFlagCTB )
				EndIf
			EndIf

			If lPadrao573 .and.  nHdlPrv > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Prepara Lancamento Contabil                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, {"EU_LA", "S", "SEU", SEU->( Recno() ), 0, 0, 0} )
					Endif
					nTotal += DetProva( nHdlPrv,;
					                    "573" /*cPadrao*/,;
					                    "FINA550" /*cPrograma*/,;
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
				AAdd(aSEUCont,SEU->(RECNO()))
			Endif
		EndIf

		If lFecha
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Fechar caixinha caso solicitado                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nVlrMov := Fa550Fecha( cCaixa)
			If lPadrao573 .and. nHdlPrv > 0 .And. nVlrMov > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Prepara Lancamento Contabil                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, {"EU_LA", "S", "SEU", SEU->( Recno() ), 0, 0, 0} )
					Endif
					nTotal += DetProva( nHdlPrv,;
					                    "573" /*cPadrao*/,;
					                    "FINA550" /*cPrograma*/,;
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
				AAdd(aSEUCont,SEU->(RECNO()))
			Endif
		Endif

		If nHdlPrv > 0 .and. (lPadrao572.or.lPadrao573)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetiva Lan‡amento Contabil                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If UsaSeqCor()
					aDiario := {}
					AADD(aDiario,{"SEU",SEU->(recno()),SEU->EU_DIACTB,"EU_NODIA","EU_DIACTB"})
				Else
					aDiario := {}
				Endif
				RodaProva( nHdlPrv,;
				           nTotal )

				If cA100Incl( cArquivo,;
					           nHdlPrv,;
					           3 /*nOpcx*/,;
					           cLote,;
					           lDigita,;
					           lAglutina /*lAglut*/,;
					           /*cOnLine*/,;
					           /*dData*/,;
					           /*dReproc*/,;
					           @aFlagCTB,;
					           /*aDadosProva*/,;
					           aDiario )

					For nX := 1	To Len(aSEUCont)
						SEU->(DbGoTo(aSEUCont[nX]))
						If !lUsaflag
							Reclock("SEU",.F.)
							Replace EU_LA	With "S"
							MsUnLock()
						Endif
						PcoDetLan("000359","02","FINA550")
					Next
				Endif

				aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

		Endif
	Endif
	dbCommitAll()
End Transaction

IF lFA550REP // gravação de dados complementares.
	ExecBlock("FA550REP",.F.,.F.)
ENDIF
RestArea(aAreaAnt)
Return nVlrRep /*Function Fa550Repor*/


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ 	MGFRep20³ Autor ³ Marcello              ³ Data ³ 26.06.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a reposicao do caixinha                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fa550Repor(ExpC1,ExpL1,ExpL2,ExpL3,ExpL4,ExpN5)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Caixinha								  ³±±
±±³          ³ ExpL1 = Baixa de Movimentos								  ³±±
±±³          ³ ExpL2 = Reposicao de saldo do caixinha					  ³±±
±±³          ³ ExpL3 = Reposicao Originada pela Inclusao do Caixinha 	  ³±±
±±³          ³ ExpL4 = Baixa de Movimentos no Fechamento				  ³±±
±±³          ³ ExpN5 = Numero do recno no arquivo de movimentos 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA550/FINA560                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MGFRep20(cCaixa,lBaixa,lRepor,lOriMv,lFecha,nRegSEU,lAutomato)
Local aAreaAnt := GetArea()
Local aRegBaix := {}
Local nx := 0, nVlrBaix := 0
Local nVlrRep := 0
Local cSeqCxa
Local lFirstRep := .T.
Local nHdlPrv := 0
Local aSEUCont	:=	{}
Local lDigita   := IIF(mv_par01==1,.T.,.F.)
Local lAglutina := IIf(mv_par02==1,.T.,.F.)
Local lGeraLanc := IIf(mv_par03==1,.T.,.F.)
Local cArquivo
Local nTotal := 0
Local lPadrao572
Local lPadrao573
Local lPadrao579
Local lLimite := IIf(mv_par04==1,.T.,.F.)	// Considerar ou nao o Limite de conta
Local nSaldoAnt := 0
Local lAbriu := .F.
Local lExisteTit := .F.
Local aSE5 := {}, aSE2 := {}
Local lF550SBCO := ExistBlock("F550SBCO")
Local lVerSaldo := .T.
Local aFlagCTB := {}
Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
Local lFindITF := .T.
Local lFA550REP	:= Existblock("FA550REP")
Local cTipoLib  := SuperGetMV( "MV_FINCTAL", .T., "1" )
Local nOpcLib   := 0

Private lTpDeb := .T.
Private cTipoDeb := "2"
Private aBcoRep:={}, aReposi:={}
Private nValor := 0
Private cBcoRep := " "
Private cAgeRep := " "
Private cCtaRep := " "
Private cTipo := " "
Private lMovBco:=.F.

Private cLote
LoteCont("FIN")

DEFAULT nRegSEU := 0
DEFAULT lAutomato := .F.

lBaixa := If( lBaixa = nil, .F., lBaixa)  // Baixa movimentos
lRepor := If( lRepor = nil, .F., lRepor)  // Repoe
lOriMv := If( lOriMv = nil, .F., lOriMv)  // Reposicao originada pela entrada de movimento (atingiu limite)
lFecha := If( lFecha = nil, .F., lFecha)  // Baixa movimentos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona-se no cadastro de caixinhas                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SET")
dbSetOrder(1)  // filial + caixa
dbSeek( xFilial("SET")+cCaixa)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controlo se o saldo do caixinha ja esta reposto, ou  ³
//³ seja, eh igual ao valor do mesmo.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lOriMv .And. lRepor .And. SET->ET_SALDO > 0 .And. (SET->ET_VALOR <= SET->ET_SALDO .AND. !lRpAcVlCx)
	Help(" ",1,"FA550JAREP")  // Saldo ja esta reposto
	Return  0 /*Function Fa550Rep20*/
Endif

If !DtMovFin(,,"1")	
	Return 0 /*Function Fa550Rep20*/
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia de lanc. Padronizados                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lPadrao572:=If( lGeraLanc , VerPadrao("572"), .F.)
lPadrao573:=If( lGeraLanc , VerPadrao("573"), .F.)
lPadrao579:=If( lGeraLanc , VerPadrao("579"), .F.)

If SET->ET_SITUAC == "1"
	If !MsgYesNo(OemToAnsi(STR0018),OemToAnsi(STR0017)) //"Deseja abrir o Caixinha?"###"Caixinha Fechado"
		Return  0 /*Function Fa550Rep20*/
	Else
		RecLock("SET",.F.)
		Replace ET_SITUAC With "0"
		REPLACE ET_SEQCXA With SOMA1(ET_SEQCXA)
		MsUnLock()
		PcoDetLan("000359","01","FINA550")
		lAbriu:=.T.
	Endif
Else
	lAbriu:=.F.
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna a sequencia atual do caixinha                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSeqCxa := Fa570SeqAtu( cCaixa)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecao do banco para reposicao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aBcoRep:={}
aReposi:={}
If lRepor
	If !U_MGFBcRep(cCaixa,@aBcoRep,@aReposi,0,nRegSEU,lLimite,lAutomato) // MGFBcRep
		Return(0) /*Function Fa550Rep20*/
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Solicita aprovação para reposição de saldo do caixinha.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Se configurado para aprovação de alçadas
	If ( cTipoLib == "2" ) .and. cPaisLoc $ 'ARG|BRA'
		nOpcLib := Fa550Libera( aReposi )

		//Se não foi aprovado termina
		If nOpcLib == 0
			Return 0
		EndIf
	EndIf

	cBcoRep :=aBcoRep[1]
	cAgeRep :=aBcoRep[2]
	cCtaRep :=aBcoRep[3]
	nValor  :=aReposi[7]
	nVlrRep :=aReposi[7]
	cTipo   :=aReposi[1]
	cTipoDeb:=aReposi[2]
	cTpTit  :=aReposi[3]
	lTpDeb := aReposi[8]
Else
	cBcoRep :=SET->ET_BANCO
	cAgeRep :=SET->ET_AGEBCO
	cCtaRep :=SET->ET_CTABCO
	nValor  :=SET->ET_VALOR
	nVlrRep :=nVlrBaix
	cTipo   :="10"
	cTipoDeb:="2"
	If !lBaixa
		If !MsgYesNo(STR0035,OemToAnsi(STR0006)) //"Confirma Reposição do Caixinha ?"
			Return 0 /*Function Fa550Rep20*/
		Endif
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controlo se existe saldo no banco para repor.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SET")
dbSetOrder(1)  // filial + caixa
dbSeek( xFilial()+cCaixa)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para validar ou não o saldo do banco vinculado    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lF550SBCO
	lVerSaldo := ExecBlock("F550SBCO",.F.,.F.,{SET->ET_CODIGO,SET->ET_BANCO,SET->ET_AGEBCO,SET->ET_CTABCO})
Endif

If !GetNewPar("MV_CXSLBCO",.F.)
	If lVerSaldo .and. lRepor .And. SldBco(cBcoRep,cAgeRep,cCtaRep,,,lLimite) <= 0
		Help(" ",1,"SldBco")
		Return  0 /*Function Fa550Rep20*/
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa comprovantes                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBaixa .And. !(cTipo$"90|91")
	dbSelectArea("SEU")
	dbSetOrder(5)  // filial + caixa + sequencia + num
	dbSeek( xFilial()+ cCaixa + cSeqCxa)
	While !Eof() .And. xFilial()+cCaixa+cSeqCxa == EU_FILIAL+EU_CAIXA+EU_SEQCXA
		lFirstRep := .F.  // nao eh primeira reposicao do caixinha
		If !( SEU->EU_TIPO $ "10/11")
			AAdd(aSEUCont,SEU->(RECNO()))
		Endif
		If EU_TIPO == "10"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Reposicao incial da ultima sequencia (abertura)   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotRep := SET->ET_VALOR - SET->ET_SALDO
			dbSkip()
			Loop
		ElseIf EU_TIPO == "11"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³fechou-se a sequencia (caixa fechado, pois esta   ³
			//³eh a ultimia sequencia). Saldo zero.              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotRep  := 0
			nVlrBaix := 0
			Exit
		ElseIf (EU_TIPO == "00" .And. !Empty(EU_BAIXA))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gastos/despesas baixados nao sao somados          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSkip()
			Loop
		ElseIf (EU_TIPO == "00" .And. !Empty(EU_NROADIA))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gastos/despesas de adiantamentos nao sao somados  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSkip()
			Loop
		ElseIf (EU_TIPO == "01")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiantamentos: Tendo ou nao saldo, considero o valor   ³
			//³total como despesa/gasto. Porem nao armanzeno no vetor ³
			//³de registros a serem baixados (aRegBaix)               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nVlrBaix += EU_VALOR
			dbSkip()
			Loop
		ElseIf EU_TIPO == "02"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o tipo for devolucao de adiantamento, o mesmo foi   ³
			//³rendido/baixado, logo considero o quanto foi devolvido ³
			//³como reposicao para o caixinha. Desconto do total de   ³
			//³comprovantes (pois considerei o adiantamento inicial)  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nVlrBaix -= EU_VALOR
			dbSkip()
			Loop
		ElseIf EU_TIPO>="90"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Reposicoes canceladas, aguardando autorizacao, cheques ³
			//³aguardando compensacao etc.                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			DbSkip()
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Aqui estao sendo somados   :                           ³
		//³- Gastos/despesas em aberto (tipo 00)                  ³
		//³- Adiantamentos fechados/rendidos (tipo 01)            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD( aRegBaix, Recno())
		nVlrBaix += EU_VALOR
		dbSkip()
	EndDo
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Checar se existem os lancamentos padrao e se nao foi       ³
//³inicializado e inicializar o HeadProva caso for necesario  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdlPrv <= 0 .And. (lPadrao572.Or.lPadrao573)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Lancamento Contabil                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nHdlPrv := HeadProva( cLote,;
		                      "FINA550" /*cPrograma*/,;
		                      Substr( cUsuario, 7, 6 ),;
		                      @cArquivo )
Endif

Begin Transaction
	DbSelectArea("SEU")
	If cTipo<>"90"
		If lBaixa .And. Len( aRegBaix)>0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pediu-se para baixar e existem comprovantes para tal  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nx := 1 to Len( aRegBaix)
				dbGoto( aRegBaix[nx])
				RecLock("SEU",.F.)
				REPLACE EU_BAIXA WITH dDataBase
				MsUnlock()
				PcoDetLan("000359","02","FINA550")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada F550BAIX             							     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ExistBlock("F550BAIX")
					ExecBlock("F550BAIX",.F.,.F.)
				Endif
			Next
	    Endif
		//Contabilizar
		For nX	:= 1	To Len(aSEUCont)
			SEU->(DbGoTo(aSEUCont[nX]))
			If lPadrao572 .and.  nHdlPrv > 0 .And. Empty(SEU->EU_LA)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Prepara Lancamento Contabil                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, {"EU_LA", "S", "SEU", SEU->( Recno() ), 0, 0, 0} )
					Endif
					nTotal += DetProva( nHdlPrv,;
					                    "572" /*cPadrao*/,;
					                    "FINA550" /*cPrograma*/,;
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

			Endif
		Next
	Endif

	dbSelectArea("SET")
	dbSetOrder(1)
	dbSeek( xFilial()+cCaixa)
	If lRepor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a reposicao do caixinha                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSaldoAnt := SET->ET_SALDO
		cProxRep	:=	''
	   If cPaisLoc <> "BRA"
			DbSelectArea("SEU")
			aAreaSEU	:=	GetArea()
			DbSetOrder(8)
			DbSeek(xFilial()+SET->ET_CODIGO+"zzzzzzzzzz",.T.)
			DbSkip(-1)
			While xFilial()+SET->ET_CODIGO == EU_FILIAL+EU_CAIXA .And. Empty(cProxRep)
				If !(EU_TIPO $ '90/91/92')
					cProxRep	:=	EU_NRREND
				Endif
				DbSkip()
			Enddo
			RestArea(aAreaSEU)
			DbSelectArea('SET')
		Endif
		IF Empty(cProxRep)
			cProxRep	:=	SET->ET_NRREND
	   Endif
		RecLock("SET",.F.)
		If cTipo<"90" .Or. cTipo == "92"
			REPLACE ET_NRREND	WITH SOMA1(cProxRep)

			Replace SET->ET_SALANT with SET->ET_SALDO

			If lTpDeb .Or. cPaisLoc == "BRA"
				REPLACE ET_SALDO	WITH ET_SALDO+nVlrRep
				REPLACE ET_ULTREP	WITH dDataBase
			EndIf
			If !lAbriu
				REPLACE ET_SEQCXA	WITH SOMA1(ET_SEQCXA)
			Endif
		Else
			REPLACE ET_NRREND	WITH SOMA1(cProxRep)
			If !lAbriu
				REPLACE ET_SEQCXA	WITH SOMA1(ET_SEQCXA)
			Endif
		Endif
		MsUnlock()
		PcoDetLan("000359","01","FINA550")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica/Busca o proximo numero para o titulo                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Substr(aReposi[4],1,1)=='*'
			cCampo	:=	"A6_NUM"+Alltrim(aReposi[3])
			If SA6->(FieldPos(cCampo)) > 0
				SA6->(DbSetOrder(1))
				SA6->(MsSeek(xFilial("SA6")+cBcoRep+cAgeRep+cCtaRep))
				Reclock("SA6",.F.)
				nSize		:=	Len(Alltrim(SA6->(&cCampo)))
				nSize		:=	If(nSize == 0,TamSX3("E2_NUM")[1],nSize)
				aReposi[4]	:=	SA6->(&cCampo)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Muda o numero se existir um titulo com o mesmo numero          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SE2")
				aSE2:=GetArea()
				DbSetOrder(6)
				DbSelectArea("SE5")
				aSE5:=GetArea()
				DbSetOrder(3)
				lExisteTit:=.T.
				While lExisteTit
					If aReposi[2]=="1"
						DbSelectArea("SE2")
						lExisteTit:=(DbSeek(xFilial("SE2")+SET->ET_FORNECE+SET->ET_LOJA+Space(TamSX3("E2_PREFIXO")[1])+aReposi[4]))
					Else
						DbSelectArea("SE5")
						lExisteTit:=(DbSeek(xFilial("SE5")+cBcoRep+cAgeRep+cCtaRep+Space(TamSX3("E5_PREFIXO")[1])+aReposi[4]))
					Endif
					If lExisteTit
						aReposi[4]:=Soma1(aReposi[4])
					Endif
				Enddo
				Replace SA6->(&cCampo)	With Soma1(aReposi[4])
				SA6->(MsUnLock())
				SE2->(RestArea(aSE2))
				SE5->(RestArea(aSE5))
			Endif
			DbSelectArea("SET")
		Else
			SA6->(DbSetOrder(1))
			SA6->(MsSeek(xFilial("SA6")+cBcoRep+cAgeRep+cCtaRep))
		Endif
		/**/
		If ExistBlock("F550VREP")
			nVlrRep := ExecBlock("F550VREP",.F.,.F.,{nVlrRep,nSaldoAnt})
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Registra movimento de reposicao                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Fa550Mov( ET_CODIGO, cTipo, nVlrRep,IIF( lMovBco,STR0019+cBcoRep,STR0023),@aBcoRep,@aReposi,nRegSEU)  //"Reposicion de banco "
		nRSeu:=SEU->(Recno())
		If !(cTipo$"90|91")
			// SAIDA EM BANCO
			If cTipoDeb=="1"  //debito diferido
			   	If cPaisLoc != "BRA"
					Fa550ChRep(ET_CODIGO,aBcoRep,aReposi,{ nHdlPrv, "573", "", "FINA550", cLote } , @aFlagCTB)
			   	Else
					If lMovBco
						If cTpTit == "CH"
							Fa550ChRep(ET_CODIGO,aBcoRep,aReposi,{ nHdlPrv, "573", "", "FINA550", cLote } , @aFlagCTB,lTpDeb)
							AtuSalCxa( SET->ET_CODIGO, dDataBase, nVlrRep ) // Atuliza saldo quando foi gerado titulo para fornecedor
						Else
							Fa550MvBc2("S", nVlrRep, STR0020, cBcoRep, cAgeRep, cCtaRep, aReposi) //"REPOSICAO DE CAIXA"
						EndIf
					Else
						AtuSalCxa( SET->ET_CODIGO, dDataBase, nVlrRep ) // Atuliza saldo quando foi gerado titulo para fornecedor
					Endif
				Endif


			Else //debito imediato
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Registra movimento no banco				                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			    If lMovBco

					//chamo rotina que verifica a necessidade de gravaca do imposto ITF na movimentacao bancaria e sua contabilizacao
					Fa550MvBc2("S", nVlrRep, STR0020, cBcoRep, cAgeRep, cCtaRep, aReposi) //"REPOSICAO DE CAIXA"
					If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .AND. lRetCkPG(3,,aBcoRep[1])
						FinProcITF( SE5->( Recno() ),3,, .F.,{ nHdlPrv, "573", "", "FINA550", cLote } , @aFlagCTB )
					EndIf
				Else
					//**********************************************************
					// Atuliza saldo quando o sistema não realiza movimentaçao *
					// bancaria. (Possivel problema nna rotina)                *
					//**********************************************************
					If cPaisLoc == "BRA"
						If FXMultSld()
					    	AtuSalCxa( SET->ET_CODIGO, dDataBase, nVlrRep )
						Endif
					Endif

			    EndIf
			Endif
			If lPadrao573 .and.  nHdlPrv > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Prepara Lancamento Contabil                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, {"EU_LA", "S", "SEU", SEU->( Recno() ), 0, 0, 0} )
					Endif
					nTotal += DetProva( nHdlPrv,;
					                    "573" /*cPadrao*/,;
					                    "FINA550" /*cPrograma*/,;
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

				AAdd(aSEUCont,SEU->(RECNO()))
			Endif
		Elseif (cTipo$"90")
			If lPadrao579 .and. nHdlPrv > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Prepara Lancamento Contabil                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
							aAdd( aFlagCTB, {"EU_LA", "S", "SEU", SEU->( Recno() ), 0, 0, 0} )
						Endif
						nTotal += DetProva( nHdlPrv,;
						                    "579" /*cPadrao*/,;
						                    "FINA550" /*cPrograma*/,;
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
				AAdd(aSEUCont,SEU->(RECNO()))
			Endif

		Endif
	EndIf

	If lFecha
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fechar caixinha caso solicitado                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nVlrMov := Fa550Fecha( cCaixa)
		If lPadrao573 .and. nHdlPrv > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Prepara Lancamento Contabil                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
					aAdd( aFlagCTB, {"EU_LA", "S", "SEU", SEU->( Recno() ), 0, 0, 0} )
				Endif
				nTotal += DetProva( nHdlPrv,;
				                    "573" /*cPadrao*/,;
				                    "FINA550" /*cPrograma*/,;
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
			AAdd(aSEUCont,SEU->(RECNO()))
		Endif
	Endif

	If nHdlPrv > 0 .and. (lPadrao572.or.lPadrao573)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetiva Lan‡amento Contabil                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RodaProva( nHdlPrv,;
			           nTotal )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Efetiva Lan‡amento Contabil                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If UsaSeqCor()
				cCodDiario:= SEU->EU_DIACTB
				aDiario := {}
				AADD(aDiario,{"SEU",SEU->(recno()),cCodDiario,"EU_NODIA","EU_DIACTB"})
			Else
				aDiario := {}
			Endif

			If cA100Incl( cArquivo,;
				           nHdlPrv,;
				           3 /*nOpcx*/,;
				           cLote,;
				           lDigita,;
				           lAglutina /*lAglut*/,;
				           /*cOnLine*/,;
				           /*dData*/,;
				           /*dReproc*/,;
				           @aFlagCTB,;
				           /*aDadosProva*/,;
				           aDiario )

				For nX := 1	To Len(aSEUCont)
					SEU->(DbGoTo(aSEUCont[nX]))
					If !lUsaFlag
						Reclock("SEU",.F.)
						Replace EU_LA	With "S"
						MsUnLock()
					Endif
					PcoDetLan("000359","02","FINA550")
				Next
			Endif

			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

	Endif
	dbCommitAll()
End Transaction

IF lFA550REP // gravação de dados complementares.
	ExecBlock("FA550REP",.F.,.F.)
ENDIF
If cTipo$"91|92"
	If ExistBlock("FA550CORP")
		If MsgYesNo(OemToAnsi(STR0046),OemToAnsi(""))
			ExecBlock("FA550CORP",.F.,.F.,{nRSeu})
		Endif
	Endif
Endif

RestArea(aAreaAnt)
Return nVlrRep /*Function Fa550Rep20*/




/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MGFBcRep  ³ Autor ³ Marcello             ³ Data ³16/06/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecao do banco para reposicao da caja chica               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA550                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MGFBcRep(cCaixa,aBco,aRep,nMin,nRegSEU,lLimite,lAutomato)

Local oDlgBco
Local oFntArial
Local oFntArialB
Local oBmp
Local oDlgAux
Local oBtnCan
Local oBtnOk
Local oBtnSai
Local oBtnImp
Local aArea			:= GetArea()
Local aSA6			:= {}
Local lRet 			:= .F.
Local cTmp 			:= ""
Local nOpc 			:= 0
Local nColBt 		:= 0
Local lNumValid		:=	.F.
Local lNaoAprov		:=	.F.
Local cTxtSald  	:= ""
Local lFA550VldRp	:= ExistBlock( "FA550VldRp" )
Local lFA550CkBc  := ExistBlock("FA550CKBCO")

Private lUsrAutor	:= .T.
Private cBanco 	:= Criavar("A6_COD"), oBanco
Private cAgencia 	:= Criavar("A6_AGENCIA"), oAgencia
Private cConta 	:= Criavar("A6_NUMCON"), oConta
Private lLimBco 	:= .F.
Private nARepor 	:= 0
Private nMoedaCx 	:= 0
Private nSldBco 	:= 0
Private oSldBco
Private nMoedaBco 	:= 1
Private oMoedaBco
Private cNumInt 	:= ''
Private oNumInt
Private nVlrRep 	:= 0
Private oVlrRep
Private nTxRep 	:= 0
Private oTxRep
Private nVlrMin 	:= 0
Private oCbAutoriz
Private lAutoriz 	:= .F.
Private oCbDebitar
Private oCbMovBco
Private lDebitar 	:= .F.
Private aTipoRep 	:= {}
Private oCbTipoRep
Private cTipoRep 	:= ""
Private aTipoTit 	:= {}
Private oCbTipoTit
Private cTipoTit 	:= ""
Private cNumero 	:= ""
Private cNumTalao := ""
Private cTipTalao := ""
Private oTalao
Private oTipTalao
Private oNumero
Private oLbNumero
Private dDtEmis 	:= dDataBase
Private oDtEmis
Private dDtVcto 	:= dDataBase
Private oDtVcto
Private oDtVcto     
Private cNumCHQ   := ""     
Private nTalCHQ   := 0
Private cPreCHQ   := "" 

Default nRegSEU 	:= 0
Default nMin 		:= -1
Default lLimite	:= .F.
Default lAutomato := .F.

If cPaisLoc == "ARG"
	cNumTalao := Criavar("EK_TALAO")
	cTipTalao := Criavar("FRE_TIPO")

	If Type( "lArgTAL" ) == "U"
		lArgTAL := .F.
	EndIf
Else
	lArgTAL := .F. 
EndIf

lLimBco := lLimite

If Type("lMovBco")=="U"
	lMovBco :=.F.
Endif

If lLimBco
	cTxtSald:="  ("+Alltrim(RetTitle("A6_SALATU"))+" = "+Alltrim(RetTitle("A6_SALATU"))+" + "+Alltrim(RetTitle("A6_LIMCRED"))+")"
Else
	cTxtSald:=""
Endif
lUsrAutor := Fa550VlUsr(cCaixa,__CUSERID)
If nRegSEU > 0
	SEU->(dbGoto(nRegSEU))
Endif
nVlrMin := Max(0,nMin)
dbSelectArea("SA6")
aSA6:=GetArea()
dbSetOrder(1)
dbSelectArea("SET")
dbSeek(xFilial("SET")+cCaixa)
lNaoAprov	:=	( cPaisLoc <> "BRA" .And. Empty(SET->ET_CODUSR+SET->ET_GRPUSR))
oFntAr8	:=	TFont():New ("Arial",,,,,,,8,,,,,,,,)
oFntAr8B	:=	TFont():New("Arial",,,,.T.,,,8,,,,,,,,)
oFntAr10B:=	TFont():New("Arial",10,12,,.T.,,,,,,,,,,,)
If cPaisLOC <> "BRA"
	If nRegSEU <> 0
		cNumInt	:=	SEU->EU_NRREND
		lNaoAprov	:=	lNaoAprov .Or. SEU->EU_TIPO <> '91'
	Else
		cNumInt	:=	GetMV('MV_SEQREP')
		If Type("cNumInt") == "C"
			If !FreeForUse('SEU',cNumInt)
				Aviso(STR0037,STR0059,{"Ok"}) //"Ya existe un usuario haciendo reposicion. Por favor intente nuevamente en unos instantes"
				Return .F.
			Endif
		Else
			MsgStop(STR0060,STR0037) //"Configure el parametro MV_SEQREP"
			Return .F.
		Endif
	Endif
EndIf
nARepor	:=	SET->ET_VALOR-SET->ET_SALDO
nARepor	:=	Max(0,nARepor)
cBanco	:=	If(nRegSEU==0,SET->ET_BANCO,SEU->EU_BCOREP)
cAgencia	:=	If(nRegSEU==0,SET->ET_AGEBCO,SEU->EU_AGEREP)
cConta	:=	If(nRegSEU==0,SET->ET_CTABCO,SEU->EU_CTAREP)
cNumero	:=	If(nRegSEU==0,CriaVar("E2_NUM"),SEU->EU_TITULO)
If cPaisLoc <> "BRA"
	dDtEmis 	:= If(nRegSEU==0,dDtEmis,SEU->EU_EMISTIT)
	dDtVcto 	:= If(nRegSEU==0,dDtVcto,SEU->EU_VCTOTIT)
Endif
nVlrRep	:=	If(nRegSEU==0,nARepor,SEU->EU_VALOR)
SA6->(DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta))
nMoedaCx	:=	Max(1,SA6->A6_MOEDA)

If cPaisLoc <> "BRA"
	If !EMPTY(SET->ET_FORNECE)
		aTipoTit:={STR0053,STR0054} //"1=Diferido"###"2=Imediato"
	Else
		aTipoTit:={STR0054} //"2=Imediato"
	Endif
	cTipoTit	:=	If(nRegSEU==0,Left(aTipoTit[1],1),Left(SEU->EU_TIPDEB,1))
Else
	cTipoTit := "1"
EndIf
/**/
aTipoRep:={}

If cPaisLoc <>"BRA"
	cTmp:=GetSESTipos({|| ES_RCOPGER == Left(cTipoTit,1)},"2")
EndIf

While !Empty(cTmp)
	AAdd(aTipoRep,Substr(cTmp,1,tamSx3("E2_TIPO")[1]))
	cTmp:=Substr(cTmp,tamSx3("E2_TIPO")[1]+2)
Enddo
If Len(aTipoRep)==0
	If cTipoTit=="1"
		Aadd(aTipoRep, "DH" )
		Aadd(aTipoRep, "CH" )
	Else
		AAdd(aTipoRep,"EF")
		AAdd(aTipoRep,"TF")
	Endif
Endif

// Obtem a taxa da moeda para reposicao
nTxRep := RecMoeda( dDatabase, nMoedaCx )

cTipoRep:=If(nRegSEU==0,aTipoRep[1],Alltrim(Substr(SEU->EU_TIPDEB,2)))
/**/
lDebitar:=If(nRegSEU==0,.F.,Left(cTipoTit,1)=="2")
lAutoriz:=If(nRegSEU==0,!lUsrAutor,SEU->EU_TIPO=="91")
/**/
nOpc:=0
DEFINE MSDIALOG oDlgBco TITLE STR0020 FROM 0,0 TO Iif(lArgTAL,420,390),510 PIXEL OF oMainWnd     

	@002,002 TO 040,254 PIXEL OF oDlgBco LABEL "" COLOR CLR_BLUE,CLR_WHITE
	@006,005 SAY SET->ET_CODIGO+"  "+SET->ET_NOME SIZE 215,10 PIXEL FONT oFntAr10B COLOR CLR_BLUE,CLR_WHITE
	@016,005 SAY Alltrim(RetTitle("ET_VALOR")) SIZE 100,10 PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
	@024,005 MSGET SET->ET_VALOR PICTURE PesqPict("SET","ET_VALOR") SIZE 60,10 PIXEL FONT oFntAr8B COLOR CLR_BLUE,CLR_WHITE WHEN .F.
	@016,077 SAY Alltrim(RetTitle("ET_SALDO")) SIZE 100,10 PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
	@024,077 MSGET SET->ET_SALDO PICTURE PesqPict("SET","ET_SALDO") SIZE 60,10 PIXEL FONT oFntAr8B COLOR CLR_BLUE,CLR_WHITE WHEN .F.
	@016,151 SAY STR0055 SIZE 100,10 PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE  //"A Repor"
	@024,151 MSGET nARepor PICTURE PesqPict("SET","ET_SALDO") SIZE 60,10 PIXEL FONT oFntAr8B COLOR CLR_BLUE,CLR_WHITE WHEN .F.
	@016,222 SAY Alltrim(RetTitle("A6_MOEDA")) SIZE 100,10 PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
	@024,222 MSGET nMoedaCx PICTURE PesqPict("SA6","A6_MOEDA") SIZE 15,10 PIXEL FONT oFntAr8B COLOR CLR_BLUE,CLR_WHITE WHEN .F.
	/**/
	@048,002 TO Iif(lArgTAL,190,175),254 PIXEL OF oDlgBco LABEL "" COLOR CLR_BLUE,CLR_WHITE   
	If cPaisLoc <> "BRA"
		@044,005 MSGET cNumInt SIZE 80,10 OF oDlgBco PIXEL WHEN .F. FONT oFntAr10B
	EndIf
	/**/
	@063,005 TO 095,251 PIXEL OF oDLGBco LABEL STR0038+cTxtSald COLOR CLR_BLUE,CLR_WHITE //"Banco para reposicao"
	@072,008 SAY RetTitle("A6_COD") SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Banco"
	@080,008 MSGET oBanco var cBanco F3 "SA6" PICTURE PesqPict("SA6","A6_COD") SIZE 10, 10 OF oDlgBco Valid Vermoeda(nMoedaCx, SA6->A6_MOEDA) PIXEL FONT oFntAr8B COLOR CLR_BLUE VALID Fa550Val("BCO") hasbutton WHEN (nRegSEU==0)
	@072,048 SAY RetTitle("A6_AGENCIA") SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Agencia"
	@080,048 MSGET oAgencia VAR cAgencia PICTURE PesqPict("SA6","A6_AGENCIA") SIZE 20, 10 OF odlgBco PIXEL FONT oFntAr8B COLOR CLR_BLUE VALID Fa550Val("AGE") WHEN (nRegSEU==0)
	@072,102 SAY RetTitle("A6_NUMCON")SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Conta"
	@080,102 MSGET oConta VAR cConta PICTURE PesqPict("SA6","A6_NUMCON")  SIZE 45, 10 OF oDlgBco PIXEL FONT oFntAr8B COLOR CLR_BLUE VALID Fa550Val("CTA") WHEN (nRegSEU==0)
	@072,163 SAY RetTitle("A6_SALATU") SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Saldo"
	@080,163 MSGET oSldBco VAR nSldBco PICTURE PesqPict("SA6","A6_SALATU") SIZE 60, 10 OF oDlgBco PIXEL FONT oFntAr8B COLOR CLR_BLUE WHEN .F.
	@072,225 SAY RetTitle("A6_MOEDA")SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Moeda"
	@080,225 MSGET oMoedaBco VAR nMoedaBco PICTURE PesqPict("SA6","A6_MOEDA") SIZE 15, 10 OF oDlgBco PIXEL FONT oFntAr8B COLOR CLR_BLUE WHEN .F.
	/**/

    If cPaisLoc <> "BRA"
    	If  lArgTAL
	 		@101,005 TO 175,251 PIXEL OF oDLGBco LABEL STR0006 COLOR CLR_BLUE,CLR_WHITE
			@109,008 SAY STR0039 SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Debito"
			@117,008 COMBOBOX oCbTipoTit VAR cTipoTit ITEMS aTipoTit SIZE 50,12 PIXEL OF oDlgBCO FONT oFntAr8B COLOR CLR_BLUE ON CHANGE Fa550Val("TTIT",.T.) WHEN (nRegSEU==0)
			@109,065 SAY STR0040 SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Tipo Titulo"
			@117,065 COMBOBOX oCbTipoRep VAR cTipoRep ITEMS aTipoRep SIZE 30,12 PIXEL OF oDlgBCO FONT oFntAr8B COLOR CLR_BLUE ON CHANGE Fa550Val("TIP",.T.) WHEN (nRegSEU==0)
			
			@109,102 SAY RetTitle("EU_TALAO") SIZE 70,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
			@117,102 MSGET oTalao VAR cNumTalao F3 "FRE550" PICTURE PesqPict("SEU","EU_TALAO") SIZE 60,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE VALID fA500Talao() WHEN (nRegSEU==0) .And. (Left(cTipoRep,2) $ "CH|DH")
			
			@109,180 SAY STR0099 SIZE 70,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
			@117,180 MSGET oTipTalao VAR cTipTalao PICTURE PesqPict("FRE","FRE_TIPO") SIZE 60,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE  WHEN .F.
			
			@133,008 SAY oLbNumero PROMPT RetTitle("E2_NUM") SIZE 53,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
			@141,008 MSGET oNumero VAR cNumero PICTURE PesqPict("SE2","E2_NUM") SIZE 53,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE VALID Fa550Val("CHQ") WHEN (nRegSEU==0) .and.  Left(cTipoTit,1) == "2"
			@133,068 SAY RetTitle("E2_EMISSAO") SIZE 70,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
			@141,068 MSGET oDtEmis VAR dDtEmis PICTURE "@D " SIZE 45,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE WHEN (nRegSEU==0)
			@133,115 SAY RetTitle("E2_VENCTO") SIZE 70,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
			@141,115 MSGET oDtVcto VAR Iif(Left(cTipoTit,1) == "1",dDtVcto,dDataBase) PICTURE "@D " SIZE 45,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE WHEN (nRegSEU==0) .and.  Left(cTipoTit,1) == "1"
			@133,168 SAY AllTrim(RetTitle("EU_VALOR"))+STR0056+StrZero(nMoedaCx,2)+")" SIZE 150,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Valor" //" (Moeda "
			@141,168 MSGET oVlrRep VAR nVlrRep PICTURE PesqPict("SET","ET_VALOR") SIZE 74,10 OF oDlgBco PIXEL FONT oFntAr8B COLOR CLR_BLUE VALID Fa550Val("VLR") WHEN ((.F. .And. nRegSEU==0).or.  (lRpMnAcLim .and. SET->(FieldPos('ET_SALANT')) > 0))
			@162,008 CHECKBOX oCbDebitar VAR lDebitar PROMPT STR0041 OF oDlgBco SIZE 100,10 FONT oFntAr8B COLOR CLR_BLUE WHEN (nRegSEU==0 .or. lUsrAutor) .And. !(Left(cTipoRep,2) $ "CH|DH")//"Debitar titulo."
							oCbDebitar:lReadOnly:=!lUsrAutor
			
			If lFA550CkBc
			  lMovBco := ExecBlock("FA550CKBCO",.F.,.F.)
			Endif
			
			@162,130 CHECKBOX oCbMovBco VAR lMovBco PROMPT STR0063 OF oDlgBco SIZE 80,10 FONT oFntAr8B COLOR CLR_BLUE WHEN  .F. //  (nRegSEU==0 .or. lUsrAutor)	.And. !(Left(cTipoRep,2) $ "CH|DH") //"Gera Mov. Bancaria"
							oCbMovBco:lReadOnly:=!lUsrAutor
			@180,005 CHECKBOX oCbAutoriz VAR lAutoriz PROMPT STR0042 OF oDlgBco SIZE 150,10 FONT oFntAr8B COLOR CLR_BLUE WHEN (nRegSEU==0) //"Aguardar autorizacao para reposicao."
		Else
			@101,005 TO 158,251 PIXEL OF oDLGBco LABEL STR0006 COLOR CLR_BLUE,CLR_WHITE
			@109,008 SAY STR0039 SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Debito"
			@117,008 COMBOBOX oCbTipoTit VAR cTipoTit ITEMS aTipoTit SIZE 50,12 PIXEL OF oDlgBCO FONT oFntAr8B COLOR CLR_BLUE ON CHANGE Fa550Val("TTIT",.T.) WHEN (nRegSEU==0)
			@109,065 SAY STR0040 SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Tipo Titulo"
			@117,065 COMBOBOX oCbTipoRep VAR cTipoRep ITEMS aTipoRep SIZE 30,12 PIXEL OF oDlgBCO FONT oFntAr8B COLOR CLR_BLUE ON CHANGE Fa550Val("TIP",.T.) WHEN (nRegSEU==0)
			@109,102 SAY oLbNumero PROMPT RetTitle("E2_NUM") SIZE 70,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
			@117,102 MSGET oNumero VAR cNumero PICTURE PesqPict("SE2","E2_NUM") SIZE 43,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE VALID Fa550Val("CHQ") WHEN (nRegSEU==0)
			@109,152 SAY RetTitle("E2_EMISSAO") SIZE 70,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
			@117,152 MSGET oDtEmis VAR dDtEmis PICTURE "@D " SIZE 45,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE WHEN (nRegSEU==0)
			@109,204 SAY RetTitle("E2_VENCTO") SIZE 70,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
			@117,204 MSGET oDtVcto VAR Iif(Left(cTipoTit,1) == "1",dDtVcto,dDataBase) PICTURE "@D " SIZE 45,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE WHEN (nRegSEU==0) .and.  Left(cTipoTit,1) == "1"
			@133,008 SAY AllTrim(RetTitle("EU_VALOR"))+STR0056+StrZero(nMoedaCx,2)+")" SIZE 150,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Valor" //" (Moeda "
			@141,008 MSGET oVlrRep VAR nVlrRep PICTURE PesqPict("SET","ET_VALOR") SIZE 74,10 OF oDlgBco PIXEL FONT oFntAr8B COLOR CLR_BLUE VALID Fa550Val("VLR") WHEN ((.F. .And. nRegSEU==0).or.  (lRpMnAcLim .and. SET->(FieldPos('ET_SALANT')) > 0))
			@142,102 CHECKBOX oCbDebitar VAR lDebitar PROMPT STR0041 OF oDlgBco SIZE 100,10 FONT oFntAr8B COLOR CLR_BLUE WHEN (nRegSEU==0 .or. lUsrAutor) //"Debitar titulo."
							oCbDebitar:lReadOnly:=!lUsrAutor
			
			If lFA550CkBc
			  lMovBco := ExecBlock("FA550CKBCO",.F.,.F.)
			Endif
			
			@142,160 CHECKBOX oCbMovBco VAR lMovBco PROMPT STR0063 OF oDlgBco SIZE 80,10 FONT oFntAr8B COLOR CLR_BLUE WHEN .F. //  (nRegSEU==0 .or. lUsrAutor)	 //"Gera Mov. Bancaria"
							oCbMovBco:lReadOnly:=!lUsrAutor
			@163,005 CHECKBOX oCbAutoriz VAR lAutoriz PROMPT STR0042 OF oDlgBco SIZE 180,10 FONT oFntAr8B COLOR CLR_BLUE WHEN (nRegSEU==0) //"Aguardar autorizacao para reposicao."
		EndIf
	Else
		@101,005 TO 170,251 PIXEL OF oDLGBco LABEL STR0006 COLOR CLR_BLUE,CLR_WHITE
		If lFA550CkBc
			lMovBco := ExecBlock("FA550CKBCO",.F.,.F.)
		Endif
		@109,008 CHECKBOX oCbMovBco VAR lMovBco PROMPT STR0063 OF oDlgBco SIZE 80,10 FONT oFntAr8B COLOR CLR_BLUE ON CLICK AtuTpRep()  WHEN .F. // (nRegSEU==0) //"Gera Mov. Bancaria"
								oCbMovBco:lReadOnly:=!lUsrAutor

		@122,008 SAY SubStr(STR0040,1,4) SIZE 50,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Tipo Titulo"
		@130,008 COMBOBOX oCbTipoRep VAR cTipoRep ITEMS aTipoRep SIZE 30,12 PIXEL OF oDlgBCO FONT oFntAr8B COLOR CLR_BLUE ON CHANGE Fa550Val("TIP",.T.) WHEN (nRegSEU==0 .And. lMovBco .And. CxDigiChq(cBanco,cAgencia,cConta) )

  	 	@122,100 SAY oLbNumero PROMPT RetTitle("E5_NUMCHEQ") SIZE 70,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
		@130,100 MSGET oNumero VAR cNumero PICTURE PesqPict("SE5","E5_NUMCHEQ") SIZE 43,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE VALID Fa550Val("CHQ") WHEN (nRegSEU==0 .And. cTipoRep == "CH" )

		@122,172 SAY RetTitle("E2_EMISSAO") SIZE 70,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE
		@130,172 MSGET oDtEmis VAR dDtEmis PICTURE "@D " SIZE 45,10 PIXEL OF oDlgBco FONT oFntAr8B COLOR CLR_BLUE WHEN (nRegSEU==0 .And. cTipoRep == "CH" )


		@146,008 SAY AllTrim(RetTitle("EU_VALOR"))+STR0056+StrZero(nMoedaCx,2)+")" SIZE 150,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Valor" //" (Moeda "
		@154,008 MSGET oVlrRep VAR nVlrRep PICTURE PesqPict("SET","ET_VALOR") SIZE 74,10 OF oDlgBco PIXEL FONT oFntAr8B COLOR CLR_BLUE VALID Fa550Val("VLR") WHEN ((.F. .And. nRegSEU==0).or. lRpMnAcLim ) hasbutton

		If FXMultSld()
			@146,102 SAY STR0065 + STR0056+StrZero(nMoedaCx,2)+")" SIZE 150,10 OF oDlgBco PIXEL FONT oFntAr8 COLOR CLR_BLUE,CLR_WHITE //"Tx.F" //" (Moeda "
			@154,102 MSGET oTxRep VAR nTxRep PICTURE PesqPict("SM2","M2_MOEDA"+ StrZero(nMoedaCx,1) ) SIZE 44,10 OF oDlgBco PIXEL FONT oFntAr8B COLOR CLR_BLUE hasbutton
		EndIf
	EndIf
	/**/
	If nRegSEU>0
		DEFINE SBUTTON oBtnImp FROM 180,130 PIXEL TYPE 6 ACTION (Iif(ExistBlock("FA550CoRp"),ExecBlock("Fa550CoRp",.F.,.F.,{nRegSEU}),iif(!lAutomato, MsgAlert(STR0064),.T.))) ENABLE OF oDlgBco 
				oBtnImp:cToolTip:=STR0046 //"Imprimir comprovante para autorizacao de reposicao"
		DEFINE SBUTTON oBtnCan FROM 180,160 PIXEL TYPE 3 ACTION (oDlgBco:End(),nOpc:=2,lRet:=.T.) ENABLE OF oDlgBco
			oBtnCan:cToolTip:=STR0043 //"Cancelar a reposicao"
			If !lUsrAutor
				oBtnCan:Disable()
			Endif

			ObtnCan:lActive:=lUsrAutor
			ObtnCan:lReadOnly:=!ObtnCan:lActive
	Endif

	DEFINE	SBUTTON oBtnOk FROM Iif(lArgTAL,194,180), 190 PIXEL TYPE 1 ;  
			ACTION	( Iif( ( nRegSEU <> 0 .Or. IIf( lArgTAL, Fa550Val("CTA|CHQ|VLR|FCH|TAL",,.T.) , Fa550Val("CTA|CHQ|VLR",,.T.) )) .And.;
					IIF( cTipoRep == "CH" .And. Empty(cNumero),.F.,.T.) .And. ;
					IIf( lFA550VldRp, ExecBlock( "FA550VldRp", .F., .F., { nRegSEU, nVlrRep } ), .T. ),;  
					( oDlgBco:End(), nOpc:=1, lRet:=.T. ), ) ) ;
			ENABLE OF oDlgBco

		If !(lUsrAutor .Or. nRegSEU==0) .Or.(nRegSEU <> 0 .And.lNaoAprov)
			oBtnOk:Disable()
		Endif
		oBtnOk:lActive		:=nRegSEU==0 .Or. (!lNaoAprov .and. lUsrAutor .and. SEU->EU_TIPO=="91")
		oBtnOk:lReadOnly	:=!oBtnOk:lActive

		DEFINE SBUTTON oBtnSai FROM Iif(lArgTAL,194,180) ,220 PIXEL TYPE 2 ACTION (oDlgBco:End(),nOpc:=0,lRet:=.F.) ENABLE OF oDlgBco     

	// Ponto de entrada para manipilar o objeto oDlgBco
	If ExistBlock( "FA550DLG" )
		oDlgAux := ExecBlock( "FA550DLG", .F., .F., { oDlgBco } )
		If ValType( oDlgAux ) == "O"
			oDlgBco := oDlgAux
		EndIf
	EndIf

If !lAutomato
	ACTIVATE MSDIALOG oDlgBco CENTERED ON INIT Fa550Val("CTA|TTIT")
Else
	If FindFunction("GetParAuto")
		aRetAuto := GetParAuto("FINA550TESTCASE")

		If (nPos := Ascan(aRetAuto[3],{|x| x[1]=="cBanco"})) > 0
			cBanco := aRetAuto[3][nPos][2]
		EndIf

		If (nPos := Ascan(aRetAuto[3],{|x| x[1]=="cAgencia"})) > 0
			cAgencia := aRetAuto[3][nPos][2]
		EndIf
		
		If (nPos := Ascan(aRetAuto[3],{|x| x[1]=="cConta"})) > 0
			cConta := aRetAuto[3][nPos][2]
		EndIf
		 
		If (nPos := Ascan(aRetAuto[3],{|x| x[1]=="lMovBco"})) > 0
			lMovBco := aRetAuto[3][nPos][2]
		EndIf
		
		If (nPos := Ascan(aRetAuto[3],{|x| x[1]=="nVlrRep"})) > 0
			nVlrRep := aRetAuto[3][nPos][2]
		EndIf

		If (nPos := Ascan(aRetAuto[3],{|x| x[1]=="nTxRep"})) > 0
			nTxRep := aRetAuto[3][nPos][2]
		EndIf
	EndIf
	
	lRet := Fa550Val("CTA|TTIT")
EndIf

If lRet
	If  Type( "lArgTAL" ) <> "U" .And.  lArgTAL      
		aBco:=Array(5)
		aBco[1]:=cBanco
		aBco[2]:=cAgencia
		aBco[3]:=cConta 
		aBco[4]:=nMoedaBco 
		aBco[5]:=Iif(Left(cTipoTit,1)=="1",cNumTalao,Space(TamSX3("EU_TALAO")[1]) )
	Else 
		aBco:=Array(4)
		aBco[1]:=cBanco
		aBco[2]:=cAgencia
		aBco[3]:=cConta 
		aBco[4]:=nMoedaBco 
	Endif	

	/**/
	If  Type( "lArgTAL" ) <> "U" .And.  lArgTAL
		aRep:=Array(15) 
		aRep[13]:=Iif(Left(cTipoTit,1)=="1",cPreCHQ,Space(TamSX3("E2_PREFIXO")[1]) )  
		aRep[14]:=Left(cTipoTit,1)=="1"
		aRep[15]:=nTalCHQ
	Else   
		aRep:=Array(12) 
	Endif
	If nRegSEU==0
		If lAutoriz
			aRep[1]:="91"
		Else
			If cPaisLoc <>"BRA"
				aRep[1]:=If(lDebitar.Or.Left(cTipoTit,1)=='2'.Or.lMovBco,"10","92")
			Else
				aRep[1]:="10"
			EndIf
		Endif
	Else
		If nOpc==2
			aRep[1]:="90"
		Else
			aRep[1]:=If(lDebitar.Or.Left(cTipoTit,1)=='2',"10","92")
		Endif
	Endif
	aRep[2]:=Left(cTipoTit,1)
	aRep[3]:=cTipoRep
	aRep[4]:=cNumero
	aRep[5]:=dDtEmis
	aRep[6]:=dDtVcto
	aRep[7]:=nVlrRep
	aRep[8]:=lDebitar
	aRep[9]:=lAutoriz
	aRep[10]:="CJCC_"
	aRep[11]:=cNumInt
	aRep[12]:=nMoedaCx
Else
	aRep:={}
	aBco:={}
Endif

If FWIsInCallStack("U_MGFFINBI")
	oDlgBco:Activate( ,,,.F.,,,,,{||oDlgBco:end()} )   
EndIf 

DbSelectArea("SA6")
RestArea(aSA6)
RestArea(aArea)
Return(lRet)





//******************************************************************************************************

Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrSEU 	:= FWFormStruct(1,"SEU")

	oStrSEU:SetProperty("*",MODEL_FIELD_OBRIGAT,.F. )
	oStrSEU:SetProperty("*",MODEL_FIELD_WHEN,{||.T.})
	oStrSEU:SetProperty("*",MODEL_FIELD_VALID,{||.T.}   )
	
	oModel := MPFormModel():New("XMGFFIN94",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	oModel:AddFields("SEUMASTER",/*cOwner*/,oStrSEU, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )	
	
	oModel:SetDescription("Movimento Caixinha")

Return oModel	

Static Function ViewDef()
	
	Local oView
	Local oModel  	:= FWLoadModel('MGFFIN94')

	Local oStrSEU 	:= FWFormStruct( 2, "SEU")

	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField( 'VIEW_SEU' , oStrSEU, 'SEUMASTER' )

	oView:CreateHorizontalBox( 'TELA' , 100 )

	oView:SetOwnerView( 'VIEW_SEU', 'TELA' )

Return oView

Static Function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.MGFFIN94" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFFIN94" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFFIN94" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	    ACTION "VIEWDEF.MGFFIN94" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)

User Function xMGF94Al()
	
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
		
	FWExecView('Alteração Mov. Caixinha','MGFFIN94', MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )

Return

User Function xMGF94De()
	
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
		
	FWExecView('Deleção Mov. Caixinha','MGFFIN94', MODEL_OPERATION_DELETE, , { || .T. }, , ,aButtons )

Return




//***********************************************************************************************************************


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ lRetCkPG  ³ Autor ³ Totvs                ³ Data ³ 09/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA550                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function lRetCkPG(n,cDebInm,cBanco,nPagar)
Local lRetCx:=.T.
If cPaisLoc$"PER|DOM"
   If n==3
      If cBanco $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR"))  .or. IsCaixaLoja(cBanco)
         lRetCx:=.F.
      Endif
   Endif
Endif
Return(lRetCx)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA550   ºAutor  ³Danilo Dias         º Data ³  04/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aprova a reposição no caixinha de acordo com o cadastro    º±±
±±º          ³ de Gestores Financeiros.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA550                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa550Libera( aRep )

Local lRet       := .T.
Local lValSaldo  := .T.
Local aArea      := GetArea()
Local nOpc       := 0	//Opção de não aprovado
Local oDlg       := Nil
Local oBtnAprov, oBtnCanc
Local cNumTit    := aRep[4]	//Número do título da reposição
Local cEmissao   := aRep[5]	//Data de emissão da reposição
Local cUsrAprov  := ""  //Código de usuário do aprovador
Local cCodAprov  := ""	//Código do aprovador
Local cNomAprov  := ""	//Nome do aprovador
Local cMoeda     := Strzero(aRep[12],TamSx3("FRP_MOEDA")[1]) //CValToChar(aRep[12])
Local dDtRef     := dDataBase	//Data de referência da aprovação
Local nLimMin    := 0	//Valor mínimo para aprovação do usuário
Local nLimMax    := 0	//Valor máximo para aprovação do usuário
Local nSldAprov  := 0	//Saldo do aprovador
Local cTipoLim   := ""	//Tipo de limite para o aprovador
Local nSaldo     := SET->ET_SALDO	//Saldo do caixinha
Local nTotal     := aRep[7]			//Valor total do movimento
Local nSaldoF    := nSaldo + nTotal	//Saldo do caixinha após a aprovação
Local aTipoLim   := {}				//Tipos de limite do aprovador no SX3, campo FRP_TIPO
Local aMovAprov  := {}	//Array de movimentos do aprovador
Local lGravou    := .T.	//Indica se gravou a movimentação na tabela de saldos
Local lValMaxMin := .T.

Local bAcaoAprov := { || IIf( FXALCGrava( cUsrAprov, cCodAprov, cMoeda, "4", dDtRef, nTotal ),;	//Grava movimentação na tabela FRT (FINXALC.PRW)
							( oDlg:End(), nOpc := 1 ),;			//Tratamento se atualizou o saldo do gestor corretamente
							( nOpc := 0, lGravou := .F. ) ) }	//Tratamento se houve erro na gravação

//Inicializa campos da tabela FRP
dbSelectArea("FRP")
FRP->(dbSetOrder(2))
FRP->(dbGoTop())

If !( FRP->(dbSeek( xFilial() + __cUserId ) ) )
	Help( " ", 1, "Fa550Libera", , STR0072, 1, 0 ) //"Usuário não encontrado no cadastro de Gestores Financeiros!"
	lRet := .F.
Else
	cNomAprov := cUserName
	cUsrAprov := FRP->FRP_USER
	cCodAprov := FRP->FRP_COD
	nLimMin   := FRP->FRP_LIMMIN
    nLimMax   := FRP->FRP_LIMMAX
    cTipoLim  := FRP->FRP_TIPO

    //Verifica se Gestor pode aprovar o título de acordo com o limite máximo definido
   	dbSelectArea("FRR")
	FRR->(dbSetOrder(2))
    If (dbSeek( xFilial("FRR") + cUsrAprov + cMoeda ))
    	lValMaxMin := Iif(FRR->FRR_AUTLIM == '1', .T., .F.)
	EndIf
	dbSelectArea("FRP")

    If ( nLimMax < nTotal ) .AND. lValMaxMin
    	Help( " ", 1, "Fa550Libera", , STR0073, 1, 0 )  //"Valor ultrapassa limite máximo estipulado para o Gestor."
    	lRet := .F.
    EndIf

    //Valor abaixo do minimo.
    If ( nLimMin > nTotal ) .AND. lValMaxMin
    	Help('', 1, "Fa550Libera", , STR0096, 1, 0)	//"Valor está abaixo do limite mínimo estipulado para o gestor."
    	lRet := .F.
    EndIf

EndIf

If lRet

	//Valida o saldo do aprovador na data de referência.
    lValSaldo  := Fa550ValSld( cUsrAprov, cCodAprov, cMoeda, dDtRef, nTotal, @nSldAprov )

	//Carrega tipos de limite do campo combo pelo X3_CBOX
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	If SX3->(dbSeek("FRP_TIPO"))
		aTipoLim := StrToKarr( X3CBox(), ";" )
	EndIf

	//Cria Dialog de aprovação da reposição
	oDlg := MSDialog():New( 0, 0, 400, 600, STR0074, , , , , , , , oMainWnd, .T., , , , )	//"Aprovação de Reposição"

		oGroup1 := TGroup():New( 002, 005, 042, 295, STR0075, oDlg,,,.T., )	//"Movimento"

			oSay     := TSay():New( 012, 010, { || STR0076 }, oGroup1,,,,,,.T.,,, 60, 10 )	//"Número Int."
		    oNumTit  := TGet():New( 010, 070, { |u| If( PCount() > 0, cNumTit := u, cNumTit ) }, oGroup1, 060, 010,,,,,,,,.T.,,,{|| .F.},,,,,,,"cNumTit" )
		    oSay     := TSay():New( 012, 170, { || STR0077 }, oGroup1,,,,,,.T.,,, 60, 10 )	//"Emissão"
		    oEmissao := TGet():New( 010, 230, { |u| If( PCount() > 0, cEmissao := u, cEmissao ) }, oGroup1, 060, 010, X3Picture("EU_EMISTIT"),,,,,,,.T.,,,{|| .F.},,,,,,,"cEmissao" )
		    oSay     := TSay():New( 026, 170, { || STR0078 }, oGroup1,,,,,,.T.,,, 60, 10 )	//"Data de Ref."
		    oDtRef   := TGet():New( 024, 230, { |u| If( PCount() > 0, dDtRef := u, dDtRef ) }, oGroup1, 060, 010,,,,,,,,.T.,,,/*{|| .F.}*/,,, { || lValSaldo  := Fa550ValSld( cUsrAprov, cCodAprov, cMoeda, dDtRef, nTotal, @nSldAprov ), oDlg:Refresh() },,,, "dDtRef" )

		oGroup2 := TGroup():New( 050, 005, 105, 295, STR0079, oDlg,,,.T., )	//"Aprovador"

		    oSay     := TSay():New( 060, 010, { || STR0079 }, oGroup2,,,,,,.T.,,, 60, 10 )	//"Aprovador"
		    oAprov   := TGet():New( 058, 070, { |u| If( PCount() > 0, cNomAprov := u, cNomAprov ) }, oGroup2, 220, 010,,,,,,,,.T.,,,{|| .F.},,,,,,,"cNomAprov" )
		    oSay     := TSay():New( 076, 010, { || STR0080 }, oGroup2,,,,,,.T.,,, 60, 10 )	//"Limite Mín."
		    oLimMin  := TGet():New( 074, 070, { |u| If( PCount() > 0, nLimMin := u, nLimMin ) }, oGroup2, 060, 010, X3Picture("FRP_LIMMIN"),,,,,,,.T.,,,{|| .F.},,,,,,,"nLimMin" )
		    oSay     := TSay():New( 076, 170, { || STR0081 }, oGroup2,,,,,,.T.,,, 60, 10 )	//"Limite Máx."
		    oLimMax  := TGet():New( 074, 230, { |u| If( PCount() > 0, nLimMax := u, nLimMax ) }, oGroup2, 060, 010, X3Picture("FRP_LIMMAX"),,,,,,,.T.,,,{|| .F.},,,,,,,"nLimMax" )
		    oSay     := TSay():New( 090, 010, { || STR0082 }, oGroup2,,,,,,.T.,,, 60, 10 )	//"Saldo"
		    oLimite  := TGet():New( 088, 070, { |u| If( PCount() > 0, nSldAprov := u, nSldAprov ) }, oGroup2, 060, 010, X3Picture("FRP_LIMITE"),,,,,,,.T.,,,{|| .F.},,,,,,,"nSldAprov" )
		    oSay     := TSay():New( 090, 170, { || STR0083 }, oGroup2,,,,,,.T.,,, 60, 10 )	//"Tipo Lim."
		    oTipoLim := TComboBox():New( 088, 230, { |u| If( PCount() > 0, cTipoLim := u, cTipoLim ) }, aTipoLim, 060, 010, oGroup2,,,,,,.T.,,,,{|| .F.},,,,, "cTipoLim" )

		oGroup3 := TGroup():New( 114, 005, 170, 295, STR0084, oDlg,,,.T., )	//"Saldos"

		    oSay     := TSay():New( 124, 010, { || STR0085 }, oGroup3,,,,,,.T.,,, 080, 10 )	//"Saldo na Data"
		    oSaldo   := TGet():New( 122, 100, { |u| If( PCount() > 0, nSaldo := u, nSaldo ) }, oGroup3, 060, 010, X3Picture("ET_SALDO"),,,,,,,.T.,,,{|| .F.},,,,,,,"nSaldo" )
		    oSay     := TSay():New( 138, 010, { || STR0086 }, oGroup3,,,,,,.T.,,, 80, 10 )	//"Total Título"
		    oTotal   := TGet():New( 136, 100, { |u| If( PCount() > 0, nTotal := u, nTotal ) }, oGroup3, 060, 010, X3Picture("EU_VALOR"),,,,,,,.T.,,,{|| .F.},,,,,,,"nTotal" )
		    oSay     := TSay():New( 152, 010, { || STR0087 }, oGroup3,,,,,,.T.,,, 80, 10 )	//"Saldo após aprovação"
		    oSaldoF  := TGet():New( 150, 100, { |u| If( PCount() > 0, nSaldoF := u, nSaldoF ) }, oGroup3, 060, 010, X3Picture("ET_SALDO"),,,,,,,.T.,,,{|| .F.},,,,,,,"nSaldoF" )

		oBtnAprov := tButton():New( 180, 090, STR0088, oDlg, bAcaoAprov, 050,,,,,.T.,,,, { || lValSaldo },,, )	//"Aprovar"
		oBtnCanc := tButton():New( 180, 160, STR0089, oDlg, { || oDlg:End(), nOpc := 0 }, 050,,,,,.T.,,,,,,, )	//"Cancelar"

    oDlg:Activate( ,,,.T.,,,,, )

EndIf

//Se houve erro na gravação do movimento alerta usuário
If !lGravou
	Help( " ", 1, "Fa550Libera", , STR0090, 1, 0 )	//"Erro na atualização do saldo do gestor!"
EndIf

RestArea(aArea)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³CxDigiChq ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 04/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que abre ou n„o o get do n§ de cheque na baixa 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CxDigiChq(cBanco,cAgencia,cConta)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Caixinha														³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CxDigiChq(cBanco,cAgencia,cConta)
Local lRet := .T.
// Nao habilita o numero de cheque para :
// - Adiantamento, Banco Caixa, Carteira ou Motivo igual a D‚bito em C/C
If SubStr(cBanco,1,2) == "CX"       .or. ;
	cBanco $ GetMv("MV_CARTEIR")     .or. ;
	IsCaixaLoja(cBanco) 					.or. ;
	IsCxFin(cBanco,cAgencia,cConta)
	lRet := .F.
Endif
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ºfA500TalaoºAutor  º Laura Medina       º Data º  04/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     º Validar a digitação do número do Talonário quando CH chequeº±±
±±º          º for próprio.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Sintaxe   º ExpL := fA500Talao()  				                      ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametrosº 														      ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       º FINA100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ObtTalCHQ(cBanco,cAgencia,cConta,cNumTalao,nOpc,nNCheque)

Local cQrySEF	:= ""
Local cTmpSEF	:= ""
Local nX        := 0
Local lRet      := .T. 
Default nOpc    := 1    
Default nNCheque:= 0

cTmpSEF := GetNextAlias()
cQrySEF	:= "Select EF_BANCO,EF_CONTA,EF_AGENCIA,EF_TALAO,EF_PREFIXO,EF_NUM,R_E_C_N_O_"
cQrySEF	+= " from " + RetSqlName("SEF") + " SEF"
cQrySEF += " where EF_FILIAL = '" + xFilial("SEF") + "'"
cQrySEF += " and EF_CART	= 'P'"
cQrySEF	+= " and EF_BANCO	= '" + cBanco + "'"
cQrySEF += " and EF_AGENCIA	= '" + cAgencia + "'"
cQrySEF += " and EF_CONTA 	= '" + cConta + "'"
cQrySEF += " and EF_TALAO 	= '" + cNumTalao + "'"
cQrySEF += " and EF_STATUS 	= '00' AND EF_LIBER = 'S'"
cQrySEF	+= " and D_E_L_E_T_ = ''" 
If  nOpc==2 //Buscar el cheque si esta disponible   
	cQrySEF	+= " and EF_NUM	= '" + nNCheque + "'"
Endif
cQrySEF += " order by EF_BANCO,EF_AGENCIA,EF_CONTA,EF_TALAO,EF_PREFIXO,EF_NUM"
cQrySEF	:= ChangeQuery(cQrySEF)
DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQrySEF),cTmpSEF,.F.,.T.)
(cTmpSEF)->(dbGoTop())

nX := 0 
While !((cTmpSEF)->(EOF()))
	nX++
	If  !(nOpc==2)
		cNumCHQ := (cTmpSEF)->EF_NUM   
		cPreCHQ := (cTmpSEF)->EF_PREFIXO 
		nTalCHQ := (cTmpSEF)->R_E_C_N_O_    
		Exit
	Endif
	(cTmpSEF)->(dbSkip())
Enddo
dbSelectArea(cTmpSEF)
DbCloseArea()
If  nX==0 
	If  !(nOpc==2)
		MsgAlert(STR0103)  //"Não foi encontrado cheque disponivel para este pagamento!"
	Endif
	lRet:=.F.
Endif	

Return(lRet)


//Funcao para verifica se a moeda do Caixinha de Reposicao
//e a mesma do caixinha de abertura.
Static Function Vermoeda(nMoedacx, nMoedaRep)
Local lRet := .F.

If nMoedacx == nMoedaRep
	lRet := .T.
Else
	Alert("A moeda do caixa de reposicao, deve ser igual ao caixinha")
Endif

Return lRet



Return nOpc


