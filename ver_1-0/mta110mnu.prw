#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MTA110MNU
Autor...............: Joni Lima
Data................: 06/01/2016
Descrição / Objetivo: O ponto de entrada 'MTA110MNU' é utilizado para adicionar botões ao Menu Principal através do array aRotina.
Doc. Origem.........: GRADE ERP
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: http://tdn.totvs.com/pages/releaseview.action?pageId=6085755
=====================================================================================
*/
User Function MTA110MNU()
	
	If FindFunction("U_xMC8110M")
		AADD(aRotina,{OemToAnsi('Log Aprovacao'),"U_xMC8110M", 0 , 2, 0, nil})
	EndIf

	If FindFunction("U_MGFCTB08")
		AADD(aRotina,{OemToAnsi('incluir Rateio'),"U_MGFCTB08", 0 , 2, 0, nil})
	EndIf

	If FindFunction("U_MGFCOM40")
		U_MGFCOM40()
	Endif
Return

