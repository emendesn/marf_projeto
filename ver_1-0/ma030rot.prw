#include "protheus.ch"

/*
=====================================================================================
Programa............: MA030ROT
Autor...............: Roberto Sidney
Data................: 09/09/2016
Descricao / Objetivo: Opção - Amarração Clientes x Endereço
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Pontos de entrada para chamada da amarração Clientes x Endereço
=====================================================================================
*/

User Function MA030ROT()

	Local aButtons := {} 

	If findfunction("U_MGFFAT01")
		AAdd( aButtons, { "Endereço de Entrega", "U_MGFFAT01", 2, 0 } )
	Endif

	If FindFunction("u_MGFCRM08")
		u_MGFCRM08(@aButtons)
	Endif
Return(aButtons)