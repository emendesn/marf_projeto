#Include "Protheus.ch"

STATIC cCodTab	:= ""	//Codigo do Favorecido
STATIC cDesTab	:= ""	//Codigo da Loja

/*
=====================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade
Data................: 14/09/2016
Descricao / Objetivo: Filtrar Tabelas de preço conforme perfil do ususario
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Obs.................: Consulta especifica para chamada da rotina no F3 do campo
=====================================================================================
*/
User Function MGFFAT05(	xVendedor	,xCliente, xLoja, xTipoPed, lValida	)
	Local lRet			:= .T.
	Local cEstado		:= ""
	Local cDepto		:= ""
	Local cRegiao		:= ""
	Local cEspeciePed  	:= SuperGetMV("MGF_FAT16F",.F.,'TP|EX|TI|DV|RB|MI|IM|TE')  //Códigos da especie de pedido que não passarão pela regra
	Local lEspecie		:= !(M->C5_ZTIPPED $ cEspeciePed) //.T.
	Local _cUsuario		:= ""
	Local aDadosUsu		:= {}										// Armazena os dados do usuario
	Local _cNomUsr		:= cUserName
	Local lContinua 	:= .T.

	DEFAULT xVendedor	:= ""
	DEFAULT xCliente	:= ""
	DEFAULT xLoja		:= ""
	DEFAULT xTipoPed	:= ""
	DEFAULT lValida		:= .F.

	// rotina especifica de transferencia entre filiais nao deve avaliar as regras
	If IsInCallStack("U_MGFEST01")
		lContinua := .F.
	Endif

	// pedidos do EEC nao deve avaliar as regras
	If IsInCallStack("EECAP100")
		lContinua := .F.
	Endif

	// rotina especifica de prepedido
	//If IsInCallStack("U_FAT87")
	//	lContinua := .F.
	//Endif


	// rotina especifica de copia de pedidos
	If IsInCallStack("U_TSTCOPIA")
		lContinua := .F.
	Endif

	// Carga de Pedidos SFA
	If IsInCallStack("importaPedidoVenda") .OR. IsInCallStack("U_MGFFAT51") .OR. IsInCallStack("U_MGFFAT53") .or. isInCallStack("U_runFAT53") .or. isInCallStack("U_runFATA5")
		lContinua := .F.
	Endif

	// inclusão de Carga Taura
	If IsInCallStack("GravarCarga") .or. IsInCallStack("U_TAS02EECPA100") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("U_xGravarCarga") .or. IsInCallStack("U_xTAS02EECPA100")
		lContinua := .F.
	Endif

	If IsInCallStack("EECFATCP") .OR. !Empty(alltrim(M->C5_PEDEXP)) .OR. IsInCallStack("U_MGFEEC24") .OR. u_IsExport(M->C5_NUM)
		lContinua := .F.
	Endif

	// rotina de exclusao de nota de saida, desfaz fis45
	If (IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
		lContinua := .F.
	Endif

	If M->C5_TIPO == "N" .AND. EMPTY(M->C5_MDCONTR) .AND. EMPTY(M->C5_MDNUMED);
		.AND. lEspecie .AND. M->C5_TIPOCLI <> 'X';
		.and. !IsInCallStack("importaPedidoVenda") .and. !IsInCallStack("U_MGFFAT51") .and. !IsInCallStack("U_MGFFAT53") .and. !isInCallStack("U_runFAT53") .and. !isInCallStack("U_runFATA5")

		// Busca dados do usuário para saber qtos digitos usa no ANO.
		PswOrder(2)
		If PswSeek( _cNomUsr, .T. )
			aDadosUsu := PswRet() // Retorna vetor com informações do usuário
			_cUsuario:= aDadosUsu[1][1]
		EndIf


		If Empty(xVendedor)
			If IsBlind()
				Help(" ",1,'NOVENDEDOR',,'Preencha o campo código do Vendedor!',1,0)
			Else
				APMsgInfo("Preencha o campo código do Vendedor!","Atenção")
			EndIf
			lRet	:= .F.

		ElseIf Empty(xCliente) .OR. Empty(xLoja)
			If IsBlind()
				Help(" ",1,'NOCLILOJ',,'Preencha o campo Cliente/Loja!',1,0)
			Else
				APMsgInfo("Preencha o campo Cliente/Loja!","Atenção")
			EndIf
			lRet	:= .F.
		ElseIf Empty(xTipoPed)
			If IsBlind()
				Help(" ",1,'NOESPECIE',,'Preencha o campo Especie do Pedido!',1,0)
			Else
				APMsgInfo("Preencha o campo Especie do Pedido!","Atenção")
			EndIf
			lRet	:= .F.
		Endif

		//-------------------------------------------------------------------------------------
		//Busca Estado/Regiao do Cliente
		//-------------------------------------------------------------------------------------
		If lRet
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+xCliente+xLoja)
				cEstado	:= SA1->A1_EST
				cRegiao	:= SA1->A1_ZREGIAO
				If Empty(cRegiao)
					APMsgInfo("O campo região não está preenchido no cadastro do cliente !","Atenção")
					lRet	:= .F.
				ElseIf Empty(cEstado)
					APMsgInfo("O campo estado não está preenchido no cadastro do cliente !","Atenção")
					lRet	:= .F.
				Endif
			Endif
		Endif

		//-------------------------------------------------------------------------------------
		//Busca Departamento do usuário
		//-------------------------------------------------------------------------------------
		If lRet
			DbSelectArea("SZE")
			DbSetOrder(2)
			If DbSeek(xFilial("SZE")+_cUsuario)
				While SZE->ZE_FILIAL == xFilial("SZE")	.AND. SZE->ZE_USER == _cUsuario
					If Empty(cDepto)
						cDepto	:=  SZE->ZE_CODDEP
					Else
						cDepto	+= "/" + SZE->ZE_CODDEP
					Endif
					SZE->(DbSkip())
				End
			Endif
		Endif
	Endif

	If lRet .and. lContinua
		If lValida
			lRet := T05ValTab( xTipoPed, xVendedor, cDepto, xCliente, xLoja, cEstado, cRegiao, M->C5_TABELA )
		Else
			T05Cons( xTipoPed, xVendedor, cDepto, xCliente, xLoja, cEstado, cRegiao )
		Endif

	Endif

