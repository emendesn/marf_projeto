#include 'protheus.ch'
#include 'parmtype.ch'

user function GFEA0652()

Local aArea 	:= GetArea()
Local aAreaSFM	:= SFM->(GetArea())

Local cTes   := GW3->GW3_TES
Local cFilUt := GETMV("MGF_FILTES")

If !ALLTRIM(xFilial('GW3')) $ cFilUt
	If ALLTRIM(GW3->GW3_CDESP) <> 'ND'
		///Apenas entrará na regra de preenchimento da TES caso o usuário não faça alteração na tela de dados da integração
		/// caso isso ocorra será considerada a TES informada pelo usuário
		If GW3->GW3_TES = GW3->GW3_ZTESOR
			If FindFunction("U_MGFGFE28")
				cTes := U_MGFGFE28()
			EndIf
		EndIf
	EndIf
Else
	If GW3->GW3_TES = GW3->GW3_ZTESOR
		If FindFunction("U_MGFGFE28")
			cTes := U_MGFGFE28()
		EndIf
	EndIf
EndIf

RestArea(aAreaSFM)
RestArea(aArea)

return cTes