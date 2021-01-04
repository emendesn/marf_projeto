#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

Static _lCpoEnt05 //Entidade 05
Static _lCpoEnt06 //Entidade 06
Static _lCpoEnt07 //Entidade 07
Static _lCpoEnt08 //Entidade 08
Static _lCpoEnt09 //Entidade 09

Static _cKEYCT2
Static _cLPCT2
/*
=====================================================================================
Programa............: MGFCTB03
Autor...............: Joni Lima
Data................: 06/11/2016
Descricao / Objetivo: Pontos de Entradas para GAp CTB01
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Todos as Funcoes de PE estaram nesse fonte para o GAP CTB01
=====================================================================================
*/
User Function MGFCTB03()

Return

/*
=====================================================================================
Programa............: xMF103RCC
Autor...............: Joni Lima
Data................: 06/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MT103RCC
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de entrada para Carregar o rateio do Pedido de compra para o rateio do documento de entrada.
=====================================================================================
*/
User Function xMF103RCC(aHeadSDE,aColsSDE)

	Local aArea      := GetArea()
	//Local aColsSDE	 := {}//PARAMIXB[2]
	Local aEntidades := {}

	Local cItem 	 := StrZero(len(aCols),Len(SD1->D1_ITEM))

	Local nRecSC7	 := SC7->(RECNO())
	Local nPosItem   := Ascan(aHeadSDE,{|x| AllTrim(x[2]) == "DE_ITEM"} )
	Local nPosPerc   := Ascan(aHeadSDE,{|x| AllTrim(x[2]) == "DE_PERC"} )
	Local nPosCC     := Ascan(aHeadSDE,{|x| AllTrim(x[2]) == "DE_CC"} )
	Local nPosConta  := Ascan(aHeadSDE,{|x| AllTrim(x[2]) == "DE_CONTA"} )
	Local nPosItCta  := Ascan(aHeadSDE,{|x| AllTrim(x[2]) == "DE_ITEMCTA"} )
	Local nPosCLVL   := Ascan(aHeadSDE,{|x| AllTrim(x[2]) == "DE_CLVL"} )
	Local nPosFilDe	 := Ascan(aHeadSDE,{|x| AllTrim(x[2]) == "DE_ZFILDES"} )
	Local nPosACols	 := Ascan(aColsSDE,{|x| AllTrim(x[1]) == Alltrim(cItem) } )
	Local nPosTotal	 := Ascan(aHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"} )
	Local nPosVlRat	 := Ascan(aHeadSDE,{|x| AllTrim(x[2]) == "DE_ZVALRAT"} )
	Local nDec	:= TamSX3("DE_ZVALRAT")[2]
	Local nCt        := 0
	Local nLinha	 := 0
	Local nEnt		 := 0
	Local nDeb		 := 0
	Local nTamItem	 := TamSX3("DE_ITEM")[1]

	SC7->(MsGoTo(nRecSC7))
	dbSelectArea("SCH")
	SCH->(dbSetOrder(1))//CH_FILIAL+CH_PEDIDO+CH_FORNECE+CH_LOJA+CH_ITEMPD+CH_ITEM
	If SCH->(dbSeek(xFilial("SCH")+SC7->( C7_NUM + C7_FORNECE + C7_LOJA + C7_ITEM ) ))
		While SCH->(!Eof()) .And. SCH->(CH_FILIAL + CH_PEDIDO + CH_FORNECE+ CH_LOJA+ CH_ITEMPD) == xFilial("SCH") + SC7->( C7_NUM + C7_FORNECE + C7_LOJA + C7_ITEM  )
			If nCt == 0
				If nPosACols <= 0
					aAdd(aColsSDE,{ cItem,{} } )
					nPosACols := Len(aColsSDE)
					nCt+=1
				EndIf
			EndIF
			nLinha++
			If len(aColsSDE[nPosACols][2]) < nLinha
				aAdd(aColsSDE[nPosACols][2],Array( Len(aHeadSDE) + 1 ) )
			EndIf
			aColsSDE[nPosACols][2][nLinha][nPosItem]  := RetAsc(Str(nLinha),nTamItem,.T.)
			aColsSDE[nPosACols][2][nLinha][nPosPerc]   	:= SCH->CH_PERC
			aColsSDE[nPosACols][2][nLinha][nPosCC]   	:= SCH->CH_CC
			aColsSDE[nPosACols][2][nLinha][nPosConta]   := SCH->CH_CONTA
			aColsSDE[nPosACols][2][nLinha][nPosItCta]  	:= SCH->CH_ITEMCTA
			aColsSDE[nPosACols][2][nLinha][nPosCLVL]   	:= SCH->CH_CLVL
			aColsSDE[nPosACols][2][nLinha][nPosFilDe]   := SCH->CH_ZFILDES
			aColsSDE[nPosACols][2][nLinha][nPosVlRat]   := Round( SCH->CH_PERC * aCols[N,nPosTotal] / 100  , nDec )
			aColsSDE[nPosACols][2][nLinha][Len(aHeadSDE) + 1] := .F.

			aEntidades := CtbEntArr()
			For nEnt := 1 to Len(aEntidades)
				For nDeb := 1 to 2
					cCpo := "DE_EC"+aEntidades[nEnt]
					cSCH := "CH_EC"+aEntidades[nEnt]

					If nDeb == 1
						cCpo += "DB"
						cSCH += "DB"
					Else
						cCpo += "CR"
						cSCH += "CR"
					EndIf

					nPosHead := aScan(aHeadSDE,{|x| AllTrim(x[2]) == Alltrim(cCpo) } )

					If nPosHead > 0
						aColsSDE[nPosACols][2][nLinha][nPosHead] := SCH->(&(cSCH))
					EndIf

				Next nDeb
			Next nEnt

			SCH->(dbSkip())
		EndDo
	EndIf

	RestArea(aArea)

Return aColsSDE

/*
=====================================================================================
Programa............: xMF103PRE
Autor...............: Joni Lima
Data................: 06/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MT103PRE
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de entrada para carregar Filial de Destino quando utilizar rateios pre configurados no documento de entrada
=====================================================================================
*/
User Function xMF103PRE(aHedSDE,aColsSDE)

	Local aArea		:= GetArea()
	Local aAreaCTJ	:= CTJ->(GetArea())

	Local nPosFilDes		:= aScan(aHedSDE,{|x| AllTrim(x[2]) == "DE_ZFILDES" } )
	Local nPosItem			:= aScan(aHedSDE,{|x| AllTrim(x[2]) == "DE_ITEM" } )
	Local cRateio			:= CTJ->CTJ_RATEIO
	Local cSequenc			:= ''

	Local _nX := 1

	dbSelectArea('CTJ')
	CTJ->(dbSetOrder(1))//CTJ_FILIAL, CTJ_RATEIO, CTJ_SEQUEN

	For _nX := 1 to len(aColsSDE)
		cSequenc := STRZERO(val(aColsSDE[_nX][nPosItem]),TamSX3('CTJ_SEQUEN')[1])
		If CTJ->(dbSeek(xFilial('CTJ') + cRateio + cSequenc ))
			aColsSDE[_nX][nPosFilDes] := CTJ->CTJ_ZFILDE
		EndIf
	Next _nX

	RestArea(aAreaCTJ)
	RestArea(aArea)

Return aColsSDE

/*
=====================================================================================
Programa............: xMF110BTR
Autor...............: Joni Lima
Data................: 06/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MT110BTR
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Adiciona botao com fun��oo para trazer os rateios confugurados marfrig
=====================================================================================
*/
User Function xMF110BTR(aBut)

	Local aRet := aBut
	Local aHeadSCX   := {}
	Private oGetDad

	AADD(aRet,{'AUTOM',{|| AdmRatExt(aHeadSCX,oGetDad:aCols,{ |x,y,z,w| u_xMF110Opc(x,y,@z,w) }) },"Rateio Marfrig",OemToAnsi("Escolha Rateio Pre-config. Marfrig")})

Return aRet

/*
=====================================================================================
Programa............: xMF110Opc
Autor...............: Joni Lima
Data................: 06/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MT110BTR
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Pega e preenche Rateios com as informa��oes, adicionando a Filial Destino
=====================================================================================
*/
User Function xMF110Opc(aCols, aHeader, cItem, lPrimeiro)

	Local lCusto		:= CtbMovSaldo("CTT")
	Local lItem	 		:= CtbMovSaldo("CTD")
	Local lCLVL	 		:= CtbMovSaldo("CTH")
	Local nPosPerc		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CX_PERC" } )
	Local nPosItem		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CX_ITEM" } )
	Local nPosCC		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CX_CC"} )
	Local nPosConta		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CX_CONTA"} )
	Local nPosItemCta	:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CX_ITEMCTA"} )
	Local nPosCLVL		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CX_CLVL"} )
	Local nPosFilde		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CX_ZFILDES"} )
	Local nHeader		:= 0
	Local aMT103PRE		:= {}
	Local aEntidades	:= {}
	Local nEnt			:= 0
	Local nDeb			:= 0

	If lPrimeiro
		//-- Se ja foi informado algum rateio, limpar o aCols
		If aCols[Len(aCols)][nPosPerc] <> 0
			aCols := {}
			Aadd(aCols, Array(Len(oGetDad:aHeader) + 1))
			For nHeader := 1 To Len(oGetDad:aHeader)
				If Trim(oGetDad:aHeader[nHeader][2]) <> "CX_ALI_WT" .And. Trim(oGetDad:aHeader[nHeader][2]) <> "CX_REC_WT"
					aCols[Len(aCols)][nHeader] := CriaVar(oGetDad:aHeader[nHeader][2])
				Endif
			Next
		EndIf
		cItem := Soma1(cItem)
		aCols[Len(aCols)][nPosItem]  := cItem
		aCols[Len(aCols)][Len(oGetDad:aHeader)+1] := .F.
	Else
		If aCols[Len(aCols)][nPosPerc] = 0
			nCols := Len(aCols)
			cItem := aCols[nCols][nPosItem]
		Else
			If Len(aCols) > 0
				cItem := aCols[Len(aCols)][nPosItem]
			Endif
			Aadd(aCols, Array(Len(oGetDad:aHeader) + 1))
			cItem := Soma1(cItem)
		EndIf

		For nHeader := 1 To Len(oGetDad:aHeader)
			If Trim(oGetDad:aHeader[nHeader][2]) <> "CX_ALI_WT" .And. Trim(oGetDad:aHeader[nHeader][2]) <> "CX_REC_WT"
				aCols[Len(aCols)][nHeader] := CriaVar(oGetDad:aHeader[nHeader][2])
			EndIf
		Next

		aCols[Len(aCols)][nPosItem] := cItem

		// Interpreto os campos incluida possibilidade de variaveis de memoria
		If !Empty(CTJ->CTJ_DEBITO)
			aCols[Len(aCols)][nPosConta]	:= CTJ->CTJ_DEBITO
			aCols[Len(aCols)][nPosFilde] := CTJ->CTJ_ZFILDE
		Else
			aCols[Len(aCols)][nPosConta]	:= CTJ->CTJ_CREDIT
			aCols[Len(aCols)][nPosFilde] := CTJ->CTJ_ZFILDE
		Endif


		If lCusto
			If ! Empty(CTJ->CTJ_CCD)
				aCols[Len(aCols)][nPosCc]	:= CTJ->CTJ_CCD
			Else
				aCols[Len(aCols)][nPosCc]	:= CTJ->CTJ_CCC
			Endif
		EndIf

		If lItem
			If ! Empty(CTJ->CTJ_ITEMD)
				aCols[Len(aCols)][nPosItemCta]	:= CTJ->CTJ_ITEMD
			Else
				aCols[Len(aCols)][nPosItemCta]	:= CTJ->CTJ_ITEMC
			Endif
		EndIf

		If lClVl
			If ! Empty(CTJ->CTJ_CLVLDB)
				aCols[Len(aCols)][nPosClVl]	:= CTJ->CTJ_CLVLDB
			Else
				aCols[Len(aCols)][nPosClVl]	:= CTJ->CTJ_CLVLCR
			Endif
		EndIf
		aCols[Len(aCols)][nPosPerc] := CTJ->CTJ_PERCEN
		aCols[Len(aCols)][Len(oGetDad:aHeader) + 1] := .F.

		aEntidades := CtbEntArr()
		For nEnt := 1 to Len(aEntidades)
			For nDeb := 1 to 2
				cCpo := "CX_EC" + aEntidades[nEnt]
				cCTJ := "CTJ_EC" + aEntidades[nEnt]

				If nDeb == 1
					cCpo += "DB"
					cCTJ += "DB"
				Else
					cCpo += "CR"
					cCTJ += "CR"
				EndIf

				nPosHead := aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == Alltrim(cCpo) } )

				If nPosHead > 0
					aCols[Len(aCols)][nPosHead] := CTJ->(&(cCTJ))
				EndIf

			Next nDeb
		Next nEnt

	EndIf

