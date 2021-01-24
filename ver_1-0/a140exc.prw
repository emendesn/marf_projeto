#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              A140EXC 
Autor....:              Marcelo Carneiro         
Data.....:              09/11/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada para Não permitir excluir Pré Nota de AR
=============================================================================================
*/
User Function A140EXC 
Local bRet := .T. 

If Findfunction("U_MGFTAE08")
bRet := U_MGFTAE08(5)                                                                  
Endif

Return bRet