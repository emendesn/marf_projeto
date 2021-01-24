#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
//-------------------------------------------------------------------
User Function MGFCOM39(cCampoSC8)
	local cRetSC8 := ""

	if cCampoSC8 == "C8_ZCODCOM"

		cRetSC8 := GetAdvFVal('SC1', 'C1_CODCOMP', xFilial('SC1')+SC8->(C8_NUM+C8_PRODUTO+C8_ITEM), 5, '')

	elseif cCampoSC8 == "C8_ZCOMPRA"

		cRetSC8 := GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+GetAdvFVal('SC1', 'C1_CODCOMP', xFilial('SC1')+SC8->(C8_NUM+C8_PRODUTO+C8_ITEM), 5, ''),1,"")

	endif

return cRetSC8
