#include 'protheus.ch'
#include 'parmtype.ch'

/// ENVIA CENTRO DE CUSTO PARA O DOCUMENTO DE ENTRADA

User Function GFEA0658()

Local cCC := PARAMIXB[1]

If FindFunction("U_MGFCTB232")	
	cCC := cCCx
EndIf

Return cCC