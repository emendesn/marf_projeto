/*
=====================================================================================
Programa............: F590CAN
Autor...............: Totvs
Data................: Março/2018 
Descricao / Objetivo: Ponto de entrada apos excluir titulo do bordero
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function F590CAN()

If FindFunction("U_MGFFIN92")
	U_MGFFIN92()
Endif	

Return()