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
User Function A100DEL
Local bRet := .T. 

If Findfunction("U_MGFTAE08") .AND. bRet
bRet := U_MGFTAE08(1)                                                                  
Endif

//GAP358, Natanael: A função irá buscar na SE1 uma NCC que tenha sido gerada através do Documento que está sendo excluído e se essa NCC sobreu baixa
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