#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFWSC02
Autor....:              Gustavo Ananias Afonso
Data.....:              08/09/2016
Descricao / Objetivo:   Integração de Clientes com SFA
Doc. Origem:            GAP MGFINT06
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function jMGFWC02(cFilJob)

	U_MGFWSC02({,"01",cFilJob})

Return 
user function eMGFWS02()

	runInteg02()

Return 

user function MGFWSC02(aEmpX)
	RPCSetType( 3 )

	PREPARE ENVIRONMENT EMPRESA aEmpX[2] FILIAL aEmpX[3]

		conout('[MGFWSC02] Iniciada Threads para a empresa' + allTrim( aEmpX[3] ) + ' - ' + dToC(dDataBase) + " - " + time())

		runInteg02()

	RESET ENVIRONMENT
return

//-------------------------------------------------------------------
//-------------------------------------------------------------------
static function runInteg02()
	local cURLPost		:= allTrim(getMv("MGF_SFA02"))
	local oWSSFA		:= nil

	conout( '[MGFWSC02] [SFA] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Inicio ' + time() )

	oWSSFA := nil
	// MGFINT23():new(cURLPost, oObjToJson, nKeyRecord, cTblUpd, cFieldUpd, cIntegra, cTypeInte, cChave, lDeserialize, lConsultaEst, lMonitor, lUseJson, lNameClass, lDelClsNam, lLogInCons)
	oWSSFA := MGFINT23():new(cURLPost, /*oObjToJson*/, /*nKeyRecord*/, /*cTblUpd*/, /*cFieldUpd*/,AllTrim(GetMv("MGF_MONI01")) /*cIntegra*/, AllTrim(GetMv("MGF_MONT06")) /*cTypeInte*/, /*cChave*/, /*lDeserialize*/, /*lConsultaEst*/,.F. /*lMonitor*/, .F. /*lUseJson*/)
	oWSSFA:lLogInCons := .T. //Se informado .T. exibe mensagens de log de integração no console quando executado o método sendByHttpPost. Não obrigatório. DEFAULT .F.
	oWSSFA:sendByHttpPost()

	conout( '[MGFWSC02] [SFA] [EMPRESA] ' + allTrim(cEmpAnt) + ' [FILIAL] ' + allTrim(cFilAnt) + ' Fim ' + time() )
return
