#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: MGFCTB08
Autor...............: Joni Lima
Data................: 17/10/2017
Descrição / Objetivo: Função para carregar Rateio para Solicitação de compras
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Carrega os rateios para solicitação de compra
=====================================================================================
*/
User Function MGFCTB08()

	Local aLinhas  := {}
	Local nPos
	Local nPosVal  := 0
	Local nPerc	   := 0
	Local lCont    := .T.
	Local cSCChv   := SC1->C1_FILIAL + SC1->C1_NUM 
	Local cFld	   := ''
	Local cTempFld := ''

	If SC1->C1_RESIDUO <> "S" .and. Empty(SC1->C1_COTACAO) .and. C1_QUJE == 0
		If xValRat()
			aLinhas  := U_MGFCTB07()
			If !Empty(aLinhas) .and. xValFiOr(aLinhas)
				nPosVal := aScan(aLinhas[1] , "VALOR" 	)
				If nPosVal > 0
					xGerPerc(@aLinhas)//Adiciona Coluna do Percentual
					If lCont
						If MsgYesNo("Deseja Aplicar o Rateio para todos os Itens?")
							DbSelectArea("SC1")
							SC1->(dbSetOrder(1))//C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD
							If SC1->(dbSeek(cSCChv))
								While SC1->(!EOF()) .and. cSCChv == SC1->(C1_FILIAL+C1_NUM) 
									If SC1->C1_RATEIO <> "1"
										For ni := 2 to Len(aLinhas)
											RecLock('SCX',.T.)
											SCX->CX_FILIAL	:= SC1->C1_FILIAL
											SCX->CX_SOLICIT	:= SC1->C1_NUM
											For nx := 1 to Len(aLinhas[1])
												If !Empty(aLinhas[ni][nx]) 
													cTempFld := xEncCPO(aLinhas[1][nx])
													If !Empty(cTempFld)
														cFld := "SCX->" + cTempFld
														&(cFld) := xTransVal(cTempFld,aLinhas[ni][nx])
													EndIf
												EndIf
											Next nx
											SCX->CX_ITEMSOL := SC1->C1_ITEM
											SCX->CX_ITEM	:= STRZERO(ni-1,3)
											SCX->(MsUnlock())
										Next ni
										RecLock('SC1',.F.)
										SC1->C1_RATEIO := "1"
										SC1->(MsUnlock())
									EndIf
									SC1->(dbSkip())
								EndDo
							Endif						
						Else
							For ni := 2 to Len(aLinhas)
								RecLock('SCX',.T.)
								SCX->CX_FILIAL	:= SC1->C1_FILIAL
								SCX->CX_SOLICIT	:= SC1->C1_NUM
								For nx := 1 to Len(aLinhas[1])
									If !Empty(aLinhas[ni][nx])
										cTempFld := xEncCPO(aLinhas[1][nx])
										If !(Empty(cTempFld)) .and. !(Empty(aLinhas[ni][nx]))
											cFld := "SCX->" + cTempFld
											&(cFld) := xTransVal(cTempFld,aLinhas[ni][nx])
										EndIf
									EndIf
								Next nx
								SCX->CX_ITEMSOL := SC1->C1_ITEM
								SCX->CX_ITEM	:= STRZERO(ni-1,2)
								SCX->(MsUnlock())
							Next ni
							RecLock('SC1',.F.)
							SC1->C1_RATEIO := "1"
							SC1->(MsUnlock())
						EndIf				
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		MsgInfo('Só é possivel incluir Rateio em SCs, que estão em aberto ou em processo de aprovação.')
	EndIf

Return 

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
Programa............: xEncCPO
Autor...............: Joni Lima
Data................: 18/10/2017
Descrição / Objetivo: Transforma o Valor.
=====================================================================================
*/
Static Function xEncCPO(cEnc)

	Local cRet		:= ' '
	Local aDePar   	:= {{'FILIAL DESTINO','CX_ZFILDES'},{'CONTA CONTABIL','CX_CONTA'},{'CENTRO DE CUSTO','CX_CC'},{'ITEM CONTABIL','CX_ITEMCTA'},{'CLASSE DE VALOR','CX_CLVL'},{'PERCENTUAL','CX_PERC'}}		
	Local nPosFld	:= aScan( aDePar, { |x| AllTrim( x[1] ) == cEnc } )

	If nPosFld > 0
		cRet := aDePar[nPosFld][2]
	EndIf

return cRet

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
	Local xRet 		:= cValue
	Local cTipo 	:= "C"

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
Programa............: xValRat
Autor...............: Joni Lima
Data................: 30/10/2017
Descrição / Objetivo: Realiza a Validação da existencia de Rateio e elimina caso necessario.
=====================================================================================
*/
Static Function xValRat()
	
	Local aArea    := GetArea()
	Local aAreaSC1 := SC1->(GetArea())
	Local aAreaSCX := SCX->(GetArea())
	
	Local lRet := .T.
	Local lApg := .F.
	Local cSCChv   := SC1->C1_FILIAL + SC1->C1_NUM

	dbSelectArea("SC1")
	SC1->(dbSetOrder(1))//C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD
	
	If SC1->(DbSeek(cSCChv))
		While SC1->(!EOF()) .and. cSCChv == SC1->(C1_FILIAL + C1_NUM)
			If SC1->C1_RATEIO == "1"
				If MsgYesNo("Existe Rateio para esse Documento, Deseja excluir o(s) Mesmo(s)?")
					lApg := .T.
					Exit
				Else
					lRet := .F.
				EndIf
			EndIf
			SC1->(dbSkip())
		EndDo
	EndIf
	
	If lApg
		If SC1->(DbSeek(cSCChv))
			While SC1->(!EOF()) .and. cSCChv == SC1->(C1_FILIAL + C1_NUM)	
				
				dbSelectArea("SCX")
				SCX->(dbSetOrder(1))//CX_FILIAL+CX_SOLICIT+CX_ITEMSOL+CX_ITEM
				If SCX->(dbSeek(SC1->(C1_FILIAL + C1_NUM + C1_ITEM )))
					While SCX->(!EOF()) .and. SC1->(C1_FILIAL + C1_NUM + C1_ITEM) == SCX->(CX_FILIAL + CX_SOLICIT + CX_ITEMSOL)
						RecLock('SCX',.F.)
							SCX->(dbDelete())
						SCX->(MsUnlock())
						SCX->(dbSkip())
					EndDo
				EndIf
				
				RecLock('SC1',.F.)
					SC1->C1_RATEIO := "2"
				SC1->(MsUnlock())				
				
				SC1->(dbSkip())	
			EndDo
		EndIf
	EndIf
	
	RestArea(aAreaSCX)
	RestArea(aAreaSC1)
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
	
	If aLinhas[2,nPosOri] <> SC1->C1_FILIAL
		lRet := .F.
		MsgInfo('Filial de Origem do Arquivo: ' + AllTrim(aLinhas[2][nPosOri]) + ", Esta diferente da Filial de Origem da Solicitação " + SC1->C1_FILIAL )
	EndIf
	
Return lRet