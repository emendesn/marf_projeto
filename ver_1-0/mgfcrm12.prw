#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

static F1ZSENHA := ""

/*=====================================================================================
Programa.:              MGFCRM12
Autor....:              Gustavo Ananias Afonso - TOTVS Campinas
Data.....:              03/04/2017
Descricao / Objetivo:   Amarracao com o RAMI
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================*/
User Function MGFCRM12(xRet)
	local aRet			:= {}
	local aParambox		:= {}
	local aMVParBkp		:= MV_PAR01

    /*---------------------------------------------------------------+
    | Mensagem de aviso de descontinuidade do programa MGFCRM12.prw  |
    +---------------------------------------------------------------*/
    MsgAlert( OEMToANSI( "A tecla [F4] - busca unitária do RAMI - será descontinuada em breve. Passe a usar a nova funcionalidade [F2]: seleção múltipla de RAMI." ) )


	MV_PAR01			:= space(6)

	if !MAFISFOUND("NF")
		help('', 1, 'A103CAB')
		return
	endif

	if M->cTipo <> "D"
		return
	endif

	if cFormul == "S"
		if empty(cA100For) .or.;
		empty(cLoja) .or.;
		empty(cUfOrig) .or.;
		empty(cEspecie) .or.;
		empty(dDEmissao)

			msgAlert("Para associar a RAMI é necessário preencher o cabeçalho.")
			return
		endif
	elseif cFormul == "N"
		if empty(cA100For) .or.;
		empty(cLoja) .or.;
		empty(cUfOrig) .or.;
		empty(cEspecie) .or.;
		empty(dDEmissao) .or.;
		empty(cNFiscal) .or.;
		empty(cSerie)

			msgAlert("Para associar a RAMI é necessário preencher o cabeçalho.")
			return
		endif
	endif

	if !empty(F1ZSENHA)
		MV_PAR01 := F1ZSENHA
	endif

	aadd(aParamBox, {1, "Senha do RAMI"	, MV_PAR01	, , , "ZAV2" , , 070	, .F.	})

	if paramBox(aParambox, "Relatório de Análise de Mercado Interno"	, @aRet, { || !empty(MV_PAR01) }, , .T. /*lCentered*/, 0, 0, , , .F. /*lCanSave*/, .F. /*lUserSave*/)
		if INCLUI
			M->F1_ZSENHA := MV_PAR01
			F1ZSENHA := M->F1_ZSENHA
			fwMsgRun(, {|| setNfRami(M->F1_ZSENHA) }, "Processando", "Aguarde. Selecionando dados..." )
			fwMsgRun(, {|| loadItens(M->F1_ZSENHA) }, "Processando", "Aguarde. Selecionando dados..." )
		endif
	endif

	MV_PAR01 := aMVParBkp
return .T.

