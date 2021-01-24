#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"  
#INCLUDE 'TOTVS.CH' 
/*
============================================================================================================================
Programa.:              MGFCOM45 
Autor....:              Antonio Carlos        
Data.....:              16/10/2017                                                                                                            
Descricao / Objetivo:   Implementação do Ponto de Entrada MT120TEL que será utilizado para incluir campo Obs no aHeder do PC
Doc. Origem:            Compras - GAP ID068
Solicitante:            Cliente 
Uso......:              Marfrig
Obs......:              Cria variáveis públicas e ativa a consulta padrão da xObs.
============================================================================================================================
*/  
User Function MGFCOM45()
    Local aArea     := GetArea()
    Local oDlg      := PARAMIXB[1]
    Local aPosGet   := PARAMIXB[2]
    Local nOpcx     := PARAMIXB[4]
    Local nRecPC    := PARAMIXB[5]
    Local lEdit     := IIF(nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx ==  9, .T., .F.) //Somente será editável, na Inclusão, Alteração e Cópia

    Public cXObsAux := ""
    Public _cNumPC  := SC7->C7_NUM
     
    //Define o conteúdo para os campos
    If nOpcx == 3
        cXObsAux := CriaVar("C7_ZCODOBS",.F.)
    Else
        cXObsAux := SC7->C7_ZCODOBS
    EndIf
     
    //Criando na janela o campo OBS
    @ 064, aPosGet[12,1] + 410 SAY Alltrim(RetTitle("C7_ZCODOBS")) OF oDlg PIXEL SIZE 050,006
    @ 063, aPosGet[12,2] + 389 MSGET oXObsAux VAR cXObsAux F3 "XOBS" SIZE 40, 006 OF oDlg COLORS 0, 16777215  PIXEL 
   
    oXObsAux:bHelp := {|| ShowHelpCpo( "C7_ZCODOBS", {GetHlpSoluc("C7_ZCODOBS")[1]}, 5  )}
     
    //Se não houver edição, desabilita os gets
    If !lEdit
        oXObsAux:lActive := .F.
    EndIf
     
    RestArea(aArea)
Return