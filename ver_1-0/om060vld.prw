#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: OM060VLD
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Clientes
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada no final do cadastro de Cliente
=====================================================================================
*/

User Function OM060VLD
Local lRetDA3 := .T.

IF ALTERA
	IF findfunction("U_MGFINT38") 
		lRetDA3 :=	U_MGFINT38('DA3','DA3')           
	EndIF      
ENDIF

Return lRetDA3 