Return(lRet)

/*
========================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade
Data................: 29/09/2016
Descricao / Objetivo: Filtrar Tabelas de preço conforme perfil do ususario
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela da consulta
========================================================================================
*/
Static Function T05Cons( xTipoPed, xVendedor, xDepto, xCliente, xLoja, xEstado, xRegiao )
	Local aArea	:= GetArea()
	Local bRet := .F.

	Private nPosProd   	:= aScan(aHeader, {|x| alltrim(x[2]) == "DA0_CODTAB"})
	Private nPosMarca  	:= aScan(aHeader, {|x| alltrim(x[2]) == "DA0_DESCRI"})
	Private cTabela    	:= "" //Alltrim(&(ReadVar()))
	Private cDescri		:= ""


	bRet := FiltraZA(xTipoPed, xVendedor, xDepto, xCliente, xLoja, xEstado, xRegiao)

	RestArea( aArea )

Return(bRet)


/*
========================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade
Data................: 03/09/2016
Descricao / Objetivo: Filtrar Tabelas de preço conforme perfil do ususario
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Monta a tela
========================================================================================
*/
Static Function FiltraZA(xTipoPed, xVendedor, xDepto, xCliente, xLoja, xEstado, xRegiao)
	Local 	aArea		:= GetArea()
	Local 	oLstSB1 	:= nil
	//Local 	cAlias1		:= GetNextAlias()

	Private oDlgZZY 	:= nil
	Private _bRet 		:= .F.
	Private aDadosDA0 	:= {}

	If T05PesTab(@aDadosDA0, xTipoPed, xVendedor, xDepto, xCliente, xLoja, xEstado, xRegiao)

		//(cAlias1)->(DbGoTop())

		//Do While (cAlias1)->(!Eof())
		//	aAdd( aDadosDA0, { (cAlias1)->DA0_CODTAB, (cAlias1)->DA0_DESCRI} )
		//	(cAlias1)->(DbSkip())
		//End

		nList := aScan(aDadosDA0, {|x| alltrim(x[1]) == alltrim(cCodTab)})

		iif(nList = 0,nList := 1,nList)

		//--Montagem da Tela
		Define MsDialog oDlgZZY Title "Consulta Tabela de Preços" From 0,0 To 280, 500 Of oMainWnd Pixel

		@ 5,5 LISTBOX oLstZZY ;
		VAR lVarMat ;
		Fields HEADER "Codigo", "Descrição" ;
		SIZE 245,110 On DblClick ( ConfZZY(oLstZZY:nAt, @aDadosDA0, @_bRet) ) ;
		OF oDlgZZY PIXEL

		oLstZZY:SetArray(aDadosDA0)
		oLstZZY:nAt := nList
		oLstZZY:bLine := { || {aDadosDA0[oLstZZY:nAt,1], aDadosDA0[oLstZZY:nAt,2]}}

		DEFINE SBUTTON FROM 122,5 TYPE 1 ACTION ConfZZY(oLstZZY:nAt, @aDadosDA0, @_bRet) ENABLE OF oDlgZZY
		DEFINE SBUTTON FROM 122,40 TYPE 2 ACTION oDlgZZY:End() ENABLE OF oDlgZZY

		Activate MSDialog oDlgZZY Centered

	Endif

	//DbCloseArea(cAlias1)
	RestArea(aArea)

