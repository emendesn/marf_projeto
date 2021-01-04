#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFCOM64
Autor...............: Totvs
Data................: 02/02/2018 
Descricao / Objetivo: Compras 
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: 
Obs.................: Rotina chamada pelo ponto de entrada MA103BUT
=====================================================================================
*/
User Function MGFCOM64()

Local aBotao := {}

If IIf(Type("l103Class")!="U",l103Class,.T.) .or. IIf(Type("l103Visual")!="U",l103Visual,.T.) .or. IsInCallStack("MATA140") 
	aAdd(aBotao,{"Valor Total Marfrig",{|| U_MGFCOM65()},"Valor Total Marfrig"})
Endif	

Return(aBotao)		