//------------------------------------------------
//------------------------------------------------
static function setNfRami(cCodRAMI)
	local cQryZAV := ""

	cQryZAV := "SELECT F2_CLIENTE, F2_LOJA, A1_COD, A1_LOJA, A1_EST, F2_CHVNFE " + CRLF
	cQryZAV += " FROM " + retSQLName("ZAV") + " ZAV"+ CRLF
	cQryZAV += " INNER JOIN " + retSQLName("SF2") + " SF2"+ CRLF
	cQryZAV += " ON"+ CRLF
	cQryZAV += " 		ZAV_NFEMIS	=	SF2.F2_EMISSAO"+ CRLF
	cQryZAV += " 	AND	ZAV_SERIE	=	SF2.F2_SERIE"+ CRLF
	cQryZAV += " 	AND	ZAV_NOTA	=	SF2.F2_DOC"+ CRLF

	cQryZAV += " INNER JOIN " + retSQLName("SA1") + " SA1"				+ CRLF
	cQryZAV += " ON"													+ CRLF
	cQryZAV += " 		SA1.A1_COD		=	SF2.F2_CLIENTE"				+ CRLF
	cQryZAV += " 	AND	SA1.A1_LOJA		=	SF2.F2_LOJA"				+ CRLF
	cQryZAV += " 	AND	SA1.A1_FILIAL	=	'" + xFilial("SA1") + "'"	+ CRLF
	cQryZAV += " 	AND	SA1.D_E_L_E_T_	<>	'*'"						+ CRLF

	cQryZAV += " WHERE"													+ CRLF
	cQryZAV += " 		ZAV.ZAV_CODIGO	=	'" + cCodRAMI		+ "'"	+ CRLF
	cQryZAV += " 	AND	SF2.F2_FILIAL	=	'" + xFilial("SF2") + "'"	+ CRLF
	cQryZAV += " 	AND	ZAV.ZAV_FILIAL	=	'" + xFilial("ZAV") + "'"	+ CRLF
	cQryZAV += " 	AND	SF2.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQryZAV += " 	AND	ZAV.D_E_L_E_T_	<>	'*'"						+ CRLF

	memoWrite("C:\TEMP\MGFCRM12.SQL", cQryZAV)

	TcQuery cQryZAV New Alias "QRYZAV"

	if !QRYZAV->(EOF())
		/*
		If GetNewPar("MV_DCHVNFE",.F.) .and. cFormul == "N" .and. AllTrim(cEspecie) $ "|SPED|CTE|NFA|"
			M->F1_CHVNFE := QRYZAV->F2_CHVNFE
		Else
			M->F1_CHVNFE := Space(44)
		Endif
		*/
		aNFEDanfe[13] := Space(44) //M->F1_CHVNFE
		If bRefresh<>Nil
			Eval(bRefresh,9,9)
		EndIf
	endif

	QRYZAV->(DBCloseArea())
return

