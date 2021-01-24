#Include 'Protheus.ch'
#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
=====================================================================================
Programa............: MGFFAT16
Autor...............: Joni Lima
Data................: 17/10/2016
Descrição / Objetivo: Função para Regras Marfrig de bloqueio
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza as validações dos Bloqueios Marfrig conforme Regras
=====================================================================================
*/
User Function MGFFAT16(cNumBlq)

	Local aArea			:= GetArea()
	Local nValMin   	:= SuperGetMV("MGF_FAT16A",.F.,150) //Valor Minimo de Pedido
	Local nValMaxPer   	:= SuperGetMV("MGF_FAT16B",.F.,30)  //Valor porcentagem Superior Permitido
	Local nValMinPer   	:= SuperGetMV("MGF_FAT16C",.F.,30)  //Valor porcentagem Inferior Permitido
	Local cCodEspec   	:= SuperGetMV("MGF_FAT16E",.F.,'BO|DO|AM')  //Códigos da especie de pedido utilizados para regra 18
	Local cCodPedLib   	:= SuperGetMV("MGF_FAT16F",.F.,'TP|EX|TI|DV|RB|MI|IM|TE')  //Códigos da especie de pedido que não passarão por aprovação
	Local lRet 			:= /*SC5->C5_TIPOCLI <> "X" .AND.*/ !(SC5->C5_ZTIPPED $ cCodPedLib)  //Tem que ficar .T. para passar por aprovação, se ficar .F. passa direto.

	Local nValAtrs		:= 0
	Local nTotPed		:= 0
	Local nMoedaNF  	:= 1
	Local nLimCrd		:= 0
	Local nSld			:= 0
	Local nAcres		:= 0

	Local nRiscoB		:= SuperGetMV("MV_RISCOB",.F.,30) //Dias máximo de atraso tolerável para Riscoo B
	Local nRiscoC       := SuperGetMV("MV_RISCOC",.F.,20) //Dias máximo de atraso tolerável para Riscoo C
	Local nRiscoD       := SuperGetMV("MV_RISCOD",.F.,10) //Dias máximo de atraso tolerável para Riscoo D
	Local cCodPer   	:= AllTrim(SuperGetMV("MGF_FAT16D",.F.,'000099'))  //Código da Perda.
	Local cEspAlm   	:= AllTrim(SuperGetMV("MGF_FAT16G",.F.,' '))  //Código da Perda.
	Local nMedAtr   	:= SuperGetMV("MGF_FAT16H",.F.,8)    //Media de dias de atraso do cliente.
	Local cBlCred		:= ''
	Local aEmpenho		:= {}
	Local lCredito		:= .T.

	local aAreaSA2

	local cFilNewStc	:= allTrim( superGetMv( "MGF_FAT13B" , , "" )  )
	local aSaldo		:= {}

	Default cNumBlq 	:= ''

	//conout("INICIO PROGRAMA FAT16")
	If !Empty( cNumBlq ) .AND. lRet .AND. ( xVerReg( SC5->C5_ZTIPPED ) .OR. xVerTES() ) .AND. SC5->C5_XORCAME <> "S"

		cNumBlq := Alltrim(cNumBlq)

		DO CASE
			CASE cNumBlq == '01'//Cliente Suspenso
			If SC5->C5_TIPO == 'N' .AND. !(SC5->C5_ZTIPPED $ cCodEspec)
				If SA1->A1_MSBLQL <> '1' .OR. SA1->A1_ZGDERED == 'S' //GAP CRE019 FASE 4 Grandes Redes
					lRet := .F.
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '02'//Cliente com duplicatas em atraso
			If SC5->C5_TIPO == 'N' .AND. SA1->A1_ZGDERED <> 'S' .AND. !(SC5->C5_ZTIPPED $ cCodEspec)//GAP CRE019 FASE 4 Grandes Redes
				//Consulta os titulos em atraso
				//nValAtrs := CrdXTitAtr(SA1->A1_COD + SA1->A1_LOJA, Nil, Nil, .F.)
				//nValAtrs := xCrdXTitAt(SA1->A1_COD + SA1->A1_LOJA, Nil, Nil, .F.)
				nValAtrs := xTAbert(SA1->A1_COD,SA1->A1_LOJA)
				If !(nValAtrs > 0)
					lRet := .F.
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '03'//Cliente com dias de atraso médio atingido
			If SC5->C5_TIPO == 'N' .AND. SA1->A1_ZGDERED <> 'S' .AND. !(SC5->C5_ZTIPPED $ cCodEspec)//GAP CRE019 FASE 4 Grandes Redes
				//				nTotPed	:= U_xMF16TotPd(SC5->C5_NUM)
				//				If !Empty(SC5->C5_MOEDA)
				//					nMoedaNF := SC5->C5_MOEDA
				//				EndIf
				//				lCredito := MaAvalCred(SA1->A1_COD,SA1->A1_LOJA,nTotPed,nMoedaNF,.T.,@cBlCred,@aEmpenho)
				//				If lCredito
				//					lRet := .F.
				//				EndIf
				If SA1->A1_RISCO == 'A'
					lRet := .F.
				ElseIf SA1->A1_RISCO == 'B'
					If SA1->A1_METR <= nRiscoB
						lRet := .F.
					Endif
				ElseIf SA1->A1_RISCO == 'C'
					If SA1->A1_METR <= nRiscoC
						lRet := .F.
					Endif
				ElseIf SA1->A1_RISCO == 'D'
					If SA1->A1_METR <= nRiscoD
						lRet := .F.
					Endif
				ElseIf empty(SA1->A1_RISCO)
					//If SA1->A1_METR <= 3 //William 13/08/2019 - Mudança para pegar valor de parametro MGF_MATR
					If SA1->A1_METR <= nMedAtr
						lRet := .F.
					endif
				Endif
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '04'//Cliente sem limite de crédito
			If SC5->C5_TIPO == 'N' .AND. SA1->A1_ZGDERED <> 'S' .AND. !(SC5->C5_ZTIPPED $ cCodEspec) //GAP CRE019 FASE 4 Grandes Redes
				If SA1->A1_LC > 0
					lRet := .F.
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '05'//Endereço de entrega bloqueado
			If SC5->C5_TIPO == 'N'
				If FieldPos("C5_ZIDEND") > 0 .AND. !Empty(SC5->C5_ZIDEND)
					dbSelectArea('SZ9')
					SZ9->(dbSetOrder(1))//Z9_FILIAL + Z9_ZCLIENT + Z9_ZLOJA + Z9_ZIDEND
					If (SZ9->(dbSeek(xFilial('SZ9') + SC5->C5_CLIENTE + SC5->C5_LOJACLI + SC5->C5_ZIDEND)))
						If SZ9->Z9_MSBLQL == 2
							lRet := .F.
						Endif
					EndIf
				Else
					lRet := .F.
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '06'//Alteração da condição de pagamento
			If SC5->C5_TIPO == 'N' .AND. SA1->A1_ZGDERED <> 'S' .AND. !(SC5->C5_ZTIPPED $ cCodEspec) //GAP CRE019 FASE 4 Grandes Redes
				If SA1->A1_COND == SC5->C5_CONDPAG
					lRet := .F.
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '07'//Total do pedido maior que o limite de crédito
			If SC5->C5_TIPO == 'N' .AND. SA1->A1_ZGDERED <> 'S' .AND. !(SC5->C5_ZTIPPED $ cCodEspec) //GAP CRE019 FASE 4 Grandes Redes
				//nTotPed	:= U_xMF16TotPd(SC5->C5_NUM) //Total do Pedido
				lRet := !(xMF16VLC(SA1->A1_COD,SA1->A1_LOJA))
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '08'//Valor total abaixo do mínimo
			If SC5->C5_TIPO == 'N' .AND. SA1->A1_ZGDERED <> 'S' //GAP CRE019 FASE 4 Grandes Redes
				nTotPed := xMF16TSPed(SC5->C5_NUM)
				If nTotPed >= nValMin
					lRet := .F.
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '09'//Condição de Pagamento Antecipada
			If SC5->C5_TIPO == 'N' .AND. SA1->A1_ZGDERED <> 'S' .AND. !(SC5->C5_ZTIPPED $ cCodEspec) //GAP CRE019 FASE 4 Grandes Redes
				dbSelectArea('SE4')
				SE4->(dbSetOrder(1))//E4_FILIAL, E4_CODIGO
				If SE4->(dbSeek(FWxFilial('SE4') + SC5->C5_CONDPAG))
					/*If SE4->E4_CTRADT <> '1'
						lRet := .F.
					EndIf*/
					If SE4->E4_ZAFAT14 <> '1'//Adiantamento FAT14
						lRet := .F.
					EndIf
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '73'//Preço máximo de venda atingido
			If SC5->C5_TIPO == 'N' .and. alltrim(SC5->C5_ZTIPPED) <> alltrim(cEspAlm) .and. xMF16EBLQ(SC5->C5_NUM,SC6->C6_ITEM)
				nPrcVen := MaTabPrVen(SC5->C5_TABELA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_MOEDA,SC5->C5_EMISSAO)

				If !Empty(SC5->C5_TABELA)
					nAcres := u_T05Preco(SC5->C5_TABELA)
					If nAcres > 0
						nPrcVen := nPrcVen + ( nPrcVen * ( nAcres/100) )
					EndIf
				EndIf

				If SC6->C6_PRCVEN <= (nPrcVen * (1 + (nValMaxPer/100)))
					lRet := .F.
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '11'//Saldo minimo em estoque atingido
			If SC5->C5_TIPO == 'N'
				Conout("[MGFFAT16] - Analizado Filial:"+SC6->C6_FILIAL+" Pedido:"+SC6->C6_NUM+" Item: "+SC6->C6_ITEM+" Produto: "+Alltrim(SC6->C6_PRODUTO)+" Qtd Pedido: "+Transform(SC6->C6_QTDVEN,"@E 999,999,999.9999"))

				if SC6->C6_FILIAL $ cFilNewStc
					aSaldo := {}
					aSaldo := U_MGFFATBI( SC6->C6_FILIAL , SC6->C6_PRODUTO , SC6->C6_ZDTMIN , SC6->C6_ZDTMAX , .F. , SC6->C6_QTDVEN , SC6->C6_XULTQTD )

					lRet := ( aSaldo[4] < 0 )
				else
					lRet := !(xMF16SldAv(SC6->C6_FILIAL,SC6->C6_PRODUTO,SC6->C6_ZDTMIN,SC6->C6_ZDTMAX))
				endif

			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '74'//Bloqueio Valor Abaixo Desconto Progressivo
			If SC5->C5_TIPO == 'N' .and. xMF16EBLQ(SC5->C5_NUM,SC6->C6_ITEM)
				lRet := xMF16DcPro()
			Else
				lRet := .F.
			Endif
			CASE cNumBlq == '72'//Preço abaixo do preço da lista
			If SC5->C5_TIPO == 'N' .and. xMF16EBLQ(SC5->C5_NUM,SC6->C6_ITEM)
				nPrcVen := MaTabPrVen(SC5->C5_TABELA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_MOEDA,SC5->C5_EMISSAO)
