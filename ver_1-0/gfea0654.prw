#Include "Protheus.ch"
#Include "parmtype.ch"

/*/{Protheus.doc} GFEA0654
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function GFEA0654()

	Local aArea		:= GetArea()
	Local aDocFrete := ParamIXB[1]
	Local aNotFis 	:= ParamIXB[2]
	Local aRet 		:= {}
	Local cNatur 	:= GETMV("MV_NTFGFE")
	Local cFilUt 	:= GETMV("MGF_FILTES")
	Local nPosCond 	:= ascan(aDocFrete , { |x| x[1] == 'MV_PAR31' } )
	Local nPosNatu	:= ascan(aDocFrete , { |x| x[1] == 'Natureza' } )  //21
	Local nPosTes	:= ascan(aDocFrete , { |x| x[1] == 'MV_PAR27' } )  //15

	U_MGFCTB232()

	If !xFilial("GW3") $ cFilUt
		If ALLTRIM(GW3->GW3_CDESP) <> "ND"
			If !Isincallstack("GFEA065XD")

				If !Empty(GW3->GW3_ZCOND)
					ADOCFRETE[nPosCond][2] := GW3->GW3_ZCOND
				EndIf

				If GW3->GW3_TES = GW3->GW3_ZTESOR
					
					IIF( nPosNatu > 0 , ADOCFRETE[nPosNatu][2] := cNatur , cOperpe  := cNatur )
					
					If !Empty(cNaturx)
						 IIF( nPosNatu > 0 , ADOCFRETE[nPosNatu][2] := cNaturx , cOperpe  := cNatur ) 
					EndIf

					If GW3->GW3_CDESP = "NFS"
						Aadd(aRet, {aDocFrete, aNotFis})
						Return aRet
					EndIf

					If GW3->GW3_TES = GW3->GW3_ZTESOR

						If FindFunction("U_MGFGFE28")
							ADOCFRETE[nPosTes][2] := U_MGFGFE28()
						EndIf

						Aadd(aRet, {aDocFrete, aNotFis})

					Else
						Aadd(aRet, {aDocFrete, aNotFis})
					EndIf

				Else
					IIF( nPosNatu > 0 , ADOCFRETE[nPosNatu][2] := cNatur , cOperpe  := cNatur )
					ADOCFRETE[nPosTes][2]	:= GW3->GW3_TES
					Aadd(aRet, {aDocFrete, aNotFis})
				EndIf
			Else
				ADOCFRETE[nPosTes][2] := GW3->GW3_TES
				IIF( nPosNatu > 0 , ADOCFRETE[nPosNatu][2] := cNatur , cOperpe  := cNatur )
				Aadd(aRet, {aDocFrete, aNotFis})
			EndIf


		else

			DbSelectarea("SFM")
			DbSetOrder(1)
			If SFM->(DbSeek(xFilial("SFM") + "66"))
				cTes := SFM->FM_TE

				ADOCFRETE[nPosTes][2] := cTes

			EndIf

			Aadd(aRet, {aDocFrete, aNotFis})
		EndIf
	Else

		If !Isincallstack("GFEA065XD")

			If !Empty(GW3->GW3_ZCOND)
				ADOCFRETE[nPosCond][2] := GW3->GW3_ZCOND
			EndIf

			If GW3->GW3_TES = GW3->GW3_ZTESOR
				IIF( nPosNatu > 0 , ADOCFRETE[nPosNatu][2] := cNatur , cOperpe  := cNatur )

				If !Empty(cNaturx)
					IIF( nPosNatu > 0 , ADOCFRETE[nPosNatu][2] := cNaturx , cOperpe  := cNatur ) 
				EndIf

				If GW3->GW3_CDESP = "NFS"
					Aadd(aRet, {aDocFrete, aNotFis})
					Return aRet
				EndIf

				If GW3->GW3_TES = GW3->GW3_ZTESOR

					If FindFunction("U_MGFGFE28")
						ADOCFRETE[nPosTes][2] := U_MGFGFE28()
					EndIf

					Aadd(aRet, {aDocFrete, aNotFis})

				Else
					Aadd(aRet, {aDocFrete, aNotFis})
				EndIf

			Else
				IIF( nPosNatu > 0 , ADOCFRETE[nPosNatu][2] := cNatur , cOperpe  := cNatur )
				ADOCFRETE[nPosTes][2] := GW3->GW3_TES
				Aadd(aRet, {aDocFrete, aNotFis})
			EndIf
		Else
			ADOCFRETE[nPosTes][2] := GW3->GW3_TES
			IIF( nPosNatu > 0 , ADOCFRETE[nPosNatu][2] := cNatur , cOperpe  := cNatur )
			Aadd(aRet, {aDocFrete, aNotFis})
		EndIf
	Endif

	RestArea(aArea)

Return aRet

User Function xGFE0654()

	Local aArea		:= GetArea()
	Local aAreaSF1  := SF1->(GetArea())
	Local aAreaSD1  := SD1->(GetArea())

	Local cCC		:= ""
	Local cItem		:= ""
	Local cClass	:= ""
	Local cConta	:= ""
	Local cFil 		:= XFILIAL("SD1")
	Local cDoc 		:= SD1->D1_DOC
	Local cSerie 	:= SD1->D1_SERIE
	Local cFornece 	:= SD1->D1_FORNECE
	Local cLoja 	:= SD1->D1_LOJA
	Local cNatur    := GETMV("MV_NTFGFE")

	U_MGFCTB232()

	cCC := cCCx
	cItem := cItemx
	cClass := cClassex
	cConta := cContaX



	DbSelectArea("SF1")
	SF1->(DbSetOrder(1))
	If SF1->(Msseek(XFILIAL("SF1") + cDoc + cSerie + cFornece + cLoja))
		RecLock("SF1", .F. )
		SF1->F1_ORIGEM := "GFEA065"
		SF1->(MsUnLock())
	EndIf
	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))
	SD1->(Msseek(XFILIAL("SD1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA))

	While SD1->(!EOF()) .and. ( XFILIAL("SD1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA) == ( cFil + cDoc + cSerie + cFornece + cLoja )
		RecLock("SD1", .F. )
		If !Empty(cConta)
			SD1->D1_CONTA := cConta
		EndIf


		SD1->D1_ITEMCTA := cItem



		SD1->D1_CC := cCCx

		MsUnLock()

		SD1->(DbSkip())
	Enddo

	If SE2->E2_NUM == ALLTRIM(GW3->GW3_NRDF)
		If !empty(cNaturx)
			RecLock("SE2", .F. )
			SE2->E2_NATUREZ := cNaturx
			MsUnLock()
		Else

			RecLock("SE2", .F. )
			SE2->E2_NATUREZ := cNatur
			MsUnLock()

		EndIf
	EndIf

	RestArea(aAreaSD1)
	RestArea(aAreaSF1)
	RestArea(aArea)

Return


Static Function xYGFE0654()

	Local aArea := GetArea()
	Local aAreaGW4 := GW4->(GetArea())
	Local aAreaSFM := SFM->(GetArea())

	Local cTes := ""

	If Empty(cTesx)

		If GW3->GW3_ACINT = "2" .AND.  GW3->GW3_TRBIMP = "1"

			DbSelectArea("GW4")
			GW4->(DbSetOrder(1))
			If GW4->(MsSeek(XFILIAL("GW4") + GW3->GW3_EMISDF + GW3->GW3_CDESP + GW3->GW3_SERDF + GW3->GW3_NRDF ))

				If GW4->GW4_TPDC = "NFE"
					DbSelectarea("SFM")
					SFM->(DbSetOrder(1))
					If SFM->(DbSeek(xFilial("SFM") + "T7"))
						cTes := SFM->FM_TE
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	RestArea(aAreaGW4)
	RestArea(aAreaSFM)
	RestArea(aArea)

Return cTes
