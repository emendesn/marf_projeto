#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MA040DIN
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integracao 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Vendedor
Solicitante.........: Cliente
Uso.................: 
Obs.................: Ponto de Entrada no final do cadastro de Vendedor
=====================================================================================
*/


User Function MA040DIN     
IF findfunction("U_MGFINT39") 
    U_MGFINT39(2,'SA3','A3_MSBLQL')           
EndIF
Return .T.