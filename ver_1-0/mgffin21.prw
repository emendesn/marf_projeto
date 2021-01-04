#INCLUDE 'PROTHEUS.CH'
/*
=====================================================================================
Programa.:              MGFFIN21
Autor....:              Rafael Garcia de Melo	
Data.....:              14/10/2016
Descricao / Objetivo:   Compensacao automatica de notas de Credito (devolucao de Vendas)
Doc. Origem:            GAP FIN_CRE035_V1
Solicitante:            Cliente
Uso......:              
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
					������������������������������������������������������������������������������
					��������������������������������������������������������������������������Ŀ��
					���Funcao    �MaIntBxCR � Autor � Eduardo Riera         � Data �31.08.2001 ���
					��������������������������������������������������������������������������Ĵ��
					���          �Rotina de integracao com as baixas do financeiro             ���
					���          �                                                             ���
					��������������������������������������������������������������������������Ĵ��
					���Parametros�ExpN1: Codigo da operacao a ser efetuada                     ���
					���          �       [1] Baixa simples do financeiro                       ���
					���          �       [2] Liquidacao de titulos                             ���
					���          �       [3] Compensacao de titulos de mesma carteira (RA/NCC) ���
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
					���          �ExpA13:Array com os valores parciais dos titulos a serem     ���
					���          �       compensados - na ausencia deste parametro sera criado ���
					���          �       um Array contendo o mesmo tamanho do Array definido   ���
					���          �       no 4o. parametro e preenchidos com zeros (0).         ���
					���          �       aNCC_RA    ( 4o. parametro)                           ���
					���          �       aNCC_RAvlr (13o. parametro)                           ���
					��������������������������������������������������������������������������Ĵ��
					���Retorno   �ExpC1: Primary Key do documento gerado.                      ���
					���          �                                                             ���
					��������������������������������������������������������������������������Ĵ��
					���Descricao �Esta rotina tem como objetivo efetuar a integracao com as bai���
					���          �xas do modulo financeiro e os titulos gerados pelo modulo de ���
					���          �faturamento                                                  ���
					���          �                                                             ���
					��������������������������������������������������������������������������Ĵ��
					���Uso       � Geral                                                       ���
					���������������������������������������������������������������������������ٱ�
					������������������������������������������������������������������������������
					������������������������������������������������������������������������������
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

