#INCLUDE 'PROTHEUS.CH'
/*
=====================================================================================
Programa.:              MGFFIN04
Autor....:              Atilio Amarilla
Data.....:              15/09/2016
Descricao / Objetivo:   Compensacao automatica de notas de notas de debito (devolucao de compras)
Doc. Origem:            Contrato - GAP CAP998
Solicitante:            Cliente
Uso......:              
Obs......:              Chamado pelo PE M460FIM
=====================================================================================
*/
User Function MGFFIN04()

Local aArea		:= GetArea()
Local aSE2	:= SE2->( GetArea() )
Local aSD1	:= SD1->( GetArea() )
Local aSF1	:= SF1->( GetArea() )
Local aSD2	:= SD2->( GetArea() )
Local aRecNDF   := {}
Local aRecSE2	:= {}
Local aRecSD2	:= {}
Local aChv
Local lCompensa	:= GetNewPar("MGF_FIN04A",.T.)
Local cParcNDF	:= GetNewPar("MGF_FIN04B","01")
Local cTipoNDF	:= GetNewPar("MGF_FIN04C","NDF")
Local nTaxaNDF	:= 0
Local nMoedaNDF	:= 0
Local nI, nPos, cChaveNDF
Local lCtbOnLine := .F.
Local nHdlPrv := 0

DEFAULT lCtbOnLine	:= .F.
DEFAULT nHdlPrv	:= 0

cParcNDF := Stuff( Space(Len(SE2->E2_PARCELA)) , 1 , Len(cParcNDF) , cParcNDF ) 
cTipoNDF := Stuff( Space(Len(SE2->E2_TIPO)) , 1 , Len(cTipoNDF) , cTipoNDF ) 

If SF2->F2_TIPO == "D" .And. !Empty(SF2->F2_DUPL) .And. lCompensa

	SE2->( dbSetOrder(1) ) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	If SE2->( dbSeek( xFilial("SE2")+SF2->(F2_PREFIXO+F2_DUPL+ cParcNDF + cTipoNDF + F2_CLIENTE+F2_LOJA) ) )
		If SE2->E2_SALDO == SE2->E2_VALOR
			aAdd( aRecNDF ,  SE2->( Recno() ) )
			
			
			SD1->( dbSetOrder(1) ) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
			SF1->( dbSetOrder(1) ) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
			SD2->( dbSetOrder(3) ) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			SE2->( dbSetOrder(6) ) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
			
			aRecSD2	:= {}
			SD2->( dbSeek( SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) ) )
			While !SD2->( eof() ) .And. 	SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) == ;
										SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
				
				// aRecSE2	:= {}
				
				nPos := aScan( aRecSD2 , { |x| x[1]== SD2->(D2_CLIENTE+D2_LOJA+D2_SERIORI+D2_NFORI) } )	

				If nPos == 0
					aAdd( aRecSD2 , { SD2->(D2_CLIENTE+D2_LOJA+D2_SERIORI+D2_NFORI) , SD2->(D2_TOTAL+D2_VALIPI+D2_ICMSRET) ,  } )
					nPos := Len( aRecSD2 )
				Else
					aRecSD2[nPos,2] += SD2->(D2_TOTAL+D2_VALIPI+D2_ICMSRET)
				EndIf
				
				SD2->( dbSkip() )			

			EndDo
			
			
			For nI := 1 to Len( aRecSD2 )
			
            	aRecSE2 := {}
				If SE2->( dbSeek(xFilial("SE2")+aRecSD2[nI,1]) )
					nMoedaNDF := SE2->E2_MOEDA
					While !SE2->( eof() ) .And.	xFilial("SE2")+aRecSD2[nI,1] == ;
												SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)

						If SE2->E2_TIPO == "NF " // .And. Empty(SE2->E2_NUMBOR)
							aAdd( aRecSE2 ,  SE2->( Recno() ) ) 
						EndIf

						SE2->( dbSkip() )

					EndDo
				EndIf
				aRecSD2[nI,3] := aRecSE2

			Next nI
			
			
				
			For nI := 1 to Len( aRecSD2 )
                
                If Len( aRecSD2[nI,3] ) > 0
                	SE2->( dbGoTo( aRecNDF[1] ) )
					cChaveNDF := xFilial("SE2") + "|" + SE2->E2_PREFIXO  + "|" + SE2->E2_NUM + ; 
						                              "|" + SE2->E2_PARCELA  + "|" + ;
						             SE2->E2_TIPO   + "|" + SE2->E2_FORNECE  + "|" + SE2->E2_LOJA
					//FINDELFKs( cChaveNDF , "SE2" )
					MaIntBxCP(2,aRecSD2[nI,3],,aRecNDF,,{lCtbOnLine,.F.,.F.,.F.,.F.,.F.},,,,aRecSD2[nI,2]/*nSaldoComp*/,,,nHdlPrv)
				EndIf
					
			Next nI

		EndIf

	EndIf

EndIf

Return

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    �MaIntBxCP � Autor � Aline Correa do Vale  � Data �30.08.2003 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de integracao com as baixas do financeiro             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Codigo da operacao a ser efetuada                     ���
���          �       [1] Baixa simples do financeiro                       ���
���          �       [2] Compensacao de titulos de mesma carteira (PA/NDF) ���
���          �ExpA2: Array com os recnos dos titulos a serem baixados      ���
���          �ExpA3: Array com os dados da baixa simples do financeiro     ���
���          �       [1] Motivo da Baixa                                   ���
���          �       [2] Valor Recebido                                    ���
���          �       [3] Banco                                             ���
���          �       [4] Agencia                                           ���
���          �       [5] Conta                                             ���
���          �       [6] Data de Credito                                   ���
���          �       [7] Data da Baixa                                     ���
���          �ExpA4: Array com os recnos dos titulos a serem compensados   ���
���          �ExpA5: Array com os dados da liquidacao do financeiro        ���
���          �     {}[1] Prefixo                                           ���
���          �       [2] Banco                                             ���
���          �       [3] Agencia                                           ���
���          �       [4] Conta                                             ���
���          �       [5] Numero do Cheque                                  ���
���          �       [6] Data Boa                                          ���
���          �       [7] Valor                                             ���
���          �       [8] Tipo                                              ���
���          �       [9] Natureza                                          ���
���          �       [A] Moeda                                             ���
���          �ExpA6: Array com os parametros da rotina                     ���
���          �       [1] Contabiliza On-Line                               ���
���          �       [2] Aglutina Lancamentos Contabeis                    ���
���          �       [3] Digita lancamentos contabeis                      ���
���          �       [4] Juros para Comissao                               ���
���          �       [5] Desconto para Comissao                            ���
���          �       [6] Calcula Comiss s/NCC                              ���
���          �ExpB7: Bloco de codigo a ser executado apos o processamento  ���
���          �       da rotina, abaixo os parametro passados               ���
���          �       [1] Recno do titulo baixado                           ���
���          �       [2] Codigo a ser informado para cancelamento futuro.  ���
���          �ExpA8: Utilizado quando deve-se estornar uma das baixas efe- ���
���          �       tuadas. Para tanto, deve-se informar o codigo informa-���
���          �       do no codeBlock anterior.                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpC1: Primary Key do documento gerado.                      ���
��������������������������������������������������������������������������Ĵ��
���Descricao �Esta rotina tem como objetivo efetuar a integracao com as bai���
���          �xas do modulo financeiro e os titulos gerados pelo modulo de ���
���          �faturamento                                                  ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Geral                                                       ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
#DEFINE CP_MOTBX   1
#DEFINE CP_VLRREC  2
#DEFINE CP_BANCO   3
#DEFINE CP_AGENCIA 4
#DEFINE CP_CONTA   5
#DEFINE CP_DTBAIXA 6
#DEFINE CP_DTCRED  7

#DEFINE LQ_PREFIXO  1
#DEFINE LQ_BANCO    2
#DEFINE LQ_AGENCIA  3
#DEFINE LQ_CONTA    4
#DEFINE LQ_NROCHQ   5
#DEFINE LQ_DATABOA  6
#DEFINE LQ_VALOR    7
#DEFINE LQ_TIPO     8
#DEFINE LQ_NATUREZA 9
#DEFINE LQ_MOEDA	10
#DEFINE LQ_DATALIQ  11
#DEFINE LQ_FORNECE	12
#DEFINE LQ_LOJA		13

Static Function MaIntBxCP(nCaso,aSE2,aBaixa,aNDF_PA,aLiquidacao,aParam,bBlock,aEstorno,aNDFDados,nSaldoComp,dBaixaCMP,nTaxaCM,nHdl)

Local aArea      := GetArea()
Local aTitulo    := {0,0,0}
Local aRecebido  := {}
Local aValores   := {}
Local bContabil  := {|| .T.}
Local nX         := 0
Local nY         := 0
Local nVlrCP	 := 0
Local nVlrACmp   := 0
Local nMoeda     := 0
Local lContabil  := .F.
Local lAgluCtb   := .F.
Local lDigita    := .F.
Local lDesconto  := .F.
Local lJuros     := .F.
Local lHeadProva := .F.
Local lEstorno   := IIf(Empty(aEstorno),.F.,.T.)
Local lRetorno   := .T.
Local cArqCtb    := ""
Local cRetorno   := ""
Local lContSaldo := ValType( nSaldoComp ) == "N"
Local nPerc			:= 0
Local nMoedaPA		:= 0
Local nMoedaNota	:= 0
Local lGeraCT2	:= .F.

DEFAULT aNDFDados := {}
DEFAULT dBaixaCMP := dDatabase
Default nHdl		 := 0

Private cPadrao		:= ""
Private nHdlPrv		:= 0
Private nTotalCtb	:= 0
Private nTaxaD		:= 0
Private cLoteCtb	:= ""
Private nVlrComp	:= 0
//��������������������������������������������������������������Ŀ
//� Verifica os parametros da rotina                             �
//����������������������������������������������������������������
If !Empty(aParam)
	lContabil  := aParam[01]
	lAgluCtb   := aParam[02]
	lDigita    := aParam[03]
	lDesconto  := aParam[04]
	lJuros     := aParam[05]
