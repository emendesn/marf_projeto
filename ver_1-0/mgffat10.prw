#Include 'Protheus.ch'
#INCLUDE "rwmake.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

Static _oBrwUp
Static _oBrwDown
Static _aRegras
Static _aRegProc
Static _oDlgPric
Static _lFech
Static _cFilCab
/*
=====================================================================================
Programa............: MGFFAT10
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Aprovacao de Pedidos
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Tela de Aprovacao de Pedidos
=====================================================================================
*/
User Function MGFFAT10()

	Local aArea 	:= GetArea()
	Local cPerg		:= "MGFFAT10"
	Local lItem		:= .T.
	Local aRet		:= xMF10Reg()
	Local aRegras	:= aRet[2]

	_lFech := .F.

	If len(aRegras) > 0
		_aRegras := aClone(aRegras)
		//xMF10xFSZV()
		If Pergunte(cPerg,.t.)
			lItem     := MV_PAR01 == 1

			Processa({||U_xMF10MntBr(lItem,aRegras)},"Validando regras de aprovacao, aguarde!")
		EndIf
	ElseIf !(aRet[1])
		MSGINFO( 'Aprovador', 'Usuario nao esta vinculado a um aprovador e/ou a Regra' )
	EndIf

	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF10Reg
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Trazer as Regras que o usuario pode aprovar
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta das regras que usuario pode aprovar
=====================================================================================
*/
Static Function xMF10Reg()

	Local aArea 	:= GetArea()
	Local aRet      := {}
	Local lAprExis	:= .T.
	Local xcUser 	:= RetCodUsr() //Pega o usuario corrente
	Local cNextAlias:= GetNextAlias()
	Local cFil01    := substr(cFilAnt,1,2)

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT DISTINCT
	Substr(ZU_FILIAL,1,2) ZU_FILIAL,
	ZU_CODRGA
	FROM
	%Table:SZS% SZS,%Table:SZU% SZU
	WHERE
	SZS.%notdel% AND
	SZS.ZS_USER = %exp:xcUser% AND
	SZS.ZS_APRFAT = '1' AND
	SZU.%notdel% AND
	SZU.ZU_MSBLQL <> '1' AND
	SZU.ZU_CODAPR = SZS.ZS_CODIGO


	EndSql
	//Alert('Query funcao  xMF10Reg' + TIME())
	(cNextAlias)->(DbGoTop())

	(cNextAlias)->(DbEval( {|| AADD(aRet,{ZU_FILIAL,ZU_CODRGA})} ))

	lAprExis := (Len(aRet) > 0)

	(cNextAlias)->(DbCloseArea())

	RestArea(aArea)

Return {lAprExis,aRet}

/*
=====================================================================================
Programa............: xMF10FilCb
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Montar Filtro de Pedidos/itens que serao apresentados no browse
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Montar o Filtro do browse da parte superior
=====================================================================================
*/
Static Function xMF10FilCb(aRegra)

	Local aArea 	:= GetArea()
	Local cNextAlias:= GetNextAlias()
	Local cRet		:= ''
	Local cFil 		:= "IN ("
	Local cField	:= ''
	Local cFil01    := MV_PAR02
	Local cFil02    := MV_PAR03
	Local c2Fil		:= ''
	Local cFil03    := substr(cFilAnt,1,2)
	Local cPed01    := MV_PAR12
	Local cPed02    := MV_PAR13
	Local cEmis01   := dtos(MV_PAR04)
	Local cEmis02   := dtos(MV_PAR05)


	aEval(aRegra,{|x| cFil += "'" + Substr(xFilial('SZV',x[1]),1,2) + x[2] + "',"})

	cFil := LEFT(cFil, Len(cFil) - 1) //Retina a ultima ','

	cFil += ")"
	cFil := '%' + cFil + '%'

	If MV_PAR01 == 1
		cField	:= '%ZV_FILIAL,ZV_PEDIDO,ZV_ITEMPED%'
	Else
		cField	:= '%ZV_FILIAL,ZV_PEDIDO%'
		c2Fil 	:= "%" + "SZV.ZV_PEDIDO BETWEEN '" + cPed01 + "' AND '" + cPed02 + "'" + '%'
	EndIf

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

//	SELECT DISTINCT
//	%exp:cField%
//	FROM
//	%Table:SZV% SZV
//	WHERE
//	SZV.%notdel% AND
//	Substr(SZV.ZV_FILIAL,1,2) || SZV.ZV_CODRGA %exp:cFil% AND
//	SZV.ZV_DTAPR = '        ' AND
//	SZV.ZV_FILIAL >= %exp:cFil01% AND
//	SZV.ZV_FILIAL <= %exp:cFil02% AND
//
//
//	EndSql
	SELECT DISTINCT
	%exp:cField%
	from
	%Table:SZV% SZV
	WHERE
	SZV.ZV_FILIAL >= %exp:cFil01% AND
	SZV.ZV_FILIAL <= %exp:cFil02% AND
	SZV.%notdel% AND
	Substr(SZV.ZV_FILIAL,1,2) || SZV.ZV_CODRGA in
	(SELECT DISTINCT
	Substr(SZU.ZU_FILIAL,1,2) || SZU.ZU_CODRGA
	FROM
	%Table:SZS% SZS,%Table:SZU% SZU
	WHERE
	SZS.%notdel% AND
	SZS.ZS_USER = %exp:xcUser% AND
	SZS.ZS_APRFAT = '1' AND
	SZU.%notdel% AND
	SZU.ZU_MSBLQL <> '1' AND
	SZU.ZU_CODAPR = SZS.ZS_CODIGO
	) AND
	SZV.ZV_DTAPR = '        ' AND %exp:c2Fil% AND
	SZV.ZV_PEDIDO IN (SELECT SC5.C5_NUM from %Table:SC5% SC5
					   WHERE SC5.%notdel% AND
					   SC5.C5_FILIAL = SZV.ZV_FILIAL AND
					   SC5.C5_NUM = SZV.ZV_PEDIDO AND
					   SC5.C5_EMISSAO >= %exp:cEmis01% AND
					   SC5.C5_EMISSAO <= %exp:cEmis02% AND
					   SC5.C5_ZBLQRGA = 'B')
	EndSql

	//Alert('Query funcao  xMF10FilCb' + TIME())

	(cNextAlias)->(DbGoTop())

	If MV_PAR01 == 1
		(cNextAlias)->(DbEval( {|| cRet +=  xFilial('SC6',(cNextAlias)->ZV_FILIAL) + (cNextAlias)->(ZV_PEDIDO + ZV_ITEMPED) + '|' } ))
	Else
		(cNextAlias)->(DbEval( {|| cRet +=  xFilial('SC5',(cNextAlias)->ZV_FILIAL) + (cNextAlias)->ZV_PEDIDO + '|' } ))
	EndIf

	cRet := Left(cRet,Len(cRet) - 1)

	If MV_PAR01 == 1
		cRet := '(C6_FILIAL + C6_NUM + C6_ITEM) $ "' + cRet + '"'
	Else
		cRet := '(C5_FILIAL + C5_NUM) $ "' + cRet + '"'
	EndIF

	If Empty(cRet)
		If MV_PAR01 == 1
			cRet :=  '(C6_NUM + C6_ITEM) == "        "'
		Else
			cRet :=  '(C5_NUM) == "      "'
		EndIf
		Alert('Nao existe Pedidos para Aprovacao')
	EndIf

	(cNextAlias)->(dbCloseArea())

	RestArea(aArea)

Return cRet

Static Function xFil10RGA(aRegra)

	Local cFil := ""

	aEval(aRegra,{|x| cFil += " (SUBSTR(ZV_FILIAL,1,2) + ZV_CODRGA) == '" + Substr(xFilial('SZV',x[1]),1,2) + x[2] + "' .or."})
	cFil := LEFT(cFil,Len(cFil)-4)

Return cFil

/*
=====================================================================================
Programa............: SetBrwUp
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Seta o Browse UP na variavel statica _oBrwUp
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Seta Browse Up
=====================================================================================
*/
Static Function SetBrwUp(oBrw)
	_oBrwUp := oBrw
Return

/*
=====================================================================================
Programa............: GetBrwUp
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Retorna o Browse UP da variavel statica _oBrwUp
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Get Browse Up
=====================================================================================
*/
Static Function GetBrwUp()
Return _oBrwUp

/*
=====================================================================================
Programa............: SetBrwDown
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Seta o Browse UP na variavel statica _oBrwDown
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Seta Browse Down
=====================================================================================
*/
Static Function SetBrwDown(oBrw)
	_oBrwDown := oBrw
Return

/*
=====================================================================================
Programa............: GetBrwDown
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Retorna o Browse UP da variavel statica _oBrwDown
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Get Browse Down
=====================================================================================
*/
Static Function GetBrwDown()
Return _oBrwDown

/*
=====================================================================================
Programa............: xMF10FilZv
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Montar Filtro de regras que serao apresentado no grid de bloqueio
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Montar o Filtro do browse da parte inferior
=====================================================================================
*/
Static Function xMF10FilZv(aRegra)

	Local cFil 		:= ""
/*	Local aRegraNew := {}

	For nI := 1 to Len(aRegra)
		lAchou := .F.
		For nU := 1 to Len(aRegraNew)
			If aRegra[nI][1] == aRegraNew[nU][1] .AND. aRegra[nI][2] == aRegraNew[nU][2]
				lAchou := .T.
			Endif
		Next
		If !lAchou
			aAdd(aRegraNew,aRegra[nI])
		Endif
	Next

	for nI := 1 to len(aRegraNew)
		cFil += aRegraNew[nI,1] + aRegraNew[nI,2] + "|"
	next
	cFil := "(ZV_FILIAL + ZV_CODRGA $ '" + cFil + "') .and. Empty(ZV_DTAPR)" */
		aEval(aRegra,{|x| cFil += Substr(xFilial('SZV',x[1]),1,2) + x[2] + "|"})

		cFil := LEFT(cFil,Len(cFil)-1)

		cFil := "(Substr(ZV_FILIAL,1,2) + ZV_CODRGA $ '" + cFil + "') .and. Empty(ZV_DTAPR)"

Return cFil