Return _bRet

/*
========================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade
Data................: 29/09/2016
Descricao / Objetivo: Filtrar Tabelas de preço conforme perfil do ususario
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Atribui os valores selecionados às variaveis staticas para retorno
========================================================================================
*/
Static Function ConfZZY(_nPos, aDadosDA0, _bRet)

	//cCodTab := aDadosDA0[_nPos,1]

	//aCols[n,nPosMarca] := cCodigo

	cCodTab := aDadosDA0[_nPos,1]    			//Não esquecer de alimentar essa variável quando for f3 pois ela é o retorno
	cDesTab	:= Alltrim(aDadosDA0[_nPos,2])		//Não esquecer de alimentar essa variável quando for f3 pois ela é o retorno

	_bRet := .T.

	oDlgZZY:End()

Return

/*
=====================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade
Data................: 29/09/2016
Descricao / Objetivo: Filtrar Tabelas de preço conforme perfil do ususario
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna o codigo da tabela de preco
=====================================================================================
*/
User Function FAT05Cod()

Return(cCodTab)

/*
=====================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade
Data................: 29/09/2016
Descricao / Objetivo: Filtrar Tabelas de preço conforme perfil do ususario
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Retorna a descricao da tabela de preco
=====================================================================================
*/
User Function FAT05Desc()

Return(cDesTab)

/*
=====================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade
Data................: 29/09/2016
Descricao / Objetivo: Gatilhar o preco unitario e preco base
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Utilizar o menor desconto
=====================================================================================
*/

