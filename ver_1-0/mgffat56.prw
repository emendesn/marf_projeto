#include "protheus.ch"

/*
=====================================================================================
Programa............: MGFFAT56
Autor...............: Mauricio Gresele
Data................: Out/2017
Descricao / Objetivo: Rotina chamada pelo ponto de entrada OM010QRY
Doc. Origem.........: Protheus
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MGFFAT56(cQ)

If IsInCallStack("U_FAT01Cpy")
	If At("ORDER BY",cQ) > 0
		// forca query para nao trazer nenhum item
		cQ := Subs(cQ,1,At("ORDER BY",cQ)-1)+" AND '1'='2' "+Subs(cQ,At("ORDER BY",cQ))
	Endif
Endif		

Return(cQ)