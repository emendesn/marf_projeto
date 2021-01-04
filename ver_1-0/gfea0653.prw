#include 'protheus.ch'
#include 'parmtype.ch'

User Function GFEA0653()
    Local aArea := GetArea()
	Local aAreaGW3  := GW3->(Getarea())

	Local cRet := GetMv("MV_CPDGFE")

   	If FindFunction("U_MGFCTB232")

   		U_MGFCTB232()

		If !Empty(GW3->GW3_ZCOND)
   			cRet := GW3->GW3_ZCOND
   			Return cRet
   		EndIf

			If !Empty(cPagtox)// <> "" .OR. NIL
				cRet := cPagtox
			//Else
			  //	If !Empty(ZD2->ZD2_CONDPG)// <> "" .OR. NIL
				//	cRet := ZD2->ZD2_CONDPG
				//EndIf
			EndIf
	EndIf

	RestArea(aAreaGW3)
	RestArea(aArea)

Return cRet


User Function MGFCONPG()

	Local ccpdGFE := GW3->GW3_ZCOND
	Local cCadastro := "Alteração de condição de pagamento"
	Local cPritDF := GW3->GW3_PRITDF

	Local oDlg
	Local nAlt := 350
	Local nLrg := 520
	Local cDsTransp
	Local oCombo
	Local cCombo
	Local lRet 	:= .F.
	Local cValores := ""
	Local aVlrs := {}

	CursorWait()

	//--------------------------
	// Montagem da tela
	//--------------------------
	Define MsDialog oDlg Title cCadastro From 00,00 To 350,520 Of oMainWnd Color CLR_BLACK,RGB(225,225,225) Pixel
	oDlg:lEscClose := .F.

	oPnlA := tPanel():New(00,00,,oDlg,,,,,,30,135,.F.,.F.)
	oPnlA:Align := CONTROL_ALIGN_ALLCLIENT

	@ 22,15 Say "Cond.Pagto"			Of oPnlA COLOR CLR_BLACK Pixel
//	@ 20,60 MSGET ccpdGFE   SIZE 100,11 Picture "@!" Of oPnlA F3 "SE4"   When .T.   Pixel //alterado Rafael 29/11/2018
	@ 20,60 MSGET ccpdGFE   SIZE 100,11 Picture "@!" Of oPnlA F3 "SE4" VALID ExistCpo("SE4",ccpdGFE)  When .T.   Pixel
	CursorArrow()

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(ODlg,{||lRet := .T. ,ODlg:End()},{||lRet := .F.  ,ODlg:End(),},,) CENTERED

	cValores := AllTrim(ccpdGFE)

	If empty(cValores)
		Return .F.
	EndIf
//	If !empty(ccpdGFE) //alterado Rafael
	If !empty(ccpdGFE) .and. lRet== .t.
		if !ExistCpo("SE4",ccpdGFE)
			MsgInfo('Condição de pagamento inválida!')
			return .f.
		endif	
		RecLock('GW3',.F.)
		GW3->GW3_ZCOND := ccpdGFE
		GW3->(MsUnlock())
		MsgInfo('Condição alterada com sucesso!')
	EndIf

Return .T.