#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: MGFCTB12
Autor...............: Joni Lima
Data................: 30/10/2017
Descrição / Objetivo: Função para carregar Rateio para Contratos
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Carrega os rateios na Medição
=====================================================================================
*/
user function MGFCTB12()

	Local aItens 	:= {}
	Local aLinhas  	:= {}		
	Local cIten	   	:= ""
	Local cEsc	   	:= " "
	Local ni	   	:= 0
	Local nPosPerc  := 0

	Local cChvCND	:= CND->(CND_FILIAL + CND_CONTRA + CND_REVISA + CND_NUMERO + CND_NUMMED)
	
	
	If Empty(CND_CLIENT)
		If Empty(CND->CND_DTFIM) .AND. CND->CND_ALCAPR = 'L'  	.AND. CND->CND_AUTFRN == '1'	.AND. CND->CND_SERVIC == '1'
			If xValRat()
				aLinhas := U_MGFCTB07()
				If !Empty(aLinhas) .and. xValFiOr(aLinhas)
	
					cIten := xMGFCPlan(CND->CND_NUMMED,CND->CND_CONTRA,CND->CND_REVISA,CND->CND_NUMERO)
					For ni := 1 To Len(cIten) STEP 4
						AADD(aItens,SubStr(cIten,ni,4))
					Next ni
	
					nPosVal := aScan(aLinhas[1] , "VALOR")
					If nPosVal > 0
						xGerPerc(@aLinhas)//Adiciona Coluna do Percentual
						If xVldVal(aLinhas,aItens)
							
							dbSelectArea("CNE")
							CNE->(dbSetOrder(1))//CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED+CNE_ITEM
	
							If CNE->(DbSeek(cChvCND))
								While CNE->(!Eof()) .and. cChvCND == CNE->(CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED)
									
									nPosIt := aScan( aItens , CNE->CNE_ITEM )
									If nPosIt <> 0
										For ni := 2 to Len(aLinhas)
										
											RecLock('CNZ',.T.)
		
											CNZ_FILIAL := xFilial("CNZ")
											CNZ_CONTRA := CND->CND_CONTRA
											CNZ_CODPLA := CND->CND_NUMERO
											CNZ_REVISA := CND->CND_REVISA 
											CNZ_FORNEC := CND->CND_FORNEC
											CNZ_LJFORN := CND->CND_LJFORN
											CNZ_ITCONT := CNE->CNE_ITEM
											CNZ_NUMMED := CND->CND_NUMMED
											CNZ_ITEM   := STRZERO(ni-1,3)
		
											For nx := 1 to Len(aLinhas[1])
												If !Empty(aLinhas[ni][nx])
													cTempFld := xEncCPO(aLinhas[1][nx])
													If !(Empty(cTempFld)) .and. !(Empty(aLinhas[ni][nx])) .and. cTempFld <> 'CNZ_VALOR1'
														cFld := "CNZ->" + cTempFld
														&(cFld) := xTransVal(cTempFld,aLinhas[ni][nx])
													ElseIf cTempFld == 'CNZ_VALOR1'
														nPosPerc := aScan(aLinhas[1] , "PERCENTUAL" )
														CNZ->CNZ_VALOR1  := Round((aLinhas[ni][nPosPerc] / 100) * CNE->CNE_VLTOT,2)
													EndIf
												EndIf
											Next nx
											CNZ->(MsUnlock())
									
										next ni
									EndIf
									CNE->(dbSkip())
								EndDo	
							EndIf		
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			MsgInfo('Só é possivel incluir rateio em medição que estão com status de aberto')
		EndIf
	Else
		MsgInfo('Só é possivel incluir rateio em medições de Compras')
	EndIf
