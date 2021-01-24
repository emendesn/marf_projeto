#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: CTB102ESTL
Autor...............: Joni Lima
Data................: 16/11/2016
Descri��o / Objetivo: O ponto de entrada CTB102ESTL valida o estorno de lan�amentos cont�beis por lote.
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6068729
=====================================================================================
*/
User Function CTB102ESTL()
	
	Local lRet  := .T.        
	Local aArea := GetArea()
	Local nOpc  := PARAMIXB[1]
	
	If Findfunction( 'U_xMF0102EXC' )
		lRet := U_xMF0102EXC(nOpc)
	EndIf	
	
	RestArea(aArea)

Return lRet