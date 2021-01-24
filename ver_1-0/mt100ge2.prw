#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MT100GE2
Autor...............: Joni Lima
Data................: 11/04/2016
Descri��o / Objetivo: Rotina que efetua a integra��o entre o documento de entrada e os t�tulos financeiros a pagar. Finalidade...: Complementar a grava��o na tabela dos t�tulos financeiros a pagar.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6085781
=====================================================================================
*/
User Function MT100GE2()

	If FindFunction("U_xMC8GSE2")
		U_xMC8GSE2()
	EndIf

	If FindFunction("U_MGFFIN76")
		U_MGFFIN76()
	EndIf
	
	// Fun��o para Aplicar novas regras para defini��o da condi��o de pagamento dos documentos de frete integrados no GFE Documento de Frete.
	If FindFunction("U_MGFFINC1")
		if isInCallStack("GFEA065")
			U_MGFFINC1()
		endif
	EndIf	
	/*
	//Desconto do Fundesa no Titulo a pagar (SE2)
	//Rotina entrou em desuso no dia 02/05/2018, pois a Totvs lan�ou a solu��o padr�o na mesma data. Ticket 2607738
	If FindFunction("U_MGFFINA1")
		U_MGFFINA1()
	EndIf*/


Return
