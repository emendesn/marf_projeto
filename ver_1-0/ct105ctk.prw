#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: CT105CTK
Autor...............: Joni Lima
Data................: 21/11/2016
Descrição / Objetivo: O ponto de entrada CT105CTK esta dentro do RecLock da CTK 
Doc. Origem.........: Contrato - GAP CTB01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function CT105CTK()
	
	Local aCt5 := PARAMIXB //Dados CT5
	
	If Findfunction('U_xMF03105CK')
		U_xMF03105CK()
	EndIf
	
Return

