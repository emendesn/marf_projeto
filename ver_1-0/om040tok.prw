#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: OM040TOK
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integracao 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Clientes
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de Entrada no final do cadastro de Cliente
=====================================================================================
*/

User Function OM040TOK
	Local uRet := .T.           

	IF Type("ALTERA") <> "U"
		IF ALTERA
			IF findfunction("U_MGFINT38")
				//uRet := U_MGFINT38('DA4','DA4')
			EndIF
		ENDIF
	ENDIF


Return uRet