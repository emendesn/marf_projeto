#Include "Protheus.ch"
#Include "totvs.ch"
#Include "FWMVCDEF.ch"
#Include "FWMBROWSE.CH"
/*/
=====================================================================================
{Protheus.doc} GFEA065
limpar campo ao excluir “Documento de Frete”

@description
Ao excluir “Documento de Frete” deverá ser limpo o campo no Romaneio
“Valor do Desconto”
“Número do Documento de Frete”

@autor Antonio Carlos
@since 18/11/2019
@type user function PE p/ chamar a user function MGFGFE55
@table

@menu
=====================================================================================
/*/
User Function GFEA065()
	Local lRet       := .T.
	Local aParam     := PARAMIXB
	Local oModel     := ""
	Local cIdPonto   := ""
	Local cIdModel   := ""

	Local nDCVAL	:= GetMV("MV_DCVAL")
	Local nDCPERC	:= GetMV("MV_DCPERC")

	If aParam <> NIL
		oModel     := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

		If cIdPonto == "MODELCOMMITNTTS"
			if(omodel:getoperation()==5)
				U_MGFGFE55()
			endif
			if(omodel:getoperation()==3) //Inclusão
				U_MGFGFE67()
			endif
			U_MGFGFE28()
		EndIf

	EndIf

Return lRet
