#include "protheus.ch"
/*/
=============================================================================
{Protheus.doc} M116ACOL
Permite manipulação de entrada em Conhecimento de Frete 

@description
Permitir a manipulação do aCols que será carregado p/cada docto entrada sele-
cionado pela rotina de Conhecimento de Frete. Chamado pelo programa MATA116 

@author Cosme Nunes
@since 04/02/2020
@type User Function

@table 
    SF1 - Cabeçalho documento de entrada
    SD1 - Itens documento de entrada
    SF2 - Cabeçalho documento de saída
    SD2 - Itens documento de saída

@param
    cAliasSD1 - Alias arq. NF Entrada itens
    nX        - Número da linha do aCols correspondente
    aDoc      - Vetor contendo o documento, série, fornecedor, loja e itens do documento
    
@return
    Nil 

@menu
    Não se aplica

@history 
    04/02/2020 - RTASK0010721 - Chamados RITM0036376 - Cosme Nunes
/*/   
User Function M116ACOL() 

//Local _cAliasSD1 := PARAMIXB[1]
//Local _nX        := PARAMIXB[2]
//Local _aDoc      := PARAMIXB[3]

///Verifica se é frete de entrada e data de inicio de vigência da regra
If GW3->GW3_SITREC <> '6'

    //Classifica o CTE por item na integração do GFE
    If FindFunction("U_MGFGFE60")
        U_MGFGFE60()
    Endif	

EndIf 

Return(Nil)