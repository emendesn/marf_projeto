#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: MGFCTB11
Autor...............: Joni Lima
Data................: 30/10/2017
Descrição / Objetivo: Função para carregar Rateio para Contratos
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Carrega os rateios para Contratos
=====================================================================================
*/
User Function MGFCTB11()

	Local cEsc := " "
	Local cIten	:= " "
	Local aLinhas  := {}	
	Local nPosVal  := 0
	Local nPosPerc := 0
	Local aFornec  := {}
	Local aItens   := {}

	Local cChvCNB	:= ""
	
	If CN9->CN9_ESPCTR == "1"
		If CN9->CN9_SITUAC == "02"
			cEsc := xMGFCPlan(CN9->CN9_NUMERO,CN9->CN9_REVISA)
	
			If !Empty(cEsc)
				If xValRat(cEsc)
					aLinhas := U_MGFCTB07()
					If !Empty(aLinhas) .and. xValFiOr(aLinhas)
						cIten := xMGFIten(CN9->CN9_NUMERO,CN9->CN9_REVISA,alltrim(cEsc))
						nPosVal := aScan(aLinhas[1] , "VALOR")
						For ni := 1 To Len(cIten) STEP 4
							AADD(aItens,SubStr(cIten,ni,4))
						Next ni
	
						cChvCNB := CN9->CN9_FILIAL + CN9->CN9_NUMERO + CN9->CN9_REVISA + AllTrim(cEsc)
	
						If nPosVal > 0
	
							xGerPerc(@aLinhas)//Adiciona Coluna do Percentual
							If xVldVal(aLinhas,aItens,AllTrim(cEsc))
	
								dbSelectArea("CNB")
								CNB->(dbSetOrder(1))//CNZ_FILIAL+CNZ_CONTRA+CNZ_REVISA+CNZ_CODPLA+CNZ_ITCONT+CNZ_ITEM
	
								If CNB->(DbSeek(cChvCNB))
									While CNB->(!Eof()) .and. cChvCNB == CNB->(CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO)
										nPosIt := aScan( aItens , CNB->CNB_ITEM )
										If nPosIt <> 0
											For ni := 2 to Len(aLinhas)
	
												aFornec := xEncFor(CNB->CNB_CONTRA,CNB->CNB_NUMERO,CNB_REVISA)
	
												RecLock('CNZ',.T.)
	
												CNZ_FILIAL := xFilial("CNZ")
												CNZ_CONTRA := CN9->CN9_NUMERO
												CNZ_CODPLA := CNB->CNB_NUMERO
												CNZ_REVISA := CNB->CNB_REVISA 
												CNZ_FORNEC := aFornec[1]
												CNZ_LJFORN := aFornec[2]
												CNZ_ITCONT := CNB->CNB_ITEM
												CNZ_ITEM   := STRZERO(ni-1,3)
	
												For nx := 1 to Len(aLinhas[1])
													If !Empty(aLinhas[ni][nx])
														cTempFld := xEncCPO(aLinhas[1][nx])
														If !(Empty(cTempFld)) .and. !(Empty(aLinhas[ni][nx])) .and. cTempFld <> 'CNZ_VALOR1'
															cFld := "CNZ->" + cTempFld
															&(cFld) := xTransVal(cTempFld,aLinhas[ni][nx])
														ElseIf cTempFld == 'CNZ_VALOR1'
															nPosPerc := aScan(aLinhas[1] , "PERCENTUAL" )
															CNZ->CNZ_VALOR1  := Round((aLinhas[ni][nPosPerc] / 100) * CNB->CNB_VLTOT,2)
														EndIf
													EndIf
												Next nx
												CNZ->(MsUnlock())
												RecLock('CNB',.F.)
												CNB->CNB_RATEIO := "1"
												CNB->(MsUnlock())
											Next ni
										EndIf	
										CNB->(dbSkip())
									EndDo
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf	
			EndIf
		Else
			MsgInfo('Só é possivel incluir rateio em contratos que estão com Status de elaboração')
		EndIf
	Else
		MsgInfo('Só é possivel incluir rateio para contratos de Compras')
	EndIf