//				If round(SC6->C6_PRCVEN, 2) >= nPrcVen //Comentado por William em 17/04/2019.
				If round(SC6->C6_PRCVEN, 2) >= Round(nPrcVen, 2)
					lRet := .F.
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '71'//Preço mínimo de venda atingido*/
			If SC5->C5_TIPO == 'N'
				nPrcVen := MaTabPrVen(SC5->C5_TABELA,SC6->C6_PRODUTO,SC6->C6_QTDVEN,SC5->C5_CLIENTE,SC5->C5_LOJACLI,SC5->C5_MOEDA,SC5->C5_EMISSAO)
				If (SC6->C6_PRCVEN > (nPrcVen * (1 - (nValMinPer/100))))
					lRet := .F.
				EndIf
			Else
				lRet := .F.
			EndIf
			CASE cNumBlq == '15'//Data de limite de crédito vencida
			If SC5->C5_TIPO == 'N' .AND. SA1->A1_ZGDERED <> 'S' //GAP CRE019 FASE 4 Grandes Redes
				If SA1->A1_VENCLC > SC5->C5_EMISSAO //Verifica se a data esta viginte
					lRet := .F.
				EndIf
			else
				lRet := .F.
			Endif
			CASE cNumBlq == '16'//Pedido aguardando transferência.
			If Empty(SC6->C6_ZPEDPAI)//Se preenchido realiza o bloqueio
				lRet := .F.
			EndIf
			CASE cNumBlq == '17'//Não Contribuinte DIFAL.
			If SC5->C5_TIPO $ 'N/C'
				If SA1->A1_EST == SM0->M0_ESTENT
					lRet := .F.
				Endif
				If SA1->A1_TIPO <> 'F'
					lRet := .F.
				Endif
				If SA1->A1_TIPO == 'F' .AND. Empty(SA1->A1_INSCR) .AND. SA1->A1_CONTRIB == '2' //Se .T. verifica se a UF está na F0L
					dbSelectArea('F0L')
					F0L->(dbSetOrder(1))//F0L_FILIAL, F0L_UF, F0L_INSCR
					If (F0L->(dbSeek(xFilial('F0L')+SA1->A1_EST)))
						lRet := .F.
					Endif
				ElseIf SA1->A1_TIPO == 'F' .AND. !Empty(SA1->A1_INSCR) .AND. SA1->A1_CONTRIB == '1' //Se .T. verifica se a UF está na F0L
					dbSelectArea('F0L')
					F0L->(dbSetOrder(1))//F0L_FILIAL, F0L_UF, F0L_INSCR
					If (F0L->(dbSeek(xFilial('F0L') + SA1->A1_EST)))
						lRet := .F.
					Endif
				EndIf
			elseIf SC5->C5_TIPO == 'B'
				aAreaSA2 := SA2->(getArea())

				DBSelectArea("SA2")
				SA2->(DBSetOrder(1))

				if SA2->( DBSeek( xFilial("SA2") + SC5->( C5_CLIENTE + C5_LOJACLI ) ) )
					If SA2->A2_EST == SM0->M0_ESTENT
						lRet := .F.
					Endif
					If SA2->A2_TIPO <> 'F'
						lRet := .F.
					Endif
					If SA2->A2_TIPO == 'F' .AND. Empty(SA2->A2_INSCR) .AND. SA2->A2_CONTRIB == '2' //Se .T. verifica se a UF está na F0L
						dbSelectArea('F0L')
						F0L->(dbSetOrder(1))//F0L_FILIAL, F0L_UF, F0L_INSCR
						If (F0L->(dbSeek(xFilial('F0L')+SA2->A2_EST)))
							lRet := .F.
						Endif
					ElseIf SA2->A2_TIPO == 'F' .AND. !Empty(SA2->A2_INSCR) .AND. SA2->A2_CONTRIB == '1' //Se .T. verifica se a UF está na F0L
						dbSelectArea('F0L')
						F0L->(dbSetOrder(1))//F0L_FILIAL, F0L_UF, F0L_INSCR
						If (F0L->(dbSeek(xFilial('F0L') + SA2->A2_EST)))
							lRet := .F.
						Endif
					EndIf
				else
					lRet := .F.
				endif

				restArea(aAreaSA2)
			Endif
			CASE cNumBlq == '18'//Pedido Tipo Bonificação/Doação/Amostra.
			If SC5->C5_TIPO $ 'N/C'
				If !(SC5->C5_ZTIPPED $ cCodEspec) //Se preenchido com BO-Bonificacao/DO-Doacao/AM-Amostra realiza o bloqueio
					lRet := .F.
				EndIf
			Endif
			CASE cNumBlq $ '90|91|92|93|94|95'
			lRet := .F.
			CASE cNumBlq $ '96|97|98'
			//Verificar se Existe Nota nas ultimas 24 Horas
			/*If SC5->C5_TIPO == 'N'
			If !(U_xMF16N24H())
			lRet := .F.
			EndIf
			RecLock('SC5',.F.)
			If lRet
			SC5->C5_ZCONFIS := 'S'
			Else
			SC5->C5_ZCONFIS := 'N'
			SC5->C5_ZCONWS  := 'S'
			EndIf
			SC5->(MsUnlock())
			EndIf*/
			lRet := .F.
			CASE cNumBlq == '99'
			If alltrim(SC5->C5_ZTIPPED) <> alltrim(cCodPer)
				lRet := .F.
			EndIf
		ENDCASE
	Else
		lRet := .F.
	EndIf

	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMF16DcPro
