#INCLUDE 'PROTHEUS.CH'
/*
=====================================================================================
Programa.:              MGFFIN21
Autor....:              Rafael Garcia de Melo	
Data.....:              14/10/2016
Descricao / Objetivo:   Compensa玢o autom醫ica de notas de Credito (devolu玢o de Vendas)
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
					北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
					北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
					北矲un噭o    矼aIntBxCR � Autor � Eduardo Riera         � Data �31.08.2001 潮�
					北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
					北�          砇otina de integracao com as baixas do financeiro             潮�
					北�          �                                                             潮�
					北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
					北砅arametros矱xpN1: Codigo da operacao a ser efetuada                     潮�
					北�          �       [1] Baixa simples do financeiro                       潮�
					北�          �       [2] Liquidacao de titulos                             潮�
					北�          �       [3] Compensacao de titulos de mesma carteira (RA/NCC) 潮�
					北�          矱xpA2: Array com os recnos dos titulos a serem baixados      潮�
					北�          矱xpA3: Array com os dados da baixa simples do financeiro     潮�
					北�          �       [1] Motivo da Baixa                                   潮�
					北�          �       [2] Valor Recebido                                    潮�
					北�          �       [3] Banco                                             潮�
					北�          �       [4] Agencia                                           潮�
					北�          �       [5] Conta                                             潮�
					北�          �       [6] Data de Credito                                   潮�
					北�          �       [7] Data da Baixa                                     潮�
					北�          矱xpA4: Array com os recnos dos titulos a serem compensados   潮�
					北�          矱xpA5: Array com os dados da liquidacao do financeiro        潮�
					北�          �     {}[1] Prefixo                                           潮�
					北�          �       [2] Banco                                             潮�
					北�          �       [3] Agencia                                           潮�
					北�          �       [4] Conta                                             潮�
					北�          �       [5] Numero do Cheque                                  潮�
					北�          �       [6] Data Boa                                          潮�
					北�          �       [7] Valor                                             潮�
					北�          �       [8] Tipo                                              潮�
					北�          �       [9] Natureza                                          潮�
					北�          �       [A] Moeda                                             潮�
					北�          矱xpA6: Array com os parametros da rotina                     潮�
					北�          �       [1] Contabiliza On-Line                               潮�
					北�          �       [2] Aglutina Lancamentos Contabeis                    潮�
					北�          �       [3] Digita lancamentos contabeis                      潮�
					北�          �       [4] Juros para Comissao                               潮�
					北�          �       [5] Desconto para Comissao                            潮�
					北�          �       [6] Calcula Comiss s/NCC                              潮�
					北�          矱xpB7: Bloco de codigo a ser executado apos o processamento  潮�
					北�          �       da rotina, abaixo os parametro passados               潮�
					北�          �       [1] Recno do titulo baixado                           潮�
					北�          �       [2] Codigo a ser informado para cancelamento futuro.  潮�
					北�          矱xpA8: Utilizado quando deve-se estornar uma das baixas efe- 潮�
					北�          �       tuadas. Para tanto, deve-se informar o codigo informa-潮�
					北�          �       do no codeBlock anterior.                             潮�
					北�          矱xpA13:Array com os valores parciais dos titulos a serem     潮�
					北�          �       compensados - na ausencia deste parametro sera criado 潮�
					北�          �       um Array contendo o mesmo tamanho do Array definido   潮�
					北�          �       no 4o. parametro e preenchidos com zeros (0).         潮�
					北�          �       aNCC_RA    ( 4o. parametro)                           潮�
					北�          �       aNCC_RAvlr (13o. parametro)                           潮�
					北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
					北砇etorno   矱xpC1: Primary Key do documento gerado.                      潮�
					北�          �                                                             潮�
					北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
					北矰escri噭o 矱sta rotina tem como objetivo efetuar a integracao com as bai潮�
					北�          硏as do modulo financeiro e os titulos gerados pelo modulo de 潮�
					北�          砯aturamento                                                  潮�
					北�          �                                                             潮�
					北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
					北砋so       � Geral                                                       潮�
					北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
					北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
					哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
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