Return

/*
=====================================================================================
Programa............: xEncFor
Autor...............: Joni Lima
Data................: 30/10/2017
Descrição / Objetivo: Encontra Fornecedor
=====================================================================================
*/
Static Function xEncFor(cContra,cNumero,cRev)

	Local aRet := {}
	Local cNextAlias:= GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT 
	CNA_FORNEC,
	CNA_LJFORN
	FROM %Table:CNA% CNA
	WHERE
	CNA.%NotDel% AND
	CNA.CNA_FILIAL = %xFilial:CNA% AND
	CNA.CNA_CONTRA = %Exp:cContra% AND
	CNA.CNA_NUMERO = %Exp:cNumero% AND
	CNA.CNA_REVISA = %Exp:cRev%

	EndSql

	(cNextAlias)->(DbGoTop())	

	While (cNextAlias)->(!EOF())

		AADD(aRet, (cNextAlias)->CNA_FORNEC)
		AADD(aRet, (cNextAlias)->CNA_LJFORN)

		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

return aRet

/*
=====================================================================================
Programa............: xMGFCPlan
Autor...............: Joni Lima
Data................: 26/10/2017
Descrição / Objetivo: Consulta das planilhas
=====================================================================================
*/
Static function xMGFCPlan(cContra,cRevis)

	local aArea		:= GetArea()

	local aLstVias	:= {}
	local cOpcoes	:= ""
	local cTitulo	:= "Seleção da Planilha onde sera escolhido os itens para o Rateio"
	local MvPar		:= ""//&(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao
	//local mvRet		:= "MV_PAR01"		// Iguala Nome da Variavel ao Nome variavel de Retorno

	Local cNextAlias:= GetNextAlias()

	//Verifica a Existencia de __READVAR para ReadVar()
	IF ( !(Type("__READVAR" ) == "C") .or. Empty(__READVAR) )
		Private M->_XPLARAT := Space(900) 
		Private __READVAR     := "M->_XPLARAT"
	EndIF

	MvPar		:= &(Alltrim(ReadVar()))

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT *
	FROM %Table:CNA% CNA
	WHERE
	CNA.%NotDel% AND
	CNA.CNA_FILIAL = %xFilial:CNA% AND
	CNA.CNA_CONTRA = %Exp:cContra% AND
	CNA.CNA_REVISA = %Exp:cRevis%

	ORDER BY CNA_NUMERO

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		AADD(aLstVias, ALLTRIM((cNextAlias)->CNA_NUMERO) + " - Fornecedor: " + (cNextAlias)->CNA_FORNEC + " - " + (cNextAlias)->CNA_LJFORN )
		cOpcoes += (cNextAlias)->CNA_NUMERO
		(cNextAlias)->(dbSkip())	
	EndDo

	If f_Opcoes(    @MvPar		,;    	//Variavel de Retorno
	cTitulo		,;    				//Titulo da Coluna com as opcoes
	@aLstVias	,;    				//Opcoes de Escolha (Array de Opcoes)
	@cOpcoes	,;    				//String de Opcoes para Retorno
	NIL			,;    				//Nao Utilizado
	NIL			,;    				//Nao Utilizado
	.T.			,;    				//Se a Selecao sera de apenas 1 Elemento por vez
	TamSx3("CNA_NUMERO")[1],; 		//TamSx3("A6_COD")[1],;
	900;							//No maximo de elementos na variavel de retorno
	)

	EndIf

	RestArea(aArea)

Return mvpar