Autor...............: Joni Lima
Data................: 06/12/2016
Descrição / Objetivo: Realiza a verificação se o desconto manual esta acima do valor maximo de desconto que o desconto progressivo permitiria
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Verifica se o valor do desconto manual esta acima do maior valor de desconto progressivo.
=====================================================================================
*/
Static Function xMF16DcPro()

	Local lRet 			:= .F.
	Local nQdtSKU		:= 0
	Local nVolume		:= 0
	Local nDescProg		:= 0
	Local aAreaAtu      := GetArea()
	Local aAreaSC6      := SC6->( GetArea() )


	//SC6->(DbSetOrder(1))
	//SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
	//While !SC6->(EOF()) .and. SC6->(C6_FILIAL + C6_NUM) == (xFilial("SC6")+SC5->C5_NUM) .and. !lRet
	//If SC6->C6_DESCONT > 0

	//conout("Barbieri Desconto" + str(SC6->C6_DESCONT) )
	//------------------------------------------------------------------------------
	//Busca a quantidade de SKU e VOLUME do pedido
	//------------------------------------------------------------------------------
	u_T06SKU(SC6->C6_NUM, @nQdtSKU, @nVolume)
	//conout("Barbieri SKU/Volume" + str(nQdtSKU) + " / " + str(nVolume) )

	//------------------------------------------------------------------------------
	//Busca o % de maior desconto progressivo, por quantidade de SKU ou por Volume
	//------------------------------------------------------------------------------
	nDescProg	:= u_T06DESC(SC5->C5_TABELA, nQdtSKU, nVolume)
	//conout("Barbieri DescProgr" + str(nDescProg) )

	SC6->(RestArea(aAreaSC6))

	If nDescProg > 0
		If NoRound(100 - ((SC6->C6_PRCVEN * 100)/SC6->C6_PRUNIT),TamSx3('ZL_PERDESC')[2]) > nDescProg
			lRet := .T.
		EndIf
	Else
		If SC6->C6_PRCVEN < SC6->C6_PRUNIT
			lRet := .T.
		EndIf
	EndIf

		//EndIf
		//SC6->(DbSkip())
	//Enddo

	SC6->(RestArea(aAreaSC6))
	RestArea(aAreaAtu)

Return lRet

