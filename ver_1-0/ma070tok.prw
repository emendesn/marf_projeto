#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} MA070TOK
Ponto de Entrada que valida as alterações no cadastro de contatos (a070TudoOK)
@description
Ponto de Entrada que valida as alterações no cadastro de contatos (a070TudoOK)
@author TOTVS
@since 21/09/2020
@type Function
@table
 SU5 - Contatos
@param
@return
@menu
/*/
user function MA070TOK()
    local lVldContat    := .T.

    if findFunction("U_MGFCRM55")
        U_MGFCRM55()
    endif
return lVldContat
