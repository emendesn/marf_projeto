#INCLUDE "PROTHEUS.CH"
//#INCLUDE "parmtype.ch"

User Function MGFCRM48()

Local lRet 		  := .T. 
Local nI  		  := 0
local nPosRami	  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ZRAMI"	  })
local nPosNfori	  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_NFORI"	  })
local nPosSerori  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_SERIORI" })
local nPosItemOri := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEMORI" })

local aArea		  := getArea()
local aAreaZAW    := ZAW->(getArea())
local aAreaZAV	  := ZAV->(getArea())

If !Isincallstack("GFEA065") .and.  M->cTipo == "D"
	DBSelectArea("ZAV")

	ZAV->(DBSetOrder(4))

	For nI := 1 to len(aCols)
		if !empty( ACOLS[nI, nPosRami] ) .and.  !empty(ACOLS[ nI, nPosNfori] ) .and.  !empty(ACOLS[ nI, nPosSerori] )

			ZAV->(DBGoTop())

			If ZAV->( DBSeek( XFILIAL("ZAV") + ACOLS[ nI, nPosRami ] + ACOLS[ nI, nPosNfori ] + ACOLS[ nI, nPosSerori ] +M->cA100For + M->cLoja ) )
				If ZAV->ZAV_ORDRET == "1"
					If ZAV->ZAV_COMERC <> "1"
						Iif(FindFunction("APMsgAlert"), APMsgAlert("RAMI n�o aprovada pelo Comercial!",), MsgAlert("RAMI n�o aprovada pelo Comercial!",))
						lRet := .F. 
						exit
					ElseIf ZAV->ZAV_QUALID <> "1"
						Iif(FindFunction("APMsgAlert"), APMsgAlert("RAMI n�o aprovada pela Qualidade!",), MsgAlert("RAMI n�o aprovada pela Qualidade!",))
						lRet := .F. 
						exit
					ElseIf ZAV->ZAV_EXPEDI <> "1"
						Iif(FindFunction("APMsgAlert"), APMsgAlert("RAMI n�o aprovada pela Expedi��o!",), MsgAlert("RAMI n�o aprovada pela Expedi��o!",))
						lRet := .F. 
						exit
					ElseIf ZAV->ZAV_PCP <> "1"
						Iif(FindFunction("APMsgAlert"), APMsgAlert("RAMI n�o aprovada pelo PCP!",), MsgAlert("RAMI n�o aprovada pelo PCP!",))
						lRet := .F. 
						exit
					ElseIf ZAV->ZAV_TRANSP <> "1"
						Iif(FindFunction("APMsgAlert"), APMsgAlert("RAMI n�o aprovada pelo Transporte!",), MsgAlert("RAMI n�o aprovada pelo Transporte!",))
						lRet := .F. 
						exit
					EndIf
				EndIf

				DBSelectArea("ZAW")
				ZAW->(DBSetOrder(1))
				ZAW->(DBGoTop())
				If !ZAW->( DBSeek( XFILIAL("ZAW") + ACOLS[ nI, nPosRami ] + ACOLS[ nI, nPosItemOri ]  ) )
					Iif(FindFunction("APMsgAlert"), APMsgAlert("Item "+ACOLS[nI,nPosItemOri]+" da RAMI "+ACOLS[nI,nPosRami]+" n�o encontrado!",), MsgAlert("Item "+ACOLS[nI,nPosItemOri]+" da RAMI "+ACOLS[nI,nPosRami]+" n�o encontrado!",))
						lRet := .F. 
						exit
				Endif
			else
				Iif(FindFunction("APMsgAlert"), APMsgAlert("N�o foi localizada a RAMI "+ACOLS[nI,nPosRami],), MsgAlert("N�o foi localizada a RAMI "+ACOLS[nI,nPosRami],))
				lRet := .F. 
				exit
			EndIf
		else
			Iif(FindFunction("APMsgAlert"), APMsgAlert("Para Notas do Tipo de Devolu��o deve ser preenchida uma RAMI, Nota Fiscal, S�rie e Item de origem.",), MsgAlert("Para Notas do Tipo de Devolu��o deve ser preenchida uma RAMI, Nota Fiscal, S�rie e Item de origem.",))
			lRet := .F. 
			exit
		endif
	Next
EndIf

restArea(aAreaZAV)
restArea(aAreaZAW)
restArea(aArea)

return lRet
