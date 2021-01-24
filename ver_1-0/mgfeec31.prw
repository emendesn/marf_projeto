#Include 'Protheus.ch'
#include 'totvs.ch'

/*/{Protheus.doc} FI040SE1
//TODO Alteração de campos para Contas a receber quando a moeda é diferente de 1
@author leonardo.kume
@since 14/08/2017
@version 6

@type function
/*/
User Function MGFEEC31()
Local lRet := .T.

//If ValType("INCLUI") <> "U"
//	If Inclui
		If !Empty(Alltrim(SC5->C5_PEDEXP))
			RecLock("SE1",.f.)
			SE1->E1_JUROS := 0
			SE1->E1_PORCJUR := 0
			SE1->E1_VALJUR := 0
			SE1->(MsUnlock())
		EndIf
//	EndIf
//EndIf


Return lRet