#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
                      
User Function MT150OK()

Local lRet := .T.

If FindFunction("U_MGFCOM37")
	lRet := U_MGFCOM37()
Endif		

Return(lRet)
