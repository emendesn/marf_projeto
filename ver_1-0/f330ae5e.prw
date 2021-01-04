/*
=====================================================================================
Programa............: F330AE5E
Autor...............: Totvs
Data................: Marco/2018
Descricao / Objetivo: Financeiro
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de Entrada para alteracao do historico da movimentacao na SE5 no momento do estorno de uma compensacao do contas a receber.
=====================================================================================
*/
User Function F330AE5E()

If FindFunction("U_MGFFIN85")
	U_MGFFIN85()
Endif	

Return()