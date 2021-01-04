#include "protheus.ch"
/*/
=============================================================================
{Protheus.doc} MT103DRF 
Ponto de para valida��o dos c�digos de reten��o

@description
Atualizar os campos Gera Dirf e c�digos de reten��o dos impostos retidos

@author Cosme Nunes
@since 16/01/2020
@type User Function

@table 
    SF1 - Cabe�alho documento de entrada
    SD1 - Itens documento de entrada

@param
    N�o se aplica
    
@return
    _aImpRet - Array da pasta Impostos do rodap� do documento de entrada

@menu
    N�o se aplica

@history 
    17/01/2020 - Tarefa RTASK0010618 - Chamados RITM0028445 e RITM0028474 - Cosme Nunes
/*/   
User Function MT103DRF()

Local _aRetDRF := {} 

If FindFunction("U_MGFCOMBE")
    _aRetDRF := U_MGFCOMBE()
Endif

Return(_aRetDRF)