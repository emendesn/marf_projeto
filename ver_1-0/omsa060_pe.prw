#include "protheus.ch"

/*
=====================================================================================
Programa............: OMSA060
Autor...............: Mauricio Gresele
Data................: 12/12/2016 
Descricao / Objetivo: Ponto de entrada na rotina de Cadastro de Veiculos, para utiliza��o em MVC
Doc. Origem.........: Protheus-Taura Cadastros
Solicitante.........: Cliente
Uso.................: 
Obs.................: 
=====================================================================================
*/
User Function OMSA060()

Local uRet := .T.

// valida campos para integracao do Taura
If FindFunction("U_OMSA060_PE")
	uRet := U_OMSA060_PE()
Endif  
		
//CAD04
IF findfunction("U_MGFINT38")
	U_MGF38_MVC('DA3','DA3')
EndIF 

Return(uRet)