#include 'protheus.ch'
#include 'parmtype.ch'
#include 'Totvs.ch'

/*
=====================================================================================
Programa............: MGFCTB07
Autor...............: Joni Lima
Data................: 02/10/2017
Descrição / Objetivo: Tela para seleção dos arquivos
Doc. Origem.........: Contrato - GAP CTB94
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function MGFCTB07()

	Local cFile 	:= xLerArq()
	Local aLinha	:= {}
	
	If !Empty(cFile)
		aLinha	:= xPrepLin(cFile)
		If !(xValLin(aLinha))
			aLinha := {}
		EndIf
	EndIf
	
Return aLinha

/*
=====================================================================================
Programa............: xLerArq
Autor...............: Joni Lima
Data................: 02/10/2017
Descrição / Objetivo: Monta a tela para escolha dos Arquivos
=====================================================================================
*/
Static Function xLerArq() 

	Local cMascara 	:= "Todos os Arquivos|*.csv"
	Local cTitulo	:= OemToAnsi("Informe o diretório onde se encontra o arquivo.")
	Local cFile		:= ''

	cFile := cGetFile(cMascara, cTitulo, 0, "\", .F., GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

Return cFile

/*
=====================================================================================
Programa............: xPrepLin
Autor...............: Joni Lima
Data................: 02/10/2017
Descrição / Objetivo: Monta o Array,
=====================================================================================
*/
Static Function xPrepLin(cFile)

	Local cLinha	:= ""
	Local aLinhas	:= {}
	Local nI		:= 2

	//ProcRegua(0)

	If FT_FUse(cFile) > 0
		//ProcRegua(FT_FLASTREC())
		FT_FGoTop()
		While !FT_FEOF()
			cLinha	:= FT_FREADLN()
			If Empty(cLinha)
				FT_FSkip()
				Loop
			EndIf
			//AADD(aLinhas,StrToKarr(cLinha,";"))
			AADD(aLinhas,StrTokArr2(cLinha,";",.T.))
			//nAux ++
			FT_FSkip()
			//IncProc(OemToAnsi("Efetuando Leitura do Arquivo"))
		Enddo
	Else
		MsgInfo( 'Não foi possível ler o arquivo: ' + cFile)
	EndIf

Return aLinhas

/*
=====================================================================================
Programa............: xValLin
Autor...............: Joni Lima
Data................: 18/10/2017
Descrição / Objetivo: Realiza validação basicas das Linhas.
=====================================================================================
*/
static function xValLin(aLinhas)

	Local aArea 		:= GetArea()
	Local aAreaSM0		:= SM0->(GetArea())
	Local aAreaCT1		:= CT1->(GetArea())
	Local aAreaCTT		:= CTT->(GetArea())
	Local aAreaCTD		:= CTD->(GetArea())
	Local aAreaCTH		:= CTH->(GetArea())

	Local lCont	  	:= .T.
	Local lTpCont 	:= .F.

	Local aCamp 	:= {'FILIAL ORIGEM','FILIAL DESTINO','CONTA CONTABIL','CENTRO DE CUSTO','ITEM CONTABIL','CLASSE DE VALOR','VALOR'}
	Local aChav     := {}
	
	Local ni	   	:= 2	
	Local nx		:= 1

	Local nPosOri	:= 1
	Local nPosDes	:= 2
	Local nConCtb	:= 3
	Local nCC		:= 4
	Local nItemCtb	:= 5
	Local nClaVal	:= 6
	Local nPosVal 	:= 7
	
	Local cFilOri   := ""
	
	Local cFldMsg

	For ni := 1 to Len(aLinhas[1])

		For nx := 1 to Len(aCamp)
			lTpCont := .F.
			If UPPER(Alltrim(aLinhas[1][ni])) == UPPER(Alltrim(aCamp[nx])) 
				lTpCont := .T.
				Exit
			EndIf
		next nx

		If !lTpCont
			cFldMsg := " " + CRLF
			For nx := 1 to Len(aCamp)
				cFldMsg += aCamp[nx] + CRLF
			next nx
			MsgInfo('Problema no Campo ' + Alltrim(aLinhas[1][ni]) + ', Favor verificar se o campo pertence a algum desses: ' + cFldMsg )
			lCont := lTpCont
			Exit
		EndIf

	next ni

	If lCont
		nPosPerc := aScan(aLinhas[1] , "VALOR" )
		For ni := 2 To Len(aLinhas)
			lTpCont := .F.
			For nx := 1 to Len(aLinhas[ni])
				if nx <> nPosVal
					If !Empty(aLinhas[ni][nx])
						lTpCont := .T.
						exit
					EndIf
				EndIf
			next nx
			If !lTpCont
				cFldMsg := " " + CRLF
				For nx := 1 to (Len(aCamp) - 1)
					cFldMsg += aCamp[nx] + CRLF
				next nx
				MsgInfo('Linha: ' + alltrim(str(ni)) + ', Necessario preencher alguma entendi contabil(abaixo) para prosseguir: ' + cFldMsg )				
				lCont := lTpCont 
				exit
			EndIf
		next ni
	EndIf

	If lCont
		dbSelectArea('SM0')
		SM0->(dbSetOrder(1))//M0_CODIGO+M0_CODFIL

		dbSelectArea("CT1")
		CT1->(dbSetOrder(1))//CT1_FILIAL+CT1_CONTA

		dbSelectArea("CTT")
		CTT->(dbSetOrder(1))//CTT_FILIAL+CTT_CUSTO
		
		dbSelectArea("CTD")
		CTD->(dbSetOrder(1))//CTD_FILIAL+CTD_ITEM

		dbSelectArea("CTH")
		CTH->(dbSetOrder(1))//CTH_FILIAL+CTH_CLVL

		nPosOri := aScan(aLinhas[1] ,  'FILIAL ORIGEM'  )
		nPosDes := aScan(aLinhas[1] ,  'FILIAL DESTINO' )

		nConCtb  := aScan(aLinhas[1] , 'CONTA CONTABIL' )
		nCC		 := aScan(aLinhas[1] , 'CENTRO DE CUSTO')
		nItemCtb := aScan(aLinhas[1] , 'ITEM CONTABIL'  )
		nClaVal  := aScan(aLinhas[1] , 'CLASSE DE VALOR') 

		nPosPerc := aScan(aLinhas[1] , "VALOR" )

		For ni := 2 To Len(aLinhas)		
			
			lTpCont := .F.
	
			If aScan(aChav,aLinhas[ni][nPosDes] + aLinhas[ni][nConCtb] + aLinhas[ni][nCC] + aLinhas[ni][nItemCtb] + aLinhas[ni][nClaVal] ) == 0
				AADD(aChav,aLinhas[ni][nPosDes] + aLinhas[ni][nConCtb] + aLinhas[ni][nCC] + aLinhas[ni][nItemCtb] + aLinhas[ni][nClaVal])
			Else
				MsgInfo('Linha: ' + alltrim(str(ni)) + ', Conjunto de entidade contabil esta duplicado'  )
				lCont := lTpCont
				exit
			EndIf

			If !Empty(aLinhas[ni][nPosOri])
				If Len(aLinhas[ni][nPosOri]) <> 6 .or. !(SM0->(DbSeek(cEmpAnt + aLinhas[ni][nPosOri])))
					MsgInfo('Linha: ' + alltrim(str(ni)) + ', Verificar a Filial de Origem: ' + AllTrim(aLinhas[ni][nPosOri])  )
					lCont := lTpCont
					exit
				EndIf
			EndIf
	
			If Empty(cFilOri)
				cFilOri := AllTrim(aLinhas[ni][nPosOri])
			Else
				If cFilOri <> AllTrim(aLinhas[ni][nPosOri])
					MsgInfo('Linha: ' + alltrim(str(ni)) + ', Verificar a Filial de Origem: ' + AllTrim(aLinhas[ni][nPosOri]) + ',Obs.: Filial de Origem deve ser igual em todo o Arquivo' )
					lCont := lTpCont
					exit
				EndIf
			EndIf

			If val(aLinhas[ni][nPosPerc]) <= 0
				MsgInfo('Linha: ' + alltrim(str(ni)) + ', Verificar o Valor: ' + AllTrim(aLinhas[ni][nPosPerc]) + ',Valor precisa ser maior que Zero para continuar' )
				lCont := lTpCont
				exit
			EndIf
			
			If !Empty(aLinhas[ni][nPosDes])
				If Len(aLinhas[ni][nPosDes]) <> 6 .or. !(SM0->(DbSeek(cEmpAnt + aLinhas[ni][nPosDes])))
					MsgInfo('Linha: ' + alltrim(str(ni)) + ', Verificar a Filial de Destino: ' + AllTrim(aLinhas[ni][nPosDes]) )				
					lCont := lTpCont 
					exit					
				EndIf
			EndIf

			If !Empty(aLinhas[ni][nConCtb])
				If !(CT1->(DbSeek(xFilial("CT1") + aLinhas[ni][nConCtb])))
					MsgInfo('Linha: ' + alltrim(str(ni)) + ', Verificar a Conta Contabil: ' + AllTrim(aLinhas[ni][nConCtb]) )				
					lCont := lTpCont 
					exit
				EndIf
			EndIf

			If !Empty(aLinhas[ni][nCC])
				If !(CTT->(DbSeek(xFilial("CTT") + aLinhas[ni][nCC])))
					MsgInfo('Linha: ' + alltrim(str(ni)) + ', Verificar o Centro de Custo: ' + AllTrim(aLinhas[ni][nCC]) )				
					lCont := lTpCont 
					exit
				EndIf
			EndIf

			If !Empty(aLinhas[ni][nItemCtb])
				If !(CTD->(DbSeek(xFilial("CTD") + aLinhas[ni][nItemCtb])))
					MsgInfo('Linha: ' + alltrim(str(ni)) + ', Verificar o Item Contabil: ' + AllTrim(aLinhas[ni][nItemCtb]) )				
					lCont := lTpCont 
					exit
				EndIf
			EndIf

			If !Empty(aLinhas[ni][nClaVal])
				If !(CTH->(DbSeek(xFilial("CTH") + aLinhas[ni][nClaVal])))
					MsgInfo('Linha: ' + alltrim(str(ni)) + ', Verificar a Classe de Valor: ' + AllTrim(aLinhas[ni][nClaVal]) )				
					lCont := lTpCont 
					exit
				EndIf
			EndIf
		Next ni
	EndIf
	
	RestArea(aAreaSM0)
	RestArea(aAreaCT1)
	RestArea(aAreaCTT)
	RestArea(aAreaCTD)
	RestArea(aAreaCTH)
	RestArea(aArea)

return lCont