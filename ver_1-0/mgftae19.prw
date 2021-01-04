#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              MGFTAE19
Autor....:              Marcelo Carneiro         
Data.....:              13/01/2017 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Programa a ser executado no final do Refaz Saldo, para bloquear os
						produtos que estão em contagem (Carga Fria)
=============================================================================================
*/


User Function MGFTAE19
Local cQuery := ''               
Private cLocalInd       := GetMV('MGF_AE6LOC',.F.,'04')            

cQuery := " Update "+RetSqlName("SB2")
cQuery += " Set B2_STATUS   = '2' "
cQuery += " Where B2_FILIAL = '"+xFilial('SB2')+"'"
cQuery += "   AND B2_LOCAL  = '"+cLocalInd+"'"
IF (TcSQLExec(cQuery) < 0)
     Return(msgStop(TcSQLError()))
EndIF                             

Return
