#include 'protheus.ch'
#include 'parmtype.ch'

user function MGFCOM92()

	RPCSetType(3)
	RpcSetEnv( '01' , '010001' , Nil, Nil, "FAT", Nil )
	SetFunName("MGFCOM92")

		xEncPCSemGRD()
		AlcaSemSC()

	RpcClearEnv()

return

Static Function xEncPCSemGRD()

	Local cQrySC7 := GetNextAlias()

	//(cQrySC7)->(dbGoTop())

	BeginSql Alias cQrySC7

		SELECT DISTINCT C7_FILIAL , C7_NUM
			FROM
				%TABLE:SC7% C7
		WHERE
			C7.%NOTDEL%
		AND (C7.C7_QUJE=0 AND C7.C7_QTDACLA=0)
		AND C7.C7_ZCODGRD <> 'ZZZZZZZZZZ'
		AND C7.C7_ZPTAURA = ' '
		AND C7.C7_RESIDUO = ' '
		AND C7.C7_FILIAL || C7.C7_NUM || 'PC' NOT IN
													(SELECT CR.CR_FILIAL|| TRIM(CR.CR_NUM)|| CR.CR_TIPO
													FROM %TABLE:SCR% CR
													WHERE
														CR.%NOTDEL% AND
														CR.CR_TIPO = 'PC')

	EndSql

	dbSelectArea("SC7")

	While (cQrySC7)->(!EOF())

		SC7->(dbSetOrder(1))//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN

		If SC7->(dbSeek((cQrySC7)->(C7_FILIAL + C7_NUM)))
			xGerGrd((cQrySC7)->C7_FILIAL,(cQrySC7)->C7_NUM)
		EndIf

		(cQrySC7)->(dbSkip())
	EndDo

	(cQrySC7)->(dbCloseArea())

return

Static Function xGerGrd(cxFil,cPed)

	Local aArea 	:= GetArea()
	Local aAreaSC1	:= SC1->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	Local aAreaSC7	:= SC7->(GetArea())

	Local cRet := ''
	Local cChavSC7  := cxFil + cPed
	Local cCC 		 := ''

	Local cNextAlias 	:= GetNextAlias()

	Local nIt			:= 1
	Local nTotal		:= xTotPed(cxFil,cPed)
	Local cNome			:= xNomFoPC(cxFil,cPed)

	Local cConaPro		:= ''

	Local cxFilZAD		:= xFilial("ZAD",cxFil)

	/*If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif*/

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

	//Inclui PC

		dbSelectArea('SC7')
		SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

		//Bloquar Pedido
		If SC7->(dbSeek(cChavSC7))

			If !Empty(SC7->C7_CC)
				cCC := SC7->C7_CC
			Else
				cCC := SC7->C7_ZCC
			EndIf

			aGrupo 	 :=	xEncAlc('PC',cCC,/*cGrupo*/,/*cNaturez*/)

			dbSelectArea('SCR')
			SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL

			If SCR->(dbSeek(cxFil + 'PC' + PadR(cPed,TamSX3('CR_NUM')[1])))
				While SCR->(!EOF()) .and. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) ==  cxFil + 'PC' + PadR(cPed,TamSX3('CR_NUM')[1])
					RecLock('SCR',.F.)
					SCR->(dbDelete())
					SCR->(MsUnLock())
					SCR->(dbSkip())
				EndDo
			EndIf

			BeginSql Alias cNextAlias

				SELECT
				    ZAD_SEQ,
				    ZAD_NIVEL,
				    ZA2_CODUSU,
				    ZAD_VALINI,
				    ZAD_VALFIM
				FROM %Table:ZAD% ZAD
				INNER JOIN %Table:ZA2% ZA2
				  ON ZA2_FILIAL = ZAD_FILIAL AND
				     ZA2_NIVEL =  ZAD_NIVEL  AND
				     ZA2_EMPFIL = %Exp:cxFil%
				WHERE
				  ZAD.%NotDel% AND
				  ZA2.%NotDel% AND
				  ZA2.ZA2_LOGIN <> ' ' AND
				  ZAD_FILIAL = %Exp:cxFilZAD% AND
				  ZAD_CODIGO = %Exp:aGrupo[1]% AND
				  ZAD_VERSAO = %Exp:aGrupo[2]%
				ORDER BY ZAD_SEQ

			EndSql

			(cNextAlias)->(dbGoTop())

			While (cNextAlias)->(!EOF())

				If nTotal >= (cNextAlias)->ZAD_VALINI .And. nTotal <= (cNextAlias)->ZAD_VALFIM

					RecLock('SCR',.T.)

					SCR->CR_FILIAL 	:= cxFil
					SCR->CR_NUM 	:= cPed
					SCR->CR_TIPO 	:= 'PC'
					SCR->CR_USER 	:= (cNextAlias)->ZA2_CODUSU
					SCR->CR_ITGRP 	:= (cNextAlias)->ZAD_SEQ
					SCR->CR_NIVEL 	:= (cNextAlias)->ZAD_SEQ
					SCR->CR_STATUS 	:= IIF(nIt == 1,'02','01')
					SCR->CR_EMISSAO	:= dDataBase
					SCR->CR_TOTAL 	:= nTotal
					SCR->CR_MOEDA 	:= SC7->C7_MOEDA
					SCR->CR_TXMOEDA	:= SC7->C7_TXMOEDA
					SCR->CR_ZCODGRD := %Exp:aGrupo[1]%
					SCR->CR_ZVERSAO := %Exp:aGrupo[2]%
					SCR->CR_ZNOMFOR := cNome
					SCR->CR_ZNIVEL  := (cNextAlias)->ZAD_NIVEL

					SCR->(MsUnlock())
					nIt ++
				EndIf

				(cNextAlias)->(dbSkip())

			EndDo

			While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == cChavSC7
				Reclock('SC7',.F.)
				SC7->C7_CONAPRO := 'B'
				SC7->C7_ZIDINTE := ''
				SC7->C7_ZBLQFLG := 'S'
				SC7->C7_ZCODGRD := aGrupo[1]
				SC7->C7_ZVERSAO := aGrupo[2]

				SC7->(MsUnLock())

				SC7->(dbSkip())
			EndDo

		EndIf

	(cNextAlias)->(DbClosearea())

	RestArea(aAreaSC7)
	RestArea(aAreaSCR)
	RestArea(aAreaSC1)
	RestArea(aArea)