/*
=====================================================================================
Programa............: xMF16SldAv
Autor...............: Joni Lima
Data................: 01/12/2016
Descrição / Objetivo: Realiza Comparação de Saldo por Lote com quantiade nos pedidos
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza comparação de Total de Pedidos e Saldo Por Lote
=====================================================================================
*/
Static Function xMF16SldAv(cFilSC6,cProdut,dDtMin,dDtMax)

	Local aArea 	:= GetArea()
	Local lRet		:= .T.
	Local aRet      := {}
	Local bTaura    := .F.
	Local bFEFO     := .F.
	Local nPedQtd   := 0
	Local nSaldo    := 0
	Local CFILC6    := ''
	Local cMGFFEFO	:= SUPERGETMV("MGF_FEFO",,"FF")

	If ValType(dDtMin) <> 'D'
		dDtMin := CtoD('//')
	EndIf

	If ValType(dDtMax) <> 'D'
		dDtMax := CtoD('//')
	EndIf

	dbSelectArea('SZJ')
	SZJ->(dbSetOrder(1))
	SZJ->(dbSeek(xFilial('SZJ')+SC5->C5_ZTIPPED))
	IF SZJ->(!EOF()) .AND. SZJ->ZJ_TAURA='S'
		bTaura := .T.
	EndIF

	Conout("[MGFFAT16] - Analizado bTaura: "+cValToChar(bTaura))

	IF bTaura

		aRetSaldo := {0,0}
		aRetSaldo := getSalProt(cProdut, SC5->C5_NUM, SC5->C5_FILIAL, .F., dDtMin, dDtMax )
		Conout("[MGFFAT16] - Retornou aRetSaldo Saldo: "+ Transform(aRetSaldo[1],"@E 999,999,999.9999") + " e peso medio: "+ Transform(aRetSaldo[2],"@E 999,999,999.9999") )

		IF aRetSaldo[1] <= 0
			lRet := .F.
		EndIF
	Else
		cQuery  := " Select SUM(B2_QATU) SALDO"
		cQuery  += " From "+RetSqlName("SB2")
		cQuery  += " Where B2_FILIAL = '"+cFilSC6+"'"
		cQuery  += "   AND B2_COD    = '"+cProdut+"'"
		cQuery  += "   AND B2_LOCAL  = '"+SC6->C6_LOCAL+"' "
		cQuery  += "   AND D_E_L_E_T_ = ' '"

		If Select("QRY_SB2") > 0
			QRY_SB2->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SB2",.T.,.F.)
		dbSelectArea("QRY_SB2")
		QRY_SB2->(dbGoTop())
		IF !QRY_SB2->(EOF())   .AND. QRY_SB2->SALDO >0
			nSaldo := QRY_SB2->SALDO
		EndIF

		cQuery  := " Select SUM(C6_QTDVEN- C6_QTDENT) As SALDO"
		cQuery  += " FROM "+RetSqlName("SC6")+" C6, "+ RetSqlName("SC5")+ " C5"
		cQuery  += " WHERE C5.D_E_L_E_T_	=	' '"
		cQuery  += "	AND	C6.D_E_L_E_T_	=	' '"
		cQuery  += "	AND C6.C6_FILIAL	=	C5.C5_FILIAL"
		cQuery  += "	AND C6.C6_NUM		=	C5.C5_NUM"
		cQuery  += "	AND C6_PRODUTO		=	'" + cProdut		+ "'"
		cQuery  += "	AND C6_FILIAL		=	'" + cFilSC6		+ "'"
		cQuery  += "	AND C6_NUM			<>	'" + SC5->C5_NUM	+ "'"
		cQuery  += "	AND C6_NOTA			=	'         '"
		cQuery  += "	AND C6_BLQ			<>	'R'"
		cQuery  += "	AND C6_QTDVEN - C6_QTDENT > 0 "

		if empty( dDtMin )
			dDtMin := ( dDataBase - 10000 )
		endif

		if empty( dDtMax )
			dDtMax := ( dDataBase + 10000 )
		endif

		cQuery  += " AND"
		cQuery  += "     ("
		cQuery  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDtMin ) + "' AND '" + dToS( dDtMax ) + "'"
		cQuery  += "         OR"
		cQuery  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDtMin ) + "' AND '" + dToS( dDtMax ) + "'"
		cQuery  += "     )"

		cQuery  += "  AND C5_ZTIPPED in ( Select ZJ_COD from "+RetSqlName("SZJ")+" SZJ Where SZJ.D_E_L_E_T_	=	' ' AND ZJ_TAURA<>'S' ) "

		If Select("QRY_SC6") > 0
			QRY_SC6->(dbCloseArea())
		EndIf
		cQuery  := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SC6",.T.,.F.)
		dbSelectArea("QRY_SC6")
		QRY_SC6->(dbGoTop())
		IF !QRY_SC6->(EOF())   .AND. QRY_SC6->SALDO >0
			nPedQtd   := QRY_SC6->SALDO
		EndIF
		IF nSaldo - nPedQtd - SC6->C6_QTDVEN < 0
			lRet := .F.
		EndIF
	EndIF

	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMGF16COT
Autor...............: Joni Lima
Data................: 06/12/2016
Descrição / Objetivo: Caso o tipo de venda marfrig seja igual ao parametro será realizado o Blqoueio
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Compara o tipo de venda marfrig com o informado no parametro.
=====================================================================================
*/
User Function xMGF16COT(cTp)

	Local lRet := cTp == SC5->C5_ZTIPPED

Return lRet

/*
=====================================================================================
Programa............: xMF16VLC
Autor...............: Joni Lima
Data................: 30/11/2016
Descrição / Objetivo: Retorna o Limite de Credito DISPONIVEL do cliente
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna Limite de credito disponivel.
=====================================================================================
*/
Static Function xMF16VLC(cCliente,cLoja)

	Local aArea 	:= GetArea()
	Local aAreaSA1	:= SA1->(GetArea())
	Local cNextAlias:= GetNextAlias()
	Local nRet		:= 0
	Local lRet		:= .F.

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	dbSelectArea('SA1')
	SA1->(dbSetOrder(1))//A1_FILIAL, A1_COD, A1_LOJA
	If SA1->(dbSeek(xFilial('SA1') + cCliente + cLoja))

		BeginSql Alias cNextAlias

			SELECT
				VSA1.LIMITE_DISPONIVEL
			FROM
				V_LIMITES_CLIENTE VSA1
			WHERE
				VSA1.RECNO_CLIENTE = %Exp:SA1->(Recno())%

		EndSql

		(cNextAlias)->(dbGoTop())
		//		conout('query JONI ' + GetLastQuery()[2])
		While (cNextAlias)->(!EOF())
			//nRet += ( (cNextAlias)->A1_LC - ( (cNextAlias)->A1_SALDUP + (cNextAlias)->A1_SALPEDL ) )
			nRet += (cNextAlias)->LIMITE_DISPONIVEL //Limite de Credito disponivel
			(cNextAlias)->(dbSkip())
		EndDo

		lRet := nRet >= 0

	EndIf

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	RestArea(aAreaSA1)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMF16N24H
Autor...............: Joni Lima
Data................: 24/11/2016
Descrição / Objetivo: Verifica se existe Nota emitida nos ultimos 24 Horas
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza a Verificação
=====================================================================================
*/
User Function xMF16N24H()

	Local aArea	:= GetArea()
	Local lRet := .F.
	Local dDtAnt := DaySub( Date(), 1 ) //Subtrai um dia da Data
	Local cDtAnt := DtoS(dDtAnt)
	Local cHrAnt := SUBSTR(TIME(),1,5)
	Local cNextAlias:= GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT
	F2_DOC,
	F2_SERIE
	FROM
	%Table:SF2% SF2
	WHERE
	SF2.F2_FILIAL = %xFilial:SF2% AND
	SF2.%NotDel% AND
	SF2.F2_CLIENTE = %Exp:SA1->A1_COD% AND
	SF2.F2_LOJA = %Exp:SA1->A1_LOJA% AND
	SF2.F2_TIPO = 'N' AND
	SF2.F2_DAUTNFE >= %Exp:cDtAnt% AND
	SF2.F2_HAUTNFE >=  %Exp:cHrAnt%

	EndSql

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		lRet := .T.
		If lRet
			Exit
		EndIf
		(cNextAlias)->(dbSkip())
	EndDo

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	RestArea(aArea)

Return lRet


/*
=====================================================================================
Programa............: xMF16TSPed
Autor...............: Joni Lima
Data................: 20/10/2016
Descrição / Objetivo: Função para Calcular o Total do Pedido Simplificado
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza o calculo do total do Pedido Simplificado
=====================================================================================
*/
Static Function xMF16TSPed(cPedido)

	Local aArea		:= GetArea()
	Local aAreaSC6	:= SC6->(GetArea())
	Local nRet		:= 0

	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

	If SC6->(dbSeek(FWxFilial('SC6') + cPedido))
		While SC6->(!EOF()) .and. SC6->(C6_FILIAL + C6_NUM) ==  FWxFilial('SC6') + cPedido
			nRet += SC6->C6_VALOR
			SC6->(dbSkip())
		EndDo
	EndIf

	RestArea(aArea)
	RestArea(aAreaSC6)

Return nRet

