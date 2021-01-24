#include "protheus.ch"

/*
=====================================================================================
Programa............: SE5FI331()
Autor...............: Flávio Dentello
Data................: 14/03/2017 
Descricao / Objetivo: Ponto de entrada no final da compensação do título a receber
Doc. Origem.........: Financeiro - CRE34
Solicitante.........: Cliente
Uso.................: Marfrig
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