#include 'protheus.ch'

/*/{Protheus.doc} MGFEEC26
//TODO Ponto de entrada para grava campos do pedido de exportação
para o pedido de venda
@author leonardo.kume
@since 05/05/2017
@version 6

@type function
/*/
user function MGFEEC26()

	Local aArea			:= GetArea()
	Local aAreaEE7		:= EE7->(GetArea())
	Local aAreaSC5		:= SC5->(GetArea())
	Local aAreaSC6		:= SC6->(GetArea())
	Local nRecnoWIt		:= 0

	If IsInCallStack("EECAP100")
			RecLock('SC5',.F.)
			SC5->C5_TPFRETE := M->EE7_ZFREFA
			SC5->C5_ZTIPPED := M->EE7_ZTIPPE
			SC5->C5_ZOBS 	:= M->EE7_ZOBS
			SC5->(MsunLock())

		If Select("WorkIt") > 0
			SC6->(dbSetOrder(1))
			nRecnoWIt := WorkIt->(RecNo())
			WorkIt->(dbGotop())
			While WorkIt->(!Eof())
				If !Empty(WorkIt->EE8_FATIT)
					If (!Empty(WorkIt->EE8_ZQTDSI) .or. !Empty(WorkIt->EE8_ZGERSI))
						If SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM+WorkIt->EE8_FATIT))
							SC6->(RecLock("SC6",.F.))
							If !Empty(WorkIt->EE8_ZQTDSI)
								SC6->C6_ZQTDSIF := WorkIt->EE8_ZQTDSI
							Endif
							If !Empty(WorkIt->EE8_ZGERSI)
								SC6->C6_ZGERSIF := WorkIt->EE8_ZGERSI
							Endif
							SC6->(MsUnLock())
						Endif
					Else
						If SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM+WorkIt->EE8_FATIT))
							SC6->(RecLock("SC6",.F.))
							SC6->C6_ZDTMIN  := WorkIt->EE8_ZDTMIN
							SC6->C6_ZDTMAX  := WorkIt->EE8_ZDTMAX
							SC6->(MsUnLock())
						Endif
					EndIf
				Endif
	        	WorkIt->(dbSkip())
			EndDo
			WorkIt->(dbGoto(nRecnoWIt))
		Endif
	EndIf

	EE7->(RestArea(aAreaEE7))
	SC5->(RestArea(aAreaSC5))
	SC6->(RestArea(aAreaSC6))
	RestArea(aArea)

return .t.