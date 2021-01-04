#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              A100DEL
Autor....:              Marcelo Carneiro         
Data.....:              09/11/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Ponto de Entrada A100DEL não permitir a exlusão de nota que tenha AR
=============================================================================================
*/
User Function MT103PN
	Local bRet := .T.

	If findfunction("U_MGFTAE08")
		bRet := U_MGFTAE08(2)
	Endif

Return bRet