EndIf
DEFAULT bBlock  := {|| .T.}

//��������������������������������������������������������������Ŀ
//� HeadProva                                                    �
//����������������������������������������������������������������
If lContabil
	dbSelectArea("SX5")
	dbSetOrder(1)
	If DbSeek(xFilial()+"09FIN")
		cLoteCtb := X5Descri()
	Else
		DbSeek(xFilial()+"09")
		cLoteCtb := X5Descri()
	EndIf
	If nHdl <= 0 // Tratamento efetuado para nao gerar handle quando ja existir um em execucao
		nHdlPrv := HeadProva(cLoteCtb,"FINA080",Substr(cUsuario,7,6),@cArqCtb)
		lGeraCT2 := .T.
	Else
		nHdlPrv:= nHdl 	
	EndIf
	lHeadProva := .T.	
Else
	lContabil := .F.
EndIf
//��������������������������������������������������������������Ŀ
//� Efetua a integracao com o financeiro                         �
//����������������������������������������������������������������
Do Case
	//��������������������������������������������������������������Ŀ
	//� Baixa simples do Financeiro                                  �
	//����������������������������������������������������������������
Case nCaso == 1 .And. .f.
	Begin Transaction
		For nX := 1 To Len(aSE2)
			//��������������������������������������������������������������Ŀ
			//� Posiciona registros                                          �
			//����������������������������������������������������������������
			dbSelectArea("SE2")
			dbSetOrder(1)
			MsGoto(aSE2[nX])

			If SE2->E2_SALDO > 0

				dbSelectArea("SA2")
				dbSetOrder(1)
				DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)

				If RecLock("SE2") .And. RecLock("SA2")

					If !lEstorno
						//��������������������������������������������������������������Ŀ
						//� Montagem dos valores para baixa                              �
						//����������������������������������������������������������������
						aValores  := FaVlAtuCP("SE2",aBaixa[CP_DTBAIXA])
						aTitulo   := {	aValores[02],; //Abatimentos
											aValores[04],; //Descrescimo
											aValores[05],; //Acrescimo
											aValores[10]}  //Correcao Monetaria

						aRecebido := {	aBaixa[CP_MOTBX],;
											aBaixa[CP_BANCO],;
											aBaixa[CP_AGENCIA],;
											aBaixa[CP_CONTA],;
											aBaixa[CP_DTBAIXA],;
											aBaixa[CP_DTCRED],;
											"Prestacao de Contas",;
											aValores[09],; //Desconto
											0,; //Multa
											aValores[08],; //Juros
											aValores[10],; //Correcao monetaria
											Min(aBaixa[CP_VLRREC],aValores[12])}

						//��������������������������������������������������������������Ŀ
						//� Verifica o Codigo do lancamento padrao                       �
						//����������������������������������������������������������������
						If lContabil
							cPadrao   := Fa080Pad()
							lContabil := VerPadrao(cPadrao)
						EndIf
						//��������������������������������������������������������������Ŀ
						//� Efetua a baixa simples dos titulos                           �
						//����������������������������������������������������������������
						cRetorno := FaBaixaCP(aTitulo,aRecebido,lDesconto,lJuros,lContabil)
						aBaixa[CP_VLRREC] -= aValores[11]
						//��������������������������������������������������������������Ŀ
						//� DetProva                                                     �
						//����������������������������������������������������������������
						If lHeadProva .And. lContabil
							nTotalCtb += DetProva(nHdlPrv,cPadrao,"FINA080",cLoteCtb)
						EndIf
					Else
						//��������������������������������������������������������������Ŀ
						//� Verifica o Codigo do lancamento padrao                       �
						//����������������������������������������������������������������
						If lContabil
							cPadrao   := "527"
							lContabil := VerPadrao(cPadrao)
						EndIf
						//��������������������������������������������������������������Ŀ
						//� Efetua o cancelamento da baixa simples do financeiro         �
						//����������������������������������������������������������������
						FaBaixaCP(aTitulo,aRecebido,lDesconto,lJuros,lContabil,aEstorno[nX])
						cRetorno := aEstorno[nX]
						//��������������������������������������������������������������Ŀ
						//� DetProva                                                     �
						//����������������������������������������������������������������
						If lHeadProva .And. lContabil
							nTotalCtb += DetProva(nHdlPrv,cPadrao,"FINA080",cLoteCtb)
						EndIf
					EndIf
					//��������������������������������������������������������������Ŀ
					//� Executa o bloco de codigo passado                            �
					//����������������������������������������������������������������
					Eval(bBlock,aSE2[nX],cRetorno)
				EndIf
			Endif
		Next nX
	End Transaction
	//��������������������������������������������������������������Ŀ
	//� Compensacao do Financeiro                                    �
	//����������������������������������������������������������������
Case nCaso == 2
	Begin Transaction

		For nX := 1 To Len(aSE2)

			If lContSaldo
				If	Empty( nSaldoComp )
					Exit
				EndIf
			EndIf

			//��������������������������������������������������������������Ŀ
			//� Posiciona registros                                          �
			//����������������������������������������������������������������
			dbSelectArea("SE2")
			dbSetOrder(1)
			MsGoto(aSE2[nX])
			dbSelectArea("SA2")
			dbSetOrder(1)
			DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)

			If RecLock("SE2")
				If !lEstorno
					nMoedaNota	:= SE2->E2_MOEDA
					If SE2->E2_TXMDCOR > 0
						nTaxaD := SE2->E2_TXMDCOR
					Else	
						nTaxaD	  := Iif(SE2->E2_TXMOEDA>0,SE2->E2_TXMOEDA,RecMoeda(ddatabase,nMoedaNota)) 
					Endif	
					//� Montagem dos valores para baixa                              �
					//����������������������������������������������������������������
					aValores  := FaVlAtuCP("SE2",dBaixaCMP,,,nTaxaD,,nTaxaCM)

					aTitulo   := { 	aValores[02],; //Abatimentos
											aValores[13],; //Saldo Descrescimo
											aValores[14],; //Saldo Acrescimo
											aValores[10]}  //Correcao Monetaria

					aRecebido := {}
					nVlrComp  := 0
					nVlrCP    := aValores[12]
					nMoeda    := SE2->E2_MOEDA

					For nY := 1 To Len(aNDF_PA)
						If aNDF_PA[nY] <> 0
							dbSelectArea("SE2")
							dbSetOrder(1)
							MsGoto(aNDF_PA[nY])
							
							nMoedaNota	:= SE2->E2_MOEDA
							If SE2->E2_TXMDCOR > 0
								nTaxaD := SE2->E2_TXMDCOR
							Else
								nTaxaD	  := Iif(SE2->E2_TXMOEDA>0,SE2->E2_TXMOEDA,RecMoeda(ddatabase,nMoedaNota))
							Endif

							If Len(aNDFDados) >= nY .and. aNDF_PA[nY] == aNDFDados[nY][1]
								aValores := aClone( aNDFDados[nY][3] )
							Else
								aValores := FaVlAtuCP("SE2",dBaixaCMP,,, nTaxaD,,nTaxaCM)
							EndIf

						    //TDF - POSICIONA NA MOEDA DO BANCO (trade easy)
						    If  !Empty(SWB->WB_BANCO)
							    SA6->(DBSETORDER(1))
							    SA6->(DBSEEK(xFilial("SA6")+AVKEY(SWB->WB_BANCO,"A6_COD")+AVKEY(SWB->WB_AGENCIA,"A6_AGENCIA")+AVKEY(SWB->WB_CONTA,"A6_NUMCON")))
    							nMoedaPA	:= SA6->A6_MOEDA
							Else
								If SE2->E2_TIPO $ MVPAGANT
									nMoedaPA	:= FinBcoPA("SE2")[2]
								EndIf
							Endif

							If (aValores[12]) > 0
								nVlrACmp   := Min(nVlrCP-nVlrComp-aTitulo[2]+aTitulo[3],aValores[12])

								If lContSaldo
	 								//��������������������������������������������������������������Ŀ
									//� Ajusta o Valor a compensar                                   �
									//����������������������������������������������������������������
									nVlrACmp   := Min( nVlrACmp, nSaldoComp )
									//��������������������������������������������������������������Ŀ
									//� Baixa o saldo a compensar                                    �
									//����������������������������������������������������������������
									nSaldoComp -= nVlrACmp
								EndIf
								
								If AllTrim(SE2->E2_ORIGEM) == "SIGAEIC"
									lCalcCM:=  nTaxaD <> nTaxaCM
								Else
									lCalcCM:= nMoedaPA <> nMoedaNota
								EndIf

								nVlrComp   += nVlrACmp
								nPerc := nVlrACmp / aValores[nY]
								aadd(aRecebido,{ aNDF_PA[nY],;
									nVlrACmp,;
									aValores[02],;
									dBaixaCMP,;
									cLoteCtb,;
									dBaixaCMP,;
									Iif (AllTrim(SE2->E2_ORIGEM) == "SIGAEIC",nTaxaCM,nTaxaD),;
									NIL,;
									NIL,;
									aValores[10]*nPerc,;//VM proporcional ao valor compensado.
									lCalcCM } )
								If nVlrCP <= nVlrComp
									Exit
								EndIf
							Else
								aNDF_PA[nY] := 0
							EndIf
						EndIf
					Next nY
					If ( Len(aRecebido) <> 0 )
						//��������������������������������������������������������������Ŀ
						//� Posiciona no titulo principal                                �
						//����������������������������������������������������������������
						dbSelectArea("SE2")
						dbSetOrder(1)
						MsGoto(aSE2[nX])
						//��������������������������������������������������������������Ŀ
						//� Verifica o Codigo do lancamento padrao                       �
						//����������������������������������������������������������������
						cPadrao := "597"
						If lHeadProva .And. VerPadrao(cPadrao)
							bContabil := {|| nTotalCtb += DetProva(nHdlPrv,cPadrao,"FINA340",cLoteCtb) }
							STRLCTPAD := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
						Else
							lContabil := .F.
						EndIf
						//��������������������������������������������������������������Ŀ
						//� Efetua a baixa simples dos titulos                           �
						//����������������������������������������������������������������
						cRetorno := FaCmpCP(aTitulo,aRecebido,lContabil,Nil,bContabil,bBlock)
						//��������������������������������������������������������������Ŀ
						//� DetProva                                                     �
						//����������������������������������������������������������������
						If lHeadProva .And. lContabil
							VALOR    := nVlrComp
							VALOR2	:= aTitulo[4]  //Variacao monetaria do titulo Principal
							REGVALOR := SE2->(RecNo())
							SE5->(MsGoto(0))
							SE2->(MsGoto(0))
							nTotalCtb += DetProva(nHdlPrv,cPadrao,"FINA330",cLoteCtb)
							VALOR		:= 0
							VALOR2	:= 0
						EndIf
					EndIf
				Else

					If Len( aEstorno ) >= nX

						aTitulo    := {0,0,0}
						aRecebido  := {}

						//��������������������������������������������������������������Ŀ
						//� Verifica o Codigo do lancamento padrao                       �
						//����������������������������������������������������������������
						cPadrao := "589"
						If lHeadProva .And. VerPadrao(cPadrao)
							bContabil := {|| nVlrComp+=SE5->E5_VALOR,nTotalCtb += DetProva(nHdlPrv,cPadrao,"FINA340",cLoteCtb) }
							STRLCTPAD := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
						Else
							lContabil := .F.
						EndIf

						cRetorno := FaCmpCP(aTitulo,aRecebido,lContabil,Nil,bContabil,bBlock,iif(valType(aEstorno[nx]) =="A",aEstorno[nX],aEstorno),lHeadProva)
						nVlrComp := 0
					EndIf

				EndIf
			EndIf
		Next nX
	End Transaction
