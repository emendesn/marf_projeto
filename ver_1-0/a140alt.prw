#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              A140ALT
Autor....:              Marcelo Carneiro         
Data.....:              09/11/2016 
Descricao / Objetivo:   Integracao TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de Entrada para Nao alterar Pre Nota de AR
=============================================================================================
*/
User Function A140ALT
Local bRet := .T. 

If Findfunction("U_MGFTAE08")
bRet := U_MGFTAE08(4)                                                                  
Endif

Return bRet