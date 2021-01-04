#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr(13) + chr(10)
/*/
=============================================================================
{Protheus.doc} CN100SIT
@description
@author TOTVS
@since 27/05/2020
@type Function
@table
@param
@return
 Sem retorno
@menu
 Sem menu
/*/
user function CN100SIT()

	if findFunction( "U_MGFFINBQ" )
		U_MGFFINBQ()
	endif

return