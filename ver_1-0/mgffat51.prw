#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"


/*/
=============================================================================
{Protheus.doc} MGFFAT51
Chamada de Job de criação de pedidos de venda a partir da tabela ZC5
@author TOTVS
@since 14/01/2020
/*/
User function MGFFAT51(_cfiliais) 

Default _cfiliais := " "

u_MGFFAT53(_cfiliais)

Return