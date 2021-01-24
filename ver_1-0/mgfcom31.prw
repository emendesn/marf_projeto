#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa.:              MGFCOM31
Autor....:              TOTVS
Data.....:              06/06/2017
Descricao / Objetivo:   Inicializador do campo de descricao do produto na prenota MATA140 e doc de entrada MATA103
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFCOM31()
	local cRet := ""

	if isInCallStack("MATA140")  // PRE NOTA
		//cRet := GetAdvFVal("SB1", "B1_DESC", xFilial("SB1") + SB1->B1_DESC, 1, "") //GDFIELDGET("D1_COD", n), 1, "")
		cRet := GetAdvFVal("SB1", "B1_DESC", xFilial("SB1") + IniAuxCod(SD1->D1_COD,"B1_DESC"), 1, "")
	elseif isInCallStack("MATA103") // DOC DE ENTRADA
		cRet := iif(!empty(GDFIELDGET("D1_COD", n)), SB1->B1_DESC, "")
	endif

return cRet

/*
=====================================================================================
Programa.:              MGFUS103
Autor....:              TOTVS
Data.....:              01/2018
Descricao / Objetivo:   Grava usuário na pre-nota e no doc de entrada
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
user function MGFUS103()

	Local cUsrNfe := UsrFullName(RetCodUsr())
	Local cDtHora := DTOC(Date())+" "+Time()

	RecLock("SF1",.F.)
	SF1->F1_ZAUDUSR := cUsrNfe
	SF1->F1_ZAUDDHR := cDtHora

	MsUnLock()

return


