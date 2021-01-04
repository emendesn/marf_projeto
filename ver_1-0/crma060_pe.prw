#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwmvcdef.ch"

#define CRLF chr( 13 ) + chr( 10 )

user function CRMA060()
	local xRet := .T.

	if findfunction("U_MGFFATBA")
		U_MGFFATBA()
	endif
return xRet