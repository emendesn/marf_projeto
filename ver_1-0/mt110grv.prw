#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT110GRV
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Ponto de Entrada ao gravar o Item
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamada na gravação de cada item no fonte MATA110
=====================================================================================
*/
User Function MT110GRV()
	
	If FindFunction("U_MC8M110GRV")
		U_MC8M110GRV()
	Endif
	
	If FindFunction("U_COM28Grv")
		U_COM28Grv()
	Endif	
	
	If FindFunction("U_mgf8GdC1") .AND. ALTERA 
		U_mgf8GdC1()
	EndIf
          
Return

