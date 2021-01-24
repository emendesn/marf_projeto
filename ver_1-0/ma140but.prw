/*
=====================================================================================
Programa............: MA140BUT
Autor...............: Totvs
Data................: Fev/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada para inclusao de botoes na tela de pre-nota de entrada
=====================================================================================
*/
User Function MA140BUT()

Local aBotao := {}

If FindFunction("U_MGFCOM64")
	aBotao := U_MGFCOM64()
Endif	

Return(aBotao)