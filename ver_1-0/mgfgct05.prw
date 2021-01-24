#INCLUDE "protheus.ch"
/*
=====================================================================================
Programa.:              MGFGCT05
Autor....:              Roberto Sidney
Data.....:              21/09/2016
Descricao / Objetivo:   Funcao chamada através do pedido de venda para seleção do contrato para medição
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Chamada efetuada através do ponto de entrada A410CONS()
=====================================================================================
*/
User Function MGFGCT05()

	Local oButton1
	Local oButton2
	Local oButton3
	Local oButton4
	Local cGet1		:= Space(10)
	Local oSay1
	Local cFields	:= ""
	Local cAliasTMP	:= ""
	Local aHeader	:= {}
	Local cStrTran	:= ""

	Local oFont
	Private oDlg
	Private aBrowse := {}
	Private aDados	:= {}
	Private oWBrowse1
	Private aItemSel := {} 
	//Private nLenAcols := len(aCols[1])
	Private aOrgiAcols := Aclone(aCols)

	if Empty(M->C5_CLIENT)
		msgalert("Para seleção de contrato o cliente deve ser informado")
		Return(.F.)
	Endif

	cStrTran	:= "SE1."

	cFields		:= "'.F.' AS MARK, CN9.CN9_NUMERO,CN9.CN9_REVISA,CN9.CN9_DTINIC,CN9.CN9_DTFIM,CNF.CNF_NUMERO,"
	cFields		+= " CNF.CNF_NUMPLA,CNA.CNA_SALDO,CNF.CNF_VLPREV,CNF.CNF_SALDO,CNF.CNF_PARCEL,CNA.CNA_CRONOG "

	cAliasTMP	:= "SE1"

	fMontaDados(cFields , cAliasTMP , @aHeader , @aDados , cStrTran , .F.)

	DEFINE FONT oFont NAME "ARIAL" SIZE 6,15 BOLD

	DEFINE MSDIALOG oDlg TITLE "Localizador de Contrato" FROM 000, 000  TO 430, 1250 COLORS 0, 16777215 PIXEL

	@ 004 , 003 TO 212 , 622 LABEL "Seleção de Contratos" PIXEL OF oDlg
	@ 018, 008 SAY oSay1 PROMPT " Contrato:" SIZE 070, 007 OF oDlg COLORS 0, 16777215 PIXEL FONT oFont
	@ 016, 080 MSGET oGet1 VAR cGet1 SIZE 160, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 015, 250 BUTTON oButton1 PROMPT "Pesquisar" SIZE 037, 015 OF oDlg PIXEL ACTION fGeraQry(cFields , @aDados , @cGet1, oDlg , oWBrowse1)
	fWBrowse1(aHeader , @aDados , oDlg , @oWBrowse1 , .F.)
	@ 190, 495 BUTTON oButton3 PROMPT "&Confirma" SIZE 038, 20 OF oDlg PIXEL ACTION Confcn9(aDados)
	@ 190, 540 BUTTON oButton4 PROMPT "&Cancela" SIZE 038, 20 OF oDlg PIXEL ACTION  oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

	Return

	/*
	=====================================================================================
	Programa.:              fGeraQry
	Autor....:              Roberto Sidney
	Data.....:              15/09/2016
	Descricao / Objetivo:   Gera a Query para seleção dos contratos relacionados ao cliente
	Doc. Origem:            VEN03 - GAP MGFVEN03
	Solicitante:            Cliente
	Uso......:              Marfrig
	Obs......:
	=====================================================================================
	*/
	Static Function fGeraQry(	cFields		,; // String contendo os campos que serao utilizados para a query e o aHeader da MarkBrowse
	aDados		,; // Este array sera preenchido com o conteudo da Query, caso exista(m) tituluos para o codigo de barras.
	cContrato	,; // Codigo de barras para pesquisa
	oDlg		,;
	oWBrowse1 )

	Local cQuery	:= ""
	Local cFrom		:= ""
	Local cWhere	:= ""
	Local cAliasTMP	:= ""
	Local lRet		:= .F.
	Local aAreaCN9	:= {}
	Local cAliasCN9	:= ""
	Local aHeader	:= {}
	Local cStrTran	:= ""
	Local lExistCod	:= .F. // Valida se o titulo nao tem codigo de barras gravado anteriormente. Caso positivo, bloqueia a gravacao.
	Local cCodTit	:= ""
	//Local aBrowse 	:= {}
	Local cCodTmp	:= ""
	aBrowse := {}

	aAreaCN9 := CN9->(GetArea())
	cCli  := M->C5_CLIENT
	cLoja := M->C5_LOJACLI

	cQuery := ''
	cQuery:=  "SELECT DISTINCT CN9.CN9_NUMERO,CN9.CN9_REVISA,CN9.CN9_SITUAC,CN9.CN9_DTINIC,CN9.CN9_DTFIM,CNF.CNF_NUMERO,CNF.CNF_REVISA, "
	cQuery += "CNF.CNF_NUMPLA,CNF.CNF_VLPREV,CNF.CNF_SALDO,CNA.CNA_SALDO,CNF.CNF_PARCEL,CNA.CNA_CONTRA,CNA.CNA_NUMERO,CNA.CNA_CRONOG "
	cQuery += "FROM "+RetSqlName("CN9") +" CN9 "
	cQuery += "INNER JOIN "+RetSqlName("CNA") + " CNA ON CNA.CNA_CONTRA = CN9.CN9_NUMERO AND CNA.CNA_REVISA = CN9.CN9_REVISA "
	cQuery += "AND CNA.CNA_CLIENT = '"+cCli+"' AND CNA.CNA_LOJACL = '"+cLoja+"' AND CNA.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN  "+RetSqlName("CNF")+ " CNF ON CNF.CNF_CONTRA = CN9.CN9_NUMERO AND CNF.CNF_REVISA = CN9.CN9_REVISA "
	cQuery += "AND CNF.CNF_SALDO > 0 AND CNF.D_E_L_E_T_ = ' ' "
	// Situação vigente
	cQuery += "WHERE CN9.CN9_SITUAC = '05' "
	if ! Empty(alltrim(cContrato))
		cQuery += "AND CN9.CN9_NUMERO = '"+cContrato+"'"
	Endif
	cQuery += "AND CN9.D_E_L_E_T_ = ' ' "

	cAliasTMP	:= GetNextAlias()
	dbUseArea(.T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasTMP , .F. , .T.)

	lRet	:= (cAliasTMP)->(!EOF())

	If ( lRet )

		cStrTran	:= "SE1."
		lExistCod	:= fMontaDados(cFields , cAliasTMP , @aHeader , @aDados , cStrTran , .T. , @cCodTit)
		fWBrowse1(aHeader , @aDados , oDlg , oWBrowse1 , .T.) //Atualizo o browser conforme resultset gerado pela Query
		cContrato	:= Space(15)
		aBrowse	:= aClone(aDados)
		(cAliasTMP)->(dbCloseArea())
		RestArea(aAreaCN9)

	Else

		MsgAlert('Não existem contratos para o cliente informado')
		aDados	:= Array(1,15)
		cContrato	:= Space(15)
		fWBrowse1(aHeader , aDados , oDlg , oWBrowse1 , .T.)

	EndIf