/*
=====================================================================================
Programa............: xMF16TotPd
Autor...............: Joni Lima
Data................: 20/10/2016
Descrição / Objetivo: Função para Calcular o Total do Pedido
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Realiza o calculo do total do Pedido
=====================================================================================
*/
User Function xMF16TotPd(cPedido)

	Local aArea 	:= GetArea()
	Local aAreaSC5 	:= SC5->(GetArea())
	Local aAreaSA1 	:= SA1->(GetArea())
	Local aAreaSC6 	:= SC6->(GetArea())
	Local aAreaSB1 	:= SB1->(GetArea())
	Local aAreaSF4 	:= SF4->(GetArea())

	Local nRet		:= 0
	Local nQtdSc6	:= xMF16QtdIt(cPedido)
	Local nValDes	:= 0
	Local nRecSB1	:= 0
	Local nRecSF4	:= 0

	dbSelectArea('SC5')
	SC5->(DbSetOrder(1))//C5_FILIAL+C5_NUM
	If SC5->(dbSeek(FWxFilial('SC5') + cPedido))

		//Cabeçalho
		MaFisIni(SC5->C5_CLIENT			 ,;//01 Codigo Cliente/Fornecedor
		SC5->C5_LOJACLI				 ,;//02 Loja do Cliente/Fornecedor
		If(SC5->C5_TIPO$'DB',"F","C"),;//03 C:Cliente , F:Fornecedor
		SC5->C5_TIPO				 ,;//04 Tipo da NF
		SC5->C5_TIPOCLI				 ,;//05 Tipo do Cliente/Fornecedor
		Nil							 ,;//06 Relacao de Impostos que suportados no arquivo
		Nil							 ,;//07 Tipo de complemento
		.F.							 ,;//08 Permite Incluir Impostos no Rodape .T./.F.
		"SB1"						 ,;//09 Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
		"MATA461"       			 ,;//10 Nome da rotina que esta utilizando a funcao
		Nil							 ,;//11 Tipo de documento
		Nil							 ,;//12 Espécie do documento
		Nil							 ,;//13 Código e Loja do Prospect
		Nil							 ,;//14 Grupo Cliente
		Nil							 ,;//15 Recolhe ISS
		Nil							 ,;//16 Código do cliente de entrega na nota fiscal de saída
		Nil							 ,;//17 Loja do cliente de entrega na nota fiscal de saída
		Nil							 ,;//18 Informações do transportador [01]-UF,[02]-TPTRANS
		Nil							 ,;//19 Se esta emitindo nota fiscal ou cupom fiscal (Sigaloja)
		Nil							 ,;//20 Define se calcula IPI (SIGALOJA)
		cPedido						 ,;//21 Pedido de Venda
		SC5->C5_CLIENT				 ,;//22 Cliente do Faturamento
		SC5->C5_LOJACLI	)			//23 Loja do Cliente do Faturamento

		dbSelectArea('SC6')
		SC6->(dbSelectArea(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO
		If SC6->(dbSeek(FWxFilial('SC6') + cPedido))
			While SC6->(!EOF()) .and. SC6->(C6_FILIAL + C6_NUM) == FWxFilial('SC6') + cPedido

				dbSelectArea('SB1')
				SB1->(dbSetOrder(1))//B1_FILIAL + B1_COD
				If SB1->(DbSeek(FWxFilial('SB1') + SC6->C6_PRODUTO))
					nRecSB1 := SB1->(RECNO())
				EndIf

				dbSelectArea('SF4')
				SF4->(dbSetOrder(1))//F4_FILIAL, F4_CODIGO
				If SF4->(DbSeek(FWxFilial('SF4') + SC6->C6_TES))
					nRecSF4 := SF4->(RECNO())
				EndIf

				nValDes	:= SC6->C6_VALDESC	+ (SC5->C5_DESCONT/nQtdSc6)

				MaFisAdd(	SC6->C6_PRODUTO			,;// 01-Codigo do Produto 					( Obrigatorio )
				SC6->C6_TES				,;// 02-Codigo do TES 						( Opcional )
				SC6->C6_QTDVEN			,;// 03-Quantidade 							( Obrigatorio )
				SC6->C6_PRCVEN			,;// 04-Preco Unitario 						( Obrigatorio )
				nValDes					,;// 05 desconto
				SC6->C6_NFORI			,;// 06-Numero da NF Original 				( Devolucao/Benef )
				SC6->C6_SERIORI			,;// 07-Serie da NF Original 				( Devolucao/Benef )
				nil						,;// 08-RecNo da NF Original no Arq SD1/SD2
				SC5->C5_FRETE/nQtdSc6	,;// 09-Valor do Frete do Item 				( Opcional )
				SC5->C5_DESPESA/nQtdSc6	,;// 10-Valor da Despesa do item	 		( Opcional )
				SC5->C5_SEGURO/nQtdSc6	,;// 11-Valor do Seguro do item 			( Opcional )
				SC5->C5_FRETAUT/nQtdSc6	,;// 12-Valor do Frete Autonomo 			( Opcional )
				SC6->C6_VALOR			,;// 13-Valor da Mercadoria 				( Obrigatorio )
				nil						,;// 14-Valor da Embalagem 					( Opcional )
				nRecSB1					,;// 15-RecNo do SB1
				nRecSF4					,;// 16-RecNo do SF4
				SC6->C6_ITEM			,;// 17-Numero do item – Exemplo '01'
				Nil						,;// 18-Despesas não tributadas (Portugal)
				Nil						,;// 19-Tara (Portugal)
				SC6->C6_CF				,;// 20-CFOP
				Nil						,;// 21-Array para o calculo do IVA Ajustado (opcional)
				Nil						,;// 22-Concepto
				Nil						,;// 23-Base Veiculo
				Nil						,;// 24-Lote Produto
				Nil						,;// 25-Sub-Lote Produto
				SC6->C6_ABATISS)		  // 26-Valor do Abatimento ISS

				SC6->(dbSkip())
			EndDo
		EndIf
		nRet := MaFisRet(,'NF_TOTAL')
		MaFisEnd()
	EndIf

	RestArea(aAreaSF4)
	RestArea(aAreaSB1)
	RestArea(aAreaSC6)
	RestArea(aAreaSA1)
	RestArea(aAreaSC5)
	RestArea(aArea)

Return nRet

/*
=====================================================================================
Programa............: xMF16QtdIt
Autor...............: Joni Lima
Data................: 20/10/2016
Descrição / Objetivo: Função para trazer a Quantidade de Itens do Pedido
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Pega a quantidade de itens do Pedido
=====================================================================================
*/
Static Function xMF16QtdIt(cPedido)

	Local aArea		:= GetArea()
	Local aAreaSC6	:= SC6->(GetArea())
	Local nRet		:= 0

	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

	If SC6->(dbSeek(FWxFilial('SC6') + cPedido))
		While SC6->(!EOF()) .and. SC6->(C6_FILIAL + C6_NUM) ==  FWxFilial('SC6') + cPedido
			nRet ++
			SC6->(dbSkip())
		EndDo
	EndIf

	RestArea(aArea)
	RestArea(aAreaSC6)

Return nRet

Static Function xMF16EBLQ(cPedido,cItem)

	Local lRet 			:= .T.
	Local cNextAlias	:= GetNextAlias()
	Local cCond			:= "%%"

	default cItem := ''

	If !Empty(cItem)
		cCond := "%" + "SZV.ZV_ITEMPED = '" + cItem + "' AND " + "%"
	EndIf

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias
		SELECT ZV_CODRGA
		FROM
		    %Table:SZV% SZV
		WHERE
		    SZV.D_E_L_E_T_ = ' ' AND
		    SZV.ZV_FILIAL = %xFilial:SZV% AND
		    SZV.ZV_PEDIDO =  %Exp:cPedido% AND
		    %Exp:cCond%
		    SZV.ZV_CODRGA IN ('000071','000072','000073')
	EndSql

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		lRet := .F.
		If !lRet
			Exit
		EndIf
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

Return lRet

/*
-----------------------------------
	cField  == F4_DUPLIC
	cField  == F4_ESTOQUE
-----------------------------------
*/
Static Function xConTES(cCod,cField)

	Local aArea		:= GetArea()
	Local aAreaSF4	:= SF4->(GetArea())
	Local lRet 		:= .T.
	Local cTempFld	:= ""

	dbSelectArea("SF4")
	SF4->(dbSetOrder(1))//F4_FILIAL+F4_CODIGO

	If SF4->(dbSeek(xFilial("SF4") + cCod ))
		cTempFld := "SF4->" + cField
		If &(cTempFld) <> "S"
			lRet := .F.
		EndIf
	EndIf

	RestArea(aAreaSF4)
	RestArea(aArea)

Return lRet

Static Function xVerTES()

	Local aArea		:= GetArea()
	Local aAreaSC6	:= SC6->(GetArea())
	Local lRet		:= .F.
	local cTpPedCC	:= allTrim( superGetMv( "MGFECOTPCC", , "CC" ) )

	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

	If SC6->(dbSeek(FWxFilial('SC6') + SC5->C5_NUM))
		While SC6->(!EOF()) .and. SC6->(C6_FILIAL + C6_NUM) ==  FWxFilial('SC6') + SC5->C5_NUM

			If SZT->ZT_TIPOREG == '2'//Financeiro
				if SC5->C5_ZTIPPED <> cTpPedCC // Pedidos com Cartao de Credito nao passam por regras do Financeiro no FAT14
					lRet := xConTES(SC6->C6_TES,"F4_DUPLIC")
				endif
			EndIf

			If SZT->ZT_TIPOREG == '3'//Estoque
				lRet := xConTES(SC6->C6_TES,"F4_ESTOQUE")
			EndIf

			//Comercial verifica a regra caso duplicada ou Estoque esteja como Sim.
/*
			If SZT->ZT_TIPOREG == '4'//Comercial
				lRet := xConTES(SC6->C6_TES,"F4_DUPLIC")
				If !lRet
					lRet := xConTES(SC6->C6_TES,"F4_ESTOQUE")
				EndIf
			EndIf
*/
			If lRet
				Exit
			EndIf
			SC6->(dbSkip())
		EndDo
	EndIf

	RestArea(aAreaSC6)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xVerReg
Autor...............: Joni Lima
Data................: 06/06/2018
Descrição / Objetivo: Função para verificar se é executada a Regra de bloqueio
Obs.................: informar o codigo do Tipo
=====================================================================================
*/
Static Function xVerReg(cCodTipo)

	Local aArea     := GetArea()
	Local aAreaSZJ  := SZJ->(GetArea())

	Local lConFis := .F.
	Local lConFin := .F.
	Local lConEst := .F.
	Local lConCom := .F.

	Local lRet	  := .F.

	dbSelectArea("SZJ")
	SZJ->(dbSetOrder(1))//ZJ_FILIAL+ZJ_COD
	If SZJ->(dbSeek(xFilial("SZJ") + cCodTipo))

		lConFis := SZJ->ZJ_FISFT14 == '1'
		lConFin := SZJ->ZJ_FINFT14 == '1'
		lConEst := SZJ->ZJ_ESTFT14 == '1'
		lConCom := SZJ->ZJ_COMFT14 == '1'

		If SZT->ZT_TIPOREG == '1'//Fiscal
			If lConFis
				lRet := .T.
			EndIf
		EndIf

		If SZT->ZT_TIPOREG == '2'//Financeiro
			If lConFin
				lRet := .T.
			EndIf
		EndIf

		If SZT->ZT_TIPOREG == '3'//Estoque
			If lConEst
				lRet := .T.
			EndIf
		EndIf

		If SZT->ZT_TIPOREG == '4'//Comercial
			If lConCom
				lRet := .T.
			EndIf
		EndIf

	Endif

	RestArea(aAreaSZJ)
	RestArea(aArea)

Return lRet

//---------------------------------------------------------------------
//
//---------------------------------------------------------------------
static Function xCrdXTitAt(cCliLoja,dData,nMoeda,lMovSE5)
	Local aArea     := { Alias() , IndexOrd() , Recno() }
	Local aAreaSE1  := { SE1->(IndexOrd()), SE1->(Recno()) }
	Local bCondSE1
	Local nSaldo    := 0
	Local nTamCli   := len(Criavar("A1_COD"))
	Local nTamLoja  := len(Criavar("A1_LOJA"))
	Local cCliente  := SubStr(cCliLoja,1,nTamCli)
	Local cLoja     := SubStr(cCliLoja,nTamCli+1,nTamLoja)
	Local nSaldoTit := 0

	// Quando eh chamada do Excel, estas variaveis estao em branco
	IF Empty(MVABATIM) .Or.;
		Empty(MV_CRNEG) .Or.;
		Empty(MVRECANT)
		CriaTipos()
	Endif

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Testa os parametros vindos do Excel                  ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMoeda      := If(Empty(nMoeda),1,nMoeda)
	dData       := If(Empty(dData),dDataBase,dData)
	If ( ValType(nMoeda) == "C" )
		nMoeda      := Val(nMoeda)
	EndIf
	dData       := DataWindow(dData)
	lMovSE5     := BoolWindow(lMovSe5)

	dbSelectArea("SE1")
	dbSetOrder(2)
	dbSeek(xFilial()+cCliente+cLoja)
	If ( !Empty(cLoja) )
		bCondSE1  := {|| !Eof() .And. xFilial() == SE1->E1_FILIAL .And.;
			cCliente == SE1->E1_CLIENTE .And.;
			cLoja    == SE1->E1_LOJA }
	Else
		bCondSE1  := {|| !Eof() .And. xFilial() == SE1->E1_FILIAL .And.;
			cCliente == SE1->E1_CLIENTE }
	EndIf
	While ( Eval(bCondSe1) )
		If ( SE1->E1_EMISSAO <= dData .And. ;
				!SE1->E1_TIPO $ MVPROVIS+"/"+MVABATIM .And.;
				((!Empty(SE1->E1_FATURA).And.;
				Substr(SE1->E1_FATURA,1,6)=="NOTFAT" ) .Or.;
				(!Empty(SE1->E1_FATURA) .And.;
				Substr(SE1->E1_FATURA,1,6)!="NOTFAT" .And.;
				SE1->E1_DTFATUR > dData ) .Or.;
				Empty(SE1->E1_FATURA)) )
			If (!SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG )
				If ( !lMovSE5 )
					If SE1->E1_SALDO > 0 .AND. SE1->E1_VENCREA < dDatabase
						nSaldo += xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,dData)
						nSaldo -= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,dData,SE1->E1_CLIENTE)
					Endif
				Else
					If SE1->E1_VENCREA < dDatabase
						nSaldoTit := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,nMoeda,,dData,SE1->E1_LOJA)
						If nSaldoTit > 0
							nSaldoTit -= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,dData,SE1->E1_CLIENTE)
						Endif
						nSaldo += nSaldoTit
					EndIf
				EndIf
			Else
				If SE1->E1_VENCREA < dDatabase
					If ( !lMovSE5  )
						nSaldo -= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,nMoeda,,dData,SE1->E1_LOJA)
					Else
						nSaldo -= xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,dData)
					EndIf
				EndIf
			EndIf
		EndIf
		dbSelectArea("SE1")
		dbSkip()
	EndDo

	dbSelectArea("SE1")
	dbSetOrder(aAreaSE1[1])
	dbGoto(aAreaSE1[2])
	dbSelectArea(aArea[1])
	dbSetOrder(aArea[2])
	dbGoto(aArea[3])
