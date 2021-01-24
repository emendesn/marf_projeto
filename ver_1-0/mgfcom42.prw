#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
//-------------------------------------------------------------------
User Function MGFCOM42()
	local aTrkBtn	:= {}

	if SC7->C7_TIPO == 2
		aadd( aTrkBtn, { "Tracker AE", { || U_MGFCOM43() } } )
	endif

return aTrkBtn