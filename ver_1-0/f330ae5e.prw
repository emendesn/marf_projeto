/*
=====================================================================================
Programa............: F330AE5E
Autor...............: Totvs
Data................: Mar�o/2018
Descricao / Objetivo: Financeiro
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada para altera��o do hist�rico da movimenta��o na SE5 no momento do estorno de uma compensa��o do contas a receber.
=====================================================================================
*/
User Function F330AE5E()

If FindFunction("U_MGFFIN85")
	U_MGFFIN85()
Endif	

Return()