/*
=====================================================================================
Programa............: xMF10PFil
Autor...............: Joni Lima
Data................: 28/10/2016
Descricao / Objetivo: Montar Filtro conforme parametros
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Montar o Filtro Conforme parametros.
=====================================================================================
*/
Static Function xMF10PFil(cxAlias)

	Local cFil	:= ''
	Local cTab	:= IIF(MV_PAR01 == 1, 'SC6','SC5')
	Local cPFld	:= Substr(cTab,2,2) + '_'
	Local cFld	:= ''

	If cxAlias == 'SC5'
		cFil += 'C5_ZBLQRGA == "B"'

		If !(Empty(MV_PAR02) .and. (MV_PAR03 ==  REPLICATE('Z',Len(SM0->M0_CODFIL)) .or. Empty(MV_PAR03) ))//Filial
			cFld := cPFld + 'FILIAL'
			cFil := IIF(!Empty(cFil), cFil + ' .and. ','')
			cFil += '(' + cFld + ' >= "' + MV_PAR02 + '" .And. ' + cFld + '<= "' + MV_PAR03 + '")'
		EndIf

		If (!Empty(MV_PAR04) .and. !Empty(MV_PAR05))//Emissao
			cFld := 'C5_EMISSAO'
			cFil := IIF(!Empty(cFil), cFil + ' .and. ','')
			cFil += '(' + cFld + ' >= sToD("' + dToS(MV_PAR04) + '") .And. ' + cFld + '<= sToD("' + dToS(MV_PAR05) + '") )'
		EndIf

		If !(Empty(MV_PAR12) .and. (MV_PAR13 ==  REPLICATE('Z',Len(SC5->C5_NUM)) .or. Empty(MV_PAR13) ))//Pedido
			cFld := 'C5_NUM'
			cFil := IIF(!Empty(cFil), cFil + ' .and. ','')
			cFil += '(' + cFld + ' >= "' + MV_PAR12 + '" .And. ' + cFld + '<= "' + MV_PAR13 + '")'
		EndIf

	EndIf
	If cxAlias == 'SC6'
		If (!Empty(MV_PAR06) .and. !Empty(MV_PAR07))//Entrega
			cFld := 'C6_ENTREG'
			cFil += '(' + cFld + ' >= sToD("' + dToS(MV_PAR06) + '") .And. ' + cFld + '<= sToD("' + dToS(MV_PAR07) + '") )'
		EndIf

		If !(Empty(MV_PAR12) .and. (MV_PAR13 ==  REPLICATE('Z',Len(SC6->C6_NUM)) .or. Empty(MV_PAR13) ))//Pedido
			cFld := 'C6_NUM'
			cFil := IIF(!Empty(cFil), cFil + ' .and. ','')
			cFil += '(' + cFld + ' >= "' + MV_PAR12 + '" .And. ' + cFld + '<= "' + MV_PAR13 + '")'
		EndIf
	EndIF

	If cxAlias == 'SA1'
		If !(Empty(MV_PAR08) .and. (MV_PAR09 ==  REPLICATE('Z',Len(SA1->A1_REGIAO)) .or. Empty(MV_PAR09) ))//Regiao
			cFld := 'A1_REGIAO'
			cFil += '(' + cFld + ' >= "' + MV_PAR08 + '" .And. ' + cFld + '<= "' + MV_PAR09 + '" )'
		EndIf
	EndIf
	If cxAlias == 'SZV'
		If !(Empty(MV_PAR10) .and. (MV_PAR11 ==  REPLICATE('Z',TamSx3('ZT_CODIGO')[1]) .or. Empty(MV_PAR11) ))//Regra
			cFld := 'ZV_CODRGA'
			cFil += '(' + cFld + ' >= "' + MV_PAR10 + '" .And. ' + cFld + '<= "' + MV_PAR11 + '")'
		EndIf
	EndIf

Return cFil

/*
=====================================================================================
Programa............: xMF10MntBr
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Montar o Browse para apresentacao dos pedidos e dos bloqueios
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Monta o browse de aprovacao.
=====================================================================================
*/
User Function xMF10MntBr(lItem,aRegras)

	Local oFWLayer    	:= Nil
	Local oDlgPrinc		:= Nil //Add AGora???
	Local oPnUp 		:= Nil
	Local oPnDown 		:= Nil
	Local oBwUp   		:= Nil
	Local oBwDown 		:= Nil
	Local oRelacSZV   	:= Nil

	Local aCoors      	:= FWGetDialogSize( oMainWnd )
	Local aFieldSZV		:= {}
	Local aFieldCab		:= {}
	Local aStruCab		:= {}

	Local cTitle    	:= 'Liberacao de Pedidos'
	Local cxAlias		:= IIF(lItem,'SC6','SC5')
	Local cxDesc		:= IIF(lItem,'Itens Pedidos','Pedidos')
	Local cFilCab		:= xFil10RGA(aRegras)//'U_xMF10xFCb()'//xMF10FilCb(aRegras)
	Local cFilQCab		:= ""
	//	Local cFilCab		:= xMF10FilCb(aRegras)
	Local cFilSZV		:= xMF10FilZv(aRegras)

	Local cFilParSC5	:= xMF10PFil(IIF(lItem,'SC6','SC5'))
	Local cFilParSA1	:= xMF10PFil('SA1')
	Local cFilParSZV	:= xMF10PFil('SZV')

	Local cFldMark		:= ''

	Local nPos			:= 0

	cFilQCab := StrTran( cFilCab, "+", "||" )
	cFilQCab := StrTran( cFilQCab, ".or.", "OR" )
	cFilQCab := StrTran( cFilQCab, "==", "=" )

	//	ProcRegua(val(MV_PAR13)-val(MV_PAR12))
	ProcRegua(0)
	//u_xFilterFat10(cxAlias)
	_aRegProc := {}

	AADD(aFieldSZV,'ZV_PEDIDO')
	AADD(aFieldSZV,'ZV_ITEMPED')
	AADD(aFieldSZV,'ZV_CODRGA')
	AADD(aFieldSZV,'ZV_DESRGA')
	AADD(aFieldSZV,'ZV_DTBLQ')
	AADD(aFieldSZV,'ZV_HRBLQ')
	AADD(aFieldSZV,'ZV_CODRJC')
	AADD(aFieldSZV,'ZV_NOMRJC')
	AADD(aFieldSZV,'ZV_DTRJC')
	AADD(aFieldSZV,'ZV_HRRJC')

	//If RIGHT(cFilCab,3) <> '  "'
	xMF10StrCa(@aStruCab)

	If lItem
		AADD(aFieldCab,'C6_FILIAL')
		AADD(aFieldCab,'C6_NUM')
		AADD(aFieldCab,'C6_ITEM')
		AADD(aFieldCab,'C6_CLI')
		AADD(aFieldCab,'C6_LOJA')

		/*AADD(aFieldCab,'C6_PRODUTO')
		AADD(aFieldCab,'C6_DESCRI')
		AADD(aFieldCab,'C6_UM')
		AADD(aFieldCab,'C6_QTDVEN')
		AADD(aFieldCab,'C6_PRCVEN')
		AADD(aFieldCab,'C6_VALOR')*/
		cFldMark := 'C6_ZMARK'
	Else
		AADD(aFieldCab,'C5_FILIAL')
		AADD(aFieldCab,'C5_NUM')
		AADD(aFieldCab,'C5_ZTIPPED')
		AADD(aFieldCab,'C5_CLIENTE')
		AADD(aFieldCab,'C5_LOJACLI')
		AADD(aFieldCab,'C5_CONDPAG')
		//AADD(aFieldCab,'C5_EMISSAO')
		cFldMark := 'C5_ZMARK'
	EndIf

	Define MsDialog oDlgPrinc Title cTitle From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	// Cria o conteiner onde serao colocados os browses
	oFWLayer:= FWLayer():New()
	oFWLayer:Init( oDlgPrinc, .F., .T. )

	// Define Painel Superior
	oFWLayer:AddLine( 'LINUP', 50, .F. )              // Cria uma 'linha' com 50% da tela.
	oFWLayer:AddCollumn( 'COLUP' , 100, .F., 'LINUP' )   // Na 'linha' criada cria-se uma coluna com 100% do seu tamanho.

	oPnUp := oFWLayer:GetColPanel( 'COLUP', 'LINUP' ) // Criar o objeto dessa parte do container.

	// Painel Inferior
	oFWLayer:AddLine( 'LINDOWN', 50, .F. )                    // Cria uma 'linha' com 50% da tela.
	oFWLayer:AddCollumn( 'COLDOWN'  , 100, .F., 'LINDOWN' )        // Na "linha" criada cria-se uma coluna com 100% de seu tamanho.

	oPnDown := oFWLayer:GetColPanel( 'COLDOWN', 'LINDOWN' ) // Criar o objeto dessa parte do container.

	// 1. FWmBrowse Superior
	oBwUp := FwMarkBrowse( ):New( )
	oBwUp:SetOwner( oPnUp )        // Aqui se associa o browse ao componente de tela superior.
	oBwUp:SetDescription( cxDesc ) // 'Bilhetes'
	oBwUp:SetAlias( cxAlias )
	oBwUp:SetFieldMark( cFldMark )
	oBwUp:SetMenuDef( 'MGFFAT10' )     // Define de onde virao os botoes deste browse
	oBwUp:SetFields( aStruCab )
	oBwUp:SetOnlyFields( aFieldCab )
	oBwUp:SetProfileID( '1' )        // Identificador (ID) para o Browse
	oBwUp:DisableDetails( )
	oBwUp:ForceQuitButton( )          // Forca exibicao do botao [Sair]


	oBwUp:AddFilter( 'Filtro Par Cab',cFilParSC5,.T.,.T.,IIF( lItem,'SC6','SC5' ) )
	oBwUp:AddFilter( 'Filtro Par Cli',cFilParSA1,.T.,.T.,'SA1' )
	oBwUp:SetInvert( .F. )
	oBwUp:SetCustomMarkRec( {|| xMF10MkCab( cFldMark ) } )
	oBwUp:SetAllMark( {|| xMF10AMkCB( cFldMark ) } )
	oBwUp:DisableReport( )
	//oBwUp:SetIniWindow( { || u_xFilterFat10() } )
	oBwUp:Activate()

	nPos := aScan(OBWUP:OBROWSE:FWFILTER():ARELATION,{|x| Alltrim(x[2]) == "SZV" })

	If nPos > 0
		//u_xFilterFat10(oBwUp:Alias())
		oBwUp:oBrowse:FwFilter():ARELATION[nPos][1] := .T.
		oBwUp:oBrowse:FwFilter():AddLevel('Cod ADD',cFilCab,cFilQCab,,.T.,.T.,.T.,"SZV","",.F.)
		oBwUp:ExecuteFilter()
	Else
		MsgInfo("Solicite a Sustenta��o, Que inclua a Tabela SZV em seu menu","Atencao")
	EndIf

	(oBwUp:Alias())->(DbGoTop())

	// 2. FWmBrowse Baixo
	oBwDown := FwMarkBrowse( ):New( )
	oBwDown:SetOwner( oPnDown )
	oBwDown:SetDescription( 'Bloqueios' ) // 'Forma Pagamento'
	oBwDown:SetAlias( 'SZV' )
	oBwDown:SetFieldMark('ZV_MARK')
	oBwDown:SetMenuDef( '' ) 			// Referencia vazia para que nao exiba nenhum botao.
	oBwDown:SetProfileID( '2' )
	oBwDown:DisableDetails( )
	oBwDown:SetOnlyFields( aFieldSZV )
	oBwDown:AddFilter( 'Filtro Regras',cFilSZV,.T.,.T. )
	If !Empty( cFilParSZV )
		oBwDown:AddFilter( 'Filtro Param',cFilParSZV,.T.,.T. )
	EndIf
	oBwDown:SetInvert(.F.)
	oBwDown:SetCustomMarkRec( {|| xMF10MkSZV(.F.,.F.,cFldMark) } )
	oBwDown:SetAllMark( {|| xMF10AMkZV( .F.,.F.,cFldMark) } )
	oBwDown:DisableReport()

	oBwDown:AddLegend( "Empty(ZV_DTAPR).AND.Empty(ZV_DTRJC).and. ZV_CODRGA <> '000099'" , "YELLOW"  , "Bloqueado" )
	oBwDown:AddLegend( "Empty(ZV_DTAPR).AND.!Empty(ZV_DTRJC).and. ZV_CODRGA <> '000099'", "RED"	 , "Rejeitado" )

	oBwDown:AddLegend( "Empty(ZV_DTAPR) .AND. Empty(ZV_DTRJC) .and. Empty(ZV_CODPER) .and. ZV_CODRGA == '000099'", "BR_LARANJA"	 , "Bloqueado S/ Classificacao" )
	oBwDown:AddLegend( "Empty(ZV_DTAPR) .AND. Empty(ZV_DTRJC).and. !Empty(ZV_CODPER) .and. ZV_CODRGA == '000099'", "BLUE"	 , "Bloqueado C/ Classificacao" )
	oBwDown:AddLegend( "Empty(ZV_DTAPR) .AND. !Empty(ZV_DTRJC).and. !Empty(ZV_CODPER) .and. ZV_CODRGA == '000099'","BR_MARROM"	 , "Rejeitado C/ Classificacao" )

	oBwDown:Activate()

	//Cria relacionamento dos Browse
	oRelacSZV := FWBrwRelation():New()

	If lItem
