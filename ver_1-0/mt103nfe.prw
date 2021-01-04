#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

user function MT103NFE()
	If findfunction("U_MGFCRM11")
		U_MGFCRM11()
	Endif
return