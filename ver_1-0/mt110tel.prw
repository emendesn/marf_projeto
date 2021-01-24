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
User Function MT110TEL()
	
	Local oDlg		 := PARAMIXB[1]
	Local aPosGet	 := PARAMIXB[2]
	Local nOpcx		 := PARAMIXB[3]
	Local nReg		 := PARAMIXB[4]
		
	If FindFunction("U_MC8M110TEL")
		U_MC8M110TEL(oDlg,aPosGet,nOpcx,nReg,SC1->C1_ZGRPPRD,SC1->C1_CC)
	Endif

	If FindFunction("U_COM28Tel")
		U_COM28Tel()
	Endif
	
	If FindFunction("U_MGFCOM36")
		U_MGFCOM36()
	EndIf
		
Return .T.