//------------------------------------------------------
//------------------------------------------------------
static function loadItens(cCodRAMI)
	local nPosItem 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"		})
	local nPosCod 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"			})
	local nPosDes 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PRODESC"		})
	local nPosUM 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_UM"			})
	local nPosQuant 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"		})
	local nPosVUnit		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"		})
	local nPosTotal		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"		})
	local nPosLocal 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOCAL"		})
	local nPosNFOri		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_NFORI"		})
	local nPosSerOri	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_SERIORI"		})
	local nPosItOri 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEMORI"		})
	local nPosQtDev 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_QTDEDEV"		})
	local nPosVlDev 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VALDEV"		})
	local nPosRAMI 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZRAMI"		})
	local nPosTES 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"			})
	local nPosCF 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CF"			})

	local nPosIpi 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_IPI"			})
	local nPosValIpi 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VALIPI"		})
	local nPosBasIpi 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_BASEIPI"		})

	local nPosICM 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PICM"		})
	local nPosValICM 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VALICM"		})
	local nPosBasICM 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_BASEICM"		})

	local nPosValDe		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VALDESC"		})
	local nPosDescZ		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_DESCZFR"		})

	local nPosCodMot 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZCODMOT"	})
	local nPosDesMot 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZDESCMO"	})
	local nPosCodJus 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZCODJUS"	})
	local nPosDesJus 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZDESCJU"	})
	local cLastItem		:= aTail(aCols)[nPosItem]
	local lFirstLine	:= .T.
	local cLocalDev		:= allTrim(superGetMv("MGF_ARMDEV", .F., "99"))
	local aArea			:= {SF4->(getArea()),SD2->(GetArea()),getArea()}
	Local aTransp	:= {"",""}
	Local nTotal	:= 0
	Local lContinua := .T.
	Local nI, nY
	local cQuery:=""

	itensRami(cCodRAMI)

	SD2->(dbSetOrder(3))
	SF4->(dbSetOrder(1))

	// verifica se TES de devolucao estah preenchido
	while !QRYZAW->(EOF())
		SF4->(DBGoTop())
		If SF4->(dbSeek(xFilial("SF4")+QRYZAW->D2_TES))
			if empty(QRYZAW->F4_TESDV) .OR. Empty(QRYZAW->F4_ZTESDE1)
				APMsgStop("Tes de Devolução não informado para o TES de saída: " + QRYZAW->D2_TES + "." + CRLF + ;
				"Verifique o cadastro do TES (Campos F4_TESDV e F4_ZTESDE1)." + CRLF + ;
				"Não será possível incluir a Nota de Devolução.")

				lContinua := .F.
				exit
			Endif
		Endif
		QRYZAW->(dbSkip())
	Enddo

	QRYZAW->(dbGotop())
	If !lContinua
		QRYZAW->(DBCloseArea())

		aEval(aArea,{|x| RestArea(x)})

		Return()
	Endif

	if cLastItem == "0001" .and. empty(aTail(aCols)[nPosCod])
		lFirstLine := .T.
	endif

	aLineAux := {}

	// limpa acols
	For nY := 1 To Len(aHeader)

		If Trim(aHeader[nY][2]) == "D1_ITEM"
			aadd(aLineAux, StrZero(1, 4))
		Else
			If AllTrim(aHeader[nY,2]) == "D1_ALI_WT"
				aadd(aLineAux, "SD1")
			ElseIf AllTrim(aHeader[nY,2]) == "D1_REC_WT"
				aadd(aLineAux, 0)
			Else
				aadd(aLineAux, CriaVar(aHeader[nY][2]))
			EndIf
		EndIf
	Next nY

	aadd(aLineAux, .F.)

	aCols := {}
	aadd(aCols, aLineAux)
	n := len(aCols)

	oGetDados:refresh()
	// fim - limpa acols

	while !QRYZAW->(EOF())
		SD2->(dbSeek(xFilial("SD2")+QRYZAW->ZAW_NOTA+QRYZAW->ZAW_SERIE+cA100For+cLoja+QRYZAW->ZAW_CDPROD))

		If !(QRYZAW->QTD > xQtdZAX(xFilial("ZAW"),QRYZAW->ZAW_CDRAMI,QRYZAW->ZAW_ITEMNF))
			QRYZAW->(dbSkip())
			Loop
		EndIf

		if lFirstLine
			lFirstLine := .F.
		else
			oGetDados:addLine()
		endif

		cLastItem := aCols[len(aCols), nPosItem]

		aLineAux := {}

		for nI := 1 to len(aHeader)
			if nI == nPosItem
				aadd(aLineAux, cLastItem)
			elseif nI == nPosCod
				aadd(aLineAux, QRYZAW->ZAW_CDPROD)
			elseif nI == nPosDes
				aadd(aLineAux, Posicione("SB1",1,XFILIAL("SB1")+QRYZAW->ZAW_CDPROD,"B1_DESC"))
			elseif nI == nPosUM
				aadd(aLineAux, QRYZAW->B1_UM)
			elseif nI == nPosQuant
				aadd(aLineAux, QRYZAW->QTD - xQtdZAX(xFilial("ZAW"),QRYZAW->ZAW_CDRAMI,QRYZAW->ZAW_ITEMNF))
            /*--------------------------------------------------------------------------+
            | Trecho substituido do programa MGFCRM52.prw para tratamento de devolucao  |
            | dos Estados do "AM"azonas e "A"ma"P"a.                                    |
            +--------------------------------------------------------------------------*/
            ElseIf nI == nPosVUnit
              If QRYZAW->D2_DESCZFR > 0 .and. CUFORIG == "AP"
                 aAdd( aLineAux, (QRYZAW->TOTAL + QRYZAW->D2_DESCZFR) / QRYZAW->QTDD2  )
              ElseIf QRYZAW->D2_DESCZFR > 0 .and. CUFORIG == "AM" // Acrescido a condicional para atender a situacao de desconto (Zona Franca) para clientes do "AM"azonas.
                     aAdd( aLineAux, (QRYZAW->TOTAL + QRYZAW->D2_DESCZFR) / QRYZAW->QTD )
              Else
                 aAdd( aLineAux, QRYZAW->TOTAL / QRYZAW->QTDD2  )
              EndIf
            ElseIf nI == nPosTotal
              If QRYZAW->D2_DESCZFR > 0  .and. (CUFORIG == "AP" .or. CUFORIG == "AM") // Acrescido a condicional para atender a situacao de desconto (Zona Franca) para clientes do "AM"azonas ou "A"ma"P"a.
                 aAdd( aLineAux, QRYZAW->TOTAL + QRYZAW->D2_DESCZFR )
              Else
                 aAdd( aLineAux, QRYZAW->TOTAL )
              EndIf
            /*--------------------------------------------------------------------------+
            | Final do trecho substituido do programa MGFCRM52.prw                      |
            +--------------------------------------------------------------------------*/
			elseif nI == nPosLocal
				if QRYZAW->ZAV_REVEND == "S"
					aadd( aLineAux, cLocalDev )
				else
					aadd( aLineAux, Posicione( "SB1", 1, XFILIAL("SB1") + QRYZAW->ZAW_CDPROD, "B1_LOCPAD" ) )
				endif
			elseif nI == nPosNFOri
				aadd(aLineAux, QRYZAW->ZAV_NOTA)
			elseif nI == nPosSerOri
				aadd(aLineAux, QRYZAW->ZAV_SERIE)
			elseif nI == nPosItOri
				aadd(aLineAux, QRYZAW->ZAW_ITEMNF)
			elseif nI == nPosValDe
				aadd(aLineAux, QRYZAW->D2_DESCZFR)
			elseif nI == nPosRAMI
				aadd(aLineAux, F1ZSENHA)
			elseif nI == nPosTES
				if M->cFormul == "S"
					aadd(aLineAux, QRYZAW->F4_ZTESDE1)
				elseif M->cFormul == "N"
					aadd(aLineAux, QRYZAW->F4_TESDV)
				endif
			elseif nI == nPosCF
				if M->cFormul == "S"
					aadd(aLineAux, getCFTes(QRYZAW->F4_ZTESDE1))
				elseif M->cFormul == "N"
					aadd(aLineAux, getCFTes(QRYZAW->F4_TESDV))
				endif

			elseif Trim(aHeader[nI][2]) == "D1_ITEM"
				aadd(aLineAux, StrZero(1, 4))

			elseif nI == nPosCodMot
				aadd( aLineAux, QRYZAW->ZAS_CODIGO )
			elseif nI == nPosDesMot
				aadd( aLineAux, QRYZAW->ZAS_DESCRI )
			elseif nI == nPosCodJus
				aadd( aLineAux, QRYZAW->ZAT_CODIGO )
			elseif nI == nPosDesJus
				aadd( aLineAux, QRYZAW->ZAT_DESCRI )
			Else
				If AllTrim(aHeader[nI,2]) == "D1_ALI_WT"
					aadd(aLineAux, "SD1")
				ElseIf AllTrim(aHeader[nI,2]) == "D1_REC_WT"
					aadd(aLineAux, 0)
				Else
					aadd(aLineAux, CriaVar(aHeader[nI][2]))
				EndIf
			EndIf
		next

		aadd(aLineAux, .F.)

		aCols[len(aCols)] := aClone(aLineAux)

		n := len(aCols)

		If ExistTrigger('D1_COD') // verifica se existe trigger para este campo
			RunTrigger(2,n,nil,,'D1_COD')
		Endif

		oGetDados:refresh()

		If ExistTrigger('D1_QUANT') // verifica se existe trigger para este campo
			RunTrigger(2,n,nil,,'D1_QUANT')
		Endif

		oGetDados:refresh()

		If ExistTrigger('D1_VUNIT') // verifica se existe trigger para este campo
			RunTrigger(2,n,nil,,'D1_VUNIT')
		Endif

		oGetDados:refresh()

		If ExistTrigger('D1_TOTAL') // verifica se existe trigger para este campo
			RunTrigger(2,n,nil,,'D1_TOTAL')
		Endif

		oGetDados:refresh()

		nItem := n

		if isInCallStack( "MATA103" )
			If MaFisFound()
				A103VldNFO(Len(aCols))//Verifica Notas de Complemento/Devolução vinculadas a NFE
			Endif
		endif

		QRYZAW->(DBSkip())
	enddo

	QRYZAW->(DBCloseArea())

	aEval(aArea,{|x| RestArea(x)})

