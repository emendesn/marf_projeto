#INCLUDE 'PROTHEUS.CH'
/*
=====================================================================================
Programa.:              MGFFIN21
Autor....:              Rafael Garcia de Melo	
Data.....:              14/10/2016
Descricao / Objetivo:   Compensação automática de notas de Credito (devolução de Vendas)
Doc. Origem:            GAP FIN_CRE035_V1
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamado pelo PE SF1100I
=====================================================================================
*/
User Function MGFFIN21()

	Local aArea			:= GetArea()
	Local aSE1			:= SE1->( GetArea() )
	Local aSD1			:= SD1->( GetArea() )
	Local aRecNCC   	:= {}
	Local aRecSE1		:= {}
	Local aRecSD1		:= {}
	Local aChv
	Local lCompensa		:= GetNewPar("MGF_FIN21A",.T.)
	Local cParcNCC		:= GetNewPar("MGF_FIN21B","01")
	Local cTipoNCC		:= GetNewPar("MGF_FIN21C","NCC")
	Local nTaxaNCC		:= 0
	Local nMoedaNCC		:= 0
	Local nI, nPos, cChaveNCC
	Local lCtbOnLine
	Local nHdlPrv


	Local cQuery    	:= ""
	Local nRecTit		:= 0
	Local nRecNcc		:= 0
	Local nDecresTIT	:= 0
	Local nSddecrTIT	:= 0

	DEFAULT lCtbOnLine	:= .F.
	DEFAULT nHdlPrv		:= 0

	cParcNCC := Stuff( Space(Len(SE1->E1_PARCELA)) , 1 , Len(cParcNCC) , cParcNCC ) 
	cTipoNCC := Stuff( Space(Len(SE1->E1_TIPO)) , 1 , Len(cTipoNCC) , cTipoNCC ) 

	If SF1->F1_TIPO == "D" .And. !Empty(SF1->F1_DUPL) .And. lCompensa

		SE1->( dbSetOrder(2) ) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		//If SE1->( dbSeek( xFilial("SE1")+SF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DUPL+"A"/*Space(Len(SE2->E2_PARCELA))*/+"NCC") ) )
		If SE1->( dbSeek( xFilial("SE1")+SF1->(F1_FORNECE+F1_LOJA+F1_PREFIXO+F1_DUPL+cParcNCC+cTipoNCC) ) )
			aAdd( aRecNCC ,  SE1->( Recno() ) )

			SD1->( dbSetOrder(1) ) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			SE1->( dbSetOrder(2) ) // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO	

			aRecSD1	:= {}
			SD1->( dbSeek( SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) )
			While !SD1->( eof() ) .And. 	SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == 	SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)

				// aRecSE2	:= {}

				nPos := aScan( aRecSD1 , { |x| x[1]== SD1->(D1_FORNECE+D1_LOJA+D1_SERIORI+D1_NFORI) } )	

				If nPos == 0
					aAdd( aRecSD1 , { SD1->(D1_FORNECE+D1_LOJA+D1_SERIORI+D1_NFORI) , SD1->(D1_TOTAL+D1_VALIPI+D1_ICMSRET) ,  } )
					nPos := Len( aRecSD1 )
				Else
					aRecSD1[nPos,2] += SD1->(D1_TOTAL+D1_VALIPI+D1_ICMSRET)
				EndIf

				SD1->( dbSkip() )			

			EndDo

			dbSelectArea("SE1")
			SE1->( dbGoTo( aRecNCC[1] ) )
			Reclock("SE1",.F.)   
			SE1->E1_DECRESC := nDecresTIT
			SE1->E1_SDDECRE := nSddecrTIT
			SE1->(MsUnlock())						

			For nI := 1 to Len( aRecSD1 )

				aRecSE1 := {}
				If SE1->( dbSeek(xFilial("SE1")+aRecSD1[nI,1]) )
					nMoedaNCC := SE1->E1_MOEDA
					While !SE1->( eof() ) .And.	xFilial("SE1")+aRecSD1[nI,1] == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)

						If SE1->E1_TIPO == "NF " //.AND. SE1->E1_SITUACA=="0" // .And. Empty(SE2->E2_NUMBOR)
							aAdd( aRecSE1 ,  SE1->( Recno() ) ) 
							nDecresTIT += SE1->(E1_DECRESC/E1_SALDO)*SE1->E1_SALDO
							nSddecrTIT += SE1->(E1_SDDECRE/E1_SALDO)*SE1->E1_SALDO
						EndIf

						SE1->( dbSkip() )

					EndDo
				EndIf
				aRecSD1[nI,3] := aRecSE1

			Next nI

			For nI := 1 to Len( aRecSD1 )

				If Len( aRecSD1[nI,3] ) > 0
					SE1->( dbGoTo( aRecNCC[1] ) )
					cChaveNCC := xFilial("SE1") + "|" + SE1->E1_PREFIXO  + "|" + SE1->E1_NUM + ; 
					"|" + SE1->E1_PARCELA  + "|" + ;
					SE1->E1_TIPO   + "|" + SE1->E1_CLIENTE  + "|" + SE1->E1_LOJA
					/*/
					±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
					±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
					±±³Fun‡„o    ³MaIntBxCR ³ Autor ³ Eduardo Riera         ³ Data ³31.08.2001 ³±±
					±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
					±±³          ³Rotina de integracao com as baixas do financeiro             ³±±
					±±³          ³                                                             ³±±
					±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
					±±³Parametros³ExpN1: Codigo da operacao a ser efetuada                     ³±±
					±±³          ³       [1] Baixa simples do financeiro                       ³±±
					±±³          ³       [2] Liquidacao de titulos                             ³±±
					±±³          ³       [3] Compensacao de titulos de mesma carteira (RA/NCC) ³±±
					±±³          ³ExpA2: Array com os recnos dos titulos a serem baixados      ³±±
					±±³          ³ExpA3: Array com os dados da baixa simples do financeiro     ³±±
					±±³          ³       [1] Motivo da Baixa                                   ³±±
					±±³          ³       [2] Valor Recebido                                    ³±±
					±±³          ³       [3] Banco                                             ³±±
					±±³          ³       [4] Agencia                                           ³±±
					±±³          ³       [5] Conta                                             ³±±
					±±³          ³       [6] Data de Credito                                   ³±±
					±±³          ³       [7] Data da Baixa                                     ³±±
					±±³          ³ExpA4: Array com os recnos dos titulos a serem compensados   ³±±
					±±³          ³ExpA5: Array com os dados da liquidacao do financeiro        ³±±
					±±³          ³     {}[1] Prefixo                                           ³±±
					±±³          ³       [2] Banco                                             ³±±
					±±³          ³       [3] Agencia                                           ³±±
					±±³          ³       [4] Conta                                             ³±±
					±±³          ³       [5] Numero do Cheque                                  ³±±
					±±³          ³       [6] Data Boa                                          ³±±
					±±³          ³       [7] Valor                                             ³±±
					±±³          ³       [8] Tipo                                              ³±±
					±±³          ³       [9] Natureza                                          ³±±
					±±³          ³       [A] Moeda                                             ³±±
					±±³          ³ExpA6: Array com os parametros da rotina                     ³±±
					±±³          ³       [1] Contabiliza On-Line                               ³±±
					±±³          ³       [2] Aglutina Lancamentos Contabeis                    ³±±
					±±³          ³       [3] Digita lancamentos contabeis                      ³±±
					±±³          ³       [4] Juros para Comissao                               ³±±
					±±³          ³       [5] Desconto para Comissao                            ³±±
					±±³          ³       [6] Calcula Comiss s/NCC                              ³±±
					±±³          ³ExpB7: Bloco de codigo a ser executado apos o processamento  ³±±
					±±³          ³       da rotina, abaixo os parametro passados               ³±±
					±±³          ³       [1] Recno do titulo baixado                           ³±±
					±±³          ³       [2] Codigo a ser informado para cancelamento futuro.  ³±±
					±±³          ³ExpA8: Utilizado quando deve-se estornar uma das baixas efe- ³±±
					±±³          ³       tuadas. Para tanto, deve-se informar o codigo informa-³±±
					±±³          ³       do no codeBlock anterior.                             ³±±
					±±³          ³ExpA13:Array com os valores parciais dos titulos a serem     ³±±
					±±³          ³       compensados - na ausencia deste parametro sera criado ³±±
					±±³          ³       um Array contendo o mesmo tamanho do Array definido   ³±±
					±±³          ³       no 4o. parametro e preenchidos com zeros (0).         ³±±
					±±³          ³       aNCC_RA    ( 4o. parametro)                           ³±±
					±±³          ³       aNCC_RAvlr (13o. parametro)                           ³±±
					±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
					±±³Retorno   ³ExpC1: Primary Key do documento gerado.                      ³±±
					±±³          ³                                                             ³±±
					±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
					±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a integracao com as bai³±±
					±±³          ³xas do modulo financeiro e os titulos gerados pelo modulo de ³±±
					±±³          ³faturamento                                                  ³±±
					±±³          ³                                                             ³±±
					±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
					±±³Uso       ³ Geral                                                       ³±±
					±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
					±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
					ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
					/*/
					nRecTit:=aRecSD1[nI,3][1]
					nRecNcc:=aRecNCC[1]
					
					MaIntBxCR(3,aRecSD1[nI,3],,aRecNCC,,{lCtbOnLine,.F.,.F.,.F.,.F.,.F.},,,,,aRecSD1[nI,2]/*nSaldoComp*/,,nHdlPrv)
					
				EndIf
			Next nI
		EndIf
	EndIf
	RestArea(aSE1)
	RestArea(aSD1)
	RestArea(aArea)

Return

