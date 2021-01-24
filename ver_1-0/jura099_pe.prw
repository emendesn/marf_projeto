#include "protheus.ch"

/*
=====================================================================================
Programa.:              JURA099_PE
Autor....:              Marcelo Carneiro
Data.....:              15/03/2019
Descricao / Objetivo:   Integração Grade de Aprovação SigaJuri
Doc. Origem:            MIT044
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              PE MVC JURA099 - Despesas
=====================================================================================
*/
User Function JURA099()

Local uRet := .T.


IF findfunction("U_MGFJUR02")
	uRet := U_MGFJUR02('NT3')
EndIF 


Return(uRet)