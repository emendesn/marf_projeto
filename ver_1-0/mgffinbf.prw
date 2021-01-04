#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*/
=============================================================================
{Protheus.doc} MGFFINBF 
Gravação de campos para o processo da Dirf 

@description
Gravação do código de retenção do título de imposto 

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
User Function MGFFINBF()

Local _aArea    := GetArea()
Local _cCR      := "5952"

If SE2->E2_TIPO == "TX " //Título de imposto
    SE2->E2_CODRET := _cCR 
    If SE2->E2_DIRF <> "1"//1=Sim
        SE2->E2_DIRF := "1"
    EndIf
ElseIf !Empty(SE2->E2_CODRET) .And. SE2->E2_DIRF <> "1"
    SE2->E2_DIRF := "1"
EndIf

RestArea(_aArea)

Return(Nil)