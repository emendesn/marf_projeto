#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM75
Autor...............: Totvs
Data................: Fev/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MT094LEG
=====================================================================================
*/

 User Function MT110COR() 

Local aCores := aClone(ParamIxb[1])
Local aCoresNew := {}
Local nCnt := 0

aadd(aCoresNew,{'C1_ZCANCEL=="S" ','BR_CANCEL'}) // bloqueio por divergencia de valor total

//Adiciono as cores padroes do sistema
For nCnt:=1 to Len(aCores)
	aAdd(aCoresNew,{aCores[nCnt][1],aCores[nCnt][2]})
Next

Return(aCoresNew)