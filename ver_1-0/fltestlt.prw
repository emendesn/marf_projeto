#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FLTESTLT
Autor...............: Joni Lima
Data................: 21/11/2016
Descricao / Objetivo: O ponto de entrada FLTESTLT faz o filtro antes da apresentacao da selcao de Lote
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: 
Obs.................: http://tdn.totvs.com/display/public/mp/CTB+-+Diversos+--+30155
=====================================================================================
*/
User Function FLTESTLT()
	
	Local lRet := .T.
	
	If Findfunction( 'U_xMF03FiL' )
		lRet := U_xMF03FiL()
	EndIf

Return lRet

