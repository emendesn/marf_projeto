#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

#define _Enter chr(13) + chr(10)

/*/
=============================================================================
{Protheus.doc} MGFEEC79
Atualização do campo Situação.
@description
Recurso para colocar o pedido de exportação como cancelado
@author
Cláudio Alves
@since
03/02/2020
@type
User Function
@table
EEC - Embarque
@param
MGF_EEC79A
@return
Nill
@menu
Sem menu
/*/

User Function MGFEEC79()
    local _cQry :=  ''
    if !ExisteSx6("MGF_EEC79A")
        CriarSX6("MGF_EEC79A", "L", "Habilita Funcionalodade da Rotina",'.T.' )
    endif
    if !(superGetMV("MGF_EEC79A", , .T.))
        return
    endif

    _cQry := _Enter  + "UPDATE "
    _cQry += _Enter  + "    " + retSQLName("EE7") + " "
    _cQry += _Enter  + "SET "
    _cQry += _Enter  + " 	EE7_MOTSIT = '0010' "
    _cQry += _Enter  + " WHERE 1 = 1 "
    _cQry += _Enter  + " 	AND EE7_PEDIDO = '" + M->EE7_PEDIDO + "' "
    _cQry += _Enter  + " 	AND	D_E_L_E_T_	=	' ' "

    MemoWrite('C:\TEMP\mgfeec79.sql', _cQry)

    If tcSQLExec( strTran(_cQry, _Enter, '' )) < 0
        conout("Não foi possível executar UPDATE." + CRLF + tcSqlError())
    Else
        tcSQLExec( "commit" )
        conout("UPDATE. realizado com Sucesso - Alterado o EE7_MOTSIT para '0010' devido a update")
    EndIf

    
return
