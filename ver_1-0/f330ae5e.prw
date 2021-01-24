/*
=====================================================================================
Programa............: F330AE5E
Autor...............: Totvs
Data................: Março/2018
Descricao / Objetivo: Financeiro
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada para alteração do histórico da movimentação na SE5 no momento do estorno de uma compensação do contas a receber.
=====================================================================================
*/
User Function F330AE5E()

If FindFunction("U_MGFFIN85")
	U_MGFFIN85()
Endif	

Return()