return

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
	Local aAreaCND	:= CND->(GetArea())
	Local aAreaCNE	:= CNE->(GetArea())

	Local lRet 		:= .T.
	Local nTotLin   := 0
	Local ni		:= 2

	Local nTotPed	:= 0
	Local nPosVal   := aScan(aLinhas[1] , "VALOR" )
	Local nPosIt	:= 0

	Local cChvCND	:= CND->(CND_FILIAL + CND_CONTRA + CND_REVISA + CND_NUMERO + CND_NUMMED)

	Local nTotal := 0 

	For ni:=2 to Len(aLinhas)
		nTotLin += val(aLinhas[ni][nPosVal])
	Next ni

	dbSelectArea("CNE")
	CNE->(dbSetOrder(1))//CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED+CNE_ITEM

	If CNE->(DbSeek(cChvCND))
		While CNE->(!EOF()) .and. cChvCND == CNE->(CNE_FILIAL + CNE_CONTRA + CNE_REVISA + CNE_NUMERO + CNE_NUMMED)
			nPosIt := aScan( aItens , CNE->CNE_ITEM )
			If nPosIt <> 0
				nTotPed += CNE->CNE_VLTOT
			EndIf
			CNE->(dbSkip())
		EndDo
		If nTotPed <> nTotLin
			lRet := .F.
			MsgInfo('A Soma dos valores não esta dando o mesmo valor dos Itens Selecionados')
		EndIf
	EndIf

	RestArea(aAreaCND)
	RestArea(aAreaCNE)
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
Programa............: xMGFCPlan
Autor...............: Joni Lima
Data................: 26/10/2017
Descrição / Objetivo: Consulta das planilhas
=====================================================================================
*/
Static function xMGFCPlan(cMedic,cContra,cRevis,cPlan)

	local aArea		:= GetArea()

	local aLstVias	:= {}
	local cOpcoes	:= ""
	local cTitulo	:= "Seleção dos itens para o Rateio"
	local MvPar		:= ""//&(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao
	//local mvRet		:= "MV_PAR01"		// Iguala Nome da Variavel ao Nome variavel de Retorno

	Local cNextAlias:= GetNextAlias()

	//Verifica a Existencia de __READVAR para ReadVar()
	IF ( !(Type("__READVAR" ) == "C") .or. Empty(__READVAR) )
		Private M->_XITRAT := Space(900) 
		Private __READVAR     := "M->_XITRAT"
	EndIF

	MvPar		:= &(Alltrim(ReadVar()))

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT *
	FROM 
		%Table:CNE% CNE
	WHERE
		CNE.%NotDel% AND
		CNE.CNE_FILIAL = %xFilial:CNE% AND
		CNE.CNE_CONTRA = %Exp:cContra% AND
		CNE.CNE_NUMMED = %Exp:cMedic% AND	
		CNE.CNE_REVISA = %Exp:cRevis% AND
		CNE.CNE_NUMERO = %Exp:cPlan%
	
	ORDER BY CNE_ITEM

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		AADD(aLstVias, ALLTRIM((cNextAlias)->CNE_ITEM) + " - Prod.: " + (cNextAlias)->CNE_PRODUT + ", Qtd.: " + TRANSFORM((cNextAlias)->CNE_QTDSOL, PesqPict( "CNB", "CNB_QUANT" )) + ", Val. Unit.: " + TRANSFORM((cNextAlias)->CNE_VLUNIT, PesqPict( "CNE", "CNE_VLUNIT" )) + ", Total: " + TRANSFORM((cNextAlias)->CNE_VLTOT, PesqPict( "CNE", "CNE_VLTOT" )))
		cOpcoes += (cNextAlias)->CNE_ITEM
		(cNextAlias)->(dbSkip())	
	EndDo

	If f_Opcoes(    @MvPar		,;    	//Variavel de Retorno
	cTitulo		,;    				//Titulo da Coluna com as opcoes
	@aLstVias	,;    				//Opcoes de Escolha (Array de Opcoes)
	@cOpcoes	,;    				//String de Opcoes para Retorno
	NIL			,;    				//Nao Utilizado
	NIL			,;    				//Nao Utilizado
	.T.			,;    				//Se a Selecao sera de apenas 1 Elemento por vez
	TamSx3("CNE_ITEM")[1],; 		//TamSx3("A6_COD")[1],;
	900;							//No maximo de elementos na variavel de retorno
	)

	EndIf

	RestArea(aArea)

