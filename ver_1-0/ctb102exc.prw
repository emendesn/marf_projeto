#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: CTB102EXC
Autor...............: Joni Lima
Data................: 16/11/2016
Descrição / Objetivo: O ponto de entrada CTB102EXC  é utilizado antes da exclusão.
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action;jsessionid=BB8BBD05F441DCF442E831DC83A7861A?pageId=6068667
=====================================================================================
*/
User Function CTB102EXC()

	Local lRet  := .T.        
	Local aArea := GetArea()
	Local nOpc	:= OPCAO
	
	If Findfunction( 'U_xMF0102EXC' )	
		lRet := U_xMF0102EXC(nOpc)
	EndIf
	
	RestArea(aArea)

Return lRet