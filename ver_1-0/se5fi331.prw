#include "protheus.ch"

/*
=====================================================================================
Programa............: SE5FI331()
Autor...............: Fl�vio Dentello
Data................: 14/03/2017 
Descricao / Objetivo: Ponto de entrada no final da compensa��o do t�tulo a receber
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