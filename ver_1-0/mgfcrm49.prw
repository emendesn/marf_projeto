#include 'protheus.ch'
#include 'parmtype.ch'

#define CRLF chr(13) + chr(10)
/*
=====================================================================================
Programa............: MGFCRM49
Autor...............: Flavio Dentello
Data................: 08/03/2017
Descricao / Objetivo: Ponto de entrada finalizar a Rami
Doc. Origem.........: CRM- RAMI
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
user function MGFCRM49()

	Local lRet 	 	 := .T.
	Local nI   	 	 := 0
	Local cProd 	 := " RAMI não será finalizada!!! Alguns produtos não atenderam as condições para finalizar a RAMI !"
	Local cAliasZAX	 := "" // RESOLUÇÃO
	Local cQuery	 := ""
	Local nQtdOco	 := 0 //Quantidade de ocorrências
	Local nQtdRes	 := 0 //Quantidade de Resolução
	Local nQuant	 := 0 //Quantidade de saldo
	Local lFinaliza  := .F.
	Local lNFinaliza := .F.
	Local nPerc		 := GetMv('MGF_TOLRAM')
	local aArea	     := getArea()
	Local aAreaZAV   := ZAV->(getArea())
	Local aAreaZAX   := ZAX->(getArea())
	local nPosRami	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZRAMI"	})
	local nPosProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"		})
	local nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"	})
	local nPosQuant	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"	})
	local nPosVlUni	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"	})
	local nPosVlTot	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"	})
	local nPosDoc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_DOC"  	})
	local nPosSer	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_SERIE"  	})

	local nPosItemOr	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEMORI"  	})
	local nPosNFOrig	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_NFORI"  		})
	local nPosSerOri	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_SERIORI"  	})

	LOCAL lAchou	:= .F.
	Local lxAchou	:= .f.

	IF !INCLUI .AND. !ALTERA
		If !Empty(ACOLS[n][nPosRami])
			For nI := 1 to len(aCols)
				ZAV->(DbGotop())
				DbSelectArea('ZAV')
				DbSetOrder(1)
				IF ZAV->(MsSeek(xfilial('ZAV') + ACOLS[nI][nPosRami] ))
					IF ZAV->ZAV_STATUS =='1'
						RecLock("ZAV",.F.)
						ZAV->ZAV_STATUS := '0'
						ZAV->(MSUNLOCK())
					ENDIF
					ZAX->(DbGotop())
					DbSelectArea('ZAX')
					DbSetOrder(1)
					IF ZAX->(MsSeek(xfilial('ZAX') + ACOLS[nI][nPosRami]))
						WHILE ZAX->(!EOF()) .AND. ZAX->ZAX_CDRAMI==ACOLS[nI][nPosRami]
							IF ZAX->ZAX_CODPRO == ACOLS[nI][nPosProd] .AND. ZAX->ZAX_QTD == ACOLS[nI][nPosQuant] .AND.;
							ALLTRIM(ZAX->ZAX_NFGER)==ALLTRIM(SF1->F1_DOC) .AND. ALLTRIM(ZAX->ZAX_SERGR)==ALLTRIM(SF1->F1_SERIE)
								RecLock("ZAX",.F.)
								ZAX->(DBDELETE())
								ZAX->(MSUNLOCK())
							ENDIF
							ZAX->(DBSKIP())
						ENDDO
					ENDIF
				ENDIF
			NEXT
		ENDIF
		RestArea(aArea)
		Restarea(aAreaZAV)
		Restarea(aAreaZAX)
		RETURN .T.
	ENDIF

	If !Empty(ACOLS[n][nPosRami])
		For nI := 1 to len(aCols)
			if !aCols[nI,len(aHeader)+1]
				///Grava resolução
				ZAV->(DbGotop())
				DbSelectArea('ZAV')
				ZAV->(DbSetOrder(1))//ZAV_FILIAL+ZAV_CODIGO
				IF ZAV->(MsSeek(xfilial('ZAV') + ACOLS[nI][nPosRami] ))
					ZAX->(DbGotop())
					DbSelectArea('ZAX')
					ZAX->(DbSetOrder(1))//ZAX_FILIAL+ZAX_CDRAMI+ZAX_ITEMNF
					IF ZAX->(MsSeek(xfilial('ZAX') + ACOLS[nI][nPosRami]))
						WHILE ZAX->(!EOF()) .AND. ZAX->ZAX_CDRAMI == ACOLS[nI][nPosRami]
							IF ZAX->ZAX_CODPRO == ACOLS[nI][nPosProd] .AND. ZAX->ZAX_QTD == ACOLS[nI][nPosQuant] .AND.;
							EMPTY(ZAX->ZAX_NFGER) .AND. EMPTY(ZAX->ZAX_SERGR)
								lAchou:= .T.
								EXIT
							ELSE
								lAchou:= .F.
							ENDIF
							ZAX->(DBSKIP())
						ENDDO
					ELSE
						lAchou:= .F.
					ENDIF
					IF lAchou
						RecLock("ZAX",.F.)
					ELSE
						RecLock("ZAX",.T.)
					ENDIF
					ZAX->ZAX_FILIAL := ZAV->ZAV_FILIAL
					ZAX->ZAX_CDRAMI := ACOLS[nI][nPosRami]
					ZAX->ZAX_ITEMNF := ACOLS[nI][nPosItemOr]
					ZAX->ZAX_CODPRO := ACOLS[nI][nPosProd]
					ZAX->ZAX_DESCPR := POSICIONE('SB1',1,XFILIAL('SB1') + ACOLS[nI][nPosProd], "B1_DESC")
					ZAX->ZAX_QTD    := ACOLS[nI][nPosQuant]
					ZAX->ZAX_PRECO  := ACOLS[nI][nPosVlUni]
					ZAX->ZAX_TOTAL  := ACOLS[nI][nPosVlTot]
					ZAX->ZAX_NOTA   := ZAV->ZAV_NOTA
					ZAX->ZAX_SERIE  := ZAV->ZAV_SERIE
					ZAX->ZAX_DATA   := DDATABASE
					ZAX->ZAX_ID     := STRZERO(nI,4) 
					ZAX->ZAX_NFGER  := SF1->F1_DOC
					ZAX->ZAX_SERGR  := SF1->F1_SERIE
					ZAX->(MsUnlock())
				EndIf
			EndIf
		Next
		For nI := 1 to len(aCols)
			lxAchou:= .f.
			If !aCols[nI,len(aHeader)+1]
				DbSelectArea('ZAW')
				ZAW->(DbSetOrder(1))	//ZAW_FILIAL+ZAW_CDRAMI+ZAW_ITEMNF
				If ZAW->(MSseek(XFILIAL('ZAW') + ACOLS[nI][nPosRami] ))

					While ZAW->(!EOF()) .AND. ZAW->ZAW_CDRAMI==ACOLS[nI][nPosRami]

						If ZAW->ZAW_ITEMNF == aCols[nI, nPosItemOr] .and.;
							ZAW->ZAW_NOTA == aCols[nI, nPosNFOrig] .and.;
							ZAW->ZAW_SERIE == aCols[nI, nPosSerOri] .and.;
							ZAW->ZAW_CDPROD == aCols[nI, nPosProd] .and.;
							aCols[nI, nPosQuant] <= ZAW->ZAW_QTD //Apenas para garatia conta sera realizada em baixo
							lxAchou:= .t.
							Exit
						EndIf

						ZAW->(DBSKIP())
					enddo

					if lxAchou
						DbSelectArea('ZAV')
						ZAV->(DbSetOrder(1))//ZAV_FILIAL+ZAV_CODIGO
						ZAV->(MSseek(xFilial('ZAV') + ACOLS[nI][nPosRami] ))

						If xAltStau(xFilial('ZAV'),ZAV->ZAV_CODIGO)
							RecLock('ZAV', .F.)
							ZAV->ZAV_STATUS := "1"
							ZAV->(MsUnlock())
							MsgInfo('RAMI ' + ACOLS[nI][nPosRami] + ' foi finalizada com sucesso!!!' )
						Else
							MsgInfo('RAMI ' + ACOLS[nI][nPosRami] + ' foi atualizada com sucesso!!!' )
						EndIf

					else
						MsgAlert (cProd)
					ENDIF
				endif
			endif
		next

		RestArea(aArea)
		Restarea(aAreaZAV)
		Restarea(aAreaZAX)

	EndIf
return lRet

Static Function xAltStau(cxFil,cCodRam)

	Local aArea 	:= GetArea()
	Local aAreaZAV	:= ZAV->(GetArea())
	Local aAreaZAW	:= ZAW->(GetArea())
	Local aAreaZAX	:= ZAX->(GetArea())

	Local cNextAlias := GetNextAlias()

	Local lRet		 := .T.

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

		SELECT ZAV_FILIAL,ZAV_CODIGO,ZAW_ITEMNF,ZAW_QTD
		FROM %Table:ZAV% ZAV
		INNER JOIN %Table:ZAW% ZAW
			ON ZAV.ZAV_FILIAL = ZAW.ZAW_FILIAL
			AND ZAV_CODIGO = ZAW.ZAW_CDRAMI
		WHERE
				ZAV.%NotDel%
			AND	ZAW.%NotDel%
			AND ZAV.ZAV_FILIAL = %Exp:cxFil%
			AND ZAV.ZAV_CODIGO = %Exp:cCodRam%

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())

		If (cNextAlias)->ZAW_QTD > xCaRamRes((cNextAlias)->ZAV_FILIAL,(cNextAlias)->ZAV_CODIGO,(cNextAlias)->ZAW_ITEMNF)
			lRet := .F.
			Exit
		EndIf

		(cNextAlias)->(dbSkip())
	EndDo

	(cNextAlias)->(DbClosearea())

	RestArea(aAreaZAX)
	RestArea(aAreaZAW)
	RestArea(aAreaZAV)
	RestArea(aArea)

return lRet

/*
	Calculo Rami Resolução
*/
Static Function xCaRamRes(cxFil,cCodRam,cItemNf)

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