//		oRelacSZV:AddRelation( oBwUp  ,oBwDown, { { 'ZV_FILIAL', 'xFilial( "SZV",SC6->C6_FILIAL )' }, {'ZV_PEDIDO','C6_NUM'},{'ZV_ITEMPED','C6_ITEM'} } )
		oRelacSZV:AddRelation( oBwUp  ,oBwDown, { { 'ZV_FILIAL', 'C6_FILIAL' }, {'ZV_PEDIDO','C6_NUM'},{'ZV_ITEMPED','C6_ITEM'} } )
	Else
//		oRelacSZV:AddRelation( oBwUp  ,oBwDown, { { 'ZV_FILIAL', 'xFilial( "SZV",SC5->C5_FILIAL )' }, {'ZV_PEDIDO','C5_NUM'} } )
		oRelacSZV:AddRelation( oBwUp  ,oBwDown, { { 'ZV_FILIAL', 'C5_FILIAL' }, {'ZV_PEDIDO','C5_NUM'} } )
	EndIf

	oRelacSZV:Activate()

	SetBrwUp(oBwUp)
	SetBrwDown(oBwDown)
	_oDlgPric := oDlgPrinc

	Activate MsDialog oDlgPrinc Center
	//EndIf

Return

/*
=====================================================================================
Programa............: xMF10AMkCB
Autor...............: Joni Lima
Data................: 11/10/2016
Descricao / Objetivo: Marcacao de todos os Registro do Browse do cabecalho
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a marcacao de todos os Registros do Browse
=====================================================================================
*/
Static Function xMF10AMkCB(cField)

	Local aRest  	:= GetArea()
	Local oBwUp		:= GetBrwUp()
	Local oBwDown	:= GetBrwDown()
	Local cAlias 	:= oBwUp:Alias()
	Local bExcRel	:= oBwUp:GetChange()

	// posiciona no primeiro registro conforme o compartilhamento da tabela
//	(cAlias)->(DbSeek((cAlias)->ZV_FILIAL))
	(cAlias)->(DbGoTop())
	Eval(bExcRel)

	While (cAlias)->(!Eof())
		xMF10MkCab(cField)  // chama a rotina de marcacao simples
		(cAlias)->(DbSkip())
		If (cAlias)->(!Eof())
			Eval(bExcRel)
		ENdIf
	EndDo

	(cAlias)->(DbGoTop())
	oBwUp:Refresh()

	RestArea(aRest)
	Eval(bExcRel)
	oBwUp:Refresh(.F.)

Return .T.
/*
=====================================================================================
Programa............: xMF10MkCab
Autor...............: Joni Lima
Data................: 11/10/2016
Descricao / Objetivo: Marcacao de Registro do Cabeaalho
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a marcacao do Browse, ja dispara e marca dos itens do bloqueio
=====================================================================================
*/
Static Function xMF10MkCab(cField)

	Local cFldMrk 	:= '  '
	Local oBwUp		:= GetBrwUp()
	Local oBwDown	:= GetBrwDown()
	Local cAlias 	:= oBwUp:Alias()

	Default cField 	:= ' '

	If !Empty(cField)
		cFldMrk := cAlias + '->' + cField
		// Verifica se o item esta sendo marcado ou desmarcado
		If ( !oBwUp:IsMark() )
			RecLock(cAlias,.F.)
			&cFldMrk  := oBwUp:Mark()
			(cAlias)->(MsUnLock())
			xMF10AMkZV(.T.,.T.,cField)
			oBwUp:Refresh()
		Else
			RecLock(cAlias,.F.)
			&cFldMrk  := '  '
			(cAlias)->(MsUnLock())
			oBwUp:Refresh()
			xMF10AMkZV(.T.,.F.,cField)
			oBwUp:Refresh()
		EndIf
	EndIf

Return .T.

/*
=====================================================================================
Programa............: xMF10AMkZV
Autor...............: Joni Lima
Data................: 11/10/2016
Descricao / Objetivo: Marcacao de todos os Registro do Browse de Bloqueio Registro
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a marcacao de todos os Registros do Browse
=====================================================================================
*/
Static Function xMF10AMkZV(lCab,lMark,cField)

	Local aRest  	:= GetArea()
	Local oBwUp		:= GetBrwUp()
	Local oBwDown	:= GetBrwDown()
	Local cAlias 	:= oBwDown:Alias()
	Local cFldMrk 	:= oBwUp:Alias() + '->' + cField
	Local cFilCorr	:= '(oBwUp:Alias())->' + Substr(cField,1,2)+'_FILIAL'
	Default lCab 	:= .F.
	Default lMark 	:= .F.

	// posiciona no primeiro registro conforme o compartilhamento da tabela
	(cAlias)->(DbSeek(xFilial(cAlias,&cFilCorr)))
//	(cAlias)->(DbSeek(xFilial(cAlias)))
//	(cAlias)->(DbSeek((cAlias)->ZV_FILIAL))
	While (cAlias)->(!Eof())
		xMF10MkSZV(lCab,lMark,cField,.T.)  // chama a rotina de marcacao simples
		(cAlias)->(DbSkip())
	EndDo

//	xMF10VMark(oBwDown,oBwUp,cFldMrk,.T.)
//	(cAlias)->(DbSeek(xFilial(cAlias)))
	(cAlias)->(DbSeek(xFilial(cAlias,&cFilCorr)))
//	(cAlias)->(DbSeek((cAlias)->ZV_FILIAL))
	xMF10VMark(oBwDown,oBwUp,cFldMrk,.T.)

	RestArea(aRest)

	If !(IsInCallStack('xMF10AMkCB'))
		oBwDown:Refresh()
		oBwUp:Refresh()
	EndIf

Return .T.

/*
=====================================================================================
Programa............: xMF10MkSZV
Autor...............: Joni Lima
Data................: 11/10/2016
Descricao / Objetivo: Marcacao de Registro
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a marcacao do Browse
=====================================================================================
*/
Static Function xMF10MkSZV(lCab,lMark,cField,lAMkZV)

	Local oBwUp		:= GetBrwUp()
	Local oBwDown	:= GetBrwDown()
	Local cAlias 	:= oBwDown:Alias()
	Local cFldMrk 	:= oBwUp:Alias() + '->' + cField
	Local cChave	:= (cAlias)->(ZV_PEDIDO) + (cAlias)->(ZV_ITEMPED)
	Local lNotMar	:= .F.
	Local nPos		:= 0

	Default lCab 	:= .F.
	Default lMark 	:= .F.
	Default lAMkZV	:= .F.

	If !(lCab)
		// Verifica se o item esta sendo marcado ou desmarcado
		lNotMar := !oBwDown:IsMark()

		RecLock(cAlias,.F.)
		(cAlias)->ZV_MARK  := IIF(lNotMar,oBwDown:Mark(),' ')
		(cAlias)->(MsUnLock())
		nPos := Ascan(_aRegProc,{|x| x[1] + x[2] + x[3] + x[4] == (cAlias)->(ZV_FILIAL + ZV_PEDIDO + ZV_ITEMPED + ZV_CODRGA)})
		If lNotMar .and. nPos == 0
			AADD(_aRegProc,{(cAlias)->ZV_FILIAL,(cAlias)->ZV_PEDIDO,(cAlias)->ZV_ITEMPED,(cAlias)->ZV_CODRGA})
		ElseIf nPos > 0
			aDel(_aRegProc,nPos)
			aSize(_aRegProc,(Len(_aRegProc) - 1))
		EndIf
		If lNotMar .and. !lAMkZV
			xMF10VMark(oBwDown,oBwUp,cFldMrk)
			oBwDown:Refresh()
		ElseIf !lNotMar .and. !lAMkZV
			RecLock(oBwUp:Alias(),.F.)
			&cFldMrk  := ' '
			(oBwUp:Alias())->(MsUnLock())
			oBwUp:Refresh()
			oBwDown:Refresh()
		EndIf
	Else
		RecLock(cAlias,.F.)
		(cAlias)->ZV_MARK  := IIF(lMark,oBwDown:Mark(),' ')
		(cAlias)->(MsUnLock())
		nPos := Ascan(_aRegProc,{|x| x[1] + x[2] + x[3] + x[4] == (cAlias)->(ZV_FILIAL + ZV_PEDIDO + ZV_ITEMPED + ZV_CODRGA)})
		If lMark .and. nPos == 0
			AADD(_aRegProc,{(cAlias)->ZV_FILIAL,(cAlias)->ZV_PEDIDO,(cAlias)->ZV_ITEMPED,(cAlias)->ZV_CODRGA})
		ElseIf nPos > 0
			aDel(_aRegProc,nPos)
			aSize(_aRegProc,(Len(_aRegProc) - 1))
		EndIf
	EndIf

Return .T.

