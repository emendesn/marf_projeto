#include "protheus.ch"

/*/{Protheus.doc} MGFCOM87
//Descrição : Ponto de Entrada MT100TOK() ativada em MATA103, que chama MGFCOM87(), para consistir Natureza da NFE
@author Andy Pudja / Welington
@since 21/11/2018
@version 1.0
@return ${return}, ${return_description}
@type function
/*/
user function MGFCOM87(cUF, cTip, aColsItem, aHeadItem) // Tratamento para Fornecedor com Estado = "EX"
	
	local _nI	
	local _lTesFin		:= .F.
	local _lRetCom87 	:= .T.
	local _cNatDev		:= allTrim(getMv("MGF_NATDEV"))
	local _cExpDev		:= allTrim(getMv("MGF_EXPDEV")) 
	local _nPosTes 		:= aScan(aHeadItem, {|x| AllTrim(Upper(X[2])) == "D1_TES" })

	if cTip == "D"
		For _nI := 1 To Len(aCols)
			If Posicione("SF4",1,xFilial("SF4")+aColsItem[_nI][_nPosTES],"F4_DUPLIC") == "S"
				_lTesFin:= .T.
			EndIf
		Next _nI

		If _lTesFin
			If AllTrim(cUF) == "EX" 
				if _cExpDev <> allTrim( MaFisRet(,"NF_NATUREZA") )
					msgAlert( 'Nota de Devolução para Tipo "EX", deverá utilizar a Natureza: ' + _cExpDev )
					_lRetCom87 := .F.
				endif
			Else
				if _cNatDev <> allTrim( MaFisRet(,"NF_NATUREZA") )
					msgAlert( "Nota de Devolução deverá utilizar a Natureza: " + _cNatDev )
					_lRetCom87 := .F.
				endif
			EndIf
		EndIf
	EndIf

return _lRetCom87