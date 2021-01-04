#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: MGFCTB10
Autor...............: Joni Lima
Data................: 20/10/2017
Descricao / Objetivo: Funcao para carregar Rateio para Documento de Entrada
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: Carrega os rateios para Documento de Entrada
=====================================================================================
*/
User Function MGFCTB10()

	Local aArea    := GetArea()
	Local aAreaSD1 := SD1->(GetArea())
	Local aLinhas  := {}

	Local cEsc	   := " "
	Local ni	   := 0
	Local nPosVal  := 0
	Local nPosPerc := 0
	Local aItens   := {}

	Local cChvSF1	:= SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)
	
	If xValCont()
		If xValRat() 
			aLinhas := U_MGFCTB07()
		
			If !Empty(aLinhas) .and. xValFiOr(aLinhas)
		
				nPosVal := aScan(aLinhas[1] , "VALOR")
				cEsc := xMGF5CNP(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
		
				For ni := 1 To Len(cEsc) STEP 4
					AADD(aItens,SubStr(cEsc,ni,4))
				Next ni
		
				If nPosVal > 0
					xGerPerc(@aLinhas)//Adiciona Coluna do Percentual
					If xVldVal(aLinhas,aItens)
		
						dbSelectArea("SD1")
						SD1->(dbSetOrder(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		
						If SD1->(DbSeek(cChvSF1))
							While SD1->(!EOF()) .and. cChvSF1 == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)
								nPosIt := aScan( aItens , SD1->D1_ITEM )
								If nPosIt <> 0
									For ni := 2 to Len(aLinhas)
										RecLock('SDE',.T.)
		
										SDE->DE_FILIAL 	:= SD1->D1_FILIAL
										SDE->DE_DOC 	:= SD1->D1_DOC 
										SDE->DE_SERIE 	:= SD1->D1_SERIE
										SDE->DE_FORNECE := SD1->D1_FORNECE
										SDE->DE_LOJA	:= SD1->D1_LOJA
										
										For nx := 1 to Len(aLinhas[1])
											If !Empty(aLinhas[ni][nx])
												cTempFld := xEncCPO(aLinhas[1][nx])
												If !(Empty(cTempFld)) .and. !(Empty(aLinhas[ni][nx])) .and. cTempFld <> "DE_CUSTO1" 
													cFld := "SDE->" + cTempFld
													&(cFld) := xTransVal(cTempFld,aLinhas[ni][nx])
												ElseIf cTempFld == "DE_CUSTO1"
												 	nPosPerc := aScan(aLinhas[1] , "PERCENTUAL" )
													SDE->DE_CUSTO1  := Round((aLinhas[ni][nPosPerc] / 100) * SD1->D1_TOTAL,2)
													SDE->DE_ZVALRAT := SDE->DE_CUSTO1
												EndIf
											EndIf
										Next nx
		
										SDE->DE_ITEMNF	:= SD1->D1_ITEM
										SDE->DE_ITEM	:= STRZERO(ni-1,3)
										
										SDE->(MsUnlock())
										
										RecLock('SD1',.F.)
											SD1->D1_RATEIO := "1"
										SD1->(MsUnlock())
										
									next ni
								EndIf
								SD1->(dbSkip())
							EndDo
						EndIf
						
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	RestArea(aAreaSD1)
	RestArea(aArea)

return

/*
=====================================================================================
Programa............: xMGF5CNP
Autor...............: Joni Lima
Data................: 20/10/2017
Descricao / Objetivo: Consulta padrao para usuarios 
=====================================================================================
*/
Static function xMGF5CNP(cDoc,cSerie,cFornece,cLoja)

	local aArea		:= GetArea()

	local aLstVias	:= {}
	local cOpcoes	:= ""
	local cTitulo	:= "Selecao dos itens onde sera incluido Rateio"
	local MvPar		:= ""//&(Alltrim(ReadVar()))		// Carrega Nome da Variavel do Get em Questao
	//local mvRet		:= "MV_PAR01"		// Iguala Nome da Variavel ao Nome variavel de Retorno

	Local cNextAlias:= GetNextAlias()

	//Verifica a Existencia de __READVAR para ReadVar()
	/*IF ( !(Type("__READVAR" ) == "C") .or. Empty(__READVAR) )
		Private M->_XITERAT := Space(900) 
		Private __READVAR     := "M->_XITERAT"
	EndIF

	MvPar		:= &(Alltrim(ReadVar()))*/

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT *
	FROM 
		%Table:SD1% SD1
	WHERE 
		SD1.D1_FILIAL = %xFilial:SD1% AND 
		SD1.%NotDel% AND 
		SD1.D1_DOC = %Exp:cDoc% AND 
		SD1.D1_SERIE = %Exp:cSerie% AND
		SD1.D1_FORNECE = %Exp:cFornece% AND
		SD1.D1_LOJA = %Exp:cLoja% AND
		SD1.D1_RATEIO <> "1"

	ORDER BY D1_ITEM

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		AADD(aLstVias, ALLTRIM((cNextAlias)->D1_ITEM) + " - Produto: " + (cNextAlias)->D1_COD + " , QTD: " + TRANSFORM((cNextAlias)->D1_QUANT, PesqPict( "SD1", "D1_QUANT" )) + " , Preco Unit.: " + TRANSFORM((cNextAlias)->D1_VUNIT, PesqPict( "SD1", "D1_VUNIT" )) + " , Total: " + TRANSFORM((cNextAlias)->D1_TOTAL, PesqPict( "SD1", "D1_TOTAL" )) )
		cOpcoes += (cNextAlias)->D1_ITEM
		(cNextAlias)->(dbSkip())
	EndDo

	If f_Opcoes(    @MvPar		,;    	//Variavel de Retorno
					cTitulo		,;    				//Titulo da Coluna com as opcoes
					@aLstVias	,;    				//Opcoes de Escolha (Array de Opcoes)
					@cOpcoes	,;    				//String de Opcoes para Retorno
					NIL			,;    				//Nao Utilizado
					NIL			,;    				//Nao Utilizado
					.F.			,;    				//Se a Selecao sera de apenas 1 Elemento por vez
					TamSx3("D1_ITEM")[1],; 			//TamSx3("A6_COD")[1],;
					900,;							//No maximo de elementos na variavel de retorno
						)

	EndIf

	RestArea(aArea)

Return mvpar

/*
=====================================================================================
Programa............: xGerPerc
Autor...............: Joni Lima
Data................: 20/10/2017
Descricao / Objetivo: Adiciona o Percentual no Array das Linhas
=====================================================================================
*/
Static Function xGerPerc(aLinhas)

	Local nTotal   := 0
	Local ni	   := 0
	Local nPosVal  := aScan(aLinhas[1] , "VALOR" ) 
	Local nPosPerc := 0
	local nTotPerc := 0
	Local nDif100  := 0

	AADD(aLinhas[1],"PERCENTUAL") //Adiciona no Cabecalho o Campo Percentual
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
Data................: 20/10/2017
Descricao / Objetivo: Transforma o Valor.
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
Data................: 20/10/2017
Descricao / Objetivo: Realiza validacao dos valores
=====================================================================================
*/
Static Function xVldVal(aLinhas,aItens)

	Local aArea 	:= GetArea()
	Local aAreaSF1	:= SF1->(GetArea())
	Local aAreaSD1	:= SD1->(GetArea())

	Local lRet 		:= .T.
	Local nTotLin   := 0
	Local ni		:= 2

	Local nTotPed	:= 0
	Local nPosVal   := aScan(aLinhas[1] , "VALOR" )
	Local nPosIt	:= 0

	Local cChvSF1	:= SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)

	Local nTotal := 0 

	For ni:=2 to Len(aLinhas)
		nTotLin += val(aLinhas[ni][nPosVal])
	Next ni

	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

	If SD1->(DbSeek(cChvSF1))
		While SD1->(!EOF()) .and. cChvSF1 == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)
			nPosIt := aScan( aItens , SD1->D1_ITEM )
			If nPosIt <> 0
				nTotPed += SD1->D1_TOTAL
			EndIf
			SD1->(dbSkip())
		EndDo
		If nTotPed <> nTotLin
			lRet := .F.
			MsgInfo('A Soma dos valores nao esta dando o mesmo valor dos Itens Selecionados')
		EndIf
	EndIf

	RestArea(aAreaSD1)
	RestArea(aAreaSF1)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xEncCPO
