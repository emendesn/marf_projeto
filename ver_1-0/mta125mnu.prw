#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MTA125MNU
Autor...............: Gresele
Data................: Nov/2017
Descri��o / Objetivo: Ponto de entrada utilizado para adicionar bot�es ao Menu Principal atrav�s do array aRotina.
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MTA125MNU()
	
If FindFunction("U_MGFCOM61")
	aRotina := U_MGFCOM61(aRotina)
EndIf

Return()

