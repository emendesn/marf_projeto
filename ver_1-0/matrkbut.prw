#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)

User Function MATRKBUT()

	Local aRetBtn := {}

	If FindFunction("U_MGFCOM42")
		aRetBtn := U_MGFCOM42()
	Endif		

Return aRetBtn
