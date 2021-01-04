#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: F050INC
Autor...............: Joni Lima
Data................: 11/04/2016
Descricao / Objetivo: O ponto de entrada F050INC sera utilizado apos confirmar a gravacao de contas a pagar, antes da contabilizacao. Antes de gravar os titulos de desdobramento.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: 
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6070887
=====================================================================================
*/
User Function F050INC()
	
	If FindFunction("U_xMG8Inc5")
		U_xMG8Inc5(SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA),3) 
	EndIf

	If FindFunction("U_MGFPROV")
	  lRet := U_MGFPROV() 
	EndIf	
	If FindFunction("U_MGFEEC27")
	  lRet := U_MGFEEC27() 
	EndIf	

Return