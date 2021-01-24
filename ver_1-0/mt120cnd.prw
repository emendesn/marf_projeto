#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT120CND
Autor...............: Gresele
Data................: Nov/2017
Descrição / Objetivo: Ponto de Entrada para alterar a condicao de pagamento no pedido de compra
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamada na Montagem do dialog no fonte MATA120
=====================================================================================
*/
User Function MT120CND()

Local lRet := .T.

If FindFunction("U_MGFCOM53")
	lRet := U_MGFCOM53()
Endif

Return(lRet)	