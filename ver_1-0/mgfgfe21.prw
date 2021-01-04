#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} MGFGFE21
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MGFGFE21()

	Local cAliasC  := ""
	Local cQuery   := ""
	Local aArea    := GetArea()
	Local aAreaZDL := GetArea()



	cAliasC := GetNextAlias()

	cQuery := " SELECT * FROM SYS_COMPANY "
	cQuery += "  WHERE M0_CODFIL = '" + SF2->F2_FILIAL + "'"
	cQuery += "  AND SYS_COMPANY.D_E_L_E_T_= ' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQuery),cAliasC, .F. , .T. )

	If (cAliasC)->(!eof())


		DbSelectArea("SA1")
		DbSetOrder(1)
		If SA1->(MsSeek(XFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))


			DbSelectArea("DAI")
			DbSetOrder(4)
			If DAI->(MsSeek(XFilial("DAI") + SC5->C5_NUM + DAK->DAK_COD + DAK->DAK_SEQCAR))


				DbSelectArea("GU3")
				DbSetOrder(1)
				GU3->(MsSeek(XFilial("GU3") + SA1->A1_CGC))


				DbSelectArea("ZDL")
				RecLock("ZDL", .T. )
				ZDL->ZDL_NUMOE  := DAK->DAK_COD
				ZDL->ZDL_CIDINI := (cAliasC)->M0_CODMUN
				ZDL->ZDL_CIDDES := GU3->GU3_NRCID
				ZDL->ZDL_DATAPR := SC5->C5_FECENT
				ZDL->ZDL_BAIRRO := SA1->A1_BAIRRO
				ZDL->ZDL_CEP    := SA1->A1_CEP
				ZDL->ZDL_CNPJ   := SA1->A1_CGC
				ZDL->ZDL_CODATV := CDATIVIDADE()
				ZDL->ZDL_CODPAI := SA1->A1_PAIS
				ZDL->ZDL_END    := SA1->A1_END
				If !empty(SC5->C5_PEDEXP)
					ZDL->ZDL_EXP    := "S"
				Else
					ZDL->ZDL_EXP    := "N"
				EndIf
				ZDL->ZDL_RAZAO  := SA1->A1_NOME
				ZDL->ZDL_NMFANT := SA1->A1_NREDUZ
				ZDL->ZDL_CODCLI := SF2->F2_CLIENTE
				ZDL->ZDL_IE     := SA1->A1_INSCR
				ZDL->ZDL_CHVNFE := SF2->F2_CHVNFE

				ZDL->ZDL_NUMNF  := SF2->F2_DOC
				ZDL->ZDL_VLRNF  := SF2->F2_VALBRUT
				ZDL->ZDL_QTDE   := SF2->F2_VOLUME1
				ZDL->ZDL_PESO   := DAI->DAI_PESO
				ZDL->ZDL_ATU    := " "
				ZDL->ZDL_CNPJEM := (cAliasC)->M0_CGC
				ZDL->ZDL_ENDEMI := (cAliasC)->M0_ENDENT
				ZDL->ZDL_REMBAI := (cAliasC)->M0_BAIRENT
				ZDL->ZDL_CEPREM := (cAliasC)->M0_CEPENT
				ZDL->ZDL_CPLEND := (cAliasC)->M0_COMPENT
				ZDL->ZDL_ENDENT := SA1->A1_END + SA1->A1_BAIRRO + SA1->A1_MUN
				ZDL->ZDL_FILIAL := XFILIAL("SF2")
				ZDL->ZDL_SERNF  := SF2->F2_SERIE
				ZDL->ZDL_NUMSEQ := U_MGF2GFE21()
				ZDL->ZDL_STATUS := "2"
				ZDL->ZDL_PROC   := " "

				ZDL->(MsUnlock())

				RestArea(aAreaZDL)
			EndIf
		EndIf
	EndIf
	RestArea(aArea)
	RestArea(aAreaZDL)
	(cAliasC)->(DbCloseArea())

return





