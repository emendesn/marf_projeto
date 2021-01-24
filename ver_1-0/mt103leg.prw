/*
=====================================================================================
Programa............: MT103LEG
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada para alteracao da legenda na tela de documento de entrada
=====================================================================================
*/
User Function MT103LEG()

Local aLegenda := aClone(ParamIxb[1])

If FindFunction("U_MGFCOM70")
	aLegenda := U_MGFCOM70()
Endif	

Return(aLegenda)