/*
=====================================================================================
Programa............: xMGFCPlan
Autor...............: Joni Lima
Data................: 26/10/2017
Descrição / Objetivo: Consulta das planilhas
=====================================================================================
*/
Static function xMGFIten(cContra,cRevis,cNumer)

	local aArea		:= GetArea()

	local aLstVias	:= {}
	local cOpcoes	:= ""
	local cTitulo	:= "Seleção da Planilha onde sera escolhido os itens para o Rateio"
	local MvPar		:= ""//&(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao
	//local mvRet		:= "MV_PAR01"		// Iguala Nome da Variavel ao Nome variavel de Retorno

	Local cNextAlias:= GetNextAlias()

	//Verifica a Existencia de __READVAR para ReadVar()
	IF ( !(Type("__READVAR" ) == "C") .or. Empty(__READVAR) )
		Private M->_XITERAT := Space(900) 
		Private __READVAR     := "M->_XITERAT"
	EndIF

	MvPar		:= &(Alltrim(ReadVar()))

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT *
	FROM %Table:CNB% CNB
	WHERE
	CNB.%NotDel% AND
	CNB.CNB_FILIAL = %xFilial:CNB% AND 
	CNB.CNB_CONTRA = %Exp:cContra% AND
	CNB.CNB_REVISA = %Exp:cRevis% AND
	CNB.CNB_NUMERO = %Exp:cNumer%
	ORDER BY CNB_ITEM

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		AADD(aLstVias, ALLTRIM((cNextAlias)->CNB_ITEM) + " - Prod.:	" + (cNextAlias)->CNB_PRODUT + ", Descri.: " + (cNextAlias)->CNB_DESCRI + ", Qtd: " + TRANSFORM((cNextAlias)->CNB_QUANT, PesqPict( "CNB", "CNB_QUANT" )) + ", Val. Unit: " + TRANSFORM((cNextAlias)->CNB_QUANT, PesqPict( "CNB", "CNB_VLUNIT" )) + ", Total: " + TRANSFORM((cNextAlias)->CNB_QUANT, PesqPict( "CNB", "CNB_VLTOT" )) )
		cOpcoes += (cNextAlias)->CNB_ITEM
		(cNextAlias)->(dbSkip())	
	EndDo

	If f_Opcoes(    @MvPar		,;    	//Variavel de Retorno
	cTitulo		,;    				//Titulo da Coluna com as opcoes
	@aLstVias	,;    				//Opcoes de Escolha (Array de Opcoes)
	@cOpcoes	,;    				//String de Opcoes para Retorno
	NIL			,;    				//Nao Utilizado
	NIL			,;    				//Nao Utilizado
	.T.			,;    				//Se a Selecao sera de apenas 1 Elemento por vez
	TamSx3("CNB_ITEM")[1],; 		//TamSx3("A6_COD")[1],;
	900;							//No maximo de elementos na variavel de retorno
	)

	EndIf

	RestArea(aArea)

Return mvpar

/*
=====================================================================================
Programa............: xGerPerc
Autor...............: Joni Lima
Data................: 20/10/2017
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
Programa............: xVldVal
Autor...............: Joni Lima
Data................: 20/10/2017
Descrição / Objetivo: Realiza validação dos valores
=====================================================================================
*/
Static Function xVldVal(aLinhas,aItens,cEsc)

	Local aArea 	:= GetArea()
	Local aAreaCNB	:= CNB->(GetArea())
	Local aAreaCNZ	:= CNZ->(GetArea())

	Local lRet 		:= .T.
	Local nTotLin   := 0
	Local ni		:= 2

	Local nTotPed	:= 0
	Local nPosVal   := aScan(aLinhas[1] , "VALOR" )
	Local nPosIt	:= 0

	Local cChvCNB := CN9->CN9_FILIAL + CN9->CN9_NUMERO + CN9->CN9_REVISA + AllTrim(cEsc)

	Local nTotal := 0 

	For ni:=2 to Len(aLinhas)
		nTotLin += val(aLinhas[ni][nPosVal])
	Next ni

	dbSelectArea("CNB")
	CNB->(dbSetOrder(1))//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM

	If CNB->(DbSeek(cChvCNB))
		While CNB->(!EOF()) .and. cChvCNB == CNB->(CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO)
			nPosIt := aScan( aItens , CNB->CNB_ITEM )
			If nPosIt <> 0
				nTotPed += CNB->CNB_VLTOT
			EndIf
			CNB->(dbSkip())
		EndDo
		If nTotPed <> nTotLin
			lRet := .F.
			MsgInfo('A Soma dos valores não esta dando o mesmo valor dos Itens Selecionados')
		EndIf
	EndIf

	RestArea(aAreaCNZ)
	RestArea(aAreaCNB)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xEncCPO
