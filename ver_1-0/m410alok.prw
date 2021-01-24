#include "protheus.ch"

/*
=====================================================================================
Programa............: M410ALOK
Autor...............: Mauricio Gresele
Data................: 25/10/2016 
Descricao / Objetivo: Ponto de entrada para permitir a alteracao/exclusao do PV
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function M410ALOK()

Local lRet := .T.

If FindFunction("U_TAS01VldMnt")
	lRet := U_TAS01VldMnt({SC5->C5_NUM})
Endif

If lRet
	If FindFunction("U_TAS01StatPV")
		lRet := U_TAS01StatPV({SC5->C5_NUM,IIf(Altera,2,IIf((!Inclui .and. !Altera),3,0))})
	Endif
Endif	

Return(lRet)