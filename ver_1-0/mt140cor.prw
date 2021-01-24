/*
=====================================================================================
Programa............: MT140COR
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada para inclusao de legenda na tela de pre-nota de entrada
=====================================================================================
*/
User Function MT140COR()

Local aCores := aClone(ParamIxb[1])

If FindFunction("U_MGFCOM67")
	aCores := U_MGFCOM67()
Endif	

Return(aCores)