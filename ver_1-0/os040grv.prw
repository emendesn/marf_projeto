#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: OS040GRV
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Motorista
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada no final do cadastro de Motorista
=====================================================================================
*/


User Function OS040GRV           
	IF Type("INCLUI") <> "U"
		IF INCLUI
			IF findfunction("U_MGFINT39")
				U_MGFINT39(2,'DA4','DA4_MSBLQL')
			EndIF
		EndIF
	EndIF

Return 