#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*/
=============================================================================
{Protheus.doc} FA050FIN  
Ponto de Entrada após a gravação do título  

@description
Será utilizado para gravar o código de retenção do título de imposto 

@author Cosme Nunes
@since 23/01/2020
@type User Function

@table 
    SE2 - Título a pagar

@param
    Não se aplica

@return
    Não se aplica

@menu
    Não se aplica

@history 
    23/01/2020 - RTASK0010618 - Chamados RITM0028445 e RITM0028474 - Cosme Nunes
/*/   
User Function FA050FIN()

Local _lMCOMBFB := SuperGetMV("MGF_COMBFB",.T.,.F.) // Desabilita a funcionalidade RITM0028445 - Código da Receita

If FindFunction("U_MGFFINBF") .AND. _lMCOMBFB
    U_MGFFINBF()
Endif	

Return(Nil)