Return nSaldo

Static Function xTitAber(lGrdRed,cRedCGC)

	Local aArea := GetArea()
	Local nRet	:= 0
	Local cNextAlias	:= GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	If lGrdRed

		BeginSql Alias cNextAlias
			SELECT SUM(E1.E1_SALDO) SALDO
			FROM %Table:SE1% E1
			INNER JOIN %Table:SA1% A1
			     ON E1.E1_CLIENTE = A1.A1_COD
			    AND E1.E1_LOJA = A1.A1_LOJA
			WHERE
			    A1.%NotDel% AND
			    E1.%NotDel% AND
			    E1.E1_TIPO NOT IN ('RA','NCC','RJ') AND
			    E1.E1_SALDO > 0 AND
			    A1_ZREDE = %Exp:cRedCGC%
		EndSql
	Else
		BeginSql Alias cNextAlias
			SELECT SUM(E1.E1_SALDO) SALDO
			FROM %Table:SE1% E1
			INNER JOIN %Table:SA1% A1
			     ON E1.E1_CLIENTE = A1.A1_COD
			    AND E1.E1_LOJA = A1.A1_LOJA
			WHERE
			    A1.%NotDel% AND
			    E1.%NotDel% AND
			    E1.E1_TIPO NOT IN ('RA','NCC','RJ') AND
			    E1.E1_SALDO > 0 AND
			    SUBSTR(A1.A1_CGC,1,9) = %Exp:cRedCGC%
		EndSql
	EndIf

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		nRet += (cNextAlias)->SALDO
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aArea)

