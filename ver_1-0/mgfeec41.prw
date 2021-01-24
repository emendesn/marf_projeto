#include 'protheus.ch'

/*/{Protheus.doc} MGFEEC41
//TODO Gravação de campos de frete e seguro para empresa 90
@author leonardo.kume
@since 12/01/2018
@version 6
@return boolean, true

@type function
/*/
user function MGFEEC41()

	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	
	Local lRet 		:= .t.
	Local aAreaEE7 	:= EE7->(GetArea())
	Local aAreaSC5 	:= SC5->(GetArea())
	Local cPedido 	:= EE7->EE7_PEDIDO
	Local aDados 	:= {EE7->EE7_ZFRETE,;
						EE7->EE7_ZSEGUR} 	

	If 	IsInCallStack("EECAP100") .and. cParam ==  "GRV_PED" 

		//Altera pedido de venda para integrar no TAURA
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+EE7->EE7_PEDFAT))
			RecLock("SC5",.F.)
			SC5->C5_ZLIBENV := "S"
			SC5->(MsUnlock())
		EndIf

		DbSelectArea("EE7")
		DbSetOrder(1)
		If DbSeek(xFilial("EE7","900001")+cPedido)
			RecLock("EE7",.F.)
				EE7->EE7_FRPREV := aDados[1]
				EE7->EE7_ZFRETE := aDados[1]
				EE7->EE7_SEGPRE := aDados[2]
				EE7->EE7_ZSEGUR := aDados[2]
			EE7->(MsUnlock())
		EndiF
	EndiF
	
	
	EE7->(RestArea(aAreaEE7))
	SC5->(RestArea(aAreaSC5))
	
return