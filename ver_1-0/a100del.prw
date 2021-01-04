#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#define CRLF chr(13) + chr(10)             
/*
============================================================================================
Programa.:              A100DEL
Autor....:              Marcelo Carneiro         
Data.....:              09/11/2016 
Descricao / Objetivo:   Integracao TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              
Obs......:              Ponto de Entrada A100DEL nao permitir a exlusao de nota que tenha AR
=============================================================================================
*/
User Function A100DEL
Local bRet := .T. 

If Findfunction("U_MGFTAE08") .AND. bRet
bRet := U_MGFTAE08(1)                                                                  
Endif

//GAP358, Natanael: A funcao ira buscar na SE1 uma NCC que tenha sido gerada atraves do Documento que esta sendo excluido e se essa NCC sobreu baixa
If Findfunction("U_MGFFIS36") .AND. bRet
bRet := U_MGFFIS36(3)                                                                  
Endif

// validacao para nao estornar classificacao de notas com origem pelo GFE
If bRet
	If Findfunction("U_MGFCOM90")
		bRet := U_MGFCOM90()
	Endif
Endif	

Return bRet