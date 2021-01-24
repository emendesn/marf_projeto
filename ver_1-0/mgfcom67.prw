#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM67
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MT103COR
=====================================================================================
*/
User Function MGFCOM67()

Local aCores := aClone(ParamIxb[1])
Local aCoresNew := {}
Local nCnt := 0

aadd(aCoresNew,{'F1_STATUS=="B" .AND. F1_ZBLQVAL=="S"','BR_BRANCO'}) // bloqueio por divergencia de valor total

//Adiciono as cores padroes do sistema
For nCnt:=1 to Len(aCores)
	aAdd(aCoresNew,{aCores[nCnt][1],aCores[nCnt][2]})
Next

Return(aCoresNew)