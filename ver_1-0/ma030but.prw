#include "protheus.ch"

/*
=====================================================================================
Programa............: MA030BUT
Autor...............: Roberto Sidney
Data................: 09/09/2016
Descricao / Objetivo: Amarracao Endereco de Entrega
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: 
Obs.................: Pontos de entrada para chamada da amarracao Clientes x Endereco
=====================================================================================
*/

User Function MA030BUT()
Local aButtons := {}

If FindFunction("u_FAT99ENT")
	u_FAT99ENT(@aButtons)
Endif
If FindFunction("u_DOCATIEX")
	u_DOCATIEX(@aButtons)
Endif

Return (aButtons)