Return nRet

Static Function xTAbert(cCod,cLoja)

	Local aArea := GetArea()
	Local nRet	:= 0
	Local cNextAlias	:= GetNextAlias()
	Local cDataB		:= DtoS(dDataBase)

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT SUM(SE1.E1_SALDO) E1_SALDO
		FROM %Table:SE1% SE1
		WHERE
		        SE1.%NotDel%
		    AND SE1.E1_TIPO = 'NF'
		    AND SE1.E1_SALDO > 0
		    AND SE1.E1_VENCREA < %Exp:cDataB%
		    AND SUBSTR(SE1.E1_ZCNPJ,1,8) IN
                                (SELECT SUBSTR(SA1.A1_CGC,1,8)
                                    FROM %Table:SA1% SA1
                                    WHERE SA1.%NotDel%
                                          AND SA1.A1_COD = %Exp:cCod%
                                          AND SA1.A1_LOJA = %Exp:cLoja%)
	EndSql

	(cNextAlias)->(dbGoTop())

	While (cNextAlias)->(!EOF())
		nRet += (cNextAlias)->E1_SALDO
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aArea)

Return nRet


//Funções antigas mantidas para retrocompatibilidade com fontes que fazem callstatic:
// MGFFAT16, MGFFAT68, MGFLIBPD, MGFWSC27, MGFWSC33
//------------------------------------------------------
// Retorna saldo do Produto apos consulta com Taura - Pedido deve estar posicionado
// [1] = Saldo (Taura - Protheus)
// [2] = Peso Medio
//------------------------------------------------------
static function getSalProt( cB1Cod, cC5Num, cStockFil, lJobStock, dDtMin, dDtMax, _BlqEst )
	local cQueryProt	:= ""
	local nRetProt		:= 0
	local nRetProt2		:= 0
	local aArea			:= getArea()
	local aAreaSZJ		:= SZJ->(getArea())
	local aAreaSA1		:= SA1->(getArea())
	local aAreaSB1		:= SB1->(getArea())

	local aRet			:= {}
	local aRet2			:= {}
	local nSalProt		:= 0
	local nSalProt2		:= 0
	local nPesoMedio	:= 0
	local aRetStock		:= { 0 , 0 }

	local lRet			:= .F.
	local lFefo			:= .F.

	local nMGFDTMIN		:= 0
	local nMGFDTMAX		:= 0

	local dDataMin		:= CTOD("  /  /  ")
	local dDataMax		:= CTOD("  /  /  ")

	local nDtMin		:= superGetMv("MGF_DTMIN", , 0 )
	local nDtMax		:= superGetMv("MGF_DTMAX", , 0 )

	local nDtMinPr		:= superGetMv( "MGF_MINPR", , 0 )
	local nDtMaxPr		:= superGetMv( "MGF_MAXPR", , 0 )

	default lJobStock	:= .F.
	default cC5Num		:= space(06)
	default cStockFil	:= cFilAnt

	default dDtMin		:= CTOD("  /  /  ")
	default dDtMax		:= CTOD("  /  /  ")
	default _BlqEst		:= .F.

	if !empty( dDtMin )
		dDataMin := dDtMin
	endif

	if !empty( dDtMax )
		dDataMax := dDtMax
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		lFefo := .T.
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			// Para o tipo VE as datas nao importam na consulta ao Taura, mas na conta para debitar Pedidos do Protheus sim
			dDataMin := CTOD("  /  /  ")
			dDataMax := CTOD("  /  /  ")
		elseif QRYSB2->ZJ_FEFO == 'S'
			dDataMin := dDataBase + QRYSB2->ZJ_MINIMO
			dDataMax := dDataBase + QRYSB2->ZJ_MAXIMO
		endif
	endif

	if lJobStock
		if QRYSB2->ZJ_FEFO <> 'S'
			U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos

			U_MGFTAE21( @aRet, cStockFil, QRYSB2->idproduto, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( QRYSB2->idproduto, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			U_MGFTAE21( @aRet2, cStockFil, QRYSB2->idproduto, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( QRYSB2->idproduto, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	else
		DBSelectArea('SZJ')
		SZJ->(DBSetOrder(1))
		SZJ->(DBSeek(xFilial('SZJ') + SC5->C5_ZTIPPED))

		if SZJ->ZJ_FEFO <> 'S'
			if !empty( dDataMin ) .and. !empty( dDataMax )
				U_MGFTAE21( @aRet, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

				nRetProt := 0
				nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
				nSalProt := 0
				nSalProt := ( aRet[01] - nRetProt )

				// CASO TENHA PARAMETRIZADO DATA, DEVERA VERIFICAR COM VE SEM DATA
				aRet2 := {0}
				U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

				nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
				nSalProt2 := ( aRet2[01] - nRetProt2 )

				// SE - 'VE com Data' for maior que 'VE sem Data' - Considera SEM DATA
				//if nSalProt2 > nSalProt
				if nSalProt > nSalProt2
					aRet := {}
					aRet := aClone( aRet2 )

					dDataMin := CTOD("  /  /  ")
					dDataMax := CTOD("  /  /  ")
				endif

			else
				U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )
			endif
		else
			// Se NAO houver saldo no VE outros tipos recebem o saldo do VE (zerado ou negativo)
			// Se HOUVER saldo no VE consulta novamente o saldo nos outros tipos
			U_MGFTAE21( @aRet, cStockFil, cB1Cod, .F., dDataMin, dDataMax )

			nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, "", "", _BlqEst )
			nSalProt := ( aRet[01] - nRetProt )

			aRet2 := {0}
			U_MGFTAE21( @aRet2, cStockFil, cB1Cod, .T., dDataMin, dDataMax )

			nRetProt2 := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
			nSalProt2 := ( aRet2[01] - nRetProt2 )

			if nSalProt2 > nSalProt
				// Se FF ou PR forem maiores do que o VE, respeitara os valores do VE
				dDataMin := CTOD("  /  /  ")
				dDataMax := CTOD("  /  /  ")
			else
				aRet := {}
				aRet := aClone( aRet2 )
			endif
		endif
	endif

	if aRet[2] > 0
		nPesoMedio := ( aRet[1] / aRet[2] )
	endif

	nRetProt := 0
	nSalProt := 0
	Conout("Parametros enviado para a função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )
	nRetProt := getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )
	nSalProt := ( aRet[01] - nRetProt )
	qTaura   := aRet[01]
	restArea(aAreaSB1)
	restArea(aAreaSA1)
	restArea(aAreaSZJ)
	restArea(aArea)

	aRetStock := { nSalProt, nPesoMedio }
	Conout("[MGFWSC05] - Resuldado da funcao getSalProt: Saldo: "+ Alltrim(Transform(nSalProt,"@E 999,999,999.9999")) + " Peso Medio: "+ Alltrim(Transform(nPesoMedio,"@E 999,999,999.9999")) )
return aRetStock


//------------------------------------------------------------
// Retorna o saldo de Pedidos
//------------------------------------------------------------
static function getSaldoPv( cB1Cod, cStockFil, cC5Num, dDataMin, dDataMax, _BlqEst )

	local nSaldoPV		:= 0
	local cQueryProt	:= ""
	local cQryPv		:= getNextAlias()

	Conout("Parametros recebido na função getSaldoPv: "+cB1Cod +"," + cStockFil + "," + cC5Num )

	// a query abaixo para trazer o saldo que o Protheus tem de pedidos, por produto
	// desconsidera o pedido que está sendo manipulado no momento ou analisado
	// mas considera todos os pedidos que estão com bloqueio seja de estoque o não no sistema
	// gerando erro. Criado um parametro no final para informar se deve ou não descosiderar
	// pedidos com bloqueio de estoque.

	cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
	cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
	cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "

	cQueryProt  += " WHERE"
	cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
	cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
	cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
	cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
	cQueryProt  += "  	AND C6_NOTA			=	'         '"
	cQueryProt  += "  	AND C6_BLQ			<>	'R'"

	if !empty( cC5Num )
		cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
	endif

	if !empty( dDataMin ) .and. !empty( dDataMax )
		cQueryProt  += " AND"
		cQueryProt  += "     ("
		cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "         OR"
		cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
		cQueryProt  += "     )"
	endif

	Conout("[MGFWSC05] - Roda Query funcao getSaldoPv: "+ cQueryProt )
	tcQuery cQueryProt New Alias (cQryPv)

	if !(cQryPv)->(EOF())
		nSaldoPV := (cQryPv)->SALDO
	endif

	If Select(cQryPv) > 0
		(cQryPv)->(DBCloseArea())
	EndIf
	Conout("[MGFWSC05] - Resuldado da Query funcao getSaldoPv saldo pvs: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )

	// agora processo o saldo de pedidos que estão com bloqueio de estoque
	// e desconto essa quantidade na quantidade de pedido que a query anterior trouxe pois havia contemplado
	// erroneamente todos os pedidos mesmos os que estão com bloqueio de estoque

	if _BlqEst
		cQueryProt  := "SELECT SUM(C6_QTDVEN) - SUM(C6_QTDENT) AS SALDO"
		cQueryProt  += " FROM " +	RetSqlName("SC6") + " C6 "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SA1") + " A1 ON C6.C6_CLI		=	A1.A1_COD AND C6.C6_LOJA		=	A1.A1_LOJA AND A1.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SF4") + " F4 ON C6_TES			=	F4_CODIGO AND F4.D_E_L_E_T_	<>	'*' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SC5") + " C5 ON C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ = ' ' "
		cQueryProt +=  " INNER JOIN " + RetSqlName("SZV") + " SZV ON SZV.ZV_FILIAL = C5.C5_FILIAL AND SZV.ZV_PEDIDO = C5.C5_NUM AND SZV.D_E_L_E_T_ = ' ' AND SZV.ZV_CODRGA IN ('000011') AND SZV.ZV_ITEMPED = C6.C6_ITEM "
		cQueryProt  += " WHERE"
		cQueryProt  += "	    C6.D_E_L_E_T_	<>	'*'"
		cQueryProt	+= "	AND F4.F4_ESTOQUE	=	'S'"
		cQueryProt  += "	AND C6_PRODUTO		=	'" + cB1Cod		+ "'"
		cQueryProt  += "	AND C6_FILIAL		=	'" + cStockFil	+ "'"
		cQueryProt  += "  	AND C6_NOTA			=	'         '"
		cQueryProt  += "  	AND C6_BLQ			<>	'R'"
		cQueryProt  += "  	AND C5.C5_ZBLQRGA = 'B' "
		cQueryProt  += "  	AND SZV.ZV_CODAPR = ' ' "
		if !empty( cC5Num )
			cQueryProt  += "  AND C6_NUM <> '" + cC5Num + "'"
		endif

		if !empty( dDataMin ) .and. !empty( dDataMax )
			cQueryProt  += " AND"
			cQueryProt  += "     ("
			cQueryProt  += "         C6.C6_ZDTMIN BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "         OR"
			cQueryProt  += "         C6.C6_ZDTMAX BETWEEN '" + dToS( dDataMin ) + "' AND '" + dToS( dDataMax ) + "'"
			cQueryProt  += "     )"
		endif

		Conout("[MGFWSC05] - Roda Query funcao getSaldoPv: "+ cQueryProt )
		tcQuery cQueryProt New Alias (cQryPv)

		if !(cQryPv)->(EOF())
			nSaldoPV := nSaldoPV - (cQryPv)->SALDO
		endif

		If Select(cQryPv) > 0
			(cQryPv)->(DBCloseArea())
		EndIf
		Conout("[MGFWSC05] - Resuldado da Query funcao getSaldoPv - saldos bloqueados: "+ Transform(nSaldoPV,"@E 999,999,999.9999") )
	ENDIF

return nSaldoPV
