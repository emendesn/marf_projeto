/*
=====================================================================================
Programa............: OM010QRY
Autor...............: Mauricio Gresele
Data................: Out/2017
Descricao / Objetivo: Ponto de entrada para alterar a query de filtro da tabela de preco
Doc. Origem.........: Protheus
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function OM010QRY()

Local cQ := ParamIxb[1]

If FindFunction("U_MGFFAT56")
	cQ := U_MGFFAT56(cQ)
Endif

Return(cQ)