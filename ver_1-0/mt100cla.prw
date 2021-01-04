/*
=====================================================================================
Programa............: MT100CLA
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada antes da classificacao da pre-nota de entrada
=====================================================================================
*/
User Function MT100CLA()

If FindFunction("U_MGFCOM68")
	U_MGFCOM68()
Endif	

Return()