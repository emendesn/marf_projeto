#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT110TEL
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: Ponto de Entrada para Edição da Dialog da SC de compra
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamada na Montagem do dialog no fonte MATA110
=====================================================================================
*/
User Function MT125TEL()
	
	Local oDlg		 := PARAMIXB[1]
	Local aPosGet	 := PARAMIXB[2]
	Local nOpcx		 := PARAMIXB[3]
	Local nReg		 := PARAMIXB[4]
		
	If FindFunction("U_COM25Tel")
		U_COM25Tel()
	Endif
		
Return .T.