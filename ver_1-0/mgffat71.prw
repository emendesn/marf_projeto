#include 'protheus.ch'

user function MGFFAT71()
	
	Local lPesoBru	:= GetMv("MGF_FAT71",,.T.)
	Local aAreaSD2	:= SD2->(GetArea())
	Local aAreaSF2	:= SF2->(GetArea())
	Local nPesoBru	:= 0
	Local nPesoLiq	:= 0
	Local aPedido	:= {}
	Local cPedido	:= ""
	Local nI		:= 0
		
	If lPesoBru
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		If SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE)))
			While !SD2->(Eof()) .AND. SD2->(D2_DOC+D2_SERIE) == SF2->(F2_DOC+F2_SERIE)
				If cPedido <> SD2->D2_PEDIDO
					aAdd(aPedido,SD2->D2_PEDIDO)
					cPedido := SD2->D2_PEDIDO
				EndIf
				SD2->(Dbskip())
			EndDo
		EndIf
		For nI := 1 to Len(aPedido)
			nPesoBru += GetAdvFVal("SC5","C5_PBRUTO",xFilial("SC5")+aPedido[nI],1,0)
			nPesoLiq += GetAdvFVal("SC5","C5_PESOL",xFilial("SC5")+aPedido[nI],1,0)
		Next nI
		If nPesoBru > 0
			RecLock("SF2",.F.)
			SF2->F2_PBRUTO := nPesoBru
			SF2->F2_PLIQUI := nPesoLiq
			SF2->(MsUnlock())
		EndIf
	endIf
	
	SD2->(RestArea(aAreaSD2))
	SF2->(RestArea(aAreaSF2))
	
	
return