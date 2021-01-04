#include 'protheus.ch'
#include 'parmtype.ch'

/// ALTERA CODIGO DO PRODUTO DE FRETE
user function GFEA0651()

Local cProd := GETMV("MV_PRITDF")	

	If FindFunction("U_MGFCTB32")

		If !empty(cProdutx)//ZD2->ZD2_PROD <> "" .OR. NIL
			cProd := cProdutx
		EndIf
		
	EndIf
	
return cProd