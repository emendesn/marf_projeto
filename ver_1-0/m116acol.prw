#include "protheus.ch"
/*/
=============================================================================
{Protheus.doc} M116ACOL
Permite manipula��o de entrada em Conhecimento de Frete 

@description
Permitir a manipula��o do aCols que ser� carregado p/cada docto entrada sele-
cionado pela rotina de Conhecimento de Frete. Chamado pelo programa MATA116 

@author Cosme Nunes
@since 04/02/2020
@type User Function

@table 
    SF1 - Cabe�alho documento de entrada
    SD1 - Itens documento de entrada
    SF2 - Cabe�alho documento de sa�da
    SD2 - Itens documento de sa�da

@param
    cAliasSD1 - Alias arq. NF Entrada itens
    nX        - N�mero da linha do aCols correspondente
    aDoc      - Vetor contendo o documento, s�rie, fornecedor, loja e itens do documento
    
@return
    Nil 

@menu
    N�o se aplica

@history 
    04/02/2020 - RTASK0010721 - Chamados RITM0036376 - Cosme Nunes
/*/   
User Function M116ACOL() 

//Local _cAliasSD1 := PARAMIXB[1]
//Local _nX        := PARAMIXB[2]
//Local _aDoc      := PARAMIXB[3]

///Verifica se � frete de entrada e data de inicio de vig�ncia da regra
If GW3->GW3_SITREC <> '6'

    //Classifica o CTE por item na integra��o do GFE
    If FindFunction("U_MGFGFE60")
        U_MGFGFE60()
    Endif	

EndIf 

Return(Nil)