Return

Static Function xEncAlc(cTipo,cCC,cGrupo,cNaturez,cxFil)

	Local aArea 		:= GetArea()
	Local cNextAlias 	:= GetNextAlias()
	Local aRet			:= {'','',''}

	Local cGrdAvRec		:= GETMV("MGF_GRDAR")//Grade Aviso de Recebimento

	Local cxFilZAB		:= xFilial("ZAB",cxFil)
	Local cxFilZAC		:= xFilial("ZAC",cxFil)
	Local cxFilZAD		:= xFilial("ZAD",cxFil)

	Default cGrupo   := ''
	Default cNaturez := ''

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	If cTipo = 'SC'

		BeginSql Alias cNextAlias
			SELECT
				ZAB.ZAB_CODIGO,
				ZAB.ZAB_VERSAO,
				ZAC.ZAC_GRPPRD
			FROM
				%Table:ZAB% ZAB
			INNER JOIN %Table:ZAC% ZAC
				 ON ZAC.ZAC_FILIAL = ZAB.ZAB_FILIAL
				AND ZAC.ZAC_CODIGO = ZAB.ZAB_CODIGO
				AND ZAC.ZAC_VERSAO = ZAB.ZAB_VERSAO
			WHERE
				ZAB.%NotDel% AND
				ZAC.%NotDel% AND
				ZAB.ZAB_FILIAL = %Exp:cxFilZAB% AND
				ZAB.ZAB_TIPO = 'T' AND
				ZAB.ZAB_CC = %Exp:cCC% AND
				ZAB.ZAB_HOMOLO = 'S' AND
				ZAC.ZAC_GRPPRD = %Exp:cGrupo%
		EndSql

		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!EOF())
			aRet := {(cNextAlias)->ZAB_CODIGO,(cNextAlias)->ZAB_VERSAO,(cNextAlias)->ZAC_GRPPRD }
			(cNextAlias)->(dbSkip())
		EndDo

	ElseIf cTipo = 'PC'

		If SC7->C7_TIPO = 1
			BeginSql Alias cNextAlias
				SELECT
					ZAB.ZAB_CODIGO,
					ZAB.ZAB_VERSAO
				FROM
					%Table:ZAB% ZAB
				WHERE
					ZAB.%NotDel% AND
					ZAB.ZAB_FILIAL = %Exp:cxFilZAB% AND
					ZAB.ZAB_TIPO = 'P' AND
					ZAB.ZAB_CC = %Exp:cCC% AND
					ZAB.ZAB_HOMOLO = 'S'
			EndSql
		Else
			BeginSql Alias cNextAlias
				SELECT
					ZAB.ZAB_CODIGO,
					ZAB.ZAB_VERSAO
				FROM
					%Table:ZAB% ZAB
				WHERE
					ZAB.%NotDel% AND
					ZAB.ZAB_FILIAL = %Exp:cxFilZAB% AND
					ZAB.ZAB_TIPO = 'P' AND
					ZAB.ZAB_CODIGO = %Exp:cGrdAvRec% AND
					ZAB.ZAB_HOMOLO = 'S'
			EndSql
		EndIf
		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!EOF())
			aRet := {(cNextAlias)->ZAB_CODIGO,(cNextAlias)->ZAB_VERSAO,' '}
			(cNextAlias)->(dbSkip())
		EndDo

	ElseIf cTipo = 'ZC'

		BeginSql Alias cNextAlias
			SELECT
				ZAB.ZAB_CODIGO,
				ZAB.ZAB_VERSAO,
				ZAE.ZAE_NATURE
			FROM
				%Table:ZAB% ZAB
			INNER JOIN %Table:ZAE% ZAE
				 ON ZAE.ZAE_FILIAL = ZAB.ZAB_FILIAL
				AND ZAE.ZAE_CODIGO = ZAB.ZAB_CODIGO
				AND ZAE.ZAE_VERSAO = ZAB.ZAB_VERSAO
			WHERE
				ZAB.%NotDel% AND
				ZAE.%NotDel% AND
				ZAB.ZAB_FILIAL = %Exp:cxFilZAB% AND
				ZAB.ZAB_TIPO = 'T' AND
				ZAB.ZAB_CC = %Exp:cCC% AND
				ZAB.ZAB_HOMOLO = 'S' AND
				ZAE.ZAE_NATURE = %Exp:cNaturez%
		EndSql

		(cNextAlias)->(DbGoTop())

		While (cNextAlias)->(!EOF())
			aRet := {(cNextAlias)->ZAB_CODIGO,(cNextAlias)->ZAB_VERSAO,(cNextAlias)->ZAE_NATURE}
			(cNextAlias)->(dbSkip())
		EndDo

	EndIf

	RestArea(aArea)