Return lRet

/*
=====================================================================================
Programa.:              fWBrowse1
Autor....:              Roberto Sidney
Data.....:              21/09/2016
Descricao / Objetivo:   Atualiza o array 'aDados', que sera exibido na MarkBrowse
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fWBrowse1(aHeader , aDados , oDlg, oWBrowse1 , lAtuDados)

	Local aBrowse 	:= {}
	Local _nLA := 0
	Local nX		:= 0
	Local nY		:= 0
	Local nPosArray	:= 0
	Local oOK		:= LoadBitmap(GetResources(),"LBOK")
	Local oNO		:= LoadBitmap(GetResources(),"LBNO")

	aItemSel := {}
	For _nLA := 1 to len(aDados)
		aadd(aItemSel,.F.)
	Next _nLA

	aBrowse	:= aClone(aDados)

	If !( lAtuDados )
		// Neste caso, somente o array 'aHeader' deve ser gerado
		// Ordem dos campos contidos em 'aHeader'

		@ 035, 007 LISTBOX oWBrowse1 Fields HEADER aHeader[++nPosArray],;// lMark
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		aHeader[++nPosArray],;
		SIZE 610 , 150 OF oDlg PIXEL ColSizes 20,35,25,30,25,40,20,80,40,40,40,40,40

		oWBrowse1:SetArray(aBrowse)

		oWBrowse1:bLine := {|| {;
		If(aBrowse[oWBrowse1:nAt,01],oOK,oNO),;
		aBrowse[oWBrowse1:nAt,02],;
		aBrowse[oWBrowse1:nAt,03],;
		aBrowse[oWBrowse1:nAt,04],;
		aBrowse[oWBrowse1:nAt,05],;
		aBrowse[oWBrowse1:nAt,06],;
		aBrowse[oWBrowse1:nAt,07],;
		aBrowse[oWBrowse1:nAt,08],;
		aBrowse[oWBrowse1:nAt,09],;
		aBrowse[oWBrowse1:nAt,10],;
		aBrowse[oWBrowse1:nAt,11],;
		aBrowse[oWBrowse1:nAt,12],;
		}}
		// DoubleClick event
		oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],u_Seleclin(aDados),;
		oWBrowse1:DrawSelect()}
		oWBrowse1:Refresh()

	Else

		oWBrowse1:SetArray(aBrowse)

		oWBrowse1:bLine := {|| {;
		If(aBrowse[oWBrowse1:nAt,01],oOK,oNO),;
		aBrowse[oWBrowse1:nAt,02],;
		aBrowse[oWBrowse1:nAt,03],;
		aBrowse[oWBrowse1:nAt,04],;
		aBrowse[oWBrowse1:nAt,05],;
		aBrowse[oWBrowse1:nAt,06],;
		aBrowse[oWBrowse1:nAt,07],;
		aBrowse[oWBrowse1:nAt,08],;
		aBrowse[oWBrowse1:nAt,09],;
		aBrowse[oWBrowse1:nAt,10],;
		aBrowse[oWBrowse1:nAt,11],;
		aBrowse[oWBrowse1:nAt,12],;
		}}
		// DoubleClick event
		oWBrowse1:bLDblClick := {|| aBrowse[oWBrowse1:nAt,1] := !aBrowse[oWBrowse1:nAt,1],u_Seleclin(aDados),;
		oWBrowse1:DrawSelect()}
		oWBrowse1:Refresh()

		//EndIf
		//Endif
	Endif
	Return

	/*
	=====================================================================================
	Programa.:              fMontaDados
	Autor....:              Roberto Sidney
	Data.....:              15/09/2016
	Descricao / Objetivo:   Monta aHeader e aCols para serem exibidos na MarkBrowse
	Doc. Origem:            VEN03 - GAP MGFVEN03
	Solicitante:            Cliente
	Uso......:              Marfrig
	Obs......:
	=====================================================================================
	*/
	Static Function fMontaDados(cFields		,;	//Campos utilizados para montagem do aHeader (Utilizados para montagem da Query)
	cAliasTMP	,;	//Alias temporario utilizado pela Query
	aHeader		,; 	//Neste array, serao salvos os campos com os respectivos titulos, conforme definido em dicionario (SX3)
	aDados		,;	//Neste Array, serao retornados os dados para exibicao na markbrowse
	cStrTran	,;	//Sera utilizado para eliminar o alias temporario contido na variavel 'cFields'
	lGeraDados	,;	//Se gera o array com 'ResultSet' da Query
	cCodTit	)	//Caso o codigo de barras ja tenha sido cadastrado, retorna o titulo e informa ao usuario

	Local nLen		:= 0
	Local nReg		:= 0
	Local nY		:= 0
	Local cNameField:= ""
	Local nX		:= 0
	Local aHeadTMP	:= {}
	Local xConverte	:= NIL
	Local nPosCodBar:= 0
	Local nPosCodDig:= 0
	Local nPosCodTit:= 0
	Local lExistCod	:= .F.
	Local _nAHed :=0
	DEFAULT aHeader	:= {}


	cFieCN9 := "'.F.' AS MARK, CN9.CN9_NUMERO,CN9.CN9_REVISA,CN9.CN9_DTINIC,CN9.CN9_DTFIM"
	cFieCNF := " CNF.CNF_NUMERO,CNF.CNF_NUMPLA,CNF.CNF_VLPREV,CNF.CNF_SALDO,CNF.CNF_PARCEL"
	cFieCNA := " CNA.CNA_CRONOG,CNA.CNA_SALDO, "

	//aHeader	:= StrToKarr(StrTran(cFields , cStrTran , "") , ',')

	aHeaCN9	:= StrToKarr(StrTran(cFieCN9 , "CN9." , "") , ',')
	aHeaCNF	:= StrToKarr(StrTran(cFieCNF , "CNF." , "") , ',')
	aHeaCNA	:= StrToKarr(StrTran(cFieCNA , "CNA." , "") , ',')

	//Armazena em 'aHeader' os campos contidos em cFields, eliminando o alias gerado para query (ex.: SE1.E1_OK, e' alterado para E1_OK)
	aHeader := {}
	For _nAHed := 1 to len(aHeaCN9)
		aadd(aHeader,aHeaCN9[_nAHed])
	Next _nAHed
	For _nAHed := 1 to len(aHeaCNF)
		aadd(aHeader,aHeaCNF[_nAHed])
	Next _nAHed
	For _nAHed := 1 to len(aHeaCNA)
		aadd(aHeader,aHeaCNA[_nAHed])
	Next _nAHed


	nLen	:= Len(aHeader)

	If ( lGeraDados )

		If ( Len(aDados) > 0 )

			aDados	:= Array(1,nLen)

		EndIf

		Do While (cAliasTMP)->(!EOF())
			//Grava em aDados o conteudo do alias temporario gerado atraves da query, para exibicao na markbrowse
			++nReg

			aDados[nReg]	:= Array(nLen) // Posicao adicional criada para armazenar '.F.' (exibir no browse como desmarcado)

			For nY := 1 TO nLen

				If ( nY == 1 )

					aDados[nReg , nY] := .F.

				Else

					If !( nY == nLen )
						//A ultima posicao de 'aHeader' refere-se ao Recno, portanto, nao preencher com o titulo (conforme dicionario).

						aDados[nReg , nY] := FieldGet((cAliasTMP)->(FieldPos(AllTrim(aHeader[nY]))))

						if ( TamSx3(FieldName(FieldPos(AllTrim(aHeader[nY]))))[3] == 'N')

							xConverte	:= Transform(aDados[nReg , nY] ,"@E 999,999,999.99")



							aDados[nReg , nY]	:= xConverte

						elseif ( TamSx3(FieldName(FieldPos(AllTrim(aHeader[nY]))))[3] == 'D' )

							xConverte	:= sToD(aDados[nReg , nY])

							aDados[nReg , nY]	:= xConverte

						Endif


					EndIf

				EndIf

			Next

			(cAliasTMP)->(dbSkip())

			If ((cAliasTMP)->(!EOF()))

				AADD(aDados , {} )

			EndIf

		EndDo

	Else

		aDados	:= Array(1 , nLen)

	EndIf

	aHeadTMP	:= Array(nLen)

	For nX := 1 TO nLen
		//Substitui o conteudo de aHeader pelo titulo contido no dicionario (SX3). Ex.: E1_PREFIXO e' alterado para 'Prefixo'.

		If ( nX == 1 )

			aHeadTMP[nX] := ''

		Else

			cNameField	:= AllTrim(RetTitle(AllTrim(aHeader[nX])))

			aHeadTMP[nX] := cNameField

		EndIf

	Next nX

	aHeader	:= aClone(aHeadTMP)

