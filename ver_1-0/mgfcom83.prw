#INCLUDE "PROTHEUS.CH"

/*
=====================================================================================
Programa............: MGFCOM83
Autor...............: Totvs
Data................: Abril/2018 
Descricao / Objetivo: Rotina chamada pelo ponto de entrada MT125GRV
Doc. Origem.........: Compras
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFCOM83()

If IsInCallStack("U_MGFCOM55")
	SC3->(RecLock("SC3",.F.))
	SC3->C3_FILENT := cFilialEnt
	SC3->(MsUnLock())
Endif

Return()