return

//------------------------------------------------------
//------------------------------------------------------
user function ALTRAMI()
	msgAlert("Não é permitido alterar os itens do RAMI.")
return .F.

//------------------------------------------------------
//------------------------------------------------------
static function itensRami(cCodRAMI)
	local cQryZAW := ""

	cQryZAW := " SELECT ZAW_CDPROD, B1_UM, ZAW_QTD AS QTD, D2_PRCVEN AS PRECO, D2_TOTAL AS TOTAL, ZAV_NOTA, ZAV_SERIE, ZAW_ITEMNF, ZAW_NOTA, ZAW_SERIE, D2_DESCZFR,ZAW_CDRAMI, " + CRLF
	cQryZAW += " D2_TES, D2_QUANT QTDD2, F4_CODIGO, F4_TESDV, F4_ZTESDE1, ZAV_REVEND,"	+ CRLF

	cQryZAW += " ZAS_CODIGO, ZAS_DESCRI, ZAT_CODIGO, ZAT_DESCRI"		+ CRLF

	cQryZAW += " FROM " + retSQLName("ZAV") + " ZAV"					+ CRLF
	cQryZAW += " INNER JOIN " + retSQLName("ZAW") + " ZAW"				+ CRLF
	cQryZAW += " ON"													+ CRLF
	cQryZAW += " 		ZAV.ZAV_CODIGO	=	ZAW.ZAW_CDRAMI"				+ CRLF
	cQryZAW += " INNER JOIN " + retSQLName("SB1") + " SB1"				+ CRLF
	cQryZAW += " ON"													+ CRLF
	cQryZAW += " 		ZAW.ZAW_CDPROD	=	SB1.B1_COD"					+ CRLF

	cQryZAW += " INNER JOIN " + retSQLName("SD2") + " SD2"				+ CRLF
	cQryZAW += " ON"													+ CRLF
	cQryZAW += "		ZAW.ZAW_ITEMNF	=	SD2.D2_ITEM"				+ CRLF
	cQryZAW += "	AND ZAW.ZAW_SERIE	=	SD2.D2_SERIE"				+ CRLF
	cQryZAW += "	AND ZAW.ZAW_NOTA	=	SD2.D2_DOC"					+ CRLF
	cQryZAW += " 	AND	SD2.D2_FILIAL	=	'" + xFilial("SD2") + "'"	+ CRLF
	cQryZAW += " 	AND	SD2.D_E_L_E_T_	<>	'*'"						+ CRLF

	cQryZAW += " INNER JOIN " + retSQLName("SF4") + " SF4"				+ CRLF
	cQryZAW += " ON"													+ CRLF
	cQryZAW += " 		SF4.F4_CODIGO	=	SD2.D2_TES"					+ CRLF
	cQryZAW += " 	AND	SF4.F4_FILIAL	=	'" + xFilial("SF4") + "'"	+ CRLF
	cQryZAW += " 	AND	SF4.D_E_L_E_T_	<>	'*'"						+ CRLF

	// ZAU - MOTIVO X JUSTIFICATIVA
	cQryZAW += " LEFT JOIN " + retSQLName("ZAU") + " ZAU"				+ CRLF
	cQryZAW += " ON"													+ CRLF
	cQryZAW += " 		ZAW.ZAW_DIRECI	=	ZAU.ZAU_CODIGO"				+ CRLF
	cQryZAW += " 	AND	ZAU.ZAU_FILIAL	=	'" + xFilial("ZAU") + "'"	+ CRLF
	cQryZAW += " 	AND	ZAU.D_E_L_E_T_	<>	'*'"						+ CRLF

	// ZAS - MOTIVO
	cQryZAW += " LEFT JOIN " + retSQLName("ZAS") + " ZAS"				+ CRLF
	cQryZAW += " ON"													+ CRLF
	cQryZAW += " 		ZAU.ZAU_CODMOT	=	ZAS.ZAS_CODIGO"				+ CRLF
	cQryZAW += " 	AND	ZAS.ZAS_FILIAL	=	'" + xFilial("ZAS") + "'"	+ CRLF
	cQryZAW += " 	AND	ZAS.D_E_L_E_T_	<>	'*'"						+ CRLF

	// ZAT - JUSTIFICATIVA
	cQryZAW += " LEFT JOIN " + retSQLName("ZAT") + " ZAT"				+ CRLF
	cQryZAW += " ON"													+ CRLF
	cQryZAW += " 		ZAU.ZAU_CODJUS	=	ZAT.ZAT_CODIGO"				+ CRLF
	cQryZAW += " 	AND	ZAT.ZAT_FILIAL	=	'" + xFilial("ZAT") + "'"	+ CRLF
	cQryZAW += " 	AND	ZAT.D_E_L_E_T_	<>	'*'"						+ CRLF

	cQryZAW += " WHERE"													+ CRLF
	cQryZAW += " 		ZAV.ZAV_CODIGO	=	'" + cCodRAMI		+ "'"	+ CRLF
	cQryZAW += " 	AND	SB1.B1_FILIAL	=	'" + xFilial("SB1") + "'"	+ CRLF
	cQryZAW += " 	AND	ZAW.ZAW_FILIAL	=	'" + xFilial("ZAW") + "'"	+ CRLF
	cQryZAW += " 	AND	ZAV.ZAV_FILIAL	=	'" + xFilial("ZAV") + "'"	+ CRLF
	cQryZAW += " 	AND	SB1.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQryZAW += " 	AND	ZAW.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQryZAW += " 	AND	ZAV.D_E_L_E_T_	<>	'*'"						+ CRLF
	cQryZAW += "    ORDER BY ZAW.ZAW_ITEMNF                          "	+ CRLF

	TcQuery cQryZAW New Alias "QRYZAW"

	_aAreaSC7 := GetArea("SD2")

	DbselectArea("SD2")
	DbSetOrder(3)
	DbGoTop()
	Dbseek(xFilial("SD2")+QRYZAW->ZAW_NOTA+QRYZAW->ZAW_SERIE)
	While !Eof().and. SD2->D2_DOC == QRYZAW->ZAW_NOTA .And. SD2->D2_SERIE == QRYZAW->ZAW_SERIE

		Reclock("SD2",.F.)
		D2_QTDEDEV := 0
		D2_VALDEV := 0
		MsUnlock()

		DbselectArea("SD2")
		Dbskip()
	Enddo

	RestArea( _aAreaSC7 )
