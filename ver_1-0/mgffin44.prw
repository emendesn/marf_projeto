#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFFIN44
Autor....:              Atilio Amarilla
Data.....:              28/02/2017
Descricao / Objetivo:   Geração Arquivo padrão CNAB
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamado pelo browse MVC MGFFIN43
=====================================================================================
*/
User Function MGFFIN44()

	Processa({|| MGFFIN4401() },"Aguarde - Gerando Arquivo...")

Return

Static Function MGFFIN4401()
	LOCAL nTamArq:=0,lResp:=.t.
	LOCAL lHeader:=.F.,lFirst:=.F.,lFirst2:=.F.
	LOCAL nTam,nDec,nUltDisco:=0,nGrava:=0,aBordero:={}

	LOCAL oDlg,oBmp,nMeter := 1
	LOCAL cTexto := "CNAB"

	LOCAL cFilDe
	LOCAL cFilAte
	LOCAL cNumBorAnt := CRIAVAR("E1_NUMBOR",.F.)
	LOCAL cCliAnt	  := CRIAVAR("E1_CLIENTE",.F.)
	LOCAL lFirstBord := .T.
	LOCAL lBorBlock := .F.
	LOCAL lAchouBord := .F.
	LOCAL lIdCnab := .T.
	Local lAtuDsk := .F.
	Local lCnabEmail := .F.
	Local cFilBor := ""
	Local nOrdSE1:=5
	Local lNovoLote := .F.
	Local lBCOBORD := .T.

	Local cLstSit := ""
	Local aHlpSit := {}
	Local cHlpSit := ""
	//--- Tratamento Gestao Corporativa

	Local cIndexSe1
	Local nIndexSe1
	Local cQuery 	:= ""
	Local lHeadMod2 := .F.
	Local bWhile2
	Local cOrder
	Local nValor
	Local cCart	:= "R"
	//Gestao
	Local lQuery 	:= IfDefTopCTB() // verificar se pode executar query (TOPCONN)
	Local aSelFil	:= {}

	Local bWhile 	:= {||.T.}
	Local cSelFil	:= ""
	Local cLastFil	:= ""
	Local nX		:= 1

	Local cAlias	//:= GetNextAlias()
	Local cNumBor	:= "" //Soma1(GetMV("MV_NUMBORR"),6)
	Local lNewBor	:= .F.
	Local nOpcA		:= 0
	Local lFIDC		:= ZA7->ZA7_TIPO == "1"

	Local aCabRem	:= {"Remessa","Filial","Prefixo","Número","Parcela","Tipo","Cliente","Loja","Nome","Emissão","Vencimento","Valor"}
	Local aItens	:= {}

	If ZA7->ZA7_TIPO == "2"
		//cArqCfg	:= cArqCfgRec
		aAdd( aCabRem , "Motivo Recommpra" )
	EndIf

	//While !MayIUseCode("SE1"+xFilial("SE1")+cNumBor)  //verifica se esta na memoria, sendo usado
	// busca o proximo numero disponivel
	//	cNumBor := Soma1(cNumBor)
	//EndDo

	If Empty( ZA7->ZA7_DATA )
		If lFIDC
			cNumBor	:= Soma1(GetMV("MV_NUMBORR"),6)

			While !MayIUseCode("SE1"+xFilial("SE1")+cNumBor)  //verifica se esta na memoria, sendo usado
				// busca o proximo numero disponivel
				cNumBor := Soma1(cNumBor)
			EndDo
		EndIf
	Else
		nOpcA := Aviso("FIDC - Geração Arquivo","Deseja gerar arquivo novamente?",{'Sim',"Nâo"})
		If nOpcA == 1
			If lFIDC
				cNumBor := ZA7->ZA7_NUMBOR
			EndIf
		Else
			Return .F.
		EndIf
	EndIf

	PRIVATE cBanco,cAgencia,xConteudo
	PRIVATE nHdlBco    	:= 0
	PRIVATE nHdlSaida  	:= 0
	PRIVATE nSeq       	:= 0
	PRIVATE nSomaValor	:= 0
	PRIVATE nSomaVlLote	:= 0
	PRIVATE nQtdTotTit	:= 0
	PRIVATE nQtdTitLote	:= 0
	PRIVATE nSomaAcres	:= 0
	PRIVATE nSomaDecre	:= 0
	PRIVATE nBorderos		:= 0
	PRIVATE xBuffer,nLidos 	:= 0
	PRIVATE nTotCnab2			:= 0 // Contador de Lay-out nao deletar
	PRIVATE nLinha				:= 0 // Contador de Linhas nao deletar
	PRIVATE nQtdLinLote			:= 0 // Contador de linhas do detalhe do lote

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no Banco indicado                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBanco  := cBcoFIDC
	cAgencia:= cAgeFIDC
	cConta  := cCtaFIDC
	cSubCta := cSubFIDC

	If lFIDC
		IF !FILE(cArqCfg)
			Help(" ",1,"NOARQPAR")
			Return .F.
		EndIf
	Else
		IF !FILE(cArqCfgRec)
			Help(" ",1,"NOARQPAR")
			Return .F.
		EndIf
	EndIf
	If !U_zMakeDir( cPatRem , "Pasta Servidor" )

		Return

	EndIf

	If !U_zMakeDir( cPatLoc , "Pasta Local" )

		Return

	EndIf

	dbSelectArea("SA6")
	If !(dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta))
		Help(" ",1,"FA150BCO")

		Return .F.

	ElseIf Max(SA6->A6_MOEDA,1) > 1

		Help( "  ", 1, "MOEDACNAB" )

		Return .F.

	Endif

	dbSelectArea("SEE")
	SEE->( dbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCta) )
	If !SEE->( found() )
		Help(" ",1,"PAR150")

		Return .F.
	Else
		If !Empty(SEE->EE_FAXFIM) .and. !Empty(SEE->EE_FAXATU) .and. Val(SEE->EE_FAXFIM)-Val(SEE->EE_FAXATU) < 100
			Help(" ",1,"FAIXA150")
		Endif
	Endif

	nTotCnab2	:= 0
	nSeq		:= 0

	cAlias	:= GetNextAlias()

	BeginSQL Alias cAlias

		SELECT SE1.R_E_C_N_O_ E1_RECNO, ZA8.R_E_C_N_O_ ZA8_RECNO, SE1.*, ZA8.*
		FROM %table:SE1% SE1
		INNER JOIN %table:ZA8% ZA8 ON ZA8.D_E_L_E_T_ = ''
			AND ZA8_FILORI = E1_FILIAL
			AND ZA8_PREFIX = E1_PREFIXO
			AND ZA8_NUM = E1_NUM
			AND ZA8_PARCEL = E1_PARCELA
			AND ZA8_TIPO = E1_TIPO
			AND ZA8_CODREM = %Exp:ZA7->ZA7_CODREM%
			AND ZA8_FILIAL = %Exp:ZA7->ZA7_FILIAL%
			AND ZA8_STATUS IN ('1','2')
		WHERE SE1.D_E_L_E_T_ = ' '
			AND E1_SITUACA = '1'
		ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO

	EndSQL

	aQuery := GetLastQuery()

	MemoWrit( FunName()+"-fGera-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )
	//[1] Tabela temp
	//[2] Query
	//..[5]

	dbSelectArea("ZA8")
	dbSetOrder(1) //ZA8_FILIAL+ZA8_CODREM+ZA8_PREFIX+ZA8_NUM+ZA8_PARCEL+ZA8_TIPO

	dbSelectArea("SEA")
	dbSetOrder(2) //EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA

	// Processa resultado da query
	While ( cAlias )->(!Eof())

		SE1->(MsGoto(( cAlias )->E1_RECNO))
		ZA8->(MsGoto(( cAlias )->ZA8_RECNO))

		lAchouBord := .T.
		IncProc()

		dbSelectArea( cAlias )

		IF SE1->E1_TIPO $ MVRECANT+"/"+MVPROVIS
			(cAlias )->( dbSkip() )
			Loop
		EndIF

		//Criação dos XMLs
		//U_xMFT90Gr((cAlias)->E1_RECNO, AllTrim(ZA7->ZA7_FILIAL) + ZA7->ZA7_CODREM)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no cliente                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA1")
		MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
		// Se o Header do arquivo nao foi criado, cria.
		If !lHeadMod2  //Modelo 2
			lHeadMod2:=AbrePar(@cArqRem)	//Abertura Arquivo ASC II
			// Se houve erro na criacao do arquivo, abandona o processo
			If ! lHeadMod2
				Exit
			Endif
		Endif

		dbSelectArea(cAlias)


		nSeq++
		nQtdTitLote ++
		nQtdTotTit ++

		nSomaValor	+= SE1->E1_VALOR //SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE // alterado em 14/06/17 a pedido do Claudio
		nSomaVlLote += SE1->E1_VALOR //SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE // alterado em 14/06/17 a pedido do Claudio

		nSomaAcres += SE1->E1_SDACRES

		nSomaDecre += SE1->E1_SDDECRE

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le Arquivo de Parametrizacao                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLidos:=0
		FSEEK(nHdlBco,0,0)
		nTamArq:=FSEEK(nHdlBco,0,2)
		FSEEK(nHdlBco,0,0)
		lIdCnab := .T.

		While nLidos <= nTamArq

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o tipo qual registro foi lido                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			xBuffer:=Space(85)
			FREAD(nHdlBco,@xBuffer,85)

			Do Case
			Case SubStr(xBuffer,1,1) == CHR(1)
				IF lHeader
					nLidos+=85
					Loop
				EndIF
			Case SubStr(xBuffer,1,1) == CHR(2)
				lFirst2 := .F. //Controle do detalhe tipo 5
				IF !lFirst
					lFirst := .T.
					FWRITE(nHdlSaida,CHR(13)+CHR(10))
				EndIF
			Case SubStr(xBuffer,1,1) == CHR(4) .and.  lCnabEmail
				IF !lFirst2
					nSeq++
					lFirst2 := .T.
					FWRITE(nHdlSaida,CHR(13)+CHR(10))
				Endif
			Case SubStr(xBuffer,1,1) == CHR(3)
				nLidos+=85
				Loop
			Otherwise
				nLidos+=85
				Loop
			EndCase

			nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
			nDec := Val(SubStr(xBuffer,23,1))
			cConteudo:= SubStr(xBuffer,24,60)
			nGrava := MGFFIN4402(nTam,nDec,cConteudo,@aBordero,,.F.,@lIdCnab,cFilBor)
			If nGrava != 1
				nSeq--
				Exit
			Endif
			dbSelectArea("SE1")
			nLidos+=85
		EndDO
		If nGrava == 3
			Exit
		Endif

		If nGrava == 1
			fWrite(nHdlSaida,CHR(13)+CHR(10))

			IF !lHeader
				lHeader := .T.
			EndIF

			/*
			dbSelectArea("ZA8")

			RecLock("ZA8",.T.)
			ZA8->ZA8_FILIAL	:= xFilial("ZA8")
			ZA8->ZA8_CODREM	:= cCodRem
			ZA8->ZA8_STATUS	:= "1" // Remessa
			ZA8->ZA8_PREFIX	:= ( cAlias )->E1_PREFIXO
			ZA8->ZA8_NUM	:= ( cAlias )->E1_NUM
			ZA8->ZA8_PARCEL	:= ( cAlias )->E1_PARCELA
			ZA8->ZA8_TIPO	:= ( cAlias )->E1_TIPO
			ZA8->ZA8_VENCRE	:= STOD( ( cAlias )->E1_VENCREA )
			ZA8->ZA8_VALOR	:= ( cAlias )->E1_VALOR
			ZA8->ZA8_BANCO	:= ( cAlias )->E1_PORTADO
			ZA8->ZA8_AGENCI	:= ( cAlias )->E1_AGEDEP
			ZA8->ZA8_CONTA	:= ( cAlias )->E1_CONTA
			If IsInCallStack("U_MGFFIN43")
				ZA8->ZA8_NUMBOR	:= ( cAlias )->E1_NUMBOR
			ElseIf IsInCallStack("U_MGFFIN45")
				ZA8->ZA8_NUMBOR	:= ( cAlias )->ZA8_CODREM
			EndIf
			ZA8->( msUnlock() )
			*/

			If lFIDC .And. nOpcA == 0

				cAliasSEA	:= GetNextAlias()

				BeginSQL Alias cAliasSEA

					SELECT SEA.R_E_C_N_O_ EA_RECNO
					FROM %table:SEA% SEA
					WHERE SEA.%notDel%
						AND EA_FILIAL = %xFilial:SEA%
						AND EA_NUMBOR = %Exp:SE1->E1_NUMBOR%
						AND EA_CART = %Exp:cCart%
						AND EA_PREFIXO = %Exp:SE1->E1_PREFIXO%
						AND EA_NUM = %Exp:SE1->E1_NUM%
						AND EA_PARCELA = %Exp:SE1->E1_PARCELA%
						AND EA_TIPO = %Exp:SE1->E1_TIPO%
						AND EA_FORNECE = %Exp:SE1->E1_CLIENTE%
						AND EA_LOJA = %Exp:SE1->E1_LOJA%
						AND EA_FILORIG = %Exp:SE1->E1_FILIAL%

				EndSQL

				aQuery := GetLastQuery()

				MemoWrit( FunName()+"-fGera-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )

				If !Empty(( cAliasSEA )->EA_RECNO) // SEA->( dbSeek( xFilial("SEA")+SE1->(E1_NUMBOR+cCart+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) ) ) //EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
					SEA->( dbGoTo( ( cAliasSEA )->EA_RECNO ) )
					RecLock("SEA",.F.)
					SEA->EA_NUMBOR	:= cNumBor
					SEA->EA_DATABOR	:= dDataBase
					SEA->EA_PORTADO := cBanco
					SEA->EA_AGEDEP	:= cAgencia
					SEA->EA_NUMCON	:= cConta
					SAE->( msUnlock() )
				EndIf
				dbSelectArea( cAliasSEA )
				dbCloseArea()

				RecLock("SE1",.F.)
				SE1->E1_NUMBOR	:= cNumBor
				SE1->E1_DATABOR	:= dDataBase
				SE1->E1_PORTADO := cBanco
				SE1->E1_AGEDEP	:= cAgencia
				SE1->E1_CONTA	:= cConta
				SE1->( msUnlock() )
				If !lNewBor
					lNewBor	:= .T.
					PutMv("MV_NUMBORR",cNumBor)
				EndIf
			ElseIf !lFIDC .And. nOpcA == 0 // Recompra
				// 03/08/2017 - Atilio - Posicionar na remessa FIDC para restaurar dados da carteira original
				aAreaZA8 := ZA8->( GetArea() )

				ZA8->( dbSetOrder(1) )
				If ZA8->( dbSeek( ZA8->ZA8_FILIAL+ZA8->ZA8_NUMBOR+ZA8->ZA8_PREFIX+ZA8->ZA8_NUM+ZA8->ZA8_PARCEL+ZA8->ZA8_TIPO ) )

					cAliasSEA	:= GetNextAlias()

					BeginSQL Alias cAliasSEA

						SELECT SEA.R_E_C_N_O_ EA_RECNO
						FROM %table:SEA% SEA
						WHERE SEA.%notDel%
							AND EA_FILIAL = %xFilial:SEA%
							AND EA_NUMBOR = %Exp:SE1->E1_NUMBOR%
							AND EA_CART = %Exp:cCart%
							AND EA_PREFIXO = %Exp:SE1->E1_PREFIXO%
							AND EA_NUM = %Exp:SE1->E1_NUM%
							AND EA_PARCELA = %Exp:SE1->E1_PARCELA%
							AND EA_TIPO = %Exp:SE1->E1_TIPO%
							AND EA_FORNECE = %Exp:SE1->E1_CLIENTE%
							AND EA_LOJA = %Exp:SE1->E1_LOJA%
							AND EA_FILORIG = %Exp:SE1->E1_FILIAL%

					EndSQL

					aQuery := GetLastQuery()

					MemoWrit( FunName()+"-fGera-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )

					If !Empty(( cAliasSEA )->EA_RECNO) // SEA->( dbSeek( xFilial("SEA")+SE1->(E1_NUMBOR+cCart+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) ) ) //EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
					//If SEA->( dbSeek( xFilial("SEA")+SE1->(E1_NUMBOR+cCart+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) ) ) //EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
						RecLock("SEA",.F.)
						SEA->EA_NUMBOR	:= ZA8->ZA8_NUMBOR
						SEA->EA_DATABOR	:= ZA8->ZA8_DATBOR
						SEA->EA_PORTADO := ZA8->ZA8_BANCO
						SEA->EA_AGEDEP	:= ZA8->ZA8_AGENCI
						SEA->EA_NUMCON	:= ZA8->ZA8_CONTA
						SAE->( msUnlock() )
					EndIf
					dbSelectArea( cAliasSEA )
					dbCloseArea()

					RecLock("SE1",.F.)
					SE1->E1_NUMBOR	:= ZA8->ZA8_NUMBOR
					SE1->E1_DATABOR	:= ZA8->ZA8_DATBOR
					SE1->E1_PORTADO := ZA8->ZA8_BANCO
					SE1->E1_AGEDEP	:= ZA8->ZA8_AGENCI
					SE1->E1_CONTA	:= ZA8->ZA8_CONTA
					SE1->( msUnlock() )

					// 30/06/2017 - Atilio - Mudar Status do titulo original para Recomprado.
					RecLock("ZA8",.F.)
					ZA8->ZA8_STATUS	:= "3"
					ZA8->( msUnlock() )

				EndIf

				ZA8->( RestArea( aAreaZA8 ) )

			EndIf
			//Gerar Bordero
			If ZA7->ZA7_TIPO == "1" // FIDC
				//aCabRem	:= {"Remessa","Prefixo","Número","Parcela","Tipo","Cliente","Loja","Nome","Vencimento","Valor"}
				aAdd( aItens , { 	ZA7->ZA7_CODREM , ( cAlias )->E1_FILIAL , ( cAlias )->E1_PREFIXO , ( cAlias )->E1_NUM, ( cAlias )->E1_PARCELA , ( cAlias )->E1_TIPO , ;
					( cAlias )->E1_CLIENTE , ( cAlias )->E1_LOJA , ( cAlias )->E1_NOMCLI , DTOC(STOD(( cAlias )->E1_EMISSAO)) , ;
					DTOC(STOD(( cAlias )->E1_VENCREA)) , Tran( ( cAlias )->E1_VALOR , PesqPict("SE1","E1_VALOR") ) } )
			Else
				//aCabRem	:= {"Remessa","Prefixo","Número","Parcela","Tipo","Cliente","Loja","Nome","Vencimento","Valor","Motivo Recompra"}
				aAdd( aItens , { 	ZA7->ZA7_CODREM , ( cAlias )->E1_FILIAL , ( cAlias )->E1_PREFIXO , ( cAlias )->E1_NUM, ( cAlias )->E1_PARCELA , ( cAlias )->E1_TIPO , ;
					( cAlias )->E1_CLIENTE , ( cAlias )->E1_LOJA , ( cAlias )->E1_NOMCLI , DTOC(STOD(( cAlias )->E1_EMISSAO)) , ;
					DTOC(STOD(( cAlias )->E1_VENCREA)) , Tran( ( cAlias )->E1_VALOR , PesqPict("SE1","E1_VALOR") ),;
					Tabela(IIF(Subs(( cAlias )->ZA8_MOTREC,1,1)=="9",cRecAut,cRecMan),( cAlias )->ZA8_MOTREC,.F.) } )
			EndIf

		Endif

		dbSelectArea("SE1")
		( cAlias )->( dbSkip() )
	Enddo

	// Se conseguiu criar o Header do arquivo, entao cria o Trailler
	If lHeadMod2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Registro Trailler                              		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSeq++
		nLidos:=0
		FSEEK(nHdlBco,0,0)
		nTamArq:=FSEEK(nHdlBco,0,2)
		FSEEK(nHdlBco,0,0)
		While nLidos <= nTamArq

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tipo qual registro foi lido                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			xBuffer:=Space(85)
			FREAD(nHdlBco,@xBuffer,85)

			IF SubStr(xBuffer,1,1) == CHR(3)
				nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
				nDec := Val(SubStr(xBuffer,23,1))
				cConteudo:= SubStr(xBuffer,24,60)
				nGrava:=MGFFIN4402( nTam,nDec,cConteudo,@aBordero,.T.,.F.,.F.,cFilBor)
			Endif
			nLidos+=85
		End

		// Se nao existir o campo que determina se deve ou nao saltar
		// a linha na gravacao do trailler do arquivo, ou se existir e
		// estiver como "1-Sim", Grava o final de linha (Chr(13)+Chr(10))
		If SEE->EE_FIMLIN == "1"
			FWRITE(nHdlSaida,CHR(13)+CHR(10))
		Endif

		dbSelectArea( cAlias )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha o arquivos utilizados                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FCLOSE(nHdlBco)
		FCLOSE(nHdlSaida)

		If nOPCA == 0
			Reclock("ZA7",.F.)
			ZA7->ZA7_DATA	:= dDataBase
			ZA7->ZA7_HORA	:= Time()
			ZA7->ZA7_STATUS := '2'
			If lFIDC
				ZA7->ZA7_NUMBOR	:= cNumBor
			EndIf
			ZA7->( msUnlock() )
		EndIf

		lCopy := CpyS2T(cPatRem+cArqRem,cPatLoc)

		U_zGeraExc(aCabRem,aItens,cArqExc,cPatRem,cPatLoc,"FIDC - Remessa "+ZA7->ZA7_CODREM)

		If !lCopy
			Aviso("FIDC - Remessa","Arquivo "+cArqRem+" não copiado para pasta "+cPatLoc+"."+CRLF+"Verifique suas permissões.",{'Ok'})
		Else
			Aviso("FIDC - Remessa","Arquivo "+cArqRem+" gerado na pasta "+cPatLoc+"."+CRLF+"Processamento terminado!",{'Ok'})
		EndIf

	Endif

	dbSelectArea( cAlias )
	dbCloseArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//RetIndex("SE1")
	//dbSetOrder(1)
	//dbClearFilter()

Return(.T.)

Static Function AbrePar(cArqRem)

	LOCAL cArqEnt	:=	IIF(ZA7->ZA7_TIPO == "1",cArqCfg,cArqCfgRec)
	Local cArqSaida
	Local cNome, cPrefNome

	If ZA7->ZA7_TIPO == "1" //IsInCallStack("U_MGFFIN43")
		cPrefNome	:= "F"
	ElseIf ZA7->ZA7_TIPO == "2" // IsInCallStack("U_MGFFIN45")
		cPrefNome	:= "R"
	Else
		cPrefNome	:= ""
	EndIf

	cNome := Right( cEmpAnt+cFilAnt , 6 )+ZA7->ZA7_CODREM+cPrefNome+Subs(DTOS(Date()),3,6)+StrTran(Time(),":")

	cArqSaida := cNome+"."+TRIM(SEE->EE_EXTEN)

	cArqRem := cArqSaida
	cArqExc := cNome+".XML"

	nHdlBco:=FOPEN(cArqEnt,0+64)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Arquivo Saida                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHdlSaida:=MSFCREATE(cPatRem+cArqSaida,0)

Return .T.

STATIC Function MGFFIN4402( nTam,nDec,cConteudo,aBordero,lTrailler,lFinCnab2,lIdCnab,cFilBor)

	Local nRetorno := 1
	Local nX       := 1
	Local oDlg, oRad, nTecla
	Local cIdCnab
	Local aGetArea := GetArea()
	Local aOrdSe1  := {}
	Local lPanelFin := IsPanelFin()
	Local cChaveID := ""

	DEFAULT lIdCnab := .F.
	DEFAULT cFilBor := xFilial("SEA")

	lTrailler := IIF( lTrailler==NIL, .F., lTrailler ) // Para imprimir o trailler
	// caso se deseje abandonar
	// a gera‡Æo do arquivo
	// de envio pela metade

	lFinCnab2 := Iif( lFinCnab2 == Nil, .F., lFinCnab2 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ O retorno podera' ser :                                  ³
	//³ 1 - Grava Ok                                             ³
	//³ 2 - Ignora bordero                                       ³
	//³ 3 - Abandona rotina                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nRetorno == 1 .or. ( lTrailler .and. nBorderos > 0 )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Analisa conteudo                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF Empty(cConteudo)
			cCampo:=Space(nTam)
		Else
			lConteudo := fa150Orig( cConteudo )
			IF !lConteudo
				RestArea(aGetArea)
				Return nRetorno
			Else
				IF ValType(xConteudo)="D"
					cCampo := GravaData(xConteudo,.F.)
				Elseif ValType(xConteudo)="N"
					cCampo:=Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
				Else
					cCampo:=Substr(xConteudo,1,nTam)
				EndIf
			EndIf
		EndIf
		If Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
			cCampo:=cCampo+Space(nTam-Len(cCampo))
		EndIf
		Fwrite( nHdlSaida,cCampo,nTam )
	EndIf

	If nX == 0
		Aadd(aBordero,Substr(SE1->E1_NUMBOR,1,6)+Str(nRetorno,1))
	EndIf

	RestArea(aGetArea)

Return nRetorno
