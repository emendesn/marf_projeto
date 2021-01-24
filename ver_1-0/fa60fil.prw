/*
=====================================================================================
Programa............: FA60FIL
Autor...............: Mauricio Gresele
Data................: Set/2017
Descricao / Objetivo: Ponto de entrada para filtragem dos titulos no bordero de cobranca
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function FA60FIL()

Local cRet := ""

If FindFunction("U_MGFFIN61")
	cRet := U_MGFFIN61()
Endif	

Return(cRet)