Static Function CDATIVIDADE()

	Local cAtividade := ""
	Local lRet       := .F.
	Local cAliasF    := ""
	Local cQuery     := ""
	Local aArea		 := GetArea()
	Local aAreaSA2	 := SA2->(GetArea())


	DbSelectArea("SA2")
	DbSetorder(3)
	If SA2->(MsSeek(xFilial("SA2") + SA1->A1_CGC))
		cAtividade := "6"
		lRet := .T.
	EndIf


	If lRet

		cAliasF := GetNextAlias()

		cQuery := " SELECT * FROM SYS_COMPANY "
		cQuery += "  WHERE M0_CODFIL = '" + SF2->F2_FILIAL + "'"
		cQuery += "  AND SYS_COMPANY.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)

		dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQuery),cAliasF, .F. , .T. )

		If !(cAliasF)->(EOF())
			cAtividade := "2"
		EndIf

		(cAliasF)->(DbCloseArea())
	EndIf


	If Len(alltrim(SA1->A1_CGC)) > 8
		cAtividade := "7"
	EndIf


	If Empty(cAtividade)
		cAtividade := "3"
	EndIf

	SA2->(RestArea(aAreaSA2))
	RestArea(aArea)

Return cAtividade




User Function MGF1GFE21()

	Local aArea    := GetArea()
	Local aAreaZDL := GetArea()

	DbSelectArea("ZDL")
	DbSetOrder(1)
	If ZDL->(MsSeek(xFilial("ZDL")+ SM0->M0_CGC + SF2->F2_DOC + SF2->F2_SERIE))

		RecLock("ZDL", .F. )
		ZDL->ZDL_CHVNFE := SF2->F2_CHVNFE
		ZDL->ZDL_DTEMIS := CVALTOCHAR(SF2->F2_EMISSAO) + " - " + SF2->F2_HORA
		MsUnlock()
	EndIf

	RestArea(aArea)
	RestArea(aAreaZDL)

Return



User Function MGF2GFE21()

	Local cAliasA := ""
	Local cAliasX := ""

	Public xAgrupCte := "0000000001"

	cAliasA := GetNextAlias()

	cQuery := " SELECT * FROM "
	cQuery += RetSqlName("DAI")+" DAI " + " ," + RetSqlName("ZDL") + " ZDL"
	cQuery += " WHERE DAI_COD = '" + DAK->DAK_COD + "'"
	cQuery += " AND DAI_FILIAL = '" + XFILIAL("DAI") + "'"
	cQuery += " AND ZDL_FILIAL = DAI_FILIAL "
	cQuery += " AND ZDL_NUMOE = DAI_COD "
	cQuery += " AND ZDL_NUMSEQ <> ' '"
	cQuery += " AND DAI.D_E_L_E_T_= ' ' "
	cQuery += " AND ZDL.D_E_L_E_T_= ' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQuery),cAliasA, .F. , .T. )

	If (cAliasA)->(!eof())

		cAliasX := GetNextAlias()

		cQuery := " SELECT * FROM "
		cQuery += RetSqlName("DAI")+" DAI "
		cQuery += " WHERE DAI_COD = '" + (cAliasA)->DAI_COD + "'"
		cQuery += " AND DAI_FILIAL = '" + XFILIAL("DAI") + "'"
		cQuery += " AND DAI_CLIENT = '" + (cAliasA)->DAI_CLIENT + "'"
		cQuery += " AND DAI_LOJA = '" + (cAliasA)->DAI_LOJA + "'"
		cQuery += " AND DAI.D_E_L_E_T_= ' ' "

		cQuery := ChangeQuery(cQuery)

		dbUseArea( .T. , "TOPCONN", TCGENQRY(,,cQuery),cAliasX, .F. , .T. )

		If (cAliasX)->(!eof())

			xAgrupCte := (cAliasA)->ZDL_NUMOE
			(cAliasX)->(DbCloseArea())
		Else
			xAgrupCte := val((cAliasA)->ZDL_NUMOE) + 1
			xAgrupCte := STR(xAgrupCte)
		EndIf

		(cAliasA)->(DbCloseArea())

	EndIf

Return xAgrupCte
