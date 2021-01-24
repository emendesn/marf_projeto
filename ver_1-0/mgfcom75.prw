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
User Function MGFCOM75()

Local aLegendaNew := {}
Local aLegenda := Paramixb[1]   
Local nCnt := 0

aAdd(aLegendaNew, {"(!Empty(CR_ZVLRTOT) .and. CR_STATUS == '02')","WHITE","Docto. Bloqueado - Divergência Valor Total Marfrig"})

For nCnt:=1 To Len(aLegenda)
	aAdd(aLegendaNew,aLegenda[nCnt])
Next	

Return(aLegendaNew)