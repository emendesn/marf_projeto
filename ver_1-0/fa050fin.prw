#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*/
=============================================================================
{Protheus.doc} FA050FIN  
Ponto de Entrada ap�s a grava��o do t�tulo  

@description
Ser� utilizado para gravar o c�digo de reten��o do t�tulo de imposto 

@author Cosme Nunes
@since 23/01/2020
@type User Function

@table 
    SE2 - T�tulo a pagar

@param
    N�o se aplica

@return
    N�o se aplica

@menu
    N�o se aplica

@history 
    23/01/2020 - RTASK0010618 - Chamados RITM0028445 e RITM0028474 - Cosme Nunes
/*/   
User Function FA050FIN()

Local _lMCOMBFB := SuperGetMV("MGF_COMBFB",.T.,.F.) // Desabilita a funcionalidade RITM0028445 - C�digo da Receita

If FindFunction("U_MGFFINBF") .AND. _lMCOMBFB
    U_MGFFINBF()
Endif	

Return(Nil)