return aRet

Static Function xTotPed(cxFil,cChav)

	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())

	Local nRet := 0

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

	If SC7->(dbSeek(cxFil + cChav))
		While SC7->(!EOF()) .and. SC7->(C7_FILIAL + C7_NUM) == cxFil + cChav
			nRet += SC7->C7_TOTAL
			SC7->(dbSkip())
		EndDo
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

Return nRet

Static Function xNomFoPC(cxFil,cChav)

	Local aArea 	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSA2	:= SA2->(GetArea())

	Local cRet := ' '

	dbSelectArea('SC7')
	SC7->(dbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN

	If SC7->(dbSeek(cxFil + cChav))

		dbSelectArea('SA2')
		SA2->(dbSetOrder(1))//A2_FILIAL, A2_COD, A2_LOJA

		If SA2->(dbSeek(xFilial('SA2',SC7->C7_FILIAL) + SC7->(C7_FORNECE + C7_LOJA) ))
			cRet := SA2->A2_NOME
		EndIf

	EndIf

	RestArea(aAreaSA2)
	RestArea(aAreaSC7)
	RestArea(aArea)

Return cRet

// rotina para excluir registros da tabela SCR tipo SC, cuja solicitacao de compras nao foi localizada
Static Function AlcaSemSC()

Local cAliasTrb := GetNextAlias()

BeginSql Alias cAliasTrb

	SELECT DISTINCT CR_FILIAL , CR_NUM
	FROM
	%TABLE:SCR% SCR
	WHERE
	SCR.%NOTDEL%
	AND CR_TIPO = 'SC'
	AND CR_FILIAL || TRIM(CR_NUM) NOT IN
										(SELECT C1_FILIAL || TRIM(C1_NUM)
										FROM %TABLE:SC1% SC1
										WHERE
										SC1.%NOTDEL%)

EndSql

SCR->(dbSetOrder(1))//CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL
While (cAliasTrb)->(!Eof())
	If SCR->(dbSeek((cAliasTrb)->CR_FILIAL+'SC'+(cAliasTrb)->CR_NUM))
		While SCR->(!Eof()) .and. SCR->CR_FILIAL+SCR->CR_TIPO+Alltrim(SCR->CR_NUM) == (cAliasTrb)->CR_FILIAL+'SC'+Alltrim((cAliasTrb)->CR_NUM)
			SCR->(RecLock('SCR',.F.))
			SCR->(dbDelete())
			SCR->(MsUnLock())
			SCR->(dbSkip())
		EndDo
	Endif
	(cAliasTrb)->(dbSkip())	
Enddo

(cAliasTrb)->(DbClosearea())

Return()