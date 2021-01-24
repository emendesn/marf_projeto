#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: M030Alt
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Clientes
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada no final do cadastro de Cliente
=====================================================================================
*/

User Function M030Alt   
Local bRet := .T.

If findfunction("U_MGFINT21")
		U_MGFINT21()
Endif
IF findfunction("U_MGFINT38") 
    U_MGF38_CDM('SA1','A1')
EndIF

Return bRet