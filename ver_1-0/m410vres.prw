/*
=====================================================================================
Programa............: M410VRES
Autor...............: Totvs
Data................: Junho/2018
Descricao / Objetivo: PE para validar execucao da rotina de eliminacao de residuos pela tela de pedido de venda
Doc. Origem.........: Faturamento
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function M410VRES()

Local lRet := .T.

If FindFunction("U_MGFFAT80")
	lRet := U_MGFFAT80()
Endif		

Return(lRet)