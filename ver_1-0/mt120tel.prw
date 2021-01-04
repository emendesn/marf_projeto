#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT120TEL
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Ponto de Entrada para Edição da Dialog da Pedido de compra
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamada na Montagem do dialog no fonte MATA120
=====================================================================================
*/
User Function MT120TEL()

	If FindFunction("U_MC8MTEL120")
		U_MC8MTEL120()
	Endif 
	
	If findfunction("U_MGFCOM45")
		U_MGFCOM45()
	Endif

	If findfunction("U_MGFCOM52")
		U_MGFCOM52()
	Endif

Return

