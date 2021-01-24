#include "protheus.ch"

/*
=====================================================================================
Programa............: MA030ROT
Autor...............: Roberto Sidney
Data................: 09/09/2016
Descricao / Objetivo: Op��o - Amarra��o Clientes x Endere�o
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Pontos de entrada para chamada da amarra��o Clientes x Endere�o
=====================================================================================
*/

User Function MA030ROT()

	Local aButtons := {} 

	If findfunction("U_MGFFAT01")
		AAdd( aButtons, { "Endere�o de Entrega", "U_MGFFAT01", 2, 0 } )
	Endif

	If FindFunction("u_MGFCRM08")
		u_MGFCRM08(@aButtons)
	Endif
Return(aButtons)