User Function T05Desconto(xProduto, xTab, xValor, xQtde,lAlteracao,xLin)
	Local aArea			:= GetArea()
	Local cQuery		:= ""
	Local nDesc			:= 0
	Local nPosQTDVEN	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_QTDVEN"})
	Local nPosVALOR		:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_VALOR"})
	Local nPosPRCVEN	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_PRCVEN"})
	Local nPosPRUNIT	:= AScan(aHeader, {|x| alltrim(x[2]) == "C6_PRUNIT"})
	Local nUsado2 		:= Len(aHeader)
	Local nAcres		:= 0
	Local cEspeciePed  	:= SuperGetMV("MGF_FAT16F",.F.,'TP|EX|TI|DV|RB|MI|IM|TE')  //Códigos da especie de pedido que não passarão pela regra
	Local lEspecie		:= !(M->C5_ZTIPPED $ cEspeciePed) //.T.

	DEFAULT xQtde		:= 1
	DEFAULT lAlteracao	:= .F.
	DEFAULT xLin		:= n

	// rotina especifica de transferencia entre filiais nao deve avaliar as regras
	If IsInCallStack("U_MGFEST01")
		Return(xValor)
	Endif

	// pedidos do EEC nao deve avaliar as regras
	If IsInCallStack("EECAP100")
		Return(xValor)
	Endif

	// rotina especifica de copia de pedidos
	If IsInCallStack("U_TSTCOPIA")
		Return(xValor)
	Endif

	// Carga de Pedidos SFA
	If IsInCallStack("importaPedidoVenda") .OR. IsInCallStack("U_MGFFAT51") .OR. IsInCallStack("U_MGFFAT53") .or. isInCallStack("U_runFAT53") .or. isInCallStack("U_runFATA5")
		Return(xValor)
	Endif

	// inclusão de Carga Taura
	If IsInCallStack("GravarCarga") .or. IsInCallStack("U_TAS02EECPA100") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("U_xGravarCarga") .or. IsInCallStack("U_xTAS02EECPA100")
		Return(xValor)
	Endif

	// rotina de exclusao de nota de saida, desfaz fis45
	If (IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
		Return(xValor)
	Endif

	If IsInCallStack("EECFATCP") .OR. !Empty(alltrim(M->C5_PEDEXP)) .OR. IsInCallStack("U_MGFEEC24") .OR. u_IsExport(M->C5_NUM)
		Return(xValor)
	Endif

	// pedidos com C5_ZDESC > 0 não deve avaliar regras
	If M->C5_ZDESC > 0
		Return(xValor)
	Endif

	// DEVOLUCAO DE PEDIDOS DE COMPRA
	if isInCallStack("A410DEVOL")
		return xValor
	endif

	// DEVOLUCAO DE PEDIDOS DE COMPRA
	if ALTERA .AND. SC5->C5_ZTIPPED == "DV"
		return xValor
	endif

	DbSelectArea("DA1")
	DbSetOrder(1) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM
	If DbSeek(xFilial("DA1")+xTab+xProduto)
		xValor := DA1->DA1_PRCVEN

		If M->C5_TIPO <> "N" .OR. !lEspecie .OR. M->C5_TIPOCLI == 'X'
			Return(xValor)
		Endif

	Else
		xValor	:= 0

		If M->C5_TIPO <> "N" .OR. !lEspecie .OR. M->C5_TIPOCLI == 'X'
			Return(xValor)
		Endif

		If lAlteracao
			aCols[xLin,nUsado2+1] := .F.
			oGetDad:Refresh()
		Else
			If EMPTY(M->C5_MDCONTR) .AND. EMPTY(M->C5_MDNUMED) .AND. lEspecie
				APMsgInfo("Produto não encontrado na tabela de preço informada!","Atenção")
			Endif
		Endif
		//	xValor :=	SB1->B1_PRV1
	Endif

	If xValor > 0
		//---------------------------------------------------------
		//Procura o Maior desconto da tabela e joga como acrescimo
		//---------------------------------------------------------
		nAcres	:= u_T05Preco(xTab)

		If nAcres >0
			//xValor := xValor + ( xValor * ( nAcres/100) )
			xValor := xValor / ((100-nAcres)/100)

			M->C6_QTDVEN			:= xQtde
			aCols[xLin][nPosQTDVEN]	:= xQtde
			aCols[xLin][nPosVALOR]	:= xValor * xQtde
			aCols[xLin][nPosPRCVEN]	:= xValor
			aCols[xLin][nPosPRUNIT]	:= xValor
		EndIf
	Endif

	RestArea(aArea)

Return(xValor)

/*
=====================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade
Data................: 29/09/2016
Descricao / Objetivo: Valida Tabela de Preco - Valid User do Campo
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Verifica se existe tabela de preco
=====================================================================================
*/
Static Function T05ValTab( xTipoPed, xVendedor, xDepto, xCliente, xLoja, xEstado, xRegiao,xTab )
	Local 	lRet		:= .T.
	Local 	_aDados		:= {}

	If !Empty(xTab) .and. !IsInCallStack("U_runFATA5")
		lRet	:= T05ItTab(_aDados, xTipoPed, xVendedor, xDepto, xCliente, xLoja, xEstado, xRegiao, xTab)

		If !lRet
			APMsgInfo("Tabela de Preço não disponível!","Atenção")
		Endif

	Endif


Return(lRet)

/*
=====================================================================================
Programa............: MGFFAT05
Autor...............: Marcos Andrade
Data................: 29/09/2016
Descricao / Objetivo: Busca tabela de preco
Doc. Origem.........: Contrato - GAP MGFFAT06
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/

Static Function T05PesTab(aDadosDA0, xTipoPed, xVendedor, xDepto, xCliente, xLoja, xEstado, xRegiao)
	Local 	lRet		:= .F.
	Local 	cQuery		:= ""

	Local 	cAlias1

	DbSelectArea("DA0")
	DbSetOrder(1)
	DbGotop()
	While DA0->(!EOF())
		IF DA0->DA0_FILIAL == xFilial("DA0")
			if DA0->DA0_ATIVO == "1" .AND. dDataBase >= DA0->DA0_DATDE .AND. dDataBase <= DA0->DA0_DATATE
				If T05ItTab(@aDadosDA0, xTipoPed, xVendedor, xDepto, xCliente, xLoja, xEstado, xRegiao, DA0->DA0_CODTAB)
					aAdd( aDadosDA0, { DA0->DA0_CODTAB, DA0->DA0_DESCRI} )
					lRet	:= .T.
				Endif
			endif
		ENDIF
		DA0->(DbsKip())
	End
	
	//Tabela de preço deve ser fornecida pelo E-commerce
	If IsInCallStack("U_runFATA5")
		lRet := .T.
	EndIf
	
	If !lRet
		APMsgInfo( "Não encontrado nenhuma tabela de preço disponível!", "Atenção" )
	Endif

Return(lRet)

Static Function T05ItTab(aDadosDA0, xTipoPed, xVendedor, xDepto, xCliente, xLoja, xEstado, xRegiao, xTab)
	Local 	cQuery		:= ""
	Local 	lContinua	:= .T.
	Local 	cEspeciePed := SuperGetMV("MGF_FAT16F",.F.,'TP|EX|TI|DV|RB|MI|IM|TE')  //Códigos da especie de pedido que não passarão pela regra
	Local 	lEspecie	:= !(M->C5_ZTIPPED $ cEspeciePed) //.T.
	Local 	cAlias1
	local cTpPedEcom	:= allTrim( superGetMv( "MGF_PVECOM", , "EC" ) )

	//If xTipoPed <> "N"
	If M->C5_TIPO <> "N" .OR. !lEspecie .OR. M->C5_TIPOCLI == 'X' .OR. M->C5_ZTIPPED == cTpPedEcom .or. IsInCallStack("U_runFATA5")
		Return(lContinua)
	Endif
	//----------------------------------------------------------
	//Seleciona a tabela de preco por FILIAL
	//----------------------------------------------------------
	If lEspecie
		lContinua := .F. // SE A FILIAL NAO ESTIVER ASSOCIADO A TABELA DE PRECO NAO PODE SER EXIBIDA/SELECIONADA

		cAlias1	:= GetNextAlias()
		cQuery := " SELECT ZB_CODFIL FROM " +RetSQLName("SZB") +"  SZB "
		cQuery += " WHERE 	SZB.ZB_FILIAL 	= '" + xFilial("SZB") + "' "
		cQuery += " AND		SZB.ZB_CODTAB 	= '" + xTab + "' "
		cQuery += " AND 	SZB.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		If (cAlias1)->(!EOF())
			While (cAlias1)->(!EOF())
				If (cAlias1)->ZB_CODFIL == cFilAnt
					lContinua := .T.
					Exit
				Endif
				lContinua := .F.
				(cAlias1)->(DbSkip())
			End
		Endif
		DbCloseArea(cAlias1)
	Endif

	//----------------------------------------------------------
	//Seleciona a tabela de preco por VENDEDOR
	//----------------------------------------------------------
	If lEspecie .AND. lContinua
		lContinua := .F. // SE O VENDEDOR NAO ESTIVER ASSOCIADO A TABELA DE PRECO NAO PODE SER EXIBIDA/SELECIONADA

		cAlias1	:= GetNextAlias()
		cQuery := " SELECT ZC_CODVEND FROM  "+RetSQLName("SZC") +"  SZC "
		cQuery += " WHERE 	SZC.ZC_FILIAL 	= '" + xFilial("SZC") + "' "
		cQuery += " AND		SZC.ZC_CODTAB 	= '" + xTab + "' "
		cQuery += " AND 	SZC.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		If (cAlias1)->(!EOF())
			While (cAlias1)->(!EOF())
				If (cAlias1)->ZC_CODVEND == xVendedor
					lContinua := .T.
					Exit
				Endif
				lContinua := .F.
				(cAlias1)->(DbSkip())
			End
		Endif
		DbCloseArea(cAlias1)
	Endif
	//----------------------------------------------------------
	//Seleciona a tabela de preco por DEPARTAMENTO
	//----------------------------------------------------------
	If lEspecie .AND. lContinua
		cAlias1	:= GetNextAlias()
		cQuery := " SELECT ZF_CODDEP FROM " +RetSQLName("SZF") +"  SZF "
		cQuery += " WHERE 	SZF.ZF_FILIAL 	= '" + xFilial("SZF") + "' "
		cQuery += " AND		SZF.ZF_CODTAB 	= '" + xTab + "' "
		cQuery += " AND 	SZF.D_E_L_E_T_	= ' ' "

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
		If (cAlias1)->(!EOF())
			While (cAlias1)->(!EOF())
				If (cAlias1)->ZF_CODDEP $ xDepto
					lContinua := .T.
					Exit
				Endif
				lContinua := .F.
				(cAlias1)->(DbSkip())
			End
		Endif
		DbCloseArea(cAlias1)
	Endif
	//----------------------------------------------------------
	//Seleciona a tabela de preco por CLIENTE
	//----------------------------------------------------------
	If lEspecie .AND. lContinua
		cAlias1	:= GetNextAlias()
		cQuery := " SELECT ZG_CODCLI, ZG_LOJCLI FROM  "+RetSQLName("SZG") +"  SZG "
		cQuery += " WHERE 	SZG.ZG_FILIAL 	= '" + xFilial("SZG") + "' "
		cQuery += " AND		SZG.ZG_CODTAB 	= '" + xTab + "' "
		cQuery += " AND 	SZG.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		If (cAlias1)->(!EOF())
			While (cAlias1)->(!EOF())
				If ( (cAlias1)->ZG_CODCLI+(cAlias1)->ZG_LOJCLI  )== (xCliente + xLoja)
					lContinua := .T.
					Exit
				Endif
				lContinua := .F.
				(cAlias1)->(DbSkip())
			End
		Endif
		DbCloseArea(cAlias1)
	Endif
	//----------------------------------------------------------
	//Seleciona a tabela de preco por ESTADO
	//----------------------------------------------------------
	If lEspecie .AND. lContinua
		cAlias1	:= GetNextAlias()
		cQuery := " SELECT ZH_CODEST FROM "+RetSQLName("SZH") +"  SZH "
		cQuery += " WHERE 	SZH.ZH_FILIAL 	= '" + xFilial("SZH") + "' "
		cQuery += " AND		SZH.ZH_CODTAB 	= '" + xTab + "' "
		cQuery += " AND 	SZH.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		If (cAlias1)->(!EOF())
			While (cAlias1)->(!EOF())
				If  (cAlias1)->ZH_CODEST == xEstado
					lContinua := .T.
					Exit
				Endif
				lContinua := .F.
				(cAlias1)->(DbSkip())
			End
		Endif
		DbCloseArea(cAlias1)
	Endif
	//----------------------------------------------------------
	//Seleciona a tabela de preco por REGIAO
	//----------------------------------------------------------
	If lEspecie .AND. lContinua
		cAlias1	:= GetNextAlias()
		cQuery := " SELECT ZI_CODREG FROM "+RetSQLName("SZI") +"  SZI "
		cQuery += " WHERE 	SZI.ZI_FILIAL 	= '" + xFilial("SZI") + "' "
		cQuery += " AND		SZI.ZI_CODTAB 	= '" + xTab + "' "
		cQuery += " AND 	SZI.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		If (cAlias1)->(!EOF())
			While (cAlias1)->(!EOF())
				If  (cAlias1)->ZI_CODREG == xRegiao
					lContinua := .T.
					Exit
				Endif
				lContinua := .F.
				(cAlias1)->(DbSkip())
			End
		Endif
		DbCloseArea(cAlias1)
	Endif
	//----------------------------------------------------------
	//Seleciona a tabela de preco por TIPO DE PEDIDO
	//----------------------------------------------------------
	If lEspecie .AND. lContinua
		cAlias1	:= GetNextAlias()
		cQuery := " SELECT ZK_CODTPED FROM "+RetSQLName("SZK") +"  SZK "
		cQuery += " WHERE 	SZK.ZK_FILIAL 	= '" + xFilial("SZK") + "' "
		cQuery += " AND		SZK.ZK_CODTAB 	= '" + xTab + "' "
		cQuery += " AND 	SZK.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)

		If (cAlias1)->(!EOF())
			While (cAlias1)->(!EOF())
				If  (cAlias1)->ZK_CODTPED 	== xTipoPed
					lContinua := .T.
					Exit
				Endif
				lContinua := .F.
				(cAlias1)->(DbSkip())
			End
		Endif
		DbCloseArea(cAlias1)
	Endif

Return(lContinua)



User Function T05Preco(xTab)
	Local aArea			:= GetArea()
	Local cQuery		:= ""
	Local _cAlias		:= GetNextAlias()
	Local nDesc			:=0


	cQuery := " SELECT MAX(TABAUX.DESCONTO) AS DESCONTO"
	cQuery += " FROM "
	cQuery += " ( "

	cQuery += " SELECT MAX(ZL_PERDESC) AS DESCONTO "
	cQuery += " FROM "  + RetSqlName("SZL") + " SZL "
	cQuery += " WHERE SZL.ZL_FILIAL = '" 	+ xFilial("SZL") 	+ "' "
	cQuery += " AND SZL.ZL_CODTAB = '" 		+ xTab 				+ "' "
	cQuery += " AND SZL.D_E_L_E_T_= ' ' "


	cQuery += " UNION ALL

	cQuery += " SELECT MAX(ZM_PERDESC)  AS DESCONTO "
	cQuery += " FROM "  + RetSqlName("SZM") + " SZM "
	cQuery += " WHERE SZM.ZM_FILIAL = '" 	+ xFilial("SZM") 	+ "' "
	cQuery += " AND SZM.ZM_CODTAB = '" 		+ xTab 				+ "' "
	cQuery += " AND SZM.D_E_L_E_T_= ' ' "

	cQuery += " ) TABAUX "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), _cAlias)

	If !(_cAlias)->( Eof() )
		nDesc := (_cAlias)->DESCONTO
	Endif

	DbCloseArea(_cAlias)
	RestArea(aArea)

Return(nDesc)

