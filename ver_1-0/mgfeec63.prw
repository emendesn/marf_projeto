#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFEEC63
Autor...............: Totvs
Data................: Dez/2018
Descricao / Objetivo: Rotina chamada pelo ponto de entrada AvKeyAuto
Doc. Origem.........: Comex
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFEEC63()
// tratamento para possilitar a alteracao via execauto do legado de pedidos de exportacao com zeros a esquerda, neste caso, a funcao AvKeyAuto vai preservar o codigo do item
// com os zeros a esquerda ( quando o pedido assim estiver ).
If ValType(PARAMIXB) == "A" .And. (Alltrim(PARAMIXB[1]) == "EE8_SEQUEN" .or. Alltrim(PARAMIXB[1]) == "LINPOS") .And. Left(PARAMIXB[2], 1) == "0"
	cConteudo := PARAMIXB[2]
EndIf

Return()