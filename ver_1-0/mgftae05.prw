#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              MGFTAE05
Autor....:              Marcelo Carneiro         
Data.....:              20/10/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada MT120FIM para na copia o campo fique como C7_ZTIPO=1
=============================================================================================
*/


User Function MGFTAE05(nOpcao,cNumPC,nOpcA)

IF nOpcao == 9 .And. nOpcA == 1
    SC7->(dbSetOrder(1))
    IF SC7->(dbSeek(xFilial('SC7')+cNumPC))
        RecLock('SC7',.F.)
        SC7->C7_ZTIPO   := '1'
	    SC7->C7_ZPTAURA := ''
        MsUnlock()  
    EndIF
EndIF

Return 