/*
=====================================================================================
Programa............: xMF10VMark
Autor...............: Joni Lima
Data................: 11/10/2016
Descricao / Objetivo: Marcacao de Registro do Cabeaalho baseando-se nos bloqueios
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza a marcacao do Browse
=====================================================================================
*/
Static Function xMF10VMark(oBwDown,oBwUp,cFldMrk,lAlMark)

	Local cAlBrwDw 	:= oBwDown:Alias()
	Local aRest  	:= GetArea()
	Local aRestBrw	:= (cAlBrwDw)->(GetArea())
	Local lAtu		:= .T.
	Local cFilCorr	:= '(oBwUp:Alias())->' + Substr(cFldMrk,2,2)+'_FILIAL'

	Default lAlMark := .F.

	// posiciona no primeiro registro conforme o compartilhamento da tabela
//	(cAlBrwDw)->(DbSeek(xFilial(cAlBrwDw)))
	(cAlBrwDw)->(DbSeek(xFilial(cAlBrwDw,&cFilCorr)))
//	(cAlBrwDw)->(DbSeek((cAlBrwDw)->ZV_FILIAL))

	While (cAlBrwDw)->(!Eof())
		If !oBwDown:IsMark()
			lAtu := .F.
			Exit
		EndIf
		(cAlBrwDw)->(DbSkip())
	EndDo

	If lAtu
		RecLock(oBwUp:Alias(),.F.)
		&cFldMrk  := oBwUp:Mark()
		(oBwUp:Alias())->(MsUnLock())
		If !lAlMark
			oBwUp:Refresh()
//			(cAlBrwDw)->(DbSeek(xFilial(cAlBrwDw)))
			(cAlBrwDw)->(DbSeek(xFilial(cAlBrwDw,&cFilCorr)))
//			(cAlBrwDw)->(DbSeek((cAlBrwDw)->ZV_FILIAL))
		EndIf
	EndIf

	If lAlMark .and. !lAtu
		RecLock(oBwUp:Alias(),.F.)
		&cFldMrk  := ' '
		(oBwUp:Alias())->(MsUnLock())
	EndIf

	RestArea(aRestBrw)
	RestArea(aRest)

Return

/*
=====================================================================================
Programa............: MenuDef
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: MenuDef da rotina
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Menu
=====================================================================================
*/
Static Function MenuDef()

	Private	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  		 ACTION "PesqBrw"       OPERATION 1	 ACCESS 0
	ADD OPTION aRotina TITLE "Liberacao Pedidos" ACTION "U_xMF10PrLib"  OPERATION 7   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar Pedido" ACTION "U_xMF10VisPe"  OPERATION 2	 ACCESS 0
	ADD OPTION aRotina TITLE "Cons. Bloqueio" 	 ACTION "U_xMF10BlCon"  OPERATION 5	 ACCESS 0
	ADD OPTION aRotina TITLE "Posicao Cliente" 	 ACTION "U_xMF10ClCon"  OPERATION 6   ACCESS 0
	ADD OPTION aRotina TITLE "Perda" 	         ACTION "U_xMF10LcPerd"   OPERATION 7   ACCESS 0
	ADD OPTION aRotina TITLE "Rejeicao Pedidos"  ACTION "U_xMF10PrRjc"  OPERATION 8   ACCESS 0
	//ADD OPTION aRotina TITLE "TESTE NAO USAR"  ACTION "U_xTESFT10"  OPERATION 9   ACCESS 0
	/*ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.MGFFAT10" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.MGFFAT10" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    		ACTION "VIEWDEF.MGFFAT10" OPERATION MODEL_OPERATION_DELETE ACCESS 0*/

Return(aRotina)

User Function xTESFT10()

	Local cret := ""

return

/*
=====================================================================================
Programa............: xMF10StrCa
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Adiciona campos no browse Superior
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Adiciona os campos de Nome e valor no browse superior
=====================================================================================
*/
Static Function xMF10StrCa(aStruCab)

	Local lItem 	:= MV_PAR01 == 1
	//	Local cCliLoj 	:= IIF(lItem, (C6_CLI + C6_LOJA), (C5_CLIENTE + C5_LOJACLI))

	AADD(aStruCab,{RetTitle("A1_NOME") ,{||GetAdvFVal('SA1','A1_NOME',FwxFilial('SA1') + IIF(lItem, SC6->(C6_CLI + C6_LOJA), SC5->(C5_CLIENTE + C5_LOJACLI)) , 1 )} ,'C',PesqPict('SA1','A1_NOME') ,1,TamSx3('A1_NOME')[1] ,TamSx3('A1_NOME')[2]})
	AADD(aStruCab,{RetTitle("A1_ZREDE"),{||GetAdvFVal('SA1','A1_ZREDE',FwxFilial('SA1') + IIF(lItem, SC6->(C6_CLI + C6_LOJA), SC5->(C5_CLIENTE + C5_LOJACLI)) , 1 )},'C',PesqPict('SA1','A1_ZREDE'),1,TamSx3('A1_ZREDE')[1],TamSx3('A1_ZREDE')[2]})

	If !lItem
		AADD(aStruCab,{'Valor.',{||xMF10CalPd(SC5->C5_NUM)},'N',PesqPict('SC6','C6_VALOR'),1,TamSx3('C6_VALOR')[1],TamSx3('C6_VALOR')[2]})
	Else
		AADD(aStruCab,{RetTitle('C5_CONDPAG'),{||GetAdvFVal('SC5','C5_CONDPAG',FwxFilial('SC5') + SC6->C6_NUM , 1)},'C',PesqPict('SC5','C5_CONDPAG'),1,TamSx3('C5_CONDPAG')[1],TamSx3('C5_CONDPAG')[2]})
		AADD(aStruCab,{RetTitle('C5_ZTIPPED'),{||GetAdvFVal('SC5','C5_ZTIPPED',FwxFilial('SC5') + SC6->C6_NUM , 1 )},'C',PesqPict('SC5','C5_ZTIPPED'),1,TamSx3('C5_ZTIPPED')[1],TamSx3('C5_ZTIPPED')[2]})
	EndIf

Return

/*
=====================================================================================
Programa............: xMF10CalPd
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Calculo do total do Pedido
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza calculo de todos os itens do pedido
=====================================================================================
*/
Static Function xMF10CalPd(cPedido)

	local aArea 	:= GetArea()
	Local aAreaSC6	:= SC6->(GetArea())
	Local nRet 		:= 0

	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

	If SC6->(dbSeek(xFilial('SC6') + cPedido))
		SC6->(DbEval({||nRet += SC6->C6_VALOR},,{||SC6->C6_NUM == cPedido}))
	EndIf

	RestArea(aAreaSC6)
	RestArea(aArea)

Return nRet

/*
=====================================================================================
Programa............: xMF10CdBlq
Autor...............: Joni Lima
Data................: 14/10/2016
Descricao / Objetivo: Cadastra o Bloqueio do Item
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: insere na tabela SZV o Bloqueio conforme parametros.
=====================================================================================
*/
User Function xMF10CdBlq(cPedido,cItem,cReg)

	Local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	local lRet		:= .T.
	Local oModMF10	:= nil
	Local oMdlSVZ	:= nil

	DbSelectArea('SZV')
	SZV->(dbSetOrder(1))//ZV_FILIAL+ZV_PEDIDO+ZV_ITEMPED+ZV_CODRGA

	If !(SZV->(DbSeek(xFilial('SZV') + cPedido + cItem + cReg)))

		If !Empty(cPedido) .and. !Empty(cItem) .and. !Empty(cReg)

			oModMF10:= FWLoadModel( 'MGFFAT10' )
			oModMF10:SetOperation( MODEL_OPERATION_INSERT )

			If oModMF10:Activate()

				oMdlSVZ := oModMF10:GetModel('SZVMASTER')

				oMdlSVZ:SetValue('ZV_FILIAL' ,xFilial('SZV'))
				oMdlSVZ:SetValue('ZV_PEDIDO' ,cPedido		)
				oMdlSVZ:SetValue('ZV_ITEMPED',cItem			)
				oMdlSVZ:SetValue('ZV_CODRGA' ,cReg			)

				lRet := !(oModMF10:HasErrorMessage())

				If !lRet .and. IsBlind()
					Conout(OEmToAnsi(xMF10EMVC( oModMF10 )))
				EndIF

				If lRet.and.oModMF10:VldData()
					lRet := FwFormCommit(oModMF10)
					oModMF10:DeActivate()
					oModMF10:Destroy()
				Else
					If !IsBlind()
						JurShowErro( oModMF10:GetErrormessage() )
					Else
						Conout(OEmToAnsi(xMF10EMVC( oModMF10 )))
					EndIf
					lRet := .F.
				EndIf
			EndIf
		Else
			lRet := .F.
		EndIf
	Else
		If !Empty(cPedido) .and. !Empty(cItem) .and. !Empty(cReg)

			oModMF10:= FWLoadModel( 'MGFFAT10' )
			oModMF10:SetOperation( MODEL_OPERATION_UPDATE )

			If oModMF10:Activate()

				oMdlSVZ := oModMF10:GetModel('SZVMASTER')

				oMdlSVZ:SetValue('ZV_DTBLQ'  ,dDataBase						)
				oMdlSVZ:SetValue('ZV_HRBLQ'  ,LEFT(Time(),5)				)
				oMdlSVZ:LoadValue('ZV_CODAPR',SPACE(TamSx3('ZV_CODAPR')[1]) )
				oMdlSVZ:SetValue('ZV_DTAPR'  ,cToD('//')					)
				oMdlSVZ:LoadValue('ZV_HRAPR' ,SPACE(TamSx3('ZV_HRAPR')[1])	)
				oMdlSVZ:LoadValue('ZV_CODRJC',SPACE(TamSx3('ZV_CODRJC')[1])	)
				oMdlSVZ:SetValue('ZV_DTRJC'  ,cToD('//')					)
				oMdlSVZ:LoadValue('ZV_HRRJC' ,SPACE(TamSx3('ZV_HRRJC')[1])	)
				oMdlSVZ:LoadValue('ZV_CODPER',SPACE(TamSx3('ZV_CODPER')[1])	)
				oMdlSVZ:LoadValue('ZV_MOTPER',SPACE(TamSx3('ZV_MOTPER')[1])	)

				lRet := !(oModMF10:HasErrorMessage())

				If !lRet .and. IsBlind()
					Conout(OEmToAnsi(xMF10EMVC( oModMF10 )))
				EndIF

				If lRet.and.oModMF10:VldData()
					lRet := FwFormCommit(oModMF10)
					oModMF10:DeActivate()
					oModMF10:Destroy()
				Else
					If !IsBlind()
						JurShowErro( oModMF10:GetErrormessage() )
					Else
						Conout(OEmToAnsi(xMF10EMVC( oModMF10 )))
					EndIf
					lRet := .F.
				EndIf
			EndIf
		Else
			lRet := .F.
		EndIf
	EndIf

	RestArea(aAreaSZV)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMF10PrLib
