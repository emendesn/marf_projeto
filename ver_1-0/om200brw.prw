#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"   
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
{Protheus.doc} OM200BRW 
Ponto de Entrada na montagem do browser

@description
Foi utilizado o ponto de entrada para incluir o intervalo de filiais no filtro padrão.

@author Cláudio Alves
@since 13/01/2020
@type Function

@table 
    DAK - Cargas

@param
    Não Tem

@return
    _cRet - Retorna string com o filtro configurado pelo usuário

@menu
    não se aplica
    
@history //Manter até as últimas 3 manutenções do fonte para facilitar identificação de versão, remover esse comentário 
    13/01/2020 - RTASK0010602 - Criação do fonte - Cláudio Alves

/*/  
User Function OM200BRW()


    local _cRet := ''


    _cRet += " 1=2 or ( "
    _cRet += " DAK_FILIAL >= '" + mv_par06 + "' AND "
    _cRet += " DAK_FILIAL <= '" + mv_par07 + "' AND "
    _cRet += " DAK_COD >= '" + mv_par01 + "' And DAK_COD <= '" + mv_par02 + "' And "
    _cRet += " DAK_DATA >= '" + Dtos(mv_par03) + "' And DAK_DATA <= '" + Dtos(mv_par04) + "' "
    If mv_par05 == 1
        _cRet += " And DAK_FEZNF = '2' And DAK_ACECAR = '2' ) "
    ElseIf mv_par05 == 2
        _cRet += " And DAK_FEZNF = '1' And DAK_ACECAR = '2' ) "
    ElseIf mv_par05 == 3
        _cRet += " And DAK_FEZNF = '1' And DAK_ACECAR = '1' ) "
    Else
        _cRet += " ) "
    EndIf

   
Return _cRet
