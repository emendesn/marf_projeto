/*
=====================================================================================
Programa............: MTALCDOC
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada apos a manutencao da alcada
=====================================================================================
*/
User Function MTALCDOC()

// exclusao do documento da alcada
If FindFunction("U_MGFCOM74")
	U_MGFCOM74()
Endif	

Return()