#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN58
Autor...............: Barbieri
Data................: 22/08/2017
Descrição / Objetivo: Validação para o campo A6_COD
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFIN58()

	Local lRet := .T.

	If SUBSTR(SA6->A6_ZFILIAL,1,2) + ALLTRIM(SA6->A6_COD) + ALLTRIM(SA6->A6_AGENCIA) + ALLTRIM(SA6->A6_NUMCON) <> ;
	SUBSTR(XFILIAL("SE5"),1,2) + ALLTRIM(SA6->A6_COD) + ALLTRIM(SA6->A6_AGENCIA) + ALLTRIM(SA6->A6_NUMCON)
		MSGALERT("Banco não cadastrado para a filial corrente.","Atenção")
		lRet := .F.
	EndIf

Return lRet
