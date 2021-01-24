#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"   
#INCLUDE 'RWMAKE.CH'

/*/
==============================================================================================================================================================================
{Protheus.doc} OM200BRW 
Ponto de Entrada na montagem do browser

@description
Foi utilizado o ponto de entrada para incluir o intervalo de filiais no filtro padr�o.

@author Cl�udio Alves
@since 13/01/2020
@type Function

@table 
    DAK - Cargas

@param
    N�o Tem

@return
    _cRet - Retorna string com o filtro configurado pelo usu�rio

@menu
    n�o se aplica
    
@history //Manter at� as �ltimas 3 manuten��es do fonte para facilitar identifica��o de vers�o, remover esse coment�rio 
    13/01/2020 - RTASK0010602 - Cria��o do fonte - Cl�udio Alves

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
