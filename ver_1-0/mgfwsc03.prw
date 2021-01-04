#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFWSC03
Autor....:              Gustavo Ananias Afonso
Data.....:              21/09/2016
Descricao / Objetivo:   Integração de Produtos com SFA
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function jMGFWC03(cFilJob)

	U_MGFWSC03({,"01",cFilJob})

Return 
user function eMGFWS03()

	runInteg03()

Return 

//-------------------------------------------------------------------
user function MGFWSC03( aEmpX )
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA aEmpX[2] FILIAL aEmpX[3]

		conout('[MGFWSC03] Iniciada Threads para a empresa' + allTrim( aEmpX[3] ) + ' - ' + dToC(dDataBase) + " - " + time())

		runInteg03()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
static function runInteg03()
	local cURLPost		:= allTrim(getMv("MGF_SFA03"))
	local oWSSFA		:= nil

	oWSSFA := nil
	oWSSFA := MGFINT23():new(cURLPost, /*oObjToJson*/, /*nKeyRecord*/, /*cTblUpd*/, /*cFieldUpd*/, allTrim(getMv("MGF_SFACOD")) /*cCodint*/, allTrim(getMv("MGF_SFA03T")) /*cCodtpint*/)
	oWSSFA:lLogInCons	:= .T. //Se informado .T. exibe mensagens de log de integração no console quando executado o método sendByHttpPost. Não obrigatório. DEFAULT .F.
	oWSSFA:lUseJson		:= .F. //Se informado .F. não utiliza JSON na integração. Não obrigatório. DEFAULT .T.
	oWSSFA:sendByHttpPost()

	delClassINTF()
return
