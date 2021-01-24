#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: MGFCTB09
Autor...............: Joni Lima
Data................: 18/10/2017
Descrição / Objetivo: Função para carregar Rateio para Pedido de compras
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Carrega os rateios para pedido de compras
=====================================================================================
*/
User Function MGFCTB09()

	Local aLinhas  := {}
	Local nPos
	Local nPosVal  := 0
	Local nPerc	   := 0
	Local nPosPerc := 0
	Local lCont    := .T.
	Local cPCChv   := SC7->C7_FILIAL + SC7->C7_NUM
	Local cFld	   := ''
	Local cTempFld := ''

	If SC7->C7_RESIDUO <> "S" .and. C7_QUJE == 0
		If xValRat()
			aLinhas  := U_MGFCTB07()
			If !Empty(aLinhas) .and. xValFiOr(aLinhas)
				nPosVal := aScan(aLinhas[1] , "VALOR")
				If nPosVal > 0
					xGerPerc(@aLinhas)//Adiciona Coluna do Percentual
					If lCont
						If MsgYesNo("Deseja Aplicar o Rateio para todos os Itens?")
							If xVldVal(aLinhas,SC7->C7_TOTAL,"T")
								DbSelectArea("SC7")
								SC7->(dbSetOrder(1))//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
								If SC7->(dbSeek(cPCChv))
									While SC7->(!EOF()) .and. cPCChv == SC7->(C7_FILIAL+C7_NUM)
										If SC7->C7_RATEIO <> "1"
											For ni := 2 to Len(aLinhas)
												RecLock('SCH',.T.)
												SCH->CH_FILIAL	:= SC7->C7_FILIAL
												SCH->CH_PEDIDO	:= SC7->C7_NUM
												For nx := 1 to Len(aLinhas[1])
													If !Empty(aLinhas[ni][nx])
														cTempFld := xEncCPO(aLinhas[1][nx])
														If !Empty(cTempFld) .and. cTempFld <> "CH_CUSTO1"
															cFld := "SCH->" + cTempFld
															&(cFld) := xTransVal(cTempFld,aLinhas[ni][nx])
														ElseIf cTempFld == "CH_CUSTO1"
															nPosPerc := aScan(aLinhas[1] , "PERCENTUAL" )
															SCH->CH_CUSTO1  := Round((aLinhas[ni][nPosPerc] / 100) * SC7->C7_TOTAL,2)
															SCH->CH_ZVALRAT := SCH->CH_CUSTO1
														EndIf
													EndIf
												Next nx
												SCH->CH_FORNECE	:= SC7->C7_FORNECE
												SCH->CH_LOJA	:= SC7->C7_LOJA
												SCH->CH_ITEMPD 	:= SC7->C7_ITEM
												SCH->CH_ITEM	:= STRZERO(ni-1,3)
												SCH->(MsUnlock())
											Next ni
											RecLock('SC7',.F.)
											SC7->C7_RATEIO := "1"
											SC7->(MsUnlock())
										EndIf
										SC7->(dbSkip())
									EndDo
								EndIf
							Endif
						Else
							If xVldVal(aLinhas,SC7->C7_TOTAL,"I")
								For ni := 2 to Len(aLinhas)
									RecLock('SCH',.T.)
									SCH->CH_FILIAL	:= SC7->C7_FILIAL
									SCH->CH_PEDIDO	:= SC7->C7_NUM
									For nx := 1 to Len(aLinhas[1])
										If !Empty(aLinhas[ni][nx])
											cTempFld := xEncCPO(aLinhas[1][nx])
											If !(Empty(cTempFld)) .and. !(Empty(aLinhas[ni][nx]))
												cFld := "SCH->" + cTempFld
												&(cFld) := xTransVal(cTempFld,aLinhas[ni][nx])
											EndIf
										EndIf
									Next nx
									SCH->CH_FORNECE	:= SC7->C7_FORNECE
									SCH->CH_LOJA	:= SC7->C7_LOJA
									SCH->CH_ITEMPD 	:= SC7->C7_ITEM
									SCH->CH_ITEM	:= STRZERO(ni-1,2)
									SCH->(MsUnlock())
								Next ni
								RecLock('SC7',.F.)
								SC7->C7_RATEIO := "1"
								SC7->(MsUnlock())
							EndIf
						EndIf				
					EndIf
				EndIf
			EndIf	
		EndIf
	Else
		MsgInfo('Só é possivel incluir Rateio em PCs, que estão em aberto ou em processo de aprovação.')
	EndIf
