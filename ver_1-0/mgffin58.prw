#Include 'Protheus.ch'

/*
=====================================================================================
Programa............: MGFFIN58
Autor...............: Barbieri
Data................: 22/08/2017
Descricao / Objetivo: Validacao para o campo A6_COD
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function MGFFIN58()

	Local lRet := .T.

	If SUBSTR(SA6->A6_ZFILIAL,1,2) + ALLTRIM(SA6->A6_COD) + ALLTRIM(SA6->A6_AGENCIA) + ALLTRIM(SA6->A6_NUMCON) <> ;
	SUBSTR(XFILIAL("SE5"),1,2) + ALLTRIM(SA6->A6_COD) + ALLTRIM(SA6->A6_AGENCIA) + ALLTRIM(SA6->A6_NUMCON)
		MSGALERT("Banco nao cadastrado para a filial corrente.","Atencao")
		lRet := .F.
	EndIf

Return lRet
