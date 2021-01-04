#include "protheus.ch"

/*
=====================================================================================
Programa.:              MGFCOM53
Autor....:              TOTVS
Data.....:              Nov/2017
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada MT120CND
Doc. Origem:            
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFCOM53()

Local lRet := .T.

If !IsBlind()
	If Type("__cCnpjFor") != "U"
		__cCnpjFor := GetAdvFVal("SA2","A2_CGC",xFilial("SA2")+cA120Forn+cA120Loj,1,"")
		__oCnpjFor:Picture := IIf(Len(Alltrim(__cCnpjFor))==11,"@R 999.999.999-99","@R 99.999.999/9999-99")
		__oCnpjFor:Refresh()
	Endif

	If Type("__cContFor") != "U"
		__cContFor := GetAdvFVal("SA2","A2_CONTATO",xFilial("SA2")+cA120Forn+cA120Loj,1,"")
		__oContFor:Refresh()
	Endif
Endif	

Return(lRet)	