return

/*
=====================================================================================
Programa............: xEncCPO
Autor...............: Joni Lima
Data................: 18/10/2017
Descrição / Objetivo: Transforma o Valor.
=====================================================================================
*/
Static Function xEncCPO(cEnc)

	Local cRet		:= ' '
	Local aDePar   	:= {{'FILIAL DESTINO','CH_ZFILDES'},{'CONTA CONTABIL','CH_CONTA'},{'CENTRO DE CUSTO','CH_CC'},{'ITEM CONTABIL','CH_ITEMCTA'},{'CLASSE DE VALOR','CH_CLVL'},{'VALOR','CH_CUSTO1'},{'PERCENTUAL','CH_PERC'}}		
	Local nPosFld	:= aScan( aDePar, { |x| AllTrim( x[1] ) == cEnc } )

	If nPosFld > 0
		cRet := aDePar[nPosFld][2]
	EndIf

return cRet

/*
=====================================================================================
Programa............: xGerPerc
Autor...............: Joni Lima
Data................: 18/10/2017
Descrição / Objetivo: Adiciona o Percentual no Array das Linhas
=====================================================================================
*/
Static Function xGerPerc(aLinhas)

	Local nTotal   := 0
	Local ni	   := 0
	Local nPosVal  := aScan(aLinhas[1] , "VALOR" ) 
	Local nPosPerc := 0
	local nTotPerc := 0
	Local nDif100  := 0

	AADD(aLinhas[1],"PERCENTUAL") //Adiciona no Cabeçalho o Campo Percentual
	nPosPerc := aScan(aLinhas[1] , "PERCENTUAL" )

	For ni:=2 to Len(aLinhas)
		nTotal += val(aLinhas[ni][nPosVal])
	Next ni

	//Adiciona em cada linha o valor de percentual que sera gravado no Rateio
	For ni:=2 to Len(aLinhas)
		AADD(aLinhas[ni],(val(aLinhas[ni][nPosVal]) / nTotal) * 100)
	Next ni

	//Verifica total do Percentual
	For ni:=2 to Len(aLinhas)
		nTotPerc += aLinhas[ni][nPosPerc]
	Next ni	

	//Ajuste de Percentual caso esteja diferente de 100
	If nTotPerc <> 100
		If nTotPerc > 100//Ajuste  para percentual quando estiver acima de 100%
			nDif100 := nTotPerc - 100 
			aLinhas[Len(aLinhas)][nPosPerc] := aLinhas[Len(aLinhas)][nPosPerc] - nDif100
		ElseIf nTotPerc < 100//Ajuste  para percentual quando estiver abaixo de 100% 
			nDif100 := 100 - nTotPerc
			aLinhas[Len(aLinhas)][nPosPerc] := aLinhas[Len(aLinhas)][nPosPerc] + nDif100
		EndIf
	EndIf

return

/*
=====================================================================================
Programa............: xTransVal
Autor...............: Joni Lima
Data................: 17/10/2017
Descrição / Objetivo: Transforma o Valor.
=====================================================================================
*/
Static Function xTransVal(cField,cValue)

	Local aArea 	:= GetArea()
	Local aAreaSX3	:= SX3->(GetArea())
	Local xRet := cValue
	Local cTipo := "C"

	dbSelectArea('SX3')
	SX3->(dbSetorder(2))//X3_CAMPO

	If SX3->(dbSeek(cField))

		cTipo := SX3->X3_TIPO

		If ValType(cValue) <> cTipo
			If cTipo == "N"
				xRet := Val(cValue)
			EndIf
		EndIf

	EndIf

	RestArea(aAreaSX3)
	RestArea(aArea)

Return xRet