OtherWise
EndCase
//��������������������������������������������������������������Ŀ
//� Efetua a integracao com o Contabil                           �
//����������������������������������������������������������������
If lHeadProva .And. lGeraCT2
	RodaProva(nHdlPrv,nTotalCtb)
	If nTotalCtb > 0
		cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAgluCtb)
	EndIf
EndIf
RestArea(aArea)
Return(lRetorno)

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    �FaCmpCP   � Autor � Eduardo Riera         � Data �11.08.2003 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de Compensasao do Contas a Pagar                      ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1: Array com os dados do titulo principal                ���
���          �       [1] Abatimento (-)                                    ���
���          �       [2] Descrescimo (-)                                   ���
���          �       [3] Acrescimo   (+)                                   ���
���          �       [4] Variacao Monetaria (=)                            ���
���          �ExpA2: Array com os dados do titulos a compensar             ���
���          �     {}[1] RecNo do Titulo a compensar                       ���
���          �       [2] Valor do Titulo a compensar na moeda do Titulos   ���
���          �           principal                                         ���
���          �       [3] Valor do Abatimento da NDF                        ���
���          �       [4] Data da Baixa                                (OPC)���
���          �       [5] Numero de Lote para contabilizacao           (OPC)���
���          �       [6] Data a ser considerar para converte o valor do    ���
���          �           titulo principal para a moeda corrente       (OPC)���
���          �       [7] Taxa da moeda a ser considerada para converte o   ���
���          �           valor do titulo principal para a moeda corrente   ���
���          �           (OPCIONAL)                                        ���
���          �       [8] Numero de decimais utilizado nas conversoes. (OPC)���
���          �       [9] Numero de decimais utilizado nas conversoes. (OPC)���
���          �       [10] Valor da Variacao Monetaria						 (OPC)���
���          �ExpL3: Indica se a compensacao sera contabilizada       (OPC)���
���          �ExpC4: Indica o programa de origem da compensacao       (OPC)���
���          �ExpB5: Bloco de codigo para contabilizacao                   ���
���          �       (OPC)                                                 ���
���          �ExpB6: Bloco de codigo apos cada compensacao. Recebe o       ���
���          �       E5_DOCUMEN como parametro                        (OPC)���
���          �ExpA7: Codigo da amarracao entre o titulo compensado e o     ���
���          �       adiantamento ( E5_DOCUMEN ). Quando informado indica  ���
���          �       uma operacao de estorno.                         (OPC)���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Descricao �Esta rotina tem como objetivo efetuar a compensacao dos titu-���
���          �los a pagar conforme os parametros solicitados.              ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Geral                                                       ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
#DEFINE CR_VLRABAT 01
#DEFINE CR_VLDESCR 02
#DEFINE CR_VLACRES 03
#DEFINE CR_VLVARMN 04

#DEFINE CMP_RECNO  1
#DEFINE CMP_VLRCMP 2
#DEFINE CMP_VLABAT 3
#DEFINE CMP_DTREC  4
#DEFINE CMP_LOTE   5
#DEFINE CMP_DATAP  6
#DEFINE CMP_TAXAP  7
#DEFINE CMP_NUMDEC 8
#DEFINE CMP_GRCONT 9
#DEFINE CMP_VLRCM 10
#DEFINE CMP_LCALCM 11

#DEFINE MODEL_OPERATION_INSERT 3


Static Function FaCmpCP(	aTitulo,	aCompensar,		lLctPad,	cOrigem,;
					bContabil,	bBlock,			aEstorno, lHeadProva)

Local aArea     := GetArea()
Local aAreaSE2  := SE2->(GetArea())
Local aAreaCMP  := {}
Local aDelCMP   := {}
Local aDelCorre := {}
Local nW        := 0
Local nX        := 0
Local nY        := 0
Local nZ        := 0
Local nVlCpMdCp := 0
Local nVlCpMd1  := 0
Local nSldMdCR  := 0
Local nSldMdCp  := 0
Local nVlBxMd1  := 0
Local nMoedaCP  := SE2->E2_MOEDA
Local nAtraso   := 0
Local cAliasSE2 := "SE2"
Local cAliasSE5 := "SE5"
Local cPrefixo  := SE2->E2_PREFIXO
Local cNumero   := SE2->E2_NUM
Local cParcela  := SE2->E2_PARCELA
Local cFornece  := SE2->E2_FORNECE
Local cLoja     := SE2->E2_LOJA
Local cPrincipal:= SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
Local cNDF_RA   := ""

Local cSeqBx    := ""
Local cSeqBxCp  := ""
Local cPrimary  := ""
Local cFilterSE2:= SE2->(dbFilter())
Local lQuery    := .F.
Local lEstorno  := IIf(Empty(aEstorno),.F.,.T.)
Local l340Mov1 	:= ExistBlock("SE5FI340")
Local l340Mov2 	:= ExistBlock("SE5FI341")
Local lMaIntDel := ExistBlock("MaIntDel")
Local aSE5		:= {}
Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
Local aDiario	:= {}
Local aFlagCTB	:= {}
Local nRecSE2 	:= 0
Local nRecSE5 	:= 0
                        //=====================================
						//Trecho alterado com o uso dos models:
						//=====================================
Local oModelBxR := FWLoadModel("FINM010") //Model de baixas a Receber
Local oSubFK1

#IFDEF TOP
	Local cQuery    := ""
	Local cKeySE2   := SE2->(IndexKey())
#ENDIF
//=====================================
//Trecho alterado com o uso dos models:
//=====================================
Local oModelBxP := FWLoadModel("FINM020") //Model de baixas a pagar
Local oSubFK2
Local oSubFK5
Local oSubFK6
Local cLog := ""
Local cChaveTit := ""
Local cChaveFK7 := ""
Local cCamposE5 := ""
Local lRet := .T.


//��������������������������������������������������������������Ŀ
//� Verifica os parametros da rotina                             �
//����������������������������������������������������������������
DEFAULT lLctPad    := .F.
DEFAULT lHeadProva := .F.
DEFAULT cOrigem    := "FINA340"
DEFAULT bContabil  := {|| .T.}
DEFAULT bBlock    := {|| .T.}
For nX := 1 To Len(aCompensar)
	For nY := 4 To 9
		If Len(aCompensar[nX])<nY
			aadd(aCompensar[nX],Nil)
		EndIf
		Do Case
		Case nY == 4
			DEFAULT aCompensar[nX][4] := dDataBase
		Case nY == 5
			DEFAULT aCompensar[nX][5] := ""
		Case nY == 8
			DEFAULT aCompensar[nX][8] := 2
		Case nY == 9
			DEFAULT aCompensar[nX][9] := .F.
		EndCase
	Next nX
