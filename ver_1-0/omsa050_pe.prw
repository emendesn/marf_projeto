#include "protheus.ch"

/*
=====================================================================================
Programa............: OMSA050
Autor...............: Mauricio Gresele
Data................: 12/12/2016 
Descricao / Objetivo: Ponto de entrada na rotina de Cadastro de Ajudantes, para utiliza��o em MVC
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function OMSA050()

Local uRet := .T.

// valida campos para integracao do Taura
If FindFunction("U_OMSA050_PE")
	uRet := U_OMSA050_PE()
Endif		

Return(uRet)