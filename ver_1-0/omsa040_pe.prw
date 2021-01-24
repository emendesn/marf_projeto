#include "protheus.ch"

/*
=====================================================================================
Programa............: OMSA040
Autor...............: Mauricio Gresele
Data................: 09/12/2016 
Descricao / Objetivo: Ponto de entrada na rotina de Cadastro de Motoristas, para utilização em MVC
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function OMSA040()

Local uRet := .T.

// valida campos para integracao do Taura
If FindFunction("U_OMSA040_PE")
	uRet := U_OMSA040_PE()
Endif		                       

//CAD04
IF findfunction("U_MGFINT38")
	U_MGF38_MVC('DA4','DA4')
EndIF 


Return(uRet)