Return .T.

/*
=====================================================================================
Programa............: xMF110BTR
Autor...............: Joni Lima
Data................: 06/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MT120BTR
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Adiciona botao com fun��oo para trazer os rateios confugurados marfrig
=====================================================================================
*/
User Function xMF120BTR(aBut)

	Local aRet := aBut
	Local aHeadSCH   := {}
	Private oGetDad

	AADD(aRet,{'AUTOM',{|| AdmRatExt(aHeadSCH,oGetDad:aCols,{ |x,y,z,w| u_xMF120Opc(x,y,@z,w) }) },"Rateio Marfrig",OemToAnsi('Escolha de Rateio Pre-Config. Marfrig')})

Return aRet

/*
=====================================================================================
Programa............: xMF120Opc
Autor...............: Joni Lima
Data................: 06/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MT120BTR
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Pega e preenche Rateios com as informa��oes, adicionando a Filial Destino
=====================================================================================
*/
User Function xMF120Opc(aCols, aHeader, cItem, lPrimeiro)

Local lCusto		:= CtbMovSaldo("CTT")
Local lItem	 		:= CtbMovSaldo("CTD")
Local lCLVL	 		:= CtbMovSaldo("CTH")
Local nPosPerc		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CH_PERC" } )
Local nPosItem		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CH_ITEM" } )
Local nPosCC		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CH_CC"} )
Local nPosConta		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CH_CONTA"} )
Local nPosItemCta	:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CH_ITEMCTA"} )
Local nPosCLVL		:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CH_CLVL"} )
Local nPosFilDe  	:= aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "CH_ZFILDES"} )
Local nHeader       := 0
Local aMT103PRE     := {}