Next nY
//��������������������������������������������������������������Ŀ
//� Posiciona registros                                          �
//����������������������������������������������������������������
dbSelectArea("SA2")
dbSetOrder(1)
DbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
//��������������������������������������������������������������Ŀ
//� Trava o registro principal                                   �
//����������������������������������������������������������������
If RecLock("SE2") .And. RecLock("SA2")
	If !lEstorno
		//��������������������������������������������������������������Ŀ
		//� Inicia a compensacao dos titulos                             �
		//����������������������������������������������������������������
		For nX := 1 To Len(aCompensar)
			If aCompensar[nX][CMP_VLRCMP]<>0
				//��������������������������������������������������������������Ŀ
				//� Calcula os valores a compensar do Titulo principal           �
				//����������������������������������������������������������������
				cPrincipal:= SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
				nVlBxMdCP := aCompensar[nX][CMP_VLRCMP]+aTitulo[2]-aTitulo[3]
				nVlBxMd1  := xMoeda(aCompensar[nX][CMP_VLRCMP],SE2->E2_MOEDA,1,aCompensar[nX][CMP_DATAP],aCompensar[nX][CMP_NUMDEC],aCompensar[nX][CMP_TAXAP])
				nSldMdCr  := SE2->E2_SALDO-nVlBxMdCP
				If ( ( nSldMdCr - aTitulo[CR_VLRABAT] ) <= 0.009 ) .OR. ( SE2->E2_SALDO - nSldMdCp <= aCompensar[nX][CMP_VLABAT] )
					nSldMdCr := 0
					nVlBxMdCP:= SE2->E2_SALDO
				EndIf
				//��������������������������������������������������������������Ŀ
				//� Verifica a proxima sequencia de baixa do titulo principal    �
				//����������������������������������������������������������������
				cSeqBx := FaNxtSeqBx("SE2")
				//��������������������������������������������������������������Ŀ
				//� Posiciona no titulo de adiantamento                          �
				//����������������������������������������������������������������
				dbSelectArea("SE2")
				MsGoTo(aCompensar[nX][CMP_RECNO])
				cNDF_RA	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
				If RecLock("SE2")
					//��������������������������������������������������������������Ŀ
					//� Verifica a proxima sequencia de baixa                        �
					//����������������������������������������������������������������
					cSeqBxCp := FaNxtSeqBx("SE2")
					//��������������������������������������������������������������Ŀ
					//� Verifica a maior sequencia entre os dois titulos             �
					//����������������������������������������������������������������
					cSeqBx := IIf(cSeqBxCp>cSeqBx,cSeqBxCp,cSeqBx)
					//��������������������������������������������������������������Ŀ
					//� Calcula os valores a compensar do Titulo de adiantamento     �
					//����������������������������������������������������������������
					nVlCpMdCp := xMoeda(aCompensar[nX][CMP_VLRCMP],nMoedaCP,SE2->E2_MOEDA,aCompensar[nX][CMP_DATAP],aCompensar[nX][CMP_NUMDEC],aCompensar[nX][CMP_TAXAP])
					nVlCpMd1  := xMoeda(aCompensar[nX][CMP_VLRCMP],nMoedaCP,1,aCompensar[nX][CMP_DATAP],aCompensar[nX][CMP_NUMDEC],aCompensar[nX][CMP_TAXAP])
					nSldMdCp  := SE2->E2_SALDO-nVlCpMdCp
					If ( SE2->E2_SALDO - ( nSldMdCp + aCompensar[nX][CMP_VLABAT] ) <= 0.009 )
						nSldMdCp  := 0
						nVlBxMdCp := SE2->E2_SALDO
					EndIf
					//��������������������������������������������������������������Ŀ
					//� Efetua a baixa do titulo principal                           �
					//����������������������������������������������������������������
					RestArea(aAreaSE2)
					SE2->E2_SALDO   := nSldMdCr
					SE2->E2_BAIXA   := aCompensar[nX][CMP_DTREC]
					SE2->E2_LOTE    := aCompensar[nX][CMP_LOTE]
					SE2->E2_MOVIMEN := aCompensar[nX][CMP_DTREC]
					SE2->E2_DESCONT := 0
					SE2->E2_MULTA   := 0
					SE2->E2_JUROS   := 0
					SE2->E2_SDACRESC:= 0
					SE2->E2_SDDECRE	:= 0
					If aCompensar[nX][CMP_LCALCM]
						SE2->E2_CORREC  := aTitulo[CR_VLVARMN]
					Endif
					SE2->E2_VALLIQ  := nVlCpMd1

					If ExistBlock("FA330SE2")
						ExecBlock("FA330SE2",.F.,.F.)
					EndIf
					//��������������������������������������������������������������Ŀ
					//� Calcula os dias de Atraso                       			 �
					//����������������������������������������������������������������
					nAtraso:=aCompensar[nX][CMP_DTREC]-SE2->E2_VENCTO
					If nAtraso > 1
						If Dow(SE2->E2_VENCTO) == 1 .Or. Dow(SE2->E2_VENCTO) == 7
							If Dow(aCompensar[nX][CMP_DTREC]) == 2 .And. nAtraso <= 2
								nAtraso := 0
							EndIf
						EndIf
						nAtraso:=Max(0,nAtraso)
					EndIf
					//��������������������������������������������������������������Ŀ
					//� Atualiza os acumulados do cliente               			 �
					//����������������������������������������������������������������
					//��������������������������������������������������������������Ŀ
					//� Atualiza maior atraso                                        �
					//����������������������������������������������������������������
					SA2->A2_MATR := nAtraso
					//��������������������������������������������������������������Ŀ
					//� Efetua a movimentacao de baixa do titulo principal       	 �
					//����������������������������������������������������������������
					If nVlBxMd1 <> 0
						//Define os campos que nao existem nas FKs e que serao gravados apenas na E5, para que a gravacao da E5 continue igual
						If !Empty(cCamposE5)
							cCamposE5 += "|"
						Endif
						cCamposE5 += "{"
						cCamposE5 += "{'E5_DTDIGIT', dDataBase}"
						cCamposE5 += ",{'E5_PREFIXO', SE2->E2_PREFIXO}"
						cCamposE5 += ",{'E5_NUMERO', SE2->E2_NUM}"
						cCamposE5 += ",{'E5_PARCELA', SE2->E2_PARCELA}"
						cCamposE5 += ",{'E5_CLIFOR', SE2->E2_FORNECE}"
						cCamposE5 += ",{'E5_LOJA', SE2->E2_LOJA}"
						cCamposE5 += ",{'E5_BENEF', SE2->E2_NOMFOR}"
						cCamposE5 += ",{'E5_MOVCX', 'S'}"
						cCamposE5 += ",{'E5_TIPO', SE2->E2_TIPO}"
						cCamposE5 += ",{'E5_LA', '"+ IIf(lLctPad,"S","N")+"'}"
						cCamposE5 += ",{'E5_FORNADT', SE2->E2_FORNECE }"
						cCamposE5 += ",{'E5_LOJAADT', SE2->E2_LOJA }"             
						cCamposE5 += ",{'E5_FORNECE', SE2->E2_FORNECE }"
						cCamposE5 += ",{'E5_DTDIGIT', dDataBase }"
						cCamposE5 += ",{'E5_DTDISPO', SE2->E2_BAIXA }"
						cCamposE5 += ",{'E5_VLDESCO',"+ Str(aTitulo[CR_VLDESCR])+" }"
						//cCamposE5 += ",{'E5_VLDECRE',"+ Str(aTitulo[CR_VLDESCR])+" }"
						cCamposE5 += ",{'E5_VLJUROS',"+ Str(aTitulo[CR_VLACRES])+" }"
						//cCamposE5 += ",{'E5_VLACRES',"+ Str(aTitulo[CR_VLACRES])+" }"
						
						If aCompensar[nX][CMP_LCALCM]
							cCamposE5 += ",{'E5_VLCORRE',"+ Str(aTitulo[CR_VLVARMN])+" }"
						Endif
						
						cCamposE5 += "}"
						
						oModelBxP:SetOperation( MODEL_OPERATION_INSERT ) //Inclusao
						oModelBxP:Activate()		
						
						//Retorna o identifcador do processo.
						cChaveTit := xFilial("SE2") + "|" + SE2->E2_PREFIXO  + "|" + SE2->E2_NUM + ; 
						                              "|" + SE2->E2_PARCELA  + "|" + ;
						             SE2->E2_TIPO   + "|" + SE2->E2_FORNECE  + "|" + SE2->E2_LOJA
						cChaveFK7 := FINGRVFK7("SE2", cChaveTit)
						//
						oModelBxP:SetValue("FKADETAIL","FKA_IDORIG",FWUUIDV4())
						oModelBxP:SetValue("FKADETAIL","FKA_TABORI","FK2")
							
						oModelBxP:SetValue( "MASTER", "E5_GRV", .T. ) //Informa se vai gravar SE5 ou nao
						oModelBxP:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serao gravados indepentes de FK5
						
						oSubFK2 := oModelBxP:GetModel("FK2DETAIL")
						oSubFK5 := oModelBxP:GetModel("FK5DETAIL")
						//Dados da baixa a pagar
						oSubFK2:SetValue( "FK2_IDFK2", FWUUIDV4() )
						oSubFK2:SetValue( "FK2_DATA", SE2->E2_BAIXA )		
						oSubFK2:SetValue( "FK2_VALOR", nVlBxMd1 )
						oSubFK2:SetValue( "FK2_MOEDA", StrZero(SE2->E2_MOEDA,2) )
						oSubFK2:SetValue( "FK2_NATURE", SE2->E2_NATUREZ )
						oSubFK2:SetValue( "FK2_RECPAG", "P" )
						oSubFK2:SetValue( "FK2_TPDOC", If(cOrigem=="MATA465","BA","CP") )
						
						//������������������������������������������������������������������?
						//?Grava historico diferenciado gestao de contratos                ?
						//������������������������������������������������������������������?
						If Type("cModulo")=="C" .and. cModulo=="EIC"
							oSubFK2:SetValue( "FK2_HISTOR", "Compens. Autom. Adiantamento")
						ElseIf aCompensar[nX,CMP_GRCONT]
							oSubFK2:SetValue( "FK2_HISTOR", "//CMP--CTR..COMP.AUTOMATICA CAUCAO CONTRATOS")//
						Else
							oSubFK2:SetValue( "FK2_HISTOR", "Comp.Autom.p/Devol.Compras")
						EndIf
						
						oSubFK2:SetValue( "FK2_VLMOE2", nVlCpMdCp )
						oSubFK2:SetValue( "FK2_MOTBX", "CMP" )
						oSubFK2:SetValue( "FK2_TXMOED", aCompensar[nX][CMP_TAXAP] )
						oSubFK2:SetValue( "FK2_ORIGEM", FunName() )
						oSubFK2:SetValue( "FK2_SEQ", cSeqBx )
						oSubFK2:SetValue( "FK2_IDDOC", cChaveFK7 )
						oSubFK2:SetValue( "FK2_FILORI",	SE2->E2_FILORIG)
						oSubFK2:SetValue( "FK2_LOTE", Substr(aCompensar[nX][CMP_LOTE],1, TAMSX3("FK2_LOTE")[1] ))
						oSubFK2:SetValue( "FK2_DOC", cNDF_RA)
						If oModelBxP:VldData()
						    oModelBxP:CommitData()
						   	SE5->(dbGoto(oModelBxP:GetValue( "MASTER", "E5_RECNO" )))
							oModelBxP:DeActivate()
						Else
							lRet := .F.
						    cLog := cValToChar(oModelBxP:GetErrorMessage()[4]) + ' - '
						    cLog += cValToChar(oModelBxP:GetErrorMessage()[5]) + ' - '
						    cLog += cValToChar(oModelBxP:GetErrorMessage()[6])        	

						    Help( ,,"M020VALID",,cLog, 1, 0 )	             
						Endif
						                                    

						If l340Mov1
							ExecBlock("SE5FI340",.F.,.F.)
						EndIf
						//��������������������������������������������������������������Ŀ
						//� Guarda a chave primary da baixa para busca futura            �
						//����������������������������������������������������������������
						cPrimary := SE5->E5_DOCUMEN

						If aCompensar[nX][CMP_LCALCM] .and. aTitulo[CR_VLVARMN] != 0    // Geracao de Corre��o monet�ria
							FinGerCM(1, aTitulo[CR_VLVARMN],cSeqBx,aCompensar[nX][CMP_LOTE], lLctPad)
						Endif

					EndIf
					//��������������������������������������������������������������Ŀ
					//� Encerra os titulos de abatimento caso a baixa seja total     �
					//����������������������������������������������������������������
					If (SE2->E2_SALDO == 0 .And. aTitulo[CR_VLRABAT]<>0) .OR. ( (SE2->E2_SALDO-aTitulo[CR_VLRABAT]) == 0)
						cPrefixo  := SE2->E2_PREFIXO
						cNumero   := SE2->E2_NUM
						cParcela  := SE2->E2_PARCELA
						cFornece  := SE2->E2_FORNECE
						cLoja     := SE2->E2_LOJA

						dbSelectArea("SE2")
						dbSetOrder(2)
						#IFDEF TOP
							SE2->(dbCommit())
							aStruSE2  := SE2->(dbStruct())
							cAliasSE2 := "FaCmpCR"
							lQuery    := .T.
							cQuery := "SELECT SE2.*, SE2.R_E_C_N_O_ SE2RECNO "
							cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
							cQuery += "WHERE SE2.E2_FILIAL='"+xFilial("SE2")+"' AND "
							cQuery += "SE2.E2_PREFIXO='"+cPrefixo+"' AND "
							cQuery += "SE2.E2_NUM='"+cNumero+"' AND "
							cQuery += "SE2.E2_PARCELA='"+cParcela+"' AND "
							cQuery += "SE2.E2_FORNECE='"+cFornece+"' AND "
							cQuery += "SE2.E2_LOJA='"+cLoja+"' AND "
							cQuery += "SE2.D_E_L_E_T_=' ' "

							cQuery := ChangeQuery(cQuery)

							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)

							For nZ := 1 To Len(aStruSE2)
								If aStruSE2[nZ][2]<>"C"
									TcSetField(cAliasSE2,aStruSE2[nZ][1],aStruSE2[nZ][2],aStruSE2[nZ][3],aStruSE2[nZ][4])
								EndIf
							Next nZ
						#ENDIF
						SE2->(dbClearFilter())
						dbSelectArea("SE2")
						dbSetOrder(6)	// E2_FILIAL, E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, R_E_C_N_O_, D_E_L_E_T_
						DbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNumero+cParcela)

						While !Eof() .And. (cAliasSE2)->E2_FILIAL == xFilial("SE2") .And.;
								(cAliasSE2)->E2_FORNECE == cFornece	.And.;
								(cAliasSE2)->E2_LOJA == cLoja .And.;
								(cAliasSE2)->E2_PREFIXO == cPrefixo .And.;
								(cAliasSE2)->E2_NUM == cNumero .And.;
								(cAliasSE2)->E2_PARCELA == cParcela

							If (cAliasSE2)->E2_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVPIABT+"/"+	MVCFABT+"/"+MVCSABT
								If lQuery
									dbSelectArea("SE2")
									MsGoto((cAliasSE2)->SE2RECNO)
								EndIf
								RecLock("SE2")
								SE2->E2_SALDO   := 0
								SE2->E2_BAIXA   := aCompensar[nX][CMP_DTREC]
								SE2->E2_LOTE    := aCompensar[nX][CMP_LOTE]
								SE2->E2_MOVIMEN := aCompensar[nX][CMP_DTREC]
								MsUnLock()
							EndIf
							dbSelectArea(cAliasSE2)
							dbSkip()
						EndDo
						If lQuery
							dbSelectArea(cAliasSE2)
							dbCloseArea()
							dbSelectArea("SE2")
						Else
							dbSelectArea("SE2")
							#IFDEF TOP
								If !Empty(cFilterSE2)
									If nOrdSE2 == 0 .And. !Empty(cKeySE2)
										cFilterSE2 += ".AND. ORDERBY("+StrTran(ClearKey(cKeySE2),"+",",")+")"
									EndIf
								EndIf
							#ENDIF
							If ( !Empty(cFilterSE2) )
								Set Filter to &cFilterSE2
							EndIf
						EndIf
					EndIf
					If nVlBxMd1 <> 0
						//��������������������������������������������������������������Ŀ
						//� Posiciona no titulo de adiantamento                          �
						//����������������������������������������������������������������
						dbSelectArea("SE2")
						MsGoTo(aCompensar[nX][CMP_RECNO])
						//��������������������������������������������������������������Ŀ
						//� Efetua a baixa do titulo de adiantamento                     �
						//����������������������������������������������������������������
						RecLock("SE2")
						SE2->E2_SALDO   := nSldMdCp
						SE2->E2_BAIXA   := aCompensar[nX][CMP_DTREC]
						SE2->E2_LOTE    := aCompensar[nX][CMP_LOTE]
						SE2->E2_MOVIMEN := aCompensar[nX][CMP_DTREC]
						SE2->E2_DESCONT := 0
						SE2->E2_MULTA   := 0
						SE2->E2_JUROS   := 0
						If aCompensar[nX][CMP_LCALCM]
							SE2->E2_CORREC  := aCompensar[nX][10]
						Endif
						SE2->E2_VALLIQ  := nVlCpMd1
						SE2->E2_SDACRES := 0
						SE2->E2_SDDECRE := 0

						cCamposE5 := ""
						If !Empty(SE5->E5_DOCUMEN)
							//Define os campos que nao existem nas FKs e que serao gravados apenas na E5, para que a gravacao da E5 continue igual
							If !Empty(cCamposE5)
								cCamposE5 += "|"
							Endif
							cCamposE5 += "{"
							cCamposE5 += "{'E5_DTDIGIT', dDataBase}"
							cCamposE5 += ",{'E5_PREFIXO', SE2->E2_PREFIXO}"
							cCamposE5 += ",{'E5_NUMERO', SE2->E2_NUM}"
							cCamposE5 += ",{'E5_PARCELA', SE2->E2_PARCELA}"
							cCamposE5 += ",{'E5_CLIFOR', SE2->E2_FORNECE}"
							cCamposE5 += ",{'E5_LOJA', SE2->E2_LOJA}"
							cCamposE5 += ",{'E5_BENEF', SE2->E2_NOMFOR}"
							cCamposE5 += ",{'E5_MOVCX', 'S'}"
							cCamposE5 += ",{'E5_TIPO', SE2->E2_TIPO}"
							cCamposE5 += ",{'E5_LA', '"+ IIf(lLctPad,"S","N")+"'}"
							cCamposE5 += ",{'E5_FORNADT', SE2->E2_FORNECE }"
							cCamposE5 += ",{'E5_LOJAADT', SE2->E2_LOJA }"             
							cCamposE5 += ",{'E5_FORNECE', SE2->E2_FORNECE }"
							cCamposE5 += ",{'E5_DTDIGIT', dDataBase }"
							cCamposE5 += ",{'E5_DTDISPO', SE2->E2_BAIXA }"
							
							If aCompensar[nX][CMP_LCALCM]
								cCamposE5 += ",{'E5_VLCORRE',"+Str( aCompensar[nX][10])+" }"
							Endif

							cCamposE5 += "}"
							
							oModelBxP:SetOperation( MODEL_OPERATION_INSERT ) //Inclusao
							oModelBxP:Activate()		
							oModelBxP:SetValue( "MASTER", "E5_GRV", .T. ) //Informa se vai gravar SE5 ou nao
							oModelBxP:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serao gravados indepentes de FK5
							//Dados da tabela auxiliar com o codigo do titulo a pagar
							cChaveTit := xFilial("SE2") + "|" +  SE2->E2_PREFIXO + "|" + SE2->E2_NUM + "|" + SE2->E2_PARCELA + "|" + ;
							              SE2->E2_TIPO  + "|" +  SE2->E2_FORNECE + "|" + SE2->E2_LOJA
							cChaveFK7 := FINGRVFK7("SE2", cChaveTit)							
							//
							oModelBxP:SetValue("FKADETAIL", "FKA_IDORIG"	, FWUUIDV4() ) // cChaveFK7 )
							oModelBxP:SetValue("FKADETAIL", "FKA_TABORI"	, 'FK2')
							//
							oSubFK2 := oModelBxP:GetModel("FK2DETAIL")
							oSubFK5 := oModelBxP:GetModel("FK5DETAIL")							
								
							//Dados da baixa a pagar
							oSubFK2:SetValue( "FK2_IDFK2", FWUUIDV4() )
							oSubFK2:SetValue( "FK2_DATA", SE2->E2_BAIXA )		
							oSubFK2:SetValue( "FK2_VALOR", nVlCpMd1 )
							oSubFK2:SetValue( "FK2_MOEDA", StrZero(SE2->E2_MOEDA,2) )
							oSubFK2:SetValue( "FK2_NATURE", SE2->E2_NATUREZ )
							oSubFK2:SetValue( "FK2_RECPAG", "P" )
							oSubFK2:SetValue( "FK2_TPDOC",  If(cOrigem<>"MATA465","BA","CP") ) 
							
							//������������������������������������������������������������������?
							//?Grava historico diferenciado gestao de contratos                ?
							//������������������������������������������������������������������?
							If Type("cModulo")=="C" .and. cModulo=="EIC"
								oSubFK2:SetValue( "FK2_HISTOR", "Compens. Autom. Adiantamento")//
							ElseIf aCompensar[nX,CMP_GRCONT]
								oSubFK2:SetValue( "FK2_HISTOR", "//CMP--CTR..COMP.AUTOMATICA CAUCAO CONTRATOS")//
							Else
								oSubFK2:SetValue( "FK2_HISTOR", "Comp.Autom.p/Devol.Compras")//
							EndIf
							
							oSubFK2:SetValue( "FK2_VLMOE2", nVlCpMdCp )
							oSubFK2:SetValue( "FK2_MOTBX", "CMP" )
							oSubFK2:SetValue( "FK2_TXMOED", aCompensar[nX][CMP_TAXAP] )
							oSubFK2:SetValue( "FK2_ORIGEM", FunName() )
							oSubFK2:SetValue( "FK2_SEQ", cSeqBx )
							oSubFK2:SetValue( "FK2_IDDOC", cChaveFK7 )
							oSubFK2:SetValue( "FK2_FILORI",	SE2->E2_FILORIG)
							oSubFK2:SetValue( "FK2_LOTE", Substr(aCompensar[nX][CMP_LOTE],1, TAMSX3("FK2_LOTE")[1] ))
							oSubFK2:SetValue( "FK2_DOC", cPrincipal)
							If oModelBxP:VldData()
							    oModelBxP:CommitData()
							   	SE5->(dbGoto(oModelBxP:GetValue( "MASTER", "E5_RECNO" )))
								oModelBxP:DeActivate()
							Else
								lRet := .F.
							    cLog := cValToChar(oModelBxP:GetErrorMessage()[4]) + ' - '
							    cLog += cValToChar(oModelBxP:GetErrorMessage()[5]) + ' - '
							    cLog += cValToChar(oModelBxP:GetErrorMessage()[6])        	
							    
							    Help( ,,"M020VALID",,cLog, 1, 0 )	             
							Endif
							 
							If l340Mov2
								ExecBlock("SE5FI341",.F.,.F.)
							EndIf

							If aCompensar[nX][CMP_LCALCM] .and. aCompensar[nX][10] != 0    // Geracao de Corre��o monet�ria
								FinGerCM(2, aCompensar[nX][10] ,cSeqBx,aCompensar[nX][CMP_LOTE], lLctPad)
							EndIf
						EndIf
						//��������������������������������������������������������������Ŀ
						//� Encerra os titulos de abatimento caso a baixa seja total     �
						//����������������������������������������������������������������
						If SE2->E2_SALDO == 0 .And. aCompensar[nX][CMP_VLABAT]<>0

							cPrefixo  := SE2->E2_PREFIXO
							cNumero   := SE2->E2_NUM
							cParcela  := SE2->E2_PARCELA
							cFornece  := SE2->E2_FORNECE
							cLoja     := SE2->E2_LOJA

							dbSelectArea("SE2")
							dbSetOrder(2)
							#IFDEF TOP
								SE2->(dbCommit())
								aStruSE2  := SE2->(dbStruct())
								cAliasSE2 := "FaCmpCP"
								lQuery    := .T.
								cQuery := "SELECT SE2.*, SE2.R_E_C_N_O_ SE2RECNO "
								cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
								cQuery += "WHERE SE2.E2_FILIAL='"+xFilial("SE2")+"' AND "
								cQuery += "SE2.E2_PREFIXO='"+cPrefixo+"' AND "
								cQuery += "SE2.E2_NUM='"+cNumero+"' AND "
								cQuery += "SE2.E2_PARCELA='"+cParcela+"' AND "
								cQuery += "SE2.E2_FORNECE='"+cFornece+"' AND "
								cQuery += "SE2.E2_LOJA='"+cLoja+"' AND "
								cQuery += "SE2.D_E_L_E_T_=' ' "

								cQuery := ChangeQuery(cQuery)

								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)

								For nX := 1 To Len(aStruSE2)
									If aStruSE2[nX][2]<>"C"
										TcSetField(cAliasSE2,aStruSE2[nX][1],aStruSE2[nX][2],aStruSE2[nX][3],aStruSE2[nX][4])
									EndIf
								Next nX
							#ENDIF
							SE2->(dbClearFilter())
							DbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNumero+cParcela)
							While !Eof() .And. (cAliasSE2)->E2_FILIAL == xFilial("SE2") .And.;
									(cAliasSE2)->E2_FORNECE == cFornece	.And.;
									(cAliasSE2)->E2_LOJA == cLoja .And.;
									(cAliasSE2)->E2_PREFIXO == cPrefixo .And.;
									(cAliasSE2)->E2_NUM == cNumero .And.;
									(cAliasSE2)->E2_PARCELA == cParcela

								If (cAliasSE2)->E2_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVPIABT+"/"+	MVCFABT+"/"+MVCSABT
									If lQuery
										dbSelectArea("SE2")
										MsGoto((cAliasSE2)->SE2RECNO)
									EndIf
									RecLock("SE2")
									SE2->E2_SALDO   := 0
									SE2->E2_BAIXA   := aCompensar[nX][CMP_DTREC]
									SE2->E2_LOTE    := aCompensar[nX][CMP_LOTE]
									SE2->E2_MOVIMEN := aCompensar[nX][CMP_DTREC]
									MsUnLock()
								EndIf
								dbSelectArea(cAliasSE2)
								dbSkip()
							EndDo
							If lQuery
								dbSelectArea(cAliasSE2)
								dbCloseArea()
								dbSelectArea("SE2")
							Else
								dbSelectArea("SE2")
								#IFDEF TOP
									If !Empty(cFilterSE2)
										If nOrdSE2 == 0 .And. !Empty(cKeySE2)
											cFilterSE2 += ".AND. ORDERBY("+StrTran(ClearKey(cKeySE2),"+",",")+")"
										EndIf
									EndIf
								#ENDIF
								If ( !Empty(cFilterSE2) )
									Set Filter to &cFilterSE2
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			//��������������������������������������������������������������Ŀ
			//� Bloco de codigo para contabilizacao                          �
			//����������������������������������������������������������������
			If lLctPad
				//��������������������������������������������������������������Ŀ
				//� Posiciona no titulo de adiantamento                          �
				//����������������������������������������������������������������
				dbSelectArea("SE2")
				MsGoTo(aCompensar[nX][CMP_RECNO])
				Eval(bContabil)
			EndIf
			//��������������������������������������������������������������Ŀ
			//� Executa o codeblock                                          �
			//����������������������������������������������������������������
			Eval(bBlock,aAreaSE2[3],cPrimary)
			//��������������������������������������������������������������Ŀ
			//� Repociona o titulo principal                                 �
			//����������������������������������������������������������������
			RestArea(aAreaSE2)
		Next nX
	Else
		//��������������������������������������������������������������Ŀ
		//� Inicia o estorno da compensacao                              �
		//����������������������������������������������������������������
		aTitulo    := Array(3)
		aTitulo    := Afill(aTitulo,0)
		aCompensar := Array(8)
		aCompensar := Afill(aCompensar,0)
		If RecLock("SE2")
			//��������������������������������������������������������������Ŀ
			//� Restaura os titulos de abatimento caso a baixa seja total    �
			//����������������������������������������������������������������
			If SE2->E2_SALDO == 0
				dbSelectArea("SE2")
				dbSetOrder(2)
				#IFDEF TOP
					SE2->(dbCommit())
					aStruSE2  := SE2->(dbStruct())
					cAliasSE2 := "FaCmpCR"
					lQuery    := .T.
					cQuery := "SELECT SE2.*,SE2.R_E_C_N_O_ SE2RECNO "
					cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
					cQuery += "WHERE SE2.E2_FILIAL='"+xFilial("SE2")+"' AND "
					cQuery += "SE2.E2_PREFIXO='"+cPrefixo+"' AND "
					cQuery += "SE2.E2_NUM='"+cNumero+"' AND "
					cQuery += "SE2.E2_PARCELA='"+cParcela+"' AND "
					cQuery += "SE2.E2_FORNECE='"+cFornece+"' AND "
					cQuery += "SE2.E2_LOJA='"+cLoja+"' AND "
					cQuery += "SE2.D_E_L_E_T_=' ' "

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)

					For nX := 1 To Len(aStruSE2)
						If aStruSE2[nX][2]<>"C"
							TcSetField(cAliasSE2,aStruSE2[nX][1],aStruSE2[nX][2],aStruSE2[nX][3],aStruSE2[nX][4])
						EndIf
					Next nX

				#ELSE
					SE2->(dbClearFilter())
					DbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNumero+cParcela)
				#ENDIF

				While !Eof() .And. (cAliasSE2)->E2_FILIAL == xFilial("SE2") .And.;
						(cAliasSE2)->E2_FORNECE == cFornece	.And.;
						(cAliasSE2)->E2_LOJA == cLoja .And.;
						(cAliasSE2)->E2_PREFIXO == cPrefixo .And.;
						(cAliasSE2)->E2_NUM == cNumero .And.;
						(cAliasSE2)->E2_PARCELA == cParcela

					If (cAliasSE2)->E2_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVPIABT+"/"+	MVCFABT+"/"+MVCSABT
						If lQuery
							dbSelectArea("SE2")
							MsGoto((cAliasSE2)->SE2RECNO)
						EndIf
						RecLock("SE2")
						SE2->E2_SALDO   := SE2->E2_VALOR
						SE2->E2_BAIXA   := Ctod("")
						SE2->E2_LOTE    := ""
						SE2->E2_MOVIMEN := Ctod("")
						MsUnLock()
						aTitulo[CR_VLRABAT] := SE2->E2_VALOR
					EndIf
					dbSelectArea(cAliasSE2)
					dbSkip()
				EndDo
				If lQuery
					dbSelectArea(cAliasSE2)
					dbCloseArea()
					dbSelectArea("SE2")
				Else
					dbSelectArea("SE2")
					#IFDEF TOP
						If !Empty(cFilterSE2)
							If nOrdSE2 == 0 .And. !Empty(cKeySE2)
								cFilterSE2 += ".AND. ORDERBY("+StrTran(ClearKey(cKeySE2),"+",",")+")"
							EndIf
						EndIf
					#ENDIF
					If ( !Empty(cFilterSE2) )
						Set Filter to &cFilterSE2
					EndIf
				EndIf
			EndIf
			//��������������������������������������������������������������Ŀ
			//� Efetua o estorno de um baixa                                 �
			//����������������������������������������������������������������
			RestArea(aAreaSE2)
			//��������������������������������������������������������������Ŀ
			//� Atualiza o saldo do titulo com base no abatimento            �
			//����������������������������������������������������������������
			SE2->E2_SALDO += aTitulo[CR_VLRABAT]
			SE2->E2_CORREC := 0
			//��������������������������������������������������������������Ŀ
			//� Pesquisa pelos registros de baixa da compensacao             �
			//����������������������������������������������������������������
			dbSelectArea("SE5")
			dbSetOrder(7)

			DbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)

			While !Eof() .And. (cAliasSE5)->E5_FILIAL == xFilial("SE5") .And.;
					(cAliasSE5)->E5_PREFIXO == SE2->E2_PREFIXO .And.;
					(cAliasSE5)->E5_NUMERO == SE2->E2_NUM      .And.;
					(cAliasSE5)->E5_PARCELA == SE2->E2_PARCELA .And.;
					(cAliasSE5)->E5_TIPO == SE2->E2_TIPO       .And.;
					(cAliasSE5)->E5_CLIFOR == SE2->E2_FORNECE .And.;
					(cAliasSE5)->E5_LOJA == SE2->E2_LOJA

				If TemBxCanc( (cAliasSE5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) , .T. )
					(cAliasSE5)->( dbskip())
					Loop
				EndIf

				If ((cAliasSE5)->E5_TIPODOC == "CP" .And. (cAliasSE5)->E5_MOTBX == "CMP" .And. (cAliasSE5)->E5_RECPAG == "P");
																										.OR. (cAliasSE5)->E5_TIPODOC == "CM"

					If (cAliasSE5)->E5_TIPODOC == "CM"
						aadd(aDelCorre,{ SE5->(Recno()) })
					ElseIf aScan(aEstorno,(cAliasSE5)->E5_DOCUMEN)<>0
						aadd(aDelCmp,{(cAliasSE5)->E5_DOCUMEN,(cAliasSE5)->(RecNo()),(cAliasSE5)->E5_SEQ })
					EndIf

				EndIf
				dbSelectArea(cAliasSE5)
				dbSkip()
			EndDo
			If lQuery
				dbSelectArea(cAliasSE5)
				dbCloseArea()
				dbSelectArea("SE5")
			EndIf
			If Len(aDelCmp)>0
				For nX := 1 To Len(aDelCmp)
					//��������������������������������������������������������������Ŀ
					//� Posiciona no registro de baixa do titulo compensado          �
					//����������������������������������������������������������������
					dbSelectArea("SE5")

					cSeqBx := aDelCmp[nX][3]
					//��������������������������������������������������������������Ŀ
					//� Pesquisa o titulo de adiantamento                            �
					//����������������������������������������������������������������
					dbSelectArea("SE2")
					dbSetOrder(1)
					If DbSeek(xFilial("SE2")+RTrim(aDelCmp[nX][1])) .And. RecLock("SE2")
						//��������������������������������������������������������������Ŀ
						//� Restaura os titulos de abatimento caso a baixa seja total    �
						//����������������������������������������������������������������
						aAreaCMP := SE2->(GetArea())
						If SE2->E2_SALDO == 0
							cPrefixo  := SE2->E2_PREFIXO
							cNumero   := SE2->E2_NUM
							cParcela  := SE2->E2_PARCELA
							cFornece  := SE2->E2_FORNECE
							cLoja     := SE2->E2_LOJA

							dbSelectArea("SE2")
							dbSetOrder(2)
							#IFDEF TOP
								SE2->(dbCommit())
								aStruSE2  := SE2->(dbStruct())
								cAliasSE2 := "FaCmpCP"
								lQuery    := .T.
								cQuery := "SELECT SE2.*,SE2.R_E_C_N_O_ SE2RECNO "
								cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
								cQuery += "WHERE SE2.E2_FILIAL='"+xFilial("SE2")+"' AND "
								cQuery += "SE2.E2_PREFIXO='"+cPrefixo+"' AND "
								cQuery += "SE2.E2_NUM='"+cNumero+"' AND "
								cQuery += "SE2.E2_PARCELA='"+cParcela+"' AND "
								cQuery += "SE2.E2_FORNECE='"+cFornece+"' AND "
								cQuery += "SE2.E2_LOJA='"+cLoja+"' AND "
								cQuery += "SE2.D_E_L_E_T_=' ' "

								cQuery := ChangeQuery(cQuery)

								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)

								For nY := 1 To Len(aStruSE2)
									If aStruSE2[nY][2]<>"C"
										TcSetField(cAliasSE2,aStruSE2[nY][1],aStruSE2[nY][2],aStruSE2[nY][3],aStruSE2[nY][4])
									EndIf
								Next nY
							#ELSE
								SE2->(dbClearFilter())
								DbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNumero+cParcela)
							#ENDIF

							While !Eof() .And. (cAliasSE2)->E2_FILIAL == xFilial("SE2") .And.;
									(cAliasSE2)->E2_FORNECE == cFornece	.And.;
									(cAliasSE2)->E2_LOJA == cLoja .And.;
									(cAliasSE2)->E2_PREFIXO == cPrefixo .And.;
									(cAliasSE2)->E2_NUM == cNumero .And.;
									(cAliasSE2)->E2_PARCELA == cParcela

								If (cAliasSE2)->E2_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVPIABT+"/"+	MVCFABT+"/"+MVCSABT
									If lQuery
										dbSelectArea("SE2")
										MsGoto((cAliasSE2)->SE2RECNO)
									EndIf
									RecLock("SE2")
									SE2->E2_SALDO   := SE2->E2_VALOR
									SE2->E2_BAIXA   := Ctod("")
									SE2->E2_LOTE    := ""
									SE2->E2_MOVIMEN := CtoD("")
									MsUnLock()
									aCompensar[CMP_VLABAT] := SE2->E2_VALOR
								EndIf
								dbSelectArea(cAliasSE2)
								dbSkip()
							EndDo
							If lQuery
								dbSelectArea(cAliasSE2)
								dbCloseArea()
								dbSelectArea("SE2")
							Else
								dbSelectArea("SE2")
								#IFDEF TOP
									If !Empty(cFilterSE2)
										If nOrdSE2 == 0 .And. !Empty(cKeySE2)
											cFilterSE2 += ".AND. ORDERBY("+StrTran(ClearKey(cKeySE2),"+",",")+")"
										EndIf
									EndIf
								#ENDIF
								If ( !Empty(cFilterSE2) )
									Set Filter to &cFilterSE2
								EndIf
							EndIf
						EndIf
						//��������������������������������������������������������������Ŀ
						//� Reposiciona nos titulos de adiantamento                      �
						//����������������������������������������������������������������
						RestArea(aAreaCMP)
						//��������������������������������������������������������������Ŀ
						//� Atualiza o saldo do titulo com base no abatimento            �
						//����������������������������������������������������������������
						SE2->E2_SALDO += aCompensar[CMP_VLABAT]
						//��������������������������������������������������������������Ŀ
						//� Localiza o registro de baixa do adiantamento                 �
						//����������������������������������������������������������������
						dbSelectArea("SE5")
						dbSetOrder(7)
						If DbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+cSeqBx)
							While ( !Eof() .And. SE5->E5_FILIAL == xFilial("SE5") .And.;
									SE5->E5_PREFIXO == SE2->E2_PREFIXO .And.;
									SE5->E5_NUMERO == SE2->E2_NUM .And.;
									SE5->E5_PARCELA == SE2->E2_PARCELA .And.;
									SE5->E5_TIPO == SE2->E2_TIPO .And.;
									SE5->E5_CLIFOR == SE2->E2_FORNECE .And.;
									SE5->E5_LOJA == SE2->E2_LOJA .And.;
									SE5->E5_SEQ == cSeqBx )

									If TemBxCanc(   SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) , .T.)
										SE5->( dbskip())
										Loop
									EndIf

									If SE5->E5_TIPODOC <> "CM"
										//��������������������������������������������������������������Ŀ
										//� Atualiza o saldo do titulo com base no SE5                   �
										//����������������������������������������������������������������
										SE2->E2_SALDO += SE5->E5_VLMOED2
									Endif
									//��������������������������������������������������������������Ŀ
									//� Bloco de codigo para contabilizacao                          �
									//����������������������������������������������������������������

								   	If lMaIntDel .and. ExecBlock("MaIntDel",.F.,.F.)
										If AllTrim( SE5->E5_TABORI ) == "FK2"
											aAreaAnt := GetArea()
											dbSelectArea( "FK2" )
											FK2->( DbSetOrder( 1 ) )
											If MsSeek( xFilial("FK2") + SE5->E5_IDORIG )
												oModelBxP := oModelMov := FWLoadModel("FINM020") //Model de baixas a pagar
												oModelBxP:SetOperation( MODEL_OPERATION_UPDATE ) //Alteracao
												oModelBxP:Activate()
												oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravacao SE5
												//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
												//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
												//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
												oModelMov:SetValue( "MASTER", "E5_OPERACAO", 2 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
										
												cCamposE5 := "{"
												
												If lUsaFlag
													aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
												Elseif !lUsaFlag .and. lLctPad
													cCamposE5 += "{'E5_LA', 'S'}
												EndIf
										
												If UsaSeqCor()
													if Len(cCamposE5)>1 
													   cCamposE5 += ","
													endif
													cCamposE5 += "{'E5_NODIA', ''}"
												EndIf
												cCamposE5 += "}"
										
												If oModelMov:VldData()
											       	oModelMov:CommitData()
												   	SE5->(dbGoto(oModelBxP:GetValue( "MASTER", "E5_RECNO" )))
											       	oModelMov:DeActivate()
												Else
													lRet := .F.
												    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
												    cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
												    cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
										    
											       	Help( ,,"M030VALID",,cLog, 1, 0 )
										       		
												Endif								
											Endif
											RestArea(aAreaAnt)
										EndIf
										
										If UsaSeqCor()
	 										AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
	  									EndIf

										If lLctPad
											If lHeadProva
												REGVALOR := SE2->(RecNo())
												nTotalCtb += DetProva(nHdlPrv,cPadrao,"FINA330",cLoteCtb)
											EndIf
										EndIf

								   	Else

										If lLctPad
											Eval(bContabil)
										EndIf

										//��������������������������������������������������������������Ŀ
										//?Deleta o registro de baixa                                   ?
										//����������������������������������������������������������������
										If AllTrim( SE5->E5_TABORI ) == "FK2"
											aAreaAnt := GetArea()
											dbSelectArea( "FK2" )
											FK2->( DbSetOrder( 1 ) )
											If MsSeek( xFilial("FK2") + SE5->E5_IDORIG )
												oModelBxP := oModelMov := FWLoadModel("FINM020") //Model de baixas a pagar
												oModelBxP:SetOperation( MODEL_OPERATION_UPDATE ) //Alteracao
												oModelBxP:Activate()
												oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravacao SE5
												//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
												//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
												//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
												oModelMov:SetValue( "MASTER", "E5_OPERACAO", 3 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
										
												If oModelMov:VldData()
											       	oModelMov:CommitData()
												   	SE5->(dbGoto(oModelBxP:GetValue( "MASTER", "E5_RECNO" )))
											       	oModelMov:DeActivate()
												Else
													lRet := .F.
												    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
												    cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
												    cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
										    
										       		Help( ,,"M030VALID",,cLog, 1, 0 )
												Endif								
											Endif
											RestArea(aAreaAnt)
										Endif

								   	Endif

								dbSelectArea("SE5")
								dbSkip()
							EndDo

							For nY := 1 to Len( aDelCorre )
								dbGoTo(aDelCorre[nY][1])
								//��������������������������������������������������������������Ŀ
								//?Bloco de codigo para contabilizacao                          ?
								//����������������������������������������������������������������
								If lLctPad
									Eval(bContabil)
								EndIf           
								If AllTrim( SE5->E5_TABORI ) == "FK2"
									aAreaAnt := GetArea()
									dbSelectArea( "FK2" )
									FK2->( DbSetOrder( 1 ) )
									If MsSeek( xFilial("FK2") + SE5->E5_IDORIG )
										oModelBxP := oModelMov := FWLoadModel("FINM020") //Model de baixas a pagar
										oModelBxP:SetOperation( MODEL_OPERATION_UPDATE ) //Alteracao
										oModelBxP:Activate()
										oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravacao SE5
										//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
										//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
										//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
										oModelMov:SetValue( "MASTER", "E5_OPERACAO", 3 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
								
										If oModelMov:VldData()
									       	oModelMov:CommitData()
										   	SE5->(dbGoto(oModelBxP:GetValue( "MASTER", "E5_RECNO" )))
									       	oModelMov:DeActivate()
										Else
											lRet := .F.
										    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
										    cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
										    cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
								    
								       		Help( ,,"M030VALID",,cLog, 1, 0 )
										Endif								
									Endif
									RestArea(aAreaAnt)
								EndIf

							Next nY
							//��������������������������������������������������������������Ŀ
							//� Encerra a atualizacao do adiantamento                        �
							//����������������������������������������������������������������
							SE2->E2_VALLIQ := 0
							SE2->E2_BAIXA  := IIf(SE2->E2_SALDO==SE2->E2_VALOR,Ctod(""),SE2->E2_BAIXA)
						EndIf
					EndIf

					//��������������������������������������������������������������Ŀ
					//� Bloco de codigo para contabilizacao                          �
					//����������������������������������������������������������������
/*					If lLctPad
						Eval(bContabil)
					EndIf*/

					//��������������������������������������������������������������Ŀ
					//� Reposiciona o titulo principal                               �
					//����������������������������������������������������������������
					SE2->E2_CORREC := 0
					RestArea(aAreaSE2)
					//��������������������������������������������������������������Ŀ
					//� Reposiciona no registro de baixa do titulo compensado        �
					//����������������������������������������������������������������
					dbSelectArea("SE5")
					MsGoto(aDelCmp[nX][2])

					//��������������������������������������������������������������Ŀ
					//� Guarda a chave primary da baixa para busca futura            �
					//����������������������������������������������������������������
					cPrimary := SE5->E5_DOCUMEN

				   	If lMaIntDel .and. ExecBlock("MaIntDel",.F.,.F.)

						//�����������������������������������������������������Ŀ
						//� Obtem os dados do registro tipo RA para gerar um	�
						//� registro de estorno 							    �
						//�������������������������������������������������������
						aSE5 := {}
						dbSetOrder( 1 )
						For nW := 1 to SE5->( Fcount() )
							AAdd( aSE5, SE5->( FieldGet(nW) ) )
						Next
						//�����������������������������������������������������Ŀ
						//� Grava o registro de estorno                         �
						//�������������������������������������������������������
						If AllTrim( SE5->E5_TABORI ) == "FK2"
							aAreaAnt := GetArea()
							dbSelectArea( "FK2" )
							FK2->( DbSetOrder( 1 ) )
							If MsSeek( xFilial("FK2") + SE5->E5_IDORIG )
								oModelBxP := oModelMov := FWLoadModel("FINM020") //Model de baixas a pagar
								oModelBxP:SetOperation( MODEL_OPERATION_UPDATE ) //Alteracao
								oModelBxP:Activate()
								oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravacao SE5
								//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
								//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
								//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
								oModelMov:SetValue( "MASTER", "E5_OPERACAO", 2 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
						
								cCamposE5 := "{"
						
								If lUsaFlag
									aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
								Elseif !lUsaFlag .and. lLctPad
									cCamposE5 += "{'E5_LA', 'S'}
								EndIf
						
								If UsaSeqCor()
									if Len(cCamposE5)>1 
									   cCamposE5 += ","
									endif
									cCamposE5 += "{'E5_NODIA', ''}"
								EndIf
								cCamposE5 += "}"
						
								If oModelMov:VldData()
							       	oModelMov:CommitData()
								   	SE5->(dbGoto(oModelBxP:GetValue( "MASTER", "E5_RECNO" )))
							       	oModelMov:DeActivate()
								Else
									lRet := .F.
								    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
								    cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
								    cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
						       		Help( ,,"M030VALID",,cLog, 1, 0 )
								Endif								
							Endif
							RestArea(aAreaAnt)
						EndIf

						If UsaSeqCor()
 							AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
  						EndIf

  						If lHeadProva
							VALOR    := SE5->E5_VALOR
							VALOR2	:= SE5->E5_VLCORRE  //Variacao monetaria do titulo Principal
							nRecSE2 := SE2->(Recno())
							nRecSE5 := SE5->(Recno())
							SE5->(MsGoto(0))
							SE2->(MsGoto(0))
							REGVALOR := SE2->(RecNo())
							nTotalCtb += DetProva(nHdlPrv,cPadrao,"FINA330",cLoteCtb)
							VALOR		:= 0
							VALOR2	:= 0
							SE5->(DbGoTo(nRecSE5))
							SE2->(DbGoTo(nRecSE2))
						EndIf

  					Else

						If lHeadProva
							VALOR    := SE5->E5_VALOR
							VALOR2	:= SE5->E5_VLCORRE  //Variacao monetaria do titulo Principal
							nRecSE2 := SE2->(Recno())
							nRecSE5 := SE5->(Recno())
							REGVALOR := SE2->(RecNo())
							SE5->(MsGoto(0))
							SE2->(MsGoto(0))
							nTotalCtb += DetProva(nHdlPrv,cPadrao,"FINA330",cLoteCtb)
							VALOR	:= 0
							VALOR2	:= 0
							SE5->(DbGoTo(nRecSE5))
							SE2->(DbGoTo(nRecSE2))
						EndIf
						//��������������������������������������������������������������Ŀ
						//� Deleta o registro de baixa                                   �
						//����������������������������������������������������������������
						If AllTrim( SE5->E5_TABORI ) == "FK2"
							aAreaAnt := GetArea()
							dbSelectArea( "FK2" )
							FK2->( DbSetOrder( 1 ) )
							If MsSeek( xFilial("FK2") + SE5->E5_IDORIG )
								oModelBxP := oModelMov := FWLoadModel("FINM020") //Model de baixas a pagar
								oModelBxP:SetOperation( MODEL_OPERATION_UPDATE ) //Alteracao
								oModelBxP:Activate()
								oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravacao SE5
								//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
								//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
								//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
								oModelMov:SetValue( "MASTER", "E5_OPERACAO", 3 ) //E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
						
								If oModelMov:VldData()
							       	oModelMov:CommitData()
								   	SE5->(dbGoto(oModelBxP:GetValue( "MASTER", "E5_RECNO" )))
							       	oModelMov:DeActivate()
								Else
									lRet := .F.
								    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
								    cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
								    cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
						       		Help( ,,"M030VALID",,cLog, 1, 0 )
								Endif								
							Endif
							RestArea(aAreaAnt)
						Endif

					Endif

					//��������������������������������������������������������������Ŀ
					//� Encerra a atualizacao do adiantamento                        �
					//����������������������������������������������������������������
					SE2->E2_SALDO  += SE5->E5_VLMOED2
					SE2->E2_VALLIQ := 0
					SE2->E2_BAIXA  := IIf(SE2->E2_SALDO==SE2->E2_VALOR,Ctod(""),SE2->E2_BAIXA)

					//��������������������������������������������������������������Ŀ
					//� Executa o codeblock                                          �
					//����������������������������������������������������������������
					Eval(bBlock,aAreaSE2[3],cPrimary)

				Next nX
			EndIf
		EndIf
	EndIf
EndIf
RestArea(aArea)
Return(.T.)