Autor...............: Joni Lima
Data................: 18/10/2016
Descricao / Objetivo: Chama funcao para liberar pedidos
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza Liberacao dos pedidos
=====================================================================================
*/
User Function xMF10PrLib()
	If Len(_aRegProc) > 0
		If 	Aviso("Liberacao", "Sera Realizado a Liberacao de todos os Itens Marcados Deseja Continuar",;
		{ "Continuar", "Cancelar" }, 1) == 1
			Processa({|| xMF10AtSZV(.T.)},"Aguarde...","Processando a Liberacao...",.F.)
			If _lFech
				_oDlgPric:End()
			EndIf
		EndIf
	Else
		Alert('Nao Foi Selecionado Nenhum Registro para Liberacao')
	EndIf
Return

/*
=====================================================================================
Programa............: xMF10PrRjc
Autor...............: Joni Lima
Data................: 18/10/2016
Descricao / Objetivo: Chama funcao para rejeitar pedidos
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza Rejeicao dos pedidos
=====================================================================================
*/
User Function xMF10PrRjc()
	If Len(_aRegProc) > 0
		If 	Aviso("Rejeicao", "Sera Realizado a Rejeicao de todos os Itens Marcados Deseja Continuar",;
		{ "Continuar", "Cancelar" }, 1) == 1
			Processa({|| xMF10AtSZV(.F.)},"Aguarde...","Processando a Rejeicao...",.F.)
		EndIf
	Else
		Alert('Nao Foi Selecionado Nenhum Registro para Rejeicao')
	EndIf
Return

/*
=====================================================================================
Programa............: xMF10AtSZV
Autor...............: Joni Lima
Data................: 18/10/2016
Descricao / Objetivo: Percorre os Browse executando Liberacao do Pedido ou Rejeicao
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza Varredura dos Browses para Liberacao
=====================================================================================
*/
Static Function xMF10AtSZV(lLibera)

	Local aArea			:= GetArea()
	Local aAreaSC5		:= SC5->(GetArea())
	Local oBwUp			:= GetBrwUp()
	Local cAprav		:= POSICIONE('SZS', 2, xFilial('SZS') + RetCodUsr(),'ZS_CODIGO')
	Local cAlBrwUp 		:= oBwUp:Alias()
	Local cFilCab		:= 'U_xMF10xFCb()'
	Local bExcRel		:= oBwUp:GetChange()
	Local ni			:= 0
	Local aAux			:= {.T.,''}
	Local cMsg			:= ''
	Local lLib 			:= .F.
	Local lEnv			:= .F.

	ProcRegua(Len(_aRegProc))

	For ni := 1 to Len(_aRegProc)
		IncProc("Filial: " + _aRegProc[ni,1] + "Pedido: " + _aRegProc[ni,2] + "Item: " + _aRegProc[ni,3] )

		If _aRegProc[ni,4] == '000099'
			aAux := xMF10VerCl(_aRegProc[ni,1],_aRegProc[ni,2],_aRegProc[ni,3],_aRegProc[ni,4])
			If !aAux[1]
				cMsg += aAux[2] + CRLF
			EndIf
		EndIf

		If aAux[1]
			U_xMF10LbRj(_aRegProc[ni,2],_aRegProc[ni,3],_aRegProc[ni,4],cAprav,lLibera)
			/*If !(U_xMF10ExiB(_aRegProc[ni,1],_aRegProc[ni,2]))
			//U_xMF10LbPd(_aRegProc[ni,1],_aRegProc[ni,2])
			EndIf*/

			dbSelectArea('SC5')
			SC5->(dbSetOrder(1))//C5_FILIAL + C5_NUM
			If SC5->(dbSeek(_aRegProc[ni,1] + _aRegProc[ni,2]))

				//Liberacao do WebService
				If xLibWS()
					RecLock('SC5',.F.)
					SC5->C5_ZCONWS := 'S'
					SC5->(MsUnlock())
				EndIf

				lLib := !(U_xMF10ExiB(_aRegProc[ni,1],_aRegProc[ni,2]))

				//Realiza Liberacao ou bloqueio
				RecLock('SC5',.F.)

				If lLib //Liberacao
					lEnv := SC5->C5_ZBLQRGA <> 'L'
					SC5->C5_ZBLQRGA := 'L'
				Else
					lEnv := SC5->C5_ZBLQRGA <> 'B'
					SC5->C5_ZBLQRGA := 'B'
				EndIf

				//If lEnv //Envia Novamente. // comentado em 07/03/18 por Gresele, para forcar sempre o envio do pedido ao Taura, toda vez que o pedido for avaliado nas regras de bloqueio
				// independente de ter havido troca do status do pedido
					SC5->C5_ZLIBENV := 'S'
					SC5->C5_ZTAUREE := 'S'
				//EndIf


				SC5->(MsUnlock())
			EndIf

		EndIf

	Next ni

	If !Empty(cMsg)
		AVISO("Bloqueios sem Classificacao", cMsg, { "OK" }, 3)
	EndIf

	//cFilCab := xMF10FilCb(_aRegras)

	//If Right(cFilCab,3) <> '  "'

	//oBwUp:SetFilterDefault(cFilCab)
	oBwUp:ExecuteFilter()

	(cAlBrwUp)->(DbGoTop())
	Eval(bExcRel)

	//Else
	//_lFech := .T.
	//EndIf

	RestArea(aAreaSC5)
	RestArea(aArea)

Return

Static function xLibWS()

	local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	Local lCont		:= .T.

	dbSelectArea('SZV')
	SZV->(dbSetOrder(1))//ZV_FILIAL+ZV_PEDIDO+ZV_ITEMPED+ZV_CODRGA

	//96
	If SZV->(dbSeek(xFilial('SZV') + SC5->C5_NUM + '01' + '000096'))
		If Empty(SZV->ZV_DTAPR)
			lCont := .F.
		EndIf
	Else
		lCont := .T.
	EndIf
	//97
	If lCont
		If SZV->(dbSeek(xFilial('SZV') + SC5->C5_NUM + '01' + '000097'))
			If Empty(SZV->ZV_DTAPR)
				lCont := .F.
			EndIf
		Else
			lCont := .T.
		EndIf
	EndIf
	//98
	If lCont
		If SZV->(dbSeek(xFilial('SZV') + SC5->C5_NUM + '01' + '000098'))
			If Empty(SZV->ZV_DTAPR)
				lCont := .F.
			EndIf
		Else
			lCont := .T.
		EndIf
	EndIf

	RestArea(aAreaSZV)
	RestArea(aArea)

return lCont

/*
=====================================================================================
Programa............: xMF10VerCl
Autor...............: Joni Lima
Data................: 28/11/2016
Descricao / Objetivo: Realiza a Verificacao de classificacao de Perda
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Retorna se existe e uma descricao do problema.
=====================================================================================
*/
Static Function xMF10VerCl(cxFil,cPedido,cItem,cRegra)

	Local cRet := ''
	Local lRet := .T.

	If Empty(Posicione('SZV',1,cxFil + cPedido + cItem + cRegra,'ZV_CODPER'))
		lRet := .F.
		cRet := 'Filial: ' + cxFil + ', Pedido: ' + cPedido + ', Item: ' + cItem + ', Regra: ' + cRegra  + CRLF
		cRet += 'Bloqueio esta sem Classificacao de Perda, Favor Classificar'
	EndIf

Return {lRet,cRet}

/*
=====================================================================================
Programa............: xMF10LbRj
Autor...............: Joni Lima
Data................: 14/10/2016
Descricao / Objetivo: Realiza a liberacao do Item
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: altera a tabela SZV a aprovacao do Bloqueio
=====================================================================================
*/
User Function xMF10LbRj(cPedido,cItem,cReg,cAprav,lLib)

	Local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	local lRet		:= .T.
	Local oModMF10	:= nil
	Local oMdlSVZ	:= nil

	Default lLib := .T.

	If !Empty(cPedido) .and. !Empty(cItem) .and. !Empty(cReg)
		DbSelectArea('SZV')
		SZV->(dbSetOrder(1))//ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
		If SZV->(dbSeek(xFilial('SZV') + cPedido + cItem + cReg))

			oModMF10:= FWLoadModel( 'MGFFAT10' )
			oModMF10:SetOperation( MODEL_OPERATION_UPDATE )

			If oModMF10:Activate()

				oMdlSVZ := oModMF10:GetModel('SZVMASTER')

				If lLib
					oMdlSVZ:SetValue('ZV_CODAPR',cAprav 		)
					oMdlSVZ:SetValue('ZV_DTAPR' ,dDataBase		)
					oMdlSVZ:SetValue('ZV_HRAPR'	,LEFT(Time(),5)	)

					sfaZC5( cPedido )
				Else
					oMdlSVZ:SetValue('ZV_CODRJC',cAprav 		)
					oMdlSVZ:SetValue('ZV_DTRJC' ,dDataBase		)
					oMdlSVZ:SetValue('ZV_HRRJC'	,LEFT(Time(),5)	)
				EndIf

				If oModMF10:VldData()
					lRet := FwFormCommit(oModMF10)
					oModMF10:DeActivate()
					oModMF10:Destroy()
				Else
					JurShowErro( oModMF10:GetModel():GetErrormessage() )
					lRet := .F.
				EndIf
			EndIf
		EndIf
	Else
		lRet := .F.
	EndIf

	RestArea(aAreaSZV)
	RestArea(aArea)

Return lRet

//-----------------------------------------------------------------
// Atualiza ZC5 para retorno do Pedido na integracao do SFA
//-----------------------------------------------------------------
static function sfaZC5( cPedidoZC5 )
	local cUpdZC5 := ""

	cUpdZC5 := "UPDATE " + retSQLName("ZC5")
	cUpdZC5 += " SET "
	cUpdZC5 += "	ZC5_INTEGR = 'P'"
	cUpdZC5 += " WHERE"
	cUpdZC5 += "		ZC5_FILIAL	=	'" + xFilial("ZC5")	+ "'"
	cUpdZC5 += "	AND	ZC5_PVPROT	=	'" + cPedidoZC5		+ "'"
	cUpdZC5 += "	AND	D_E_L_E_T_	<>	'*'"

	tcSQLExec(cUpdZC5)

	// ATUALIZA PEDIDO DE VENDA - SC5
	cUpdZC5 := ""

	cUpdZC5 := "UPDATE " + retSQLName("SC5")
	cUpdZC5 += " SET "
	cUpdZC5 += "	C5_XINTEGR = 'P'"
	cUpdZC5 += " WHERE"
	cUpdZC5 += "		C5_FILIAL	=	'" + xFilial("SC5")	+ "'"
	cUpdZC5 += "	AND	C5_NUM		=	'" + cPedidoZC5		+ "'"
	cUpdZC5 += "	AND	D_E_L_E_T_	<>	'*'"

	tcSQLExec(cUpdZC5)