Autor...............: Joni Lima
Data................: 20/10/2017
Descricao / Objetivo: Transforma o Valor.
=====================================================================================
*/
Static Function xEncCPO(cEnc)

	Local cRet		:= ' '
	Local aDePar   	:= {{'FILIAL DESTINO','DE_ZFILDES'},{'CONTA CONTABIL','DE_CONTA'},{'CENTRO DE CUSTO','DE_CC'},{'ITEM CONTABIL','DE_ITEMCTA'},{'CLASSE DE VALOR','DE_CLVL'},{'VALOR','DE_CUSTO1'},{'PERCENTUAL','DE_PERC'}}		
	Local nPosFld	:= aScan( aDePar, { |x| AllTrim( x[1] ) == cEnc } )

	If nPosFld > 0
		cRet := aDePar[nPosFld][2]
	EndIf

return cRet

/*
=====================================================================================
Programa............: xValRat
Autor...............: Joni Lima
Data................: 30/10/2017
Descricao / Objetivo: Realiza a Validacao da existencia de Rateio e elimina caso necessario.
=====================================================================================
*/
Static Function xValRat()
	
	Local aArea    := GetArea()
	Local aAreaSD1 := SD1->(GetArea())
	Local aAreaSDE := SDE->(GetArea())
	
	Local lRet := .T.
	Local lApg := .F.
	Local cChvSF1	:= SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)

	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM	
	
	If SD1->(DbSeek(cChvSF1))
		While SD1->(!EOF()) .and. cChvSF1 == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)	
			If SD1->D1_RATEIO == "1"
				If MsgYesNo("Existe Rateio para esse Documento, Deseja excluir o(s) Mesmo(s)?")
					lApg := .T.
					Exit
				Else
					lRet := .F.
				EndIf
			EndIf
			SD1->(dbSkip())		
		EndDo
	EndIf
	
	If lApg
		If SD1->(DbSeek(cChvSF1))
			While SD1->(!EOF()) .and. cChvSF1 == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)	
				
				dbSelectArea("SDE")
				SDE->(dbSetOrder(1))//DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF+DE_ITEM
				If SDE->(dbSeek(SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM) ))
					While SDE->(!EOF()) .and. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_ITEM) == SDE->(DE_FILIAL + DE_DOC + DE_SERIE + DE_FORNECE + DE_LOJA + DE_ITEMNF)
						RecLock('SDE',.F.)
							SDE->(dbDelete())
						SDE->(MsUnlock())
						SDE->(dbSkip())
					EndDo
				EndIf
				
				RecLock('SD1',.F.)
					SD1->D1_RATEIO := "2"
				SD1->(MsUnlock())			
				
				SD1->(dbSkip())
			EndDo
		EndIf
	EndIf	
	
	RestArea(aAreaSDE)
	RestArea(aAreaSD1)
	RestArea(aArea)
	
Return lRet

/*
=====================================================================================
Programa............: xValFiOr
Autor...............: Joni Lima
Data................: 30/10/2017
Descricao / Objetivo: Realiza a Validacao da filial de origem com a filial de Destino
=====================================================================================
*/
Static Function xValFiOr(aLinhas)
	
	Local nPosOri := aScan(aLinhas[1] , "FILIAL ORIGEM" )
	Local lRet := .T.
	
	If aLinhas[2,nPosOri] <> SF1->F1_FILIAL
		lRet := .F.
		MsgInfo('Filial de Origem do Arquivo: ' + AllTrim(aLinhas[2][nPosOri]) + ", Esta diferente da Filial de Origem do Pedido de Compra " + SF1->F1_FILIAL )
	EndIf
	
Return lRet

/*
=====================================================================================
Programa............: xValFiOr
Autor...............: Joni Lima
Data................: 09/11/2017
Descricao / Objetivo: Valida se Documento ja Foi contabilizado
=====================================================================================
*/
Static Function xValCont()

	Local lRet := .T.

	If !Empty(SF1->F1_DTLANC) 
		lRet := .F.
		MsgInfo('Documento Encontra-se Contabilizado')
	EndIf

return lRet