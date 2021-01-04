#include 'protheus.ch'
#include 'parmtype.ch'

User Function CN120RAT()

	Local aArea  	:= GetArea()
	Local aAreaCNZ  := CNZ->(GetArea())

	Local aRet 	:= PARAMIXB[1]
	Local cTipo := PARAMIXB[2]

	Local ni

	Local cContrato	:= ' '
	Local cNumMed	:= ' '
	Local cRevisao	:= ' '
	Local cFornece	:= ' '
	Local cLoja		:= ' '
	Local cItemPlan	:= ' '  

	If cTipo == "1"

		cContrato	:= CNE->CNE_CONTRA
		cNumMed		:= CNE->CNE_NUMMED
		cRevisao	:= CNE->CNE_REVISA
		cFornece	:= CND->CND_FORNEC
		cLoja		:= CND->CND_LJFORN
		cItemPlan	:= CNE->CNE_ITEM

		dbSelectArea('CNZ')
		CNZ->(dbSetOrder(3))//CNZ_FILIAL+CNZ_CONTRA+CNZ_REVISA+CNZ_NUMMED+CNZ_FORNEC+CNZ_LJFORN+CNZ_ITCONT+CNZ_ITEM                                                                                                                                                                            

		for ni := 1 to len(aRet)
			If CNZ->(DbSeek(xFilial("CNZ") + cContrato + cRevisao + cNumMed + cFornece + cLoja + cItemPlan + aRet[ni][2][2] ))
				AADD(aRet[ni], {"CH_ZFILDES" , CNZ->CNZ_ZFILDES , nil})				
				AADD(aRet[ni], {"CH_ZVALRAT" , CNZ->CNZ_VALOR1  , nil})
			EndIf
		next ni

	EndIf

	RestArea(aAreaCNZ)
	RestArea(aArea)

Return aRet