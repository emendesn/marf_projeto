#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: AvKeyAuto
Autor...............: Totvs
Data................: Dez/2018
Descrição / Objetivo: Ponto de entrada para tratamento da variavel cConteudo via execauto
Doc. Origem.........: EEC
Solicitante.........: Cliente
Uso.................: Marfrig
=====================================================================================
*/
User Function AvKeyAuto()

If FindFunction("U_MGFEEC63")
	U_MGFEEC63()
EndIf

Return()