Local lCtbIsCube    := FindFunction("CtbEntArr") .And. AliasInDic("CV0")
Local aEntidades	:= {}
Local nEnt			:= 0
Local nDeb			:= 0

If lPrimeiro
	//-- Se ja foi informado algum rateio, limpar o aCols
	If aCols[Len(aCols)][nPosPerc] <> 0
		aCols := {}
		Aadd(aCols, Array(Len(oGetDad:aHeader) + 1))
		For nHeader := 1 To Len(oGetDad:aHeader)
			If Trim(oGetDad:aHeader[nHeader][2]) <> "CH_ALI_WT" .And. Trim(oGetDad:aHeader[nHeader][2]) <> "CH_REC_WT"
				aCols[Len(aCols)][nHeader] := CriaVar(oGetDad:aHeader[nHeader][2])
			Endif
		Next
	EndIf
	cItem := Soma1(cItem)
	aCols[Len(aCols)][nPosItem]  := cItem
	aCols[Len(aCols)][Len(oGetDad:aHeader)+1] := .F.
Else
	If aCols[Len(aCols)][nPosPerc] = 0
		nCols := Len(aCols)
		cItem := aCols[nCols][nPosItem]
	Else
		If Len(aCols) > 0
			cItem := aCols[Len(aCols)][nPosItem]
		Endif
		Aadd(aCols, Array(Len(oGetDad:aHeader) + 1))
		cItem := Soma1(cItem)
	EndIf

	For nHeader := 1 To Len(oGetDad:aHeader)
		If Trim(oGetDad:aHeader[nHeader][2]) <> "CH_ALI_WT" .And. Trim(oGetDad:aHeader[nHeader][2]) <> "CH_REC_WT"
			aCols[Len(aCols)][nHeader] := CriaVar(oGetDad:aHeader[nHeader][2])
		EndIf
	Next

	aCols[Len(aCols)][nPosItem] := cItem

	// Interpreto os campos incluida possibilidade de variaveis de memoria
	If !Empty(CTJ->CTJ_DEBITO)
		aCols[Len(aCols)][nPosConta]	:= CTJ->CTJ_DEBITO
		aCols[Len(aCols)][nPosFilDe]    := CTJ->CTJ_ZFILDE
	Else
		aCols[Len(aCols)][nPosConta]	:= CTJ->CTJ_CREDIT
		aCols[Len(aCols)][nPosFilDe]    := CTJ->CTJ_ZFILDE
	Endif


	If lCusto
		If ! Empty(CTJ->CTJ_CCD)
			aCols[Len(aCols)][nPosCc]	:= CTJ->CTJ_CCD
		Else
			aCols[Len(aCols)][nPosCc]	:= CTJ->CTJ_CCC
		Endif
	EndIf

	If lItem
		If ! Empty(CTJ->CTJ_ITEMD)
			aCols[Len(aCols)][nPosItemCta]	:= CTJ->CTJ_ITEMD
		Else
			aCols[Len(aCols)][nPosItemCta]	:= CTJ->CTJ_ITEMC
		Endif
	EndIf

	If lClVl
		If ! Empty(CTJ->CTJ_CLVLDB)
			aCols[Len(aCols)][nPosClVl]	:= CTJ->CTJ_CLVLDB
		Else
			aCols[Len(aCols)][nPosClVl]	:= CTJ->CTJ_CLVLCR
		Endif
	EndIf
	aCols[Len(aCols)][nPosPerc] := CTJ->CTJ_PERCEN
	aCols[Len(aCols)][Len(oGetDad:aHeader) + 1] := .F.

	If lCtbIsCube
		aEntidades := CtbEntArr()
		For nEnt := 1 to Len(aEntidades)
			For nDeb := 1 to 2
				cCpo := "CH_EC"+aEntidades[nEnt]
				cCTJ := "CTJ_EC"+aEntidades[nEnt]

				If nDeb == 1
					cCpo += "DB"
					cCTJ += "DB"
				Else
					cCpo += "CR"
					cCTJ += "CR"
				EndIf

				nPosHead := aScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == Alltrim(cCpo) } )

				If nPosHead > 0 .And. CTJ->(FieldPos(cCTJ)) > 0
					aCols[Len(aCols)][nPosHead] := CTJ->(&(cCTJ))
				EndIf

			Next nDeb
		Next nEnt
	EndIf

