#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: M030PALT
Autor...............: Marcelo Carneiro
Data................: 30/11/2016 
Descricao / Objetivo: Integração 
Doc. Origem.........: Contrato GAPS - MIT044- Cadastro de Clientes
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada no final do cadastro de Cliente
=====================================================================================
*/
User Function M030PALT

Local nOpcao := PARAMIXB[1]    

IF findfunction("U_MGFINT39") 
	IF nOpcao == 1
		U_MGFINT39(3,'SA1','A1')
	EndIF
EndIF


Return .T.