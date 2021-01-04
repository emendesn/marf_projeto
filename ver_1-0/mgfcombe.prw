#include "protheus.ch"
/*/
=============================================================================
{Protheus.doc} MGFCOMBE 
Atualiza��o da pasta "Impostos" - Rodap� do documento de entrada 

@description
Atualizar os campos Gera Dirf e c�digos de reten��o dos impostos retidos
Rotina chamada pelo ponto de entrada MT103DRF

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
    17/01/2020 - RTASK0010618 - Chamados RITM0028445 e RITM0028474 - Cosme Nunes
/*/   
User Function MGFCOMBE()

Local _aArea	:= GetArea()

Local _cCRFor  := ""
Local _lCRFor  := .T.
Local _cCRPro  := ""
Local _lCRPro  := .T.
Local _cCodRet := ""
Local _lCodRet := .T.
Local _cCRPCC  := "5952"
Local _cCRIR   := "1708"
Local _nCntB1  := 0
Local _aImpRet := {}

//Carrega codret do fornecedor
_cCRFor := Posicione("SA2",1,xFilial("SA2")+cA100For+cLoja,"A2_ZCODRET") 
If Empty(_cCRFor)
    _lCRFor := .F.
EndIf 
//Carrega codret do produto
SB1->(dbSetOrder(1))
For _nCntB1:=1 To Len(aCols)
    If !gdDeleted(_nCntB1) .And. !Empty(gdFieldGet("D1_COD",_nCntB1))
        If SB1->(dbSeek(xFilial("SB1")+gdFieldGet("D1_COD",_nCntB1)))
            _cCRPro := SB1->B1_ZCODRET
        Endif	
    Endif
Next
If Empty(_cCRPro)
    _lCRPro := .F.
EndIf 

If _lCRFor
    _cCodRet := _cCRFor
ElseIf _lCRPro
    _cCodRet := _cCRPro
/*Else
    ApMsgStop("O c�digo de reten��o deve ser informado.")   
*/
EndIf

If !Empty(_cCodRet)
    aadd(_aImpRet,{"IRR",1,_cCodRet})
Else 
    aadd(_aImpRet,{"IRR",1,_cCodRet})    
    //ApMsgStop("O c�digo de reten��o deve ser informado.")   
    //aadd(_aImpRet,{"IRR",1,_cCRIR})    
EndIf 
aadd(_aImpRet,{"PIS",1,_cCRPCC})
aadd(_aImpRet,{"COF",1,_cCRPCC})              
aadd(_aImpRet,{"CSL",1,_cCRPCC})
//aadd(_aImpRet,{"ISS",2,""})

RestArea(_aArea)

Return(_aImpRet)