EndIf

Return .T.

/*
=====================================================================================
Programa............: xMF03VlLP
Autor...............: Joni Lima
Data................: 07/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada CTBA120, Localizado no Fonte MGFCTB04 (PE MVC)
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz o Pos valid da Linha, foi adicionado o filial destino
=====================================================================================
*/
User Function xMF03VlLP()

	Local oMdlGeral		:= FwModelActive()
	Local oModel		:= oMdlGeral:GetModel('CTJDETAIL')
	Local lRet			:= .T.
	Local nPercen		:= oModel:GetValue("CTJ_PERCEN")
	Local nLinha		:= 0
	Local nLinPos		:= oModel:GetLine()
	Local cChaveDeb		:= oModel:GetValue("CTJ_DEBITO") + oModel:GetValue("CTJ_CCD") + oModel:GetValue("CTJ_ITEMD") + oModel:GetValue("CTJ_CLVLDB") + oModel:GetValue("CTJ_ZFILDE")
	Local cChaveCred	:= oModel:GetValue("CTJ_CREDIT") + oModel:GetValue("CTJ_CCC") + oModel:GetValue("CTJ_ITEMC") + oModel:GetValue("CTJ_CLVLCR") + oModel:GetValue("CTJ_ZFILDE")
	Local cChvAuxDeb	:= ""
	Local cChvAuxCrd	:= ""

	//Analise da existencia dos campos das novas entidades
	Ctb120IniVar()

	If Empty(nPercen)
		Help(" ",1,"CTJVLZERO")
		lRet := .F.
	EndIf

	If _lCpoEnt05
		cChaveDeb  += oModel:GetValue("CTJ_EC05DB")
		cChaveCred += oModel:GetValue("CTJ_EC05CR")
	EndIf

	If _lCpoEnt06
		cChaveDeb  += oModel:GetValue("CTJ_EC06DB")
		cChaveCred += oModel:GetValue("CTJ_EC06CR")
	EndIf

	If _lCpoEnt07
		cChaveDeb  += oModel:GetValue("CTJ_EC07DB")
		cChaveCred += oModel:GetValue("CTJ_EC07CR")
	EndIf

	If _lCpoEnt08
		cChaveDeb  += oModel:GetValue("CTJ_EC08DB")
		cChaveCred += oModel:GetValue("CTJ_EC08CR")
	EndIf

	If _lCpoEnt09
		cChaveDeb  += oModel:GetValue("CTJ_EC09DB")
		cChaveCred += oModel:GetValue("CTJ_EC09CR")
	EndIf

	//--------------------------------------------------------------
	// Nao  permite duplicar a chave da entidade a credito ou debito
	//--------------------------------------------------------------
	For nLinha := 1 To oModel:Length()

		oModel:GoLine(nLinha)

		//Ignora a linha editada na comparacao
		If nLinha != nLinPos .And. !oModel:IsDeleted()

			cChvAuxDeb	:= oModel:GetValue("CTJ_DEBITO") + oModel:GetValue("CTJ_CCD") + oModel:GetValue("CTJ_ITEMD") + oModel:GetValue("CTJ_CLVLDB") + oModel:GetValue("CTJ_ZFILDE")
			cChvAuxCrd	:= oModel:GetValue("CTJ_CREDIT") + oModel:GetValue("CTJ_CCC") + oModel:GetValue("CTJ_ITEMC") + oModel:GetValue("CTJ_CLVLCR") + oModel:GetValue("CTJ_ZFILDE")

			If _lCpoEnt05
				cChvAuxDeb += oModel:GetValue("CTJ_EC05DB")
				cChvAuxCrd += oModel:GetValue("CTJ_EC05CR")
			EndIf

			If _lCpoEnt06
				cChvAuxDeb += oModel:GetValue("CTJ_EC06DB")
				cChvAuxCrd += oModel:GetValue("CTJ_EC06CR")
			EndIf

			If _lCpoEnt07
				cChvAuxDeb += oModel:GetValue("CTJ_EC07DB")
				cChvAuxCrd += oModel:GetValue("CTJ_EC07CR")
			EndIf

			If _lCpoEnt08
				cChvAuxDeb += oModel:GetValue("CTJ_EC08DB")
				cChvAuxCrd += oModel:GetValue("CTJ_EC08CR")
			EndIf

			If _lCpoEnt09
				cChvAuxDeb += oModel:GetValue("CTJ_EC09DB")
				cChvAuxCrd += oModel:GetValue("CTJ_EC09CR")
			EndIf

			//Avalia chave duplicada de debito e credito
			If cChaveDeb + cChaveCred == cChvAuxDeb + cChvAuxCrd
				lRet := .F.
				Help('',1,'CT120VDENT',,"Contas invalidas. Deve-se utilizar contas diferentes para ser um rateio.",1,0)	//"Contas invalidas"
				Exit
			EndIf

		EndIf

	Next nLinha

	oModel:GoLine(nLinPos) //Restaura a linha posicionada

Return lRet

