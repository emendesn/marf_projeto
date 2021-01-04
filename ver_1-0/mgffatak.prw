#Include "Protheus.ch"
#Include "FwMVCDef.ch"
#Include "FWMBROWSE.ch"
#Include "TOTVS.ch"
#Include "TOPCONN.ch"
#Include "TBICONN.ch"

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
/*/{Protheus.doc} VlNumExp
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function VlNumExp()
	Local  aArea    :=  GetArea()
	Local  lRet     := .F.
	Local  cChEmp   :=  cEmpAnt + Space( 4 )
	Local  cTitDiag :=  "Exportação/Transferência"

	ZB8->( DbSetOrder( 3 ) )

	If ! Empty( M->C5_ZNUMEXP )
		If ZB8->( DbSeek( cChEmp + M->C5_ZNUMEXP ) )
			lRet  := .T.
		Else
			Iif(FindFunction("APMsgAlert"), APMsgAlert(OEMToANSI("O código do campo 'Ref.EXP.Tran.' "+AllTrim(M->C5_ZNUMEXP)+" não encontrado."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)), MsgAlert(OEMToANSI("O código do campo 'Ref.EXP.Tran.' "+AllTrim(M->C5_ZNUMEXP)+" não encontrado."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)))
		EndIf
	Else
		If PVExp( M->C5_ZTIPPED )
			Iif(FindFunction("APMsgAlert"), APMsgAlert(OEMToANSI("O código do campo 'Ref.EXP.Tran.' deve ser preenchido."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)), MsgAlert(OEMToANSI("O código do campo 'Ref.EXP.Tran.' deve ser preenchido."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)))
			lRet := .F.
		Else
			lRet := .T.
		EndIf
	EndIf

	RestArea( aArea )
Return( lRet )















User Function Blq_Cpo(cCpo)
	Local aArea :=  GetArea()
	Local lRet  := .T.

	If ! Empty( M->C5_ZTIPPED )
		Do Case
			Case cCpo == 1
			If PVExp( M->C5_ZTIPPED )
				lRet := .F.
			EndIf
			Case cCpo == 2
			If PVExp( M->C5_ZTIPPED )
				lRet := .F.
			EndIf
			Case cCpo == 3
			If ! PVExp( M->C5_ZTIPPED )
				M->C5_ZNUMEXP := Space( Len( M->C5_ZNUMEXP ) )
				lRet := .F.
			EndIf
		EndCase
	EndIf

	RestArea( aArea )
Return( lRet )








User Function DelItem()
	Local aArea := GetArea()
	Local nPos  := Len( aCols[n] )
	Local lRet  := .T.

	If aCols[n][nPos]




		If ! PVExp( M->C5_ZTIPPED ) .and.  ! Empty( M->C5_ZNUMEXP )
			Alert( OEMToANSI( "Não é permitido a exclusão de itens do Pedido de Venda de Refaturamento." + Chr( 13 ) + Chr( 10 ) + Chr( 13 ) + Chr( 10 ) + "Se necessário, refaça o Pedido de Venda." ), OEMToANSI( "Atenção" ) )
			aCols[n][nPos] := .F.
			oGetDad:Refresh()
		EndIf
	EndIf

	RestArea( aArea )
Return( lRet )









Static Function Vrf_TP()
	Local  cRet    :=  "0"
	Local  aArea   :=  GetArea()
	Local  cChEmp  :=  cEmpAnt + Space( 4 )
	Local  cChPrd
	Local  nCnt    :=  1

	cPrdSTB_ := ""

	DA1->( DbSetOrder( 1 ) )

	cChPrd := cChEmp + M->C5_TABELA

	QRYZB9->( DbGoTop() )
	while !QRYZB9->(EoF())
		If ! DA1->( DbSeek( cChPrd + QRYZB9->CODPROD ) )
			cRet := "2"
			cPrdSTB_ += ( StrZero( nCnt++, 3 ) + ") [" + QRYZB9->CODPROD + " - " + GetAdvFVal( "SB1", "B1_DESC", xFilial( "SB1" ) + QRYZB9->CODPROD, 1, "" ) + "]" + Chr( 13 ) + Chr( 10 ) )
		EndIf
		QRYZB9->( DbSkip() )
	EndDo

	RestArea( aArea )
Return( cRet )








User Function LmpAcols()
	Local  aArea    :=  GetArea()
	Local  aLnAux   :=  {}
	Local  cCmp     :=  ""
	Local  lRet     := .T.

	M->C5_ZNUMEXP := Space( TAMSX3("C5_ZNUMEXP")[1] )

	For nY := 1 To Len( aHeader )
		If Trim( aHeader[nY][2] ) == "C6_ITEM"
			aAdd( aLnAux, StrZero( 1, 2 ) )
		Else
			If AllTrim( aHeader[nY,2] ) == "C6_ALI_WT"
				aAdd( aLnAux, "SC6" )
			ElseIf AllTrim( aHeader[nY,2] ) == "C6_REC_WT"
				aAdd( aLnAux, 0 )
			Else
				aAdd( aLnAux, CriaVar( aHeader[nY][2] ) )
			EndIf
		EndIf
	next

	aAdd( aLnAux, .F.  )
	aCols := {}
	aAdd( aCols, aLnAux )
	n     := Len( aCols )
	oGetDad:Refresh()

	RestArea( aArea )
Return( lRet )









Static Function PVExp( _cTpPV_ )
	Local  aArea := GetArea()
	Local  lRet  := .T.





	PrcZJ_Imp()

	If ! Empty( _cTpPV_ )
		DbSelectArea( "SZJ" )
		SZJ->( DbSetOrder( 1 ) )

		If DbSeek( xFilial( "SZJ" ) + _cTpPV_ )
			If SZJ->ZJ_IMP == "2" .or.  Empty( SZJ->ZJ_IMP )
				lRet := .F.
			Else
				lRet := .T.
			EndIf
		Else
			Iif(FindFunction("APMsgAlert"), APMsgAlert(OEMToANSI("Tipo de PV "+AllTrim(_cTpPV_)+" não encontrado."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI("Exportação/Transferência")), MsgAlert(OEMToANSI("Tipo de PV "+AllTrim(_cTpPV_)+" não encontrado."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI("Exportação/Transferência")))
		EndIf
	EndIf

	RestArea( aArea )
Return( lRet )









Static Function PrcZJ_Imp()
	Local  aArea := GetArea()
	Local  cQry

	cQry  :=  "SELECT ZJ_FILIAL UNIDADE, ZJ_COD CODIGO, ZJ_IMP EXPORTA" + Chr( 13 ) + Chr( 10 )
	cQry  +=  "FROM " + RetSQLName( "SZJ" ) + " SZJ" + Chr( 13 ) + Chr( 10 )
	cQry  +=  "WHERE    ZJ_FILIAL  =   '" + xFilial( "SZJ" )  + "'" + Chr( 13 ) + Chr( 10 )
	cQry  +=  "  AND    ZJ_IMP     =   '" + Space( Len( SZJ->ZJ_IMP ) ) + "'" + Chr( 13 ) + Chr( 10 )
	cQry  +=  "  AND    SZJ.D_E_L_E_T_  <>  '*'" + Chr( 13 ) + Chr( 10 )

	If Select( "QRYSZJ" ) > 0
		QRYSZJ->( DbCloseArea() )
	EndIf

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQry), "QRYSZJ" , .F. , .T. )

	QRYSZJ->( DbGoTop() )
	If QRYSZJ->( EoF() )
		QRYSZJ->( DbCloseArea() )
	Else
		SZJ->( DbSetOrder( 1 ) )
		while QRYSZJ->(!EoF())
			If SZJ->( DbSeek( QRYSZJ->UNIDADE + QRYSZJ->CODIGO ) )
				RecLock( "SZJ", .F.  )
				_FIELD->SZJ->ZJ_IMP := "2"
				SZJ->( MSUnlock() )
			EndIf
			QRYSZJ->( DbSkip() )
		EndDo
		QRYSZJ->( DbCloseArea() )
	EndIf

	RestArea( aArea )
Return( Nil )
















User Function VldPEXP()
	Local  aArea    :=  GetArea()
	Local  lRet     := .F.
	Local  cChEmp   :=  cEmpAnt + Space( 4 )
	Local  nPsCod   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
	Local  cProd__  :=  M->C6_PRODUTO
	Local  cTitDiag :=  "Exportação/Transferência"

	If PVExp( M->C5_ZTIPPED ) .and.  Empty( M->C5_ZNUMEXP )
		Iif(FindFunction("APMsgAlert"), APMsgAlert(OEMToANSI("O campo 'Ref.EXP.Tran' deve ser preenchido por se tratar de Pedido de Exportação."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)), MsgAlert(OEMToANSI("O campo 'Ref.EXP.Tran' deve ser preenchido por se tratar de Pedido de Exportação."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)))
		lRet := .F.
	Else
		If ! Empty( M->C5_ZNUMEXP )
			DbSelectArea( "ZB9" )

			DbSetOrder( 2 )

			If ZB9->( DbSeek( cChEmp + Left( M->C5_ZNUMEXP, 14 ) ) )
				while !ZB9->(EoF()) .and. (ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP+ZB9_SUBEXP)==cChEmp+Left(M->C5_ZNUMEXP,14))
					If cProd__ <> ZB9->ZB9_COD_I
						ZB9->( DbSkip() )
						LooP
					Else



						lRet := .T.
						ExiT
					EndIf
				EndDo
			EndIf
		Else
			lRet := .T.
		EndIf






		If ! lRet
			Iif(FindFunction("APMsgAlert"), APMsgAlert(OEMToANSI("O produto não encontrado no 'Ref.EXP.Tran' "+AllTrim(M->C5_ZNUMEXP)+"."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)), MsgAlert(OEMToANSI("O produto não encontrado no 'Ref.EXP.Tran' "+AllTrim(M->C5_ZNUMEXP)+"."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)))
		EndIf

	EndIf

	RestArea( aArea )
Return( lRet )

















User Function Vld_Qtd()
	Local  aArea    :=  GetArea()
	Local  lRet     := .F.
	Local  cChEmp   :=  cEmpAnt + Space( 4 )
	Local  nPsCod   :=  aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
	Local  cProd__  :=  aCols[n][nPsCod]
	Local  cQtde__  :=  M->C6_QTDVEN
	Local  cTitDiag :=  "Exportação/Transferência"
	Local  cInf_    :=  iIf( PVExp( M->C5_ZTIPPED ), "EXP/Transferência", "Refaturamento" )

	If ! Empty( M->C5_ZNUMEXP )
		DbSelectArea( "ZB9" )

		DbSetOrder( 2 )

		If ZB9->( DbSeek( cChEmp + AllTrim( M->C5_ZNUMEXP ) ) )
			while !ZB9->(EoF()) .and. (ZB9->(ZB9_FILIAL+ZB9_EXP+ZB9_ANOEXP)==cChEmp+AllTrim(M->C5_ZNUMEXP))
				If cProd__ <> ZB9->ZB9_COD_I
					ZB9->( DbSkip() )
					LooP
				Else




					If cQtde__ <= ZB9->ZB9_SLDINI
						lRet := .T.
						ExiT
					Else
						Iif(FindFunction("APMsgAlert"), APMsgAlert(OEMToANSI("A Quantidade deste item não deve ser maior na "+cInf_+Space(1)+AllTrim(M->C5_ZNUMEXP)+"."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)), MsgAlert(OEMToANSI("A Quantidade deste item não deve ser maior na "+cInf_+Space(1)+AllTrim(M->C5_ZNUMEXP)+"."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)))
						lRet := .F.
						RestArea( aArea )
						Return( lRet )
					EndIf
					ExiT
				EndIf
			EndDo
		EndIf
	Else
		lRet := .T.
	EndIf






	If ! lRet
		Iif(FindFunction("APMsgAlert"), APMsgAlert(OEMToANSI("O produto não encontrado no 'Ref.EXP.Tran' "+AllTrim(M->C5_ZNUMEXP)+"."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)), MsgAlert(OEMToANSI("O produto não encontrado no 'Ref.EXP.Tran' "+AllTrim(M->C5_ZNUMEXP)+"."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Favor verificar."), OEMToANSI(cTitDiag)))
	EndIf

	RestArea( aArea )
Return( lRet )
