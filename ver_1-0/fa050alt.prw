#include "protheus.ch"
/*/
=============================================================================
{Protheus.doc} FA050ALT   
Ponto de para valida��o do t�tulo a pagar

@description
Atualizar os campos Gera Dirf e c�digos de reten��o dos impostos retidos

@author Cosme Nunes
@since 17/01/2020
@type User Function

@table 
    SE2 - T�tulo a pagar

@param
    N�o se aplica

@return
    _lRet - Dados v�lidos para inclus�o

@menu
    N�o se aplica

@history 
    17/01/2020 - RTASK0010618 - Chamados RITM0028445 e RITM0028474 - Cosme Nunes
/*/   
User Function FA050ALT()

Local _lRet := .F. 

If FindFunction("U_MGFFINBE")
    _lRet := U_MGFFINBE()
Endif	

Return(_lRet)