/*
=====================================================================================
Programa............: xMF03TdOK
Autor...............: Joni Lima
Data................: 07/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada CTBA120, Localizado no Fonte MGFCTB04 (PE MVC)
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz o Tudo OK, antes do commit. verifica se caso utiliza filia destino, esta preenchida em todas as Linhas
=====================================================================================
*/
User Function xMF03TdOK(oModel)

	Local lRet 		:= .T.
	Local lFilDes	:= .F.
	Local oMdlGrid	:= oModel:GetModel('CTJDETAIL')
	Local ni		:= 0

	//Analise da existencia dos campos das novas entidades
	Ctb120IniVar()

	oMdlGrid:GoLine(1)

	lFilDes := !Empty(oMdlGrid:GetValue('CTJ_ZFILDE'))//Verifica se a Primeira Linha tem Filial Destino

	For ni := 1 To oMdlGrid:Length()
		oMdlGrid:GoLine(ni)
		If !oMdlGrid:IsDeleted(ni)
			If lFilDes
				lRet := !Empty(oMdlGrid:GetValue('CTJ_ZFILDE'))
			Else
				lRet := Empty(oMdlGrid:GetValue('CTJ_ZFILDE'))
			EndIf
			If !lRet
				Help(,,'Filial Destino',,'Quanto Utilizar Filial de Destino todas os registros precisam estar com a filial destino preenchida',1,0)
				Exit
			EndIf
		EndIf
	Next ni

Return lRet

/*
=====================================================================================
Programa............: xMF0102EXC
Autor...............: Joni Lima
Data................: 07/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada CTB102EXC Ou CTB102ESTL. valida��oo de Exclusao e Exclusao Por Lote
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a valida��oo do calendario para Exclusao do lan�amento contabil.
=====================================================================================
*/
User Function xMF0102EXC(nOpc)

	Local lRet := .T.
	Local dDtHav
	Local lTempRet := .T.

	Local aERROS := {}
	Local cxFilAtu := cFilAnt  //Retorna Filial
	Local ni
	Local nTamChv := 0

	Local cNextAlias:= GetNextAlias()
	Local cChvSDE	:= ''
	Local cChvQuer	:= ''

	If nOpc == 5 .and.  CT2->CT2_LP $ '650|651' .and. !(IsInCallStack('U_xM102EXCL'))//Exclusao e LPs 650 e 651

		//Pega os campos que compoe a Chave
		dbSelectArea('CTL')
		CTL->(dbSetOrder(1))//CTL_FILIAL, CTL_LP
		If CTL->(dbSeek(xFilial('CTL') + CT2->CT2_LP))
			aFields	:= StrTokArr(CTL->CTL_KEY , '+')
			//Pega o tamanho da chave
			For ni:=1 to Len(aFields)
				nTamChv += TamSx3(aFields[ni])[1]
			Next ni
		EndIf

		//Posiciona no Item da Nota de entrada
		dbSelectArea('SD1')
		SD1->(dbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM
		If SD1->(dbSeek(LEFT(CT2->CT2_KEY,nTamChv)))
			//Encontra Rateios
			dbSelectArea('SDE')
			SDE->(dbSetOrder(1))//DE_FILIAL, DE_DOC, DE_SERIE, DE_FORNECE, DE_LOJA, DE_ITEMNF, DE_ITEM
			cChvSDE := SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_ITEM)
			If SDE->(dbSeek(cChvSDE))
				While SDE->(!EOF()).and. cChvSDE == SDE->(DE_FILIAL + DE_DOC + DE_SERIE + DE_FORNECE + DE_LOJA + DE_ITEM)
					If !Empty(SDE->DE_ZDTLANC)

						cChvQuer := SDE->(DE_FILIAL + DE_DOC + DE_SERIE + DE_FORNECE + DE_LOJA + DE_ITEMNF + DE_ITEM)

						If Select(cNextAlias) > 0
							(cNextAlias)->(DbClosearea())
						Endif

						BeginSql Alias cNextAlias

							SELECT
								DISTINCT CT2.CT2_FILIAL,CT2.CT2_DATA
							FROM
								%Table:CT2% CT2
							WHERE
								CT2.CT2_FILIAL <> ' ' AND
								CT2.CT2_KEY = %exp:cChvQuer% AND
								CT2.CT2_ROTINA = 'MGFCTB01' AND
								CT2.D_E_L_E_T_ = ' '

							ORDER BY CT2_FILIAL, CT2_DATA

						EndSql

						(cNextAlias)->(dbGoTop())

						While (cNextAlias)->(!EOF())

							cFilAnt := (cNextAlias)->CT2_FILIAL
							SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
							SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))

							dDtHav := STOD((cNextAlias)->CT2_DATA) //Pega Data
							lTempRet := VlDtCal(dDtHav,dDtHav) //Realiza Valida��oo do Periodo

							If !lTempRet
								AADD(aERROS,'Filial: ' + (cNextAlias)->CT2_FILIAL + ', Data: ' + dToC(dDtHav))
								If lRet //Sera alterado apenas uma vez essa variavel.
									lRet := .F.
								EndIf
							EndIf

							(cNextAlias)->(dbSkip())
						EndDo
					EndIf
					SDE->(dbSkip())
				EndDo
			EndIf
		EndIf

		//Verifica se Gerou erros e apresenta as filiais e datas que estao com datas em calendarios INDISPONIVEIS
		If Len(aERROS) > 0
			For ni := 1 to Len(aERROS)
				cErros += aERROS[ni]
			Next ni
			AVISO('Periodo Bloqueado',cErros,{'OK'},3)
		EndIf

		cFilAnt := cxFilAtu //Retorna Filial
		SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
		SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))
	ElseIf nOpc == 5 .and.  CT2->CT2_LP $ '333|334' .and. !(IsInCallStack('U_xM102EXCL')) //Nao e possivel realizar a dele��oo
		lRet := .F.
		AVISO('Aten��oo!','Lancamento proveniente de rateio. Para excluir este lan�amento sera necessario excluir o lan�amento de origem ',{'OK'},3)
	EndIf

Return lRet

