#Include "Protheus.ch"
#Include "parmtype.ch"

/*/{Protheus.doc} GFEC065_PE
//TODO Descrição auto-gerada.
@author thiago.queiroz
@since 02/10/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function GFEC065_PE()

	Local aArea		 := GetArea()
	Local lRet       := .T.
	Local aParam     := PARAMIXB
	Local oModel     := ""
	Local cIdPonto   := ""
	Local cIdModel   := ""

	If aParam <> NIL
		oModel     := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

	EndIf

	RestArea(aArea)

Return lRet