Autor...............: Joni Lima
Data................: 20/10/2017
Descrição / Objetivo: Transforma o Valor.
=====================================================================================
*/
Static Function xEncCPO(cEnc)

	Local cRet		:= ' '
	Local aDePar   	:= {{'FILIAL DESTINO','CNZ_ZFILDE'},{'CONTA CONTABIL','CNZ_CONTA'},{'CENTRO DE CUSTO','CNZ_CC'},{'ITEM CONTABIL','CNZ_ITEMCT'},{'CLASSE DE VALOR','CNZ_CLVL'},{'VALOR','CNZ_VALOR1'},{'PERCENTUAL','CNZ_PERC'}}		
	Local nPosFld	:= aScan( aDePar, { |x| AllTrim( x[1] ) == cEnc } )

	If nPosFld > 0
		cRet := aDePar[nPosFld][2]
	EndIf

return cRet

/*
=====================================================================================
Programa............: xTransVal
Autor...............: Joni Lima
Data................: 20/10/2017
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
Static Function xValRat(cPlan)

	Local aArea    := GetArea()
	Local aAreaCNB := CNB->(GetArea())
	Local aAreaCNZ := CNZ->(GetArea())

	Local lRet := .T.
	Local lApg := .F.
	Local cChvCNB   := CN9->CN9_FILIAL + CN9->CN9_NUMERO + CN9->CN9_REVISA + cPlan

	dbSelectArea("CNB")
	CNB->(dbSetOrder(1))//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM

	If CNB->(DbSeek(cChvCNB))
		While CNB->(!EOF()) .and. cChvCNB == CNB->(CNB_FILIAL + CNB_CONTRA + CNB_REVISA + CNB_NUMERO)
			If CNB->CNB_RATEIO == "1"
				If MsgYesNo("Existe Rateio para esse Documento, Deseja excluir o(s) Mesmo(s)?")
					lApg := .T.
					Exit
				Else
					lRet := .F.
				EndIf
			EndIf
			CNB->(dbSkip())
		EndDo
	EndIf

	If lApg
		If CNB->(DbSeek(cChvCNB))
			While CNB->(!EOF()) .and. cChvCNB == CNB->(CNB_FILIAL + CNB_CONTRA + CNB_REVISA + CNB_NUMERO)

				dbSelectArea("CNZ")
				CNZ->(dbSetOrder(1))//CNZ_FILIAL+CNZ_CONTRA+CNZ_REVISA+CNZ_CODPLA+CNZ_ITCONT+CNZ_ITEM
				If CNZ->(dbSeek(CNB->(CNB_FILIAL + CNB_CONTRA + CNB_REVISA + CNB_NUMERO + CNB_ITEM )))
					If Empty(CNZ->CNZ_NUMMED)
						While SCH->(!EOF()) .and. CNB->(CNB_FILIAL + CNB_CONTRA + CNB_REVISA + CNB_NUMERO + CNB_ITEM ) == CNZ->(CNZ_FILIAL + CNZ_CONTRA + CNZ_REVISA + CNZ_CODPLA + CNZ_ITCONT)
							RecLock('CNZ',.F.)
							CNZ->(dbDelete())
							CNZ->(MsUnlock())
							CNZ->(dbSkip())
						EndDo
					ENdIf
				EndIf

				RecLock('CNB',.F.)
				CNB->CNB_RATEIO := "2"
				CNB->(MsUnlock())

				CNB->(dbSkip())
			EndDo
		EndIf
	EndIf

	RestArea(aAreaCNZ)
	RestArea(aAreaCNB)
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
	
	If aLinhas[2,nPosOri] <> CN9->CN9_FILIAL
		lRet := .F.
		MsgInfo('Filial de Origem do Arquivo: ' + AllTrim(aLinhas[2][nPosOri]) + ", Esta diferente da Filial de Origem do Contrato " + CN9->CN9_FILIAL )
	EndIf
	
Return lRet