#include "protheus.ch"

/*
=====================================================================================
Programa.:              JURA098_PE
Autor....:              Marcelo Carneiro
Data.....:              15/03/2019
Descricao / Objetivo:   Integracao Grade de Aprovacao SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              
Obs......:              PE MVC JURA098 - Garantia
=====================================================================================
*/
User Function JURA098()

	Local uRet := .T.

	IF findfunction("U_MGFJUR02")
		uRet := U_MGFJUR02('NT2')
	EndIF 

Return(uRet)