#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN69
Autor...............: Atilio Amarilla
Data................: 09/11/2017
Descrição / Objetivo: Manter valor de desconto para título com baixa parcial 
Doc. Origem.........: Contrato - GAP CRE041 FASE 4
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFIN69(LRECLCJUR)
	
	Local lFINA200	:= FunName() == "FINA200" .Or. FwIsInCallStack("fa200Ger")
	
	Default lReclcJur := .F.

	dbSelectArea("SE1")
	If FunName() <> "FINA630" .and. !lFINA200 .And. !( SE1->E1_TIPO $ MVRECANT + "|" + MV_CRNEG ) 
		//IF (!Empty(oDtBaixa) .AND. oDtBaixa:lModified) .or. Empty(oDtBaixa)
			nDescont := FaDescFin("SE1",dBaixa,SE1->E1_SALDO-nTotAbat,nMoedaBco,.T.)
			nOldDescont := nDescont
		//Endif
		//IF (!Empty(oJuros) .AND. oJuros:lModified) .or. Empty(oJuros).or. oDtBaixa:lModified
			nCM1     := 0
			nProRata := 0

			fa070Juros(nMoedaBco,,,,Iif( lReclcJur , nTxMoeda , Nil ) )

			If nCM1 > 0
				nJuros -= nCM1
			Else
				nDescont += nCM1
			EndIf

			If nProRata > 0
				nJuros -= nProRata
			Else
				nDescont += nProRata
			EndIf

			//Quando for uma baixa de cancelamento (Integração TIN x PROTHEUS), não calcular o juros e multa.
			/*
			If Type("aAutoCab") == "A"
				If (nPos := aScan(aAutoCab,{|x| x[1] == 'AUTMOTBX'})) > 0 
					If aAutoCab[nPos,2] == "TIN" .And. AllTrim(SE1->E1_ORIGEM) == "FINI055" .And. lFini055
						nJuros := 0
						nMulta := 0
					Endif
				Endif
			EndIf
			*/
		//EndIf
	Endif

Return

