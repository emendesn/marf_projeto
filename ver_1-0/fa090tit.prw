#include 'protheus.ch'
#include 'parmtype.ch'

/*/   
{Protheus.doc} FA090TIT
Descrição : Ponto de Entrada FA090TIT() ativada em FINA090 e FINA091
    Chamar MGFFINB6(), para gerar registro de Movimentação de Reposição de Caixinha, para baixa de títulos funções 
    Baixa Automática de Multi-Filiais , Baixa Automatica, Baixa em lote.
@author Henrique Vidal
@since 02/03/2020
@return lógico
@type function
/*/
User Function FA090TIT()

    Local lRet:= .T.

    lRet:= U_MGFFINB6()

Return lRet