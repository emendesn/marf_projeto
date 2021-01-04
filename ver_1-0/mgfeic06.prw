#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} mgfeic06
//TODO Progama para confirmar/cancelar numeração do EEC
GAP 039
@author leonardo.kume
@since 12/11/2017
@version 6

@type function
/*/
User function eic06x()
	Local aAreaSW6 := {}
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb1,If(Type("ParamIxb") = "C",ParamIxb,""))


	If cParam == "FINAL_OPCAO"//"DI500SAIR"//
		aAreaSW6 := SW6->(GetArea())
		RollbackSx8()
		RestArea(aAreaSW6)
	EndIf
	
	
Return .t.

User function eic06c()
	Local aAreaSW6 := {}
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb1,If(Type("ParamIxb") = "C",ParamIxb,""))

	If cParam == "POS_GRAVA_TUDO"
		aAreaSW6 := SW6->(GetArea())
		ConfirmSx8()
		RestArea(aAreaSW6)
	EndIf
	
	
Return .t.
