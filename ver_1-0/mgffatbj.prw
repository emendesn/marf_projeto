#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include 'fwmvcdef.ch'

/*/
=============================================================================
{Protheus.doc} MGFFATBJ
Valida��o Pedido de Venda - exclus�o.
@description
Crair uma valida��o para que o pedido n�o seja exclu�do quando o campo C5_ZIDECOM estiver preenchido.
Criar um parmetro para que alguns usu�rios possam excluir os pedidos com o campo C5_ZIDECOM preenchido.
@author
Cl�udio Alves
@since
21/01/2020
@type
User Function
@table
SC5 - Cabe�alho dos Pedidos
SX6 - Cadastro de Par�metros do Sistema
@param
MGF_FATBJA
@return
True ou False (_lRet)
@menu
Sem menu
/*/
user function MGFFATBJ()
    local usrPermit :=  ''
    local usrLogado :=  ''
    local msgRetorn :=  'Exclus�o n�o permitida, pedido gerado via Ecommerce.'
    local _lRet     :=  .T.


//--------------| Verifica exist�ncia de par��metros e caso n�o exista, cria. |-----
    if !ExisteSx6("MGF_FATBJA")
        CriarSX6("MGF_FATBJA", "C", "Usu�rios que podem excluir pedidos",'000001|000002|004974' )
    endif

    if !ExisteSx6("MGF_FATBJB")
        CriarSX6("MGF_FATBJB", "L", "Habilita Funcionalodade da Rotina",'.T.' )
    endif

    if !(superGetMV("MGF_FATBJB", , .T.))
        return _lRet
    endif

    usrPermit   :=  superGetMV("MGF_FATBJA", , '000001|000002|004974')
    usrLogado   :=  __cUserID

    if !empty(M->C5_ZIDECOM)
        if usrLogado $ usrPermit
            _lRet   :=    .T.
        else
            Help(NIL, NIL, "Aviso", NIL, "Exclus�o Bloqueada", 1, 0, NIL, NIL, NIL, NIL, NIL, {msgRetorn})
            _lRet   :=    .F.
        endif
    endif

return _lRet