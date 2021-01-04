#include "protheus.ch"

/*
=====================================================================================
Programa............: SE5FI331()
Autor...............: Flavio Dentello
Data................: 14/03/2017 
Descricao / Objetivo: Ponto de entrada no final da compensacao do titulo a receber
Doc. Origem.........: Financeiro - CRE34
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function SE5FI331()

If FindFunction("U_MGFFIN50")
	U_MGFFIN50()
Endif

If FindFunction("U_MGFFIN84")
	U_MGFFIN84()
Endif

Return