#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MGFEEC27
//TODO Gravação de campos ao salvar despesas Nacionais e Internacionais no Embarque
@author leonardo.kume
@since 31/05/2017
@version 6

@type function
/*/
user function MGFEEC27()
	
//	CONOUT("INICIO LEO")
	If IsInCallStack("EECAE100")
		If Select("EXL") > 0 .AND. SE2->E2_MOEDA <> 1
			RecLock("SE2",.F.)
			SE2->E2_CCUSTO 	:= EXL->EXL_ZCCUST
			SE2->E2_ITEMD 	:= EXL->EXL_ZITEMD
//			SE2->E2_TIPO 	:= "DP"
			SE2->(MsUnlock())
//			Conout("EECAE100 - EXL")
		EndIf
		If Select("EET") > 0 .AND. SE2->E2_MOEDA == 1
			RecLock("SE2",.F.)
			SE2->E2_CCUSTO 	:= EET->EET_ZCCUST
			SE2->E2_ITEMD 	:= EET->EET_ZITEMD
//			SE2->E2_TIPO 	:= "DP"
			SE2->(MsUnlock())
//			Conout("EECAE100 - EET")
		EndIf
	EndIf
	
return .T.

/*/{Protheus.doc} xMGFEEC27
//TODO Ponto de entrada para mostrar campos na tela de Despesas Nacionas e Internacionais
//TODO Pontos de entrada EECAE103_PE e EECAE106_PE
@author leonardo.kume
@since 31/05/2017
@version 6

@type function
/*/
User Function xMGFEEC27()
	Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
	
	If Alltrim(cParam) == "CAMPOS_DESPINT"
		AAdd(aCampos,"EXL_ZCCUST")
		AAdd(aCampos,"EXL_ZITEMD")
	EndIf
	If Alltrim(cParam) == "TELA_DESPESAS"
		AAdd(aCampos,"EET_ZCCUST")
		AAdd(aCampos,"EET_ZITEMD")
	EndIf

Return .t.