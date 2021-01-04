#include "protheus.ch"

/*
=====================================================================================
Programa............: MT410CPY
Autor...............: Mauricio Gresele
Data................: 25/10/2016 
Descricao / Objetivo: Ponto de entrada na copia do PV
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MT410CPY()

If FindFunction("U_TAS01Cpy")
	U_TAS01Cpy()
Endif	

If FindFunction("U_TMS01Cpy")
	U_TMS01Cpy()
Endif	


Return()