return

//------------------------------------------------------
//------------------------------------------------------
static function getCFTes(cTesDevol)
	local cQrySF4	:= ""
	local cRetCF	:= ""
	Local aDadosCFO := {}

	cQrySF4 := "SELECT F4_CF"											+ CRLF
	cQrySF4 += " FROM " + retSQLName("SF4") + " SF4"					+ CRLF
	cQrySF4 += " WHERE"													+ CRLF
	cQrySF4 += " 		SF4.F4_CODIGO	=	'" + cTesDevol		+ "'"	+ CRLF
	cQrySF4 += " 	AND	SF4.F4_FILIAL	=	'" + xFilial("SF4") + "'"	+ CRLF
	cQrySF4 += " 	AND	SF4.D_E_L_E_T_	<>	'*'"						+ CRLF

	TcQuery cQrySF4 New Alias "QRYSF4"

	if !QRYSF4->(EOF())
		cRetCF := QRYSF4->F4_CF

		aDadosCFO := {}
		Aadd(aDadosCfo,{"OPERNF","E"})
		Aadd(aDadosCfo,{"TPCLIFOR",GetAdvFVal("SA1","A1_TIPO",xFilial("SA1")+cA100For+cLoja,1,"")})
		Aadd(aDadosCfo,{"UFDEST",GetAdvFVal("SA1","A1_EST",xFilial("SA1")+cA100For+cLoja,1,"")})
		cRetCF := MaFisCfo(,cRetCF,aDadosCfo)
	endif

	QRYSF4->(DBCloseArea())
