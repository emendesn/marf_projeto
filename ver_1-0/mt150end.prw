#include "Protheus.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
/*
=====================================================================================
Programa............: MT150END
Autor...............: Roberto Sidney
Data................: 23/09/2016
Descricao / Objetivo: Ponto de entrada no final da cotação - Efetua a chamada da função MGFCOM01 -Workflow de aprovação
Doc. Origem.........: COM01 - GAP MGCOM01
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ajusta o Flag de Workflow enviado para N=Não
=====================================================================================
*/
User Function MT150END()
Local nOp := PARAMIXB[1]

IF  nOp == 3 .OR. nOp == 5         
	RecLock("SC8",.F.)                 
	SC8->C8_ZWFENV := 'N'
	SC8->(MsUnlock() )
ENDIF

Return nil 
