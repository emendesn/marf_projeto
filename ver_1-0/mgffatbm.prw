#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
/*/
=============================================================================
{Protheus.doc} MGFFATBM
Desativação de parâmetros do ICMS e verif.de regra espec.p/criação tit. pagar

@description
Desativar os parâmetros 17,18,19 e 20 e carregar regra p/geração do ICMS próprio
Rotina chamada pelo ponto de entrada M460ICM

@author Cosme Nunes
@since 19/02/2020
@type User Function

@table 
    ZFW - Regra venda interestadual x grupo tributação cab
    ZFX - Regra venda interestadual x grupo tributação item

@param
    MV_Par17 - Desativa o padrão
    MV_Par18 - Desativa o padrão
    MV_Par19 - Desativa o padrão    
    MV_Par20 - Desativa o padrão

@return
    _aRgrVIntE - Dados para gravação do título de ICMS

@menu
    Não se aplica

@history 
    19/02/2020 - RTASK0010790 - Chamados RITM0023263 - Cosme Nunes

/*/ 
User Function MGFFATBM()

Local _aArea	:= GetArea()
Local _aAreaSF2	:= SF2->( GetArea() )
Local _aAreaSD2	:= SD2->( GetArea() )
Local _aAreaSB1	:= SB1->( GetArea() )
Local _aRotExc	:= STRTOKARR(SuperGetMV("MGF_FATBM",.F.,''),";") //Rotinas que não passarão pela validação
Local _lMGFATBMB := SuperGetMV("MGF_FATBMB",.T.,.F.)

Local _nMV_Par17 := 2 //MT460A17 - Gera Titulo ?              - Sim/Nao (1/2)
Local _nMV_Par18 := 2 //MT460A18 - Gera guia recolhimento ?   - Sim/Nao (1/2)
Local _nMV_Par19 := 2 //MT460A19 - Gera Titulo ICMS Próprio ? - Sim/Nao (1/2)   
Local _nMV_Par20 := 2 //MT460A20 - Gera Guia ICMS Próprio ?   - Sim/Nao (1/2)

//Verifica se rotinas que não devem passar pela validação estão na pilha de chamada. 
//Se estiver, sai da função. 
For _nCnt := 1 To Len(_aRotExc)
    If IsInCallStack(Alltrim(_aRotExc[_nCnt]))
        Return
    EndIf
Next

//Verifica se gera título de ICMS próprio via customização - MGFFATBL
If !_lMGFATBMB
    Return
EndIf

//Redefine os parametros de processamento para não gerar o título do ICMS pelo padrão
MV_Par17 := _nMV_Par17
MV_Par18 := _nMV_Par18
MV_Par19 := _nMV_Par19
MV_Par20 := _nMV_Par20


RestArea(_aAreaSB1)
RestArea(_aAreaSD2)
RestArea(_aAreaSF2)
RestArea(_aArea)

Return()