return (cRetCF)

/*=====================================================================================
Programa.:              MGFCR12A
Autor....:              wanderley.silva@totvs.com.br
Data.....:              26/12/2017
Descricao / Objetivo:   Validaço para X3_WHEN dos campos
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================*/
User Function MGFCR12A()
	Local l_Ret := .T.

	If AllTrim(M->cTipo) == "D"
		l_Ret := .F.
	EndIF

Return(l_Ret)

/*=====================================================================================
Programa.:              MGFCR12B
Autor....:              wanderley.silva@totvs.com.br
Data.....:              26/12/2017
Descricao / Objetivo:   Validaço para nao permitir alteraçao do codigo
Doc. Origem:            GAP CRM
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================*/
User Function MGFCR12B( n_Type )
Local  l_Ret    :=  .T.
Local  aArea    :=  GetArea()
Local  c_Var    :=  ReadVar() // Obtém o nome da variável
Local  c_Cont   :=  &( ReadVar() ) // Obtém o conteúdo da variável
Static c_Cod

If AllTrim( M->cTipo ) == "D" .and. !IsInCallStack( "LOJA720" )
   If n_Type == 1
      c_Cod := &( ReadVar() ) // Obtém o conteúdo da variável aCols[n, n_PosCod]
   ElseIf AllTrim( c_Var ) == "M->D1_COD"
          If &c_Var <> c_Cod //  >>>-----> Tentativa de trocar ou inserir codigo de produto no D1_COD.
             If .not. Empty( c_Cod )
                DbSelectArea( "SB1" )
                DbSetOrder( 1 ) // B1_FILIAL + B1_COD
                If DbSeek( xFilial( "SB1" ) + c_Cod )
                   MsgAlert( OEMToANSI( "Troca de produto não permitido para Devolução (com RAMI)." ) )
                EndIf
                &c_Var  :=  c_Cod
             Else
                MsgAlert( OEMToANSI( "Inserção novo produto não permitido para Devolução (com RAMI)." ) )
                &c_Var  :=  c_Cod+CRLF  //  {>>>-----> usado a constante CRLF para forçar o carriage return no campo D1_COD.
             EndIf
             l_Ret   :=  .F.
          EndIf
   ElseIf AllTrim( c_Var ) == "M->D1_QUANT" .or. AllTrim( c_Var ) == "M->D1_VUNIT"
          If &c_Var > c_Cod //  >>>-----> Tentativa de inserir valor maior no campo D1_QUANT ou D1_VUNIT.
             MsgAlert( OEMToANSI( "O Valor Unitário e/ou Quantidade não deve ser maior na Devolução (com RAMI)." ) )
             &c_Var  :=  c_Cod
             l_Ret   :=  .F.
          EndIf
   EndIf
