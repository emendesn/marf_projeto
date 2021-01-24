#include 'protheus.ch'
#include 'parmtype.ch'

/*/   
{Protheus.doc} FA090TIT
Descri��o : Ponto de Entrada FA090TIT() ativada em FINA090 e FINA091
    Chamar MGFFINB6(), para gerar registro de Movimenta��o de Reposi��o de Caixinha, para baixa de t�tulos fun��es 
    Baixa Autom�tica de Multi-Filiais , Baixa Automatica, Baixa em lote.
@author Henrique Vidal
@since 02/03/2020
@return l�gico
@type function
/*/
User Function FA090TIT()

    Local lRet:= .T.

    lRet:= U_MGFFINB6()

Return lRet