#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: FLTESTLT
Autor...............: Joni Lima
Data................: 21/11/2016
Descri��o / Objetivo: O ponto de entrada FLTESTLT faz o filtro antes da apresenta��o da sel��o de Lote
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/display/public/mp/CTB+-+Diversos+--+30155
=====================================================================================
*/
User Function FLTESTLT()
	
	Local lRet := .T.
	
	If Findfunction( 'U_xMF03FiL' )
		lRet := U_xMF03FiL()
	EndIf

Return lRet