EndIf

RestArea( aArea )
Return( l_Ret )

//-----------------------------------------------------------------
// Verifica se RAMI digitada já foi utilizada anteriormente
//-----------------------------------------------------------------
static function chkRami()
	local lRet		:= .T.
	local cQrySD1	:= ""

	cQrySD1 := " SELECT D1_ZRAMI" + CRLF
	cQrySD1 += " FROM " + retSQLName("SD1") + " SUBSD1" + CRLF
	cQrySD1 += " WHERE" + CRLF
	cQrySD1 += " 		SUBSD1.D1_ZRAMI		=	'" + MV_PAR01 + "'" + CRLF
	cQrySD1 += "	AND SUBSD1.D1_FILIAL	=	'" + xFilial("SD1")	+ "'" + CRLF
	cQrySD1 += "	AND SUBSD1.D_E_L_E_T_	<>	'*'" + CRLF

	TcQuery cQrySD1 New Alias "QRYSD1"

	if !QRYSD1->(EOF())
		msgAlert("RAMI " + allTrim(MV_PAR01) + " já utilizada em outra devolução.")
		lRet := .F.
	endif

	QRYSD1->(DBCloseArea())
return lRet

Static Function xQtdZAX(cxFil,cCodRam,cItemNf)

	Local aArea 	:= GetArea()
	Local aAreaZAV	:= ZAV->(GetArea())
	Local aAreaZAW	:= ZAW->(GetArea())
	Local aAreaZAX	:= ZAX->(GetArea())

	Local cNextAlias := GetNextAlias()

	Local nTotZAX	:= 0

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT
			SUM(ZAX.ZAX_QTD) ZAX_QTD
		FROM %Table:ZAX% ZAX
		WHERE
			ZAX.%NotDel%
		AND ZAX.ZAX_FILIAL = %Exp:cxFil%
		AND ZAX.ZAX_CDRAMI = %Exp:cCodRam%
		AND ZAX.ZAX_ITEMNF = %Exp:cItemNf%

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		nTotZAX += (cNextAlias)->ZAX_QTD
		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aAreaZAX)
	RestArea(aAreaZAW)
	RestArea(aAreaZAV)
	RestArea(aArea)

Return nTotZAX