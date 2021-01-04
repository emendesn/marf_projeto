#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} CRMXCTRENT
//TODO Retornar tabelas que n�o gravar�o AO4
@author leonardo.kume
@since 26/07/2018
@version 6
@return array, Tabelas que n�o gravar�o a AO4

@type function
/*/
User Function CRMXCTRENT()

	Local aEntCtrtPri := PARAMIXB[1]
	Local nX := 0
	Local aRetorno := {}
	Local cEntRemove := "SC5"

	For nX := 1 To Len(aEntCtrtPri)
		If !(aEntCtrtPri[nX] $ cEntRemove)
			aAdd(aRetorno,aEntCtrtPri[nX])
		EndIf
	Next nX

Return(aRetorno)