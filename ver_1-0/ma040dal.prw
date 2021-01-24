#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MA040DAL
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Clientes
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada no final do cadastro de Vendedor
=====================================================================================
*/

User Function MA040DAL

IF findfunction("U_MGFINT39") 
	U_MGFINT39(3,'SA3','A3')
EndIF
If FindFunction("U_MGFFAT23")
	U_MGFFAT23()
EndIf  

Return .T.