/*
=====================================================================================
Programa............: xMF0PEANCT
Autor...............: Joni Lima
Data................: 22/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada ANCTB102GR
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Chama JOB para exclusao dos lan�amentos 333 e 334
=====================================================================================
*/
User Function xMF0PEANCT(nOpc)

	Local cCT2KEY := CT2->CT2_KEY
	Local cCT2LP  := CT2->CT2_LP

	If cCT2LP $ '650|651' .and. nOpc == 5 .and. !(IsInCallStack('U_xM102EXCL'))
		_cKEYCT2 := cCT2Key//Pega a Key do Registro
		_cLPCT2  := cCT2LP //pega a LP do Registro
		StartJob("U_xM102EXCL",GetEnvServer(),.T.,cEmpAnt,cFilAnt,cModulo,nOpc,cCT2Key,cCT2LP)
	EndIf

Return

/*
=====================================================================================
Programa............: xMF02DEPGV
Autor...............: Joni Lima
Data................: 22/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada DPCTB102GR
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Para limpar o Flag caso necessario da tabela SDE
=====================================================================================
*/
User Function xMF02DEPGV(nOpc)

	Local aArea 	:= GetArea()
	Local aAreaSF1	:= SD1->(GetArea())
	Local aAreaSD1  := SF1->(GetArea())
	Local aAreaSDE	:= SDE->(GetArea())
	Local cChave	:= ''
	Local cChvNF	:= ''
	Local nTamChv	:= 0

	If !Empty(_cKEYCT2) .and. !Empty(_cLPCT2)
		If nOPC == 5
			If _cLPCT2 $ '650|651'

				nTamChv	:= TamSX3('D1_FILIAL')[1] + TamSX3('D1_DOC')[1] + TamSX3('D1_SERIE')[1] + TamSX3('D1_FORNECE')[1] + TamSX3('D1_LOJA')[1]
				cChvNF := LEFT(AllTrim(_cKEYCT2), nTamChv)

				DbSelectArea('SD1')
				SD1->(DbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM
				If SD1->(DbSeek(AllTrim(cChvNF)))
					While SD1->(!EOF()) .and. AllTrim(cChvNF) == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA )
						DbSelectArea('SF1')
						SF1->(dbSetOrder(1))//F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
						If SF1->(DbSeek(SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)))
							cChave := xFilial('SDE') + SD1->(D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_ITEM)
							DbSelectArea('SDE')
							SDE->(DbSetOrder(1))//DE_FILIAL, DE_DOC, DE_SERIE, DE_FORNECE, DE_LOJA, DE_ITEMNF, DE_ITEM
							If (SDE->(DbSeek(cChave)))
								While SDE->(!EOF()) .and. cChave == SDE->(DE_FILIAL + DE_DOC + DE_SERIE + DE_FORNECE + DE_LOJA + DE_ITEMNF)

									RecLock('SDE',.F.)
										SDE->DE_ZDTLANC := SF1->F1_DTLANC
									SDE->(MsUnlock())

									SDE->(DbSkip())
								EndDo
							EndIf
						EndIf
						SD1->(DbSkip())
					EndDo
				EndIf
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSDE)
	RestArea(aAreaSD1)
	RestArea(aAreaSF1)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xM102EXCL
