#include 'Protheus.ch'

/*
=====================================================================================
Programa............: MTA094RO
Autor...............: Gresele
Data................: Nov/2017
Descrição / Objetivo: Ponto de entrada utilizado para adicionar botões na tela de liberacao de documento
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MTA094RO()

Local aButtons := PARAMIXB[1]

If FindFunction("U_MGFCOM57")
	aButtons := U_MGFCOM57(aButtons)
Endif

If FindFunction("U_MGFCOM77")
	aButtons := U_MGFCOM77(aButtons)
Endif

Return(aButtons)