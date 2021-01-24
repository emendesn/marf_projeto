#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#define CRLF chr( 13 ) + chr( 10 )

/*/
=============================================================================
{Protheus.doc} MGFCRM55
Marca flag de contato como pendente - Chamado pelo PE MA070TOK
@description
Marca flag de contato como pendente - Chamado pelo PE MA070TOK
@author TOTVS
@since 21/09/2020
@type Function
@table
 SU5 - Contatos
@param
@return
@menu
/*/
user function MGFCRM55()

    M->U5_XINTSFO := 'P'

return