Autor...............: Joni Lima
Data................: 22/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada ANCTB102GR
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Prepara ambiente para o JOB
=====================================================================================
*/
User Function xM102EXCL(cEmp,cFil,cModulo,nOpc,cCT2Key,cCT2LP)

	Local lPrepEnv  := ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )
	Local aInfo		:= {}
	Local ni		:= 0
	Local bError 	:= ErrorBlock( { |oError| MyError( oError ) } )

	If ( lPrepEnv )
		RpcSetType( 3 )
		PREPARE ENVIRONMENT EMPRESA( cEmp ) FILIAL ( cFil ) MODULO ( cModulo ) TABLES "CT2", "CV3", "CTK", "SDE", "SF1", "SD1" ,"CTL"
	EndIf

	BEGIN SEQUENCE

		Conout('Iniciou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME() + ' Modulo: ' + IIF(Valtype(cModulo)=='C',cModulo,''))
		U_xMF0EX102(nOpc,cCT2Key,cCT2LP)
		Conout('Terminou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME())

	RECOVER
		Conout('Deu Problema na Execu��oo' + ' Horas: ' + TIME() )
    END SEQUENCE

	ErrorBlock( bError )

	If ( lPrepEnv )
		RESET ENVIRONMENT
	EndIF

Return .T.

Static Function MyError(oError )
	Conout( oError:Description + "Deu Erro" )
	BREAK
Return .T.

/*
=====================================================================================
Programa............: xMF0EX102
Autor...............: Joni Lima
Data................: 22/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada ANCTB102GR
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a exclusao dos lan�amentos 333 e 334 para os registro 650/651
=====================================================================================
*/
User Function xMF0EX102(nOpc,cCT2Key,cCT2LP)
    Local cError     := ''
	Local ni 		 := 0
	Local nTamChv	 := 0

	Local cNextAlias := GetNextAlias()

	Local cChvSDE	 := ''
	Local cChvQuer	 := ''
	Local cChvWhi	 := ''
	Local cSpacFil	 := Replicate(' ',LEN(SM0->M0_CODIGO))
	Local cxFilAtu   := cFilAnt  //Pega Filial Atual

	Local lRet       := .T.

	Local aFields	 := {}
	Local aDadosCab  := {}
	Local aDadosItem := {}
	Local aLinhas 	 := {}

	Private lMsErroAuto := .F.
	Private lMsHelpAuto	:= .T.
	Private CTF_LOCK := 0
	Private lSubLote := .T.

	If nOpc == 5 .and.  cCT2LP $ '650|651' //Exclusao e LPs 650 e 651

		Begin Transaction

			//Pega os campos que compoe a Chave
			dbSelectArea('CTL')
			CTL->(dbSetOrder(1))//CTL_FILIAL, CTL_LP
			If CTL->(dbSeek(xFilial('CTL') + cCT2LP))
				aFields	:= StrTokArr(CTL->CTL_KEY , '+')
				//Pega o tamanho da chave
				For ni:=1 to Len(aFields)
					nTamChv += TamSx3(aFields[ni])[1]
				Next ni
			EndIf

			//Posiciona no Item da Nota de entrada
			dbSelectArea('SD1')
			SD1->(dbSetOrder(1))//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM
			If SD1->(dbSeek(LEFT(cCT2Key,nTamChv)))

				//Encontra Rateios
				dbSelectArea('SDE')
				SDE->(dbSetOrder(1))//DE_FILIAL, DE_DOC, DE_SERIE, DE_FORNECE, DE_LOJA, DE_ITEMNF, DE_ITEM
				cChvSDE := SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_ITEM)
				If SDE->(dbSeek(cChvSDE))

					While SDE->(!EOF()).and. cChvSDE == SDE->(DE_FILIAL + DE_DOC + DE_SERIE + DE_FORNECE + DE_LOJA + DE_ITEM)
						If !Empty(SDE->DE_ZDTLANC)

						//Posicionar no Lancamento e Chamar ExecAuto para Exclusao dos Lan�amentos
							aDadosCab  := {}
							aDadosItem := {}

							cChvQuer := SDE->(DE_FILIAL + DE_DOC + DE_SERIE + DE_FORNECE + DE_LOJA + DE_ITEMNF + DE_ITEM)

							If Select(cNextAlias) > 0
								(cNextAlias)->(DbClosearea())
							Endif

							BeginSql Alias cNextAlias

								SELECT
									CT2.*
								FROM
									%Table:CT2% CT2
								WHERE
									CT2.CT2_FILIAL <> ' ' AND
									CT2.CT2_KEY = %exp:cChvQuer% AND
									CT2.CT2_ROTINA = 'MGFCTB01' AND
									CT2.D_E_L_E_T_ = ' '

								ORDER BY CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LP, CT2_DIACTB, CT2_LINHA

							EndSql

							(cNextAlias)->(dbGoTop())

							cChvWhi	:= (cNextAlias)->(CT2_FILIAL + CT2_DATA + CT2_LOTE + CT2_SBLOTE + CT2_DOC + CT2_LP + CT2_DIACTB)
							cFilAnt := (cNextAlias)->CT2_FILIAL
							SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
							SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))

							While (cNextAlias)->(!EOF())

								If cChvWhi == (cNextAlias)->(CT2_FILIAL + CT2_DATA + CT2_LOTE + CT2_SBLOTE + CT2_DOC + CT2_LP + CT2_DIACTB)

									If Len(aDadosCab) == 0
										AADD(aDadosCab,{ "DDATALANC"  ,StoD((cNextAlias)->CT2_DATA)   ,NIL } )
										AADD(aDadosCab,{ "CLOTE"      ,(cNextAlias)->CT2_LOTE   ,NIL } )
										AADD(aDadosCab,{ "CSUBLOTE"   ,(cNextAlias)->CT2_SBLOTE ,NIL } )
										AADD(aDadosCab,{ "CDOC"       ,(cNextAlias)->CT2_DOC    ,NIL } )
										//AADD(aDadosCab,{ "CPADRAO"    ,(cNextAlias)->CT2_LP     ,NIL } )
										//AADD(aDadosCab,{ "CCODSEQ"    ,(cNextAlias)->CT2_DIACTB ,NIL } )
										//AADD(aDadosCab,{ "NTOTINF"    ,0.00            			,NIL } )
										//AADD(aDadosCab,{ "NTOTINFLOT" ,0.00            			,NIL } )
									EndIf

									aLinhas := {}

									AADD(aLinhas,{'CT2_FILIAL',(cNextAlias)->CT2_FILIAL , NIL})
									AADD(aLinhas,{'CT2_LINHA' ,(cNextAlias)->CT2_LINHA  , NIL})
									AADD(aLinhas,{'LINPOS' ,'CT2_LINHA'  , (cNextAlias)->CT2_LINHA})
									AADD(aLinhas,{'CT2_MOEDLC',(cNextAlias)->CT2_MOEDLC , NIL})
									AADD(aLinhas,{'CT2_DC'    ,(cNextAlias)->CT2_DC     , NIL})
									AADD(aLinhas,{'CT2_DEBITO',(cNextAlias)->CT2_DEBITO , NIL})
									AADD(aLinhas,{'CT2_CREDIT',(cNextAlias)->CT2_CREDIT , NIL})
									AADD(aLinhas,{'CT2_VALOR' ,(cNextAlias)->CT2_VALOR  , NIL})
									AADD(aLinhas,{'CT2_ORIGEM',(cNextAlias)->CT2_ORIGEM , NIL})
									AADD(aLinhas,{'CT2_HP'    ,(cNextAlias)->CT2_HP     , NIL})
									AADD(aLinhas,{'CT2_HIST'  ,(cNextAlias)->CT2_HIST   , NIL})
									AADD(aDadosItem,aLinhas)
								Else

									MSExecAuto({|x,y,z| CTBA102(x,y,z)},aDadosCab,aDadosItem,5)//Exclusao

									If lMsErroAuto
										If (!IsBlind()) // COM INTERFACE GRAFICA
										MostraErro()
									    Else // EM ESTADO DE JOB
									        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
									
									        ConOut(PadC("Automatic routine ended with error", 80))
									        ConOut("Error: "+ cError)
									    EndIf
									EndIf

									//Zera Cabecalho e item
									aDadosCab  := {}
									aDadosItem := {}

									//Monta Chave para Proximo Lote
									cChvWhi	:= (cNextAlias)->(CT2_FILIAL + CT2_DATA + CT2_LOTE + CT2_SBLOTE + CT2_DOC + CT2_LP + CT2_DIACTB)
									cFilAnt := (cNextAlias)->CT2_FILIAL
									SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
									SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))

									If !Empty(cChvWhi)
										If Len(aDadosCab) == 0
											AADD(aDadosCab,{ "DDATALANC"  ,StoD((cNextAlias)->CT2_DATA)   ,NIL } )
											AADD(aDadosCab,{ "CLOTE"      ,(cNextAlias)->CT2_LOTE   ,NIL } )
											AADD(aDadosCab,{ "CSUBLOTE"   ,(cNextAlias)->CT2_SBLOTE ,NIL } )
											AADD(aDadosCab,{ "CDOC"       ,(cNextAlias)->CT2_DOC    ,NIL } )
											//AADD(aDadosCab,{ "CPADRAO"    ,(cNextAlias)->CT2_LP     ,NIL } )
											//AADD(aDadosCab,{ "CCODSEQ"    ,(cNextAlias)->CT2_DIACTB ,NIL } )
											//AADD(aDadosCab,{ "NTOTINF"    ,0.00            			,NIL } )
											//AADD(aDadosCab,{ "NTOTINFLOT" ,0.00            			,NIL } )
										EndIf

										aLinhas := {}

										AADD(aLinhas,{'CT2_FILIAL',(cNextAlias)->CT2_FILIAL , NIL})
										AADD(aLinhas,{'CT2_LINHA' ,(cNextAlias)->CT2_LINHA  , NIL})
										AADD(aLinhas,{'LINPOS' ,'CT2_LINHA'  , (cNextAlias)->CT2_LINHA})
										AADD(aLinhas,{'CT2_MOEDLC',(cNextAlias)->CT2_MOEDLC , NIL})
										AADD(aLinhas,{'CT2_DC'    ,(cNextAlias)->CT2_DC     , NIL})
										AADD(aLinhas,{'CT2_DEBITO',(cNextAlias)->CT2_DEBITO , NIL})
										AADD(aLinhas,{'CT2_CREDIT',(cNextAlias)->CT2_CREDIT , NIL})
										AADD(aLinhas,{'CT2_VALOR' ,(cNextAlias)->CT2_VALOR  , NIL})
										AADD(aLinhas,{'CT2_ORIGEM',(cNextAlias)->CT2_ORIGEM , NIL})
										AADD(aLinhas,{'CT2_HP'    ,(cNextAlias)->CT2_HP     , NIL})
										AADD(aLinhas,{'CT2_HIST'  ,(cNextAlias)->CT2_HIST   , NIL})
										AADD(aDadosItem,aLinhas)
									EndIf

								EndIf

								(cNextAlias)->(dbSkip())
							EndDo

							If Len(aDadosCab) > 0
								//Executa a Exclusao do ultimo Registro
								MSExecAuto({|x,y,z| CTBA102(x,y,z)},aDadosCab,aDadosItem,5)//Exclusao

								If lMsErroAuto
									If (!IsBlind()) // COM INTERFACE GRAFICA
									MostraErro()
								    Else // EM ESTADO DE JOB
								        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
								
								        ConOut(PadC("Automatic routine ended with error", 80))
								        ConOut("Error: "+ cError)
								    EndIf
								EndIf
							EndIf

						EndIf
						SDE->(dbSkip())
					EndDO
				EndIf
			EndIf
		End Transaction
		cFilAnt := cxFilAtu
		SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
		SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))
	EndIf

