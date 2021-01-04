#include "protheus.ch"
/*/
=============================================================================
{Protheus.doc} MGFCOMBF
Validacao da pasta "Impostos" - Rodap� do documento de entrada 

@description
Verificar se os c�digos de reten��o dos impostos retidos est�o preenchidos
Rotina chamada pelo ponto de entrada MT100TOK

@author Cosme Nunes
@since 29/01/2020
@type User Function

@table 
    SF1 - Cabe�alho documento de entrada
    SD1 - Itens documento de entrada

@param
    N�o se aplica
    
@return
    _lRet - Ok / Pendente

@menu
    N�o se aplica

@history 
    29/01/2020 - RTASK0010618 - Chamados RITM0028445 e RITM0028474 - Cosme Nunes
/*/   
User Function MGFCOMBF()

Local _aArea	:= GetArea()
Local _lRet     := .T.
Local _aRotExc	:= STRTOKARR(SuperGetMV("MGF_COMBF",.F.,''),";") //Rotinas que n�o passar�o pela valida��o
Local _nCnt     := 0
Local _nI       := 0
Local _naScan   := 0
Local _aVImpRet     //Impostos retidos
Local _lMCOMBFB := SuperGetMV("MGF_COMBFB",.T.,.F.)

//Verifica se � ExecAuto
If l103Auto
    Return(.T.)
EndIf

//Verifica se a NF � Normal
If cTipo <> "N"
    Return(.T.)
EndIf

//Verifica se rotinas que n�o devem passar pela valida��o est�o na pilha de chamada. Se estiver, sai da fun��o. 
For _nCnt := 1 To Len(_aRotExc)
    If IsInCallStack(Alltrim(_aRotExc[_nCnt]))
        Return(.T.)
    EndIf
Next

//Verifica se a valida��o do codigo retencao est� habilitada
If !_lMCOMBFB
    Return(.T.)
EndIf

//ADIRFRT = Impostos retidos
 _aVImpRet := aClone(ADIRFRT) 

//Verifica se h� reten��o de IR e valida o c�digo de reten��o
_nValIRR := MaFisRet(,"NF_VALIRR")
If _nValIRR > 0
    cDirf := "1"//Garante o valor correto p/ "cDirf", mesmo quando o campo "Gera Dirf" esteja visualmente c/ "Sim" pois, o IR � maior que zero
    If cDirf <> "1" .Or. Empty(cCodRet)
        _lRet := .F.
        ApMsgStop("O c�digo de reten��o deve ser informado.")
    ElseIf cDirf == "1" .And. !Empty(cCodRet)
        _naScan := aScan(_aVImpRet,{|x| x[1] =="IRR"})
        If _naScan != 0
            _aVImpRet[_naScan][2] := cDirf
            _aVImpRet[_naScan][3] := cCodRet
           ADIRFRT := aClone(_aVImpRet) 
        EndIf
    EndIf
EndIf

RestArea(_aArea)

Return(_lRet)