return

/*
=====================================================================================
Programa............: xMF10ExiB
Autor...............: Joni Lima
Data................: 14/10/2016
Descricao / Objetivo: Verifica se existe bloqueio nao aprovado para o pedido
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Verifica na se existe bloqueio para o pedido SZV sem Data de aprovacao
=====================================================================================
*/
User Function xMF10ExiB(cxFil,cPedido)

	Local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local lRet 		:= .F.

	Default cPedido := ''

	If !Empty(cPedido)
		dbSelectArea('SC5')
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilial('SC5',cxFil) + cPedido))
			If SC5->C5_ZCONWS == 'S' //Verifica se ja fez a consulta do Webservice
				dbSelectArea('SZV')
				SZV->(dbSetOrder(1))////ZV_FILIAL, ZV_PEDIDO, ZV_ITEMPED, ZV_CODRGA
				If SZV->(DbSeek(xFilial('SZV',cxFil) + cPedido))
					While SZV->(!Eof()).and. ( SZV->(ZV_FILIAL + ZV_PEDIDO ) == xFilial('SZV',cxFil) + cPedido )
						If Empty(SZV->ZV_DTAPR)
							lRet := .T.
							Exit
						EndIf
						SZV->(dbSkip())
					EndDo
				EndIf
			Else
				lRet := .T.
			EndIf
		Else
			lRet := .T.
		EndIf
	EndIf

	RestArea(aAreaSC5)
	RestArea(aAreaSZV)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMF10VisPe
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Rotina para visualizacao dos pedidos
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a visualizacao do pedido possicionado
=====================================================================================
*/
User Function xMF10VisPe()

	Local aArea 	:= GetArea()
	Local aAreaSC5 	:= SC5->(GetArea())
	Local aAreaSC6 	:= SC6->(GetArea())
	Local oBrwUp	:= GetBrwUp()
	Local cPerg		:= "MGFFAT10"

	private aRotina := {	{"Pesquisar","PesqBrw"		, 0 , 1 , 0 , .F.},;	// "Pesquisar"
	{"Visualizar","A410Visual"	, 0 , 2 , 0 , NIL},;	// "Visualizar"
	{"Liberar","A440Libera"		, 0 , 6 , 0 , NIL},;	// "Liberar"
	{"Automatico","A440Automa"	, 0 , 0 , 0 , NIL},;	// "Automatico"
	{"Legenda","A410Legend"		, 0 , 0 , 0 , .F.}}		// "Legenda"

	If MV_PAR01 == 1	//visualizacao por item
		dbSelectArea('SC5')
		SC5->(dbSetOrder(1))//C5_FILIAL, C5_NUM
		If SC5->(dbSeek(xFilial('SC5') + SC6->C6_NUM))
			A410Visual('SC5',SC5->(RecNO()),2)
		EndIf
	Else //visualizacao por pedido
		A410Visual('SC5',SC5->(RecNO()),2)
	EndIf

	PERGUNTE(cPerg,.F.)
	oBrwUp:ExecuteFilter()

	RestArea(aAreaSC6)
	RestArea(aAreaSC5)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF10ConBl
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Chama rotina para visualizacao dos bloqueios
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a visualizacao dos bloqueios existenste no item do pedido ou pedido
=====================================================================================
*/
User Function xMF10BlCon()

	Local lItem		:= MV_PAR01 == 1
	Local cxFil		:= IIF(lItem,SC6->C6_FILIAL,SC5->C5_FILIAL)
	Local cPedido	:= IIF(lItem,SC6->C6_NUM,SC5->C5_NUM)
	Local cClient	:= IIF(lItem,SC6->C6_CLI,SC5->C5_CLIENTE)
	Local cLojCli   := IIF(lItem,SC6->C6_LOJA,SC5->C5_LOJACLI)
	Local cPerg		:= "MGFFAT10"
	Local oBrwUp	:= GetBrwUp()

	U_MGFFAT12(lItem,cxFil,cPedido,cClient,cLojCli)

	PERGUNTE(cPerg,.F.)
	oBrwUp:ExecuteFilter()

Return

/*
=====================================================================================
Programa............: xMF10ClCon
Autor...............: Joni Lima
Data................: 10/10/2016
Descricao / Objetivo: Chama rotina de posicao do Cliente
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a visualizacao das consultas dos clientes
=====================================================================================
*/
User Function xMF10ClCon()

	Local aArea		:= GetArea()
	Local aAreaSA1	:= SA1->(GetArea())
	Local lItem		:= MV_PAR01 == 1
	Local cPedido	:= IIF(lItem,SC6->C6_NUM,SC5->C5_NUM)
	Local cPerg		:= "MGFFAT10"
	Local cCliLoj	:= ''
	Local oBrwUp	:= GetBrwUp()

	Private aRotina := {	{"Pesquisar","PesqBrw"		, 0 , 1 , 0 , .F.},;	// "Pesquisar"
	{"Visualizar","A410Visual"	, 0 , 2 , 0 , NIL},;	// "Visualizar"
	{"Liberar","A440Libera"		, 0 , 6 , 0 , NIL},;	// "Liberar"
	{"Automatico","A440Automa"	, 0 , 0 , 0 , NIL},;	// "Automatico"
	{"Legenda","A410Legend"		, 0 , 0 , 0 , .F.}}		// "Legenda"

	dbSelectArea('SA1')
	SA1->(dbSetOrder(1))//A1_FILIAL, A1_COD, A1_LOJA

	If lItem
		cCliLoj := SC6->C6_CLI + SC6->C6_LOJA
	Else
		cCliLoj := SC5->C5_CLIENTE + SC5->C5_LOJACLI
	EndIf

	If SA1->(DbSeek(xFilial('SA1') + cCliLoj ))
		a450F4Con()
		PERGUNTE(cPerg,.F.)
		oBrwUp:ExecuteFilter()
	EndIf

	RestArea(aAreaSA1)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF10JAllR
Autor...............: Joni Lima
Data................: 17/10/2016
Descricao / Objetivo: Executa todos as Regras para um Pedido de Venda em outra thread ,
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza todas as regras para o Pedido em uma outra thread.
=====================================================================================
*/
User Function xMF10JAllR(cPedido,aRegra,cEmp,cFil,cModulo)

	Local lPrepEnv  := ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )
	Local aInfo		:= {}
	Local ni		:= 0
	Local bError := ErrorBlock( { |oError| MyError( oError ) } )

	If ( lPrepEnv )
		RpcSetType( 3 )
		PREPARE ENVIRONMENT EMPRESA( cEmp ) FILIAL ( cFil ) MODULO ( cModulo ) TABLES "SA1", "SB1", "SC5", "SC6", "SF4", "SZT", "SZV", "SZU", "SE1", "SDE"
	EndIf

	BEGIN SEQUENCE

		Conout('Iniciou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME() + ' Modulo: ' + IIF(Valtype(cModulo)=='C',cModulo,''))
		U_xMF10AllRg(cPedido,aRegra)
		Conout('Terminou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME())

		RECOVER
		Conout('Deu Problema na Execucao' + ' Horas: ' + TIME() )
	END SEQUENCE

	ErrorBlock( bError )

	If ( lPrepEnv )
		RESET ENVIRONMENT
	EndIF

Return .T.

Static Function MyError(oError )
	Conout( oError:Description + "Deu Erro" )
	BREAK
Return Nil

/*
=====================================================================================
Programa............: xMF10AllRg
Autor...............: Joni Lima
Data................: 17/10/2016
Descricao / Objetivo: Executa todos as Regras para um Pedido de Venda,
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza todas as regras para o Peiddo
=====================================================================================
*/
User Function xMF10AllRg(cPedido,aRegra)

	Local aArea 	:= GetArea()
	Local aAreaSZT	:= SZT->(GetArea())
	Local lCont     := .T.
	Local lFilRga	:= .F.
	Local lLib		:= .T.
	Local lEnv		:= .F.

	Local cCorFil	:= xFilial('SZT')
	Local cFilPed	:= xFilial('SC5')

	Default cPedido := ''
	Default aRegra	:= {}

	lFilRga		:= Len(aRegra)>0

	//xMF10AtSC5(xFilial('SC5'),cPedido,'B')

	dbSelectArea('SZT')
	SZT->(dbSetOrder(1))//ZT_FILIAL+ZT_CODIGO

	If SZT->(dbSeek(cCorFil)).and. !Empty(cPedido)
		While SZT->(!EOF()).and. SZT->ZT_FILIAL == cCorFil
			IF SZT->ZT_CODIGO <> '000088' .AND. SZT->ZT_CODIGO <> '000089' // Linha incluida Carneiro 11/2017 para nao incluir as regras 88 e 89
				If SZT->ZT_MSBLQL <> '1'
					If lFilRga
						lCont := Ascan(aRegra,{|x| AllTrim(UPPER(x)) == AllTrim(UPPER(SZT->ZT_CODIGO))}) > 0
					EndIf
					If lCont
						U_xMF10ExcRg(cPedido,SZT->ZT_CODIGO)
					EndIf
				EndIf
			EndIF
			SZT->(dbSkip())
		EndDo
	EndIf

	lLib := !(U_xMF10ExiB(cFilPed,cPedido))

	dbSelectArea('SC5')
	SC5->(dbSetOrder(1))//C5_FILIAL + C5_NUM
	If SC5->(dbSeek(xFilial('SC5') + cPedido))

		RecLock('SC5',.F.)

		If lLib //Liberacao
			lEnv := SC5->C5_ZBLQRGA <> 'L'
			SC5->C5_ZBLQRGA := 'L'
		Else
			lEnv := SC5->C5_ZBLQRGA <> 'B'
			SC5->C5_ZBLQRGA := 'B'
		EndIf

		//If lEnv //Envia Novamente. // comentado em 07/03/18 por Gresele, para forcar sempre o envio do pedido ao Taura, toda vez que o pedido for avaliado nas regras de bloqueio
		// independente de ter havido troca do status do pedido
			SC5->C5_ZLIBENV := 'S'
			SC5->C5_ZTAUREE := 'S'
		//EndIf

		SC5->C5_ZCONRGA	:= 'S'

		SC5->(MsUnlock())

	EndIf
	//U_xMF10LbPd(cxFil,cPedido)
	//xMF10AtSC5(xFilial('SC5'),cPedido,'L')
	//Else
	//xMF10AtSC5(xFilial('SC5'),cPedido,'B')
	//EndIf

	RestArea(aAreaSZT)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF10AtSC5
Autor...............: Joni Lima
Data................: 28/11/2016
Descricao / Objetivo: Atualiza os Dados do Pedido de Venda
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza Atualiza��o de alguns campos do Pedido de Venda
=====================================================================================
*/
Static Function xMF10AtSC5(cxFil,cPedido,cBlqRga,cConFis,cConRGA,cConWS)

	Local aArea 	:= GetArea()
	Local aAreaSC5	:= SC5->(GetArea())
	Local cxT		:= ''

	Default cBlqRga := ''
	Default cConFis := ''
	Default cConRGA := ''
	Default cConWS  := ''

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))//C5_FILIAL, C5_NUM
	If SC5->(dbSeek(xFilial('SC5',cxFil) + cPedido ))

		If SC5->C5_ZTAURA == '2'
			cxT := '4'
		EndIf

		RecLock('SC5',.F.)

		//Flag Taura
		If !Empty(cxT)
			SC5->C5_ZTAURA 	:= cxT
		EndIf

		//Consulta Fiscal
		If !Empty(cConFis)
			SC5->C5_ZCONFIS := cConFis
		EndIf

		//Consultou Regra
		If !Empty(cConRGA)
			SC5->C5_ZCONRGA := cConFis
		EndIf

		//Consultou Web Service
		If !Empty(cConWS)
			SC5->C5_ZCONWS := cConWS
		EndIf

		//Bloqueio de Regra
		If !Empty(cBlqRga)
			If cBlqRga == 'L'
				If SC5->C5_ZCONRGA == 'S' .and. C5_ZCONWS == 'S'
					SC5->C5_ZBLQRGA := cBlqRga
					SC5->C5_ZLIBENV := 'S'
					SC5->C5_ZTAUREE := 'S'
				EndIf
			Else
				SC5->C5_ZBLQRGA := cBlqRga
				SC5->C5_ZLIBENV := 'S' // inserido em 07/03/18 por Gresele
				SC5->C5_ZTAUREE := 'S'
			EndIf
		EndIf

		//Libera Alteracao
		If SC5->C5_ZCONWS=='S' .and. SC5->C5_ZCONRGA=='S' .and. !(SC5->C5_ZTAURA $ '0|1')
			SC5->C5_ZLIBALT := 'S'
		EndIf

		SC5->(MsUnLock())

	EndIf

	RestArea(aAreaSC5)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF10ExcRg
