#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: FA290
Autor...............: TOTVS
Data................: 07/06/2017 
Descricao / Objetivo: PE para gravar dados bancarios do fornecedor na fatura gerada 
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
user function FA290()
	If FindFunction("U_MGFFIN56")
		U_MGFFIN56()
	Endif
return