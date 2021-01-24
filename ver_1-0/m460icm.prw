#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
/*/
=============================================================================
{Protheus.doc} M460ICM
Ponto para recálculo de ICMS

@description
Desativação de parâmetros do ICMS e verificação de regra especifica p/ geração
do ICMS próprio

@author Cosme Nunes
@since 19/02/2020
@type User Function

@table 
    Documento de saída / entrada

@param
    Não se aplica
    
@return
    Não se aplica

@menu
    Não se aplica

@history 
    19/02/2020 - RTASK0010790 - Chamados RITM0023263 - Cosme Nunes
/*/ 
User Function M460ICM()

//Na emissão de venda interestadual com um dos grupos tributários listados na rotina MGFFATBL,
//carregará os dados do fornecedor, natureza, centro de custo e conta contábil, 
//Cria título a pagar com o valor do ICMS calculado (F2_VALICM) 

If FindFunction("U_MGFFATBM")
    //If SF2->F2_VALICM > 0 //ICMS calculado
        U_MGFFATBM()
    //EndIf 
Endif

Return()