Return lExistCod

/*
=====================================================================================
Programa.:              Confcn9
Autor....:              Roberto Sidney
Data.....:              21/09/2016
Descricao / Objetivo:   Reconstroi acols do pedido de venda de acordo com parcela do contrato selecionado
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function Confcn9(aDados)

	Local _nT := 0
	Local nCntFor := 0
	Local _nLinAcol := 0
	Local _nPItem	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM"	})
	Local _nPProd	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"	})
	Local _nPUM  	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_UM"		})
	Local _nPQtd    := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN"	})
	Local _nPPrcVen := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRCVEN"	})
	Local _nPValor	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_VALOR"	})
	Local _nPLocal	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_LOCAL"	})
	Local _nPTES	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"		})
	Local _nPDescri	:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_DESCRI"	})
	Local _nSel := 0
	Local _nCont := 0

	default aDados := {}

	if len(aDados) == 0
		msgalert("Nenhum item de contrato selecionado.")
		Return(.F.)
	endif

	For _nSel := 1 to len(aItemSel)
		aDados[_nSel,1]  := aItemSel[_nSel]
		if aItemSel[_nSel] = .T.
			_nCont ++
		Endif
	Next _nSel

	if _nCont > 1
		msgalert("Apenas 1 (um) item do contrato deve ser selecionado")
		Return(.F.)
	Endif


	_nT := 0
	For _nT := 1 to len(aDados)
		if aDados[_nT,1] = .T.
			//M->C5_CONTRA  := aDados[_nT,2]
			M->C5_ZMDCTR :=  aDados[_nT,2]
			M->C5_ZREVIS :=  aDados[_nT,3]
			M->C5_ZMDPLAN := aDados[_nT,7]
			M->C5_ZPARCEL := aDados[_nT,10]

			_cChaveCNB := aDados[_nT,2]+aDados[_nT,3]+aDados[_nT,7]
			_cChaveCNF := aDados[_nT,2]+aDados[_nT,3]+aDados[_nT,6]+aDados[_nT,10]
		Endif
	Next _nT

	// Apura o valora da parcela para proporcionar o item
	_nValParc := 0
	DbSelectArea("CNF")
	DbSetOrder(3)
	if CNF->(DbSeek(xFilial("CNF")+_cChaveCNF))
		_nValParc := CNF->CNF_VLPREV
	EndIF


	aItemCNB :={}
	// Atualiza Acols do pedido de venda
	DbSelectArea("CNB")
	DbSetOrder(1)
	_nITCNB := 1
	_cCNBComp := _cChaveCNB
	_cChaveCNB+= '001'
	_nTotCNB := 0
	IF CNB->(DbSeek(xFilial("CNB")+_cChaveCNB))
		While ! CNB->(EOF()) .AND. CNB->CNB_CONTRA+CNB->CNB_REVISA+CNB->CNB_NUMERO =  _cCNBComp
			AADD(aItemCNB,{strzero(_nITCNB,2),CNB->CNB_PRODUT,CNB->CNB_UM,CNB->CNB_QUANT,CNB->CNB_VLUNIT,CNB->CNB_VLTOT,'01',CNB->CNB_TS,CNB->CNB_DESCRI})
			_nITCNB ++
			_nTotCNB += CNB->CNB_VLTOT
			CNB->(DbSkip())
		Enddo
	Endif

	// Ajusta valores do item proporcional a parcela
	For _nT := 1 to len(aItemCNB)
		// Valores atuais
		_nQuant   := aItemCNB[_nT,4]
		_nValUnit := aItemCNB[_nT,5]
		_nValTot  := aItemCNB[_nT,6]

		// Apura o percentual
		_nPercVal := (_nValParc / _nTotCNB) * 100

		// Apura nova quantidade de acordo com percentual
		_nNewQuant := (_nQuant * _nPercVal) / 100
		aItemCNB[_nT,4] := _nNewQuant

		// Apura novo valor unitário
		//_nNewVunit := (_nValUnit * _nPercVal) / 100
		//aItemCNB[_nT,5] := _nNewVunit

		// Apura novo valor total
		_nNewVTot := (_nValTot * _nPercVal) / 100
		aItemCNB[_nT,6] := _nNewVTot

	Next _nT

	//	aCols := {}
	_nT := 0
	nCntFor := 0
	aBkpAcols := Aclone(aCols[1])
	aNewAcols := {}
	aCols:= {}
	if len(aItemCNB) > 1

		For _nT := 1 to len(aItemCNB)
			aadd(aCols,aBkpAcols)
		Next
		aNewAcols := aClone(aCols)

		_nLinAcol := 0
		For _nLinAcol := 1 to len(aNewAcols)
			aNewAcols[_nLinAcol,_nPItem]   := aItemCNB[_nLinAcol,1]
			aNewAcols[_nLinAcol,_nPProd]   := aItemCNB[_nLinAcol,2]
			aNewAcols[_nLinAcol,_nPUM] 	   := aItemCNB[_nLinAcol,3]
			aNewAcols[_nLinAcol,_nPQtd]    := aItemCNB[_nLinAcol,4]
			aNewAcols[_nLinAcol,_nPPrcVen] := aItemCNB[_nLinAcol,5]
			aNewAcols[_nLinAcol,_nPValor]  := aItemCNB[_nLinAcol,6]
			aNewAcols[_nLinAcol,_nPLocal]  := aItemCNB[_nLinAcol,7]
			aNewAcols[_nLinAcol,_nPTES]	   := aItemCNB[_nLinAcol,8]
			aNewAcols[_nLinAcol,_nPDescri] := aItemCNB[_nLinAcol,9]
		Next

		aCols := aClone(aNewAcols)

	Else
		// Caso não tenha itens restaura Acols originial  
		aCols :={}
		aadd(aCols,aOrgiAcols[1])
	Endif

	_nT := 0

	oDlg:End()
	GETDREFRESH()
	SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
	oGetDad:Refresh()
	A410LinOk(oGetDad)

Return(.T.)

/*
=====================================================================================
Programa.:              Seleclin
Autor....:              Roberto Sidney
Data.....:              21/09/2016
Descricao / Objetivo:   Seleciona o item no mark broase
Doc. Origem:            VEN03 - GAP MGFVEN03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function Seleclin(aDados)
	Local lMark := .T.
	nLinSel := oWBrowse1:nAt
	lSelAtu := iif(aItemSel[nLinSel] = .T.,.F.,.T.)
	aItemSel[nLinSel] := lSelAtu

Return(.T.)