Return lRet

/*
=====================================================================================
Programa............: xMF03FiL
Autor...............: Joni Lima
Data................: 21/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada FLTESTLT
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz o Filtro dos itens para exibi��oo na marca��oo do Lote
=====================================================================================
*/
User Function xMF03FiL()

	local aArea	:= GetArea()
	local lRet 	:= .T.

	If AllTrim(CT2->CT2_LP) $ '333|334'
		lRet := .F.
	EndIf

	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMF03105CK
Autor...............: Joni Lima
Data................: 21/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada CT105CTK
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a gravacao correta da Data do lan�amento na CTK
=====================================================================================
*/
User Function xMF03105CK()

	Local aArea		:= GetArea()
	Local aAreaSDE	:= SDE->(GetArea())
	Local aAreaSF1	:= SF1->(GetArea())

	If AllTrim(CTK->CTK_LP) $ '333|334'
		dbSelectArea('SDE')
		SDE->(DbSetOrder(1))//DE_FILIAL, DE_DOC, DE_SERIE, DE_FORNECE, DE_LOJA, DE_ITEMNF, DE_ITEM
		If SDE->(DbSeek(AllTrim(CTK->CTK_KEY)))
			dbSelectArea('SF1')
			SF1->(dbSetOrder(1))//F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
			If SF1->(DbSeek(xFilial('SF1',SDE->DE_FILIAL) + SDE->(DE_DOC + DE_SERIE + DE_FORNECE + DE_LOJA)))
				CTK->CTK_DATA := SF1->F1_DTDIGIT
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSF1)
	RestArea(aAreaSDE)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF03103E
Autor...............: Joni Lima
Data................: 22/11/2016
Descricao / Objetivo: Utilizado no Ponto de Entrada MT103EXC
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica se existe Contabilizacao para Doc de entrada.
=====================================================================================
*/
User Function xMF03103E()

	Local lRet := .T.

	If !Empty(SF1->F1_DTLANC)
		lRet := .F.
		AVISO('Aten��oo!','o Documento de Entrada possui contabiliza��es, para processeguir favor excluir os lan�amentos.',{'OK'},1)
	EndIf

Return lRet

User Function xMF03CGat(nTot)

	Local cRet := " "

	Local nPosValR := aScan(ACPHSCH,{|x| Alltrim(x[2]) == "CH_ZVALRAT"})
	Local nPosAco  := 0
	Local nPosPerc := aScan(ACPHSCH,{|x| Alltrim(x[2]) == "CH_PERC"})

	Local nZ := 0

	If nPosValR > 0 .and. nPosPerc > 0
		If Len(ACPISCH) > 0
			nPosAco := aScan(ACPISCH,{|x| Alltrim(x[1]) == StrZero(n,Len(SC7->C7_ITEM),0)})
			If nPosAco > 0
				For nZ := 0 to Len(ACPISCH[nPosAco][2])
					ACPISCH[nPosAco][2][nZ][nPosValR] := (ACPISCH[nPosAco][2][nZ][nPosPerc] / 100) * nTot
				next nZ
			EndIf
		EndIf
	EndIf

Return nTot