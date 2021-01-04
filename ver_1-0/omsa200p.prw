#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              OMSA200P
Autor....:              Marcelo Carneiro         
Data.....:              09/11/2016 
Descricao / Objetivo:   Integracao TAURA - SAIDAS
Doc. Origem:            TAURA
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de Entrada para Nao Liberar PV do Taura
=============================================================================================
*/
User Function OMSA200P
Local bRet := .T. 

If Findfunction("U_MGFTAS05")
	 bRet := U_MGFTAS05(2)// 2= Bloqueia Estorno                                                                  
Endif

Return bRet