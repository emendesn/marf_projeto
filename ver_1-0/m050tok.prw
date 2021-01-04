#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: M050TOK
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integracao 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Transportadora
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de Entrada no final do cadastro de Transportadora
=====================================================================================
*/

User Function M050TOK

Local lRet := .T.

// valida campos para integracao do Taura
If FindFunction("U_TAC02M050TOK")
	lRet := U_TAC02M050TOK()
Endif		

If lRet
	IF findfunction("U_MGFINT38") 
		lRet := U_MGFINT38('SA4','A4')           
	EndiF
Endif	

Return(lRet)