Return mvpar

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
	Local aAreaCND := CND->(GetArea())
	Local aAreaCNE := CNE->(GetArea())

	Local lRet := .T.
	Local lApg := .F.
	Local cChvCND	:= CND->(CND_FILIAL + CND_CONTRA + CND_REVISA + CND_NUMERO + CND_NUMMED)

	dbSelectArea("CNE")
	CNE->(dbSetOrder(1))//CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED+CNE_ITEM

	If CNE->(DbSeek(cChvCND))
		While CNE->(!EOF()) .and. cChvCND == CNE->(CNE_FILIAL + CNE_CONTRA + CNE_REVISA + CNE_NUMERO + CNE_NUMMED)
			
			If !(xExiRat(CNE->CNE_CONTRA,CNE->CNE_REVISA,CNE->CNE_NUMMED,CNE->CNE_NUMERO))
				If MsgYesNo("Existe Rateio para esse Documento, Deseja excluir o(s) Mesmo(s)?")
					lApg := .T.
					Exit
				Else
					lRet := .F.
				EndIf
			EndIf

			CNE->(dbSkip())
		EndDo
	EndIf

	If lApg
		If CNE->(DbSeek(cChvCND))
			While CNE->(!EOF()) .and. cChvCND == CNE->(CNE_FILIAL + CNE_CONTRA + CNE_REVISA + CNE_NUMERO + CNE_NUMMED)

				dbSelectArea("CNZ")
				CNZ->(dbSetOrder(2))//CNZ_FILIAL+CNZ_CONTRA+CNZ_REVISA+CNZ_NUMMED+CNZ_ITCONT+CNZ_ITEM
				If CNZ->(dbSeek(CNE->(CNE_FILIAL + CNE_CONTRA + CNE_REVISA + CNE_NUMMED + CNE_ITEM )))
					If !Empty(CNZ->CNZ_NUMMED)
						While CNZ->(!EOF()) .and. CNE->(CNE_FILIAL + CNE_CONTRA + CNE_REVISA + CNE_NUMMED + CNE_ITEM) == CNZ->(CNZ_FILIAL + CNZ_CONTRA + CNZ_REVISA + CNZ_NUMMED + CNZ_ITCONT)
							RecLock('CNZ',.F.)
							CNZ->(dbDelete())
							CNZ->(MsUnlock())
							CNZ->(dbSkip())
						EndDo
					EndIf
				EndIf

				CNE->(dbSkip())
			EndDo
		EndIf
	EndIf
	
	RestArea(aAreaCNE)
	RestArea(aAreaCND)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xExiRat
Autor...............: Joni Lima
Data................: 31/10/2017
Descrição / Objetivo: Existe Rateio
=====================================================================================
*/
Static Function xExiRat(cContra,cRevisa,NumMed,cCodPla)
	
	Local lRet := .T.
	Local cNextAlias:= GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT *
	FROM 
		%Table:CNZ% CNZ
	WHERE
		CNZ.%NotDel% AND
		CNZ.CNZ_FILIAL = %xFilial:CNZ% AND
		CNZ.CNZ_CONTRA = %Exp:cContra% AND
	    CNZ.CNZ_REVISA = %Exp:cRevisa% AND
	    CNZ.CNZ_NUMMED = %Exp:NumMed% AND
	    CNZ.CNZ_CODPLA = %Exp:cCodPla%
	
	ORDER BY CNZ_ITEM

	EndSql

	(cNextAlias)->(DbGoTop())	
	
	While (cNextAlias)->(!EOF())
		lRet := .F.
		If !lRet
			Exit
		EndIf
		(cNextAlias)->(dbSkip())
	EndDo
	
	(cNextAlias)->(DbClosearea())
	
return lRet

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
	
	If aLinhas[2,nPosOri] <> CND->CND_FILIAL
		lRet := .F.
		MsgInfo('Filial de Origem do Arquivo: ' + AllTrim(aLinhas[2][nPosOri]) + ", Esta diferente da Filial de Origem do Pedido de Compra " + CND->CND_FILIAL )
	EndIf
	
Return lRet