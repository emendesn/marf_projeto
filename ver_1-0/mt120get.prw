#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT120GET
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Ponto de Entrada para mudança das coordenadas da Dialog
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamada na Montagem do dialog no fonte MATA120
=====================================================================================
*/
User Function MT120GET()

	Local aPosObj := PARAMIXB[1]
	Local nOpc    := PARAMIXB[2]

	If FindFunction("U_MC8MGET120")
		U_MC8MGET120(@aPosObj)
	Endif
	
Return aPosObj