Autor...............: Joni Lima
Data................: 17/10/2016
Descricao / Objetivo: Executa a Regra para o pedido
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a Verificacao e cadastro do bloqueio caso exista.
=====================================================================================
*/
User Function xMF10ExcRg(cPedido,cCodRga)

	Local aArea 	:= GetArea()
	Local aAreaSZT 	:= SZT->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSC6	:= SC6->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local cMsgErro	:= ''
	Local cItem		:= '01'
	Local bFunc		:= nil
	Local lBlq		:= .F.

	Default cCodRga := ''

	dbSelectArea('SZT')
	SZT->(dbSetOrder(1))//ZT_FILIAL+ZT_CODIGO

	DbSelectArea('SC5')
	SC5->(dbSetOrder(1))//C5_FILIAL+C5_NUM

	DbSelectArea('SC6')
	SC6->(dbSetOrder(1))//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO

	If (SZT->(dbSeek(xFilial('SZT') + cCodRga ))) //Posiciona na Regra
		If SZT->ZT_MSBLQL <> '1'//Verifica se Regra nao esta Bloqueada
			If SC5->(DbSeek(xFilial('SC5') + cPedido)) .and. SA1->(DbSeek(xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI)))//Posiciona no Pedido e no Cliente
				If SZT->ZT_TIPO == '1' .or. SZT->ZT_TIPO == '2'//Pedido de Venda ou Cliente
					bFunc := &('{||' + Alltrim(SZT->ZT_FUNCAO) + '}')
					lBlq := Eval(bFunc)//ExecBlock(SZT->ZT_FUNCAO,.F.,.F.)
					If ValType(lBlq) == 'L'
						If lBlq
							U_xMF10CdBlq(cPedido,'01',cCodRga)
						EndIf
					Else
						If !IsBlind()
							Alert('A Funcao da regra: ' + cCodRga + ', nao esta retornando um valor logico. favor verificar')
						Else
							Conout('A Funcao da regra: ' + cCodRga + ', nao esta retornando um valor logico. favor verificar')
						EndIf
					EndIf
				ElseIf SZT->ZT_TIPO == '3'//Produto
					If SC6->(DbSeek(xFilial('SC6') + SC5->C5_NUM)) .and. SB1->(DbSeek(xFilial('SB1') + SC6->(C6_PRODUTO)))//Posiciona no primeiro item do pedido
						While SC6->(!Eof()) .and. SC6->(C6_FILIAL + C6_NUM) == xFilial('SC6') + SC5->C5_NUM //faz a verredura de todos os itens do pedido
							bFunc := &('{||' + Alltrim(SZT->ZT_FUNCAO) + '}')
							lBlq := Eval(bFunc)
							If ValType(lBlq) == 'L'
								If lBlq
									U_xMF10CdBlq(SC6->C6_NUM,SC6->C6_ITEM,cCodRga)
								EndIf
							Else
								If !IsBlind()
									Alert('A Funcao da regra: ' + cCodRga + ', nao esta retornando um valor logico. favor verificar')
								Else
									Conout('A Funcao da regra: ' + cCodRga + ', nao esta retornando um valor logico. favor verificar')
								EndIf
							EndIf
							SC6->(DbSkip())
						EndDo
					Else
						cMsgErro := 'Nao Foi encontrado o itens para o Pedido: ' + cPedido
					EndIf
				EndIf
			Else
				cMsgErro := 'Nao Foi encontrado o Pedido: ' + cPedido
			EndIf
		Else
			cMsgErro := 'Regra: ' + cCodRga + ' encontra-se Bloqueada'
		EndIf
	Else
		cMsgErro := 'Nao Foi encontrado a Regra de Bloqueio: ' + cCodRga
	EndIf

	If !Empty(cMsgErro)
		If !IsBlind()
			Alert(cMsgErro)
		Else
			Conout(cMsgErro)
		EndIF
	EndIf

	RestArea(aAreaSB1)
	RestArea(aAreaSC6)
	RestArea(aAreaSA1)
	RestArea(aAreaSC5)
	RestArea(aAreaSZT)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF10LbCE
Autor...............: Joni Lima
Data................: 24/10/2016
Descricao / Objetivo: Realiza a Liberacao do Pedido de Venda
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a Liberacao do Pedido de Venda
=====================================================================================
*/
User Function xMF10LbPd(cxFil,cPedido)

	Local aArea 	:= GetArea()
	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSC6	:= SC6->(GetArea())

	DBSelectArea("SC5")
	SC5->(DBSetOrder(1))
	SC5->(MsSeek( xFilial("SC5",cxFil) + cPedido ))

	dbSelectArea("SC6")
	SC6->(DBSetOrder(1))
	SC6->(MsSeek( xFilial("SC6",cxFil) + cPedido ))

	While SC6->(!Eof()) .And. SC6->(C6_FILIAL + C6_NUM) == xFilial("SC6",cxFil) + cPedido
		If RecLock("SC5")
			nQtdLib  := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) )
			RecLock("SC6") //Forca a atualizacao do Buffer no Top
			Begin Transaction
				MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,.F.,.F.,.F.,.F.)
			End Transaction
		EndIf
		SC6->(MsUnLock())
		Begin Transaction
			SC6->(MaLiberOk({cPedido},.F.))
		End Transaction
		SC6->(dbSkip())
	EndDO

	xMF10LbCE(cxFil,cPedido)
	xMF10AtSC5(cxFil,cPedido,'L')

	RestArea(aAreaSC6)
	RestArea(aAreaSC5)
	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF10LbCE
Autor...............: Joni Lima
Data................: 24/10/2016
Descricao / Objetivo: Realiza a Liberacao de Credito e Estoque
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a Liberacao de Credito e Estoque
=====================================================================================
*/
Static Function xMF10LbCE(cxFil,cPedido)

	Local aArea 	:= GetArea()
	Local aAreaSC9	:= SC9->(GetArea())
	Local nTotRec	:= 0
	Local nRecSc9	:= 0
	Local bValid    := {|| SC9->(Recno()) <= nTotRec}
	Local lHelp		:= .F.

	DbSelectArea('SC9')
	SC9->(DbSetOrder(1))//C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO

	nTotRec := SC9->(LastRec())

	If SC9->(dbSeek(xFilial('SC9',cxFil) + cPedido))
		While ( !Eof() .And. SC9->C9_FILIAL == xFilial("SC9",cxFil) .And.;
		SC9->C9_PEDIDO == cPedido .And. Eval(bValid) )

			SC9->(dbSkip())
			nRecSc9 := SC9->(Recno())
			SC9->(dbSkip(-1))

			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .Or.;
			(SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .Or.;
			SC9->C9_BLCRED=="09" )

				a450Grava(1,.T.,.T.,@lHelp)
			EndIf
			SC9->(MsGoto(nRecSc9))
		EndDo
		SC9->(dbSkip())
	EndIf
	RestArea(aAreaSC9)
	RestArea(aArea)
Return

/*
=====================================================================================
Programa............: ModelDef
Autor...............: Joni Lima
Data................: 06/10/2016
Descricao / Objetivo: ModelDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao do Modelo de Dados para cadastro de Bloqueios
=====================================================================================
*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrSZV 	:= FWFormStruct(1,"SZV")

	If (IsInCallStack('U_xMF10LcPerd'))
		oStrSZV:SetProperty('*',MODEL_FIELD_WHEN,{||.F.})

		oStrSZV:SetProperty('ZV_CODPER',MODEL_FIELD_WHEN,{||.T.})
		oStrSZV:SetProperty('ZV_DESPER',MODEL_FIELD_WHEN,{||.T.})
		oStrSZV:SetProperty('ZV_MOTPER',MODEL_FIELD_WHEN,{||.T.})

	EndIf

	oModel := MPFormModel():New("XMGFFAT10", /*bPreValidacao*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SZVMASTER",/*cOwner*/,oStrSZV, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetPrimaryKey({'ZV_FILIAL','ZV_PEDIDO','ZV_ITEMPED','ZV_CODRGA'})

	oModel:SetDescription('Bloqueios')

Return(oModel)

