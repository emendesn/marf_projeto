#include 'protheus.ch'
#include 'parmtype.ch'

/*
=====================================================================================
Programa............: EECAE102
Autor...............: Joni Lima
Data................: 27/12/2019
Descrição / Objetivo: Ponto de entrada na Rotina de Embarque
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada para a Rotina de processos a Embarcar fonte: EECAE102
=====================================================================================
*/
user function EECAE102()

	If FindFunction("U_MGFEEC77")
		U_MGFEEC77()
	EndIf
	
return nil