/*
=====================================================================================
Programa............: xVldVal
Autor...............: Joni Lima
Data................: 19/10/2017
Descrição / Objetivo: Realiza validação dos valores
=====================================================================================
*/
Static Function xVldVal(aLinhas,nTotal,cTipo)

	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(getArea())

	Local lRet 		:= .T.
	Local nTotLin   := 0
	Local ni		:= 2

	Local nTotPed	:= 0
	Local nPosVal  := aScan(aLinhas[1] , "VALOR" ) 

	Local cChvSC7	:= SC7->(C7_FILIAL + C7_NUM)

	Default nTotal := 0 

	If cTipo == "I"
		For ni:=2 to Len(aLinhas)
			nTotLin += val(aLinhas[ni][nPosVal])
		Next ni

		If nTotal <> nTotLin
			lRet := .F.
			MsgInfo('A Soma dos valores não esta dando o mesmo valor do Item')
		EndIf
	Else
		dbSelectArea("SC7")
		SC7->(dbSetOrder(1))//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN                                                                                                                              

		If SC7->(dbSeek(cChvSC7))
			While SC7->(!EOF()) .and. cChvSC7 == SC7->(C7_FILIAL + C7_NUM)
				nTotPed += SC7->C7_TOTAL
				SC7->(dbSkip())
			EndDo

			For ni:=2 to Len(aLinhas)
				nTotLin += val(aLinhas[ni][nPosVal])
			Next ni

			If nTotPed <> nTotLin
				lRet := .F.
				MsgInfo('A Soma dos valores não esta dando o mesmo valor do Pedido')
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xValRat
Autor...............: Joni Lima
Data................: 30/10/2017
Descrição / Objetivo: Realiza a Validação da existencia de Rateio e elimina caso necessario.
=====================================================================================
*/
Static Function xValRat()
	
	Local aArea    := GetArea()
	Local aAreaSC7 := SC7->(GetArea())
	Local aAreaSCH := SCH->(GetArea())
	
	Local lRet := .T.
	Local lApg := .F.
	Local cPCChv   := SC7->C7_FILIAL + SC7->C7_NUM

	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
	
	If SC7->(DbSeek(cPCChv))
		While SC7->(!EOF()) .and. cPCChv == SC7->C7_FILIAL + SC7->C7_NUM
			If SC7->C7_RATEIO == "1"
				If MsgYesNo("Existe Rateio para esse Documento, Deseja excluir o(s) Mesmo(s)?")
					lApg := .T.
					Exit
				Else
					lRet := .F.
				EndIf
			EndIf
			SC7->(dbSkip())
		EndDo
	EndIf
	
	If lApg
		If SC7->(DbSeek(cPCChv))
			While SC7->(!EOF()) .and. cPCChv == SC7->C7_FILIAL + SC7->C7_NUM
				
				dbSelectArea("SCH")
				SCH->(dbSetOrder(2))//CH_FILIAL+CH_PEDIDO+CH_ITEMPD+CH_ITEM
				If SCH->(dbSeek(SC7->(C7_FILIAL + C7_NUM + C7_ITEM )))
					While SCH->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM + C7_ITEM) == SCH->(CH_FILIAL + CH_PEDIDO + CH_ITEMPD)
						RecLock('SCH',.F.)
							SCH->(dbDelete())
						SCH->(MsUnlock())
						SCH->(dbSkip())
					EndDo
				EndIf
				
				RecLock('SC7',.F.)
					SC7->C7_RATEIO := "2"
				SC7->(MsUnlock())				
				
				SC7->(dbSkip())	
			EndDo
		EndIf
	EndIf
	
	RestArea(aAreaSCH)
	RestArea(aAreaSC7)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xValFiOr
Autor...............: Joni Lima
Data................: 30/10/2017
Descrição / Objetivo: Realiza a Validação da filial de origem com a filial de Destino
=====================================================================================
*/
Static Function xValFiOr(aLinhas)
	
	Local nPosOri := aScan(aLinhas[1] , "FILIAL ORIGEM" )
	Local lRet := .T.
	
	If aLinhas[2,nPosOri] <> SC7->C7_FILIAL
		lRet := .F.
		MsgInfo('Filial de Origem do Arquivo: ' + AllTrim(aLinhas[2][nPosOri]) + ", Esta diferente da Filial de Origem do Pedido de Compra " + SC7->C7_FILIAL )
	EndIf
	
Return lRet