/*
=====================================================================================
Programa............: ViewDef
Autor...............: Joni Lima
Data................: 06/10/2016
Descricao / Objetivo: ViewDef
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Definicao da visualizacao da tela
=====================================================================================
*/
Static Function Viewdef()

	Local oModel   	:= FWLoadModel( 'MGFFAT10' )
	Local oStrSZV 	:= FWFormStruct(2,"SZV")
	Local oView    	:= FWFormView():New()
	Local oStruct
	Local aCpos		:= {'ZV_FILIAL','ZV_PEDIDO','ZV_ITEMPED','ZV_CODRGA','ZV_DTBLQ','ZV_HRBLQ','ZV_CODPER','ZV_DESPER','ZV_MOTPER'}
	Local ni
	Local aAux

	If (IsInCallStack('U_xMF10LcPerd'))
		// Obtemos a estrutura de dados
		oStruct := oModel:GetModel('SZVMASTER'):GetStruct()
		aAux 	:= oStruct:GetFields()
		For ni := 1 To Len( aAux )
			If !((nPos := aScan(aCpos,{|x| AllTrim( x )== AllTrim(aAux[nI][3])}))>0)
				oStrSZV:RemoveField( aAux[nI][3] )
			EndIf
		Next ni
	EndIf

	oView:SetModel( oModel )

	oView:AddField('VIEW_SZVMAST',oStrSZV,'SZVMASTER')

	oView:CreateHorizontalBox('TELA',100)

	oView:SetOwnerView('VIEW_SZVMAST','TELA')

Return oView

/*
=====================================================================================
Programa............: xMF10SZTE
Autor...............: Joni Lima
Data................: 21/10/2016
Descricao / Objetivo: Validacao do codigo da Regra
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza Validacao
=====================================================================================
*/
User Function xMF10SZTE(oModel,cField,xValue,nLin)

	Local aArea		:= GetArea()
	Local aAreaSZT	:= SZT->(GetArea())
	Local lRet 		:= .T.

	dbSelectArea('SZT')
	SZT->(dbSetOrder(1))

	lRet := SZT->(dbSeek(xFilial('SZT') + xValue))

	RestArea(aAreaSZT)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMF10SZSE
Autor...............: Joni Lima
Data................: 21/10/2016
Descricao / Objetivo: Validacao do codigo do aprovador
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Realiza Validacao
=====================================================================================
*/
User Function xMF10SZSE(oModel,cField,xValue,nLin)

	Local aArea		:= GetArea()
	Local aAreaSZS	:= SZS->(GetArea())
	Local lRet 		:= .T.

	dbSelectArea('SZS')
	SZS->(dbSetOrder(1))

	lRet := SZS->(dbSeek(xFilial('SZS') + xValue))

	RestArea(aAreaSZS)
	RestArea(aArea)

Return lRet

/*
=====================================================================================
Programa............: xMF10EMVC
Autor...............: Joni Lima
Data................: 21/10/2016
Descricao / Objetivo: Monta string de erro
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Monta a String de erro
=====================================================================================
*/
Static Function xMF10EMVC( ObjMVC )

	Local aErro := {}
	Local cRet	:= ''

	DEFAULT ObjMVC := nil

	If ValType(ObjMVC) == 'O'
		aErro := ObjMVC:GetErrorMessage()
		If Len(aErro) > 0
			cRet +=  '[' + AllToChar( aErro[MODEL_MSGERR_IDFORMERR] ) + ']' + CRLF
			cRet +=  '[' + AllToChar( aErro[MODEL_MSGERR_IDFIELDERR] ) + ']' + CRLF
			cRet +=  '[' + AllToChar( aErro[MODEL_MSGERR_ID] ) + ']' + CRLF
			cRet +=  '[' + AllToChar( aErro[MODEL_MSGERR_MESSAGE] ) + '|' + AllToChar( aErro[MODEL_MSGERR_SOLUCTION] ) + ']'
		EndIf
	EndIf

Return cRet

/*
=====================================================================================
Programa............: xMF10LcPerd
Autor...............: Joni Lima
Data................: 29/10/2016
Descricao / Objetivo: Abre a tela de perda para classificacao
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Faz a chamada da tela de classificacao de perda
=====================================================================================
*/
User Function xMF10LcPerd()

	Local aArea 	:= GetArea()
	Local aAreaSZV	:= SZV->(GetArea())
	Local aButtons 	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

	Local oBwDown	:= GetBrwDown()
	Local cAliasSZV	:= oBwDown:Alias()

	Local nRecSZV 	:= (cAliasSZV)->(Recno())

	If (cAliasSZV)->ZV_CODRGA == '000099'
		If SZV->(dbGoto(nRecSZV))
			FWExecView("Adicionar Tipo de Perda", "MGFFAT10", MODEL_OPERATION_UPDATE,, {|| .T.}, , ,aButtons)	//"Alteracao"
		EndIf
	Else
		Help(" ",1,"Perda",,"Vinculo de Perda apenas para Regra '000099' ",1,0)
	EndIf

	RestArea(aArea)

Return

/*
=====================================================================================
Programa............: xMF10xFCb
Autor...............: Joni Lima
Data................: 29/10/2016
Descricao / Objetivo: Abre a tela de aprovacao de pedido
Doc. Origem.........: Contrato - GAP FAT14
Solicitante.........: Cliente
Uso.................: 
Obs.................: Filtro da parte superior
=====================================================================================
*/
User Function xMF10xFCb()

	Local aArea 	:= GetArea()
	Local aRegra	:= _aRegras
	Local xcUser 	:= RetCodUsr()

	Local cNextAlias:= GetNextAlias()
	Local cRet		:= ''
	Local cFil 		:= "IN ("
	Local c2Fil		:= ''
	Local cField	:= ''

	Local lRet		:= .F.
	Local cFil01    := MV_PAR02
	Local cFil02    := MV_PAR03
	Local cFil03    := substr(cFilAnt,1,2)
	Local cPed01    := MV_PAR12
	Local cPed02    := MV_PAR13
	Local cEmis01   := dtos(MV_PAR04)
	Local cEmis02   := dtos(MV_PAR05)

//	aEval(aRegra,{|x| cFil += "'" + Substr(xFilial('SZV',x[1]),1,2) + x[2] + "',"})
//
//	cFil := LEFT(cFil, Len(cFil) - 1) //Retina a ultima ','
//
//	cFil += ")"
//	cFil := '%' + cFil + '%'

	If MV_PAR01 == 1
		cField	:= '%ZV_FILIAL,ZV_PEDIDO,ZV_ITEMPED%'
		c2Fil 	:= '%' + "SZV.ZV_PEDIDO || SZV.ZV_ITEMPED = '" + SC6->(C6_NUM+C6_ITEM) + "'" + '%'
	Else
		cField	:= '%ZV_FILIAL,ZV_PEDIDO%'
//		c2Fil 	:= "%" + "SZV.ZV_PEDIDO = '" + SC5->C5_NUM + "'" + '%'
		c2Fil 	:= "%" + "SZV.ZV_PEDIDO BETWEEN '" + cPed01 + "' AND '" + cPed02 + "'" + '%'
	EndIf

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias
	SELECT DISTINCT
	%exp:cField%
	from
	%Table:SZV% SZV, %Table:SC5% SC5
	WHERE
    SZV.ZV_PEDIDO = SC5.C5_NUM AND
    SZV.ZV_FILIAL = SC5.C5_FILIAL AND
	SZV.ZV_FILIAL >= %exp:cFil01% AND
	SZV.ZV_FILIAL <= %exp:cFil02% AND
	%exp:c2Fil% AND
    SC5.C5_EMISSAO >= %exp:cEmis01% AND
    SC5.C5_EMISSAO <= %exp:cEmis02% AND
	SC5.C5_ZBLQRGA = 'B' AND
	SC5.%notdel% AND
	SZV.%notdel% AND
	SZV.ZV_DTAPR = '        ' AND
	Substr(SZV.ZV_FILIAL,1,2) || SZV.ZV_CODRGA in
	       (SELECT DISTINCT
	       Substr(SZU.ZU_FILIAL,1,2) || SZU.ZU_CODRGA
	       FROM
	       %Table:SZS% SZS,%Table:SZU% SZU
	       WHERE
	       SZS.%notdel% AND
	       SZS.ZS_USER = %exp:xcUser% AND
	       SZS.ZS_APRFAT = '1' AND
	       SZU.%notdel% AND
	       SZU.ZU_MSBLQL <> '1' AND
	       SZU.ZU_CODAPR = SZS.ZS_CODIGO
	       )

	 EndSql

	(cNextAlias)->(DbGoTop())

	(cNextAlias)->(DbEval({||lRet:= .T.}))

	(cNextAlias)->(dbCloseArea())

	RestArea(aArea)

Return lRet

Static Function xMF10xFSZV()

	//	Local cFil := ''

	//	_cFilCab := ''

	//	aEval(_aRegras,{|x| cFil +=  xFilial('SZV',x[1]) + x[2] + "|"})

	//	_cFilCab += "SZV->ZV_FILIAL+SZV->ZV_CODRGA" $ "'" + cFil + "'"
	//	_cFilCab += 'A1_COD=="000021"'//SZV->ZV_FILIAL+SZV->ZV_CODRGA $ "'" + cFil + "'"

Return

User function xFilterFat10(cxAlias)

	Local cFilSC6	:= ""
	Local cFilSC5	:= ""
	Local cEmiSC5   := ""
	Local cEntSC6   := ""
	Local cPedSC6   := ""
	Local cPedSC5   := ""

	cFilSC6	  := "C6_FILIAL >= '"+MV_PAR02+"' .AND. C6_FILIAL <= '"+MV_PAR03+"'"
	cFilSC5	  := "C5_FILIAL >= '"+MV_PAR02+"' .AND. C5_FILIAL <= '"+MV_PAR03+"'"
	cEmiSC5   := "C5_EMISSAO >= '"+dtos(MV_PAR04)+"' .AND. C5_EMISSAO <= '"+dtos(MV_PAR05)+"'"
	cEntSC6   := "C6_ENTREG >= '"+dtos(MV_PAR06)+"' .AND. C6_ENTREG <= '"+dtos(MV_PAR07)+"'"
	cPedSC6   := "C6_NUM >= '"+MV_PAR12+"' .AND. C6_NUM <= '"+MV_PAR13+"'"
	cPedSC5   := "C5_NUM >= '"+MV_PAR12+"' .AND. C5_NUM <= '"+MV_PAR13+"' .AND. C5_ZBLQRGA == 'B' "

	lItem     := MV_PAR01 == 1
	If lItem
		DbSelectArea("SC6")
		(cxAlias)->(DbSetOrder(1))
		(cxAlias)->(DbSetFilter({|| &(cFilSC6 +" .AND. "+ cPedSC6) }, cFilSC6 +" .AND. "+ cPedSC6 ))
		(cxAlias)->(DbGoTop())
	Else
		DbSelectArea("SC5")
		(cxAlias)->(DbSetOrder(1))
		(cxAlias)->(DbSetFilter({|| &(cFilSC5 +" .AND. "+ cPedSC5) }, cFilSC5 +" .AND. "+ cPedSC5 ))
		(cxAlias)->(DbGoTop())
	Endif

return