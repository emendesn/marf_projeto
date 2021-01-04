#include "protheus.ch"

/*
=====================================================================================
Programa............: MTA500FIL
Autor...............: Mauricio Gresele
Data................: 25/11/2016 
Descricao / Objetivo: Ponto de entrada para acrescentar condição customizada à cláusula WHERE
					  na rotina de eliminacao por residuo.	
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MTA500FIL()

Local cFil := ""

// filtra pedidos que foram enviados ao Taura, para estes nao serem eliminados por residuo.
If FindFunction("U_TAS01RESFIL")
	cFil := U_TAS01RESFIL()
Endif		

Return(cFil)