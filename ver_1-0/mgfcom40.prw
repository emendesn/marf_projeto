#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

#define CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
//-------------------------------------------------------------------
User Function MGFCOM40()

	aadd( aRotina, { "Solic Compras Custon"	,"U_Matr140()"	, 0 , 2, 0, nil} )
	aadd( aRotina, { "Cancelamento de SCs"	,"U_Mgfcom96()"	, 0 , 2, 0, nil} )

return
