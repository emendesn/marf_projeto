#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM70
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Rotina chamada pelo ponto de entrada MT103LEG
=====================================================================================
*/
User Function MGFCOM70()

Local aLegenda := aClone(ParamIxb[1])

aAdd(aLegenda,{"BR_BRANCO","Docto. Bloqueado - Divergência Valor Total Marfrig"})

Return(aLegenda)