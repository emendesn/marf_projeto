#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*/
=============================================================================
{Protheus.doc} MGFFINBE 
Automação e validação de campos para o processo da Dirf 

@description
Automatizar o preenchimento dos campos gera Dirf e códigos da receita do IRRF 
e o do Pis/Cofins/Csll no Documento de Entrada e Título a Pagar

@author Cosme Nunes
@since 17/01/2020
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
    17/01/2020 - RTASK0010618 - Chamados RITM0028445 e RITM0028474 - Cosme Nunes
/*/   
User Function MGFFINBE()

Local _aArea    := GetArea()
Local _cCRFor   := ""
Local _lCRFor   := .T.
Local _nValIRR  := 0
Local _nValPis  := 0
Local _nValCof  := 0
Local _nValCSL  := 0
Local _nReten   := 0


_nValIRR := M->E2_IRRF
_nValPis := M->E2_PIS
_nValCof := M->E2_COFINS
_nValCSL := M->E2_CSLL
_nReten := _nValPis+_nValCof+_nValCSL+_nValIRR

//Verifica valor de retencao maior que zero
If _nReten > 0 

    M->E2_DIRF      := "1"//1=Sim

    //Carrega codret do fornecedor e atualializa tÃ­tulo 
    _cCRFor := Posicione("SA2",1,xFilial("SA2")+M->E2_FORNECE+M->E2_LOJA,"A2_ZCODRET")
    If !Empty(_cCRFor)
        M->E2_CODRET    := _cCRFor
    //Else 
        //_lCRFor := .F.
        //ApMsgStop("O código de retenção deve ser informado.")
    EndIf

    If M->E2_DIRF <> "1" 
        _lCRFor := .F.
        ApMsgStop("O código de retenção deve ser informado.")
    ElseIf Empty(M->E2_CODRET) 
        _lCRFor := .F.
        ApMsgStop("O código de retenção deve ser informado.")    
    ElseIf !_lCRFor
        ApMsgStop("O código de retenção deve ser informado.")
    EndIf

EndIf

If M->E2_TIPO == "TX "
    M->E2_DIRF   := "1"//1=Sim
    M->E2_CODRET := "5952"
EndIf

RestArea(_aArea)

Return(_lCRFor)

/*/
======================================================================================
{Protheus.doc} FINBEG()
Gatilho p/ verificar e atualizar campos gera dirf e código de retenção do fornecedor

@author Cosme Nunes
@since 20/01/2020  
@type User Function 

@param 
    _cGD - "GD" = Atualiza o campo Gera Dirf
    _cCR - "CR" = Atualiza o campo Códido de Retenção

@return
    _cret - Retorno conteúdo para preenchimento do campo 
/*/
User Function FINBEG(cGDCR)

Local _aArea    := GetArea()
Local _cCRFor   := ""
Local _nValIRR  := 0
Local _nValPis  := 0
Local _nValCof  := 0
Local _nValCSL  := 0
Local _nReten   := 0
Local _cGD      := "2"
Local _cRet		:= ""

_nValIRR := M->E2_IRRF
_nValPis := M->E2_PIS
_nValCof := M->E2_COFINS
_nValCSL := M->E2_CSLL
_nReten := _nValPis+_nValCof+_nValCSL+_nValIRR




If cGDCR == "GD" .AND. ; //Verifica se o gatilho tem o E2_DIRF contra domínio.
    _nReten > 0  //Verifica valor de retencao maior que zero

    _cRet := "1"//1=Sim    
   
    
ElseIf cGDCR == "CR"; //Verifica se o gatilho tem o E2_DIRF contra domínio.
    .AND. M->E2_DIRF == "1"

    //Carrega codret do fornecedor e atualializa tí­tulo 
    _cCRFor := Posicione("SA2",1,xFilial("SA2")+M->E2_FORNECE+M->E2_LOJA,"A2_ZCODRET")

    If Empty(_cCRFor)
        _cCRFor := IIf(EXISTCPO("SX5","37"+_cCRFor),_cCRFor,M->E2_CODRET)
    EndIf

    If M->E2_TIPO $"TX"
        _cCRFor := "5952"
    EndIf

    _cRet := _cCRFor

Endif


RestArea(_aArea)

Return(_cRet)