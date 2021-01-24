#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT103EXC
Autor...............: Joni Lima
Data................: 22/11/2016
Descrição / Objetivo: Ponto de entrada para validação da exclusão do documento de entrada.
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=184781713
=====================================================================================
*/
User Function MT103EXC()
	
	Local lRet := .T.
	
	If Findfunction('U_xMF03103E')
		lRet := U_xMF03103E()
	EndIf
	
	// RVBJ
	If	lRet	.and.	Findfunction('U_MGFFINBG')
		lRet := U_MGFFINBG()
	EndIf
	
	If Findfunction('U_TAE15EXC') .and. lRet
		lRet := U_TAE15EXC()
	EndIf

Return lRet