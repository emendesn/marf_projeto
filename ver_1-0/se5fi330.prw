#include "protheus.ch"

/*
=====================================================================================
Programa............: SE5FI330()
Autor...............: Totvs
Data................: Marco/2018 
Descricao / Objetivo: Ponto de entrada no final da compensacao do titulo a receber
Doc. Origem.........: Financeiro
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function SE5FI330()

If FindFunction("U_MGFFIN84")
	U_MGFFIN84()
Endif

Return