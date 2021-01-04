#include "protheus.ch"

/*
=====================================================================================
Programa............: MT410BRW
Autor...............: Roberto Sidney
Data................: 14/09/2016
Descricao / Objetivo: Bot�o no browse do pedido de venda para exibir endere�o de entrega por completo
Doc. Origem.........: FAT99 - GAP MGFAT99
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................:
=====================================================================================
*/
User Function MT410BRW()

Local aRotina := {}

	If findfunction("U_VISUSZ9")
		Aadd(aRotina, {"Endere�o de Entrega","U_VISUSZ9(1)",0,3})
	Endif

return aRotina