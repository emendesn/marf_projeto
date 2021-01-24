#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: F050ALT
Autor...............: Joni Lima
Data................: 11/04/2016
Descrição / Objetivo: O ponto de entrada F050ALT é utilizado para validação pós confirmação de alteração, executado antes de atualizar saldo do fornecedor.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6070876
=====================================================================================
*/
User Function F050ALT()
	
	If FindFunction("U_xMG8Inc5")
		If U_xMC8E2VL()
			U_xMG8Inc5(SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA),3) 
		EndIf
	EndIf
	
	If FindFunction("U_MGFFIN57")
		U_MGFFIN57()
	Endif	                      
	
	If FindFunction("U_MGFFIN87")
		U_MGFFIN87(1)
	Endif	

	
Return .T.